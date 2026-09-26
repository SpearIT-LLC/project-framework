# Bug: "Delete Optional Fields" Rule Survives Outside Contacts

**ID:** BUG-245
**Type:** Bug
**Priority:** High
**Version Impact:** PATCH
**Created:** 2026-09-24
**Workspace:** framework
**Depends On:**
**Completed:**

---

## Summary

Found by UAT-37 (2026-09-24, installed 0.4.7). BUG-207 replaced the "delete empty optional
fields" rule with a keep-blank rule, but only for contact records. The same rule still
tells the AI to delete fields on board cards, ops records and troubleshooting cases, so
those records lose fields that would be filled in later and drift from their templates.

## Bug Description

**Actual:** creating FEAT-001 in framework-uat, every layer told the AI to delete
`Workspace`, `Parent` and `Depends On` because no value was known yet. The rule is in six
places in the source tree:

| File | Line | Record |
|---|---|---|
| `commands/fw-new.md` | 83 | work item (step 5 names `Workspace`, `Parent`, `Depends On`) |
| `templates/records/work-item.md` | 33 | work item (comment header) |
| `scripts/fw-new.sh` | 228 | work item ("Next: … delete optional fields you don't need.") |
| `commands/fw-new-ops-record.md` | 33 | INC / REQ |
| `scripts/fw-new-ops-record.sh` | 54 | INC / REQ ("Next:" line) |
| `templates/records/ts-case.md` | 9 | troubleshooting case |

**Expected (tester rule, as settled in BUG-207 / UAT-13):** required fields filled; no
`__X__` placeholder survives; optional fields with no known value stay as blank lines;
delete only what cannot apply. A blank line is a prompt and an update path. A deleted
line has to be added back by hand with the right name and order.

**Expected (tester, UAT-37), step 5 of `/fw-new`:** the AI fills in what it can, proposes
a value where unsure (flagged as a proposal), then summarises what it filled and proposed.
The card must have a clear goal, checkable acceptance criteria, and at most one
dependency, named in the header's `Depends On:` line.

**Impact:** every board card, ops record and troubleshooting case created from 0.4.x.
UAT-37 passed only because the tester's standing preference overrode the instruction.
A user without that preference gets lossy records.

## Fix Design

1. Replace the delete rule with the keep-blank rule in all six places. The templates are
   the authored home (ADR-008). The commands and the `Next:` lines point to the template
   and do not restate the rule.
2. Rewrite `/fw-new` step 5 as the tester expectation above: fill, propose when unsure,
   summarise; clear goal, checkable criteria, at most one `Depends On`.
3. **More than one dependency → advise a split, don't refuse** (decided 2026-09-24,
   Gary). Refusing is the ideal, but its impact is hard to predict: the template shows
   `Depends On` as a list, and the dependency gate and the family union rule (UAT-43)
   already read lists. So `/fw-new` step 5 treats a second dependency as a sign the card
   is too big. The AI proposes a split: each piece gets at most one dependency, and the
   pieces are either separate cards or dotted children. If the user still wants two
   dependencies, the card keeps both and the Notes say why. It warns and never blocks,
   the same pattern as WIP (UAT-41). Revisit refusal once cards with two dependencies
   can be counted on the live board.

## Folded in from UAT-49 (2026-09-26)

Two more `/fw-new` instruction defects, found in the same files this fix already
edits. They are folded in here so `fw-new.md` and `work-item.md` are opened and fixed
once, not twice.

**A. The docs say a card is always created in `backlog/`, but the script doesn't do
that.** `fw-new.sh:189` correctly puts a dotted child (`--parent`) in its **parent's
folder**, so it moves with the parent. UAT-49 created FEAT-912.1.1 in `doing/`, as the
runbook expects. Three places state the old rule with no exception:

| File | Line | Text |
|---|---|---|
| `commands/fw-new.md` | 11 | "the item lands in `kanban/backlog/`" |
| `commands/fw-new.md` | 15 | "**Creation is always into `backlog/`.**" |
| `templates/records/work-item.md` | 2 | "Created ONLY by fw-new.sh, into kanban/backlog/" |

**Fix:** state the exception once, in the template, which is the authored home, and
have `fw-new.md` agree: "Created into `backlog/`; a dotted child is created in its
parent's folder." Put the reason next to the step 4 text on dotted ids (the child
moves with its parent).

**B. The AI makes up a slug when the user gives no description.** In UAT-49,
`add a sub-task under FEAT-912.1.1` gave no description, and the AI invented
`migration-note-subtask` instead of asking. The depth check refused first, so no
harm was done. At a legal depth, though, the card would have been created under an
invented name, and a slug lives in the filename forever. Step 1 only says to ask
when the *type* is ambiguous. UAT-05 has the equivalent rule for
`/fw-new-workspace` ("What should this workspace be called?").

**Fix:** in step 3, if the user hasn't said what the work is, ask. Never build a
slug or title from nothing.

## Acceptance Criteria

- [ ] `grep -rni "delete optional"` over `commands/ templates/ scripts/` returns nothing
- [ ] `work-item.md`, `ts-case.md` and the ops-record template state the keep-blank rule; `fw-new.sh` and `fw-new-ops-record.sh` `Next:` lines no longer say delete
- [ ] `/fw-new` step 5 says: fill what you can, propose when unsure, summarise; clear goal, checkable criteria, at most one `Depends On`
- [ ] `/fw-new` step 5 says a second dependency means proposing a split, not refusing; if the user keeps two, the reason goes in Notes
- [ ] UAT-37 re-run PASS against the built plugin: the card keeps blank `Workspace` / `Parent` / `Depends On` lines and no `__` placeholder survives
- [ ] UAT-15 and UAT-25 records re-checked: blank optionals kept, not deleted
- [ ] (A) `grep -rn "always into\|into kanban/backlog" commands/ templates/` returns nothing; `work-item.md` states that a dotted child is created in its parent's folder, and `fw-new.md` agrees with it without restating it
- [ ] (B) `/fw-new` says to ask when the user gives no description of the work, and never to invent a slug or title
- [ ] (B) UAT-49 re-run: `add a sub-task under FEAT-912.1` with no description → the AI asks what the sub-task is before it runs the script

## Related

- **BUG-207** — the same defect, fixed for contact records only; its Expected text is the rule to reuse here.
- **FEAT-229** — the kanban board section (UAT-37..49) where this was found.
- `workspaces/framework/tests/UAT-RESULTS-2026-08-26.md` — Section G, rows UAT-37 and UAT-49.

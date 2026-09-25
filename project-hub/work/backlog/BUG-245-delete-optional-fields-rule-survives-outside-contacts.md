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

## Acceptance Criteria

- [ ] `grep -rni "delete optional"` over `commands/ templates/ scripts/` returns nothing
- [ ] `work-item.md`, `ts-case.md` and the ops-record template state the keep-blank rule; `fw-new.sh` and `fw-new-ops-record.sh` `Next:` lines no longer say delete
- [ ] `/fw-new` step 5 says: fill what you can, propose when unsure, summarise; clear goal, checkable criteria, at most one `Depends On`
- [ ] `/fw-new` step 5 says a second dependency means proposing a split, not refusing; if the user keeps two, the reason goes in Notes
- [ ] UAT-37 re-run PASS against the built plugin: the card keeps blank `Workspace` / `Parent` / `Depends On` lines and no `__` placeholder survives
- [ ] UAT-15 and UAT-25 records re-checked: blank optionals kept, not deleted

## Related

- **BUG-207** — the same defect, fixed for contact records only; its Expected text is the rule to reuse here.
- **FEAT-229** — the kanban board section (UAT-37..49) where this was found.
- `workspaces/framework/tests/UAT-RESULTS-2026-08-26.md` — Section G, row UAT-37.

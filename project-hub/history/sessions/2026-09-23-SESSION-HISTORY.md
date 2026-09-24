# Session History: 2026-09-23

**Date:** 2026-09-23
**Participants:** Gary Elliott, Claude Code
**Session Focus:** TASK-242 decided; FEAT-229.3 implemented. **The kanban board is functionally
complete.**

---

## Summary

One decision session and one implementation session. **TASK-242** settled the board's terminal and
parked states as a set, and **FEAT-229.3** encoded them — which completes the FEAT-229 family's
implementation work. Every remaining criterion across all four children is the *same* Human UAT
against the installed plugin, closable in one publish cycle.

---

## TASK-242 — five decisions

### 1. `accept/` has exactly two exits: `doing` and `done`

**Gary's argument settled it, and it is the strongest in the discussion:**

> *"We have implemented something and it's in the repo. We've determined it needs more work (or
> else it would have gone straight to done). Leaving buggy code while we work on something else
> would be a bad idea. SO… I'm thinking it should only go to doing or done now."*

**A card in `accept/` has merged code.** `accept → todo` puts it behind unstarted work;
`→ backlog` files finished code as an unranked idea; `→ hold`/`→ blocked` park it indefinitely.
**All three strand known-imperfect code with nothing scheduled to finish it.** Going back to
`doing/` costs queue position and nothing else.

Claude's initial objection had been narrower — only `accept → backlog` — on the grounds that it
discards readiness. **Gary generalized it correctly:** the problem is not readiness, it is
*merged code with no owner*.

**FEAT-221.2's authored flow already showed exactly these two exits** (*Refine* and *Close*), so
the decision ratifies rather than invents.

**Consequence: `doing:done` is removed.** FEAT-229.1 shipped it before `accept/` was decided;
`accept/` is now the only route to `done/`, which is what makes the state mean anything.

### 2. `cancelled` is terminal · `done → cancelled` invalid — and it was a hole

**Gary:** *"done → cancelled would violate the definition of done."*

Then he asked the right follow-up: *"Did we actually move something from done → archive in the
past? or was this a hole we never closed?"*

**Checked, not assumed.** Six completed cards sit in `project-hub/work/archive/`:

| Card | `Status:` | Cancellation fields | In a release? |
|---|---|---|---|
| CHORE-132 | `Done` | none | no |
| DOCS-133 | `Done` | none | no |
| CHORE-131 | `Backlog` (stale) | none | no |

**None carries `Cancelled Date:` or `Cancellation Reason:`; none appears in
`history/releases/`.** They were *completed work put away* — **storage, not cancellation.** So
`done → archive` was a hole `archive/`'s double duty concealed, and it closes without a
transition now that `cancelled/` is first-class and `history/archive/` owns storage.

### 3. `blocked/` AND `hold/` — a combined `park/` was proposed and rejected

**Gary's definitions become the authored ones:**

> **blocked** — cannot proceed due to some external issue
> **hold** — a decision to prioritize another card

**Claude argued for a single `park/` folder** on three grounds: `blocked/` holds exactly one card
(BUG-144, on Anthropic); FEAT-221's parked cards fit neither definition; and TECH-177's
`[?]`/`[h]` markers already record the cause at line precision, so a folder repeating it coarsely
adds nothing.

**Gary overruled it, and the reason is decisive:**

> *"Newcomers (including yourself in a new session) will intuitively understand blocked and hold
> more than park."*

**Every session in this framework starts as a newcomer** (`workspaces/framework/CLAUDE.md`).
`park/` needs a lookup; `blocked/` and `hold/` do not. **Intuitive-on-arrival beats concise.**

Consequences recorded: FEAT-221's parked cards go to `blocked/` (blocked on the *answer*, which is
outside the card); `Blocked By:` / `External Reference:` become **optional**, used when the
external party is nameable; **FEAT-030 closes as implemented** after nine months.

### 4. No board closure code

Gary: *"we haven't had them before and I don't think we missed them. HOWEVER, I'm open, what did
you have in mind?"*

**Claude had ops' set in mind** (`resolved | cancelled | duplicate | no-fault-found | rejected`)
for FEAT-196 reporting — **then withdrew it on a structural point it had under-weighted:** ops
codes live in a `Resolution:` field *because ops has no `cancelled/` folder*. The field **is** the
outcome there. The board is getting the folder instead, so `cancelled/` already encodes the
distinction that matters. Everything finer is reporting, and no report consumes it yet.

### 5. `archive/` restated

`history/archive/` is **storage** — put away, never a lifecycle outcome. No `archive/` under the
board.

---

## FEAT-229.3 — the decisions encoded

**The transition set**, now in `kanban_TRANSITIONS`:

```
backlog:todo      todo:backlog
todo:doing        doing:todo
doing:accept      accept:doing      accept:done
backlog:blocked   todo:blocked      doing:blocked
backlog:hold      todo:hold         doing:hold
blocked:backlog   blocked:todo      blocked:doing
hold:backlog      hold:todo         hold:doing
backlog:cancelled todo:cancelled    doing:cancelled
```

**`hold/` was missing from both `kanban_FOLDERS` and the queue scaffold** — added to each.

**The acceptance gate moved with the route.** It is namespace-wide on `→ done`, so making
`accept/` the only route to `done/` relocated the gate to `accept → done` **without a code
change** — where the card actually completes. *(FEAT-221.1 anticipated needing this and wanted the
gate on `doing → accept`; it lands correctly as-is.)*

### Spike archival — the bundle is the type test

A spike reaching a terminal state **leaves the board** for `history/spikes/`, never a release
archive: a spike produces **knowledge**, not a shippable change (TECH-228).

- **Research spike** → a file: `history/spikes/SPIKE-001-research-question.md`
- **POC spike** → a folder: `history/spikes/SPIKE-002/` holding **both** the record and `run.sh`

**No type flag is needed.** TECH-228's split is that a research spike is a document and a POC
spike is a document *plus code in its bundle* — so **if a bundle travelled, the archive gets a
folder.** The data already distinguishes them.

**Implemented as a redirect after the move, deliberately.** Making `history/spikes` a
pseudo-target would put a non-folder in the policy table and force a special case through the
transition matrix, the gates *and* the family carry. The record lands in `done/` or `cancelled/`
like any card, then leaves the board.

### Validation

| Area | Result |
|---|---|
| `accept/` path | `doing→accept`, `accept→done` ✅ · **`doing→done` refused** ✅ |
| `accept/` exits | all five illegal exits refused ✅ |
| Acceptance gate | `accept→done` with `[/]` **blocked** ✅ |
| `hold/` | in from three folders, out to three ✅ · `hold→blocked` refused ✅ |
| `cancelled/` | in from three ✅ · terminal ✅ · **`done→cancelled` refused** ✅ |
| Spike archival | both forms ✅ · board left empty of spikes ✅ · no release path ✅ |
| Gate suite re-run | 7/7 through the accept path ✅ |
| Operations | 5 cases + sweep ✅ · **no `history/spikes/` created there** ✅ |

---

## Two Cards Filed From the Discussion

### TECH-243 — the release guard covers only `doing/`

**Gary caught this while settling `accept/`:**

> *"We should also put guards on release to check for cards in accept/, blocked/, hold/. Half done
> items in there could affect a release."*

**Verified:** `/fw-release` step 2a blocks on `doing/` and **nothing else**. Its warning —
*"releasing with in-progress work risks an incomplete or out-of-sync release"* — is **equally true
of `accept/`, `blocked/` and `hold/`**, and `accept/` is the sharpest case: a card only reaches it
by being implemented.

**Proposed severity, not uniform:** hard block on `accept/`; **warn-and-confirm** on
`blocked/`/`hold/`, because a card parked *before* implementation is harmless and a guard people
habitually `--force` past stops being read.

### TECH-244 — operations breaks folder-is-state

**Gary:** *"In the kanban folders, the folder is the state. But I'm not crazy that operations
doesn't exactly follow that principle."*

**No existing card covered it.** TECH-033 ("status field redundancy") is about a redundant *field
on a board card* — settled by TASK-219 — which is a different question from **two namespaces
disagreeing about what a folder means.**

Priority **Low**: nothing is broken, both work as designed. **The cost is re-derivation** — a
defensive paragraph each time a state question spans both namespaces, which TASK-242 itself had
to pay.

---

## Decisions Made

1. **`accept/` → `doing` or `done` only.** Merged code is never parked. (Gary)
2. **`done → cancelled` invalid**, and `done → archive` was a hole, not a practice — proven from
   the six completed cards in `archive/`.
3. **Keep `blocked/` and `hold/`; reject `park/`.** Conventional words need no lookup, and every
   session starts as a newcomer. (Gary, overruling Claude's `park/` proposal)
4. **No closure code.** Ops codes exist because ops lacks the folder; the board has the folder.
5. **Spike archival needs no type flag** — the bundle distinguishes research from POC.
6. **Spike archival is a post-move redirect**, not a pseudo-target in the policy table.

---

## Files Created

- `project-hub/work/backlog/TECH-243-release-guard-covers-every-unfinished-state.md`
- `project-hub/work/backlog/TECH-244-operations-breaks-folder-is-state.md`
- `workspaces/framework/templates/queues/kanban/hold/.gitkeep`

## Files Modified

- `workspaces/framework/scripts/fw-move.sh` — `hold` in `kanban_FOLDERS`; the full transition set;
  `doing:done` removed; spike archival; the policy-row comment rewritten to carry the *why* of
  each absent pair.
- `workspaces/framework/templates/queues/kanban/README.md` — `hold/`, the two-exit rule, the
  corrected gate location, `archive/` as storage.
- `workspaces/framework/CHANGELOG.md` — the full FEAT-229 entry under Unreleased.
- `project-hub/work/done/TASK-242-...md` — five decisions, 9/9.
- `project-hub/work/doing/FEAT-229.3-...md` — 6/6 with its validation run.
- `project-hub/work/doing/FEAT-229-...md` — parent reconciled: 10 met, 2 `[h]`.
- `project-hub/work/backlog/FEAT-030-...md` — **resolved**; 16 old-build checklist items marked
  `[-]`, not `[x]`.
- `FEAT-221`, `FEAT-221.1`, `FEAT-221.2`, `FEAT-229.3` — dependencies retargeted to TASK-242.

## Files Moved

- `TECH-232` → `todo/` (parked, not active)
- `TASK-242` → `todo/` → `doing/` → `done/`

## Commits

- `2f0d404` — TECH-232 back to `todo/`
- `631ee26` — TASK-242 complete
- `04f44bb` — FEAT-229.3

---

## Current State

### In doing/ — 1 WIP item (5 files)
The **FEAT-229 family**: parent + `.1` (8/8 ✅) + `.2` (9/10) + `.3` (6/6 ✅) + `.4` (10/11).

**Every open criterion across all five is the same Human UAT** against the installed plugin.
**One publish cycle closes four cards.**

### In done/ — 13 cards
*(The engine reports 14 — BUG-174, `.gitkeep`, in the old engine, unfixed by design. Counted by
hand: 13.)*

### In todo/ — 13 · In backlog/ — 87 items
Filed today: TECH-243, TECH-244.

---

## Next Session — release first

**Gary: *"We'll release first thing tomorrow."***

1. **The release.** 13 cards in `done/`, overdue since 2026-09-21. **Note the publish cycle also
   closes the four UAT criteria** in the FEAT-229 family — worth sequencing them together.
2. **FEAT-229 family → `done/`** once the UAT passes. One `/fw-move` moves all five (tight
   coupling).
3. **TECH-243** — the release guard. Ironic sequencing: it protects the release *after* this one.
4. **TECH-232 reconcile** — three criteria look satisfied by `workspace.yaml` already in the tree.
5. **Carried:** `/fw-backlog` pass (`todo/` 13) · BUG-237 unwritten · four uncovered UAT paths ·
   `git mv` BUG-225 to `archive/` (fifth session).

---

**Last Updated:** 2026-09-23

# Bug: fw-next-id Cannot See Cards the Engine Moved Off the Board, and Reissues Their IDs

**ID:** BUG-258
**Type:** Bug
**Priority:** High
**Version Impact:** PATCH
**Created:** 2026-09-29
**Workspace:** framework
**Depends On:**
**Completed:** 2026-09-29

---

## Summary

Found in TASK-223's pre-implementation review (2026-09-29). `workspaces/framework/scripts/fw-next-id.sh`
finds the highest id by scanning `kanban/` only. But the move engine put some cards outside
`kanban/`: a spike that reached `done/` or `cancelled/` went to `history/spikes/` (FEAT-229.3).
Once a spike left, its id was invisible, and a later `/fw-new` could issue the same id again.

**Reproduced 2026-09-29** with a scratch tree: `kanban/backlog/FEAT-003-x.md` and
`history/spikes/SPIKE-005-y.md`. `fw-next-id.sh --root <tree> kanban` printed **004**. The card
after that would get 005, which SPIKE-005 already had.

## Decision: fix the cause, not the scan (Gary, 2026-09-29)

The card first proposed widening the scan with a shared list of off-board folders. At review
Gary asked why kanban sends records outside its root when operations never does (operations
sweeps prior-year records into `closed/YYYY/`, still under `operations/`).

**Outcome: no record leaves its namespace root.** Every place a record can be is then under
the one folder the scanner already reads, so the ID-safety rule holds by construction and no
list has to be kept in sync. The spike redirect is removed. A spike is an ordinary card.

**Why the off-board move lost** (pros and cons weighed at review):
- It broke ID safety, which is this bug. Every off-board folder is a place the scanner has to
  be told about.
- It was a special case in the engine (~40 lines), and it had already caused one bug: in the
  2026-09-24 dry run, spikes left the board mid-flight.
- It gave the framework two models for one idea: operations stays in its root, kanban didn't.
- It competed with `kb/<domain>/research/` as the home for knowledge.

The rest of the spike lifecycle was decided in the same review and is carried by
**TASK-259**. That covers the POC home in `workspaces/<ws>/poc/<SPIKE-id>/`, where results go,
filing under `release/<ws>/spikes/` at release, spikes staying out of release notes, and
two-way links to the feature.

**Consequence for `history/archive/`:** TASK-242 D5 and TASK-223 named `history/archive/` as
storage for completed cards that are put away. That is also outside the root, so the in-root
rule supersedes it for board cards. The board README now says completed work leaves `done/`
only by release. The 27 legacy `deprecated/` cards on the live board (`project-hub/work/`)
are unaffected until the board crosses over (ADR-009 D5). Their home at crossover needs
deciding then.

## Acceptance Criteria

- [x] The `history/spikes/` redirect is removed from `fw-move.sh`; a terminal spike stays in `done/` or `cancelled/` with its bundle
- [x] The in-root invariant is stated where it is relied on: the `fw-next-id.sh` header and the board README's Rules
- [x] Fixture: a spike holding the highest id (`FEAT-003`, `SPIKE-005` moved `accept → done`) gives next id **006** *(scratch repo, 2026-09-29)*
- [x] Seeded board: `913 → done`, `914 → cancelled` land on the board, SPIKE-914's `poc.sh` beside it, and no `history/` is created *(scratch repo, 2026-09-29)*
- [x] `commands/fw-move.md`, `UAT-COMMANDS.md` UAT-50/51 and `seed-uat-fixtures.sh` no longer describe spikes leaving the board
- [x] UAT-50 re-run on the installed plugin *(Gary)* *(PASS 2026-09-29; UAT-50 (re-run) row)*
- [x] Plugin CHANGELOG updated

## Related

- **TASK-259**: the rest of the spike lifecycle decided here
- **TASK-223**: where this was found; its `history/archive/` outcome is superseded here
- **TASK-242**: D5 (`history/archive/`) superseded for board cards; the ID-safety constraint
- **TECH-228**: its "Spikes archive to `history/spikes/`" carry-in is superseded
- **FEAT-229.3**: introduced the redirect

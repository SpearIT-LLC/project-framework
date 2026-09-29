# Bug: fw-next-id Cannot See Cards the Engine Moved Off the Board, and Reissues Their IDs

**ID:** BUG-258
**Type:** Bug
**Priority:** High
**Version Impact:** PATCH
**Created:** 2026-09-29
**Workspace:** framework
**Depends On:**
**Completed:**

---

## Summary

Found in TASK-223's pre-implementation review (2026-09-29). `workspaces/framework/scripts/fw-next-id.sh`
finds the highest id by scanning `kanban/` only (lines 22–33). But the move engine puts some cards
outside `kanban/`: a spike that reaches `done/` or `cancelled/` goes to `history/spikes/` (TECH-228,
`fw-move.sh` ~line 605). Once a spike leaves, its id is invisible, and a later `/fw-new` can issue the
same id again.

## Bug Description

**Reproduced 2026-09-29** with a scratch tree: `kanban/backlog/FEAT-003-x.md` and
`history/spikes/SPIKE-005-y.md`. `fw-next-id.sh --root <tree> kanban` printed **004**. The card
after that gets 005, which SPIKE-005 already has.

**Expected:** an id is never reissued. Every place the engine moves a card must be in the scanner's
search. That is the ID-safety constraint TASK-242 recorded ("any new folder must live under the board
root, so both id scanners see it").

**Also affected:** `history/archive/`, the storage home TASK-242 D5 names for completed work that is
put away. Anything moved there drops out of the scan the same way. TASK-223 holds the move of the 27
`deprecated/` cards there until this is fixed.

**Why it wasn't caught:** in UAT the archived spike ids (SPIKE-913, SPIKE-914) were never the highest
id on the board.

## Proposed Solution

Make the scanner's search cover the same places the engine writes. Keep one authored list (ADR-008),
not a second hand-kept copy: for example, the namespace's scan roots declared next to
`kanban_ROOT` in `fw-move.sh`'s policy data and read by `fw-next-id.sh`. The fixer decides where the
list lives. The rule is that there must be one list.

## Acceptance Criteria

- [ ] `fw-next-id.sh kanban` counts ids in `history/spikes/` and `history/archive/`
- [ ] The scan roots are authored once and read by both the engine and the scanner, or the card says why that isn't possible
- [ ] Fixture: the scratch tree above gives **006**
- [ ] `seed-uat-fixtures.sh` / `UAT-COMMANDS.md` gain a case with an archived spike holding the highest id
- [ ] Verified on the installed plugin
- [ ] Plugin CHANGELOG updated

## Related

- **TASK-223**: found here; the move of the `deprecated/` cards waits on this
- **TASK-242**: the ID-safety constraint and the `history/archive/` storage decision
- **TECH-228**: spikes leave the board for `history/spikes/`

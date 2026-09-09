# Session History: 2026-09-09

**Date:** 2026-09-09
**Participants:** Gary Elliott, Claude Code
**Session Focus:** Roadmap maintenance — which exposed that the roadmap itself is the wrong shape

---

## Summary

Started as a small correction: the roadmap's checkbox legend still described the pre-`[h]`
marker set. Reconciling it also meant fixing board state that had drifted in two days —
the **second** such reconciliation in three days. That prompted the real question, and the
answer was already in the repo: FEAT-198 had decided there should be no spine-level
authored master roadmap, and `/fw-roadmap` already ships the themes/planning-periods model
the current file does not use.

---

## Work Completed

### ROADMAP-DELIVERABLES.md — legend corrected, board state reconciled

The stated ask. `[!]` was replaced by `[h]` on 2026-09-08 (it means *important* in every
Obsidian theme collection, not blocked) but the roadmap legend still listed the old set.
Legend now carries `[ ] [/] [x] [-] [?] [h]` plus a note on why `[!]` is not used.

Board state had also drifted since the 09-07 snapshot, so that was fixed in the same pass:

- **BUG-215** is in `doing/`, not `todo/`, and was rescoped to *parity across both
  namespaces*. Marked `[/]`.
- **TECH-177** is no longer a ride-along on BUG-215 — it grew into owning sub-task-level
  blocking for the framework, and is the next card.
- Counts: todo 16 → 15, doing 0 → 1.
- **D3b** no longer lists batch moves as a blocker (restored 09-07).
- **D1b**'s `accept/` row records that the authored repo-structure diagram settles
  `accept/` and `cancelled/` as first-class, and names the three things it does not settle.

### FEAT-198 — the roadmap shape, recorded where the decision already lived

Gary: *"the roadmap feels too heavy and the details should always be part of the
individual card. For me, I think the roadmap should be just a list of existing or planned
cards with a planned order. Add a little explanation of each phase with a reason. That's
all we need really."*

Recorded on **FEAT-198** rather than as a new card. That card already decided *"No
spine-level authored master roadmap exists in the new model; any cross-workspace view is
generated"* — so this is the concrete shape for a decision made 2026-08-20, not a new one.

Added to it: the judgment/derived split, the completion-criteria finding, the
cheap-divergence rule, and five acceptance criteria. `ROADMAP-DELIVERABLES.md` marked
**superseded in shape** at the top.

---

## Decisions Made

1. **A roadmap holds judgment and card ids; never card detail.**
   - Judgment = ordering, phase rationale, phase done-conditions. References = card ids.
     Folder, priority, status, summary all live on the card.
   - **Rationale — the file is its own evidence.** Hand-reconciled twice in three days
     (09-07, 09-09). Both times what drifted was the *derived* half. The ordering has
     never been wrong. The judgment held; the copy rotted.

2. **The "never finish a roadmap" pattern is unacknowledged mid-flight change, not
   indiscipline.**
   - Gary asked which it was. **Verified:** `ROADMAP-DELIVERABLES.md` carries no success
     criteria for any deliverable, so "halfway through and diverged" was never
     *observable* — there is no condition that was met or missed.
   - Diagnosis matters because the two causes want opposite responses: indiscipline says
     enforce harder, unacknowledged change says the roadmap could not absorb reality.
   - Evidence for the second: FEAT-221 and FEAT-222 were both filed mid-session (from a
     diagram and a slash command), and BUG-215 turned out to be a namespace problem, not
     a batch problem. None was indiscipline; the roadmap had nowhere to put any of it.

3. **Use the themes/planning-periods model the framework already ships.**
   - `/fw-roadmap` produces **Themes** (stable categories) and **Planning Periods**
     (temporal, each with a goal and **success criteria**); cards carry `Theme:` and
     `Planning Period:` fields to link back. A planning period with success criteria *is*
     a phase with a done-condition.
   - **Two roadmap models exist in this repo** — the shipped one, and the ad-hoc
     deliverable-ranked file we have actually been maintaining. The ad-hoc one is the one
     that rotted.

4. **Divergence must be cheap to record** — a one-line appended note (what changed, why,
   date), never a rewrite. If changing the plan is expensive, it happens informally and
   the roadmap silently stops being true.

5. **No third reconciliation of `ROADMAP-DELIVERABLES.md`.** Its own note set that
   threshold (*"worth a card if this reconciliation is needed a third time"*) and it has
   been reached. Read it for the ranking; go to the card for anything else.

---

## Files Modified

- `project-hub/planning/ROADMAP-DELIVERABLES.md` — legend corrected to the `[h]` set;
  board state reconciled; marked superseded in shape; second reconciliation note added
- `project-hub/work/backlog/FEAT-198-per-workspace-roadmaps.md` — the roadmap shape, the
  completion-criteria finding, cheap-divergence rule, five new acceptance criteria, one
  new open question

---

## Current State

### In doing/
- **BUG-215** — both halves shipped and tested; a built-plugin UAT pass is what closes it.

### In todo/
- 15 items. **TECH-177** is next — it owns the `[?]`/`[h]` gate behaviour that this
  roadmap's own marks depend on, and it blocks D3b.

### In done/ (awaiting release)
- 8 items, unchanged.

### Open question left on FEAT-198, deliberately

**Where does the framework's own roadmap live** once the spine master retires?
`workspaces/framework/` is a workspace, so its roadmap belongs there — but the board it
plans sits at the spine until the ADR-009 D5 crossover. Lean: it lives in the workspace
and references spine card ids, which are stable across the crossover.

---

**Last Updated:** 2026-09-09

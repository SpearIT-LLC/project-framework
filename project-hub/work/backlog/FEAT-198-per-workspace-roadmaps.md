# Feature: Per-Workspace Roadmaps — `/fw-roadmap` for the Repo-Is-the-Customer Model

**ID:** FEAT-198
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-08-20
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

`/fw-roadmap` was conceived under the repo-is-the-project model: one repo, one
`ROADMAP.md`. ADR-009 makes the repo the *customer* — many workspaces (products,
projects, operations) with independent strategic direction. One spine-level roadmap no
longer fits: a customer repo may legitimately carry several roadmaps (one per product,
one per live project) — or none.

Surfaced 2026-08-20 during TASK-197 refinement (Gary), while resolving why the
`project` scaffold carries no `plan/` folder.

## Direction (proposed, confirm at design)

- **The roadmap is workspace-owned.** A roadmap describes one bounded body of work, so
  it lives in the workspace it describes (e.g. `workspaces/<name>/ROADMAP.md`), not at
  the spine. The close-test supports this: a project's roadmap freezes when the project
  closes; a product's roadmap lives as long as the product. A spine roadmap would
  accrete dead sections.
- **Type fit:** product and project workspaces may have roadmaps; operations and
  knowledgebase do not (they are ongoing areas, not directed efforts).
- **This does not split the board or the timeline.** Work items stay on the one kanban
  board (`Workspace:` field, FEAT-163); history stays at the spine (ADR-009 D2).
  Roadmaps are forward-looking strategy documents owned by the thing they describe —
  different rule from history's one-timeline-at-the-spine.
- **The engagement-level view is derived, never authored.** "Where is everything for
  this customer headed" is a report assembled across workspace roadmaps + the board
  (FEAT-196's layered-report shape), not a hand-kept master roadmap (ADR-008).
- `/fw-roadmap` gains a workspace argument (or infers from context) and writes into
  the target workspace.

## The Shape a Roadmap Should Have (added 2026-09-09)

Gary, 2026-09-09: *"the roadmap feels too heavy and the details should always be part of
the individual card. For me, I think the roadmap should be just a list of existing or
planned cards with a planned order. Add a little explanation of each phase with a reason.
That's all we need really."*

**Card ids + order + a short reason per phase. Nothing else.**

The rule that follows: a roadmap holds **judgment** (ordering, phase rationale, what
"done" means for a phase) and **references** (card ids). It holds **no card detail** —
folder, priority, status, summary all live on the card and are derived at read time or
not shown. Only the derived half ever drifts, because it is a copy.

### Why the current spine roadmap is the counter-example

`project-hub/planning/ROADMAP-DELIVERABLES.md` is ~380 lines and is exactly the
authored spine-level master roadmap this card says should not exist. It duplicates
folder, priority and one-line summary for ~60 cards. It has been hand-reconciled against
the board **twice in three days** (2026-09-07 and 2026-09-09), each time because the
duplicated columns went stale — never because the *ordering* was wrong. That is the
evidence for the split above: the judgment held, the copy rotted.

### The completion problem — and why the framework already solves it

Gary, 2026-09-09: *"I'm not sure we've ever fully implemented a complete roadmap from top
to bottom. We always seem to get halfway through and then diverge or forget about the
roadmap. I'm not sure if that's a lack of discipline or the real roadmap changed midflight
without formally acknowledging it."*

**Verified 2026-09-09: the second, and the current file made it undetectable.**
`ROADMAP-DELIVERABLES.md` carries no success criteria for any deliverable, so "halfway
through and diverged" cannot be observed — there is no condition that was met or missed.

**The framework already ships the missing piece and this file does not use it.**
`/fw-roadmap` produces **Themes** (stable categories — what the project *is*) and
**Planning Periods** (temporal, each with a goal, its themes, and **success criteria**).
Work items carry `Theme:` and `Planning Period:` fields to link back. A planning period
with success criteria *is* a phase with a done-condition.

So there are two roadmap models in this repo: the shipped themes/periods one, and the
ad-hoc deliverable-ranked file we have actually been maintaining. **Use the shipped one.**

### Divergence must be cheap to record

If changing the plan is expensive, it happens informally and the roadmap silently stops
being true — which is the failure Gary described. A course change should be a **one-line
appended note** (what changed, why, date), never a rewrite. Two recent examples that the
current file could not absorb: FEAT-221/222 were filed mid-session from a diagram and a
slash command, and BUG-215 turned out to be a namespace problem rather than a batch
problem. None of that was indiscipline; the roadmap had nowhere to put it.

### What this means for `ROADMAP-DELIVERABLES.md`

It is **superseded by this card**, not maintained. Its *ordering and phase rationale* are
the judgment worth carrying forward into the new shape; its per-card columns are not.
Do not reconcile it a third time — the reconciliation note in the file itself set that
threshold, and it has now been reached.

---

## Open Questions (resolve before → doing)

- [ ] Is the roadmap file scaffolded (empty/template in the product/project overlays)
      or created on first `/fw-roadmap` run? (Lean: created on demand — a scaffolded
      empty roadmap is noise for workspaces that never need one.)
- [ ] Does the existing repo-level `/fw-roadmap` flow (themes, planning periods)
      carry over per-workspace unchanged, or does planning-period vocabulary stay
      spine-level while themes go per-workspace?
- [ ] **Where does the framework's own roadmap live** once the spine master is retired?
      `workspaces/framework/` is a workspace, so its roadmap belongs there — but the
      board it plans is at the spine until the ADR-009 D5 crossover. (Lean: it lives in
      `workspaces/framework/` and references spine card ids; the ids are stable across
      the crossover.)
- [ ] Old-framework `/fw-roadmap` and `docs/project/ROADMAP.md`: untouched until
      graduation (ADR-009 D5), or does this land only in the new build? (Lean: new
      build only, like FEAT-163.)

## Acceptance Criteria

- [ ] A product or project workspace can hold its own roadmap, created/updated via
      `/fw-roadmap <workspace>`
- [ ] No spine-level authored master roadmap exists in the new model; any cross-
      workspace view is generated (FEAT-196 territory)
- [ ] Roadmap location/ownership documented in exactly one home
- [ ] **A roadmap contains card ids, ordering, and phase rationale — no per-card detail**
      (no folder, priority, status or summary duplicated from the card)
- [ ] **Every phase has a done-condition** — planning-period success criteria, so
      divergence is observable rather than inferred
- [ ] **Recording a course change is a one-line append**, not a rewrite
- [ ] The themes/planning-periods model `/fw-roadmap` already produces is used, not
      re-invented
- [ ] `ROADMAP-DELIVERABLES.md`'s ordering and phase rationale are carried into the new
      shape and the file itself is retired
- [ ] Verified against the built plugin, not the source tree

## Related

- **ADR-009** — repo-is-the-customer; one board, one timeline at the spine.
- **TASK-197** — workspace type taxonomy; the refinement that surfaced this.
- **FEAT-163** — board/history slicing by workspace (the tactical layer; this item is
  the strategic layer).
- **FEAT-196** — layered progress reporting; the derived engagement-level view.
- **FEAT-164** — `/fw-new-workspace` scaffolds; touchpoint if the roadmap is scaffolded.
- **FEAT-093** — planning-period archival; the other half of the periods model (what
  happens to a period when it closes).
- **`project-hub/planning/ROADMAP-DELIVERABLES.md`** — the spine master this card
  retires. Read it for the ordering judgment, not the card columns.
- **`.claude/commands/fw-roadmap.md`** — the shipped themes/planning-periods flow.

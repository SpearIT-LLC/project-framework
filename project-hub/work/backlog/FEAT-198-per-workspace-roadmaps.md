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

## Open Questions (resolve before → doing)

- [ ] Is the roadmap file scaffolded (empty/template in the product/project overlays)
      or created on first `/fw-roadmap` run? (Lean: created on demand — a scaffolded
      empty roadmap is noise for workspaces that never need one.)
- [ ] Does the existing repo-level `/fw-roadmap` flow (themes, planning periods)
      carry over per-workspace unchanged, or does planning-period vocabulary stay
      spine-level while themes go per-workspace?
- [ ] Old-framework `/fw-roadmap` and `docs/project/ROADMAP.md`: untouched until
      graduation (ADR-009 D5), or does this land only in the new build? (Lean: new
      build only, like FEAT-163.)

## Acceptance Criteria

- [ ] A product or project workspace can hold its own roadmap, created/updated via
      `/fw-roadmap <workspace>`
- [ ] No spine-level authored master roadmap exists in the new model; any cross-
      workspace view is generated (FEAT-196 territory)
- [ ] Roadmap location/ownership documented in exactly one home
- [ ] Verified against the built plugin, not the source tree

## Related

- **ADR-009** — repo-is-the-customer; one board, one timeline at the spine.
- **TASK-197** — workspace type taxonomy; the refinement that surfaced this.
- **FEAT-163** — board/history slicing by workspace (the tactical layer; this item is
  the strategic layer).
- **FEAT-196** — layered progress reporting; the derived engagement-level view.
- **FEAT-164** — `/fw-new-workspace` scaffolds; touchpoint if the roadmap is scaffolded.

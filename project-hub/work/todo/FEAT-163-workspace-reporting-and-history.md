# Feature: Workspace-Aware Reporting and History

**ID:** FEAT-163
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-07-02
**Theme:** Workflow
**Workspace:** framework
**Planning Period:** [Optional]

---

## Summary

Add the ability to view and report project status **by workspace**, and ensure session
history can be labeled and filtered by workspace. This is the reporting half of the
workspace model (ADR-009): one Kanban board and one ID namespace serve all workspaces,
so the board must be sliceable by the `Workspace:` field or per-workspace views cannot
exist and drift is silent.

> **Rewritten 2026-08-18** in `workspace` vocabulary per ADR-009 (was "Stream-Aware
> Reporting and History" under ADR-005). The field decision that gated this item is
> now settled — ADR-009 OQ2: a distinct **`Workspace:`** field, orthogonal to
> `Theme:`. This item is **implemented as part of the framework workspace build**
> (`workspaces/framework/`), not patched onto the old commands.

## Motivation

Per ADR-009, a single repo hosts multiple **workspaces** with one shared Kanban board.
The contractor needs to slice the board and history by workspace on demand — "show me
only sow-02 work," "what did I do for the jobqueue workspace last month." Retrospectives
follow the same model (ADR-009 D2): scope is declared in the document, so account-wide
evaluation reads across workspace-labeled items — which only works if items are
reliably labeled and unlabeled items are surfaced.

## Scope

**In:**
- **`Workspace:` field** added to work-item templates (settled — ADR-009 OQ2; optional
  in single-workspace repos, expected in multi-workspace repos).
- Workspace filter/grouping for status reporting — either `--workspace <value>` flags
  on the status/WIP commands or a dedicated workspace view (decide during design).
- Group-by-workspace summary (counts per workspace across backlog/todo/doing/done).
- **Surface unassigned items** — items with no `Workspace:` value are reported as
  such, so drift is visible (ADR-005/009 risk).
- Session history records/labels by workspace so a per-workspace history slice is
  possible; retrospectives declare scope via the same field.

**Out (this item):**
- Git tag namespacing per workspace (deferred since ADR-005).
- Workspace scaffolding — see FEAT-164.
- Migration of existing work items to carry the field (follow-up chore once the
  framework-next commands exist).

## Acceptance Criteria

- [ ] Work-item templates carry the `Workspace:` field.
- [ ] A command produces status grouped or filtered by workspace.
- [ ] Work items lacking a workspace value are counted and flagged, not silently
      dropped.
- [ ] Session history output can be filtered/labeled by workspace.
- [ ] Reuses one frontmatter parser across the framework-next commands (no per-command
      parsing).
- [ ] Documented where the framework-next command docs live (the command doc is the
      SoT — ADR-008/009).

## Notes

- **Release buckets need workspace-qualified keys** (surfaced 2026-08-20, TASK-197
  follow-on): released cards stay on the spine timeline per ADR-009 D2 (never split
  into per-workspace folders; `Workspace:` field carries scope), but in a
  multi-product customer repo "release" is per-product — spine buckets must key on
  workspace + version (e.g. `history/releases/dpmextract-v2.1/`), since bare `v2.1/`
  collides across products. Design detail for the new release flow; the
  shipped-files half lives in the workspace's write-once `deliverables/` (TASK-197).

- Original gating question ("reuse `Theme:` vs. new field") settled 2026-08-18:
  distinct `Workspace:` field. `Theme:` keeps its *stable category* meaning; multiple
  workspaces can serve one theme.
- This file itself dogfoods the field (`Workspace: framework`) on the old board,
  per ADR-009 D5 (old board stays authoritative until graduation).

## Related

- ADR-009 (workspace model — supersedes ADR-005)
- FEAT-164 (workspace scaffolding)
- FEAT-190 (framework workspace kickoff)

# Feature: Trim the Operations Workspace Scaffold

**ID:** FEAT-193
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-08-19
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

First real test of `/fw-new-workspace <op> operations` (2026-08-19) showed the operations
scaffold is heavier than the work it holds. Trim it to:

- `open/`
- `onhold/`
- `closed/`
- `meetings/`
- `agreements/`
- `reference/`

Changes from current: the `intake/` tree (`intake/incidents`, `intake/requests`) is
replaced by workspace-level **flow folders** — location is the status, and the record
type (incident vs. request) is carried by the `INC-`/`REQ-` filename prefix (FEAT-195),
mirroring the kanban's folder=status / prefix=type pattern. `deliverables/` and
`contacts/` are dropped.

---

## Rationale (decided in review, 2026-08-19)

- **`intake/` replaced by flow folders** — operations stays off the kanban board (its
  gates are built for planned work, not incident response), but keeps the board's
  location-is-status concept: `open/` → `onhold/` (waiting on customer et al.) →
  `closed/`, with record type in the filename prefix. One flow structure instead of two
  parallel category trees; `/fw-wip` gets one glob. ITIL was considered for growth:
  `problems/` and `changes/` are the plausible additions, and both are deliberately
  excluded. Problems: promote a recurring incident to a problem record only when
  root-cause work is consciously funded. Changes: change records always live in the
  client's change-management system (e.g. ServiceNow); the workspace holds at most a
  pointer from the related incident or request. When an incident spawns real project
  work, that work becomes a kanban item cross-referenced from the record — the systems
  link, they don't merge.
- **`deliverables/` dropped** — in operations the resolved incident/request record *is*
  the output; the folder would sit empty or duplicate it.
- **`contacts/` dropped** — contacts get one company-wide home as a knowledgebase
  `company` domain (FEAT-194), per the Single-Source Rule (ADR-008). Per-workspace
  contact folders are the scattered-copies pattern that rule exists to kill.
- **`meetings/`, `agreements/` kept** — ops reviews/vendor calls need a home; agreements
  scoped to operational ones (SLAs, vendor/support contracts). Client agreements tied to
  a SOW stay in that SOW's workspace.

---

## Scope

**In scope:**
- `fw-new-workspace.sh` only — the sole home for workspace structure (ADR-009 D3).
  Note: the current script builds operations from the shared `FLOOR` list
  (`meetings reference deliverables contacts agreements`) plus `intake/*`; operations
  now diverges from the floor, so give it its own dir list while keeping the structure
  authored in exactly one place.
- Regenerate the test `workspaces/operations` as a **one-time manual step** — safe only
  because the 2026-08-19 placeholder is empty and uncommitted. The script itself must
  never delete or modify an existing workspace: its existing refuse-if-exists guard
  stays, and no delete/regenerate behavior is added to any script or command.

**Out of scope:**
- Changing the floor for `application` and `sow` (the contacts question for those types
  is FEAT-194's open question).
- Any `problems/` or `changes/` support.

---

## Acceptance Criteria

- [ ] `fw-new-workspace.sh <name> operations` emits exactly: `open/`, `onhold/`,
      `closed/`, `meetings/`, `agreements/`, `reference/` (plus `README.md`)
- [ ] `application`, `knowledgebase`, and `sow` scaffolds are unchanged
- [ ] No document restates the operations tree (ADR-009 D3 still holds)
- [ ] The script still refuses an existing workspace — no deletion or in-place
      modification is introduced anywhere
- [ ] Verified against the built plugin, not the source tree

---

## Documentation

- [ ] CHANGELOG entry in the framework workspace
- [ ] Check ADR-009 for any restated operations tree; amend with a decision note if the
      scaffold shape is recorded there

---

## Related

- **FEAT-164** — `/fw-new-workspace`; this trims its operations output.
- **FEAT-194** — kb `company` domain; where the dropped `contacts/` content lives.
- **FEAT-195** — record ID convention; supplies the `INC-`/`REQ-` prefixes the flow
  folders rely on, and the closed-folder archival answer.
- **ADR-008** — Single-Source Rule (drives the contacts decision).
- **ADR-009 D3** — structure by command only; the script is the one home.

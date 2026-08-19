# Feature: Operations Record ID Convention (ITIL Prefixes)

**ID:** FEAT-195
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-08-19
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

Operations intake records get their own ID system — the same reasoning that gave the
kanban its own work-item IDs. ITIL prefixes, per-workspace sequence:

- `INC-###` — incidents
- `REQ-###` — requests

Customer ticket systems (Jira, ServiceNow, …) are recorded as a **cross-reference field
on the record, never as our primary key**. Decided 2026-08-19 with FEAT-193/194.

**Lifecycle (decided with FEAT-193):** location is the status — records move
`open/` → `onhold/` → `closed/` at the workspace level; the prefix carries the type.
Operations stays off the kanban board; `/fw-wip` and `/fw-status` surface active ops
records alongside kanban WIP for one view of everything in flight.

**Closed-folder growth:** `closed/` accumulates indefinitely, so closure includes a
periodic sweep into year buckets (`closed/2026/…`) — same shape as the board's
planning-period archival (FEAT-093). Sweep is a command/script, never a hand move.

---

## Rationale

- We don't control the customer's namespace — internal-only work can't mint a Jira ID.
- The mapping isn't 1:1 — one incident may relate to zero or several customer tickets; a
  field holds that, a filename can't.
- Our IDs must survive a customer changing tools.
- ITIL prefixes reused deliberately — no need to invent new vocabulary.

---

## Scope

**In scope:**
- The ID convention (prefix + sequence) and the cross-reference field in the
  incident/request record shape.
- Next-ID mechanics for the operations namespace. **Direction (Gary, 2026-08-19):**
  adapt the existing next-id script to take a namespace/folder root rather than writing
  a second one — it's the same function over different folders (kanban vs. operations).
  One authored home for the ID logic (ADR-008).
- Move mechanics, same treatment (Gary, 2026-08-19): adapt `fw-move` to the operations
  flow (`open/` → `onhold/` → `closed/`) rather than writing a second mover — `git mv`
  enforcement and the stamp-on-terminal-move behavior (Completed on kanban → done;
  a Closed date on ops → closed) are shared machinery. The kanban-specific gates
  (ripeness review, dependency check) must NOT apply to ops moves — the transition
  policy is per-namespace.

**Out of scope:**
- Migrating or renaming any existing records.
- Any sync or automation against customer systems — cross-reference is a manual field.

---

## Open Questions (resolve before → doing)

- [ ] Sequence scope: one sequence per prefix (`INC-001` and `REQ-001` coexist) or one
      shared sequence per workspace? (Kanban precedent: shared namespace.)
- [ ] Record template: does an incident/request record template ship with the scaffold,
      and where is its one home? Direction under discussion: authored in the plugin so
      updates propagate; a project's `.claude/templates/` acts as optional override.
- [ ] Archival trigger: when does the `closed/` year-bucket sweep run (on close, on
      demand, or with the FEAT-093 planning-period archival)?

---

## Acceptance Criteria

- [ ] ID convention documented in exactly one home; operations records named
      `INC-###-slug.md` / `REQ-###-slug.md`
- [ ] Records carry a customer cross-reference field (0..n external tickets)
- [ ] Next-ID logic has one authored home shared across namespaces — no second script
- [ ] Move logic likewise: `fw-move` handles ops transitions with `git mv`, per-namespace
      transition policy (no kanban gates on ops moves), and a Closed stamp on → closed
- [ ] Verified against the built plugin, not the source tree

---

## Related

- **FEAT-193** — operations scaffold trim; these records flow through its `open/`,
  `onhold/`, `closed/` folders.
- **FEAT-093** — planning-period archival; the kanban counterpart of the closed sweep.
- **FEAT-194** — kb `company` domain; contacts referenced from records live there.
- **ADR-008** — Single-Source Rule; one home for ID logic and for the convention.

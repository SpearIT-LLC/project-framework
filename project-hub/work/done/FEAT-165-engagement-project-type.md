# Feature: Introduce `engagement` Project Type

**ID:** FEAT-165
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-07-02
**Theme:** Project Guidance
**Planning Period:** [Optional]

---

## Summary

Add a fifth `project.type` — **`engagement`** — for the single-customer /
multiple-stream model (ADR-005), and audit every place in the framework that
branches on or enumerates project type so the new type is fully wired, not just
present in the schema.

## Motivation

Per ADR-005, a customer engagement is structurally distinct from the existing
`toolbox` type. `toolbox` is a flat collection of **homogeneous peers** (utility
scripts). An `engagement` is a customer workspace of **heterogeneous activities**
(org info, source, operations, knowledge base, deliverables) that **sprawls wider
over a long engagement**. Overloading `toolbox` to mean both repeats the same
"one term, two meanings" trap the team caught with `Theme`. A distinct type keeps
the taxonomy honest.

The schema description is the primary runtime clarity surface (it is what
`Setup-Framework.ps1` shows in the type picker), so wording matters.

## Scope

**In:**
- Add `engagement` to `project.type` enum in `framework-schema.yaml` with a clear,
  picker-appropriate description. **Proposed wording** (from ADR-005 discussion,
  not yet applied to the schema — this item applies it):
  > "One customer/client, one repo — multiple heterogeneous work streams (SOWs,
  > deliverables, source, operations, knowledge base) under a shared spine, growing
  > over a long engagement"
- **Audit every type-branching / type-enumerating point:**
  - `framework-roles.yaml` → `project_type_defaults`: add an `engagement` default
    role (else it falls through to `fallback_default`). **Confirmed gap.**
  - `Setup-Framework.ps1` — verify the picker renders the new type correctly (it
    parses the schema, so likely automatic — confirm, don't assume).
  - Docs enumerating the four types: `framework/CLAUDE.md`,
    `framework/docs/PROJECT-STRUCTURE.md`, `framework/docs/ref/GLOSSARY.md`,
    `framework/docs/collaboration/architecture-guide.md`,
    `templates/NEW-PROJECT-CHECKLIST.md`.
  - Any templates that vary by project type.

**Out (this item):**
- The `engagement` type's detailed folder structure (see FEAT-164).
- Stream reporting/history (see FEAT-163).

## Acceptance Criteria

- [x] `engagement` present in schema with a description that is unambiguous at the
      setup picker. *(framework-schema.yaml:29-30)*
- [x] `project_type_defaults` has an `engagement` entry with a deliberate role.
      *(framework-roles.yaml:47 → `senior-architect`; session-start default only,
      freely switched conversationally — see CLAUDE.md role section)*
- [x] Setup picker verified to show the new type. *(Setup-Framework.ps1 parses the
      schema generically via `Get-ProjectTypes`; the regex captures `engagement`
      with no script change — verified by tracing the pattern, lines 104/114)*
- [x] All docs enumerating project types updated to include `engagement`.
      *(GLOSSARY.md:159, PROJECT-STRUCTURE.md:207, NEW-PROJECT-CHECKLIST.md:75,125)*
- [x] Grep for `toolbox`/type enumerations confirms no stale "four types" claims.
      *(also fixed a pre-existing bug: NEW-PROJECT-CHECKLIST.md still said `tool`,
      stale since the 2026-01-17 `tool`→`toolbox` rename — now `toolbox`)*

## Notes

- Chosen name `engagement` (over `client` / `workspace`) — see ADR-005 decision.
- Audit surface identified 2026-07-02: `framework-roles.yaml` is the one with
  functional (not just documentary) impact.

## Related

- ADR-005 (multi-SOW / engagement customer repo model)
- FEAT-163 (stream-aware reporting and history)
- FEAT-164 (scalable stream content folder structure)

# Feature: `/fw-new-domain` — Add a Domain to an Existing Knowledgebase

**ID:** FEAT-192
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-08-18
**Workspace:** framework
**Completed:** 2026-08-24

---

## Summary

`/fw-new-workspace` only creates workspaces; there is no command to grow one. Add
`/fw-new-domain <kb> <domain>` to scaffold a new domain inside an existing knowledgebase
and append its line to the kb's `INDEX.md`.

Surfaced 2026-08-18 while testing: `/fw-new-workspace kb kb hpc` failed with "workspace
already exists" — the intent was a second domain (`hpc`) in the existing `kb`.

---

## Problem Statement

**Current state** (verified 2026-08-18): a knowledgebase is created with exactly one
domain (`fw-new-workspace.sh <name> knowledgebase <domain>` — the domain is required, per
the ADR-009 D4 amendment). Adding a second domain has no command, and ADR-009 D3 forbids
creating workspace structure by hand.

**Desired state**: `/fw-new-domain` scaffolds `<domain>/` (same per-domain structure the
create path uses — one home for that structure) inside an existing kb workspace and adds
the domain's entry to `INDEX.md` (one index per kb; a domain gets no index of its own).

**Shape decision (direction set at filing):** a separate command, not an `--add-domain`
flag on `/fw-new-workspace` — creating a workspace and growing one are different verbs,
and the INDEX append is a different operation from a fresh scaffold. The per-domain
folder set must still have exactly one authored home shared by both paths (likely the
same script, refactored so create and add-domain call one scaffold function).

---

## Scope

**In scope:**
- The command + script path (script remains the sole structure authority, ADR-009 D3).
- INDEX.md append with the description-pending placeholder.
- Guards: target workspace must exist and be a knowledgebase; domain must not already
  exist; domain name validated like the create path.

**Out of scope:**
- Removing or renaming domains.
- FEAT-191's guided intake (but its kb question set should eventually point here for
  "add another domain later").

---

## Acceptance Criteria

> **Interface revised at implementation (2026-08-24, Gary):** the command is
> **`/fw-new-kb-domain <domain>`** — renamed so the kb target lives in the name
> (a bare "domain" silently implies kb; new users wouldn't get that), and the
> `<kb>` argument dropped because kb became a fixed singleton at
> `workspaces/kb` (2026-08-20). It also **creates the kb on first use** instead
> of erroring — `/fw-new-workspace kb <domain>` delegates here, so either door
> lands on one code path and an existing kb + new domain now grows instead of
> failing (the exact 2026-08-18 test that surfaced this card).

- [x] `/fw-new-kb-domain <domain>` scaffolds the domain (creating the kb shell on
      first use) — verified 2026-08-24: first-call create, second-call grow
- [x] The per-domain folder set has one authored home shared with the create path
      — the template `_domain_/` shape; create delegates to this script
- [x] `INDEX.md` gains the domain's line; no per-domain index is created —
      verified across two domains plus the delegated door
- [x] Errors cleanly: duplicate domain (case-insensitive), bad name; missing kb is
      now first-use creation by design; tampered kb (no INDEX.md) errors
- [x] Verified against the built plugin, not the source tree — kb fixture
      regenerated 2026-08-24 from the published marketplace copy

---

## Documentation

- [x] Command doc for `/fw-new-kb-domain` (the flow's one home) — includes the
      INDEX-description judgment step, mirroring the workspace purpose step
- [x] CHANGELOG entry in the framework workspace — `CHANGELOG.md` created (did
      not exist; started at [Unreleased] with this window's changes)

---

## Related

- **FEAT-164** — `/fw-new-workspace`; this is its growth counterpart.
- **FEAT-191** — guided purpose intake; the kb question set and this command should
  reference each other.
- **ADR-009 D3/D4** — structure by command only; kb domain model (D4 amended 2026-08-18).

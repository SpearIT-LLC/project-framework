# Feature: Swarm Modes — Context-Aware Swarm Types

**ID:** FEAT-150
**Type:** Feature
**Priority:** Medium
**Created:** 2026-02-22

---

## Summary

Extend `/fw-swarm` to support multiple context-aware modes beyond the original project kick-off. The core multi-perspective team structure is reusable across common engineering and project scenarios — modes make the pattern explicit and configurable.

---

## Problem Statement

The original `/fw-swarm` command was hardcoded for project kick-off. The underlying pattern — structured multi-persona analysis with role-specific focus areas — is valuable in other contexts: incident triage, decision reviews, architecture stress-tests, risk identification, and technology evaluation.

**Context:** Raised after the 2026-02-20 Swarm Kick-off session as a natural evolution of the MVP. The pattern is proven; the question was how to make it general without over-engineering.

---

## Modes Implemented

| Mode | Invoke as | Purpose |
|------|-----------|---------|
| `project` | `/fw-swarm project` | Project kick-off — existing behaviour, now explicitly named |
| `incident` | `/fw-swarm incident` | Live collaborative triage — iterative diagnostic loop until resolved |
| `decision` | `/fw-swarm decision` | Structured decision review — options, trade-offs, ADR output |
| `architecture` | `/fw-swarm architecture` | Design stress-test before build |
| `risk` | `/fw-swarm risk` | Identify and document a project risk |
| `research` | `/fw-swarm research` | Evaluate any external tool, library, API, language, framework, or service |

**Not included:** `retrospective` mode — deferred, may become a separate `/fw-retro` command.

---

## Design Decisions

**Single file:** All modes live in one `fw-swarm.md`. Not split per mode.

**Mode dispatch:** Natural language detection (infer from opening) + explicit argument + ask if ambiguous.

**Resume:** Option A — explicit `resume` argument.
```
/fw-swarm incident resume                    # most recent
/fw-swarm incident resume 2026-02-24-slug    # specific session
```

**Output locations:**

| Mode | Artifact | Location |
|------|----------|----------|
| `project` | Brief + Outline | `project-hub/planning/` |
| `incident` | Resolution doc (incremental) | `project-hub/history/swarm/` |
| `decision` | ADR (sequential NNN-slug.md) | `project-hub/research/adr/` |
| `architecture` | Architecture doc | `project-hub/docs/architecture/` |
| `risk` | Risk file | `project-hub/risks/` |
| `research` | Research note | `project-hub/research/` |
| **all modes** | Meeting minutes | `project-hub/meetings/` |

**Filename pattern:** `YYYY-MM-DD-swarm-{mode}-{slug}.md` for meetings. `YYYY-MM-DD-{slug}.md` for artifacts (location provides mode context). Exception: decision ADRs use `NNN-{slug}.md` to match existing convention.

**Incident mode:** Iterative diagnostic loop — not a single-pass. Casey (Ops) added to team roster for incident triage. Resolution doc written incrementally during session.

**Research mode (formerly "vendor"):** Renamed from `vendor` — scope is broader than commercial vendors. Covers any external tool, library, API, language, framework, platform, or service whether open source or commercial.

**Risk fields:** `Status: Open | Mitigated | Accepted | Closed` (simplified from longer list).

**Scope: fw-swarm only.** Plugin `swarm.md` not updated in this item — tracked separately.

---

## Acceptance Criteria

- [x] All 6 modes implemented in `.claude/commands/fw-swarm.md`
- [x] All 6 modes implemented in `templates/starter/.claude/commands/fw-swarm.md`
- [x] Each mode has its own persona focus, phase structure, and output template
- [x] Mode inferred from natural language or accepted as argument; ambiguous input asks user
- [x] Resume logic defined (Option A — explicit argument)
- [x] Output locations and filename patterns defined for all modes
- [x] `research` mode description is clearly scoped in help text

---

**Last Updated:** 2026-02-24
**Status:** Done
**Completed:** 2026-02-24

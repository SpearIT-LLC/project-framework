# Feature: Swarm Modes — Context-Aware Swarm Types

**ID:** FEAT-150
**Type:** Feature
**Priority:** Medium
**Created:** 2026-02-22

---

## Summary

Extend `/swarm` (and `/fw-swarm`) to support multiple swarm modes beyond the current project kick-off pattern. The core multi-perspective analysis structure is reusable across common engineering and project scenarios; modes make the pattern explicit and configurable.

---

## Problem Statement

The current `/swarm` command is hardcoded for project kick-off. The underlying pattern — structured multi-persona analysis with role-specific focus areas — is valuable in other contexts: incident triage, decision reviews, retrospectives, initial project setup. Without named modes, each new use case requires a custom command or users must adapt the output mentally.

**Context:**
Raised after the 2026-02-20 Swarm Kick-off session as a natural evolution of the MVP. The pattern is proven; the question is how to make it general without over-engineering.

---

## Proposed Modes

| Mode | Trigger | Description |
|------|---------|-------------|
| `project` | `swarm project` | Current default — kick-off facilitation, project brief, two-phase structure |
| `incident` | `swarm incident` | Triage a live or recent outage/problem — business impact, technical root cause, systemic risk |
| `decision` | `swarm decision` | Structured review of a decision — options, trade-offs, recommendation from each persona |
| `retrospective` | `swarm retrospective` | Post-mortems and end-of-sprint retrospectives (may become a standalone command) |
| `architecture` | `swarm architecture` | Design review before build — stress-test a proposed technical approach; Dan and Sam lead, Morgan/Riley join if relevant. Output: ADR or design review note |
| `risk` | `swarm risk` | Pre-release or pre-delivery threat assessment — what could go wrong across product, technical, security, and operational lenses. Morgan prominent alongside Sam. Output: risk register or go/no-go recommendation |
| `vendor` | `swarm vendor` | Tool, library, or service evaluation — Alex frames requirements, Dan assesses integration complexity, Sam checks architectural fit, Morgan covers security/compliance. Output: vendor evaluation note |

**Note on `retrospective`:** This mode may justify its own command (`/fw-retro`) given how distinct the output format is. Tracked here for now; may be split out during design.

**Note on implementation sequencing:** Modes will likely be implemented one at a time in separate work items. This file captures the full intended scope; individual delivery work items will reference back here.

---

## Invocation Design

Two approaches under consideration — likely use both:

**1. Explicit argument:**
```
/swarm project
/swarm incident
/swarm decision
```

**2. Natural language detection:**
Claude infers mode from opening description. `"We had an outage last night..."` → incident mode. `"Should we use Postgres or SQLite?"` → decision mode. Falls back to asking if ambiguous.

Combining both gives power users speed and new users a guided path.

---

## Requirements

**Must Have:**
- At least `project` and `incident` modes implemented
- Mode is either detected from natural language or accepted as an argument
- Each mode has its own persona focus areas and output template
- Graceful fallback when mode is ambiguous (ask the user)

**Should Have:**
- `decision` mode
- `architecture` mode
- `risk` mode
- `vendor` mode
- Documentation of available modes in `/fw-help`

**Out of Scope (this version):**
- `retrospective` as a standalone command (tracked separately if split)
- Custom persona configuration
- Saving/reusing swarm configurations

---

## Acceptance Criteria

- [ ] `/swarm project` (or natural language) produces current kick-off output
- [ ] `/swarm incident` produces triage-focused output with appropriate persona focus areas
- [ ] `/swarm decision` produces decision-review output
- [ ] Mode detection from natural language works for clear cases
- [ ] Ambiguous input prompts user to clarify mode
- [ ] Both plugin (`/spearit-framework:swarm`) and local (`/fw-swarm`) updated

---

## Design Notes

Each mode should define:
- **Personas active** (may differ by mode — incident might drop Product Owner, add Ops)
- **Phase structure** (kick-off is two-phase; incident might be three: triage → cause → prevention)
- **Output template** (meeting record vs. incident report vs. decision log)
- **Suggested next steps** (what command or action follows naturally)

---

**Last Updated:** 2026-02-22 (added architecture, risk, vendor modes)
**Status:** Backlog

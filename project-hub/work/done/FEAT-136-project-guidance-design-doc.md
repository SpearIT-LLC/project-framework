# Feature: Project Guidance Design Document

**ID:** FEAT-136
**Type:** Feature
**Priority:** High
**Version Impact:** NONE (design/planning work)
**Created:** 2026-02-17
**Completed:** 2026-02-17
**Theme:** Project Guidance
**Planning Period:** PI MVP

---

## Summary

Create `project-hub/planning/design/project-guidance.md` - a design document that defines the intended user experience, conversation flow, outputs, and open questions for the Project Guidance theme before implementation begins.

This design doc is a prerequisite for building the `/swarm` command.

---

## Problem Statement

The `/swarm` command concept is clear at a high level but not designed at a level of detail sufficient to implement. Before building, we need to answer:
- What exactly does the kick-off conversation look like?
- What disciplines/roles are available and when are they invoked?
- What does the command produce (outputs)?
- What is the full project lifecycle that Project Guidance enables?

Without this design doc, implementation will be ad-hoc and hard to iterate on.

---

## Document Contents

The design doc should capture:

### 1. Project Lifecycle Overview
The full lifecycle a user follows from idea to execution — not just the sequence, but the handoffs:
```
/swarm (kick-off) → Project Brief → Roadmap → Planning Period → Work Items → Report → (repeat)
```
For each step: what it is, what triggers it, what it produces, and who/what initiates the next step.

**Also covers:**
- What "repeat" looks like — is it a retrospective? A lighter check-in? A new swarm?
- The lifecycle hook for periodic review (even if that command is Future — swarm must be designed with it in mind)

### 2. MVP Scope Definition
Explicit in/out list for PI MVP. Prevents the design doc from being a pure vision document.

**Covers:**
- Which lifecycle steps are in scope for PI MVP vs. future
- Fixed vs. dynamic discipline roster in MVP
- Output format: written to file vs. chat output only
- Minimum viable kick-off: what's the shortest acceptable swarm for a trivial project?
- What `/swarm` does NOT do in MVP (explicit exclusions)

### 3. `/swarm` Conversation Design
- Opening question(s)
- Clarifying question sequence and branching
- How complexity/scope is assessed
- How disciplines are selected and recommended
- Tone and persona of the "team"
- Termination condition: how does `/swarm` know it has enough information?

### 4. Discipline Roster (MVP)
For PI MVP, define the initial set of disciplines:
- What roles are available (PM/Product Owner, Scrum Master, Senior Dev, etc.)
- When each is invoked (what project characteristics trigger inclusion)
- What each discipline contributes to the kick-off
- Fixed roster for MVP — dynamic expansion is Future

### 5. Outputs
What `/swarm` always produces:
- Project brief (what, for whom, why, MVP definition)
- Recommended structure (light/medium/full - scales to project size)
- Starter backlog (5-10 work items)
- Open risks/questions flagged by the team

### 6. Edge Cases & Failure Modes
- User runs `/swarm` mid-project (project already has ROADMAP.md, existing backlog)
- User has no clear idea what they're building
- Scope is trivially small (a script, not a product)
- Relationship to existing framework artifacts: does swarm read them? Ignore them?

### 7. Backlog Culling (Placeholder)
Future capability for reviewing and pruning stale backlog items. Likely belongs in Project Guidance theme. Capture the concept here for design consideration — don't spec yet.

### 8. Open Questions to Resolve
- How does the team "assemble" (sequential roles speaking, or synthesized output)?
- Does the brief get written to a file, or output to chat only?
- Naming: is the team given a name/personality, or is it anonymous?
- What triggers a periodic review vs. a new swarm?

### 9. Future Considerations (not PI MVP)
- Periodic review command
- Retrospective command
- Dynamic discipline expansion mid-project

---

## Acceptance Criteria

- [x] `project-hub/planning/design/project-guidance.md` created
- [x] Full project lifecycle documented with handoffs (not just sequence)
- [x] MVP scope explicitly defined — in/out list, no ambiguity
- [x] `/swarm` conversation flow designed (question sequence, branching, termination)
- [x] MVP discipline roster defined (which roles, when invoked, fixed for MVP)
- [x] Command outputs specified (brief format, backlog format, file vs. chat)
- [x] Edge cases documented (mid-project swarm, trivial scope, existing artifacts)
- [x] Backlog culling placeholder captured
- [x] Open questions enumerated for resolution during implementation
- [x] Document reviewed and approved before `/swarm` implementation begins

---

## Dependencies

**Requires:** None (pure design work)

**Blocks:**
- `/swarm` command implementation (FEAT-TBD)
- Any Project Guidance work items

**Related:**
- `project-hub/planning/ROADMAP.md` - PI MVP planning period
- FEAT-092: Sprint support (depends on Project Guidance being established first)

---

**Last Updated:** 2026-02-17

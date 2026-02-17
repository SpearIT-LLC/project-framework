# Feature: Project Guidance Design Document

**ID:** FEAT-136
**Type:** Feature
**Priority:** High
**Version Impact:** NONE (design/planning work)
**Created:** 2026-02-17
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
The intended sequence a user follows from idea to execution:
```
/swarm (kick-off) → Project Brief → Roadmap → Planning Period → Work Items → Report → (repeat)
```
Each step: what it is, what triggers it, what it produces.

### 2. `/swarm` Conversation Design
- Opening question(s)
- Clarifying question sequence
- How complexity/scope is assessed
- How disciplines are selected and recommended
- Tone and persona of the "team"

### 3. Discipline Roster (MVP)
For PI MVP, define the initial set of disciplines:
- What roles are available (PM/Product Owner, Scrum Master, Senior Dev, etc.)
- When each is invoked (what project characteristics trigger inclusion)
- What each discipline contributes to the kick-off

### 4. Outputs
What `/swarm` always produces:
- Project brief (what, for whom, why, MVP definition)
- Recommended structure (light/medium/full - scales to project size)
- Starter backlog (5-10 work items)
- Open risks/questions flagged by the team

### 5. Open Questions to Resolve
- How does the team "assemble" (sequential roles speaking, or synthesized output)?
- What's the minimum viable kick-off (how short can it be for a simple project)?
- How does `/swarm` know when enough information has been gathered?
- Naming: is the team given a name/personality, or is it anonymous?

### 6. Future Considerations (not PI MVP)
- Periodic review command
- Retrospective command
- Dynamic discipline expansion mid-project

---

## Acceptance Criteria

- [ ] `project-hub/planning/design/project-guidance.md` created
- [ ] Project lifecycle sequence documented (swarm → brief → roadmap → work → report)
- [ ] `/swarm` conversation flow designed (question sequence, branching)
- [ ] MVP discipline roster defined (which roles, when invoked)
- [ ] Command outputs specified (brief format, backlog format)
- [ ] Open questions enumerated for resolution during implementation
- [ ] Document reviewed and approved before `/swarm` implementation begins

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

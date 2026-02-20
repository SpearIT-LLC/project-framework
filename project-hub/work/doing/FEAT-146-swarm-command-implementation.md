# Feature: /swarm Command Implementation

**ID:** FEAT-146
**Type:** Feature
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-02-20
**Theme:** Project Guidance
**Planning Period:** v1.1

**Depends On:** FEAT-136 (Project Guidance Design Doc - complete)

---

## Summary

Implement the `/swarm` command for the `spearit-framework` full plugin — a two-phase AI-facilitated kick-off conversation that produces a Project Brief, Project Outline, and meeting notes. This is the core deliverable of the Project Guidance theme.

**Goal:** Give the user a clear, confident project direction — what to build, for whom, and in what order — before they commit to any work.

---

## Problem Statement

**What problem does this solve?**

Users starting a new project (or pivoting an existing one) have no structured way to think through direction before jumping into work items and execution. The `/swarm` command provides a facilitated team conversation that surfaces the right questions, the right perspectives, and the right risks before the user commits to a direction.

**Who is affected?**

Solo developers and small teams using the full plugin who want help clarifying direction before planning.

**Design Document:**

`project-hub/planning/design/project-guidance.md` — revised 2026-02-20.

---

## Proposed Implementation

### Commands to Add

#### `/spearit-framework:swarm`

Two-phase kick-off:

**Phase 1 — Discovery**
- Product Owner opens with a single direct question
- PO asks clarifying questions including "should we build this at all?"
- PO assembles team by judgment based on signals heard
- Each discipline speaks in turn (2-4 sentences max)
- Phase ends when team has answered the 5 termination criteria
- User approves direction before Phase 2

**Phase 2 — Planning**
- PO + Architect (or Senior Dev) produce brief and outline
- User approves outputs before files are written
- Files written: meeting notes + project brief + project outline

#### `/spearit-framework:swarm --summary`

Bottom-line only — skips team discussion, produces brief and outline directly.

### Outputs

| Output | Location |
|---|---|
| Meeting notes | `project-hub/meetings/YYYY-MM-DD-swarm-kickoff.md` |
| Project brief | `project-hub/planning/project-brief.md` |
| Project outline | `project-hub/planning/project-outline.md` |
| Starter backlog | In chat only (user creates files with `/fw-new`) |

### Team Roster (MVP)

**Always present:** Product Owner (Alex), Senior Developer (Dan)

**Conditional — PO assembles by judgment:**
- Architect (Sam) — non-trivial scope, multiple components or integrations
- UX Designer (Jordan) — user-facing interface
- Security Analyst (Morgan) — auth, PII, payments, external APIs
- Data/ML Specialist (Riley) — AI, data pipelines, analytics

**Phase 2 only:** PO + Architect (or Senior Dev if no Architect)

---

## Requirements

### Functional Requirements

- [ ] `/swarm` opens with a single warm direct question from the Product Owner
- [ ] PO clarifying questions include "should we build this at all?"
- [ ] PO assembles team by judgment based on conversation signals (not a fixed trigger list)
- [ ] Each role speaks in turn with focused, scoped contributions (2-4 sentences max)
- [ ] Phase 1 terminates when team has answered the 5 termination criteria
- [ ] User approves direction before Phase 2 begins
- [ ] Phase 2 produces brief and outline (PO + Architect/Senior Dev only)
- [ ] User approves outputs before files are written
- [ ] Meeting notes written to `project-hub/meetings/YYYY-MM-DD-swarm-kickoff.md`
- [ ] Project brief written to `project-hub/planning/project-brief.md`
- [ ] Project outline written to `project-hub/planning/project-outline.md`
- [ ] Starter backlog (5-10 items) output to chat
- [ ] `--summary` flag bypasses team discussion
- [ ] Archives existing brief/outline to `project-hub/planning/archive/` before overwriting
- [ ] Degrades gracefully for trivially small projects (2-role team, 3-5 exchanges, single-phase outline)

### Non-Functional Requirements

- [ ] Tone: warm, direct, professional — not consultant-ish
- [ ] Compatible with existing full plugin commands
- [ ] help.md updated to list `/swarm`

---

## Design Reference

Full conversation design, discipline roster, output templates, edge cases, and decisions log:

**`project-hub/planning/design/project-guidance.md`**

---

## Files to Add

- `plugins/spearit-framework/commands/swarm.md`

## Files to Update

- `plugins/spearit-framework/commands/help.md` — add `/swarm` to listing
- `plugins/spearit-framework/CHANGELOG.md` — v1.1 entry
- `plugins/spearit-framework/.claude-plugin/plugin.json` — bump version

---

## Dependencies

**Requires:**
- FEAT-136 (Project Guidance Design Doc) — complete ✅

**Related:**
- FEAT-137 — Plugin Project Guidance Commands (status, backlog, plan)
- FEAT-138 — Plugin Developer Guidance Commands
- FEAT-139 — claude-project.yaml config (future: enables auto backlog creation)

---

## Acceptance Criteria

- [ ] `/spearit-framework:swarm` runs a two-phase facilitated kick-off conversation
- [ ] Phase 1 ends with user direction approval before Phase 2 begins
- [ ] `/spearit-framework:swarm --summary` produces brief and outline without team discussion
- [ ] Meeting notes saved to correct location with correct format
- [ ] Project brief saved to correct location matching template in design doc
- [ ] Project outline saved to correct location matching template in design doc
- [ ] Starter backlog output to chat (5-10 items)
- [ ] Existing brief/outline archived to `planning/archive/` before overwrite
- [ ] `/spearit-framework:help` updated to list `/swarm`
- [ ] All tested in framework project
- [ ] Plugin version bumped and rebuilt

---

**Last Updated:** 2026-02-20

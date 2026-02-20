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

Implement the `/swarm` command for the `spearit-framework` full plugin — a structured AI-facilitated kick-off conversation that produces a Project Brief and meeting notes. This is the core deliverable of the Project Guidance theme.

---

## Problem Statement

**What problem does this solve?**

Users starting a new project (or pivoting an existing one) have no structured way to think through direction before jumping into work items and execution. The `/swarm` command provides a facilitated team conversation that surfaces the right questions before the user commits to a direction.

**Who is affected?**

Solo developers and small teams using the full plugin who want help clarifying direction before planning.

**Design Document:**

`project-hub/planning/design/project-guidance.md` — fully specced, approved 2026-02-17.

---

## Proposed Implementation

### Commands to Add

#### `/spearit-framework:swarm`

Standard kick-off conversation:
- Product Owner opens with a single direct question
- Clarifying questions establish: who it's for, what success looks like, rough scale
- Team assembled based on scope (2-5 roles)
- Each discipline speaks in turn (2-4 sentences max per turn)
- Conversation ends when team has enough to write a brief
- Outputs: meeting notes file + project brief file

#### `/spearit-framework:swarm --summary`

Bottom-line only — skips team discussion, produces brief directly.

### Outputs

| Output | Location |
|---|---|
| Meeting notes | `project-hub/meetings/YYYY-MM-DD-swarm-kickoff.md` |
| Project brief | `project-hub/planning/project-brief.md` |
| Starter backlog | In chat only (user creates files with `/fw-new`) |

### Team Roster (MVP)

**Always present:** Product Owner (Alex), Senior Developer (Dan)

**Conditional:**
- UX Designer (Jordan) — user-facing interface
- Security Analyst (Morgan) — auth, PII, payments, external APIs
- Data/ML Specialist (Riley) — AI, data pipelines, analytics
- Scrum Master (Sam) — medium/full complexity

---

## Requirements

### Functional Requirements

- [ ] `/swarm` opens with a single warm direct question from the Product Owner
- [ ] Clarifying questions establish audience, success criteria, and scale
- [ ] Product Owner selects appropriate discipline roster based on scope
- [ ] Each role speaks in turn with focused, scoped contributions (2-4 sentences max)
- [ ] Conversation terminates when team has answered the 5 termination criteria
- [ ] Meeting notes written to `project-hub/meetings/YYYY-MM-DD-swarm-kickoff.md`
- [ ] Project brief written to `project-hub/planning/project-brief.md`
- [ ] Starter backlog (5-10 items) output to chat
- [ ] `--summary` flag bypasses team discussion
- [ ] Warns before overwriting existing `project-brief.md`
- [ ] Degrades gracefully for trivially small projects (2-role team, 3-5 exchanges)

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

- [ ] `/spearit-framework:swarm` runs a facilitated team kick-off conversation
- [ ] `/spearit-framework:swarm --summary` produces brief without team discussion
- [ ] Meeting notes saved to correct location with correct format
- [ ] Project brief saved to correct location matching template in design doc
- [ ] Starter backlog output to chat (5-10 items)
- [ ] Existing brief overwrite warning works correctly
- [ ] `/spearit-framework:help` updated to list `/swarm`
- [ ] All tested in framework project
- [ ] Plugin version bumped and rebuilt

---

**Last Updated:** 2026-02-20

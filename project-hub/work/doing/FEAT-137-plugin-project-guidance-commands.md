# Feature: Plugin - Project Guidance Commands

**ID:** FEAT-137
**Type:** Feature
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-02-17
**Theme:** Project Guidance
**Planning Period:** v1.1

**Depends On:** FEAT-127 (Full Framework Plugin - complete)

---

## Summary

Add project guidance commands to the `spearit-framework` full plugin — proactive AI-assisted commands that help users think clearly about their project before acting. MVP uses explicit commands; passive skill interception is a future milestone.

---

## Problem Statement

**What problem does this solve?**

The current plugin executes workflow operations (create, move, track) but offers no guidance layer. Users can create and move work items without ever being prompted to think about priorities, dependencies, scope, or whether the project is healthy. Claude has the context to provide this guidance but no structured way to surface it.

**Who is affected?**

Solo developers and small teams using the full plugin who want Claude as a genuine project partner, not just a workflow executor.

**Current workaround (if any):**

Users ask Claude ad-hoc questions. Results are inconsistent because Claude doesn't know where to look or what the project structure expects.

---

## Proposed Commands (MVP)

### `/spearit-framework:status`
Project health snapshot at a glance.
- WIP counts per folder (backlog / todo / doing / done)
- Items in doing (active work)
- Items blocked or stalled
- Summary: "X items in flight, Y in backlog, last session: [date]"

### `/spearit-framework:backlog`
Guided backlog review and prioritization.
- List backlog items grouped by type or theme
- Surface items ready to pull into todo (no unmet dependencies)
- Identify stale items (created > 90 days ago, never started)
- Prompt: "Which of these should move to todo this session?"

### `/spearit-framework:plan` *(or `pre-flight`)*
Pre-implementation review before starting a work item.
- Read the work item in doing/
- Surface: what we're building, open questions, dependencies, scope risks
- Ask: "Ready to proceed, or are there questions to resolve first?"
- This is the command version of what `move → doing` already does informally

---

## Requirements

### Functional Requirements

- [ ] `status` command reads project-hub/work/ folder counts and summarizes
- [ ] `status` identifies items in doing/ and surfaces them by name
- [ ] `backlog` command lists backlog items and identifies pull-ready candidates
- [ ] `backlog` flags items with unmet dependencies (Depends On field)
- [ ] `plan` command reads a work item and presents pre-implementation review
- [ ] All commands work with framework project structure (project-hub/work/)
- [ ] Commands degrade gracefully if folders are empty

### Non-Functional Requirements

- [ ] Performance: status and backlog should complete in < 15 seconds
- [ ] Compatibility: Works alongside existing light plugin commands
- [ ] Documentation: help.md updated to list new commands

---

## Design

### Implementation Approach

Commands are markdown files in `plugins/spearit-framework/commands/`. Each command provides Claude with structured instructions for reading project state and presenting guidance.

**Key pattern:** Script-based reads (fast) + AI synthesis (guidance layer)

```
status.md   → bash script reads folder counts → Claude summarizes
backlog.md  → bash script lists backlog files → Claude analyzes + prompts
plan.md     → Claude reads specified work item → presents structured review
```

### Files to Add

- `plugins/spearit-framework/commands/status.md`
- `plugins/spearit-framework/commands/backlog.md`
- `plugins/spearit-framework/commands/plan.md`

### Files to Update

- `plugins/spearit-framework/commands/help.md` — add new commands to listing
- `plugins/spearit-framework/CHANGELOG.md` — v1.1 entry
- `plugins/spearit-framework/.claude-plugin/plugin.json` — bump to v1.1.0

---

## Future: Passive Skill Interception

The MVP uses explicit commands. The end goal is passive skills that interject automatically:

- Before `move → doing`: Claude runs pre-flight check without being asked
- On session start: Claude surfaces status without being asked
- When backlog grows stale: Claude flags it proactively

This requires the skill system to support event hooks (not available yet). Commands validate the guidance content; skills promote it to ambient behavior.

**Milestone path:**
```
v1.1  Explicit commands (this work item)
v1.2  yaml-aware commands (any project structure - FEAT-139)
v2.0  Passive skill interception (ambient guidance)
```

---

## Dependencies

**Requires:**
- FEAT-127 (Full Framework Plugin) — complete ✅

**Blocks:**
- FEAT-138 (Developer Guidance Commands) — developer guidance depends on project guidance foundation
- Future passive skill work

**Related:**
- FEAT-138 — Developer Guidance Commands
- FEAT-139 — claude-project.yaml config

---

## Acceptance Criteria

- [ ] `/spearit-framework:status` shows folder counts and active items
- [ ] `/spearit-framework:backlog` lists items and identifies pull candidates
- [ ] `/spearit-framework:plan [item-id]` presents pre-implementation review
- [ ] `/spearit-framework:help` updated to list all 8 commands
- [ ] All commands tested in framework project
- [ ] Plugin version bumped to 1.1.0 and rebuilt

---

## Notes

**Why commands before skills?**
Commands let us validate the guidance content without solving the harder "when to interject" problem. Once we know what good guidance looks like through real usage, promoting to passive skills becomes a design problem with known inputs.

**Scope boundary:**
This is project-level guidance (workflow, priorities, project health). Code-level guidance (architecture, schema review, testing approach) is FEAT-138.

---

**Last Updated:** 2026-02-17

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

Add `status` and `backlog` guidance commands to the `spearit-framework` full plugin — proactive AI-assisted commands that help users understand project health and prioritize work. MVP uses explicit commands; passive skill interception is a future milestone.

The `preflight` command (pre-implementation review) was scoped out to FEAT-148 due to distinct design and naming considerations.

---

## Problem Statement

**What problem does this solve?**

The current plugin executes workflow operations (create, move, track) but offers no guidance layer. Users can create and move work items without ever being prompted to think about priorities, dependencies, or whether the project is healthy. Claude has the context to provide this guidance but no structured way to surface it.

**Who is affected?**

Solo developers and small teams using the full plugin who want Claude as a genuine project partner, not just a workflow executor.

**Current workaround (if any):**

Users ask Claude ad-hoc questions. Results are inconsistent because Claude doesn't know where to look or what the project structure expects.

---

## Commands (MVP)

### `/spearit-framework:kanban-state`
Project health snapshot at a glance.
- WIP counts per folder (backlog / todo / doing / done / blocked)
- Items in doing (active work), with hierarchical count
- Items awaiting release (done/)
- WIP limit indicator (✅ under / ⚠ at / ❌ over)
- Version from PROJECT-STATUS.md

### `/spearit-framework:backlog`
Guided backlog review and prioritization.
- List backlog items in compact table (ID, type, impact, created, summary)
- Surface items ready to pull into todo (no unmet dependencies)
- Identify stale items (created > 90 days ago, never started)
- Subcommands: `full`, `detail <id>`, `prioritize`
- Ends with prompt pointing to `/spearit-framework:move <id> todo`

---

## Requirements

### Functional Requirements

- [x] `status` command reads project-hub/work/ folder counts and summarizes
- [x] `status` identifies items in doing/ and surfaces them by name
- [x] `status` shows WIP limit with ✅/⚠/❌ indicator
- [x] `backlog` command lists backlog items and identifies pull-ready candidates
- [x] `backlog` flags items with unmet dependencies (Depends On field)
- [x] `backlog` flags stale items (> 90 days)
- [x] All commands work with framework project structure (project-hub/work/)
- [x] Commands degrade gracefully if folders are empty

### Non-Functional Requirements

- [x] Performance: status and backlog use embedded bash scripts (fast path)
- [x] Compatibility: Works alongside existing plugin commands
- [x] Documentation: help.md updated to list new commands

---

## Design

### Implementation Approach

Commands are self-contained markdown files in `plugins/spearit-framework/commands/`. Each includes Role & Mindset, an embedded bash script for data gathering, and AI synthesis instructions.

**Pattern:** Script-based reads (fast) + AI synthesis (guidance layer)

```
kanban-state.md → bash script reads folder counts + items → Claude renders
backlog.md  → bash script lists backlog metadata → Claude analyzes + prompts
```

Both commands are ports of the `fw-status` and `fw-backlog` local commands, rewritten as self-contained plugin commands with no PowerShell dependency.

### Files Added

- `plugins/spearit-framework/commands/kanban-state.md` ✅
- `plugins/spearit-framework/commands/backlog.md` ✅

### Files Updated

- `plugins/spearit-framework/commands/help.md` — 8 commands listed ✅

### Files Remaining

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
v1.1  Explicit commands (this work item + FEAT-148)
v1.2  yaml-aware commands (any project structure - FEAT-139)
v2.0  Passive skill interception (ambient guidance)
```

---

## Dependencies

**Requires:**
- FEAT-127 (Full Framework Plugin) — complete ✅

**Blocks:**
- FEAT-138 (Developer Guidance Commands) — developer guidance depends on project guidance foundation
- FEAT-148 (Preflight Command) — depends on FEAT-137 being complete
- Future passive skill work

**Related:**
- FEAT-138 — Developer Guidance Commands
- FEAT-139 — claude-project.yaml config
- FEAT-148 — Preflight Command (scoped out from this item)

---

## Acceptance Criteria

- [x] `/spearit-framework:kanban-state` shows folder counts, WIP indicator, and active items
- [x] `/spearit-framework:backlog` lists items, identifies pull candidates, flags stale
- [ ] `/spearit-framework:help` updated — 8 commands listed (kanban-state, backlog; needs verification)
- [ ] Both commands tested in framework project
- [ ] CHANGELOG.md updated with v1.1 entry
- [ ] Plugin version bumped to 1.1.0 and rebuilt

---

## Notes

**Why commands before skills?**
Commands let us validate the guidance content without solving the harder "when to interject" problem. Once we know what good guidance looks like through real usage, promoting to passive skills becomes a design problem with known inputs.

**Scope boundary:**
This is project-level guidance (workflow, priorities, project health). Code-level guidance (architecture, schema review, testing approach) is FEAT-138. Pre-implementation review is FEAT-148.

**`preflight` scoped out:**
Originally included as `plan` (later renamed `preflight`). Moved to FEAT-148 because it has a distinct design (no script, different role/mindset) and naming required a separate decision conversation. See FEAT-148 for rationale.

---

**Last Updated:** 2026-02-21

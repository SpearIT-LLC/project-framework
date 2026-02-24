# Session History: 2026-02-23

**Date:** 2026-02-23
**Participants:** Gary Elliott, Claude Code
**Session Focus:** FEAT-137 — Plugin backlog/kanban-state command review and refinement

---

## Summary

Reviewed the `kanban-state` and `backlog` plugin commands against real output. Fixed several issues with `kanban-state` (Todo WIP indicator missing, header showing project name/version). Had a deeper design discussion about the `backlog` command's purpose, cost, and output discipline, arriving at a clear design principle: default view = mechanical table + blocked/stale, `prioritize` = AI-guided analysis.

---

## Work Completed

### FEAT-137: Plugin - Project Guidance Commands (in progress)

- Fixed `kanban-state`: Todo row now shows WIP indicator (consistent with Doing row)
- Fixed `kanban-state`: Removed project name/version from header — now shows generic "Kanban Board State" title; version line removed entirely (no reliable cross-project source of truth until FEAT-139)
- Renamed "Pull candidates" → "Ready for todo" in `backlog` (avoids confusion with Pull Requests)
- Added type-grouped format for Ready for todo section (BUG/FEAT/TECH/Other by ID prefix — deterministic, no AI inference)
- Changed "To pull an item to todo:" → "To move an item to todo:"
- Bumped plugin to `1.0.0-dev6`

---

## Decisions Made

1. **kanban-state version line removed:**
   - `PROJECT-STATUS.md` contains framework version, not project version — misleading in plugin context
   - No reliable cross-project source of truth exists until FEAT-139 (`claude-project.yaml`)
   - Decision: omit version line silently; revisit when FEAT-139 lands

2. **kanban-state header simplified:**
   - "Project Status: [Project Name]" removed — project name has no reliable source in arbitrary repos
   - Replaced with static "Kanban Board State" — describes what the command does, not the project
   - `basename "$REPO_ROOT"` considered but rejected as "unofficial"

3. **backlog command design principle established:**
   - Default view = mechanical (table + blocked + stale). Fast, consistent, no AI improvisation.
   - `prioritize` subcommand = AI-guided analysis. Higher token cost is expected and intentional.
   - Root cause of improvisation: open-ended synthesis instructions + large script output invite the AI to editorialize

4. **Product tier progression clarified:**
   - Correct order: fw- commands (most functionality) → full plugin → light plugin (least)
   - fw- commands should lead design; plugins are deliberate reductions
   - Design in framework first, validate, then port down — prevents tier divergence
   - `fw-backlog` is currently behind the plugin; will be addressed in a separate work item

---

## Files Modified

- `plugins/spearit-framework/commands/kanban-state.md` — removed version bash block, simplified header, added Todo WIP indicator to example
- `plugins/spearit-framework/commands/backlog.md` — renamed Pull candidates → Ready for todo, added type-grouping rule, updated footer text
- `plugins/spearit-framework/.claude-plugin/plugin.json` — bumped to 1.0.0-dev6

---

## Current State

### In done/ (awaiting release)
- FEAT-146: /swarm Command Implementation

### In doing/
- FEAT-137: Plugin - Project Guidance Commands (kanban-state and backlog refinement in progress; backlog output discipline fix still pending)

---

**Last Updated:** 2026-02-23

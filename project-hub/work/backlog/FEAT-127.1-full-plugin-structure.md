# Feature: Full Plugin - Structure & Core Commands

**ID:** FEAT-127.1
**Parent:** FEAT-127 (Full Framework Plugin)
**Type:** Feature
**Priority:** High
**Created:** 2026-02-16

---

## Summary

Set up the spearit-framework plugin structure and integrate the 3 core commands from spearit-framework-light (help, new, move). This establishes the foundation for adding advanced commands (session-history, roadmap).

---

## Problem Statement

The spearit-framework-light plugin provides essential workflow commands (help, new, move) but lacks advanced features. Power users graduating from the light plugin need:
- Session history tracking
- AI-guided roadmap planning
- Complete project management suite

This work item creates the plugin structure and copies the proven core commands as a foundation.

---

## Requirements

**Must Have:**
- Plugin directory: `plugins/spearit-framework/`
- Structure matches Anthropic standards:
  - `.claude-plugin/plugin.json`
  - `commands/` (help, new, move initially)
  - `skills/` (reuse from light)
  - `templates/` (reuse from light)
  - `README.md` (comprehensive edition positioning)
  - `CHANGELOG.md` (version history)
  - `LICENSE` (MIT)

**Core Commands (copied from light):**
- `commands/help.md` - Updated to list 5 commands (not 3)
- `commands/new.md` - No changes (proven)
- `commands/move.md` - No changes (optimized)

**Plugin Metadata:**
- Name: `spearit-framework`
- Namespace: `spearit-framework` (cleaner than `-light` suffix)
- Version: `1.0.0-dev1` (development)
- Description: "Complete project management suite for power users"
- Commands: 5 listed (help, new, move, session-history, roadmap)

**Skills & Templates:**
- Reuse from `spearit-framework-light/skills/`
- Reuse from `spearit-framework-light/templates/`
- No changes needed (core concepts unchanged)

---

## Proposed Solution

### Technical Approach

**1. Create Plugin Structure:**
```bash
mkdir -p plugins/spearit-framework/.claude-plugin
mkdir -p plugins/spearit-framework/commands
mkdir -p plugins/spearit-framework/skills
mkdir -p plugins/spearit-framework/templates
```

**2. Copy Core Commands:**
```bash
# Copy and update as needed
cp plugins/spearit-framework-light/commands/help.md plugins/spearit-framework/commands/
cp plugins/spearit-framework-light/commands/new.md plugins/spearit-framework/commands/
cp plugins/spearit-framework-light/commands/move.md plugins/spearit-framework/commands/
```

**3. Update help.md:**
- Change command count: 3 → 5
- Add session-history and roadmap to command table
- Mark session-history and roadmap as "coming soon" (placeholders OK)

**4. Copy Skills & Templates:**
```bash
# Reuse proven content
cp -r plugins/spearit-framework-light/skills/* plugins/spearit-framework/skills/
cp -r plugins/spearit-framework-light/templates/* plugins/spearit-framework/templates/
```

**5. Create plugin.json:**
```json
{
  "name": "spearit-framework",
  "version": "1.0.0-dev1",
  "description": "Complete project management suite for power users - all framework features as Claude Code commands",
  "author": {
    "name": "Gary Elliott / SpearIT Solutions"
  },
  "license": "MIT"
}
```

**6. Create README.md:**
- Position as "comprehensive edition"
- Distinguish from light edition (3 commands → 5 commands)
- Clear upgrade path messaging
- Feature comparison table (light vs full)

**7. Create CHANGELOG.md:**
```markdown
# v1.0.0-dev1 (Development)
- Initial structure
- Core commands integrated (help, new, move)
- Placeholders for session-history and roadmap
```

---

## Acceptance Criteria

- [ ] Directory `plugins/spearit-framework/` exists with correct structure
- [ ] `.claude-plugin/plugin.json` configured (name: spearit-framework, v1.0.0-dev1)
- [ ] Core commands copied: help.md, new.md, move.md
- [ ] help.md updated to list 5 commands (placeholders OK for session-history, roadmap)
- [ ] Skills copied from light plugin (3 skills: kanban-workflow, work-items, moving-items)
- [ ] Templates copied from light plugin (3 templates: FEAT, BUG, CHORE)
- [ ] README.md created (comprehensive edition positioning)
- [ ] CHANGELOG.md created (v1.0.0-dev1 entry)
- [ ] LICENSE file present (MIT)
- [ ] No syntax errors in any .md files
- [ ] Plugin structure validates (ready for build script extension)

---

## Implementation Notes

**Files to Create:**
- `plugins/spearit-framework/.claude-plugin/plugin.json`
- `plugins/spearit-framework/commands/help.md` (updated command list)
- `plugins/spearit-framework/commands/new.md` (copy from light)
- `plugins/spearit-framework/commands/move.md` (copy from light)
- `plugins/spearit-framework/skills/*.md` (3 files, copy from light)
- `plugins/spearit-framework/templates/*.md` (3 files, copy from light)
- `plugins/spearit-framework/README.md` (new, comprehensive)
- `plugins/spearit-framework/CHANGELOG.md` (new, development log)
- `plugins/spearit-framework/LICENSE` (MIT, copy from light)

**Help Command Updates:**
Update command table in `help.md`:
```markdown
| Command | Purpose | Status |
|---------|---------|--------|
| help | Command reference | ✅ Available |
| new | Create work items | ✅ Available |
| move | Move items through workflow | ✅ Available |
| session-history | Document work sessions | 🚧 Coming in v1.0.0 |
| roadmap | AI-guided roadmap planning | 🚧 Coming in v1.0.0 |
```

**README Positioning:**
```markdown
# SpearIT Project Framework - Comprehensive Edition

Complete project management suite for power users. Includes all 5 commands:
- Core workflow (help, new, move)
- Session tracking (session-history)
- Strategic planning (roadmap)

**Graduating from Light Edition?** This plugin includes everything from
spearit-framework-light plus advanced features. Both can be installed
simultaneously (different namespaces).
```

**Dependencies:**
- No blockers (can start immediately)
- Light plugin serves as reference implementation
- Core commands already optimized (v1.0.0 shipped Feb 13)

**Testing Strategy:**
- Verify plugin structure with Build-Plugin.ps1 (once extended)
- No functional testing yet (commands are placeholders/copies)
- Full testing in FEAT-127.4 (after all commands integrated)

---

## Related Work Items

**Parent:** FEAT-127 - Full Framework Plugin

**Siblings:**
- FEAT-127.2 - Session History Integration (depends on this)
- FEAT-127.3 - Roadmap Command (depends on this)
- FEAT-127.4 - Build & Testing (depends on 127.2 and 127.3)

**Reference Implementation:**
- FEAT-118 - Light Plugin (source for core commands)
- TASK-126 - Plugin MVP finalization (testing approach)

---

## Notes

**Why Start Here:**
- Establishes plugin identity and structure
- Reuses proven commands (no re-invention)
- Creates foundation for advanced features
- Low risk (copying working code)

**Namespace Strategy:**
- Light: `/spearit-framework-light:*` (3 commands)
- Full: `/spearit-framework:*` (5 commands)
- Cleaner namespace = upgrade incentive for power users

**Development Order:**
1. FEAT-127.1 (this) - Structure ✅
2. FEAT-127.2 - Add session-history
3. FEAT-127.3 - Add roadmap
4. FEAT-127.4 - Build & test complete plugin

---

**Last Updated:** 2026-02-16
**Status:** Backlog (ready to start)

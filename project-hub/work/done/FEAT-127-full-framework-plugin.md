# Feature: Full Framework Plugin (Parent/Epic)

**ID:** FEAT-127
**Type:** Feature (Parent/Epic)
**Priority:** High
**Created:** 2026-02-13
**Decomposed:** 2026-02-16
**Completed:** 2026-02-17

---

## Summary

Create comprehensive edition of SpearIT Project Framework plugin (spearit-framework) that builds on the lightweight edition by adding advanced features for power users. Starts with 3 core commands from light plugin (help, new, move) and adds session-history and roadmap commands to provide complete project management capabilities.

**This is a parent/epic work item.** Implementation is decomposed into 4 child work items for incremental delivery.

---

## Problem Statement

The lightweight plugin (spearit-framework-light) successfully delivers core workflow commands for quick onboarding, but power users need access to advanced framework features including session documentation and AI-guided roadmap creation. These features were intentionally deferred from the light edition to maintain focus and simplicity.

**Context:**
- Light plugin launching with 3 commands (help, new, move)
- Session-history and roadmap commands already exist in framework
- Users graduating from light edition need upgrade path
- Power users want complete framework feature set as Claude Code commands

**Impact:**
- Power users get complete project management suite
- Clear upgrade path from light to full edition
- Both plugins can coexist (different namespaces)
- Tests light plugin's `new` command (dogfooding)
- Establishes pattern for future plugin editions

---

## Requirements

**Must Have:**
- Plugin structure in `plugins/spearit-framework/`
- All 5 commands functional:
  - **help** - Command reference (from light)
  - **new** - Create work items with auto-ID (from light)
  - **move** - Move items through workflow (from light)
  - **session-history** - Document work sessions (already preserved)
  - **roadmap** - AI-guided roadmap creation (adapt from fw-roadmap)
- Plugin namespace: `spearit-framework` (commands use `/spearit-framework:*`)
- README distinguishes it from light edition
- Can be installed alongside light plugin (no conflicts)
- Build script supports both plugins
- Skills documentation (reuse or adapt from light)

**Out of Scope (for v1.0):**
- **status** command (defer to v1.1+)
- **wip** command (defer to v1.1+)
- **backlog** command (defer to v1.1+)
- **topic-index** command (defer to v1.1+)
- Marketplace submission (light plugin ships first)
- Comprehensive testing (basic validation only for placeholder)

---

## Proposed Solution

**Plugin Architecture:**
```
plugins/spearit-framework/
├── .claude-plugin/
│   └── plugin.json (name: "spearit-framework", namespace: spearit-framework)
├── commands/
│   ├── help.md (copy from light, update command list)
│   ├── new.md (copy from light, no changes)
│   ├── move.md (copy from light, no changes)
│   ├── session-history.md (already exists, preserved from light)
│   └── roadmap.md (adapt from .claude/commands/fw-roadmap.md)
├── skills/
│   ├── kanban-workflow.md (reuse from light)
│   ├── work-items.md (reuse from light)
│   └── moving-items.md (reuse from light)
├── templates/
│   ├── FEAT-template.md (copy from light)
│   ├── BUG-template.md (copy from light)
│   ├── CHORE-template.md (copy from light)
│   └── session-history-template.md (already exists, preserved from light)
├── README.md (comprehensive edition positioning)
└── LICENSE (MIT, same as light)
```

**Technical Approach:**
1. **Foundation:** Copy core structure from spearit-framework-light
2. **Add preserved:** Session-history command and template already exist
3. **Adapt roadmap:** Use `.claude/commands/fw-roadmap.md` as starting point
4. **Update help:** List all 5 commands (not just 3)
5. **Build support:** Extend Build-Plugin.ps1 to handle multiple plugins
6. **Documentation:** Clear value proposition vs light edition

**Constraints:**
- Ships after light plugin (lower priority)
- Uses same build and testing infrastructure
- Must coexist with light plugin (different namespace)
- Placeholder work item (planning only, not immediate implementation)

**Value Proposition:**
"Complete project management suite for power users - all framework features as Claude Code commands. Graduate from lightweight edition when ready for advanced capabilities."

---

## Child Work Items

This parent work item is decomposed into 4 incremental deliverables:

1. **FEAT-127.1** - Structure & Core Commands
   - Status: Backlog
   - Duration: 1 session
   - Creates plugin structure, copies help/new/move from light plugin

2. **FEAT-127.2** - Session History Integration
   - Status: Backlog (blocked by 127.1)
   - Duration: 1 session
   - Verifies and integrates preserved session-history command

3. **FEAT-127.3** - Roadmap Command
   - Status: Backlog (blocked by 127.1)
   - Duration: 1-2 sessions
   - Adapts fw-roadmap command for plugin use

4. **FEAT-127.4** - Build & Testing
   - Status: Backlog (blocked by 127.2, 127.3)
   - Duration: 1 session
   - Extends build script, tests all 5 commands, verifies coexistence

**Total Estimated Duration:** 4-6 sessions (vs 3-5 for monolithic approach)

---

## Parent-Level Acceptance Criteria

**Epic complete when:**
- [x] All 4 child work items complete (127.1, 127.2, 127.3, 127.4)
- [x] Plugin v1.0.0 built and packaged
- [x] All 5 commands tested and working
- [x] Both plugins (light + full) can coexist
- [x] Documentation complete (README, CHANGELOG)
- [x] Ready for eventual marketplace submission (separate decision)

---

## Implementation Notes

**Starting Point:**
- Session-history: `plugins/spearit-framework/commands/session-history.md` (already exists)
- Session template: `plugins/spearit-framework/templates/session-history-template.md` (already exists)
- Roadmap source: `.claude/commands/fw-roadmap.md` (adapt from framework commands)
- Core commands: Copy from `plugins/spearit-framework-light/`

**Build Script Updates:**
- Build-Plugin.ps1 currently builds spearit-framework-light
- Extend to support `-Plugin spearit-framework` option
- Output to `distrib/plugin-full/spearit-framework-vX.Y.Z.zip`
- Support building both plugins (or auto-discover all plugins/)

**Namespace Strategy:**
- Light: `/spearit-framework-light:*` (3 commands)
- Full: `/spearit-framework:*` (5+ commands)
- No conflicts - users can install both if desired
- Full edition has cleaner namespace (upgrade incentive)

**Dependencies:**
- Blocked by: None (can start planning anytime)
- Enables: Full framework feature adoption via Claude Code
- Related: FEAT-118 (light plugin), TASK-126 (light MVP finalization)

**Testing Strategy:**
- Basic validation only (placeholder/planning work item)
- Full testing when prioritized for implementation
- Use same testing infrastructure as light plugin
- Test both plugins installed simultaneously

---

## Questions / Open Issues

1. **Skills documentation:** Reuse light edition skills, or expand with full framework context?
   - Recommendation: Start with reuse, expand in v1.1+ if needed

2. **Roadmap command scope:** Full fw-roadmap feature set, or simplified version?
   - Recommendation: Adapt existing fw-roadmap.md, simplify if too complex

3. **Build automation:** Auto-discover all plugins/ subdirectories, or explicit list?
   - **Decision:** Explicit plugin parameter required (prevents accidental changes)

4. **Version strategy:** Independent versioning (v1.0 for both), or coupled?
   - Recommendation: Independent (light ships first as v1.0, full follows as v1.0)

5. **Marketplace submission:** Submit both at once, or light first?
   - Decided: Light first, full follows after light validation

---

**Last Updated:** 2026-02-16 (Decomposed into child work items)
**Status:** Todo (Parent/Epic - track via children)

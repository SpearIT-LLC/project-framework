# Feature: Full Plugin - Roadmap Command

**ID:** FEAT-127.3
**Parent:** FEAT-127 (Full Framework Plugin)
**Type:** Feature
**Priority:** High
**Created:** 2026-02-16
**Completed:** 2026-02-16
**Depends On:** FEAT-127.1

---

## Summary

Adapt the fw-roadmap command from `.claude/commands/fw-roadmap.md` for use in the spearit-framework plugin. This provides AI-guided roadmap creation and planning capabilities to power users.

---

## Problem Statement

Power users need strategic planning capabilities:
- AI-guided roadmap creation
- Theme-based work organization
- Milestone planning
- Work item prioritization
- Long-term vision alignment

The fw-roadmap command exists as a framework command (`.claude/commands/fw-roadmap.md`) but needs adaptation for plugin context.

---

## Requirements

**Must Have:**
- Roadmap command operational in plugin
- Creates `ROADMAP.md` in project root
- AI-guided conversation for roadmap creation
- Theme extraction and organization
- Work item suggestions
- Milestone structuring

**Command Behavior:**
- Conversational planning session
- Reads existing work items (backlog, todo) for context
- Proposes themes and structure
- Generates ROADMAP.md
- Git adds the file automatically

**Adaptation Needs:**
- Remove framework-specific assumptions
- Work in any project (with or without project-hub/)
- Simpler output format (focus on essentials)
- Clear instructions for standalone use

**Out of Scope:**
- Roadmap updates/maintenance (defer to v1.1)
- Integration with sprint planning (FEAT-092 not implemented)
- Quarterly planning features (future)

---

## Proposed Solution

### Technical Approach

**1. Copy Source Command:**
```bash
cp .claude/commands/fw-roadmap.md plugins/spearit-framework/commands/roadmap.md
```

**2. Simplify for Plugin Context:**

**Remove:**
- References to other framework commands
- Assumptions about project-hub/ structure
- Complex sprint/quarter planning
- Framework-specific terminology

**Keep:**
- AI-guided conversation flow
- Theme identification and organization
- Work item context reading
- Markdown roadmap generation
- Git integration

**3. Update Command Instructions:**

**Focus on:**
```markdown
# Purpose
Guide user through roadmap creation via AI conversation.

# Process
1. Ask about project vision and goals
2. Review existing work items (if any)
3. Propose themes to organize work
4. Suggest milestones and priorities
5. Generate ROADMAP.md

# Output
Create ROADMAP.md with:
- Project vision
- Themes (3-5 major areas)
- Milestones (time-based or feature-based)
- Work item mapping (which items support which themes)
```

**4. Test Command:**
- Create test roadmap in framework project
- Verify conversation flow
- Verify ROADMAP.md generated correctly
- Verify themes make sense
- Verify git add works

**5. Update Help & Changelog:**
```markdown
| roadmap | AI-guided roadmap planning | ✅ Available |
```

```markdown
# v1.0.0-dev3 (Development)
- Added roadmap command (strategic planning)
```

---

## Acceptance Criteria

- [x] Roadmap command file created at `plugins/spearit-framework/commands/roadmap.md`
- [x] Command adapted from fw-roadmap.md
- [x] Simplified for standalone plugin use (no framework assumptions)
- [x] Command executes without errors
- [x] Conversational planning flow works
- [x] Reads existing work items for context
- [x] Proposes themes and structure
- [x] Generates ROADMAP.md in project root
- [x] Git adds file automatically
- [x] Help command updated (roadmap marked available)
- [x] CHANGELOG.md updated (v1.0.0-dev3 entry)
- [x] Works in projects without project-hub/ structure

---

## Implementation Notes

**Source File:**
- `.claude/commands/fw-roadmap.md` (framework command)

**Adaptation Strategy:**

**Before (Framework Command):**
```markdown
Read work items from project-hub/work/backlog/
Read work items from project-hub/work/todo/
Reference framework.yaml for project type
Use framework terminology (themes, sprints, etc.)
```

**After (Plugin Command):**
```markdown
Check if project-hub/work/ exists
  - If yes: Read from backlog/, todo/
  - If no: Start from scratch
Simple conversational planning
Generic project management terminology
Focus on roadmap document creation
```

**Command Simplification:**
- Remove sprint planning references (FEAT-092 not implemented)
- Remove quarterly milestone assumptions
- Remove framework.yaml dependencies
- Keep AI-guided theme extraction
- Keep work item context reading
- Keep markdown generation

**Testing Approach:**
1. Bump version: 1.0.0-dev2 → 1.0.0-dev3
2. Build plugin with roadmap command
3. Test in framework project (has project-hub/)
4. Test in vanilla project (no project-hub/)
5. Verify both scenarios work

**Expected Workflow:**
```
User: /spearit-framework:roadmap
Claude: Let's create your project roadmap. What's your project's vision?
User: [describes vision]
Claude: What are your major goals?
User: [lists goals]
Claude: [Reads backlog/todo if available]
Claude: I see work items in these areas... [proposes themes]
User: [confirms or adjusts themes]
Claude: [Generates ROADMAP.md with themes, milestones, work item mapping]
✅ Roadmap created: ROADMAP.md
```

**Plugin Version Strategy:**
- dev1: Structure + core commands (FEAT-127.1)
- dev2: + session-history (FEAT-127.2)
- **dev3: + roadmap (this work item)**
- 1.0.0: Final build (FEAT-127.4)

**Dependencies:**
- Requires: FEAT-127.1 (plugin structure)
- Parallel with: FEAT-127.2 (session-history independent)
- Blocks: FEAT-127.4 (final build needs all commands)

---

## Related Work Items

**Parent:** FEAT-127 - Full Framework Plugin

**Siblings:**
- FEAT-127.1 - Structure & Core Commands (prerequisite)
- FEAT-127.2 - Session History (parallel)
- FEAT-127.4 - Build & Testing (blocked until this + 127.2 complete)

**Source Command:**
- `.claude/commands/fw-roadmap.md` (framework skill)
- FEAT-091 created original roadmap command

**Future Enhancements:**
- FEAT-092: Sprint Support (roadmap ↔ sprint integration)
- Roadmap updates/maintenance commands
- Quarterly planning features

---

## Notes

**Why This Command Matters:**
- Strategic planning is power user feature
- AI-guided planning reduces blank page syndrome
- Theme organization clarifies project structure
- Milestone planning drives prioritization

**Adaptation Challenge:**
The fw-roadmap command assumes framework structure. Plugin version must work in ANY project:
- With or without project-hub/
- With or without framework.yaml
- With or without existing work items

**Risk Assessment:** MEDIUM
- Requires adaptation (not just copying)
- Must test in multiple project types
- Conversation flow needs refinement
- More complex than session-history

**Estimated Effort:** 1-2 sessions
- 1 session if adaptation straightforward
- 2 sessions if conversation flow needs iteration

---

**Last Updated:** 2026-02-16
**Status:** Backlog (blocked by FEAT-127.1)

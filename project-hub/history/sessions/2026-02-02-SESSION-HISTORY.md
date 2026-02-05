# Session History: 2026-02-02

**Date:** 2026-02-02
**Participants:** Gary Elliott, Claude Code
**Session Focus:** FEAT-095 MVP fixes and documentation structure planning
**Role:** Senior Architect

---

## Summary

Resolved project definition SsoT question, identified documentation structure issues, created work items for splitting workflow-guide.md, and fixed all three MVP issues in /fw-roadmap skill (file location, time expectations, feature-based format support).

---

## Work Completed

### FEAT-095: AI-Guided Roadmap Questionnaire

**MVP v1.1 Improvements:**
- ✅ Fixed file location bug - now generates at `docs/project/ROADMAP.md` instead of root
- ✅ Added time expectation notice (15-25 minutes upfront)
- ✅ Added feature-based roadmap format support (default, alongside theme-based OKR style)
- ✅ Added vision integration - checks README.md before re-asking foundational questions
- ✅ Added backlog scanning - groups work items by feature area to inform roadmap
- ✅ Synced changes to template version

**Status:** MVP v1.1 ready for testing (all recommended improvements implemented)

---

## Decisions Made

1. **Project Definition SsoT Pattern:**
   - **Decision:** README.md#what-is-this is the single source of truth for prose project definition
   - **Rationale:** framework.yaml contains minimal structured metadata; README.md is natural location for both humans and AI to find project definition
   - **Pattern:** Use `sources.project-definition: README.md#what-is-this` in framework.yaml to make relationship explicit
   - **Follow-up:** TECH-101 created to document this pattern formally

2. **Documentation Structure Refactoring:**
   - **Decision:** Split workflow-guide.md into three focused documents (workflow-guide.md, project-guide.md, developer-guide.md)
   - **Rationale:** Current workflow-guide.md mixes three distinct concerns (workflow process, project guidance, developer standards) and is getting too long
   - **Follow-up:** TECH-100 (parent), FEAT-102 (project-guide), FEAT-103 (developer-guide) created

3. **Feature-Based Roadmaps as Default:**
   - **Decision:** /fw-roadmap should default to feature-based timeline format (Q1: F1, F2; Q2: F3, F4) rather than theme-based OKR style
   - **Rationale:** User mental model expects "what gets built when" not strategic themes; aligns better with typical roadmap expectations
   - **Implementation:** Dual format support added, feature-based recommended

---

## Files Modified

- `.claude/commands/fw-roadmap.md` - Fixed MVP issues (file location, time expectations, dual format support, vision integration)
- `templates/starter/.claude/commands/fw-roadmap.md` - Synced with root version
- `framework/project-hub/work/doing/FEAT-095-ai-roadmap-questionnaire.md` - Documented MVP v1.1 fixes and status update
- `framework/project-hub/work/doing/FEAT-095-framework-roadmap-ideas.md` - Updated with workflow patterns and developer patterns notes

## Files Created

- `framework/project-hub/work/backlog/TECH-100-split-workflow-guide.md` - Parent issue for documentation restructure
- `framework/project-hub/work/backlog/TECH-101-project-definition-ssot-pattern.md` - Document where project definitions should live
- `framework/project-hub/work/backlog/FEAT-102-create-project-guide.md` - Create dedicated project-level guidance document
- `framework/project-hub/work/backlog/FEAT-103-create-developer-guide.md` - Create dedicated developer-focused guidance document

---

## Context & Insights

### Project Definition Discovery
Discussion about official SsoT for project definition led to identifying that framework.yaml and README.md serve complementary purposes (structured metadata vs prose definition). This surfaced a need to document the pattern explicitly.

### Documentation Structure Issue
Identifying where to document the project definition pattern revealed that workflow-guide.md has grown to cover three distinct concerns (workflow, project guidance, developer guidance), leading to documentation restructure work items.

### Roadmap Format Insight
Testing revealed users expect roadmaps to show "what gets built when" (feature timeline) rather than abstract strategic themes. The fix adds dual format support with feature-based as default.

### FEAT-095 Dependencies
Discussion reinforced that roadmap planning (FEAT-095) naturally depends on project definition (FEAT-087) and project organization (FEAT-089) being complete first - vision questions should happen once during project definition, not every roadmap review.

---

## Current State

### In doing/
- FEAT-095: AI-Guided Roadmap Questionnaire (MVP v1.1 ready for testing)
- FEAT-095-framework-roadmap-ideas.md (complementary sketch document)

### In todo/
- FEAT-092: Sprint Support
- FEAT-093: Planning Period Archival
- TECH-070: Issue Response Process
- TECH-070.1: Validate Issue Response Process

### New in backlog/
- TECH-100: Split workflow-guide.md into focused documents
- TECH-101: Document project definition SsoT pattern
- FEAT-102: Create project-guide.md
- FEAT-103: Create developer-guide.md

---

## Next Steps

1. Test updated /fw-roadmap skill on framework project
2. Consider addressing TECH-101 (quick fix, independent of TECH-100)
3. Continue FEAT-095 work based on testing results

---

**Last Updated:** 2026-02-02

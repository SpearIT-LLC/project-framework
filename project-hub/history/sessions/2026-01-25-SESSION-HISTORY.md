# Session History: 2026-01-25

**Date:** 2026-01-25
**Participants:** Gary Elliott, Claude Code
**Session Focus:** TECH-076 - Consolidate Workflow Transition Checklists
**Role:** senior-claude

---

## Summary

Completed TECH-076, which consolidated workflow transition checklists by making `fw-move.md` reference `workflow-guide.md` as the single source of truth instead of duplicating (and drifting from) the checklists. Also enhanced `workflow-guide.md` with additional checklist items discovered during review.

---

## Work Completed

### TECH-076: Consolidate Workflow Transition Checklists

- Reviewed existing checklists in workflow-guide.md vs fw-move.md, identified drift
- Revised scope from "add enforcement prompts" to "eliminate duplication"
- Enhanced workflow-guide.md per-transition checklists:
  - → backlog: Added commit step after creation
  - → todo: Added `.limit` check, `git mv`
  - → doing: Added `Depends On` check, emphasized "STOP" language
  - → done: Added `git mv`, post-move actions (session history + commit)
  - → releases: Added full release process section
- Updated fw-move.md to reference workflow-guide.md instead of duplicating
- Synced changes to templates/standard/

---

## Decisions Made

1. **Reference vs Duplicate:**
   - Decided fw-move.md should reference workflow-guide.md rather than duplicate checklists
   - Rationale: Single source of truth prevents drift; minor performance cost is acceptable

2. **WIP Limits on Any Folder:**
   - Any folder can have a `.limit` file, not just `doing/`
   - Checklist now says "If `.limit` exists, check WIP limit"

3. **Pre-Implementation Review Trigger:**
   - Triggers on move to doing/ OR when user requests review
   - Not just on initial move

---

## Files Modified

- `framework/docs/collaboration/workflow-guide.md` - Enhanced per-transition checklists, updated Last Updated date
- `.claude/commands/fw-move.md` - Replaced duplicated checklists with reference to workflow-guide.md
- `templates/standard/.claude/commands/fw-move.md` - Synced with framework version
- `framework/thoughts/work/done/TECH-076-enforcement-prompts.md` - Updated scope, acceptance criteria, marked done

## Files Moved

- `framework/thoughts/work/todo/TECH-076-enforcement-prompts.md` → `framework/thoughts/work/doing/` → `framework/thoughts/work/done/`

---

## Current State

### In done/ (awaiting release)
- TECH-076: Consolidate Workflow Transition Checklists

### In doing/
- (empty)

---

**Last Updated:** 2026-01-25

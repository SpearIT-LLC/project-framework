# Tech Debt: Consolidate Workflow Transition Checklists

**ID:** TECH-076
**Type:** Tech Debt
**Priority:** High
**Version Impact:** PATCH
**Created:** 2026-01-23
**Status:** Done

---

## Summary

Eliminate checklist duplication between fw-move.md and workflow-guide.md by making fw-move.md reference the single source of truth.

---

## Problem Statement

**What is the current state?**

- `workflow-guide.md` has comprehensive per-transition checklists (lines 384-425)
- `fw-move.md` duplicates an abbreviated version of these checklists
- The abbreviated version is missing key steps (pre-implementation review, dependency checks)
- Testing on a project without fw-move.md showed AI bypassing workflow rules

**Why is this a problem?**

- Duplication leads to drift (fw-move.md fell behind workflow-guide.md)
- AI using fw-move.md doesn't see the complete checklist
- Violates single source of truth principle
- Maintenance burden to keep both in sync

**What is the desired state?**

- `workflow-guide.md` = single source of truth for transition checklists
- `fw-move.md` = references workflow-guide.md instead of duplicating
- No drift possible because there's only one copy

---

## Proposed Solution

### 1. Review workflow-guide.md checklists for completeness

Ensure these items are present (add if missing):

**→ doing checklist:**
- [ ] Check `Depends On` field - all dependencies must be in done/
- [ ] Explicit "**STOP - Wait for user approval before proceeding**" emphasis

**→ done checklist:**
- [ ] Use `git mv` (not regular mv) to preserve history

### 2. Update fw-move.md to reference instead of duplicate

Replace the "Per-Transition Checklists" section with:

```markdown
## Per-Transition Checklists

Before executing any move, read and follow the appropriate checklist at:
`framework/docs/collaboration/workflow-guide.md#per-transition-checklists`

This ensures you follow the complete, authoritative checklist rather than an abbreviated version.
```

Keep the transition validity matrix in fw-move.md (quick lookup, rarely changes).

**Files Affected:**
- `framework/docs/collaboration/workflow-guide.md` - Review/enhance checklists
- `.claude/commands/fw-move.md` - Remove duplicate checklists, add reference
- `templates/standard/.claude/commands/fw-move.md` - Sync changes

---

## Acceptance Criteria

- [x] workflow-guide.md → backlog checklist includes commit step
- [x] workflow-guide.md → todo checklist includes `.limit` check
- [x] workflow-guide.md → doing checklist includes dependency check (`Depends On`)
- [x] workflow-guide.md → doing checklist has explicit "STOP" emphasis
- [x] workflow-guide.md → done checklist includes `git mv` requirement
- [x] workflow-guide.md → done checklist includes post-move actions (session history, commit)
- [x] workflow-guide.md → releases checklist includes full release process
- [x] All transitions specify `git mv` for moves
- [x] fw-move.md per-transition checklists replaced with reference to workflow-guide.md
- [x] fw-move.md transition validity matrix retained
- [x] Template synced to templates/standard/

---

## Notes

Original scope was to add enforcement prompts to workflow-guide.md. Review revealed workflow-guide.md already has comprehensive checklists - the real gap was fw-move.md duplicating (incompletely) instead of referencing.

This refactoring ensures future updates only need to happen in one place.

---

## Related

- FEAT-025: Manual Setup Validation (source of finding)
- TECH-068: Hotfix/emergency workflow (exception to normal flow)
- TECH-075: Spike workflow contradiction

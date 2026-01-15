# TECH-056: Consolidate Workflow Documentation

**ID:** TECH-056
**Type:** Technical
**Priority:** Medium
**Status:** Doing
**Created:** 2026-01-14
**Version Impact:** PATCH
**Related:** DOC-054, FEAT-057

---

## Summary

Consolidate duplicate workflow documentation by:
1. Deleting `kanban-workflow.md` (content already in workflow-guide.md)
2. Clarifying the relationship between `workflow-guide.md` and `version-control-workflow.md`
3. Removing unnecessary references across ~42 files

---

## Problem Statement

Three documents cover overlapping workflow topics:

| Document | Location | Lines | Purpose |
|----------|----------|-------|---------|
| `workflow-guide.md` | `collaboration/` | ~1470 | Comprehensive contributor guide |
| `kanban-workflow.md` | `process/` | ~420 | Work item lifecycle (DUPLICATE) |
| `version-control-workflow.md` | `process/` | ~505 | Git & release process |

**Issues:**
- kanban-workflow.md duplicates ~40% of workflow-guide.md content
- 42 files reference kanban-workflow.md
- Many references are unnecessary (work items don't need workflow links)
- Unclear document hierarchy

---

## Analysis

### Document Purposes (After Consolidation)

| Document | Purpose | Keep? |
|----------|---------|-------|
| `workflow-guide.md` | **Master workflow document** - Development phases, kanban workflow, work item management, documentation standards, AI collaboration | YES |
| `version-control-workflow.md` | **Git & release specifics** - Branching, commits, release checklist, hotfix process | YES |
| `kanban-workflow.md` | Duplicate of content in workflow-guide.md | DELETE |

### Content Already Merged to workflow-guide.md
- ✅ Spike flow (added 2026-01-15)
- ✅ Roadmap integration examples (added 2026-01-15)
- ✅ Folder structure, WIP limits, work item naming
- ✅ State transitions, release triggers

### Content NOT Being Kept
- ❌ PowerShell WIP limit check script (doesn't exist, was placeholder)

---

## Implementation Plan

### Phase 1: Update workflow-guide.md References Section

**File:** `framework/docs/collaboration/workflow-guide.md`

Remove kanban-workflow.md from References section (line ~1417).

### Phase 2: Update version-control-workflow.md

**File:** `framework/docs/process/version-control-workflow.md`

Change references from kanban-workflow.md to workflow-guide.md:
- Line 13: Update workflow integration link
- Line 493: Update Related Documents section

### Phase 3: Update Active Documentation (Essential References)

These files legitimately need a workflow reference:

| File | Action |
|------|--------|
| `framework/INDEX.md` | Update link to workflow-guide.md |
| `framework/docs/PROJECT-STRUCTURE-STANDARD.md` | Update link to workflow-guide.md |
| `framework/thoughts/work/README.md` | Update link to workflow-guide.md |
| `examples/hello-world/thoughts/work/README.md` | Update link to workflow-guide.md |

### Phase 4: Update Templates

| Template | Action |
|----------|--------|
| `framework/templates/documentation/CLAUDE-TEMPLATE.md` | Update workflow reference |
| `framework/templates/documentation/INDEX-TEMPLATE.md` | Update workflow reference |
| `framework/templates/documentation/README-TEMPLATE.md` | Update workflow reference |
| `templates/standard/CLAUDE.md` | Update workflow reference |
| `templates/standard/INDEX.md` | Update workflow reference |
| `templates/standard/README.md` | Update workflow reference |
| `templates/STRUCTURE.md` | Update structure listing |
| `templates/NEW-PROJECT-CHECKLIST.md` | Update checklist reference |

### Phase 5: Update Backlog Work Items

These work items reference kanban-workflow.md because they plan to modify it.
Update to reference workflow-guide.md instead:

| Work Item | Action |
|-----------|--------|
| `DOC-054-workflow-state-transition-rules.md` | Update target file references |
| `TECH-041-supporting-files-naming-policy.md` | Update target file references |
| `TECH-044-document-work-item-creation-policy.md` | Update target file references |
| `TECH-046-work-item-id-discovery-policy.md` | Update target file references |
| `TECH-048-remove-team-references-from-docs.md` | Update target file references |
| `TECH-055-work-item-move-validation-script.md` | Update target file references |
| `FEAT-047-small-team-id-collision-support.md` | Update target file references |

### Phase 6: Remove Unnecessary References

These files have workflow references that aren't needed:

| File | Action |
|------|--------|
| `feature-017-backlog-review-command.md` | Remove Related Documents link |
| `feature-018-claude-command-framework.md` | Remove Related Documents link |
| `FEAT-025-ALIGNMENT-ANALYSIS.md` | Keep (documents alignment issue) |
| `FEAT-025-brainstorming.md` | Keep (documents structure) |
| `framework/thoughts/research/adr/001-ai-workflow-checkpoint-policy.md` | Update reference |
| `framework/thoughts/external-references/version-strategy.md` | Update reference |
| `framework/thoughts/retrospectives/2025-12-20-workflow-enforcement-retrospective.md` | Keep as-is (historical) |

### Phase 7: Leave Historical Records As-Is

Do NOT modify these (they document what happened at that time):

- `framework/CHANGELOG.md` - Historical record
- `framework/thoughts/history/sessions/*.md` - Session histories
- `framework/thoughts/history/releases/*/*.md` - Archived work items

### Phase 8: Delete kanban-workflow.md

```bash
git rm framework/docs/process/kanban-workflow.md
```

### Phase 9: Verify

```bash
# Should return 0 results (excluding history/ and CHANGELOG)
grep -r "kanban-workflow" --include="*.md" | grep -v "history/" | grep -v "CHANGELOG"
```

---

## Files Summary

**Delete (1):**
- `framework/docs/process/kanban-workflow.md`

**Update - Essential References (4):**
- `framework/INDEX.md`
- `framework/docs/PROJECT-STRUCTURE-STANDARD.md`
- `framework/thoughts/work/README.md`
- `examples/hello-world/thoughts/work/README.md`

**Update - Related Documents (3):**
- `framework/docs/collaboration/workflow-guide.md`
- `framework/docs/process/version-control-workflow.md`
- `framework/thoughts/research/adr/001-ai-workflow-checkpoint-policy.md`

**Update - Templates (8):**
- `framework/templates/documentation/CLAUDE-TEMPLATE.md`
- `framework/templates/documentation/INDEX-TEMPLATE.md`
- `framework/templates/documentation/README-TEMPLATE.md`
- `templates/standard/CLAUDE.md`
- `templates/standard/INDEX.md`
- `templates/standard/README.md`
- `templates/STRUCTURE.md`
- `templates/NEW-PROJECT-CHECKLIST.md`

**Update - Backlog Work Items (7):**
- `DOC-054-workflow-state-transition-rules.md`
- `TECH-041-supporting-files-naming-policy.md`
- `TECH-044-document-work-item-creation-policy.md`
- `TECH-046-work-item-id-discovery-policy.md`
- `TECH-048-remove-team-references-from-docs.md`
- `TECH-055-work-item-move-validation-script.md`
- `FEAT-047-small-team-id-collision-support.md`

**Update - Remove Unnecessary Links (2):**
- `feature-017-backlog-review-command.md`
- `feature-018-claude-command-framework.md`

**Update - Other (1):**
- `framework/thoughts/external-references/version-strategy.md`

**Leave As-Is - Historical (~14):**
- `framework/CHANGELOG.md`
- `framework/thoughts/history/sessions/*.md`
- `framework/thoughts/history/releases/*/*.md`
- `framework/thoughts/retrospectives/*.md`

**Total files to modify: ~25**

---

## Completion Criteria

- [ ] kanban-workflow.md deleted
- [ ] workflow-guide.md has no reference to kanban-workflow.md
- [ ] version-control-workflow.md references workflow-guide.md
- [ ] All templates updated
- [ ] All backlog work items updated
- [ ] Unnecessary references removed
- [ ] Grep verification passes (no active references remain)
- [ ] Changes committed

---

## CHANGELOG Notes

### Changed
- Consolidated workflow documentation: deleted `kanban-workflow.md`, content now in `workflow-guide.md`
- Updated ~25 files to reference `workflow-guide.md` instead of `kanban-workflow.md`

---

**Last Updated:** 2026-01-15

# TECH-056: Consolidate Workflow Documentation

**ID:** TECH-056
**Type:** Technical
**Priority:** Medium
**Status:** Backlog
**Created:** 2026-01-14
**Version Impact:** PATCH
**Related:** DOC-054 (state transition rules - should be done first or together)

---

## Summary

Consolidate duplicate workflow documentation by merging `kanban-workflow.md` into `workflow-guide.md` and updating all references.

---

## Problem Statement

Two documents define the same workflow with ~40% overlap:

| Document | Location | Lines |
|----------|----------|-------|
| `workflow-guide.md` | `framework/docs/collaboration/` | ~1420 |
| `kanban-workflow.md` | `framework/docs/process/` | ~420 |

**Issues:**
- Duplicate content creates maintenance burden
- Unclear which is authoritative
- Risk of drift between documents
- 40 files reference `kanban-workflow.md`

---

## Analysis

### Content in Both (Overlap)
- Folder structure (`thoughts/work/backlog/todo/doing/done/`)
- WIP limits and `.limit` files
- Work item naming (`FEAT-NNN`, `BUGFIX-NNN`, etc.)
- State transitions (backlog → todo → doing → done → archive)
- Release triggers
- Work item templates and metadata

### Unique to workflow-guide.md
- Development phases (Research, Define, Plan, Code, Commit/Release)
- Research phase depth by framework level
- Documentation standards
- Git workflow (branch strategy, commit messages, PRs)
- Version calculation (Step 9)
- ADRs (Architecture Decision Records)
- AI collaboration practices (Step 7.5, mode clarity)
- Grouped releases

### Unique to kanban-workflow.md
- PowerShell WIP limit check script
- Roadmap.md integration examples
- Spike flow (distinct from features)

---

## Decision

**Keep:** `workflow-guide.md` (in `collaboration/`)
**Delete:** `kanban-workflow.md` (in `process/`)

**Rationale:**
- workflow-guide.md is comprehensive and already contains kanban content
- `collaboration/` is the appropriate location for contributor workflows
- Unique kanban content can be merged or moved to appropriate locations

---

## Implementation Tasks

### Phase 1: Merge Unique Content
- [ ] Review kanban-workflow.md for any content not in workflow-guide.md
- [ ] Add PowerShell WIP limit script to `framework/tools/` (if worth keeping)
- [ ] Ensure spike flow is documented in workflow-guide.md
- [ ] Add roadmap.md integration examples if missing

### Phase 2: Update References (40 files)
- [ ] Update all references from `kanban-workflow.md` to `workflow-guide.md`
- [ ] Verify paths are correct (some may be relative)
- [ ] Files to update include:
  - Templates (CLAUDE-TEMPLATE.md, INDEX-TEMPLATE.md, etc.)
  - Work items in backlog/todo
  - Session histories
  - ADRs and retrospectives
  - Examples and other docs

### Phase 3: Delete and Verify
- [ ] Delete `framework/docs/process/kanban-workflow.md`
- [ ] Run grep to verify no remaining references
- [ ] Test any documentation links

---

## Files Affected

**Delete:**
- `framework/docs/process/kanban-workflow.md`

**Modify:**
- `framework/docs/collaboration/workflow-guide.md` (merge unique content)
- ~40 files with references (see grep results)

**Create (optional):**
- `framework/tools/Test-WipLimit.ps1` (if PowerShell script is worth preserving)

---

## Testing

- [ ] Grep for `kanban-workflow` returns 0 results after completion
- [ ] All documentation links resolve correctly
- [ ] workflow-guide.md contains all necessary workflow information

---

## CHANGELOG Notes

### Changed
- Consolidated workflow documentation into single file (`workflow-guide.md`)
- Removed duplicate `kanban-workflow.md`

---

**Last Updated:** 2026-01-14

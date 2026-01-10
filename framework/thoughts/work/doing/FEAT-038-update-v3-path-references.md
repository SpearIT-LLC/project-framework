# Feature: Update All v3.0.0 Path References

**ID:** FEAT-038
**Type:** Feature (Documentation Update)
**Version Impact:** PATCH (fixes outdated documentation)
**Status:** Doing
**Created:** 2026-01-10
**Completed:** N/A
**Developer:** Claude + User

---

## Summary

Update all active documentation and templates to align with v3.0.0 structure, fixing outdated path references (`thoughts/project/planning/` → `thoughts/work/`) in process docs, collaboration guides, templates, and NEW-PROJECT-CHECKLIST.md.

---

## Problem Statement

**What problem does this solve?**

FEAT-026 restructured the repository but missed updating many active documentation files and templates. These files still reference the old 4-level structure (`thoughts/project/planning/backlog/`) instead of the new 3-level structure (`thoughts/work/backlog/`).

**Affected Files (9 critical files):**

**Process Documentation (4 files):**
1. `framework/docs/process/kanban-workflow.md` - Core workflow reference
2. `framework/docs/collaboration/workflow-guide.md` - AI collaboration guide
3. `framework/docs/collaboration/troubleshooting-guide.md` - Troubleshooting guide
4. `framework/docs/collaboration/architecture-guide.md` - Architecture guide

**Templates (5 files):**
5. `framework/templates/documentation/CLAUDE-TEMPLATE.md`
6. `framework/templates/documentation/INDEX-TEMPLATE.md`
7. `framework/templates/documentation/PROJECT-STATUS-TEMPLATE.md`
8. `framework/templates/documentation/README-TEMPLATE.md`
9. `framework/templates/research/PROJECT-DEFINITION-TEMPLATE.md`

**Setup Documentation:**
10. `project-templates/NEW-PROJECT-CHECKLIST.md`

**Issues in these files:**
1. Reference `thoughts/project/planning/backlog/` (old 4-level structure) instead of `thoughts/work/backlog/` (new 3-level)
2. Reference `thoughts/project/work/` instead of `thoughts/work/`
3. Reference old folder structures that no longer exist

**Who is affected?**

- **Users** - Will copy templates with wrong paths
- **AI assistants** - Will reference incorrect paths from documentation
- **New adopters** - Will follow outdated setup instructions
- **FEAT-025 validation** - Blocked until paths are accurate

**Current workaround (if any):**

None - users and AI will use incorrect paths until fixed.

---

## Requirements

### Functional Requirements

**All Files:**
- [ ] Replace `thoughts/project/planning/backlog/` with `thoughts/work/backlog/`
- [ ] Replace `thoughts/project/work/` with `thoughts/work/`
- [ ] Remove all references to intermediate `planning/` folder level
- [ ] Verify 3-level structure references (not 4-level)
- [ ] Update Last Updated dates to completion date

**Process Documentation (4 files):**
- [ ] `framework/docs/process/kanban-workflow.md` - Update all path examples
- [ ] `framework/docs/collaboration/workflow-guide.md` - Update workflow references
- [ ] `framework/docs/collaboration/troubleshooting-guide.md` - Update troubleshooting paths
- [ ] `framework/docs/collaboration/architecture-guide.md` - Update architecture examples

**Templates (5 files):**
- [ ] `framework/templates/documentation/CLAUDE-TEMPLATE.md` - Update example paths
- [ ] `framework/templates/documentation/INDEX-TEMPLATE.md` - Update index links
- [ ] `framework/templates/documentation/PROJECT-STATUS-TEMPLATE.md` - Update status references
- [ ] `framework/templates/documentation/README-TEMPLATE.md` - Update readme examples
- [ ] `framework/templates/research/PROJECT-DEFINITION-TEMPLATE.md` - Update definition paths

**NEW-PROJECT-CHECKLIST.md:**
- [ ] Update all path references to v3.0.0 structure
- [ ] Fix template package path (`project-framework-template/` → `project-templates/`)
- [ ] Fix template location references
- [ ] Remove `thoughts/framework/` references (user projects don't have this)
- [ ] Align with PROJECT-STRUCTURE-STANDARD.md
- [ ] Update version to 3.0.0

### Non-Functional Requirements

- [ ] Consistency: All files use same path structure
- [ ] Accuracy: All paths verified against PROJECT-STRUCTURE-STANDARD.md
- [ ] Completeness: No outdated references remain in active documentation

---

## Design

### Architecture Impact

**Files Modified:**
- `project-templates/NEW-PROJECT-CHECKLIST.md` - Complete path and reference update

**Files Referenced (for verification):**
- `framework/docs/PROJECT-STRUCTURE-STANDARD.md` - Structure specification
- `framework/docs/REPOSITORY-STRUCTURE.md` - Repository structure
- `project-templates/standard/` - Actual template package structure
- `project-templates/light/` - Light template structure
- `project-templates/minimal/` - Minimal template structure

### Implementation Approach

**Phase 1: Process Documentation (4 files)**

For each file:
1. Open file
2. Search for `thoughts/project/planning` - Replace with `thoughts/work`
3. Search for `planning/backlog` - Replace with `work/backlog`
4. Verify all path examples use 3-level structure
5. Update "Last Updated" date
6. Verify changes don't break context

Files:
- [ ] `framework/docs/process/kanban-workflow.md`
- [ ] `framework/docs/collaboration/workflow-guide.md`
- [ ] `framework/docs/collaboration/troubleshooting-guide.md`
- [ ] `framework/docs/collaboration/architecture-guide.md`

**Phase 2: Templates (5 files)**

For each template:
1. Open file
2. Search for `thoughts/project/planning` - Replace with `thoughts/work`
3. Search for `planning/backlog` - Replace with `work/backlog`
4. Search for `thoughts/project/work` - Replace with `thoughts/work`
5. Update example paths in comments/instructions
6. Update "Last Updated" date

Files:
- [ ] `framework/templates/documentation/CLAUDE-TEMPLATE.md`
- [ ] `framework/templates/documentation/INDEX-TEMPLATE.md`
- [ ] `framework/templates/documentation/PROJECT-STATUS-TEMPLATE.md`
- [ ] `framework/templates/documentation/README-TEMPLATE.md`
- [ ] `framework/templates/research/PROJECT-DEFINITION-TEMPLATE.md`

**Phase 3: NEW-PROJECT-CHECKLIST.md**

1. Update all path references (as above)
2. Fix `project-framework-template/` → `project-templates/`
3. Fix `thoughts/framework/templates/` references (per DECISION-036 if available)
4. Align with PROJECT-STRUCTURE-STANDARD.md
5. Update version to 3.0.0
6. Update "Last Updated" date

**Known Issues in NEW-PROJECT-CHECKLIST.md (from FEAT-025-ALIGNMENT-ANALYSIS.md):**
- Line 220, 228, 236: References `thoughts/framework/templates/` (INCORRECT for user projects)
- Line 272, 489: References `thoughts/project/planning/backlog/` (OLD structure)
- Line 335, 419: References `thoughts/framework/` (user projects don't have this)
- Line 604: References `thoughts/framework/process/kanban-workflow.md` (incorrect path for users)

**Phase 4: Verification**

1. Run grep to verify no remaining `thoughts/project/planning` in updated files:
   ```bash
   grep -r "thoughts/project/planning" framework/docs/process/ framework/docs/collaboration/ framework/templates/ project-templates/NEW-PROJECT-CHECKLIST.md
   ```
2. Should return 0 results
3. Cross-reference paths with PROJECT-STRUCTURE-STANDARD.md
4. Verify all 10 files updated

### Alternative Approaches Considered

**Option 1: Complete rewrite**
- Pros: Could reorganize for clarity
- Cons: More work, might introduce new issues
- Decision: Not needed - update in place is sufficient

**Option 2: Create new v3 checklist, archive old**
- Pros: Preserves history
- Cons: Confusing to have multiple versions
- Decision: Not needed - single checklist with updated version

**Option 3: Wait for template access strategy decision (DECISION-036)**
- Pros: Could fix template access references correctly
- Cons: Blocks FEAT-025, may not affect checklist significantly
- Decision: Proceed now, update template access later if needed

---

## Dependencies

**Requires:**
- Access to current repository structure
- PROJECT-STRUCTURE-STANDARD.md (exists)
- REPOSITORY-STRUCTURE.md (exists)
- FEAT-026 completion (done)

**Blocks:**
- FEAT-025 (Manual Setup Process Validation) - Can't validate until checklist is correct

**Related:**
- FEAT-026 (Framework Structure Migration) - Established new structure
- DECISION-036 (Template Access Strategy) - May inform template reference updates
- FEAT-039 (Verify project-hello-world) - Both ensure v3.0.0 compliance

---

## Testing Plan

### Validation Checklist

**Path Accuracy:**
- [ ] Search for `thoughts/project/planning/` - Should find 0 occurrences
- [ ] Search for `project-framework-template/` - Should find 0 occurrences
- [ ] Search for `thoughts/framework/templates/` in user project context - Should find 0 occurrences
- [ ] All paths verified against PROJECT-STRUCTURE-STANDARD.md
- [ ] All paths verified against actual template packages

**Structure Compliance:**
- [ ] Compare Standard section against `project-templates/standard/` structure
- [ ] Compare Light section against `project-templates/light/` structure
- [ ] Compare Minimal section against `project-templates/minimal/` structure
- [ ] All required files listed
- [ ] All required folders listed

**Template References:**
- [ ] Template package path correct (`project-templates/`)
- [ ] Template access instructions accurate
- [ ] No references to non-existent template locations

**Completeness:**
- [ ] All setup steps present
- [ ] No missing steps discovered
- [ ] Version updated to 3.0.0
- [ ] Last Updated date current

### Manual Verification

1. Read through entire updated checklist
2. Compare each section against actual template packages
3. Verify each path exists in actual structure
4. Check for any remaining outdated references
5. Validate against PROJECT-STRUCTURE-STANDARD.md

---

## Documentation Updates

### Files to Update

- [x] `project-templates/NEW-PROJECT-CHECKLIST.md` - Primary work item file

### New Documentation Needed

None - this is a documentation fix, not new documentation.

---

## Implementation Checklist

- [ ] Read FEAT-025-ALIGNMENT-ANALYSIS.md for known issues
- [ ] Create comprehensive issue list from NEW-PROJECT-CHECKLIST.md
- [ ] Update all path references to v3.0.0 structure
- [ ] Update all template package references
- [ ] Fix template access references
- [ ] Align with PROJECT-STRUCTURE-STANDARD.md
- [ ] Verify against actual template packages
- [ ] Update version to 3.0.0
- [ ] Update Last Updated date
- [ ] Validation checklist completed
- [ ] Manual verification completed
- [ ] Ready for FEAT-025 to use

---

## Success Metrics

**How do we know this update is successful?**

1. ✅ Zero references to old structure paths (`thoughts/project/planning/`)
2. ✅ All paths verified against PROJECT-STRUCTURE-STANDARD.md
3. ✅ All template references accurate and accessible
4. ✅ FEAT-025 can use checklist for validation without confusion
5. ✅ New users can follow checklist without encountering errors

**Failure Criteria:**
- Checklist still contains outdated paths
- Template references incorrect
- Checklist doesn't match actual template packages
- Users encounter errors following checklist

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Fixed
- **FEAT-038: Update All v3.0.0 Path References**
  - Updated 10 files with v3.0.0 structure path references
  - Process documentation: kanban-workflow.md, workflow-guide.md, troubleshooting-guide.md, architecture-guide.md
  - Templates: CLAUDE-TEMPLATE.md, INDEX-TEMPLATE.md, PROJECT-STATUS-TEMPLATE.md, README-TEMPLATE.md, PROJECT-DEFINITION-TEMPLATE.md
  - NEW-PROJECT-CHECKLIST.md updated to v3.0.0
  - All references changed: thoughts/project/planning/ → thoughts/work/
  - Fixed template package path: project-framework-template/ → project-templates/
  - Removed 4-level structure references (now 3-level)
  - Aligned all documentation with PROJECT-STRUCTURE-STANDARD.md
```

---

## Notes

**Priority:** P0 - Blocking FEAT-025

This is a critical prerequisite for FEAT-025. The checklist must be accurate before we can validate the setup process, otherwise we'll be validating against incorrect instructions.

**Discovered during:** FEAT-025 alignment analysis (2026-01-10)

**Key insight:** NEW-PROJECT-CHECKLIST.md was written before major structural changes in FEAT-026. It represents the old world view and must be updated to reflect current reality.

**Template access decision:** If DECISION-036 (Template Access Strategy) is completed before this, incorporate those decisions. If not, use current best understanding and update later if needed.

---

## References

- [FEAT-025-ALIGNMENT-ANALYSIS.md](FEAT-025-ALIGNMENT-ANALYSIS.md) - Documented issues
- [PROJECT-STRUCTURE-STANDARD.md](../../docs/PROJECT-STRUCTURE-STANDARD.md) - Structure specification
- [REPOSITORY-STRUCTURE.md](../../docs/REPOSITORY-STRUCTURE.md) - Repository structure
- FEAT-026 Release Notes - v3.0.0 structure changes

---

**Last Updated:** 2026-01-10

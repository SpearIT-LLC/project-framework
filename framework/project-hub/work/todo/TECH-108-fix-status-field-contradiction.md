# Tech Debt: Fix Status Field Contradiction in Workflow Enforcement

**ID:** TECH-108
**Type:** Tech Debt
**Priority:** High
**Version Impact:** PATCH
**Created:** 2026-02-04
**Theme:** Workflow & Process

---

## Summary

Remove redundant "Status: Done" field requirement from all three enforcement layers (workflow-guide.md, fw-move.md, pre-commit hook), aligning with the Kanban principle that folder location IS the status.

---

## Problem Statement

**What is the current state?**

The framework has a system-wide contradiction regarding work item status:

- **Line 997** of workflow-guide.md states: "Status is determined by folder location (backlog/todo/doing/done), not a metadata field"
- **But three enforcement layers require** a redundant "Status: Done" field:
  1. workflow-guide.md line 426 (→ done/ checklist)
  2. .claude/commands/fw-move.md lines 167, 175, 281
  3. .claude/hooks/Validate-WorkItems.ps1 lines 77-78

**Why is this a problem?**

1. **Contradicts Kanban model**: Location = status is the core Kanban principle
2. **Confusing for users**: Documentation says one thing, enforcement requires another
3. **Redundant metadata**: Status field adds no value when location already indicates status
4. **Blocks legitimate moves**: fw-move incorrectly flags work items as "missing Status field"

**What is the desired state?**

- All three enforcement layers align with the Kanban model (location = status)
- Status field requirement removed from → done/ checklists
- Pre-commit hook validates only Completed date and acceptance criteria
- Completed date remains (useful for tracking when work finished)

---

## Proposed Solution

### Files to Update

1. **workflow-guide.md** (line 426)
   - Remove: `- [ ] Status field updated to "Done"`
   - Keep: `- [ ] Completed date is set`

2. **.claude/commands/fw-move.md** (lines 167, 175, 281)
   - Remove Status field validation from "→ done/" checklist
   - Update error messages to not mention Status field
   - Keep Completed date validation

3. **.claude/hooks/Validate-WorkItems.ps1** (lines 77-78)
   - Remove Status field check entirely
   - Keep Completed date check
   - Keep acceptance criteria check

### Validation Rules (Post-Fix)

Work items in done/ must have:
- ✅ **Completed date** (format: YYYY-MM-DD)
- ✅ **All acceptance criteria checked** (no `- [ ]` after "## Acceptance Criteria")
- ✅ **User approval** (confirmed before move)

Status is determined by location:
- backlog/ = backlog status
- todo/ = todo status
- doing/ = doing status
- done/ = done status

---

## Acceptance Criteria

- [ ] workflow-guide.md → done/ checklist removes Status field requirement
- [ ] fw-move.md → done/ checklist removes Status field requirement
- [ ] Validate-WorkItems.ps1 removes Status field validation
- [ ] All three enforcement layers use same validation rules
- [ ] Completed date validation remains in all three layers
- [ ] Acceptance criteria validation remains in all three layers
- [ ] Sync warning in workflow-guide.md notes these must stay aligned

---

## Files Affected

- `framework/docs/collaboration/workflow-guide.md` (line 426)
- `.claude/commands/fw-move.md` (lines 167, 175, 281)
- `.claude/hooks/Validate-WorkItems.ps1` (lines 77-78)

---

## Risk Assessment

**Low Risk:**
- Text-only changes to enforcement rules
- Completed date validation remains (preserves useful tracking)
- Acceptance criteria validation remains (ensures completeness)
- Can be completed in one session
- Easy to validate (test fw-move and pre-commit hook)

---

## Related

- **TECH-094**: Workflow Enforcement System (created the three-layer enforcement)
- **TECH-106**: Remove Multi-Level Framework References (discovered this issue during /fw-move)
- **workflow-guide.md line 997**: Explicitly states "Status is determined by folder location... not a metadata field"

---

## Notes

**Discovery Context:**
This issue was discovered when attempting to move TECH-106 to done/ using /fw-move. The enforcement system flagged "missing Status field" despite the workflow-guide.md explicitly stating that status is determined by folder location.

**Root Cause:**
The three-layer enforcement system (TECH-094) duplicated validation rules from workflow-guide.md without noticing the contradiction between line 426 (requires Status field) and line 997 (status = location, not a field).

**Coordination Note:**
workflow-guide.md has a sync warning that these checklists must stay aligned with fw-move.md. After fixing, verify both documents have identical validation rules.

---

**Last Updated:** 2026-02-04

# Tech Debt: Document Work Item Cancellation Process

**ID:** TECH-069
**Type:** Tech Debt
**Priority:** High
**Version Impact:** PATCH
**Created:** 2026-01-23

---

## Summary

The framework defines `thoughts/history/archive/` for "Cancelled/outdated/superseded items" but provides no documented process for actually cancelling work items.

---

## Problem Statement

**What is the current state?**

- PROJECT-STRUCTURE-STANDARD.md defines archive folder purpose
- No cancellation checklist (similar to other transition checklists)
- No guidance on updating work item status before archiving
- No naming convention for cancelled items
- No required documentation (reason, lessons learned)
- No valid transition paths defined

**Why is this a problem?**

- Work items may be cancelled inconsistently
- Reasons for cancellation may be lost
- No lessons learned captured
- Audit trail incomplete

**What is the desired state?**

- Clear cancellation process documented
- Consistent cancellation handling
- Preserved rationale and lessons learned

---

## Proposed Solution

Add cancellation process section to `workflow-guide.md`:

**Proposed 5-Step Cancellation Process:**
1. Update work item with cancellation reason
2. Add `**Status:** Cancelled` and `**Cancelled Date:** YYYY-MM-DD`
3. Move to `thoughts/history/archive/` using `git mv`
4. Optionally document lessons learned
5. Update session history noting the cancellation

**Valid Cancellation Transitions:**
- backlog → archive (most common)
- todo → archive (commitment withdrawn)
- doing → archive (work abandoned)
- done → archive (retroactive cancellation rare but possible)

**Required Cancellation Metadata:**
- Cancellation reason (brief explanation)
- Cancelled date
- Optional: Lessons learned
- Optional: Superseded by [ITEM-NNN]

**Files Affected:**
- `framework/docs/collaboration/workflow-guide.md` - Add Cancellation Process section
- `templates/standard/framework/docs/collaboration/workflow-guide.md` - Sync changes

---

## Acceptance Criteria

- [x] Cancellation process documented in workflow-guide.md
- [x] Valid transition paths to archive defined
- [x] Required metadata fields documented
- [x] Example cancellation shown
- [x] Template synced to templates/standard/

---

## Notes

Discovered during FEAT-025 validation testing. FEAT-008 in project-hello-world tested cancellation workflow and found no documented process.

---

## Related

- FEAT-025: Manual Setup Validation (source of finding)
- TECH-068: Hotfix/emergency workflow
- TECH-070: Rollback/revert policy

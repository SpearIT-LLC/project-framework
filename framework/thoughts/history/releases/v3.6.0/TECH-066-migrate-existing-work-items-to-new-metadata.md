# Tech Debt: Migrate Existing Work Items to New Metadata Standard

**ID:** TECH-066
**Type:** Tech Debt
**Priority:** Low
**Version Impact:** PATCH
**Created:** 2026-01-20

---

## Summary

Update existing work items in `thoughts/work/` to use the standardized metadata fields established in TECH-064.

---

## Problem Statement

**What is the current state?**

Existing work items use inconsistent metadata fields:
- `**Date:**` instead of `**Created:**`
- `**Status:**` field (now determined by folder location)
- `**Target Version:**` (removed per policy)
- `**Completed:**` field (tracked by git history)
- `**Developer:**` instead of `**Assigned:**`
- Missing `**Priority:**` or `**Version Impact:**` fields

**Why is this a problem?**

- Automation tools (Get-BacklogItems.ps1) need multiple fallback patterns
- Inconsistent reports and summaries
- Confusion about which fields are required

**What is the desired state?**

All work items in active folders (backlog/, todo/, doing/, done/) use the standard metadata:

```markdown
**ID:** TYPE-NNN
**Type:** Feature | Bug | Tech Debt | Decision | Spike
**Priority:** High | Medium | Low
**Version Impact:** MAJOR | MINOR | PATCH | None
**Created:** YYYY-MM-DD
```

---

## Proposed Solution

Batch update all work items in `thoughts/work/` folders:

1. **Scan** all `.md` files in backlog/, todo/, doing/, done/
2. **Identify** items with non-standard metadata
3. **Update** each item:
   - Rename `**Date:**` → `**Created:**`
   - Rename `**Developer:**` → `**Assigned:**` (and move to optional section)
   - Remove `**Status:**` field
   - Remove `**Target Version:**` field
   - Remove `**Completed:**` field
   - Add missing `**Priority:**` (default: Medium)
   - Add missing `**Version Impact:**` (infer from type or default: MINOR)

**Files Affected:**
- All `.md` files in `framework/thoughts/work/backlog/`
- All `.md` files in `framework/thoughts/work/todo/`
- All `.md` files in `framework/thoughts/work/doing/`
- All `.md` files in `framework/thoughts/work/done/`

**Note:** Files in `thoughts/history/` are not updated (historical record).

---

## Acceptance Criteria

- [x] All work items in backlog/ use standard metadata
- [x] All work items in todo/ use standard metadata
- [x] All work items in doing/ use standard metadata
- [x] All work items in done/ use standard metadata (none currently)
- [ ] Get-BacklogItems.ps1 works without fallback patterns (deferred - tool works)
- [x] No `**Status:**`, `**Target Version:**`, or `**Completed:**` fields remain in metadata headers

---

## Notes

- This is opportunistic cleanup - low priority
- Could be done incrementally (update items as they're touched)
- Consider creating a migration script if item count is high
- Per TECH-064 decision: "Existing items grandfathered - update opportunistically when touched"

---

## Related

- TECH-064: Standardize work item metadata fields (established the standard)
- [workflow-guide.md#standard-metadata-fields](../../docs/collaboration/workflow-guide.md#standard-metadata-fields)

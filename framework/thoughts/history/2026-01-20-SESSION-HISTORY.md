# Session History: 2026-01-20

**Date:** 2026-01-20
**Participants:** Gary Elliott, Claude
**Session Focus:** Scrum Master Evaluation + WIP Limit Enforcement Fix
**Related Work:** PowerShell tooling (Move-WorkItem, Get-WorkflowStatus, FrameworkWorkflow module)

---

## Summary

Started with a scrum master role evaluation of the project state, then addressed a gap in WIP limit enforcement where the todo/ folder's limit (10 items) was not being checked by Move-WorkItem.ps1.

---

## Scrum Master Evaluation

### Project Health Snapshot (v3.4.0)

| Metric | Value | Notes |
|--------|-------|-------|
| Doing | 0 items | Clean - no in-progress work |
| Todo | 9 items | Committed queue |
| Backlog | 38 items | Healthy depth |
| Done | 0 items | Clean - work properly released |

### Key Observations

1. **Todo queue manageable** - 9 of 10 slots used (now enforced!)
2. **PROJECT-STATUS.md outdated** - "Pending Work" section references old item IDs
3. **Documentation drift** - "Next Milestones" targets v2.0-v2.2 but current is v3.4.0
4. **Low-hanging fruit available** - FEAT-060 (Bootstrap Block) is small and well-defined

---

## Bug Fixed: WIP Limit Not Enforced for Todo

### Problem
Move-WorkItem.ps1 only checked WIP limits for moves to `doing/`. The `todo/` folder has a `.limit` file (value: 10) but it was never enforced.

### Solution (Option B - Generalized)
Refactored WIP functions to be folder-agnostic so any folder with a `.limit` file gets enforcement.

### Files Modified

**FrameworkWorkflow.psm1:**
- `Get-WipLimit` - Renamed parameter `DoingPath` → `FolderPath`
- `Get-WipCount` - Renamed parameter `DoingPath` → `FolderPath`
- `Test-WipLimitExceeded` - Renamed parameter `DoingPath` → `FolderPath`
- Added `HasLimit` property to distinguish "no limit configured" from "limit not exceeded"

**Move-WorkItem.ps1:**
- WIP check now applies to **any** target folder with a `.limit` file
- Contextual error messages based on target folder
- Updated description from "POC" to "Production"

**Get-WorkflowStatus.ps1:**
- Updated to use new `FolderPath` parameter name
- Fixed `Get-FolderItems` to return empty array instead of `$null` for empty folders
  - PowerShell quirk: returning `@()` from function becomes `$null`
  - Fix: use comma operator (`, @()`) to preserve array structure

### Testing

```powershell
# Todo enforcement test (simulated limit=5 with 7 items)
./Move-WorkItem.ps1 FEAT-021 todo -WhatIf
# Output: X Cannot move to todo/ - WIP limit reached
#         Current: 7 of 5
#         Review and prioritize existing items in todo/ first.

# Doing enforcement still works
./Move-WorkItem.ps1 FEAT-022 doing -WhatIf  # with temp item in doing
# Output: X Cannot move to doing/ - WIP limit reached
#         Current: 1 of 1
#         Complete or pause current work first.
```

---

## Commits

| Hash | Message |
|------|---------|
| 1cd1a00 | feat: Generalize WIP limit checking for all workflow folders |

---

## Behavior After Fix

| Folder | .limit | Enforcement |
|--------|--------|-------------|
| backlog/ | none | No limit |
| todo/ | 10 | ✅ Now enforced |
| doing/ | 1 | ✅ Still enforced |
| done/ | none | No limit |

---

## Lessons Learned

1. **PowerShell empty array return bug** - Functions returning `@()` return `$null` to the caller. Use `, @()` (comma operator) to preserve arrays.

2. **Breaking changes in shared modules** - Renaming parameters in a module breaks callers. Should have checked all consumers before committing.

3. **Generalized solutions are better** - Option B (folder-agnostic WIP checking) is cleaner and more maintainable than adding special cases for each folder.

---

## PowerShell Tools Consistency Improvements

### Get-WorkflowStatus.ps1 - Todo WIP Limit Display

**Problem:** Table output showed WIP limit for `doing/` but not for `todo/`, despite both folders supporting limits.

**Solution:**
- Added `HasLimit`, `HierarchicalCount`, and `Limit` fields to Todo status object
- Refactored `Format-TableOutput` to use a helper function `Get-FolderStatusLine` for consistent formatting
- Both Todo and Doing now show limit and status indicator when configured

**Before:**
```
Todo:     9 items
Doing:    1 item  (limit: 1) ✅
```

**After:**
```
Todo:     7 items  (limit: 10) ✅
Doing:    0 items  (limit: 1) ✅
```

### Get-BacklogItems.ps1 - Replace Type with Priority

**Problem:** The Type column was redundant because the ID prefix (FEAT, TECH, DECISION) already conveys item type.

**Solution:**
- Replaced Type column with Priority column
- Added priority normalization (High/Medium/Low from various formats like P1, "High - blocking", etc.)
- Updated `-SortBy` parameter: `Type` → `Priority`
- Priority sort order: High → Medium → Low → unset

**Before:**
```
ID             Type         Impact Created      Summary
FEAT-010       Feature      MINOR  2025-12-19   Document Enterprise...
```

**After:**
```
ID             Priority   Impact   Created      Summary
DECISION-029   High       -        2026-01-08   Decide which open...
FEAT-015       Medium     MINOR    2025-12-19   Generate executive...
```

---

## Follow-up Items

- [ ] Update PROJECT-STATUS.md "Pending Work" section (stale references)
- [ ] Update PROJECT-STATUS.md "Next Milestones" section (targets past versions)
- [ ] Consider FEAT-060 (Bootstrap Block) as quick win

---

**Session Duration:** ~1 hour
**Last Updated:** 2026-01-20

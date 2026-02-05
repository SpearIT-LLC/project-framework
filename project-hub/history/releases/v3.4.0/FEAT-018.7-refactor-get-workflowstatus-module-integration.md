# FEAT-018.7: Refactor Get-WorkflowStatus.ps1 Module Integration

**ID:** FEAT-018.7
**Parent:** [FEAT-018](./feature-018-claude-command-framework.md)
**Type:** Tech Debt (Sub-task)
**Version Impact:** PATCH
**Created:** 2026-01-19

---

## Summary

Refactor `Get-WorkflowStatus.ps1` to import `FrameworkWorkflow.psm1` and remove duplicated functions. This eliminates ~130 lines of duplicated code and improves consistency across workflow tools.

---

## Context

Code review identified these duplicated functions:

| Function in Script | Module Equivalent | Lines |
|---|---|---|
| `Find-WorkFolder` (101-122) | `Find-WorkFolder` | ~22 |
| `Get-WipLimit` (190-237) | `Get-WipLimit` | ~48 |
| `Get-HierarchicalWipCount` (298-357) | `Get-WipCount` | ~60 |

The module already lists `Get-WorkflowStatus.ps1` as an intended consumer (line 13).

---

## Refactor Plan

### 1. Import Module at Script Start

**Location:** After line 94 (`$ErrorActionPreference = "Stop"`)

```powershell
# Import shared workflow module
$modulePath = Join-Path $PSScriptRoot "FrameworkWorkflow.psm1"
if (Test-Path $modulePath) {
    Import-Module $modulePath -Force
} else {
    Write-Error "Required module not found: $modulePath"
    exit 1
}
```

### 2. Remove Duplicated Functions

**Remove:**
- `Find-WorkFolder` (lines 101-122)
- `Get-WipLimit` (lines 190-237)
- `Get-HierarchicalWipCount` (lines 298-357)

### 3. Replace Get-HierarchicalWipCount Usage

The module's `Get-WipCount` takes a `DoingPath` directly instead of pre-parsed items.

**Replace in main script (~line 517):**

```powershell
# Before
$hierarchicalWip = Get-HierarchicalWipCount -Items $doingItems

# After
$hierarchicalWip = Get-WipCount -DoingPath $doingPath
```

### 4. Update Notes Section

Add `Dependencies: FrameworkWorkflow.psm1` to the `.NOTES` section.

---

## Files Modified

| File | Change |
|------|--------|
| [framework/tools/Get-WorkflowStatus.ps1](../../../tools/Get-WorkflowStatus.ps1) | Import module, remove ~130 lines of duplicates |

---

## Testing

1. Run `Get-WorkflowStatus.ps1` with no parameters - verify JSON output unchanged
2. Run with `-Format table` - verify table output unchanged
3. Run with `-Summary` - verify folder counts correct
4. Run with `-WipCount` - verify hierarchical count correct
5. Run with `-Current` - verify current items listed correctly

---

## Acceptance Criteria

- [x] Module imported at script start with error handling
- [x] `Find-WorkFolder` function removed (use module version)
- [x] `Get-WipLimit` function removed (use module version)
- [x] `Get-HierarchicalWipCount` replaced with `Get-WipCount`
- [x] All existing parameter sets and output formats still work
- [x] Net reduction of ~130 lines of code (removed 130 lines, script now 478 lines vs 602)

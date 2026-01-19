# FEAT-018.6: Refactor Get-BacklogItems.ps1 Module Integration

**ID:** FEAT-018.6
**Parent:** [FEAT-018](../../doing/feature-018-claude-command-framework.md)
**Type:** Tech Debt (Sub-task)
**Version Impact:** PATCH
**Created:** 2026-01-19

---

## Summary

Refactor `Get-BacklogItems.ps1` to import `FrameworkWorkflow.psm1` and address code quality issues identified during production review. This eliminates ~40 lines of duplicated code and improves consistency across workflow tools.

---

## Context

Code review identified:
1. Duplicated folder discovery logic (`Find-BacklogFolder` vs `Find-WorkFolder`)
2. Duplicated ID normalization logic (lines 123-144 vs `ConvertTo-NormalizedWorkItemId`)
3. The module already lists `Get-BacklogItems.ps1` as an intended consumer (line 13)
4. Minor robustness issues with sorting and type handling

---

## Refactor Plan

### 1. Import Module at Script Start

**Location:** After line 84 (`$ErrorActionPreference = "Stop"`)

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

### 2. Replace Find-BacklogFolder with Find-WorkFolder

**Remove:** Lines 211-232 (entire `Find-BacklogFolder` function)

**Replace usage in main script (line 346):**

```powershell
# Before
$Path = Find-BacklogFolder

# After
$workFolder = Find-WorkFolder
if ($workFolder) {
    $Path = Join-Path $workFolder "backlog"
    if (-not (Test-Path $Path)) {
        $Path = $null
    }
}
```

### 3. Refactor Get-WorkItemMetadata to Use ConvertTo-NormalizedWorkItemId

**Replace lines 123-144** (ID extraction block) with:

```powershell
# Extract ID - try metadata field first, then filename
$id = ""
if ($content -match '\*\*ID:\*\*\s*([A-Za-z]+-\d+(?:\.\d+)?)') {
    $id = ConvertTo-NormalizedWorkItemId -RawId $matches[1] -IncludeSubItem
}
elseif ($content -match '\*\*ID:\*\*\s*(\d+)') {
    # Bare number - infer prefix from filename
    $num = $matches[1]
    if ($filename -match '^([A-Za-z]+)-') {
        $id = ConvertTo-NormalizedWorkItemId -RawId "$($matches[1])-$num"
    } else {
        $id = $num
    }
}
elseif ($filename -match '^([A-Za-z]+-\d+(?:\.\d+)?)') {
    $id = ConvertTo-NormalizedWorkItemId -RawId $matches[1] -IncludeSubItem
}
```

**Benefit:** Gets automatic `FEATURE` → `FEAT` and `TECHDEBT` → `TECH` normalization.

### 4. Fix Null-Safe Sorting

**Replace lines 384-390:**

```powershell
# Sort items with null-safe comparison
if ($items.Count -gt 0) {
    $items = $items | Sort-Object -Property {
        $val = $_.$SortBy
        if ([string]::IsNullOrEmpty($val)) { [string]::Empty } else { $val }
    } -Descending:(-not $Ascending)
}
```

### 5. Improve Array Coercion (Minor)

**Replace lines 373-379:**

```powershell
# Ensure items is always an array, filtering nulls
$items = @($items | Where-Object { $_ })
```

---

## Files Modified

| File | Change |
|------|--------|
| [framework/tools/Get-BacklogItems.ps1](../../../tools/Get-BacklogItems.ps1) | Import module, remove duplicates, fix sorting |

---

## Testing

1. Run `Get-BacklogItems.ps1` with no parameters - verify same output
2. Run with `-SortBy ID` on items with missing IDs - verify no errors
3. Run with `-Format json` - verify output unchanged
4. Run with `-Full` - verify word-wrapping still works
5. Verify items with `feature-` prefix normalize to `FEAT-`

---

## Acceptance Criteria

- [x] Module imported at script start with error handling
- [x] `Find-BacklogFolder` function removed
- [x] ID extraction uses `ConvertTo-NormalizedWorkItemId`
- [x] Sorting handles null/empty values gracefully
- [x] All existing tests/usage patterns still work
- [x] Net reduction of ~35-40 lines of code (removed 27 lines, simplified logic)

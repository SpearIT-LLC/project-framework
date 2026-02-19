# /fw-status - Project Status Summary

Show a summary of the current project status including version, work items in progress, and workflow health.

## Usage

```
/fw-status [current]
```

## Arguments

- `current` (optional): Show only items currently in doing/ folder

## Behavior

1. Read `PROJECT-STATUS.md` for current version
2. Scan `project-hub/work/` subfolders and count items
3. Read `doing/.limit` for WIP limit (default: 2). Apply hierarchical counting per `workflow-guide.md#hierarchical-numbering`
4. Present formatted status report

## Output Format (Default)

```
Project Status: [Project Name]
=======================================================

Version: v3.3.0 (2026-01-19)

Workflow Summary:
  Backlog:  12 items
  Todo:      3 items
  Doing:     1 item  (limit: 2) ✅
  Blocked:   1 item  ⚠ Waiting on external party
  Done:      1 item  ⚠ Ready for release

Currently In Progress:
  - FEAT-018: Claude Command Framework (+6 sub-items)

Awaiting Release:
  - DOC-063: Add README Update Step to Release Process
```

## Output Format (current)

```
FEAT-018: Claude Command Framework
  - FEAT-018.1: /fw-help Command
  - FEAT-018.2: /fw-move Command
  - FEAT-018.3: /fw-status Command
```

## Status Indicators

- ✅ Under WIP limit (can start more work)
- ⚠ At WIP limit, items in done/ awaiting release, or items in blocked/ waiting on external parties
- ❌ Over WIP limit (needs attention)

## Data Sources

- **Version**: `framework/PROJECT-STATUS.md` or `PROJECT-STATUS.md`
- **Work items**: `project-hub/work/{backlog,todo,doing,blocked,done}/`
- **WIP limit**: `project-hub/work/doing/.limit` (default: 2)

## Examples

```
/fw-status         # Full status report
/fw-status current # Show items in doing/ only
```

## Implementation

```powershell
# Default (full report)
.\framework\tools\Get-WorkflowStatus.ps1 -Format table

# Current items only
.\framework\tools\Get-WorkflowStatus.ps1 -Current
```

## Edge Cases

- **PROJECT-STATUS.md missing**: Show warning, continue with available data
- **Empty folders**: Show "0 items" (not an error)
- **Items in done/**: Flag with ⚠ as ready for release
- **Items in blocked/**: Flag with ⚠ as waiting on external party

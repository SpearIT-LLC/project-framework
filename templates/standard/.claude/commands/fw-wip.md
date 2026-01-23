# /fw-wip - Show Current Work In Progress

Display current work items in the doing/ folder with expanded sub-items.

## Usage

```
/fw-wip
```

## Arguments

None.

## Behavior

1. Run `Get-WorkflowStatus.ps1 -Current`
2. Display items currently in doing/ with expanded sub-items

## Output Format

```
FEAT-018: Claude Command Framework
  - FEAT-018.1: /fw-help Command
  - FEAT-018.2: /fw-move Command
  - FEAT-018.3: /fw-status Command
```

If no work in progress:
```
No work currently in progress.
```

## Hierarchical WIP Counting

See `workflow-guide.md#hierarchical-numbering` for the authoritative rule.

**Summary**: Parent + children = 1 WIP item (e.g., FEAT-018 + FEAT-018.1 + FEAT-018.2 = 1 item, not 3).

**Detection**: Items sharing the same base ID (e.g., `FEAT-018`, `FEAT-018.1`) are grouped.

## Examples

```
/fw-wip    # Show current work in progress
```

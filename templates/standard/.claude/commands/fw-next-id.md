# /fw-next-id - Get Next Available Work Item ID

Returns the next available work item ID from the common namespace.

## Usage

```
/fw-next-id
```

## Behavior

1. Run the PowerShell script to get the next ID
2. Display the result

## Script Location

```
framework/tools/Get-NextWorkItemId.ps1
```

## Example Output

```
Next available work item ID: 067
```

## How to Use the Result

When creating a new work item, use this ID:

```
FEAT-067-my-feature-description.md
TECH-067-refactor-something.md
SPIKE-067-investigate-option.md
```

## For AI Assistants

When the user asks to create a work item (feature, bug, tech debt, spike, decision):

1. Run this command first to get the next ID
2. Use that ID in the filename: `{TYPE}-{ID}-{description}.md`
3. Place in appropriate folder (`thoughts/work/backlog/` for new items)

**Execute:**

```powershell
powershell -ExecutionPolicy Bypass -File framework/tools/Get-NextWorkItemId.ps1
```

Report the result to the user as: "Next available work item ID: {result}"

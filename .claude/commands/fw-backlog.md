# /fw-backlog - Backlog Review and Prioritization

Review and prioritize backlog items, with options to view details and move items to todo/.

## Usage

```
/fw-backlog [subcommand] [item-id]
```

## Subcommands

- (none): List all backlog items (compact, truncated summaries)
- `full`: List all backlog items with full summaries (word-wrapped)
- `detail <item-id>`: Show full details for a specific item
- `move <item-id>`: Move an item to todo/ (with confirmation)
- `prioritize`: Start interactive prioritization session
- `help`: Show help (delegates to `/fw-help backlog`)

## Behavior

### List View (default)

1. Scan `thoughts/work/backlog/` for `.md` files
2. Parse metadata from each file (ID, Type, Version Impact, Created)
3. Present formatted table sorted by created date

### Detail View

1. Find and read the specified item file
2. Display full metadata and summary/problem statement
3. Offer option to move to todo/

### Move

1. Validate the item exists in backlog/
2. Use `/fw-move` logic internally (transition validation)
3. Confirm success

### Interactive Prioritization

1. Present items one at a time
2. For each: show summary, offer options (move to todo, keep, show details, skip)
3. Summarize actions taken at end

## Output Format - List View

```
Backlog Review
─────────────────────────────────────────────────────

12 items in backlog

ID          Type       Impact   Created     Summary
────────────────────────────────────────────────────────────
FEAT-037    Feature    MINOR    2026-01-10  Project config file
FEAT-038    Feature    MINOR    2026-01-11  Template validation
BUGFIX-012  Bugfix     PATCH    2026-01-12  Fix path handling
TECH-033    Tech Debt  PATCH    2026-01-08  Status field review
...

Commands:
  /fw-backlog full         - Full summaries (word-wrapped)
  /fw-backlog detail <id>  - Show full details for an item
  /fw-backlog move <id>    - Move item to todo/
```

## Output Format - Detail View

```
/fw-backlog detail FEAT-037

FEAT-037: Project Config File
─────────────────────────────────────────────────────

Type: Feature
Version Impact: MINOR
Created: 2026-01-10

Summary:
Add project-config.yaml file for multi-project repositories
to enable context switching between projects.

Problem:
Currently, CLAUDE.md at root must manually direct to correct
project CLAUDE.md. A config file would automate this.

Dependencies: None

Move to todo? Use: /fw-backlog move FEAT-037
```

## Examples

```
/fw-backlog                    # List all backlog items (compact)
/fw-backlog full               # List with full summaries
/fw-backlog detail FEAT-037    # Show details for FEAT-037
/fw-backlog move FEAT-037      # Move FEAT-037 to todo/
/fw-backlog prioritize         # Start interactive session
```

## Metadata Parsing

Extract from work item markdown files:
- **ID**: From `**ID:**` field or filename
- **Type**: From `**Type:**` field
- **Version Impact**: From `**Version Impact:**` field
- **Created**: From `**Created:**` field
- **Summary**: From `## Summary` section (first paragraph)

## Edge Cases

- **Empty backlog**: Show "No items in backlog" with suggestion
- **Malformed metadata**: Skip item or show with "Unknown" fields
- **Item ID not found**: Suggest similar IDs from backlog

## Implementation Notes

**IMPORTANT:** Always display the complete script output in a code block. Do not summarize, truncate, or reformat the output - show it exactly as returned by the PowerShell script. The script handles its own formatting.

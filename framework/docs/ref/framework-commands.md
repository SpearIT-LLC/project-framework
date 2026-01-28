# Framework Commands Reference

**Version:** 1.0.0
**Last Updated:** 2026-01-28

Framework commands provide shortcuts for common workflow operations in the SpearIT Project Framework. All commands use the `/fw-` prefix.

---

## Quick Command List

| Command | Description | Status |
|---------|-------------|--------|
| `/fw-help` | List available commands or get help on a specific command | Active |
| `/fw-move` | Move work item between folders with policy enforcement | Active |
| `/fw-status` | Show project status summary | Active |
| `/fw-wip-check` | Check WIP limits and current work | Active |
| `/fw-backlog` | Review and prioritize backlog items | Active |

---

## Command Syntax

**General format:** `/fw-<command> [arguments]`

**Getting help:**
```
/fw-help                    # List all commands
/fw-help <command>          # Get help on specific command (without /fw- prefix)
```

---

## Command Reference

### /fw-help

**Purpose:** List available commands or get detailed help on a specific command.

**Syntax:**
```
/fw-help [command-name]
```

**Arguments:**
- `command-name` (optional) - Command to get help for (without `/fw-` prefix)

**Examples:**
```
/fw-help           # List all available commands
/fw-help move      # Show detailed help for /fw-move
/fw-help status    # Show detailed help for /fw-status
```

**Output:**
- Without arguments: Lists all available commands with brief descriptions
- With command name: Shows detailed usage, arguments, examples, and notes for that command

---

### /fw-move

**Purpose:** Move a work item between workflow folders with transition validation, WIP limit checking, and proper git operations.

**Syntax:**
```
/fw-move <item-id> <target-folder>
```

**Arguments:**
- `item-id` (required) - Work item ID (e.g., `FEAT-018`, `BUGFIX-001`) or partial filename
- `target-folder` (required) - Target workflow folder: `backlog`, `todo`, `doing`, or `done`

**Examples:**
```
/fw-move FEAT-042 todo      # Move from backlog to todo
/fw-move FEAT-042 doing     # Start work (moves to doing)
/fw-move FEAT-042 done      # Complete work (moves to done)
/fw-move BUGFIX-001 backlog # Deprioritize back to backlog
```

**Behavior:**
1. **Find the item** - Searches `project-hub/work/` subfolders for a file matching the item-id
2. **Validate transition** - Checks against the transition validity matrix
3. **Check WIP limit** - If moving to `doing/`, verifies WIP limit not exceeded
4. **Execute move** - Uses `git mv` to move the file (preserves git history)
5. **Report result** - Confirms success or explains why the move was rejected

**Transition Validity Matrix:**

| From | To | Valid? | Reason |
|------|----|----|--------|
| backlog | todo | ✅ | Standard flow - committing to work |
| backlog | doing | ❌ | Must commit to work (todo) first |
| backlog | done | ❌ | Must be worked on |
| todo | doing | ✅ | Starting work |
| todo | backlog | ✅ | Deprioritizing |
| todo | done | ❌ | Must actually do the work (doing first) |
| doing | done | ✅ | Completing work |
| doing | todo | ✅ | Pausing work |
| doing | backlog | ❌ | Use todo as intermediate state |
| done | history | ✅ | Post-release archival |
| done | * | ❌ | No reopening (create new work item) |
| backlog | archive | ✅ | Cancellation |
| todo | archive | ✅ | Cancellation |
| doing | archive | ✅ | Cancellation |
| done | archive | ✅ | Cancellation (rare) |

**Error Handling:**

**Invalid transition:**
```
❌ Cannot move FEAT-042 directly from backlog to doing.
   Valid path: backlog → todo → doing
   Would you like me to move it to todo first?
```

**WIP limit exceeded:**
```
❌ Cannot move FEAT-042 to doing - WIP limit reached.
   Current: 2 items in doing/ (limit: 2)
   Complete or pause current work first.
```

**Item not found:**
```
❌ Could not find work item 'FEAT-999'.
   Did you mean one of these?
   - FEAT-018 (in doing/)
   - FEAT-037 (in backlog/)
```

**Per-Transition Checklists:**

Before executing any move, read and follow the appropriate checklist at:
[workflow-guide.md#per-transition-checklists](../collaboration/workflow-guide.md#per-transition-checklists)

**Key points:**
- Use `git mv` for all moves (preserves history)
- Check `.limit` files when they exist (any folder can have one)
- Moving to `doing/` triggers pre-implementation review
- Moving to `done/` triggers session history update and commit
- Moving to `releases/` triggers full release process

**Policy Reference:**
[workflow-guide.md#workflow-transitions](../collaboration/workflow-guide.md#workflow-transitions)

---

### /fw-status

**Purpose:** Show project status summary including version, current work, and workflow health.

**Syntax:**
```
/fw-status [--compact]
```

**Options:**
- `--compact` (optional) - Show single-line summary instead of full report

**Examples:**
```
/fw-status           # Full status report
/fw-status --compact # One-line summary
```

**Output includes:**
- Current version (from PROJECT-STATUS.md)
- Items in each workflow folder (backlog, todo, doing, done)
- WIP limit status (current count vs. limit)
- Items awaiting release (in done/)
- Recent activity summary

**Example Output:**
```
Project Status: SpearIT Project Framework v4.0.0

Workflow Status:
  Backlog: 12 items
  Todo: 3 items
  Doing: 1/2 items (WIP limit OK ✅)
  Done: 0 items

Active Work:
  - TECH-061: CLAUDE.md Duplication Review (in doing/)

Awaiting Release: None
```

**Compact Output:**
```
v4.0.0 | Backlog: 12 | Todo: 3 | Doing: 1/2 ✅ | Done: 0
```

---

### /fw-wip-check

**Purpose:** Check Work In Progress limits and list items currently in doing/.

**Syntax:**
```
/fw-wip-check
```

**Arguments:** None

**Examples:**
```
/fw-wip-check        # Check current WIP status
```

**Output includes:**
- Current count vs. limit (from `.limit` file)
- List of items in progress (in doing/)
- Status indicator (✅ under, ⚠️ at, ❌ over limit)
- Recommendation if over limit

**Example Output:**
```
WIP Limit Check

Limit: 2 items
Current: 1 item ✅

Items in doing/:
  - TECH-061: CLAUDE.md Duplication Review

Status: Under limit (1/2) - Can start new work
```

**Over Limit Example:**
```
WIP Limit Check

Limit: 2 items
Current: 3 items ❌

Items in doing/:
  - FEAT-042: Add User Authentication
  - FEAT-043: Implement Dashboard
  - BUGFIX-001: Fix Login Issue

Status: OVER LIMIT (3/2)
Recommendation: Complete or pause work before starting new items
```

---

### /fw-backlog

**Purpose:** Review and prioritize backlog items interactively.

**Syntax:**
```
/fw-backlog [subcommand] [item-id]
```

**Subcommands:**
- `(none)` - List all backlog items
- `detail <id>` - Show full details for an item
- `move <id>` - Move item to todo/ (with confirmation)
- `prioritize` - Interactive prioritization session

**Arguments:**
- `item-id` (required for detail/move) - Work item ID to act on

**Examples:**
```
/fw-backlog                   # List all backlog items
/fw-backlog detail FEAT-037   # Show details for FEAT-037
/fw-backlog move FEAT-037     # Move FEAT-037 to todo/
/fw-backlog prioritize        # Start interactive prioritization
```

**List Output:**
```
Backlog Items (12 total)

High Priority:
  - FEAT-042: Add User Authentication (MINOR impact)
  - FEAT-037: Implement Search Feature (MINOR impact)

Medium Priority:
  - TECH-068: Refactor API Layer (PATCH impact)
  - FEAT-051: Add Export Functionality (MINOR impact)

Low Priority:
  - TECH-061: CLAUDE.md Duplication Review (PATCH impact)
  ...
```

**Detail Output:**
```
FEAT-037: Implement Search Feature

Type: Feature
Priority: High
Version Impact: MINOR
Created: 2026-01-15

Summary:
Add full-text search capability to the application with filtering
and sorting options.

Dependencies:
  - Requires: FEAT-030 (Database Schema Update) ✅ Done
  - Blocks: FEAT-040 (Advanced Filters)

Status: Ready to move to todo/
```

**Move Behavior:**
- Validates transition (backlog → todo is valid)
- Checks if item is ready (dependencies met)
- Confirms with user before moving
- Uses `git mv` to preserve history

**Prioritize Mode:**
Interactive session that:
1. Shows items grouped by priority
2. Asks user to confirm/adjust priorities
3. Suggests items ready to move to todo/
4. Updates items based on user decisions

---

## Adding New Commands

New framework commands should follow these guidelines:

### Naming Convention
- Use `/fw-<verb>` or `/fw-<noun>` pattern
- Examples: `/fw-release`, `/fw-roadmap`, `/fw-archive`
- Keep names concise (one or two words)

### Documentation Requirements
1. Add to command registry table (Quick Command List)
2. Add detailed reference section
3. Include syntax, arguments, examples, and output format
4. Document error conditions and handling

### Implementation Pattern
1. Create work item (e.g., FEAT-XXX-YYY sub-task)
2. Implement command logic
3. Add tests if applicable
4. Update this documentation
5. Update CLAUDE.md quick reference

### Consistency Guidelines
- Follow existing argument patterns (`<required>` vs. `[optional]`)
- Use consistent output formatting
- Include helpful error messages
- Validate transitions/limits where applicable
- Use `git mv` for file operations

---

## Command Development Reference

**Framework Command Feature:**
- Work Item: FEAT-018 (Claude Command Framework)
- Location: `framework/project-hub/work/` (varies by status)

**Related Documentation:**
- [workflow-guide.md](../collaboration/workflow-guide.md) - Workflow transitions and policies
- [CLAUDE.md](../../CLAUDE.md) - AI collaboration contract
- [GLOSSARY.md](GLOSSARY.md) - Framework terminology

---

## Troubleshooting

### Command Not Recognized
**Symptom:** `/fw-command` doesn't work or shows "unknown command"

**Possible causes:**
1. Typo in command name (check `/fw-help` for valid commands)
2. Command not yet implemented
3. Missing `.claude/commands/` folder

**Solution:**
- Verify command exists: `/fw-help`
- Check spelling (case-sensitive)
- Ensure `.claude/commands/` folder contains command files

### Invalid Transition Error
**Symptom:** `/fw-move` rejects the transition

**Solution:**
- Check transition validity matrix above
- Use intermediate states (e.g., backlog → todo → doing)
- Verify current location of work item

### WIP Limit Blocking Move
**Symptom:** Cannot move item to doing/ due to WIP limit

**Solution:**
- Complete current work (move to done/)
- Pause work (move back to todo/)
- Check if limit should be adjusted (verify `.limit` file)

### Item Not Found
**Symptom:** Command cannot locate work item by ID

**Solution:**
- Verify item ID is correct (check folder listings)
- Ensure item exists in one of the workflow folders
- Try partial filename match if ID doesn't work

---

## See Also

- [GLOSSARY.md](GLOSSARY.md) - Framework terminology definitions
- [workflow-guide.md](../collaboration/workflow-guide.md) - Complete workflow process
- [CLAUDE.md](../../CLAUDE.md) - AI collaboration contract (includes command quick reference)

---

**Last Updated:** 2026-01-28
**Maintained by:** Gary Elliott (gary.elliott@spearit.solutions)

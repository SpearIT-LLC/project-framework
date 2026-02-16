# /spearit-framework:help - Framework Command Help

Show available framework commands or get help on a specific command.

## Usage

```
/spearit-framework:help [command-name]
```

## Arguments

- `command-name` (optional): Command to get help for (e.g., "move", "new")

## Behavior

**CRITICAL:** When invoked with no arguments, you MUST show ONLY the table below.

**Command Source:** Read ONLY from the plugin's commands directory at `plugins/spearit-framework/commands/`. Do NOT scan or list commands from any other location (not from `.claude/commands/`, not from any other plugin, not from any local framework installation).

Show this exact table:

| Command | Description | Status |
|---------|-------------|--------|
| `/spearit-framework:help` | Show this help message | ✅ Available |
| `/spearit-framework:new` | AI-guided work item planning with interactive breakdown and approval | ✅ Available |
| `/spearit-framework:move` | Move work item between folders with policy enforcement | ✅ Available |
| `/spearit-framework:session-history` | Document work sessions with structured templates | ✅ Available |
| `/spearit-framework:roadmap` | AI-guided roadmap planning and strategic organization | ✅ Available |

When invoked with a command name (e.g., `/spearit-framework:help move`), show detailed help for that command including:
- Full syntax
- All arguments with descriptions
- 2-3 examples
- Any relevant notes

## Examples

```
/spearit-framework:help                    # List all commands
/spearit-framework:help move               # Show help for move command
/spearit-framework:help new                # Show help for new command
/spearit-framework:help session-history    # Show help for session-history command
/spearit-framework:help roadmap            # Show help for roadmap command
```

## Output Format

Use a clean, readable format with horizontal rules and tables where appropriate.

## Help Content Source

**IMPORTANT:** This command operates ONLY on the 5 commands included in this plugin.

**Where to find command files:**
- Read from: `plugins/spearit-framework/commands/` directory
- Available files: `help.md`, `new.md`, `move.md`, `session-history.md`, `roadmap.md`
- Do NOT read from: `.claude/commands/` or any other location

**Command list (no arguments):**
When invoked with no arguments, show the table above listing these 5 commands:
- `/spearit-framework:help`
- `/spearit-framework:new`
- `/spearit-framework:move`
- `/spearit-framework:session-history`
- `/spearit-framework:roadmap`

**Detailed help (with command name):**
When invoked with a command name (e.g., "move"), read the corresponding `.md` file from `plugins/spearit-framework/commands/` to show detailed help.

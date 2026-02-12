# /spearit-framework-light:help - Framework Command Help

Show available framework commands or get help on a specific command.

## Usage

```
/spearit-framework-light:help [command-name]
```

## Arguments

- `command-name` (optional): Command to get help for (e.g., "move", "new")

## Behavior

**CRITICAL:** When invoked with no arguments, you MUST show ONLY the table below.

**Command Source:** Read ONLY from the plugin's commands directory at `plugins/spearit-framework-light/commands/`. Do NOT scan or list commands from any other location (not from `.claude/commands/`, not from any other plugin, not from any local framework installation).

Show this exact table:

| Command | Description |
|---------|-------------|
| `/spearit-framework-light:help` | Show this help message |
| `/spearit-framework-light:new` | Create a new work item with auto-assigned ID |
| `/spearit-framework-light:move` | Move work item between folders with policy enforcement |

When invoked with a command name (e.g., `/spearit-framework-light:help move`), show detailed help for that command including:
- Full syntax
- All arguments with descriptions
- 2-3 examples
- Any relevant notes

## Examples

```
/spearit-framework-light:help              # List all commands
/spearit-framework-light:help move         # Show help for move command
/spearit-framework-light:help new          # Show help for new command
```

## Output Format

Use a clean, readable format with horizontal rules and tables where appropriate.

## Help Content Source

**IMPORTANT:** This command operates ONLY on the 3 commands included in this plugin.

**Where to find command files:**
- Read from: `plugins/spearit-framework-light/commands/` directory
- Available files: `help.md`, `new.md`, `move.md`
- Do NOT read from: `.claude/commands/` or any other location

**Command list (no arguments):**
When invoked with no arguments, show the table above listing these 3 commands:
- `/spearit-framework-light:help`
- `/spearit-framework-light:new`
- `/spearit-framework-light:move`

**Detailed help (with command name):**
When invoked with a command name (e.g., "move"), read the corresponding `.md` file from `plugins/spearit-framework-light/commands/` to show detailed help.

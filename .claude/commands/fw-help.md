# /fw-help - Framework Command Help

Show available framework commands or get help on a specific command.

## Usage

```
/fw-help [command-name]
```

## Arguments

- `command-name` (optional): Command to get help for (without `/fw-` prefix)

## Behavior

When invoked with no arguments, list all available `/fw-*` commands in a table:

| Command | Description | Status |
|---------|-------------|--------|
| `/fw-help` | Show this help message | Active |
| `/fw-move` | Move work item between folders with policy enforcement | Active |
| `/fw-status` | Show project status summary | Active |
| `/fw-wip-check` | Check WIP limits and current work | Active |
| `/fw-backlog` | Review and prioritize backlog items | Active |

When invoked with a command name (e.g., `/fw-help move`), show detailed help for that command including:
- Full syntax
- All arguments with descriptions
- 2-3 examples
- Any relevant notes

## Examples

```
/fw-help              # List all commands
/fw-help move         # Show help for /fw-move
/fw-help status       # Show help for /fw-status
```

## Output Format

Use a clean, readable format with horizontal rules and tables where appropriate.

## Help Content Source

This command is the **single source of truth** for all `/fw-*` command help. When generating help for a specific command:

1. Read the command's `.md` file from `.claude/commands/fw-<name>.md`
2. Extract and format:
   - Description (from first paragraph after title)
   - Syntax (from `## Usage` code block)
   - Subcommands/Arguments (from `## Subcommands` or `## Arguments`)
   - Examples (from `## Examples`)
3. Present in a consistent format

Other `/fw-*` commands that receive `help` as an argument should delegate to this command (e.g., `/fw-backlog help` produces the same output as `/fw-help backlog`).

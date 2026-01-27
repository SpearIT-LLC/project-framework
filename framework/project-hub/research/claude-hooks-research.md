# Claude Code Hooks Research

**Date:** 2026-01-27
**Purpose:** Evaluate Claude hooks for enforcing workflow policies in fw-move
**Related:** TECH-093 (fw-move enforcement)

---

## What Are Hooks?

Hooks are user-defined shell commands that execute at specific points in Claude Code's lifecycle. They run automatically during the agentic loop and provide deterministic control over Claude's behavior.

**Key principle:** Hooks execute rules reliably rather than relying on the LLM to choose to follow them.

---

## How They Work

Hooks are configured in `.claude/settings.json` or `~/.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "your-command-here"
          }
        ]
      }
    ]
  }
}
```

Components:
- **Event matchers** - Which hook events trigger (e.g., `PreToolUse`)
- **Tool matchers** - Filter by specific tools (e.g., `Bash`, `Edit|Write`)
- **Hook commands** - The shell commands that execute

---

## Available Hook Events

### For Policy Enforcement (Most Relevant)

| Event | Timing | Can Block? | Use Case |
|-------|--------|------------|----------|
| **PreToolUse** | Before tool execution | Yes (exit 2) | Validate before action |
| **PostToolUse** | After tool completes | Yes (exit 2) | Validate after action |
| **PermissionRequest** | On permission dialog | Yes | Auto-approve/deny |

### Other Lifecycle Events

| Event | Purpose |
|-------|---------|
| UserPromptSubmit | Validate/intercept prompts before processing |
| Stop/SubagentStop | Control when Claude stops |
| SessionStart/SessionEnd | Session lifecycle |
| Notification | Customize notifications |
| PreCompact/Setup | Pre-processing |

---

## Hook Capabilities

### What Hooks CAN Do

- **Block actions** with custom error messages (exit code 2)
- **Modify tool inputs** before execution
- **Auto-approve or ask confirmation** on specific operations
- **Add contextual information** for Claude to consider
- **Validate against rules** (file patterns, command syntax, state)
- **Perform side effects** (logging, notifications, environment setup)
- **Run in parallel** - multiple hooks execute simultaneously

### What Hooks CAN'T Do

- **Proactively guide** - They react to attempts, not guide the process
- **Ensure order** - They validate state, not sequence of operations
- **Replace skill logic** - They complement skills, not replace them

---

## Hook Input/Output

Hooks receive JSON on stdin with context:

```json
{
  "tool_name": "Bash",
  "tool_input": {
    "command": "git commit -m 'message'"
  },
  "session_id": "...",
  "project_dir": "..."
}
```

Exit codes:
- `0` - Allow the operation
- `2` - Block the operation (stderr shown to Claude)
- Other - Treated as allow (with warning)

Environment variables available:
- `$CLAUDE_PROJECT_DIR` - Project root path

---

## Example: Pre-Commit Validation Hook

### PowerShell 5.1 Implementation

```powershell
# Validate-WorkItems.ps1
# Blocks git commit if work items in done/ have inconsistent state

param()
$ErrorActionPreference = 'Stop'

# Read hook input from stdin
$inputJson = $input | Out-String | ConvertFrom-Json
$command = $inputJson.tool_input.command

# Only check git commit commands
if ($command -notmatch 'git commit') {
    exit 0
}

$projectDir = $env:CLAUDE_PROJECT_DIR
$donePath = Join-Path $projectDir "framework/project-hub/work/done"

$errors = @()

Get-ChildItem -Path $donePath -Filter "*.md" -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -notlike ".*" } |
    ForEach-Object {
        $content = Get-Content $_.FullName -Raw
        $name = $_.Name

        # Check Status field
        if ($content -notmatch '\*\*Status:\*\*\s*Done') {
            $errors += "$name: Missing 'Status: Done'"
        }

        # Check Completed date
        if ($content -notmatch '\*\*Completed:\*\*') {
            $errors += "$name: Missing 'Completed' date"
        }

        # Check for unchecked acceptance criteria
        if ($content -match '## Acceptance Criteria' -and $content -match '- \[ \]') {
            $errors += "$name: Has unchecked acceptance criteria"
        }
    }

if ($errors.Count -gt 0) {
    [Console]::Error.WriteLine("Work item validation failed:")
    $errors | ForEach-Object { [Console]::Error.WriteLine("   $_") }
    exit 2  # Block
}

exit 0  # Allow
```

### Hook Configuration

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "powershell -ExecutionPolicy Bypass -File .claude/hooks/Validate-WorkItems.ps1"
          }
        ]
      }
    ]
  }
}
```

---

## Configuration Locations

Priority order (first match wins):

1. `.claude/settings.json` - Project-specific (committed)
2. `.claude/settings.local.json` - Project-local (not committed)
3. `~/.claude/settings.json` - User-level (applies to all projects)

---

## Debugging Hooks

```bash
/hooks           # Interactive menu to view/edit hooks
claude --debug   # See hook execution details
```

Debug output includes:
- Which hooks matched
- Commands being executed
- Success/failure status
- Output/error messages

---

## Security Considerations

Hooks run automatically with user credentials. Best practices:

- Always quote shell variables: `"$VAR"`
- Block path traversal: check for `..` in paths
- Use absolute paths with `$CLAUDE_PROJECT_DIR`
- Skip sensitive files explicitly
- Test thoroughly before enabling

---

## Applicability to fw-move Enforcement

### Hooks Are Good For

| Use Case | Hook Type | Implementation |
|----------|-----------|----------------|
| Block commit if work item state wrong | PreToolUse (Bash) | Validate files in done/ |
| Block git mv if preconditions not met | PreToolUse (Bash) | Check source file state |
| Log all transitions | PostToolUse (Bash) | Append to audit log |

### Hooks Are NOT Good For

| Use Case | Why Not | Alternative |
|----------|---------|-------------|
| Guide step-by-step process | Reactive, not proactive | Enhanced fw-move skill |
| Ensure correct order | Only validates state | Skill with explicit gates |
| Interactive confirmation | One-way (block/allow) | AskUserQuestion in skill |

### Recommended Approach

**Hybrid: Skill + Hooks**

1. **fw-move skill** - Proactive guidance, verifies preconditions, updates work item
2. **Pre-commit hook** - Safety net, catches anything the skill missed

This provides defense in depth: the skill should handle most cases, but the hook catches edge cases where Claude bypassed or partially executed the skill.

---

## References

- [Claude Code Hooks Documentation](https://docs.anthropic.com/claude-code/hooks)
- [Hooks Configuration Reference](https://docs.anthropic.com/claude-code/settings#hooks)

---

**Last Updated:** 2026-01-27

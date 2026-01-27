# Tech Debt: Enforce Workflow Transitions in fw-move

**ID:** TECH-093
**Type:** Tech Debt
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-01-27

---

## Summary

The `/fw-move` skill documents transition policies but doesn't enforce them mechanically, leading to inconsistent compliance. Implement a three-layer enforcement system: enhanced skill, durable work item records, and pre-commit validation hooks.

---

## Problem Statement

**What is the current state?**

The `/fw-move` skill at `.claude/commands/fw-move.md`:
- Documents the transition validity matrix
- References checklists in `workflow-guide.md`
- Instructs Claude to "read and follow the appropriate checklist"

But this is advisory, not enforced. Claude may:
- Skip reading the checklist
- Read it but execute steps out of order
- Forget steps entirely when focused on implementation

Evidence: FEAT-091 was moved to `done/` and committed before the Status field was updated and acceptance criteria were checked. These edits happened after the commit.

**Why is this a problem?**

- Workflow policies exist but aren't reliably followed
- No durable record of what was verified during transitions
- Inconsistent work item state (folder location doesn't match metadata)
- User must manually audit and catch mistakes
- Erodes trust in the framework's process guarantees

**What is the desired state?**

Mechanical enforcement where:
1. fw-move cannot complete until all preconditions are verified
2. Work items record their transition history durably
3. Pre-commit hooks catch any state inconsistencies as a safety net
4. Scripts use PowerShell 5.1 for Windows compatibility

---

## Proposed Solution

### Three-Layer Enforcement Architecture

```
┌─────────────────────────────────────────────────────────┐
│  Layer 1: Enhanced fw-move skill (proactive guidance)   │
│  - Embedded checklists, not references                  │
│  - Must verify each condition before proceeding         │
│  - Updates work item with transition record             │
├─────────────────────────────────────────────────────────┤
│  Layer 2: Work item transition section (durable record) │
│  - Records what was checked and when                    │
│  - Verifiable by hooks                                  │
├─────────────────────────────────────────────────────────┤
│  Layer 3: Pre-commit hook (safety net)                  │
│  - Validates work item state matches folder             │
│  - Blocks commit if state is inconsistent               │
└─────────────────────────────────────────────────────────┘
```

### Layer 1: Redesigned fw-move Skill

Key changes to `.claude/commands/fw-move.md`:

1. **Embed checklists directly** - No "see workflow-guide.md" references
2. **Verify before move** - Read work item file, check each condition programmatically
3. **Block if conditions not met** - Report what's missing, offer to fix or abort
4. **Update work item** - Append transition record after successful move

Example behavior for `→ done` transition:

```
1. Find the item
2. Validate transition is legal (doing → done ✓)
3. READ the work item file
4. Verify pre-conditions:
   - All acceptance criteria checked? (scan for `- [ ]` in criteria section)
   - Status field = "Done"?
   - Completed date set?

   If ANY fail → STOP, report what's missing, offer to fix

5. Execute `git mv`
6. Append transition record to work item
7. Post-move: update session history, prompt to commit
```

### Layer 2: Work Item Transition Section

Add to work item templates after metadata:

```markdown
## Transition History

<!-- Auto-updated by /fw-move - Do not edit manually -->
| Date | From | To | Verified |
|------|------|----|-----------|
| 2026-01-27 | backlog | todo | Priority ✓ |
| 2026-01-27 | todo | doing | WIP ✓, Dependencies ✓ |
| 2026-01-27 | doing | done | Status ✓, Completed ✓, Criteria ✓ |
```

Benefits:
- **Durable** - In the file, committed to git
- **Verifiable** - Hooks can check the last transition matches current folder
- **Auditable** - Shows the complete path the item took

### Layer 3: Pre-commit Hook (PowerShell 5.1)

Location: `.claude/hooks/Validate-WorkItems.ps1`

```powershell
# Validate-WorkItems.ps1
# Pre-commit hook to verify work item state consistency
# Reads JSON from stdin, exits 2 to block

param()

$ErrorActionPreference = 'Stop'

# Read hook input from stdin
$input = $input | Out-String | ConvertFrom-Json
$command = $input.tool_input.command

# Only check git commit commands
if ($command -notmatch 'git commit') {
    exit 0  # Allow
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
    exit 2  # Block commit
}

exit 0  # Allow
```

Hook configuration in `.claude/settings.json`:

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

### Optional: Role-Based Enforcement

Add to `framework.yaml`:

```yaml
roles:
  default: developer
  scrum_master:
    enforces:
      - strict-transitions  # fw-move blocks on missing preconditions
      - wip-limits          # Cannot exceed configured limits
```

fw-move could check the active role to determine enforcement level:
- `developer` role: Warn but allow override
- `scrum_master` role: Block until conditions met

---

## Acceptance Criteria

- [ ] fw-move.md rewritten with embedded checklists per transition type
- [ ] fw-move verifies preconditions before executing `git mv`
- [ ] fw-move blocks and reports when preconditions not met
- [ ] fw-move offers to fix missing fields (Status, Completed date)
- [ ] Work item templates updated with Transition History section
- [ ] fw-move appends to Transition History after successful move
- [ ] Pre-commit hook script created (PowerShell 5.1)
- [ ] Hook configuration added to settings.json
- [ ] Hook tested: blocks commit when work item state inconsistent
- [ ] Documentation updated in workflow-guide.md

---

## Implementation Notes

### Transition-Specific Checks

| Target | Preconditions to Verify |
|--------|------------------------|
| → backlog | ID assigned, created from template |
| → todo | Priority set, user approved |
| → doing | WIP limit not exceeded, dependencies in done/ |
| → done | Status = Done, Completed date, all criteria checked |

### Hook Limitations

Claude hooks are reactive (catch after attempt), not proactive (guide before). The enhanced fw-move skill provides proactive guidance; hooks provide the safety net.

### PowerShell 5.1 Constraints

- No `ConvertFrom-Json -AsHashtable` (use default PSCustomObject)
- Use `[Console]::Error.WriteLine()` for stderr
- Test on Windows PowerShell, not PowerShell Core

---

## Notes

This work item originated from a session analyzing why FEAT-091 was committed with incomplete metadata. The root cause: fw-move instructs Claude to follow checklists but doesn't enforce compliance mechanically.

Research on Claude hooks capabilities saved to: `framework/project-hub/research/claude-hooks-research.md`

---

## Related

- [workflow-guide.md](../../docs/collaboration/workflow-guide.md) - Source of transition checklists
- [fw-move.md](../../../.claude/commands/fw-move.md) - Current skill implementation
- FEAT-091 - Example of incomplete transition (moved before metadata updated)
- [Claude Hooks Documentation](https://docs.anthropic.com/claude-code/hooks) - External reference

---

**Last Updated:** 2026-01-27

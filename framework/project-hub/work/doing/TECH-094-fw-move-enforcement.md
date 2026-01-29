# Tech Debt: Enforce Workflow Transitions in fw-move

**ID:** 094
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

- [x] fw-move.md rewritten with embedded checklists per transition type
- [x] fw-move verifies preconditions before executing `git mv`
- [x] fw-move blocks and reports when preconditions not met
- [x] fw-move offers to fix missing fields (Status, Completed date)
- [x] Work item templates updated with enhanced Implementation Checklist
- [x] fw-move updated with enforcement rules for step-by-step execution
- [x] Pre-commit hook script created (PowerShell 5.1)
- [x] Hook configuration added to settings.json
- [x] Hook tested: blocks commit when work item state inconsistent
- [x] Hook tested: respects --no-verify flag
- [x] Hook syntax errors fixed (variable interpolation)
- [x] Hook refinement: Only check boxes after "## Acceptance Criteria" heading
- [x] Documentation updated in workflow-guide.md and CLAUDE.md

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->
<!-- User can say "continue to completion" to approve remaining steps at once. -->

- [x] **PRE-IMPLEMENTATION REVIEW COMPLETED**
  - AI presented: Three-layer architecture, design decisions, scope
  - User approved: Skip Layer 2, implement Layers 1 and 3

- [x] Layer 1: Enhanced fw-move with embedded checklists
- [x] Work item templates updated with enhanced Implementation Checklist
- [x] Layer 3: Pre-commit validation hooks (created and tested)
- [x] Hook syntax errors fixed (variable interpolation, --no-verify support)
- [x] Testing: Hook blocks invalid commits, respects --no-verify
- [x] Hook refinement: Improve acceptance criteria detection (scope after ## heading only)
- [x] fw-move updated with step-by-step enforcement rules
- [x] Documentation updated (workflow-guide.md, CLAUDE.md)
- [ ] CHANGELOG.md updated

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

### Testing Results (2026-01-29)

**Hook Functionality:**
- ✅ Hook successfully blocks commits with invalid work items
- ✅ Hook respects `--no-verify` flag for emergency bypasses
- ✅ Error messages are clear and actionable
- ✅ Lists all validation failures, not just the first one

**Issues Found & Resolved:**
1. **Syntax Error (FIXED):** Variable interpolation `$name:` failed; required `${name}:` syntax
2. **Overly Broad Validation (FIXED):** Hook was checking for ANY unchecked box if "## Acceptance Criteria" section exists
   - Was catching unchecked boxes in "Requirements" sections that appear before Acceptance Criteria
   - FEAT-088, FEAT-091 had completed Acceptance Criteria but unchecked Requirements (false positives)
   - **Resolution:** Updated hook to split content at "## Acceptance Criteria" heading and only check that section
   - **Verification:** FEAT-088 and FEAT-091 now pass validation; TEST-004 still correctly fails

**Remaining Issues:**
3. **Artifact Files in done/:** TECH-061-audit-report.md is a deliverable, not a work item
   - Doesn't follow work item template structure
   - Recommendation: Either move artifacts to separate folder or update hook to identify work items by template structure
4. **Legitimately Incomplete Items:** TECH-081 in done/ has unchecked criteria and is actually incomplete
   - Demonstrates the hook is working correctly - this item should not be in done/
   - Root cause: Manual move without fw-move enforcement (exactly what TECH-094 addresses)

**Test Files Created:**
- TEST-001: Valid work item (all requirements met)
- TEST-002: Missing Status field
- TEST-003: Missing Completed date
- TEST-004: Unchecked acceptance criteria
- TEST-005: Multiple issues
- TEST-006: In doing/ folder (correctly ignored by hook)

### fw-move Enforcement Rules (2026-01-29)

**Added to "→ doing/" section:**
- "During Implementation - Checklist Enforcement" subsection
- Step-by-step execution protocol with 5 mandatory rules
- Example workflow showing stop-at-each-step pattern
- User override phrases ("continue to completion", "skip to step N")

**Enforcement Rules:**
1. Complete checklist items in strict order (no skipping ahead)
2. Mark items complete immediately after finishing
3. STOP at each unchecked item and wait for user approval
4. Read work item file before every edit (may be updated during work)
5. Use TodoWrite tool for progress tracking and user visibility

**Integration with Templates:**
Works with enhanced Implementation Checklist added to work item templates:
```markdown
<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->
```

When this comment is present, fw-move enforcement rules automatically apply during the doing phase.

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

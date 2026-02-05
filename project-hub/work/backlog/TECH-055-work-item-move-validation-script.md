# TECH-055: Create Work Item Move Validation Script

**ID:** TECH-055
**Type:** Tech Debt
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-01-13

---

## Summary

Create a validation script that checks work item state transitions before moving files. Ensures workflow rules are followed (e.g., cannot move backlog → doing directly). Can be called by AI or run manually.

**Context:** During DOC-053 work, AI violated workflow by moving item from backlog → done. Need programmatic validation to prevent invalid transitions.

---

## Problem Statement

**Issue:** No automated way to validate work item moves. AI and humans can accidentally create invalid state transitions.

**Invalid transitions that should be prevented:**
- backlog → doing (must go through todo)
- backlog → done (must be worked on)
- todo → done (must be in doing first)
- done → doing (no reopening)

**Who is affected:**
- AI assistants (need validation before moves)
- Human contributors (prevent mistakes)
- Workflow integrity (ensure proper state flow)

**Current state:**
- State rules will be documented (DOC-054) ✅ (planned)
- No programmatic validation ❌
- No tool to check transitions before moving ❌
- AI relies on understanding rules (error-prone) ❌

---

## Requirements

### Functional Requirements

**Script capabilities:**
- [ ] Accept parameters: From folder, To folder, Work item ID
- [ ] Validate transition using rules from DOC-054
- [ ] Check WIP limits in target folder
- [ ] Verify all `{TYPE-ID}-*` files exist in source
- [ ] Return clear pass/fail with explanation
- [ ] Exit code: 0 = valid, 1 = invalid

**Validation checks:**
- [ ] Transition is in allowed list
- [ ] Source folder contains the work item
- [ ] Target folder has capacity (WIP limits)
- [ ] All related files (`{TYPE-ID}-*`) present in source

**Output:**
- [ ] Success: "✓ Valid transition: backlog → todo for FEAT-042"
- [ ] Failure: "✗ Invalid transition: backlog → doing. Must go through todo first."
- [ ] WIP violation: "✗ Target folder doing/ at WIP limit (1/1). Complete current work first."

### Non-Functional Requirements

- Cross-platform (PowerShell Core or bash)
- Fast execution (< 1 second)
- Clear error messages
- Exit codes for automation
- Self-documenting (comments, help text)

---

## Design

### Script Location

`framework/scripts/Validate-WorkItemMove.ps1` (PowerShell)
OR
`framework/scripts/validate-work-item-move.sh` (Bash)

**Recommendation:** Start with PowerShell (Windows primary), add bash later if needed

### Script Interface

```powershell
# Usage
./Validate-WorkItemMove.ps1 -From backlog -To todo -WorkItemId FEAT-042

# Parameters
-From       # Source folder: backlog, todo, doing, done
-To         # Target folder: todo, doing, done, history
-WorkItemId # Work item ID (e.g., FEAT-042)
-WorkPath   # Optional: path to work folder (default: project-hub/work/)
```

### Validation Logic

```powershell
# 1. Define allowed transitions (from DOC-054)
$allowedTransitions = @{
    "backlog" = @("todo")
    "todo"    = @("doing", "backlog")
    "doing"   = @("done", "todo")
    "done"    = @("history")
}

# 2. Check transition validity
if ($allowedTransitions[$From] -notcontains $To) {
    Write-Error "Invalid transition: $From → $To"
    Write-Error "Allowed: $($allowedTransitions[$From] -join ', ')"
    exit 1
}

# 3. Check WIP limits (if target is todo/doing)
if ($To -in @("todo", "doing")) {
    $limit = [int](Get-Content "$WorkPath/$To/.limit")
    # Count unique work item prefixes (TYPE-NNN), not files
    # Work items can have multiple files: .md, .yaml, .json, .ps1, etc.
    $workItemPrefixes = Get-ChildItem "$WorkPath/$To/*" -Exclude ".gitkeep",".limit" |
        ForEach-Object { $_.Name -replace '-.*$', '' } |
        Select-Object -Unique
    $count = $workItemPrefixes.Count

    if ($count -ge $limit) {
        Write-Error "WIP limit reached in $To/ ($count/$limit)"
        exit 1
    }
}

# 4. Verify all {TYPE-ID}-* files present in source
$workItems = Get-ChildItem "$WorkPath/$From/$WorkItemId-*"
if ($workItems.Count -eq 0) {
    Write-Error "Work item $WorkItemId not found in $From/"
    exit 1
}

Write-Host "✓ Valid transition: $From → $To for $WorkItemId" -ForegroundColor Green
Write-Host "Files to move: $($workItems.Count)" -ForegroundColor Gray
$workItems | ForEach-Object { Write-Host "  - $($_.Name)" -ForegroundColor Gray }
exit 0
```

### Output Examples

**Valid transition:**
```
✓ Valid transition: backlog → todo for FEAT-042
Files to move: 2
  - FEAT-042-namespace.md
  - FEAT-042-notes.md
```

**Invalid transition:**
```
✗ Invalid transition: backlog → doing for FEAT-042
Allowed transitions from backlog: todo
```

**WIP limit reached:**
```
✗ WIP limit reached in doing/ (1/1)
Complete current work before starting FEAT-042
```

---

## Implementation Approach

### Phase 1: Basic Script
- [ ] Create PowerShell script with parameter validation
- [ ] Implement allowed transitions check
- [ ] Add clear error messages
- [ ] Test with valid and invalid transitions

### Phase 2: WIP Limit Check
- [ ] Read `.limit` files from target folders
- [ ] Count existing work items in target
- [ ] Validate capacity before allowing move
- [ ] Test with WIP violations

### Phase 3: File Pattern Check
- [ ] Find all `{TYPE-ID}-*` files in source
- [ ] Report count and list files
- [ ] Warn if no files found
- [ ] Test with multi-file work items

### Phase 4: Documentation
- [ ] Add help text to script (`Get-Help Validate-WorkItemMove`)
- [ ] Document in workflow-guide.md
- [ ] Add usage examples
- [ ] Update AI guidance to use script

---

## Usage Examples

### AI Integration

```
Before moving work item, AI calls:
./Validate-WorkItemMove.ps1 -From backlog -To doing -WorkItemId FEAT-042

If exit code = 1 (invalid):
  AI explains to user why transition is invalid
  AI suggests correct path

If exit code = 0 (valid):
  AI proceeds with move
```

### Manual Use

```powershell
# Check if move is valid before doing it
./Validate-WorkItemMove.ps1 -From todo -To doing -WorkItemId FEAT-042

# If valid (exit 0), proceed with actual move
if ($LASTEXITCODE -eq 0) {
    git mv project-hub/work/todo/FEAT-042-*.* project-hub/work/doing/
}
```

---

## Success Metrics

**How do we know this work is complete?**

1. ✅ Script validates transitions correctly
2. ✅ Script checks WIP limits
3. ✅ Script finds all related files
4. ✅ Clear error messages for each failure type
5. ✅ AI can call script and interpret results
6. ✅ Manual usage works for humans

**Validation tests:**
- Valid transitions return exit 0
- Invalid transitions return exit 1
- WIP violations return exit 1
- Missing files return exit 1
- Clear explanatory messages in all cases

---

## Dependencies

**Requires:**
- DOC-054 completed (state transition rules documented)
- PowerShell Core installed (or bash for bash version)

**Enables:**
- Automated workflow validation
- AI self-checking before moves
- Foundation for CI/CD validation
- FEAT-037 can reference this script

**Related:**
- FEAT-037 - project-config.yaml (could store transition rules there)
- DOC-054 - Source of transition rules

---

## Future Enhancements

**Phase 5 (Optional):**
- Bash version for Linux/Mac users
- Integration with git hooks (pre-commit validation)
- Status field sync check (file status matches folder)
- Subtask tracking (ensure all subtasks complete)

**Phase 6 (Optional):**
- Move validation + execution in one command
- Interactive mode (prompt user for corrections)
- Batch validation (check all work items)

---

## Notes

**Critical: Extension-agnostic file patterns**

Work items can include multiple file types (discovered during FEAT-059 testing):
- `.md` - documentation, specs, plans
- `.yaml` / `.yml` - structured definitions, configs
- `.json` - data files, schemas
- `.ps1` / `.sh` - scripts related to the work
- `.png` / `.svg` - diagrams, mockups

**All queries must use `{TYPE-ID}-*` patterns, never `{TYPE-ID}-*.md`.**

WIP counting must count unique work item prefixes (e.g., `FEAT-059`), not individual files. A single work item with 3 files (`FEAT-059-main.md`, `FEAT-059-research.md`, `FEAT-059-roles.yaml`) counts as 1 toward WIP limit.

---

**Priority:** Medium
- Not blocking (manual validation works)
- Improves workflow reliability
- Foundation for automation

**Why this matters:**
Programmatic validation prevents workflow violations. Provides clear, consistent enforcement of rules. Reduces cognitive load (AI and humans don't need to remember all rules).

**Implementation time:** ~2 hours
- Basic script: 1 hour
- WIP checks: 30 min
- File pattern check: 20 min
- Documentation: 10 min

**Testing strategy:**
- Create test work items in test folders
- Run script with valid transitions (expect exit 0)
- Run script with invalid transitions (expect exit 1)
- Verify error messages are clear

---

**Last Updated:** 2026-01-17

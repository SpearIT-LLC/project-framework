# Tech Debt: Work-In-Progress Enforcement Hook

**ID:** TECH-114
**Type:** Tech Debt
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-02-06
**Theme:** Workflow

---

## Summary

Research and design a pre-commit hook that enforces the workflow rule: implementation work must only be done on items in `doing/`, preventing violations of the backlog → todo → doing → done flow.

---

## Problem Statement

**What problem does this solve?**

The current workflow relies on self-discipline to follow the backlog → todo → doing → done flow. When work is "quick," there's a temptation to bypass the workflow and implement directly from backlog or todo, violating WIP limits and tracking policies.

**Current violations:**
- BUG-113: Created in backlog, fixed immediately, moved directly to done (skipped todo and doing)
- Similar pattern observed multiple times when fixes seem trivial
- No mechanical enforcement to prevent this

**Impact:**
- Workflow violations go undetected until noticed
- WIP limits can be bypassed
- Work tracking is incomplete (items never appear in doing/)
- Metrics and visibility are inaccurate

**Root cause:** No hook to enforce "implementation must happen from doing/"

---

## Current State

**Existing hook:** `.claude/hooks/Validate-WorkItems.ps1`
- Validates items in `done/` have completion metadata
- Does NOT prevent implementation outside `doing/`
- Reactive (catches violations after attempt)

**Workflow enforcement layers:**
- Layer 1: `/fw-move` command guidance (proactive but not enforced)
- Layer 2: Implementation checklists (structural but optional)
- Layer 3: Pre-commit hook for done/ (reactive, specific scope)

**Gap:** No enforcement that work must be in `doing/` before implementation

---

## Research Questions

### 1. Detection Strategy

**Question:** How do we detect "implementation" vs "work item management"?

**Scenarios to distinguish:**
- ✅ Creating work item in backlog (allowed)
- ✅ Updating work item text in backlog (allowed)
- ❌ Implementing bug fix while item in backlog (violation)
- ❌ Writing code for feature while item in todo (violation)

**Approaches to research:**
1. **File-based detection:** Check if commits include files outside `project-hub/work/`
   - Pros: Simple, catches most implementation
   - Cons: Doesn't catch work item artifact files, legitimate repo-wide changes

2. **Active work item tracking:** Require setting an active item in doing/ before commits
   - Pros: Explicit, clear contract
   - Cons: Manual tracking, easy to forget, tooling overhead

3. **Commit message analysis:** Require commit messages to reference work item ID, validate it's in doing/
   - Pros: Leverages existing commit message conventions
   - Cons: Easy to bypass, doesn't prevent violations proactively

4. **Hybrid:** Combine file-based detection + active work item tracking
   - Pros: Defense in depth
   - Cons: Complexity

### 2. Scope and Exceptions

**Question:** What commits should be exempt from this enforcement?

**Potential exceptions:**
- Emergency hotfixes (need rapid response)
- Repository maintenance (README updates, typo fixes)
- Hook fixes themselves (can't use broken hook to commit hook fixes)
- Session history updates (meta-work, not feature implementation)

**Research needed:**
- How to identify exceptions reliably?
- Should exceptions require explicit flags (`--no-verify`, special commit prefix)?
- Are exceptions a slippery slope that defeats the purpose?

### 3. User Experience

**Question:** How do we make this helpful rather than annoying?

**Considerations:**
- Clear error messages (what's wrong, how to fix)
- Easy bypass for legitimate exceptions
- Guidance on proper workflow when violations detected
- Not overly restrictive for legitimate multi-item work

**User journey:**
```
1. Developer commits implementation changes
2. Hook detects no work item in doing/
3. Hook provides clear error: "No work item in doing/ for this change"
4. Hook suggests: "Move work item to doing/ with: /fw-move ITEM-NNN doing"
5. Developer follows proper workflow
```

### 4. Technical Implementation

**Question:** What's the most reliable implementation approach?

**Options:**
- PowerShell pre-commit hook (current ecosystem)
- Git pre-commit hook (standard Git mechanism)
- Combination (PowerShell called from Git hook)

**Compatibility:**
- Must work with Claude Code hooks system
- Must work with standard Git workflows
- Must not break existing Validate-WorkItems.ps1 hook

---

## Proposed Design (Research Needed)

### Option A: File-Based Detection

**Logic:**
```powershell
# Get staged files
$stagedFiles = git diff --cached --name-only

# Filter for files outside project-hub/work/
$implementationFiles = $stagedFiles | Where-Object {
    $_ -notlike "project-hub/work/*" -and
    $_ -notlike "project-hub/history/*" -and
    $_ -notlike ".claude/*"
}

# If implementation files exist, check for work item in doing/
if ($implementationFiles.Count -gt 0) {
    $itemsInDoing = Get-ChildItem "project-hub/work/doing/*.md"
    if ($itemsInDoing.Count -eq 0) {
        Write-Error "Implementation changes require an active work item in doing/"
        exit 2
    }
}
```

**Pros:**
- Simple to implement
- Catches most violations
- No manual tracking required

**Cons:**
- Can't determine WHICH item the changes relate to
- Legitimate repo-wide changes blocked
- Doesn't enforce one-item-at-a-time rule

### Option B: Active Work Item File

**Logic:**
```powershell
# Check for .active file
$activePath = "project-hub/work/.active"
if (-not (Test-Path $activePath)) {
    Write-Error "No active work item. Set with: echo 'ITEM-NNN' > $activePath"
    exit 2
}

$activeItem = Get-Content $activePath
$itemPath = "project-hub/work/doing/$activeItem*.md"
if (-not (Test-Path $itemPath)) {
    Write-Error "Active work item $activeItem not found in doing/"
    exit 2
}
```

**Pros:**
- Explicit contract
- Enforces one-item-at-a-time
- Clear which item is being worked on

**Cons:**
- Requires manual tracking
- Easy to forget to set/unset
- Additional tooling needed

### Option C: Hybrid Approach

Combine both: detect implementation files + validate active work item exists in doing/

---

## Success Criteria

- [ ] Research completed on detection strategies
- [ ] User experience design validated with examples
- [ ] Technical approach selected and documented
- [ ] Prototype implementation tested
- [ ] Edge cases and exceptions identified
- [ ] Integration with existing Validate-WorkItems.ps1 verified
- [ ] Documentation updated with new hook behavior

---

## Out of Scope

- Automatic work item selection (stays manual)
- Multi-item tracking (one work item at a time is policy)
- Retroactive enforcement (only enforces going forward)

---

## Related Work Items

- **Validate-WorkItems.ps1:** Existing pre-commit hook for done/ validation
- **BUG-113:** Example violation that triggered this exploration
- **TECH-094:** Original work item that created the three-layer validation system
- **FEAT-099:** `/fw-release` command (may need similar enforcement)

---

## Notes

**Trigger:** User asked "Are there any hooks that can help prevent implementation outside of doing?" after BUG-113 workflow violation

**Philosophy question:** Is strict mechanical enforcement better than self-discipline + reactive validation? This research should explore both the technical feasibility and the workflow impact.

**Balance to strike:**
- Enforce workflow consistency
- Don't make legitimate work annoying
- Provide clear guidance when violations detected
- Allow exceptions for genuine edge cases

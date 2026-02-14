# Version Control & Release Workflow

**Version:** 1.0.0
**Created:** 2025-11-26
**Status:** Active Process Standard

---

## Core Principle

**ONE work item at a time.** Work on a single feature, bugfix, or blocker from planning through release.

**Workflow Integration:** This document describes the git/release process. See [workflow-guide.md](../collaboration/workflow-guide.md) for the complete work item lifecycle (planning → backlog → todo → doing → done → release → archive).

---

## Semantic Versioning Rules

Given version MAJOR.MINOR.PATCH (e.g., 1.2.3):

| Change Type | Version Bump | Example |
|-------------|--------------|---------|
| **Breaking change** (data format incompatible, removed features) | MAJOR | 1.2.3 → 2.0.0 |
| **New feature** (backward-compatible addition) | MINOR | 1.2.3 → 1.3.0 |
| **Bug fix** (backward-compatible fix) | PATCH | 1.2.3 → 1.2.4 |

**Decision Tree:**
```
Does it break existing manifests/workflows? → YES → MAJOR
  ↓ NO
Does it add new capability? → YES → MINOR
  ↓ NO
Is it a bug fix only? → YES → PATCH
```

---

## Git Branching Strategy

### Branch Types

| Branch | Purpose | Naming | Lifespan |
|--------|---------|--------|----------|
| `main` | Released versions only | `main` | Permanent |
| Feature | New capabilities | `feature/brief-description` | Until merged |
| Bugfix | Non-critical fixes | `bugfix/brief-description` | Until merged |
| Hotfix | Critical emergency fixes | `hotfix/brief-description` | Short (hours/days) |

### Branch Workflow

**Starting New Work:**
```powershell
# Move work item: work/todo/feature-NNN-name.md → work/doing/feature-NNN-name.md

# For features (use ID in branch name)
git checkout main
git pull
git checkout -b feature/NNN-brief-name

# For bugfixes (use ID in branch name)
git checkout main
git pull
git checkout -b bugfix/NNN-brief-name

# For hotfixes (critical - use ID if available)
git checkout main
git pull
git checkout -b hotfix/NNN-brief-name
```

**Example with IDs:**
```powershell
# Feature 002
git checkout -b feature/002-namespace-system

# Bugfix 101
git checkout -b bugfix/101-memory-export
```

**Completing Work:**
```powershell
# Test thoroughly
.\scripts\tests\Test-*.ps1

# Merge to main
git checkout main
git merge feature/catia-template

# Tag the release
git tag -a v1.2.0 -m "Feature: CATIA template support"

# Push
git push origin main --tags

# Delete feature branch
git branch -d feature/catia-template
```

---

## Release Process

### When to Release

Release immediately when:
1. ✅ Feature complete and tested
2. ✅ Bugfix complete and tested
3. ✅ Blocker resolved and tested

**Rule:** Release when ready. Batching multiple completed issues into a single release is acceptable.

### Release Checklist

```markdown
Pre-Release:
[ ] All tests pass
[ ] Feature/bugfix branches merged to main
[ ] Work item(s) moved to work/done/
[ ] Work item(s) have CHANGELOG notes sections

Determine Version:
[ ] Read work item metadata (use highest impact if batching multiple):
    - Type: Feature | Bugfix | Breaking Change
    - Version Impact: MAJOR | MINOR | PATCH
[ ] Calculate new version number from current version

Release (do together - atomic operation):
[ ] Update PROJECT-STATUS.md:
    [ ] Update "Current Version" in header
    [ ] Update "Last Updated" date
    [ ] Add completion notes if applicable
[ ] Update CHANGELOG.md:
    [ ] Move [Unreleased] to new version section [vX.Y.Z] - YYYY-MM-DD
    [ ] Add changes from all work items' CHANGELOG notes
    [ ] Update Version History table
    [ ] Reset [Unreleased] sections to "None"
[ ] Commit both: git commit -m "Release vX.Y.Z: Description"
[ ] Create git tag: git tag -a vX.Y.Z -m "Description"
[ ] Push with tags: git push origin main --tags
[ ] Delete feature/bugfix branches if applicable

Post-Release:
[ ] Build distribution archive: .\tools\Build-FrameworkArchive.ps1
    - Creates SpearIT-Framework-vX.Y.Z.zip in distrib/
    - Version automatically read from PROJECT-STATUS.md
    - Validates no unreleased items in done/ folder
[ ] Verify tag pushed to origin: git tag -l vX.Y.Z
[ ] Archive: work/done/*.md → history/releases/{product}/vX.Y.Z/
[ ] Update CLAUDE.md if architecture/standards changed
[ ] Update roadmap.md status for completed work items

Note: README.md and other docs reference PROJECT-STATUS.md, so no updates needed there.
```

---

## Emergency Override: When to Interrupt Current Work

### Scenario 1: Customer-Reported Critical Issue

**Criteria:**
- System is completely broken for customer
- Data loss or corruption risk
- Security vulnerability
- Production workflow blocked

**Action:**
```powershell
# 1. Pause current work (commit WIP)
git add .
git commit -m "WIP: Pausing for critical customer issue"

# 2. Create hotfix branch from main
git checkout main
git checkout -b hotfix/customer-critical-issue

# 3. Fix, test, release as PATCH
# ... fix code ...
git commit -m "Fix: Critical issue description"
git checkout main
git merge hotfix/customer-critical-issue
git tag -a v1.2.4 -m "Hotfix: Critical customer issue"
git push origin main --tags

# 4. Resume paused work
git checkout feature/original-work
```

### Scenario 2: Blocker for Current Work

**Criteria:**
- Bug discovered that blocks progress on current feature
- Cannot complete current work without fixing it first
- The bug is in existing code, not new code

**Action:**
```powershell
# 1. Commit current feature work (WIP state)
git add .
git commit -m "WIP: Blocked by Write-JobLog issue"

# 2. Create bugfix branch from main
git checkout main
git checkout -b bugfix/write-joblog-blocker

# 3. Fix the blocker, test, release as PATCH
# ... fix code ...
git commit -m "Fix: Write-JobLog blocker"
git checkout main
git merge bugfix/write-joblog-blocker
git tag -a v1.2.4 -m "Bugfix: Write-JobLog exception"
git push origin main --tags

# 4. Rebase feature branch on updated main
git checkout feature/original-work
git rebase main
# ... continue feature work ...
```

---

## Handling Merge Conflicts

**If bugfix and feature touch same files:**

```powershell
# After shipping bugfix (now on main)
git checkout feature/my-feature

# Rebase feature onto updated main
git rebase main

# Resolve conflicts if any
# Edit conflicted files
git add <resolved-files>
git rebase --continue

# Continue feature work with bugfix incorporated
```

**Best Practice:** Keep changes focused and small to minimize conflict risk.

---

## CHANGELOG Discipline

### Update Process

**During Development:**
- DO NOT update CHANGELOG.md yet
- Keep notes in your feature/bugfix planning document
- Document what changed, what was added, what was fixed

**At Release Time:**
- Update CHANGELOG.md in a single operation
- Move [Unreleased] to new version section
- Add all changes from your notes
- Update Version History table
- Reset [Unreleased] to "None"
- Commit CHANGELOG with release commit
- Tag immediately after

**Example - Feature Planning Doc Notes:**
```markdown
## Changes for CHANGELOG
- Added: CATIA Downward Compatibility template
  - Pre-flight validation for CATSTART
  - Support for environment configuration
  - Test manifests included
```

**Then at release, update CHANGELOG.md:**
```markdown
## [Unreleased]
### Added
- None
...

## [1.2.0] - 2025-11-26
### Added
- CATIA Downward Compatibility template
  - Pre-flight validation for CATSTART
  - Support for environment configuration
  - Test manifests included
```

### Standard Change Categories

Use these categories in CHANGELOG:

- **Added** - New features or capabilities
- **Changed** - Changes to existing functionality
- **Fixed** - Bug fixes
- **Deprecated** - Features that will be removed in future versions
- **Removed** - Features that have been removed
- **Security** - Security vulnerability fixes or improvements

---

## Multiple Work Items Warning

**RULE: Never work on a new issue without a formal plan.**

**Trigger:** If more than one feature, bugfix, or blocker is in progress:

```
⚠️ WARNING: Multiple work items detected:
  - feature/catia-template (in progress)
  - bugfix/scheduler-summary (in progress)

REQUIRED ACTION:
1. Stop and review current state
2. Decide priority:
   - Complete one item first? Which one?
   - Is one blocking the other?
   - Should one be put on hold?
3. Document decision in session history
4. Return to ONE active work item
```

**Claude's Responsibility:** Remind Gary whenever detecting multiple active work items.

---

## Work Item Planning Requirements

Before starting ANY new feature, bugfix, or blocker:

### 1. Create Planning Document

**Features:** `project-hub/plans/features/feature-<name>.md`
**Bugfixes:** `project-hub/plans/bugfixes/bugfix-<name>-YYYY-MM-DD.md`
**Blockers:** `project-hub/plans/blockers/blocker-<name>.md`

### 2. Required Content

- **Problem/Goal Statement:** What are we solving/building?
- **Scope:** What's in/out of scope?
- **Technical Approach:** How will we do it?
- **Version Impact:** MAJOR/MINOR/PATCH and why?
- **Testing Plan:** How will we verify it works?
- **Files Affected:** Which files will change?
- **CHANGELOG Notes:** Keep running notes of changes for CHANGELOG entry at release

### 3. Get Approval

- Discuss plan with Gary
- Adjust based on feedback
- Document final approach
- THEN start coding

---

## Example Workflow: Feature Development

**Scenario:** Add CATIA template support

### Phase 1: Planning

```powershell
# 1. Create planning document
New-Item "project-hub/plans/features/feature-catia-template.md"

# 2. Document approach (use template)
# ... write feature plan ...

# 3. Discuss with Gary, get approval
```

### Phase 2: Development

```powershell
# 1. Create feature branch
git checkout main
git pull
git checkout -b feature/catia-template

# 2. Implement feature
# ... code changes ...
git add .
git commit -m "Add CATIA template with pre-flight validation"

# 3. Test thoroughly
.\scripts\New-JobsFromManifest.ps1 -ManifestPath "manifests\test-catdwc-manifest.json"
.\scripts\Start-JobScheduler.ps1
# ... verify all works ...

# 4. Document changes in feature planning doc
# Keep notes of what changed for CHANGELOG later
```

### Phase 3: Release

```powershell
# 1. Final pre-release checks
# [ ] Tests pass
# [ ] Docs updated

# 2. Merge feature branch to main
git checkout main
git merge feature/catia-template

# 3. Update CHANGELOG.md
# - Move [Unreleased] to new version section [1.2.0] - 2025-11-26
# - Add changes based on notes from feature doc
# - Update Version History table
# - Reset [Unreleased] to "None"

# 4. Commit CHANGELOG
git add CHANGELOG.md
git commit -m "Release v1.2.0: CATIA template support"

# 5. Tag release
git tag -a v1.2.0 -m "Feature: CATIA Downward Compatibility template"

# 6. Push
git push origin main --tags

# 7. Cleanup
git branch -d feature/catia-template

# 8. Archive feature doc
Move-Item "project-hub/plans/features/feature-catia-template.md" `
          "project-hub/history/feature-catia-template-complete.md"
```

---

## Example Workflow: Critical Hotfix

**Scenario:** Customer reports scheduler crashes on exit

### Immediate Response

```powershell
# 1. Currently working on feature/reporting-dashboard
git add .
git commit -m "WIP: Pausing for critical customer issue"

# 2. Create hotfix branch
git checkout main
git checkout -b hotfix/scheduler-crash-on-exit

# 3. Quick bugfix doc (abbreviated for hotfixes)
# project-hub/plans/bugfixes/bugfix-scheduler-crash-2025-11-26.md
```

### Fix and Ship

```powershell
# 1. Reproduce and fix
# ... debug ...
# ... fix code ...
git commit -m "Fix: Scheduler crash on exit - null reference in cleanup"

# 2. Test fix
.\scripts\Start-JobScheduler.ps1
# ... verify crash is gone ...

# 3. Update CHANGELOG
# [Unreleased] -> [1.2.1] - 2025-11-26
# Added to "Fixed" section

# 4. Merge and release
git checkout main
git merge hotfix/scheduler-crash-on-exit
git tag -a v1.2.1 -m "Hotfix: Scheduler crash on exit"
git push origin main --tags

# 5. Cleanup
git branch -d hotfix/scheduler-crash-on-exit
```

### Resume Original Work

```powershell
# 1. Update feature branch with hotfix
git checkout feature/reporting-dashboard
git rebase main  # Incorporates the hotfix

# 2. Continue feature work
# ... continue coding ...
```

---

## Issue Response Process

When an issue is discovered—whether during development, testing, or after release—follow this structured process: **triage → assess → decide → resolve**.

### Process Overview

```
Issue Discovered
      ↓
Phase 1: Severity Triage
      ↓
Phase 2: Impact Assessment
      ↓
   ┌─────────────────────────────────────┐
   │ Does issue have roots in a          │
   │ previous release?                   │
   │                                     │
   │  YES → Release Impact Analysis      │
   │        (conflicts, rollback viable?)│
   │                                     │
   │  NO  → Current-state assessment     │
   │        (simpler, no release checks) │
   └─────────────────────────────────────┘
      ↓
Phase 3: Decision
      ↓
Phase 4: Resolution
```

---

### Phase 1: Severity Triage

**Immediate questions when an issue is discovered:**

| Question | Purpose |
|----------|---------|
| What is broken? | Understand the symptom |
| Who is affected? | Scope of impact |
| Is data at risk? | Determines urgency |
| When did it start? | Helps identify root cause |
| Is there a workaround? | Buys time for proper fix |

**Severity Levels:**

| Level | Criteria | Response |
|-------|----------|----------|
| **Critical** | System down, data loss, security breach | Immediate action |
| **High** | Major feature broken, no workaround | Same day |
| **Medium** | Feature degraded, workaround exists | Next planned work |
| **Low** | Minor issue, cosmetic, edge case | Backlog |

**After triage, proceed to Impact Assessment for Critical/High issues.**

---

### Phase 2: Impact Assessment

**Before deciding HOW to fix, understand WHAT is affected.**

#### Step 1: Identify the Root Cause Location

- Is the issue in current uncommitted work?
- Is it in the current branch but committed?
- Does it trace back to a previous release?

#### Step 2: Scope the Affected Code

```powershell
# What files contain the problematic code?
# What functions are involved?
# What other code depends on the affected code?
```

#### Step 3: Release Impact Analysis (When Applicable)

**Skip this step if the issue is contained to current unreleased work.**

When the issue has roots in a previous release:

```powershell
# What releases exist?
git tag --sort=-version:refname | head -10

# What changed in the problematic release?
git log v1.0.0..v1.1.0 --oneline
git diff --name-only v1.0.0..v1.1.0

# What changed in subsequent releases?
git diff --name-only v1.1.0..HEAD
```

#### Step 4: Conflict Analysis (When Releases Involved)

For files changed in multiple releases, examine at function level:

```powershell
# Detailed changes in the problematic release
git diff v1.0.0..v1.1.0 -- path/to/file.ps1

# Changes in subsequent releases to the same file
git diff v1.1.0..HEAD -- path/to/file.ps1
```

Identify:
- Which functions were modified in each release
- Line ranges affected
- Whether the same function was modified by multiple releases (conflict risk)
- Call dependencies between modified functions

#### Step 5: Check for Non-Revertible Changes (When Releases Involved)

- [ ] Data format or schema changes?
- [ ] Database migrations?
- [ ] External API contract changes?
- [ ] Configuration format changes?
- [ ] Files deleted or renamed?

These may require fix-forward regardless of code analysis.

#### Assessment Report Template

```markdown
## Issue Impact Assessment

**Date:** YYYY-MM-DD
**Issue:** [Brief description]
**Severity:** [Critical/High/Medium/Low]
**Discovery point:** [Development/Testing/Post-release]
**Root cause location:** [Current work / Branch / Release vX.Y.Z]

### Affected Code
| File | Functions/Lines | Impact |
|------|-----------------|--------|
| src/example.ps1 | Function-Name (40-95) | [Description] |

### Release Impact (if applicable)
- **Problematic release:** vX.Y.Z (released YYYY-MM-DD)
- **Subsequent releases:** [list or "none"]
- **Conflicts detected:** [Yes/No - details]

### Non-Revertible Changes
- [ ] Data/schema changes: [Yes/No]
- [ ] External API changes: [Yes/No]
- [ ] File renames/deletes: [Yes/No]

### Recommendation
[ ] Fix in current branch (issue contained to current work)
[ ] Fix forward (bugfix branch)
[ ] Rollback (clean revert viable)
[ ] Hotfix (critical severity)
```

---

### Phase 3: Decision Matrix

**Use assessment findings to choose resolution path:**

| Discovery Point | Severity | Assessment Finding | Path |
|-----------------|----------|-------------------|------|
| Current work | Any | Issue in uncommitted code | **Fix in place** |
| Current branch | Any | Issue in branch commits | **Fix in branch** |
| Post-release | Critical | Any | **Hotfix** |
| Post-release | High | Clean rollback viable | **Rollback** |
| Post-release | High | Conflicts exist | **Fix Forward** |
| Post-release | High | Simple fix | **Fix Forward** |
| Post-release | Medium/Low | Any | **Fix Forward** (scheduled) |
| Any | Any | Data/schema changes involved | **Fix Forward** |

**Decision tree for released issues:**

```
Is severity Critical?
  ↓ YES → HOTFIX (immediate)
  ↓ NO
      ↓
Is rollback clean? (no conflicts, no data changes, recent release)
  ↓ YES                           ↓ NO
  Is fix simpler than rollback?   → FIX FORWARD
    ↓ YES → FIX FORWARD
    ↓ NO  → ROLLBACK
```

---

### Phase 4: Resolution Paths

#### Path A: Fix in Current Work

**When to use:** Issue discovered in uncommitted or current-branch work.

Simply fix the code and continue. No special process needed.

---

#### Path B: Fix Forward (Bugfix Branch)

**When to use:** Issue in released code; rollback not viable or fix is simpler.

```powershell
# 1. Create work item (BUG type)
# project-hub/work/doing/BUG-NNN-description.md

# 2. Create bugfix branch
git checkout main
git pull
git checkout -b bugfix/NNN-brief-description

# 3. Implement the fix
git add .
git commit -m "Fix: [description]"

# 4. Test thoroughly

# 5. Merge and release
git checkout main
git merge bugfix/NNN-brief-description

# 6. Release as PATCH version

# 7. Cleanup
git branch -d bugfix/NNN-brief-description
```

---

#### Path C: Rollback

**When to use:** Issue in released code; clean rollback viable and faster than fixing.

**Prerequisites:**
- Issue traced to a specific release
- No subsequent releases modified the same code (or conflicts manageable)
- No data/schema changes involved

**Branch strategy:** Always use a dedicated rollback branch—never revert directly on main.

```powershell
# 1. Create work item (BUG type)
# project-hub/work/doing/BUG-NNN-rollback-description.md

# 2. Create rollback branch
git checkout main
git pull
git checkout -b rollback/vX.Y.Z-brief-reason

# 3. Perform the revert
# Single commit:
git revert <commit-hash>

# Multiple commits (single revert commit):
git revert <oldest>^..<newest> --no-commit
git commit -m "Revert: vX.Y.Z - [reason]"

# 4. Resolve conflicts if any (use assessment report)

# 5. Test thoroughly
# - Run all tests
# - Verify original issue is resolved
# - Verify later release functionality still works

# 6. If tests pass: merge and release
git checkout main
git merge rollback/vX.Y.Z-brief-reason

# 7. Release as PATCH version

# 8. Cleanup
git branch -d rollback/vX.Y.Z-brief-reason
```

**If rollback fails:** Abandon branch, switch to Fix Forward.

```powershell
git checkout main
git branch -D rollback/vX.Y.Z-brief-reason
# Create bugfix branch instead
```

**Important:**
- Keep original release tag (don't delete—it's history)
- Original work items stay archived (don't move back)

##### Rollback Limitations

**Practical rollback window:** Generally the most recent release only.

Rolling back older releases is complex because:
- Later releases may depend on the changes (function-level conflicts)
- Git conflicts increase with each subsequent release
- Data changes cannot be reverted by code rollback

**Rollback is NOT viable when:**
- Multiple subsequent releases modified the same functions
- Data migrations or schema changes occurred
- External systems integrated with the changed behavior
- Files were deleted or renamed in later releases

---

#### Path D: Hotfix (Critical/Emergency)

**When to use:** Critical severity—system down, data at risk, security issue.

**Key difference:** Speed over process. Abbreviated assessment, immediate action.

```powershell
# 1. If other work in progress, pause it
git add .
git commit -m "WIP: Pausing for critical issue"

# 2. Create hotfix branch from main
git checkout main
git pull
git checkout -b hotfix/critical-description

# 3. Minimal assessment
# - What's the most likely cause?
# - What's the smallest change that fixes it?

# 4. Implement fix (or revert if faster)
git commit -m "Hotfix: [description]"

# 5. Test the critical path

# 6. Merge and release immediately
git checkout main
git merge hotfix/critical-description
git tag -a vX.Y.Z -m "Hotfix: [description]"
git push origin main --tags

# 7. Create/complete work item

# 8. Resume paused work
git checkout feature/original-work
git rebase main
```

**Post-hotfix:**
- Full assessment of what went wrong
- Determine if additional fixes needed
- Update tests to catch similar issues

---

### Version Numbering for Issue Resolution

| Resolution Path | Version Bump | Example |
|-----------------|--------------|---------|
| Fix Forward | PATCH | v1.1.0 → v1.1.1 |
| Rollback | PATCH | v1.1.0 → v1.1.1 |
| Hotfix | PATCH | v1.1.0 → v1.1.1 |
| Any (behavior changes significantly) | MINOR | v1.1.0 → v1.2.0 |

**Rule:** Always move version forward—never reuse or delete version numbers.

---

### CHANGELOG Formats

**For Fix Forward:**
```markdown
## [1.1.1] - 2026-01-23

### Fixed
- [Description of fix] - resolves issue introduced in v1.1.0
```

**For Rollback:**
```markdown
## [1.1.1] - 2026-01-23

### Removed
- Reverts v1.1.0: [Feature name] - [Reason for rollback]
```

**For Hotfix:**
```markdown
## [1.1.1] - 2026-01-23

### Fixed
- **HOTFIX:** [Critical issue description]
```

---

### Test Scenario: Practice the Full Process

Use this scenario to practice the issue response process on a simple application.

#### Setup: Create a Simple Test App

```powershell
mkdir rollback-test
cd rollback-test
git init
mkdir src
```

**Create `src/calculator.ps1`:**

```powershell
# Simple calculator module

function Add-Numbers {
    param([int]$a, [int]$b)
    return $a + $b
}

function Subtract-Numbers {
    param([int]$a, [int]$b)
    return $a - $b
}

function Get-Version {
    return "1.0.0"
}
```

**Create `src/formatter.ps1`:**

```powershell
# Output formatter

function Format-Result {
    param([string]$operation, [int]$result)
    return "$operation = $result"
}
```

**Create `test.ps1`:**

```powershell
# Basic tests
. ./src/calculator.ps1
. ./src/formatter.ps1

$pass = 0
$fail = 0

# Test Add
$result = Add-Numbers -a 2 -b 3
if ($result -eq 5) { $pass++; Write-Host "PASS Add-Numbers" }
else { $fail++; Write-Host "FAIL Add-Numbers: expected 5, got $result" }

# Test Subtract
$result = Subtract-Numbers -a 5 -b 3
if ($result -eq 2) { $pass++; Write-Host "PASS Subtract-Numbers" }
else { $fail++; Write-Host "FAIL Subtract-Numbers: expected 2, got $result" }

# Test Format
$result = Format-Result -operation "2 + 3" -result 5
if ($result -eq "2 + 3 = 5") { $pass++; Write-Host "PASS Format-Result" }
else { $fail++; Write-Host "FAIL Format-Result: expected '2 + 3 = 5', got '$result'" }

Write-Host "`nResults: $pass passed, $fail failed"
if ($fail -gt 0) { exit 1 }
```

**Initial commit and release:**

```powershell
git add .
git commit -m "Initial release: basic calculator"
git tag -a v1.0.0 -m "Initial release"
```

---

#### Release v1.1.0: Add Multiply (with a bug)

```powershell
git checkout -b feature/multiply
```

**Edit `src/calculator.ps1`—add multiply function WITH A BUG:**

```powershell
function Multiply-Numbers {
    param([int]$a, [int]$b)
    return $a + $b  # BUG: should be $a * $b
}

function Get-Version {
    return "1.1.0"
}
```

**Add test to `test.ps1`:**

```powershell
# Test Multiply
$result = Multiply-Numbers -a 3 -b 4
if ($result -eq 12) { $pass++; Write-Host "PASS Multiply-Numbers" }
else { $fail++; Write-Host "FAIL Multiply-Numbers: expected 12, got $result" }
```

```powershell
git add .
git commit -m "Add multiply function"
git checkout main
git merge feature/multiply
git tag -a v1.1.0 -m "Feature: multiply support"
git branch -d feature/multiply
```

---

#### Release v1.2.0: Improve Formatter (independent change)

```powershell
git checkout -b feature/formatter-v2
```

**Edit `src/formatter.ps1`:**

```powershell
function Format-Result {
    param([string]$operation, [int]$result)
    return "Result: $operation = $result"  # Added "Result: " prefix
}

function Format-Error {
    param([string]$message)
    return "Error: $message"
}
```

**Update test in `test.ps1`:**

```powershell
# Test Format (updated expectation)
$result = Format-Result -operation "2 + 3" -result 5
if ($result -eq "Result: 2 + 3 = 5") { $pass++; Write-Host "PASS Format-Result" }
else { $fail++; Write-Host "FAIL Format-Result" }
```

```powershell
git add .
git commit -m "Improve formatter with prefix and error function"
git checkout main
git merge feature/formatter-v2
git tag -a v1.2.0 -m "Feature: improved formatter"
git branch -d feature/formatter-v2
```

---

#### Exercise: Issue Reported

**Report:** "Multiply function returns wrong results. 3 × 4 returns 7 instead of 12."

**Practice the full process:**

1. **Triage:** What's the severity? (High—major feature broken)

2. **Assessment:**
   ```powershell
   # What changed in v1.1.0?
   git diff --name-only v1.0.0..v1.1.0

   # What changed after?
   git diff --name-only v1.1.0..v1.2.0

   # Conflict check on calculator.ps1
   git diff v1.1.0..v1.2.0 -- src/calculator.ps1
   ```

3. **Decision:** Rollback or fix forward?
   - v1.2.0 didn't touch calculator.ps1 → rollback is clean
   - But fix is one character (`+` → `*`) → fix forward is simpler

4. **Resolution:** Try both paths to practice:

   **Fix Forward:**
   ```powershell
   git checkout -b bugfix/001-multiply-wrong-result
   # Fix: change $a + $b to $a * $b
   ./test.ps1  # Verify
   git add . && git commit -m "Fix: Multiply was adding instead of multiplying"
   git checkout main && git merge bugfix/001-multiply-wrong-result
   git tag -a v1.2.1 -m "Bugfix: multiply calculation"
   ```

   **Rollback (reset first to try):**
   ```powershell
   git reset --hard v1.2.0
   git checkout -b rollback/v1.1.0-multiply-bug
   git log --oneline  # Find multiply commit
   git revert <hash>
   ./test.ps1  # Verify (multiply test gone)
   git checkout main && git merge rollback/v1.1.0-multiply-bug
   ```

---

#### Advanced Exercise: Force a Conflict

Reset and create v1.2.0 that ALSO modifies calculator.ps1:

```powershell
git reset --hard v1.1.0

git checkout -b feature/divide
```

**Add to `src/calculator.ps1`:**

```powershell
function Divide-Numbers {
    param([int]$a, [int]$b)
    if ($b -eq 0) { throw "Cannot divide by zero" }
    return $a / $b
}
```

Now rollback of v1.1.0 will conflict with v1.2.0's changes to the same file. Run the assessment to see how conflicts are detected.

---

#### Cleanup

```powershell
cd ..
Remove-Item -Recurse -Force rollback-test
```

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2025-11-26 | Initial workflow established |

---

## Related Documents

- [workflow-guide.md](../collaboration/workflow-guide.md) - Work item lifecycle and kanban process
- [CHANGELOG.md](../../CHANGELOG.md) - Version history
- [PROJECT-STATUS.md](../../PROJECT-STATUS.md) - Current status
- [coding-standards.md](coding-standards.md) - Code quality standards
- [documentation-standards.md](documentation-standards.md) - Doc formatting
- [FEATURE-TEMPLATE.md](../templates/FEATURE-TEMPLATE.md) - Feature planning template
- [BUGFIX-TEMPLATE.md](../templates/BUGFIX-TEMPLATE.md) - Bugfix planning template
- [SPIKE-TEMPLATE.md](../templates/SPIKE-TEMPLATE.md) - Spike/investigation template

---

**Last Updated:** 2026-01-26
**Next Review:** When process issues arise or after 5 releases

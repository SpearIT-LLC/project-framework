# Version Control & Release Workflow

**Version:** 1.0.0
**Created:** 2025-11-26
**Status:** Active Process Standard

---

## Core Principle

**ONE work item at a time.** Work on a single feature, bugfix, or blocker from planning through release.

**Workflow Integration:** This document describes the git/release process. See [kanban-workflow.md](kanban-workflow.md) for the complete work item lifecycle (planning → backlog → todo → doing → done → release → archive).

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

**Rule:** One release per completed issue. Don't batch multiple changes.

### Release Checklist

```markdown
Pre-Release:
[ ] All tests pass
[ ] Feature/bugfix branch merged to main
[ ] Work item moved to work/done/ (triggers this process)
[ ] Work item has CHANGELOG notes section

Determine Version:
[ ] Read work item metadata:
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
    [ ] Add changes from work item CHANGELOG notes
    [ ] Update Version History table
    [ ] Reset [Unreleased] sections to "None"
[ ] Commit both: git commit -m "Release vX.Y.Z: Description"
[ ] Create git tag: git tag -a vX.Y.Z -m "Description"
[ ] Push with tags: git push origin main --tags
[ ] Delete feature/bugfix branch: git branch -d feature/NNN-name

Post-Release:
[ ] Verify tag pushed to origin: git tag -l vX.Y.Z
[ ] Archive: work/done/[item].md → history/releases/vX.Y.Z/[item].md
[ ] Update CLAUDE.md if architecture/standards changed
[ ] Update roadmap.md status for this work item

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

**Features:** `thoughts/plans/features/feature-<name>.md`
**Bugfixes:** `thoughts/plans/bugfixes/bugfix-<name>-YYYY-MM-DD.md`
**Blockers:** `thoughts/plans/blockers/blocker-<name>.md`

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
New-Item "thoughts/plans/features/feature-catia-template.md"

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
Move-Item "thoughts/plans/features/feature-catia-template.md" `
          "thoughts/history/feature-catia-template-complete.md"
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
# thoughts/plans/bugfixes/bugfix-scheduler-crash-2025-11-26.md
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

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2025-11-26 | Initial workflow established |

---

## Related Documents

- [kanban-workflow.md](kanban-workflow.md) - Work item lifecycle and kanban process
- [CHANGELOG.md](../../CHANGELOG.md) - Version history
- [PROJECT-STATUS.md](../../PROJECT-STATUS.md) - Current status
- [coding-standards.md](coding-standards.md) - Code quality standards
- [documentation-standards.md](documentation-standards.md) - Doc formatting
- [FEATURE-TEMPLATE.md](../templates/FEATURE-TEMPLATE.md) - Feature planning template
- [BUGFIX-TEMPLATE.md](../templates/BUGFIX-TEMPLATE.md) - Bugfix planning template
- [SPIKE-TEMPLATE.md](../templates/SPIKE-TEMPLATE.md) - Spike/investigation template

---

**Last Updated:** 2025-12-18
**Next Review:** When process issues arise or after 5 releases

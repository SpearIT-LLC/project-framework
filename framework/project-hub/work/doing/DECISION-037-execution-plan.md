# Execution Plan: Move project-hub to Repository Root

**Work Item:** DECISION-037
**Created:** 2026-02-05
**Status:** Pre-execution (awaiting post-release)

---

## Overview

Move `framework/project-hub/` to `project-hub/` at repository root to separate framework (product) from project management (meta-context).

**Rationale:** This repository is both:
- The framework source (product in `framework/`)
- A project using the framework (dogfooding)

Moving project-hub to root clarifies: "This is the repo's project management, separate from the framework being developed."

---

## Impact Summary

- **Breaking Change:** YES (MAJOR version bump required)
- **Files to Update:** ~50-60 files
- **Git History:** Preserved via `git mv`
- **Testing Required:** All PowerShell tools and skills

---

## Pre-Execution Prerequisites

- [x] Release current items in done/ (blocks this work)
- [x] Decision documented in DECISION-037
- [x] Impact analysis complete
- [ ] Backup/branch created (execute during implementation)

---

## Execution Steps

### Phase 1: Preparation

#### 1.1 Create Working Branch
```bash
git checkout -b feat/move-project-hub-to-root
```

#### 1.2 Verify Clean State
```bash
git status  # Should be clean after release
```

#### 1.3 Document Current Structure
```bash
tree framework/project-hub -L 2 > pre-move-structure.txt
```

---

### Phase 2: Execute Move

#### 2.1 Move Directory (Preserves Git History)
```bash
git mv framework/project-hub project-hub
```

#### 2.2 Verify Move
```bash
# Check that directory moved
ls project-hub/

# Check that git tracked the rename
git status
```

---

### Phase 3: Update File References

**Strategy:** Update files in logical groups, commit incrementally for safety.

#### 3.1 Root Documentation (2 files)

**Files:**
- `CLAUDE.md`
- `QUICK-START.md`

**Search/Replace:**
- `framework/project-hub/` → `project-hub/`

**Changes:**
- CLAUDE.md: Update bootstrap block, structure diagram
- QUICK-START.md: Update any path references

**Commit:**
```bash
git add CLAUDE.md QUICK-START.md
git commit -m "docs: Update root docs for project-hub move"
```

---

#### 3.2 Framework Core Documentation (8 files)

**Files:**
- `framework/CLAUDE.md`
- `framework/docs/collaboration/workflow-guide.md`
- `framework/docs/collaboration/architecture-guide.md`
- `framework/docs/collaboration/troubleshooting-guide.md`
- `framework/docs/REPOSITORY-STRUCTURE.md`
- `framework/docs/PROJECT-STRUCTURE.md`
- `framework/docs/ref/framework-commands.md`
- `framework/docs/process/distribution-build-checklist.md`

**Search/Replace:**
- `framework/project-hub/` → `project-hub/`

**Special attention:**
- Structure diagrams need ASCII tree updates
- Example paths in documentation
- Links using markdown format

**Commit:**
```bash
git add framework/docs/
git add framework/CLAUDE.md
git commit -m "docs(framework): Update docs for project-hub move"
```

---

#### 3.3 Skills - Root Commands (11 files)

**Files in `.claude/commands/`:**
- `fw-status.md`
- `fw-backlog.md`
- `fw-move.md`
- `fw-session-history.md`
- `fw-roadmap.md`
- `fw-next-id.md`
- `fw-wip.md`
- `fw-help.md`
- `fw-topic-index.md`
- Plus any others

**Search/Replace:**
- `framework/project-hub/` → `project-hub/`
- Check for hardcoded paths in:
  - Data sources sections
  - Example paths
  - Implementation notes

**Commit:**
```bash
git add .claude/commands/
git commit -m "feat(skills): Update skill paths for project-hub move"
```

---

#### 3.4 Skills - Template Commands (11 files)

**Files in `templates/starter/.claude/commands/`:**
- Same files as 3.3, but in template package

**Search/Replace:**
- `framework/project-hub/` → `project-hub/`

**Note:** These are what users will copy, so CRITICAL to update correctly.

**Commit:**
```bash
git add templates/starter/.claude/commands/
git commit -m "feat(templates): Update template skills for project-hub move"
```

---

#### 3.5 PowerShell Tools (5 files)

**Files:**
- `framework/tools/FrameworkWorkflow.psm1`
- `framework/tools/Get-BacklogItems.ps1`
- `framework/tools/Get-WorkflowStatus.ps1`
- `framework/tools/Move-WorkItem.ps1`
- `.claude/hooks/Validate-WorkItems.ps1`

**Search/Replace:**
- `framework/project-hub/` → `project-hub/`
- Check for path construction logic
- Verify relative path assumptions

**Testing Required:** Each script must be tested after update.

**Commit:**
```bash
git add framework/tools/ .claude/hooks/
git commit -m "feat(tools): Update PowerShell tools for project-hub move"
```

---

#### 3.6 Build Scripts (1 file)

**File:**
- `tools/Build-FrameworkArchive.ps1`

**Changes:**
- Update any references to framework/project-hub/
- Check if build script includes project-hub in archive (it shouldn't)
- Verify exclusion logic still works

**Commit:**
```bash
git add tools/Build-FrameworkArchive.ps1
git commit -m "build: Update archive script for project-hub move"
```

---

#### 3.7 Template Documentation (10-15 files)

**Files in `templates/starter/`:**
- `CLAUDE.md`
- `README.md`
- `INDEX.md`
- `PROJECT-STATUS.md`
- `QUICK-START.md`
- `framework/CLAUDE.md` (template copy)
- Plus others in `templates/starter/framework/docs/`

**Search/Replace:**
- `framework/project-hub/` → `project-hub/`

**Commit:**
```bash
git add templates/starter/
git commit -m "feat(templates): Update template docs for project-hub move"
```

---

#### 3.8 Active Work Items (5-10 files)

**Files in `project-hub/work/`:**
- Scan all folders (backlog, todo, doing) for references
- Notable ones:
  - `FEAT-093-planning-period-archival.md` (mentions project-hub structure)
  - `DECISION-037-project-hub-location.md` (this decision!)
  - `TECH-098-auto-branching-strategy.md`
  - Others as found

**Search/Replace:**
- `framework/project-hub/` → `project-hub/`

**Note:** Session histories in `project-hub/history/sessions/` are historical - leave as-is.

**Commit:**
```bash
git add project-hub/work/
git commit -m "docs(work-items): Update active work items for new structure"
```

---

#### 3.9 Update DECISION-037 Itself

**File:**
- `project-hub/work/doing/DECISION-037-project-hub-location.md`

**Changes:**
- Update Status to "Completed"
- Add Completed date
- Add implementation notes section
- Document final decision and rationale
- Check all acceptance criteria

**Commit:**
```bash
git add project-hub/work/doing/DECISION-037-project-hub-location.md
git commit -m "docs(DECISION-037): Document final decision and implementation"
```

---

### Phase 4: Testing

#### 4.1 Test PowerShell Tools
```powershell
# Test each script
.\framework\tools\Get-WorkflowStatus.ps1
.\framework\tools\Get-BacklogItems.ps1
.\framework\tools\Move-WorkItem.ps1 -ItemId "TEST-001" -TargetFolder "backlog" -WhatIf

# Test hooks (if applicable)
.\.claude\hooks\Validate-WorkItems.ps1
```

#### 4.2 Test Skills
```bash
# Test each skill via Claude Code
/fw-status
/fw-backlog
/fw-wip
/fw-next-id
```

#### 4.3 Verify File Structure
```bash
# Verify project-hub at root
ls project-hub/

# Verify framework/project-hub/ is gone
ls framework/  # Should NOT have project-hub/

# Check git history preserved
git log --follow project-hub/work/doing/ | head -20
```

#### 4.4 Test Build Process
```powershell
# Run build script
.\tools\Build-FrameworkArchive.ps1 -Version "test-build"

# Verify archive structure
# Extract and check that project-hub is NOT included (it's repo-specific)
```

---

### Phase 5: Documentation Updates

#### 5.1 Update CHANGELOG.md

Add entry for breaking change:

```markdown
## [Unreleased]

### BREAKING CHANGES

#### project-hub/ Moved to Repository Root

**Change:** `framework/project-hub/` → `project-hub/`

**Rationale:**
- Separates framework (product) from project management (meta-context)
- Clarifies that project-hub is for the repository, not part of the framework package
- Sets precedent: user projects have project-hub/ at root

**Migration for existing users:**

1. Move your project-hub:
   ```bash
   git mv framework/project-hub project-hub
   ```

2. Update `.claude/commands/` skills:
   - Find: `framework/project-hub/`
   - Replace: `project-hub/`

3. Update any custom scripts or tools that reference the old path

4. Update `CLAUDE.md` structure diagram if you have one

**Impact:** Skills, documentation, and tools now reference `project-hub/` directly.

**Related:** DECISION-037
```

#### 5.2 Update PROJECT-STATUS.md

Update version to next MAJOR (e.g., v5.0.0)

#### 5.3 Update DECISION-037

Move to done/ after testing complete.

---

### Phase 6: Final Commit & Merge

#### 6.1 Final Review
```bash
# Review all changes
git log --oneline origin/main..HEAD

# Check for any missed references
git grep "framework/project-hub" | grep -v "history/sessions"
```

#### 6.2 Create Summary Commit (Optional)
```bash
# If needed, create a summary commit that references all the changes
git commit --allow-empty -m "feat!: Move project-hub to root (DECISION-037)

BREAKING CHANGE: project-hub/ moved from framework/ to repository root.

This separates framework source (product) from project management (meta).

Impact:
- Updated ~50 files (skills, docs, tools, templates)
- All references now use project-hub/ instead of framework/project-hub/
- PowerShell tools and skills tested and verified
- Migration guide added to CHANGELOG.md

Closes: DECISION-037
Version: MAJOR bump required"
```

#### 6.3 Merge to Main
```bash
# Merge branch
git checkout main
git merge --no-ff feat/move-project-hub-to-root

# Tag the release
git tag -a v5.0.0 -m "Release v5.0.0: project-hub moved to root"

# Push
git push origin main --tags
```

---

## Verification Checklist

After completion, verify:

- [ ] `project-hub/` exists at repository root
- [ ] `framework/project-hub/` does NOT exist
- [ ] All skills work correctly (`/fw-status`, `/fw-backlog`, etc.)
- [ ] All PowerShell tools work correctly
- [ ] Build script produces correct archive
- [ ] `git log --follow project-hub/` shows full history
- [ ] No remaining references to `framework/project-hub/` (except in session histories)
- [ ] CHANGELOG.md documents breaking change
- [ ] PROJECT-STATUS.md shows new MAJOR version
- [ ] DECISION-037 moved to done/ and marked complete

---

## Rollback Plan

If issues are discovered:

```bash
# Rollback is simple - just revert the merge
git revert -m 1 <merge-commit-sha>

# Or reset if not pushed
git reset --hard origin/main
```

---

## Estimated Effort

- **Phase 1 (Prep):** 5 minutes
- **Phase 2 (Move):** 2 minutes
- **Phase 3 (Updates):** 30-45 minutes (search/replace across 50+ files)
- **Phase 4 (Testing):** 15-20 minutes
- **Phase 5 (Docs):** 10 minutes
- **Phase 6 (Merge):** 5 minutes

**Total: 1-1.5 hours**

---

## Notes

- **Session histories:** Leave historical records unchanged (they document what existed at the time)
- **Git history:** Using `git mv` preserves full history, accessible via `git log --follow`
- **Template impact:** Critical that template skills are updated - users copy these
- **Testing:** Don't skip PowerShell tool testing - path logic can be fragile

---

**Status:** Ready for execution after v5.0.0 release

**Last Updated:** 2026-02-05

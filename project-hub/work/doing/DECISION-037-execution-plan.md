# Execution Plan: Move project-hub to Repository Root

**Work Item:** DECISION-037
**Created:** 2026-02-05
**Updated:** 2026-02-05
**Completed:** 2026-02-05
**Status:** Execution Complete (testing pending)

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
- **Files to Update:** 33 files (excluding historical records)
- **Git History:** Preserved via `git mv`
- **Testing Required:** All PowerShell tools and skills
- **Approach:** File-by-file with validation

---

## Principles

**What we UPDATE:**
- Functional code (skills, tools, hooks, scripts)
- User navigation (CLAUDE.md, README files, templates)
- Active and backlog work items (prevent future confusion)

**What we NEVER UPDATE (historical records):**
- `framework/CHANGELOG.md` - Historical record of what WAS
- `framework/project-hub/history/sessions/` - Session histories
- `framework/project-hub/history/releases/` - Completed work items
- `framework/project-hub/research/` - Historical research notes

---

## Pre-Execution Prerequisites

- [x] Release current items in done/ (blocks this work)
- [x] Decision documented in DECISION-037
- [x] Impact analysis complete
- [x] File list finalized (33 files)
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
git status  # Should be clean
```

#### 1.3 Document Current Structure
```bash
# Create snapshot for reference
git log --oneline -10 > pre-move-commits.txt
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

#### 2.3 Commit Move
```bash
git commit -m "feat: Move project-hub to repository root

BREAKING CHANGE: project-hub/ moved from framework/ to root.

This separates framework source (product) from project management (meta).
All path references will be updated in subsequent commits.

Related: DECISION-037"
```

---

### Phase 3: Update Files (File-by-File with Validation)

**Strategy:** One file at a time. Edit → Validate → Commit → Next.

**Total files:** 33 (plus DECISION-037 itself)

#### Per-File Workflow Template

For each file in the list below:

```bash
# 1. EDIT: Update paths in file
#    Find: framework/project-hub/
#    Replace: project-hub/

# 2. REVIEW: Check changes
git diff <file>

# 3. VALIDATE: File-specific validation (see validation guide below)

# 4. COMMIT: Individual commit with context
git add <file>
git commit -m "<type>(<scope>): Update paths for project-hub move

File: <filename>
Changes: framework/project-hub/ → project-hub/"
```

---

#### Validation Guide by File Type

**PowerShell files (*.ps1, *.psm1):**
```powershell
# Syntax check
Get-Command <path-to-script> -Syntax
# Or run with -WhatIf if supported
```

**Markdown files (*.md):**
```bash
# Visual review for:
# - Broken structure/formatting
# - Link syntax issues
# - Code block formatting
# Just review the diff carefully
```

**Skills (.claude/commands/*.md):**
```bash
# Check markdown formatting
# Verify paths in "Data sources" section match
# Check example code blocks for path references
```

**Work items:**
```bash
# Visual review only
# Check that context makes sense with new paths
```

---

#### Priority 1: Functional Files (Will Break) - 10 files

**1. `.claude/commands/fw-session-history.md`**
- Update: Path construction logic
- Validate: Review diff for correct path references
- Commit: `feat(skills): Update fw-session-history paths for project-hub move`

**2. `.claude/hooks/Validate-WorkItems.ps1`**
- Update: Path construction in validation logic
- Validate: PowerShell syntax check
- Commit: `feat(hooks): Update Validate-WorkItems paths for project-hub move`

**3. `framework/tools/FrameworkWorkflow.psm1`**
- Update: Module path references
- Validate: PowerShell syntax check, test import
- Commit: `feat(tools): Update FrameworkWorkflow paths for project-hub move`

**4. `framework/tools/Get-BacklogItems.ps1`**
- Update: Backlog path construction
- Validate: Run with -WhatIf if available, or syntax check
- Commit: `feat(tools): Update Get-BacklogItems paths for project-hub move`

**5. `framework/tools/Get-WorkflowStatus.ps1`**
- Update: Status lookup paths
- Validate: Run with -WhatIf if available, or syntax check
- Commit: `feat(tools): Update Get-WorkflowStatus paths for project-hub move`

**6. `tools/Build-FrameworkArchive.ps1`**
- Update: Archive exclusion logic
- Validate: PowerShell syntax check
- Commit: `build: Update Build-FrameworkArchive paths for project-hub move`

**7. `templates/starter/.claude/commands/fw-backlog.md`**
- Update: Path references
- Validate: Markdown formatting check
- Commit: `feat(templates): Update fw-backlog paths for project-hub move`

**8. `templates/starter/.claude/commands/fw-next-id.md`**
- Update: Path references
- Validate: Markdown formatting check
- Commit: `feat(templates): Update fw-next-id paths for project-hub move`

**9. `templates/starter/.claude/commands/fw-session-history.md`**
- Update: Path construction logic
- Validate: Markdown formatting check
- Commit: `feat(templates): Update fw-session-history paths for project-hub move`

**10. `templates/starter/.claude/commands/fw-status.md`**
- Update: Path references
- Validate: Markdown formatting check
- Commit: `feat(templates): Update fw-status paths for project-hub move`

---

#### Priority 2: User Navigation - 10 files

**11. `CLAUDE.md`**
- Update: Bootstrap block, structure diagrams, navigation paths
- Validate: Check structure diagram formatting
- Commit: `docs: Update CLAUDE.md paths for project-hub move`

**12. `README.md`**
- Update: Any path references to project-hub
- Validate: Markdown formatting
- Commit: `docs: Update README paths for project-hub move`

**13. `framework/docs/ref/framework-commands.md`**
- Update: Command location references
- Validate: Markdown formatting
- Commit: `docs(framework): Update framework-commands paths for project-hub move`

**14. `templates/README.md`**
- Update: Template documentation paths
- Validate: Markdown formatting
- Commit: `docs(templates): Update templates README paths for project-hub move`

**15. `templates/starter/CLAUDE.md`**
- Update: Structure diagrams, navigation
- Validate: Check structure diagram formatting
- Commit: `feat(templates): Update starter CLAUDE.md paths for project-hub move`

**16. `templates/starter/INDEX.md`**
- Update: Index path references
- Validate: Markdown formatting
- Commit: `feat(templates): Update starter INDEX paths for project-hub move`

**17. `templates/starter/PROJECT-STATUS.md`**
- Update: Status file path references
- Validate: Markdown formatting
- Commit: `feat(templates): Update starter PROJECT-STATUS paths for project-hub move`

**18. `templates/starter/QUICK-START.md`**
- Update: Quick start path references
- Validate: Markdown formatting
- Commit: `feat(templates): Update starter QUICK-START paths for project-hub move`

**19. `templates/starter/README.md`**
- Update: Template readme path references
- Validate: Markdown formatting
- Commit: `feat(templates): Update starter README paths for project-hub move`

**20. `templates/starter/framework/docs/ref/framework-commands.md`**
- Update: Command references in template
- Validate: Markdown formatting
- Commit: `feat(templates): Update starter framework-commands paths for project-hub move`

---

#### Priority 3: Work Items (Prevent Future Confusion) - 13 files

**21. `project-hub/work/todo/FEAT-093-planning-period-archival.md`**
- Update: Work item path references
- Validate: Visual review of context
- Commit: `docs(work): Update FEAT-093 paths for project-hub move`

**22. `project-hub/work/backlog/DECISION-029-license-choice.md`**
- Update: Cross-references
- Validate: Visual review
- Commit: `docs(work): Update DECISION-029 paths for project-hub move`

**23. `project-hub/work/backlog/DECISION-035-root-status-reference.md`**
- Update: References
- Validate: Visual review
- Commit: `docs(work): Update DECISION-035 paths for project-hub move`

**24. `project-hub/work/backlog/DECISION-097-release-sizing-policy.md`**
- Update: References
- Validate: Visual review
- Commit: `docs(work): Update DECISION-097 paths for project-hub move`

**25. `project-hub/work/backlog/FEAT-028-release-automation-script.md`**
- Update: Script path references
- Validate: Visual review
- Commit: `docs(work): Update FEAT-028 paths for project-hub move`

**26. `project-hub/work/backlog/FEAT-030-add-hold-folder.md`**
- Update: Folder path references
- Validate: Visual review
- Commit: `docs(work): Update FEAT-030 paths for project-hub move`

**27. `project-hub/work/backlog/FEAT-034-projects-showcase.md`**
- Update: References
- Validate: Visual review
- Commit: `docs(work): Update FEAT-034 paths for project-hub move`

**28. `project-hub/work/backlog/feature-007-validation-script.md`**
- Update: Script references
- Validate: Visual review
- Commit: `docs(work): Update feature-007 paths for project-hub move`

**29. `project-hub/work/backlog/TECH-027-cross-reference-convention.md`**
- Update: Convention references
- Validate: Visual review
- Commit: `docs(work): Update TECH-027 paths for project-hub move`

**30. `project-hub/work/backlog/TECH-033-status-field-redundancy.md`**
- Update: References
- Validate: Visual review
- Commit: `docs(work): Update TECH-033 paths for project-hub move`

**31. `project-hub/work/backlog/TECH-049-human-ai-work-handoff-policy.md`**
- Update: Policy references
- Validate: Visual review
- Commit: `docs(work): Update TECH-049 paths for project-hub move`

**32. `project-hub/work/backlog/TECH-097-document-artifacts-pattern.md`**
- Update: Pattern references
- Validate: Visual review
- Commit: `docs(work): Update TECH-097 paths for project-hub move`

**33. `project-hub/work/backlog/TECH-098-auto-branching-strategy.md`**
- Update: Strategy references
- Validate: Visual review
- Commit: `docs(work): Update TECH-098 paths for project-hub move`

---

### Phase 4: Update DECISION-037 Documents

**34. `project-hub/work/doing/DECISION-037-project-hub-location.md`**
- Update: Status to "Completed", add completion date
- Add: Implementation notes section
- Validate: Check all acceptance criteria marked
- Commit: `docs(DECISION-037): Mark decision as completed`

**35. `project-hub/work/doing/DECISION-037-execution-plan.md`**
- Update: Status to "Completed"
- Add: Execution completion notes
- Validate: Visual review
- Commit: `docs(DECISION-037): Mark execution plan as completed`

---

### Phase 5: Comprehensive Testing

#### 5.1 Test PowerShell Tools
```powershell
# Test each updated script
.\framework\tools\Get-WorkflowStatus.ps1
.\framework\tools\Get-BacklogItems.ps1

# Test hooks
.\.claude\hooks\Validate-WorkItems.ps1
```

#### 5.2 Test Skills (via Claude Code)
```bash
/fw-status
/fw-backlog
/fw-wip
/fw-session-history
```

#### 5.3 Verify File Structure
```bash
# Verify project-hub at root
ls project-hub/

# Verify framework/project-hub/ is gone
ls framework/  # Should NOT have project-hub/

# Check git history preserved
git log --follow project-hub/work/doing/ | head -20
```

#### 5.4 Test Build Process
```powershell
# Run build script to ensure it still works
.\tools\Build-FrameworkArchive.ps1 -Version "test-build"

# Verify project-hub is NOT included in archive (repo-specific)
```

#### 5.5 Final Path Check
```bash
# Check for any missed references (excluding historical)
git grep "framework/project-hub" | grep -v "history/" | grep -v "CHANGELOG.md"
# Should return no results
```

---

### Phase 6: Documentation & Finalization

#### 6.1 Add New CHANGELOG Entry

Create new section in `framework/CHANGELOG.md` for next release:

```markdown
## [Unreleased]

### BREAKING CHANGES

#### project-hub/ Moved to Repository Root

**Change:** `framework/project-hub/` → `project-hub/`

**Rationale:**
- Separates framework (product) from project management (meta-context)
- Clarifies that project-hub is for the repository, not part of framework package
- Establishes pattern: user projects should have project-hub/ at root

**Migration for existing users:**

1. Move your project-hub directory:
   ```bash
   git mv framework/project-hub project-hub
   ```

2. Update skill files in `.claude/commands/`:
   - Find: `framework/project-hub/`
   - Replace: `project-hub/`

3. Update any custom scripts/tools that reference the old path

4. Update `CLAUDE.md` structure diagram if present

**Impact:** All skills, documentation, and tools now reference `project-hub/` directly.

**Related:** DECISION-037
```

**Commit:**
```bash
git add framework/CHANGELOG.md
git commit -m "docs(CHANGELOG): Document project-hub move (DECISION-037)"
```

#### 6.2 Update PROJECT-STATUS.md

Update version to next MAJOR (v5.0.0)

**Commit:**
```bash
git add framework/PROJECT-STATUS.md
git commit -m "chore: Bump version to v5.0.0 (MAJOR - breaking change)"
```

---

### Phase 7: Final Review & Merge

#### 7.1 Review All Changes
```bash
# Review commit history
git log --oneline origin/main..HEAD

# Should see ~37 commits (1 move + 33 files + 2 DECISION-037 + CHANGELOG + STATUS)

# Review files changed
git diff --stat origin/main..HEAD
```

#### 7.2 Final Verification
```bash
# Run verification checklist (see below)
```

#### 7.3 Merge to Main
```bash
# Switch to main
git checkout main

# Merge with no-fast-forward to preserve branch structure
git merge --no-ff feat/move-project-hub-to-root

# Verify merge
git log --oneline -10

# Tag the release
git tag -a v5.0.0 -m "Release v5.0.0: project-hub moved to root (DECISION-037)"

# Push (when ready)
git push origin main --tags
```

---

## Verification Checklist

Run before merging to main:

**File Structure:**
- [ ] `project-hub/` exists at repository root
- [ ] `framework/project-hub/` does NOT exist
- [ ] All subdirectories intact: work/, history/, research/, external-references/

**Git History:**
- [ ] `git log --follow project-hub/work/` shows full history
- [ ] All 33+ files committed individually
- [ ] Commit messages follow convention

**Functional Testing:**
- [ ] `/fw-status` works correctly
- [ ] `/fw-backlog` works correctly
- [ ] `/fw-wip` works correctly
- [ ] `/fw-session-history` works correctly
- [ ] `Get-WorkflowStatus.ps1` runs without errors
- [ ] `Get-BacklogItems.ps1` runs without errors
- [ ] `Validate-WorkItems.ps1` runs without errors
- [ ] `Build-FrameworkArchive.ps1` produces correct archive

**Path References:**
- [ ] No remaining active references to `framework/project-hub/` (check with grep)
- [ ] Historical files (history/, CHANGELOG) unchanged
- [ ] Research files unchanged

**Documentation:**
- [ ] CHANGELOG.md has new entry documenting breaking change
- [ ] PROJECT-STATUS.md shows v5.0.0
- [ ] DECISION-037 files marked complete
- [ ] Migration guide in CHANGELOG is clear

**Build Validation:**
- [ ] Test build archive does NOT include project-hub/
- [ ] Archive structure is correct

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

**File-by-file systematic approach:**

- **Phase 1 (Preparation):** 5 minutes
- **Phase 2 (Move directory):** 2 minutes
- **Phase 3 (33 files × 2-3 min each):** 60-90 minutes
  - Edit, validate, commit for each file
  - Functional files may take longer (testing)
- **Phase 4 (DECISION-037 updates):** 5 minutes
- **Phase 5 (Testing):** 15-20 minutes
- **Phase 6 (Documentation):** 10 minutes
- **Phase 7 (Final review & merge):** 10 minutes

**Total: 2-2.5 hours**

**Note:** Systematic approach takes longer but provides:
- Better validation at each step
- Easier rollback if issues found
- Clear audit trail
- Safer execution

---

## Notes

**Historical Integrity:**
- Session histories in `history/sessions/` are NEVER updated (historical record)
- Completed work in `history/releases/` is NEVER updated (frozen at release)
- `CHANGELOG.md` is NEVER updated for past entries (only add new section)
- Research files are historical unless actively needed

**Git Practices:**
- Using `git mv` preserves full history, accessible via `git log --follow`
- File-by-file commits provide clear audit trail
- Each commit is independently revertable if issues found

**Critical Areas:**
- Template skills (templates/starter/.claude/commands/) - users copy these exactly
- PowerShell tools - path logic can be fragile, test thoroughly
- Build script - must correctly exclude project-hub from archive

**Validation Discipline:**
- Don't skip validation steps, even for simple markdown files
- PowerShell scripts MUST be syntax-checked at minimum
- Visual review catches context issues that automated checks miss

**Why File-by-File:**
- Previous structural updates succeeded with this approach
- Easier to identify which change caused an issue
- Better documentation of what changed in each file
- Safer rollback (revert specific file changes)

---

**Status:** Ready for execution

**Last Updated:** 2026-02-05

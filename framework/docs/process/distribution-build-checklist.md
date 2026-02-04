# Distribution Build Checklist

**Version:** 1.0.0
**Last Updated:** 2026-01-23
**Purpose:** Ensure template packages are complete before distribution

---

## Overview

This checklist ensures the `templates/standard/` package contains everything needed for users to set up a new project without missing components.

**When to use:** Before any release that includes template changes.

---

## Pre-Build Validation

### 1. Core Structure Verification

- [ ] Verify structure matches [PROJECT-STRUCTURE.md](../docs/PROJECT-STRUCTURE.md)
- [ ] Run structure comparison:
  ```powershell
  # List all files in template
  Get-ChildItem -Recurse templates/standard/ | Select-Object FullName
  ```

### 2. Required Root Files

- [ ] `README.md` - Project overview template
- [ ] `PROJECT-STATUS.md` - Status template with placeholders
- [ ] `CHANGELOG.md` - Changelog template
- [ ] `CLAUDE.md` - AI collaboration template
- [ ] `INDEX.md` - Documentation index template
- [ ] `QUICK-START.md` - Quick reference guide
- [ ] `NEW-PROJECT-CHECKLIST.md` - Setup instructions
- [ ] `framework.yaml` - Project configuration template
- [ ] `.gitignore` - Git ignore patterns

### 3. Required Folder Structure

- [ ] `src/` with `.gitkeep`
- [ ] `tests/` with `.gitkeep`
- [ ] `docs/` with `README.md`
- [ ] `project-hub/work/backlog/` with `.gitkeep`
- [ ] `project-hub/work/todo/` with `.gitkeep` and `.limit` (contains: 10)
- [ ] `project-hub/work/doing/` with `.gitkeep` and `.limit` (contains: 1)
- [ ] `project-hub/work/done/` with `.gitkeep`
- [ ] `project-hub/work/README.md`
- [ ] `project-hub/history/releases/` with `.gitkeep`
- [ ] `project-hub/history/sessions/` with `.gitkeep`
- [ ] `project-hub/history/spikes/` with `.gitkeep`
- [ ] `project-hub/history/archive/` with `.gitkeep`
- [ ] `project-hub/research/` with `README.md`
- [ ] `project-hub/research/adr/` with `.gitkeep`
- [ ] `project-hub/poc/` with `.gitkeep` and `README.md`
- [ ] `project-hub/retrospectives/` with `.gitkeep`
- [ ] `project-hub/external-references/` with `README.md`

### 4. Framework Documentation

- [ ] `framework/docs/README.md`
- [ ] `framework/docs/PROJECT-STRUCTURE.md`
- [ ] `framework/docs/REPOSITORY-STRUCTURE.md`
- [ ] `framework/docs/collaboration/` - All workflow guides
- [ ] `framework/docs/process/` - All process docs
- [ ] `framework/docs/patterns/` - All pattern docs
- [ ] `framework/docs/ref/` - Schema files

### 5. Framework Templates

**Work Items:**
- [ ] `framework/templates/work-items/FEATURE-TEMPLATE.md` (or FEAT-NNN-template.md)
- [ ] `framework/templates/work-items/BUG-TEMPLATE.md`
- [ ] `framework/templates/work-items/SPIKE-TEMPLATE.md`
- [ ] `framework/templates/work-items/TECHDEBT-TEMPLATE.md`
- [ ] `framework/templates/work-items/DECISION-TEMPLATE.md`

**Decisions:**
- [ ] `framework/templates/decisions/ADR-MAJOR-TEMPLATE.md`
- [ ] `framework/templates/decisions/ADR-MINOR-TEMPLATE.md`

**Documentation:**
- [ ] `framework/templates/documentation/README-TEMPLATE.md`
- [ ] `framework/templates/documentation/CHANGELOG-TEMPLATE.md`
- [ ] `framework/templates/documentation/PROJECT-STATUS-TEMPLATE.md`
- [ ] `framework/templates/documentation/CLAUDE-TEMPLATE.md`
- [ ] `framework/templates/documentation/INDEX-TEMPLATE.md`
- [ ] `framework/templates/documentation/SESSION-HISTORY-TEMPLATE.md` **(NEW)**
- [ ] `framework/templates/documentation/EXTERNAL-REFERENCE-TEMPLATE.md` **(NEW)**

**Research:**
- [ ] `framework/templates/research/FEASIBILITY-TEMPLATE.md`
- [ ] `framework/templates/research/LANDSCAPE-ANALYSIS-TEMPLATE.md`
- [ ] `framework/templates/research/PROBLEM-STATEMENT-TEMPLATE.md`
- [ ] `framework/templates/research/PROJECT-DEFINITION-TEMPLATE.md`
- [ ] `framework/templates/research/PROJECT-JUSTIFICATION-TEMPLATE.md`
- [ ] `framework/templates/research/TESTING-PLAN-TEMPLATE.md`

### 6. Framework Tools (Scripts)

- [ ] `framework/tools/` folder exists in template
- [ ] `Get-NextWorkItemId.ps1` - Gets next available work item ID
- [ ] `Move-WorkItem.ps1` - Moves work items between folders (with git mv)
- [ ] `Get-BacklogItems.ps1` - Lists backlog items
- [ ] `Get-WorkflowStatus.ps1` - Shows workflow status
- [ ] `Get-FrameworkIndex.ps1` - Gets framework topic index
- [ ] `FrameworkWorkflow.psm1` - PowerShell module for workflow functions
- [ ] `validate-framework.ps1` - Validates framework structure

### 7. Claude Code Commands

- [ ] `.claude/commands/` folder exists in template
- [ ] `fw-backlog.md` - Backlog review command
- [ ] `fw-help.md` - Framework help command
- [ ] `fw-move.md` - Work item move command
- [ ] `fw-next-id.md` - Next ID generation command
- [ ] `fw-session-history.md` - Session history command
- [ ] `fw-status.md` - Project status command
- [ ] `fw-topic-index.md` - Topic index command
- [ ] `fw-wip.md` - Work in progress command

**Note:** The fw- commands depend on the scripts in `framework/tools/`. Both must be included.

### 8. Optional Components

- [ ] `tools/` folder at project root (placeholder with `.gitkeep` if no project-specific tools)
- [ ] `templates/` folder at project root (only if project produces templates)

---

## Build Process

### Step 1: Sync from Source

```powershell
# Ensure template has latest framework docs
# Source: framework/docs/ → Target: templates/standard/framework/docs/

# Copy collaboration guides
Copy-Item -Recurse framework/docs/collaboration/* templates/standard/framework/docs/collaboration/

# Copy process docs
Copy-Item -Recurse framework/docs/process/* templates/standard/framework/docs/process/

# Copy patterns
Copy-Item -Recurse framework/docs/patterns/* templates/standard/framework/docs/patterns/
```

### Step 2: Sync Templates

```powershell
# Ensure template has latest framework templates
# Source: framework/templates/ → Target: templates/standard/framework/templates/

Copy-Item -Recurse framework/templates/* templates/standard/framework/templates/
```

### Step 3: Sync Framework Tools

```powershell
# Copy framework tools/scripts to template
# Source: framework/tools/*.ps1, *.psm1 → Target: templates/standard/framework/tools/

New-Item -ItemType Directory -Path templates/standard/framework/tools -Force
Copy-Item framework/tools/*.ps1 templates/standard/framework/tools/
Copy-Item framework/tools/*.psm1 templates/standard/framework/tools/
```

### Step 4: Sync Claude Commands

```powershell
# Copy fw- commands to template
# Source: .claude/commands/fw-*.md → Target: templates/standard/.claude/commands/

New-Item -ItemType Directory -Path templates/standard/.claude/commands -Force
Copy-Item .claude/commands/fw-*.md templates/standard/.claude/commands/
```

### Step 5: Validate WIP Limits

```powershell
# Verify .limit files have correct values
Get-Content templates/standard/project-hub/work/todo/.limit    # Should be: 10
Get-Content templates/standard/project-hub/work/doing/.limit   # Should be: 1
```

### Step 6: Validate Placeholders

- [ ] Check all template files for `{{PLACEHOLDER}}` markers
- [ ] Verify NEW-PROJECT-CHECKLIST.md documents all placeholders
- [ ] Ensure no hardcoded project-specific values remain

---

## Post-Build Validation

### 1. Fresh Project Test

```powershell
# Create test project from template
$testPath = "C:\temp\test-project"
Remove-Item -Recurse -Force $testPath -ErrorAction SilentlyContinue
Copy-Item -Recurse templates/standard/* $testPath
Copy-Item templates/standard/.gitignore $testPath
Copy-Item -Recurse templates/standard/.claude $testPath -ErrorAction SilentlyContinue

# Initialize and verify
cd $testPath
git init
git add .
git status
```

### 2. Checklist Validation

- [ ] Follow NEW-PROJECT-CHECKLIST.md step-by-step
- [ ] Document any missing or unclear steps
- [ ] Verify all template paths referenced are correct

### 3. Claude Code Integration Test

- [ ] Open test project in VSCode with Claude Code
- [ ] Run `/fw-help` - should work
- [ ] Run `/fw-status` - should work
- [ ] Run `/fw-wip` - should work
- [ ] Ask Claude about project structure - should understand

---

## Known Gaps (To Be Addressed)

These items are documented as missing and have work items to address:

| Gap | Work Item |
|-----|-----------|
| Session history template | TECH-072 |
| External reference template | TECH-073 |

---

## Release Checklist

Before releasing a version with template changes:

- [ ] All pre-build validation items pass
- [ ] Build process completed
- [ ] All post-build validation items pass
- [ ] Fresh project test successful
- [ ] CHANGELOG.md updated with template changes
- [ ] Version number bumped appropriately

---

## References

- [PROJECT-STRUCTURE.md](../docs/PROJECT-STRUCTURE.md) - Canonical structure
- [NEW-PROJECT-CHECKLIST.md](../../templates/standard/NEW-PROJECT-CHECKLIST.md) - User setup guide
- [version-control-workflow.md](version-control-workflow.md) - Release process

---

**Last Updated:** 2026-01-23

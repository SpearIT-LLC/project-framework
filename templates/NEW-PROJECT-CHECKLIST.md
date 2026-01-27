# New Project Setup Checklist

**Version:** 4.0.0
**Last Updated:** 2026-01-26

---

## Overview

This checklist guides setup of a new project using the SpearIT Project Framework.

**What you get:**
- Documentation structure (README, PROJECT-STATUS, CHANGELOG, CLAUDE.md)
- Kanban workflow system (backlog → todo → doing → done)
- Framework templates for work items, decisions, and documentation
- AI assistant integration via CLAUDE.md

---

## Quick Start - Automated (2 minutes)

### Option 1: Using Setup Script (Recommended)

```powershell
# Run the setup script with the framework archive
.\tools\Setup-Project.ps1 -ArchivePath ".\distrib\spearit_framework_v3.0.0.zip" -Destination "C:\Projects\my-app"
```

The script will:
- Prompt for project name and description
- Extract the archive to your destination
- Replace all `{{PLACEHOLDER}}` tokens automatically
- Initialize git repository with initial commit

**Setup Complete!** Begin development.

### Option 2: Manual Setup

If you don't have the archive or prefer manual setup, see [Detailed Manual Setup](#detailed-manual-setup) below.

---

## Quick Start - Manual (10 minutes)

### Step 1: Copy Template

```powershell
# Copy the template package to your project location
Copy-Item -Recurse path/to/framework/templates/starter/* path/to/your-project/

# Copy hidden files too
Copy-Item path/to/framework/templates/starter/.gitignore path/to/your-project/
Copy-Item -Recurse path/to/framework/templates/starter/.claude path/to/your-project/

# Copy framework documentation and templates
Copy-Item -Recurse path/to/framework/docs path/to/your-project/framework/
Copy-Item -Recurse path/to/framework/templates path/to/your-project/framework/
Copy-Item -Recurse path/to/framework/tools path/to/your-project/framework/
```

### Step 2: Configure framework.yaml

Edit `framework.yaml` at the project root:

```yaml
project:
  name: "Your Project Name"
  type: application  # framework | application | library | tool
  deliverable: code  # code | documentation | hybrid
```

### Step 3: Initialize Git

```powershell
cd path/to/your-project
git init
git add .
git commit -m "Initial project setup from SpearIT Framework"
git tag -a v0.1.0 -m "Initial setup"
```

### Step 4: Customize Documents

- [ ] **README.md** - Update project name and description
- [ ] **PROJECT-STATUS.md** - Set initial version and status
- [ ] **CHANGELOG.md** - Update project name
- [ ] **CLAUDE.md** - Add project-specific information

**Setup Complete!** Begin development.

---

## Detailed Manual Setup

### Phase 1: Copy Template Package

- [ ] Copy `templates/starter/*` to your project root
- [ ] Copy `templates/starter/.gitignore` to your project root
- [ ] Copy `templates/starter/.claude` to your project root
- [ ] Copy `framework/docs` to `your-project/framework/docs`
- [ ] Copy `framework/templates` to `your-project/framework/templates`
- [ ] Copy `framework/tools` to `your-project/framework/tools`
- [ ] Verify folder structure exists:
  - [ ] `framework/` - Framework documentation and templates
  - [ ] `src/` - Source code (empty)
  - [ ] `tests/` - Test files (empty)
  - [ ] `docs/` - Project documentation
  - [ ] `project-hub/work/` - Kanban workflow folders
  - [ ] `project-hub/history/` - Session logs and archives
  - [ ] `project-hub/research/` - Research and ADRs
  - [ ] `project-hub/retrospectives/` - Project retrospectives
  - [ ] `project-hub/external-references/` - Cached references

### Phase 2: Configure Project

- [ ] **Update framework.yaml**
  - [ ] Set `project.name`
  - [ ] Set `project.type` (application, library, tool, framework)
  - [ ] Set `project.deliverable` (code, documentation, hybrid)

- [ ] **Update README.md**
  - [ ] Replace `{{PROJECT_NAME}}` with actual project name
  - [ ] Replace `{{PROJECT_DESCRIPTION}}` with description
  - [ ] Replace `{{DATE}}` with current date
  - [ ] Update Quick Start section with actual commands

- [ ] **Update PROJECT-STATUS.md**
  - [ ] Set project name
  - [ ] Set initial version (v0.1.0)
  - [ ] Set creation date
  - [ ] Update status to "In Development"

- [ ] **Update CHANGELOG.md**
  - [ ] Set project name in header
  - [ ] Update initial [0.1.0] entry date

- [ ] **Update CLAUDE.md**
  - [ ] Replace `{{PROJECT_NAME}}` with actual project name
  - [ ] Replace `{{PROJECT_DESCRIPTION}}` with description
  - [ ] Replace `{{DATE}}` with current date
  - [ ] Add project-specific coding standards
  - [ ] Add project-specific architecture decisions

- [ ] **Update INDEX.md**
  - [ ] Replace `{{PROJECT_NAME}}` with actual project name
  - [ ] Replace `{{DATE}}` with current date

- [ ] **Add LICENSE file (optional)**
  - For open source: MIT, Apache 2.0, GPL
  - For proprietary: Add copyright notice or skip
  - Use https://choosealicense.com/ if unsure

### Phase 3: Git Setup

- [ ] Initialize git repository
  ```powershell
  git init
  ```

- [ ] Add all files
  ```powershell
  git add .
  ```

- [ ] Initial commit
  ```powershell
  git commit -m "Initial project setup from SpearIT Framework"
  ```

- [ ] Tag initial version
  ```powershell
  git tag -a v0.1.0 -m "Initial setup"
  ```

### Phase 3.5: Remote Setup (Optional)

If you want to push to GitHub or another remote:

- [ ] Create repository on GitHub/GitLab (do not initialize with README)
- [ ] Add remote
  ```powershell
  git remote add origin https://github.com/username/repo-name.git
  ```
- [ ] Push with tags
  ```powershell
  git push -u origin main
  git push --tags
  ```

### Phase 4: Verify Setup

- [ ] **Verify folder structure**
  ```powershell
  Get-ChildItem -Recurse -Directory | Select-Object FullName
  ```

- [ ] **Verify WIP limit files**
  ```powershell
  Get-Content project-hub/work/doing/.limit   # Should contain "1"
  Get-Content project-hub/work/todo/.limit    # Should contain "10"
  ```

- [ ] **Verify framework templates accessible**
  ```powershell
  Get-ChildItem framework/templates/work-items/
  Get-ChildItem framework/templates/decisions/
  ```

- [ ] **Test Claude integration** (if using Claude Code)
  - [ ] Open Claude Code in project directory
  - [ ] Verify CLAUDE.md is loaded
  - [ ] Ask Claude about project structure

---

## After Setup

### First Work Item

After setup completes, define what you're building. Work items define scope BEFORE writing code, preventing scope creep and providing clear completion criteria.

**Option A: Ask the AI (Recommended if using Claude Code)**

Open Claude Code in your project directory and ask:
```
Create a work item for my first feature: [describe what you want to build]
```

The AI will create a properly formatted work item in `project-hub/work/backlog/` using the framework templates.

**Option B: Manual Creation**

```powershell
# Copy a feature template
Copy-Item framework/templates/work-items/FEAT-NNN-template.md project-hub/work/backlog/FEAT-001-your-feature.md

# Edit the work item to describe:
# - What you're building
# - Why it's needed
# - Acceptance criteria

# Move through workflow as you work:
# backlog → todo → doing → done
```

**Why work items?** They document intent before implementation, making it easy to:
- Stay focused on the current goal
- Know when you're done
- Communicate progress
- Avoid scope creep

---

## Key Documents Reference

| Document | Purpose |
|----------|---------|
| `framework.yaml` | Machine-readable project configuration |
| `README.md` | Project overview for users |
| `PROJECT-STATUS.md` | Single source of truth for version and status |
| `CHANGELOG.md` | Version history (Keep a Changelog format) |
| `CLAUDE.md` | AI assistant instructions |
| `INDEX.md` | Documentation navigation |

---

## Framework Folders Reference

| Folder | Purpose |
|--------|---------|
| `framework/docs/collaboration/` | Workflow guides |
| `framework/docs/process/` | Process documentation |
| `framework/docs/patterns/` | Implementation patterns |
| `framework/templates/work-items/` | Feature, bug, spike templates |
| `framework/templates/decisions/` | ADR templates |
| `framework/templates/documentation/` | Session history templates |
| `framework/templates/research/` | Research phase templates |

---

## Workflow Folders Reference

| Folder | Purpose | Limit |
|--------|---------|-------|
| `project-hub/work/backlog/` | Future work, not committed | None |
| `project-hub/work/todo/` | Committed next work | 10 |
| `project-hub/work/doing/` | Active work | 1 |
| `project-hub/work/done/` | Completed, awaiting release | None |

---

## Related Documents

- [workflow-guide.md](../framework/docs/collaboration/workflow-guide.md) - Work item lifecycle
- [version-control-workflow.md](../framework/docs/process/version-control-workflow.md) - Release process
- [QUICK-START.md](../QUICK-START.md) - Framework quick reference

---

## Success Criteria

You've successfully set up the project when:

- [ ] All placeholder values replaced in templates
- [ ] Git repository initialized with initial commit
- [ ] Framework templates accessible from `framework/templates/`
- [ ] WIP limit files in place (`.limit` files)
- [ ] Claude can answer questions about project structure (if using Claude Code)

---

## Troubleshooting

### Missing framework/ folder
The framework/ folder is created from live source during automated setup. For manual setup:
- Copy `framework/docs` to `your-project/framework/docs`
- Copy `framework/templates` to `your-project/framework/templates`
- Copy `framework/tools` to `your-project/framework/tools`

### Placeholders not replaced
If using manual setup, replace these tokens in all `.md` and `.yaml` files:
- `{{PROJECT_NAME}}` - Your project name
- `{{PROJECT_DESCRIPTION}}` - Project description
- `{{DATE}}` - Current date (YYYY-MM-DD)

### Git ignoring important files
Check `.gitignore` - it should only ignore temp files and build artifacts, not framework files.

### Claude doesn't see CLAUDE.md
Ensure CLAUDE.md is at the project root and you opened Claude Code in that directory.

### Missing Claude commands (.claude/commands/)
Copy the `.claude/` folder from `templates/starter/.claude/` to your project root.

---

**Last Updated:** 2026-01-26

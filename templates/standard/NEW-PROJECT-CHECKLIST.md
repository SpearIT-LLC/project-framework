# New Project Setup Checklist

**Version:** 3.0.0
**Last Updated:** 2026-01-21

---

## Overview

This checklist guides setup of a new project using the SpearIT Project Framework.

**What you get:**
- Documentation structure (README, PROJECT-STATUS, CHANGELOG, CLAUDE.md)
- Kanban workflow system (backlog → todo → doing → done)
- Framework templates for work items, decisions, and documentation
- AI assistant integration via CLAUDE.md

---

## Quick Start (10 minutes)

### Step 1: Copy Template

```powershell
# Copy the template package to your project location
Copy-Item -Recurse path/to/framework/templates/standard/* path/to/your-project/

# Copy hidden files too
Copy-Item path/to/framework/templates/standard/.gitignore path/to/your-project/
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

## Detailed Setup Checklist

### Phase 1: Copy Template Package

- [ ] Copy `templates/standard/*` to your project root
- [ ] Copy `templates/standard/.gitignore` to your project root
- [ ] Verify folder structure exists:
  - [ ] `framework/` - Framework documentation and templates
  - [ ] `src/` - Source code (empty)
  - [ ] `tests/` - Test files (empty)
  - [ ] `docs/` - Project documentation
  - [ ] `thoughts/work/` - Kanban workflow folders
  - [ ] `thoughts/history/` - Session logs and archives
  - [ ] `thoughts/research/` - Research and ADRs
  - [ ] `thoughts/retrospectives/` - Project retrospectives
  - [ ] `thoughts/external-references/` - Cached references

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

### Phase 4: Verify Setup

- [ ] **Verify folder structure**
  ```powershell
  Get-ChildItem -Recurse -Directory | Select-Object FullName
  ```

- [ ] **Verify WIP limit files**
  ```powershell
  Get-Content thoughts/work/doing/.limit   # Should contain "1"
  Get-Content thoughts/work/todo/.limit    # Should contain "10"
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

## First Work Item

After setup, create your first work item:

```powershell
# Copy a feature template
Copy-Item framework/templates/work-items/FEAT-NNN-template.md thoughts/work/backlog/FEAT-001-first-feature.md

# Edit the work item
# Move to todo when ready to plan
Move-Item thoughts/work/backlog/FEAT-001-*.md thoughts/work/todo/

# Move to doing when ready to implement (max 1)
Move-Item thoughts/work/todo/FEAT-001-*.md thoughts/work/doing/

# Move to done when complete
Move-Item thoughts/work/doing/FEAT-001-*.md thoughts/work/done/
```

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
| `thoughts/work/backlog/` | Future work, not committed | None |
| `thoughts/work/todo/` | Committed next work | 10 |
| `thoughts/work/doing/` | Active work | 1 |
| `thoughts/work/done/` | Completed, awaiting release | None |

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
Ensure you copied the entire `templates/standard/` directory, including the `framework/` subfolder.

### Git ignoring important files
Check `.gitignore` - it should only ignore temp files and build artifacts, not framework files.

### Claude doesn't see CLAUDE.md
Ensure CLAUDE.md is at the project root and you opened Claude Code in that directory.

---

**Last Updated:** 2026-01-21

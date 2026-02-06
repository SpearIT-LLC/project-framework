# Feature: Interactive Setup Script

**ID:** FEAT-006
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2025-12-19
**Completed:** 2026-02-06
**Theme:** Distribution & Onboarding

---

## Summary

Create an interactive setup script that asks users planning questions and automatically sets up the appropriate framework level with customized templates.

---

## Problem Statement

**What problem does this solve?**

Manual framework setup requires:
1. Deciding which framework level
2. Copying files
3. Customizing multiple template files
4. Creating folder structure

This is time-consuming and error-prone for new users.

**Who is affected?**

- New users setting up first framework project
- Users unfamiliar with framework levels
- Teams wanting standardized setup

**Current workaround:**

Manual following of NEW-PROJECT-CHECKLIST.md (2-4 hours for Standard).

---

## Requirements

### Functional Requirements

- [x] ~~Ask 3 classification questions (Scope, Lifespan, Team)~~ - N/A (multi-level framework retired)
- [x] ~~Recommend framework level based on answers~~ - N/A (multi-level framework retired)
- [x] ~~Allow user to override recommendation~~ - N/A (multi-level framework retired)
- [x] Prompt for project details (name, author, description) - ✅ COMPLETE with git config fallback
- [x] Copy appropriate framework template - ✅ COMPLETE
- [x] Customize templates with user-provided details - ✅ COMPLETE ({{PROJECT_NAME}}, {{AUTHOR_NAME}}, etc.)
- [x] Initialize git repository (optional) - ✅ COMPLETE
- [x] Create first commit (optional) - ✅ COMPLETE

### Non-Functional Requirements

- [x] Cross-platform (PowerShell Core 7+ preferred) - ✅ COMPLETE (PowerShell 7+)
- [ ] Fallback Bash script for Linux/Mac - Deferred (separate work item in backlog)
- [x] Clear, user-friendly prompts - ✅ COMPLETE
- [ ] Dry-run mode to preview without changes - Deferred (future enhancement)
- [x] Error handling for invalid inputs - ✅ COMPLETE (validation, prompts on empty required values)

---

## Design

### Script Flow

```
1. Welcome message
2. Prompt: "Destination path for new project" (if not provided via parameter)
3. Validate destination path:
   - Verify not copying to self
   - Check destination not occupied (or -Force required)
4. Prompt: "Project name" (if not provided via parameter)
5. Prompt: "Project description" (if not provided via parameter, defaults to "A new project")
6. Get author name:
   - Try global git config user.name (from user's .gitconfig)
   - If not found, prompt "Author name (optional, press Enter to skip)"
7. Get author email:
   - Try global git config user.email (from user's .gitconfig)
   - If not found, prompt "Author email (optional, press Enter to skip)"
8. Project type selection:
   - Read project types from framework-schema.yaml
   - Display numbered menu of types with descriptions
   - Prompt: "Project type [1-N]" (defaults to "application" if empty)
9. Display configuration summary:
   - Project Name, Description, Type
   - Author Name, Author Email (shows "(not set)" if empty)
   - Destination, Date
   - Note: "Author info can be updated later in framework.yaml and README.md"
10. Confirm: "Proceed with setup? (y/n)"
11. Execute if confirmed:
    - Create destination directory (if doesn't exist)
    - Copy template files (excluding Setup-Framework.ps1 itself)
    - Replace placeholders in all text files:
      * {{PROJECT_NAME}}, {{PROJECT_DESCRIPTION}}, {{PROJECT_TYPE}}
      * {{AUTHOR_NAME}}, {{AUTHOR_EMAIL}}, {{DATE}}
    - Initialize git repository (unless -NoGit switch provided):
      * git init --quiet
      * git add -A
      * git commit -m "Initial project setup from SpearIT Framework"
12. Display completion summary:
    - Project location
    - Complete project structure with descriptions
    - Next steps (NEW-PROJECT-CHECKLIST.md)
    - Key commands (/fw-help, /fw-status, /fw-backlog)
```

### Placeholder Replacement

**Placeholders in templates:**
- `[Project Name]` → User-provided project name
- `[Author Name]` → User-provided author
- `[Author Email]` → User-provided email
- `YYYY-MM-DD` → Current date
- `[Project Description]` → User-provided description

---

## Implementation Steps

- [x] Create setup-framework.ps1 (PowerShell Core 7+) - ✅ Renamed from Setup-Project.ps1
- [x] Implement question flow with validation - ✅ Author prompts with git config fallback
- [x] ~~Implement framework level recommendation logic~~ - N/A (multi-level framework retired)
- [x] Implement file copying with placeholder replacement - ✅ COMPLETE
- [ ] Add dry-run mode (-WhatIf parameter) - Deferred
- [x] Add verbose mode for debugging - ✅ Configuration summary display
- [x] Test on Windows (PowerShell 7) - ✅ User tested at C:\Temp\hello-father
- [ ] Create setup-framework.sh (Bash fallback) - Deferred (separate backlog item)
- [ ] Test on Linux/Mac - Deferred (pending bash script)
- [x] Document script usage in README.md - ✅ Updated README, QUICK-START, NEW-PROJECT-CHECKLIST
- [x] Add script to tools/ folder - ✅ Script in templates/starter/ (runs from extracted archive)

---

## Success Criteria

- [x] ~~Script successfully sets up all 3 framework levels~~ - N/A (single comprehensive framework)
- [x] Placeholders correctly replaced with user input - ✅ COMPLETE ({{PROJECT_NAME}}, {{AUTHOR_NAME}}, {{AUTHOR_EMAIL}}, {{DATE}})
- [x] ~~Framework level recommendation matches manual decision tree~~ - N/A (multi-level framework retired)
- [x] Git initialization works (when opted-in) - ✅ COMPLETE
- [x] User testing confirms setup is faster than manual - ✅ User successfully tested at C:\Temp\hello-father
- [x] Documentation clear for script usage - ✅ COMPLETE (README, QUICK-START, NEW-PROJECT-CHECKLIST all updated)

---

## CHANGELOG Notes

**Added:**
- Setup-Framework.ps1 - Interactive framework setup script (PowerShell 7+)
- Automated project initialization with customization
- Project type selection from framework-schema.yaml
- Author metadata prompts with git config fallback
- Transparent display of git config file path when reading author info

---

---

## Implementation Completion (2026-02-05 - Sprint D&O 1)

**Status:** ✅ COMPLETE

**What Was Implemented:**
- ✅ Setup-Framework.ps1 (renamed from Setup-Project.ps1)
- ✅ Author name/email prompts with git config fallback
- ✅ All parameters now optional (intelligent defaults + prompts)
- ✅ Destination parameter optional (prompts if not provided)
- ✅ Author metadata storage in framework.yaml (SSOT)
- ✅ Author section in README.md with SSOT reference
- ✅ framework-schema.yaml updated with author object
- ✅ PROJECT-STRUCTURE.md documents author SSOT
- ✅ Validation ordering fixed (prompt before validate)
- ✅ Configuration summary enhanced with author info
- ✅ Complete project structure display
- ✅ Distribution archive builds and tested successfully
- ✅ User testing at C:\Temp\hello-father - all features working

**What Was Deferred:**
- Framework level selection (Multi-level framework retired per DECISION-105)
- Framework level recommendation logic (Not applicable - single comprehensive framework)
- Dry-run mode (-WhatIf) - Deferred to potential future enhancement
- Cross-platform bash script - Deferred (already in backlog)
- License selection - Deferred to DECISION-029 (License Choice for Framework)
- Data-driven question configuration - Deferred to FEAT-111 (Sprint D&O 4)

**Decisions Made:**
1. **Framework-level support:** Removed (DECISION-105 retired multi-level concept)
2. **Author info:** Implemented git config fallback with optional prompts
3. **License selection:** Deferred to DECISION-029
4. **Bash script:** Deferred (PowerShell-only for MVP)
5. **Dry-run mode:** Deferred to future enhancement

**Related Work Items:**
- **Prerequisite:** DECISION-050 - Framework-as-Dependency Model (v4.0.0)
- **Prerequisite:** DECISION-105 - Retire Multi-Level Framework (v4.1.0)
- **Follow-up:** FEAT-111 - Data-Driven Setup Script Questions (Sprint D&O 4)
- **Follow-up:** FEAT-112 - Setup Script Edge Cases and Polish (Backlog - Polish Sprint)
- **Related:** DECISION-029 - License Choice for Framework (Sprint D&O 1)

**Testing:**
- Build-test-fix cycles with multiple archive builds
- User testing at C:\Temp\hello-father
- Git config fallback validated
- Author placeholder replacement validated
- All template files copied successfully
- .git initialization working
- Structure display accurate

**Key Improvements:**
- Script renamed to Setup-Framework.ps1 (prevents naming collisions)
- SSOT pattern for author metadata (framework.yaml)
- Enhanced user experience with intelligent defaults
- Comprehensive documentation updates (15+ files)
- Fixed critical project structure error (project-hub/ location)
- Added transparency for git config reading (shows file path when reading author info)

**Last Updated:** 2026-02-06
**Status:** ✅ Complete - Script flow documented, edge cases tracked in FEAT-112

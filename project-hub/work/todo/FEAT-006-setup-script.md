# Feature: Interactive Setup Script

**ID:** FEAT-006
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2025-12-19
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

- [ ] Ask 3 classification questions (Scope, Lifespan, Team)
- [ ] Recommend framework level based on answers
- [ ] Allow user to override recommendation
- [ ] Prompt for project details (name, author, description)
- [ ] Copy appropriate framework template
- [ ] Customize templates with user-provided details
- [ ] Initialize git repository (optional)
- [ ] Create first commit (optional)

### Non-Functional Requirements

- [ ] Cross-platform (PowerShell Core 7+ preferred)
- [ ] Fallback Bash script for Linux/Mac
- [ ] Clear, user-friendly prompts
- [ ] Dry-run mode to preview without changes
- [ ] Error handling for invalid inputs

---

## Design

### Script Flow

```
1. Welcome message
2. Ask: "Project Name?"
3. Ask: "Author Name?"
4. Ask: "Author Email?"
5. Ask: "Project Description?"
6.
7. Framework Selection:
8. Ask: "Scope & Complexity?" (Script/Tool/Application/System)
9. Ask: "Lifespan & Evolution?" (Throwaway/Short-term/Maintained/Critical)
10. Ask: "Team & Collaboration?" (Solo-Personal/Solo-Professional/Small-Team/Large-Team)
11.
12. Display: "Recommended: [Level] Framework"
13. Ask: "Use this level? (Y/n)"
14.
15. Display: "Preview of files to be created..."
16. Ask: "Proceed with setup? (Y/n)"
17.
18. Execute:
19. - Copy template files
20. - Replace placeholders with user input
21. - Create folder structure
22. - Set WIP limits (if Standard)
23.
24. Ask: "Initialize git repository? (Y/n)"
25. If yes: git init, git add, git commit
26.
27. Display: "Setup complete! Next steps..."
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

- [ ] Create setup-framework.ps1 (PowerShell Core 7+)
- [ ] Implement question flow with validation
- [ ] Implement framework level recommendation logic
- [ ] Implement file copying with placeholder replacement
- [ ] Add dry-run mode (-WhatIf parameter)
- [ ] Add verbose mode for debugging
- [ ] Test on Windows (PowerShell 7)
- [ ] Create setup-framework.sh (Bash fallback)
- [ ] Test on Linux/Mac
- [ ] Document script usage in README.md
- [ ] Add script to tools/ folder

---

## Success Criteria

- [ ] Script successfully sets up all 3 framework levels
- [ ] Placeholders correctly replaced with user input
- [ ] Framework level recommendation matches manual decision tree
- [ ] Git initialization works (when opted-in)
- [ ] User testing confirms setup is faster than manual
- [ ] Documentation clear for script usage

---

## CHANGELOG Notes

**Added:**
- setup-framework.ps1 - Interactive framework setup script (PowerShell 7+)
- setup-framework.sh - Interactive framework setup script (Bash)
- Automated project initialization with customization
- Framework level recommendation based on user responses

---

## Partial Implementation (v3.7.0)

A basic `Setup-Project.ps1` was created in v3.7.0 as part of the distribution archive work. It covers:
- [x] Project name prompt
- [x] Project description prompt
- [x] Placeholder replacement (`{{PROJECT_NAME}}`, `{{PROJECT_DESCRIPTION}}`, `{{DATE}}`)
- [x] Git initialization (optional)
- [x] Initial commit
- [x] Works in-place from extracted archive

**Still needed for full feature:**
- [ ] Author name/email prompts
- [ ] Framework level selection questions (Scope, Lifespan, Team)
- [ ] Framework level recommendation logic
- [ ] Dry-run mode (-WhatIf)
- [ ] Cross-platform bash script
- [ ] License selection
- [ ] Validation of destination path

---

## Decisions to Make

1. **Framework level support** - Current archive is "Standard" only. Do we need Minimal/Light variants, or is Standard the only distribution target?

2. **Author info** - Should we prompt for author name/email, or rely on git config?

3. **License selection** - Offer license picker (MIT, Apache, etc.) or leave as placeholder?

4. **Bash script** - Is cross-platform support needed, or is PowerShell-only acceptable?

5. **Dry-run mode** - Is -WhatIf valuable for a setup script, or unnecessary complexity?

---

**Last Updated:** 2026-01-26
**Status:** Backlog - Partially implemented in v3.7.0

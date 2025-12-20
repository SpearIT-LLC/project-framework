# Feature: Interactive Setup Script

**ID:** FEAT-006
**Type:** Feature (Tooling)
**Version Impact:** MINOR (new tool)
**Target Version:** v2.1.0
**Status:** Backlog
**Created:** 2025-12-19
**Completed:** N/A
**Developer:** Gary Elliott

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

**Last Updated:** 2025-12-19
**Status:** Backlog (priority for v2.1.0)

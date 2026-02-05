# Feature: ZIP Distribution Package

**ID:** FEAT-005
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2025-12-19

---

## Summary

Create pre-packaged ZIP files for each framework level (Minimal, Light, Standard) to provide easy download and setup without requiring Git knowledge.

---

## Problem Statement

**What problem does this solve?**

Current distribution requires Git clone, which may be barrier for:
- Users unfamiliar with Git
- Organizations with restricted Git access
- Quick evaluation/testing of framework
- Offline environments

**Who is affected?**

- Non-technical users evaluating framework
- Organizations with security restrictions on Git
- Users wanting quick start without Git setup

**Current workaround:**

Manual "Download ZIP" from GitHub, then navigate to appropriate folder.

---

## Requirements

### Functional Requirements

- [ ] Create spearit-framework-minimal-v2.1.0.zip
- [ ] Create spearit-framework-light-v2.1.0.zip
- [ ] Create spearit-framework-standard-v2.1.0.zip
- [ ] Include README-FIRST.txt in each ZIP with quick start instructions
- [ ] Automate ZIP creation as part of release process

### Non-Functional Requirements

- [ ] ZIPs hosted on GitHub Releases page
- [ ] Clear naming convention with version number
- [ ] Each ZIP self-contained (includes guide docs)
- [ ] Documentation updated with download links

---

## Design

### ZIP Package Contents

**Minimal ZIP:**
```
spearit-framework-minimal-v2.1.0/
├── README-FIRST.txt          # Quick start instructions
├── README.md                 # Minimal template
└── .gitignore                # Gitignore template
```

**Light ZIP:**
```
spearit-framework-light-v2.1.0/
├── README-FIRST.txt
├── README.md
├── PROJECT-STATUS.md
├── CHANGELOG.md
├── CLAUDE.md
├── .gitignore
└── project-hub/project/
    ├── history/.gitkeep
    └── research/justification-template.md
```

**Standard ZIP:**
```
spearit-framework-standard-v2.1.0/
├── README-FIRST.txt
├── README.md
├── CLAUDE.md
├── PROJECT-STATUS.md
├── CHANGELOG.md
├── INDEX.md
├── .gitignore
└── project-hub/
    ├── framework/           # Complete framework
    └── project/             # Project workspace
```

### README-FIRST.txt Template

```
SpearIT Project Framework - [Level] Template
Version: v2.1.0

QUICK START:
1. Extract this ZIP to your project location
2. Rename the folder to your project name
3. Open README.md and customize with your project details
4. [Level-specific instructions]

NEXT STEPS:
- See README.md for detailed setup guide
- Visit https://github.com/spearit-solutions/project-framework for documentation

Questions? gary.elliott@spearit.solutions
```

---

## Implementation Steps

- [ ] Create ZIP creation script (PowerShell or Bash)
- [ ] Script copies appropriate template folder
- [ ] Script adds README-FIRST.txt
- [ ] Script creates ZIP with version in filename
- [ ] Test ZIP extraction and folder structure
- [ ] Document ZIP creation process in CONTRIBUTING.md (future)
- [ ] Add ZIP creation to release checklist
- [ ] Upload ZIPs to GitHub Releases
- [ ] Update documentation with download links

---

## Success Criteria

- [ ] Three ZIP files created for v2.1.0
- [ ] ZIPs extract correctly with proper structure
- [ ] README-FIRST.txt provides clear quick start
- [ ] ZIPs available on GitHub Releases page
- [ ] Documentation updated with download links

---

## CHANGELOG Notes

**Added:**
- ZIP distribution packages for Minimal, Light, and Standard frameworks
- README-FIRST.txt quick start guide in each ZIP
- Automated ZIP creation script
- GitHub Releases distribution method

---

**Last Updated:** 2025-12-19

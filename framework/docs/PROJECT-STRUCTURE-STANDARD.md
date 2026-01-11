# Standard Framework - Project Structure Definition

**Version:** 3.0.0
**Status:** Published
**Last Updated:** 2026-01-07
**Purpose:** Definitive reference for Standard Framework project structure

---

## Overview

This document defines the complete folder and file structure for **Standard Framework** level projects.

**Applies to:**
- The framework project itself (dogfooding)
- All user projects created from the framework
- Validation of project structure compliance

**Does NOT apply to:**
- Repository root (meta-level container - see [REPOSITORY-STRUCTURE.md](REPOSITORY-STRUCTURE.md))
- Light Framework level (different structure)
- Minimal Framework level (different structure)

---

## Repository Root Reference

**For repository root structure, see [REPOSITORY-STRUCTURE.md](REPOSITORY-STRUCTURE.md)**

The project-framework repository is a **monorepo** containing multiple projects (framework/, project-hello-world/). The repository root has minimal files (README, QUICK-START, CLAUDE, LICENSE, .gitignore).

**This document defines PROJECT structure only.**

Standard user projects typically create a single-project repository and follow the structure below directly at root.

---

## Complete Project Structure

```
[project-name]/
├── .gitignore                        # REQUIRED - Git ignore patterns
├── LICENSE                           # OPTIONAL - Project license
├── README.md                         # REQUIRED - Project overview
├── PROJECT-STATUS.md                 # REQUIRED - SSOT for version/status
├── CHANGELOG.md                      # REQUIRED - Version history (Keep a Changelog)
├── CLAUDE.md                         # REQUIRED - AI collaboration guide
├── INDEX.md                          # REQUIRED - Documentation navigation
│
├── src/                              # REQUIRED - Source code
│   └── .gitkeep                     # REQUIRED (if empty)
│
├── tests/                            # REQUIRED - Test files
│   └── .gitkeep                     # REQUIRED (if empty)
│
├── docs/                             # REQUIRED - Project documentation
│   ├── README.md                    # REQUIRED - Documentation index
│   │
│   └── [OPTIONAL SUBFOLDERS - Create as needed]
│       ├── patterns/                # OPTIONAL - Project-specific patterns
│       ├── process/                 # OPTIONAL - Project-specific processes
│       ├── collaboration/           # OPTIONAL - Project-specific AI guides
│       ├── api/                     # OPTIONAL - API documentation
│       ├── guides/                  # OPTIONAL - User guides
│       ├── architecture/            # OPTIONAL - Architecture docs
│       └── deployment/              # OPTIONAL - Deployment docs
│
├── templates/                        # OPTIONAL - Only if project produces templates
├── tools/                            # OPTIONAL - Only if project has utilities
│
└── thoughts/                         # REQUIRED - Project management
    ├── work/                         # REQUIRED - Kanban workflow
    │   ├── README.md                # REQUIRED - Minimal workflow reference
    │   │
    │   ├── backlog/                 # REQUIRED - Future work
    │   │   └── .gitkeep            # REQUIRED
    │   │
    │   ├── todo/                    # REQUIRED - Approved work
    │   │   ├── .gitkeep            # REQUIRED
    │   │   └── .limit              # REQUIRED - Contains: 10
    │   │
    │   ├── doing/                   # REQUIRED - Work in progress
    │   │   ├── .gitkeep            # REQUIRED
    │   │   └── .limit              # REQUIRED - Contains: 1
    │   │
    │   └── done/                    # REQUIRED - Completed work
    │       └── .gitkeep            # REQUIRED
    │
    ├── history/                      # REQUIRED
    │   ├── releases/                # REQUIRED - Archived work items by version
    │   ├── sessions/                # REQUIRED - Session history files
    │   ├── spikes/                  # REQUIRED - Experimental research
    │   └── archive/                 # REQUIRED - Cancelled/outdated/superseded items
    │
    ├── research/                     # REQUIRED
    │   ├── README.md                # REQUIRED - Research folder purpose
    │   └── adr/                     # REQUIRED - Architecture Decision Records
    │
    ├── retrospectives/               # REQUIRED - Project retrospectives
    │
    └── external-references/          # REQUIRED - External reference library
        └── README.md                # REQUIRED - Distinction explanation
```

---

## File Specifications

### Root Files (Project Level)

#### `.gitignore` (REQUIRED)
**Purpose:** Git ignore patterns for security, OS, IDE, temporary files

**Content:** See [.gitignore Template](#gitignore-template) section below

**Note:** Single `.gitignore` at repository root (not project-level). Users can add project-specific `.gitignore` if needed.

---

#### `README.md` (REQUIRED)
**Purpose:** Project overview and introduction

**Minimum content:**
- Project name and description
- What problem it solves
- Quick start / usage
- Links to documentation (INDEX.md, CLAUDE.md)
- License and contributing info

**Length:** ~50-150 lines

---

#### `PROJECT-STATUS.md` (REQUIRED)
**Purpose:** Single Source of Truth (SSOT) for project version and status

**Minimum content:**
- Current version
- Release date
- Project status (Development, Alpha, Beta, Stable, Production)
- Core features status
- Known issues
- Pending work summary

**Template:** Use `PROJECT-STATUS-TEMPLATE.md` from framework templates

---

#### `CHANGELOG.md` (REQUIRED)
**Purpose:** Version history and changes

**Format:** [Keep a Changelog](https://keepachangelog.com/) format

**Sections:**
- [Unreleased]
- [Version] - Date
  - Added
  - Changed
  - Deprecated
  - Removed
  - Fixed
  - Security

**Template:** Use `CHANGELOG-TEMPLATE.md` from framework templates

---

#### `CLAUDE.md` (REQUIRED)
**Purpose:** AI collaboration guide and project contract

**Minimum content:**
- Project overview
- Architecture summary
- Coding standards
- Workflow process
- Testing strategy
- Security requirements

**Template:** Use `CLAUDE-TEMPLATE.md` from framework templates

---

#### `INDEX.md` (REQUIRED)
**Purpose:** Master documentation index

**Minimum content:**
- Links to core documents (README, PROJECT-STATUS, CHANGELOG, CLAUDE)
- Links to documentation (docs/)
- Links to project management (thoughts/)

**Template:** Use `INDEX-TEMPLATE.md` from framework templates

---

#### `LICENSE` (OPTIONAL)
**Purpose:** Project license

**When to include:**
- If different from repository license
- If project is standalone
- If license terms differ from framework

---

### `docs/` Folder Files

#### `docs/README.md` (REQUIRED)
**Purpose:** Documentation index for the project

**Minimum content:**
```markdown
# Project Documentation

[Brief description of what documentation exists]

## Documentation

- [Link to doc 1]
- [Link to doc 2]

---

**Last Updated:** YYYY-MM-DD
```

**Organization:**
- Keep flat until 5+ documents OR clear categories emerge
- Use subfolders when needed (api/, guides/, architecture/, etc.)
- AI proposes subfolder organization for user approval

---

### `thoughts/` Folder Files

#### `thoughts/work/README.md` (REQUIRED)
**Purpose:** Minimal workflow reference

**Content:**
```markdown
# Kanban Workflow

This folder manages work items using a Kanban workflow.

See [docs/process/kanban-workflow.md](../../docs/process/kanban-workflow.md) for complete workflow specification.

## WIP Limits

- `todo/.limit` - Maximum items in todo/ (default: 10)
- `doing/.limit` - Maximum items in doing/ (default: 1)
```

**Framework project:** Links to `../../docs/process/kanban-workflow.md`
**User projects:** Links to `../../../framework/docs/process/kanban-workflow.md`

---

#### `thoughts/work/todo/.limit` (REQUIRED)
**Purpose:** WIP (Work In Progress) limit for todo/ folder

**Content:** Plain text number
```
10
```

**Format:** Single integer on first line
**Default:** `10`
**Changeable:** Yes, by user

---

#### `thoughts/work/doing/.limit` (REQUIRED)
**Purpose:** WIP (Work In Progress) limit for doing/ folder

**Content:** Plain text number
```
1
```

**Format:** Single integer on first line
**Default:** `1`
**Changeable:** Yes, by user

---

#### `thoughts/research/README.md` (REQUIRED)
**Purpose:** Explain research folder purpose and distinction from external-references/

**Content:**
```markdown
# Research

This folder contains **project-specific research and decisions**.

**Purpose:** Document investigations, analysis, and architectural decisions for THIS project.

**Deletion Test:** If this folder is deleted, we lose critical project intellectual property and decision rationale. This content is IRREPLACEABLE.

**Store here:**
- ✅ Architecture Decision Records (ADRs)
- ✅ Technology evaluations (Stripe vs PayPal)
- ✅ Competitive analysis
- ✅ Feature feasibility studies
- ✅ Third-party integration investigations
- ✅ Performance benchmarking results
- ✅ Security analysis
- ✅ Idea collections that spawn work items

**Do NOT store here:**
- ❌ External references (use external-references/)
- ❌ Active work items (use work/)

**Rule:** If it explains WHY we made a decision, it goes here.

**Idea Collections:** Files containing multiple enhancement ideas or observations that will generate work items. Track created work items in the file, archive when exhausted.

See also: [external-references/README.md](../external-references/README.md) for distinction.
```

---

#### `thoughts/external-references/README.md` (REQUIRED)
**Purpose:** Explain external-references folder purpose and distinction from research/

**Content:**
```markdown
# External References

This folder contains **authoritative external references** for offline/quick access.

**Purpose:** Convenience cache of fact-based, authoritative sources.

**Deletion Test:** If this folder is deleted, we lose convenience but NOT project understanding. All content should be re-findable from authoritative sources.

**Store here:**
- ✅ RFC specifications
- ✅ Official API documentation (versioned snapshots)
- ✅ Industry standards (ISO, IEEE, W3C)
- ✅ Language specifications (ECMAScript, Python PEP)
- ✅ Authoritative cheat sheets

**Do NOT store here:**
- ❌ Blog posts or opinion pieces → Use `research/` if analyzing
- ❌ Our analysis or investigations → Use `research/`
- ❌ Competitive analysis → Use `research/`
- ❌ Tutorial articles → Bookmark externally

**Rule:** Only authoritative, replaceable, fact-based references.

See also: [research/README.md](../research/README.md) for distinction.
```

---

### `.gitkeep` Files

**Purpose:** Ensure empty folders exist after git clone

**Locations (6 files per project):**
1. `src/.gitkeep`
2. `tests/.gitkeep`
3. `thoughts/work/backlog/.gitkeep`
4. `thoughts/work/todo/.gitkeep`
5. `thoughts/work/doing/.gitkeep`
6. `thoughts/work/done/.gitkeep`

**Policy:** Selective strategy (only where needed for user experience)

**Retention:** Keep `.gitkeep` files forever (don't delete when folder has files)

**Rationale:**
- Ensures folder visibility after clone
- Critical for workflow folders (user knows where to put work items)
- Prevents "where do I put this?" confusion for new projects

---

## .gitignore Template

**Location:** Repository root only (applies to all projects)

**Content:**
```gitignore
# =============================================================================
# Project Framework - Repository .gitignore
# =============================================================================
#
# This file contains patterns for the project-framework repository.
#
# RECOMMENDATION: Set up a global .gitignore for personal preferences
# (OS-specific, IDE-specific patterns). See:
# https://docs.github.com/en/get-started/getting-started-with-git/ignoring-files#configuring-ignored-files-for-all-repositories-on-your-computer
#
# Users are expected to customize this file for their project needs.
#
# =============================================================================

# =============================================================================
# Security & Secrets (NEVER COMMIT THESE)
# =============================================================================
# Environment variables
.env
.env.local
.env.development
.env.test
.env.production
.env.*.local

# Keep example files
!.env.example

# Secrets and credentials
secrets/
credentials/
*.key
*.pem
*.p12
*.pfx
api-keys.*
**/config/secrets.*

# =============================================================================
# OS-Specific (Recommend moving to global .gitignore)
# =============================================================================
# macOS
.DS_Store
.AppleDouble
.LSOverride
._*

# Windows
Thumbs.db
Thumbs.db:encryptable
ehthumbs.db
Desktop.ini
$RECYCLE.BIN/

# Linux
*~
.directory
.Trash-*

# =============================================================================
# IDE & Editors (Recommend moving to global .gitignore)
# =============================================================================
# VSCode
.vscode/*
!.vscode/extensions.json
!.vscode/tasks.json

# JetBrains (IntelliJ, PyCharm, WebStorm, etc.)
.idea/
*.iml
*.ipr
*.iws

# Sublime Text
*.sublime-project
*.sublime-workspace
*.tmlanguage.cache
*.tmPreferences.cache

# Vim
[._]*.s[a-v][a-z]
[._]*.sw[a-p]
[._]s[a-rt-v][a-z]
[._]ss[a-gi-z]
[._]sw[a-p]
*.un~
Session.vim

# Emacs
*~
\#*\#
.\#*

# =============================================================================
# Temporary & Cache Files
# =============================================================================
*.tmp
*.temp
*.bak
*.swp
*.swo
*.log
*.cache
*~
tmp/
temp/
cache/
logs/

# =============================================================================
# Build Artifacts & Dependencies
# =============================================================================
# Node.js
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.npm
.yarn/

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
venv/
.venv/
ENV/
env/

# Ruby
*.gem
*.rbc
/.config
/coverage/
/InstalledFiles
/pkg/
/spec/reports/
/test/tmp/
/test/version_tmp/
/tmp/

# =============================================================================
# Project-Specific
# =============================================================================
# Local development
local/
*.local

# User uploads (if applicable)
uploads/
user-content/

# Scratch/experimental files
scratch/
experiments/
```

---

## Initialization Checklist

When creating a new Standard Framework project:

**Phase 1: Create folder structure**
- [ ] Create all REQUIRED folders (use structure tree above)
- [ ] Add `.gitkeep` to 6 locations (src, tests, work/backlog, work/todo, work/doing, work/done)

**Phase 2: Create REQUIRED files**
- [ ] `.gitignore` (copy from repository root or use template above)
- [ ] `README.md` (use README-TEMPLATE.md)
- [ ] `PROJECT-STATUS.md` (use PROJECT-STATUS-TEMPLATE.md)
- [ ] `CHANGELOG.md` (use CHANGELOG-TEMPLATE.md)
- [ ] `CLAUDE.md` (use CLAUDE-TEMPLATE.md)
- [ ] `INDEX.md` (use INDEX-TEMPLATE.md)

**Phase 3: Create docs/ files**
- [ ] `docs/README.md` (minimal documentation index)

**Phase 4: Create thoughts/ files**
- [ ] `thoughts/work/README.md` (minimal workflow reference)
- [ ] `thoughts/work/todo/.limit` (contains: `10`)
- [ ] `thoughts/work/doing/.limit` (contains: `1`)
- [ ] `thoughts/research/README.md` (research purpose explanation)
- [ ] `thoughts/external-references/README.md` (distinction explanation)

**Phase 5: Initialize git**
- [ ] `git init`
- [ ] `git add .`
- [ ] `git commit -m "Initial project setup from Standard Framework"`
- [ ] `git tag -a v0.1.0 -m "Initial setup"`

**Phase 6: Customize**
- [ ] Update all placeholder text in templates
- [ ] Set project name, description, author
- [ ] Set initial version (v0.1.0)
- [ ] Customize CLAUDE.md for project specifics

---

## Validation Checklist

To verify a project matches Standard Framework structure:

**Folder structure validation:**
- [ ] All REQUIRED folders exist
- [ ] Folder hierarchy matches specification (3 levels max in thoughts/)
- [ ] No extra unexpected folders (unless project-specific)

**File validation:**
- [ ] All REQUIRED root files present (README, PROJECT-STATUS, CHANGELOG, CLAUDE, INDEX)
- [ ] `docs/README.md` exists
- [ ] All `.gitkeep` files in correct locations (6 total)
- [ ] `.limit` files exist and contain correct defaults

**Content validation:**
- [ ] `.gitignore` contains security patterns (secrets, .env)
- [ ] `README.md` has project name and description
- [ ] `PROJECT-STATUS.md` has current version
- [ ] `CHANGELOG.md` follows Keep a Changelog format
- [ ] `.limit` files contain integers only
- [ ] `thoughts/work/README.md` references workflow doc
- [ ] `thoughts/research/README.md` explains purpose
- [ ] `thoughts/external-references/README.md` explains distinction

**Git validation:**
- [ ] Repository initialized
- [ ] Initial commit exists
- [ ] Initial version tagged (v0.1.0 or similar)

---

## Framework-Specific Additions

The framework project adds these to the universal structure:

**Additional folders:**
```
framework/
├── [UNIVERSAL STRUCTURE]
│
└── Additional framework-specific:
    ├── templates/           # Framework deliverable templates
    └── tools/               # Framework deliverable utilities
```

**Enhanced docs/ structure:**
```
framework/docs/
├── README.md                # REQUIRED
├── patterns/                # Framework implementation patterns
├── process/                 # Framework process documentation
└── collaboration/           # Framework AI collaboration guides
```

These additions are OPTIONAL for user projects (only if project produces templates/tools or needs custom docs).

### Framework-Specific Exceptions

The framework project intentionally deviates from Standard structure:

**Missing Folders:**
- `src/` - Framework has no executable source code
- `tests/` - Framework has no code tests currently

**Rationale:** Framework produces templates and documentation, not executable code. It is primarily a documentation and template delivery project.

**Additional Folders:**
- `templates/` - Framework deliverable templates (19 production templates)
- `tools/` - Framework deliverable utilities
- `process/` - Framework workflow documentation
- `patterns/` - Framework implementation patterns

**Reference:** FEAT-026-P1-BUG-framework-structure.md (v3.0.0 migration decisions)

---

## Notes

**Version:** This is the Standard Framework level structure. Light and Minimal levels have different (simpler) structures.

**Flexibility:** User projects can add project-specific folders/files beyond this structure. Required items must remain.

**Validation:** Future tooling may validate projects against this specification automatically.

**Migration:** Projects migrating from v2.x to v3.0.0 should follow FEAT-026 migration plan.

---

## References

- [FEAT-026-structure-migration.md](FEAT-026-structure-migration.md) - Migration plan to v3.0.0
- [FEAT-026-universal-structure-decisions.md](FEAT-026-universal-structure-decisions.md) - Complete decision log
- Framework templates folder - Copy-paste starting points for all files

---

**Last Updated:** 2026-01-05
**Version:** 3.0.0 (Draft)
**Status:** Ready for migration implementation

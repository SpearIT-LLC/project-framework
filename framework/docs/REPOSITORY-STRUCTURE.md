# Repository Structure - project-framework

**Version:** 3.0.0
**Status:** Published
**Last Updated:** 2026-01-27
**Purpose:** Definitive reference for project-framework repository root structure

---

## Overview

This document defines the **repository root structure** for the project-framework repository.

**Important distinction:**
- This document defines **REPOSITORY** structure (source code repository for developing the framework)
- For **USER PROJECT** structure, see [PROJECT-STRUCTURE-STANDARD.md](PROJECT-STRUCTURE-STANDARD.md)

**This repository:**
- Source code for developing the framework itself
- `framework/` folder contains the packaged framework content (documentation, templates, tools)
- Repository root has project management files for developing the framework
- Users receive the `framework/` contents via the distribution archive

---

## Repository Root Structure

```
project-framework/                    # REPOSITORY (not a project)
├── README.md                         # REQUIRED - Repo overview
├── QUICK-START.md                    # REQUIRED - Fast navigation guide
├── CLAUDE.md                         # REQUIRED - AI navigation hub
├── LICENSE                           # REQUIRED - Repo-wide license
├── .gitignore                        # REQUIRED - Repo-wide git ignores
├── CONTRIBUTING.md                   # OPTIONAL - Contribution guidelines
│
├── framework/                        # PROJECT (follows Standard Framework structure)
│   └── [See PROJECT-STRUCTURE-STANDARD.md]
│
├── templates/                        # Template packages for new projects
│   └── starter/                     # Complete project scaffolding with framework
│
└── tools/                            # Build and setup scripts
    └── Build-FrameworkArchive.ps1   # Creates distribution archive
```

---

## Required Files

### `README.md` (REQUIRED)

**Purpose:** Repository overview - what is this repository?

**Target audience:** First-time visitors, potential users

**Minimum content:**
- Repository description
- High-level goals/vision
- What's inside (framework + sample projects)
- Who should use this
- Links to QUICK-START.md
- License info
- Contributing info

**Length:** ~50-100 lines

**Template:** (TBD - create during migration)

---

### `QUICK-START.md` (REQUIRED)

**Purpose:** Fast navigation guide - get me to what I need FAST

**Target audience:** Users who know they want the framework, need fast path

**Minimum content:**
- Decision tree ("What do you want to do?")
- Quick links to key documents
- Common tasks with direct links
- NO duplication of content (just navigation)

**Length:** ~30-50 lines

**Template:** (TBD - create during migration)

**Note:** Will need more explanation/instructions post-reorg (users may not know what "framework" means in our context). Will revisit after migration complete.

---

### `CLAUDE.md` (REQUIRED)

**Purpose:** AI navigation hub - orient to repository structure

**Target audience:** AI assistants working in the repository

**Content:**
```markdown
# CLAUDE.md - Repository Root

**Repository:** project-framework
**Contains:** Framework project + Example projects

---

## Quick Navigation

**Working on the framework itself?**
→ Read [framework/CLAUDE.md](framework/CLAUDE.md)

**Working on templates?**
→ Work in [templates/](templates/)

---

## Repository Structure

This repository contains:
- `framework/` - The framework itself (reusable, universal)
- `templates/` - Template packages for new projects
- `tools/` - Build scripts for distribution

The framework project follows the Standard Framework structure.

---

**When in doubt:** Read the project-specific CLAUDE.md for detailed guidance.
```

**Length:** ~20-30 lines

**Rationale:**
- ✅ Immediate context - AI knows this repository contains multiple projects
- ✅ Clear navigation - Decision tree to correct project CLAUDE.md
- ✅ Reduces cognitive load - No guessing which project we're working on
- ✅ Consistency - Completes the trio (README, QUICK-START, CLAUDE)

**Reference:** See DECISION-015 in [FEAT-026-universal-structure-decisions.md](FEAT-026-universal-structure-decisions.md)

---

### `LICENSE` (REQUIRED)

**Purpose:** Repo-wide license

**Content:** Legal license text (applies to all projects in repository)

**Location:** Repository root only (applies to all)

**Note:** Individual projects MAY have their own LICENSE if different from repository license (rare).

---

### `.gitignore` (REQUIRED)

**Purpose:** Repo-wide git ignore patterns

**Location:** Repository root only (single source)

**Content:** See [PROJECT-STRUCTURE-STANDARD.md](PROJECT-STRUCTURE-STANDARD.md#gitignore-template) for complete template

**Key sections:**
- Security & Secrets (NEVER COMMIT)
- OS-Specific
- IDE & Editors
- Temporary & Cache Files
- Build Artifacts & Dependencies
- Project-Specific

**Best practices:**
- Create before first commit
- Framework-specific templates
- Comments explaining complex patterns
- Security-critical patterns always included
- Recommend users set up global .gitignore for personal preferences

**Note:** Users can add project-specific .gitignore if needed, but repository root .gitignore is the primary source.

---

## Optional Files

### `CONTRIBUTING.md` (OPTIONAL)

**Purpose:** Contribution guidelines

**When to include:**
- If repository accepts external contributions
- If there are specific contribution workflows

**Content:**
- How to contribute
- Code of conduct
- Pull request process
- Development setup

---

## What's NOT at Repository Root

These files live **inside each project**, not at repository root:

❌ **PROJECT-STATUS.md** - Each project has its own version tracking
❌ **CHANGELOG.md** - Each project has its own change history
❌ **INDEX.md** - Each project has its own documentation index
❌ **Project-specific folders** (src/, tests/, docs/, project-hub/) - All inside projects

**Why?**
- Each project is self-contained
- Users copy framework/ folder and get EVERYTHING
- Clean separation of concerns
- Scales to multiple projects

---

## Framework Source Repository vs User Projects

### This Repository (Framework Source)

The framework source repository structure for developing the framework itself:

```
project-framework/           # Repository root
├── README.md               # Repository overview
├── QUICK-START.md          # Navigation guide
├── CLAUDE.md               # AI navigation hub
├── LICENSE                 # Repository-wide license
├── .gitignore              # Repository-wide ignores
│
├── docs/                   # Framework development project management
│   └── project/            # Roadmap for framework development
│       └── ROADMAP.md      # Strategic direction for this project
│
├── framework/              # Packaged framework content (what users get)
│   ├── docs/               # Framework documentation (user-facing)
│   ├── templates/          # Work item and planning templates
│   ├── tools/              # PowerShell utilities
│   └── project-hub/        # Framework's own work tracking
│
├── templates/              # Project scaffolding templates
│   └── starter/            # Complete starter template with framework included
│
└── tools/                  # Build and distribution scripts
    └── Build-FrameworkArchive.ps1
```

**Key insight:** `framework/` is analogous to `src/` in a code project - it's the packaged content that gets distributed.

### User Projects

When users create projects from the starter template, they get:

```
my-awesome-project/         # User's repository root
├── README.md              # Project overview
├── PROJECT-STATUS.md      # Project version/status
├── CHANGELOG.md           # Version history
├── CLAUDE.md              # AI collaboration guide
├── INDEX.md               # Documentation navigation
├── LICENSE
├── .gitignore
│
├── docs/                   # Project documentation
│   └── project/            # Project planning (roadmap)
│       └── ROADMAP.md      # Strategic direction for this project
│
├── src/                    # Source code
├── tests/                  # Test files
│
├── framework/              # Framework package (documentation, templates, tools)
│   ├── docs/               # Framework documentation (read-only)
│   ├── templates/          # Work item templates
│   └── tools/              # PowerShell utilities
│
└── project-hub/            # Project management (user's work items)
    ├── work/               # Kanban workflow
    ├── history/            # Session history, releases
    └── research/           # Research artifacts
```

**They follow PROJECT-STRUCTURE-STANDARD.md directly at repository root.**

---

## Validation Checklist

To verify repository root matches this specification:

**File presence:**
- [ ] `README.md` exists (repo overview)
- [ ] `QUICK-START.md` exists (navigation)
- [ ] `CLAUDE.md` exists (AI navigation)
- [ ] `LICENSE` exists (repo-wide)
- [ ] `.gitignore` exists (repo-wide)

**Content validation:**
- [ ] `README.md` describes repository (not individual project)
- [ ] `QUICK-START.md` has navigation links
- [ ] `CLAUDE.md` points to project-specific CLAUDE.md files
- [ ] `.gitignore` contains security patterns

**Structure validation:**
- [ ] Project folders exist (framework/, templates/, tools/)
- [ ] framework/ follows PROJECT-STRUCTURE-STANDARD.md
- [ ] No project-specific files at root (PROJECT-STATUS.md, CHANGELOG.md, INDEX.md)

---

## Implementation

**When creating repository:**
1. Initialize git repository
2. Create all REQUIRED root files (5 files)
3. Create project folders (framework/, templates/, tools/)
4. Populate framework/ following PROJECT-STRUCTURE-STANDARD.md
5. Commit: `git commit -m "Initial repository setup"`

**Migration (FEAT-026):**
- Created in Phase 1 (create root files)
- See [FEAT-026-structure-migration.md](FEAT-026-structure-migration.md) for migration plan

---

## References

- [PROJECT-STRUCTURE-STANDARD.md](PROJECT-STRUCTURE-STANDARD.md) - Standard Framework project structure
- [FEAT-026-structure-migration.md](FEAT-026-structure-migration.md) - Migration plan
- [FEAT-026-universal-structure-decisions.md](FEAT-026-universal-structure-decisions.md) - Complete decision log
  - DECISION-012: Multi-Project Repository with Meta-Root
  - DECISION-013: README vs QUICK-START Separation
  - DECISION-015: Add CLAUDE.md to Repository Root

---

## Notes

**Scope:** This document defines repository root structure ONLY. For project structure, see PROJECT-STRUCTURE-*.md documents.

**Scalability:** When adding new project types (LIGHT, MINIMAL), this document remains unchanged. Only PROJECT-STRUCTURE-*.md documents are added.

**DRY Principle:** Single source of truth for repository root structure. Referenced by all project structure documents.

---

**Created:** 2026-01-06
**Last Updated:** 2026-01-06
**Version:** 3.0.0 (Draft)
**Status:** Ready for migration implementation

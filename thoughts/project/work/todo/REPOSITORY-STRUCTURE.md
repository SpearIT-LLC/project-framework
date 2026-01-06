# Repository Structure - project-framework

**Version:** 3.0.0
**Status:** Draft
**Last Updated:** 2026-01-06
**Purpose:** Definitive reference for project-framework repository root structure
**Location (after migration):** `framework/docs/REPOSITORY-STRUCTURE.md`
**Location (current):** `thoughts/project/planning/backlog/REPOSITORY-STRUCTURE.md` (migration planning)

---

## Overview

This document defines the **repository root structure** for the project-framework monorepo.

**Important distinction:**
- This document defines **REPOSITORY** structure (meta-level container)
- For **PROJECT** structure, see:
  - [PROJECT-STRUCTURE-STANDARD.md](PROJECT-STRUCTURE-STANDARD.md) - Standard Framework level
  - PROJECT-STRUCTURE-LIGHT.md (future) - Light Framework level
  - PROJECT-STRUCTURE-MINIMAL.md (future) - Minimal Framework level

**Repository ≠ Project:**
- Repository root contains multiple projects
- Each project follows its own structure standard
- Repository root is minimal (just navigation and meta files)

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
└── project-hello-world/              # PROJECT (follows Standard Framework structure)
    └── [See PROJECT-STRUCTURE-STANDARD.md]
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

**Purpose:** AI navigation hub - orient to monorepo structure

**Target audience:** AI assistants working in the repository

**Content:**
```markdown
# CLAUDE.md - Repository Root

**Repository:** project-framework (monorepo)
**Contains:** Framework project + Sample projects

---

## Quick Navigation

**Working on the framework itself?**
→ Read [framework/CLAUDE.md](framework/CLAUDE.md)

**Working on hello-world sample?**
→ Read [project-hello-world/CLAUDE.md](project-hello-world/CLAUDE.md)

**Not sure which project?**
→ Ask the user which project you're working on

---

## Repository Structure

This is a monorepo containing multiple projects:
- `framework/` - The framework itself (reusable, universal)
- `project-hello-world/` - Sample project (validation/reference)

Each project is self-contained and follows the Standard Framework structure.

---

**When in doubt:** Read the project-specific CLAUDE.md for detailed guidance.
```

**Length:** ~20-30 lines

**Rationale:**
- ✅ Immediate context - AI knows it's in a monorepo
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
❌ **Project-specific folders** (src/, tests/, docs/, thoughts/) - All inside projects

**Why?**
- Each project is self-contained
- Users copy framework/ folder and get EVERYTHING
- Clean separation of concerns
- Scales to multiple projects

---

## Monorepo vs Single Project

### This Repository (Monorepo)

```
project-framework/           # Repository root (minimal)
├── README.md               # Repo overview
├── QUICK-START.md          # Navigation
├── CLAUDE.md               # AI navigation
├── LICENSE
├── .gitignore
├── framework/              # Project 1 (complete)
└── project-hello-world/    # Project 2 (complete)
```

### User Projects (Single Project)

When users create their own projects, they typically create a **single project repository**:

```
my-awesome-project/         # Repository root = Project root
├── README.md              # Project overview
├── PROJECT-STATUS.md      # Project version
├── CHANGELOG.md           # Project changes
├── CLAUDE.md              # Project AI guide
├── INDEX.md               # Project docs
├── LICENSE
├── .gitignore
├── src/
├── tests/
├── docs/
└── thoughts/
```

**They follow PROJECT-STRUCTURE-STANDARD.md directly at root.**

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
- [ ] Project folders exist (framework/, project-hello-world/)
- [ ] Each project folder follows appropriate PROJECT-STRUCTURE-*.md
- [ ] No project-specific files at root (PROJECT-STATUS.md, CHANGELOG.md, INDEX.md)

---

## Implementation

**When creating repository:**
1. Initialize git repository
2. Create all REQUIRED root files (5 files)
3. Create project folders (framework/, project-hello-world/)
4. Populate each project following PROJECT-STRUCTURE-STANDARD.md
5. Commit: `git commit -m "Initial repository setup"`

**Migration (FEAT-026):**
- Created in Phase 1 (create root files)
- See [FEAT-026-structure-migration.md](FEAT-026-structure-migration.md) for migration plan

---

## References

- [PROJECT-STRUCTURE-STANDARD.md](PROJECT-STRUCTURE-STANDARD.md) - Standard Framework project structure
- [FEAT-026-structure-migration.md](FEAT-026-structure-migration.md) - Migration plan
- [FEAT-026-universal-structure-decisions.md](FEAT-026-universal-structure-decisions.md) - Complete decision log
  - DECISION-012: Monorepo with Meta-Root
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

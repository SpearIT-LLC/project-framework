# Universal Standard Framework Structure - Decisions Log

**Date:** 2026-01-04 (Session 1), 2026-01-05 (Session 2), 2026-01-06 (Session 3)
**Status:** In Progress - Structure Definition Complete, Minor Additions
**Related:** FEAT-026-structure-migration.md

---

## Purpose

Document the decisions made while defining the Universal Standard Framework structure for v3.0.0. This structure will be used by:
- The framework project itself (dogfooding)
- All user projects created from the framework

---

## Key Principles Established

### 1. Universal Structure Philosophy
- **Framework IS a project** - Framework dogfoods its own structure
- **Core structure is universal** - All Standard Framework projects use the same base
- **Flexibility for extensions** - Projects can add project-specific folders as needed
- **Required vs Optional** - Clear distinction between mandatory and optional folders

### 2. Folder Structure First, Files Second
- Agreed to define complete folder structure before specifying files
- Ensures clean architecture foundation

### 3. Framework-Specific Content
- Framework has additional folders (`templates/`, `tools/`, enhanced `docs/`)
- These are OPTIONAL for user projects (only if project produces templates/tools)
- User projects CAN use same `docs/` subfolders if needed (patterns/, process/, collaboration/)

---

## Folder Structure Decisions

### Root Level (All Projects)

```
[project-name]/
├── .git/                    # Git repository
├── .gitignore               # REQUIRED
├── LICENSE                  # OPTIONAL
├── README.md                # REQUIRED
├── PROJECT-STATUS.md        # REQUIRED - SSOT for version/status
├── CHANGELOG.md             # REQUIRED
├── INDEX.md                 # REQUIRED
├── CLAUDE.md                # REQUIRED
│
├── src/                     # REQUIRED - Source code (.gitkeep if empty)
├── tests/                   # REQUIRED - Tests (.gitkeep if empty)
├── docs/                    # REQUIRED - Project documentation
├── templates/               # OPTIONAL - Only if project produces templates
├── tools/                   # OPTIONAL - Only if project has utilities
│
└── thoughts/                # REQUIRED - Project management
```

**Decision Rationale:**
- `src/`, `tests/`, `docs/` are UNIVERSAL and REQUIRED for all projects
- Forces good structure from day one
- `templates/` and `tools/` only for projects that produce them (framework does)

---

### `docs/` Folder Structure

```
docs/
├── README.md                # REQUIRED - Documentation index
│
└── [OPTIONAL SUBFOLDERS - Created as needed]
    ├── patterns/            # Project-specific implementation patterns
    ├── process/             # Project-specific processes
    ├── collaboration/       # Project-specific AI/team guides
    ├── api/                 # API documentation
    ├── guides/              # User guides, tutorials
    ├── architecture/        # Architecture decisions, diagrams
    ├── deployment/          # Deployment, configuration
    └── [project-specific]/  # Any other categories
```

**Decision Rationale:**
- `docs/README.md` is REQUIRED - serves as documentation index
- All subfolders are OPTIONAL - created when needed
- Threshold guideline: Keep flat until 5+ docs OR clear categories emerge
- AI proposes subfolder organization for user approval when threshold reached
- Framework uses `patterns/`, `process/`, `collaboration/` - user projects CAN too

**Framework-Specific:**
- Framework project WILL have `patterns/`, `process/`, `collaboration/` populated
- These are framework deliverables (universal guides)

---

### `thoughts/` Folder Structure

```
thoughts/                           # REQUIRED - Project management
├── work/                           # REQUIRED - Kanban workflow
│   ├── backlog/.gitkeep           # REQUIRED - Flattened from planning/backlog/
│   ├── todo/.gitkeep              # REQUIRED
│   ├── doing/                     # REQUIRED
│   │   ├── .gitkeep              # REQUIRED
│   │   └── .limit                # REQUIRED - Contains WIP limit (default: 1)
│   └── done/.gitkeep              # REQUIRED
│
├── history/                        # REQUIRED
│   ├── releases/                  # REQUIRED - Archived work items by version
│   ├── sessions/                  # REQUIRED - Session history files
│   └── spikes/                    # REQUIRED - Experimental research (NEW LOCATION)
│
├── research/                       # REQUIRED
│   └── adr/                       # REQUIRED - Architecture Decision Records
│
├── retrospectives/                 # REQUIRED
├── external-references/            # REQUIRED - External reference library
└── archive/                        # REQUIRED - Historical/outdated docs
```

**Decision Rationale:**
- **Flattened structure:** `planning/backlog/` → `work/backlog/` (removes extra nesting)
- **Spikes moved:** From `thoughts/project/history/spikes/` to `thoughts/history/spikes/`
- **External references renamed:** From `reference/` to `external-references/` for clarity
- **All top-level folders REQUIRED** - Core workflow needs visibility

---

### `.gitkeep` Policy

**Decision: Option 1-B - Selective `.gitkeep` (6 files)**

**Use `.gitkeep` in these folders:**
```
src/.gitkeep                        # Prevents "where do I put code?" confusion
tests/.gitkeep                      # Prevents "where do I put tests?" confusion
thoughts/work/backlog/.gitkeep      # Critical workflow visibility
thoughts/work/todo/.gitkeep         # Critical workflow visibility
thoughts/work/doing/.gitkeep        # Critical workflow visibility
thoughts/work/done/.gitkeep         # Critical workflow visibility
```

**Do NOT use `.gitkeep` in:**
- `thoughts/history/*` - Will populate naturally on first release/session/spike
- `thoughts/research/adr/` - Will populate on first ADR
- `thoughts/retrospectives/` - Will populate on first retro
- `thoughts/external-references/` - May never be used
- `thoughts/archive/` - Will populate when needed

**Keep `.gitkeep` forever** - Don't delete even when folder has files (especially important for `work/` folders and new projects)

**Rationale:**
- Reduces clutter (6 files instead of 13)
- Focuses on critical workflow folders that must be visible immediately
- Other folders will populate naturally during project lifecycle
- Can review after we add files to structure

---

### `thoughts/research/` vs `thoughts/external-references/` Distinction

**Critical distinction using "Deletion Test" mental framework:**

#### `thoughts/research/` = PROJECT INTELLECTUAL PROPERTY
**Purpose:** Document investigations, analysis, and architectural decisions for THIS project.

**Deletion Impact:** CRITICAL - Irreplaceable project knowledge, breaks decision trail

**Store here:**
- ✅ Architecture Decision Records (ADRs)
- ✅ Technology evaluations (Stripe vs PayPal)
- ✅ Competitive analysis
- ✅ Feature feasibility studies
- ✅ Third-party integration investigations
- ✅ Performance benchmarking results
- ✅ Security analysis

**Rule:** If it explains WHY we made a decision, it goes here.

---

#### `thoughts/external-references/` = CONVENIENCE CACHE
**Purpose:** Authoritative external references for offline/quick access.

**Deletion Impact:** MINOR - Inconvenience, but all content re-findable from authoritative sources

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

---

**Deletion Test Framework (Hypothetical):**
Ask: "If this folder disappeared, what's the impact?"
- Critical/irreplaceable → `research/`
- Inconvenient/replaceable → `external-references/`

**NOT an actual test to run** - this is a mental framework for decision-making.

---

### Multi-Repository Strategy

**Decision: Option D - Monorepo with Post-Setup Separation**

**Development structure:**
```
project-framework/
├── .git/                    # Single repo during development
├── framework/               # The framework project
└── project-hello-world/     # Sample user project (reference example)
```

**User workflow:**
1. User clones `project-framework` repo → Sees complete structure
2. User reviews `framework/` and `project-hello-world/` as references
3. User creates NEW project → Fresh git repo (clean separation)

**Rationale:**
- **Development convenience:** Framework + example developed together
- **User visibility:** Users see full structure when they clone
- **Clean separation:** Users create fresh repos for their projects
- **Hello-world role:** Reference example, not meant to be user's actual project

**In universal structure documentation:**
- Show `.git/` at project root (for individual projects)
- Explain that framework repo is special (contains framework + example)
- Document how to create new projects from framework

---

## Special Files

### `thoughts/work/doing/.limit`
- **Purpose:** Contains WIP (Work In Progress) limit number
- **Default value:** `1` (changeable by user)
- **Location:** `thoughts/work/doing/.limit`
- **Required:** YES

---

## Additional Decisions (2026-01-05 Session)

### Need for Structure Definition Template

**DECISION-010: Create PROJECT-STRUCTURE-STANDARD.md**
**Date:** 2026-01-05

**Issue identified:** No single authoritative document defines what a Standard Framework project structure contains.

**Current state:**
- Structure is IMPLIED by copying template
- Structure is PARTIALLY shown in CLAUDE-TEMPLATE (but outdated)
- Structure is REFERENCED in NEW-PROJECT-CHECKLIST (but not definitive)

**Decision:** Create separate `PROJECT-STRUCTURE-STANDARD.md` reference document

**Rationale:**
- ✅ **Single responsibility** - One doc = structure definition
- ✅ **Reusable reference** - Can link from multiple places
- ✅ **Scalable** - Easy to add LIGHT, MINIMAL later (PROJECT-STRUCTURE-LIGHT.md, etc.)
- ✅ **Validation ready** - Can programmatically check against it
- ✅ **Framework-level** - This is framework documentation, not project planning
- ✅ **Not template bloat** - Missing foundational document that should have existed from v1.0.0

**Location:** `framework/docs/PROJECT-STRUCTURE-STANDARD.md` (after v3.0.0 migration)

**Usage:**
- Framework itself (dogfooding - check our own structure)
- NEW-PROJECT-CHECKLIST.md (references it)
- CLAUDE-TEMPLATE.md (references it instead of duplicating)
- Users creating new projects
- AI validating project structure
- Future: Automated structure validation scripts

**Contains:**
- Complete folder structure (from yesterday's decisions)
- All required files
- All optional files
- .gitkeep policy
- Initialization checklist
- Validation checklist

**Implementation:** Add to FEAT-026 Phase 1 (create BEFORE migration starts, use as migration target)

---

### Migration Strategy

**DECISION-011: Use Copy-Then-Validate-Then-Delete Migration Strategy**
**Date:** 2026-01-05

**Options evaluated:**
- Option A: Parallel structure (copy, validate, delete)
- Option B: In-place transformation (git mv)
- Option C: Separate repos

**Decision:** Option A - Copy strategy on migration branch (Hybrid approach with incremental commits)

**Approach:**
1. Create `feat-026-migration` branch
2. Copy files category-by-category (incremental)
3. Fix links in new files as we go
4. Commit after each category (incremental validation)
5. Keep old structure until new is validated
6. Delete old structure in final commit
7. Merge to main when confident

**Rationale:**
- ✅ Safety net (original preserved until validated)
- ✅ Can compare old vs new side-by-side
- ✅ Can validate fully before committing to deletion
- ✅ Less risky (if we mess up new structure, old is intact)
- ✅ Incremental progress (can review each category)
- ✅ Clean final state (only new structure in main after merge)
- ✅ Rollback capability (delete branch if problems)
- ✅ File integrity more important than git history for this one-time restructure

**Trade-off accepted:**
- Git file history lost (files appear as "new" in new locations)
- But migration is documented in FEAT-026
- This is a one-time major restructure (v3.0.0)
- Future changes will have proper history

**Link-fixing strategy:**
1. Move/copy file to new location
2. Fix links INSIDE that file immediately (while in memory)
3. Search entire repo for links TO that file (from other files)
4. Fix those references
5. Commit both changes
6. Move to next file/category

**Prevents:**
- Broken links accumulating
- Forgetting what was moved
- Massive link-fixing session at end (error-prone)

---

### Repository vs Project Distinction

**DECISION-012: Monorepo with Meta-Root**
**Date:** 2026-01-05

**Issue identified:** With framework/ and project-hello-world/ as separate folders, what goes at repository root?

**Decision:** Repository root is meta-level (not a project), contains multiple projects

**Structure:**
```
project-framework/                    # REPOSITORY (not a project)
├── README.md                         # Repo overview
├── QUICK-START.md                    # Fast navigation guide
├── CLAUDE.md                         # AI navigation hub
├── LICENSE                           # Repo-wide license
├── .gitignore                        # Repo-wide git ignores
├── CONTRIBUTING.md                   # OPTIONAL
│
├── framework/                        # PROJECT (follows universal structure)
│   └── [COMPLETE PROJECT STRUCTURE]
│
└── project-hello-world/              # PROJECT (follows universal structure)
    └── [COMPLETE PROJECT STRUCTURE]
```

**Rationale:**
- ✅ **True dogfooding** - Framework follows its own structure completely
- ✅ **Clear separation** - Each project self-contained
- ✅ **Scalable** - Could add more example projects later
- ✅ **User clarity** - When they copy framework/, they get EVERYTHING
- ✅ **Universal structure unchanged** - It defines PROJECT structure, not repository structure

**Root files (REQUIRED):**
- README.md - Overview of repo (describes both projects)
- QUICK-START.md - Fast path to using the repo
- CLAUDE.md - AI navigation hub (points to project-specific CLAUDE.md files)
- LICENSE - Legal (applies to all)
- .gitignore - Repo-level

**Root files (NOT PRESENT):**
- PROJECT-STATUS.md - Each project has its own
- CHANGELOG.md - Each project has its own
- INDEX.md - Each project has its own

**Each project is self-contained with its own:**
- README.md, CLAUDE.md, PROJECT-STATUS.md, CHANGELOG.md, INDEX.md
- src/, tests/, docs/
- thoughts/

---

### README vs QUICK-START Separation

**DECISION-013: Clear Separation of Root README and QUICK-START**
**Date:** 2026-01-05

**Purpose of separation:** Avoid overlap between root-level meta files

**Root README.md (Repo Overview):**
- **Purpose:** What is this repository?
- **Content:** Repository description, high-level goals/vision, what's inside, who should use this, links to QUICK-START.md, license info, contributing info
- **Target audience:** First-time visitors, potential users
- **Length:** ~50-100 lines

**Root QUICK-START.md (Navigation Guide):**
- **Purpose:** Get me to what I need FAST
- **Content:** Decision tree ("What do you want to do?"), quick links to key documents, common tasks with direct links, NO duplication of content (just navigation)
- **Target audience:** Users who know they want the framework, need fast path
- **Length:** ~30-50 lines

**Note for future:** QUICK-START.md will need more explanation/instructions post-reorg (users may not know what "framework" means in our context). Will revisit after migration complete.

---

### Folder Visibility Strategy

**DECISION-014: Selective Strategy (Meaningful READMEs + .gitkeep)**
**Date:** 2026-01-05

**Issue identified:** How to ensure folders exist after git clone?

**Options evaluated:**
- Option A: .gitkeep everywhere (13 files)
- Option B: No .gitkeep (folders created on-demand)
- Option C: Init script creates folders
- Option D: README files instead of .gitkeep
- Option E: Selective strategy (meaningful READMEs + .gitkeep for simple folders)

**Decision:** Option E - Selective Strategy

**Meaningful READMEs (9 files across both projects):**
- Repository root: README.md
- Each project: README.md, docs/README.md, thoughts/work/README.md, thoughts/research/README.md, thoughts/external-references/README.md

**.gitkeep files (6 per project = 12 total):**
- `src/.gitkeep`
- `tests/.gitkeep`
- `thoughts/work/backlog/.gitkeep`
- `thoughts/work/todo/.gitkeep`
- `thoughts/work/doing/.gitkeep`
- `thoughts/work/done/.gitkeep`

**Retention policy:** Keep .gitkeep forever (don't delete when folder has files)

**Rationale:**
- ✅ Folders exist after git clone
- ✅ READMEs where they provide value
- ✅ Not drowning in README files
- ✅ Future delivery format flexibility

---

### Repository Root CLAUDE.md

**DECISION-015: Add CLAUDE.md to Repository Root**
**Date:** 2026-01-06

**Issue identified:** After v3.0.0 migration, AI needs clear navigation to understand monorepo structure and which project-specific CLAUDE.md to read.

**Decision:** Add CLAUDE.md as REQUIRED file at repository root

**Purpose:** AI navigation hub that orients to repository structure and points to project-specific CLAUDE.md files

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

**Rationale:**
- ✅ **Immediate context** - AI knows it's in a monorepo
- ✅ **Clear navigation** - Decision tree to correct project CLAUDE.md
- ✅ **Reduces cognitive load** - No guessing which project we're working on
- ✅ **Consistency** - Completes the trio (README, QUICK-START, CLAUDE)
- ✅ **Minimal** - ~20-30 lines, just navigation

**Length:** ~20-30 lines

**Implementation:** Add to FEAT-026 Phase 1 (create with other root files)

---

### Separate Repository Structure Document

**DECISION-016: Create REPOSITORY-STRUCTURE.md**
**Date:** 2026-01-06

**Issue identified:** Repository root structure currently embedded in PROJECT-STRUCTURE-STANDARD.md will cause duplication when adding LIGHT and MINIMAL project types.

**Problem:**
- PROJECT-STRUCTURE-STANDARD.md contains both repository root AND project structure
- When we create PROJECT-STRUCTURE-LIGHT.md and PROJECT-STRUCTURE-MINIMAL.md, we'll need to duplicate repository root section
- Violates DRY principle
- Risk of inconsistency (update repo root in 3+ places)

**Decision:** Create separate REPOSITORY-STRUCTURE.md document

**Location:** `framework/docs/REPOSITORY-STRUCTURE.md` (after v3.0.0 migration)

**Separation:**
- REPOSITORY-STRUCTURE.md = Repository root ONLY (README, QUICK-START, CLAUDE, LICENSE, .gitignore)
- PROJECT-STRUCTURE-STANDARD.md = Standard Framework project structure ONLY
- PROJECT-STRUCTURE-LIGHT.md (future) = Light Framework project structure ONLY
- PROJECT-STRUCTURE-MINIMAL.md (future) = Minimal Framework project structure ONLY

**Benefits:**
- ✅ Single source of truth for repository root
- ✅ No duplication across project types
- ✅ Clean separation (repository ≠ project)
- ✅ Easy to reference from all project structure docs
- ✅ Scalable for future project types

**Structure (after v3.0.0 migration):**
```
framework/docs/
├── REPOSITORY-STRUCTURE.md          ← NEW (repo root only)
├── PROJECT-STRUCTURE-STANDARD.md    (references REPOSITORY-STRUCTURE.md)
├── PROJECT-STRUCTURE-LIGHT.md       (future, references REPOSITORY-STRUCTURE.md)
└── PROJECT-STRUCTURE-MINIMAL.md     (future, references REPOSITORY-STRUCTURE.md)
```

**Current location (pre-migration):**
```
thoughts/project/work/todo/
├── FEAT-026-REPOSITORY-STRUCTURE.md          ← Migration planning (drops prefix at final location)
├── FEAT-026-PROJECT-STRUCTURE-STANDARD.md    ← Migration planning (drops prefix at final location)
```

**Cross-references:**
- Each PROJECT-STRUCTURE-*.md references REPOSITORY-STRUCTURE.md
- REPOSITORY-STRUCTURE.md references all PROJECT-STRUCTURE-*.md documents

**Implementation:**
1. Create REPOSITORY-STRUCTURE.md with repository root content
2. Update PROJECT-STRUCTURE-STANDARD.md to remove repository root section
3. Add reference link to REPOSITORY-STRUCTURE.md in PROJECT-STRUCTURE-STANDARD.md
4. Update FEAT-026 Phase 1 to create both documents

---

### Archive Folder Location

**DECISION-017: Move archive/ under history/**
**Date:** 2026-01-07

**Issue identified:** Where should cancelled/outdated/superseded work items and documents be stored?

**Original structure:** `thoughts/archive/` at top level alongside work/, history/, research/, etc.

**Problem:** Archive is inherently historical. Having it at the same level as history/ creates confusion about purpose and organization.

**Decision:** Move `archive/` to be a subfolder of `history/`

**New structure:**
```
thoughts/
├── work/
├── history/
│   ├── releases/
│   ├── sessions/
│   ├── spikes/
│   └── archive/         # NEW LOCATION - Cancelled/outdated/superseded items
├── research/
├── retrospectives/
└── external-references/
```

**Rationale:**
- ✅ **Everything in archive IS historical** - Cancelled work items, outdated docs, superseded processes
- ✅ **history/ is already the "past stuff" container** - Releases, sessions, spikes are all timeline-based
- ✅ **Simpler mental model** - "History contains the past, including archived items"
- ✅ **Cleaner thoughts/ root** - One less top-level folder
- ✅ **Location IS status principle** - archive/ location = archived, file content explains why (cancelled, outdated, superseded)

**archive/ folder purpose:**
- Cancelled work items (with cancellation note in file)
- Outdated documentation (superseded by newer versions)
- Deprecated processes (replaced by better approaches)
- Superseded decisions (kept for context)

**Status field usage in archive/:**
The Status field becomes useful again in archived files because archive contains multiple "types":
- Status: Cancelled (with cancellation reason)
- Status: Outdated (with replacement reference)
- Status: Superseded (with link to replacement)

**Implementation:** Updated in FEAT-026 immediately (2026-01-07)

**First use case:** FEAT-026-P2-TECH-doc-dedup.md cancelled and moved to history/archive/

---

## Next Steps

- [ ] Define FILES for each folder (root files, docs files, thoughts files) - IN PROGRESS
- [ ] Create PROJECT-STRUCTURE-STANDARD.md with complete folder + file definitions
- [ ] Create folder README.md content where needed
- [ ] Update FEAT-026 with finalized universal structure and migration strategy
- [ ] Create detailed migration plan using copy strategy

---

## Open Questions for Later Discussion

1. Should we create a policy document for `.gitkeep` usage? (Deferred)
2. Should we review `.gitkeep` selective approach after adding files? (Yes, planned)
3. QUICK-START.md needs more explanation - revisit after migration (2026-01-05)

---

**Created:** 2026-01-04
**Last Updated:** 2026-01-07
**Status:** Structure definition complete, archive/ relocated to history/archive/ (DECISION-017)

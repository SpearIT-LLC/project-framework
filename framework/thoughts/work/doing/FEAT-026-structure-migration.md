# FEAT-026: Framework Structure Migration (v3.0.0)

**Work Item ID:** FEAT-026
**Type:** Feature (Breaking Change)
**Status:** Doing
**Created:** 2026-01-02
**Updated:** 2026-01-06
**Related:** FEAT-025-brainstorming.md, 2026-01-02-framework-structure-retrospective.md, FEAT-026-universal-structure-decisions.md, PROJECT-STRUCTURE-STANDARD.md
**Version Impact:** MAJOR (v3.0.0)

---

## Summary

Reorganize the project-framework repository to separate framework and project into distinct top-level folders, implementing the "Framework IS a Project" model decided in retrospective.

**Goal:** Create clean structure where framework/ and project-*/ folders coexist at root level, both using Standard framework structure.

---

## Current State (v2.2.5)

### Root Level
```
project-framework/
├── .claude/
├── .git/
├── .gitignore
├── CHANGELOG.md
├── CLAUDE.md
├── CLAUDE-QUICK-REFERENCE.md
├── INDEX.md
├── LICENSE
├── PROJECT-STATUS.md
├── QUICK-REFERENCE.md
├── README.md
├── project-framework-template/    # Template package (minimal/light/standard)
│   ├── minimal/
│   ├── light/
│   └── standard/
└── thoughts/
    └── project/                   # Current project tracking
        ├── archive/
        ├── collaboration/         # AI collaboration guides (7 files)
        ├── history/
        │   ├── releases/         # v2.1.0 through v2.2.5
        │   └── spikes/
        ├── planning/
        │   └── backlog/
        ├── reference/
        ├── research/
        │   └── adr/              # 2 ADRs
        ├── retrospectives/       # 2 retrospectives
        └── work/
            ├── doing/            # Current work
            ├── done/
            └── todo/
```

### What's Missing
- No `thoughts/framework/` folder (framework doesn't dogfood itself yet)
- Templates are in `project-framework-template/standard/thoughts/framework/templates/`
- Process docs are in `project-framework-template/standard/thoughts/framework/process/`
- Patterns are in `project-framework-template/standard/thoughts/framework/patterns/`

---

## Target State (v3.0.0)

**For complete structure specification, see:**
- [FEAT-026-PROJECT-STRUCTURE-STANDARD.md](FEAT-026-PROJECT-STRUCTURE-STANDARD.md) - Universal project structure (SSOT)
- [FEAT-026-universal-structure-decisions.md](FEAT-026-universal-structure-decisions.md) - Decision rationale

### High-Level Overview
```
project-framework/                        # Repository root (monorepo)
├── README.md                            # Repo overview
├── QUICK-START.md                       # Fast navigation guide
├── CLAUDE.md                            # AI navigation hub
├── LICENSE                              # Repo-wide license
├── .gitignore                           # Repo-wide git ignores
│
├── framework/                           # Framework project
│   └── [Standard Project Structure]    # See PROJECT-STRUCTURE-STANDARD.md
│       ├── templates/                   # Framework-specific deliverable
│       ├── tools/                       # Framework-specific deliverable
│       └── docs/                        # Enhanced with process/, patterns/, collaboration/
│
└── project-hello-world/                 # Sample project
    └── [Standard Project Structure]     # See PROJECT-STRUCTURE-STANDARD.md
```

**Key architectural decisions:**
- **Monorepo with meta-root** - Repository root contains multiple projects
- **Framework dogfoods itself** - Follows its own Standard structure completely
- **Structure flattened** - Max 3 levels in thoughts/ (was 4 with planning/backlog/)
- **Clear separation** - Each project self-contained with own docs, status, tracking

---

## Key Changes

### 1. Flatten Structure ✅
**Before:** `thoughts/project/planning/backlog/` (4 levels)
**After:** `thoughts/work/backlog/` (3 levels)

**Rationale:** Remove `planning/` folder, move `backlog/` into `work/`

### 2. Framework Gets Its Own Structure ✅
**New:** `framework/thoughts/` mirrors project structure
**Why:** Framework IS a project, should dogfood its own structure

### 3. Collaboration Guides Move to Framework ✅
**Before:** `thoughts/project/collaboration/`
**After:** `framework/collaboration/`

**Rationale:** These are universal guides, not project-specific

### 4. Templates Reorganized ✅
**Before:** Flat list of 19 templates in one folder
**After:** Categorized into subfolders (work-items/, decisions/, research/, documentation/, project/, wrappers/)

**Rationale:** Easier navigation, clearer organization

### 5. Remove project-framework-template/ ✅
**Before:** Separate `project-framework-template/` folder with minimal/light/standard
**After:** Standard structure IS the template (in framework/ folder)

**Rationale:**
- Focusing only on Standard level for v3.0.0
- Minimal/Light deferred
- Eliminates duplication

---

## Migration Mapping

### Root Files
| Current Location | Target Location | Action | Notes |
|-----------------|----------------|--------|-------|
| CHANGELOG.md | framework/CHANGELOG.md | MOVE | Framework changes |
| CLAUDE.md | framework/CLAUDE.md | MOVE | Framework project guide |
| PROJECT-STATUS.md | framework/PROJECT-STATUS.md | MOVE | Framework version |
| INDEX.md | framework/INDEX.md | MOVE | Framework index |
| CLAUDE-QUICK-REFERENCE.md | framework/CLAUDE-QUICK-REFERENCE.md | MOVE | Framework quick ref |
| README.md | README.md | UPDATE | New overview of framework + hello-world |
| QUICK-REFERENCE.md | QUICK-START.md | RENAME + UPDATE | User getting started |
| LICENSE | LICENSE | KEEP | Root level |
| .gitignore | .gitignore | KEEP | Root level |

### Framework Content
| Current Location | Target Location | Action |
|-----------------|----------------|--------|
| project-framework-template/standard/thoughts/framework/templates/ | framework/templates/ | MOVE + REORGANIZE |
| project-framework-template/standard/thoughts/framework/process/ | framework/process/ | MOVE |
| project-framework-template/standard/thoughts/framework/patterns/ | framework/patterns/ | MOVE |
| thoughts/project/collaboration/ | framework/collaboration/ | MOVE |

### Framework Project Tracking (NEW)
| Current Location | Target Location | Action |
|-----------------|----------------|--------|
| thoughts/project/work/ | framework/thoughts/work/ | COPY structure |
| thoughts/project/history/ | framework/thoughts/history/ | COPY structure |
| thoughts/project/research/adr/ | framework/thoughts/research/adr/ | MOVE (framework ADRs) |
| thoughts/project/retrospectives/ | framework/thoughts/retrospectives/ | MOVE (framework retros) |
| thoughts/project/planning/backlog/ | framework/thoughts/work/backlog/ | FLATTEN |

### Hello-World Project (NEW)
| Content | Target Location | Action |
|---------|----------------|--------|
| Standard project template | project-hello-world/ | CREATE from template |
| Sample source code | project-hello-world/src/ | CREATE |
| Project CLAUDE.md | project-hello-world/CLAUDE.md | CREATE (references framework) |

### Files to Remove (This Migration)
| Location | Reason |
|----------|--------|
| thoughts/project/ | Splitting into framework/thoughts/ and project-hello-world/thoughts/ |

### Files to Remove (Future Cleanup Task)
| Location | Reason |
|----------|--------|
| project-framework-template/ | Defer to post-migration cleanup task |

---

## Decisions Made

### Q1: What happens to current work items in thoughts/project/work/? ✅
**Decision:** Move to framework/thoughts/work/ and keep current status
**Rationale:** They are framework work items, preserve work state
**Date:** 2026-01-02

### Q2: Session history - where does it go? ✅
**Current:** `thoughts/project/history/` has no session files (only releases/)
**Decision:** framework/thoughts/history/sessions/ for framework session history
**Date:** 2026-01-02

### Q3: Do we keep release archives in framework? ✅
**Current:** `thoughts/project/history/releases/v2.1.0/` through `v2.2.5/`
**Decision:** YES - move to framework/thoughts/history/releases/
**Date:** 2026-01-02

### Q4: What about project-framework-template/ folder? ✅
**Decision:** Leave alone for now, cleanup in post-migration task
**Rationale:** Don't lose focus on core reorganization
**Date:** 2026-01-02

### Q5: Collaboration guides location? ✅
**Decision:** Move to framework/collaboration/
**Rationale:** Universal guides, not project-specific
**Date:** 2026-01-02

---

## Implementation Steps

### Phase 1: Create Target Structure
1. Create `framework/` folder and subfolders
2. Create `framework/thoughts/` structure
3. Create `project-hello-world/` folder and subfolders
4. Create `project-hello-world/thoughts/` structure

### Phase 2: Move Framework Content
1. Move process/ docs to framework/process/
2. Move patterns/ docs to framework/patterns/
3. Move and reorganize templates/ to framework/templates/
4. Move collaboration/ guides to framework/collaboration/
5. Create framework/tools/.gitkeep

### Phase 3: Move Framework Project Tracking
1. Move work items from thoughts/project/work/ to framework/thoughts/work/
2. Move ADRs to framework/thoughts/research/adr/
3. Move retrospectives to framework/thoughts/retrospectives/
4. Move release history to framework/thoughts/history/releases/
5. Flatten: backlog from planning/backlog/ to work/backlog/

### Phase 4: Move Root Documentation
1. Move CHANGELOG.md to framework/
2. Move CLAUDE.md to framework/
3. Move PROJECT-STATUS.md to framework/
4. Move INDEX.md to framework/
5. Move CLAUDE-QUICK-REFERENCE.md to framework/
6. Rename QUICK-REFERENCE.md to QUICK-START.md and update
7. Update README.md for new structure

### Phase 5: Create Hello-World Project
1. Copy framework template structure to project-hello-world/
2. Create hello-world source in src/
3. Create project-hello-world/CLAUDE.md (references ../framework/)
4. Create project-hello-world/README.md
5. Create project-hello-world/PROJECT-STATUS.md
6. Create empty thoughts/ structure

### Phase 6: Cleanup
1. Delete project-framework-template/
2. Delete thoughts/ folder
3. Update all internal documentation references
4. Update .gitignore if needed

### Phase 7: Validation
1. Navigate structure - is it intuitive?
2. Check all file references/links
3. Verify nothing missing
4. Test "AS IF freshly unzipped"

---

## Risks

**RISK-001: Breaking all existing documentation references**
- Mitigation: Search and replace paths systematically
- Every .md file needs review

**RISK-002: Losing git history on moved files**
- Mitigation: Use `git mv` instead of manual moves where possible
- Document what was moved from where

**RISK-003: Missing files during migration**
- Mitigation: Create checklist, verify all files accounted for
- Before/after file count comparison

---

## Success Criteria

✅ All framework content in framework/ folder
✅ All project content in project-hello-world/ folder
✅ Structure flattened (3 levels max instead of 4)
✅ No orphaned files
✅ All documentation links working
✅ Git history preserved where possible
✅ Can navigate easily
✅ "AS IF freshly unzipped" test passes

---

## Notes

**Important:** This is a breaking change. Current users would need migration guide (which doesn't exist yet because we have zero external users).

**Scope:** This work item covers the reorganization only. Hello-world implementation (actual code) is separate work.

**Timeline:** Planned for incremental execution (not single session).

---

## Structure Definition Complete (2026-01-05)

**Universal structure fully defined:**
- See [PROJECT-STRUCTURE-STANDARD.md](PROJECT-STRUCTURE-STANDARD.md) for complete reference
- See [FEAT-026-universal-structure-decisions.md](FEAT-026-universal-structure-decisions.md) for decision log

**Key decisions documented:**
- 14 major decisions over 2 sessions (2026-01-04, 2026-01-05)
- Folder structure: Flattened, universal, dogfooded
- File requirements: READMEs, .gitkeep, .limit files
- Migration strategy: Copy-then-validate-then-delete on branch
- Monorepo with meta-root structure

**Ready for implementation:**
- ✅ Structure defined
- ✅ Files specified
- ✅ Migration strategy agreed
- ⏳ Awaiting user approval to proceed

---

**Created By:** Claude Code
**Last Updated:** 2026-01-05

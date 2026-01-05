# Session History: 2026-01-05

**Date:** 2026-01-05
**Participants:** Gary Elliott, Claude Code
**Duration:** ~3 hours
**Focus:** Complete universal Standard Framework structure definition (files and special content)

---

## Summary

Completed the universal Standard Framework structure definition by specifying all required and optional files, their content, and special files (.gitignore, .limit). Created PROJECT-STRUCTURE-STANDARD.md as the definitive reference document for Standard Framework projects.

**Key Outcome:** PROJECT-STRUCTURE-STANDARD.md created - THE authoritative reference for what a Standard Framework project contains (folders + files + content).

---

## What We Did

### 1. Template Need Identification

**Issue identified:** No single template defines what Standard Framework project structure should look like.

**Current gap:**
- Structure IMPLIED by copying template
- CLAUDE-TEMPLATE shows partial structure (outdated)
- NEW-PROJECT-CHECKLIST references structure but doesn't define it

**Decision:** Create PROJECT-STRUCTURE-STANDARD.md as separate reference document

**Rationale:**
- Single responsibility (one doc = structure definition)
- Reusable (can link from multiple places)
- Scalable (easy to add LIGHT, MINIMAL versions later)
- Validation-ready (can programmatically check against it)

### 2. Migration Strategy Finalized

**Options evaluated:**
- Option A: Parallel structure (copy, validate, delete)
- Option B: In-place transformation (git mv)
- Option C: Separate repos

**Decision: Option A - Copy strategy on migration branch**

**Approach:**
1. Create `feat-026-migration` branch
2. Copy files category-by-category (incremental)
3. Fix links in new files as we go
4. Commit after each category (incremental validation)
5. Keep old structure until new is validated
6. Delete old structure in final commit
7. Merge to main when confident

**Trade-off accepted:**
- Git file history lost (files appear as "new")
- But: File integrity more important than git history for one-time restructure
- Migration documented in FEAT-026

**Link-fixing strategy:**
1. Move/copy file to new location
2. Fix links INSIDE that file immediately (while in memory)
3. Search entire repo for links TO that file (from other files)
4. Fix those references
5. Commit both changes
6. Move to next file/category

### 3. Repository vs Project Structure Clarified

**Issue:** With framework/ and project-hello-world/ as separate folders, what goes at repository root?

**Decision: Monorepo with Meta-Root**

**Structure:**
```
project-framework/                    # REPOSITORY (not a project)
├── README.md                         # Repo overview
├── QUICK-START.md                    # Fast navigation guide
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

**Key insight:** Universal structure defines PROJECT structure, not repository structure.

**Root files (REQUIRED at repo level):**
- README.md, QUICK-START.md, LICENSE, .gitignore

**Root files (NOT at repo level, in each project):**
- CLAUDE.md, PROJECT-STATUS.md, CHANGELOG.md, INDEX.md

### 4. README vs QUICK-START Separation

**Decision: Clear separation of purpose**

**Root README.md (Repo Overview):**
- Purpose: What is this repository?
- Content: Repo description, goals, what's inside, links to QUICK-START
- Target audience: First-time visitors, potential users
- Length: ~50-100 lines

**Root QUICK-START.md (Navigation Guide):**
- Purpose: Get me to what I need FAST
- Content: Decision tree, quick links, common tasks
- Target audience: Users who know they want framework
- Length: ~30-50 lines

**Note captured:** QUICK-START.md needs more explanation post-reorg (users may not know what "framework" means in our context)

### 5. Project Root Files Defined

**REQUIRED files at project root:**
- `.gitignore` (inherits from repo root)
- `README.md` (project overview)
- `PROJECT-STATUS.md` (SSOT for version/status)
- `CHANGELOG.md` (Keep a Changelog format)
- `CLAUDE.md` (AI collaboration guide)
- `INDEX.md` (documentation navigation)

**OPTIONAL files:**
- `LICENSE` (if different from repo license)

**Decision: INDEX.md is REQUIRED for Standard Framework** (even if simple initially)

### 6. docs/ Folder Files Defined

**REQUIRED:**
- `docs/README.md` (documentation index)

**OPTIONAL subfolders (create as needed):**
- `patterns/`, `process/`, `collaboration/`, `api/`, `guides/`, `architecture/`, `deployment/`

**Organization strategy:** Threshold-based
- ≤5 docs → Keep flat
- >5 docs OR clear categories → Use subfolders
- AI proposes organization for user approval

**Hierarchy decision:**
- Project INDEX.md = master index (points to major areas)
- docs/README.md = detailed documentation index

### 7. thoughts/ Folder Files Defined

**REQUIRED files:**

1. **`thoughts/work/README.md`** - Minimal workflow reference
   - Points to central kanban-workflow.md
   - Lists WIP limits
   - Both framework and user projects have it

2. **`thoughts/work/todo/.limit`** - Contains: `10`

3. **`thoughts/work/doing/.limit`** - Contains: `1`

4. **`thoughts/research/README.md`** - Explains research folder purpose
   - Project intellectual property (irreplaceable)
   - Decision rationale

5. **`thoughts/external-references/README.md`** - Explains distinction from research/
   - Convenience cache (replaceable)
   - Authoritative sources only

**Key principle:** Workflow doc is THE critical spec
- Lives in ONE place: `framework/docs/process/kanban-workflow.md`
- All projects reference it (not duplicate)

### 8. Folder Visibility Strategy

**Issue:** How to ensure folders exist after git clone?

**Options evaluated:**
- Option A: .gitkeep everywhere (13 files)
- Option B: No .gitkeep (folders created on-demand)
- Option C: Init script creates folders
- Option D: README files instead of .gitkeep
- Option E: Selective strategy (meaningful READMEs + .gitkeep for simple folders)

**Decision: Option E - Selective Strategy**

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
- Folders exist after git clone
- READMEs where they provide value
- Not drowning in README files
- Future delivery format flexibility

### 9. .gitignore Strategy

**Decision: Single .gitignore at repository root only**

**Content defined:**
- Security & Secrets (NEVER COMMIT)
- OS-Specific (with note about global .gitignore)
- IDE & Editors (with note about global .gitignore)
- Temporary & Cache Files (including logs/)
- Build Artifacts & Dependencies
- Project-Specific

**Best practices applied:**
- Create before first commit
- Framework-specific templates
- Comments explaining complex patterns
- Security-critical always ignored
- Recommendation for users to set up global .gitignore

**No project-level .gitignore:**
- Users can add if needed
- Expected to customize repo .gitignore

### 10. PROJECT-STRUCTURE-STANDARD.md Created

**Comprehensive 600+ line reference document containing:**

✅ Complete structure visualization (tree format)
✅ All file specifications with content examples
✅ Full .gitignore template (ready to use)
✅ Initialization checklist (step-by-step project setup)
✅ Validation checklist (verify compliance)
✅ Framework-specific additions documented
✅ All decisions from 2 sessions incorporated

**This document is now THE reference for:**
- FEAT-026 migration (target structure)
- New project creation (initialization checklist)
- Structure validation (validation checklist)
- AI guidance (I can reference to validate projects)
- User onboarding (clear documentation)
- Future framework levels (template for LIGHT/MINIMAL)

---

## Decisions Made

**Total decisions this session:** 4 new decisions (bringing total to 14)

### DECISION-010: Create PROJECT-STRUCTURE-STANDARD.md
**Date:** 2026-01-05

**Issue:** No single authoritative document defines Standard Framework project structure

**Decision:** Create separate PROJECT-STRUCTURE-STANDARD.md reference document in framework/docs/

**Implementation:** Add to FEAT-026 Phase 1 (create BEFORE migration starts, use as migration target)

---

### DECISION-011: Migration Strategy
**Date:** 2026-01-05

**Decision:** Use Copy-Then-Validate-Then-Delete strategy on migration branch

**Approach:** Incremental copy, fix links as we go, validate, delete old, merge to main

**Trade-off:** Git history lost, but file integrity preserved

---

### DECISION-012: Monorepo with Meta-Root
**Date:** 2026-01-05

**Decision:** Repository root is meta-level (not a project), contains multiple projects

**Structure:** framework/ and project-hello-world/ are self-contained projects

**Root files:** README.md, QUICK-START.md, LICENSE, .gitignore only

---

### DECISION-013: README vs QUICK-START Separation
**Date:** 2026-01-05

**Decision:** Clear separation of purpose between root README and QUICK-START

**README:** What is this repository?
**QUICK-START:** Fast navigation to what you need

---

### DECISION-014: Folder Visibility Strategy
**Date:** 2026-01-05

**Decision:** Option E - Selective strategy (meaningful READMEs + .gitkeep for simple folders)

**Implementation:** 9 READMEs + 12 .gitkeep files across both projects

---

## Work Items

### Created
- **PROJECT-STRUCTURE-STANDARD.md** - Definitive structure reference

### Updated
- **FEAT-026-structure-migration.md** - Added structure definition complete section, updated related docs
- **FEAT-026-universal-structure-decisions.md** - Updated throughout session with new decisions

### Completed
- Universal Standard Framework structure definition (folders + files + content)

---

## Documentation Created/Updated

### Created
- `thoughts/project/planning/backlog/PROJECT-STRUCTURE-STANDARD.md` (600+ lines)
- `thoughts/project/history/2026-01-05-SESSION-HISTORY.md` (this file)

### Updated
- `thoughts/project/planning/backlog/FEAT-026-structure-migration.md`
- `thoughts/project/planning/backlog/FEAT-026-universal-structure-decisions.md`

---

## Blockers & Issues

### Identified
- None

### Resolved
- **Template need** - PROJECT-STRUCTURE-STANDARD.md created
- **Migration strategy uncertainty** - Copy strategy finalized
- **Repository vs project confusion** - Monorepo with meta-root clarified
- **Folder visibility concerns** - Selective strategy balances visibility vs clutter

---

## Key Learnings

### Process Learnings

**Define structure completely before implementation**
- Folder structure first (session 1)
- File specifications second (session 2)
- Ensures clean architecture foundation
- Migration becomes straightforward with complete target

**Selective approach better than all-or-nothing**
- .gitkeep only where needed (not everywhere)
- READMEs where they provide value (not every folder)
- Balances user experience with maintainability

**Threshold-based organization scales better than rigid rules**
- docs/ flat until 5+ files OR clear categories
- AI proposes organization when threshold reached
- User approves/adjusts
- Flexibility with guidance

### Framework Learnings

**Repository ≠ Project in monorepo model**
- Repository is meta-level container
- Projects are self-contained with universal structure
- Clear separation prevents confusion
- Universal structure unchanged (defines PROJECT, not repository)

**.gitignore best practices matter**
- Security patterns always included
- Recommend global .gitignore for personal preferences
- Document expected customization
- Single source at repo root (simpler)

**Documentation hierarchy prevents overlap**
- Master INDEX.md points to major areas
- Folder READMEs provide detailed indices
- No duplication of content
- Clear navigation path

---

## Next Steps

### Immediate (Next Session)
1. Get user approval on PROJECT-STRUCTURE-STANDARD.md
2. Update FEAT-026 with detailed migration plan
3. Begin migration execution (create branch, start copying)

### Short Term
1. Execute FEAT-026 migration incrementally
2. Validate structure against PROJECT-STRUCTURE-STANDARD.md
3. Test "AS IF freshly unzipped" experience

### Future
1. Create PROJECT-STRUCTURE-LIGHT.md
2. Create PROJECT-STRUCTURE-MINIMAL.md
3. Automated structure validation tooling

---

## Files Modified

### Git Status Before Session
- Working tree has uncommitted changes
- On branch: main
- Last commit: v2.2.5

### Files Changed This Session
- Created: `thoughts/project/planning/backlog/PROJECT-STRUCTURE-STANDARD.md`
- Updated: `thoughts/project/planning/backlog/FEAT-026-structure-migration.md`
- Updated: `thoughts/project/planning/backlog/FEAT-026-universal-structure-decisions.md`
- Created: `thoughts/project/history/2026-01-05-SESSION-HISTORY.md`

---

## Metrics

### Time Allocation
- Template discussion and decision: ~30 minutes
- Migration strategy finalization: ~30 minutes
- Repository vs project clarification: ~20 minutes
- File specifications (root, docs, thoughts): ~45 minutes
- Folder visibility strategy: ~30 minutes
- .gitignore strategy: ~20 minutes
- PROJECT-STRUCTURE-STANDARD.md creation: ~30 minutes
- Session recording: ~15 minutes

### Decisions Made
- 4 new decisions (total: 14 across 2 sessions)

### Work Items
- Created: 1 major document (PROJECT-STRUCTURE-STANDARD.md)
- Updated: 2 planning documents
- Completed: Universal structure definition

### Documentation Stats
- PROJECT-STRUCTURE-STANDARD.md: 600+ lines
- Complete folder structure: ~40 folders
- Complete file list: ~30 files
- .gitignore template: 150+ lines

---

## References

- [PROJECT-STRUCTURE-STANDARD.md](../planning/backlog/PROJECT-STRUCTURE-STANDARD.md) - **NEW** - Definitive structure reference
- [FEAT-026-structure-migration.md](../planning/backlog/FEAT-026-structure-migration.md) - Migration work item
- [FEAT-026-universal-structure-decisions.md](../planning/backlog/FEAT-026-universal-structure-decisions.md) - Decision log
- [2026-01-04-SESSION-HISTORY.md](2026-01-04-SESSION-HISTORY.md) - Previous session (folder structure)

---

**Session End:** 2026-01-05
**Status:** Complete - Universal structure fully defined
**Next Session:** Update FEAT-026 with migration plan, get approval, begin execution

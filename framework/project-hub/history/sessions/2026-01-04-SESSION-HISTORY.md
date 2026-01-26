# Session History: 2026-01-04

**Date:** 2026-01-04
**Participants:** Gary Elliott, Claude Code
**Duration:** ~2 hours
**Focus:** Universal Standard Framework structure definition (folder architecture)

---

## Summary

Defined the universal folder structure for Standard Framework level that will be used by both the framework project (dogfooding) and all user projects. Established clear distinctions between required/optional folders, framework-specific additions, and critical policies for `.gitkeep` usage and multi-repository strategy.

**Key Outcome:** Complete folder structure definition documented in FEAT-026-universal-structure-decisions.md, ready to proceed with files definition.

---

## What We Did

### 1. Initial Structure Review
- Reviewed FEAT-026-structure-migration.md
- Identified that proposed structure showed two different structures (framework vs project-hello-world) without defining the universal base
- Recognized need to define "What folders does EVERY Standard Framework project have?"

### 2. Universal Structure Philosophy Established

**Key Principles Agreed:**
- Framework IS a project (dogfooding)
- Core structure is universal (all Standard projects use same base)
- Flexibility for extensions (projects can add project-specific folders)
- Required vs Optional clear distinction

**Template Model:**
- Universal project structure = template for all projects
- Framework adheres strictly (promotes dogfooding)
- User projects maintain core folders/files but allow additional content

### 3. Root Folder Structure Decisions

**Agreed on universal root folders:**
```
[project-name]/
├── src/           # REQUIRED - All projects get this by default
├── tests/         # REQUIRED - All projects get this by default
├── docs/          # REQUIRED - All projects get this by default
├── templates/     # OPTIONAL - Only if project produces templates
├── tools/         # OPTIONAL - Only if project has utilities
└── thoughts/      # REQUIRED - Project management
```

**Rationale:** Forces good structure from day one, even for new projects

### 4. Framework-Specific Content Location

**Question raised:** Where should framework-specific content go?
- `patterns/` - Implementation patterns
- `templates/` - Template artifacts
- `tools/` - Utilities
- `process/` - Process documentation
- `collaboration/` - AI collaboration guides

**Decision made:**
```
framework/
├── docs/
│   ├── patterns/       # Documentation
│   ├── process/        # Documentation
│   └── collaboration/  # Documentation
├── templates/          # Deliverable artifacts (not docs)
└── tools/              # Deliverable utilities (not docs)
```

**Key insight:** User projects CAN also use `docs/patterns/`, `docs/process/`, `docs/collaboration/` if they have project-specific needs (truly universal structure)

### 5. `docs/` Organization Strategy

**Threshold-based approach agreed:**
- If ≤5 docs total → Keep flat (*.md at docs/ root)
- If >5 docs OR clear categories → Use subfolders

**Recommended subfolders (all OPTIONAL):**
- `api/` - API documentation
- `guides/` - User guides, tutorials
- `architecture/` - Architecture decisions, diagrams
- `deployment/` - Deployment, configuration
- `patterns/` - Project-specific patterns
- `process/` - Project-specific processes
- `collaboration/` - Project-specific AI/team guides

**Requirements:**
- `docs/README.md` is REQUIRED - serves as documentation index
- Subfolder names are suggestions, not requirements
- AI proposes folder organization for approval when threshold reached
- Threshold is guideline, not enforced rule

### 6. `thoughts/` Structure Refinement

**Flattening confirmed:**
- `planning/backlog/` → `work/backlog/` (removes extra nesting level)
- Before: 4 levels, After: 3 levels

**Spikes relocation:**
- From: `thoughts/project/history/spikes/`
- To: `thoughts/history/spikes/`

**Final structure:**
```
thoughts/
├── work/
│   ├── backlog/          # FLATTENED from planning/backlog/
│   ├── todo/
│   ├── doing/
│   │   └── .limit       # Contains WIP limit (default: 1)
│   └── done/
├── history/
│   ├── releases/
│   ├── sessions/
│   └── spikes/           # NEW LOCATION
├── research/
│   └── adr/
├── retrospectives/
├── external-references/  # RENAMED from reference/
└── archive/
```

### 7. Critical Distinction: `research/` vs `external-references/`

**Question raised:** Potential for confusion between these folders?

**Developed "Deletion Test" mental framework:**

**If `research/` deleted:**
- ❌ CRITICAL - Breaks project understanding, decision trail, continuity
- ❌ IRREPLACEABLE - Can't Google our unique investigations
- ❌ COULD STEER WRONG - Lost context for why we made decisions

**If `external-references/` deleted:**
- ⚠️ INCONVENIENCE - Need to re-find external resources
- ✅ REPLACEABLE - Can Google authoritative sources again
- ✅ FACT-BASED - RFCs, specs won't change
- ⚠️ COULD STEER WRONG IF - We stored opinion pieces (shouldn't)

**Key insight from Deletion Test:**
```
research/              = PROJECT INTELLECTUAL PROPERTY
                         (Irreplaceable, unique, explains decisions)

external-references/   = CONVENIENCE CACHE
                         (Replaceable, authoritative, quick access)
```

**Authoritative Source Rule established:**
Only store authoritative, fact-based references in `external-references/`:
- ✅ RFC specifications
- ✅ Official API docs (versioned)
- ✅ Industry standards (ISO, IEEE, W3C)
- ✅ Language specifications
- ❌ Blog posts (opinion)
- ❌ Tutorial articles (opinion)
- ❌ Competitive analysis (goes in research/)

**Clarification:** Deletion Test is HYPOTHETICAL mental framework for decision-making, not an actual test to run

### 8. `.gitkeep` Policy Definition

**Initial proposal:** Option 1 - All REQUIRED folders get `.gitkeep` (13 files)
**Reaction:** "That feels like a lot"

**Revised to Option 1-B: Selective `.gitkeep` (6 files)**

**Use `.gitkeep` in:**
```
src/.gitkeep                        # Prevents "where's my code?" confusion
tests/.gitkeep                      # Prevents "where's my tests?" confusion
thoughts/work/backlog/.gitkeep      # Critical workflow visibility
thoughts/work/todo/.gitkeep         # Critical workflow visibility
thoughts/work/doing/.gitkeep        # Critical workflow visibility
thoughts/work/done/.gitkeep         # Critical workflow visibility
```

**Skip `.gitkeep` in:**
- `thoughts/history/*` - Will populate naturally
- `thoughts/research/adr/` - Will populate on first ADR
- `thoughts/retrospectives/` - Will populate on first retro
- `thoughts/external-references/` - May never be used
- `thoughts/archive/` - Will populate when needed

**Retention policy:** Keep `.gitkeep` forever (don't delete even when folder has files)

**Rationale:**
- Especially important for `work/` folders (workflow visibility)
- Important for new projects before content created
- Prevents confusion for first-time users
- Can review after we add files to structure

### 9. Multi-Repository Strategy

**Question:** How to handle `.git/` in v3.0.0 structure with framework/ and project-hello-world/?

**Options evaluated:**
- Option A: Single monorepo
- Option B: Nested repos (submodules)
- Option C: Separate repos entirely
- Option D: Monorepo with post-setup separation

**Decision: Option D - Monorepo with Post-Setup Separation**

**Structure:**
```
project-framework/
├── .git/                    # Single repo during development
├── framework/               # Framework project
└── project-hello-world/     # Sample/reference project
```

**User workflow:**
1. Clone `project-framework` repo → See complete structure
2. Review framework/ and hello-world/ as references
3. Create NEW project → Fresh git repo (clean separation)

**Rationale:**
- Development convenience (framework + example together)
- User visibility (see full structure on clone)
- Clean separation (users create fresh repos)
- Hello-world role (reference example, not user's actual project)

### 10. Special Files

**`thoughts/work/doing/.limit` clarified:**
- Purpose: Contains WIP limit number
- Default value: `1` (changeable by user)
- Previous session had mentioned `2`, corrected to current practice of `1`

---

## Decisions Made

All decisions documented in: `thoughts/project/planning/backlog/FEAT-026-universal-structure-decisions.md`

**Major Decisions:**

**DECISION-001: Universal Structure Philosophy**
- Framework dogfoods its own structure
- Core structure universal, extensions allowed
- Required vs Optional clear distinction

**DECISION-002: Root Folders**
- `src/`, `tests/`, `docs/` REQUIRED for all projects
- `templates/`, `tools/` OPTIONAL (only if project produces them)

**DECISION-003: Framework Content Location**
- `docs/patterns/`, `docs/process/`, `docs/collaboration/` for documentation
- `templates/` at root for deliverable artifacts
- `tools/` at root for deliverable utilities
- User projects CAN use same `docs/` subfolders if needed

**DECISION-004: `docs/` Organization**
- `docs/README.md` REQUIRED
- Threshold-based: ≤5 docs flat, >5 docs use subfolders (guideline, not rule)
- AI proposes subfolder organization for approval
- Recommended subfolder names are suggestions

**DECISION-005: `thoughts/` Flattening**
- `planning/backlog/` → `work/backlog/`
- `thoughts/project/history/spikes/` → `thoughts/history/spikes/`
- Reduces nesting from 4 to 3 levels

**DECISION-006: Folder Distinction Framework**
- `research/` = Project intellectual property (irreplaceable)
- `external-references/` = Convenience cache (replaceable, authoritative only)
- Use "Deletion Test" mental framework for classification
- Authoritative Source Rule for external-references/

**DECISION-007: `.gitkeep` Policy**
- Option 1-B: Selective `.gitkeep` (6 files)
- Focus on critical workflow folders (`work/*`, `src/`, `tests/`)
- Keep `.gitkeep` forever (don't delete)
- May review after adding files

**DECISION-008: Multi-Repository Strategy**
- Option D: Monorepo with post-setup separation
- Single repo for development (framework + hello-world)
- Users create fresh repos for their projects
- Documentation explains workflow

**DECISION-009: Special Files**
- `.limit` default value: `1` (changeable)
- `.limit` location: `thoughts/work/doing/.limit`

---

## Work Items

### Created
- **FEAT-026-universal-structure-decisions.md** - Documentation of folder structure decisions

### Updated
- **FEAT-026-structure-migration.md** - Referenced throughout session (not modified yet)

### Completed
- Folder structure definition (ready for files discussion)

---

## Documentation Created/Updated

### Created
- `thoughts/project/planning/backlog/FEAT-026-universal-structure-decisions.md`
- `thoughts/project/history/2026-01-04-SESSION-HISTORY.md` (this file)

### Updated
- None (FEAT-026-structure-migration.md will be updated with final structure)

---

## Blockers & Issues

### Identified
- None

### Resolved
- **Confusion about universal structure:** Resolved by defining clear base structure that both framework and user projects follow
- **`.gitkeep` clutter concerns:** Resolved with selective approach (6 files instead of 13)
- **Multi-repo complexity:** Resolved with monorepo development strategy

---

## Key Learnings

### Process Learnings

**Start with folder structure before files**
- Clean architecture foundation
- Easier to discuss and visualize
- Files layer on top naturally

**Deletion Test is powerful mental framework**
- Helps clarify folder purposes
- Distinguishes critical vs convenience
- Works for both AI and humans

**Threshold-based organization scales better than rigid rules**
- Flat until it hurts (5+ docs)
- AI proposes organization at threshold
- User approves/adjusts

### Framework Learnings

**Universal structure enables true dogfooding**
- Framework uses same structure it recommends
- User projects can extend with framework-like folders (patterns/, process/, collaboration/)
- No special cases needed

**`.gitkeep` serves human users primarily**
- First-time users need visible structure
- Workflow folders especially critical
- Selective approach balances visibility vs clutter

**Monorepo development with separate user repos**
- Best of both worlds
- Development convenience
- User flexibility

---

## Next Steps

### Immediate (This Session or Next)
1. Define FILES for universal structure
   - Root-level files (REQUIRED vs OPTIONAL)
   - File templates/structure
   - Folder README files
   - Special files (`.gitignore` contents, etc.)

### Short Term
1. Update FEAT-026-structure-migration.md with finalized universal structure
2. Create migration plan using agreed structure
3. Execute structure migration

### Future
1. Review `.gitkeep` selective approach after files added
2. Consider policy document for `.gitkeep` usage (deferred)

---

## Open Questions

**For later discussion:**
1. Should we create a policy document for `.gitkeep` usage? (Deferred)
2. Should we review `.gitkeep` selective approach after adding files? (Yes, planned)

---

## Files Modified

### Git Status Before Session
- Working tree has uncommitted changes
- On branch: main
- Last commit: v2.2.5

### Files Changed This Session
- Created: `thoughts/project/planning/backlog/FEAT-026-universal-structure-decisions.md`
- Created: `thoughts/project/history/2026-01-04-SESSION-HISTORY.md`

---

## Metrics

### Time Allocation
- Structure review and analysis: ~30 minutes
- Root folder decisions: ~30 minutes
- `docs/` and `thoughts/` structure: ~30 minutes
- Critical distinctions (research/ vs external-references/): ~15 minutes
- `.gitkeep` policy: ~15 minutes
- Multi-repo strategy: ~15 minutes
- Documentation: ~15 minutes

### Decisions Made
- 9 major decisions
- Multiple sub-decisions within each

### Work Items
- Created: 1 documentation file (FEAT-026-universal-structure-decisions.md)
- Updated: 0
- Completed: Folder structure definition

---

## References

- [FEAT-026-structure-migration.md](../planning/backlog/FEAT-026-structure-migration.md)
- [FEAT-026-universal-structure-decisions.md](../planning/backlog/FEAT-026-universal-structure-decisions.md)
- [2026-01-02-SESSION-HISTORY.md](2026-01-02-SESSION-HISTORY.md) - Previous session (retrospective and migration planning)

---

**Session End:** 2026-01-04
**Status:** Complete - Folder structure defined
**Next Session:** Define files for universal structure, then update FEAT-026 and execute migration

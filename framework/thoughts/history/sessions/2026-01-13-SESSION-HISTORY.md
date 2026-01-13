# Session History: 2026-01-13

**Date:** 2026-01-13
**Duration:** Morning session
**Participants:** Gary Elliott, Claude (Sonnet 4.5)
**Focus:** Repository structure refactoring and industry alignment

---

## Session Overview

Discussed DECISION-050 (framework distribution model) implications for repository structure. Researched industry-standard patterns from npm, pip, and bundler to adopt professional terminology and structure conventions. Created comprehensive refactoring work item with path-by-path migration strategy.

---

## Key Decisions Made

### 1. Repository is No Longer a "Monorepo"

**Context:** With framework-as-dependency model (DECISION-050), `project-hello-world/` becomes an example, not a peer project.

**Decision:** Adopt "framework source repository" terminology instead of "monorepo"
- Repository contains framework source + examples (standard pattern)
- Not a monorepo in traditional sense (multiple independent projects)
- Aligns with npm, pip, bundler conventions

**Rationale:** Industry-standard terminology makes framework instantly recognizable to developers from any ecosystem.

---

### 2. Adopt Industry-Standard Directory Names

**Decision:** Rename directories to match npm/pip/bundler conventions:
- `project-hello-world/` → `examples/hello-world/`
- `project-templates/` → `templates/`

**Research findings:**
- `examples/` is universal across npm, pip, bundler
- Removes redundant "project-" prefix
- Professional, recognizable structure

**Supporting document:** [package-ecosystem-terminology-patterns.md](../../research/package-ecosystem-terminology-patterns.md)

---

### 3. Consolidate Structure Documentation

**Question raised:** Do we need both REPOSITORY-STRUCTURE.md and PROJECT-STRUCTURE-STANDARD.md?

**Decision:** Keep PROJECT-STRUCTURE-STANDARD.md, simplify REPOSITORY-STRUCTURE.md
- PROJECT-STRUCTURE-STANDARD.md serves both users and framework maintainers
- Universal structure spec (everyone follows same pattern)
- Repository layout simple enough for README.md/CLAUDE.md

**Rationale:** Single structure spec reduces duplication, one source of truth.

---

### 4. Path-by-Path Migration Strategy

**Context:** FEAT-026 created 6+ P1 bugs and 8+ P2 tech debt items due to incomplete path updates.

**Decision:** Migrate one path at a time, not all at once:
1. Rename `project-hello-world/` → Fix ALL docs → Validate → User review
2. Rename `project-templates/` → Fix ALL docs → Validate → User review
3. Update terminology → Validate → User review

**Rationale:**
- Focused scope (one path at a time)
- Immediate validation (grep = zero old references)
- Incremental progress (independently valuable)
- Easier rollback (undo one change, not many)
- Natural validation gates (binary pass/fail)

**Key principle:** Same files edited multiple times, but each path fully completed before moving to next.

---

## Work Items Created

### REFACTOR-052: Adopt Industry-Standard Repository Structure

**File:** [REFACTOR-052-adopt-industry-standard-repo-structure.md](../../work/backlog/REFACTOR-052-adopt-industry-standard-repo-structure.md)

**Scope:**
- Rename `project-hello-world/` → `examples/hello-world/`
- Rename `project-templates/` → `templates/`
- Update terminology throughout (monorepo → framework source repository)
- Update all documentation with new paths
- Comprehensive validation strategy to avoid FEAT-026 problems

**Status:** Backlog (high priority, blocks FEAT-025)

**Key features:**
- Path-by-path migration strategy
- 5 mitigation strategies learning from FEAT-026
- Explicit validation gates and user review checkpoints
- Comprehensive checklist with STOP points

---

## Research Completed

### Package Ecosystem Terminology Patterns

**File:** [package-ecosystem-terminology-patterns.md](../../research/package-ecosystem-terminology-patterns.md)

**Researched ecosystems:**
- npm (Node.js) - Package structure and conventions
- pip (Python) - Src layout and distribution patterns
- bundler (Ruby) - Gem structure and naming

**Key findings:**
1. `examples/` is universal directory name across all ecosystems
2. "Source" vs "Distribution" separation is standard
3. "Bundled dependency" pattern is well-established
4. Package development repos don't typically have "repository structure spec" docs
5. Single structure spec serves both maintainers and users

**Terminology mapping established:**
- "monorepo" → "framework source repository"
- "THE framework" → "framework source" or "canonical source"
- "framework-as-dependency" → "bundled dependency model"

---

## Lessons from FEAT-026 Applied

### Problems Identified in FEAT-026:
1. Missed path references throughout documentation
2. Insufficient validation (spot checks inadequate)
3. Duplication and contradictions in docs
4. No comprehensive audit before changes
5. Created 6+ P1 bugs and 8+ P2 tech debt items

### Mitigation Strategies for REFACTOR-052:

**Strategy 1: Comprehensive Pre-Change Audit**
- Grep EVERYTHING before starting
- Categorize all findings (Critical/High/Medium/Low/Skip)
- Explicit "update" or "skip" decision for every file
- No assumptions

**Strategy 2: Staged Implementation with Validation Gates**
- Small commits, validate each stage
- User review between major phases
- STOP points enforce validation
- Binary pass/fail per phase

**Strategy 3: Automated Path Validation**
- `validate-paths.ps1` script
- Check for old paths/terminology
- Run after each phase before committing

**Strategy 4: Explicit "Won't Update" List**
- Document what we're NOT changing and why
- Historical files preserved
- Intentional references clearly noted
- Deferred updates explicitly marked

**Strategy 5: Validation Checklist**
- Manual validation (fresh clone, test navigation)
- Automated validation (run script)
- User acceptance testing
- 15-minute final check

---

## Technical Discussions

### Why Path-by-Path Instead of All-at-Once?

**User's insight:** "Change one path, fix all docs for that path, validate, then move to next path. Even though same files edited multiple times, each path task is complete."

**Benefits identified:**
- ✅ Focused scope (only ONE path at a time)
- ✅ Immediate validation (grep confirms zero)
- ✅ Incremental progress (independently valuable steps)
- ✅ Easier rollback (one change to undo)
- ✅ Natural validation gates (binary pass/fail)

**Implementation:**
- Phase 2: Migrate project-hello-world/ (rename → fix → validate → review)
- Phase 3: Migrate project-templates/ (rename → fix → validate → review)
- Phase 4: Update terminology (find → fix → validate → review)
- Phase 5: Final structure doc review
- Phase 6: CHANGELOG and final validation

---

## Questions Raised and Answered

### Q: "Are we still a monorepo after this change?"
**A:** No. Framework-as-dependency model means we're a "framework source repository" with examples, not a traditional monorepo with peer projects.

### Q: "Should we keep both REPOSITORY-STRUCTURE.md and PROJECT-STRUCTURE-STANDARD.md?"
**A:** Keep PROJECT-STRUCTURE-STANDARD.md (serves both maintainers and users), simplify/merge REPOSITORY-STRUCTURE.md into navigation docs.

### Q: "How do we avoid FEAT-026's problems (6+ follow-up bugs)?"
**A:** 5-part mitigation strategy: comprehensive audit, validation gates, automated validation, explicit skip list, thorough final validation.

### Q: "What's the best strategy for this refactoring?"
**A:** Path-by-path migration (user's suggestion). Change one path, fix all its references, validate to zero, user review, then next path. More rigorous than all-at-once approach.

---

## Documentation Updated

### Created:
- `framework/thoughts/research/package-ecosystem-terminology-patterns.md` - Industry pattern research
- `framework/thoughts/work/backlog/REFACTOR-052-adopt-industry-standard-repo-structure.md` - Refactoring work item

### To Be Updated (by REFACTOR-052):
- Repository structure and navigation docs
- All path references throughout
- Terminology throughout
- 23+ work items with old path references

---

## Action Items

### Immediate (Before Implementation):
- [ ] Review REFACTOR-052 work item for completeness
- [ ] Decide when to implement (blocks FEAT-025)

### Implementation (REFACTOR-052):
- [ ] Phase 0: Pre-change audit
- [ ] Phase 2: Migrate project-hello-world/ (path-by-path)
- [ ] Phase 3: Migrate project-templates/ (path-by-path)
- [ ] Phase 4: Update terminology
- [ ] Phase 5: Final structure doc review
- [ ] Phase 6: CHANGELOG and validation

### Future:
- [ ] Consider deleting/merging REPOSITORY-STRUCTURE.md after refactoring
- [ ] Update DECISION-050 to reference new research document

---

## Key Insights

### 1. Industry Alignment Reduces Cognitive Load
Using `examples/` and standard terminology makes framework instantly recognizable to developers from npm, pip, or bundler ecosystems. Professional appearance matters.

### 2. Path-by-Path Migration is Superior
User's suggestion to migrate one path at a time (fix ALL its references, validate to zero) is more rigorous and easier to execute than all-at-once approach. Same files get edited multiple times, but each path task is complete.

### 3. FEAT-026 Taught Valuable Lessons
Creating 6+ P1 bugs and 8+ P2 tech debt items revealed systematic validation is critical for structural changes. Spot checks are insufficient.

### 4. Explicit "Skip Lists" Prevent Uncertainty
Documenting what we're NOT updating (and why) prevents "did we forget this?" anxiety. Historical files stay historical, research docs keep context.

### 5. Structure Documentation Can Be Simplified
One PROJECT-STRUCTURE-STANDARD.md serves both maintainers and users when structure is universal. Repository layout is simple enough for README/CLAUDE.md.

---

## Metrics

**Work Items Created:** 1 (REFACTOR-052)
**Research Documents Created:** 1 (package-ecosystem-terminology-patterns)
**Files to Refactor:** ~30-40 (Tier 1 & 2)
**Historical Files Preserved:** All session history and release archives
**Estimated Impact:** High (blocks FEAT-025, improves professionalism)

---

## References

- DECISION-050: Framework distribution model
- FEAT-026: Structure migration (v3.0.0) - lessons learned
- FEAT-025: Manual setup validation (blocked by this work)
- npm, pip, bundler documentation (industry research)

---

## Session Quality Notes

**Strengths:**
- Thorough research into industry patterns
- User's path-by-path strategy superior to initial proposal
- Comprehensive mitigation strategies from FEAT-026 lessons
- Clear decision trail and rationale documentation

**Process Observations:**
- User caught missing structure docs in scope (excellent review)
- Discussion about monorepo terminology led to deeper insights
- Iterative refinement of implementation strategy worked well

---

**Next Session:** Implement REFACTOR-052 or continue with other priorities

---

**Last Updated:** 2026-01-13

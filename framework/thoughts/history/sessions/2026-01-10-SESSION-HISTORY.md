# Session History - 2026-01-10

**Date:** 2026-01-10
**Participants:** Gary Elliott, Claude (Sonnet 4.5)
**Session Type:** Analysis and Work Item Creation

---

## Summary

Analyzed FEAT-025 for alignment with FEAT-026 v3.0.0 structure decisions. Discovered significant path reference issues in active documentation and templates that were missed during FEAT-026. Created comprehensive analysis document and four prerequisite work items to resolve issues before FEAT-025 can proceed.

---

## Work Completed

### 1. FEAT-025 Alignment Analysis

**Context:**
- FEAT-025 proposes validating manual setup process for Standard/Light/Minimal framework levels
- Written before FEAT-026 restructured repository into monorepo
- User requested analysis of whether FEAT-025 still aligns with current decisions

**Analysis Results:**
- Created comprehensive [FEAT-025-ALIGNMENT-ANALYSIS.md](../work/todo/FEAT-025-ALIGNMENT-ANALYSIS.md)
- Identified 10 major alignment issues
- Documented 3 critical decision points
- Determined FEAT-025 requires major updates before implementation

**Key Findings:**
1. Structure references outdated (`thoughts/project/planning/` vs `thoughts/work/`)
2. Path references incorrect (templates location)
3. Template package location changed (`project-framework-template/` → `project-templates/`)
4. Scope unclear (project-hello-world/ already exists as Standard reference)
5. NEW-PROJECT-CHECKLIST.md outdated (pre-FEAT-026)
6. Template access strategy undefined

### 2. Discovery of Missed FEAT-026 Updates

**Critical Discovery:**
Found 42 files still referencing old structure paths, including:
- 4 active process/collaboration docs
- 5 active template files
- NEW-PROJECT-CHECKLIST.md
- Plus 33 historical files (acceptable - in history/)

**Impact:**
- Users copying templates will get wrong paths
- AI assistants referencing docs will use incorrect paths
- New adopters following setup will encounter errors
- FEAT-025 blocked until corrected

### 3. Work Items Created

**FEAT-038: Update All v3.0.0 Path References** (P0 - Critical)
- Location: `framework/thoughts/work/todo/`
- Scope: 10 files (4 process docs, 5 templates, NEW-PROJECT-CHECKLIST.md)
- Purpose: Fix `thoughts/project/planning/` → `thoughts/work/` across all active documentation
- Status: Todo (moved from backlog)
- Blocking: FEAT-025

**FEAT-039: Verify project-hello-world Compliance** (P1)
- Location: `framework/thoughts/work/todo/`
- Purpose: Validate project-hello-world/ matches PROJECT-STRUCTURE-STANDARD.md
- Determines: Whether FEAT-025 needs to validate Standard level or focus on Minimal/Light only
- Status: Todo (moved from backlog)
- Output: Will create FEAT-039-VALIDATION-REPORT.md

**DECISION-036: Template Access Strategy** (P1)
- Location: `framework/thoughts/work/todo/`
- Purpose: Decide how users access framework templates
- Options: 5 approaches evaluated (copy all, reference externally, minimal set, online repo, hybrid)
- Status: Proposed
- Impact: Informs FEAT-038 and FEAT-025

**TECH-040: Document Work Item Creation Policy** (Low-Medium)
- Location: `framework/thoughts/work/backlog/`
- Purpose: Add explicit policy that new work items start in backlog/ with Status: Backlog
- Triggered by: Initially creating FEAT-038/039/036 in wrong location (todo/ instead of backlog/)
- Status: Backlog
- Note: Separate from FEAT-038 (different concerns)

### 4. Process Learning

**Discovery:** New work items should be created in backlog/, not todo/
- Work items initially created in todo/
- Corrected by moving to backlog/
- Identified need for explicit policy documentation (TECH-040)
- Learned: backlog/ = all planned work, todo/ = committed to work soon

---

## Decisions Made

### Decision 1: Work Item Numbering
**Issue:** Suggested work item numbers (FEAT-027, FEAT-028, DECISION-034) already taken
**Resolution:** Used next available: FEAT-038, FEAT-039, DECISION-036, TECH-040
**Learning:** Always check existing work item numbers before suggesting

### Decision 2: FEAT-038 Scope Expansion
**Original:** Update NEW-PROJECT-CHECKLIST.md only
**Expanded:** Update all 10 files with outdated path references
**Rationale:** More efficient to fix all path issues in one work item
**Renamed:** `FEAT-038-update-new-project-checklist.md` → `FEAT-038-update-v3-path-references.md`

### Decision 3: Keep TECH-040 Separate from FEAT-038
**Question:** Should TECH-040 be merged into FEAT-038 (both update kanban-workflow.md)?
**Decision:** Keep separate
**Rationale:**
- Different concerns (fix existing vs. add new)
- Different priorities (P0 vs. Low-Medium)
- Allows independent prioritization
- Clearer changelog entries

---

## Key Insights

### 1. FEAT-026 Incomplete
FEAT-026 successfully restructured the repository but missed updating active documentation and templates. This created a significant gap where:
- Structure is correct
- Documentation references are wrong
- Users and AI would follow incorrect paths

### 2. Template Access Unresolved
Critical validation issue from FEAT-025 analysis: Users need framework templates but no clear access strategy exists. This is a fundamental framework usability issue requiring resolution.

### 3. Validation Before Implementation Value
Analyzing FEAT-025 before implementation prevented:
- Wasted effort validating against wrong structure
- Creating examples with incorrect paths
- Following outdated checklist
- Missing the broader path reference problem

Estimated time saved: 2-3 days of rework

### 4. Work Item Creation Policy Gap
Framework workflow shows the flow but doesn't explicitly state WHERE new work items are created. This ambiguity led to error and revealed documentation gap.

---

## Technical Details

### Files Modified
- Created: `FEAT-025-ALIGNMENT-ANALYSIS.md` (todo/)
- Created: `FEAT-038-update-v3-path-references.md` (backlog → todo)
- Created: `FEAT-039-verify-hello-world-compliance.md` (backlog → todo)
- Created: `DECISION-036-template-access-strategy.md` (backlog → todo)
- Created: `TECH-040-document-work-item-creation-policy.md` (backlog)

### Path Issues Identified
**Pattern:** `thoughts/project/planning/` → `thoughts/work/`

**Affected Files (Active Documentation):**
1. `framework/docs/process/kanban-workflow.md`
2. `framework/docs/collaboration/workflow-guide.md`
3. `framework/docs/collaboration/troubleshooting-guide.md`
4. `framework/docs/collaboration/architecture-guide.md`
5. `framework/templates/documentation/CLAUDE-TEMPLATE.md`
6. `framework/templates/documentation/INDEX-TEMPLATE.md`
7. `framework/templates/documentation/PROJECT-STATUS-TEMPLATE.md`
8. `framework/templates/documentation/README-TEMPLATE.md`
9. `framework/templates/research/PROJECT-DEFINITION-TEMPLATE.md`
10. `project-templates/NEW-PROJECT-CHECKLIST.md`

**Historical Files:** 33 files in `thoughts/history/` (not updated - historical record)

---

## Action Items for Next Session

### Immediate (P0):
- [ ] Implement FEAT-038 (Update All v3.0.0 Path References)
  - Update 10 files
  - Verify with grep command
  - Critical blocker for FEAT-025

### High Priority (P1):
- [ ] Complete FEAT-039 (Verify project-hello-world)
  - Create validation report
  - Determine FEAT-025 scope impact

- [ ] Decide DECISION-036 (Template Access Strategy)
  - Evaluate 5 options
  - Select approach
  - Document in ADR
  - Implement in template packages

### After Prerequisites:
- [ ] Update FEAT-025 work item itself
  - Fix all path references
  - Update scope based on FEAT-039 findings
  - Reference prerequisite work items
  - Align with v3.0.0 reality

- [ ] Implement FEAT-025 (Manual Setup Validation)
  - Execute after prerequisites complete
  - Validate setup process
  - Test template access strategy

### Lower Priority:
- [ ] Implement TECH-040 (Document Work Item Creation Policy)
  - Add policy to kanban-workflow.md
  - Can be done anytime

---

## Challenges Encountered

### Challenge 1: Work Item Number Conflicts
**Issue:** Suggested numbers already taken
**Resolution:** Checked existing numbers, used next available
**Prevention:** Always verify available numbers before suggesting

### Challenge 2: Scope Creep Management
**Issue:** Discovery of 42 files with path issues could expand scope indefinitely
**Resolution:** Limited FEAT-038 to active documentation only (10 files), excluded historical files
**Rationale:** Historical files are archival record, don't need updating

### Challenge 3: Work Item Location Confusion
**Issue:** Unclear where new work items should be created
**Resolution:** Learned backlog/ is correct, created TECH-040 to document
**Impact:** Process improvement for future work items

---

## Metrics

**Time Investment:**
- Analysis: ~2 hours (comprehensive FEAT-025 review)
- Work item creation: ~1.5 hours (4 work items)
- Total: ~3.5 hours

**Files Analyzed:**
- 1 work item (FEAT-025) - comprehensive review
- 42 files identified with path issues
- 10 files scoped for FEAT-038

**Work Items Created:** 4
- 1 Analysis document (FEAT-025-ALIGNMENT-ANALYSIS)
- 2 Features (FEAT-038, FEAT-039)
- 1 Decision (DECISION-036)
- 1 Technical (TECH-040)

**Estimated Work Prevented:**
- FEAT-025 rework avoided: 2-3 days
- Path issue discovery later: Would have caused user confusion and multiple small fixes

---

## References

**Work Items:**
- [FEAT-025-ALIGNMENT-ANALYSIS.md](../work/todo/FEAT-025-ALIGNMENT-ANALYSIS.md)
- [FEAT-038-update-v3-path-references.md](../work/todo/FEAT-038-update-v3-path-references.md)
- [FEAT-039-verify-hello-world-compliance.md](../work/todo/FEAT-039-verify-hello-world-compliance.md)
- [DECISION-036-template-access-strategy.md](../work/todo/DECISION-036-template-access-strategy.md)
- [TECH-040-document-work-item-creation-policy.md](../work/backlog/TECH-040-document-work-item-creation-policy.md)

**Related Documents:**
- [PROJECT-STRUCTURE-STANDARD.md](../../docs/PROJECT-STRUCTURE-STANDARD.md)
- [REPOSITORY-STRUCTURE.md](../../docs/REPOSITORY-STRUCTURE.md)
- FEAT-026 Release Notes (v3.0.0)

---

## Notes for Future Sessions

**Context for Next Session:**
- FEAT-038 is critical blocker - implement first
- FEAT-025 cannot proceed until prerequisites complete
- Template access strategy needs decision
- project-hello-world compliance unknown

**Workflow Validated:**
- Analysis before implementation prevents rework
- Creating prerequisite work items when dependencies discovered is correct approach
- Work items should start in backlog/, move to todo/ when committed

**Process Improvements Identified:**
- Document work item creation policy (TECH-040)
- Consider automated path validation in future
- FEAT-026 should have included documentation review phase

---

**Session End:** 2026-01-10 (Morning Session)
**Status:** Prerequisites identified and created, ready for implementation
**Next Session:** Begin FEAT-038 implementation

---

# Session 2: Todo Review and Structure Audit (Afternoon)

**Time:** Afternoon, 2026-01-10
**Participants:** Gary Elliott, Claude (Sonnet 4.5)
**Focus:** Todo review, priority assessment, structure compliance audit
**Duration:** ~2 hours

---

## Summary (Session 2)

Conducted comprehensive review of todo/ work items to identify highest priorities. Discovered framework structure compliance gaps during priority assessment. Created FEAT-040 to fix structure issues and prioritized FEAT-038 as immediate P0 work.

**Key outcomes:**
- Reviewed 9 todo items and assessed priorities
- Identified P0 blockers: FEAT-038 (path references), DECISION-036 (template access)
- Discovered framework structure non-compliance issues
- Created FEAT-040 to fix structure compliance
- Moved FEAT-038 to doing/ as highest priority

---

## Work Completed (Session 2)

### 5. Todo Review and Priority Assessment

**Task:** Review framework/thoughts/work/todo/ for highest priority items

**Work items reviewed:**
- DECISION-036: Template Access Strategy (P0 - blocking)
- FEAT-038: Update v3.0.0 Path References (P0 - blocking FEAT-025)
- FEAT-039: Verify project-hello-world Compliance (P1)
- FEAT-025-ALIGNMENT-ANALYSIS: Analysis complete, major updates required
- FEAT-022: Automated Session History Generation (P2)
- FEAT-017: Backlog Review Command (backlog)
- FEAT-018: Claude Command Framework (backlog)
- FEAT-025-brainstorming.md, FEAT-025-manual-setup-validation.md (supporting files)

**Priority determination:**
- P0: DECISION-036, FEAT-038, FEAT-040 (blocking validation work)
- P1: FEAT-039 (informs FEAT-025 scope)
- P2: FEAT-022 (quality of life improvement)

**Recommended action sequence:**
1. FEAT-038 (fix outdated paths) ← HIGHEST PRIORITY
2. FEAT-040 (fix structure compliance)
3. DECISION-036 (template access decision)
4. FEAT-039 (validate hello-world)
5. FEAT-025 (manual setup validation)

### 6. Framework Structure Compliance Audit

**Task:** Verify framework/ complies with PROJECT-STRUCTURE-STANDARD.md

**Initial assessment (incorrect):**
- Appeared ~60% compliant with many missing elements
- Identified: missing src/, tests/, README.md, various READMEs, wrong folder names

**Investigation conducted:**
- Reviewed FEAT-026-universal-structure-decisions.md for design decisions
- Found DECISION-014: Selective README strategy (9 READMEs total, 5 per project)
- Found framework intentionally lacks src/tests/ (no executable code)
- Found .gitignore at repo root is by design (REPOSITORY-STRUCTURE.md line 160)

**Corrected assessment (~85% compliant):**
- Most "issues" were deliberate design decisions
- Only 4 real compliance gaps identified

**Actual non-compliance issues found:**
1. ❌ Folder name: `thoughts/reference/` should be `thoughts/external-references/`
2. ❌ Missing: `thoughts/history/spikes/` folder
3. ❌ Missing: 3 README files per DECISION-014:
   - `framework/README.md` (framework-specific overview)
   - `thoughts/work/README.md` (minimal workflow reference)
   - `thoughts/external-references/README.md` (distinction explanation)
4. ⚠️ Undocumented: Framework's intentional lack of src/tests/ folders

**Deliberate design decisions (NOT non-compliant):**
- ✅ No src/tests/ - Framework has no executable code (FEAT-026-P1-BUG-framework-structure.md lines 35-36)
- ✅ Single .gitignore at repo root - By design (REPOSITORY-STRUCTURE.md line 160)
- ✅ Selective .gitkeep files (6 per project) - Per DECISION-014

**Key documents consulted:**
- PROJECT-STRUCTURE-STANDARD.md
- REPOSITORY-STRUCTURE.md
- FEAT-026-universal-structure-decisions.md (DECISION-014 lines 429-462)
- FEAT-026-P1-BUG-framework-structure.md

### 7. Created FEAT-040: Fix Framework Structure Compliance

**Created:** framework/thoughts/work/todo/FEAT-040-fix-framework-structure-compliance.md

**Scope:**
- Rename thoughts/reference/ → thoughts/external-references/ (preserves git history)
- Create thoughts/history/spikes/ folder (no .gitkeep per DECISION-014)
- Add 3 missing README files per DECISION-014
- Document framework exceptions in PROJECT-STRUCTURE-STANDARD.md
- Update any references to old reference/ path

**Priority:** P0 - Blocks validation work (FEAT-025, FEAT-039)

**Estimated effort:** 1-2 hours

**Rationale:** Framework must dogfood its own structure before validating user projects against it.

### 8. Priority Comparison: FEAT-038 vs FEAT-040

**Analysis:** Which P0 item is higher priority?

**FEAT-038 (Path References) - Winner:**
- ❌ Active harm: Users following docs get wrong paths NOW
- ❌ Affects 10 actively-used files (docs, templates, checklist)
- ❌ Blocks FEAT-025 validation (can't validate with wrong docs)
- ❌ Process docs, templates, setup checklist all reference old structure
- Impact: Immediate user/AI confusion

**FEAT-040 (Structure Compliance):**
- ⚠️ Passive issue: Structure wrong but doesn't actively break workflow
- ⚠️ Mainly affects framework as reference implementation
- ⚠️ Blocks validation preparation (FEAT-025, FEAT-039)
- ⚠️ Users don't typically browse framework/thoughts/ directly
- Impact: Delayed (validation phase)

**Decision:** FEAT-038 higher priority
- Fix documentation/templates users consume NOW
- Then fix framework structure for validation reference
- Active harm > Passive issues

### 9. Moved FEAT-038 to Doing

**Action taken:**
- Moved FEAT-038 from todo/ to doing/
- Updated status: Todo → Doing
- Updated developer: TBD → Claude + User

**Rationale:** Highest priority P0 item, ready to start immediately

---

## Decisions Made (Session 2)

### Decision 4: FEAT-038 Has Higher Priority Than FEAT-040

**Context:** Both are P0 blockers, which to tackle first?

**Decision:** FEAT-038 first (update path references)

**Rationale:**
- Active harm vs. passive issue
- User-facing docs wrong NOW
- Path bugs cause immediate confusion
- Structure compliance mainly affects validation prep

**Implementation sequence:**
1. FEAT-038 (2-3 hours) - Fix paths in active docs/templates
2. FEAT-040 (1-2 hours) - Fix framework structure
3. DECISION-036 - Template access strategy decision
4. FEAT-039 - Verify project-hello-world
5. FEAT-025 - Manual setup validation

### Decision 5: Document Framework Exceptions

**Context:** Framework intentionally lacks src/tests/ folders

**Decision:** Add "Framework-Specific Exceptions" section to PROJECT-STRUCTURE-STANDARD.md

**Format:**
```markdown
### Framework-Specific Exceptions

The framework project intentionally deviates from Standard structure:

**Missing Folders:**
- `src/` - Framework has no executable source code
- `tests/` - Framework has no code tests currently

**Rationale:** Framework produces templates and documentation, not executable code.

**Additional Folders:**
- `templates/` - Framework deliverable templates
- `tools/` - Framework deliverable utilities

**Reference:** FEAT-026-P1-BUG-framework-structure.md
```

---

## Files Created (Session 2)

1. **FEAT-040-fix-framework-structure-compliance.md**
   - Location: framework/thoughts/work/todo/
   - Purpose: Fix 4 structure compliance gaps
   - Type: Feature (Structure Compliance)
   - Priority: P0
   - Estimated effort: 1-2 hours

---

## Files Modified (Session 2)

1. **FEAT-038-update-v3-path-references.md**
   - Moved: thoughts/work/todo/ → thoughts/work/doing/
   - Status: Todo → Doing
   - Developer: TBD → Claude + User

2. **2026-01-10-SESSION-HISTORY.md** (this file)
   - Added: Session 2 documentation
   - Updated: End status, next steps

---

## Key Insights (Session 2)

### Insight 1: Framework Structure Compliance

**Discovery:** Initial compliance assessment was incorrect because it didn't account for deliberate design decisions documented in FEAT-026.

**Learning:** When auditing compliance:
1. Check design decisions FIRST (FEAT-026 docs, ADRs)
2. Distinguish intentional deviations from gaps
3. Document exceptions explicitly in standards

**Impact:** Framework is ~85% compliant (not 60%), with only 4 real gaps to fix.

### Insight 2: Framework as Reference Implementation

**Challenge:** Framework is a documentation project (no src/tests/), creating intentional deviations from standard.

**Solution:** Document exceptions explicitly in PROJECT-STRUCTURE-STANDARD.md with rationale.

**Importance:** Framework must dogfood its own structure to serve as credible reference for users.

### Insight 3: Priority Assessment Methodology

**Effective approach:**
1. Read all work items
2. Identify blockers (what blocks what?)
3. Assess immediate user impact (active harm vs. passive issue)
4. Check dependencies
5. Prioritize: Active harm > Blocking > Important but not urgent

**Applied to FEAT-038 vs FEAT-040:**
- Both P0 blockers
- FEAT-038: Active harm (wrong docs NOW)
- FEAT-040: Passive (structure wrong but not breaking workflow)
- Result: FEAT-038 first

### Insight 4: DECISION-014 Clarity

**Key reference:** DECISION-014: Selective README strategy (lines 429-462)
- 9 READMEs total across monorepo
- 5 per project: root, docs/, work/, research/, external-references/
- Not drowning in README files (rejected Option D - READMEs everywhere)

**Importance:** This decision resolved user's concern about "too many READMEs" - we explicitly decided which ones to keep.

---

## Blocking Relationships (Current State)

```
FEAT-038 (doing) ──blocks──> FEAT-025 (todo)
FEAT-040 (todo)  ──blocks──> FEAT-025 (todo)
DECISION-036     ──blocks──> FEAT-025 (todo)
FEAT-039 (todo)  ──informs─> FEAT-025 (scope)
```

**Resolution path:**
- Complete FEAT-038 + FEAT-040 + DECISION-036
- Then FEAT-039 (validate hello-world)
- Finally FEAT-025 (setup validation) unblocked

---

## Follow-up Items (Combined)

### Immediate Next Steps

1. **Complete FEAT-038** - Update all v3.0.0 path references (DOING)
   - 10 files to update (4 process docs, 5 templates, 1 checklist)
   - Replace thoughts/project/planning/ → thoughts/work/
   - Update template references
   - Verify with grep command
   - Status: Moved to doing/

2. **Complete FEAT-040** - Fix framework structure compliance
   - Rename reference/ → external-references/
   - Create spikes/ folder
   - Add 3 READMEs
   - Document exceptions
   - Quick fixes (1-2 hours)

3. **Make DECISION-036** - Template access strategy
   - Evaluate 5 options
   - Critical for FEAT-025 validation
   - Document in ADR

4. **Complete FEAT-039** - Verify project-hello-world
   - Create validation report
   - Determine FEAT-025 scope impact

5. **Update and execute FEAT-025** - Manual setup validation
   - After all prerequisites complete
   - Validate setup process works end-to-end

---

## Metrics (Combined Sessions)

**Total session time:** ~5.5 hours (3.5 morning + 2 afternoon)

**Work items reviewed:** 9

**Work items created:** 5 total
- Session 1: FEAT-038, FEAT-039, DECISION-036, TECH-040
- Session 2: FEAT-040

**Work items moved:** 1 (FEAT-038 todo → doing)

**Decisions made:** 5
- Session 1: 3 decisions
- Session 2: 2 decisions

**Files read:** ~15 (structure standards, FEAT-026 decisions, work items)

**Structure compliance:** Improved understanding from 60% → 85% compliant

**Documents consulted:**
- PROJECT-STRUCTURE-STANDARD.md
- REPOSITORY-STRUCTURE.md
- FEAT-026-universal-structure-decisions.md
- FEAT-026-P1-BUG-framework-structure.md
- Multiple work items in todo/

---

## Lessons Learned (Combined)

1. **Check design decisions before reporting non-compliance** - Saves time and prevents incorrect assessments

2. **Active harm > Passive issues** - When prioritizing, fix user-facing problems before internal reference issues

3. **Document exceptions explicitly** - Intentional deviations need rationale in standards docs

4. **Dogfooding matters** - Framework must follow its own structure to be credible reference

5. **Blocking relationships guide priorities** - Understanding what blocks what clarifies execution order

6. **Analysis before implementation prevents rework** - FEAT-025 analysis saved 2-3 days of rework

7. **Work items should start in backlog/** - Then move to todo/ when committed (TECH-040)

---

## References (Combined)

**Work items created today:**
- [FEAT-025-ALIGNMENT-ANALYSIS.md](../work/todo/FEAT-025-ALIGNMENT-ANALYSIS.md)
- [FEAT-038-update-v3-path-references.md](../work/doing/FEAT-038-update-v3-path-references.md)
- [FEAT-039-verify-hello-world-compliance.md](../work/todo/FEAT-039-verify-hello-world-compliance.md)
- [FEAT-040-fix-framework-structure-compliance.md](../work/todo/FEAT-040-fix-framework-structure-compliance.md)
- [DECISION-036-template-access-strategy.md](../work/todo/DECISION-036-template-access-strategy.md)
- [TECH-040-document-work-item-creation-policy.md](../work/backlog/TECH-040-document-work-item-creation-policy.md)

**Related documents:**
- [PROJECT-STRUCTURE-STANDARD.md](../../docs/PROJECT-STRUCTURE-STANDARD.md)
- [REPOSITORY-STRUCTURE.md](../../docs/REPOSITORY-STRUCTURE.md)
- [FEAT-026-universal-structure-decisions.md](../releases/v3.0.0/FEAT-026-universal-structure-decisions.md)
- [FEAT-026-P1-BUG-framework-structure.md](../releases/v3.0.0/FEAT-026-P1-BUG-framework-structure.md)

---

**Session End:** 2026-01-10 (Both sessions complete)
**Status:** FEAT-038 in doing/, priorities established, structure compliance understood
**Next Session:** Implement FEAT-038 (update path references)

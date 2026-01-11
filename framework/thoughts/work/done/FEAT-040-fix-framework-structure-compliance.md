# Feature: Fix Framework Structure Compliance

**ID:** FEAT-040
**Type:** Feature (Structure Compliance)
**Version Impact:** PATCH (fixes structure compliance)
**Status:** Todo
**Created:** 2026-01-10
**Completed:** N/A
**Developer:** TBD

---

## Summary

Fix remaining framework/ structure compliance issues discovered during structure audit. Align framework folder structure with PROJECT-STRUCTURE-STANDARD.md and DECISION-014 (Selective README strategy).

---

## Problem Statement

**What problem does this solve?**

During structure compliance audit (2026-01-10), discovered that framework/ project has incomplete migration from FEAT-026. Several required folders, files, and naming conventions from v3.0.0 decisions are not yet implemented.

**Specific Issues Identified:**

1. **Wrong folder name:** `thoughts/reference/` should be `thoughts/external-references/`
2. **Missing README files:** 3 READMEs required by DECISION-014 are missing
3. **Missing required folder:** `thoughts/history/spikes/` doesn't exist
4. **Undocumented deviation:** Framework lacks `src/` and `tests/` folders (intentional but not documented)

**Who is affected?**

- Framework maintainers (structure doesn't match our own standard)
- FEAT-025 validation (can't validate setup process with non-compliant framework)
- FEAT-039 validation (project-hello-world validation blocked)
- Users looking at framework as reference implementation

**Current workaround (if any):**

None - framework is not fully compliant with its own standard.

---

## Requirements

### Functional Requirements

**Folder Corrections:**
- [ ] FR1: Rename `thoughts/reference/` to `thoughts/external-references/`
- [ ] FR2: Create `thoughts/history/spikes/` folder
- [ ] FR3: Update any references to old `reference/` path in documentation

**README Files (per DECISION-014):**
- [ ] FR4: Create `framework/README.md` (framework-specific overview)
- [ ] FR5: Create `thoughts/work/README.md` (minimal workflow reference)
- [ ] FR6: Create `thoughts/external-references/README.md` (distinction explanation)

**Documentation Updates:**
- [ ] FR7: Document intentional `src/` and `tests/` deviation in PROJECT-STRUCTURE-STANDARD.md
- [ ] FR8: Update any references to `thoughts/reference/` across all docs
- [ ] FR9: Verify all structure decisions are implemented

**Validation:**
- [ ] FR10: Framework structure matches PROJECT-STRUCTURE-STANDARD.md (with documented exceptions)
- [ ] FR11: All DECISION-014 READMEs present
- [ ] FR12: All FEAT-026 structure decisions implemented

### Non-Functional Requirements

- [ ] NFR1: Consistency - Framework dogfoods its own structure
- [ ] NFR2: Documentation - All deviations explicitly documented with rationale
- [ ] NFR3: Completeness - All v3.0.0 structural decisions implemented

---

## Design

### Architecture Impact

**Files/Folders Renamed:**
- `framework/thoughts/reference/` → `framework/thoughts/external-references/`
  - Contains: `version-strategy.md` (will move with folder)

**Files Added:**
- `framework/README.md` - Framework-specific overview
- `framework/thoughts/work/README.md` - Workflow reference
- `framework/thoughts/external-references/README.md` - Distinction explanation
- `framework/thoughts/history/spikes/` - Empty folder (no .gitkeep per DECISION-014)

**Files Modified:**
- `framework/docs/PROJECT-STRUCTURE-STANDARD.md` - Add framework exception note
- Any docs referencing `thoughts/reference/`

**Configuration Changes:**
None

### Implementation Approach

**Phase 1: Folder Structure Fixes**

1. **Rename reference folder:**
   ```bash
   git mv framework/thoughts/reference framework/thoughts/external-references
   ```

2. **Create spikes folder:**
   ```bash
   mkdir framework/thoughts/history/spikes
   ```

3. **Verify no .gitkeep needed:**
   - Per DECISION-014 line 147: "Do NOT use .gitkeep in thoughts/history/*"
   - Rationale: Will populate naturally on first spike

**Phase 2: Create README Files**

1. **framework/README.md:**
   - Framework-specific overview
   - What is the Standard Project Framework?
   - Link to full documentation in docs/
   - Link to root README for repository overview
   - Length: ~50-100 lines

2. **thoughts/work/README.md:**
   - Based on PROJECT-STRUCTURE-STANDARD.md lines 236-254
   - Minimal workflow reference
   - Link to kanban-workflow.md
   - WIP limits explanation
   - Length: ~15-20 lines

3. **thoughts/external-references/README.md:**
   - Based on PROJECT-STRUCTURE-STANDARD.md lines 321-350
   - Explain external-references purpose
   - Deletion test distinction from research/
   - What to store here vs. research/
   - Length: ~30-40 lines

**Phase 3: Document Exceptions**

1. **Update PROJECT-STRUCTURE-STANDARD.md:**
   - Add section: "Framework-Specific Exceptions"
   - Document: Framework has no src/ or tests/ folders
   - Rationale: Framework is documentation/templates project, not executable code
   - Reference: FEAT-026-P1-BUG-framework-structure.md
   - Location: After "Complete Project Structure" section

2. **Example exception documentation:**
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

**Phase 4: Find and Fix References**

1. **Search for old references:**
   ```bash
   grep -r "thoughts/reference/" framework/docs/
   grep -r "thoughts/reference/" framework/templates/
   ```

2. **Update any found references to:**
   - `thoughts/reference/` → `thoughts/external-references/`

**Phase 5: Validation**

1. **Run structure validation checklist from PROJECT-STRUCTURE-STANDARD.md**
2. **Verify against DECISION-014 (Selective README strategy)**
3. **Verify against all FEAT-026 decisions**
4. **Document validation results**

### Alternative Approaches Considered

**Option A: Keep current structure, update standard to match**
- Pros: No file moves needed
- Cons: Defeats purpose of v3.0.0 migration, inconsistent with decisions
- Decision: Rejected - framework should match its own standard

**Option B: Add src/ and tests/ folders to framework**
- Pros: Perfect compliance with standard
- Cons: Unnecessary (framework has no code), misleading to users
- Decision: Rejected - document exception instead

**Option C: Delay until FEAT-025 validation**
- Pros: Could fix based on validation findings
- Cons: Can't validate against non-compliant framework, delays FEAT-025
- Decision: Rejected - fix now to unblock validation

---

## Dependencies

**Requires:**
- PROJECT-STRUCTURE-STANDARD.md (exists)
- DECISION-014 (documented in FEAT-026)
- FEAT-026 completion (done)

**Blocks:**
- FEAT-025 (Manual Setup Process Validation) - Needs compliant framework
- FEAT-039 (Verify project-hello-world) - Parallel validation work

**Related:**
- FEAT-026 (Framework Structure Migration) - Completes migration
- FEAT-038 (Update v3.0.0 Path References) - Parallel path fix work
- DECISION-036 (Template Access Strategy) - May affect documentation

---

## Testing Plan

### Validation Checklist

**Folder Structure:**
- [ ] `thoughts/external-references/` exists (renamed from reference/)
- [ ] `thoughts/external-references/` contains version-strategy.md
- [ ] `thoughts/history/spikes/` exists (empty folder)
- [ ] No `thoughts/reference/` folder remains

**README Files (DECISION-014):**
- [ ] `framework/README.md` exists with framework overview
- [ ] `thoughts/work/README.md` exists with workflow reference
- [ ] `thoughts/external-references/README.md` exists with distinction explanation
- [ ] All READMEs have appropriate content (not just placeholders)

**Documentation Compliance:**
- [ ] PROJECT-STRUCTURE-STANDARD.md documents src/tests exception
- [ ] No references to `thoughts/reference/` in documentation
- [ ] All paths reference `thoughts/external-references/`

**Structure Compliance:**
- [ ] Run PROJECT-STRUCTURE-STANDARD.md validation checklist (lines 599-628)
- [ ] All required folders exist (with documented exceptions)
- [ ] All required files exist
- [ ] All DECISION-014 READMEs present

### Manual Verification

1. **Search for old references:**
   ```bash
   grep -r "thoughts/reference/" framework/
   # Should return 0 results (except in history/)
   ```

2. **Verify folder rename:**
   ```bash
   ls framework/thoughts/external-references/version-strategy.md
   # Should exist
   ```

3. **Check README content quality:**
   - Read each README
   - Verify helpful content (not just "TODO")
   - Verify appropriate length
   - Verify correct links

4. **Git history clean:**
   - Verify `git mv` used (preserves history)
   - No orphaned files

---

## Implementation Checklist

**Phase 1: Folder Structure**
- [ ] Rename `thoughts/reference/` to `thoughts/external-references/`
- [ ] Create `thoughts/history/spikes/` folder
- [ ] Verify `version-strategy.md` moved correctly

**Phase 2: README Files**
- [ ] Create `framework/README.md`
- [ ] Create `thoughts/work/README.md`
- [ ] Create `thoughts/external-references/README.md`
- [ ] Verify README content quality

**Phase 3: Documentation**
- [ ] Add exception section to PROJECT-STRUCTURE-STANDARD.md
- [ ] Document src/tests deviation with rationale
- [ ] Search and replace old reference/ paths
- [ ] Update any templates referencing old paths

**Phase 4: Validation**
- [ ] Run validation checklist
- [ ] Verify all DECISION-014 items implemented
- [ ] Check for remaining compliance issues
- [ ] Document validation results

**Phase 5: Commit**
- [ ] Review all changes
- [ ] Commit with descriptive message
- [ ] Update work item status to Done

---

## Success Metrics

**How do we know this fix is successful?**

1. ✅ Framework structure matches PROJECT-STRUCTURE-STANDARD.md (with documented exceptions)
2. ✅ All 5 DECISION-014 READMEs present in framework/
3. ✅ Zero references to `thoughts/reference/` in active docs
4. ✅ All FEAT-026 structure decisions implemented
5. ✅ Framework can serve as reference implementation for users
6. ✅ FEAT-025 and FEAT-039 can proceed with validation

**Failure Criteria:**
- Structure still has compliance gaps
- READMEs missing or placeholder-only
- Old paths still referenced
- Deviations not documented

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Fixed
- **FEAT-040: Fix Framework Structure Compliance**
  - Renamed thoughts/reference/ to thoughts/external-references/ (per DECISION-014)
  - Created thoughts/history/spikes/ folder (per FEAT-026)
  - Added 3 missing README files (framework/README.md, thoughts/work/README.md, thoughts/external-references/README.md)
  - Documented framework exceptions (no src/tests/) in PROJECT-STRUCTURE-STANDARD.md
  - Updated all references to old reference/ path
  - Framework now fully compliant with v3.0.0 structure standard
```

---

## Notes

**Priority:** P0 - Blocks validation work items (FEAT-025, FEAT-039)

**Discovered during:** Structure compliance audit (2026-01-10)

**Key insight:** Framework must dogfood its own structure before validating user projects against it. Can't validate setup process with non-compliant framework.

**DECISION-014 Reference:** "Selective Strategy (Meaningful READMEs + .gitkeep)" - lines 429-462 in FEAT-026-universal-structure-decisions.md

**Related decisions:**
- DECISION-014: Selective README strategy (9 READMEs total)
- DECISION-016: Separate REPOSITORY-STRUCTURE.md
- FEAT-026-P1-BUG-framework-structure.md: Questions about src/tests/

**Estimated effort:** 1-2 hours (straightforward fixes)

---

## References

- [PROJECT-STRUCTURE-STANDARD.md](../../docs/PROJECT-STRUCTURE-STANDARD.md) - Structure specification
- [FEAT-026-universal-structure-decisions.md](../history/releases/v3.0.0/FEAT-026-universal-structure-decisions.md) - DECISION-014
- [FEAT-026-P1-BUG-framework-structure.md](../history/releases/v3.0.0/FEAT-026-P1-BUG-framework-structure.md) - Original issue
- Structure compliance audit findings (2026-01-10)

---

**Last Updated:** 2026-01-10
**Status:** Todo

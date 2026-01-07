# FEAT-026 Sub-Item: Fix framework/CLAUDE.md Paths and References

**ID:** FEAT-026-P2-TECH-claude-md-cleanup
**Parent:** FEAT-026-structure-migration
**Type:** Technical Debt
**Priority:** P2 (Should fix before merge)
**Status:** Todo
**Created:** 2026-01-06

---

## Summary

Fix outdated folder paths, architecture references, and other issues in framework/CLAUDE.md.

---

## Problem

**From followup lines 28-40:**

Multiple issues in framework/CLAUDE.md:
1. Line 28: References "Standard Framework Level" which is never defined
2. Line 32: Architecture folders look out of date
3. Line 31: Critical folder paths are wrong
4. The 11 Steps section issues
5. Example interaction issues

---

## Specific Issues

### Issue 1: Undefined "Standard Framework Level"
**Line 28:** "references the 'Standard Framework Level' but we've never defined what that is."

Need to either:
- Define what "Standard Framework Level" means
- Remove the term and use clearer language

### Issue 2: Outdated Architecture Folders
**Line 32:** "The architecture folders look out of date. Should we be defining any of this here?"

Review and update:
- Current structure documentation
- Remove outdated folder references
- Consider if CLAUDE.md is right place for detailed structure

### Issue 3: Wrong Critical Paths
**Line 31:** "Critical folder paths are wrong."

Audit and fix all folder paths in CLAUDE.md to match new structure.

### Issue 4: Research Step Timeframe
**Line 32-33:** "Step 2. Why mention a time frame for research?"

Remove artificial time constraints on research phase.

### Issue 5: Status Redundancy
**Line 33-34:** "Step 7. Are we adding a redundant step by updating the status within the file when it's already sitting in a status folder?"

Review if file status field is redundant with folder location.

### Issue 6: Release Workflow
**Line 34-35:** "Step 9. Should the framework allow a user the option to release multiple items at the same time under the same version number?"

Document current approach or plan enhancement.

### Issue 7: Example Interaction
**Line 35-36:** "Perhaps we should change line 256 to something like 'Should I move to todo/?' or maybe not prompt any action."

Review example interactions to not violate workflow.

---

## Implementation

1. **Read** current framework/CLAUDE.md
2. **Fix** all path references
3. **Update** architecture documentation
4. **Remove** time constraints
5. **Review** workflow steps for redundancy
6. **Update** example interactions
7. **Define** or remove "Standard Framework Level" term

---

## Completion Criteria

- [ ] All folder paths correct
- [ ] Architecture references current
- [ ] "Standard Framework Level" defined or removed
- [ ] Research timeframes removed
- [ ] Workflow steps reviewed and updated
- [ ] Example interactions don't violate workflow
- [ ] Changes committed

---

**Last Updated:** 2026-01-06
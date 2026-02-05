# Feature: Renumber Workflow Steps to Sequential Integers

**ID:** FEAT-024
**Type:** Feature
**Priority:** Low
**Version Impact:** PATCH
**Created:** 2026-01-01
**Theme:** Workflow

---

## Summary

After BUGFIX-002 (Step 8.5) and BUGFIX-005 (Step 7.5) are implemented, the AI Workflow Checkpoint Policy will have non-sequential step numbering (1-7, 7.5, 8, 8.5, 9). This feature renumbers all steps to clean sequential integers (1-11) and updates all documentation references.

---

## Problem Statement

**Current State (after BUGFIX-002 + BUGFIX-005):**
```
Step 1: User Requests Feature
Step 2: Brief Research
Step 3: Create Backlog Item
Step 4: Present Plan to User ⚠️ CHECKPOINT
Step 5: Wait for User Approval
Step 6: Check WIP Limits
Step 7: Move Through Workflow
Step 7.5: Pre-Implementation Review ⚠️ CHECKPOINT (BUGFIX-005)
Step 8: Implement
Step 8.5: Review & Approval ⚠️ CHECKPOINT (BUGFIX-002)
Step 9: Complete & Release
```

**Issues:**
1. **Unprofessional appearance:** Decimal step numbers (7.5, 8.5) look like patches/band-aids
2. **Future insertions:** If we need another step, do we use 7.25? 8.75? Gets messy
3. **Reference ambiguity:** "Step 9" could mean different things in different doc versions
4. **Scaling problem:** Can't sustain this pattern as workflow evolves

**Desired State:**
```
Step 1: User Requests Feature
Step 2: Brief Research
Step 3: Create Backlog Item
Step 4: Present Plan to User ⚠️ CHECKPOINT
Step 5: Wait for User Approval
Step 6: Check WIP Limits
Step 7: Move Through Workflow
Step 8: Pre-Implementation Review ⚠️ CHECKPOINT (was 7.5)
Step 9: Implement (was 8)
Step 10: Post-Implementation Review & Approval ⚠️ CHECKPOINT (was 8.5)
Step 11: Complete & Release (was 9)
```

---

## Why This Exists

**Context:**
- BUGFIX-002 added Step 8.5 (post-implementation review) to avoid breaking references
- BUGFIX-005 will add Step 7.5 (pre-implementation review) for same reason
- Each bugfix deferred the renumbering work to avoid scope creep
- Now we have accumulated "documentation debt"

**User Request (2026-01-01):**
> "Let's defer and create a new work item. This way we can clean all the docs up in one task once all or most of the other open items are complete."

**Strategic Timing:**
- Wait until workflow stabilizes (BUGFIX-002, BUGFIX-005 complete)
- Do one comprehensive renumbering instead of piecemeal updates
- Minimize total churn across documentation

---

## Goals

### Primary Goals
1. **Clean sequential numbering:** Steps 1-11 with no decimals
2. **Update all references:** Find and update all "Step X" references across docs
3. **Maintain meaning:** Step content/order unchanged, only numbers change

### Non-Goals
- ❌ Change step content or workflow logic
- ❌ Add/remove steps (this is just renumbering)
- ❌ Update historical documents (session histories, archived releases)

---

## User Stories

**As a developer reading CLAUDE.md:**
- I want to see clean sequential step numbers (1-11)
- So that the workflow looks professional and well-designed
- Rather than seeing decimal numbers that suggest "we didn't plan this"

**As a contributor referencing the workflow:**
- I want "Step 9" to have one clear meaning
- So that I can reference specific steps without version confusion
- Rather than wondering "old Step 9 or new Step 9?"

**As maintainers evolving the workflow:**
- I want to be able to insert new steps cleanly
- So that future enhancements don't create Step 7.33 or similar
- Rather than accumulating more decimal step numbers

---

## Technical Design

### Renumbering Map

| Old Number | New Number | Step Name |
|------------|------------|-----------|
| 1 | 1 | User Requests Feature |
| 2 | 2 | Brief Research |
| 3 | 3 | Create Backlog Item |
| 4 | 4 | Present Plan to User ⚠️ CHECKPOINT |
| 5 | 5 | Wait for User Approval |
| 6 | 6 | Check WIP Limits |
| 7 | 7 | Move Through Workflow |
| **7.5** | **8** | **Pre-Implementation Review ⚠️ CHECKPOINT** |
| **8** | **9** | **Implement** |
| **8.5** | **10** | **Post-Implementation Review & Approval ⚠️ CHECKPOINT** |
| **9** | **11** | **Complete & Release** |

**Changes:**
- Steps 1-7: No change
- Step 7.5 → Step 8 (pre-implementation review)
- Step 8 → Step 9 (implement)
- Step 8.5 → Step 10 (post-implementation review)
- Step 9 → Step 11 (complete & release)

### Files to Update

**Primary Documents:**
1. **CLAUDE.md** - AI Workflow Checkpoint Policy section
   - Change "The 10 Steps" → "The 11 Steps" (or "The 11 Steps" if BUGFIX-005 done)
   - Renumber Step 7.5 → 8, Step 8 → 9, Step 8.5 → 10, Step 9 → 11
   - Update all internal references (e.g., "proceed to Step 9" → "proceed to Step 11")

2. **CLAUDE-QUICK-REFERENCE.md**
   - Line 107: Update "step 9" reference to "step 11"

3. **project-hub/project/collaboration/workflow-guide.md**
   - Line 198: Update "Step 9" reference to "Step 11"

4. **project-hub/project/collaboration/troubleshooting-guide.md**
   - Line 248: Update "step 9" reference to "step 11"
   - Line 253: Update "step 9" reference to "step 11"

**Work Items (if not yet archived):**
- BUGFIX-002: Update Step 8.5 → Step 10 references
- BUGFIX-005: Update Step 7.5 → Step 8 references

**Templates:**
- No changes needed (templates reference CLAUDE.md, not specific step numbers)

**Historical Documents:**
- ❌ Do NOT update (session histories, archived releases)
- Keep as historical record of how workflow evolved

### Implementation Strategy

**Phase 1: Preparation**
1. Ensure BUGFIX-002 and BUGFIX-005 are complete and released
2. Grep for all "Step [0-9]" references across active documentation
3. Create checklist of files to update

**Phase 2: Renumbering**
1. Update CLAUDE.md (main workflow section)
2. Update CLAUDE.md (all internal references)
3. Update CLAUDE-QUICK-REFERENCE.md
4. Update workflow-guide.md
5. Update troubleshooting-guide.md

**Phase 3: Verification**
1. Grep for remaining "Step 7.5" or "Step 8.5" references (should be zero in active docs)
2. Verify all "Step 9" now means "Complete & Release" (Step 11)
3. Review updated docs for consistency

**Phase 4: Documentation**
1. Add note to CHANGELOG: "Documentation: Renumbered workflow steps to sequential integers (1-11)"
2. Update this work item with completion notes

---

## Search Patterns for References

**Files to search (active docs only):**
```bash
# Primary docs
CLAUDE.md
CLAUDE-QUICK-REFERENCE.md
project-hub/project/collaboration/*.md
project-hub/project/planning/backlog/*.md
project-hub/project/work/todo/*.md
project-hub/project/work/doing/*.md
```

**Patterns to search:**
```regex
Step 7\.5
Step 8\.5
Step 9[^0-9]  # Step 9 not followed by digit
step 9[^0-9]  # case insensitive
```

**Expected results (after BUGFIX-002 + BUGFIX-005 complete):**
- "Step 7.5" in CLAUDE.md, BUGFIX-005 work item → Change to "Step 8"
- "Step 8.5" in CLAUDE.md, BUGFIX-002 work item → Change to "Step 10"
- "Step 9" in multiple files → Change to "Step 11"

---

## Testing Strategy

### Manual Verification Checklist

**Before starting:**
- [ ] BUGFIX-002 is complete and released (Step 8.5 exists)
- [ ] BUGFIX-005 is complete and released (Step 7.5 exists)
- [ ] OR: Both are still pending (only Step 8.5 exists for now)

**Renumbering checklist:**
- [ ] CLAUDE.md: Header changed to "The 11 Steps"
- [ ] CLAUDE.md: Step 7.5 → Step 8
- [ ] CLAUDE.md: Step 8 → Step 9
- [ ] CLAUDE.md: Step 8.5 → Step 10
- [ ] CLAUDE.md: Step 9 → Step 11
- [ ] CLAUDE.md: All internal "proceed to Step X" references updated
- [ ] CLAUDE-QUICK-REFERENCE.md: Step 9 → Step 11
- [ ] workflow-guide.md: Step 9 → Step 11
- [ ] troubleshooting-guide.md: step 9 → step 11 (2 occurrences)

**Verification:**
- [ ] Grep for "Step 7.5" in active docs: 0 results
- [ ] Grep for "Step 8.5" in active docs: 0 results
- [ ] Grep for "Step 9[^0-9]" in active docs: Only references to new Step 9 (Implement)
- [ ] Read through CLAUDE.md workflow section: Makes sense, no orphaned references
- [ ] All step numbers 1-11 are sequential integers

**Historical preservation:**
- [ ] Session histories NOT updated (intentional)
- [ ] Archived releases NOT updated (intentional)
- [ ] Work items BUGFIX-002 and BUGFIX-005 mention renumbering happened

---

## Alternative Approaches Considered

### Option A: Keep Decimal Numbering
- Pros: No work required, no references to update
- Cons: Unprofessional, doesn't scale, ambiguous references
- **Decision:** Rejected - accumulates documentation debt

### Option B: Renumber Immediately with Each Bugfix
- Pros: Always clean numbering
- Cons: Churns documentation multiple times, high overhead per bugfix
- **Decision:** Rejected - too much churn, better to batch

### Option C: Renumber Now (Selected Approach)
- Pros: One-time cleanup, clean sequential numbers, professional appearance
- Cons: Need to update ~4 files, one-time effort
- **Decision:** Accepted - best balance of cost vs benefit

---

## Success Criteria

**Must Have:**
- [ ] All workflow steps numbered 1-11 (sequential integers, no decimals)
- [ ] All active documentation references updated
- [ ] No broken internal references (grep verification)
- [ ] CHANGELOG documents the renumbering

**Nice to Have:**
- [ ] Note in BUGFIX-002 and BUGFIX-005 work items about renumbering
- [ ] Smooth reading experience through CLAUDE.md workflow section

**Out of Scope:**
- Updating historical documents (intentionally preserved)
- Changing step content or workflow logic

---

## Impact Assessment

**User Impact:**
- ✅ Positive: Cleaner, more professional documentation
- ✅ Positive: Clearer step references going forward
- ⚠️ Neutral: No functional changes, pure cosmetic

**Breaking Changes:**
- ❌ None - this is documentation only
- References in old commits/docs will still make sense in context

**Documentation Debt:**
- ✅ Reduces: Eliminates decimal step numbers
- ✅ Prevents: Future 7.25, 8.33, etc. complexity

---

## Dependencies

**Blockers (must be complete first):**
- BUGFIX-002: Missing Review Step (adds Step 8.5)
- BUGFIX-005: Missing Pre-Implementation Review (adds Step 7.5)

**Recommended (better to wait for):**
- Any other workflow changes in progress
- Workflow stabilization period

**Blocks:**
- None - this is cosmetic cleanup

---

## Risks & Mitigation

**Risk 1: Miss a reference, break documentation**
- Likelihood: Low
- Impact: Low (just a broken reference)
- Mitigation: Grep verification, manual review
- Rollback: Easy (just a doc change, revert commit)

**Risk 2: Confusion about "old Step 9 vs new Step 9"**
- Likelihood: Medium
- Impact: Low (users can check CLAUDE.md)
- Mitigation: Add note in CHANGELOG about renumbering
- Rollback: N/A (forward-only change)

**Risk 3: More workflow changes come after renumbering**
- Likelihood: Medium (workflow still evolving)
- Impact: Low (renumbering doesn't prevent future changes)
- Mitigation: Wait for workflow stabilization before doing this
- Rollback: N/A (not applicable)

---

## Timeline Recommendation

**When to implement:**
- ✅ After BUGFIX-002 is released (v2.3.0)
- ✅ After BUGFIX-005 is released (v2.3.1 or later)
- ✅ After other workflow changes stabilize
- ✅ Low priority - can wait for slow period

**Estimated effort:**
- Research: 30 minutes (grep all references)
- Implementation: 1 hour (update all files)
- Verification: 30 minutes (grep + manual review)
- Total: ~2 hours

---

## Related Work

**Depends on:**
- BUGFIX-002: Missing Review Step (adds Step 8.5)
- BUGFIX-005: Missing Pre-Implementation Review (adds Step 7.5)

**Related to:**
- ADR-001: AI Workflow Checkpoint Policy (the workflow being renumbered)

**History:**
- 2026-01-01: User suggested deferring renumbering to avoid scope creep
- 2026-01-01: Discussion of 8.5 vs renumbering during BUGFIX-002 review
- 2026-01-01: FEAT-024 created to track this cleanup work

---

## CHANGELOG Notes

**Changed:**
- Renumbered AI Workflow Checkpoint Policy steps to sequential integers (1-11)
- Updated all documentation references to new step numbers
- No functional changes, documentation cleanup only

**Migration Guide:**
- Old Step 7.5 → New Step 8 (Pre-Implementation Review)
- Old Step 8 → New Step 9 (Implement)
- Old Step 8.5 → New Step 10 (Post-Implementation Review)
- Old Step 9 → New Step 11 (Complete & Release)

---

## Notes

**Strategic Decision:**
- Deferred from BUGFIX-002 to avoid scope creep
- Allows all workflow changes to settle before comprehensive cleanup
- One-time effort vs. multiple small updates

**Future Prevention:**
- If workflow needs more steps, insert them with clean sequential numbers
- Update references immediately
- Avoid decimal numbering going forward

---

**Last Updated:** 2026-01-01

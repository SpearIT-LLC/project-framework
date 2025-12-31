# Bug Fix: Missing Review Step in AI Workflow Checkpoint Policy

**ID:** BUGFIX-002
**Type:** Bugfix
**Version Impact:** PATCH (backward-compatible documentation fix)
**Target Version:** v2.2.2
**Status:** Backlog
**Severity:** Medium
**Priority:** P2
**Version Found:** v2.2.1
**Version Fixed:** N/A
**Created:** 2025-12-31
**Fixed:** N/A
**Developer:** TBD

---

## Summary

The AI Workflow Checkpoint Policy (CLAUDE.md Step 8-9) lacks an explicit review step between implementation and release, causing AI to proceed directly from implementation to moving work items to done/ without user review.

---

## Bug Description

**What is happening (actual behavior)?**

Current CLAUDE.md workflow:
- **Step 8: Implement** - Write code, tests, documentation
- **Step 9: Complete & Release** - Move to done/, update versions, release

When AI completes Step 8 (implementation), it immediately proceeds to Step 9 (moving to done/ and releasing) without an explicit review checkpoint.

**Example from 2025-12-31 session (BUGFIX-001):**
1. AI implemented the fix (added work item numbering docs)
2. AI immediately attempted to move BUGFIX-001 from doing/ to done/
3. User correctly stopped AI and asked: "I want to review the work first before we move to done. Do we have a step for that in our workflow?"
4. Upon investigation: No explicit review step exists between Step 8 and Step 9

**What should happen (expected behavior)?**

After Step 8 (Implement) and before Step 9 (Complete & Release), there should be:

**Step 8.5: Review & Approval**
- AI presents completed work for user review
- AI summarizes what was changed/created
- User reviews the changes
- User approves or requests changes
- Only after approval does AI proceed to Step 9

**Impact:**

- **Medium severity:** Work is released without user review opportunity
- **Affects:** All work items using the AI Workflow Checkpoint Policy
- **Risk:** Changes the user didn't approve get released
- **Current mitigation:** Users can manually stop AI before release (as happened in BUGFIX-001 session)

---

## Reproduction Steps

**Environment:**
- Framework: Standard (v2.2.1)
- CLAUDE.md: AI Workflow Checkpoint Policy (9 Steps)
- Work item: Any (FEAT, BUGFIX, etc.)

**Steps to Reproduce:**

1. Start work on any work item (move from todo/ to doing/)
2. AI implements the changes (Step 8: Implement)
3. AI completes implementation and all tasks
4. **Observe:** AI immediately proceeds to move work item to done/
5. **Expected:** AI should pause and ask for review first

**Reproducibility:** Always (when AI follows the 9-step workflow)

**Evidence:**

From 2025-12-31 BUGFIX-001 session:
```
Claude: Perfect! BUGFIX-001 is complete. Now I should move it to done/ and update the status.
Claude: [Attempts to move file to done/]
User: I want to review the work first before we move to done. Do we have a step for that in our workflow?
```

---

## Root Cause Analysis

**File(s) Affected:**
- `CLAUDE.md` - AI Workflow Checkpoint Policy (Lines 189-223, Steps 8-9)

**Root Cause:**

The 9-step workflow has two checkpoints:
1. **Checkpoint 1 (Step 4):** User approval before moving from backlog to implementation
2. **Checkpoint 2:** Missing - Should be between Step 8 (Implement) and Step 9 (Release)

**Why was this missed?**

1. workflow-guide.md mentions "Self-review before committing" in Phase 4 (Code), but it's not explicit in CLAUDE.md
2. CLAUDE.md Step 9 says "Work is done and tested" but doesn't specify WHO verifies this
3. The workflow was designed with approval before starting work, but not before releasing work
4. Solo developer scenario assumed AI and user are aligned on completion criteria

**Related Context:**

workflow-guide.md Phase 4 includes:
```markdown
**Code Review:**
- Self-review before committing
- Peer review via Pull Request (teams)
- Address feedback promptly
- Check coding standards compliance
```

This guidance exists but isn't reflected in CLAUDE.md's 9-step workflow.

---

## Fix Design

**Approach:** Add explicit Step 8.5 (Review & Approval) to CLAUDE.md AI Workflow Checkpoint Policy

**Implementation:**

Update CLAUDE.md to change from:
```
8. Implement
9. Complete & Release
```

To:
```
8. Implement
8.5. Review & Approval ⚠️ CHECKPOINT
9. Complete & Release
```

**New Step 8.5: Review & Approval** ⚠️ CHECKPOINT

After completing implementation (Step 8), AI MUST present work for review:

**AI presents:**
- Summary of changes made
- Files created/modified with brief descriptions
- Testing results (if applicable)
- Any decisions made during implementation

**AI asks:** "The work is complete and ready for review. Would you like to review the changes before I move to done/ and proceed with release?"

**User options:**
- **Approve:** "Yes, looks good" → AI proceeds to Step 9
- **Request changes:** "Change X first" → AI makes changes, presents again
- **Review first:** "I want to review" → User reviews, then approves or requests changes

**Example interaction:**
```
Claude: I've completed BUGFIX-001. Here's a summary of the changes:

Changes Made:
1. Added comprehensive Work Item Numbering section to workflow-guide.md
   - Lines 358-437: Complete numbering guidance with examples
2. Updated CLAUDE.md AI Workflow Checkpoint Policy
   - Line 161: Added reference to workflow-guide.md numbering

Testing Results:
- ✅ FEAT numbering: Correctly finds 022 (next: 023)
- ✅ BUGFIX numbering: Correctly finds 001 (next: 002)
- ✅ Scans all 5 locations (backlog, todo, doing, done, releases/*/)

Files Modified:
1. thoughts/project/collaboration/workflow-guide.md (~80 lines added)
2. CLAUDE.md (1 line added)
3. thoughts/project/work/doing/BUGFIX-001-work-item-number-collision.md (test results added)

The work is complete and ready for review. Would you like to review the changes before I move to done/ and proceed with release?
```

**Files to Update:**

1. **CLAUDE.md** - Add Step 8.5 between Step 8 and Step 9:
   ```markdown
   **8. Implement**
      - Follow the plan
      - Write code, tests, documentation
      - Keep CHANGELOG notes in work item document

   **8.5. Review & Approval** ⚠️ CHECKPOINT
      - AI presents completed work for user review
      - Summarize changes made (files created/modified)
      - Present testing results
      - **ASK FOR EXPLICIT APPROVAL:** "The work is complete and ready for review. Would you like to review the changes before I move to done/ and proceed with release?"
      - User reviews and approves/requests changes
      - ❌ DON'T: Move to done/ without approval

   **9. Complete & Release** ⚠️ CRITICAL: Atomic Release Process
      - Work is done, tested, AND APPROVED
      - **STOP - Before committing:** Prepare version updates atomically
      ...
   ```

2. **workflow-guide.md** - Reinforce review step in Code phase (already mentions it, but could be clearer)

**Alternative Considered (Implicit Review):**

Make Step 9 start with: "Present work for review, get approval, then release"

**Decision:** Rejected - Less visible, easier to miss. Explicit Step 8.5 is clearer.

---

## Testing Strategy

### Test Cases

**TC1: AI Presents Work for Review**
- Complete implementation of a feature
- AI should summarize changes and ask for review
- Should NOT automatically move to done/

**TC2: User Approves**
- User says "looks good" or "approved"
- AI proceeds to Step 9 (move to done/, release)

**TC3: User Requests Changes**
- User says "change X first"
- AI makes changes
- AI presents updated work for review again

**TC4: User Wants to Review First**
- User says "I want to review"
- AI waits for user to complete review
- After review, user approves or requests changes

### Validation

- [ ] AI stops after Step 8 and presents work
- [ ] AI asks explicit approval question
- [ ] AI waits for user response
- [ ] AI only proceeds to Step 9 after approval
- [ ] Documented in CLAUDE.md
- [ ] Next 5 work items follow new review process

---

## Prevention Strategy

**How to prevent similar issues:**

1. **Review all "Steps" in CLAUDE.md for missing checkpoints**
   - Are there other places where user approval is assumed but not explicit?

2. **Consistency check:** workflow-guide.md vs CLAUDE.md
   - Ensure both documents agree on critical steps
   - workflow-guide.md has detailed guidance, CLAUDE.md should reference it

3. **Testing the 9-step workflow end-to-end**
   - Walk through with actual work items
   - Document where user approval is needed
   - Make all checkpoints explicit

**Future consideration:**
- Create a "checkpoint audit" as part of documentation review process
- Ensure all points where AI must wait for user input are marked with ⚠️ CHECKPOINT

---

## Success Criteria

- [ ] Step 8.5 added to CLAUDE.md AI Workflow Checkpoint Policy
- [ ] AI presents work for review after implementation
- [ ] AI asks explicit approval question
- [ ] AI waits for approval before moving to done/
- [ ] Documented clearly with examples
- [ ] No work items released without review in next 10 releases

---

## Notes

**Discovery:**

This bug was discovered during BUGFIX-001 work when user correctly stopped AI before release and asked: "Do we have a step for that in our workflow?"

Investigation revealed:
- workflow-guide.md mentions "Self-review before committing" but it's not in CLAUDE.md
- CLAUDE.md has approval checkpoint BEFORE work (Step 4) but not AFTER work (missing Step 8.5)
- This is a gap in the dogfooding process - we caught it by using the framework

**Good catch by user!** This demonstrates the value of the review step we're adding.

---

## CHANGELOG Notes

**Fixed:**
- Added explicit Review & Approval checkpoint (Step 8.5) to AI Workflow Checkpoint Policy
- AI now presents completed work for user review before moving to done/
- Prevents premature release of work without user approval

**Changed:**
- Updated CLAUDE.md with Step 8.5 between Implement and Complete & Release
- Step 9 now requires work to be "done, tested, AND APPROVED"

---

## Related

- BUGFIX-001: Work item numbering collision (session where this bug was discovered)
- ADR-001: AI Workflow Checkpoint Policy (the policy being fixed)
- workflow-guide.md Phase 4 (Code) - Already mentions review, but not in CLAUDE.md

---

## Changelog

- 2025-12-31: Bug discovered during BUGFIX-001 review, backlog item created

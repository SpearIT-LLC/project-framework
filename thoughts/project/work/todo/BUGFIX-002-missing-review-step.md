# Bug Fix: Missing Review Step in AI Workflow Checkpoint Policy

**ID:** BUGFIX-002
**Type:** Bugfix
**Version Impact:** PATCH (backward-compatible documentation fix)
**Target Version:** v2.3.0
**Status:** Todo
**Severity:** Medium
**Priority:** P2
**Version Found:** v2.2.1
**Version Fixed:** N/A
**Created:** 2025-12-31
**Fixed:** N/A
**Developer:** Claude & User

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

## Design Discussion: Review Folder vs AI Prompts

**Question:** Should we add a physical `work/review/` folder to the kanban workflow, or rely on AI prompts to trigger review?

### Option A: Add work/review/ Folder (Physical State)

**Workflow becomes:**
```
backlog/ → todo/ → doing/ → review/ → done/ → releases/
```

**How it works:**
- After implementing (Step 8), AI moves work item from `doing/` to `review/`
- Item sits in `review/` folder awaiting user approval
- User reviews the work item document and/or code changes
- User manually moves from `review/` to `done/` when approved
- OR user moves back to `doing/` if changes needed

**Pros:**
- ✅ **Physical visibility:** Clear which items are awaiting review
- ✅ **WIP limit separation:** Review items don't count against doing/ WIP limit
- ✅ **Team workflows:** Multiple reviewers can see review queue
- ✅ **Audit trail:** Can see how long items spent in review
- ✅ **Standard pattern:** Matches common kanban boards (To Do, In Progress, Review, Done)

**Cons:**
- ❌ **Folder complexity:** Adds another folder to structure
- ❌ **Manual file movement:** User must move files (or AI does after approval)
- ❌ **Solo developer overhead:** May be overkill for 1-person teams
- ❌ **Documentation updates:** Need to update all workflow docs with new folder

### Option B: AI Prompts Only (Virtual State)

**Workflow stays:**
```
backlog/ → todo/ → doing/ → done/ → releases/
```

**How it works:**
- After implementing (Step 8), AI stays in Step 8.5 (virtual review state)
- Item remains in `doing/` folder
- AI presents work for review via prompt
- User reviews and responds in conversation
- AI only moves from `doing/` to `done/` after approval

**Pros:**
- ✅ **Simpler structure:** No new folder needed
- ✅ **Conversational:** Review happens in natural AI-human dialogue
- ✅ **Solo-friendly:** Works well for single developer workflows
- ✅ **Less overhead:** No extra file movements
- ✅ **Backward compatible:** Doesn't break existing folder structure

**Cons:**
- ❌ **No physical visibility:** Can't see "items in review" by looking at folders
- ❌ **Session-dependent:** Review state only exists during AI conversation
- ❌ **Team workflows:** Harder for multiple reviewers to coordinate
- ❌ **WIP limits:** Review items still count against doing/ limit

### Option C: Hybrid (Folder + Status Flag)

**Workflow:**
```
backlog/ → todo/ → doing/ → done/ → releases/
```

**How it works:**
- After implementing, AI updates work item status to "Review" but keeps in `doing/`
- AI presents work for review via prompt
- User can see items in review by checking status field
- After approval, AI changes status to "Done" and moves to `done/`

**Pros:**
- ✅ **Queryable:** Can grep for status:"Review" in doing/
- ✅ **No new folder:** Keeps structure simple
- ✅ **Visible in document:** Opening work item shows it's in review
- ✅ **Best of both:** Physical location + status tracking

**Cons:**
- ❌ **Less visible:** Must open files or grep to see review status
- ❌ **WIP limits:** Still counts against doing/ limit

---

### Recommendation & Discussion Points

**For discussion:**

1. **Team size consideration:**
   - Solo developer: Option B (AI prompts) might be sufficient
   - Small team (2-5): Option A (review/ folder) provides better visibility
   - Larger team: Option A definitely needed

2. **WIP limit philosophy:**
   - Should "items in review" count against doing/ WIP limit?
   - Or should review be a separate stage with its own limit?

3. **Framework levels:**
   - Minimal/Light: Probably don't need review/ folder
   - Standard: Could benefit from it
   - Full/Enterprise: Likely needs it for team coordination

4. **Current project (Standard framework, solo developer):**
   - Currently using Option B (AI prompts) and it worked
   - But discovered the gap because prompt wasn't explicit enough
   - Would Option A (review/ folder) have prevented the issue?

**Proposed Decision for BUGFIX-002:**

Start with **Option B (AI Prompts)** because:
- This project is solo developer using Standard framework
- Simpler to implement (just update CLAUDE.md)
- Can always add review/ folder later if needed (non-breaking change)
- Fixes the immediate issue (missing review checkpoint)

**Future consideration (separate work item):**
- Create FEAT-XXX: Add optional review/ folder for team workflows
- Document when to use review/ vs staying in doing/
- Update WIP limit guidance for review stage

**Question for user:**
Do you prefer Option A (review/ folder), Option B (AI prompts), or Option C (hybrid)? Or should we start with B and revisit later?

---

### Updated Recommendation: Framework-Level Decision

**Better approach:** Tie the review mechanism to team size/framework level:

**Solo Developer (this project):**
- Use **Option B (AI prompts)** - Simpler, conversational
- No review/ folder needed
- AI presents work via Step 8.5 checkpoint

**Team Workflows (2+ developers):**
- Use **Option A (review/ folder)** - Better visibility and coordination
- Physical folder makes review queue visible to all team members
- Clear separation of "in development" vs "awaiting review"

**Implementation Strategy:**

1. **BUGFIX-002 (Immediate fix):**
   - Add Step 8.5 (Review & Approval) to CLAUDE.md with AI prompts
   - Works for solo developer workflows
   - Document this as the Standard framework approach for solo developers

2. **FEAT-XXX (Future enhancement):**
   - Add optional work/review/ folder for team workflows
   - Document when to add review/ folder (team size >= 2)
   - Update workflow-guide.md with both approaches
   - Add .limit file to review/ if using folder

**Documentation Updates:**

In workflow-guide.md, add guidance:
```markdown
### Review Stage (Team Workflows)

**When to use review/ folder:**
- Team size: 2+ developers
- Multiple reviewers needed
- Physical visibility required for coordination

**How it works:**
- After implementation, move from doing/ to review/
- Reviewer(s) examine work item and code changes
- Approved: Move to done/
- Changes needed: Move back to doing/

**Solo developers:** Skip review/ folder, use AI Step 8.5 checkpoint instead.
```

**Decision deferred:** We'll implement Option B now, document Option A for teams, let users choose based on their needs.

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

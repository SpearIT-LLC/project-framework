# Bug Fix: Missing Pre-Implementation Review Checkpoint

**ID:** BUGFIX-005
**Type:** Bugfix
**Version Impact:** PATCH (backward-compatible documentation fix)
**Target Version:** v2.2.4
**Status:** Done
**Severity:** Medium
**Priority:** P2
**Version Found:** v2.2.3
**Version Fixed:** v2.2.4
**Created:** 2026-01-01
**Fixed:** 2026-01-01
**Developer:** Claude & User

---

## Summary

The AI Workflow Checkpoint Policy lacks an explicit review checkpoint between moving a work item to doing/ and starting implementation, causing AI to begin implementation without refreshing context, reviewing strategy, or addressing open questions that may be documented in the work item.

---

## Bug Description

**What is happening (actual behavior)?**

Current CLAUDE.md workflow after BUGFIX-002 fix:
- **Step 7: Move Through Workflow** - Move from todo/ → doing/, update status
- **Step 8: Implement** - Follow the plan, write code
- **Step 8.5: Review & Approval** - Present completed work for review (AFTER implementation)

When AI moves a work item from todo/ to doing/, it immediately proceeds to Step 8 (implementation) without:
1. Re-reading and reviewing the complete work item document
2. Identifying open questions or design decisions that need user input
3. Refreshing understanding of the strategy/approach
4. Confirming the implementation plan is still valid

**Example from 2026-01-01 session (BUGFIX-002):**
1. User asked to work on BUGFIX-002
2. AI moved it from todo/ to doing/
3. AI started implementing Step 8.5 (Review & Approval checkpoint)
4. **AI did NOT notice:** BUGFIX-002 contains a large "Design Discussion" section (lines 213-385) with three different implementation options (Option A: review/ folder, Option B: AI prompts, Option C: Hybrid)
5. **AI did NOT ask:** "Which option do you want me to implement?"
6. User correctly stopped AI and asked: "What is our policy when working an item just moved todo? Do we have a review step to refresh ourselves on the strategy before actual implementation?"
7. Upon investigation: No explicit pre-implementation review step exists between Step 7 and Step 8

**What should happen (expected behavior)?**

After Step 7 (Move to doing/) and before Step 8 (Implement), there should be:

**Step 7.5: Pre-Implementation Review** ⚠️ CHECKPOINT
- AI reads the complete work item document thoroughly
- AI identifies and presents:
  - Design decisions documented but not yet decided
  - Open questions that need answers
  - Alternative approaches discussed
  - Any "TBD", "TODO", "Question:", or "Decision needed:" sections
- AI summarizes the implementation approach
- AI presents any open items to user
- **ASK FOR CONFIRMATION:** "Before I begin implementation, I've reviewed [work item]. The approach is [summary]. I notice these open questions: [list]. My recommendation is [recommendation]. Do you agree with this approach, or would you like to discuss alternatives?"
- User confirms approach or provides additional guidance
- AI updates work item with final decisions
- Only then proceed to Step 8 (Implement)

**Impact:**

- **Medium severity:** AI may implement the wrong approach if open questions aren't addressed
- **Affects:** All work items using the AI Workflow Checkpoint Policy, especially those with:
  - Design discussions
  - Multiple implementation options
  - Complex features with many decisions
- **Risk:** Wasted implementation effort if AI chooses wrong approach or misses critical context
- **Current mitigation:** User can manually stop AI and ask clarifying questions (as happened in BUGFIX-002 session)

---

## Reproduction Steps

**Environment:**
- Framework: Standard (v2.3.0 with BUGFIX-002 fix applied)
- CLAUDE.md: AI Workflow Checkpoint Policy (10 Steps with Step 8.5)
- Work item: Any with open questions or design discussions

**Steps to Reproduce:**

1. Create a work item with design discussion or open questions
2. Place in todo/ folder
3. Ask AI to work on the item
5. AI moves item from todo/ → doing/ (Step 7)
6. **Observe:** AI immediately proceeds to Step 8 (Implement)
7. **Expected:** AI should pause, review work item, identify open questions, ask for confirmation

**Reproducibility:** Always (when work item has unresolved design decisions)

**Evidence:**

From 2026-01-01 BUGFIX-002 session:
```
User: "Happy New Year Claude. Let's work on bugfix0002."
Claude: [Moves BUGFIX-002 to doing/]
Claude: [Starts updating CLAUDE.md with Step 8.5]
User: "What is our policy when working an item just moved todo? Do we have a review step to refresh ourselves on the strategy before actual implementation? What about open questions that need to be addressed before implementation?"
Claude: "Excellent observation! You've identified a gap in our workflow."
```

The AI did not notice or address the "Design Discussion" section (213-385 lines) with three implementation options before starting work.

---

## Root Cause Analysis

**File(s) Affected:**
- `CLAUDE.md` - AI Workflow Checkpoint Policy (Steps 7-8)

**Root Cause:**

The 10-step workflow (after BUGFIX-002) has two checkpoints:
1. **Checkpoint 1 (Step 4):** User approval before moving from backlog to implementation
2. **Checkpoint 2 (Step 8.5):** User review/approval after implementation completion
3. **Checkpoint 3:** Missing - Should be between Step 7 (Move to doing/) and Step 8 (Implement)

**Why was this missed?**

1. Step 7 says "Move through workflow" but doesn't include "Review work item"
2. Step 8 says "Follow the plan" but doesn't specify reviewing/confirming the plan first
3. workflow-guide.md mentions "Review work item documents before starting work" but it's not explicit in CLAUDE.md as a checkpoint
4. Assumption that work items moved to doing/ are "ready to implement" without review
5. No process for identifying open questions or unresolved design decisions

**Related Context:**

workflow-guide.md Collaboration Practices includes:
```markdown
- Review work item documents before starting work
```

This guidance exists but isn't reflected as an explicit checkpoint in CLAUDE.md's workflow.

**Why is this different from Step 4 (approval before backlog → implementation)?**

Step 4 happens when:
- Work item is first created in backlog
- User reviews the proposal
- User approves moving forward

Step 7.5 would happen when:
- Work item already approved and in todo/
- About to start actual implementation
- Need to refresh context and confirm approach
- User may have new guidance or changed priorities

---

## Fix Design

**Approach:** Add explicit Step 7.5 (Pre-Implementation Review) to CLAUDE.md AI Workflow Checkpoint Policy

**Implementation:**

Update CLAUDE.md to change from:
```
7. Move Through Workflow
8. Implement
8.5. Review & Approval
9. Complete & Release
```

To:
```
7. Move Through Workflow
7.5. Pre-Implementation Review ⚠️ CHECKPOINT
8. Implement
8.5. Post-Implementation Review & Approval ⚠️ CHECKPOINT
9. Complete & Release
```

**New Step 7.5: Pre-Implementation Review** ⚠️ CHECKPOINT

After moving work item to doing/ (Step 7), AI MUST review before implementing:

**AI performs:**
1. Read the complete work item document thoroughly
2. Scan for open items:
   - Search for "TODO", "TBD", "Question:", "Decision needed:", "Option A/B/C"
   - Look for "Design Discussion", "Alternatives Considered" sections
   - Check for unresolved comments or notes
3. Review the implementation approach/strategy
4. Identify files that will be affected

**AI presents:**
- Summary of the work item and approach
- Open questions or decisions needed (if any)
- Files that will be created/modified
- Recommendation for addressing open items

**AI asks:** "Before I begin implementation, I've reviewed [WORK-ITEM-ID]. Here's what I understand:

**Approach:** [Brief summary of implementation strategy]

**Files to modify:** [List of files]

**Open questions:** [List any unresolved items, or state "None identified"]

[If open questions exist:]
My recommendation: [Proposed answers/approach]

Do you agree with this approach, or would you like to provide additional guidance before I start?"

**User options:**
- **Confirm:** "Yes, proceed" → AI proceeds to Step 8
- **Provide guidance:** "Actually, use approach X instead" → AI updates work item, confirms, proceeds to Step 8
- **Discuss:** "Let's talk about the approach" → AI discusses, reaches agreement, updates work item, proceeds to Step 8
- **Defer:** "Not ready yet" → AI keeps in doing/ but doesn't implement (or moves back to todo/)

**Example interaction:**
```
User: "Let's work on BUGFIX-002"

Claude: [Moves BUGFIX-002 from todo/ to doing/, updates status]

Claude: "Before I begin implementation, I've reviewed BUGFIX-002. Here's what I understand:

**Approach:** Add Step 8.5 (Review & Approval) checkpoint to AI Workflow Checkpoint Policy in CLAUDE.md

**Files to modify:**
- CLAUDE.md (add Step 8.5 between Step 8 and Step 9)
- BUGFIX-002-missing-review-step.md (document implementation)

**Open questions:**
I notice a Design Discussion section (lines 213-385) with three implementation options:
- Option A: Add physical review/ folder to kanban workflow
- Option B: AI prompts only (recommended for solo developers)
- Option C: Hybrid (status flag + prompts)

The work item recommends Option B for this project (solo developer, simpler approach).

My recommendation: Proceed with Option B (AI prompts only) as documented in the work item, which adds Step 8.5 as an AI prompt-based checkpoint without adding a review/ folder.

Do you agree with this approach, or would you like to discuss the alternatives?"

User: "Yes, proceed with Option B"

Claude: "Great! Proceeding with Step 8 (Implementation)..."
```

**Files to Update:**

1. **CLAUDE.md** - Add Step 7.5 between Step 7 and Step 8:
   ```markdown
   **7. Move Through Workflow**
      - Move file: `planning/backlog/` → `work/todo/`
      - Update status in document to "Todo"
      - Move file: `work/todo/` → `work/doing/`
      - Update status in document to "Doing"

   **7.5. Pre-Implementation Review** ⚠️ CHECKPOINT
      - AI reads the complete work item document thoroughly
      - AI scans for open questions, design decisions, alternatives
      - AI summarizes the implementation approach
      - AI presents open items and recommendations to user
      - **ASK FOR CONFIRMATION:** "Before I begin implementation, I've reviewed [WORK-ITEM-ID]. The approach is [summary]. [Open questions if any]. Do you agree with this approach?"
      - User confirms or provides additional guidance
      - AI updates work item with final decisions
      - ❌ DON'T: Start implementing without reviewing the work item and confirming approach

   **8. Implement**
      - Follow the plan (as confirmed in Step 7.5)
      - Write code, tests, documentation
      - Keep CHANGELOG notes in work item document
   ```

2. **CLAUDE.md** - Update workflow summary:
   - Change "10 Steps" to "11 Steps"

3. **CLAUDE.md** - Update "What NOT to Do":
   - Add: "❌ Start implementing without reviewing work item and confirming approach"

4. **workflow-guide.md** - Clarify pre-implementation review:
   - Make "Review work item documents before starting work" more explicit
   - Reference CLAUDE.md Step 7.5

---

## Alternative Fixes Considered

**Option 1: Implicit review (no checkpoint)**
- Just say "review the work item" in Step 8 without a checkpoint
- Pros: Simpler, no new step number
- Cons: Easy to miss, not explicit, no user confirmation
- Decision: Rejected - Same problem as BUGFIX-002 (implicit isn't enough)

**Option 2: Merge into Step 7**
- Make Step 7 include both "move file" and "review work item"
- Pros: Keeps step count at 10
- Cons: Step 7 becomes overloaded, checkpoint less visible
- Decision: Rejected - Checkpoints should be explicit and visible

**Option 3: Merge into Step 8**
- Make Step 8 start with "Review work item, then implement"
- Pros: Keeps step count at 10
- Cons: No user checkpoint, AI might still skip review
- Decision: Rejected - Need explicit user confirmation for complex work items

**Option 4: Only for items with "Design Discussion" sections**
- Add checkpoint only when AI detects design discussions
- Pros: Lighter weight for simple items
- Cons: Complex logic, might miss items that need review, inconsistent
- Decision: Rejected - Better to always review, even briefly

**Decision: Add explicit Step 7.5 checkpoint** - Consistent with pattern established by BUGFIX-002 (Step 8.5). Makes review mandatory and visible.

---

## Testing Strategy

### Test Cases

**TC1: Work item with design discussion**
- Work item has "Design Discussion" or "Alternatives" section
- AI should identify open questions and ask for decision
- Should NOT start implementing without user confirmation

**TC2: Work item with TODO/TBD items**
- Work item contains "TODO:", "TBD:", "Decision needed:" markers
- AI should identify these and ask for user input
- Should update work item with decisions before implementing

**TC3: Simple work item, no open questions**
- Work item is straightforward with clear approach
- AI should still review and present summary
- User can quickly confirm and proceed
- Review should be brief but present

**TC4: User provides new guidance during review**
- AI presents approach from work item
- User says "Actually, let's do X instead"
- AI should update work item with new approach
- AI should confirm updated approach before implementing

### Validation

- [ ] AI stops after Step 7 and reviews work item
- [ ] AI identifies open questions/design decisions
- [ ] AI asks for confirmation before implementing
- [ ] AI presents clear summary of approach
- [ ] AI only proceeds to Step 8 after user confirmation
- [ ] Documented in CLAUDE.md with ⚠️ CHECKPOINT marker
- [ ] Next 5 work items follow new review process

---

## Related Issues

**Complements:**
- BUGFIX-002: Missing post-implementation review (Step 8.5) - Fixed in v2.3.0

**Together, BUGFIX-002 and BUGFIX-005 provide:**
- Step 7.5: Review BEFORE implementation (confirm approach)
- Step 8.5: Review AFTER implementation (approve changes)

**Pattern:**
Both bugs discovered through dogfooding - using the framework revealed gaps in the workflow.

**Relationship to ADR-001:**
ADR-001 (AI Workflow Checkpoint Policy) established the checkpoint pattern. These bugs extend it with missing checkpoints.

---

## Prevention Strategy

**How can we prevent similar missing checkpoints?**

1. **Checkpoint audit of the workflow:**
   - Walk through all 10+ steps
   - Identify points where AI makes decisions without user input
   - Add checkpoints where user approval/confirmation is needed

2. **Pattern recognition:**
   - Whenever AI "moves to next phase" without user interaction → potential missing checkpoint
   - Format: Step N → [CHECKPOINT] → Step N+1

3. **Testing the workflow end-to-end:**
   - Use actual work items with various complexities
   - Note where AI makes assumptions
   - Add checkpoints where assumptions should be confirmed

4. **Future consideration:**
   - Create FEAT-XXX: "Workflow Checkpoint Audit" to systematically review all steps
   - Ensure all decision points have explicit user input

---

## Success Criteria

- [ ] Step 7.5 added to CLAUDE.md AI Workflow Checkpoint Policy
- [ ] AI reviews work item before implementation
- [ ] AI identifies open questions and design decisions
- [ ] AI asks for confirmation before implementing
- [ ] AI updates work item with final decisions
- [ ] No work items implemented without pre-implementation review in next 10 releases
- [ ] User reports increased confidence that AI understands the plan before implementing

---

## Notes

**Discovery:**

This bug was discovered during BUGFIX-002 implementation when user asked: "What is our policy when working an item just moved todo? Do we have a review step to refresh ourselves on the strategy before actual implementation?"

Investigation revealed:
- workflow-guide.md mentions "Review work item documents before starting work" but it's not a checkpoint in CLAUDE.md
- BUGFIX-002 work item had 172 lines of design discussion (lines 213-385) with three implementation options
- AI moved to doing/ and started implementing without asking which option to use
- This is the same pattern as BUGFIX-002: implicit guidance isn't enough, need explicit checkpoint

**Good catch by user!** This demonstrates the value of:
1. Dogfooding the framework (using it reveals gaps)
2. User questioning AI behavior (uncovered missing checkpoint)
3. The review checkpoints we're adding (would have caught this)

**Irony:** While implementing a bug about missing review checkpoints, we discovered another missing review checkpoint!

---

## CHANGELOG Notes

**Fixed:**
- Added Pre-Implementation Review checkpoint (Step 7.5) to AI Workflow Checkpoint Policy
- AI now reviews work item, identifies open questions, and confirms approach before implementing
- Prevents starting implementation with outdated context or unresolved design decisions

**Changed:**
- Updated CLAUDE.md with Step 7.5 between Move Through Workflow and Implement
- Updated workflow from 10 steps to 11 steps
- Step 8 now requires work item to be reviewed and approach confirmed

---

## Related

- BUGFIX-002: Missing post-implementation review checkpoint (Step 8.5) - Fixed in v2.3.0
- ADR-001: AI Workflow Checkpoint Policy (the policy being extended)
- workflow-guide.md Collaboration Practices - Already mentions review, but not as explicit checkpoint

---

## Changelog

- 2026-01-01: Bug discovered during BUGFIX-002 implementation, backlog item created
- 2026-01-01: Moved backlog → todo → doing
- 2026-01-01: Implementation started

---

## Implementation Notes

**Changes Made:**

1. **CLAUDE.md - AI Workflow Checkpoint Policy:**
   - Line 148: Changed "The 10 Steps" to "The 11 Steps"
   - Lines 190-196: Added Step 7.5 (Pre-Implementation Review) checkpoint between Step 7 and Step 8
   - Line 199: Updated Step 8 to reference "(as confirmed in Step 7.5)"
   - Line 273: Updated "What NOT to Do" to include Step 7.5 in checkpoint list
   - Line 274: Added "Start implementing without reviewing work item and confirming approach"
   - Lines 281, 287: Updated "Rationale" section with Step 7.5 benefits

2. **workflow-guide.md - Collaboration Practices:**
   - Lines 993-1069: Added comprehensive "Pre-Implementation Review (Step 7.5)" section
   - Includes: When, Purpose, What AI Should Do (5 steps), Example Patterns, What to Present, Benefits
   - Provides detailed guidance on identifying open questions and design decisions

3. **BUGFIX-005 work item:**
   - Updated with implementation notes (this section)

**Files Modified:**
- [CLAUDE.md](../../../CLAUDE.md) - Lines 148, 190-196, 199, 273-274, 281, 287
- [workflow-guide.md](../../collaboration/workflow-guide.md) - Lines 993-1069 (77 lines added)
- [BUGFIX-005-missing-pre-implementation-review.md](BUGFIX-005-missing-pre-implementation-review.md) - This file

**Testing Status:**
- ✅ Step 7.5 is clearly visible in CLAUDE.md
- ✅ Checkpoint warning (⚠️ CHECKPOINT) is present
- ✅ Explicit confirmation question is documented
- ✅ "DON'T start implementing without review" is clearly stated
- ✅ Rationale section updated with Step 7.5 benefits
- ✅ Detailed guidance added to workflow-guide.md
- ✅ "What NOT to Do" section includes Step 7.5

**Validation:**
This implementation was validated by following Step 7.5 itself:
1. AI performed pre-implementation review of BUGFIX-005
2. AI identified no open questions (approach was clear)
3. AI presented summary and confirmed approach with user
4. User approved: "yes"
5. AI proceeded with implementation

**Post-Implementation Addition (Step 8.5 feedback):**

During Step 8.5 review, user identified that the implementation sequence was suboptimal:
- Original sequence: Updated CLAUDE.md first, then workflow-guide.md
- Better sequence: Update workflow-guide.md (master) first, then CLAUDE.md (summary)

User requested making this a universal principle, not just for workflow-guide.md.

**Additional change made:**
- Lines 1071-1127: Added "Documentation Update Order (Universal Principle)" section to workflow-guide.md
- Establishes universal rule: Always update master documentation BEFORE derived summaries
- Documents 4 common hierarchies: collaboration/* → CLAUDE.md, PROJECT-STATUS.md → README.md, ADRs → implementation docs, Templates → instances
- Provides examples and rationale
- Information flow principle: detailed → summary (not summary → detailed)

This demonstrates Step 8.5 working correctly:
1. User reviewed work
2. User requested improvement
3. AI made change
4. AI presents updated work for approval

**Next Steps:**
- Present updated work for user review (Step 8.5, round 2)
- After approval, move to done/ and prepare release

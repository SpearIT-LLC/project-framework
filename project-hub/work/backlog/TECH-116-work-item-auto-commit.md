# Tech: Work Item Lifecycle Auto-Commit

**ID:** TECH-116
**Type:** Tech Debt
**Priority:** Medium
**Version Impact:** PATCH
**Created:** 2026-02-06
**Theme:** Workflow
**Planning Period:** Sprint WF 2

---

## Summary

Ensure work items are committed to git at key lifecycle points (creation, completion), addressing the gap between framework workflow expectations and Claude Code's cautious commit policy.

---

## Problem Statement

**What problem does this solve?**

Work items are not automatically committed to git at key lifecycle points (creation, completion), creating risk of lost work and manual burden on users.

**Discovered in:** FEAT-011 validation (hello-father project)

**Issue #1: Creation**
- User feedback: "The initial work item was not committed at creation time"
- Current behavior: Work item created but sits as unstaged change
- Framework expectation: Work items should be committed when added to backlog
- Impact: Risk of losing work, manual burden

**Issue #2: Completion (move to done/)**
- User feedback: "/fw-move to done/ didn't commit or generate session history"
- Current behavior: Move completes but no auto-commit or session history generation
- Framework expectation (per checklist): Auto-update session history and commit
- Impact: User must manually run /fw-session-history and commit

**Root cause:** Claude Code system prompt says "NEVER commit changes unless the user explicitly asks"

This is a sensible safety policy for general code editing, but conflicts with framework's workflow expectations where work items should be tracked in git at key lifecycle transitions.

**Who is affected?**
- All users creating work items
- All users completing work items (moving to done/)
- Especially impacts batch operations (multiple items uncommitted)

---

## Requirements

### Functional Requirements

**Scenario 1: Work Item Creation**
- [ ] Work items committed when added to backlog (or appropriate folder)
- [ ] Clear, descriptive commit messages
- [ ] Works with both manual and skill-based work item creation

**Scenario 2: Move to done/**
- [ ] Session history auto-generated when moving to done/
- [ ] Changes (work item + session history) committed together
- [ ] Clear, descriptive commit message

**General:**
- [ ] Respects Claude Code's git safety policies (no force commits, etc.)
- [ ] User approval required (prompts with default yes)
- [ ] Batch operations handled appropriately

### Non-Functional Requirements

- [ ] Transparent: User knows what's happening
- [ ] Safe: Follows git best practices
- [ ] Consistent: Same pattern across all lifecycle transitions
- [ ] Low friction: Easy to accept (default yes, one keystroke)

---

## Design

### Options Evaluated

**Option A: Explicit Checklist Instruction**
- Update framework checklists to explicitly say "commit this work item now"
- AI asks user permission before committing
- Pros: Respects Claude Code policy, transparent, user control
- Cons: Still manual user approval needed, extra step

**Option B: Git Hook (post-creation)**
- Add git hook that auto-commits work items when added to backlog/
- Hook runs after file creation
- Pros: Automatic, no user intervention, consistent
- Cons: Requires hook setup, may conflict with other workflows

**Option C: Hybrid (Checklist + Prompt)**
- Checklist says: "Commit work item (recommended)"
- AI prompts: "Commit FEAT-XXX now? (Y/n)"
- Defaults to yes, user can decline
- Pros: Balances automation with control, clear intent
- Cons: Still requires user interaction (but easy)

### Recommendation: Option C (Hybrid)

**Rationale:**
- Respects Claude Code's "ask before committing" policy
- Makes committing easy (default yes, one keystroke)
- Transparent (user sees what's happening)
- Can be enhanced with hooks later if desired

### Implementation

**Scenario 1: Work Item Creation Checklist**

```markdown
## After Creating Work Item

1. ✅ Verify work item is well-formed
2. ✅ File is in correct location (backlog/, todo/, etc.)
3. ✅ **Commit work item to git** (recommended)
   - Prompt: "Commit [ITEM-ID] to git? (Y/n)"
   - Default commit message: "feat: Add [ITEM-ID] - [title]"
   - User can decline if batching multiple items
```

**Example interaction:**
```
AI: Created FEAT-042-new-feature.md in backlog/
    Commit to git? (Y/n): _
User: [Enter] or "y"
AI: Committed with message: "feat: Add FEAT-042 - New feature description"
```

---

**Scenario 2: Move to done/ Checklist**

```markdown
## After Moving to done/

1. ✅ Work item moved successfully
2. ✅ All acceptance criteria validated
3. ✅ **Generate session history and commit** (recommended)
   - Prompt: "Generate session history and commit? (Y/n)"
   - If yes:
     a. Run /fw-session-history (updates or creates session history file)
     b. Stage changes: work item in done/ + session history file
     c. Commit with message: "feat: Complete [ITEM-ID] - [title]"
   - User can decline if they want to batch multiple completions
```

**Example interaction:**
```
AI: ✅ FEAT-042 moved to done/
    Generate session history and commit? (Y/n): _
User: [Enter] or "y"
AI: Generating session history...
    Updated: project-hub/history/sessions/2026-02-06-SESSION-HISTORY.md
    Committed with message: "feat: Complete FEAT-042 - New feature description"
```

**Alternative wording (clearer):**
```
AI: ✅ FEAT-042 moved to done/

    Next steps:
    1. Update session history (/fw-session-history)
    2. Commit changes

    Do this now? (Y/n): _
```

---

## Acceptance Criteria

**Scenario 1: Work Item Creation**
- [ ] Work item creation process includes commit prompt
- [ ] Commit prompt defaults to "yes" (easy to accept)
- [ ] Clear commit message auto-generated (e.g., "feat: Add FEAT-042 - Title")
- [ ] User can decline if batching multiple items
- [ ] Skills that create work items follow this pattern

**Scenario 2: Move to done/**
- [ ] /fw-move to done/ includes post-completion prompt
- [ ] Prompt offers to generate session history + commit
- [ ] If accepted:
  - [ ] /fw-session-history runs successfully
  - [ ] Changes staged (work item + session history)
  - [ ] Clear commit message (e.g., "feat: Complete FEAT-042 - Title")
- [ ] User can decline if batching multiple completions
- [ ] /fw-move skill updated with this behavior

**General:**
- [ ] Framework checklists updated in CLAUDE.md
- [ ] /fw-move skill prompt updated
- [ ] Documented in workflow guide
- [ ] Tested with both individual and batch operations

---

## Dependencies

**Requires:**
- None (can implement immediately)

**Related:**
- FEAT-011: Discovered both issues (#2 and #4) during validation
- TECH-117: Performance investigation for /fw-move (different concern)
- Framework checklists in CLAUDE.md
- /fw-move skill prompt
- /fw-session-history skill

---

## Open Questions

### 1. Should batch operations handle commits differently?

**Context:** If user creates/completes 5 work items at once, should we:
- A: Commit after each item (5 commits)
- B: Commit all at end (1 commit)
- C: Ask user preference

**Recommendation:** Ask user: "Commit individually or batch?"

### 2. What about work items created outside skills?

**Context:** User manually creates markdown file
**Options:**
- A: Git hook auto-commits (requires hook setup)
- B: User must commit manually (current state)
- C: Document that manual creation requires manual commit

**Recommendation:** Option C for now, consider hook in future

### 3. Should session history generation be separate from commit?

**Context:** When moving to done/, should we:
- A: Always generate session history + commit together (simpler)
- B: Prompt separately: "Generate session history?" then "Commit?" (more control)
- C: Make session history optional, commit required (hybrid)

**Recommendation:** Option A (together) - they're conceptually linked
- Session history documents what was done
- Commit captures the completion milestone
- Doing them together is clearer and less friction

---

## CHANGELOG Notes

```markdown
### Fixed
- Work item lifecycle transitions now prompt for commit
  - Creation: Prompt to commit new work items (default yes)
  - Completion: Prompt to generate session history + commit when moving to done/ (default yes)
  - Clear auto-generated commit messages
  - Reduces risk of lost work
  - Respects Claude Code git safety policy while minimizing friction
```

---

## Notes

**Root Cause Analysis:**

Claude Code system prompt includes:
```
NEVER commit changes unless the user explicitly asks you to.
```

This is a sensible safety policy for general code editing, but conflicts with framework's workflow expectations where work items should be tracked in git at key lifecycle points.

**Solution Philosophy:**
- Don't bypass Claude Code's safety policy
- Make "asking" very easy (default yes prompt, one keystroke)
- User retains control but friction is minimized
- Apply same pattern to both creation and completion

**Two Scenarios Addressed:**

1. **Work Item Creation** (Issue #2 from FEAT-011)
   - Problem: Work items created but not committed
   - Solution: Prompt "Commit now? (Y/n)" after creation
   - Benefit: Reduces risk of lost work

2. **Move to done/** (Issue #4 from FEAT-011)
   - Problem: /fw-move to done/ doesn't auto-commit or generate session history
   - Solution: Prompt "Generate session history and commit? (Y/n)" after move
   - Benefit: Captures completion milestone properly

**Consistency Across Lifecycle:**
By using the same prompting pattern for both scenarios, we create a predictable user experience while respecting Claude Code's safety policies.

---

**Last Updated:** 2026-02-06

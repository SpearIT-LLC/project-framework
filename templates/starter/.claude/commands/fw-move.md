# /fw-move - Move Work Item Between Folders

Move a work item between workflow folders with policy enforcement, transition validation, and proper git operations.

## Usage

```
/fw-move <item-id> <target-folder>
```

## Arguments

- `item-id` (required): Work item ID (e.g., FEAT-018, BUGFIX-001) or partial filename
- `target-folder` (required): One of: `backlog`, `todo`, `doing`, `done`, `archive`, `releases`

## Transition Validity Matrix

| From | To | Valid? | Reason |
|------|----|----|--------|
| backlog | todo | ✅ | Standard flow - committing to work |
| backlog | doing | ❌ | Must commit to work (todo) first |
| backlog | archive | ✅ | Cancelling work |
| todo | doing | ✅ | Starting work |
| todo | backlog | ✅ | Deprioritizing work |
| todo | archive | ✅ | Cancelling work |
| doing | done | ✅ | Completing work |
| doing | todo | ✅ | Pausing work |
| doing | archive | ✅ | Cancelling work |
| done | releases | ✅ | Post-release archival |
| done | archive | ✅ | Cancelling/superseding work |
| done | backlog | ❌ | No reopening - create new item |
| done | todo | ❌ | No reopening - create new item |
| done | doing | ❌ | No reopening - create new item |

---

## Embedded Transition Checklists

**CRITICAL:** Follow these checklists completely before executing any move. If ANY check fails, STOP and report what's missing.

### → backlog/

**Use case:** Creating new work items

**Before moving:**
1. ✅ Verify work item created from template
2. ✅ Verify ID assigned (scan ALL work/ locations and history/releases/ first)

**Execute move:**
```bash
git mv project-hub/work/[source]/ITEM-NNN-*.md project-hub/work/backlog/
```

**After move:**
- Commit new work item(s) (immediately or after batch creation)

---

### → todo/

**Use case:** Committing to work (from backlog) or deprioritizing (from doing)

**Before moving:**
1. ✅ Validate transition (check matrix above)
2. ✅ Read work item file
3. ✅ Verify `Priority` field is set
4. ✅ Verify user has approved the work
5. ✅ Check `todo/.limit` file (if exists) - WIP limit not exceeded

**If ANY check fails:**
- STOP and report what's missing
- Offer to fix (e.g., "FEAT-042 has no Priority set. Set it now?")
- Do NOT proceed with move

**Execute move:**
```bash
git mv project-hub/work/[source]/ITEM-NNN-*.md project-hub/work/todo/
```

**After move:**
- No additional actions required

---

### → doing/

**Use case:** Starting work on a committed item

**Before moving:**
1. ✅ Validate transition (check matrix above)
2. ✅ Read work item file COMPLETELY
3. ✅ Check `Depends On` field - all dependencies must be in done/
4. ✅ Check `doing/.limit` file (if exists) - verify WIP not exceeded
   - Default limit: 1 for solo developers, 2 for teams
   - Count current items in doing/ (including subdirectories)

**If ANY check fails:**
- STOP and report what's missing
- Examples:
  - "FEAT-042 depends on FEAT-038 which is still in todo. Complete FEAT-038 first?"
  - "WIP limit reached (2/2). Complete or pause current work first?"
- Do NOT proceed with move

**Execute move:**
```bash
git mv project-hub/work/[source]/ITEM-NNN-*.md project-hub/work/doing/
```

**After move - Pre-Implementation Review (REQUIRED):**
1. ✅ Identify open questions in the work item:
   - Search for: TODO, TBD, DECIDE, Question, "Option A/B/C"
   - Check for incomplete design sections
   - Note any assumptions that need validation
2. ✅ Present pre-implementation summary to user:
   - What we're building
   - Key design decisions
   - Open questions found
   - Implementation scope
3. ✅ **STOP - Wait for user confirmation before implementing**

**Do NOT start implementation until user approves the plan.**

**During Implementation - Checklist Enforcement:**

If the work item has an "Implementation Checklist" section with the enforcement comment:
```markdown
<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->
```

**You MUST follow this step-by-step execution protocol:**

1. ✅ **Complete items in strict order** - Do not skip ahead
2. ✅ **Mark items complete immediately** - Update `[ ]` to `[x]` as soon as finished
3. ✅ **STOP at each unchecked item** - Wait for explicit user approval before proceeding
   - Exception: User says "continue to completion" to approve all remaining steps at once
4. ✅ **Read the file before every edit** - Work item may be updated during implementation
5. ✅ **Use TodoWrite tool** - Track progress and provide visibility to user

**Step-by-step execution example:**
```
Current item: "[ ] Design API endpoint structure"
AI: "I'll design the API endpoint structure now..."
[AI completes the work]
AI: [Marks item complete in work item file]
AI: "API endpoint structure designed. Next step is implementing the handler. Continue?"
[Waits for user approval]
User: "yes"
AI: [Proceeds to next checklist item]
```

**User override phrases:**
- "continue to completion" → Approve all remaining checklist items at once
- "skip to step N" → Jump ahead (only if user explicitly requests)

**CRITICAL:** The enforcement comment indicates user wants control over implementation pace. Respect this by stopping at each step unless explicitly told to continue.

---

### → done/

**Use case:** Completing work

**Before moving:**
1. ✅ Validate transition (check matrix above)
2. ✅ Read work item file COMPLETELY
3. ✅ Verify ALL acceptance criteria are checked `[x]` (scan for `- [ ]`)
4. ✅ Verify `Completed` date is set (format: YYYY-MM-DD)
5. ✅ Verify user has approved the completed work

**If ANY check fails:**
- STOP and report what's missing
- Offer to fix:
  - "FEAT-042 has 2 unchecked acceptance criteria. Mark them complete?"
  - "No Completed date. Set it to today (2026-02-04)?"
- Do NOT proceed with move until ALL criteria are met

**Execute move:**
```bash
git mv project-hub/work/doing/ITEM-NNN-*.md project-hub/work/done/
```

**After move (REQUIRED):**
1. ✅ Update session history using `/fw-session-history`
2. ✅ Commit the changes:
   ```bash
   git add .
   git commit -m "feat: Complete ITEM-NNN - [brief description]"
   ```

---

### → history/archive/ (Cancellation)

**Use case:** Cancelling, superseding, or archiving work that won't be completed

**When to Cancel vs Deprioritize:**

| Situation | Action | Destination |
|-----------|--------|-------------|
| Work no longer needed | Cancel | archive/ |
| Requirements changed fundamentally | Cancel | archive/ |
| Superseded by different approach | Cancel | archive/ |
| Lower priority, may do later | Deprioritize | backlog/ |
| Blocked temporarily | Pause | todo/ or backlog/ |

**Rule of thumb:** If the work item as written will *never* be done, cancel it. If it *might* be done later, deprioritize it.

**Before moving:**
1. ✅ Validate transition (check matrix above)
2. ✅ Read work item file
3. ✅ Verify cancellation metadata added:
   - `**Status:** Cancelled`
   - `**Cancelled Date:** YYYY-MM-DD`
   - `**Cancellation Reason:** [Brief explanation]`
4. ✅ Optional but recommended:
   - `**Superseded By:** ITEM-NNN` (if applicable)
   - `**Lessons Learned:** [What we learned]`

**If metadata missing:**
- STOP and offer to add it
- Ask user for cancellation reason
- Suggest lessons learned if valuable

**Execute move:**
```bash
git mv project-hub/work/[source]/ITEM-NNN-*.md project-hub/history/archive/
```

**After move:**
1. ✅ Update session history noting the cancellation
2. ✅ Commit: `git commit -m "chore: Cancel ITEM-NNN - [brief reason]"`

---

### → history/releases/vX.Y.Z/

**Use case:** Post-release archival of completed work

**Before moving:**
1. ✅ Validate transition (done → releases only)
2. ✅ Verify release version exists: `history/releases/vX.Y.Z/` directory
3. ✅ Verify all items in done/ are ready for release

**Execute move:**
```bash
git mv project-hub/work/done/*.md project-hub/history/releases/vX.Y.Z/
```

**After move:**
1. ✅ Verify done/ is empty
2. ✅ Follow complete release process at: `framework/docs/process/version-control-workflow.md#release-checklist`

**Note:** This is typically done as part of a full release, not for individual items.

---

## Examples

```bash
/fw-move FEAT-042 todo      # Move from backlog to todo (committing)
/fw-move FEAT-042 doing     # Start work (with pre-implementation review)
/fw-move FEAT-042 done      # Complete work (with validation)
/fw-move BUGFIX-001 backlog # Deprioritize back to backlog
/fw-move FEAT-099 archive   # Cancel work (add metadata first)
```

## Error Handling

**Invalid transition:**
```
❌ Cannot move FEAT-042 directly from backlog to doing.
   Valid path: backlog → todo → doing
   Would you like me to move it to todo first?
```

**Missing preconditions:**
```
❌ Cannot move FEAT-042 to done - preconditions not met:
   - Completed date missing
   - 2 acceptance criteria still unchecked

   Would you like me to fix these issues?
```

**WIP limit exceeded:**
```
❌ Cannot move FEAT-042 to doing - WIP limit reached.
   Current: 2 items in doing/ (limit: 2)
   Items in progress: FEAT-038, TECH-041
   Complete or pause current work first.
```

**Dependency not met:**
```
❌ Cannot move FEAT-042 to doing - dependency not satisfied:
   Depends on: FEAT-038 (currently in doing/)

   FEAT-038 must be completed and moved to done/ first.
```

**Item not found:**
```
❌ Could not find work item 'FEAT-999'.
   Did you mean one of these?
   - FEAT-098 (in backlog/)
   - FEAT-042 (in doing/)
```

---

## Policy Reference

This command enforces the transition policy defined in:
- `framework/docs/collaboration/workflow-guide.md#workflow-transitions`
- `framework.yaml` → `policies.onTransition`

**Source of truth:** `framework/docs/collaboration/workflow-guide.md#per-transition-checklists`

**⚠️ Sync Note:** These embedded checklists are duplicated for enforcement. When the source checklists change in workflow-guide.md, this file must be updated to match.

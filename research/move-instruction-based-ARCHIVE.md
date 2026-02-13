# /spearit-framework-light:move - Move Work Item Between Folders

Move a work item between workflow folders with policy enforcement, transition validation, and proper git operations.

## Usage

```
/spearit-framework-light:move <item-id> <target-folder>
```

## Arguments

- `item-id` (required): Work item ID (e.g., FEAT-018, BUGFIX-001) or partial filename
- `target-folder` (required): One of: `backlog`, `todo`, `doing`, `done`, `archive`, `releases`

## Prerequisites

**Expected structure:** `project-hub/work/{backlog,todo,doing,done}/` and `project-hub/history/{archive,releases}/`

**If structure doesn't exist:**
- Offer to create the directory structure
- Provide guidance on setting up file-based Kanban workflow
- See plugin skills for methodology overview

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

## Performance Requirements

**CRITICAL: Most transitions are deterministic operations requiring NO AI reasoning.**

**Performance Targets:**

| Transition | Target Time | Operations |
|------------|-------------|------------|
| → backlog | < 3 seconds | Rule check + git mv |
| → todo | < 5 seconds | Rule check + WIP count + git mv |
| → doing | < 15 seconds | Above + AI review |
| → done | < 3 seconds | Rule check + git mv |
| → archive | < 3 seconds | Rule check + git mv |

**Execution Model:**
- **Deterministic transitions** (backlog, todo, done, archive): Direct tool use only
- **AI-assisted transition** (doing): Fast operations + concise review

---

## Execution Approach

**Philosophy:** Trust user judgment. Only enforce critical gates that add real value.

**When to read the work item file:**
- **→ doing/**: YES - Pre-implementation review is critical
- **All other moves**: NO - Just validate transition and execute

**When to use AI reasoning:**
- **→ doing/**: YES - Understanding scope, dependencies, open questions
- **All other moves**: NO - Deterministic lookup/arithmetic only

---

## Embedded Transition Checklists

### → backlog/

**Use case:** Deprioritizing work or creating new items

**CRITICAL: Deterministic operation - Do NOT use AI reasoning or spawn agents.**

**Execution:**
1. **YOU validate transition directly** (lookup in matrix above - no reasoning)
2. **Execute:** `git mv project-hub/work/[source]/ITEM-NNN-*.md project-hub/work/backlog/`
3. **Done** (< 3 seconds)

**Do NOT:**
- Read work item file
- Run find/search commands
- Generate summaries or analysis
- Use Task tool or spawn agents

---

### → todo/

**Use case:** Committing to work (from backlog) or pausing work (from doing)

**CRITICAL: Deterministic operation - Do NOT use AI reasoning or spawn agents.**

**Execution:**
1. **YOU validate transition directly** (lookup in matrix - no reasoning)
2. **YOU count WIP directly** (if `todo/.limit` file exists):
   - Read limit as integer from file
   - Glob for `todo/*.md` files
   - Parse TYPE-ID pattern from filenames (e.g., FEAT-127)
   - Count unique work items (arithmetic only - no analysis)
   - If count >= limit, warn with template message but don't block
3. **Execute:** `git mv project-hub/work/[source]/ITEM-NNN-*.md project-hub/work/todo/`
4. **Done** (< 5 seconds)

**Do NOT:**
- Read work item file contents
- Run find/search commands
- Generate summaries or analysis
- Use Task tool or spawn agents

---

### → doing/

**Use case:** Starting work on a committed item

**This is the ONLY transition requiring AI reasoning. Execute in two phases:**

---

**Phase 1: Fast Deterministic Operations (< 5 seconds)**

1. **YOU validate transition directly** (lookup in matrix - no reasoning)
2. **YOU count WIP directly** (if `doing/.limit` file exists):
   - Read limit as integer from file
   - Glob for `doing/*.md` files
   - Parse TYPE-ID pattern from filenames
   - Count unique work items (arithmetic only)
   - If count >= limit, warn but don't block
   - Example: "⚠️ WIP limit: 3/2 work items (TASK-126, FEAT-118, TECH-042)"
3. **Execute:** `git mv project-hub/work/[source]/ITEM-NNN-*.md project-hub/work/doing/`

**Do NOT run find commands or check related work items during this phase.**

---

**Phase 2: AI Pre-Implementation Review (< 10 seconds)**

**This is where AI adds value - understanding and summarizing the work:**

1. **Read work item file** (required for review)
2. **Extract key information:**
   - Summary: What we're building (1-2 sentences)
   - Dependencies: Check "Depends On" field (warn if not in done/)
   - Open questions: Search for TODO, TBD, DECIDE, Question, "Option A/B/C"
3. **Present concise review** (not elaborate markdown reports):
   ```
   📋 Pre-Implementation Review: ITEM-NNN

   Building: [1-2 sentence summary]
   Dependencies: [list if any, or "None"]
   Open Questions: [list if found, or "None"]

   Ready to proceed?
   ```
4. **STOP - Wait for user confirmation**

**Do NOT:**
- Run find commands to check where related items are located
- Generate multi-section formatted reports with tables
- Over-analyze or elaborate beyond key facts
- Search codebase or read other files

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

**CRITICAL: Deterministic operation - Do NOT use AI reasoning or spawn agents.**

**Execution:**
1. **YOU validate transition directly** (lookup in matrix - no reasoning)
2. **Execute:** `git mv project-hub/work/doing/ITEM-NNN-*.md project-hub/work/done/`
3. **Done** (< 3 seconds)

**Optional:** Remind user they can document completion in session history, but don't require it.

**Do NOT:**
- Read work item file
- Run find/search commands
- Generate summaries or analysis
- Use Task tool or spawn agents

---

### → history/archive/ (Cancellation)

**Use case:** Cancelling, superseding, or archiving work that won't be completed

**CRITICAL: Deterministic operation - Do NOT use AI reasoning or spawn agents.**

**When to Cancel vs Deprioritize:**

| Situation | Action | Destination |
|-----------|--------|-------------|
| Work no longer needed | Cancel | archive/ |
| Requirements changed fundamentally | Cancel | archive/ |
| Superseded by different approach | Cancel | archive/ |
| Lower priority, may do later | Deprioritize | backlog/ |
| Blocked temporarily | Pause | todo/ or backlog/ |

**Rule of thumb:** If the work item as written will *never* be done, cancel it. If it *might* be done later, deprioritize it.

**Execution:**
1. **YOU validate transition directly** (lookup in matrix - no reasoning)
2. **Execute:** `git mv project-hub/work/[source]/ITEM-NNN-*.md project-hub/history/archive/`
3. **Done** (< 3 seconds)

**Optional:** After move, suggest adding cancellation metadata (Status: Cancelled, Cancelled Date, Reason) but don't block the move if missing.

**Do NOT:**
- Read work item file (unless suggesting metadata)
- Run find/search commands
- Generate summaries or analysis
- Use Task tool or spawn agents

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
2. ✅ Create release notes and tag the version
3. ✅ Update project changelog

**Note:** This is typically done as part of a full release, not for individual items.

---

## Examples

```bash
/spearit-framework-light:move FEAT-042 todo      # Move to todo (instant)
/spearit-framework-light:move FEAT-042 doing     # Start work (triggers pre-implementation review)
/spearit-framework-light:move FEAT-042 done      # Complete work (instant)
/spearit-framework-light:move BUGFIX-001 backlog # Deprioritize (instant)
/spearit-framework-light:move FEAT-099 archive   # Cancel work (instant, metadata suggested after)
```

## Error Handling

**Invalid transition:**
```
❌ Cannot move FEAT-042 directly from backlog to doing.
   Valid path: backlog → todo → doing
   Would you like me to move it to todo first?
```

**WIP limit warning (doing/ only):**
```
⚠️  Moving FEAT-042 to doing/
   Current WIP: 2 items (limit: 2)
   Items in progress: FEAT-038, TECH-041

   Proceeding with move. Consider completing current work first.
```

**Dependency check (doing/ only):**
```
⚠️  FEAT-042 depends on: FEAT-038 (currently in todo/)

   Proceeding with move. Complete dependencies for best workflow.
```

**Item not found:**
```
❌ Could not find work item 'FEAT-999'.
   Did you mean one of these?
   - FEAT-098 (in backlog/)
   - FEAT-042 (in doing/)
```

---

## Notes

- **Fast and friction-free:** Trusts user judgment for routine moves
- **Critical gate:** Pre-implementation review (→ doing/) is the only moment requiring deep validation
- **Warnings, not blocks:** WIP limits and dependencies warn but don't prevent moves
- Uses `git mv` for proper version control tracking
- Graceful behavior if project-hub/ structure doesn't exist (offers to create)
- Compatible with any git repository

**Philosophy:** The move command should feel instant for routine operations, with the valuable "pause and review" moment reserved for when you're about to start implementation.

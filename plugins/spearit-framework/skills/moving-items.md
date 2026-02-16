# Skill: Moving Work Items - Workflow Transitions and Policies

## Overview

Moving work items between folders represents state transitions in the workflow. Each transition has **validation rules** and **checklists** to ensure quality and focus.

## The Move Command

```
/spearit-framework-light:move <item-id> <target-folder>
```

**Example:**
```
/spearit-framework-light:move FEAT-042 doing
```

The command enforces all transition policies automatically.

## Transition Policies

### backlog → todo (Committing to Work)

**What it means:** "Yes, we're going to do this"

**Validation:**
- ✅ Priority must be set (High/Medium/Low)
- ✅ User has approved the work
- ✅ WIP limit in todo/ not exceeded (if `.limit` file exists)

**After move:** Work is in the committed queue

### todo → doing (Starting Work)

**What it means:** "I'm actively working on this now"

**Validation:**
- ✅ WIP limit in doing/ not exceeded (default: 1 for solo)
- ✅ All dependencies satisfied (check `Depends On` field)
- ✅ Work item fully understood

**After move - CRITICAL:**
1. Pre-implementation review is performed
2. Open questions identified (TODO, TBD, DECIDE markers)
3. **STOP and wait for user approval** before implementing

**Philosophy:** Understand before building

### doing → done (Completing Work)

**What it means:** "This is functionally complete"

**Validation:**
- ✅ ALL acceptance criteria checked `[x]`
- ✅ Completed date set (YYYY-MM-DD)
- ✅ User has approved the work

**After move - REQUIRED:**
1. Update session history: `/spearit-framework-light:session-history`
2. Commit changes to git

**Philosophy:** Done means DONE (all criteria met)

### Pausing Work (doing → todo)

**When to use:**
- Need to context-switch temporarily
- Blocked on external dependency
- Higher priority work arrived

**Effect:** Frees up WIP slot in doing/

### Deprioritizing (todo → backlog)

**When to use:**
- Priority changed (lower than other work)
- Not ready to commit yet
- May do eventually but not soon

**Effect:** Removes from committed queue

### Cancelling Work (* → archive)

**When to use:**
- Work no longer needed
- Requirements changed fundamentally
- Superseded by different approach

**Required metadata:**
```markdown
**Status:** Cancelled
**Cancelled Date:** YYYY-MM-DD
**Cancellation Reason:** [Brief explanation]
**Superseded By:** TYPE-NNN (if applicable)
```

**Philosophy:** Archive, don't delete (preserve lessons learned)

## WIP (Work In Progress) Limits

### Purpose
Enforce focus by limiting parallel work

### Default Limits
- **doing/**: 1 item (enforces focus)
- **todo/**: No default limit (configurable)

### Configuration
Create a `.limit` file in the workflow folder containing a single integer:
```
echo "2" > project-hub/work/doing/.limit
```

This sets the WIP limit to 2 items for that folder.

### Enforcement
If limit exceeded, move command blocks with error:
```
❌ Cannot move FEAT-042 to doing - WIP limit reached.
   Current: 1 item in doing/ (limit: 1)
   Complete or pause current work first.
```

### Philosophy
**Finish what you start** before starting something new

## Dependency Checking

Work items can depend on other work items:

```markdown
**Depends On:** FEAT-038, TECH-015
```

**Enforcement:** Cannot move to `doing/` until all dependencies are in `done/`

**Example error:**
```
❌ Cannot move FEAT-042 to doing - dependency not satisfied:
   Depends on: FEAT-038 (currently in doing/)
   FEAT-038 must be completed first.
```

## Pre-Implementation Review

**Triggered when:** Moving item to `doing/` OR user requests review

**Process:**
1. Read ENTIRE work item document
2. Identify open questions:
   - Search for: TODO, TBD, DECIDE, Question
   - Check for "Option A/B/C" decision points
   - Note incomplete design sections
3. Present summary to user:
   - What we're building
   - Key design decisions
   - Open questions found
   - Implementation scope
4. **STOP - Wait for user confirmation**

**Philosophy:** No surprises. User approves the plan before code is written.

## Common Patterns

### Standard Flow
```
backlog → todo → doing → done → releases/
```

### Interrupted Work
```
doing → todo (pause)
[work on something else]
todo → doing (resume)
```

### Changed Mind
```
todo → backlog (deprioritize)
backlog → archive (cancel)
```

## Invalid Transitions (Blocked)

❌ **backlog → doing** - Must commit first (→ todo)
❌ **todo → done** - Must do the work (→ doing first)
❌ **done → anything** - No reopening; create new work item

**Philosophy:** Enforce proper workflow discipline

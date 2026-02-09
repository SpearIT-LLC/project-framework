# Skill: File-Based Kanban Workflow

## Overview

This plugin implements a **file-based Kanban workflow** where work items are markdown files organized into folders representing workflow states. Everything is tracked in git - no external tools or databases required.

## Core Concept

**Work items are files. Workflow state is folder location.**

```
project-hub/
└── work/
    ├── backlog/        # Ideas and future work
    ├── todo/           # Committed to do (prioritized)
    ├── doing/          # Active work (WIP limited)
    └── done/           # Completed (awaiting release)
```

Moving a work item through the workflow = moving its file between folders using `git mv`.

## Workflow States

### backlog/
**Purpose:** Capture ideas and future work without commitment

**Characteristics:**
- No priority required
- No size estimates needed
- Can stay here indefinitely
- Low detail is acceptable

**When to use:** Any idea worth capturing for potential future work

### todo/
**Purpose:** Work you've committed to doing (prioritized queue)

**Characteristics:**
- Priority must be set (High/Medium/Low)
- Should be refined enough to start
- WIP limit enforced (configurable via `todo/.limit` file containing an integer)

**When to use:** When you've decided "yes, we're doing this"

### doing/
**Purpose:** Active work in progress

**Characteristics:**
- **Strict WIP limit** (default: 1 item - enforces focus)
  - Configure via `doing/.limit` file containing an integer (e.g., "2")
- All dependencies must be satisfied
- Requires pre-implementation review before starting
- Work item should be fully understood

**When to use:** When actively implementing/working on the item

**Key principle:** Finish what you start before starting something new

### done/
**Purpose:** Completed work awaiting release

**Characteristics:**
- All acceptance criteria checked
- Completed date set
- Code committed and tested
- Ready to ship

**When to use:** Work is functionally complete but not yet released

## Valid Transitions

The workflow enforces valid state transitions to maintain quality:

**Standard flow:**
```
backlog → todo → doing → done
```

**Common variations:**
```
doing → todo      # Pause work
todo → backlog    # Deprioritize
* → archive       # Cancel work
```

**Invalid (blocked):**
```
backlog → doing   # Must commit (todo) first
done → *          # No reopening (create new item instead)
```

## Work Item Lifecycle Example

1. **Create idea:** Write markdown file in `backlog/`
2. **Commit to work:** Move to `todo/`, set priority
3. **Start work:** Move to `doing/` (check WIP limits, dependencies)
4. **Complete work:** Move to `done/` (verify acceptance criteria)
5. **Release:** Archive to `history/releases/vX.Y.Z/`

## Key Benefits

✅ **Simple:** Files and folders - no complex tools
✅ **Transparent:** See entire workflow in file tree
✅ **Version controlled:** All changes tracked in git
✅ **Portable:** Works in any text editor or IDE
✅ **AI-friendly:** Easy for Claude to read and manipulate
✅ **Offline-first:** No external services required

## Philosophy

This workflow emphasizes:

- **Focus:** WIP limits prevent context switching
- **Commitment:** Explicit transition from "maybe" (backlog) to "yes" (todo)
- **Completion:** Finish what you start before starting more
- **History:** Archive cancelled work instead of deleting (preserve lessons)
- **Simplicity:** Files > Databases, Folders > Custom States

## When This Works Well

✅ Solo developers working independently
✅ Projects tracked in git repositories
✅ Working with AI assistants (Claude Code)
✅ Want lightweight process without heavy tools

## When to Consider Alternatives

❌ Teams (ID collision risk - use full framework with centralized ID management)
❌ Need rich reporting/analytics dashboards
❌ External stakeholders require specific PM tools
❌ Regulatory compliance requires audit trails in specific formats

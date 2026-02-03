# /fw-session-history - Generate Session History

Generate or update the session history document for today, capturing work completed, decisions made, and files modified during the current session.

## Usage

```
/fw-session-history [focus]
```

## Arguments

- `focus` (optional): Brief description of session focus (e.g., "FEAT-022 implementation")

## Behavior

1. **Determine file path**: `framework/project-hub/history/sessions/YYYY-MM-DD-SESSION-HISTORY.md`
2. **Check if file exists**:
   - If exists: Read and update/append to existing content
   - If new: Create from template structure below
3. **Gather information**:
   - Review conversation context for work completed
   - Check git log for commits since session start (or last history entry)
   - Identify decisions made and their rationale
   - List files created, modified, and moved
4. **Generate/update session history** following the standard format
5. **Present to user** for review before writing

## Session History Format

```markdown
# Session History: YYYY-MM-DD

**Date:** YYYY-MM-DD
**Participants:** [User name], Claude Code
**Session Focus:** [Focus description]
**Role:** [Active role from framework.yaml]

---

## Summary

[2-3 sentence summary of what was accomplished]

---

## Work Completed

### [Work Item ID]: [Title]

- [Key accomplishment]
- [Key accomplishment]

---

## Decisions Made

1. **[Decision topic]:**
   - [Decision details]
   - [Rationale]

---

## Files Modified

- `path/to/file` - [Brief description of change]

## Files Created

- `path/to/file` - [Purpose]

## Files Moved

- `old/path` -> `new/path`

---

## Current State

### In done/ (awaiting release)
- [Work items]

### In doing/
- [Work items]

---

**Last Updated:** YYYY-MM-DD
```

## Examples

```
/fw-session-history                           # Generate with auto-detected focus
/fw-session-history "FEAT-022 implementation" # Generate with explicit focus
```

## Integration Points

This command should also be offered:
- After `/fw-move X done` completes (prompt: "Would you like me to update session history?")
- When user signals session end ("wrapping up", "that's all for today", etc.)

## Notes

- AI uses conversation context - no special tooling required
- Multiple updates per day append to same file
- User reviews content before file is written
- Existing content is preserved when updating

## Important: Append-Only Principle

**Session history is a historical record - show the journey, not just the destination.**

*See also: [Workflow Guide - Session History](../docs/collaboration/workflow-guide.md#session-history) for detailed process guidance.*

When updating an existing session history file:

✅ **DO:**
- Append new sections for continued work
- Show evolution of thinking throughout the day
- Preserve original decisions/conclusions even if later superseded
- Add "(Later)" or "(Afternoon Session)" markers when continuing discussions
- Document how you arrived at final decisions

❌ **DON'T:**
- Replace earlier content with final decisions
- Rewrite history to show only the end state
- Delete original "pending" or "TBD" status when decisions are made later

**Example:**

**Morning (original):**
```
### 2. Epic Structure (Pending)
**Status:** Three options under consideration, final decision next session
```

**Afternoon (append, don't replace):**
```
### 2. Epic Structure - Final Decision (Afternoon Session)
**Continuation:** Resumed epic discussion from morning
**Final decision:** Themes + Planning Periods model
**Rationale:** [Why we chose this over the three options]
```

This preserves the historical record of HOW decisions evolved, not just WHAT was decided.

ARGUMENTS: $ARGUMENTS

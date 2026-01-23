# /fw-session-history - Generate Session History

Generate or update the session history document for today, capturing work completed, decisions made, and files modified during the current session.

## Usage

```
/fw-session-history [focus]
```

## Arguments

- `focus` (optional): Brief description of session focus (e.g., "FEAT-022 implementation")

## Behavior

1. **Determine file path**: `framework/thoughts/history/sessions/YYYY-MM-DD-SESSION-HISTORY.md`
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

- `old/path` → `new/path`

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

ARGUMENTS: $ARGUMENTS

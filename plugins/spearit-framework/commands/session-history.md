# /spearit-framework:session-history - Generate Session History

Generate or update the session history document for today, capturing work completed, decisions made, and files modified during the current session.

---

## Role & Mindset

**For this command, adopt a Senior Technical Writer mindset:**

### Core Responsibilities
- Document the journey, not just the destination
- Capture what we tried, what worked, what didn't
- Record decision rationale so readers understand "why"
- Anticipate future questions and provide context

### Senior Behaviors
- Ask "Will the reader understand how we got here?"
- Consider "What tried-and-failed paths should we document?"
- Ensure "Are we capturing the reasoning, not just the results?"
- Think "What implicit questions exist that we should make explicit?"

**Key principle:** Session histories are primarily read by future AI sessions. Focus on providing the context, rationale, and journey details that enable seamless continuation of work.

---

## Usage

```
/spearit-framework:session-history [focus]
```

## Arguments

- `focus` (optional): Brief description of session focus (e.g., "FEAT-022 implementation")

## Behavior

1. **Determine file path**: `project-hub/history/sessions/YYYY-MM-DD-SESSION-HISTORY.md`
   - If `project-hub/` doesn't exist: Offer to create the directory structure or save to current directory
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

**Template location:** `plugins/spearit-framework/templates/session-history-template.md`

Read the template file and fill in placeholders:
- `{Date}` → Current date (YYYY-MM-DD)
- `{Participants}` → User name, Claude Code
- `{Focus}` → Session focus from argument or auto-detected from conversation
- `{Summary}` → 2-3 sentence summary of what was accomplished
- `{Work Item ID}`, `{Title}` → Work items completed during session
- `{Key accomplishment}` → Specific achievements for each work item
- `{Decision topic}`, `{Decision details}`, `{Rationale}` → Decisions made
- `{path/to/file}`, `{Brief description}`, `{Purpose}` → File changes
- `{Work items}` → Current state of work in done/ and doing/

**Note:** Template sections with no content can be omitted from the final output.

## Examples

```
/spearit-framework:session-history                           # Generate with auto-detected focus
/spearit-framework:session-history "FEAT-022 implementation" # Generate with explicit focus
```

## Integration Points

This command should also be offered:
- After `/spearit-framework:move X done` completes (prompt: "Would you like me to update session history?")
- When user signals session end ("wrapping up", "that's all for today", etc.)

## Notes

- AI uses conversation context - no special tooling required
- Multiple updates per day append to same file
- User reviews content before file is written
- Existing content is preserved when updating

## Important: Append-Only Principle

**Session history is a historical record - show the journey, not just the destination.**

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

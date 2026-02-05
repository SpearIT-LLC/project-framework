# Feature: Automated Session History Generation

**ID:** FEAT-022
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2025-12-29
**Completed:** 2026-01-20

---

## Scope Revision (2026-01-20)

**Original scope was over-engineered.** Simplified to:
1. `/fw-session-history` command (explicit trigger)
2. Prompt on done-transition ("Would you like me to update session history?")
3. Conversational signals (AI detects "wrapping up", "that's all for today")

**Dropped:** Context % trigger (AI cannot reliably detect context usage metrics)

See "Original Design (Archived)" section below for historical context

---

## Summary

Implement automated session history generation that captures work done during development sessions, triggered at natural checkpoints or by explicit user command, reducing manual effort while ensuring complete project history documentation.

---

## Problem Statement

**What problem does this solve?**

Currently, session history is created manually at the end of work sessions. This approach has several issues:

1. **Easy to forget:** Users might forget to generate session history when wrapping up
2. **Difficult with multiple work items:** When covering multiple backlog items in one day, it's hard to capture everything accurately
3. **Context loss:** Waiting until end of session means details might be forgotten
4. **Inconsistent:** Sometimes generated, sometimes missed, creating gaps in project history
5. **Manual reconstruction is hard:** As seen with 2025-12-28 session, reconstructing history from git logs and conversation summaries is time-consuming and potentially incomplete

**Who is affected?**

- **AI assistants:** Need session history to understand project context when resuming work
- **Project maintainers:** Use session history for retrospectives and understanding project evolution
- **New contributors:** Rely on session history to understand how decisions were made
- **Future users:** Adopting the framework need complete history examples

**Current workaround (if any):**

Manual generation when user remembers, or reconstruction from git logs and conversation summaries after the fact.

---

## Simplified Requirements

### Functional Requirements

- [x] `/fw-session-history` command generates session history on demand
- [x] On done-transition (via `/fw-move`), prompt: "Would you like me to update session history?"
- [x] AI detects conversational wrap-up signals and offers to generate history
- [x] Session history follows existing format (YYYY-MM-DD-SESSION-HISTORY.md)
- [x] Appends to existing day's history if file exists

### Non-Functional Requirements

- [x] No special tooling required - AI uses conversation context + git log
- [x] User can decline prompts without friction
- [x] Works with existing `/fw-*` command pattern

---

## Simplified Implementation

### Deliverables

1. **`.claude/commands/fw-session-history.md`** - Command definition
2. **Update `/fw-move`** - Add prompt when target is `done`
3. **Update `framework/CLAUDE.md`** - Add guidance for conversational triggers

### Command Behavior

```
/fw-session-history [focus]
```

- Generates/updates `thoughts/history/sessions/YYYY-MM-DD-SESSION-HISTORY.md`
- Optional `focus` parameter for session focus description
- AI uses conversation context to populate sections
- Checks git log for commits since last history entry

### Trigger Points

1. **Explicit:** User runs `/fw-session-history`
2. **Done-transition:** After `/fw-move X done`, prompt offered
3. **Conversational:** AI detects "wrapping up", "that's all", "let's stop here"

### Acceptance Criteria

- [x] `/fw-session-history` command works
- [x] Done-transition prompts user (non-blocking)
- [x] AI recognizes wrap-up signals and offers history generation (via command definition)
- [x] Generated content follows existing session history format

---

## Original Design (Archived)

<details>
<summary>Click to expand original over-engineered design (preserved for context)</summary>

### Original Problem Statement

Currently, session history is created manually at the end of work sessions. This approach has several issues:

1. **Easy to forget:** Users might forget to generate session history when wrapping up
2. **Difficult with multiple work items:** When covering multiple backlog items in one day, it's hard to capture everything accurately
3. **Context loss:** Waiting until end of session means details might be forgotten
4. **Inconsistent:** Sometimes generated, sometimes missed, creating gaps in project history
5. **Manual reconstruction is hard:** As seen with 2025-12-28 session, reconstructing history from git logs and conversation summaries is time-consuming and potentially incomplete

### Original Requirements (36 items)

**Core Functionality (FR1-FR5):**
- AI can generate session history automatically at natural checkpoints
- User can trigger session history generation via explicit command
- Session history includes: date, participants, summary, what was done, decisions made, files modified, commits, lessons learned
- Session history format matches existing standard
- Multiple session histories can be generated per day if needed

**Natural Checkpoint Triggers (FR6-FR9):**
- Before releasing (when doing/ → done/ movement occurs)
- When work item changes status
- After completing significant work (detected by commit volume or time threshold)
- AI proactively suggests generating history when conversation shows natural break

**Content Generation (FR10-FR15):**
- Parse git log to extract commits from session
- Analyze conversation to extract decisions, problems solved, blockers
- List files created/modified with brief descriptions
- Capture ADRs created and their decisions
- Document follow-up items and deferred work
- Calculate metrics (commits, files, duration estimate)

**Integration (FR16-FR19):**
- Works with existing session history files
- Follows naming convention
- Can append to existing day's history or create new file
- Integrates with FEAT-018 (Claude command framework)

**Non-Functional (NFR1-NFR5):**
- Performance: Generate in <5 seconds
- Accuracy: 90%+ of key decisions
- Usability: User should not need extensive input
- Documentation: Update workflow-guide.md
- Compatibility: Works with CLI and IDE

### Original Architecture

**Key Components:**

1. **Conversation Parser:** Extract decisions, problems, work items, technical details
2. **Git Log Analyzer:** Get commits, group by work item, extract messages/files, calculate metrics
3. **History Generator:** Template-based, populate sections, format markdown, write file
4. **Checkpoint Detector:** Monitor releases, status changes, conversation signals

### Original Implementation Plan (3 phases)

- Phase 1 (v2.3.0): Foundation - template, git parser, basic generator, explicit command
- Phase 2 (v2.4.0): Automation - checkpoint detector, triggers, proactive suggestion
- Phase 3 (v2.5.0): Enhancement - improved parsing, multi-session handling, archival

### Why Simplified

1. **Over-scoped:** 36 requirements, 4 components, 3 phases for what is essentially "AI writes a summary"
2. **AI already capable:** Claude can generate session history from conversation context without special tooling
3. **Context % trigger impractical:** AI cannot reliably detect context usage metrics
4. **YAGNI:** Most automated triggers add complexity without proportional value

</details>

---

## Notes

- Session history complements work item documentation (captures "why" and "how")
- Multiple histories per day is acceptable
- AI-generated content should be reviewable and editable

---

## Changelog

- 2026-01-20: Scope simplified - dropped context trigger, reduced to command + done-prompt + conversational signals
- 2025-12-30: Moved from backlog/ to todo/ (approved for implementation)
- 2025-12-29: Initial feature proposal, backlog item created

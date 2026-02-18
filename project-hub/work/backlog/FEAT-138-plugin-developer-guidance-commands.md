# Feature: Plugin - Developer Guidance Commands

**ID:** FEAT-138
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-02-17
**Theme:** Developer Guidance
**Planning Period:** v1.2

**Depends On:** FEAT-137 (Project Guidance Commands)

---

## Summary

Add developer guidance commands to the `spearit-framework` full plugin — proactive commands that slow down implementation and surface the right engineering questions before code gets written. The antidote to vibe coding.

---

## Problem Statement

**What problem does this solve?**

Developers (and Claude) tend to jump straight to implementation. There's no structured pause to ask: Do we understand the schema? Is this the right architecture? Should we build a POC first? Have we considered testability? These questions are easy to skip and expensive to ignore.

**Who is affected?**

Developers using the full plugin who want Claude to act as a peer programmer — one who asks "are you sure you want to do that?" before the keyboard gets involved.

**Current workaround (if any):**

Ad-hoc prompting. Inconsistent results because there's no structured checklist or context about the project's conventions.

---

## Proposed Commands (MVP)

### `/spearit-framework:review`
Pre-implementation engineering review for a feature or task.
- What are we building? (reads work item if provided)
- Do we understand the data schema / API contract involved?
- What is the right architectural approach?
- Should we build a POC or MVP before production code?
- What are the testing requirements?
- What could go wrong? (risk surface)
- Verdict: "Ready to implement" or "Resolve these questions first"

### `/spearit-framework:refactor`
Guided refactor assessment.
- Is a refactor warranted here, or is this premature?
- What is the scope? (file, module, system)
- What are the risks of refactoring vs. not refactoring?
- What tests need to exist before refactoring begins?
- Recommended approach and sequence

### `/spearit-framework:poc`
POC / MVP scoping guide.
- What hypothesis are we testing?
- What is the minimum needed to validate it?
- What explicitly is NOT in scope for the POC?
- How will we know the POC succeeded?
- When does POC become production? (graduation criteria)

---

## Requirements

### Functional Requirements

- [ ] `review` command presents structured pre-implementation checklist
- [ ] `review` reads work item file if item-id provided as argument
- [ ] `refactor` command presents refactor assessment framework
- [ ] `poc` command guides POC scoping conversation
- [ ] Commands work with or without a specific work item reference
- [ ] help.md updated to include new commands

### Non-Functional Requirements

- [ ] Commands are conversational, not just checklists — Claude engages, doesn't just list
- [ ] Compatible with framework project structure
- [ ] Documentation updated

---

## Design

### Implementation Approach

Same pattern as project guidance commands — markdown files with structured Claude instructions.

**Key principle:** These commands create a *pause*, not a gate. Claude presents the review, user decides whether to proceed. The value is in surfacing the questions, not blocking action.

```
review.md  → reads work item (optional) → structured engineering questions → verdict
refactor.md → asks about scope and risk → recommended approach
poc.md     → scoping conversation → hypothesis + minimum viable test
```

### Files to Add

- `plugins/spearit-framework/commands/review.md`
- `plugins/spearit-framework/commands/refactor.md`
- `plugins/spearit-framework/commands/poc.md`

### Files to Update

- `plugins/spearit-framework/commands/help.md` — add developer guidance section
- `plugins/spearit-framework/CHANGELOG.md` — v1.2 entry
- `plugins/spearit-framework/.claude-plugin/plugin.json` — bump to v1.2.0

---

## Future: Passive Skill Interception

The end goal is a passive skill that fires when Claude is about to write code:

> "Before we start — have we done an engineering review for this? Here's what I'd want to know first..."

This requires event hooks in the skill system. Commands validate the guidance content first.

**Milestone path:**
```
v1.1  Project guidance commands (FEAT-137)
v1.2  Developer guidance commands (this work item)
v1.3  yaml-aware commands for any project (FEAT-139)
v2.0  Passive skill interception — both layers
```

---

## Dependencies

**Requires:**
- FEAT-137 (Project Guidance Commands) — establish the guidance pattern first

**Blocks:**
- Future passive developer guidance skill

**Related:**
- FEAT-137 — Project Guidance Commands (prerequisite)
- FEAT-139 — claude-project.yaml config (makes both guidance layers project-agnostic)

---

## Acceptance Criteria

- [ ] `/spearit-framework:review` presents structured pre-implementation review
- [ ] `/spearit-framework:refactor` presents refactor assessment
- [ ] `/spearit-framework:poc` guides POC scoping
- [ ] `/spearit-framework:help` updated with developer guidance section
- [ ] Commands tested on real work items from this project
- [ ] Plugin version bumped to 1.2.0 and rebuilt

---

## Notes

**Scope boundary:**
Developer guidance is code-level (architecture, schema, testing, refactoring).
Project guidance (FEAT-137) is workflow-level (status, backlog, pre-flight).
Both are "guidance" — they differ in the domain they're guiding.

**The peer programmer metaphor:**
These commands simulate a senior developer looking over your shoulder — not blocking you, but asking the questions you might skip when you're eager to start building.

**Commands vs. skills:**
Commands require explicit invocation. The real value is when this becomes ambient — Claude asks these questions without being prompted. That's the v2.0 vision.

---

**Last Updated:** 2026-02-17

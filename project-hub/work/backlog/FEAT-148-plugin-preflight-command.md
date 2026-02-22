# Feature: Plugin - Preflight Command

**ID:** FEAT-148
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-02-21
**Theme:** Project Guidance
**Planning Period:** v1.1

**Depends On:** FEAT-137 (Project Guidance Commands - status and backlog)

---

## Summary

Add a `/spearit-framework:preflight` command to the full plugin that presents a structured pre-implementation review for a specific work item. This is the command version of the informal review that already happens when moving an item to doing/.

---

## Problem Statement

**What problem does this solve?**

Users can start work on an item without a structured moment to review scope, open questions, and dependencies. The move → doing transition already triggers an informal AI review, but there's no standalone command to invoke this review on demand — before starting, mid-work, or when re-orienting after a break.

**Who is affected?**

Anyone using the full plugin who wants Claude as a project partner, not just a workflow executor.

**Current workaround:**

The `move → doing` transition in the move command does this informally as a post-move step. But it's coupled to the move action and can't be invoked independently.

---

## Proposed Command

### `/spearit-framework:preflight [item-id]`

Pre-implementation review for a specific work item.

- Read the work item file from project-hub/work/ (any folder)
- Surface: what we're building, open questions, dependencies, scope risks
- Ask: "Ready to proceed, or are there questions to resolve first?"

**Arguments:**
- `item-id` (optional): ID of the work item to review. If omitted and exactly one item is in doing/, review that item. If omitted and multiple items are in doing/, prompt user to specify.

**Output format:**
```
📋 Preflight Review: FEAT-NNN

Building: [1-2 sentence summary]
Location: doing/ (or todo/, backlog/)
Dependencies: [list or "None identified"]
Open Questions: [any TODO/TBD/DECIDE markers found, or "None"]
Scope notes: [anything that looks like risk or ambiguity]

Ready to proceed?
```

---

## Requirements

### Functional Requirements

- [ ] `preflight` with no args reviews the single item in doing/ (or prompts if multiple)
- [ ] `preflight <id>` reads and reviews any item regardless of folder
- [ ] Surfaces TODO/TBD/DECIDE markers from the item content
- [ ] Checks Depends On field and flags any unmet dependencies
- [ ] Works for any work item type (FEAT, BUGFIX, TECH, DECISION, etc.)

### Non-Functional Requirements

- [ ] Completes in < 10 seconds
- [ ] Degrades gracefully if item not found (suggest closest match)

---

## Design

### Implementation Approach

Command file reads the specified (or auto-detected) work item, then Claude synthesizes the structured review. No bash script needed — pure AI read + analysis.

### Files to Add

- `plugins/spearit-framework/commands/preflight.md`

### Files to Update

- `plugins/spearit-framework/commands/help.md` — add to command listing
- `plugins/spearit-framework/CHANGELOG.md` — v1.1 entry (alongside status and backlog)
- `plugins/spearit-framework/.claude-plugin/plugin.json` — bump to v1.1.0 (with FEAT-137)

---

## Relationship to FEAT-137

FEAT-137 (status + backlog) and FEAT-148 (preflight) together complete the v1.1 guidance layer:

- `status` — where is the project?
- `backlog` — what should we work on next?
- `preflight` — are we ready to start this item?

They were originally one work item but split because preflight has a distinct design (no script, different role/mindset) and the naming needed more thought.

---

## Future: Passive Skill Interception

The long-term goal is for preflight to run automatically when moving to doing/ — without being invoked explicitly. This requires event hook support in the skill system (not available yet). The command validates the guidance content; the skill promotes it to ambient behavior.

---

## Acceptance Criteria

- [ ] `/spearit-framework:preflight` with one item in doing/ presents structured review
- [ ] `/spearit-framework:preflight <id>` works for any item in any folder
- [ ] TODO/TBD/DECIDE markers are surfaced
- [ ] Unmet dependencies are flagged
- [ ] `/spearit-framework:help` updated to list 9 commands
- [ ] Plugin version bumped to v1.1.0 (coordinate with FEAT-137)

---

## Notes

**Why "preflight" not "plan"?**
"Plan" overlaps with roadmap and swarm — those commands create plans. Preflight is a safety check before takeoff: you're not planning, you're confirming you're ready. The aviation metaphor is accurate and memorable.

**Naming considered:** `plan`, `review`, `review-work-item`, `inspect`, `brief`, `preflight`
Decision: `preflight` — distinct, memorable, accurate metaphor.

---

**Last Updated:** 2026-02-21

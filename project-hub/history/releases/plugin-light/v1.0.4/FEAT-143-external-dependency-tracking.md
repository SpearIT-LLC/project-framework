# Feature: External Dependency Tracking — Blocked/ Workflow

**ID:** FEAT-143
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-02-18
**Theme:** Workflow
**Planning Period:** Unscheduled

**Depends On:** None
**Completed:** 2026-02-18

---

## Summary

Add a `blocked/` folder to the workflow and supporting process documentation for tracking work that is blocked on an external party — vendors, clients, other teams, or individuals. This is a common scenario for contractors and consultants where the work exists and is defined, but progress requires action from outside the repo.

---

## Problem Statement

**What problem does this solve?**

The current workflow (`backlog → todo → doing → done`) has no state for "defined work that is blocked on someone else." Items blocked on external parties don't fit in:
- `backlog/` — implies not yet committed, may be deprioritized
- `todo/` — implies ready to start, waiting on you
- `doing/` — implies actively in progress by you

External dependencies can sit unresolved for days, weeks, or months. Without a dedicated state, they get buried in backlog, forgotten, or incorrectly tracked as active WIP.

**Who is affected?**

Contractors, consultants, and anyone working with external parties — vendors, client approvers, third-party APIs, procurement teams, other developers.

**Observed trigger:**

Discovered while preparing to file a bug report with Anthropic (Claude Code plugin namespace collision). Needed a place to track the filed issue, expected resolution timeline, workaround in use, and follow-up actions — none of which fit existing workflow states.

**Current workaround:**

None. Items either sit in backlog with a status tag (invisible) or get tracked outside the repo entirely.

---

## Proposed Solution

### New Folder: `project-hub/work/blocked/`

A dedicated workflow state for items blocked on external parties.

**Transition rules:**
- `backlog → blocked` (external dependency identified on a backlog item)
- `todo → blocked` (external blocker discovered after committing)
- `doing → blocked` (hit a blocker mid-work)
- `blocked → todo` (external party resolved, ready to resume)
- `blocked → doing` (external party resolved, resuming active work)
- `blocked → archive` (external party won't resolve, cancelling)
- `blocked → done` (rare: external party resolved AND no further work needed)

**Work item metadata additions:**

```markdown
**Blocked By:** [External party name/description]
**External Reference:** [URL, ticket number, email thread, etc.]
**Reported Date:** YYYY-MM-DD
**Expected Resolution:** YYYY-MM-DD or "Unknown"
**Workaround:** [What we're doing in the meantime, or "None"]
**Follow-up Actions:** [What AI/human needs to do when unblocked]
```

### Supporting Documentation

1. Update `framework/docs/collaboration/workflow-guide.md` — add `blocked/` to transition matrix and per-transition checklist
2. Update work item template — add optional `blocked/` metadata block
3. Update `fw-move` command — add `blocked` as valid target with appropriate transition rules
4. Update `spearit-framework:move` plugin command — add `blocked` as valid target
5. Update `spearit-framework-light:move` plugin command — add `blocked` as valid target
6. Add `blocked/` folder with `.gitkeep` to framework template (`templates/starter/`)

### Scope Note: Where Details Live

The work item file itself is the lightweight tracker (status, reference, workaround). Rich detail — reproduction steps, conversation logs, vendor correspondence — lives in `project-hub/research/` linked from the work item. This keeps the work item scannable and the detail findable.

---

## Requirements

### Functional Requirements

- [x] `project-hub/work/blocked/` folder exists in framework and template
- [x] Transition matrix updated with `blocked/` state and valid transitions
- [x] Per-transition checklist for `→ blocked/` documented in workflow guide
- [x] Per-transition checklist for `blocked/ →` documented in workflow guide
- [x] `fw-move` command recognizes `blocked` as a valid target folder
- [x] `spearit-framework:move` plugin command recognizes `blocked` as a valid target folder
- [x] `spearit-framework-light:move` plugin command recognizes `blocked` as a valid target folder
- [x] Work item template includes optional external dependency metadata block
- [x] `fw-status` command counts and displays `blocked/` items separately

### Non-Functional Requirements

- [x] `blocked/` is clearly distinct from `backlog/` (blocked ≠ deprioritized)
- [x] Process works for contractors tracking multiple external parties simultaneously
- [x] Periodic review of `blocked/` items is supported (visible in status/WIP views)

---

## Design Notes

**Why not use a tag or status field in `backlog/`?**

Invisible. Status fields don't appear in folder listings, `fw-status` output, or git status. A dedicated folder makes blocked work visible at a glance — same reason `doing/` exists instead of a "in progress" tag.

**`blocked/` vs `hold/`**

`FEAT-030` already proposes a `hold/` folder. These are different:
- `hold/` — paused by choice (deprioritized, deferred)
- `blocked/` — paused by external constraint (blocked, not a choice)

Both may be worth implementing. They should not be merged.

**Periodic review**

Items in `blocked/` need occasional human review — the external party may have resolved the issue without notifying you, or the expected resolution date may have passed. Consider a lightweight review prompt in `fw-backlog` or `fw-status` that surfaces stale `blocked/` items.

---

## Prototype

File Anthropic plugin namespace collision bug as the first `blocked/` item (see BUG-144). Use that to validate the metadata schema and transition flow before finalizing the process documentation.

---

## Acceptance Criteria

- [x] `blocked/` folder added to framework and starter template
- [x] Transition matrix updated in workflow guide
- [x] Per-transition checklists written for `→ blocked/` and `blocked/ →`
- [x] `fw-move` updated to accept `blocked` as target
- [x] `spearit-framework:move` updated to accept `blocked` as target
- [x] `spearit-framework-light:move` updated to accept `blocked` as target
- [x] Work item template updated with optional blocked-by metadata
- [x] `fw-status` shows `blocked/` item count
- [x] Prototype item (Anthropic namespace bug) successfully tracked through the new flow

---

**Last Updated:** 2026-02-19

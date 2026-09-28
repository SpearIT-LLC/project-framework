# Tech Debt: Define Sub-Task/Parent Work Item Pattern

**ID:** TECH-082
**Type:** Tech Debt
**Priority:** Low
**Version Impact:** PATCH
**Created:** 2026-01-23
**Legacy:** TASK-218 C6 — board convention; closing it is owned by TASK-223
**Status:** Cancelled
**Cancelled Date:** 2026-09-28
**Cancellation Reason:** Superseded — the convention was decided and built by TASK-219 (released in framework-dev v0.5.0). The acceptance criteria below target the old tree (`framework/docs/`, old templates) and will not be met there.
**Theme:** Workflow

---

## Summary

Define a pattern for parent/child work item relationships, similar to Jira sub-tasks. Currently the framework has no formal way to link discovered work back to a parent item.

---

## Problem Statement

**What is the current state?**

- Work items are independent with their own IDs
- `Depends On` field exists for dependencies
- No `Parent` field for sub-task relationships
- When work is discovered during a feature, it gets separate IDs with no formal link
- FEAT-025 discovered 14 issues → created TECH-068 to TECH-081 as independent items

**Why is this a problem?**

- Parent item completion status unclear when sub-work exists
- No way to see all work spawned from a feature
- Jira-like sub-task pattern is familiar and useful

**What is the desired state?**

- Optional `Parent` field in work item templates
- Guidance on when to use sub-tasks vs. separate items
- Clear rules for parent completion when sub-tasks exist

---

## Proposed Solution

1. Add optional `Parent` field to work item templates:
   ```markdown
   **ID:** TECH-074
   **Type:** Tech Debt
   **Parent:** FEAT-025  <!-- Optional: links to parent item -->
   ```

2. Document sub-task pattern in workflow-guide.md:
   - When to create sub-tasks vs. separate items
   - Parent completion rules (can close parent when sub-tasks deferred?)
   - How sub-tasks affect WIP limits (do they count separately?)

3. Update work item templates with optional `Parent` field

**Files Affected:**
- `framework/templates/work-items/*.md` - Add Parent field
- `framework/docs/collaboration/workflow-guide.md` - Add sub-task guidance

---

## Acceptance Criteria

- [ ] `Parent` field added to work item templates (optional, commented out by default)
- [ ] Sub-task pattern documented in workflow-guide.md

---

## Notes

Discovered during FEAT-025 wrap-up discussion. The pattern is familiar from Jira and would help track related work.

---

## Related

- FEAT-025: Manual Setup Validation (inspired this pattern need)

---

## Closing Note (2026-09-28)

Settled by **TASK-219** (Group 1, decided 2026-09-09; archived at `project-hub/history/releases/framework-dev/v0.5.0/`), and closed here per **TASK-223**'s "every source card is closed" criterion. Outcome: both mechanisms adopted, for different jobs. A dotted id means tight coupling: the child dies with the parent and counts as one WIP item. A `Parent:` field means provenance: the child stands alone and counts as its own item. Rule: does it make sense on its own? Yes, use `Parent:`; no, use a dotted id. Lives in the comment header of `workspaces/framework/templates/records/work-item.md`.

The unchecked criteria above were written against the old framework and are left as-is on purpose: ticking them would claim work that was not done there.

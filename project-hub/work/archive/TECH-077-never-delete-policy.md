# Tech Debt: Document "Never Delete" Work Item Policy

**ID:** TECH-077
**Type:** Tech Debt
**Priority:** Medium
**Version Impact:** PATCH
**Created:** 2026-01-23
**Legacy:** TASK-218 C6 — board convention; closing it is owned by TASK-223
**Status:** Cancelled
**Cancelled Date:** 2026-09-29
**Cancellation Reason:** Superseded — the never-delete rule is written in the new board's README (Rules: "Never delete a card"), the move engine never deletes a card, and the check that enforces it is TECH-253's PreToolUse hook (deny `rm`/`git rm`/`Remove-Item` on a board card). The acceptance criteria below target the old `workflow-guide.md`. Closed by TASK-223.
**Theme:** Workflow

---

## Summary

Document a policy that work items should never be deleted, only archived. Deletion leaves unexplained ID gaps that make audit/history reconstruction difficult.

---

## Problem Statement

**What is the current state?**

- BUG-017 was created as test artifact, then deleted
- This left a gap in ID sequence (BUG-016 → BUG-018)
- No record exists explaining why ID 017 is missing
- No documented policy against deletion

**Why is this a problem?**

- Future ID scans show unexplained gaps
- Audit trail is incomplete
- History reconstruction is difficult
- No way to know if gap was intentional or data loss

**What is the desired state?**

- Clear policy: "Never delete work items"
- Archive cancelled/test items to `project-hub/history/archive/`
- Add cancellation note explaining why item was retired
- Preserves complete ID history and audit trail

---

## Proposed Solution

Add "Work Item Retention Policy" section to workflow-guide.md:

```markdown
## Work Item Retention Policy

**Rule:** Never delete work items. Archive instead.

**Rationale:** Deletion leaves unexplained gaps in ID sequences. Archived items preserve complete history and audit trail.

**For cancelled items:**
1. Update work item with cancellation reason
2. Add `**Status:** Cancelled` and date
3. Move to `project-hub/history/archive/` using `git mv`

**For test/temporary items:**
1. Mark as `**Status:** Test Artifact`
2. Note the parent test (e.g., "Created for FEAT-007 testing")
3. Move to `project-hub/history/archive/` using `git mv`

**Result:** All IDs are accounted for. No unexplained gaps.
```

**Files Affected:**
- `framework/docs/collaboration/workflow-guide.md` - Add retention policy section

---

## Acceptance Criteria

- [ ] "Never delete" policy documented in workflow-guide.md
- [ ] Process for archiving cancelled items documented
- [ ] Process for archiving test artifacts documented

---

## Notes

This policy supports TECH-069 (cancellation process) by ensuring cancelled items are archived rather than deleted.

---

## Related

- FEAT-025: Manual Setup Validation (source of finding)
- TECH-069: Work item cancellation process

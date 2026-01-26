# Tech Debt: Document Session Handoff Checklist

**ID:** TECH-071
**Type:** Tech Debt
**Priority:** Medium
**Version Impact:** PATCH
**Created:** 2026-01-23

---

## Summary

The framework provides context sources for cross-session continuity but no documented checklist for ending a session or starting a new one.

---

## Problem Statement

**What is the current state?**

- Framework provides session history, work items in doing/, PROJECT-STATUS.md
- No documented checklist for ending a session
- No documented checklist for starting a new session
- Relies heavily on tool features (Claude Code continuation) rather than framework structure
- No guidance on minimum context to capture for session transitions

**Why is this a problem?**

- Context may be lost between sessions if not captured
- New sessions may start without sufficient understanding
- Inconsistent session handoff quality

**What is the desired state?**

- Clear end-of-session checklist
- Clear start-of-session checklist
- Consistent session transitions

---

## Proposed Solution

Add session handoff checklists to workflow documentation:

**Proposed End of Session Checklist:**
1. Ensure work in progress has clear next steps documented in work item
2. Update session history with current status
3. Note any blockers or decisions needed in work item
4. Commit all changes with descriptive message

**Proposed Start of Session Checklist:**
1. Read work items in `doing/` folder
2. Read most recent session history
3. Check PROJECT-STATUS.md for current version
4. Confirm understanding before proceeding

**Optional: Claude Code Continuation**
- If using Claude Code, the continuation feature can bridge sessions
- Still recommended to follow checklists for context preservation

**Files Affected:**
- `framework/docs/collaboration/workflow-guide.md` - Add Session Handoff section

---

## Acceptance Criteria

- [ ] End of session checklist documented
- [ ] Start of session checklist documented
- [ ] Guidance on minimum context to preserve
- [ ] Integration with session history documented

---

## Notes

Discovered during FEAT-025 validation testing. FEAT-014 in project-hello-world tested cross-session continuity and found no documented process.

Findings from testing:
- Session history + work item in doing/ provided sufficient context
- Claude Code's continuation feature was critical for bridging sessions
- Without continuation, would need to read multiple files to reconstruct context

---

## Related

- FEAT-025: Manual Setup Validation (source of finding)
- TECH-072: Session history template

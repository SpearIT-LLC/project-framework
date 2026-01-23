# Tech Debt: Reconcile Spike Workflow vs Transition Matrix

**ID:** TECH-075
**Type:** Tech Debt
**Priority:** Medium
**Version Impact:** PATCH
**Created:** 2026-01-23

---

## Summary

The workflow-guide.md contains contradictory information about whether spikes can skip the `todo/` folder.

---

## Problem Statement

**What is the current state?**

- **Transition matrix (lines 348-378):** States `backlog → doing` is **INVALID** for ALL work items
- **Spike flow section (lines 458-498):** States spikes can go directly from `backlog/` to `doing/`

These directly contradict each other.

**Why is this a problem?**

- AI/users following transition matrix will reject valid spike workflow
- AI/users following spike section will violate transition matrix
- Inconsistent enforcement depending on which section is read

**What is the desired state?**

- Consistent documentation
- Clear rules for spike workflow
- Transition matrix accurately reflects all valid transitions

---

## Proposed Solution

**Option A: Update transition matrix to allow spike exception**

Add exception to transition matrix:
```markdown
| From     | To      | Valid | Notes |
|----------|---------|-------|-------|
| backlog  | doing   | NO*   | *Exception: Spikes may bypass todo/ |
```

**Option B: Update spike flow to require todo/**

Change spike workflow to:
1. Create spike in backlog/
2. Move to todo/ when ready to investigate
3. Move to doing/ when starting investigation
4. Move to done/ or archive when complete

**Recommendation:** Option A

Spikes are inherently exploratory and time-boxed. Requiring them to sit in `todo/` adds process overhead without value. The transition matrix should acknowledge this exception.

**Files Affected:**
- `framework/docs/collaboration/workflow-guide.md` - Update transition matrix OR spike section
- `templates/standard/framework/docs/collaboration/workflow-guide.md` - Sync changes

---

## Acceptance Criteria

- [ ] Transition matrix and spike section are consistent
- [ ] Exception (if any) is clearly documented
- [ ] Template synced to templates/standard/

---

## Notes

Discovered during FEAT-025 validation testing. This was noted in SETUP-VALIDATION-NOTES.md under "Confusing Steps".

---

## Related

- FEAT-025: Manual Setup Validation (source of finding)

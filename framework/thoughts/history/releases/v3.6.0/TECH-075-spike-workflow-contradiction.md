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

**Consolidate spike workflows - spikes use `poc/` folder, not `work/doing/`**

The current documentation incorrectly shows research spikes going through `work/doing/`. This contradicts the transition matrix AND the intent of the `poc/` folder (introduced in FEAT-062).

**Correct consolidated workflow (preferred path - direct to poc/):**

```
poc/SPIKE-NNN-description/
    ├── SPIKE-NNN-description.md
    └── [code artifacts, if any]
    ↓ (findings documented, investigation complete)
history/spikes/SPIKE-NNN-description/
    ├── SPIKE-NNN-description.md
    └── [code artifacts, if any]
```

Optionally, spikes may be queued in `work/backlog/` first if not ready to start immediately.

**Key changes:**
1. Remove separate "Research Spike" and "POC Spike" workflow sections
2. Single spike workflow: `poc/` → `history/spikes/` (with optional `backlog/` queue)
3. The only difference between spikes is whether code artifacts exist in the folder
4. Transition matrix remains accurate (spikes never go through `work/doing/`)
5. Preferred path is direct to `poc/` - less ceremony for exploratory work

**Why this resolves the contradiction:**
- Spikes don't use `work/doing/` at all, so the transition matrix stays correct for standard work items
- No exception needed - spikes simply follow a different path (`poc/` instead of `work/`)

**Files Affected:**
- `framework/docs/collaboration/workflow-guide.md` - Consolidate spike flow section (lines 634-678)
- `templates/standard/framework/docs/collaboration/workflow-guide.md` - Sync changes

---

## Acceptance Criteria

- [x] Spike flow section consolidated to single workflow using `poc/` folder
- [x] Research spike / POC spike distinction removed (workflow is same, only artifacts differ)
- [x] Transition matrix remains accurate (no exceptions needed)
- [x] Template synced to templates/standard/

---

## Notes

Discovered during FEAT-025 validation testing. This was noted in SETUP-VALIDATION-NOTES.md under "Confusing Steps".

---

## Related

- FEAT-025: Manual Setup Validation (source of finding)

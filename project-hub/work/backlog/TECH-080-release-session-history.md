# Tech Debt: Add Release to Session History Step

**ID:** TECH-080
**Type:** Tech Debt
**Priority:** Low
**Version Impact:** PATCH
**Created:** 2026-01-23
**Theme:** Workflow

---

## Summary

Release process doesn't mention updating session history. Session history updates are only tied to `done/` transitions via `/fw-move`. Releases should also be documented in session history.

---

## Problem Statement

**What is the current state?**

- Release process in version-control-workflow.md (lines 171-210) has no session history step
- Session history updates only happen via `/fw-move` to done/
- Release events (version bump, tag creation) not captured in session history

**Why is this a problem?**

- Session history is incomplete - missing release milestones
- Cross-session context lacks release information
- Have to check git tags or CHANGELOG to find release history

**What is the desired state?**

- Release events documented in session history
- Session history serves as complete work log including releases

---

## Proposed Solution

Add session history step to release process in version-control-workflow.md:

```markdown
### Post-Release

- [ ] Archive done/ items to releases/vX.Y.Z/
- [ ] **Update session history with release:**
  ```markdown
  ## Release: vX.Y.Z

  **Released:** YYYY-MM-DD
  **Type:** MAJOR | MINOR | PATCH

  ### Included Work Items
  - FEAT-NNN: [Description]
  - BUG-NNN: [Description]

  ### Release Notes
  [Brief summary of what this release includes]
  ```
- [ ] Commit all post-release changes
```

**Files Affected:**
- `framework/docs/process/version-control-workflow.md` - Add session history step

---

## Acceptance Criteria

- [ ] Session history update added to post-release checklist
- [ ] Format for release entry in session history documented

---

## Notes

This complements TECH-078 (release archival) - both are post-release steps that should happen together.

Consider enhancing `/fw-session-history` command to include a release entry format option.

---

## Related

- FEAT-025: Manual Setup Validation (source of finding)
- TECH-078: Release archival process
- TECH-072: Session history template

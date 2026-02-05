# Tech Debt: Document Release Archival Process

**ID:** TECH-078
**Type:** Tech Debt
**Priority:** Medium
**Version Impact:** PATCH
**Created:** 2026-01-23

---

## Summary

Document that work items in `done/` must be archived to `project-hub/history/releases/vX.Y.Z/` immediately after each release. Current release process doesn't enforce this step.

---

## Problem Statement

**What is the current state?**

- FEAT-015 testing: v1.0.1 was released but done/ items weren't archived
- Required separate cleanup operation after the fact
- Release process in version-control-workflow.md doesn't mention archival
- done/ folder can accumulate items across multiple releases

**Why is this a problem?**

- done/ becomes cluttered with items from multiple releases
- Unclear which items belong to which release
- Release history is not self-contained
- Easy to forget archival step

**What is the desired state?**

- Archival is explicit step in release checklist
- Each release has its items archived to `releases/vX.Y.Z/`
- done/ is empty after each release
- Release history is organized by version

---

## Proposed Solution

Add archival step to release process in version-control-workflow.md:

```markdown
## Release Checklist

### Pre-Release
- [ ] All work items for this release are in done/
- [ ] CHANGELOG.md updated with all changes
- [ ] PROJECT-STATUS.md version updated

### Release
- [ ] Commit all changes
- [ ] Tag release: `git tag -a vX.Y.Z -m "Release vX.Y.Z"`
- [ ] Push tag if using remote

### Post-Release (REQUIRED)
- [ ] Create `project-hub/history/releases/vX.Y.Z/` folder
- [ ] Move all items from done/ to releases/vX.Y.Z/ using `git mv`
- [ ] Verify done/ is empty
- [ ] Commit archival: `git commit -m "Archive vX.Y.Z work items"`
- [ ] Update session history with release notes
```

**Files Affected:**
- `framework/docs/process/version-control-workflow.md` - Add post-release archival step

---

## Acceptance Criteria

- [ ] Post-release archival step added to version-control-workflow.md
- [ ] Archival folder naming convention documented (releases/vX.Y.Z/)
- [ ] `git mv` usage specified (not regular mv)
- [ ] Empty done/ verification included

---

## Notes

Consider adding this to `/fw-move` command when moving to done/ - prompt for release archival if done/ has items and a new release is being prepared.

---

## Related

- FEAT-025: Manual Setup Validation (source of finding)
- TECH-079: Empty release guard

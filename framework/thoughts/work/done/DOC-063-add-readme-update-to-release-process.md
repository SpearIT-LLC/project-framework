# DOC-063: Add README Update Step to Release Process

**ID:** 063
**Type:** Documentation
**Priority:** Low
**Status:** Doing
**Created:** 2026-01-19
**Version Impact:** PATCH

---

## Summary

Add "Update README" as an explicit step in the release process documentation.

---

## Problem Statement

During the v3.3.0 release, we discovered the README wasn't updated with new features until prompted. The release process should explicitly include a README review step to ensure user-facing documentation reflects released capabilities.

---

## Proposed Solution

Add a step to the release process in workflow-guide.md:

**Before:**
1. Calculate version
2. Update CHANGELOG.md
3. Update PROJECT-STATUS.md
4. Move work items to releases/
5. Commit and tag

**After:**
1. Calculate version
2. Update CHANGELOG.md
3. Update PROJECT-STATUS.md
4. **Update README.md** (if new features affect user-facing documentation)
5. Move work items to releases/
6. Commit and tag

---

## Acceptance Criteria

- [x] workflow-guide.md release process includes README update step
- [x] CLAUDE.md Step 9 references README check

---

## Notes

This is a process improvement identified during v3.3.0 release (FEAT-059, FEAT-037).

---

**Last Updated:** 2026-01-19

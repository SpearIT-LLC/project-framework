# Bug: Incomplete Release Checklist - Missing Build Archive Step

**ID:** BUG-113
**Type:** Bug
**Priority:** High
**Version Impact:** PATCH
**Created:** 2026-02-06
**Theme:** Workflow

---

## Summary

The release checklist in `framework/docs/process/version-control-workflow.md` is incomplete - it doesn't include building the distribution archive, which is a critical deliverable for each release.

---

## Problem Statement

**What's broken?**

The release checklist (lines 112-149 in version-control-workflow.md) documents the complete release process but omits a critical step: building the distribution archive with `Build-FrameworkArchive.ps1`.

**Current state:**
- Checklist includes: update files, commit, tag, archive work items
- Checklist **missing**: build distribution ZIP with new version number

**Expected state:**
- Complete checklist that produces a releasable distribution package
- Build archive step included in appropriate location (likely after tagging)

**Impact:**
- Releases can be "complete" per checklist but not actually distributable
- Discovered during v5.1.0 release when following the checklist
- No distribution package was created until we noticed the omission

---

## Steps to Reproduce

1. Follow the release checklist in `framework/docs/process/version-control-workflow.md`
2. Complete all steps successfully
3. Notice: no distribution ZIP created in `distrib/`
4. Realize critical deliverable is missing from process

---

## Root Cause

The release checklist was written before the distribution package workflow (FEAT-005) was fully implemented. The checklist documents git/version control operations but doesn't include the build artifact creation that's required for user-facing releases.

---

## Proposed Fix

Update `framework/docs/process/version-control-workflow.md` release checklist to include:

**Add to Post-Release section (after line 144):**

```markdown
Post-Release:
[ ] Build distribution archive: .\tools\Build-FrameworkArchive.ps1
    - Creates SpearIT-Framework-vX.Y.Z.zip in distrib/
    - Version automatically read from PROJECT-STATUS.md
    - Validates no unreleased items in done/ folder
[ ] Verify tag pushed to origin: git tag -l vX.Y.Z
[ ] Archive: work/done/*.md → history/releases/vX.Y.Z/
[ ] Update CLAUDE.md if architecture/standards changed
[ ] Update roadmap.md status for completed work items
```

**Rationale:**
- Build archive **after** tagging ensures version tag exists for reference
- Build archive **after** file updates ensures correct version in package
- Place in Post-Release makes sense: tag is created, now create distributable

---

## Acceptance Criteria

- [ ] Release checklist includes build archive step
- [ ] Build archive step positioned logically in workflow
- [ ] Build archive step includes script path and purpose
- [ ] Note added about version being read from PROJECT-STATUS.md
- [ ] Following updated checklist produces complete release (git tag + ZIP)

---

## Related Work Items

- **FEAT-005:** ZIP Distribution Package - Implemented the build script
- **FEAT-099:** /fw-release Command - Will automate this entire process (future)
- **FEAT-028:** Release Automation Script - Older automation concept
- **Discovered during:** v5.1.0 release (2026-02-06)

---

## Notes

**Discovery context:**
- Completed all release checklist steps for v5.1.0
- User asked: "Should we build the archive?"
- Realized checklist doesn't mention this critical step
- User identified this as "top priority workflow bug to fix"

**Why high priority:**
- Affects every release going forward
- Core deliverable missing from documented process
- Easy fix, high impact

**Future automation:**
- FEAT-099 will eventually automate entire release process
- Until then, checklist must be accurate for manual execution

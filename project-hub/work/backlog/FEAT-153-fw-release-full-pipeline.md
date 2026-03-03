# Feature: /fw-release Full Pipeline — Include Distribution Build

**ID:** FEAT-153
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-03-02
**Theme:** Workflow

**Depends On:** BUG-152

---

## Summary

Extend `/fw-release` to run the full release pipeline end-to-end, including building and committing the distribution ZIP artifact (`distrib/framework/`). Currently the command stops after archiving work items, leaving the distribution build as a manual step.

---

## Problem Statement

After `/fw-release` completes, the developer must manually run `Build-FrameworkArchive.ps1` and commit the resulting ZIP. This breaks the "one command" release experience and is easy to forget — the distribution artifact can fall out of sync with the tagged version.

Industry norm: release pipelines produce artifacts. A release without its artifact is incomplete.

---

## Proposed Solution

Add a **Step 8: Build Distribution** between the archive step and the summary:

```
Step 6: Git commit + tag
Step 7: Archive work items → commit
Step 8: Build distribution ZIP → commit   ← NEW
Step 9: Release summary
```

### Step 8 Detail

```bash
# Check if a build script exists for this product
# For 'framework' product: tools/Build-FrameworkArchive.ps1

powershell -ExecutionPolicy Bypass -File tools/Build-FrameworkArchive.ps1

# Stage and commit the updated ZIP
git add distrib/framework/
git commit -m "chore: Build distribution archive v5.3.0"
```

If the build script is not found or fails:
- Warn the user: "⚠️ Distribution build failed or not configured — skipping"
- Continue to summary (do not block the release)
- Note in summary: "Distribution artifact: NOT built (see warning above)"

### Configuration

Add optional `build_script` field to product config in `framework.yaml`:

```yaml
release:
  products:
    - id: framework
      label: "SpearIT Project Framework"
      priority: 1
      archive_path: "history/releases/framework"
      build_script: "tools/Build-FrameworkArchive.ps1"   # ← NEW (optional)
```

If `build_script` is absent, skip the build step silently (backwards compatible).

---

## Acceptance Criteria

- [ ] `framework.yaml` supports optional `build_script` per product
- [ ] `/fw-release framework` runs `Build-FrameworkArchive.ps1` after archival
- [ ] Build output is staged and committed as a separate commit
- [ ] Build failure produces a warning but does not abort the release
- [ ] If `build_script` is not configured, step is silently skipped
- [ ] Release summary reflects whether the build ran and succeeded
- [ ] Tested end-to-end: tag created, work items archived, ZIP updated in one command

---

## CHANGELOG Notes

```markdown
### Changed
- `/fw-release` now runs the full pipeline including distribution build
  - Invokes `build_script` from `framework.yaml` product config after archiving work items
  - Build output committed as `chore: Build distribution archive vX.Y.Z`
  - Build failure is non-fatal — warns and continues to summary
  - No `build_script` configured → step silently skipped (backwards compatible)
```

---

## Notes

- Depends on BUG-152 being resolved first (archival script bugs should be fixed before extending the pipeline)
- `build_script` path is relative to repo root
- For multi-product repos, each product can have its own build script or none

---

**Last Updated:** 2026-03-02

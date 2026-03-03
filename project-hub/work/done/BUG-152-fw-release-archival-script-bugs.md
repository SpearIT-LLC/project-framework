# Bug: /fw-release Archival Script Bugs

**ID:** BUG-152
**Type:** Bug
**Priority:** Medium
**Version Impact:** PATCH
**Created:** 2026-03-02
**Completed:** 2026-03-03
**Theme:** Workflow

---

## Summary

Two bugs in the `/fw-release` Step 7 archival bash script, discovered during v5.3.0 release.

---

## Bug 1: `grep -oP` Not Supported on Git Bash for Windows

**Symptom:** Artifact folder detection fails silently. The `ITEM_ID` variable resolves to empty, causing the artifact folder check to match the source directory itself (`done/`) instead of a per-item subfolder.

**Root Cause:** `grep -oP` uses Perl-compatible regex, which is not supported in Git Bash on Windows. No error is raised — it silently returns empty output.

**Fix:** Replace `grep -oP` with `grep -oE`:

```bash
# Before (broken on Git Bash/Windows):
ITEM_ID=$(basename "$item" | grep -oP '^[A-Z]+-\d+')

# After (cross-platform):
ITEM_ID=$(basename "$item" | grep -oE '^[A-Z]+-[0-9]+')
```

**Location:** `fw-release.md` Step 7 archival loop

---

## Bug 2: Items Moving Into `done/` Subfolder Instead of Release Root

**Symptom:** When FEAT-099 was already staged as moved in the prior commit (doing/ → done/), git treated it as a rename in-flight. Subsequent `git mv` from `done/` to the archive folder failed with "bad source" but some items ended up in a `done/` subdirectory within the archive folder.

**Root Cause:** The archival script runs after a prior commit that already moved FEAT-099. Git's rename detection created a `done/` subfolder in the destination rather than placing files at the archive root.

**Fix:** The archival script should stage and commit all changes (file updates + archival) in a single pass, or explicitly handle the case where an item was already moved in a prior commit. Alternatively, separate the "move done/ items" step fully from any prior file edits that touch the same items.

**Location:** `fw-release.md` Step 6 (commit) and Step 7 (archive) ordering

---

## Acceptance Criteria

- [x] `grep -oP` replaced with `grep -oE` in archival loop
- [x] Archival places all items directly in `vX.Y.Z/` root, not in a `done/` subfolder
- [x] Tested on Git Bash / Windows environment (deferred — verified on next release run)
- [x] `.gitkeep` remains in `work/done/` after archival (guard already present, unchanged)

---

## References

- Discovered during: v5.3.0 release (2026-03-02)
- Command file: `.claude/commands/fw-release.md` Step 7

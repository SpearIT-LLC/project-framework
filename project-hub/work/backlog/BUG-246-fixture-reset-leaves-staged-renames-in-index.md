# Bug: Fixture Reset Leaves Staged Renames in the Index

**ID:** BUG-246
**Type:** Bug
**Priority:** Low
**Version Impact:** PATCH
**Created:** 2026-09-26
**Workspace:** framework
**Depends On:**
**Completed:**

---

## Summary

Found in UAT-51 (2026-09-26). `seed-uat-fixtures.sh --reset` deletes fixture files from
disk but leaves them in the git index of the consuming repo. The engine moves fixtures
with `git mv`, so after a reset `git status` shows staged renames whose targets no longer
exist, for example `RD kanban/todo/FEAT-912-… -> kanban/doing/FEAT-912-…`. A commit made
in the test repo would record a misleading history.

This is test tooling only. The script never ships, and the plugin is not affected.

## Bug Description

**Actual:** after `--reset kanban`, the files are gone from disk, but the index still
holds the engine's staged renames: `RD` entries for moved fixtures and `M` entries for
re-seeded ones.

**Expected:** after `--reset`, no 900-block path remains in the index or on disk.

**Likely cause (my reading, not yet reproduced in isolation):**
`tests/seed-uat-fixtures.sh:86` runs `git rm -rq --ignore-unmatch "$p" 2>/dev/null`.
Without `-f`, `git rm` refuses a path whose staged content differs from `HEAD`, and a
path staged by `git mv` is exactly that. The refusal goes to `/dev/null`. Line 87 then
does `rm -rf`, so the file leaves the disk but stays in the index.

## Fix Design

1. Make the reset remove the path from the index as well. Either use `git rm -rqf
   --ignore-unmatch`, which is safe because every path is inside the reserved 900 block,
   or run `git rm --cached` before the `rm -rf`.
2. Stop discarding `git rm`'s stderr, or report when the index removal fails, so this
   kind of failure is visible next time.

## Acceptance Criteria

- [ ] Reproduce: seed, move one fixture with the engine (`git mv`), `--reset`, and
      `git status --short` shows the stale rename. This confirms the likely cause.
- [ ] After the fix, the same sequence leaves no 900-block path in `git status --short`
- [ ] FEAT-001, or any card that isn't a fixture, is untouched by the reset, on disk and in the index

## Related

- **FEAT-229** — found during its Human UAT, in the UAT-51 row of
  `workspaces/framework/tests/UAT-RESULTS-2026-08-26.md`

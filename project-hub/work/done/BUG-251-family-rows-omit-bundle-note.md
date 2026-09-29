# Bug: Family Member Rows Omit the Bundle Note

**ID:** BUG-251
**Type:** Bug
**Priority:** Low
**Version Impact:** PATCH
**Created:** 2026-09-28
**Workspace:** framework
**Depends On:**
**Completed:** 2026-09-29

---

## Summary

Found in UAT-56 (2026-09-28, installed 0.4.7). When a dotted family moves, a member that
wasn't named moves its bundle folder, but its `↳` row doesn't say so. The row for the named
record does (`(bundle FEAT-912.1/)`, UAT-48), and so do operations rows (UAT-33, BUG-225).
The folder moves correctly; only the report is missing the note.

## Bug Description

**Actual** (`/fw-move FEAT-912.2 hold`):

```
  OK         ↳ FEAT-912-family-parent.md
  OK         ↳ FEAT-912.1-family-child-one.md
  OK       FEAT-912.2-family-child-with-dep.md → hold/
```

`hold/FEAT-912.1/notes.txt` is on disk. The FEAT-912.1 row doesn't say it came along.

**Expected:** `OK         ↳ FEAT-912.1-family-child-one.md  (bundle FEAT-912.1/)`

**Cause:** `workspaces/framework/scripts/fw-move.sh:589-591`. The member loop moves
`$m_bundle`, then prints `row OK "  ↳ $m_base"` without the note that line 567 builds for
the named record.

## Proposed Solution

Build a note in the loop the same way as line 567, and append it to the `↳` row.

## Acceptance Criteria

- [x] Naming a family member whose sibling has a bundle prints `(bundle <ID>/)` on that sibling's `↳` row
      *(2026-09-29, scratch repo with seeded fixtures: `$K FEAT-912.2 hold` → `↳ FEAT-912.1-family-child-one.md  (bundle FEAT-912.1/)`)*
- [x] Naming the member that has the bundle is unchanged (UAT-48 output)
      *(`$K FEAT-912.1 todo` → `FEAT-912.1-family-child-one.md → todo/  (bundle FEAT-912.1/)`)*
- [x] Operations output unchanged (D2, UAT-33..36)
      *(UAT-33 shape re-run: identical rows, bundle inline on INC-902)*
- [x] UAT-56's expected output in `UAT-COMMANDS.md` shows the note

## Related

- **FEAT-229** — UAT-56 row in `workspaces/framework/tests/UAT-RESULTS-2026-08-26.md`
- **BUG-225** — inline bundle note on its own row (the convention this extends)
- **BUG-241** — a child's bundle is its own

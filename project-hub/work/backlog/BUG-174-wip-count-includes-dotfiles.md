# Bug: WIP / final-move count includes dotfiles (`.gitkeep`) — inflates count by 1

**ID:** BUG-174
**Type:** Bug
**Priority:** Low
**Version Impact:** PATCH
**Created:** 2026-07-07
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->
**Theme:** Workflow

---

## Summary

`.claude/scripts/fw-move.sh`'s item counts (WIP-limit warning and the post-move "final count")
exclude `.limit` but **not** `.gitkeep`, so every count is inflated by one. The file moves themselves
are correct — only the displayed count is wrong.

---

## Bug Description

**What is happening (actual behavior)?**

The count of items in a folder includes the `.gitkeep` placeholder. Observed 2026-07-07:
- Moving into `doing/` (holding 1 real item + `.gitkeep`) reported `WIP limit: 2/2` (should be 1/2),
  then `3/2` mid-batch.
- Moving into `done/` (holding 4 real items + `.gitkeep`) reported `done/: 5/∞` (should be 4).

**What should happen (expected behavior)?**

Counts should reflect only real work items — i.e. ignore all dotfiles (`.limit`, `.gitkeep`, and any
future `.`-prefixed control files), not just `.limit`.

**Impact:**

- **Cosmetic/misleading only.** No incorrect move is performed and no hard-block misfires — the WIP
  limit is warning-only, and the final count is display text. But the off-by-one erodes trust in the
  numbers and could mask a real WIP breach (a folder at limit reads as over; a folder one under limit
  reads as at-limit).

---

## Reproduction Steps

**Environment:** any; bash engine.

**Steps to Reproduce:**

1. Ensure a work folder (e.g. `doing/`) contains its `.gitkeep` (and `.limit`) plus N real `.md` items.
2. Run `bash .claude/scripts/fw-move.sh <id> doing`.
3. Observe the reported count is `N+1`, not `N`.

**Reproducibility:** Always (deterministic).

---

## Root Cause Analysis

**File(s) Affected:**
- `.claude/scripts/fw-move.sh` — **line 340** (WIP-limit warning) and **line 515** (final count).

**Root Cause:**

Both counts use:
```bash
find "$WORK_DIR/<folder>" -type f ! -name ".limit" | wc -l
```
The `! -name ".limit"` filter excludes only `.limit`. `.gitkeep` (present in every work folder as the
git placeholder) is a regular file, so `find -type f` counts it. Result: every count is +1.

**Verified NOT affected:** the other `find -type f` sites (`find_parent` ~L120, `find_children` ~L131,
dependency scan ~L196) pipe through `grep -iE "[-]<id>..."`, so dotfiles never match — those are safe.
Only the two bare count sites have the flaw.

**Why was this missed?**

`.gitkeep` is invisible in normal `ls` and the off-by-one looks plausible until you count by hand. The
count is display-only, so nothing failed loudly. Surfaced 2026-07-07 during BUG-170 verification when
`done/` reported "5" for 4 items.

---

## Fix Design

**Approach:** Exclude all dotfiles from both counts, not just `.limit`.

**File:** `.claude/scripts/fw-move.sh` (lines 340 and 515)

**Before:**
```bash
find "$WORK_DIR/doing" -type f ! -name ".limit" | wc -l   # L340
find "$WORK_DIR/$TARGET" -type f ! -name ".limit" | wc -l # L515
```

**After (option a — exclude all dotfiles; preserves "any extension" support):**
```bash
find "$WORK_DIR/doing" -type f ! -name ".*" | wc -l
find "$WORK_DIR/$TARGET" -type f ! -name ".*" | wc -l
```

**Explanation:** `! -name ".*"` drops `.limit`, `.gitkeep`, and any future control dotfile in one
rule, while still counting work items of any extension (the engine deliberately supports non-`.md`
items per its header). Verify `find` on the target platform treats `! -name ".*"` as intended (it
matches basenames, so nested paths are unaffected here since the folders are flat).

*Alternative (option b): count only `*.md`.* Simpler, but contradicts the engine's stated
"any file extension" support — rejected unless we decide items are always markdown.

---

## Testing

### Verification Steps

1. With `doing/` holding 1 real item + `.gitkeep` + `.limit`, run a move into `doing/` → expect `1/2`.
2. With `done/` holding N real items + `.gitkeep`, run a move into `done/` → expect the count = N (+1
   for the just-moved item), not N+2.

### Regression Testing

- [ ] Parent/child/dependency resolution unaffected (those paths use `grep`, not the count).
- [ ] WIP-limit warning still fires correctly at the real limit.
- [ ] Counts match a hand count (`ls *.md | wc -l`) in doing/ and done/.

---

## Related

- **BUG-170** — surfaced this during end-to-end verification (the `done/: 5/∞` report for 4 items).
- Both count sites live in the engine relocated by BUG-170 (`.claude/scripts/fw-move.sh`).

---

## Notes

- Two-line fix, but touches the same file TECH-173 will modify (enforcement wiring). If TECH-173 is
  implemented first, fold this in there to avoid two passes over the count logic; otherwise it's an
  independent quick fix.

---

**Last Updated:** 2026-07-07

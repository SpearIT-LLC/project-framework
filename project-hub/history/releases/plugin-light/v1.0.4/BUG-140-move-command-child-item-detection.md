# Bug: Move Command - Child Item Detection Broken

**ID:** BUG-140
**Type:** Bug
**Priority:** Medium
**Created:** 2026-02-17
**Completed:** 2026-02-17
**Theme:** Workflow

---

## Summary

The `move` command in both plugins fails to find work items whose IDs contain a dot (e.g., `FEAT-127.4`), and the child item detection logic is inverted — it excludes children when finding the parent but doesn't correctly gather them for the move.

---

## Problem Statement

**Bug 1: Items with dots in ID not found**

The find command uses `grep -v "\."` to filter results, intended to exclude child items when searching for a parent. But this also excludes any item whose filename contains a dot — including child items themselves (e.g., `FEAT-127.4-*.md`).

```bash
# This grep -v "\." drops FEAT-127.4-*.md from results entirely
SOURCE=$(find project-hub/work -type f -iname "${ITEM_ID}-*.md" 2>/dev/null | grep -v "\." | head -1)
```

**Bug 2: Move intent is wrong**

When moving `FEAT-127`, the intent is:
- Find `FEAT-127-*.md` (the parent) — **exclude** child pattern `FEAT-127.N-*.md`
- Also find and move all `FEAT-127.N-*.md` (children) together

The current logic attempts this but the grep filter is applied to the wrong search, causing both parent and child lookups to fail.

**Expected behavior:**

```
/move FEAT-127 done       → moves FEAT-127-*.md + FEAT-127.1-*.md + FEAT-127.2-*.md etc.
/move FEAT-127.4 todo     → moves FEAT-127.4-*.md only (no children)
/move FEAT-136 todo       → moves FEAT-136-*.md (no dot in ID, must still work)
```

---

## Root Cause

The `grep -v "\."` filter was added to distinguish parent from child filenames, but dots appear in all child filenames AND in the path separators (`project-hub/work/backlog/`). The filter is unreliable for both purposes.

**Correct approach:**

To find a parent item (excluding children), match the exact ID pattern without a dot after the ID:

```bash
# Find parent only: FEAT-127-*.md but NOT FEAT-127.1-*.md
SOURCE=$(find project-hub/work -type f -iname "${ITEM_ID_UPPER}-*.md" 2>/dev/null \
  | grep -v "/${ITEM_ID_UPPER}\." | head -1)
```

To find children:
```bash
# Find children: FEAT-127.*.md
CHILDREN=$(find project-hub/work -type f -iname "${ITEM_ID_UPPER}.*-*.md" 2>/dev/null)
```

---

## Affected Files

- `plugins/spearit-framework/commands/move.md`
- `plugins/spearit-framework-light/commands/move.md`

Both use identical logic and need the same fix.

---

## Acceptance Criteria

- [x] `/move FEAT-127 done` moves parent + all FEAT-127.N children
- [x] `/move FEAT-127.4 todo` moves only FEAT-127.4 (no children)
- [x] `/move FEAT-136 todo` works (no dot in ID)
- [x] `/move feat-136 todo` works (case insensitive)
- [x] Edge case: item with no children moves correctly
- [x] Edge case: item not found reports clear error

---

## Notes

Discovered when moving FEAT-136 and FEAT-127.4 — both failed with "could not find work item" and had to be moved manually with `git mv`.

The workaround (direct `git mv`) works fine during development but the command should handle all cases correctly.

---

**Last Updated:** 2026-02-17

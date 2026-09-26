# Tech: Invalid-Transition Refusal Lists the Whole Table

**ID:** TECH-247
**Type:** Tech
**Priority:** Low
**Version Impact:** PATCH
**Created:** 2026-09-26
**Workspace:** framework
**Depends On:**
**Completed:**

---

## Summary

Found in UAT-52 and also visible in UAT-38 (2026-09-26). When a move isn't allowed, the
engine lists every allowed `from:to` pair in the namespace. On the kanban board that is 23
pairs. The user only needs the moves out of the folder the record is in now.

## Problem Statement

`scripts/fw-move.sh:540`:

```
invalid transition backlog → done (allowed: backlog:todo todo:backlog todo:doing … doing:cancelled)
```

The refusal is meant to teach: the `/fw-new` and `/fw-move` commands tell the AI to quote
it verbatim because of that. But the useful part, where the record *can* go, is hidden in
a list of pairs, most of which start somewhere else.

## Proposed Solution

Filter `$NS_TRANSITIONS` to the pairs that start at `$SOURCE`, and print only the targets:

```
invalid transition backlog → done (from backlog: todo, blocked, hold, cancelled)
```

The table itself doesn't change. This only changes how the refusal renders it. The line
is shared, but operations can't reach it today. Its table
(`open:onhold onhold:open open:closed onhold:closed`, `fw-move.sh:57`) allows every move
out of a live folder. A move to the same folder is a skip, and `closed` is terminal. So
the change affects only kanban.

## Acceptance Criteria

- [ ] `$K FEAT-901 done` from `backlog/` prints `(from backlog: todo, blocked, hold, cancelled)`, with no pairs that start in another folder
- [ ] A folder with few exits renders cleanly (`accept` → `from accept: doing, done`), and D2 (UAT-33..36) still passes unchanged
- [ ] UAT-38 and UAT-52's expected text in `UAT-COMMANDS.md` updated to the new form; the other checks in those cases are unchanged

## Related

- **FEAT-229** — kanban UAT, rows UAT-38 and UAT-52 in `workspaces/framework/tests/UAT-RESULTS-2026-08-26.md`

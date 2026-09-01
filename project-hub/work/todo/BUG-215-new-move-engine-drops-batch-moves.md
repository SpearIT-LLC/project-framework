# Bug: New Move Engine Drops Batch Moves

**ID:** BUG-215
**Type:** Bug
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-09-01
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

The ADR-009 build's `fw-move.sh` accepts exactly one id per invocation. The old engine
accepts a list — `fw-move 001,002,003 todo` — so moving several records now costs one
command each.

Found 2026-09-01 while discussing the operations/kanban convergence (TASK-213). Gary:
"before we used to be able to move multiple cards in one pass using `fw-move
001,002,003 todo`. Now we have to add the prefix which makes the command longer to
enter."

**Note on the prefix half of that report:** bare numerics already work in the new
engine — `case "$PREFIX" in ""|INC|REQ) NS="operations"` maps an empty prefix to
operations, so `fw-move.sh 12 closed` is valid today. What was actually lost is the
**batch**, not the bare form. Recorded because the two are easy to conflate.

## Evidence

New engine (`workspaces/framework/scripts/fw-move.sh`):

```bash
[ ${#ARGS[@]} -eq 2 ] || { echo "Usage: fw-move.sh <id> <open|onhold|closed> ..." >&2; exit 1; }
```

Old engine (`.claude/scripts/fw-move.sh`), which documents and implements the list:

```bash
#   bash .claude/scripts/fw-move.sh "FEAT-145, FEAT-146" todo
IFS=', ' read -ra TOKENS <<< "$RAW_LIST"
```

The old `/fw-move` command doc advertises `/fw-move "FEAT-042, 043" todo` and batch
examples; the new engine's does not.

## Reproduction

1. In a repo with an operations workspace holding open records 1, 2, 3.
2. `bash fw-move.sh "1, 2, 3" closed --resolution resolved`
3. Observe: usage error, exit 1. Each record must be moved by its own invocation.

**Reproducibility:** Always.

## Fix Design

Split the id argument on commas/spaces and loop, as the old engine does. Points to settle
at implementation:

- **Per-item outcome reporting.** The old engine reports moved / skipped / failed counts;
  the new one is single-shot. A batch needs the same summary.
- **Partial failure.** If item 2 of 3 fails its transition check, do items 1 and 3 still
  move? The old engine continues and reports; that is the precedent, and it matches
  `git mv` semantics per item.
- **`--resolution` applies to the whole batch.** Closing three records with one code is
  the common case (`duplicate`, `cancelled`). Confirm that is acceptable rather than
  requiring per-item codes.
- **`sweep` is unaffected** — it already operates on a set.

## Acceptance Criteria

- [ ] `fw-move.sh "1, 2, 3" closed --resolution resolved` moves all three
- [ ] Comma-separated, space-separated, and mixed forms all parse; quoted and unquoted
- [ ] Full ids, bare numerics, and mixed lists all work
- [ ] Per-item summary reported (moved / skipped / failed), matching the old engine
- [ ] A failing item does not prevent the others from moving
- [ ] Command doc shows the batch form
- [ ] Verified against the built plugin, not the source tree (TECH-188)

## Related

- **TASK-213** — surfaced during that discussion; independent of the root move.
- **ADR-009 D5** — the crossover that makes the new engine the only engine; this gap
  must close before then, or the board loses batch moves at graduation.

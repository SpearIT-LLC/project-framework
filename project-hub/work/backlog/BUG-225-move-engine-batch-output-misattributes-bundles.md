# Bug: Move Engine Batch Output Misattributes Bundles and Is Hard to Scan

**ID:** BUG-225
**Type:** Bug
**Priority:** Medium
**Version Impact:** PATCH
**Created:** 2026-09-11
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

Two defects in the **output layer** of `workspaces/framework/scripts/fw-move.sh`, both
found during BUG-215's UAT run on 2026-09-11 (UAT-33). The moves themselves are correct —
this is entirely presentation.

1. **The bundle notice reads as belonging to the wrong record.** It is indented under the
   *previous* record's success line, so on a batch you attribute a bundle move to the
   record above it.
2. **The batch report is hard to scan** and the failure reason is detached from the row it
   explains.

Filed separately from BUG-215 deliberately: that card's criteria are met and it is one
verification step from done. Folding cosmetic defects into it would reopen a nearly-closed
card.

## Evidence

UAT-33, batch of three with a bundle on the **second** record (INC-902):

```
✅ INC-901-batch-item-one.md → open/
   bundle INC-902/ moved
✅ INC-902-batch-item-two.md → open/
✅ REQ-903-batch-item-three.md → open/
📊 moved: 3  skipped: 0  failed: 0
```

The indentation implies `bundle INC-902/` is a child of the INC-901 line above it.

**The cause is presentational, not ordering** (a first diagnosis during the run said the
bundle was emitted one iteration early — it is not). In `move_one`, the record moves, then
the bundle notice prints, then the record's own `✅` prints
([fw-move.sh:189-191](../../../workspaces/framework/scripts/fw-move.sh#L189-L191) and
[:210](../../../workspaces/framework/scripts/fw-move.sh#L210)):

```bash
gmv "$REC" "$NS_ROOT/$TARGET/" || { fail_item "move failed for $BASE"; return 1; }
BUNDLE="$(dirname "$REC")/$FULL_ID"
[ -d "$BUNDLE" ] && { gmv "$BUNDLE" "$NS_ROOT/$TARGET/"; echo "   bundle $FULL_ID/ moved"; }
```

So the line belongs to the record *below* it, and the indentation says the opposite.

**Compounding it:** `✅` lines go to stdout while `fail_item` writes `❌` to stderr, so on a
batch with failures the reasons detach from their rows when the streams interleave.

## Fix Design

**One formatting function in the engine, used by every namespace.** `fw-move.sh` is one
engine with a policy table per namespace (operations today, kanban at the ADR-009 D5
crossover). The report must be produced by shared code so the kanban command inherits it by
construction rather than diverging — agreed with Gary 2026-09-11: *"fw-move should behave
the same for operations and kanban."*

Target shape:

```
Move from onhold → open
  OK       INC-901-batch-item-one.md
  OK       INC-902-batch-item-two.md  (bundle INC-902/)
  FAILED   REQ-903-batch-item-three.md — invalid transition closed → open
  📊 moved: 2  skipped: 0  failed: 1
```

Decisions settled at design time (2026-09-11):

- **Status first, fixed-width, left-aligned.** The eye scans one column. Trailing status
  designators cannot align without padding every filename, which is why the
  status-first form was chosen over `<file>  OK`.
- **Bundle inline on its own record's row.** This *removes* the misattribution rather than
  re-ordering around it: the bundle can no longer be a free-floating line that indentation
  attaches to the wrong record.
- **Failure reason on the row**, not on a detached stderr line. The report is read closely
  only when something failed; that is when the reason must be adjacent.
- **Keep the summary line.** It was offered for removal and kept: it is the only thing that
  survives scrollback on a long batch, it is what a script greps, and it matches the old
  engine's moved/skipped/failed report.
- **Single move keeps its own single-line output** — no header, no summary (current
  behaviour, unchanged).

**Open:** whether `❌`/`✅` glyphs survive alongside the OK/FAILED/SKIPPED words, and
whether the failure reasons stay on stderr (scriptable) while the rows go to stdout.

## Acceptance Criteria

- [ ] A batch with a bundle on a non-first record attributes the bundle to the correct
      record, unambiguously — verified with the bundle on the **second** of three
- [ ] Status appears first in a fixed-width column; rows align regardless of filename length
- [ ] A failed item's reason appears on that item's row
- [ ] The `moved / skipped / failed` summary line is retained
- [ ] Single-id moves are unchanged (no header, no summary)
- [ ] The report is emitted by one shared function, so a second namespace gets it without
      new code — verified by inspection at the call sites
- [ ] Validated: **AI** — re-run the BUG-215 source-tree cases and diff the output shape;
      **Human** — UAT-33 and UAT-35 in `framework-uat` read correctly without the
      filesystem needing to be checked to interpret them

## Related

- **BUG-215** — the card whose UAT found this. Its criteria are unaffected; this is the
  output layer only.
- **UAT-33 / UAT-35** — the runbook cases that exercise the batch report
  (`workspaces/framework/tests/UAT-COMMANDS.md`, section D2).
- **ADR-009 D5** — the kanban crossover that inherits this formatter. The shared-function
  requirement exists so the crossover is a table row, not a second report.

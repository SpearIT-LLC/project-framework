# Bug: Move Engine Batch Output Misattributes Bundles and Is Hard to Scan

> # ⚠️ SUPERSEDED 2026-09-12 — MERGED INTO BUG-215. DO NOT IMPLEMENT.
>
> This card's content now lives on **BUG-215** (`doing/`), under **"Merged in from
> BUG-225"** — design sections verbatim, acceptance criteria in its list. Work it there.
>
> **Why:** this card and BUG-215 were never two bugs. They are one engine change (remove the
> prompt, fix the report) plus one verification, in the same file, in the same commit. The
> 2026-09-11 supersession moved the prompt removal here while BUG-215's UAT-34 and UAT-36
> were rewritten to the new design — so BUG-215 could not pass its own UAT until this card
> shipped, and this card sat in `backlog/`, unreachable under the Implementation Rule. The
> merge eliminates the cross-dependency by construction.
>
> Kept in place as the record of the split and its reasoning. **Archive when convenient —
> the file has no remaining owner.**

**ID:** BUG-225
**Type:** Bug
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-09-11
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

Two defects in the **output layer** of `workspaces/framework/scripts/fw-move.sh`, both
found during BUG-215's UAT run on 2026-09-11 (UAT-33). The moves themselves are correct —
the two defects below are entirely presentation.

> **Scope grew 2026-09-11:** this card also carries the **prompt removal** (see "Also in
> scope", below), which is a behaviour change, not presentation — it changes what
> `--resolution` accepts and what a `→ closed` move does. Hence **MINOR**, not PATCH.

1. **The bundle notice reads as belonging to the wrong record.** It is indented under the
   *previous* record's success line, so on a batch you attribute a bundle move to the
   record above it.
2. **The batch report is hard to scan** and the failure reason is detached from the row it
   explains.

~~Filed separately from BUG-215 deliberately: that card's criteria are met and it is one
verification step from done. Folding cosmetic defects into it would reopen a nearly-closed
card.~~

> **The premise above expired 2026-09-11.** It was true when filed: BUG-215 was one
> verification step from done, and this card was cosmetic. Both halves then changed —
> this card absorbed the prompt removal, and BUG-215's **UAT-34 and UAT-36 were rewritten**
> to the post-supersession design.
>
> **The dependency now runs the other way: BUG-215 cannot pass its own UAT until this card
> ships.** UAT-34 expects `--resolution` to apply to a batch; UAT-36 expects a `→ closed`
> with no code to be refused per record, with no prompt and no tty-dependence. The engine
> still implements the superseded 2026-09-07 design
> ([fw-move.sh:137-138](../../../workspaces/framework/scripts/fw-move.sh#L137-L138) and
> [:174-184](../../../workspaces/framework/scripts/fw-move.sh#L174-L184)), so both fail today.
>
> Confirmed empirically 2026-09-12: a batch `→ closed` refused with *"no terminal is
> available to prompt"* — the right end state (nothing moved, `failed: 2`) reached by the
> wrong mechanism. That is the no-tty arm of the prompt branch, not the refusal UAT-36
> specifies; with a terminal attached the same command prompts instead.
>
> The separation still holds for the **output-layer** defects. What no longer holds is
> "BUG-215 is nearly closed and unaffected."

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

### Also in scope: remove the prompt (added 2026-09-11)

Same file, same commit, and it simplifies the code this card already rewrites.

**Decided 2026-09-11, superseding BUG-215's 2026-09-07 design:** the engine does not prompt.
A `→ closed` move with no `--resolution` is **refused per record**, naming what is missing and
the valid codes; `--resolution` applies to the **whole batch**, because a batch close happens
precisely when records share a root cause.

**What comes out:** the `read`/`/dev/tty` branch and the `[ -t 0 ]` guard — which was wrong
independently of this decision: it tests **stdin** while the read is from **`/dev/tty`**, so a
piped invocation failed closed while a usable terminal was attached.

**Why it belongs on this card:** with no interactive branch, every line the engine emits is a
report line — which is what makes the single shared formatter above achievable rather than a
formatter plus an escape hatch.

Full reasoning: BUG-215's supersession note, and the 2026-09-11 session history (decisions
15-18).

## Acceptance Criteria

- [ ] A batch with a bundle on a non-first record attributes the bundle to the correct
      record, unambiguously — verified with the bundle on the **second** of three
- [ ] Status appears first in a fixed-width column; rows align regardless of filename length
- [ ] A failed item's reason appears on that item's row
- [ ] The `moved / skipped / failed` summary line is retained
- [ ] Single-id moves are unchanged (no header, no summary)
- [ ] The report is emitted by one shared function, so a second namespace gets it without
      new code — verified by inspection at the call sites
- [ ] The engine never prompts: `→ closed` with no `--resolution` is refused per record,
      naming the valid codes; `read`, `/dev/tty` and `[ -t 0 ]` are gone from the script
- [ ] `--resolution` is accepted with a list and applied to the whole batch
- [ ] A piped or headless invocation behaves identically to an interactive one
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

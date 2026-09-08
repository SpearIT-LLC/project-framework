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
  `git mv` semantics per item. **Decided 2026-09-07: validate per item inside the loop,
  continue on failure, report at the end.** A batch may therefore partially apply — which
  is the old engine's behaviour and what the per-item summary exists to make visible.
- **~~`--resolution` applies to the whole batch.~~ Decided 2026-09-07: per record.**
  Gary: *"I think each card gets its own resolution."* The reasoning is that
  `Resolution:` is a per-record classification and the close gate is **already
  per-record** — it asks for the code *and a one-line reason*, plus the
  durable-knowledge question for incidents, and that answer lands in each record's own
  **Outcome** section. One shared code paired with N individually-written outcomes is
  incoherent.

  **Mechanism: prompt per card.** A batch `→ closed` asks for each record's code in
  turn. Rejected: per-id inline syntax (`"1:duplicate, 2:resolved"`) — invents a grammar
  to make a judgment step look mechanical; and refusing batch `→ closed` outright —
  unnecessary once prompting works.

  **`--resolution` on a batch:** with more than one id, the flag cannot express the
  decision. Reject it rather than silently applying one code to all.
  Single-id invocations keep the flag exactly as today (scriptable, no prompt).
- **`sweep` is unaffected** — it already operates on a set.

## Acceptance Criteria

- [x] `fw-move.sh "1, 2, 3" onhold` moves all three *(T1)*
- [x] `fw-move.sh "1, 2, 3" closed` prompts for each record's resolution in turn
      *(T11b — two records, two different codes stamped)*
- [x] `--resolution` with a multi-id list is rejected with a clear message *(T3)*
- [x] `fw-move.sh 1 closed --resolution duplicate` still works unprompted (single id) *(T5)*
- [x] Comma-separated, space-separated, and mixed forms all parse; quoted and unquoted
      *(T1 quoted commas, T4 unquoted spaces)*
- [x] Full ids, bare numerics, and mixed lists all work *(T9 confirms prefix routing;
      bare numerics throughout)*
- [x] Per-item summary reported (moved / skipped / failed), matching the old engine *(T1, T4, T7)*
- [x] A failing item does not prevent the others from moving *(T4 — 1 ok, 99 missing, 3 ok)*
- [x] Command doc shows the batch form

**The namespace half (rescoped 2026-09-07) — not yet started:**

- [ ] **Two commands exist**, one per namespace; neither infers a namespace from the
      target folder or the id shape
- [ ] Bare numerics work in **both** commands
- [ ] One script invoked as `fw-move.sh <namespace> <ids> <target>`, policy table at the
      top; the `""|INC|REQ) NS="operations"` guess is gone
- [ ] ADR-009's "table entry, not a second engine" note is confirmed or amended in
      writing, not left ambiguous

**Verification:**

- [ ] Verified against the built plugin, not the source tree (TECH-188) — **outstanding.**
      Tested at source via `--root` against a scratch git fixture (12 cases, below).
      The built-plugin cycle needs a publish step that was not available in the remote
      session of 2026-09-07. Left as `[ ]` rather than `[/]` deliberately: the done-gate
      counts only `[ ]` today, so `[ ]` is both true and enforced. TECH-177 makes `[/]`
      blocking, but that is its work, not this card's.

---

## Test Evidence (2026-09-07, source tree via `--root`)

Scratch git fixture: four INC records in `open/`, one carrying an artifact bundle.

| # | Case | Result |
|---|---|---|
| T1 | Batch `"1, 2, 3" onhold`, quoted commas | 3 moved; bundle `INC-002/` moved with its record |
| T2 | Single id still works | moved, no summary line (single move prints its own) |
| T3 | `--resolution` on a batch | refused, exit 1 |
| T4 | Partial failure `1 99 3` unquoted | 1 and 3 moved, 99 reported, exit 1 |
| T5 | Single `closed --resolution resolved` | stamped `Closed:` + `Resolution:` |
| T6 | Batch `→ closed` with no tty | both items failed cleanly — **no hang**, exit 1 |
| T7 | Already in target | skipped (not failed), exit 0 |
| T8 | `closed` is terminal | refused |
| T9 | Kanban prefix `BUG-215` | refused with the crossover pointer |
| T10 | Unknown resolution code | refused |
| T11b | Interactive prompt, two records | `duplicate` and `cancelled` stamped per record |
| T12 | `sweep` regression | prior-year record bucketed to `closed/2025/` |

**T6 is the one worth keeping in mind:** a non-interactive batch close fails rather than
hanging on a `read` that can never return. That is the headless case FEAT-221 cares about.

## Related

- **TASK-213** — surfaced during that discussion; independent of the root move.
- **ADR-009 D5** — the crossover that makes the new engine the only engine; this gap
  must close before then, or the board loses batch moves at graduation.

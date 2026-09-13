# Session History: 2026-09-13

**Date:** 2026-09-13
**Participants:** Gary Elliott, Claude Code
**Session Focus:** BUG-215 — the engine change (prompt removal + shared report formatter)

---

## Summary

Made the engine change that yesterday's merge unblocked. `fw-move.sh` no longer prompts,
`--resolution` now applies to a whole batch, and all output goes through one shared
formatter. Ten cases pass at source against `framework-uat`; the built-plugin verification
is still outstanding and remains the one thing between BUG-215 and done.

---

## Work Completed

### BUG-215: the engine change

- **Prompt removed.** `read`, `/dev/tty` and `[ -t 0 ]` are gone from `fw-move.sh`. A
  `→ closed` with no code is refused **per record**, naming the five valid codes. Verified
  by grep over comment-stripped source — the only `read` remaining is the
  `IFS=', ' read -ra` list parser.
- **`--resolution` applies to the whole batch**, replacing the list-refusal at the old
  lines 137-139. Validated **once at parse time** rather than per record.
- **One shared `row()` formatter.** Every outcome path — OK, SKIPPED, and FAILED via
  `fail_item` — goes through it, so the kanban namespace inherits the report at the
  ADR-009 D5 crossover by construction rather than growing a second one.
- **Bundle note inline on its own record's row**, which removes the misattribution rather
  than re-ordering around it.
- Fallout landed in the same commit: `commands/fw-move-ops.md`, `tests/UAT-COMMANDS.md`,
  `CHANGELOG.md`.

### Source-tree verification (2026-09-13)

Fixtures reset and re-seeded first — `framework-uat` had drifted (REQ-903 missing from
`open/`), which is the same drift that caveated UAT-35 on 2026-09-11.

**Ten cases, all pass:** UAT-36 (tty), UAT-36b (piped), unknown code, UAT-33, UAT-35,
single move, already-in-target, terminal guard, UAT-34, stamp check.

Notable results:
- **UAT-36 and UAT-36b are byte-identical** — the headless-safety criterion, demonstrated
  rather than argued.
- **UAT-34** closed both records with one shared code, each stamped `Closed: 2026-09-13`,
  `Resolution: resolved`.
- **UAT-33** put `(bundle INC-902/)` on INC-902's own row; INC-9010 did not move (the
  substring trap held).
- **UAT-35** placed `FAILED   999 — no operations record with that id` in order between the
  two `OK` rows.

---

## Decisions Made

1. **BUG-225's first open question — do failure reasons stay on stderr? — decided: NO.**
   - Implemented the stderr copy first, deliberately, to avoid breaking `fw-move-ops.md`
     step 2 ("report its message verbatim").
   - **It was wrong and was removed.** Every failure printed twice and the two streams
     interleaved on a terminal — which is exactly the detached-reason problem BUG-225
     exists to fix. Reasons now live on the rows, on stdout.
   - `die` still writes to stderr: a usage error (unknown namespace, bad target, unknown
     code) is about the whole invocation, not a record outcome. `fw-move-ops.md` updated
     to say so.

2. **BUG-225's second open question — do the `✅`/`❌` glyphs survive? — decided by the tests.**
   - Words (OK/FAILED/SKIPPED) replace glyphs on rows. **The `📊` summary line is kept
     byte-identical** because UAT-33 and UAT-35 assert it verbatim — that line is a test
     contract, not cosmetics. A comment in the script now says so, so the next person does
     not reformat it.

3. **An unknown resolution code is validated once, at parse time.**
   - It is a usage error about the invocation, not a property of any one record, so it
     fails before any record is touched rather than producing N identical row failures.

4. **A single move carries its destination on its row; a batch prints it once in the header.**
   - First implementation dropped `→ onhold/` from the single-move line, which BUG-225 says
     must be *unchanged*. Caught in the first run and fixed.

5. **Three output defects were found by running, not by reading.**
   - The doubled stderr line, the missing single-move destination, and a failure row with no
     filename (`FAILED   no operations record with id 999`, which did not align with the
     other rows). All three were visible only in real output. Worth remembering: the
     formatter's defects were not visible in the diff.

---

## Files Modified

- `workspaces/framework/scripts/fw-move.sh` — prompt removed; batch `--resolution`; shared
  `row()` formatter; bundle inline; failure reasons on rows.
- `workspaces/framework/commands/fw-move-ops.md` — policy bullet and step 2 rewritten (both
  still documented per-record prompting and the list refusal); added a "Reading the output"
  paragraph naming the stdout/stderr split.
- `workspaces/framework/tests/UAT-COMMANDS.md` — UAT-33, UAT-35 and UAT-36 now show the
  expected report shape verbatim; UAT-36 gains the unknown-code case and a byte-identical
  piped-run assertion.
- `workspaces/framework/CHANGELOG.md` — new `### Changed` block under `[Unreleased]`.
- `project-hub/work/doing/BUG-215-new-move-engine-drops-batch-moves.md` — ten merged engine
  criteria ticked with per-case evidence; both BUG-225 open questions recorded as decided.

## Files Created

- `project-hub/history/sessions/2026-09-13-SESSION-HISTORY.md` — this file.

## Files Moved

- None in this repo. In `framework-uat`, fixtures moved as part of the UAT runs.

---

## Current State

### In doing/
- **BUG-215** — engine change done and green at source. **Two criteria remain:** the
  built-plugin verification, and the kanban criterion awaiting a scope call.
- **TECH-232** — untouched.

### In backlog/
- **BUG-225** — superseded, still awaiting `git mv` to `archive/`.
- **DOC-234** — the plugin-development-guide fixes, still unapplied. Confirmed this morning
  that filing the note changed nothing in the guide.

---

## Next Session

1. **Built-plugin verification**, in this order: publish → `/plugin install
   spearit-framework-dev@dev-marketplace --scope local` → restart → `--reset` and re-seed →
   UAT-33..36 as one set. **Install last** — the publish script's clean step strips
   `*@dev-marketplace` from `installed_plugins.json`, returning the cache to empty.
2. Settle the kanban criterion (recommendation on the card: strike it; it is FEAT-229's).
3. `git mv` BUG-225 to `archive/`.
4. **Housekeeping in `framework-uat`:** unrelated untracked files are sitting in that repo —
   `workspaces/kb/company/contacts/` (betty-rubble, wilma-flintstone, the-great-gazoo,
   CONTACTS-ALL.md) and `workspaces/widget/CONTACTS.md`. They predate today's work. Worth
   clearing so the built-plugin run starts from an honest tree.

---

**Last Updated:** 2026-09-13

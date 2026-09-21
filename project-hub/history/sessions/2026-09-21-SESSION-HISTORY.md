# Session History: 2026-09-21

**Date:** 2026-09-21
**Participants:** Gary Elliott, Claude Code
**Session Focus:** BUG-215 — the built-plugin verification; UAT in a re-scaffolded `framework-uat`

---

## Summary

Closed BUG-215's last two criteria and moved it to `done/`. The kanban criterion was
**struck** (it was always FEAT-229's), and the built-plugin verification was **run against
the installed cache** — five cases, all green. Two false alarms along the way are recorded
below in full, because both are instructive and neither was an engine defect. FEAT-229 was
queued to `todo/` rather than started, leaving the pre-implementation review for a fresh
session.

---

## Work Completed

### BUG-215: the kanban criterion, struck

The card carried an out-of-scope criterion (*"a second command exists for kanban"*) as an
unchecked `[ ]`, deliberately, with a note saying it therefore still blocked the card and
that the done-gate question had to be settled one way or the other.

**Settled: struck from the list**, replaced by a prose paragraph naming FEAT-229 as owner
and pointing at its Scope items 3 and 4.

**It was removed, not ticked.** A `[x]` would have made out-of-scope work indistinguishable
from completed work and dropped it from the gate silently — which is precisely the failure
the card's own note warned against. Removing the box drops it from the gate honestly.

### BUG-215: built-plugin verification (TECH-188) — closed

**Verified against the installed cache**, not the marketplace and not the source tree. The
2026-09-10 note on the card had already established why the distinction matters: the
dev-marketplace entries are *symlinks to the source tree*, so "testing against the
marketplace" tests the same files.

Path, with the detail that cost a false pass:

```
~/.claude/plugins/cache/dev-marketplace/spearit-framework-dev/0.4.7/scripts/fw-move.sh
                                                              ^^^^^ version directory
```

The cached copy was `diff`ed against source **first** and is byte-identical, so the
2026-09-13 grep (no `read` / `/dev/tty` / `[ -t 0 ]` beyond the `IFS=', ' read -ra` list
parser) carries to the artifact.

**Five cases, all pass**, each with a before/after snapshot diffed against the report:

| Case | Via | Result |
|---|---|---|
| UAT-33 | plugin command | 3 OK → `onhold/`; bundle inline on INC-902's row; INC-9010 held; `moved: 3`; exit 0 |
| UAT-34 | plugin command | batch `--resolution`; both stamped, inserted after `Opened:`; bundle across two hops; `moved: 2`; exit 0 |
| UAT-35 | plugin command | OK / FAILED / OK **in order**; `moved: 2 … failed: 1`; exit 1; nothing created for 999 |
| UAT-36 | plugin command | refused **per record**, five codes named; `moved: 0  failed: 2`; exit 1 |
| UAT-36b | cached script direct | tty vs `< /dev/null`: **byte-identical, 352 bytes**; both exit 1 |

Notable: **UAT-36's refusal came from the rule itself**, not from the no-tty arm of a prompt
branch. BUG-225 had recorded this same case reaching the right end state by the *wrong*
mechanism; this run confirms both BUG-215's design and the prompt removal shipped.

**UAT-34 scope caveat, recorded on the card:** the close gate (step 1) was skipped by the
user's choice, because the 9xx fixtures have no **Outcome** section for it to write into.
Engine mechanics verified; the command's judgment step is **not** exercised.

---

## Decisions Made

1. **The struck criterion is prose, not `[-]`.**
   - Gary asked whether it should have become `[-]` (cancelled) per the Obsidian-style
     convention. **It should — eventually.** TECH-177 adopts that convention and is still in
     `todo/`, unstarted, all five criteria unchecked.
   - **Not used today, for two reasons.** The gate reads `grep -c '- \[ \]'`, so `[-]` passes
     *by accident* rather than by design — it would look like the convention and behave like
     an unimplemented one. And TECH-177's code target is the **old** engine
     (`.claude/scripts/fw-move.sh`), not the ADR-009 build that will gate these cards.
   - One precedent exists: `FEAT-175:178` carries a `[-]` in a card already in `done/` —
     notation used ahead of its mechanism, which is the situation TECH-177 exists to fix.
   - **Convert both when TECH-177 lands**, as a mechanical pass with a working gate behind it.

2. **FEAT-229 queued to `todo/`, not `doing/`.**
   - Gary's call, and the right one near a session end: `→ doing` triggers a mandatory
     pre-implementation review, and FEAT-229 is a large card. That review deserves a fresh
     session.
   - `todo/` is now **15/10 — over its WIP limit**. Warning only, not a block, but it is the
     signal the limit exists to give. A `/fw-backlog` pass to push items back is worth doing
     before the queue grows further.

3. **BUG-235 and BUG-236 stay in `backlog/`.**
   - Neither blocks kanban: both are in `fw-contacts.sh` and the pre-commit hook, no overlap
     with the move engine.
   - BUG-236 is the more interesting of the two — it is a *class* defect. Fixing BUG-235
     removes this instance, but the hook would still misreport the next check failure.

---

## Two False Alarms — Both Worth Keeping

### 1. "The engine moved records silently and reported it falsely"

**The most serious-looking finding of the session, and it was not an engine defect.**

Mid-run, a UAT-35 invocation reported `SKIPPED — already in open/` for two records that the
prior command had closed, and a third record (INC-902) appeared to move without being named
in any id list. The run escalated to *"silent data movement plus a false report"* and stopped
for a repair decision.

**What actually happened: the fixtures were re-seeded between UAT-34 and UAT-35.**

**How it was disentangled — the stamps.** UAT-34 wrote `Closed:` and `Resolution:` into
INC-901 and INC-902 and verified them on disk. Reading those files after UAT-35 showed **no
stamps at all**. A `git mv` carries file content, so a record returning from `closed/` would
still have them. Stamp-free files are *new* files — the seeder's. That also accounts for
INC-902, which no id list named: re-created in `open/` with its bundle.

All three reported defects dissolve at once:

- *"`closed` is not terminal"* — the terminal guard at `fw-move.sh:197-199` runs before any
  move. INC-901 was in `open/` when UAT-35 ran.
- *"The report is false"* — the report was **correct**. Both records *were* in `open/`. The
  report matched disk; the run's **memory** of prior state did not.
- *"INC-902 moved unasked"* — it did not move. It was re-created.

**The general lesson:** the run reasoned from remembered state and verified *against memory*
rather than re-reading disk. Each UAT case must establish its own preconditions, never
inherit them from the previous case's remembered outcome. Snapshot-before-each-move was
adopted for the rest of the session and made every subsequent run conclusive.

### 2. A `BYTE-IDENTICAL` that compared two failures

**Claude's error, recorded because the failure mode is general.**

The first UAT-36b attempt was given as a slash command with `2>&1 | cat` appended — invalid,
since a slash command is not parsed by a shell. Gary caught it. The replacement was a real
shell command, but its plugin path **omitted the version directory** (`0.4.7/`), written from
memory of the cache layout rather than checked.

Both captures therefore contained the same *bash* error — `No such file or directory` — and
`diff` duly reported them identical. **`BYTE-IDENTICAL` printed, and the script had never
run.**

**The lesson, now on the card:** a byte-comparison test must also assert that the content is
the *expected output*, not merely that two captures match. A `diff` of two failed runs passes,
and passes loudest when nothing happened.

---

## Files Modified

- `project-hub/work/doing/BUG-215-...md` → moved to `done/`; kanban criterion struck and
  replaced with prose; built-plugin criterion ticked with five-case evidence, the false-pass
  note, and an explicit list of paths **not** exercised.

## Files Created

- `project-hub/work/backlog/BUG-235-fw-contacts-check-crashes-when-workspaces-absent.md`
- `project-hub/work/backlog/BUG-236-pre-commit-hook-reports-check-crash-as-stale-views.md`
  — both authored by Gary earlier in the session, from the `framework-uat` run.
- `project-hub/history/sessions/2026-09-21-SESSION-HISTORY.md` — this file.

## Files Moved

- `project-hub/work/doing/BUG-215-...md` → `project-hub/work/done/` (`Completed: 2026-09-21`
  stamped by the script)
- `project-hub/work/backlog/FEAT-229-...md` → `project-hub/work/todo/`

**In `framework-uat`:** the repo was re-scaffolded for a fresh start — the prior tree moved to
`archive/` (98 files, verified intact) — then fixtures seeded and re-seeded across the UAT
runs. The seeder's `no operations queue` guard required one real record to be created first.

---

## Current State

### In done/ (awaiting release)
- **BUG-215** — closed today. `done/` now holds **11** items; the script reported `12/∞`, a
  discrepancy not chased. At 11 the release nudge band (10–14) applies: **worth releasing
  soon.**

### In doing/
- **TECH-232** — workspace declarations. Untouched today; built and committed 2026-09-12.

### In todo/
- **FEAT-229** — the kanban board. Queued today, **not started**. 15/10 items in `todo/`.

### In backlog/
- **BUG-235**, **BUG-236** — filed today, untracked until this commit.
- **BUG-225** — superseded by the BUG-215 merge; **still awaiting `git mv` to `archive/`**.
  Carried over from 2026-09-13.
- **DOC-234** — plugin-development-guide fixes, still unapplied.

---

## Next Session

1. **FEAT-229 → `doing/`** and its pre-implementation review. This is the core of the
   framework and the card is ready; it is not blocked (the FEAT-021 / TECH-082 conflict was
   found not to exist on 2026-09-09).
2. **Sequencing question to settle first:** TECH-177 sits *behind* FEAT-229 in the queue but
   changes what the gates read. FEAT-229 ports three gates; if TECH-177 lands after, those
   gates get revised again. Worth deciding the order deliberately rather than by queue
   position.
3. **BUG-237 — not yet written.** The 9xx fixtures have no **Outcome** section, so no UAT run
   can exercise the close gate against them. A fixture-set gap in `seed-uat-fixtures.sh`,
   surfaced twice today. Write it before it is forgotten.
4. **A follow-up UAT case** for the four paths BUG-215 never covered: the close gate's Outcome
   step, the `closed`-is-terminal refusal, an **invalid** resolution code (which routes to
   **stderr** as a whole-invocation parse error, unlike a *missing* code's per-record row —
   a good test precisely because the two look alike), and the sweep (INC-907 is seeded with
   `Closed: 2025-11-14` and a bundle, ready for it).
5. **`git mv` BUG-225 to `archive/`** — third session carrying this.
6. **Consider a release** — 11 items in `done/`.
7. **`/fw-backlog` pass** — `todo/` is over its WIP limit at 15/10.

---

**Last Updated:** 2026-09-21

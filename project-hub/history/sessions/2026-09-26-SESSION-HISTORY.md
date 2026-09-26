# Session History: 2026-09-26

**Date:** 2026-09-26
**Participants:** Gary Elliott, Claude Code
**Session Focus:** FEAT-229 Human UAT: the rest of section G (UAT-49 to UAT-51), the D2 re-run
(UAT-33 to UAT-36) and the start of G2 (UAT-52), on installed 0.4.7. All pass. No engine bugs, but
there are three runbook defects and four smaller findings.

---

## Summary

The UAT resumed at UAT-49. Gary typed the `>` cases to a Claude session in `framework-uat`, ran the
`$K` cases in Git Bash, and pasted both outputs here. This session checked each result on disk and
recorded it. **UAT-49, 50, 51, the D2 re-run and UAT-52 all passed.** The engine held everywhere.
What the run found was mostly about the runbook and the docs, not the code. It stopped after UAT-52
because Gary is remote for the rest of the day.

---

## Work Completed

### FEAT-229: the kanban board, Human UAT (G, D2 re-run, start of G2)

The results are in `UAT-RESULTS-2026-08-26.md`, section G, with one row per case:

- **UAT-49:** the AI chose a dotted id for "a sub-task under FEAT-912.1" and said why. The script
  created `FEAT-912.1.1` in **`doing/`**, the parent's folder. A fourth level was refused verbatim
  (`max dotted-id depth is 3 … the parent is too big`), and the AI did not try to get around it.
- **UAT-50:** SPIKE-913 stayed on the board through `→ accept` and was archived as a file on
  `→ done`. SPIKE-914 was archived as a folder (record and `poc.sh`) on `→ cancelled`. There is no
  `history/releases/`. `Completed:` is stamped on done and left blank on cancelled.
- **UAT-51:** the kanban reset removed every 900-block path, including FEAT-912.1.1, and left
  FEAT-001 alone. Operations was re-seeded for the D2 re-run.
- **D2 re-run:** the shared engine behaves for operations exactly as before.
  - UAT-33 matched the runbook's block.
  - UAT-34's close gate proposed a reason for each record, waited, and wrote a separate Outcome to
    each.
  - UAT-36 refused only on REQ-903, because of the ordering defect.
  - UAT-35 ran with INC-904 standing in for INC-901 and matched row for row.
- **UAT-52:** `/fw-move FEAT-901 done` was refused verbatim. The legal path was offered, not taken.

**The method:** verification happened in this repo, not in the UAT session. That session's AI
cannot see the runbook (framework-uat is a consuming repo). It sometimes guessed at the runbook or
offered to record results, and those offers were set aside.

---

## Decisions Made

1. **Run UAT-35 last, with a substitute record, instead of re-seeding again.**
   - UAT-34 had already closed INC-901, which is terminal. The UAT-session AI proposed running the
     case as written first and then with a substitute. Gary ran UAT-36 as written, then UAT-35 with
     INC-904.
   - This gave the partial-failure check through operations without a third seed.
2. **Record at checkpoints, commit when section G ends.** The rows were written after D2 and after
   UAT-52. This session's commit is an early checkpoint because Gary is going remote.
3. **The findings are recorded but not filed yet.** They go into cards after the run, so the UAT
   isn't interrupted. The list is below.

**Corrected in the record:** before D2, Claude predicted that INC-901 would be refused as terminal
in UAT-36. The engine reported `SKIPPED — already in closed/` instead. That's correct: a move to the
folder a record is already in is a no-op skip, as UAT-40 shows. Claude's prediction was wrong, not
the engine.

---

## Findings (not yet filed)

- **Runbook, order:** UAT-34 (rewritten 2026-09-11) closes INC-901, but UAT-35 and UAT-36 still
  assume INC-901 is in `onhold/`. Fix: UAT-34 closes `"902, 904"`.
- **Runbook, layer:** UAT-36 expects the *script's* refusal. Through `/fw-move-ops`, the AI's close
  gate asks for the code first, so the script never sees a bare call. The UAT-session AI had to skip
  the gate on purpose. It should be an engine call in the terminal, as section G does it.
- **Docs contradict the script (UAT-49):** `commands/fw-new.md:15` says "Creation is always into
  `backlog/`", and `templates/records/work-item.md:2` says the same. `fw-new.sh:189` correctly puts
  a dotted child in its parent's folder, and neither document mentions it.
- **Judgment gap (UAT-49):** given no description, the AI invented a slug instead of asking.
  `fw-new.md` only says to ask when the *type* is ambiguous. UAT-05 has the equivalent rule for
  workspaces.
- **Readability (UAT-52, UAT-38):** the refusal's `allowed:` list prints all 23 `from:to` pairs. It
  should list only the moves out of the current folder.
- **Fixture reset (UAT-51):** `--reset` deletes files but leaves the engine's staged `git mv`
  renames in the `framework-uat` index.
- **Cosmetic (UAT-50):** an archived spike's main row names `done/` or `cancelled/`, but the file
  lands in `history/spikes/`. The `↳` line above it states the truth. Not to be filed unless wanted.
- The "delete optional fields" hint came back in UAT-49. BUG-245 already covers it.

---

## Files Modified

- `workspaces/framework/tests/UAT-RESULTS-2026-08-26.md` - UAT-49 to 52 and the D2 re-run recorded

## Files Created

- `project-hub/history/sessions/2026-09-26-SESSION-HISTORY.md` - this file

## Files Moved

- None in this repo.

---

## Current State

### In doing/ — 1 WIP item (5 files)
The **FEAT-229 family**. Human UAT: UAT-37 to UAT-52 pass. **Left:** UAT-53 to UAT-57 (G2, typed to
Claude in `framework-uat`), then F (UAT-27 and 28) as applicable.

**`framework-uat` state at the stop.** The kanban board is re-seeded and FEAT-901 is untouched after
UAT-52, so UAT-53 can start directly. Operations holds leftover D2 state (INC-901 and 902 closed;
INC-904 and REQ-903 in `open/`). That doesn't matter for G2.

### In done/ — 13 · todo/ — 13 · backlog/ — 92

---

## Next Session

1. **Resume at UAT-53** (local machine only, since it needs the installed plugin): type
   `/fw-move 904 doing` to Claude in `framework-uat`. Then UAT-54 to UAT-57.
2. **File the findings above.** Fix the two runbook defects directly (UAT-34 → `"902, 904"`;
   UAT-36 → engine call). Put the dotted-child doc line and the missing-description ask into cards,
   or fold them into BUG-245, which touches the same files (`fw-new.md`, `work-item.md`).
3. **FEAT-229 family out of `doing/`** once G2 passes.
4. **Carried:** the release order (`framework-dev-v0.5.0` / `v5.7.0`); BUG-245; the old-vs-new
   `fw-move.sh` audit; the duplicate `installed_plugins.json` entry; TECH-243; the TECH-232
   reconcile; a `/fw-backlog` pass; BUG-237; `git mv` of BUG-225 to `archive/`.

---

**Last Updated:** 2026-09-26

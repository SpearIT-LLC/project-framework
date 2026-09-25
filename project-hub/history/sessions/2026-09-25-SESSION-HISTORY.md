# Session History: 2026-09-25

**Date:** 2026-09-25
**Participants:** Gary Elliott, Claude Code
**Session Focus:** FEAT-229 Human UAT, section G. UAT-38 to UAT-48 run on installed 0.4.7. All
pass, with no new bugs.

---

## Summary

The FEAT-229 UAT resumed at UAT-38. Gary ran the cases in a Git Bash terminal in `framework-uat`
and pasted the output. Claude checked the files on disk after each case and recorded it. **UAT-38 to
UAT-48 all passed.** Both engine fixes from 2026-09-24 held on the installed copy: spikes are archived
only on a terminal move, and `Completed:` is stamped. The session stopped before UAT-49, the first
case in the rest of G that is typed to Claude.

---

## Work Completed

### FEAT-229: the kanban board, Human UAT (section G)

Every result is in `UAT-RESULTS-2026-08-26.md`, section G. What each case proved:

- **UAT-38:** the allowed moves form a fixed list (backlog cannot go to done, doing or accept). The
  WIP warning prints and still decides nothing.
- **UAT-39:** a batch move carries BUG-902's bundle, and the `901` / `9010` substring trap holds.
- **UAT-40:** a bad id in the middle of a batch does not stop the ids after it (exit 1). A no-op is
  a skip, and exits 0.
- **UAT-41:** the WIP limit warns but never blocks. The count ignores `.gitkeep` and `.limit`
  (BUG-174).
- **UAT-42:** `[?]` and `[h]` block `→ doing`, and the refusal quotes both the line and its note.
  **SPIKE-910 stayed on the board** when it moved `doing → todo`, which confirms the terminal-only
  archival fix.
- **UAT-43:** a dependency not on the board is refused. A family is refused as a whole, and the
  refusal says where the dependency is (`currently in doing/`).
- **UAT-44:** the done gate: `[/]` blocks, `[-]` passes, and a marker quoted in prose is ignored.
  **`**Completed:** 2026-09-25` was stamped** on all three cards that reached `done/`, and not on
  the refused one. This confirms the `stamp_completed` port.
- **UAT-45:** `accept/` has exactly two exits, `doing` and `done`, and it is the only way into
  `done/`.
- **UAT-46:** `done/` is terminal.
- **UAT-47:** FEAT-901 went through a nine-step `hold` / `blocked` / `cancelled` sequence. Every
  move and every refusal came out as specified, and `cancelled/` is terminal.
- **UAT-48:** naming only the child (`912.1`) moved the whole family, and 912.1's bundle went with
  912.1 (BUG-241). The WIP count treats a family as one item: `doing/` held 6 files but 4 base ids,
  and the warning said 4/2 (BUG-240).

**The method:** `echo "exit=$?"` was added to each command from UAT-40 onward, because the runbook's
pass criteria check exit codes and the terminal output does not show them. For UAT-38 the exit code
was checked by re-running one refusal, which does not change the board.

**One runbook correction:** the expected block for UAT-42 left out the WIP warning line. `doing/` is
over its limit on purpose, so the warning always appears. The line is now in the block.

---

## Decisions Made

None. This was a test-execution session.

**Observed, not decided:** a card moved to `cancelled/` keeps a blank `Completed:` field. Both the
old and new engines stamp only on `→ done`, so the behaviour matches. Nobody has decided whether a
cancelled card should get a date.

---

## Files Modified

- `workspaces/framework/tests/UAT-RESULTS-2026-08-26.md` - UAT-38 to UAT-48 recorded (section G)
- `workspaces/framework/tests/UAT-COMMANDS.md` - WIP warning line added to UAT-42's expected
  output

## Files Created

- `project-hub/history/sessions/2026-09-25-SESSION-HISTORY.md` - this file

## Files Moved

- None in this repo. `framework-uat` board state is test data and is not recorded here.

---

## Current State

### In doing/ — 1 WIP item (5 files)
The **FEAT-229 family**. Human UAT: UAT-37 to UAT-48 pass. **The rest of G:** UAT-49 (dotted
create and depth cap, typed to Claude in a `framework-uat` session), UAT-50 (spike archival,
terminal only) and UAT-51. **Then G2** (UAT-52 to UAT-57, the `/fw-move` command), which needs
one publish and restart first.

**`framework-uat` board state at the stop.** `doing/` holds BUG-907, FEAT-904, TASK-905,
SPIKE-913 and the FEAT-912 family (+`FEAT-912.1/`). `done/` holds FEAT-906, TECH-908 and FEAT-911.
`cancelled/` holds FEAT-901. `framework-uat` also has **two staged INC-902 renames** left over from
the operations UAT. They do not affect kanban.

### In done/ — 13 · todo/ — 13 · backlog/ — 92

---

## Next Session

1. **Resume at UAT-49.** Open a Claude session in `framework-uat` and type `add a sub-task under
   FEAT-912.1: write the migration note`, then `add a sub-task under FEAT-912.1.1`. Then run
   UAT-50 and UAT-51 in Git Bash (`K='bash
   ../claude-local-marketplace/framework/scripts/fw-move.sh kanban'`).
2. **Publish and restart, then run G2** (UAT-52 to UAT-57).
3. **FEAT-229 family out of `doing/`** once the UAT passes.
4. **Carried from 2026-09-24:**
   - decide which release goes first (`framework-dev-v0.5.0` and/or the overdue `v5.7.0`);
   - BUG-245;
   - audit the old `fw-move.sh` against the new one;
   - remove the duplicate `installed_plugins.json` entry;
   - TECH-243, the TECH-232 reconcile, a `/fw-backlog` pass, BUG-237, and `git mv` of BUG-225 to
     `archive/`.

---

**Last Updated:** 2026-09-25

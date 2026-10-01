# Session History: 2026-09-30

**Date:** 2026-09-30
**Participants:** Gary Elliott, Claude Code
**Session Focus:** TECH-253, the board hooks (last card on the kanban finish line), and their UAT

Continues straight on from `2026-09-29-SESSION-HISTORY.md` ("Later Session"); the work crossed
midnight.

---

## Summary

TECH-253 is built and committed: a SessionStart hook reports `doing/`, and a PreToolUse hook
blocks plain move, copy and delete commands on board records. UAT-58 to UAT-61 passed on the
installed plugin, including the undocumented `PowerShell` matcher. One design question came out
of UAT-61 and is open: should the guard also block a hand `git mv` between status folders?
UAT-62 (this repo's interim board) and the root `CLAUDE.md` edit are still to do.

---

## Work Completed

### TECH-253: The mechanical bootstrap steps become hooks (doing/)

- **Pre-implementation review.** Gary approved all three recommendations.
  - **Which folders:** the namespace roots the engine declares. They moved into a new
    `scripts/lib/namespace-roots.sh`, read by `fw-move.sh`, `fw-next-id.sh` and both hooks.
  - **This repo's interim board:** `SPRIT_BOARD_ROOTS=project-hub/work` in `.claude/settings.json`.
  - **WIP report:** on `startup|clear|compact`, not `resume`.
- **Docs check (subagent, 2026-09-29):**
  - The deny JSON shape and the SessionStart matchers are documented.
  - `Bash|PowerShell` alternation is supported, but `PowerShell` as a matcher value is not in
    the hooks reference.
  - Whether a `settings.json` `env` value reaches a plugin hook is not stated outright ("applied
    to every session"), so UAT-62 is the proof.
- **Built:** `hooks/report-wip.sh` and `hooks/board-guard.sh`, registered in `hooks/hooks.json`.
  - The guard splits a command at `;`, `&&`, `||` and `|`, follows `cd`, and treats Windows, Git
    Bash and POSIX paths as equal.
  - It covers `mv cp rm rmdir`, `git rm`, the PowerShell cmdlets and aliases, `find -delete/-exec`
    and `xargs rm`.
  - **Added while building:** files inside a record's bundle folder pass. Otherwise deleting a
    scratch log in `FEAT-012/` would be blocked.
  - `tests/test-board-guard.sh` has 29 cases, all passing. The first harness was written inline
    and broke on shell escaping; moving it to a file fixed that. One real miss was fixed: `xargs rm`
    now judges by the paths in the whole command.
- **Held back:** removing the bootstrap steps from the root `CLAUDE.md` waits until UAT-62 passes.
  Until then that text is this repo's only guard.

### UAT section H (Gary, installed plugin after publish + restart)

- **UAT-58 PASS.** The transcript shows the SessionStart hook's output in context before the first
  prompt. The AI also ran one Glob to double-check; that was its own diligence, not a gap in the
  hook.
- **UAT-59 PASS, after two invalid runs.** Gary first typed `mv`, then `Move-Item`, into his own
  terminals. Both moved the card, because a hook sees only Claude's tool calls. FEAT-901 was put
  back each time, and section H now says every command is a prompt to Claude (`c9c8fa7`). As
  prompts: `mv` and `cp` were blocked on Bash, and `Move-Item` was blocked on the **PowerShell
  tool**, which settles the matcher question.
- **UAT-60 PASS.** `rm` and `git rm` were blocked with the never-delete reason.
- **UAT-61 PASS, with a finding.** All four allowed commands ran. The UAT session's AI flagged that
  a hand `git mv` from `todo/` to `backlog/` passes the guard and so skips every gate.

---

## Decisions Made

1. **Folders come from one list** (`namespace-roots.sh`). A guard that protected a different
   folder from the one the engine moves records in would be worse than none.
2. **Interim coverage by an environment variable, not a copied hook.** One settings line, deleted
   at the ADR-009 D5 crossover. The `SPRIT_` prefix follows DECISION-171's rule for environment
   variables.
3. **The bundle-folder exception.** Working material is the author's to reshape; the record and
   its bundle folder are not.
4. **The `CLAUDE.md` bootstrap edit waits for UAT-62.** Step 2's pointer to `framework.yaml`'s
   `sources:` and transition policy stays until BUG-181.

### Open (asked, not yet answered)

- **Block `git mv` between status folders?** My recommendation is yes, allowing only a rename
  within the same folder. The old "git mv only" rule protected history; now that the engine runs
  gates, a hand move also skips transitions, dependencies, acceptance criteria and `Started:`.
  The engine is unaffected, because it runs inside a script the hook never sees. The cost is that
  you can't hand-move a card even on purpose.

---

## Files Created

- `workspaces/framework/hooks/board-guard.sh` - PreToolUse guard
- `workspaces/framework/hooks/report-wip.sh` - SessionStart WIP report
- `workspaces/framework/scripts/lib/namespace-roots.sh` - the one home for namespace folders
- `workspaces/framework/tests/test-board-guard.sh` - 29-case table test

## Files Modified

- `workspaces/framework/hooks/hooks.json` - registers both hooks
- `workspaces/framework/scripts/fw-move.sh`, `scripts/fw-next-id.sh` - source `namespace-roots.sh`
- `.claude/settings.json` - `SPRIT_BOARD_ROOTS=project-hub/work`
- `workspaces/framework/tests/UAT-COMMANDS.md` - section H (UAT-58..62); prompts-not-terminal note
- `workspaces/framework/tests/UAT-RESULTS-2026-08-26.md` - section H run
- `workspaces/framework/CHANGELOG.md` - board hooks entry
- `project-hub/work/doing/TECH-253-*.md` - review decisions, AC state

## Commits

- `b419e84` feat: TECH-253 - board hooks; awaiting UAT
- `c9c8fa7` docs: UAT section H - commands are prompts to Claude

---

## Current State

### In done/ (awaiting release)
- BUG-241, SPIKE-248, BUG-251, TECH-247, BUG-250, TASK-223, DECISION-171, BUG-258, TECH-243 (9)

### In doing/
- **TECH-253**: built; UAT-58..61 pass. Open: the `git mv` decision, UAT-62, the `CLAUDE.md` edit.

**todo/ — 8 · backlog/ — 92 · blocked/ — 1**

---

## Next Session

1. **Gary decides:** should the guard block `git mv` between status folders? If yes: add it to
   `board-guard.sh`, add table-test cases, and change UAT-61 step 2 to a same-folder rename.
2. **Gary: UAT-62** in this repo (fresh session). The context should carry
   `Work in progress (project-hub/work/doing/): …`, and `mv` of a card under `project-hub/work/`
   should be blocked. This proves `settings.json` `env` reaches plugin hooks.
3. After UAT-62: remove bootstrap steps 1, 3 and 4 (and step 2's persona) from the root
   `CLAUDE.md`, then close TECH-253. **That completes the kanban finish line.**
4. **Release:** 9 cards in `done/`, 10 with TECH-253, which reaches the release nudge.
5. **Carried:** BUG-256 (default-yes commit wording), TASK-259 (spike lifecycle), BUG-181 (High),
   BUG-255; restore `framework-uat`'s `BUG-902/evidence.txt` (or reseed).

---

**Last Updated:** 2026-09-30

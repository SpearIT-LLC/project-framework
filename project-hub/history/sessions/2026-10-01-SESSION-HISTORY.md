# Session History: 2026-10-01

**Date:** 2026-10-01
**Participants:** Gary Elliott, Claude Code
**Session Focus:** TECH-253: settle the `git mv` question from UAT-61; prepare UAT-62

Continues `2026-09-30-SESSION-HISTORY.md`.

---

## Summary

Gary approved blocking a hand `git mv` between status folders. The guard now allows only a
`git mv` that renames a record within its folder. Building it showed that the old `/fw-move`
command told the AI to `git mv` artifact folders by hand, which the guard would now block, so the
old engine moves them itself. Next: Gary restarts and runs UAT-62 in this repo.

---

## Work Completed

### TECH-253 (doing/): hand `git mv` between status folders is blocked

- **Clarified first (Gary's question):** "blocking git mv" means a raw `git mv` that Claude types.
  The engine's own `git mv` runs inside `fw-move.sh`, which the hook never sees, so `/fw-move` is
  unaffected.
- **`hooks/board-guard.sh`:** a new `status_of` helper resolves a path to `<root>|<status folder>`.
  A `git mv` whose source is a board record is denied when the destination's status folder
  differs, including a destination outside the board. A rename within one folder, and moves
  inside a bundle folder, pass. The header records the rule and its date.
- **`tests/test-board-guard.sh`:** 6 new cases (cross-folder deny, rename allow, bundle-internal
  allow, out-of-board deny, multi-source with `-f` deny, non-board allow). 35/35 pass.
- **Consequence found while building:** `.claude/commands/fw-move.md` told the AI, after the
  script, to `git mv` a card's artifact folder by hand, which the guard would now block in this
  repo. The old engine (`.claude/scripts/fw-move.sh`) gained `move_bundle` and moves `<ID>/` with
  the record, shown as `(+ <ID>/)`, as the new engine already did. The manual step was removed from
  the command. Tested on a scratch board with SPIKE-005 and its folder.
- **Checked, no change:** `/fw-release`'s archive step `git mv`s from shell variables
  (`"$item"`), which the hook cannot resolve, so the next release is not blocked.
- **Runbook:** UAT-59 adds the cross-folder `git mv` case; UAT-61 step 2 is now a rename within one
  folder.

---

## Decisions Made

1. **A hand `git mv` between status folders is blocked (Gary).**
   - The "git mv only" rule dated from when history was the only thing a hand move could lose.
     With gates in the engine, a hand `git mv` keeps history but skips transitions, dependencies,
     acceptance criteria and the `Started:` stamp.
   - `/fw-move` is now the only way a card changes status. A rename in place is still a raw
     `git mv`.
   - Raised by the UAT session's AI in UAT-61; recommended here; approved by Gary.
2. **Artifact folders move inside the engine, not by an AI step.** One place, mechanical, and
   consistent with the new engine.

---

## Files Modified

- `workspaces/framework/hooks/board-guard.sh` - cross-folder `git mv` deny; `status_of`
- `workspaces/framework/tests/test-board-guard.sh` - 6 cases
- `.claude/scripts/fw-move.sh` - `move_bundle`: artifact folder moves with its record
- `.claude/commands/fw-move.md` - manual artifact `git mv` step removed
- `workspaces/framework/tests/UAT-COMMANDS.md` - UAT-59, UAT-61 updated
- `workspaces/framework/CHANGELOG.md` - board hooks entry updated
- `project-hub/work/doing/TECH-253-*.md` - decision recorded

## Commits

- `405bf5d` feat: TECH-253 - guard blocks hand git mv between status folders

---

## Current State

### In done/ (awaiting release)
- BUG-241, SPIKE-248, BUG-251, TECH-247, BUG-250, TASK-223, DECISION-171, BUG-258, TECH-243 (9)

### In doing/
- **TECH-253**: UAT-58..61 pass; guard updated. Open: UAT-62, then the root `CLAUDE.md` edit.

---

## Next Session

1. **Gary:** reload VS Code, then UAT-62 in this repo, in a fresh session. The context should
   carry `Work in progress (project-hub/work/doing/): …`; `mv` of TECH-253's card to `todo/`
   should be blocked; optionally `git mv` the same way, also blocked. Passing proves a
   `settings.json` `env` value reaches a plugin hook.
2. Then: remove bootstrap steps 1, 3 and 4 (and step 2's persona) from the root `CLAUDE.md`, and
   close TECH-253. That completes the kanban finish line and brings `done/` to 10 (release nudge).
3. **Carried:** BUG-256, TASK-259, BUG-181 (High), BUG-255; `framework-uat`'s
   `BUG-902/evidence.txt` (restore or reseed).

---

**Last Updated:** 2026-10-01

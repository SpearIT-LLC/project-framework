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

## Later Session (2026-10-01): status check and a UAT re-run reviewed

**Focus:** Resume check on TECH-253; review Gary's re-run of UAT-58..61 in `framework-uat`.

### UAT-62, first half: passed without being run

This session's start context carried
`Work in progress (project-hub/work/doing/): 1 card(s)… TECH-253`. That report only appears in
this repo through `SPRIT_BOARD_ROOTS` in `.claude/settings.json`, so **a `settings.json` `env`
value does reach a plugin hook**. The open question in TECH-253's "This repo's board" decision is
answered. The second half of UAT-62 (a `mv` of a card under `project-hub/work/` is blocked) was
not run.

### Review of the UAT-58..61 re-run (fresh `framework-uat` session)

Every result agrees with the guard's design. Nothing in it contradicts the earlier pass of
UAT-58..61 recorded above.

- **UAT-58:** cards listed correctly. The answer also gave the `.limit` of 2, which
  `report-wip.sh` does not print, so the AI read that file on its own. The staging details most
  likely came from Claude Code's git-status snapshot. Probable pass, since the card list needed
  no read. Confirm from the tool rows if it matters.
- **UAT-59:** `mv` blocked, with the expected reason. `cp` and the cross-folder `git mv` were
  not in this run.
- **UAT-60:** `rm` blocked, with the expected reason. `git rm` was not in this run.
- **UAT-61:** `touch x.tmp && rm x.tmp` passed. The rename failed because the
  `/fw-move FEAT-901 todo` step that comes before it was not run. The bundle `rm` failed because
  `BUG-902/evidence.txt` was already deleted and the deletion was never committed. Both are
  fixture/order effects, not guard failures; the hook let both through, which is correct.
- **Correction (Gary):** the run *was* a fresh session. That fixes UAT-58's context source; the
  missing cases are simply not in the pasted run.

### Observation: `framework-uat` fixture drift

The fixture repo carries many staged leftovers from earlier UATs: 6 cards in `doing/` against a
limit of 2, renames across folders, and the missing `evidence.txt`. A reseed before the next
gated-move UAT is advisable.

### Files

None modified. Review only.

### Current State

- **doing/:** TECH-253. Remaining: the `mv`-blocked half of UAT-62, then the root `CLAUDE.md`
  edit, then close.
- **done/:** unchanged (9).

### Next Session

1. **Gary:** in this repo, prompt Claude with
   `run this exactly: mv project-hub/work/doing/TECH-253-bootstrap-steps-become-hooks.md project-hub/work/todo/`.
   If it's blocked, UAT-62 passes.
2. Remove bootstrap steps 1, 3 and 4 (and step 2's persona) from the root `CLAUDE.md`; close
   TECH-253.
3. Reseed `framework-uat` (carried).

---

**Last Updated:** 2026-10-01

# Session History: 2026-09-24

**Date:** 2026-09-24
**Participants:** Gary Elliott, Claude Code
**Session Focus:** Release day that became UAT day. Writing the FEAT-229 UAT exposed two engine
bugs and a missing command. **No release shipped.**

---

## Summary

The plan was to release. The release was blocked by the FEAT-229 family in `doing/`: its only open
criterion is the Human UAT against the installed plugin, and **that UAT did not exist**. The
runbook had no kanban section, and UAT-20 asserted the opposite of the new behaviour. Writing it,
and dry-running it before handing it over, found **two real engine bugs** (spikes archived on
*every* move; `Completed:` never stamped). Gary then decided the board gets its **own `/fw-move`
command now**, not at crossover. Gary ran UAT-37, which passed with BUG-245 filed. UAT-38 onward
resumes next session.

---

## How the Day Went

### 1. The release was blocked, and the blocker was a missing test

`/fw-release` step 2a refuses while anything is in `doing/`. The five FEAT-229 cards were
code-complete and AI-validated, with one criterion left: *"a full UAT pass in `framework-uat`
against the installed plugin."* FEAT-229.2 and .4 still carried that line as `[ ]` while the parent
had it as `[h]`, so both were brought into line.

**Open question, not answered:** I asked whether today's release was `framework-dev` (the kanban
board) or the main framework `v5.7.0` (13 cards in `done/`, overdue since 2026-09-21). Gary
published the dev plugin, which implied `framework-dev`, but **the main release question was never
settled**. It is still owed.

### 2. A stale memory entry: `Publish-ToLocalMarketplace.ps1 -Build`

I told Gary to run the publish script with `-Build`. **The script takes no parameters**
(`param()`). The flag came from my auto-memory, not the repo. The memory entry is corrected.

### 3. The UAT runbook had nothing for the board, and UAT-20 was inverted

`UAT-COMMANDS.md` covered A–F (workspaces, kb, contacts, operations, troubleshoot, cross-cutting)
and **no kanban**. The "cases mirroring UAT-33..36" that FEAT-229:223 marks `[x]` were never
written into the runbook. **UAT-20 passed only if kanban was *refused*,** so it would have failed
a working board while testing nothing new. Gary: *"yes"* to writing section G first.

### 4. Dry-running the runbook found two engine bugs

Every case was run in a throwaway repo **before** being written down, so the expected output is
real output rather than a guess. That is what found:

- **Every spike move archived the spike.** The spike-archival block tested the namespace and the
  `SPIKE-` prefix but **not the target**. So SPIKE-910 going `doing → todo` and SPIKE-913 going
  `doing → accept` both left the board for `history/spikes/`. The code's own comment said
  *"a spike reaching a terminal state"*. **Why the AI validation missed it:** FEAT-229.3's cases
  exercised only terminal moves, which is exactly where the bug cannot show.
- **`**Completed:**` was never stamped.** Gary asked whether this was a live bug. **It is not.**
  The old engine stamps it (`stamp_completed`, BUG-167), and the last five cards in `done/` carry
  dates. **The port to the new engine dropped it**, while the work-item template and `/fw-new`
  both kept promising it. It is now ported, with the design noted in the code: it stamps every
  family member, stamps *before* spike archival so the date travels, and is idempotent (an
  existing date is kept).

The seeder's own new `--reset` also failed on its first run (the variable was set inside the
loop,
and `git rm --ignore-unmatch` "succeeds" on untracked files without removing them). Both are fixed.
Reset now also clears the four-digit `*-9010` trap, which it had never matched.

### 5. `$K`, and why the moves went through the script

Gary asked what `$K` was. It is a Git Bash variable wrapping the installed `fw-move.sh kanban`. The
runbook's wording was tightened. **I had argued the kanban move command belonged to the crossover
card**, to avoid two `/fw-move`s pointing at two boards. **Gary corrected that:**

> *"fw-move old and new commands live in different namespaces so I see no reason why we have to
> limit the new. That said, I do see some value in testing the .sh commands direct."*

He is right. Plugin commands are namespaced (`spearit-framework-dev:fw-move` beside the root
`/fw-move`), exactly as `spearit-framework-dev:fw-new` already sits beside the root `/fw-new`. In
a repo with no `kanban/` the engine simply refuses. **Decision: build it now.** The result is
**two UAT layers**: G (UAT-37..51) tests the engine directly, and G2 (UAT-52..57) tests the
command's judgment.

### 6. The new `/fw-move`

Authored fresh, not copied from the old command. The workspace `CLAUDE.md` forbids carrying
structure forward without a reason. **The engine enforces every fact; the command carries only
judgment:**
- the pre-implementation review on `→ doing`, then stop;
- a `Cancellation Reason:` before `→ cancelled` (free text, per TASK-242 D4);
- the blocked-vs-hold *cause* check;
- refusals reported verbatim, with recovery offered as a question.

**Dropped from the old command, with reasons recorded in the file:**
- the "child split" warning: a dotted family now always moves together (FEAT-229.4);
- the manual bundle `git mv`: the engine moves bundles.

**The review runs after the move:** the gates are cheap facts, so a card with an unmet dependency is
refused before anyone spends time reviewing it.

Found while doing it: the engine's "no queue" refusal always named `/fw-new-ops-record`, even for
kanban. The create command is now a column of the policy table (`<ns>_CREATE`).

### 7. The duplicate plugin row

Gary asked why the old SpearIT plugins appeared in "Available" and the new one did not. **The new
one was there: installed, and listed twice.** "Available" lists only *uninstalled* plugins.
The duplicate: `installed_plugins.json` holds two `local` installs for `framework-uat` whose paths
differ **only in drive-letter case** (`C:\…` vs `c:\…`). Both point at the same cache. **Left
alone until after the UAT**, so a cleanup doesn't disturb the install under test.

### 8. UAT started: UAT-37 PASS, with BUG-245

Gary ran UAT-37 on installed 0.4.7 (results in `UAT-RESULTS-2026-08-26.md`, new section G). The
scaffold, limits and fixtures all came out as specified. **BUG-245 filed (High):** the *"delete
optional fields"* rule survives in the kanban path. It is the same defect as BUG-207, which was
fixed only for contacts. The rule appears in `fw-new.md`, `work-item.md`, the `fw-new.sh` "Next:"
line, `fw-new-ops-record.md` and `ts-case.md`. **Gary's rule:** optional fields with no known value
stay as blank lines, because deleting them leaves no update path.

---

## Decisions Made

1. **The dev plugin gets its own `/fw-move` now**, not at the D5 crossover. The namespaces
   separate the two commands; the engine refuses where there is no `kanban/`. (Gary)
2. **UAT runs in two layers:** the engine directly (facts) and the command (judgment). (Gary)
3. **`/fw-move` runs the pre-implementation review after the move**, so the gates refuse
   cheaply before a review is spent.
4. **Spike archival is terminal-only.** This is a correction to FEAT-229.3's implementation, not a
   new decision: its own comment already said so.
5. **`Completed:` is stamped by the engine**, ported from BUG-167, first-completion-wins.
6. **The duplicate `installed_plugins.json` entry waits until after the UAT.**

---

## Files Created

- `workspaces/framework/commands/fw-move.md` - the board's command (`spearit-framework-dev:fw-move`)
- `project-hub/work/backlog/BUG-245-delete-optional-fields-rule-survives-outside-contacts.md` -
  filed by Gary from UAT-37

## Files Modified

- `workspaces/framework/scripts/fw-move.sh`:
  - spike archival limited to terminal moves;
  - `stamp_completed` ported;
  - `<ns>_CREATE` column added to the policy table.
- `workspaces/framework/tests/seed-uat-fixtures.sh`:
  - new fixtures: the FEAT-912 dotted family (child bundle, child dependency), TASK-915
    (dependency off the board), SPIKE-913 (research), SPIKE-914 (POC);
  - `--reset` fixed and widened;
  - the outdated "no gates yet" note removed.
- `workspaces/framework/tests/UAT-COMMANDS.md` - section G (UAT-37..51) and G2 (UAT-52..57);
  UAT-20 rewritten; UAT-00 command list updated
- `workspaces/framework/tests/UAT-RESULTS-2026-08-26.md` - section G started, UAT-37 (Gary)
- `workspaces/framework/commands/fw-move-ops.md` - removed the outdated "kanban not wired" line
- `workspaces/framework/CHANGELOG.md` - `[Unreleased]`: the command, `Completed:`, section G, the
  error-message fix
- `project-hub/work/doing/FEAT-229.2-…md`, `FEAT-229.4-…md` - validation line `[ ]` → `[h]`,
  matching the parent
- Auto-memory `MEMORY.md` - the `-Build` flag removed

## Files Moved

- None.

---

## Current State

### In doing/ — 1 WIP item (5 files)
The **FEAT-229 family**. Everything is implemented; the Human UAT is in progress: **UAT-37 passed**,
UAT-38..57 remain. **Installed plugin vs source:**
- G (UAT-38..51) can run on the currently installed copy, which already has the spike and
  `Completed:` fixes.
- G2 (UAT-52..57) needs **one more publish and restart** first, for `/fw-move`.

### In done/ — 13 cards · todo/ — 13 · backlog/ — 92 (BUG-245 new)

---

## Next Session

1. **Resume the UAT at UAT-38** in `framework-uat` (Git Bash, `K='bash
   ../claude-local-marketplace/framework/scripts/fw-move.sh kanban'`). Publish and restart before
   G2.
2. **FEAT-229 family out of `doing/`** once the UAT passes: tick the Human halves, then move via
   `accept/`.
3. **Settle which release comes first:** `framework-dev-v0.5.0` (the board) and/or the overdue
   main framework `v5.7.0` (13 cards in `done/`). The main release is blocked by the same
   `doing/` guard.
4. **BUG-245** (High), plus a follow-up worth considering: the old engine's features were ported
   without a checklist, and `Completed:` slipped through. An audit of the old `fw-move.sh` against
   the new one would find any other omissions.
5. **Clean the duplicate `installed_plugins.json` entry** after the UAT.
6. **Carried:** TECH-243 · TECH-232 reconcile · `/fw-backlog` pass · BUG-237 unwritten ·
   `git mv` BUG-225 to `archive/`.

---

**Last Updated:** 2026-09-24

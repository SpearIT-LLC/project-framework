# Session History: 2026-09-29

**Date:** 2026-09-29
**Participants:** Gary Elliott, Claude Code
**Session Focus:** Close SPIKE-248; define "kanban complete" and start on it

---

## Summary

SPIKE-248 closed. D3 was withdrawn (Response Style stays in the contract, with a review for
old-model baggage carried by BUG-181) and D6 was dropped. Gary asked whether kanban is done.
It isn't, so a seven-card finish line was agreed, and the first three cards were worked:
TECH-247 and BUG-251 are done, and BUG-250 waits on a UAT re-run.

---

## Work Completed

### SPIKE-248: Rebaseline the framework against current Claude Code → done
- **D3 (Response Style):** Claude recommended keeping it in the contract, because moving it
  would reverse ADR-007 D5 and D1 already reaches every machine. Gary: *"keep but consider
  refinements if they work against what's already built in the new model."*
- **Misread, then corrected.** Claude first took "new model" to mean the new build
  (`workspaces/framework/`) and wrote that into BUG-181, ADR-007 Amendment 1 and
  `findings.md`. Gary clarified: **the new Claude model.** The spike's purpose is to find old
  baggage that helped older models and is unneeded or a hindrance now. All three places were
  reworded (`6c689f1`). BUG-181's pre-implementation review now checks each Response Style rule
  against the current model's default behaviour. The spike itself never ran that check; it is
  deferred to BUG-181, where the contract has to be re-read anyway.
- **D6 (advisory Implementation-Rule hook): dropped.** "`doing/` is empty" fires on legitimate
  edits (histories, ADRs, research) and misses the real violation (unrelated edits while
  something else is in `doing/`). The rule stays prose in the contract.
- Last exit criterion ticked; moved to `done/` with its artifact folder (`35e6f43`).

### "Is kanban done?" — the finish line
Gary wants kanban complete before other features, since it is core. Claude listed every
`Workspace: framework` card and proposed seven as the finish line; Gary: "yes".
1. **BUG-250**, **BUG-251**, **TECH-247**: engine and command defects from UAT.
2. **TASK-223, Groups 2 and 5 only**: board lifecycle conventions and the `fw-` rule. Groups
   3–4 (issue response, session handoff, meeting records, external-reference template) are
   not board work and are to be split into their own card.
3. **TECH-243**: the release guard must cover `accept/`, `hold/` and `blocked/`, not only `doing/`.
4. **TECH-253**: bootstrap hooks (report `doing/`; deny non-`git mv` board moves).
5. **BUG-225**: housekeeping archive.

Left out on purpose: TECH-230, TECH-237, FEAT-231, TECH-228 and FEAT-221 (they extend the
board; it is complete without them); BUG-239/240 (old engine, close at the D5 crossover);
BUG-246 and TECH-249 (the test harness). Unverified: BUG-239/240 being old-engine-only rests on
the 2026-09-28 notes, not a code check.

### BUG-225 → archive
Superseded 2026-09-12 (merged into BUG-215). The cancellation reason was taken from the card's
own banner, not drafted.

### TECH-247 → done
`fw-move.sh` refuses an invalid transition with only the exits from the current folder:
`invalid transition backlog → done (from backlog: todo, blocked, hold, cancelled)`. UAT-38's
expected text updated. UAT-52 quotes the row verbatim and names no list, so it needed no change.

### BUG-251 → done
An unnamed family member that carries a bundle now reports `(bundle <ID>/)` on its `↳` row.
UAT-56's expected text updated.

### BUG-250 (doing/) — waits on Gary's UAT-55 re-run
- `commands/fw-move.md` step 1 now carries one rule over all its questions (`→ cancelled`,
  `→ blocked`, `→ hold`): ask, offer no answer, record the answer as given.
- **Gary: the card was carrying two things** (a kanban fix and an ops question), which was a
  mistake when the goal is closing out kanban. The ops half was split to **BUG-255**.
- **Ops decision (Gary), recorded on BUG-255:** the AI may draft the Outcome summary from facts
  in the record and its history; the closing reason and what was learned are a **joint
  effort**, because "valuable input" comes from both sides. How "joint" works is open.
- Claude kept the board rule as "user's answer alone"; the joint-effort answer was about ops.

### Verification
In a scratch repo (`fw-new.sh` to create `kanban/`, then `seed-uat-fixtures.sh`), Claude ran
UAT-38, the `accept` exits (`from accept: doing, done`), UAT-48, UAT-56, and the UAT-33 ops batch
against the changed engine. All matched; ops output unchanged. First attempts failed on Claude's
side: `$K` needs the `kanban` namespace argument, and a Python edit had put a literal newline
into the `printf` (caught by reading the diff, fixed before testing).

---

## Decisions Made

1. **D3 withdrawn; Response Style stays in the contract** (ADR-007 D5 confirmed), with a review
   for old-model baggage at BUG-181.
2. **"New model" = the current Claude model**, not the new build. SPIKE-248's purpose is to
   remove old-model baggage.
3. **D6 dropped.** The Implementation Rule stays a contract rule.
4. **Kanban finish line = the seven cards above**, before other features.
5. **A card carries one thing.** BUG-250's ops half became BUG-255.
6. **Ops close gate:** summary may be drafted; reason and durable knowledge are joint.

---

## Files Modified

- `project-hub/research/adr/007-ai-collaboration-contract-and-claude-md.md` - Amendment 1: D5 confirmed, advisory hook dropped
- `project-hub/work/todo/BUG-181-*.md` - Response Style stays; review for old-model baggage
- `workspaces/framework/scripts/fw-move.sh` - scoped refusal (TECH-247); member bundle note (BUG-251)
- `workspaces/framework/commands/fw-move.md` - ask without drafting (BUG-250)
- `workspaces/framework/tests/UAT-COMMANDS.md` - UAT-38, UAT-55, UAT-56 expectations
- `workspaces/framework/CHANGELOG.md` - `[Unreleased]` entries for the three cards

## Files Created

- `project-hub/work/backlog/BUG-255-ops-close-gate-drafting.md` - ops half of BUG-250

## Files Moved

- `doing/SPIKE-248*` (card + folder) → `done/`
- `backlog/BUG-225-*` → `archive/`
- `backlog/BUG-251-*`, `backlog/TECH-247-*` → `done/` (via `todo/`, `doing/`)
- `backlog/BUG-250-*` → `doing/` (via `todo/`)

## Commits

- `35e6f43` feat: Complete SPIKE-248
- `6c689f1` docs: SPIKE-248 D3 refinement is against the current Claude model
- `7bd68ab` fix: Complete BUG-251 and TECH-247; BUG-250 rule

---

## Later Session (afternoon and evening)

Picked up after `ad74b53`. Worked the kanban finish line card by card. Four cards closed, three
filed, and one design reversal came out of Gary's challenge questions.

### BUG-250 → done
- Gary re-ran UAT-55 on 0.5.0 in a fresh session. On BUG-902 the AI asked, offered no reason,
  and recorded "Issue turned out to be a false issue." verbatim. PASS.
- Two observations recorded in the `UAT-55 (re-run)` row: the AI asked for TECH-903's reason
  before noticing the card was already cancelled, and it worded its commit offer as "I'll go
  ahead unless you say no".
- **BUG-256 filed** for that commit wording. The cause is the command text: "default yes" in
  `fw-move.md:95` and `fw-new.md:87` was meant as the recommended answer, and was read as consent.

### TASK-223 → split, then done
- Groups 3–4 (process and templates, not board work) moved to **TASK-257**.
- Pre-implementation review settled all eight remaining conventions. FEAT-030, TECH-044,
  TECH-077 and TECH-078 were archived as superseded; DECISION-171 went to done.
  - TECH-077's never-delete check was added to TECH-253's hook.
  - TECH-078 closed into **FEAT-028**: the release-command card already existed, so no new
    card was needed.
  - DECISION-171's `fw-` rule went into `workspaces/framework/CLAUDE.md`. Its check became an
    AC on TECH-189, because the repo has no commit-time check yet.
- **Found in review: BUG-258.** `fw-next-id.sh` scanned only `kanban/`, while spikes were moved
  to `history/spikes/`. Reproduced: next id 004 with SPIKE-005 off-board.

### BUG-258 → done, and the design reversal
- Proposed fix: a shared list of off-board folders for the scanner to read.
- **Gary's challenge:** why does kanban send records outside its root when operations never does?
  Operations' archive equivalent, the `closed/YYYY/` sweep, stays inside `operations/`.
- The pros and cons were weighed: off-board moves break ID safety, are a special case in the
  engine that had already caused one bug, and give the framework two models for one idea.
- **Decision: no record leaves its namespace root.** The `history/spikes/` redirect was removed,
  which fixes the bug by construction.
- Scenario walk-throughs (a POC for `workspaces/app1`; a spike whose feature ships later) settled
  the spike lifecycle, recorded on **TASK-259**:
  - POC code goes in `workspaces/<ws>/poc/<SPIKE-id>/`, linked from the card.
  - Results go to `<ws>` or `kb/`.
  - The card leaves `done/` with the next release and is filed under `release/<ws>/spikes/`.
    Gary proposed that folder, replacing my version-folder idea.
  - Spikes are never in release notes, only in activity reports.
  - Spike and feature are joined by links, not timing.
- **Superseded:** TECH-228's `history/spikes/` carry-in, and TASK-242 D5's `history/archive/` for
  board cards. The 27 legacy `deprecated/` cards wait until the board crosses over.
- UAT-50 re-run PASS (spikes stay on the board).

### TECH-243 → done
- Review found that the live board has no `accept/` or `hold/`, and that the old `/fw-release`
  guard was prose (`ls`), not a script.
- **Gary's challenge:** "why is there no cheap way to tell parked-with-code from never-started?"
  - Git history can't tell: moves reach git only when committed, and TASK-223's history shows
    `backlog → done`.
  - A `**Started:**` stamp can. Both engines now write it on the first move into `doing/`, and
    the first start wins (Gary's path todo → doing → hold → doing → accept → done keeps the
    first date).
- `.claude/scripts/fw-release-guard.sh`:
  - `doing/` and `accept/` block the release.
  - `blocked/` and `hold/` warn and need confirmation when the card was started, and print an
    info line otherwise.
- **FEAT-260 filed** (Gary's "big perhaps"): a timestamped move history on every card. Deferred
  until something reads it. Gary noted that session history already answers "which day", roughly.

---

## Current State

### In done/ (awaiting release)
- BUG-241, SPIKE-248, BUG-251, TECH-247, BUG-250, TASK-223, DECISION-171, BUG-258, TECH-243

### In doing/
- **TECH-253**: built after midnight; continued in `2026-09-30-SESSION-HISTORY.md`.

### Earlier today
- BUG-250 closed after Gary's UAT-55 re-run passed on 0.5.0 (BUG-902, fresh session).
  TASK-223 closed: all eight board conventions have outcomes (table on the card).

**todo/ — 8 · backlog/ — 93 · blocked/ — 1**

---

## Next Session

1. ~~UAT-55 re-run~~ — **done**, PASS on 0.5.0; BUG-250 closed. Two observations in the
   UAT-55 (re-run) row: the AI asked for a reason before finding the card already
   cancelled, and worded its commit offer as default-yes.
2. ~~Split TASK-223~~ and ~~work Groups 2 and 5~~ — **done**. Groups 3–4 → TASK-257. Four
   source cards archived (FEAT-030, TECH-044, TECH-077, TECH-078), DECISION-171 done. Filed
   **BUG-256** (the "default yes" commit offer) and **BUG-258** (High: `fw-next-id.sh` scans only
   `kanban/`, so spike ids in `history/spikes/` can be reissued; reproduced).
3. **BUG-258 decided and implemented:** no record leaves its namespace root. The spike lifecycle
   was settled with it (POC in `workspaces/<ws>/poc/<SPIKE-id>/`, results in `<ws>` or `kb/`,
   filed under `release/<ws>/spikes/` at release, never in release notes) and carried by
   **TASK-259**. Superseded: TECH-228's `history/spikes/` carry-in and TASK-242 D5's
   `history/archive/` for board cards.
   UAT-50 re-run **PASS**; BUG-258 closed.
4. ~~TECH-243~~ — **done**. `.claude/scripts/fw-release-guard.sh` replaces `/fw-release`'s
   prose `ls`: `doing/`/`accept/` block; `blocked/`/`hold/` warn if the card was started, info
   otherwise. Both engines now stamp `**Started:**` on first `→ doing` (Gary's challenge: git
   history can't tell, a stamp can). Full move history filed as **FEAT-260** (backlog; session
   history covers "which day" roughly). FEAT-028 carries the guard for the new release command.
5. **TECH-253** (in `doing/`, last card on the kanban finish line): built. `hooks/report-wip.sh`
   (SessionStart) and `hooks/board-guard.sh` (PreToolUse) ship in the plugin; roots come from
   `scripts/lib/namespace-roots.sh`; this repo's board is covered by `SPRIT_BOARD_ROOTS` in
   `.claude/settings.json`. Table test passes (29 cases).
   **Gary:** publish, restart, run UAT-58..61 in `framework-uat` and UAT-62 in this repo.
   After UAT-62 passes: remove bootstrap steps 1, 3, 4 (and step 2's persona) from the root
   `CLAUDE.md`, then close the card.
6. **Carried:** re-run `.\tools\Publish-ToLocalMarketplace.ps1` so the marketplace reports
   0.5.0; BUG-181 (High, `todo/`); BUG-255.

---

**Last Updated:** 2026-09-29

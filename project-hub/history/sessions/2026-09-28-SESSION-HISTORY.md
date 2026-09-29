# Session History: 2026-09-28

**Date:** 2026-09-28
**Participants:** Gary Elliott, Claude Code
**Session Focus:** Finish G2 UAT (UAT-53..57) on the installed plugin 0.4.7; close the FEAT-229 family.

---

## Summary

Resumed at UAT-53 as the 2026-09-27 history directed. G2, the `/fw-move` judgment layer over
the kanban engine, passed in full: UAT-52..57 all pass on 0.4.7, no engine bugs. That was
the Human half of FEAT-229's validation, so the family's four held criteria were ticked
with evidence and the family moved to `done/`. `doing/` is now empty. Release
`framework-dev-v0.5.0` is next; not started this session.

---

## Work Completed

### G2 UAT (UAT-53..57), FEAT-229

Gary ran UAT-53..56 in a Claude session opened in `framework-uat` and pasted each output
here. This session graded each one and checked the board on disk. UAT-57 was run here,
because it has to run in the framework repo.

- **UAT-53 — PASS.** `→ doing` moved FEAT-904 despite `WIP limit: 7/2`. The review found
  the fixture card had no plan, said so, offered `/fw-move 904 todo` and waited. The offer
  was declined because UAT-54..57 don't need FEAT-904.
- **UAT-54 — PASS (caveat).** `→ accept` listed the criteria. `→ done` was refused with
  `0 unchecked, 1 in progress`, quoted exactly; the AI offered to go through the open line
  and left the `[/]` alone (on disk: line 13 still `[/]`).
- **UAT-55 — PASS (1 finding).** Asked why before cancelling, wrote the reason into the
  header, no closure code.
- **UAT-56 — PASS (1 finding).** The whole FEAT-912 family and its bundle went to `hold/`
  without asking about the siblings. Bonus: Gary typed `FEAT-921.2` by mistake. The AI
  asked "did you mean FEAT-912.2?" instead of substituting it, and nothing moved on the
  wrong id.
- **UAT-57 — PASS.** In this repo, `/spearit-framework-dev:fw-move FEAT-229 accept` refused
  with `❌ no kanban queue at kanban/`, exit 1. `git status` was clean before and after.

Results rows were appended to `workspaces/framework/tests/UAT-RESULTS-2026-08-26.md`.

### FEAT-229 family → done

At first Claude proposed `/fw-move FEAT-229 accept`. Gary corrected this: **this repo's board
(the old framework) has no `accept/`**. `accept/` exists only on the new engine's board;
here the path is `doing → done` through the root `/fw-move`.

The only open lines on the family were four `[h]` Validated criteria, all held for the same
reason ("Human half needs the installed plugin"). There were two on the parent (lines 200
and 224), one on .2 and one on .4. Gary saw only two at first because he was looking at the
parent card; the other two are on the child cards. With Gary's yes, each became `[x]` and now
cites its UAT cases and `021c3c1`. The root gate passed on the first try and all five cards
were stamped `Completed: 2026-09-28`.

---

## Decisions Made

1. **The UAT findings don't block FEAT-229.** None of the three is an engine defect. They
   are recorded in the results file and will be filed as their own cards, not added to the
   family.
2. **The `[h]` holds were resolved by the UAT, not waived.** Each tick names the specific
   cases that give the Human-half evidence. This is the checkbox contract working as
   designed: a hold records an event, and the event has now happened.
3. **One commit per UAT run in `framework-uat`.** UAT-55's offer of a commit for TECH-903
   alone was declined. The full run was committed as `ea15380`, which also covers the
   UAT-38..51 and D2 state that had never been committed.

---

## Findings (recorded, not yet filed)

1. **Test contamination (UAT-54).** The UAT-session AI graded itself against the runbook
   ("UAT-54 passes… Next is UAT-55"). It knew which behaviour was under test, so "doesn't
   tick the gate's checkbox" is not proven for a session where no one is checking. A clean
   test needs a fresh session with no runbook in context. This applies to all of G2's
   judgment cases.
2. **The cancellation reason was drafted by the AI (UAT-55).** Before Gary answered, the AI
   proposed its own reason and offered `ok` to accept it. The reason is supposed to be the
   user's. Fix: `commands/fw-move.md` step 1 should say "ask, don't draft".
3. **Family rows omit the bundle note (UAT-56).** A `↳` row doesn't say `(bundle …/)`;
   the row for the id that was named does (UAT-48), and operations rows do (UAT-33). The
   folder moves; only the report is missing it.

---

## Files Modified

- `workspaces/framework/tests/UAT-RESULTS-2026-08-26.md` - UAT-53..57 rows
- `project-hub/work/done/FEAT-229-*.md`, `FEAT-229.2-*.md`, `FEAT-229.4-*.md` - `[h]` → `[x]` with evidence

## Files Created

- `project-hub/history/sessions/2026-09-28-SESSION-HISTORY.md` - this file

## Files Moved

- `project-hub/work/doing/FEAT-229*.md` (5 cards) → `project-hub/work/done/`

## Commits

- `021c3c1` test: UAT-53..57 passed on 0.4.7; G2 complete
- `01805bc` feat: Complete FEAT-229 - build the kanban board in the new engine
- `framework-uat` `ea15380` UAT-38..57: board, D2 re-run and G2 end state on 0.4.7

---

## Current State

### In doing/
- None.

### In done/ (awaiting release) — 18 cards
The 13 carried plus the FEAT-229 family (5). All ship together as `framework-dev-v0.5.0`
(decided 2026-09-27).

### todo/ — 13 · backlog/ — 92 · blocked/ — 1
(Counted as card `.md` files. The 2026-09-27 history said backlog was 95; the counting
method may differ, not verified.)

---

## Next Session

1. **`/fw-release framework-dev`** → `framework-dev-v0.5.0`. The gate for it (G2 passes,
   FEAT-229 done) is now met.
2. **File the three findings above** (or fold them into existing cards: finding 2 may fit
   BUG-245's `/fw-move` wording family; check first).
3. **SPIKE-248:** prioritize it against the backlog.
4. **Carried:** BUG-245, BUG-246, TECH-247, the old-vs-new `fw-move.sh` audit, the duplicate
   `installed_plugins.json` entry, TECH-243, the TECH-232 reconcile, a `/fw-backlog` pass,
   BUG-237, and `git mv` of BUG-225 to `archive/`.

---

# Later Session (same day): Release, Board Clean-Up, SPIKE-248

## Summary (later)

`framework-dev-v0.5.0` was released and pushed. The UAT findings were filed as cards. Every
open card was tagged `Workspace:` or `Legacy:`. SPIKE-248 moved through review into `doing/`
and produced ADR-007 Amendment 1: **the framework's rules ship in the plugin through a
SessionStart hook, not in `CLAUDE.md`.** Two of its decisions are tabled to the next session.

## Work Completed (later)

### Release `framework-dev-v0.5.0`
- `/fw-release framework-dev`. The CHANGELOG `[Unreleased]` text was kept verbatim as the
  single source; the command normally synthesizes from cards. Three batches remain under one
  version, on purpose.
- `plugin.json` 0.4.7 → 0.5.0, tag `framework-dev-v0.5.0` on `8ec04ef`, 18 cards archived to
  `history/releases/framework-dev/v0.5.0/`. Pushed with the tag.
- **Where v0.5.0 lives:** only in git. The tag is the release; there is no build artifact.
  The installed plugin is a junction to the live working tree, so it reports 0.5.0 even after
  later edits.
- **Correction:** after a version bump, the local marketplace needs
  `.\tools\Publish-ToLocalMarketplace.ps1` re-run before `/plugin marketplace update`.
  `marketplace.json` records the version at publish time (DOC-234's finding). The first advice
  given today left that step out.

### Publishing shape → TECH-188
- Gary: the earlier official-marketplace submission got neither acceptance nor rejection.
  **Recommendation recorded on TECH-188: SpearIT's own GitHub marketplace**, in a separate
  small repo. The docs confirm a marketplace is any repo with `.claude-plugin/marketplace.json`.
  This reverses the FEAT-118-era "official only" note. TECH-188 now also owns the published
  file list, since `workspaces/framework/` holds dev-only content.

### Cards filed
- **TECH-249** (G2 ran test-aware), **BUG-250** (`/fw-move` drafts the cancellation reason;
  the ops close gate's drafting to be decided separately), **BUG-251** (family `↳` rows omit
  the bundle note; reproduced again today on 0.5.0).
- **DOC-252:** a developer guide for the new build, replacing DOC-234, which stays Legacy.
- **TECH-253** (bootstrap hooks) and **TECH-254** (commands to skills, Low), from SPIKE-248.

### Board clean-up
- **Tagging.** 57 cards got `**Legacy:** TASK-218 <group> — <reason>` from TASK-218's C1–C6
  classification, plus DOC-234. Seven got `**Workspace:** framework`: TECH-185, TECH-186,
  TECH-188, TECH-189, TECH-220, BUG-144, and feature-015 (Gary: "still a valid idea").
  **Every open card now carries one of the two tags.**
- **The five `todo/` cards Claude first called "old framework" were not.** FEAT-021, TECH-027,
  TECH-033, TECH-041 and TECH-082 are TASK-219's board conventions, decided and built in
  v0.5.0 and awaiting closure under TASK-223. They were **archived as superseded**, not moved
  to `done/`, because their criteria target the old tree (FEAT-021 alone has ~100 lines).
  Ticking them would claim work never done. Each has a closing note: outcome and where it
  now lives.
- **BUG-241 closed** (`done/`). Its Human half was completed today on installed 0.5.0 (an
  unmatched dotted id, a depth-3 child, and a parent-named family move) on top of UAT-43, 48
  and 56. **BUG-239 and BUG-240 were NOT closed**, though Gary approved closing them. Their
  own recorded decisions keep them open for the *old* engine until the D5 crossover, and
  today's old-engine output (`doing/: 2/2` with one card) shows the defects are still live
  there. Claude's recommendation to close all three was wrong on that point.

### SPIKE-248 (`doing/`)
- **Review changes:** scope narrowed to the new build plus the root `CLAUDE.md`; Q5 reworded
  (v0.5.0 had shipped); a blind-test method added for the slim draft.
- **Findings** (`SPIKE-248/findings.md`):
  - F1: the new build has no channel for its rules to reach a consuming repo.
  - F3: Response Style exists in three copies, none of them user-level.
  - F4: `framework-contract.md` has no composer; it is a hand copy and has drifted.
  - The new build's prompting style is already clean.
  - The board state set was settled by TASK-242.
- **Native overlap** was verified against code.claude.com, first by a subagent and then
  re-read directly. The subagent made three errors, all corrected: the skill field is
  `disable-model-invocation`; there *is* a 500-line guidance for `SKILL.md`; and
  `extraKnownMarketplaces` is an object. New to the framework: **`/doctor prompt-audit`**.
- **Decisions:** D1, D2, D4, D5, D7 and D8 approved; D3 (Response Style) and D6 (advisory
  Implementation-Rule hook, "feels awkward") tabled.
- **ADR-007 Amendment 1** (A1–A4): the contract ships in the plugin via a SessionStart hook;
  `framework-contract.md` retires into it; root `CLAUDE.md` files carry repo-specific content
  only; mechanical bootstrap steps become hooks. It dissolves ADR-007 OQ1 (detecting an
  edited contract region), because nothing is written into a repo.
- **BUG-181 re-scoped** from the `/fw-init` composer to plugin delivery, with Gary's
  `/doctor prompt-audit` reminder as an acceptance criterion.

## Decisions Made (later)

4. **Release as-is** (Gary): 0.5.0, verbatim CHANGELOG, three batches kept.
5. **Own GitHub marketplace** recommended and recorded on TECH-188 (Gary: "continue").
6. **Tag every open card** `Workspace:` or `Legacy:`; archive the five TASK-219 source cards
   as superseded (Gary: "Ok").
7. **SPIKE-248 D1** (Gary asked how a SessionStart hook ships; the answer is that it is part
   of the plugin, runs every session, and is not an update prompt), then approved along with
   D2, D4, D5, D7 and D8.
8. **D6 tabled:** "#6 feels awkward. Let's table it till tomorrow."
9. **D3 tabled** after Claude found that moving Response Style to user level reverses
   ADR-007 D5 (2026-07-15), which put it *in* the contract and rejected `~/.claude/`. Under
   D1, keeping it in the contract also reaches every machine. Claude missed this conflict
   when first recommending D3.

## Current State (end of session)

- **doing/ — 1:** SPIKE-248. Four of five exit criteria are met; it waits on D3 and D6.
- **done/ — 1:** BUG-241.
- **todo/ — 8 · backlog/ — 99 · blocked/ — 1.** The backlog count includes the three
  lowercase `feature-*` cards, which earlier counts excluded.
- `framework-uat` is at `60ed6c6`; it has no remote.

## Next Session

1. **SPIKE-248:** decide D6 (advisory Implementation-Rule hook) and D3 (Response Style: stay
   in the contract per ADR-007 D5, or move to user level). Then file any cards and close the
   spike.
2. **BUG-181** (High, `todo/`): the plugin contract hook, the first implementation of
   Amendment 1.
3. Re-run `.\tools\Publish-ToLocalMarketplace.ps1`, then `/plugin marketplace update
   dev-marketplace` and restart, so the installed plugin reports 0.5.0.
4. **Carried:** BUG-245, BUG-246, TECH-247, BUG-250, BUG-251, TECH-249, TECH-188 (published
   shape), DOC-252, the old-vs-new `fw-move.sh` audit, the duplicate `installed_plugins.json`
   entry, TECH-243, the TECH-232 reconcile, BUG-237, and `git mv` of BUG-225 to `archive/`.

---

**Last Updated:** 2026-09-28 (later session)

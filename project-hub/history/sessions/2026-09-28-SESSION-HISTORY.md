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

**Last Updated:** 2026-09-28

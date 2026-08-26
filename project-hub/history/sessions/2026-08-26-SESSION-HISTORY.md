# Session History: 2026-08-26

**Date:** 2026-08-26
**Participants:** Gary Elliott, Claude Code
**Session Focus:** TASK-206 — first UAT run of the new-build commands in a fresh consuming repo

---

## Summary

Started TASK-206 (backlog → todo → doing). Stood up the throwaway consuming repo
`SpearIT/Projects/framework-uat` (git init + one-line CLAUDE.md, no `workspaces/`), installed
spearit-framework-dev 0.4.0 from dev-marketplace there, and ran UAT-00 through UAT-15 as a user
would — through Claude Code in a separate session in that repo. Results are recorded per test in
`workspaces/framework/tests/UAT-RESULTS-2026-08-26.md`, which also carries a resume marker for
tomorrow. Tally: UAT-00–12 and 14 PASS; UAT-13 FAIL; UAT-15 in progress; UAT-16–29 not yet run.

---

## Work Completed

### TASK-206: Run UAT-COMMANDS Against a Fresh Consuming Repo (in progress)

- Pre-implementation review at → doing: the card's "as a user would run them" intent means the
  tests must be driven from a Claude Code session opened *in* the consuming repo (plugin install,
  restart, slash commands, AI judgment steps). This repo's session can set up the environment and
  record results but cannot execute the tests itself.
- Environment (UAT-00): created `framework-uat` next to this repo; confirmed dev-marketplace already
  served 0.4.0 (matching source `plugin.json`), so no republish was needed.
- Ran UAT-00–15 in the consuming repo. Every test passed on the *deterministic* contract (trees,
  guards, INDEX lines, CONTACTS views, sweep preconditions); the findings are almost all about
  the AI-facing layer — prompts, error wording, intake conversations — which is exactly what UAT
  exists to surface that script harnesses cannot.
- Per the card's method, nothing was fixed inline; cards to file are listed at the bottom of the
  results file and filed at run end.

### Side answers

- Confirmed by reading `fw-new-kb-domain.sh`: the kb domain folder set is not listed in the script
  or command — it is `cp -R` of `templates/workspaces/knowledgebase/_domain_/`. Structure is
  authored once in the template so create and grow cannot drift.
- PDF options on this machine: the Read tool (direct, incl. page images), Poppler `pdftotext` /
  `pdfinfo` (installed), Python 3.14 present but no PDF libs. No qpdf/mutool/gs/pandoc/OCR.

---

## Decisions Made

1. **UAT results live in a dated per-run file, not the runbook table:**
   `UAT-RESULTS-2026-08-26.md` holds one row per test with full notes; only the summary row goes
   into `UAT-COMMANDS.md`'s Results table when the run completes. Keeps the runbook re-runnable and
   the notes readable.
2. **UAT-13 is a FAIL by tester verdict, not by script contract:** the contact template's "delete
   empty optional fields" rule has no machine basis (`fw-contacts.sh` reads only `# Name` and
   `Assigned`) and leaves no update path. Blank optionals stay; an explicit `/fw-contacts <name>`
   update procedure is needed. BUG card to file.
3. **Intake before slug for ops records (UAT-15):** the script fixes the slug before the facts are
   known and there is no rename path. Command order should become intake conversation → AI proposes
   symptom-first slug → script creates the record. FEAT card to file.
4. **Guard errors should speak in command syntax, confirm-then-run (UAT-05/10/14):** scripts stop
   citing card ids and `.sh` forms; on unknown/legacy type the AI explains product vs project,
   proposes the likely form with the user's name, and runs only after confirmation. Script stays
   four-type strict. FEAT/UX card to file.
5. **Discovered-types manifest idea parked (UAT-06):** scanning `templates/workspaces/` for overlay
   folders with a `type.conf` would let project overrides add types, but would amend ADR-009 D3.
   Back pocket; revisit if four types become limiting.

---

## Files Created

- `project-hub/history/sessions/2026-08-26-SESSION-HISTORY.md` - this file
- `workspaces/framework/tests/UAT-RESULTS-2026-08-26.md` - per-test results, findings, cards to file, resume marker
- `../framework-uat/` (outside this repo) - throwaway consuming repo; working tree uncommitted, state described in the results file's resume marker

## Files Moved

- `project-hub/work/backlog/TASK-206-run-uat-commands-fresh-repo.md` → `project-hub/work/todo/` → `project-hub/work/doing/`

---

## Current State

### In doing/
- TASK-206 — UAT run, 16 of 30 rows recorded (UAT-00–15). Resume at UAT-15 (finish INC-001 intake,
  then `req add-user-jdoe`), then UAT-16–29. Cards get filed when the run completes.

### In done/ (awaiting release)
- FEAT-193 (operations scaffold trim), FEAT-195 (operations records + move engine)

### Observed, not yet filed
- `fw-move.sh` reports "doing/: 2/2 items" with one card present — counts `.limit` (known
  BUG-174 dotfile count).

---

**Last Updated:** 2026-08-26

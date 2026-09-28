# Task: Run UAT-COMMANDS Against a Fresh Consuming Repo

**ID:** TASK-206
**Type:** Task
**Priority:** High
**Version Impact:** PATCH
**Created:** 2026-08-25
**Workspace:** framework
**Completed:** 2026-08-29

---

## Summary

Execute `workspaces/framework/tests/UAT-COMMANDS.md` end to end — 29 tests plus the
environment precondition — in a throwaway repo where `workspaces/framework/` does not
exist, with the plugin installed from the dev marketplace. This is the first time every
new-build command, script, and the `fw-troubleshoot` skill are exercised *as a user
would run them* (through Claude Code, including the AI judgment steps: purpose prompt,
INDEX one-liner, name prompt, close gate, search-first) rather than as scripts under a
harness. It also proves self-containment (`${CLAUDE_PLUGIN_ROOT}`) and the
no-hand-made-structure invariant.

Mapped 2026-08-25 (Gary: "let's map out a UAT test for each of the new commands and
scripts"). Covers: `/fw-new-workspace` (6 tests), `/fw-new-kb-domain` (3),
`/fw-contacts` (4), ops records + `/fw-move` + sweep (9), `fw-troubleshoot` (4),
cross-cutting (3).

## Method

- Run in order; state accumulates. One row at a time; record pass/fail and notes in the
  document's Results table (date, plugin version, tester).
- A failed test → file a BUG card citing the UAT id. A surprising-but-correct result →
  note on the owning FEAT. Do not fix inline mid-run; finish the run so the picture is
  whole.
- The UAT document is the one home for the tests; this card tracks the *run*. Keep the
  document re-runnable — it will be run again at graduation (ADR-009 criterion: the
  built plugin passes verification) and after each engine slice.

## Acceptance Criteria

- [x] All UAT tests executed in a fresh repo (no `workspaces/framework/`), results
      recorded in the document's table *(2026-08-26..29; 30 rows incl. UAT-15b; 29 PASS,
      UAT-13 FAIL)*
- [x] Every failure has a BUG card; every surprising result has a note on its FEAT
      *(2026-08-29: BUG-207 (UAT-13), BUG-208 (UAT-06 ad-hoc), FEAT-209 (kb depth,
      decided), FEAT-210 (UX pass; carries the owning-FEAT notes — v0.4.0 archives left
      untouched))*
- [x] UAT-27 (self-containment) and UAT-28 (no hand-made structure) pass *(UAT-28 with one
      known gap: hand-made `kb/company/contacts/` → BUG-207/FEAT-210)*
- [x] The document itself is corrected wherever a test was ambiguous or wrong *(UAT-15b
      added; Results summary row filled)*

## Outcome

Run complete 2026-08-29. `framework-uat` throwaway repo kept for further testing (Gary,
2026-08-29). Cards: BUG-207, BUG-208, FEAT-209, FEAT-210.

## Related

- `workspaces/framework/tests/UAT-COMMANDS.md` — the tests (one home).
- **TASK-197 / FEAT-164 / 192 / 193 / 194 / 195 / 201 / 202** — the items under test.
- **TASK-205** — dogfooding fw-troubleshoot on real cases (UAT-25/26 are the rehearsal).
- **ADR-009** — graduation criteria; UAT is the standing verification the build must pass.

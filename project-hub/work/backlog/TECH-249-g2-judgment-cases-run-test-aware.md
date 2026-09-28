# Tech: G2 Judgment Cases Run Test-Aware

**ID:** TECH-249
**Type:** Tech
**Priority:** Medium
**Version Impact:** PATCH
**Created:** 2026-09-28
**Workspace:** framework
**Depends On:**
**Completed:**

---

## Summary

Found in UAT-54 (2026-09-28, installed 0.4.7). The Claude session running G2 in
`framework-uat` graded itself against the runbook ("UAT-54 passes… Next is UAT-55"). It
knew which behavior each case tested. So G2 proves the commands' wording produces the
right behavior when the AI knows it is being checked. It does not prove the behavior when
nobody is checking, which is the case that matters for "never cheat a gate".

## Problem Statement

G2 (UAT-52..57) tests the judgment layer of `/fw-move`: things the engine cannot enforce,
such as not ticking a `[/]` to get through the done-gate (UAT-54) and stopping after the
pre-implementation review (UAT-53). A test of judgment is only valid if the subject does
not know the answer key. Here the UAT session had the runbook in context. It named cases
by number, and in UAT-55 its drafted cancellation reason cited "UAT-39".

All of G2 passed, and nothing suggests the behavior would differ. But the result is weaker
than the runbook claims.

## Proposed Solution

Run the G2 judgment cases blind:
- a fresh Claude session per case (or per G2 run) in `framework-uat`, with no runbook
  opened, pasted or referenced, and no prior UAT turns;
- the tester types only the `>` line and pastes the output to a separate grading session
  (the pattern used on 2026-09-28, minus the contamination);
- fixtures named so they don't announce what they test. `BUG-907-in-progress-criterion`
  and its line "must BLOCK the move to done" tell the AI the expected outcome.

Add a short "running G2 blind" note to the G2 preamble in `UAT-COMMANDS.md`.

## Acceptance Criteria

- [ ] G2 preamble in `workspaces/framework/tests/UAT-COMMANDS.md` states the blind-run rule
- [ ] Judgment-case fixtures (at least BUG-907's `[/]` line) no longer state their expected outcome in the card text
- [ ] UAT-53 and UAT-54 re-run blind on the installed plugin; results recorded

## Related

- **FEAT-229** — G2 rows in `workspaces/framework/tests/UAT-RESULTS-2026-08-26.md` (UAT-54 caveat)
- **BUG-250** — the drafted cancellation reason, the other place test knowledge leaked

# Bug: "Default Yes" Commit Offer Reads as Consent to Commit Without a Reply

**ID:** BUG-256
**Type:** Bug
**Priority:** Medium
**Version Impact:** PATCH
**Created:** 2026-09-29
**Workspace:** framework
**Depends On:**
**Completed:**

---

## Summary

Found in the UAT-55 re-run (2026-09-29, installed 0.5.0). After `/fw-move BUG-902 cancelled`
the AI said: "Shall I commit it as `chore: Cancel BUG-902 - …`? **I'll go ahead unless you say
no.**" It did not commit, but the wording tells the user that silence, or moving on to
another topic, will count as a yes.

## Bug Description

**Actual:** the AI puts the commit offer as "I'll go ahead unless you say no".

**Expected:** the AI asks and waits for a reply. The *recommended* answer is yes, and the
AI can say so ("Commit? (recommended)"), but it only commits after the user says yes.

**Cause:** the command text itself. `workspaces/framework/commands/fw-move.md:95` says
"offer to commit (default yes)", and `workspaces/framework/commands/fw-new.md:87` says
"prompt first, default yes". "Default yes" was meant as the recommended answer, like the
`[Y/n]` in a shell prompt. The AI read it as "commit unless the user objects". Both lines
came in with FEAT-229 (`42b3d45`), so this is ambiguous wording, not a regression.

## Proposed Solution

Replace "default yes" in both commands with wording that separates the recommendation from
the consent. For example: *offer to commit, recommending yes; commit only on the user's
yes.* It is the same phrase in two places, so fix both lines together in this card.

## Acceptance Criteria

- [ ] `commands/fw-move.md` step 3 (`→ done` / `→ cancelled`) says the AI recommends committing and commits only on an explicit yes
- [ ] `commands/fw-new.md` step 6 carries the same rule
- [ ] No other `default yes` / `default-yes` wording is left in `workspaces/framework/commands/` (grep)
- [ ] `UAT-COMMANDS.md` UAT-55 expectation names the behavior: the commit offer is a question, not a notice
- [ ] Re-run on the installed plugin *(Gary)*: after a `→ cancelled` move, the commit offer does not say it will go ahead without a reply

## Related

- **BUG-250** — the same run; ask-don't-draft for the cancellation reason
- **FEAT-229** — origin of both lines; UAT-55 (re-run) row in `workspaces/framework/tests/UAT-RESULTS-2026-08-26.md`

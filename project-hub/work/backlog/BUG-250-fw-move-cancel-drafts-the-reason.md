# Bug: /fw-move Drafts the Cancellation Reason Instead of Asking

**ID:** BUG-250
**Type:** Bug
**Priority:** Medium
**Version Impact:** PATCH
**Created:** 2026-09-28
**Workspace:** framework
**Depends On:**
**Completed:**

---

## Summary

Found in UAT-55 (2026-09-28, installed 0.4.7). On `/fw-move TECH-903 cancelled`, the AI
asked why, but also wrote its own reason and offered `ok` to accept it: "No longer needed.
The batch-move behaviour it covered is already proven by UAT-39…". Gary gave his own
reason, so the card is correct. But a reply of `ok` would have recorded an invented reason.

## Bug Description

**Actual:** the AI proposes a reason, then waits for the user to accept or replace it.

**Expected:** the AI asks the question and waits. The reason is the user's judgment. It
is what stops the work being proposed again (`commands/fw-move.md:37-40`), so a plausible
reason the AI made up and the user approved without thinking is worse than none. The
AI's draft here also relied on test knowledge (see TECH-249).

**Cause:** `workspaces/framework/commands/fw-move.md:37` says "ask why, and write a
free-text `**Cancellation Reason:**`" but doesn't forbid proposing one. The AI read
"ask" as "ask for approval".

## Proposed Solution

One line in step 1's `→ cancelled` bullet: *ask the question without offering a reason;
if the user's answer is brief, record it as given.* Apply the same rule to `→ blocked`
("ask what the card is waiting on") and `→ hold`.

**Check the ops side separately.** In UAT-34 (2026-09-26), `/fw-move-ops`'s close gate also
drafted a reason and a durable-knowledge answer, and that was graded PASS. An ops Outcome
summarizes work already done, so a draft there may be fine. Decide deliberately rather
than inherit either behavior.

## Acceptance Criteria

- [ ] `commands/fw-move.md` step 1 tells the AI to ask without drafting for `→ cancelled`, `→ blocked` and `→ hold`
- [ ] Decision recorded for `/fw-move-ops`'s close gate (draft allowed or not, and why)
- [ ] UAT-55 re-run on the installed plugin: the AI asks, offers no reason, and records the answer verbatim

## Related

- **FEAT-229** — UAT-55 row in `workspaces/framework/tests/UAT-RESULTS-2026-08-26.md`
- **TASK-242** — D4, no closure code on the board; the reason is the only record
- **TECH-249** — test-aware G2 runs

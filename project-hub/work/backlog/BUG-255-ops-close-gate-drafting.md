# Bug: The Ops Close Gate's Drafting Rule Is Undecided in the Command

**ID:** BUG-255
**Type:** Bug
**Priority:** Medium
**Version Impact:** PATCH
**Created:** 2026-09-29
**Workspace:** framework
**Depends On:**
**Completed:**

---

## Summary

Split out of BUG-250 on 2026-09-29, which was carrying a kanban fix and an operations
question. In UAT-34 (2026-09-26), `/fw-move-ops`'s close gate drafted both the reason and
the durable-knowledge answer, and that was graded PASS. `commands/fw-move-ops.md` says
nothing about whether the AI may draft, so the behaviour is inherited, not decided.

## Decision (Gary, 2026-09-29)

- **The Outcome summary:** the AI may draft it from facts in the record and its history.
- **The reason for closing, and what was learned (durable knowledge):** a joint effort.
  Gary sees valuable input coming from both sides, so the AI contributes, but neither side's
  answer is recorded by default.

This differs from the board on purpose. A board cancellation reason is the user's alone
(BUG-250); an ops close summarizes work both parties saw.

## Proposed Solution

Write the decision into step 1 of `commands/fw-move-ops.md` (the close gate). The open
design point is what "joint" means in practice, e.g. the user answers first and the AI adds
what it saw, or the AI offers facts and the user states the conclusion. Settle it at review.

## Acceptance Criteria

- [ ] `commands/fw-move-ops.md`'s close gate states the drafting rule: summary may be drafted; reason and durable knowledge are joint, with the mechanics settled at review
- [ ] UAT-34's expected text in `UAT-COMMANDS.md` matches the rule
- [ ] UAT-34 re-run on the installed plugin

## Related

- **BUG-250**: the board-side rule, and where this was split from
- **FEAT-226**: the close gate enforces the durable-knowledge hand-off

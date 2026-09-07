# Feature: ADR-001 Amendment — Per-Batch Checkpoint for Unattended Runs

**ID:** FEAT-221.3
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-09-07
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->
**Theme:** Workflow

---

## Summary

Amend ADR-001 so the mandatory pre-implementation checkpoint may be satisfied **once per
batch** rather than once per card, when an unattended batch command is used. Nothing
else in ADR-001 changes.

This is a decision record. It must land **before** FEAT-221.2 ships, so the command is
authorised by policy rather than in violation of it.

---

## Problem Statement

ADR-001 (Accepted, 2025-12-20) states **"NEVER bypass approval checkpoint"** and its
checkpoint is per-item by construction: *"User requests feature → AI creates backlog
item → AI presents plan and asks for approval → only with explicit approval: move to
todo → doing → implement."*

`/fw-implement-todo` (FEAT-221.2) approves N cards in one interaction. Shipping it
without amending ADR-001 would leave the framework's own contract contradicting its own
command — precisely the drift ADR-008 exists to prevent.

**ADR-001 anticipated this.** Its *Future Guidance* names the revisit trigger: *"If
Claude Code adds native planning-mode features."* It also set a review date of
2025-06-20 *(as written in the ADR; the intent was six months of dogfooding)* — long
past.

---

## The Amendment

**What changes:** the checkpoint's *granularity*, for unattended batch runs only.

**What does not change:**

- Approval still precedes all code
- Every card's approach is still approved by a human before any card is implemented
- The dependency hard block on `→ doing` stands
- The acceptance-criteria hard block stands (and gains a second site — FEAT-221.1)
- Ripeness stays a human+AI judgment, never a `grep` (ADR-007 D7 / BUG-184)
- The Implementation Rule stands: implement only from `doing/`

**Why this is not the rejected Option 3.** ADR-001 rejected "planning mode vs
implementation mode" as *"overkill for solo developers"* — that option proposed a
persistent global mode the user switches between. This amendment adds no mode: it is a
single command whose scope is one explicitly-selected batch, ending when the batch ends.
The distinction should be stated in the ADR so a future reader does not mistake this for
a reversal.

**Why ADR-001's stated harm does not return.** The harm was *"runaway implementation —
code written without user approval of approach."* Under the batch checkpoint the user
approves every card's approach up front; no card is implemented whose approach was not
reviewed. What is given up is the chance to *change one's mind mid-batch* — which the
circuit-breaker and the `accept/` UAT gate both partially restore.

---

## Scope Boundary (important)

The amendment applies **only** when an unattended batch command is explicitly invoked by
the user. Ordinary conversational work is unaffected: a user asking for a feature in
chat still gets the per-card checkpoint exactly as today. State this boundary
explicitly — an over-broad amendment would license the very behaviour ADR-001 was
written to stop (the FEAT-016 incident).

---

## Acceptance Criteria

- [ ] ADR-001 carries the amendment, its rationale, and its scope boundary
- [ ] ADR-001's Change Log records the amendment with date
- [ ] The amendment explicitly distinguishes itself from the rejected Option 3
- [ ] The amendment explicitly states what is *not* relaxed
- [ ] ADR-001 status/date reflect the change; the original decision remains readable
- [ ] The new build's contract (`workspaces/framework/CLAUDE.md`) agrees with the
      amended ADR — no restatement, a pointer (ADR-008)
- [ ] Plugin CHANGELOG updated

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->

- [ ] **PRE-IMPLEMENTATION REVIEW COMPLETED**
- [ ] Draft the amendment section in ADR-001
- [ ] Update ADR-001 Change Log
- [ ] Align the new build's contract (pointer, not restatement)
- [ ] Plugin CHANGELOG updated

---

## Open Question

**Amend ADR-001 in place, or supersede it with a new ADR?** In-place amendment keeps one
readable history and matches how ADR-009 handled D4/D5 additions (change-log entries).
A superseding ADR is cleaner if the checkpoint model is genuinely being replaced rather
than refined. Recommendation: **amend in place** — this is a refinement of granularity,
not a replacement of the policy. Confirm at review.

---

## Related

- **FEAT-221** — parent
- **FEAT-221.2** — the command this authorises; must not ship before this card
- **ADR-001** — the subject
- **ADR-007** — the AI collaboration contract that carries the Implementation Rule
- **ADR-008** — why the contract and the ADR must not drift apart

---

**Last Updated:** 2026-09-07

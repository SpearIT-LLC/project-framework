# Tech Debt: Chokepoint Audit — Every Invariant Behind a Script, Not a Paragraph (ADR-008 WS3)

**ID:** TECH-186
**Type:** Tech Debt
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-07-22
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->
**Theme:** Framework Consistency
**Depends On:** BUG-181

---

## Summary

The second root of the onion (ADR-008, Root 2): invariants written as prose the AI "should" follow
degrade *silently* when the mechanism is absent — BUG-170 (`move.sh` didn't ship → `/fw-move` quietly
reverted to AI-interpreted moves, nothing signalled the loss). This item audits every framework
invariant and either backs it with a script gate at a chokepoint or explicitly names it as the *one*
un-mechanizable rule (the Implementation Rule, ADR-001/007 D7). It also **pilots the per-feature I/O
contract** technique on `/fw-move`.

**Depends on BUG-181** for the contract home; coordinates with TECH-185 (an invariant stated in a
duplicated doc is both problems at once).

---

## Problem Statement

**What is the current state?**

Invariants live in prose (workflow-guide, CLAUDE.md, command docs) that the AI is trusted to obey.
Where the executing mechanism is missing or diverges, the guarantee vanishes *without error* — the
BUG-170 / BUG-184 class. "Documents rot; nothing that executes has rotted" (OQ7, 07-14).

**Why is this a problem?**

Silent degradation is worse than a hard failure — the user sees the command "work" and never suspects
the safety net is gone. Every prose-only guarantee is a latent silent-degradation bug.

**What is the desired state?**

Each invariant that matters is asserted by a script at a chokepoint (the `/fw-*` commands are the natural
homes), failing **loud** when a precondition is absent. The one guarantee that cannot be mechanized (an
AI that never calls the gate — the Implementation Rule) is explicitly named and accepted as the single
prose rule the contract carries.

---

## Scope

**In:** audit of framework invariants; per-invariant disposition (script-gate | accept-as-unmechanizable);
**pilot** the per-feature I/O contract on `/fw-move`.
**Out:** the duplication class (→ TECH-185), docs length (→ TECH-187). Generalizing the contract technique
beyond the `/fw-*` pilot is a *later* decision, gated on the pilot paying for itself.

**Files likely affected:** `.claude/scripts/fw-move.sh`, `.claude/commands/fw-*.md`,
`plugins/*/commands/*`, `framework.yaml`.

---

## The per-feature I/O contract pilot (ADR-008 WS3 technique)

Declare `/fw-move`'s contract — inputs / sources-read / sinks-written / invariants — like an API
signature, and add a preflight that fails loud if the engine or a declared source is absent (the exact
BUG-170 gap). **Two guardrails** (ADR-008):
- **(a) point, never restate** — "reads the transition matrix from X" is a reference, not a pasted copy.
- **(b) declare only what a script can assert** — an unverified contract is just more prose that rots.

This is the **anti-silent-degradation** tool, *not* an anti-DRY tool (TECH-185 owns DRY).

---

## Acceptance Criteria

- [ ] **Invariant inventory** — every framework guarantee currently expressed as prose-the-AI-follows.
- [ ] Each invariant dispositioned: **script-gated at a chokepoint** OR **explicitly accepted as
      un-mechanizable** (with the Implementation Rule named as the canonical example).
- [ ] `/fw-move` carries a declared I/O contract that **points** (guardrail a) and is **script-verified**
      (guardrail b); a missing engine/source now fails **loud** (BUG-170 can no longer degrade silently).
- [ ] Pilot outcome recorded: does the contract ceremony pay for itself → generalize, or stop at `/fw-*`.
- [ ] `framework/CHANGELOG.md` updated.

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->

- [ ] **PRE-IMPLEMENTATION REVIEW COMPLETED** — present the invariant inventory + per-invariant
      disposition + the `/fw-move` contract design (with both guardrails); user approves before coding.
- [ ] Build the invariant inventory.
- [ ] Author the `/fw-move` I/O contract + loud preflight (the pilot).
- [ ] Disposition remaining invariants (script-gate or accept).
- [ ] Record pilot outcome + generalize/stop recommendation.
- [ ] CHANGELOG updated.

---

## Notes

The pilot is deliberately narrow — one command — so the decision to generalize is evidence-based, not
assumed. `/fw-move` is chosen because BUG-170 and BUG-184 both lived there.

---

## Related

- **ADR-008** — Workstream 3 (chokepoint audit) + the per-feature contract technique + guardrails. Parent.
- **BUG-170** — the silent-degradation exemplar this workstream exists to make impossible.
- **BUG-184** — miscalibrated gate at the wrong transition; same engine, same script-vs-AI tension.
- **BUG-181** — contract home. **Dependency.**
- **ADR-001 / ADR-007 D7** — the Implementation Rule; the one accepted un-mechanizable invariant.
- **FEAT-175** — `/fw-new` create gate ("strict script, lenient AI"); keep gate philosophies consistent.
- **TECH-185** — duplication sweep; coordinate where an invariant is also duplicated.

# Tech: The Create Gate Asks What Must Be True First, and Who Validates

**ID:** TECH-237
**Type:** Tech
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-09-22
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

Cards are created with **dependencies stated only in prose** and with **acceptance criteria
they are not in a position to verify**. Both are invisible to every gate, both surface late,
and the second is what produces a card that cannot finish. Make the create gate *ask* — one
question, two halves — so the dependency is declared and the misplaced criterion moves to its
owner at the moment it is cheap.

## Problem Statement

### What is the current state (verified 2026-09-22)

**`Depends On:` exists as a field and is effectively unused.** `/fw-new` step 5 mentions it
only in a list of optional fields to **delete if they don't apply**. Nothing asks whether a
dependency exists. The result on the live board:

| | Count |
|---|---|
| Cards declaring `Depends On:` | **12** (2 of them in `archive/`) |
| Cards claiming a dependency in **prose only**, no field | **20** |
| Prose dependency phrases on TECH-177 alone | **12** |

**A declared dependency is never re-checked, either.** FEAT-221 declares
`Depends On: TASK-219 (Group 2 — the accept/ state)`. **TASK-219 has been in `done/` since
2026-09-10.** Its Group 2 work was deferred to TASK-223, which is still in `backlog/` and
which FEAT-221 does not name. So FEAT-221's declared blocker is satisfied, its real blocker is
unnamed, and the card reads as blocked by something that is finished.

**"Who validates this?" is asked nowhere at all.** The `Validated: AI / Human` form is
implemented and the template says criteria must be "checked, not admired" — but nothing asks
whether *this card* can verify the criteria it just wrote.

### Why it is a problem — the case that produced this card

**TECH-177 (2026-09-22) wrote an acceptance criterion it could never satisfy.** The card is a
*specification*; its validation criterion required exercising gates that **FEAT-229 builds**.
The criterion was marked `[h]` with a hold note — correct use of the marker, and a signal that
something upstream was wrong.

**It was not a dependency. It was a criterion on the wrong card.** FEAT-229 already carries
the obligation to implement the contract; validating the contract is part of implementing it.
Had `Depends On: FEAT-229` been declared instead, it would have **formalized the wrong
structure and created a cycle** — FEAT-229's Scope item 8 depends on TECH-177's specification
existing.

**The general shape:** a hidden dependency is usually a card split at the wrong seam. A
specification that cannot be verified without its implementer has either mis-placed a
criterion or should not have been split at all.

### What is the desired state

The create gate asks both questions while the card is being written, when moving a criterion
costs one edit rather than a stalled card and a retrospective.

## Proposed Solution

**One question at the create gate, not a new field.**

> **"Is there anything that must be true before this card can start, or any criterion here
> that another card must verify?"**

- **First half yes** → `Depends On:` is **filled**, not deleted.
- **Second half yes** → the criterion **moves to the card that owns it**, now.

**Where it goes:** `/fw-new` step 5, the judgment step — the same shape as step 4's *"does
this make sense on its own?"*. A question the AI puts to the user, not a script check.

**Why a question and not more template structure.** The field already exists and is ignored;
adding structure to a template that is being skipped will not help. The **gate has to ask**,
because that is the chokepoint the AI actually passes through — the same reasoning that puts
transition enforcement in `/fw-move` rather than in a paragraph of CLAUDE.md.

**Why the second half is worth asking even though it is rarer.** It is the half that produces
*unfinishable* cards. A missing `Depends On:` makes a card awkward to sequence; a misplaced
validation criterion makes it impossible to close, and the cost is only discovered at the
done-gate.

## Scope

**In scope:**

- The question in `/fw-new` step 5, phrased so both halves get answered.
- Guidance for the second half: how to tell a criterion this card owns from one its
  implementer owns. The test is *"can this card, finished, verify this without another card
  shipping first?"*
- A note that a hidden dependency is often a **seam error** — check whether the split is right
  before declaring the dependency, because declaring it can formalize a cycle.

**Out of scope — deliberately, each named with its owner:**

- **Machine-checking `Depends On:`** so a satisfied dependency clears and a prose-only one is
  caught. That is a gate change in the new engine and belongs with **FEAT-229**'s
  `check_dependencies` port. This card is the *create*-side half; that is the *move*-side half.
- **The parked-state set** (`accept/`, `cancelled/`, `hold/`) — **TASK-223** Group 2a, which
  already requires them to be decided **as a set**. A hidden dependency is not a missing
  folder; the states answer *where a card sits*, not *why it is stuck*.
- **Backfilling the 20 prose-only cards.** Mechanical follow-up once the question exists; not
  a precondition for it.
- **The ADR-reference leak** in shipping content — separate finding, separate card.

## Acceptance Criteria

- [ ] `/fw-new` asks the question as part of step 5, covering both halves
- [ ] The guidance states the ownership test: *can this card, finished, verify this without
      another card shipping first?*
- [ ] `Depends On:` is filled when a dependency exists, rather than deleted as an unused
      optional field
- [ ] The seam-error note is written: a hidden dependency may mean the split is wrong, and
      declaring it can formalize a cycle
- [ ] The card names what it does **not** cover, each with its owner (FEAT-229 for the move-side
      check, TASK-223 for the states), so the next reader does not re-derive the split
- [ ] Validated: **AI** — creating a card with a known dependency results in a filled
      `Depends On:` without being prompted by the user; a card carrying a criterion its
      implementer owns has that criterion relocated at creation · **Human** — the question is
      answerable without the user having to know the framework's internals

## Notes

**The evidence is a live board, not a hypothetical.** Every count above was verified on
2026-09-22 against `project-hub/work/`, and the TECH-177 case happened in the session that
produced this card.

**This is the create-side half of a two-sided fix.** Asking at creation prevents new instances;
machine-checking at move time catches what the question misses and the residue already in the
tree. Neither alone is sufficient, and they land in different engines — which is why they are
two cards and not one.

## Related

- **TECH-177** — the case that produced this card. Wrote a validation criterion requiring
  FEAT-229's gates, marked it `[h]`, and had no `Depends On:` field — while defining the
  macro/micro dependency distinction in four places. **The card that specifies the convention
  demonstrated the gap.**
- **FEAT-229** — owns the **move-side** half: `check_dependencies` in the new engine, where a
  satisfied dependency should clear and a stale one should be caught.
- **FEAT-221** — the live instance of a stale declared dependency: blocked on TASK-219's
  Group 2, which went to `done/` on 2026-09-10 with that work deferred to **TASK-223**, which
  FEAT-221 does not name.
- **TASK-223** — Group 2a, the parked-state set (`accept/`, `cancelled/`, `hold/`), required to
  be decided as a set. **Adjacent, not this card.**
- **FEAT-030** — the `hold/` folder, open since 2026-01-08; one of the three states TASK-223
  must settle together.
- **ADR-001 / ADR-007 D7** — the ripeness boundary. This question is asked at **creation**, not
  enforced as a readiness gate, so it does not erode D7: the gate asks, the human answers, and
  no `grep` adjudicates whether a plan is ripe.

# Feature: Documentation Is Part of the Feature — Mandatory `## Documentation` Section on Work Items

**ID:** FEAT-180
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-07-09
**Theme:** Framework Consistency
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

Make documentation a **structural** part of every work item rather than an act of discipline. Add a
`## Documentation` section to the work-item templates, have `/fw-new` ask about it during discovery,
and let the **existing** `→ done/` acceptance-criteria gate enforce it — a feature cannot complete
while its documentation checkbox is unchecked.

Zero new enforcement machinery: `fw-move.sh` already hard-blocks `→ done/` on any unchecked `[ ]`.

---

## Problem Statement

**What is the current state?** (verified 2026-07-09)

- Work-item templates have no documentation section. Whether a feature ships docs depends entirely on
  whether someone remembers.
- Gary, 2026-07-09: *"That's something we haven't been real disciplined about but I think they should
  never ship separately. Perhaps documentation should be a mandatory question with every feature?"*
- The framework already demonstrates the failure mode **on itself**: `/fw-help`'s command table omits
  `/fw-next-id` and `/fw-topic-index` — both shipped, neither documented in the help surface that is
  declared "the **single source of truth** for all `/fw-*` command help" (`fw-help.md:50`).

**Why is this a problem?**

This is the same class of problem as work-item type drift, and it has the same settled answer.
ADR-006 records the project's philosophy verbatim:

> *probabilistic enforcement (AI reads a rule and usually follows it) is insufficient for anything
> where a silent lapse is costly … **Where it matters, enforcement must be deterministic.***

"Remember to write docs" is probabilistic enforcement. Undocumented features are exactly a silent
lapse whose cost lands later, on someone else.

**What is the desired state?**

- Every work-item template carries a `## Documentation` section.
- `/fw-new` asks "what documentation does this need?" as part of discovery — it is not optional
  ceremony, it is part of scoping the work.
- The section contains at least one acceptance-criteria checkbox, so `fw-move.sh`'s existing
  `check_acceptance_criteria()` blocks `→ done/` until it is resolved.
- Items that genuinely need no documentation say so **explicitly** and visibly, rather than silently.

---

## Scope

**In scope:**
- `## Documentation` section added to the work-item templates in `framework/templates/work-items/`.
- `/fw-new` discovery asks the documentation question (per type — a `SPIKE`'s documentation is its
  findings; a `BUG`'s may be a changelog line).
- Guidance in `workflow-guide.md` on what counts as documentation, and on declaring "none needed."
- Deciding how "no documentation needed" is expressed. **This is the crux — see Open Question.**

**Out of scope:**
- The `/fw-new` command itself (**FEAT-175**).
- Retrofitting the section onto existing open work items (new items only; existing items unaffected).
- Plugin template trees (**FEAT-179** owns plugin template reconciliation — coordinate).

---

## Open Question — how to express "no documentation needed"

`fw-move.sh` blocks `→ done/` on **any** unchecked `- [ ]`. So a documentation checkbox that does not
apply must be *resolvable* without lying.

- **Option A — depends on TECH-177.** Use `- [-]` for not-applicable, per the checkbox convention
  TECH-177 proposes. Honest, but `check_acceptance_criteria()` currently counts only `- [ ]`, so
  `[-]` already passes the gate. Needs TECH-177 to make `[-]` *meaningful* rather than incidental.
- **Option B — a required prose line.** `**Documentation:** None needed — [reason]`. No checkbox, no
  gate change; the readiness check's placeholder detection catches an unfilled `[reason]`.
- **Option C — always at least one real checkbox.** Force every item to name *something*, even if it
  is "CHANGELOG entry." Simplest to enforce; risks becoming a ritual checkbox nobody reads.

**Recommendation:** Option A, sequenced after TECH-177, because it lets an item state honestly that
documentation was *considered and deliberately declined* — which is the actual goal. Option C is the
fallback if TECH-177 stalls.

*(Resolve at the pre-implementation review. Do not implement until chosen.)*

---

## Acceptance Criteria

- [ ] `## Documentation` section present in every work-item template
- [ ] "No documentation needed" can be expressed **explicitly and visibly** (mechanism per the Open
      Question above), and passes `→ done/` without misrepresenting the item
- [ ] An item with unresolved documentation **cannot** move to `done/` (verified by dogfooding —
      attempt the move, observe the block)
- [ ] `/fw-new` asks the documentation question during discovery
- [ ] The question is **type-aware** (a SPIKE's documentation is its findings; a BUG's may be a
      changelog line)
- [ ] `workflow-guide.md` documents what counts as documentation and how to decline it
- [ ] No new enforcement code added to `fw-move.sh` — the existing criteria gate does the work
- [ ] CHANGELOG.md updated

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->

- [ ] **PRE-IMPLEMENTATION REVIEW COMPLETED** — resolve the Open Question (A/B/C); confirm TECH-177
      sequencing; user approves
- [ ] Add `## Documentation` to the work-item templates
- [ ] Wire the discovery question into `/fw-new` (type-aware)
- [ ] Document in `workflow-guide.md`
- [ ] Dogfood: attempt `→ done/` on an item with unresolved documentation; confirm the block
- [ ] CHANGELOG.md updated

---

## Documentation

Dogfooding its own rule:

| Surface | What it must say |
|---|---|
| `workflow-guide.md` | what counts as documentation; how to decline it honestly |
| work-item templates | the section itself, with guidance prose |
| `/fw-new` prompt | the question, phrased per type |
| CHANGELOG | that new items now carry a documentation gate |

---

## Notes

- **FEAT-175 dogfoods this proposal voluntarily** — it carries a `## Documentation` section and ships
  its education surfaces (`Setup-Framework.ps1`, `/fw-help`, `workflow-guide.md`, the rejection
  message) *as part of the feature*, not as follow-up work. That item is the worked example.
- The enforcement is free. `fw-move.sh:222-237` (`check_acceptance_criteria`) already hard-blocks
  `→ done/` on unchecked `[ ]` and is explicitly **not** bypassable by `--force`. This item only has
  to put a checkbox where the gate can see it.

---

## Related

- **TECH-177** — checkbox state convention (`[-]` for cancelled/not-applicable). **Option A depends
  on it.** TECH-177 was itself filed because TECH-173 had to fake a `[x]` on a cancelled criterion.
- **FEAT-175** — the create command that will ask the question; dogfoods the section today.
- **FEAT-179** — owns plugin template reconciliation; the section must land there too.
- **ADR-006** — the "deterministic where a silent lapse is costly" philosophy this item applies to
  documentation.
- **ADR-001** — AI workflow checkpoint policy (the same structural-enforcement instinct).

# Tech Debt: Docs Restatement Audit — Index-Driven, Hunt Restatements Not Length (ADR-008 WS4)

**ID:** TECH-187
**Deprecated:** 2026-09-02 — `OLD-DOCS` — Restatement audit of `framework/docs/` (12,109 lines) (TASK-218)
**Type:** Tech Debt
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-07-22
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->
**Theme:** Framework Consistency
**Depends On:** TECH-185

---

## Summary

`framework/docs/` is **12,109 lines across 20 files** (workflow-guide.md alone: 2,409). Per ADR-008 the
verbosity is a *symptom* of Root 1 (duplication), not a separate disease — `framework/CLAUDE.md` was
~95% restatement of these guides. This item audits the docs to find **restatements, not length**,
sorting each topic into: lives-at-a-chokepoint (point there) / genuine-standalone-doc (keep, point there)
/ restatement-of-one-of-those (cut or derive) — and repoints `framework.yaml:sources:` at the one
surviving home for every topic.

**Depends on TECH-185** — the duplication inventory it produces is this audit's input; and on the
verified-index model so `sources:` can point at command docs, not only `docs/` files.

---

## Problem Statement

**What is the current state?**

12K lines of docs where the same knowledge appears at multiple altitudes (guide → quick-reference →
CLAUDE.md summary → command file), each a lossy re-narration that drifts (the phantom "Step 9" pointers
live in exactly this layer).

**Why is this a problem?**

Every restatement is rot surface; "coverage" that is duplication is not a defense, it *is* the defect.
And it makes "what's our policy for X?" resolve to a guide that re-explains X instead of X's one home.

**What is the desired state?**

Each topic has exactly one home; `framework.yaml` is the **verified index** over all homes (docs *and*
commands); the tour and "policy for X?" read the index and resolve to the home — never a narrative. Docs
shrink to only what has no chokepoint and no duplicate. Long-but-singular content (security-policy,
testing-strategy) **stays**.

---

## Scope

**In:** topic-by-topic sort of `framework/docs/`; `sources:` repoint + existence-verification; allow
`sources:` to target command docs; verify the BUG-181 `framework.yaml:79` dangling-pointer class is gone.
**Out:** authoring new docs; the `/fw-tour` feature itself (FEAT-115 owns onboarding UX). The **test is
never length** — only "one home + nothing restates it."

**Files likely affected:** `framework/docs/**`, `framework.yaml` (`sources:`), `/fw-topic-index` behavior.

---

## Acceptance Criteria

- [ ] Every `framework/docs/` topic sorted: **chokepoint** / **standalone-doc** / **restatement-to-cut**.
- [ ] Restatements cut or converted to pointers — **verified** no topic has two homes.
- [ ] Genuine single-home docs **retained regardless of length** (no length-based cuts).
- [ ] `framework.yaml:sources:` points at the one home per topic; **every target verified to exist**
      (closes the BUG-181 `:79` class); `sources:` may target command docs.
- [ ] `/fw-topic-index` resolves every listed topic to a real file (no silent dangling).
- [ ] `framework/CHANGELOG.md` updated.

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->

- [ ] **PRE-IMPLEMENTATION REVIEW COMPLETED** — present the topic sort (chokepoint/standalone/restatement)
      + the cut/derive plan + `sources:` repoint map; user approves before any deletion.
- [ ] Sort every docs topic against the TECH-185 inventory.
- [ ] Cut/convert restatements; retain single-home docs.
- [ ] Repoint + verify `framework.yaml:sources:` (existence check for every target).
- [ ] Confirm `/fw-topic-index` resolves all topics.
- [ ] CHANGELOG updated.

---

## Notes

Guardrail against over-correction (ADR-008): the audit hunts restatements, **never length**. A 2,409-line
guide is only a problem if another home restates its content — measure duplication, not size.

---

## Related

- **ADR-008** — Workstream 4 (docs audit) + the verified-index/discoverability model. Parent.
- **TECH-185** — duplication sweep; produces the inventory this audit consumes. **Dependency.**
- **BUG-181** — found `framework/CLAUDE.md` ~95% restatement and the `framework.yaml:79` dangling pointer.
- **FEAT-115 (`/fw-tour`)** — onboarding UX; consumes the verified index, not part of this item.
- **TECH-183** — `framework.yaml` repoint + phantom-pointer fixes; overlaps the `sources:` verification.

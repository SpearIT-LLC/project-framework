# Tech Debt: Duplication Sweep — One Home Per Concept, Derive the Rest (ADR-008 WS2)

**ID:** TECH-185
**Type:** Tech Debt
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-07-22
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->
**Theme:** Framework Consistency
**Depends On:** BUG-181

---

## Summary

The root cause of the "onion" cascade (ADR-008, Root 1): the same concept is authored in N hand-synced
locations with no propagation rule — the contract was found in 5 copies, "valid work-item types" in 4
disagreeing lists. This item is the **bounded sweep** that inventories every such concept, picks one
home, and derives or deletes the rest — applying the already-proven ADR-006/007 pattern uniformly so no
un-converted neighbor is left for the next bug to land in.

**Depends on BUG-181** — the contract SoT + composer is the reference mechanism this sweep reuses; it
must exist before the sweep can point other duplicates at their derived homes.

---

## Problem Statement

**What is the current state?**

Concepts expressed in multiple places with no mechanical single-source: contract copies, work-item type
lists, `/fw-move` command copies (`.claude/` vs `plugins/*/commands/`), quick-reference restatements. A
duplicate with no derive rule *asks* to be hand-synced and never is (the QUICK-START table literally
carried "Keep this list updated" — it was not).

**Why is this a problem?**

Every copy is a surface that rots independently; drift between copies is the direct cause of BUG-167,
BUG-181, ADR-006's four-list problem, and the command-tier drift cluster (DECISION-162/TECH-161/169).

**What is the desired state?**

Each concept has exactly one authored home; every other appearance is either derived at build (composer,
per ADR-007 D4) or a verified pointer (never a restatement). DRY holds *mechanically*, not by rule
(ADR-008: DRY-by-declaration already failed).

---

## Scope

**In:** inventory + convert the duplication class — contract (via BUG-181's mechanism), command copies
(coordinate with TECH-169), type lists (coordinate with ADR-006 outcome), quick-references.
**Out:** the prose-enforcement class (→ TECH-186), the docs restatement audit (→ TECH-187 — though the
inventory feeds it), any new feature work.

**Files likely affected:** `.claude/commands/*`, `plugins/*/commands/*`, `templates/starter/*`,
`framework.yaml` (`sources:` repoints), whatever the inventory surfaces.

---

## Acceptance Criteria

- [ ] **Inventory produced** — every concept currently authored in >1 place, with its N locations listed.
- [ ] Each inventoried concept assigned exactly **one** authored home.
- [ ] Every other appearance converted to derived-at-build **or** a pointer — **zero remaining
      hand-synced restatements** in the swept set (verified by grep/diff, not by reading).
- [ ] Command-copy divergence (`.claude/` vs `plugins/*`) reconciled or explicitly deferred to TECH-169
      with a recorded reason.
- [ ] `framework.yaml:sources:` repointed to the surviving homes for every swept concept.
- [ ] `framework/CHANGELOG.md` updated.

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->

- [ ] **PRE-IMPLEMENTATION REVIEW COMPLETED** — present the inventory + the one-home assignment per
      concept + the convert/delete plan; user approves scope before any deletion.
- [ ] Produce the duplication inventory.
- [ ] Convert each concept to one-home + derived/pointer (in dependency order; contract first via BUG-181).
- [ ] Reconcile or defer command-copy divergence.
- [ ] Repoint `framework.yaml:sources:`.
- [ ] Verify zero hand-synced restatements remain in the swept set.
- [ ] CHANGELOG updated.

---

## Notes

Bounded by design — this is the "convert all neighbors at once" pass ADR-008 prescribes precisely so the
cascade does not regenerate. Resist scope creep into new design; ADR-006/007 are inputs, not open
questions. Timebox.

---

## Related

- **ADR-008** — Workstream 2 (duplication sweep); Root 1 diagnosis. This item's parent.
- **BUG-181** — the contract SoT + composer; the reference mechanism this sweep reuses. **Hard dependency.**
- **ADR-006 / ADR-007** — the proven pattern applied here uniformly.
- **TECH-169 / DECISION-162 / TECH-161** — command-tier drift; same class, reconcile or coordinate.
- **TECH-186** (chokepoint audit), **TECH-187** (docs audit) — sibling workstreams; the inventory feeds 187.

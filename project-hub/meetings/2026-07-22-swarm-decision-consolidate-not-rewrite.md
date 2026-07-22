# Swarm: Decision (Retrospective) — Consolidate the Framework, Don't Rewrite

**Date:** 2026-07-22
**Mode:** decision (retrospective framing)
**Participants:** Gary Elliott, Alex (Lead), Dan (Senior Dev), Sam (Architect)

---

## Topic

Three weeks of cascading "simple" fixes ("the onion") delayed client work. Is the
framework structurally sound, or does it need a fresh version? And is `framework/docs/`
verbosity part of the problem?

## Team Discussion

**Evidence base:** Gary's 07-16 brainstorm, the Jan-2 structure retrospective, BUG-167/
170/181/184, and all 15 session logs (06-25 → 07-18, read via fan-out).

**Gary's framing** (accepted as the meeting's spine): two categories — *coupling*
(critical, decision-independent) and *streams/organization* (real, 3 live customers, but
downstream). North star: the framework serves **Gary-the-contractor first**.

**Alex** — the onion has exactly two roots: hand-synced duplication with no propagation
rule (~12 items; contract in 5 copies) and enforcement-as-prose that degrades silently
(BUG-170). They multiply, so two roots feel like ten.

**Dan** — the cure is already found *and proven in production* (BUG-170's stamp fires
downstream). A rewrite discards the single most valuable thing the three weeks bought —
discovery of the onion and its fix — which lives in *this* repo, not a blank one.

**Sam** — OQ7 is the design principle: "documents rot; chokepoints hold." But pure
patch-by-bug *is what caused the cascade* (each fix left neighbors as prose). The answer
is neither rewrite nor keep-patching: **one bounded consolidation pass** applying the
proven pattern to all duplicated artifacts at once.

**On verbosity** — `framework/docs/` is 12,109 lines/20 files; a symptom of Root 1
(CLAUDE.md was ~95% restatement), not a separate disease. Test: one home + nothing
restates it, not length.

**Gary's decisive point (mid-session)** — DRY/SoT has been a stated principle from the
start, yet duplication happened anyway. Conclusion: a principle-as-prose is just another
document that rots; only DRY-*by-mechanism* holds. The new principle must live at a
chokepoint, not as a fresh doc.

## Decisions / Conclusions

1. **Consolidate, don't rewrite** (ADR-008 / Option C).
2. **Coupling first, streams after** — streams gets its own ADR on the clean base (ADR-005).
3. **Ratify the derive-once + chokepoint pattern as an explicit principle** — enforced
   mechanically, not stated as prose.
4. **Docs audit hunts restatements, not length.**
5. **Framework serves Gary-the-contractor first** — the tiebreaker against mission drift.
6. Artifacts: **both** ADR-008 and a retrospective document.

## Open Questions

- Streams naming; common-root vs repo-root anchoring; per-stream types; `/fw-add-stream`.
- Whether `project-hub/` flattens (independent of streams).
- Study "Superpowers" and other AI-collaboration frameworks (Gary's agenda; not yet done).

## Artifacts

- [ADR-008 — Consolidate, Don't Rewrite](../research/adr/008-consolidate-not-rewrite.md)
- [The Onion Retrospective](../retrospectives/2026-07-22-the-onion-retrospective.md)

---
*AI-generated meeting record via /fw-swarm decision on 2026-07-22.*

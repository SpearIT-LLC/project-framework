# The Onion Retrospective — Coupling, Consolidation, and What the Framework Is For

**Date:** 2026-07-22
**Participants:** Gary Elliott, Claude Code (swarm: Alex/Lead, Dan/Senior Dev, Sam/Architect)
**Type:** Retrospective swarm (facilitated, evidence-based)
**Inputs:** Gary's 2026-07-16 brainstorm; the Jan-2 framework-structure retrospective; BUG-167/170/181/184; all 15 session logs 2026-06-25 → 07-18
**Companion decision:** [ADR-008 — Consolidate, Don't Rewrite](../research/adr/008-consolidate-not-rewrite.md)

---

## Why this retrospective happened

Gary's own words: *"It's an onion, and I hate onions."* Three weeks of "simple" fixes
that each exposed the next, delaying enhancements he needed for new client work. The
question on the table: is the framework structurally sound, or do we need a fresh
version?

Gary framed the issues in two categories, and insisted on the order:

1. **Coupling** — the framework's own internal dependencies and maintainability.
   *Critical, and exists regardless of anything else.*
2. **Project organization (streams)** — multi-stream/multi-SOW project structure.
   *Real (3 live customers), but downstream of coupling.*

And a north star that reframes every trade-off: **the framework was built for Gary,
a SpearIT contractor, first** — to create/develop/test/document his client work.
Solo devs and small teams are a hoped-for bonus, not the design center.

---

## What we found (from the record, not memory)

### The onion has exactly two layers

Every cascade traces to one or both roots:

1. **Hand-synced duplication, no propagation rule.** The contract in *5* copies. "Valid
   types" in *4* disagreeing lists. ~12 recent items are this one root wearing different
   masks. A quick-reference table literally carried the epitaph *"Keep this list
   updated."* It asked to be hand-synced. It was not.

2. **Enforcement as prose, not mechanism.** BUG-170: `move.sh` didn't ship, so `/fw-move`
   silently degraded to the AI winging it — *nothing signalled the safety net was gone.*
   OQ7, 07-14: *"documents rot; nothing that executes has rotted. Commands own
   chokepoints; documents do not."*

Two roots, multiplying, is why it *felt* like ten problems.

### The cascade chains (concrete)

- **Completed-field:** FEAT-165 needed `--force` → TECH-166 (readiness false-positives)
  → BUG-167 (field retired in one layer, resurrected in another) → building the backstop
  revealed the hook didn't exist (TECH-168) + plugin copies diverged (TECH-169) →
  **BUG-170** (move.sh not shipped — the big one).
- **Contract:** "be less verbose" → *"which CLAUDE.md does this go in?"* → three CLAUDE.md
  files, no propagation rule → BUG-181 → the contract is the *fifth* copy, ~4.6% unique,
  8 drift defects → **ADR-007** → exposed BUG-184 (readiness check miscalibrated).
- **Types:** BUG-170's relocation → DECISION-171 (namespace) → two concepts for one idea
  (ADR vs DECISION-*) → TECH-172/173 → a *fourth* divergent type list → **ADR-006**.

### The cure was already found — and proven

ADR-006, ADR-007, and BUG-170's fix independently landed on the same pattern:

> **Author once → derive at build → enforce at a chokepoint → verify the built artifact.**

It's not theory. BUG-170's Completed-stamp fires downstream now. The architecture isn't
wrong — the pattern is just applied in three places and prose-duplicated everywhere else.

### Why DRY was already a principle — and still failed (the decisive insight)

Gary's sharpest point: DRY-documentation / single-SoT has been a **stated** principle
since very early — *and the duplication happened anyway.* That's not a gap in the rule;
it's proof the rule-as-prose was never the lever. **A principle written in a document is
just another document, and documents rot.** DRY-by-declaration doesn't survive a busy
solo dev under client pressure; only DRY-by-*mechanism* — derive-at-build, drift-guard,
chokepoint — does. The fix for "our anti-duplication rule didn't work" is not a
better-worded rule; it's to make the single source *mechanically* the only source.
(Corollary we must not miss: don't state the new principle as a fresh standalone doc —
that repeats the error. It lives at a chokepoint / in the derived-once contract.)

### On verbosity (Gary's question)

`framework/docs/` = **12,109 lines / 20 files** (workflow-guide alone: 2,409). It's a
*symptom* of Root 1, not a separate problem — CLAUDE.md was ~95% restatement of those
guides. **Too many copies, not over-writing.** Test: *one home + nothing restates it* —
not length. Long-but-singular stays; short-but-duplicated is the poison.

---

## What went well (worth protecting)

- **Kanban + session history** — validated across projects; the session logs *are* why
  this retrospective could be evidence-based. Gary: "extremely valuable."
- **Dogfooding** — the framework surfaced its own onion. That's the system working.
- **The discovery itself** — three weeks bought a *proven* architectural pattern. Painful,
  but it's an asset, and it lives in this repo.
- **Deterministic chokepoints held.** Everything that executed survived. Only documents rot.

## What didn't

- **Bug-by-bug scoping regenerated the cascade** — each fix converted only its own
  artifact, leaving neighbors as prose for the next bug to land in.
- **Verified in source, broke in the archive** — ~6 items of the "works here, not
  downstream" class (BUG-170 the exemplar).
- **Growth outpaced fixes** — "growing new issues faster than we can solve them" (07-14);
  ~156 → ~184 items across the window; 1 → 3 client projects blocked.
- **Mission drift** — "not one of today's items is a feature a client project would use"
  (07-15). Internal framework work drifted off the "help Gary serve clients" mission.

---

## Decisions

| # | Decision | Rationale |
|---|----------|-----------|
| 1 | **Consolidate, don't rewrite** (ADR-008) | Rewrite discards the proven cure; patch-by-bug regenerates the onion. One bounded pass applies the pattern everywhere. |
| 2 | **Coupling first, streams after** | Streams on the un-consolidated base gives the onion a new axis. Streams gets its own ADR on the clean base (ADR-005 is the start). |
| 3 | **Ratify the pattern as an explicit principle** | "One authored source per concept; derive the rest; invariants live behind chokepoints; verify the built artifact." Written into the framework, not left implicit. |
| 4 | **Docs audit = hunt restatements, not length** | 12K lines is symptom, not disease. Single-home content stays regardless of length. |
| 5 | **Re-affirm: framework serves Gary-the-contractor first** | The tiebreaker for every future scope call. Guards against mission drift. |

---

## Next actions

1. **Finish BUG-181** — contract SoT + build composer (the keystone). Then TECH-182/183.
2. **Create consolidation work items** for the four remaining workstreams in ADR-008:
   duplication sweep, chokepoint audit, docs restatement audit, built-artifact verification.
3. **Write the ratified principle** into the framework's own contract (once BUG-181 gives
   it a home — don't create a new duplicate to state the anti-duplication rule).
4. **Timebox the pass** and resist re-opening ADR-006/007.
5. **Then** open a streams swarm on the consolidated base (ADR-005 → refresh).

## Open questions (carried, not resolved here)

- Streams naming (Gary dislikes "stream" — tracks/engagements/initiatives all candidates).
- Common-root vs repo-root anchoring for streams; per-stream project types.
- `/fw-add-stream` command + per-stream templates (mini-swarm to scaffold).
- Whether `project-hub/` flattens (kanban/ + history/) — *independent* of streams; decide
  separately.
- "Superpowers" and other AI-collaboration frameworks — study for outside ideas (Gary's
  agenda item; not yet done).

---
*AI-facilitated retrospective via /fw-swarm on 2026-07-22. Companion: ADR-008.*

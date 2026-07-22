# ADR-008: Consolidate, Don't Rewrite — Fix Coupling via One Derive-Once Pass

**Status:** Proposed
**Date:** 2026-07-22
**Deciders:** Gary Elliott, Claude Code
**Impact:** Major
**Supersedes:** None (reaffirms the *pattern* of ADR-006/ADR-007; reverses the framing of the Jan-2 "reorganize/rewrite" instinct)

---

## Context

Over roughly three weeks (2026-06-25 → 07-18), a run of "simple" fixes each took far
longer than expected because fixing one item exposed another — BUG-167 → BUG-170 →
BUG-181 → BUG-184, plus TECH-168/169/172/173, ADR-006, ADR-007. Gary named it "the
onion": *fixing one issue exposes another issue which exposes yet another.* The delay
began blocking three live client projects (Honda/HPC, Boston Dynamics, and others).

This ADR records the decision reached in the 2026-07-22 retrospective swarm about
**what to do with the framework as a whole** — rewrite, keep patching, or something
else — grounded in a review of the four anchor bugs and all 15 session logs across the
window.

### The onion has exactly two roots (verified from the record)

Every cascade in the window traces to one or both of:

1. **Hand-synced duplication with no propagation rule.** The AI-collaboration contract
   was found in **five** copies (BUG-181/ADR-007). "Valid work-item types" existed in
   **four** disagreeing lists across two isolated channels (ADR-006). ~12 recent items
   are instances of this single root. A duplicate with no derive rule *asks* to be
   hand-synced; it never is.

2. **Enforcement written as prose the AI "should" follow, not a mechanism that runs.**
   BUG-170 is the specimen: `move.sh` didn't ship in the archive, so `/fw-move`
   *silently degraded* to the AI interpreting intent — losing every deterministic
   guarantee, with **nothing signalling the safety net was gone.** OQ7 (07-14) states
   the principle the record kept proving: *"every artifact that rotted is a document;
   nothing that executes has rotted. Commands own chokepoints; documents do not."*

Root 1 × Root 2 multiply — duplication that also degrades silently — which is why two
roots *feel* like ten problems.

### Why the DRY principle didn't save us (the decisive insight)

DRY-documentation / single-source-of-truth has been a **stated** framework principle
since very early. The duplication happened **anyway** — five contract copies, four type
lists — *under* an explicit DRY rule. That is the whole lesson in one fact: **a principle
written in a document is just another document, and documents rot.** DRY-by-declaration
does not hold against a busy solo contractor under client pressure; only DRY-*by-mechanism*
(derive-at-build + drift-guard + chokepoint) survives contact. This is the ADR's thesis
applied to the ADR's own premise: the fix for "our anti-duplication rule didn't work" is
not a stronger-worded rule — it is to **stop relying on the rule being obeyed** and make
the single source *mechanically* the only source. (Corollary: do not write the ratified
principle below as a fresh standalone doc — that would re-commit the exact error. It must
live at a chokepoint / in the derived-once contract.)

### The cure is already proven, just not applied consistently

ADR-006, ADR-007, and the BUG-170 fix independently converged on one pattern, and it is
**validated in production**, not theoretical (BUG-170's Completed-stamp demonstrably
fires downstream now):

> **Author once → derive/compose into each channel at build → enforce with a script at
> a chokepoint → verify against the built artifact, not the source repo.**

The framework does not have a wrong architecture. It has the *right* pattern applied in
three places and prose-duplication everywhere else.

### Documentation footprint (Gary's question, measured 2026-07-22)

`framework/docs/` is **12,109 lines across 20 files**; `workflow-guide.md` alone is
2,409. The verbosity is a *symptom* of Root 1, not a separate disease:
`framework/CLAUDE.md` was ~95% restatement of those guides. Too many copies at too many
altitudes — not over-writing. The test is **"one home, nothing restates it,"** not
length: long-but-singular is fine; short-but-duplicated is the poison.

### Prior decisions in tension

- **Jan-2 retrospective, DECISION-004** ("reorganize before building") carried a
  rewrite/restructure instinct. This ADR reverses that instinct for *now*: the base is
  a working prototype that *taught* the architecture; restructuring resets the odometer.
- **Jan-2 DECISION-001** (one-framework-one-project, defer multi-project "until proven
  need"): the streams need is now **proven** (Honda multi-stream, Boston Dynamics
  multi-SOW). That reversal is real but is handled downstream of this ADR, on the
  consolidated base — see ADR-005, which already proposes the `engagement`/streams model.

## Options Considered

### Option A: Clean-slate rewrite
Start a fresh v-next repo; carry forward only the proven patterns + kanban/session-history core.
**Pros:** psychologically clean; no legacy cruft.
**Cons:** discards the single most valuable asset the three weeks bought — *discovery of the
onion and its cure*, which lives in **this** repo's artifacts, not in a blank one. High risk of
re-finding the same onion by hand. Blocks clients longer.

### Option B: Keep patching bug-by-bug
Continue fixing each duplication/drift bug as it surfaces.
**Pros:** lowest upfront cost.
**Cons:** **this is what produced the cascade.** Each fix converted only *its* artifact to the good
pattern and left neighbors as prose; the next bug lived in the next un-converted neighbor. The
onion regenerates. Growth already outpaced fixes ("growing new issues faster than we can solve
them," 07-14).

### Option C: Bounded consolidation pass (chosen)
Adopt the derive-once + chokepoint pattern as an **explicit stated principle**, then run *one
deliberate pass* that applies it across **all** remaining duplicated artifacts and prose at once —
so no un-converted neighbor is left to cascade into. Bounded, with a definition of done; not
open-ended.
**Pros:** preserves the proven pattern and the discovery; kills the cascade at its two roots;
unblocks clients on a clean base.
**Cons:** requires discipline to scope and *stop*; must resist re-opening design already settled in
ADR-006/007.

## Decision

**Chosen: Option C — Consolidate, don't rewrite.**

The last three weeks were expensive *discovery*, not failure. Discovery doesn't transfer to a blank
repo; it transfers to this one. Patch-by-bug regenerates the onion; rewrite discards the cure. The
middle path — one bounded pass applying the already-proven pattern everywhere duplication and
prose-enforcement still live — is the only option that removes the *root* rather than a symptom.

**Sequencing:** coupling first, streams after. Streams built on the un-consolidated base would give
the onion a new axis to grow along. Streams gets its own swarm/ADR on the clean base (ADR-005 is its
starting point).

### The principle this ADR ratifies (to be written into the framework)

> **One authored source per concept. Everything else is derived at build. Every invariant that
> matters lives behind a command/script chokepoint, not in a paragraph. Verify against the built
> artifact, not the source repo.**

### Discoverability: the index is a separate job from the source (Gary, 2026-07-22)

Embedding a contract at its chokepoint (e.g. in the command doc) raises a real question: *"what's
our policy for X, and how do I find it?"* The instinct to answer that with a prose guide is **exactly
the instinct that built `framework/docs/` to 12K lines** — a guide explaining policy X *restates* X,
creating a second home that drifts. The SoT and the *index over sources* are two different jobs;
conflating them is the mechanism of Root 1.

The DRY-safe answer is Gary's: **`framework.yaml` points to where X lives; it never contains X.** A
pointer that goes stale is a *visibly broken link* (script-checkable); a restatement that goes stale
is *silent rot*. The `sources:` block already exists as a topic→SoT map, and the bootstrap already
routes "where is X documented?" through it. This ADR extends it:

1. **A `sources:` entry may point at a command doc**, not only a `docs/` file — so "how moves are
   gated" resolves to `.claude/commands/fw-move.md` (where the contract lives), not a guide that
   re-explains it.
2. **Every `sources:` target is script-verified to exist** — BUG-181 found `framework.yaml:79`
   pointing at a non-existent file, so `/fw-topic-index` silently resolved to nothing. An unchecked
   index is the same onion one level up.
3. **The tour and "policy for X?" read the index, not a narrative** — AI-driven tour and
   `/fw-topic-index` resolve topic→home via `framework.yaml`; they never restate the home's content.

**This does not zero `framework/docs/`.** Topics with no chokepoint (security policy, testing
strategy) legitimately remain docs, and `sources:` points there. Workstream 4's sort becomes: each
topic → *lives at a chokepoint* (point there) / *genuine standalone doc* (keep, point there) /
*restatement of one of those* (delete). The index makes the sort possible by forcing "what is the
**one** home?" for every topic.

**Refined model:** *contract at the chokepoint; `framework.yaml` as the verified index over all
homes — docs and commands alike.*

## Consequences

**Easier:** the next "where does this go?" question has one answer; CLAUDE.md drops ~501→≤150
(ADR-007); guides shrink as they stop restating each other; a fix converts a *class* of artifacts,
not one file.

**Harder / requires discipline:** the consolidation pass must be scoped and *finished*, not allowed
to become its own onion. Design already settled (ADR-006/007) must not be re-litigated. Genuine
single-home content (security-policy, testing-strategy) is **kept** — the audit hunts restatements,
not length.

**Different:** the framework is understood, going forward, as *commands that own chokepoints + a
minimal derived-once document layer* — not a documentation set the AI is trusted to obey.

## Consolidation scope (workstreams — to become work items, not part of this ADR's gate)

1. **Finish BUG-181** — the contract SoT + build composer. The keystone; the derive-once mechanism
   everything else reuses. TECH-182/183 follow.
2. **Duplication sweep** (→ **TECH-185**) — inventory every concept expressed in >1 place (contract,
   type lists, command copies, quick-references); pick one home; derive or delete the rest. Apply the
   ADR-006/007 pattern uniformly.
3. **Chokepoint audit** (→ **TECH-186**) — every invariant currently expressed as prose-the-AI-should-follow: either
   back it with a script gate or explicitly accept it as the *one* un-mechanizable rule (the
   Implementation Rule, ADR-001/007 D7).
   - **Technique — per-feature I/O contracts** (Gary, 2026-07-22): declare each feature's
     inputs / sources-read / sinks-written / invariants, like an API signature, so a missing
     guarantee fails **loud** instead of degrading silently (the BUG-170 class). This is the
     **anti-silent-degradation** tool — *not* an anti-DRY tool (the derive-once mechanism owns
     DRY). Two guardrails, or it becomes the next onion: **(a)** the contract *points, never
     restates* — "reads rules from d1" is a reference; pasting d1's rules into the contract is a
     fifth copy in a lab coat; **(b)** declare a contract *only where a script can assert it*
     (does the declared source exist? does the feature write only its declared sink?) — an
     unverified contract is just more prose that rots. **Pilot on the `/fw-*` commands** (already
     the chokepoints; BUG-170/184 lived there), starting with `/fw-move`; generalize only if the
     ceremony pays for itself.
4. **Docs restatement audit** (→ **TECH-187**) — `framework/docs/` (12,109 lines): find restatements, not length.
   Long-but-singular stays; short-but-duplicated is cut or derived. Driven by the index sort above:
   each topic → chokepoint / standalone-doc / restatement-to-delete, with `framework.yaml:sources:`
   updated to point at the surviving one home. Includes **verifying every `sources:` target exists**
   (the BUG-181 `:79` dangling-pointer class) and allowing `sources:` to target command docs.
5. **Built-artifact verification** (→ **TECH-188**) — a standing check that core commands work in a
   *built* archive, not just the source repo (the BUG-170 class).

## Risks

- **The pass becomes the next onion.** Mitigate: each workstream is a bounded work item with a
   done-gate; timebox; resist scope creep into new design.
- **Re-opening settled design.** Mitigate: ADR-006/007 are inputs, not open questions.
- **Client pressure pulls focus to streams first.** Mitigate: streams is explicitly sequenced *after*
   and gets its own ADR; the consolidation pass is scoped to be short precisely to unblock clients.
- **Over-cutting docs.** Mitigate: the test is "one home + nothing restates it," never length.

---
*Generated by /fw-swarm decision (retrospective) on 2026-07-22.*

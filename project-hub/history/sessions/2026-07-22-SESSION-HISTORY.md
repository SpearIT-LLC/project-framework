# Session History: 2026-07-22

**Date:** 2026-07-22
**Participants:** Gary Elliott, Claude Code
**Session Focus:** "Outside Ideas" research for the retrospective — what other projects/philosophies the Framework can learn from (garys-thoughts.md:158-160)

---

## Summary

Ran a two-pass deep-research survey answering the retrospective's open "Outside Ideas" question. **Pass 1** (breadth) covered AI-agent dev toolkits and Anthropic's own guidance; **Pass 2** (depth) covered the two areas Pass 1 left thin — human PM/knowledge-management systems and plain-text/file-based tools — targeted specifically at the retrospective's two live decisions: the **"streams" modeling/naming question** and the **documentation-duplication pain**. Output is a single research file, `project-hub/research/outside-ideas-survey.md`. Note this ran alongside a separate retrospective session (the onion retrospective, ADR-008, TECH-185–188) whose work is *not* part of this history.

---

## Work Completed

### Outside-Ideas Research Survey (retrospective input)

**Created `project-hub/research/outside-ideas-survey.md`** — a two-pass, adversarially-verified survey.

**Pass 1 — breadth (AI toolkits + Anthropic):**
- 5 search angles, 26 sources, 25 claims 3-vote-verified (all survived), 8 synthesized findings.
- Headline: nearly everything the Framework already does is validated by Anthropic's own guidance — the retrospective's worry may be "right architecture, under-enforced," not "wrong architecture."
- Five convergent lessons: (1) progressive disclosure / index-plus-load-on-demand; (2) context is finite and duplication is measurable "context rot"; (3) hard guardrails need deterministic hooks, not instructions; (4) procedures belong in skills; (5) sessions start memoryless → Session History + WIP-limited Kanban are validated. Plus: separate spec (what/why) from plan (how); commands are software (fewer, workflow-complete, defensively designed).

**Pass 2 — depth (human PM systems + plain-text tools):**
- 5 angles, 23 sources, 25 claims verified, **24 survived / 1 refuted**.
- **Streams question — answered by PARA:** the real axis is **Project (has an end) vs Area (ongoing, no end)**, not the name. Engagement-stream = Project; Operations/KB-stream = Area — maps onto the Framework's existing Application-vs-Operations split. Likely explains why a single "stream" name felt wrong: it collapses two lifecycles. PARA also gives a deterministic placement algorithm (Project → Area → Resource → Archive).
- **Duplication — answered by transclusion (single-source-by-reference), with a critical AI caveat:** five tools converge on "content lives once, referenced everywhere," BUT transclusion is display-time only — raw-Markdown export leaves only the `![[...]]` pointer, not the content. So adopt the *principle* via the Framework's existing index-and-load pattern (AI follows the pointer) + **derived indexes** (compute from files, don't hand-maintain copies), NOT literal Obsidian syntax.
- Bonus: immutable-ADR + supersede discipline is a direct antidote to re-litigating settled decisions (the "onion"); Shape Up's **appetite** (fix time, vary scope) fits bounding AI sessions (its 6-week calendar does not).

---

## Decisions Made

*(No framework decisions this session — this was research input for the retrospective, which is happening in a separate session. Findings are recommendations, not adopted decisions.)*

1. **Scope of "other projects" (via clarifying question):** cover all four areas (AI toolkits, Anthropic guidance, human PM/KM, plain-text tools); start with a quick survey and dive deeper on a second pass; write output to a new research file.
2. **Ran Pass 2 rather than stopping at Pass 1:** Pass 1's coverage was lopsided (22/25 claims from Anthropic/Claude sources), leaving the human-PM and plain-text-tool angles effectively unverified — and those were exactly the angles bearing on the streams and duplication questions. Gary approved the second pass.

---

## Journey / What To Know For Next Time

- **The deep-research workflow's final synthesis step failed on Pass 2** — twice. First run returned placeholder output ("test"/"test claim"); a cache-resume re-run then crashed with a StructuredOutput retry-cap error (5 failures). The search/fetch/verify stages all succeeded (24 confirmed, 1 refuted); only the write-up stage broke.
- **Recovery:** the 24 verified claims were extracted directly from the verification journal (`.../subagents/workflows/wf_fc7924c2-773/journal.jsonl`) rather than trusting the broken top-level result. Pass 2 of the survey therefore reflects the actual 3-vote-verified research. If re-running research workflows here, be aware Python and Node are NOT usable from the Bash tool on this box (`python`→not installed; `node`→resolves to a Windows HPC tool). Use `grep`/`sed`/`awk` for JSONL recovery.
- **One refuted claim to NOT lean on:** PARA's Project/Area split is real and useful, but the *Pareto-Principle justification* for it did not survive verification (1-2).

---

## Files Created

- `project-hub/research/outside-ideas-survey.md` — two-pass outside-ideas research survey (retrospective input)
- `project-hub/history/sessions/2026-07-22-SESSION-HISTORY.md` — this file

---

## Current State

### In doing/
- (unchanged this session — verify separately; this session touched no work items)

### Research / retrospective inputs ready
- `outside-ideas-survey.md` — ready for review alongside the retrospective. Open follow-ups it raises: (a) split "streams" into Project-like vs Area-like per PARA; (b) implement single-source-by-reference via index-and-load + derived indexes, not embed syntax; (c) adopt immutable-ADR + supersede discipline.

---
---

# Session 2 (Afternoon) — The Onion Retrospective

**Session Focus:** Retrospective swarm on the framework's structural/coupling problems (garys-thoughts.md) → rewrite-vs-consolidate decision. This is the "separate retrospective session" the morning entry above flagged.

---

## Summary

Ran a `/fw-swarm` retrospective (Alex/Lead, Dan/Sr Dev, Sam/Architect) on Gary's "it's an onion" complaint — three weeks of cascading bugs delaying client work. Grounded it in evidence: read BUG-167/170/181/184 and fanned out over all 15 session logs (06-25 → 07-18). The team diagnosed the onion as **exactly two roots** and found the cure was **already proven** in ADR-006/007 + BUG-170. Decision: **consolidate, don't rewrite** (ADR-008), coupling before streams. Produced ADR-008 + a retrospective doc + meeting minutes, and drafted four consolidation work items (TECH-185–188). All committed with this history.

---

## Work Completed

### The onion retrospective — diagnosis

- **Two roots, not ten.** Every cascade traces to (1) hand-synced duplication with no propagation rule (contract in 5 copies; types in 4 lists; ~12 items) and/or (2) enforcement-as-prose that degrades *silently* (BUG-170: `move.sh` didn't ship → `/fw-move` reverted to AI-interpreted moves with no signal). They multiply, so two roots feel like ten.
- **The cure is already proven, not theoretical.** ADR-006, ADR-007, and BUG-170's fix independently converged on: *author once → derive at build → enforce at a chokepoint → verify the built artifact.* Applied in 3 places, prose-duplicated everywhere else. Rewrite would discard this discovery; patch-by-bug regenerates the onion. → one **bounded consolidation pass**.
- **Verbosity is a symptom, not a disease.** `framework/docs/` measured at **12,109 lines / 20 files**. Test is "one home + nothing restates it," never length.
- **DRY-by-declaration already failed** (Gary's decisive point): DRY was a stated principle from day one and duplication happened anyway — a principle in a doc is another doc that rots. Only DRY-*by-mechanism* holds.
- **Discoverability model** (Gary): embed contract at the chokepoint; `framework.yaml` is the *verified index* over all homes (docs AND commands) — pointers only, never content. Extends `sources:` to target command docs + script-verify every target exists (the BUG-181 `:79` dangling-pointer class).
- **Per-feature I/O contract idea** (Gary): declare each feature's inputs/sources/sinks/invariants like an API signature → folded into TECH-186 as the *anti-silent-degradation* technique (2 guardrails: point-never-restate; declare-only-what-a-script-can-assert), piloted on `/fw-move`.

---

## Decisions Made

1. **Consolidate, don't rewrite** (ADR-008, Option C) — bounded pass applies the proven pattern to ALL duplicated artifacts at once. Rationale: rewrite discards the discovery; patch-by-bug caused the cascade.
2. **Coupling first, streams after** — streams (Honda/Boston Dynamics; real, reverses Jan-2 DECISION-001) rides on the clean base; gets its own ADR (ADR-005 is the start). Streams-on-uncleaned-base = new onion axis.
3. **Ratify the derive-once + chokepoint pattern as a principle** — enforced mechanically, and (corollary) NOT written as a fresh standalone doc, which would repeat the error.
4. **Docs audit hunts restatements, not length.**
5. **Framework serves Gary-the-contractor first** — the tiebreaker against mission drift.
6. **Artifacts: both ADR + retrospective.**

*(ADR-008 is **Proposed**, not yet Accepted. Its own logic: once accepted, finish BUG-181 before TECH-185/186 can point at a real mechanism.)*

---

## Files Created

- `project-hub/research/adr/008-consolidate-not-rewrite.md` — the rewrite-vs-consolidate decision (Proposed)
- `project-hub/retrospectives/2026-07-22-the-onion-retrospective.md` — narrative retrospective
- `project-hub/meetings/2026-07-22-swarm-decision-consolidate-not-rewrite.md` — swarm meeting minutes
- `project-hub/work/backlog/TECH-185-duplication-sweep.md` — WS2 (depends on BUG-181)
- `project-hub/work/backlog/TECH-186-chokepoint-audit.md` — WS3 + `/fw-move` I/O-contract pilot (depends on BUG-181)
- `project-hub/work/backlog/TECH-187-docs-restatement-audit.md` — WS4 index-driven (depends on TECH-185)
- `project-hub/work/backlog/TECH-188-built-artifact-verification.md` — WS5 (independent)

---

## Journey / What To Know For Next Time

- **Read the record before diagnosing.** The team's whole value came from reading the 4 bugs + fanning out over 15 session logs, not theorizing. The 07-14 OQ7 note ("documents rot; chokepoints hold") and Gary's 07-15 "onion" quote were the load-bearing evidence.
- **The morning's `outside-ideas-survey.md` corroborates this decision** — PARA (Project-vs-Area) informs the streams split; transclusion/derived-indexes informs the discoverability model; immutable-ADR discipline guards against re-litigating the onion. Fold it in when streams gets its swarm.
- **`retrospectives/2026-07-16-garys-thoughts.md` is the source brainstorm** — has the streams naming candidates and the `/fw-add-stream` idea, still open.
- **Dependency spine for the pass:** BUG-181 (keystone) → TECH-185/186 → TECH-187; TECH-188 independent. Don't start 185/186 implementation until BUG-181 gives the contract a mechanical home.

---

## Current State (end of day)

### In doing/
- **BUG-181** — the ADR-007 contract-delivery anchor; steps 1–2 done, build machinery remains. The keystone for the whole consolidation pass. (Unchanged this session.)

### In backlog/ (new — consolidation pass, ADR-008)
- TECH-185, TECH-186, TECH-187, TECH-188 — drafted, not yet moved to todo/doing (Implementation Rule: planning artifacts until moved).

### Proposed, awaiting acceptance
- **ADR-008** — consolidate-not-rewrite. Accept to start the pass (BUG-181 first).

### Deferred to its own swarm
- **Streams** (multi-stream/multi-SOW) — real need, sequenced after coupling. ADR-005 + the outside-ideas survey are its inputs.

---

**Last Updated:** 2026-07-22

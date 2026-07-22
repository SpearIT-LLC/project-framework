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

**Last Updated:** 2026-07-22

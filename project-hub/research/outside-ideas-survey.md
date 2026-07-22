# Outside Ideas — What the Framework Can Learn From Other Projects (Survey)

**Date:** 2026-07-22
**Purpose:** Survey answering the retrospective's "Outside Ideas" question (garys-thoughts.md:158-160) — what concepts and design patterns could the SpearIT Framework borrow from projects like Superpowers and from Anthropic's published philosophies.
**Related:** 2026-07-16-garys-thoughts.md (retrospective input), ADR-007 (AI collaboration contract), ADR-008 (consolidate-not-rewrite)
**Method:** Deep-research harness (two passes). Pass 1 — 5 angles, 26 sources, 25 claims verified 3-vote, all survived. Pass 2 — 5 angles, 23 sources, 25 claims verified 3-vote, 24 survived / 1 refuted; recovered directly from the verification journal after the workflow's final synthesis step failed.
**Depth:** Pass 1 = breadth (AI toolkits + Anthropic). Pass 2 = depth on the two under-covered areas (human PM/KM systems + plain-text tools). Both are research inputs for the retrospective, not final decisions.

---

## Bottom Line

Nearly everything the framework already does is independently validated by Anthropic's own guidance and the leading AI-dev toolkits. The strongest signal is **progressive disclosure** — a lean always-loaded index that pulls full content only when a task triggers it. That single pattern reframes the framework's biggest pain (documentation duplication) as a *context-engineering* problem, not a discipline problem: duplication actively degrades the AI, so the fix is fewer high-signal tokens, not more docs.

The other three big lessons: **hard rules need deterministic enforcement, not instructions** (hooks/scripts, not prose); **procedures belong in skills, not the always-loaded context file**; and **sessions start memoryless**, which validates Session History and the file-based Kanban outright.

**Caveat up front:** this pass covered AI-agent toolkits and Anthropic guidance well (22 of 25 surviving claims). It did **not** independently verify the human-PM (PARA, Shape Up, GTD, ADR/RFC) or plain-text-tool (Obsidian, Dendron, Logseq, Taskwarrior, git-bug) angles — those are candidates for pass 2, not "nothing to learn."

---

## The Five Convergent Lessons

### 1. Progressive disclosure — index + load-on-demand (the dominant pattern)

Five independent primary sources converge on the same architecture: keep a lean, always-loaded index of lightweight identifiers (paths, descriptions), and load full content only when a task triggers it.

- **Agent Skills** use a three-level filesystem: metadata (~100 tokens, always loaded) → SKILL.md (loaded when triggered) → resources/scripts (loaded when accessed). Many skills install at near-zero context cost.
- **Context-engineering guidance** prescribes "just in time" retrieval — hold "lightweight identifiers (file paths, stored queries, web links)" and load dynamically, explicitly mirroring human indexing systems.
- **CLAUDE.md convention**: treat it "as an index pointing to other files," kept under ~200 lines.
- **Superpowers** stores composable skills as SKILL.md files auto-checked before each task.

**Fit to the framework:** This is a *literal* match, not an analogy. `framework.yaml`'s `sources:` block and `MEMORY.md`-as-index already instantiate it. The lesson is to lean harder into it — every always-loaded doc should be an index, and content lives one hop away.

*Sources: Agent Skills overview; Effective context engineering; Steering Claude Code (skills/hooks/rules); Superpowers; Claude Code best-practices. (5 claims, all 3-0)*

### 2. Context is finite — duplication is "context rot," not just untidiness

Anthropic defines context engineering as "curating the optimal set of tokens during inference" and calls context "a critical but finite resource." The goal is "the smallest possible set of high-signal tokens." Directly: "every redundant tool description, every piece of stale data actively degrades an agent's performance." Model recall declines as context grows — a gradient, not a cliff. At the file level: bloated CLAUDE.md files "cause Claude to ignore your actual instructions," with the pruning test — *"would removing this cause Claude to make mistakes? If not, cut it."*

**Fit to the framework:** This is technical evidence *for* the DRY / single-source-of-truth principle and *against* duplication. The framework's documentation-duplication pain isn't a failure of discipline to fix with more rules — it's a measurable performance tax. Reframe it as a context-engineering problem.

*Sources: Effective context engineering; Claude Code best-practices. (one sub-claim was 2-1 — the on-disk-to-loaded-context bridge is inference; the underlying facts are unanimous)*

### 3. Hard rules need deterministic enforcement — not instructions

Anthropic, verbatim: *"When there's something that absolutely must not happen, an instruction is the wrong tool… A real guardrail needs to be deterministic, and the enforcement methods are hooks and permissions."* And: "The model choosing to run a formatter is different from the formatter running automatically." Skills bundle executable scripts precisely so deterministic operations "run via bash without the code entering context," which is "far more reliable than having Claude generate equivalent code on the fly."

**Fit to the framework:** This is a precise answer to the deterministic-vs-AI tension. The framework's own CLAUDE.md already recognizes it ("a move gate cannot stop an AI that never calls the gate") — so the gap is *enforcement, not awareness*. "No implementation without a plan" and the move-gates cannot be prompt-enforced; the parts that must hold belong in hooks/permissions/scripts. (See open question 3 — which guardrails to migrate is its own scoping project.)

*Sources: Steering Claude Code; Building effective agents; Agent Skills overview. (4 claims, all 3-0)*

### 4. Procedures belong in skills, not the always-loaded context file

Anthropic: *"Instructions that are procedural, like deploy workflows, release checklists, or review processes, belong in a skill rather than in CLAUDE.md"* — only name/description load at session start; the full body loads on invocation (via slash command or auto-match). Side-effecting workflows use `disable-model-invocation: true` for manual-only triggering. Critically, **the description field is the trigger** — it "must say both what the Skill does and when to use it," because Claude matches the request against that text.

**Fit to the framework:** The `fw-*` commands are already surfaced as skills, so this is a direct mapping. Two concrete takeaways: (a) move procedural content *out* of CLAUDE.md into skills; (b) write command/skill **descriptions** deliberately — they are the auto-activation mechanism, not just labels.

*Sources: Steering Claude Code; Claude Code best-practices; Agent Skills overview. (3 claims, all 3-0)*

### 5. Sessions start memoryless — persistent handoff state + WIP=1 is the proven pattern

Anthropic's long-running-agents research: *"each new session begins with no memory of what came before."* The fix is persistent, human-readable handoff state — a progress log "alongside the git history," a machine-readable status file (pass/fail per feature), a startup script so an agent can "quickly understand the state of work when starting with a fresh context window." Separately, agents must work on "only one feature at a time" to avoid the over-ambition failure mode ("tendency to do too much at once — to one-shot the app").

**Fit to the framework:** Direct external validation of **Session History** and file-based state as first-class design (not incidental), and of **WIP-limited Kanban + the `doing/`-only rule**. Also relevant to the "too many dependencies" pain: Anthropic recommends the simplest solution first, adding agentic complexity "only when simpler solutions fall short."

*Sources: Effective harnesses for long-running agents; Building effective agents. (4 claims, all 3-0)*

---

## Two More Findings Worth Noting

### 6. Separate the "what/why" (spec) from the "how" (plan) — before implementing

Two independent toolkits converge here. **Spec-Kit** enforces an ordered command pipeline — constitution → specify → clarify → plan → tasks → analyze → implement — with a strict left-to-right dependency chain, explicitly separating specification ("the *what* and *why*, not the tech stack") from planning ("your tech stack and architecture choices"). **Superpowers** embeds a fixed seven-phase SDLC (brainstorm → worktrees → plans → subagent dev → TDD → review → finish), with plans broken into 2-5 minute tasks carrying exact file paths, complete code, and verification steps.

**Fit to the framework:** A richer model for "no implementation without a plan." *But* note the tension (open question 2): both toolkits enforce a **rigid** SDLC sequence, whereas the framework's Kanban is deliberately fluid. Borrow the spec/plan separation without necessarily borrowing the rigidity.

*Sources: Spec-Kit; Superpowers. (3 claims, all 3-0)*

### 7. Commands are software — fewer, workflow-complete, defensively designed

Anthropic: "Tools are a new kind of software which reflects a contract between deterministic systems and non-deterministic agents," and must be "defensively designed: clear enough that agents can't easily misuse them." Invest in the agent-computer interface "just as much" as human interfaces. Prefer "a few thoughtful tools targeting specific high-impact workflows" over thin wrappers — one `schedule_event` that finds availability *and* books, not separate list/create tools.

**Fit to the framework:** The slash commands should be few and workflow-complete — a move that *also* validates ripeness, checks dependencies, and enforces the done-gate (which `fw-move` already aspires to) — and defensively designed against AI misuse, not thin wrappers over `git mv`.

*Sources: Writing tools for agents; Building effective agents. (3 claims, all 3-0)*

---

## Open Questions for Pass 2

1. **Areas 3 & 4 are uncovered.** A dedicated second pass on human-PM systems (Shape Up's appetite/betting-table, ADR/RFC decision records the framework already partly uses, GTD contexts) and plain-text tools (Obsidian/Dendron front-matter, wikilink backlinks, Logseq block references, Taskwarrior's query model). The **"streams" concept especially resembles PARA's Projects/Areas split and multi-vault patterns** — none verified here.
2. **Rigid pipelines vs. Kanban fluidity.** Superpowers and Spec-Kit both enforce a fixed ordered SDLC. Which parts of implementation genuinely warrant a *hard gate* vs. a *soft convention* in the framework's more fluid flow?
3. **Which guardrails migrate to hooks?** The evidence says "no implementation without a plan" and move-gates can't be prompt-enforced — but converting them to deterministic hooks/permissions/scripts is its own scoped engineering project.
4. **Streams + progressive disclosure.** Does per-stream indexing (a `framework.yaml` per stream, loaded on demand) follow from finding 1 — and how does that keep the always-loaded root context under the ~200-line ceiling as stream count grows?

---

## Caveats

- **Lopsided coverage.** 22 of 25 surviving claims are Anthropic primary sources or Claude-ecosystem repos. Authoritative for an AI-native, Claude-driven framework — but Areas 3 and 4 of the brief went effectively unverified. Treat them as *uncovered*, not *empty*.
- **Inference vs. fact.** The "framework application" clauses (e.g. "validates Session History," "addresses the DRY pain") are the researcher's transferable *interpretation*, sound but labeled inference — not statements from the sources. One claim (context-rot → DRY) was the only non-unanimous vote (2-1); its facts are solid, the on-disk-duplication bridge is inference.
- **Time-sensitivity.** The skills/hooks ecosystem is fast-moving (2025-2026 sources). Specific mechanisms (SKILL.md front-matter fields, `disable-model-invocation`, `hooks/session-start`) may drift; the *principles* (progressive disclosure, determinism-vs-instruction, memoryless sessions) are stable.

---

## Primary Sources

**Anthropic / Claude ecosystem (primary):**
- Effective context engineering for AI agents — anthropic.com/engineering/effective-context-engineering-for-ai-agents
- Building effective agents — anthropic.com/research/building-effective-agents
- Writing tools for agents — anthropic.com/engineering/writing-tools-for-agents
- Effective harnesses for long-running agents — anthropic.com/engineering/effective-harnesses-for-long-running-agents
- Steering Claude Code (skills, hooks, rules, subagents) — claude.com/blog/steering-claude-code-...
- Agent Skills overview — platform.claude.com/docs/en/agents-and-tools/agent-skills/overview
- Claude Code best practices — code.claude.com/docs/en/best-practices

**AI-dev toolkits (primary):**
- Superpowers — github.com/obra/superpowers
- Spec-Kit — github.com/github/spec-kit

**Areas 3 & 4 (fetched but not fully verified this pass — see Pass 2 below):**
- Architecture Decision Records — martinfowler.com/bliki/ArchitectureDecisionRecord.html; adr.github.io
- PARA method summary — thomasjfrank.com
- Shape Up ch.9 — basecamp.com/shapeup/2.3-chapter-09
- Zettelkasten atomicity — zettelkasten.de/atomicity/guide
- git-bug — github.com/git-bug/git-bug; Obsidian MOC patterns — github.com/seqis/ObsidianMOC

---
---

# Pass 2 — Human PM Systems & Plain-Text Tools (Deep Dive)

**Scope:** The two areas Pass 1 left unverified — human PM/knowledge-management systems (PARA, Shape Up, GTD, ADR/MADR) and plain-text/file-based tools (Obsidian, Logseq, Dendron, Fossil, TrackDown, git-issues). Focused on the two things the retrospective actually needs decided: **the "streams" modeling/naming question** and **the documentation-duplication pain**.

## Bottom Line (Pass 2)

Two clean answers fell out.

1. **The "streams" question is a solved problem in PARA.** The distinction that matters is not the *name* — it's **Project (has an end) vs Area (ongoing, no end)**. A shippable customer engagement is a PARA *Project*; an ongoing responsibility like Operations/support is a PARA *Area*. This maps directly onto the framework's own Application-vs-Operations type split, and PARA's placement rule ("most relevant Project → else Area → else Resource → else Archive") is a deterministic algorithm the framework could adopt verbatim.

2. **The duplication pain has a named fix: transclusion — single-source-by-reference, not copy.** Five independent tools (Obsidian, Logseq, Roam, plus the ADR and git-tracker traditions) converge on the same principle: *the idea lives in exactly one place and is referenced everywhere else.* **Big caveat for an AI context:** transclusion is display-time only — on export to plain Markdown, the embed is NOT resolved; only the `![[...]]` instruction survives. An AI reading raw files sees the pointer, not the content, unless it follows the link. So the transferable lesson is the *principle* (reference, don't copy) implemented via the framework's existing index-and-load pattern — not literal Obsidian embed syntax.

The refuted claim: the idea that PARA's Project/Area split is justified by the Pareto Principle did **not** survive verification (1-2). The split is real and useful; that particular *rationale* for it is not well-supported. Don't lean on it.

---

## Area 3 — Human PM & Knowledge-Management Systems

### PARA — resolves the "streams" question (Project vs Area is the real axis)

- **The load-bearing distinction is end-state, not label.** A Project is "a series of tasks linked to a goal, with a deadline" — it completes ("when the presentation is delivered, the project is over"). An Area is "a sphere of activity with a standard to be maintained over time" — it never finishes ("health is never done"). The plain test: *"if you can imagine shipping it or closing the ticket, it is a project. If it is just part of what your role means, it is an area."*
- **This maps onto the framework's own types.** PARA-for-engineers explicitly files active feature/CI-CD work under Projects and ongoing cloud platforms under Areas — mirroring the framework's **Application (has an end) vs Operations (ongoing) split**. So a "stream" isn't one thing: an engagement-stream is Project-like; an operations/KB-stream is Area-like. That's likely *why* the single "stream" name felt off in the retrospective — it's collapsing two different lifecycles into one word.
- **PARA organizes by *actionability*, not by topic** — the inversion of conventional folder-by-subject filing. Review cadence follows actionability too (Projects reviewed often, Areas less, Resources on demand). Directly relevant to how a KB/Docs repo type (Resource-like, passive) differs from active work folders.
- **Deterministic placement algorithm** (adoptable as a mechanical rule): *most relevant Project → else Area → else Resource → else Archive.* This is exactly the kind of deterministic decision procedure Pass 1 said should be mechanized rather than left to instruction.
- **PARA names the duplication problem outright:** "a file cannot reside within two places at once," and copying to resolve overlap "causes duplicates and version-control problems" — the framework's exact DRY pain, acknowledged as inherent to category-based filing.
- **PARA + Zettelkasten are complementary, not rival:** durable concept notes live in a separate reference layer that active-work notes *link to* — keeping reusable knowledge out of active contexts. A reference-not-copy pattern.
- **PARA is app-agnostic and works in plain Markdown + Git** (no Obsidian required) — validating the framework's file-based/git-native substrate as a legitimate PARA implementation.
- **⚠ Refuted:** the Pareto-Principle justification for the Project/Area split (1-2). The distinction stands on its own; skip that rationale.

### Shape Up — "appetite" and the circuit breaker (fixed time, variable scope)

- **Appetite replaces the estimate and reverses causality:** *"Estimates start with a design and end with a number. Appetites start with a number and end with a design."* You set the time budget *first*, then shape scope to fit. Two fixed sizes: Small Batch (1-2 weeks) and Big Batch (~6 weeks).
- **The circuit breaker enforces it:** "if they don't finish, by default the project doesn't get an extension" — forcing scope trade-offs instead of deadline slippage. The same feature is deliberately built at different depths depending on budget (modeled DB columns vs. a flat textarea).
- **"No backlog" philosophy:** rather than grooming an ever-growing queue, surface "just a few good options" at each betting table to preserve optionality. This is a genuine *tension* with the framework's `backlog/` folder — worth a deliberate decision, not accidental drift.
- **Transfer for an AI framework:** appetite is a natural fit for scoping AI work sessions ("shape this to a two-session budget"), and the circuit breaker is a deterministic stop-condition. *Caveat:* Shape Up's fixed 6-week cycles + cool-downs are a human-team cadence that doesn't map cleanly onto AI-driven continuous flow — borrow appetite/variable-scope, not the calendar.

### GTD — reference-by-attribute, and the reconciliation ritual

- **Projects and next-actions are kept as *separate* lists, linked by reference** — via software association or "a keyword in the project name and the next actions" — *not* by duplicating action content into the project. A reference-not-copy pattern (relevant to whether checklists should live inside work-item files or be linked).
- **Full project detail is "project support," kept separately from the action list** — maps to the framework's project-file (support) vs checklist-item (next action) distinction.
- **The catch:** reference-based links require a **periodic reconciliation ritual** (the Weekly Review) to stay consistent — GTD does *not* rely on continuous automatic linkage. Lesson for the framework: if you go reference-not-copy, you need a deterministic "re-sync/verify links" step (a command or hook), because references silently rot otherwise.

### ADR / MADR — the mature practice the framework is likely missing

The framework already uses ADRs. What the mature practice adds:

- **Accepted ADRs are immutable.** A changed decision is not edited — you write a *new* ADR that supersedes the old one and flips the old one's status to "Superseded by ADR-NNNN." *"The truth of the architecture is the full chain of ADRs, not the latest one."* This is the mechanism that fights re-litigating settled decisions — directly on-point for the framework's "cascading onion" and its "don't re-open decisions" goal.
- **Four-state lifecycle:** Proposed → Accepted → Deprecated → Superseded. **Numbers assigned monotonically, never reused.**
- **Store ADRs in the same repo as the code** (the framework already does this) — and the diagnostic for silent failure is sharp: *if `grep -r 'adr/' src/` returns zero, nobody is referencing them and the practice is failing.* Worth adopting as an actual check.
- **MADR ships in two tiers** — "MADR light" (3-5 essential elements) and a full template — a progressive-disclosure pattern for decision records (start minimal, expand only when warranted). The full template has a fixed section order (Context → Drivers → Considered Options → Decision Outcome → Consequences).
- **MADR's decision-makers/consulted/informed split (from RACI)** is called out as "the single most useful addition over Nygard for teams larger than five" — probably overkill for a solo-contractor + AI context; note but don't adopt reflexively.

---

## Area 4 — Plain-Text / File-Based Tools

### Transclusion — the convergent answer to the duplication pain (with an AI caveat)

**The convergence is the signal:** Obsidian, Logseq, and Roam all independently implement the same idea, and the ADR/git-tracker traditions echo it — *content lives once, is referenced everywhere.*

- **Obsidian:** `![[note]]` / `![[note#heading]]` embeds transclude by reference — "editing the source updates every place it appears."
- **Logseq:** distinguishes a **block reference** (read-only "window" to one block) from a **block embed** (editable "portal" that renders the block *and its whole subtree*, editable in place, propagating back to source). Explicitly patterned on Roam — hence the convergence.
- **Transclusion decouples content from hierarchy:** "focus on the ideas themselves, worry about the hierarchies later." The idea exists once; *where* it appears is decided separately. This is conceptually identical to Pass 1's progressive-disclosure/index pattern.
- **⚠ The AI-context caveat (verified, important):** transclusion is **display-time only**. On export to plain Markdown/PDF/DOCX, embeds are **not resolved** — "only the markdown syntax appears," "the Markdown instruction, not the desired result." An AI (or any tool) reading the *raw* files sees `![[...]]`, not the content, unless it deliberately follows the link. **So the framework should adopt the *principle* (single-source-by-reference) using its existing index-and-load mechanism — where the AI is instructed to follow the pointer — not literal Obsidian embed syntax, which would leave the AI reading dead pointers.**

### Front-matter as a queryable schema (Obsidian / Dataview)

- **YAML front-matter = a database schema.** Dataview models "every note as a row, every property as a column," with type inference (text/number/date/list/link). A consistent front-matter convention makes work-items queryable *without a separate database* — relevant to `fw-status`, `fw-wip`, roadmap rollups.
- **Indexes/MOCs can be *generated from a query*, not hand-maintained:** "a hand-written 'Active Projects' note is out of date the next time you finish a project; a Dataview query never is." This is single-source-of-truth *by derivation* — the strongest available answer to index-rot and one form of the duplication pain. (The framework's deterministic commands can play the Dataview role: compute the index from the files rather than maintaining a copy.)
- **Concrete pitfalls (verified):** query quality is bounded by metadata quality; **missing vs empty fields behave differently** (empty fields can pass filters unexpectedly); freeform/inconsistent keys are "impossible to query reliably." → argues for a **small, enforced, template-seeded front-matter schema** ("five well-maintained fields beat twenty inconsistently-filled ones"), created from a template at note-creation time.

### Hierarchical naming vs. folder nesting (Dendron)

- **Dendron encodes hierarchy in dotted filenames** (`proj.area.topic`) instead of folder nesting — structure expressed by *name*, avoiding deep directory trees. A concrete alternative worth weighing for the streams layout (e.g. `stream.acme.research.*`) against folder-per-stream.
- **Schemas enforce structure + auto-deploy templates per hierarchy level** — the capability plain Obsidian lacks (there it's a manual naming convention the tool doesn't validate). Refactor-hierarchy uses regex capture groups for safe bulk-rename, with an overwrite guard. *Caveat:* the one Dendron page fetched did **not** confirm that refactors auto-update backlinks — link-integrity-on-rename is unverified, flag before relying on it.

### Git-native issue trackers — modeling state in files (append-only)

Strong convergence here, and it's the closest analogue to what the framework already is:

- **Fossil derives current ticket state by replaying an append-only log** of immutable change artifacts (same ticket ID, timestamp order) — *state is computed from an event log, not stored as a mutable record.* This is the cleanest model for non-destructive work-item history and sidesteps merge conflicts (append-only artifacts merge automatically; "tickets do not branch").
- **git-issues** stores issues as **YAML-front-matter Markdown in `.issues/`**, version-controlled with code, zero infrastructure — and notably **auto-generates a `.agent.md` context file for Claude Code**, with an agent-oriented command sequence (`issues next → claim → done`) *distinct from the human workflow*. This is a live example of exactly the framework's ambition — an AI-first, file-based tracker — worth studying directly.
- **TrackDown** keeps all issues in a **single Markdown file**, status inline in the heading (`## ID Title (status)`), and **auto-derives a roadmap rollup** from the issues (index-by-derivation again). Local file is authoritative; sync to GitHub/GitLab is optional and one-directional.
- **Convergent transferable principles:** (1) issues-as-files travel with git branches — `git bisect` shows issue state at any commit; (2) local file is the source of truth, external trackers are optional mirrors; (3) append-only/derived state beats in-place mutation for history and merges.

---

## What Pass 2 Changes for the Retrospective

- **Streams:** don't pick a single name — split the concept. Engagement-streams are **Projects** (have an end); operations/KB-streams are **Areas** (ongoing). Consider PARA's Project/Area/Resource/Archive as the actual vocabulary, and its placement algorithm as a deterministic rule.
- **Duplication:** the fix is **single-source-by-reference**, but implemented via the framework's index-and-load pattern (Pass 1), *not* literal transclusion syntax — because embeds don't resolve for a tool reading raw files. Prefer **derived indexes** (compute from files) over hand-maintained copies. If you adopt reference-links, add a deterministic **re-sync/verify** step (the GTD Weekly-Review lesson).
- **Decisions:** adopt the **immutable-ADR + supersede** discipline fully — it's the direct antidote to re-litigating settled decisions and the "onion." Consider a `grep`-based check that ADRs are actually referenced.
- **Scoping:** Shape Up's **appetite** (fix time, vary scope) + **circuit breaker** transfer well to bounding AI work sessions; its 6-week calendar cadence does not.

---

## Pass 2 Caveats

- **Source quality is more mixed than Pass 1.** Primary sources: Basecamp (Shape Up), Fossil, TrackDown, git-issues, Logseq issue #43, GTD official, Dendron wiki. The rest are blogs/forums (PARA summaries, Dataview/front-matter guides, MADR primers) — good for mechanics, weaker as authority. Treat the *mechanics* as reliable and the *interpretations* as inference.
- **One refuted claim** (PARA↔Pareto rationale, 1-2) — excluded above.
- **Two unverified specifics flagged inline:** Dendron backlink-integrity-on-refactor, and Obsidian's export-transclusion limitation (confirmed *as a limitation*, but the surrounding tooling moves fast — 2020-2026 sources).
- **Recovered from journal.** The workflow's final synthesis step failed twice (placeholder output, then a StructuredOutput retry-cap error). The 24 verified claims above were extracted directly from the verification journal (`wf_fc7924c2-773/journal.jsonl`), so this section reflects the actual 3-vote-verified research, not a re-synthesis. The framework-application interpretations (mapping claims to streams/duplication) are mine, labeled as such.

---

## Pass 2 Sources

**Primary:**
- Shape Up (appetite, betting, circuit breaker) — basecamp.com/shapeup/1.2-chapter-03; basecamp.com/shapeup/2.2-chapter-08
- Fossil bug theory (append-only ticket state) — fossil-scm.org/home/doc/tip/www/bugtheory.wiki
- TrackDown (single-file Markdown issues) — codeberg.org/backendzeit/trackdown
- git-issues (YAML-front-matter issues + `.agent.md`) — news.ycombinator.com/item?id=47973644
- Logseq transclusion (issue #43) — github.com/logseq/logseq/issues/43
- GTD linking next-actions & projects — gettingthingsdone.com/2020/06/the-gtd-approach-to-linking-next-actions-and-projects
- Dendron refactor hierarchy — wiki.dendron.so

**Blog / forum (mechanics reliable, authority weaker):**
- PARA — thomasjfrank.com; glukhov.org/.../para-method-for-engineers; dasroot.net (PARA for technical knowledge); taskade.com; get-alfred.ai; medium.com/practice-in-public (the refuted-claim source)
- MADR primers — ozimmer.ch/.../MADRTemplatePrimer; hidekazu-konishi.com
- Obsidian/Dataview/front-matter — obsibrain.com (Dataview guide); danholloran.me (properties/front-matter); forum.obsidian.md (transclusion-on-export #3193; Dendron-schemas #58496)
- Logseq block refs vs embeds — discuss.logseq.com/t/.../8459

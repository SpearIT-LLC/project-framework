# SpearIT Framework — Deliverable Roadmap

**Created:** 2026-09-02
**Basis:** all open cards grouped by deliverable, ranked by what gets the ADR-009 build
from **0.4.6 → 1.0**.
**Updated 2026-09-02:** D8 executed (26 cards archived, TASK-218); D1b added for the
board conventions that survived that review (TASK-219).
**Updated 2026-09-07:** reconciled against actual board state — the 09-02 snapshot had
gone stale (TASK-213 shipped 09-03; D1b Group 1 promoted to `todo/` the same day).
Progress checkboxes added. FEAT-221/222 slotted in.
**Updated 2026-09-09:** checkbox legend corrected — `[!]` was replaced by `[h]` on
2026-09-08 (it means *important* in every Obsidian theme collection, not blocked).
BUG-215 rescoped and now in `doing/`.
> **Superseded in shape by FEAT-198 (2026-09-09).** This file is an *authored
> spine-level master roadmap*, which FEAT-198 says the new model should not have. Its
> **ordering and phase rationale are the judgment worth keeping**; its per-card columns
> (folder, priority, one-line summary) are duplicated from the cards and are the half
> that rots — hand-reconciled twice in three days, each time because the copy went stale,
> never because the ordering was wrong.
>
> **Do not reconcile it a third time.** The reconciliation note at the foot of this file
> set that threshold and it has been reached. Read it for the ranking; go to the card for
> anything else.

**Companion to:** [`ROADMAP.md`](ROADMAP.md) — theme-based, predates ADR-009 (last
updated 2026-02-17). **Stale; do not plan from it.** This one is deliverable-based and
current.

**Board state (verified 2026-09-09):** 72 backlog · 15 todo · 1 doing · 8 done · 1 blocked.

> **Progress marks** follow TECH-177's Obsidian convention: `[ ]` pending · `[/]`
> in progress · `[x]` done · `[-]` cancelled/N-A · `[?]` needs information ·
> `[h]` something prevents completion. A deliverable is `[/]` when any of its cards has
> shipped.
>
> **`[h]`, not `[!]`** (settled 2026-09-08). `[!]` means *important* in all four Obsidian
> theme collections and imports into Tasks as an ordinary TODO; `[h]` is free in all four
> and is the symbol the Tasks docs use for `ON_HOLD`. Evidence in TECH-177. **These marks are hand-kept** — the board folder is the source of
> truth, this file is a view of it (ADR-008: derived, not authored). Re-verify against
> `project-hub/work/` before trusting a mark; TECH-177 itself would let a script check
> them once the states are implemented in the gate.

> **Grouping rule.** A *deliverable* is one thing a user gets — a capability they can
> name. Cards of every type (FEAT/BUG/TECH/TASK/SPIKE/DECISION) that serve the same
> user-visible capability sit together, regardless of which folder they are in.

---

## The Frame

Two frameworks exist in this repo:

| | old | new |
|---|---|---|
| **Lives in** | `framework/`, `templates/`, `plugins/`, `tools/` | `workspaces/framework/` |
| **Version** | v5.6.0 (2026-08-24) | 0.4.6 |
| **Status** | **maintenance-only** — confirmed by TECH-172's 2026-08-24 re-scope note: *"the old framework is maintenance-only (v5.6.0); its doc, template, and plugin straggler edits below are dead work."* | the live build (ADR-009, Accepted 2026-08-18) |
| **Model** | archive ships the structure; 3 hand-synced tiers (framework + 2 plugin editions) | the framework **is** the plugin; commands build the structure (ADR-009 D3) |

Everything below is ranked against one goal: **graduate `workspaces/framework/` to a
1.0 that replaces the old framework on live client work.**

---

## Ranked Deliverables

### D1 — The Spine: Board, Operations, and kb at Root  `[/]`
**Rank 1 · 5 cards · 1 done, 1 in `doing/`, 3 in `todo/`**

The repo-root structure the whole model rests on. Everything else assumes these paths
are settled, so churn here is the most expensive churn available — it is first for that
reason alone, not because it is the largest.

| ✓ | Card | Folder | Pri | What |
|---|---|---|---|---|
| `[x]` | TASK-213 | **done** | Med | Operations moved out of `workspaces/` to root, as a peer queue beside the board — *shipped 2026-09-03* |
| `[/]` | **BUG-215** | **doing** | Med | **In progress.** Rescoped 2026-09-08 from "batch moves dropped" to **parity across both namespaces** — batch was the symptom, the engine guessing its namespace was the cause. Batch half and namespace half both shipped and tested; two criteria open (kanban command → crossover work; built-plugin verification → needs a publish step) |
| `[ ]` | TECH-177 | todo | **Med** | Obsidian checkbox states `[ ] [x] [/] [-]` + gate awareness in `fw-move.sh`. **Re-scoped 2026-09-07:** `[?]`/`[h]` promoted from deferred — they mark *where* a card is blocked, which no folder can. Symbol settled 2026-09-08 (`[h]`, not `[!]`). **Now blocks D3b** |
| `[ ]` | TASK-214 | todo | Med | `Workspace:` field on ops records — restores the scoping the root move removes |
| `[ ]` | TASK-216 | todo | Med | `kb/` moves to root; framework gains a multi-source list (local + N external corpora) |

**Why first:** TASK-216 relocates a top-level tree; every command, script, and doc that
names a path is downstream. BUG-215 is a live regression on the single most-used command.

**BUG-215 is in `doing/`** (started 2026-09-07, both halves implemented 2026-09-08). What
remains on it is a UAT pass against the built plugin — the source-tree tests pass, but
"verified against the built plugin" is a separate claim and needs a publish step.

**TECH-177 no longer rides along.** It was scoped as a cheap companion (same `fw-move.sh`
gate functions), but it grew: it now owns sub-task-level blocking for the whole framework
(`[?]`/`[h]`, their gate behaviour, and the `Depends On:` macro/micro split). It is the
natural next card once BUG-215 closes, and it **blocks D3b**.

---

### D1b — Board Conventions for the New Build  `[ ]`
**Rank 2 · 18 conventions + TASK-219 · owned by TASK-219**

Sixteen board conventions that exist as analysis on old cards and as **nothing** in the
ADR-009 build. Ranked here — immediately behind the spine — because it **blocks FEAT-175**
and pairs with the D5 board crossover.

| ✓ | Card | Folder | Pri | What |
|---|---|---|---|---|
| `[ ]` | TASK-219 | todo | **High** | Owns the set: decide each convention, give it a mechanism, close the source card |
| `[ ]` | FEAT-021, TECH-082, TECH-041, TECH-027, TECH-033 | **todo** | — | **Group 1 — the blocker.** Numbering, parent/child, supporting files, cross-references, status-vs-folder. Interlock; settle as a set before any work-item template is authored. *Promoted to `todo/` 2026-09-03* |
| `[ ]` | TECH-044, TECH-077, TECH-078, FEAT-030 | backlog | — | Board lifecycle: creation policy, never-delete, release archival, a hold state |
| `[ ]` | **`accept/` · `cancelled/` · `blocked/` metadata** | *(in TASK-219 Group 2a)* | — | **Added 2026-09-07/08.** `accept/` = finished but not yet accepted; `cancelled/` = a lifecycle status, not a storage location; `blocked/` metadata widened for internally-blocked cards. **Largely settled 2026-09-08** by the authored repo-structure diagram — `accept/` and `cancelled/` are first-class there. Still open: where the 27 `deprecated/` cards live (no `archive/` under `kanban/`), FEAT-030's hold state (absent from the diagram), `templates/` (the diagram marks it *"alt idea"*). **Blocks FEAT-221** |
| `[ ]` | TECH-070, TECH-070.1, TECH-071, TECH-049 | backlog | — | Process: issue response, session handoff, human-AI concurrent work. **TECH-049 also owns locking/session identity** — FEAT-221 degrades safely without it but does not solve it |
| `[ ]` | TECH-073, FEAT-149 | backlog | — | Templates the new build lacks: external reference, meeting record |
| `[ ]` | DECISION-171 | backlog | — | The `fw-` namespace rule the new build already follows but never wrote down |

**Why rank 2:** the new build ships **no work-item template of any kind**
(`templates/records/` holds only `contact.md`, `ops-record.md`, `ts-case.md`). FEAT-175's
create gate must resolve a template per type, so the templates are its prerequisite — and
the templates encode these conventions. Author them first and they encode guesses.

**The sharpest single finding:** `fw-move.sh:6` already treats **"child items"** as
grouping that moves with its parent — a concept nothing in the repo defines. The engine is
ahead of the conventions.

**Known conflict inside Group 1 (flagged 2026-09-03):** FEAT-021 and TECH-082 propose
**competing mechanisms for the same concept** — dotted sub-ids (`FEAT-021.1`) vs. a
`Parent:` field on independently numbered items. The board uses both styles today.
Resolve this first; the other four hang off it.

**Not a docs task.** Each convention needs a *mechanism* — a template field, a script
check, a hook — or an explicit statement that it cannot be mechanized. A convention in
prose only is ADR-008 Root 2, the failure this framework exists to avoid.

---

### D2 — Knowledgebase That Stays Trustworthy  `[ ]`
**Rank 2 · 3 cards**

The kb is the asset with the longest half-life and the one Gary named as most at risk:
*"The long term viability of the kb is the biggest challenge in my opinion. […] Without
some means to flag potentially out of date info makes the kb unreliable."* (2026-09-01)

| Card | Folder | Pri | What |
|---|---|---|---|
| TASK-217 | todo | **High** | Staleness/provenance metadata — make the provenance rule a mechanism, not prose |
| FEAT-209 | todo | **High** | Sub-topic depth: `<domain>/<subtopic>/` with provenance folders at the leaf (decided: option (b), UAT-23) |
| TASK-216 | todo | Med | *(shared with D1 — the multi-source half belongs here)* |

**Why second:** an unreliable kb is worse than no kb, and every day of accumulated
content raises the cost of retrofitting provenance. TASK-217 is the ADR-008
*prose→mechanism* pattern applied to the kb.

---

### D3 — Command UX Good Enough to Hand Over  `[ ]`
**Rank 3 · 4 cards**

Everything in D3 works today; none of it *feels* finished. This is the gap between
"the script runs" and "a person who is not Gary can use it."

| ✓ | Card | Folder | Pri | What |
|---|---|---|---|---|
| `[ ]` | FEAT-210 | todo | **High** | New-build command UX pass — all UAT 2026-08-26..29 findings, grouped by command |
| `[ ]` | **FEAT-222** | backlog | Med | **New 2026-09-07.** Session history in the new build — it ships no such command, and **four** authored formats disagree. Adopt the plugin edition's separate-template-file mechanism; supersedes TECH-072, replaces the never-finished CHORE-146 sync |
| `[ ]` | FEAT-211 | backlog | Med | Contact grammar rework: title vs function, `;` delimiter, batch assign |
| `[ ]` | FEAT-191 | backlog | Med | Guided purpose intake for `/fw-new-workspace` — 3–4 questions, not one vague one |

**Why third:** this is the 1.0 quality bar. FEAT-210 is explicitly the collected UAT
findings and says *"split out any item that grows past a session's work"* — expect it
to spawn cards.

---

### D3b — Unattended Batch Implementation  `[ ]`
**Rank 3 · 4 cards · new 2026-09-07 · blocked by D1b**

`/fw-implement-todo` — implement every card in `todo/` in one unattended run: one batch
review, then serial card-by-card implementation, landing each in `accept/`. Drafted from
Gary's Lucid page *fw-implement-todo*
(`project-hub/poc/fw-implement-todo/`; published link in
[`../docs/diagram-index.md`](../docs/diagram-index.md)).

| ✓ | Card | Folder | Pri | What |
|---|---|---|---|---|
| `[ ]` | FEAT-221 | backlog | Med | Parent — holds the ADR-001 conflict analysis, circuit-breaker, WIP/serial reasoning, batch membership, concurrency limits |
| `[ ]` | FEAT-221.3 | backlog | Med | **First.** ADR-001 amendment: the checkpoint becomes per-batch, not per-card. Must land before the command ships |
| `[ ]` | FEAT-221.1 | backlog | Med | Acceptance-criteria gate fires on either exit from `doing/`, not on `accept → done` |
| `[ ]` | FEAT-221.2 | backlog | Med | The command itself |

**Why rank 3, not higher:** it is **blocked by D1b** (`accept/` is a board lifecycle
state TASK-219 owns) and by **TECH-177** (the `[?]`/`[h]` markers its circuit-breaker
writes). Batch moves are no longer a blocker — BUG-215 restored them 2026-09-07.

**Why it matters beyond itself:** this is the first card group that genuinely tests
parent/child grouping (D1b Group 1's unresolved FEAT-021 vs TECH-082 conflict) on real
work. Note the ordering trap recorded on the parent: **FEAT-221.2 cannot implement
itself**, so the honest dogfood is the *next* feature group, not this one.

---

### D4 — Reporting, Roadmaps, and History Per Workspace  `[ ]`
**Rank 4 · 4 cards**

ADR-009 makes the repo the *customer*, hosting many workspaces. The reporting layer has
not caught up: one board, one history, one roadmap — none of them sliceable.

| Card | Folder | Pri | What |
|---|---|---|---|
| FEAT-163 | todo | Med | Workspace-aware reporting and history (rewritten 2026-08-18 for ADR-009) |
| FEAT-196 | backlog | Med | Workspace progress reporting — exec summary + detail from one data set |
| FEAT-198 | backlog | Med | Per-workspace roadmaps — `/fw-roadmap` for repo-is-the-customer |
| feature-015 | backlog | Low | Executive summary reporting (A4 stakeholder output) — folds into FEAT-196 |

**Why fourth:** this is what a contractor shows a client. It needs D1's `Workspace:`
field settled first (TASK-214), which is why it sits behind the spine.

---

### D5 — Troubleshooting, Proven on Real Work  `[ ]`
**Rank 5 · 3 cards**

`fw-troubleshoot` shipped (FEAT-202) and is the only skill in the new build. It was
built against fixtures.

| Card | Folder | Pri | What |
|---|---|---|---|
| TASK-205 | backlog | **High** | Dogfood on three real cases, then retro — *"the first three real incidents will rewrite it more than any amount of design"* |
| FEAT-203 | backlog | Med | Domain playbooks — "first five minutes" cookbook entries read at rung 6 |
| FEAT-204 | backlog | Med | Diagnostic collector scripts — pre-scrubbed evidence bundles as products |

**Why fifth:** TASK-205 is High and cheap, but it is **demand-driven** — it fires when
Honda/Toyota/SpearIT-internal sends the next real problem, not on a date. Treat it as
standing readiness that jumps the queue when a case arrives. FEAT-203/204 should wait
for its retro; building playbooks before the retro risks building the wrong shape.

---

### D6 — Time: Deadlines, Reminders, Calendar  `[ ]`
**Rank 6 · 2 cards**

| Card | Folder | Pri | What |
|---|---|---|---|
| FEAT-199 | backlog | Med | Deadline awareness — surface dated obligations before they are late |
| FEAT-200 | backlog | Med | Schedule reminders + calendar view, layered above FEAT-199 |

**Why sixth:** genuinely new capability, coherent as a pair, but nothing else depends on
it and the framework is usable without it. FEAT-199 first — FEAT-200 explicitly layers
on it. Post-1.0 candidate.

---

### D7 — The ADR-008 Guards (carried forward, needs rewriting)  `[ ]`
**Rank 7 · 4 cards · ⚠️ written against old paths**

These are the two root causes from ADR-008 — hand-synced duplication, and enforcement
written as prose. **The principles are permanent and already binding** (they are the
Single-Source Rule in the root `CLAUDE.md` and in `workspaces/framework/CLAUDE.md`).
The *cards* audit the old tree.

| Card | Folder | Pri | Fate |
|---|---|---|---|
| TECH-189 | backlog | **High** | **Re-earner.** The failing drift gate. The new build's whole design assumes it. Rewrite against `workspaces/framework/`. |
| TECH-186 | backlog | **High** | **Re-earner.** Chokepoint audit — every invariant behind a script. The new build has 7 scripts and 2 hooks to audit. |
| TECH-188 | backlog | **High** | **Partial re-earner.** "Test the built artifact" survives; but the new build publishes by junction, not archive, so the mechanism differs. |
| TECH-185 | backlog | **High** | **Mostly deprecated.** The duplication sweep inventoried the old 3-tier tree. The new build has one copy by construction — that *was* the fix. Keep only if a fresh sweep of `workspaces/framework/` is wanted. |

**Recommendation:** rewrite TECH-189 and TECH-186 as new cards scoped to the new build;
close TECH-185 as superseded-by-construction; re-scope TECH-188 to the junction publish
path. Do this *before* 1.0 — these are the guards that stop the onion regrowing.

---

### D8 — Deprecated: Old Framework Docs, Setup, and Distribution  `[x]`
**Rank 8 · 26 cards · archived 2026-09-02 · no work planned**

**Archived by TASK-218**, which holds the full disposition table, the reason codes, and
the reversal procedure. Read that card before pulling anything back;
`project-hub/work/archive/deprecated/README.md` is the short version.

Every archived card names a **specific dead file** as its deliverable —
`framework/docs/collaboration/workflow-guide.md`, `framework/INDEX.md`,
`framework/CLAUDE.md`, `Setup-Framework.ps1`, or a doc describing only the old
distribution. The file is the deliverable and it is not coming back.

**What is NOT archived.** This roadmap's first draft proposed bulk-moving ~75 cards.
Reading them in full cut that to 26 across four passes, and the ~49 that stayed are the
more important half:

| Held | Why | Where |
|---|---|---|
| Commands, plugins, scripts | The migration is mid-flight — the new build ships **5** commands against the old set's **11**. These cards are the requirements input for the ten not yet ported. | C4 in TASK-218 |
| Hooks | Actively in use (`hooks/hooks.json`, `tools/pre-commit`) and the mechanism half of the Single-Source Rule. | C5 |
| Board conventions | Parent/child items, numbering, cross-references, never-delete, release archival — the new build has defined **none** of these, and `templates/records/` has no work-item template at all. | C6 |
| Kanban gate design | The new engine says *"No kanban gates apply"* — these are the D5 crossover's design input. | C1 |
| Product ideas | Sprints, velocity, team IDs — unbuilt in **both** frameworks. | C2 |

**The lesson worth keeping:** the summary-level heuristic (type + title + the paths a
card names) systematically over-archived. A card titled *"Document X policy"* pointing at
`framework/docs/` looks dead, but the *policy* is the deliverable and the file is
incidental. Three whole classes failed that heuristic identically.

---

### D9 — Blocked, External  `[-]`
**Rank — · 1 card · not schedulable**

| Card | Folder | What |
|---|---|---|
| BUG-144 | blocked | Anthropic plugin command namespace collision — [issue #26906](https://github.com/anthropics/claude-code/issues/26906). Platform fix required. Monitor only. |

Note: this one is *not* deprecated by ADR-009 — the new framework ships as a plugin, so
the collision risk applies to it too.

---

## Sequence

```
NOW      BUG-215 in doing/ ── parity across both namespaces; UAT remains
              │
NEXT     TECH-177 ── the [ ] [/] [x] [-] [?] [h] gate behaviour this file's
              │       own marks depend on; blocks D3b
              ▼
NOW      D1 spine ──► D1b conventions ──► D2 kb trust ──► D3 command UX ──► 1.0
          [/]            │  [ ]              [ ]             [ ]
              │          │
              │          ├──► unblocks FEAT-175 (board create gate)
              │          └──► unblocks D3b (accept/ state)  ← new 2026-09-07
              └──► D4 reporting (needs TASK-214)

WITH D5   D1b + FEAT-175 pair with the ADR-009 D5 board crossover
CROSSOVER (C1 gate-design cards land here too: TECH-166/168/055/114/177)

BEFORE   D7 guards — rewrite TECH-189 + TECH-186 against the new build
1.0
LATER    D6 time/calendar · D5 troubleshooting (dev-stage, not demand-driven)
DONE     D8 — 26 cards archived 2026-09-02 (TASK-218)
         TASK-213 — operations at root, shipped 2026-09-03 (D1)
```

**The one-line answer:** finish the spine (D1), define the conventions the board runs on
(D1b), make the kb trustworthy (D2), polish the commands (D3) — that is 1.0. Rebuild the
two ADR-008 guards (D7) before you call it 1.0, or the onion grows back.

**BUG-215 is in `doing/`**, both halves shipped; a built-plugin UAT pass is what closes
it. **TECH-177 is next** — it is no longer a ride-along, and D3b waits on it.

> **WIP warning:** `todo/` holds **15** against a `.limit` of **10**. It was already over
> before D1b Group 1 was promoted. Nothing new should be promoted to `todo/` until it
> drains — an over-limit queue is the condition the limit exists to surface.


---

## Resolved Questions (2026-09-02)

1. **D8 destination — `project-hub/work/archive/deprecated/`.** Location is the
   status, so the cards move rather than gaining a `Deprecated:` field.
   **ID safety verified against both engines:**
   - Old (live for this board) — `Get-NextWorkItemId` in
     `framework/tools/FrameworkWorkflow.psm1:276` scans `work`, `releases`, `poc`,
     `history/spikes` with `-Recurse`, matching any `[A-Za-z]+-NNN` basename
     generically. `work/archive/deprecated/` is under `work/`, so it is counted.
     `work/archive/` already holds 8 cards today — the pattern is in use and working.
   - New — `workspaces/framework/scripts/fw-next-id.sh:33` scans the namespace root
     recursively. Its own header states the rule: *"status is only the first path
     segment under the root; deeper folders … are grouping, never status, and still
     count."* `archive/deprecated/` reads as status `archive`, grouping `deprecated`.

   **Constraint:** deprecated must live **under `work/`**. A sibling root such as
   `project-hub/deprecated/` would be invisible to the old scanner and would risk
   ID reissue.

2. **Card-by-card review before archiving — required, not optional.** D8 is a
   *proposed* bucket. Before any card moves, read it for content that outlived the
   old framework; anything that survives is re-written as a fresh card against
   `workspaces/framework/` **first**, and only then is the original archived. The
   three pre-flagged re-earners (FEAT-180, FEAT-115, FEAT-157) are candidates, not
   the finished list. The same rule governs D7's TECH-189/186/188/185.

3. **D5 trigger — no live case.** Troubleshooting is development-stage; TASK-205
   does not jump the queue. D5 stays at rank 5.

---

## Reconciliation Note (2026-09-07)

The 2026-09-02 snapshot had drifted from the board in five days. What was wrong:

- **TASK-213 listed in `todo/`** — shipped 2026-09-03, in `done/`.
- **D1b Group 1 listed in `backlog/`** — all five promoted to `todo/` 2026-09-03.
- **`done/` (8 cards) invisible here** — the file tracked open work only, so shipped work
  left no trace and D1 looked untouched.

**This is the ADR-008 pattern again:** a hand-kept view of a source of truth
(`project-hub/work/`) drifts silently, and nothing fails when it does. The checkbox marks
added today make drift *visible* but do not prevent it — they are still hand-kept. A real
fix generates this file's status column from the folders. **Carded?** No — worth a card
if this reconciliation is needed a third time.

---

## Reconciliation Note (2026-09-09) — the threshold was reached

Reconciled a **second** time: the checkbox legend still described the pre-`[h]` marker
set, BUG-215 had moved to `doing/` and been rescoped, TECH-177 had stopped being a
ride-along, and the counts had shifted (todo 16→15, doing 0→1).

**What drifted, both times, was only the derived half** — folder, priority, mark, counts.
The *ordering* has never been wrong. That is the split now recorded in **FEAT-198**: a
roadmap holds judgment (order, phase rationale, done-conditions) and card ids; it holds no
card detail.

**And the completion question is answered.** Gary asked whether the pattern of never
finishing a roadmap top-to-bottom is indiscipline or unacknowledged mid-flight change.
Verified: this file carries **no success criteria for any deliverable**, so divergence was
never *observable*. The framework already ships the fix — `/fw-roadmap`'s planning periods
carry goals and success criteria — and this file does not use it. Two roadmap models
exist; the ad-hoc one is the one we kept maintaining.

**Status: superseded in shape by FEAT-198.** No third reconciliation.

---

**Last Updated:** 2026-09-09

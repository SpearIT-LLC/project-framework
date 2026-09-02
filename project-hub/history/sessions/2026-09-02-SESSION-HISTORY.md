# Session History: 2026-09-02

**Date:** 2026-09-02
**Participants:** Gary Elliott, Claude Code
**Session Focus:** Build a deliverable-based roadmap from all open cards — group by user-visible capability, rank toward the ADR-009 build's 1.0, and separate the old framework's dead work from what still earns its place

---

## Summary

No implementation this session. All 108 open cards (96 `backlog/`, 11 `todo/`, 1
`blocked/`) were read and regrouped from *type* into *deliverable* — one thing a user
gets — then ranked against a single goal: graduating `workspaces/framework/` from 0.4.6
to a 1.0 that replaces the old framework. Nine deliverables came out of it, of which
D8 is ~75 cards of old-framework work with nothing planned. The deprecation call was
verified against TECH-172's re-scope note and ADR-009 rather than assumed. The session
closed by verifying, in both ID engines, that archiving those cards cannot cause an ID
collision.

---

## Work Completed

### ROADMAP-DELIVERABLES.md — new deliverable-based roadmap

- Read every open card's header (id, type, priority, workspace, theme, summary) across
  `backlog/`, `todo/`, and `blocked/`.
- Grouped into **nine deliverables** and ranked D1–D9. Mixed-type grouping throughout —
  each deliverable holds whatever FEAT/BUG/TECH/TASK/SPIKE/DECISION cards serve the same
  user-visible capability, regardless of folder.
- Written to `project-hub/planning/ROADMAP-DELIVERABLES.md` as a **companion** to the
  existing `ROADMAP.md`, not a replacement — see Decisions #2.

**The ranking, and the reasoning for each position:**

| | Deliverable | Cards | Why there |
|---|---|---|---|
| D1 | The Spine: board, operations, kb at root | 5 (all `todo/`) | Relocates two top-level trees; every path-bearing command/script/doc is downstream. Most expensive churn to defer. |
| D2 | Knowledgebase that stays trustworthy | 3 | Retrofit cost rises with every day of accumulated content. Both cards High. |
| D3 | Command UX good enough to hand over | 3 | The 1.0 quality bar — the gap between "the script runs" and "someone who is not Gary can use it." |
| D4 | Reporting/roadmaps/history per workspace | 4 | What a contractor shows a client, but gated on D1's `Workspace:` field (TASK-214). |
| D5 | Troubleshooting proven on real work | 3 | TASK-205 is High but demand-driven. See Decisions #4. |
| D6 | Time: deadlines, reminders, calendar | 2 | Coherent pair, nothing depends on it. Post-1.0. |
| D7 | The ADR-008 guards | 4 | ⚠️ Principles bind; cards audit the old tree. Rewrite before 1.0. |
| D8 | Deprecated: old framework/templates/plugins/tools | ~75 | No work planned. See Decisions #1. |
| D9 | Blocked, external | 1 | BUG-144, Anthropic platform fix. Not schedulable. |

---

## Decisions Made

### 1. The old framework is deprecated — confirmed from sources, not assumed

Gary's instruction allowed for uncertainty ("confirm it's really deprecated, ask if
unsure"). Two independent sources settle it, so no ask was needed:

- **TECH-172's re-scope note (2026-08-24), verbatim:** *"the old framework is
  maintenance-only (v5.6.0); its doc, template, and plugin straggler edits below are
  dead work."*
- **ADR-009 (Accepted 2026-08-18)** makes the framework *be* the plugin, with commands
  building the structure — the old archive-ships-the-structure model is superseded by
  design, not by neglect.

Version state corroborates: `framework/PROJECT-STATUS.md` reads v5.6.0 (2026-08-24) and
has not moved; `workspaces/framework/.claude-plugin/plugin.json` reads 0.4.6 and is
where all recent work lands.

**A distinction that emerged while sorting D8** — and that is worth keeping, because it
changes how the cards should be closed rather than merely *that* they close. Some D8
cards are not stale so much as **dissolved by construction**: DECISION-162 (command-tier
sync), TECH-169 (reconcile `/fw-move` copies), FEAT-179 (plugin create-gate parity),
TECH-160 (align plugin build model), SPIKE-178 (can a plugin invoke its own script).
Every one exists *only* because three tiers were hand-synced. ADR-009's one-copy model
is the fix those cards were asking for. They should close as **superseded-by-design**,
which is a different closure note than "old framework, not doing it."

### 2. Companion roadmap, not a rewrite

`project-hub/planning/ROADMAP.md` is theme-based (Project Guidance / Developer Guidance
/ Workflow / …), last updated 2026-02-17 — seven months stale and pre-ADR-009. It was
left untouched and the new file written beside it.

**Rationale:** the existing roadmap's *themes* are still a defensible taxonomy of what
the project is; what it lacks is any awareness of the workspace model or the two-framework
split. Overwriting it would have destroyed a still-valid axis to deliver a different one.
Two files, two axes, both readable. Revisit if maintaining both proves to be a cost —
this is a judgment that can be reversed cheaply, unlike the deletion.

### 3. D8 destination is `project-hub/work/archive/deprecated/` — ID safety verified in both engines

Gary: *"The location is the status, so I favor archive/deprecated/. Will the next-id
script find those cards?"* Asked because a missed card would let an ID be reissued.

**Verified by reading both implementations, not by inference:**

- **Old engine (live for this board)** — `Get-NextWorkItemId` in
  `framework/tools/FrameworkWorkflow.psm1:276-281` scans `work`, `releases`, `poc`,
  `history/spikes` with `-Recurse`, matching any `[A-Za-z]+-NNN` basename generically
  (ADR-006's disk-discovery model: "recognized" = "present on disk", no authored list).
  `work/archive/deprecated/` sits under `work/`, so it is counted.
- **New engine** — `workspaces/framework/scripts/fw-next-id.sh:33-35` does a recursive
  `find` over the namespace root. Its own header comment already states the governing
  rule: *"status is only the first path segment under the root; deeper folders (year
  buckets, release buckets, bundles) are grouping, never status, and still count."*
  `archive/deprecated/` therefore parses as status `archive`, grouping `deprecated` —
  exactly Gary's "location is the status" model, one level deeper.
- **Precedent:** `work/archive/` already holds 8 cards (TECH-135, DECISION-029,
  CHORE-131/132, DOCS-133 and its supporting files). The pattern is in use and working.

**Constraint recorded in the roadmap:** deprecated must live **under `work/`**. A
sibling root such as `project-hub/deprecated/` would fall outside the old scanner's four
scan folders, be invisible to it, and reopen exactly the ID-reissue risk the question was
about. The recursion under `work/` is what makes this safe — there is no archive-specific
special case in either engine.

### 4. D5 does not jump the queue — no live troubleshooting case

The roadmap draft had TASK-205 as "standing readiness that jumps the queue when a real
case arrives," on the reasoning that three real incidents would reshape `fw-troubleshoot`
more than any design work. Gary: *"No, this is all in development stage."* D5 stays at
rank 5; the queue-jump language is removed from the resolved-questions section.

### 5. Card-by-card review is a precondition for archiving, not a courtesy

Gary: *"I'm leaning towards keeping but we should carefully review before implementation
to be sure all the old stuff is out of the card."*

Recorded as a hard rule: D8 is a **proposed** bucket. No card moves until it has been read
for content that outlived the old framework; anything that survives is rewritten as a
fresh card against `workspaces/framework/` **first**, and only then is the original
archived. Three pre-flagged re-earn candidates — **FEAT-180** (documentation as a
done-gate rule, cheap for the new build to adopt), **FEAT-115** (`/fw-tour`), **FEAT-157**
(provenance stamp, useful at graduation) — are candidates, not a finished list.

The same rule was extended to **D7**, which has the identical shape: TECH-185/186/188/189
carry principles that bind the new build (the Single-Source Rule is live in both
`CLAUDE.md` files) inside cards that audit the old tree. Per-card fate recorded in the
roadmap: TECH-189 and TECH-186 are full re-earners, TECH-188 partial (the new build
publishes by junction, not archive, so the mechanism differs), TECH-185 mostly
superseded-by-construction.

---

## Files Created

- `project-hub/planning/ROADMAP-DELIVERABLES.md` — deliverable-based roadmap; 9 ranked
  deliverables over all 108 open cards, with a Resolved Questions section carrying the
  ID-safety verification and the review-before-archive rule.
- `project-hub/history/sessions/2026-09-02-SESSION-HISTORY.md` — this file.

## Files Modified

- *(none — no framework source was touched this session)*

## Files Moved

- *(none — the D8 bulk move is proposed, not executed)*

---

## Current State

### In doing/
- *(empty)*

### In todo/
- BUG-181, BUG-215, FEAT-163, FEAT-175, FEAT-209, FEAT-210, TASK-213, TASK-214,
  TASK-216, TASK-217, TECH-177

### In blocked/
- BUG-144 (Anthropic issue #26906 — platform fix required)

### Open threads for next session

- **Nothing implemented.** The roadmap is a planning artifact; no card changed state and
  no work item moved folder.
- **D1 is the recommended start**, and yesterday's history already constrains how:
  TASK-213 and TASK-216 *should land as one migration* — both change root layout and
  break the same relative paths. That note predates this roadmap and still stands.
- **Unresolved from 2026-09-01, still unresolved:** does the root move land before or
  after the D5 board crossover? The roadmap does not settle this; it is the first
  question D1 has to answer.
- **The D8 bulk move is not scheduled.** It needs the per-card review from Decisions #5
  before any `git mv` runs. Worth doing as a deliberate pass, not folded into other work.
- **BUG-181 sits in `todo/` but is classed D8** (deprecated) — the starter `CLAUDE.md`
  it fixes belongs to the old framework, and the new build authors its own. It should
  either be re-earned against `workspaces/framework/` or archived; leaving a High-priority
  card in `todo/` that the roadmap treats as dead work is the kind of quiet contradiction
  that misleads a future session.
- **FEAT-175 likewise sits in `todo/`** and is the old framework's `/fw-new` create gate.
  The new build has create gates already (`fw-new-workspace.sh`, `fw-new-ops-record.sh`,
  `fw-new-contact.sh`). Same disposition question as BUG-181.

---

**Last Updated:** 2026-09-02

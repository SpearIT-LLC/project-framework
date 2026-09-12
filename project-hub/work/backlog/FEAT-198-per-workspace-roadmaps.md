# Feature: Per-Workspace Roadmaps — `/fw-roadmap` for the Repo-Is-the-Customer Model

**ID:** FEAT-198
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-08-20
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

`/fw-roadmap` was conceived under the repo-is-the-project model: one repo, one
`ROADMAP.md`. ADR-009 makes the repo the *customer* — many workspaces (products,
projects, operations) with independent strategic direction. One spine-level roadmap no
longer fits: a customer repo may legitimately carry several roadmaps (one per product,
one per live project) — or none.

Surfaced 2026-08-20 during TASK-197 refinement (Gary), while resolving why the
`project` scaffold carries no `plan/` folder.

## Direction (proposed, confirm at design)

- **The roadmap is workspace-owned.** A roadmap describes one bounded body of work, so
  it lives in the workspace it describes (e.g. `workspaces/<name>/ROADMAP.md`), not at
  the spine. The close-test supports this: a project's roadmap freezes when the project
  closes; a product's roadmap lives as long as the product. A spine roadmap would
  accrete dead sections.
- **Type fit:** product and project workspaces may have roadmaps; operations and
  knowledgebase do not (they are ongoing areas, not directed efforts).
- **This does not split the board or the timeline.** Work items stay on the one kanban
  board (`Workspace:` field, FEAT-163); history stays at the spine (ADR-009 D2).
  Roadmaps are forward-looking strategy documents owned by the thing they describe —
  different rule from history's one-timeline-at-the-spine.
- **The engagement-level view is derived, never authored.** "Where is everything for
  this customer headed" is a report assembled across workspace roadmaps + the board
  (FEAT-196's layered-report shape), not a hand-kept master roadmap (ADR-008).
- `/fw-roadmap` gains a workspace argument (or infers from context) and writes into
  the target workspace.

## The Shape a Roadmap Should Have (added 2026-09-09)

Gary, 2026-09-09: *"the roadmap feels too heavy and the details should always be part of
the individual card. For me, I think the roadmap should be just a list of existing or
planned cards with a planned order. Add a little explanation of each phase with a reason.
That's all we need really."*

**Card ids + order + a short reason per phase. Nothing else.**

The rule that follows: a roadmap holds **judgment** (ordering, phase rationale, what
"done" means for a phase) and **references** (card ids). It holds **no card detail** —
folder, priority, status, summary all live on the card and are derived at read time or
not shown. Only the derived half ever drifts, because it is a copy.

### Why the current spine roadmap is the counter-example

`project-hub/planning/ROADMAP-DELIVERABLES.md` is ~380 lines and is exactly the
authored spine-level master roadmap this card says should not exist. It duplicates
folder, priority and one-line summary for ~60 cards. It has been hand-reconciled against
the board **twice in three days** (2026-09-07 and 2026-09-09), each time because the
duplicated columns went stale — never because the *ordering* was wrong. That is the
evidence for the split above: the judgment held, the copy rotted.

### The completion problem — and why the framework already solves it

Gary, 2026-09-09: *"I'm not sure we've ever fully implemented a complete roadmap from top
to bottom. We always seem to get halfway through and then diverge or forget about the
roadmap. I'm not sure if that's a lack of discipline or the real roadmap changed midflight
without formally acknowledging it."*

**Verified 2026-09-09: the second, and the current file made it undetectable.**
`ROADMAP-DELIVERABLES.md` carries no success criteria for any deliverable, so "halfway
through and diverged" cannot be observed — there is no condition that was met or missed.

**The framework already ships the missing piece and this file does not use it.**
`/fw-roadmap` produces **Themes** (stable categories — what the project *is*) and
**Planning Periods** (temporal, each with a goal, its themes, and **success criteria**).
Work items carry `Theme:` and `Planning Period:` fields to link back. A planning period
with success criteria *is* a phase with a done-condition.

So there are two roadmap models in this repo: the shipped themes/periods one, and the
ad-hoc deliverable-ranked file we have actually been maintaining. **Use the shipped one.**

### Divergence must be cheap to record

If changing the plan is expensive, it happens informally and the roadmap silently stops
being true — which is the failure Gary described. A course change should be a **one-line
appended note** (what changed, why, date), never a rewrite. Two recent examples that the
current file could not absorb: FEAT-221/222 were filed mid-session from a diagram and a
slash command, and BUG-215 turned out to be a namespace problem rather than a batch
problem. None of that was indiscipline; the roadmap had nowhere to put it.

### What this means for `ROADMAP-DELIVERABLES.md`

It is **superseded by this card**, not maintained. Its *ordering and phase rationale* are
the judgment worth carrying forward into the new shape; its per-card columns are not.
Do not reconcile it a third time — the reconciliation note in the file itself set that
threshold, and it has now been reached.

---

## The Two Layers, in Each Workspace's Vocabulary (2026-09-11)

**One command, one shape, three vocabularies — supplied by the workspace's own declaration
(TECH-232), never by a separate command per type.**

| | temporal layer | capability layer |
|---|---|---|
| **product** | planning period | **feature** |
| **project** | phase | **deliverable** |
| **knowledgebase** | — | **domain** |

**Why not `/fw-product-roadmap` and `/fw-project-roadmap`:** the shapes overlap almost entirely
— ordering, references, temporal markers with success criteria. Two implementations of that is
the sync problem ADR-008 exists to prevent, there are four workspace types (so it would be four
commands), and the framework's established pattern is one command per *capability*, parameterized
— `fw-new-workspace` already takes the type as an argument.

### The capability layer is now an authored file, not a declared list

**`Theme:` is replaced by `Serves:` (FEAT-231), on usage evidence.** A theme was a *label* in a
list that nothing validated — FEAT-095 chose "loose coupling, no referential integrity"
deliberately. Result, measured 2026-09-11: 13 distinct theme values against 5 declared in
`ROADMAP.md`, the third most-used theme absent from the roadmap entirely, a declared theme with
zero cards, and one value with a planning period smuggled inside it.

**So the roadmap stops declaring categories and starts referencing files.** Features,
deliverables and domains are authored documents with definition, MVP and testable success
criteria; the roadmap points at them. That is this card's own rule applied one layer up —
*a roadmap holds judgment and references, never content authored elsewhere.*

**The cost, accepted:** a theme was cheap (a line in a list); a feature file is not. Expect
fewer, larger categories. That is the correct pressure — cheap is what produced 13 values.

### Worked example: the Honda HPC 2016→2019 upgrade

Read 2026-09-11 (`HPC/HPCJobQueuePrototype/customers/honda/hpc-2019-upgrade/plan/`), because
it is a **real project plan, on its fourth version** — and Gary reached for `/fw-swarm` rather
than `/fw-roadmap` for it, which is itself evidence the roadmap command did not fit.

Three things it establishes:

1. **Projects have a temporal layer and call it phases.** Phase 0 Discovery → 1 New Head Node →
   2 Gold Image + QA → 3 Migration → 4 Decommission. Sequential, each gating the next — planning
   periods with a different word. **This corrects an earlier proposal** that projects need
   *deliverables and milestones* as two axes; they need one temporal axis, same as products.
2. **Deliverables are phase outputs**, not a separately declared list — "a new head node", "a
   validated gold image", "a decommissioned 2016 cluster".
3. **The plan is versioned by supersession, not edited.** v3 exists because v1/v2 described a
   cross-version DB schema upgrade Microsoft does not support; the reason sits at the top with a
   link to DECISION-093. **Project plans get invalidated by discovery**, so supersession is the
   normal case, not an exception — the same append-don't-rewrite discipline session history uses.

### Scope boundary — WBS and schedule are in, critical-path machinery is not

Gary, 2026-09-11: *"The framework doesn't need to handle large projects but it should do the
basics well."*

**Corrected the same day.** An earlier version of this section cut WBS and schedule entirely, on
the argument that a WBS duplicates the board — cards already decompose work, carry `Depends On:`
and parent/child structure. **That argument is wrong for the case that matters:**

> Gary: *"in the HPC scenario, there are people outside of SpearIT involved with the project.
> That particular one is feeding the 'public' tasks into Jira while keeping our stuff private in
> that repo."*

**The board and the WBS have different audiences, so they are not duplicate content.** The board
is SpearIT's private decomposition; the WBS is the shared one external parties work from — and
in the Honda case it feeds Jira. The HPC project **has** both a WBS and a schedule, and Gary
calls them part of the basics.

**Still out of scope:** critical-path calculation, resource levelling, automatic date arithmetic
across a dependency network. That is PM tooling and a different product. Knowing *what is due and
what is blocked* is the framework's version, and lives in FEAT-199/FEAT-200.

**Not solved here.** How a WBS relates to the board, and how public work is exported to an
external tracker while private work stays in the repo, is **project-workspace scope** — deferred
deliberately on 2026-09-11 so the current focus (kanban) is not derailed. What this card records
is that the cut was wrong and why.

---

## Open Questions (resolve before → doing)

- [ ] Is the roadmap file scaffolded (empty/template in the product/project overlays)
      or created on first `/fw-roadmap` run? (Lean: created on demand — a scaffolded
      empty roadmap is noise for workspaces that never need one.)
- [x] ~~Does the existing repo-level `/fw-roadmap` flow (themes, planning periods) carry over
      per-workspace unchanged?~~ **Answered 2026-09-11 — see "The two layers, in each
      workspace's vocabulary" below. Neither: both layers carry over, both get the
      workspace's own word, and the theme layer is replaced by an authored file rather than
      a declared list.**
- [ ] **Where does the framework's own roadmap live** once the spine master is retired?
      `workspaces/framework/` is a workspace, so its roadmap belongs there — but the
      board it plans is at the spine until the ADR-009 D5 crossover. (Lean: it lives in
      `workspaces/framework/` and references spine card ids; the ids are stable across
      the crossover.)
- [ ] Old-framework `/fw-roadmap` and `docs/project/ROADMAP.md`: untouched until
      graduation (ADR-009 D5), or does this land only in the new build? (Lean: new
      build only, like FEAT-163.)

## Acceptance Criteria

- [ ] A product or project workspace can hold its own roadmap, created/updated via
      `/fw-roadmap <workspace>`
- [ ] No spine-level authored master roadmap exists in the new model; any cross-
      workspace view is generated (FEAT-196 territory)
- [ ] Roadmap location/ownership documented in exactly one home
- [ ] **A roadmap contains card ids, ordering, and phase rationale — no per-card detail**
      (no folder, priority, status or summary duplicated from the card)
- [ ] **Every phase has a done-condition** — planning-period success criteria, so
      divergence is observable rather than inferred
- [ ] **Recording a course change is a one-line append**, not a rewrite
- [ ] The themes/planning-periods model `/fw-roadmap` already produces is used, not
      re-invented — **with the capability layer replaced by authored files** (features /
      deliverables / domains) rather than a declared list of labels
- [ ] `/fw-roadmap` asks in the workspace's own vocabulary, read from its declaration
      (TECH-232): *features* in a product, *deliverables* in a project, *domains* in a kb —
      one command, not one per type
- [ ] A project roadmap's temporal layer is **phases**; a product's is **planning periods**.
      Both carry success criteria
- [ ] A superseded plan is replaced by a new version that states what changed and why, with
      the prior versions kept — never edited in place
- [ ] **No critical-path calculation, resource levelling, or date arithmetic across a
      dependency network** — that is PM tooling. WBS and schedule themselves are in scope for a
      project workspace but are **not designed by this card**; "what is due / what is blocked"
      belongs to FEAT-199/200
- [ ] `ROADMAP-DELIVERABLES.md`'s ordering and phase rationale are carried into the new
      shape and the file itself is retired
- [ ] Verified against the built plugin, not the source tree

## Related

- **ADR-009** — repo-is-the-customer; one board, one timeline at the spine.
- **TASK-197** — workspace type taxonomy; the refinement that surfaced this.
- **FEAT-163** — board/history slicing by workspace (the tactical layer; this item is
  the strategic layer).
- **TECH-232** — the workspace declaration this card reads for its vocabulary. **Blocks the
  vocabulary half of this card.**
- **FEAT-231** — `Serves:` on every card, replacing `Theme:`. The card-side half of the same
  change: this card stops the roadmap *declaring* categories, that one makes the card
  *reference* an authored file.
- **FEAT-199 / FEAT-200** — deadlines and calendar. Where "what is due, what is blocked" lives,
  now that WBS and scheduling are explicitly out of scope here.
- **`/fw-swarm`** — what Gary actually used to plan the Honda HPC upgrade. Worth asking during
  implementation *why* it fit where `/fw-roadmap` did not; the answer is likely that a swarm
  produces a plan for one problem while a roadmap sequences many, and a project may want both.
- **FEAT-196** — layered progress reporting; the derived engagement-level view.
- **FEAT-164** — `/fw-new-workspace` scaffolds; touchpoint if the roadmap is scaffolded.
- **FEAT-093** — planning-period archival; the other half of the periods model (what
  happens to a period when it closes).
- **`project-hub/planning/ROADMAP-DELIVERABLES.md`** — the spine master this card
  retires. Read it for the ordering judgment, not the card columns.
- **`.claude/commands/fw-roadmap.md`** — the shipped themes/planning-periods flow.

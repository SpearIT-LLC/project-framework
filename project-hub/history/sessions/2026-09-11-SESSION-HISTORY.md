# Session History: 2026-09-11

**Date:** 2026-09-11
**Participants:** Gary Elliott, Claude Code
**Session Focus:** BUG-215 UAT fixtures; roadmap re-framing around features; the feature-file model

---

## Summary

Started on BUG-215's outstanding built-plugin verification, which surfaced the real blocker:
no mock data to test against. Built and proved a UAT fixture seeder, and added the four
missing batch-move cases to the runbook. Along the way the conversation opened a much larger
thread — why the roadmap keeps failing to finish — and landed on a **feature-definition
layer** between roadmap and cards, with a drafted template.

---

## Work Completed

### BUG-215: New Move Engine Drops Batch Moves

- Established what verification exists: 25 defined cases (T1–T12 source-tree, N1–N13
  namespace half), all passing. Outstanding: built-plugin verification, plus the deferred
  kanban command (owned by the ADR-009 D5 crossover, not this card).
- Wrote `workspaces/framework/tests/seed-uat-fixtures.sh` — mock operations records in the
  reserved **900 block** so fixtures and live records coexist.
- Verified the seeder end-to-end against a throwaway repo, then ran the four BUG-215
  behaviours through the real engine: batch move with bundle (3 moved), `--resolution`
  refusal on a list, partial failure (901/999/903 → 2 moved 1 failed), and the substring
  trap (`901` moved INC-901 and left INC-9010 alone). All passed.
- Added **UAT-33..36** to `UAT-COMMANDS.md` as a new section **D2**, written against the
  900-block fixture ids.

**Still open on BUG-215:** the plugin must be installed to the cache
(`/plugin install spearit-framework-dev@dev-marketplace --scope local` + restart) before
UAT-33..36 prove anything — the dev-marketplace entries are symlinks to the source tree, so
testing "against the marketplace" is testing the same files.

---

## Decisions Made

### 1. Seeder is authored once and points at the target repo

**Decision:** `seed-uat-fixtures.sh` lives in `workspaces/framework/tests/` and takes
`--root <repo>`; it is **never** copied into framework-uat.

**Rationale:** a copy goes stale the moment `fw-move.sh` changes — which is precisely the
class of bug BUG-215 *is*. ADR-008, one authored source. Mirrors `fw-move.sh --root`.

### 2. Kanban fixtures are refused, with an explanation

**Decision:** the seeder recognizes `kanban` and dies with a pointer to the crossover.

**Rationale:** `fw-move.sh:81` refuses the namespace *before* parsing any id, because
`kanban_TRANSITIONS=""` marks "declared but not wired." Seeded kanban cards would produce
byte-identical output to seeding nothing. Kanban fixtures become writable when the crossover
ports its gates — and their requirements come *from* those gates, so designing them now is
guesswork. **Operations-first is forced, not a preference.**

### 3. The roadmap's unit is wrong — features, not cards

**The diagnosis (Gary):** `ROADMAP-DELIVERABLES.md` opens with *"all open cards grouped by
deliverable"* — a bottom-up frame. Deliverables were discovered by sorting cards that
happened to exist, so **anything without a card was structurally invisible**.

**The proof:** the ADR-009 D5 kanban crossover is referenced from four places in that file
and owned by none. There is no roadmap deliverable that builds the new `kanban/`.

**The deeper cause, already recorded at line 411 of that file:** *"this file carries no
success criteria for any deliverable, so divergence was never observable."* A deliverable
with no definition of done cannot be finished, only abandoned. Missing deliverables and
missing done-conditions are the same root cause.

**Naming collision worth remembering:** "D5" means two different things — ADR-009 decision
D5 (the board crossover) and roadmap deliverable D5 (troubleshooting). BUG-215 means the
former.

### 4. Feature ordering

**Decision:** kanban → operations → kb → workspaces (projects/products) → other
(reporting, swarm, history, roadmaps).

**Rationale (Gary):** *"kanban is the core of the whole framework."* Drive each feature to a
defined MVP before moving on, instead of jumping around.

**Correction recorded:** Claude claimed kanban was "the largest undefined pile." Gary
corrected: kanban is *exactly* `project-hub/work/` plus a few states — the most known and
developed part of the framework; the change is name and location. What is undefined is the
**convention inventory** (D1b), which is old-card analysis, not unbuilt capability. Claude
had mistaken a docs backlog for missing function.

**Claim worth testing later (Gary):** *"operations is really just a variation of the
kanban."* The move engine already agrees — one engine, two policy-table rows differing only
in folders/transitions/terminal states. If that generalizes to templates, create gates, ids
and reporting, **operations largely falls out of kanban as a second table row**, collapsing
a lot of D-list work.

### 5. A feature-definition layer exists between roadmap and cards

**Decision:** three layers, each answering one question, no overlap.

| Layer | Question | Changes |
|---|---|---|
| Product definition (1 file) | What is this, who for, what is 1.0? | Rarely |
| Feature definition (1 per capability) | What is it, what is MVP, how do we know it works, what is out? | On scope decisions |
| Cards | What is the next executable chunk? | Constantly |

The roadmap is **not** a fourth layer — it is a *view*: ordering plus state, derived. That
is FEAT-198's split. Explicitly **not** making this a `/fw-roadmap` refinement yet: roadmap
answers "in what order," feature answers "what and how good." Merging them produced the file
that needed hand-reconciling twice.

**Skipped deliberately:** epics, themes, initiatives, phase documents — scaffolding for
teams that cannot hold the product in their head.

### 6. Membership is derived; the feature file holds no card list

**Decision:** cards carry a `Feature:` field. The feature file **never** lists its cards.

**Rationale:** Claude first drafted a "Cards: ids only" section, then Gary caught it —
*"that's a lot of churn for something that could be generated by a deterministic script."*
Correct, and it contradicted Claude's own stated reason for cutting card detail. Hand-keeping
membership means every card creation and move touches two files, and the unenforced one rots.
One direction of reference: **cards → feature**.

**Consequence:** `Workspace:` and `Feature:` are both card-side fields. A feature belongs to
a workspace; the feature file names its workspace.

### 7. Every card names a feature — coverage, not correspondence

**Gary's framing, which replaced Claude's strawman:** ten FEAT cards can refine one
high-level feature, and a BUG can fix it. A feature file is **not** one-per-FEAT-card.

**The invariant:** every card belongs to exactly one feature. The question at creation is not
"does this FEAT have a doc" but *"which feature does this card serve — and if none, is that a
missing feature or a card that shouldn't exist?"* The second outcome is the valuable one:
a card fitting no feature is usually scope creep, caught cheaply at creation.

**Mechanism (not yet built):** `/fw-new` validates `Feature:` against the set of feature
files; unknown → refuse and offer to create the feature file. Same shape as the close gate's
resolution prompt. ADR-008 standard: a mechanism, not a rule to remember.

### 8. Acceptance criteria and sub-tasks are conflated today

**Finding (Gary):** *"The `[ ]` boxes are sub-tasks but I agree each card should have a
testable condition."* Today the done-gate counts unchecked boxes under
`## Acceptance Criteria`, so sub-tasks and acceptance criteria share syntax in one section
and the gate cannot tell them apart. "All boxes checked" therefore means *the work was done*,
not *the result was verified*.

**Also decided:** anything user-facing needs **both** AI and human validation. That maps onto
what exists — source-tree tests are the AI half, UAT in framework-uat the human half.
BUG-215 is the live example: AI half passing, human half outstanding.

**Not yet carded.**

### 9. Borrowed from the Accounting spec template

Reviewed `Accounting/docs/specs/SPEC-TEMPLATE.md`. It independently arrived at three of our
conclusions: exclusions must name an owner; no card list (`Established by:` is provenance,
not membership); a versioned change log.

**Taken:**
- **Citable numbered sections**, stable once published — retire by marking superseded,
  insert as `§Na` rather than renumbering.
- **Three-state implementation line:** `Built` | `Pending — ITEM-NNN` |
  `Door — opens when <trigger> (ITEM-NNN)`. **"Door" solves a live problem:** kanban's
  transitions are *designed but deliberately unbuilt* pending the crossover — not missing,
  not done. It also means **a feature can be complete without every criterion being Built**,
  so "complete" stops being hostage to the longest-deferred item.

**Not taken:** `Confidence:` — accounting rules trace to tax authority; our features have no
external authority to cite.

**Difference preserved:** a **spec** says what must be *true* (normative, medium-independent,
outlives the build); a **feature file** says what we are *building and when it is good
enough*. Accounting's template has no MVP and no status because a rule has no MVP.

### 10. Threshold for when a spec is also required

**Decision (proposed, one line in the template header):** features always; a **spec** only
when the rules are normative and outlive the build — when something external (regulation,
contract, standard) or a formula makes "what must be true" separable from "what we are
building." Accounting has tax authority; kanban does not.

Deliberately not designing the spec layer today.

### 11. Section-reference prefix

**Gary:** bare `§4` is ambiguous — section labels from various docs get cited in
conversation and cost minutes to place.

**Recommendation:** name the feature in the token — **`kanban§4`** — self-locating, reads
naturally aloud, needs no lookup. Specs keep bare `§` or take `SPEC§`; the two never collide.

### 12. `Status:` dropped from the feature template

**Rationale:** with per-criterion `State:` lines, overall status is derivable (all
Built-or-Door → complete; some Built → in-progress; none → planned). A hand-kept header field
restating what the criteria already say is the same rotting-column pattern that killed the
Cards section. **Kept as authored:** `MVP Target:` and `Last Reviewed:` — neither derivable.

### 13. Feature files live with our planning, not in the shipping framework

**Decision:** our five feature files go in `project-hub/planning/features/`. The *capability*
(template, `/fw-new-feature`) is framework product and gets extracted later.

**Rationale:** `workspaces/framework/` is the plugin source tree — only plugin content ships,
and its `CLAUDE.md` says work items live on the repo's single board until the D5 crossover.
Putting our planning artifacts there either ships them to every consumer or creates an
exception to that workspace's authority rule. Same shape as everything else:
`templates/records/ops-record.md` ships; our actual ops records do not.

**Sequencing argument:** authoring the template before writing real feature files encodes
guesses — the same argument the roadmap makes at line 116 about work-item templates and board
conventions. Write kanban's and operations' first, then extract.

**Open (Gary):** where the extracted template belongs. `templates/workspaces/` holds folder
scaffolds copied literally; `templates/records/` holds file templates for instances. A
feature template is the second kind, so `records/` is technically fine — but "records" reads
like instances-of-a-thing (contact, ops-record, ts-case), and a feature definition may want
its own category. **Deferred until the shape proves out.**

---

## The Feature Template (draft, not yet written to disk)

```markdown
# Feature: <Name>

**Workspace:** <workspace>
**MVP Target:** <version or milestone>
**Last Reviewed:** <date>

<!-- Membership is derived: cards carry `Feature: <Name>`. This file never
     lists them. -->

## Definition
<One paragraph. The capability a user gets, in their terms. Not how it is built.>

## Why It Exists
<The problem this solves. Scope creep is measured against this.>

## MVP
<One paragraph: the smallest version that delivers the capability for real.>

## Success Criteria
<!-- Numbered, stable once published; cite as "<feature>§N". Retire by marking
     superseded; insert as §Na rather than renumbering. -->

### §1. <Condition — a sentence, not a title>
**Met when:** <the testable condition>
**Validated by:** AI: <how> · Human: <UAT case or manual check>
**State:** Built | Pending — ITEM-NNN | Door — opens when <trigger> (ITEM-NNN)

## Out of Scope
<Name the owner of each exclusion — a sibling feature, a card id, or "not planned".>

## Open Questions
<Mandatory. Each with the card that owns it. A planned feature is mostly this section.>

## Change Log
| Version | Date | Change |
```

**The one-page cap is a real constraint:** the failure mode of this structure is feature
files becoming essays. Past a page, it is absorbing card detail and the problem is rebuilt.

---

## Files Created

- `workspaces/framework/tests/seed-uat-fixtures.sh` — UAT fixture seeder, 900-block ids,
  `--root` target, `--reset`, namespace prompt, refuses to seed the framework repo's own tree
  without `--force`

## Files Modified

- `workspaces/framework/tests/UAT-COMMANDS.md` — new section **D2**: UAT-33..36 (BUG-215
  batch moves and namespace parity), written against the 900-block fixtures

---

## Current State

### In doing/
- **BUG-215** — batch and namespace halves shipped and tested at source. Fixtures and
  runbook cases now exist. Remaining: install the plugin to the cache, restart, run
  UAT-33..36. The kanban-command criterion stays deferred to the crossover.

### Open threads (next session)
1. **Draft `project-hub/planning/features/kanban.md`** using the template above — the
   template-by-example for the other four features.
2. **Card the acceptance-criteria/sub-task conflation** (decision 8).
3. **Card the `Feature:` field + `/fw-new` validation** (decision 7).
4. **The unowned crossover** — there is no card that builds the new `kanban/`. Recommended:
   one card owning the `kanban_TRANSITIONS` fill and the kanban move command, with the
   conventions/gates cards as dependencies. Then BUG-215's deferred criterion and the
   seeder's kanban half point at a real id instead of a phrase.

---

**Last Updated:** 2026-09-11

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

---

# Continuation — UAT run, two cards filed, kanban.md drafted

**Session Focus:** running the BUG-215 UAT cases at source; filing what they found; writing
the first feature file

---

## UAT Run (source tree, `framework-uat`)

Gary ran the new cases in the UAT project with a second Claude session driving; results
relayed here. **All at source** — the plugin is still not installed to
`~/.claude/plugins/cache/`, and `claude-local-marketplace/framework/` is a symlink to
`workspaces/framework/`, so none of this closes BUG-215's built-plugin criterion.

| Case | Result | Notes |
|---|---|---|
| UAT-33 | PASS | 3 moved, bundle `INC-902/` travelled, `moved: 3 skipped: 0 failed: 0`, exit 0. **Substring trap cleared** — `901` moved INC-901 and left INC-9010 alone. |
| UAT-34 | PASS | `--resolution` on a list refused, exit 1, **nothing moved** — the refusal is pre-flight, before any record is touched. An extra isolation test confirmed an invalid code is refused on a single record with the five valid codes enumerated. |
| UAT-35 | PASS *(with caveat)* | Ran as skip+skip+fail rather than the documented partial-failure path: 901/903 were already in `open/` from a direction-reversed UAT-33, so the start state did not match the case. Confirmed skip ≠ fail, run continues past a failure, output order matches argument order, exit 1 on any failure. |

**Two false alarms from the UAT session, both corrected there:**

1. *"The script invented filenames"* — it reported moves for records the session believed did
   not exist. Cause: it trusted the session-start `git status` snapshot (which the environment
   notice marks as non-updating) over the filesystem. The 900-block fixtures were real and
   staged. **Lesson worth keeping: verify against the filesystem, not a start-of-session
   snapshot.**
2. *"The bundle line is emitted an iteration early"* — it is not. See BUG-225 below.

**Outstanding for the UAT list:** UAT-35 re-run from the documented start state
(`--reset` + re-seed), the partial-failure variant `"905 999 902" onhold` (905 skips, 902
really moves, 999 fails — the case that proves a successful move survives a later failure),
and UAT-36, which is being **rewritten** rather than run (see decision 16).

---

## Decisions Made (continuation)

### 14. Two output defects → BUG-225, filed separately from BUG-215

**Decision:** file the batch-output defects as their own card rather than folding them into
BUG-215.

**Rationale:** BUG-215's criteria are met and it is one verification step from done. Folding
cosmetic defects in would reopen a nearly-closed card — how cards become immortal.

**The diagnosis was corrected.** The UAT session read the bundle line as emitted one iteration
early. It is not: in `move_one` the record moves, the bundle notice prints, *then* that
record's `✅` prints. The line belongs to the record **below** it while the indentation implies
the one **above**. Presentational, not ordering — so the fix is to put the bundle inline on its
own row, not to re-order.

**Output format agreed** (Gary's shape, with alignment):

```
Move from onhold → open
  OK       INC-901-batch-item-one.md
  OK       INC-902-batch-item-two.md  (bundle INC-902/)
  FAILED   REQ-903-batch-item-three.md — invalid transition closed → open
  📊 moved: 2  skipped: 0  failed: 1
```

Status-first because trailing designators cannot align without padding every filename; bundle
inline because it *removes* the misattribution rather than working around it; reason on the row
because that is when the report is read closely; summary kept because it survives scrollback
and is what a script greps.

**Shared formatter is an acceptance criterion**, not a note — Gary: *"fw-move should behave the
same for operations and kanban."* The crossover must inherit the report by construction.

### 15. The tty guard tests the wrong thing (found, then made moot)

The script's `[ -t 0 ]` tests **stdin**, then reads from **`/dev/tty`**. Those can differ:
`echo x | fw-move.sh … closed` leaves `/dev/tty` perfectly usable but fails closed anyway.
Found while establishing that the script needs *no* stdin at all — every other `read` in it is
string parsing.

**Superseded by decision 16** before it was fixed.

### 16. Prompting comes out of the engine entirely

**Decision (Gary):** *"In the kanban cards, we simply reject the move if it's missing the
proper criteria. I see no reason not to do the same thing for operations."*

The script refuses `→ closed` without `--resolution`, per record, with stdout explaining what
is missing — the human resolves and runs again. No prompt, no `/dev/tty`, no `[ -t 0 ]`.

**What this kills:** the tty guard bug (15), any need for `--no-prompt`, and the no-tty UAT
case. The engine becomes fully mechanical and headless-safe, which is what FEAT-221 needs.

**Checked for precedent:** the old engine **never prompts** — every `read` in it is
`IFS=… read -ra` string parsing. Its gates are all greppable (transition matrix, dependency in
`done/`, unchecked criteria), so there was never a judgment to ask about. Its `--force` is a
*bypass* flag, a different concept, and not a model here.

**Which surfaced the one real asymmetry between the namespaces:** operations needs a gate type
kanban does not have — a judgment no grep can compute. The engine header already anticipates
it (*"a dependency lookup and a resolution prompt are not expressible as a list"*). So
**operations ≈ kanban + different folders + a judgment gate** — a caveat on Gary's "operations
is just a variation of kanban," not a refutation.

### 17. `--resolution` applies to the whole batch (supersedes BUG-215's 2026-09-07 decision)

**Decision (Gary):** *"If I had a batch of INC about the same root issue, then they would all
close with the same resolution."*

**This inverts the 2026-09-07 decision on its own evidence.** That decision assumed a batch
close meant *different records with different outcomes*, and therefore required per-record
prompting. The realistic case is the opposite: **a batch close happens precisely because the
records share a root cause**, and sharing a cause means sharing a classification. The
incoherence it worried about ("one shared code paired with N individually-written outcomes")
does not arise.

**What stays per-record:** the one-line reason and the durable-knowledge answer, each in its
own record's Outcome section. The code is shared; the story is not.

**⚠️ NOT YET WRITTEN TO BUG-215.** This supersession exists only here and in conversation. It
must be recorded on the card as a dated note — *without* deleting the 2026-09-07 reasoning,
which is the record of why the earlier conclusion was reached.

### 18. The resolution code is a filter, not knowledge → FEAT-226

**Gary:** *"A 'code' only records basic information about the closure. The value is some record
of how we identified the problem and resolved it."*

**The value split, settled:**

| Artifact | Holds | Value |
|---|---|---|
| `Resolution:` code | One of five words | Filtering and counting — macro only |
| Outcome reason | One line, per record | Why *this* record closed |
| **kb entry** | The diagnosis | **Solving the next one** |

**So the code stays cheap and the attention goes to the kb hand-off** — and the audit found
that hand-off is **prose at three layers and enforced at none**: the close gate asks the
durable-knowledge question, the record template says to link the kb entry or say "nothing
durable", and the move engine never reads the Outcome section. An AI that skips the question
closes the record exactly as successfully as one that asks it. ADR-008 Root 2, in the workflow
whose entire value is the knowledge it captures.

**Contrast that makes it sharp:** kanban's `→ done` blocks mechanically on unchecked criteria;
operations has no equivalent gate.

**No live evidence either way** — this repo holds zero real ops records (verified), and
`framework-uat`'s are fixtures. A defect in the mechanism, not a measured failure rate.

**Filed as FEAT-226, sequenced to build *with* the kb feature**, not now — designing the kb
hand-off before kanban and operations settle is the guessing pattern this project keeps
catching.

### 19. kanban.md — one feature, three groups

**Rejected:** splitting into kanban-board / kanban-cards / kanban-orchestration. Cards and
board are not separable — *status **is** folder*, so the card's format and the board's states
are one design, and the seam would be arbitrary.

**Accepted:** grouping *within* one file — **Board** (what it is), **Cards** (what is in it),
**Gates** (what protects it). Gates was not in Gary's proposed list but is where most criteria
live; it is the difference between a board and a folder tree.

**Also rejected from the grouping:** Lifecycle as a separate group (it *is* the board's
definition — states plus legal transitions are what make folders a board), and Orchestration
and Reporting as groups (both are *consumers* of the board; pulling them in makes kanban absorb
everything that touches it, which is how the roadmap's deliverables lost their edges).

**Numbering is flat across groups** so `kanban§8` stays unambiguous; groups are headings, not
namespaces.

### 20. Feature files name functions, never commands

**Gary:** the doc should say what function is served, not which command serves it.

**The test applied:** *if the command were renamed tomorrow, would this criterion change?* For
lifecycle and gates, no. For "the command is called `fw-move`", yes — so that does not belong.

**And the corollary:** creation and movement **are** the two operations the lifecycle is
defined for, so the *functions* must appear. A lifecycle spec that never says cards enter here
and move along these paths is incomplete.

### 21. §3 — entry is `backlog/` or `todo/`, nothing else

**Gary:** *"New cards can enter in backlog (normal) or todo (urgent), that's it. Anything else
destroys planning."*

**Rationale recorded on the criterion:** a card that appears mid-board was never planned,
estimated, or queued — invisible to every decision made before it arrived.

### 22. §5 — WIP limits warn loudly and never block

**Decision reversed mid-discussion, and the reversal is the point.** The lean was toward
blocking (with the override question framed as hard-block / `--force` / must-move-something-out).
Gary reversed it on evidence: *"I've only had one project where I've had issues with WIP, the
Honda HPC project. All the others WIP limits as they are worked great."*

**Why blocking is wrong here:** one project out of many hitting the limit is a signal about
*that board* (it needs grooming), not about the gate. Blocking would force a backlog problem to
surface as a fight with the tooling, and the predictable workaround — editing `.limit` to get
unblocked — is worse than the breach: a permanent change made to solve a temporary problem,
with nothing recording that it happened.

**Narrowed on Gary's correction:** warn on moves **into** an over-limit folder, not on every
move while over limit. A board at 15/10 stays quiet while cards move *out* of `todo/` — that
direction drains it.

**Editable limits are a feature:** each repo tunes its own balance, so the limit is a per-repo
declaration the gate reads. No mechanism can stop someone editing a declaration and the feature
does not pretend otherwise.

**No remedy advice in the message** (Gary): suggesting "move something out or finish something
nearly done" would not change the behaviour. **"The real purpose of WIP is to encourage
focus"** — a nag that does not block is honest about being a nudge.

**Correction to an earlier claim in this session:** Claude reported WIP limits as "declared but
nothing enforces them," citing the roadmap's warning note. Verified against code, it is
narrower — the **old** engine warns but only on `→ doing` (so a board stuck at 15/10 in `todo/`
never warns again), and the **new** engine has no `.limit` handling at all.

---

## What kanban.md Surfaced

Writing the feature file did the job it was supposed to do — it made the shape of the work
visible in one place:

- **14 criteria, and exactly one is Built** (§13 batch moves, and only for operations).
- **§4 is a Door with no card behind it** — nothing in the roadmap builds the new `kanban/`.
- **Three criteria have no owner at all:** the crossover (§4), criteria-vs-sub-tasks (§8), and
  the `Feature:` field (§9).
- **The MVP is smaller than feared** — today's board has five of the seven authored folders;
  `accept/` and `cancelled/` are the whole structural delta. This confirms Gary's correction
  from the morning: kanban is the *most* developed part of the framework, and what is undefined
  is the convention inventory, not the capability.

---

## Files Created (continuation)

- `project-hub/work/backlog/BUG-225-move-engine-batch-output-misattributes-bundles.md` —
  bundle misattribution + batch report format; shared-formatter requirement so the crossover
  inherits it
- `project-hub/work/backlog/FEAT-226-close-gate-enforces-durable-knowledge-handoff.md` —
  the kb hand-off has no mechanism; High priority, sequenced with the kb feature
- `project-hub/planning/features/kanban.md` — **the first feature file** (v0.3), the
  template-by-example for operations, kb, workspaces, and other

---

## Current State (end of session)

### In doing/
- **BUG-215** — unchanged. Both halves shipped; UAT-33..35 pass at source. **Blocked on:**
  plugin install to the cache + restart, then the full set re-run. Also needs the decision-17
  supersession note written on the card.

### In backlog/
- **BUG-225**, **FEAT-226** — filed today, not started.

### Not carded (tracked only in kanban.md's Open Questions)
1. **The crossover** — nothing builds the new `kanban/`. Recommended: one card owning the
   kanban transition table and the kanban move function, with TASK-219 and TECH-177 as
   dependencies.
2. **Acceptance criteria vs sub-tasks** (kanban§8).
3. **The `Feature:` field** (kanban§9).

### Next session
1. Write the BUG-215 supersession note (decision 17) — the one loose thread from today.
2. Update BUG-225's scope: prompt removal (16) and the shared batch code (17).
3. Rewrite UAT-36 — it currently tests per-record prompting, which is being removed.
4. Draft `operations.md` — and use it to test Gary's "operations is just a variation of
   kanban" claim against the judgment-gate caveat.

---

**Last Updated:** 2026-09-11

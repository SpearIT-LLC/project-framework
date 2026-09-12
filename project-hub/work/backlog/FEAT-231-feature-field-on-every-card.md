# Feature: Every Card Names the Feature It Serves

**ID:** FEAT-231
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-09-11
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

Add a **`Feature:`** field to the work-item template, validated at creation against the set of
feature files. It sits **beside `Workspace:`**, not instead of it.

This is what makes feature membership *derivable* rather than hand-kept — and it is the
mechanism that catches a card serving no feature, which is usually scope creep, caught cheaply
at creation.

## Why

**Feature files must not list their cards.** A hand-kept card list means every creation and
every move touches two files, and the one nothing enforces is the one that rots — the pattern
that drifted `ROADMAP-DELIVERABLES.md` twice and misled a whole session on 2026-09-11. So
membership runs **one direction: card → feature**, and a feature's card list is a query.

**The question the field forces is the valuable part.** Not *"does this FEAT have a doc"* but
*"which feature does this card serve — and if none, is that a missing feature or a card that
should not exist?"* The second outcome is why the field earns its place.

**Both fields, because they answer different questions.** `Workspace:` is *whose work* (which
customer, which product). `Feature:` is *what capability*. A feature belongs to a workspace;
the pair is what makes roadmap and reporting sliceable — the D4 reporting cards need both cuts.

## Design

### The field — `Serves:`, with a qualified value

```
**Workspace:** framework
**Serves:** feature/kanban
```

Required. An unknown value is **refused**, with an offer to create the feature file — the same
shape as the close gate's resolution prompt: a judgment step the AI asks, enforced by the
script.

**Why `Serves:` and not `Feature:`** (settled 2026-09-11). The framework must treat all four
workspace types equally — a *product* has features, a *project* has **deliverables**, a
*knowledgebase* has **domains**. A field literally named `Feature:` reads wrong on a project
card, and the framework would be privileging the type Gary happens to work on most. `Serves:`
is correct in every context and never implies a strength of contribution that some card types
(a BUG restores rather than delivers) do not have.

**Why the value is qualified** — `feature/kanban`, not `kanban`:

- **A cold reader learns what kind of thing it is.** Every session starts as a newcomer; a bare
  value tells it nothing about what `kanban` *is* or where its definition lives. This session
  lost real time to exactly that class of ambiguity.
- **It disambiguates across workspaces.** A product feature and a project deliverable can both
  be called "Reporting". Bare values collide; prefixed ones do not.
- **The validator gets stronger** — a `deliverable/` prefix on a product workspace is a
  detectable error.

**It is a logical reference, not a path.** TECH-027 (settled by TASK-219): *reference by id,
never by path — a path breaks on every move; an id survives*. `feature/kanban` resolves through
the workspace's declaration (TECH-232); it does not encode where the file sits today. The
create gate supplies the prefix from the workspace type, so the author types only the name.

**Rejected:** `Links To:` — names the mechanism rather than the relationship, and cards already
have a `Related` section full of links. `Delivers:` — stronger and better in the common case,
but wrong for a BUG. `Supports:` — too weak; it permits "vaguely related to", which is how the
`Theme:` field drifted into 13 values against 5 declared.

### `Serves:` replaces `Theme:` — the history, because it was nearly re-litigated

**`Theme:` already exists and carries this data badly.** The old build's `/fw-roadmap` model is
Themes (stable categories — what the project *is*) plus Planning Periods (temporal, with
success criteria). Work items carry both fields.

**The naming was decided on 2026-02-03 (FEAT-095), and "Feature Area" / "Feature Domain" were
explicitly rejected** as *"too prescriptive, tied to 'features'"*. Genericness was recorded as a
**virtue** — "flexible", "open to user interpretation", "accommodates functional, strategic, or
technical organization". There is no recorded objection anywhere that Theme is too generic.

**The usage data says the rejection was wrong** (measured 2026-09-11 across 142 board files):

- 101 cards carry a `Theme:` — it was adopted, not ignored
- **13 distinct values in use; only 5 are declared in `ROADMAP.md`**
- *Framework Consistency* is the third most-used theme (15 cards) and **is not in the roadmap
  at all**; *Reporting & Visibility* is declared and has **zero** cards
- Near-duplicate splinters: *Workflow*, *Workflow Precision*, *Workflow Commands*,
  *Workflow Commands / Distribution*
- One value is `Distribution & Onboarding (Sprint D&O 4 - Polish)` — a planning period smuggled
  into the theme field, the exact conflation the 2026-02-03 design existed to prevent

**The difference is mechanization, not vocabulary.** A theme is a *label* — FEAT-095 chose
"loose coupling — no referential integrity, no sync logic" deliberately, so nothing can refuse a
near-duplicate. `Serves:` resolves against a file that exists, so the drift above is
structurally impossible.

**`Planning Period:` stays.** Temporal phases with success criteria are genuinely orthogonal to
capability, and FEAT-198 is right that the framework already ships the missing piece.

**Open:** whether `Theme:` is retired outright or kept as a deprecated alias during transition.
The 13 values map onto features fairly cleanly, and this card's grooming-based migration already
handles the long tail — which argues for outright retirement at migration.

**Correction recorded:** a draft of TECH-228 and the 2026-09-11 session history say `Theme:` and
`Planning Period:` were *"superseded by FEAT-198"*. **They are not** — FEAT-198 keeps both and
supersedes `ROADMAP-DELIVERABLES.md`, the ad-hoc file. The error came from reading that
roadmap's summary instead of the card.

### Two cases the value must handle

**1. Cross-cutting cards.** TECH-230 changes the work-item template, the done-gate, and every
existing card. **The tiebreak is the feature whose criteria the card serves, not the files it
touches** — TECH-230 closes `kanban§8`, so it is Kanban. Without this rule the field becomes a
guess.

**2. Infrastructure cards that serve no feature.** BUG-144 is an Anthropic plugin namespace
collision — platform, not capability. **`Feature: none` is a legitimate value**, and it is
required rather than blank: a blank field tells you nothing, `none` tells you someone decided.

### What it enables

- A feature's card list becomes a query — the reason feature files hold no card list.
- `State:` lines on feature criteria could eventually be **derived** from the cards that serve
  them, which is the one hand-kept thing in a feature file that is expected to churn.
- Reporting can slice by capability, not just by workspace (D4).

### Open

- **Is `Feature:` also wanted on operations records?** An INC serves a customer, not a
  framework capability — the answer is probably no, and the field stays board-only. Confirm when
  `operations.md` is written.
*(Migration is settled — see below.)*

## Migration — settled 2026-09-11

**No bulk backfill.** ~100 open cards have no `Feature:`, and hand-backfilling them is the kind
of work that does not get finished.

- **New cards** — required at creation.
- **`backlog/`** — filled in **during grooming**, when the card is being read anyway.
- **`todo/` → `doing/`** — **required.** The field must be present to start work.
- **Already in `doing/`** — **grandfathered**, unless a card would genuinely benefit.

**Why `todo → doing` is the enforcement point:** it is already where the ripeness review
happens, so this is one more thing that gate checks rather than a new ceremony. It is also the
last moment the answer is cheap — by the time work starts, the card has been read closely enough
that its feature is obvious.

**Consequence:** the field is effectively required for everything that *matters* (work in
flight, work about to start) and optional for the long tail of `backlog/`, which is where an
unanswerable `Feature:` would most likely mean *the card should not exist* — a question better
asked at grooming than at migration.

## Acceptance Criteria

- [ ] The work-item template carries `Feature:` beside `Workspace:`, with the cross-cutting
      tiebreak and the `none` value stated in the template's comment header
- [ ] Creation refuses an unknown feature and offers to create the feature file
- [ ] `Feature: none` is accepted for infrastructure cards
- [ ] A blank or missing `Feature:` is refused at creation
- [ ] `todo/` → `doing/` is refused when `Feature:` is missing — the migration enforcement point
- [ ] Cards already in `doing/` when the field ships are not blocked by it
- [ ] A card list for a feature can be produced by query, with no hand-kept list anywhere
- [ ] Validated: **AI** — an unknown value is refused, `none` is accepted, the query returns the
      right cards · **Human** — the create gate's question is answerable without looking
      anything up

## Tasks

- [ ] Update `templates/records/work-item.md`
- [ ] Add validation to the create gate
- [ ] Backfill per the chosen approach

## Related

- **TECH-232** — **blocks this card.** The workspace declaration says what kind of thing a card
  serves here and where those live. Without it the field cannot be validated and the create
  gate cannot ask in the workspace's own vocabulary.
- **kanban§9** — the criterion this card closes.
- **TASK-219** — settled the work-item template this modifies.
- **FEAT-175** — the create gate this extends (shipped 0.4.7).
- **TECH-230** — the other template/gate change settled the same day; they touch the same two
  files and should land aware of each other.
- **FEAT-163 / FEAT-196** — workspace-aware reporting. `Feature:` is the second axis they need.

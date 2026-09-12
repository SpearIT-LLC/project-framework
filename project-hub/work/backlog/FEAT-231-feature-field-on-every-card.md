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

### The field

```
**Workspace:** framework
**Feature:** Kanban
```

Required. Validated at creation against the feature files in
`project-hub/planning/features/` (location per the workspace's own convention — the framework
repo's path, not a shipped one). An unknown value is **refused**, with an offer to create the
feature file — the same shape as the close gate's resolution prompt: a judgment step the AI
asks, enforced by the script.

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
- **Migration of existing cards.** ~100 open cards have no `Feature:`. Backfilling by hand is
  the kind of work that does not get finished. Options: backfill only cards in `todo/`/`doing/`
  and let `backlog/` fill in as cards are groomed, or accept the field as required for *new*
  cards only until a card is next touched.

## Acceptance Criteria

- [ ] The work-item template carries `Feature:` beside `Workspace:`, with the cross-cutting
      tiebreak and the `none` value stated in the template's comment header
- [ ] Creation refuses an unknown feature and offers to create the feature file
- [ ] `Feature: none` is accepted for infrastructure cards
- [ ] A blank or missing `Feature:` is refused at creation
- [ ] A card list for a feature can be produced by query, with no hand-kept list anywhere
- [ ] Validated: **AI** — an unknown value is refused, `none` is accepted, the query returns the
      right cards · **Human** — the create gate's question is answerable without looking
      anything up

## Tasks

- [ ] Decide the migration approach for existing cards (see Open)
- [ ] Update `templates/records/work-item.md`
- [ ] Add validation to the create gate
- [ ] Backfill per the chosen approach

## Related

- **kanban§9** — the criterion this card closes.
- **TASK-219** — settled the work-item template this modifies.
- **FEAT-175** — the create gate this extends (shipped 0.4.7).
- **TECH-230** — the other template/gate change settled the same day; they touch the same two
  files and should land aware of each other.
- **FEAT-163 / FEAT-196** — workspace-aware reporting. `Feature:` is the second axis they need.

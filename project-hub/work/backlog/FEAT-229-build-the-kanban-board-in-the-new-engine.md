# Feature: Build the Kanban Board in the New Engine

**ID:** FEAT-229
**Type:** Feature
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-09-11
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

Make `kanban/` a working board in the ADR-009 build: fill the namespace's policy row, port the
three move gates, ship the create and move functions, and author the work-item template the new
build has never had.

**This card builds the board. It does not switch to it** — the cutover from
`project-hub/work/` to `kanban/` is its own card (see Related), because building and switching
are separable work with different risk: the build can land, be tested, and sit unused; the
switch is atomic and one-way.

## Why This Card Exists

**Nothing built the new board.** The ADR-009 D5 crossover is referenced from four places in
`ROADMAP-DELIVERABLES.md` and owned by none of them. `kanban.md§4` records it as a Door with no
card behind it.

**The cause was a naming habit.** "The crossover" names a *moment* — a single atomic switch at
graduation — so the conversation kept pointing at a future event and nobody noticed there was
no card for the **capability**. The moment is the last ten minutes of the work; the work is
everything below.

This is the bottom-up blindness the roadmap was diagnosed with on 2026-09-11: deliverables were
derived from cards that happened to exist, so a capability with no card was structurally
invisible.

## Current State

The engine declares kanban and refuses it
([`fw-move.sh:59-62`](../../../workspaces/framework/scripts/fw-move.sh#L59-L62)):

```bash
kanban_ROOT="kanban"
kanban_FOLDERS="backlog blocked todo doing accept done cancelled"
kanban_TRANSITIONS=""
kanban_TERMINAL="done cancelled"
```

An empty `TRANSITIONS` is the declared-but-not-wired signal; the refusal fires at
[`fw-move.sh:81`](../../../workspaces/framework/scripts/fw-move.sh#L81) **before any id is
parsed**, which is why seeding kanban fixtures proves nothing today.

**What already exists to port from:** the old engine (`.claude/scripts/fw-move.sh`) implements
all three gates and has run this project for months. This is a **port with justified carry-ins**
(`workspaces/framework/CLAUDE.md`), not a design exercise.

**What does not exist anywhere:** a work-item template. `templates/records/` holds
`contact.md`, `ops-record.md`, `ts-case.md`, `work-item.md` — and `work-item.md` serves all five
types identically, which is its own defect (TECH-228).

## Scope

1. **Fill `kanban_TRANSITIONS`** and remove the not-wired refusal for this namespace.
2. **Port the three gates** — dependency (`→ doing` requires deps complete), acceptance criteria
   (`→ done` requires no unchecked boxes), and the transition matrix. **Ripeness stays a
   judgment step** enforced by the command, never claimed as a script check (ADR-007 D7).
3. **The move function for kanban** — one engine, one policy table; the namespace is an
   argument, never inferred (BUG-215).
4. **The create function for kanban** — next id from the shared sequence, template per type,
   required fields, legal entry folders only (`kanban§3`: `backlog/` or `todo/`, nothing else).
5. **Author the work-item template**, encoding the conventions TASK-219 settles.
6. **WIP warnings** — loud on a move *into* an over-limit folder, never blocking (`kanban§5`).
7. **Terminal-state archival** — a spike archives to `history/spikes/`, a POC spike as a
   *folder*; neither produces a release (`kanban§2`, TECH-228).

## Out of Scope

- **The cutover itself** — making `kanban/` the live board and retiring `project-hub/work/`.
  Own card; this one leaves the new board built and unused.
- **The board conventions** — TASK-219 decides them; this card *encodes* them.
- **Checkbox state semantics** — TECH-177.
- **Batch output format** — BUG-225, which lands in the shared engine and is inherited here.

## Dependencies — and the honest critical path

This card **cannot start** until the conventions it encodes are settled. Writing it makes the
path concrete, and the path is longer than `kanban.md` currently implies:

- **TASK-219 Group 1** — numbering, parent/child, supporting files, cross-references,
  status-vs-folder. **The blocker**, and it contains an unresolved conflict: FEAT-021 (dotted
  sub-ids) vs TECH-082 (a `Parent:` field), with the board using both styles today. A template
  authored before this resolves encodes a guess.
- **TECH-177** — checkbox states, including `[?]`/`[h]`; the gates must read them.
- **TECH-228** — the SPIKE template, and the type-per-template split this card's create
  function must resolve.

**Consequence worth stating plainly:** kanban's MVP is gated on a *decision* (the parent/child
conflict), not on effort. Until that is settled, no amount of implementation time moves this
card.

## Acceptance Criteria

- [ ] `kanban_TRANSITIONS` is populated and the not-wired refusal no longer fires for kanban
- [ ] All three gates refuse correctly, each naming what is missing — verified with a fixture
      that violates each
- [ ] Ripeness is **not** claimed as a script check anywhere
- [ ] A card can be created into `backlog/` or `todo/` and nowhere else
- [ ] The work-item template exists and encodes the TASK-219 conventions; each convention traces
      to a mechanism, not a paragraph
- [ ] A move into an over-limit folder warns loudly and still succeeds
- [ ] A spike moved to a terminal state archives to `history/spikes/`; a POC spike archives as a
      folder
- [ ] One engine serves both namespaces — no kanban-specific copy of the move logic, verified at
      the call sites
- [ ] The kanban fixture seeder works (`seed-uat-fixtures.sh` currently refuses kanban by
      design) and UAT cases mirroring UAT-33..36 pass
- [ ] Validated: **AI** — every gate and transition exercised against a scratch fixture;
      **Human** — a full UAT pass in `framework-uat` against the **installed plugin**, not the
      source tree

## Related

- **The cutover card** — not yet written. Makes `kanban/` live and retires
  `project-hub/work/`; atomic, one-way, and the only ADR-009 D5 step this card leaves.
- **`kanban.md§4`** — the Door this card opens. Also `§1`, `§2`, `§3`, `§5`, `§6`, `§11`, `§12`.
- **TASK-219** (conventions, the blocker) · **TECH-177** (checkbox states) ·
  **TECH-228** (templates per type).
- **BUG-215** — established the one-engine/policy-table shape and that the namespace is always
  an argument.
- **ADR-009 D5** — the decision this implements.

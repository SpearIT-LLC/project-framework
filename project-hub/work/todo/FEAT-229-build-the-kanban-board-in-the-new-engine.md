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

**What already exists — verified 2026-09-11, correcting an earlier draft of this card:**

- **The work-item template** — `templates/records/work-item.md`, built by TASK-219 on
  2026-09-09, encoding the Group 1 conventions. One template with a `Type:` field, mirroring
  `ops-record.md`; five near-identical templates would be five things to keep in sync.
- **The kanban queue scaffold** — `templates/queues/kanban/`: `backlog blocked todo doing
  accept done cancelled release`, `.limit` files (todo 10, doing 2), and a README carrying the
  flow.
- **The create gate** — FEAT-175, shipped in 0.4.7. `fw-new.sh` creates cards.
- **The Group 1 conventions** — numbering, parent/child, supporting files, cross-references,
  status-vs-folder: all five settled **with mechanisms** on 2026-09-09.

**So the remaining work is narrower than first written.** TASK-219 line 167 names it exactly:
*"`fw-new.sh` to create cards and scaffold `kanban/` on first use, and the kanban row in
`fw-move.sh` wired to real transitions and gates."*

## SPLIT INTO THREE CHILDREN — 2026-09-22

**This card is now the parent. The work is in FEAT-229.1/.2/.3.** (Gary: *"I'm good with
splitting the card into sub-task cards"* / *"Smaller bites are better."*)

| Child | Scope | Depends On | Folder |
|---|---|---|---|
| **.1** | Wire `kanban_TRANSITIONS` for the five settled folders; retire the not-wired refusal; teach the seeder | *(nothing)* | `todo/` |
| **.2** | The gates — dependency, acceptance (TECH-177's contract), WIP warnings | .1 | `todo/` |
| **.3** | `accept/` + `cancelled/` + terminal archival | .2, **TASK-223** | `todo/` |

**All four sit in `todo/` together, and that is correct.** A dotted id is *tight coupling*: the
child moves with the parent and the family counts as **one** WIP item (TASK-219 Group 1). An
earlier plan put .3 in `backlog/` because it is blocked; the engine moved it with the parent
and **the engine is right** — `.3`'s `Depends On: TASK-223` is what records that it cannot
start, not its folder. Splitting the family across folders would fight the convention and
double-count the WIP.

**Two Scope items below are already satisfied — verified by execution, not inspection.** Run in
a scratch repo on 2026-09-22:

```
$ fw-new.sh FEAT test-scaffold
Created kanban queue at kanban/ (first use)          ← item 4's scaffold: DONE
Created: kanban/backlog/FEAT-001-test-scaffold.md    ← item 4's create: DONE
$ fw-new.sh BUG t2  →  BUG-002                        ← shared sequence: correct
$ fw-move.sh kanban FEAT-001 todo
❌ namespace 'kanban' is declared but not active      ← the only real gap
```

`fw-new.sh:155-163` scaffolds on first use (FEAT-175, shipped 0.4.7) and `templates/records/
work-item.md` already encodes the TASK-219 conventions. **Items 4 and 5 are verification, not
authoring** — this card's own *"narrower than first written"* note did not go far enough.

**`accept/` and `cancelled/` were deferred deliberately** (Gary, 2026-09-22): both sit in
`kanban_FOLDERS` with semantics TASK-223 has not settled, so leaving them to .3 means **.1 and
.2 are blocked by nothing** and run straight through.

**The dependency review that produced this split** applied TECH-237's test — *can this card,
finished, verify this without another card shipping first?* This card had **no `Depends On:`
field** while carrying a hidden TASK-223 dependency through `accept/`, which is the same defect
TECH-237 was written to prevent and the same one that stalled FEAT-221.

---

## Scope (original — now distributed across the children)

1. **Fill `kanban_TRANSITIONS`** and remove the not-wired refusal for this namespace. → **.1**
2. **Port the three gates** → **.2** — dependency (`→ doing` requires deps complete),
   acceptance criteria (`→ done` requires no unchecked boxes), and the transition matrix.
   **Ripeness stays a judgment step** enforced by the command, never claimed as a script
   check (ADR-007 D7).
3. **The move function for kanban** → **.1** — one engine, one policy table; the namespace
   is an argument, never inferred (BUG-215).
4. **The create function for kanban** → **ALREADY DONE** (FEAT-175, verified by execution
   2026-09-22) — next id from the shared sequence, template per type, required fields, legal
   entry folders only (`kanban§3`).
5. **Author the work-item template** → **ALREADY DONE** (TASK-219, 2026-09-09) — it exists
   and encodes the Group 1 conventions. Reduces to verification.
6. **WIP warnings** → **.2** — loud on a move *into* an over-limit folder, never blocking
   (`kanban§5`).
7. **Terminal-state archival** → **.3** — a spike archives to `history/spikes/`, a POC spike
   as a *folder*; neither produces a release (`kanban§2`, TECH-228).
8. **Implement TECH-177's checkbox contract** → **.2** (added 2026-09-21). The gates are written
   checkbox-aware from the start: the done-gate blocks on `[ ]` **and** `[/]` while `[x]` and
   `[-]` pass **by design**; `→ doing` blocks on `[?]` and `[h]`, naming the marked line and
   its note; readiness is unchanged (only `[ ]` blocks). TECH-177 is the authored source —
   point at it, do not restate it (ADR-008).

## Out of Scope

- **The cutover itself** — making `kanban/` the live board and retiring `project-hub/work/`.
  Own card; this one leaves the new board built and unused.
- **The board conventions** — TASK-219 decides them; this card *encodes* them.
- ~~**Checkbox state semantics** — TECH-177.~~ **Moved INTO scope 2026-09-21.** TECH-177
  was retargeted at the new engine as a *specification*, and this card implements it — see
  Scope item 8. Listing it here would now be false: there is no checkbox gate in the new
  engine for TECH-177 to change on its own.
- **Batch output format** — BUG-225, which lands in the shared engine and is inherited here.

## Dependencies

**This card is not blocked.** An earlier draft said it was gated on the FEAT-021 / TECH-082
parent-child conflict. **That conflict does not exist** — TASK-219 read both cards on
2026-09-09 and found them *complementary, not competing*:

- **Dotted ids** (`FEAT-042.1`) = tight coupling. The child dies with the parent, moves with
  it, counts as **one** WIP item.
- **`Parent:` field** = provenance. The child stands alone, is worked separately, counts as
  its **own** WIP item.

**Both adopted**, with the rule *"does this make sense on its own?"* — yes → `Parent:`,
no → dotted. The rule lives in the template's own comment header so it travels with every card.

**Soft dependencies, neither blocking the core work:**

- ~~**TECH-177** — checkbox states `[?]`/`[h]`. The gates should read them, but the three
  ported gates do not require them.~~

  > **Superseded 2026-09-21 — TECH-177 is no longer a soft dependency; it is this card's
  > contract.** It was retargeted (new engine only) from a code change into the authored
  > specification of the convention, precisely so these gates are written checkbox-aware
  > the first time instead of being revised afterwards. TECH-177 was pulled into `doing/`
  > ahead of this card for that reason. **Read it before porting the gates.**
- **TECH-228** — the SPIKE template. Affects what the create function resolves for one type,
  not whether it works.

**The stale-roadmap lesson, recorded because it cost a draft:** `ROADMAP-DELIVERABLES.md` lists
TASK-219 in `todo/` as "the blocker" and says the new build ships no work-item template. Both
were true on 2026-09-02 and false by 2026-09-09. The file's own header says **"do not reconcile
it a third time — read it for the ranking; go to the card for anything else."** Card state must
come from the board, never from the roadmap.

## Acceptance Criteria

- [ ] `kanban_TRANSITIONS` is populated and the not-wired refusal no longer fires for kanban
- [ ] All three gates refuse correctly, each naming what is missing — verified with a fixture
      that violates each
- [ ] Ripeness is **not** claimed as a script check anywhere
- [ ] **TECH-177's checkbox contract is implemented in these gates** (added 2026-09-21):
      `[ ]`/`[/]` block `→ done`, `[x]`/`[-]` pass, `[?]`/`[h]` block `→ doing` naming the
      marked line and its note, readiness unchanged. The ADR-007 D7 boundary — a marker
      records an event, it is not a ripeness judgment — is documented where the gate lives.
      The contract is authored in `workspaces/framework/skills/fw-checkbox-states/SKILL.md`
      (TECH-177, 2026-09-22); implement it, do not restate it.
- [ ] **The checkbox contract is validated** (moved here from TECH-177, 2026-09-22):
      **AI** — every one of the six states exercised against a scratch fixture; **Human** — a
      `[-]` criterion moves to `done/` and a `[/]` criterion is blocked, against the
      **installed plugin**, not the source tree (TECH-188).

      > **Why this criterion lives here and not on TECH-177.** TECH-177 is the
      > *specification*; validating it requires the gates **this card builds**. A criterion
      > its own card cannot verify made TECH-177 unfinishable, and declaring
      > `Depends On: FEAT-229` there would have formalized a **cycle** — Scope item 8 depends
      > on TECH-177's specification existing. The seam was wrong, not the dependency.
      > Validating the contract is part of implementing it. See **TECH-237**, which adds the
      > create-gate question that would have caught this at authoring time.
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

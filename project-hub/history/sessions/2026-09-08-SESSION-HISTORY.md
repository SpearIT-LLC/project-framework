# Session History: 2026-09-08

**Date:** 2026-09-08
**Participants:** Gary Elliott, Claude Code
**Session Focus:** BUG-215 — from "batch moves dropped" to the namespace decision underneath it; `[!]` → `[h]` on the Obsidian evidence

---

## Summary

Two corrections drove the day, both Gary's. The `[!]` marker was checked against the
Obsidian convention it claimed to follow and turned out to mean *important*, not
*blocked* — replaced with `[h]`. Then BUG-215's scope was challenged: batch moves were a
symptom, and the cause was the engine guessing its namespace from the id shape. That was
fixed with two commands, one script, and a policy table. A repo-structure diagram
surfaced late in the session and answered most of TASK-219 Group 2a.

---

## Work Completed

### `[!]` → `[h]` — the marker conflicted with its own cited convention

Gary: *"I may have mixed up Obsidian's definition of this one. I interpreted it to mean
blocked but I think Obsidian defines it as just important."* Verified against the Obsidian
Tasks documentation rather than either recollection:

- `[!]` is **"important" in all four theme collections** (Minimal, Things, ITS, SlRvb) —
  unanimous. Imported into Tasks it is classified as status type **TODO**, so a blocking
  gate on it would fight the tool's own model.
- `[?]` is **"question"** in all four — what we meant. Unchanged.
- `[h]` is **free in all four** *and* is the symbol the Tasks docs use to illustrate the
  `ON_HOLD` status type — added in Tasks 7.23.0 for work "not actionable right now", and
  contrasted in those docs with dependencies, which are *sequencing*. That is the same
  macro/micro line TECH-177 already drew between `Depends On:` and the marker.

Candidates checked and rejected: `[b]` (bookmark in all four), `[B]` (Brainstorm in
ITS/SlRvb), `[O]` (Outline/Plot in ITS/SlRvb), `[o]` (free but meaningless, and renders
confusingly beside an empty checkbox). Case is deliberately significant in those
collections, so flipping case to dodge a collision just claims the other half of
someone's pair.

15 live references updated across TECH-177, FEAT-221, FEAT-221.2. Historical `[!]`
mentions in TECH-177's original deferral note were left intact.

### BUG-215 — rescoped, then the namespace half implemented

**The challenge.** Gary: *"The farther we go with this the more uneasy I feel about it.
We seem to be drifting from the original goal. Migrate the old framework to the new. The
move command should work the same as it did before with the addition that it can handle
kanban and operations moves. That's really it."*

Correct on both counts. The card was titled "drops batch moves" and had become a design
session about resolution semantics. And the ambiguity Gary spotted was real:
`fw-move 001,002,003 todo` — the card's own example — could not say which namespace the
ids belonged to.

**The defect the batch work exposed.** `case "$PREFIX" in ""|INC|REQ) NS="operations"`
made a bare numeric silently mean operations, so that command resolved against operations
and *then* failed because `todo` is not an operations folder. The wrong error, and a
misroute waiting at the D5 crossover. Gary: *"now I see we have the same issue for single
or multi moves. This is the first thing we need to resolve."*

**Implemented:** `/fw-move` renamed `/fw-move-ops`, always passing `operations`;
`fw-move.sh <namespace> <ids> <target>`; policy table declaring root, folders,
transitions and terminal states per namespace; the prefix guess deleted entirely. The
`kanban` row is declared with the authored folder set but **not wired** — it refuses with
a pointer to the root `/fw-move` until crossover.

13 test cases against a fixture holding both namespaces (N1–N13 on the card). No
regressions in the batch half committed the previous evening.

### TASK-219 Group 2a — largely answered by the structure diagram

Gary produced a Lucid repo-structure page (same document as `fw-implement-todo`) carrying
the authored folder set for the ADR-009 build:

```
kanban/     backlog  blocked  todo  doing  accept  done  cancelled
            release/<product>          templates/ (marked "alt idea")
operations/ open  onhold  closed
kb/         <domain>/{cookbook,faq,reference,research}   index
workspaces/ <created as needed>
history/    sessions/YYYY/  retrospectives/  archive/
```

`accept/` and `cancelled/` are **authored, first-class** — they were open questions that
morning and are settled by this. Recorded on the card as ratification rather than
decision.

---

## Decisions Made

1. **`[h]` replaces `[!]` for blocked.** `[!]` means "important" in every Obsidian theme
   collection; `[h]` is free everywhere and carries the ON_HOLD connotation. `[!]` left
   alone with its conventional meaning.
2. **The namespace is an argument, never inferred.** Rejected, with reasons recorded:
   - *Infer from prefix* — breaks bare numerics.
   - *Infer from target folder* — would make folder names **globally unique across
     namespaces forever**, enforced by nothing. Gary: *"If we added a 'cancelled' state to
     one, then we forever could not also have a cancelled state in the other."* Decisive,
     since `accept/` and `cancelled/` are landing now.
   - *Resolve by lookup* — Gary: *"a lot of churn in a deterministic command that still
     might not return an accurate result."*
   - *Default bare numerics to kanban* — matched actual usage but asymmetric. Gary: *"I
     don't like having to remember kanban moves work one way but an operations move works
     another."*
3. **Two commands, one script, policy table at the top.** Gary's reasoning: independent,
   so a change to one cannot bug the other; more control; less internal churn deciding
   what to do; each board free to grow. This *confirms* ADR-009's "table entry, not a
   second engine" note — what was wrong was inferring the namespace, not the one-engine
   design.
4. **Resolution prompting stays.** Gary: *"it should behave like kanban. If we are missing
   info, then prompt for it."*
5. **BUG-215 reworked, not closed.** The batch loop is real tested work that survives the
   namespace decision, and the card's evidence is the research the decision rests on.
6. **The built-plugin criterion reverted `[/]` → `[ ]`.** The done-gate counts only `[ ]`
   today, so `[ ]` is both true *and* enforced. Making `[/]` blocking is TECH-177's work.

---

## Corrections to the AI

Recorded because they are the substance of the day, not asides.

- **Scope drift.** The AI turned a regression card into a design session on resolution
  semantics and presented a parity fix as a feature.
- **A distinction that did not hold.** The AI proposed splitting "parity fix" from
  "namespace question" as separate work. Gary: *"They sound like the same issue to me."*
  Correct — the batch loop only means something once the namespace is known, so it was one
  card finished early, not two cards.
- **Verbosity.** Gary: *"Your answers are sometimes so verbose."*
- **A false claim about `[/]`.** The AI implied marking a criterion `[/]` was an
  accomplishment. It is not — `[/]` is never complete, and the gate cannot even read it
  yet.
- **"No card owns the new kanban structure."** Overstated: the *structure* was authored in
  Gary's diagram. What is true is narrower — no card has built the kanban policy row, and
  `/fw-init` (named in ADR-009 D5) does not exist.
- **framework-uat did not have the board.** The AI checked before building on the
  assumption; it has `operations/` and four workspaces, no board folders at any depth.

---

## Files Modified

- `workspaces/framework/scripts/fw-move.sh` — namespace argument, policy table, prefix
  guess removed
- `workspaces/framework/CHANGELOG.md` — the namespace change and the rename
- `workspaces/framework/templates/queues/operations/README.md`,
  `workspaces/framework/tests/UAT-COMMANDS.md` — `/fw-move` → `/fw-move-ops`
- `project-hub/work/doing/BUG-215-*.md` — rescoped; N1–N13 evidence; criteria split
- `project-hub/work/todo/TECH-177-*.md` — `[h]`, with the convention evidence
- `project-hub/work/backlog/FEAT-221*.md` — marker swap
- `project-hub/work/todo/TASK-219-*.md` — Group 2a answered by the structure diagram
- `project-hub/docs/diagram-index.md` — structure diagram row (export pending)

## Files Moved

- `workspaces/framework/commands/fw-move.md` → `workspaces/framework/commands/fw-move-ops.md`

---

## Current State

### In doing/
- **BUG-215** — batch half and namespace half both implemented and tested. Two criteria
  remain: the kanban command (belongs to crossover work, deliberately deferred) and
  built-plugin verification (needs a publish step; Gary is interactive again and offered
  to run UAT).

### In todo/
- 16 items. **TECH-177** is the natural next card — the `[h]`/`[?]` gate behaviour is now
  specified but not implemented, and the done-gate still counts only `[ ]`.

### In done/ (awaiting release)
- 8 items, unchanged today.

### Next step

Either finish BUG-215 (UAT + built-plugin verification) or start TECH-177. They are
independent: TECH-177 changes the *old* engine's gate, BUG-215 the *new* engine's move
logic.

Still open and worth not losing: where the 27 `deprecated/` cards live (the diagram has no
`archive/` under `kanban/`), FEAT-030's hold state (absent from the diagram), and
`templates/` which the diagram itself marks "alt idea". The structure diagram export is
still pending — the index row says so.

---

**Last Updated:** 2026-09-08

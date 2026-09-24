# Feature: The `accept/` and `cancelled/` States, and Terminal Archival

**ID:** FEAT-229.3
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-09-22
**Workspace:** framework
**Depends On:** FEAT-229.2 (the gates) — TASK-242 SETTLED 2026-09-23, see below

<!-- Retargeted 2026-09-22: was TASK-223. Group 2a split out of that card into TASK-242
     precisely because it was the only part blocking this one. TASK-223 keeps its other
     eleven conventions and blocks nothing here. -->
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

Add the two deferred folders — `accept/` and `cancelled/` — to the kanban transition matrix,
with their terminal semantics and spike archival. **Deliberately split off so FEAT-229.1 and .2
run straight through** (Gary, 2026-09-22).

> **On this card's folder:** it sits in `todo/` with its parent and siblings because a dotted
> id moves with the parent and the family counts as one WIP item (TASK-219 Group 1). Its
> `Depends On: TASK-223` is what records that it cannot start — not its folder.

## Why This Is Separate

**Both folders are already in `kanban_FOLDERS`; neither has settled semantics.** The engine
declares:

```bash
kanban_FOLDERS="backlog blocked todo doing accept done cancelled"
kanban_TERMINAL="done cancelled"
```

**`kanban_TERMINAL` presumes an answer TASK-223 has not given.** Its Group 2a open questions
are explicit: *transitions into `cancelled/`, whether it is terminal, a board closure code,
where the 27 `deprecated/` cards live* — and `accept/`'s relationship to `done/` and to
FEAT-030's hold state.

**TASK-223 requires these to be decided as a set** (line 198: *"The terminal/parked-state set
is decided as a set (Group 2a) — `accept/`, `cancelled/`, and FEAT-030's hold"*). Three folder
questions arrived within one week; answering one alone produces the fourth uncoordinated answer.

**So the dependency is real and this card waits.** FEAT-229.1 and .2 do not — that is the whole
point of the split. The two folders stay declared and simply get no transitions until this card
runs.

## Scope

1. **Transitions into and out of `accept/`** — the state between `doing` and `done`, per
   TASK-223's decision.
2. **Transitions into `cancelled/`**, and whether it is genuinely terminal.
3. **`kanban_TERMINAL` corrected** to match what TASK-223 settles, rather than presuming it.
4. **Terminal-state archival** — a spike moved to a terminal state archives to
   `history/spikes/`; a POC spike archives as a **folder**; neither produces a release
   (`kanban§2`, TECH-228).
5. **The board closure code**, if TASK-223 decides there is one (the operations namespace has
   `CODES`; the board may or may not want an equivalent).

## Out of Scope

- **Deciding the semantics.** TASK-223 does that; this card *encodes* the decision. If it turns
  out TASK-223 settles them and this card is trivial, that is the correct outcome — the
  encoding is still a mechanism that has to exist.
- **FEAT-030's `hold/` folder** — part of TASK-223's set, but a `project-hub/work/` folder
  question, not a kanban-engine one. It may or may not produce work here.
- **The cutover.**

## Acceptance Criteria

- [x] `accept/` has transitions in and out, matching TASK-223's decision
- [x] `cancelled/` has transitions in, and its terminal status matches the decision rather than
      the current presumption
- [x] `kanban_TERMINAL` is correct and traces to TASK-223, not to an assumption
- [x] A spike moved to a terminal state archives to `history/spikes/`; a POC spike archives as
      a folder; neither produces a release
- [x] No transition is added that TASK-223 did not settle — an unsettled pair stays illegal
- [x] Validated: **AI** — every new pair exercised against a seeded fixture (see the run below)
      · **Human** — a card through `doing → accept → done` and a card to `cancelled/`, against
      the **installed plugin** (TECH-188) — **pending one publish cycle**, shared with
      FEAT-229.1/.2/.4's identical criterion

## Related

- **FEAT-229** — parent · **FEAT-229.2** — the gates these transitions pass through.
- **TASK-223** — **Group 2a, the blocker.** Decides `accept/`, `cancelled/` and FEAT-030's hold
  **as a set**.
- **FEAT-030** — the `hold/` folder, open since 2026-01-08; the third member of that set.
- **FEAT-221 / FEAT-221.1** — `accept/` is *their* blocker too, via TASK-223. This card does
  not unblock them; TASK-223 does.
- **TECH-228** — the SPIKE template, which affects what archival resolves for one type.

---

## The Decisions to Encode — TASK-242, 2026-09-23

**TASK-242 is settled (9/9).** This card now has a complete specification and no open questions.
Encode it; do not re-decide it.

### The transition set

```
backlog:todo      todo:backlog
todo:doing        doing:todo
doing:accept      accept:doing      accept:done
backlog:blocked   todo:blocked      doing:blocked
backlog:hold      todo:hold         doing:hold
blocked:backlog   blocked:todo      blocked:doing
hold:backlog      hold:todo         hold:doing
backlog:cancelled todo:cancelled    doing:cancelled
```

**Terminal:** `done cancelled`.

### ⚠️ `doing:done` is REMOVED — a change to what FEAT-229.1 shipped

FEAT-229.1 wired `doing:done` before `accept/` was decided. **`accept/` is now the only route to
`done/`**, which is what makes the state mean anything: a card cannot reach `done` without passing
through the user's acceptance.

**This is a deliberate reversal, not an oversight.** Verify it is gone from `kanban_TRANSITIONS`.

### `accept/` has exactly two exits — and this is the load-bearing decision

`accept → doing` (refine) and `accept → done` (close). **Nothing else.**

> **Why, in Gary's words (2026-09-23):** *"We have implemented something and it's in the repo.
> We've determined it needs more work… Leaving buggy code while we work on something else would be
> a bad idea."*

**A card in `accept/` has merged code.** `accept → todo` puts it behind unstarted work;
`→ backlog` files it as an unranked idea; `→ hold`/`→ blocked` parks it indefinitely. All three
strand known-imperfect code with nothing scheduled to finish it.

**Do not add a convenience exit here later without re-reading that argument.** It is the one
transition rule in the set whose absence will feel wrong in the moment and be right anyway.

### `hold/` is new to this card's scope

TASK-242 adopted **both** `blocked/` and `hold/` (rejecting a combined `park/` on the grounds that
newcomers — including a fresh AI session — understand the conventional words without a lookup).

- **blocked** — cannot proceed due to an external issue
- **hold** — a decision to prioritise another card

**`hold/` must be added to `kanban_FOLDERS`** — it is not there today, and it is not in the
scaffold (`templates/queues/kanban/`). Both need it.

**No `blocked:hold` or `hold:blocked`.** A changed cause goes via a real state; parked folders are
not a shuffling ground.

### `done → cancelled` is invalid, and there is no `archive/` transition

Cancelling completed work contradicts the definition of done (Gary). The old matrix's
`done → archive` *"rare, retroactive"* was **a hole, not a practice** — verified 2026-09-23: the
six completed cards in `project-hub/work/archive/` carry no cancellation fields and appear in no
release. They were *stored*, not cancelled. `history/archive/` owns storage; `cancelled/` owns the
outcome.

### No closure code

Free-text `Cancellation Reason:` stays. Ops' code set lives in a `Resolution:` field **because ops
has no `cancelled/` folder**; the board gets the folder instead. Revisit only when FEAT-196 needs
it (TASK-242 decision 4).

---

## Validation Run — 2026-09-23

Scratch repos, `--root`, fixtures from the generalized seeder.

### The `accept/` path and its two exits

| Case | Expect | Result |
|---|---|---|
| `doing → accept` | move | ✅ |
| `accept → done` | move | ✅ |
| **`doing → done` direct** | **refuse** | ✅ — `accept/` is now the only route |
| `accept → todo` · `→ backlog` · `→ hold` · `→ blocked` · `→ cancelled` | **refuse, all five** | ✅ |
| `accept → doing` (refine) | move | ✅ |

**The acceptance gate moved with the route.** `accept → done` with a `[/]` criterion is
**blocked** ✅ — so the gate now sits where the card actually completes, not where it leaves
`doing/`. *(FEAT-221.1 anticipated this and wanted the gate on `doing → accept`; the gate is
namespace-wide on `→ done`, so it lands correctly without a change.)*

### `hold/`

| Case | Result |
|---|---|
| `backlog → hold` · `todo → hold` · `doing → hold` | ✅ all move |
| `hold → backlog` · `→ todo` · `→ doing` | ✅ all move |
| **`hold → blocked`** | ✅ **refused** — a changed cause goes via a real state |

### `cancelled/` and terminals

| Case | Result |
|---|---|
| `backlog → cancelled` · `todo →` · `doing →` | ✅ move |
| `cancelled → todo` | ✅ refused — *"in cancelled/, which is terminal"* |
| **`done → cancelled`** | ✅ refused — terminal guard fires first, with the clearer message |
| `done → doing` · `done → todo` | ✅ refused |
| `hold → cancelled` | ✅ refused — abandoning goes via a pre-terminal state |

> **A faulty test, recorded because the pattern repeats.** `done → cancelled` first read as a
> FAIL. The fixture was in `doing/`, not `done/` — so `doing:cancelled` correctly applied and the
> move succeeded. **The engine was right; the test asserted the wrong precondition.** Same lesson
> as FEAT-229.4's placeholder case: a test result that contradicts the design deserves suspicion
> of the test first.

### Spike archival (scope item 4)

| Case | Result |
|---|---|
| **Research spike** `SPIKE-001 → done` | ✅ `history/spikes/SPIKE-001-research-question.md` |
| **POC spike** `SPIKE-002 → cancelled` (with a bundle) | ✅ `history/spikes/SPIKE-002/` holding **both** the record and `run.sh` |
| Board after both | ✅ empty of spikes — neither left a card behind |
| Neither entered `release/` | ✅ — spikes produce knowledge, not a shippable change |

**The bundle is the type test.** A research spike is a document; a POC spike is a document plus
code in its bundle (TECH-228's split). So no `Type:` flag is needed — **if a bundle travelled, the
archive gets a folder; if not, a file.**

**Implemented as a redirect after the move, deliberately.** Making `history/spikes` a pseudo-target
would put a non-folder in the policy table and force a special case into the transition matrix, the
gates and the family carry. The record lands in `done/` or `cancelled/` like any card, then leaves
the board.

### No regressions

**Gate suite re-run through the accept path — 7/7:** `[-]` passes ✅ · quoted marker passes
(TECH-166) ✅ · `[?]` and `[h]` block `→ doing` ✅ · `backlog:doing` refused ✅.

**Operations — 5 cases plus sweep, all pass**, and **no `history/spikes/` is created for
operations** ✅ (the archival is guarded on `$NS = kanban`).

**Dotted families still intact** — `FEAT-9011` / `FEAT-9011.1` created and addressable.

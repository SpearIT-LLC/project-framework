# Task: Decide the Terminal and Parked-State Set, as a Set

**ID:** TASK-242
**Type:** Task
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-09-22
**Workspace:** framework
**Parent:** TASK-223
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->
**Theme:** Framework Consistency

---

## Summary

Settle the board's terminal and parked states **as one model**: `accept/`, `cancelled/`, and
FEAT-030's hold state. Split out of **TASK-223 Group 2a** on 2026-09-22 because it is the only
part of that card blocking real work — **FEAT-229.3** and **FEAT-221** both wait on it, and
TASK-223's other eleven conventions block nothing.

**Most of it is already answered.** Three genuine decisions remain.

## Why Split

**The same reason TASK-223 was split from TASK-219** — and TASK-223 records the lesson itself:

> *"a card owning nineteen decisions under one acceptance block cannot be closed until the least
> urgent one is done."*

TASK-223 carries fourteen conventions across four groups; its acceptance block requires **all**
of them plus closing every source card. Group 2a is a single afternoon's decisions with two cards
waiting on it. Leaving them in the same card means FEAT-229.3 waits on an external-reference
template and a meeting-record standard.

**Group 2a stays out of TASK-223 entirely** — that card keeps Groups 2 (less 2a), 3, 4 and 5.

## Already Settled — ratification, not decisions

**The authored repo-structure diagram** (Gary's Lucid page, indexed in
[diagram-index.md](../../docs/diagram-index.md)) is an **authored design, not a proposal**:

```
kanban/  backlog  blocked  todo  doing  accept  done  cancelled
```

| Question | Answer |
|---|---|
| Does `accept/` exist? | **Yes** — first-class, between `doing` and `done`, as `fw-implement-todo` requires |
| Does `cancelled/` exist? | **Yes** — first-class, confirming cancellation is a lifecycle status, not a storage location |
| Is `archive/` under `kanban/`? | **No.** With `cancelled/` first-class, `history/archive/` is the storage home |

**And the folders already exist in the scaffold** (`templates/queues/kanban/`, built under
TASK-219) and in the engine's `kanban_FOLDERS`. Nothing needs creating — only wiring.

## The Genuine Decisions

### 1. Which transitions reach `cancelled/`, and is it terminal?

Cancellation is available from every pre-terminal state today (`backlog`/`todo`/`doing` →
`archive`, plus `done → archive` as *"rare, retroactive"*). TASK-223 says `cancelled` is
**"presumably terminal"** like `done` — presumption is not a decision.

**Note the engine already presumes an answer:** `kanban_TERMINAL="done cancelled"`. That was
carried from the diagram, not decided here. Either ratify it or change it.

### 2. Which transitions reach `accept/`, and what leaves it?

`doing → accept → done` is the happy path. **What happens on rejection** — back to `doing`, or
to `todo`? — is not settled, and it is the transition that gives the state its purpose.

### 3. FEAT-030's hold state: dropped, or covered by `blocked/`?

**The one question the diagram does not answer at all.** No hold folder appears under `kanban/`.
Three possibilities, per TASK-223: the state is dropped for the board, `blocked/` covers it, or
the diagram predates the question.

**FEAT-030 has been open since 2026-01-08.** Whatever is decided, that card closes.

### 4. Does the board gain a closure code? (additive, low risk)

Operations has `CODES="resolved cancelled duplicate no-fault-found rejected"`. The board carries
free-text `Cancellation Reason:` only. TASK-223: **"additive — no structural risk either way"**,
and reporting (FEAT-196) would want it.

## Why the Ops Model Does Not Simply Port

Recorded so it is not re-argued. Operations has no `cancelled/` folder because FEAT-193 ruled
location = *flow* state and outcome = a `Resolution:` field. Quoting FEAT-193:

> *The kanban's separate `archive/` exists only because `done/` feeds a release sweep that
> cancelled items must not enter; ops `closed/` has no such fork.*

**The board has a downstream consumer; operations does not.** A cancelled card sitting in `done/`
behind a field ships in a release archive the moment one consumer forgets to filter. The folder
does protective work a field cannot — so *"make the board work like ops"* is the option to
**reject**, not the default.

## Out of Scope

- **Where the 27 `deprecated/` cards live.** Verified 2026-09-22: 8 loose + 27 deprecated in
  `project-hub/work/archive/`. They are neither cancelled nor released, and they are a
  **storage** question that blocks nothing. **Stays on TASK-223.**
- **`templates/` under `kanban/`** — marked *"alt idea"* in the diagram, explicitly unsettled by
  its author. Stays on TASK-223.
- **Implementing the transitions.** **FEAT-229.3** does that; this card is the decision it
  encodes. Same split as TECH-177 → FEAT-229.2.
- **The year-bucket sweep for `archive/`** — a grouping action that changes no status. Any time.
- **TASK-223's other eleven conventions.**

## Acceptance Criteria

- [ ] `accept/`'s transitions are decided, **including what leaves it on rejection**
- [ ] `cancelled/`'s transitions are decided, and whether `done → cancelled` is permitted
- [ ] `cancelled`'s terminal status is **decided, not presumed** — `kanban_TERMINAL` either
      ratified with the reason recorded, or changed
- [ ] FEAT-030's hold state is resolved: dropped, covered by `blocked/`, or given a folder —
      **with the reason written down**, and **FEAT-030 closed either way**
- [ ] The closure-code question is answered yes or no (additive; either is acceptable)
- [ ] `archive/`'s meaning is restated once, now that `cancelled/` is first-class
- [ ] **ID safety:** every folder involved lives under the board root, so both id scanners see
      it recursively. A sibling root would be invisible to one and risk id reissue
- [ ] The decisions are recorded where **FEAT-229.3 can implement them without re-deciding** —
      one authored place, pointed at, not restated (ADR-008)
- [ ] Validated: **Human** — the model answers *"where does a card go when it is finished but
      unaccepted / abandoned / waiting on something"* without a follow-up question

## Related

- **TASK-223** — the parent. Group 2a is split out here; its other eleven conventions stay
  there. Its Group 2a section holds the full source analysis.
- **FEAT-229.3** — **implements this.** Blocked until this card lands; its `Depends On:` names
  TASK-223 today and should be retargeted here.
- **FEAT-221** / **FEAT-221.1** — blocked on `accept/` via TASK-223. **This card unblocks them**,
  and their `Depends On:` should be retargeted here too.
- **FEAT-030** — the hold state, open since 2026-01-08. Closes with decision 3.
- **FEAT-193** — the ops `Resolution:` ruling, and the asymmetry that keeps the two namespaces
  different.
- **FEAT-196** — reporting, which would consume a closure code.
- **The repo-structure diagram** — the authored design that settles which folders exist.

# Task: Decide the Terminal and Parked-State Set, as a Set

**ID:** TASK-242
**Type:** Task
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-09-22
**Workspace:** framework
**Parent:** TASK-223
**Completed:** 2026-09-23
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

- [x] `accept/`'s transitions are decided, **including what leaves it on rejection**
- [x] `cancelled/`'s transitions are decided, and whether `done → cancelled` is permitted
- [x] `cancelled`'s terminal status is **decided, not presumed** — `kanban_TERMINAL` either
      ratified with the reason recorded, or changed
- [x] FEAT-030's hold state is resolved: dropped, covered by `blocked/`, or given a folder —
      **with the reason written down**, and **FEAT-030 closed either way**
- [x] The closure-code question is answered yes or no (additive; either is acceptable)
- [x] `archive/`'s meaning is restated once, now that `cancelled/` is first-class
- [x] **ID safety:** every folder involved lives under the board root, so both id scanners see
      it recursively. A sibling root would be invisible to one and risk id reissue
- [x] The decisions are recorded where **FEAT-229.3 can implement them without re-deciding** —
      one authored place, pointed at, not restated (ADR-008)
- [x] Validated: **Human** — the model answers *"where does a card go when it is finished but
      unaccepted / abandoned / waiting on something"* without a follow-up question

      > **Answered 2026-09-23**, one folder each with no overlap:
      > **finished but unaccepted** → `accept/` · **abandoned** → `cancelled/` (terminal) ·
      > **waiting on something external** → `blocked/` · **paused to do other work** → `hold/`
      > · **finished and put away** → `history/archive/`.
      >
      > The question that used to have no answer — *"implemented, needs more work, but I am
      > working on something else"* — now has one, and it is deliberately uncomfortable: it
      > stays in `accept/` or goes back to `doing/`. **Merged code does not get parked**
      > (decision 1).

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

---

## DECISIONS — 2026-09-23

Settled with Gary. **This card decides; FEAT-229.3 encodes.**

### 1. `accept/` has exactly two exits: `doing` and `done`

```
doing → accept → done
          ↓
        doing   (refine)
```

**`accept → todo`, `→ backlog`, `→ blocked`, `→ hold`, `→ cancelled` are all invalid.**

**The reason is the strongest argument in the discussion** (Gary, 2026-09-23):

> *"We have implemented something and it's in the repo. We've determined it needs more work (or
> else it would have gone straight to done). Leaving buggy code while we work on something else
> would be a bad idea. SO... I'm thinking it should only go to doing or done now."*

**A card in `accept/` has code merged.** Every other exit strands known-imperfect code in the repo
with nothing scheduled to finish it — `todo` puts it behind unstarted work, `backlog` files it as
an unranked idea, `hold`/`blocked` park it indefinitely. **The queue inefficiency of "go back to
doing" is far cheaper than merged code nobody is finishing.**

This makes `accept/` **different in kind from every other folder**: it is the only one where *not
moving forward* means *go back and finish*, never *wait*.

**`accept → cancelled` is not a transition.** UAT can reveal work that should not ship — but that
is *revert the code, then cancel*, a distinct action, not a folder move.

**The authored diagram already agreed:** FEAT-221.2's flow shows exactly two exits — *Refine*
(`accept → doing`) and *Close* (`accept → done`). The decision ratifies it rather than inventing it.

### 2. `cancelled` is terminal · `done → cancelled` is invalid

**Terminal, ratified** — `kanban_TERMINAL="done cancelled"` stands, now decided rather than
presumed. Reached from `backlog`, `todo`, `doing`; **not** from `accept` (see above) or `done`.

**`done → cancelled` is invalid** (Gary): *"done → cancelled would violate the definition of
done."* Cancelling completed work is a contradiction, not a rare case.

**And the old matrix's `done → archive` "rare, retroactive" was a hole, not a practice** —
verified 2026-09-23. Six completed cards sit in `project-hub/work/archive/`:

| Card | `Status:` | Cancelled fields? | In a release? |
|---|---|---|---|
| CHORE-132 | `Done` | none | no |
| DOCS-133 | `Done` | none | no |
| CHORE-131 | `Backlog` (stale) | none | no |

**None carries `Cancelled Date:` or `Cancellation Reason:`; none appears in
`history/releases/`.** They are *completed work put away* — storage, not cancellation. The
transition existed because `archive/` was doing double duty. **With `cancelled/` first-class and
`history/archive/` owning storage, the hole closes without a transition.**

### 3. `blocked/` AND `hold/` — both, with Gary's definitions

> **blocked** — cannot proceed due to some external issue
> **hold** — a decision to prioritise another card

**A combined `park/` was proposed and rejected.** It is more concise, and for a folder off the
happy path concision has real appeal. **Conventional terminology won** (Gary, 2026-09-23):

> *"Newcomers (including yourself in a new session) will intuitively understand blocked and hold
> more than park."*

That is decisive for a framework whose every session starts as a newcomer
(`workspaces/framework/CLAUDE.md`). `park/` needs a lookup; `blocked/` and `hold/` do not.

**Consequences:**

- **FEAT-221's parked cards go to `blocked/`** — a card parked on an unanswered question is
  blocked on something outside itself (the answer), not a prioritisation decision.
- **`Blocked By:` / `External Reference:` become optional**, used when the external party is
  nameable. They were written assuming a third party; FEAT-221's case fills them differently.
  TECH-177's `[?]`/`[h]` markers carry the line-level *why* in every case.
- **FEAT-030 closes as implemented** — it asked for `hold/` and gets `hold/`, definition sharpened
  and the *"not for items blocked on other work items"* line now expressed by a sibling folder.

### 4. No board closure code — free-text `Cancellation Reason:` stays

Considered: ops' `resolved | cancelled | duplicate | no-fault-found | rejected`, so FEAT-196 could
report *"we decided not to"* vs *"superseded"*.

**Rejected for now** (Gary): *"we haven't had them before and I don't think we missed them."*

**And there is a structural reason the ops set does not transfer:** ops codes live in a
`Resolution:` field **because ops has no `cancelled/` folder** — the field *is* the outcome. The
board is getting the folder instead, so `cancelled/` already encodes the distinction that matters.
Everything finer is reporting, and **no report consumes it yet**.

**Additive with no structural risk** (TASK-223's own words), which cuts both ways: add it the day
FEAT-196 needs it. **Recorded so it is not re-derived.**

### 5. `archive/` restated

**`history/archive/` is storage: put away, not a lifecycle outcome.** No `archive/` under the
board. A cancelled card goes to `cancelled/`; a completed card put away goes to storage; the two
are no longer the same folder.

---

## The Resulting Transition Set (for FEAT-229.3)

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

**`doing:done` is removed** — `accept/` is now the only route to `done/`, which is what makes the
state mean anything. *(FEAT-229.1 shipped `doing:done` before `accept/` was decided; FEAT-229.3
replaces it.)*

**Terminal:** `done cancelled`.

**Not present, each deliberately:** `backlog:doing` (commit first) · `done:*` (not reopened) ·
`accept:*` beyond the two · `blocked:hold` / `hold:blocked` (the cause changed — go via a real
state, do not shuffle between parked folders) · anything into `accept` but `doing`.

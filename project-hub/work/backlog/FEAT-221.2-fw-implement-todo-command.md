# Feature: The `/fw-implement-todo` Command

**ID:** FEAT-221.2
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-09-07
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->
**Theme:** Workflow

**Depends On:** FEAT-221.3 (the ADR-001 amendment authorises this), FEAT-221.1, TASK-219,
TECH-177 (the `[?]`/`[h]` markers and their gate behaviour)

---

## Summary

The command itself: review the whole batch once, then implement every card in `todo/`
serially and unattended, landing each in `accept/`.

---

## Usage (from the source diagram)

```
/fw-implement-todo [review] [--wait <duration>]
```

- **no argument** — full run. Always performs the batch review first.
- **`review`** — review only. Resolve all questions, confirm the plan, stop. Does not
  implement.
- **`--wait <duration>`** — how long to wait for a reply before parking a tripped card.
  Default `60s` (a starting value, expected to rise with real use). `--wait 0` means
  never ask, park immediately. See parent for naming rationale and the
  `askUserQuestionTimeout` reconciliation note.

**Same-session prompt:** if a review already ran this session, prompt rather than
silently re-reviewing — *"This gives the user an opportunity to pass if it has already
been done"* (diagram header). The prompt is the point; do not auto-skip.

---

## The Flow

From the diagram, second swimlane:

```
Start → Select cards → Invoke command → Review → Implement → UAT? ─Yes→ Close → Stop
                                                     ↑         └─No→ Refine ─┘
```

| Step | Actor | Notes |
|---|---|---|
| Select cards, move to `todo/` | User | Pre-existing; not part of this command |
| Invoke command | User | |
| Review | AI | **Gate: all cards well defined, no open questions, conflicts and dependencies resolved** |
| Implement | AI | Unattended, one card at a time |
| UAT (accept?) | User | Cards sit in `accept/` |
| Refine | AI | `accept → doing`, loops back to Implement |
| Close | AI | `accept → done` |

---

## The Review Gate

The review is a batch-wide pre-implementation review and is the **only** human
checkpoint in a clean run. It must, per the diagram sticky, confirm for every card:

- The card is well defined with **no open questions** (TODO, TBD, DECIDE, Option A/B/C)
- **Conflicts between cards are resolved** — two cards editing the same file in
  incompatible ways is a batch-level problem invisible to a per-card review
- **Dependencies are resolved** and correctly ordered within the batch

A card failing the gate does not enter the run. Report it and continue with the rest;
do not block the batch on one unripe card.

**Cross-card conflict detection is the genuinely new analysis here** — the existing
per-card review has never had to consider siblings. The diagram sticky calls this out
explicitly: *"A file change in the middle of an implementation could have downstream
affects on other cards."*

---

## Batch Membership

**The roster is fixed at the review gate.** `todo/` is read once, before implementation
starts, and not re-scanned between cards. A card added to `todo/` mid-run — including
one a second session answers and returns — is picked up by the **next** invocation, not
this one. Rationale in the parent (*Batch Membership*): a mid-run addition would be
unreviewed work, which is the ADR-001 harm the batch checkpoint exists to prevent.

**Guard before each card:** re-verify the card is still in `todo/` immediately before
`todo → doing`. Another session may have moved it (there is no lock — see parent,
*Concurrent Sessions*). If it moved: skip, note it in the report, continue. Never fail
the run over it.

**This guard is about roster staleness, not concurrency.** It keeps the run from
crashing on a vanished file. It does **not** make concurrent batch runs safe — nothing
here does. Do not present it as if it did.

**Optional advisory marker:** a start-time marker file lets a second invocation warn
*"a batch appears to be running — continue?"* If implemented: advisory only, never
called a lock, and it must not block a run whose predecessor crashed holding it. Real
locking is TECH-049.

---

## Serial Execution

One card in `doing/` at a time — *"Each item is implemented one at a time like a queue"*
(diagram sticky). Per card: `todo → doing`, implement, `doing → accept`.

**WIP limits are honoured unchanged — no batch-specific rule.** Serial execution is a
*separate, stricter* constraint layered on top:

- The WIP limit is a **ceiling** the batch respects, exactly as interactive use does.
- Serial is a **floor**: one card at a time **even when the limit leaves room**. With
  `doing/.limit` of 4 and an empty `doing/`, the batch still runs one card, not four.

**Serial is a correctness requirement, not politeness.** Concurrent implementations
compete for the same resources, and worse: one thread reads a file and forms a plan
while another thread changes that same file, leaving the first implementing against a
foundation that no longer exists. The diagram sticky: *"to prevent collisions between
threads and so that each implementation is working from the same foundation."*

**Do not parallelise this, and do not treat it as a performance defect.** It is an
explicit first-iteration safeguard. Widening it requires a real answer to read-plan-write
interleaving across cards — not a benchmark.

**Scope of the guarantee: within a run only.** One loop controls the sequence, so serial
holds for that loop. It does **not** survive two batch runs at once — see parent,
*Serial execution is an intra-run guarantee only*. Say this in the command's help text
rather than letting a reader infer a stronger promise.

---

## The Circuit-Breaker

Defined in the parent (FEAT-221). **The trigger is anything that blocks *complete*
implementation of the card** — not only a missing fact. A card the AI could finish
"mostly" is a card that trips: partial implementation is the failure mode this exists to
prevent, because a half-done card that lands in `accept/` looks finished.

On trip: **ask if a person can resolve it now; otherwise mark, note, and park.** Never
invent an answer, never implement around the gap, never halt the batch.

**Either marker may warrant an ask.** Gary, 2026-09-07: park applies *"if the user is
not able to answer/resolve the issue interactively during the run."* A watching user can
often clear a blocker on the spot — supply the missing information, unlock the file,
grant the approval. Ask, and park on no answer, regardless of which marker applies.

**Do not branch behaviour by marker type.** An earlier draft had `[h]` never asking, then
asking only for "technical" blockers. Both were over-specified: a marker's meaning does
not determine whether a person happens to be present to act on it. Gary, 2026-09-07:
*"just define what ? and ! mean and use them where they apply, when they apply."*

```
Anything blocking COMPLETE implementation of the card
              │
              ▼
   AskUserQuestion (--wait) ──resolved in time──► clear marker, continue card
              │
     no answer / no one there / headless
              │
              ▼
   mark the exact line — [?] need information * [h] something prevents completion
   + write the reason note
              │
              ▼
   doing → blocked ──► next card
```

**Mark the line, write the reason, then move** (TECH-177, markers promoted 2026-09-07).
Three steps, in order, before the card leaves `doing/`:

1. **Mark** the **exact** criterion, checklist step, or acceptance line that tripped.
2. **Note the reason** alongside it — what was attempted, what happened, what is needed
   to clear it. The marker says *where*; the note says *why*. A marker with no note
   forces the next session to re-derive the problem from scratch, which is the cost this
   whole mechanism exists to avoid.
3. **Move** `doing → blocked`.

A run that marks but does not note has done half the job. Treat the note as part of
writing the marker, not as a separate report step — the report is a pointer *to* this
note.

| Marker | Written when | Resolution is |
|---|---|---|

| Marker | Written when |
|---|---|
| `[?]` | More information is needed to complete the job |
| `[h]` | Something prevents completion — technical, procedural, resource, or another card this sub-task waits on |

> **`[h]`, not `[!]`** (settled 2026-09-07). `[!]` means *important* in all four Obsidian
> theme collections and imports into Tasks as an ordinary TODO — a blocking gate on it
> would fight the tool's own model. `[h]` is free in all four and is the symbol the Tasks
> docs use for `ON_HOLD`. Evidence and rejected candidates are recorded in TECH-177.

Definitions per TECH-177; apply them where they fit rather than matching a scenario list.
Note the level: `[h]` marks **one blocked sub-task**. When the *whole card* waits on
another card, that is `Depends On:`, which is already mechanized.

Both block `→ doing` on the next run, so a parked card cannot silently re-enter the queue
before the thing that stopped it is cleared. The marker is its own unblock condition — no
separate parked state.

**Why marking matters here specifically:** `blocked/` records *that* a card is stuck; it
cannot record *where*. Without the marker, the next run reads a 200-line card with no
cursor, and the answer the user gave lives only in a batch report nobody re-reads.

**Implementation notes:**

- **Ask first, park on no answer** — the same path for either marker. The marker records
  *what kind* of blocker it was; it does not gate whether asking was worth trying.
- The availability test **is** the `AskUserQuestion` timeout — do not build a separate
  presence probe. None exists (parent card documents what was ruled out).
- **Headless (`claude -p`) must skip stage 1.** With `--permission-prompts none` the
  tool is removed entirely; without it the prompt is denied rather than timed out.
  Detect the absence of the tool and park directly — do not attempt an ask that cannot
  succeed, and do not treat the denial as an answer.
- One tripped card must not raise the cost of the next: the timeout is per question.
  A run that trips on five cards should not stall five full timeouts if the first
  already showed no one is there. **Consider parking the remainder immediately after
  the first timeout** — decide at review.
- The parked card needs metadata `blocked/` does not currently have (see parent,
  *Blocked Metadata*; owned by TASK-219).
- **A parked card is not re-opened during the run** — see parent, *Unblocking*. Even if
  the user answers moments later, that card is finished for this run. Resuming it would
  break serial execution.

---

## Reply Ambiguity (design constraint on the report)

Because a parked card is never resumed mid-run, every reply the user gives during a run
belongs to the card currently in `doing/` — unambiguously, by construction. This is
*why* the no-resume rule exists (parent, *Unblocking*): it removes the ambiguity rather
than trying to resolve it.

**The report carries the consequence.** Answers to parked cards arrive after the run, so
the report must make each parked card actionable on its own:

- The card ID, stated explicitly
- Whether it needs an **answer** (`[?]`) or a **fix** (`[h]`) — grouped, not lumped
- The marked line, quoted, with a path and line reference so the user can jump to it
- Enough context to act without reconstructing the run

**The marker changes what the report has to be.** Earlier drafts of this card required
the report to restate every question in full, because nothing in the card marked the
spot. With `[?]`/`[h]` written inline, the report becomes a **pointer** — it says where
to look and why, and the card itself carries the detail. The answer then lands next to
the question, in the file the next run actually reads.

A report that says *"3 cards blocked, see blocked/"* still fails. So does one that
restates everything and leaves the cards unmarked.

---

## The Batch Report

The run is unattended, so the report is the entire user-facing output. It must state:

- Cards completed and now in `accept/`
- Cards parked, split by `[?]` (needs an answer) and `[h]` (needs a fix), each pointing
  at its marked line
- Cards that failed the review gate and never ran
- Anything discovered mid-run that affects a card not yet run
- Roster cards that vanished or moved mid-run (another session touched them)

---

## Acceptance Criteria

- [ ] `/fw-implement-todo` runs the batch review, then implements serially, unattended
- [ ] `/fw-implement-todo review` reviews and stops without implementing
- [ ] A same-session repeat run prompts rather than silently re-reviewing
- [ ] The review gate rejects cards with open questions, unresolved conflicts, or
      unmet dependencies — and the batch continues without them
- [ ] Cross-card file conflicts are detected at review time
- [ ] Exactly one card is in `doing/` at any moment — including when the WIP limit
      would permit more (verify with a limit raised above 1)
- [ ] Cards land in `accept/`
- [ ] **Anything** blocking complete implementation trips the breaker — not only a
      missing fact; a card is never partially implemented and passed on
- [ ] A parked trip is marked `[?]` or `[h]` per TECH-177's definitions
- [ ] A trip asks, and continues the run when resolved in time
- [ ] A resolved trip clears its marker and the card completes normally
- [ ] An unanswered `[?]` parks to `blocked/` and the run continues
- [ ] A headless run parks without attempting an ask it cannot make
- [ ] Every parked card carries its marker on the **exact line** that tripped, not only
      in a summary field
- [ ] Every parked card carries a **reason note** with the marker — what was attempted,
      what happened, what would clear it
- [ ] A card carrying an unresolved `[?]` or `[h]` is blocked from `→ doing`
- [ ] The batch report covers completed, parked, and rejected cards
- [ ] Each parked card in the report is answerable without opening the card file
- [ ] `--wait` is honoured, including `--wait 0`
- [ ] The roster is fixed at review; a card added to `todo/` mid-run is not picked up
- [ ] A roster card moved by another session is skipped and reported, not fatal
- [ ] Command help states the serial guarantee is intra-run and that concurrent batch
      runs void it
- [ ] If the advisory marker is implemented, a stale marker never blocks a legitimate run
- [ ] Plugin CHANGELOG updated

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->

- [ ] **PRE-IMPLEMENTATION REVIEW COMPLETED** — including the parked-card decision
- [ ] Batch review pass (incl. cross-card conflict detection)
- [ ] Serial implementation loop (fixed roster + pre-move existence check)
- [ ] Circuit-breaker: classify `[?]`/`[h]`, ask-with-timeout, headless detection,
      mark the line, write the reason note, park
- [ ] Batch report
- [ ] `review` and `--wait` arguments; same-session prompt
- [ ] Plugin CHANGELOG updated

---

## Related

- **FEAT-221** — parent (holds the ADR-001 conflict analysis and WIP reasoning)
- **FEAT-221.3** — the amendment that authorises this command
- **FEAT-221.1** — the gate that fires when this command moves a card to `accept/`
- **TECH-177** — the checkbox-state convention. Its 2026-09-07 promotion of `[?]`/`[h]`
  from deferred to specified was driven by this command; **blocks it**
- `project-hub/poc/fw-implement-todo/` — the source diagram

---

**Last Updated:** 2026-09-07

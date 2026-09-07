# Session History: 2026-09-07

**Date:** 2026-09-07
**Participants:** Gary Elliott, Claude Code
**Session Focus:** FEAT-221 — unattended batch implementation (`/fw-implement-todo`), drafted from a Lucid diagram; diagram-index filed

---

## Summary

Started as "do we have a doc with the Lucid published URL?" (we did not) and became a
full design session on **unattended batch implementation**. Filed
`project-hub/docs/diagram-index.md` to hold published diagram links, then drafted
FEAT-221 + three children from Gary's Lucid page *fw-implement-todo*. The design work
was mostly **finding and resolving conflicts with existing rules** — ADR-001's
per-card checkpoint, WIP limits, and the `blocked/` semantics — rather than inventing
new behaviour. Several of the AI's initial positions were corrected by Gary and the
corrections are the substance of the cards.

---

## The Journey (how the design arrived where it did)

The path mattered here; the final cards read as obvious but three positions were
reversed along the way.

### 1. The Lucid link had no home (and the first two homes were wrong)

Searched for an existing doc holding the published URL — none existed. Notably the
**Grep tool returned zero matches repo-wide on two attempts** while `git grep` found
the hit immediately; all searching this session used git as a result. Worth knowing if
it recurs.

Three placements were tried before one stuck:

- `project-hub/external-references/` — **rejected by its own README.** That folder's
  deletion test is for *authoritative, replaceable, third-party* sources (RFCs, specs).
  An authored working diagram is not re-findable and fails the test.
- `project-hub/research/` — written there first, then **moved on Gary's correction**:
  research is analysis; this is a master-framework asset.
- `project-hub/docs/` — final. Registered in `framework.yaml` `sources:` as
  `diagram-index`, back-linked from ADR-009's reference to the folder-structure
  mind-graph.

Gary also corrected a scope conflation: **TECH-220 (diagram standards) is generic
Mermaid guidance that derived projects inherit** — nothing to do with where the master
framework's own diagram sources live. The two do not overlap and the index says so.

### 2. The diagram's own open question answered itself

The Lucid page carried a sticky on `done/`: *"QUESTION: How to implement the UAT?
Maybe we need a 'review/' folder?"* The flow answers it — UAT sits *between* implement
and close, so a card that is implemented but unaccepted has nowhere to live. It cannot
stay in `doing/` (the batch must move on) and cannot go to `done/` (not accepted).

Adopted as **`accept/`**, not `review/` — the state is "awaiting acceptance," and
`review` collides with the pre-implementation review already in the vocabulary.

### 3. `accept/` turned out not to belong to this command at all

Initially scoped as an unattended-workflow need. Gary: *"doing --> accept is proposed
for unattended workflow although COULD be used if I'm waiting on someone outside the
team to check some work."*

That reframing matters — it makes `accept/` a **general board state** answering a real
solo-dev situation (waiting on a client, a colleague, a compliance check) that has no
folder today. It therefore earns its keep independently of `/fw-implement-todo`, which
is a much easier case to make against ADR-001's simplicity bar. Filed to **TASK-219
Group 2** (board lifecycle policy) rather than to the command card.

### 4. The WIP sticky was reversed (AI position was wrong)

The diagram sticky read *"one at a time regardless of the WIP limit."* The AI first
wrote this up as *"no exemption needed — a serial queue never exceeds the limit
anyway."* Gary corrected the intent:

> *"I was trying to emphasize serial implementation even if there is room in the WIP
> limits. i.e. WIP limit = 4 with no cards in doing. Batch implementation is still one
> at a time even though WIP limits says we could go 4 wide."*

The corrected framing — **ceiling vs. floor** — is materially stronger. WIP limit is a
ceiling, honoured unchanged, *no batch-specific rule*. Serial is an independent floor
that binds even when the limit leaves room. The AI's version made serial a *side-effect*
of the limit, which would have let a future reader optimise it away on observing there
was headroom.

The real reason was also recorded: not just resource contention but **read-plan-write
interleaving** — one thread reads a file and forms a plan while another changes that
same file, leaving the first implementing against a foundation that no longer exists.

### 5. The safeguard is not a checkpoint (the distinction that unlocked ADR-001)

The AI initially flagged "unattended" and "stop and prompt when something unplanned
surfaces" as contradictory. Gary's framing dissolved it:

> *"My thoughts on the unattended prompt was a safe-guard for the unexpected. Don't
> plow through the card and make up answers we don't have facts for. The happy path is
> the review catches all the questions and we're able to implement end to end with no
> issues."*

Two different mechanisms, deliberately not conflated:

| | Checkpoint (ADR-001) | Circuit-breaker |
|---|---|---|
| Asks | "May I proceed?" | "I hit a fact I do not have" |
| When | Once, up front, per batch | Exception path, mid-card |
| Batched? | Yes | No — never |

The circuit-breaker is **not new policy** — it is the existing Epistemic Standard
(*"never silently fall back to guessing"*) applied to unattended mode.

### 6. Availability detection already exists — do not build one

Gary asked for *"either a time limit or some kind of test you can run to know if I'm
available."* Verified against the Claude Code docs rather than designed:

**`AskUserQuestion` + `askUserQuestionTimeout`.** On elapse the dialog auto-closes and
tells the AI the user may be away from keyboard. **The timeout IS the availability
test** — present = answers in time, away = timeout fires.

Confirmed as *not existing*, recorded so nobody re-derives it: no env var for
interactive-vs-headless, no hook field for session type, no presence-detecting hook
(`Notification` means *Claude is waiting*, not *someone is watching*), no timeout on any
other prompt.

Headless (`claude -p`) is a distinct case: with `--permission-prompts none` the ask tool
is *removed*; without it a prompt is *denied*, not timed out. Either way, skip the ask
and park.

### 7. 60s was accepted only as a starting value

Gary: *"60s is a very short time when a user is not expecting to be prompted."* Correct
— the prompt is unexpected by construction. Became a command argument.

Named **`--wait`**. Gary's candidates `TimeToBlocked` / `TimeToPark` name the failure
rather than the behaviour; `WaitForPrompt` is backwards (it is the *reply* being waited
on). `--wait 0` added = never ask, park immediately.

### 8. Two-thread reply ambiguity — removed rather than managed

Gary raised it: FEAT-001 parks while FEAT-002 is being implemented; the user replies;
*which card is that reply for?*

Resolved by an assumption the AI removed rather than a mechanism it added: **a parked
card is parked, not pending.** `blocked/` is park-and-forget, reviewed *between* runs.
Precedent verified — `BUG-144`, the only card in `blocked/`, is an Anthropic bug report
whose Follow-up Actions are all "when resolved, do X." Nobody unblocks it mid-session.

So a parked card is never re-opened during the run, and every reply during a run
belongs unambiguously to the card in `doing/`. Accepting a late answer would resume
FEAT-001 while FEAT-002 is mid-flight — exactly the interleaving that made execution
serial.

**Cost accepted honestly:** a user who *is* watching must still wait for the run to end.
Mitigated by requiring the batch report to make each parked card answerable on its own.

### 9. Fixed roster, and a broader hazard it exposed

Gary asked whether a card answered in a second session and moved back to `todo/` would
be picked up on the next loop. **No — the roster is fixed at the review gate.** A
mid-run addition would be unreviewed work, silently reopening the ADR-001 hole the batch
checkpoint was written to keep closed. It also would not terminate.

The question exposed something larger: **`fw-move.sh` has no lock, no session identity,
no concurrency guard at all** (verified). Tolerable while moves are human-paced; an
unattended run is precisely when a second session gets opened.

### 10. Skip-and-report does *not* protect serial execution (AI correction)

Gary asked: *"Skip and report keeps our serial execution guard, correct?"* The honest
answer was **no**, and the AI had conflated two guards when offering the choice:

- **Skip-and-report** guards *roster staleness* — a card that moved out from under the
  batch — so the run degrades instead of crashing.
- **Serial execution** is voided by two concurrent batch *runs*, which skip-and-report
  does nothing about. Both runs proceed happily and collide only if they reach the same
  card file.

Landed as a **documented limitation** rather than a half-built lock: serial is
guaranteed *within a run*; concurrent runs void it; an optional start-time marker is
advisory only and must never be called a lock or block a run whose predecessor crashed.
Real locking deferred to **TECH-049**.

---

## Work Completed

### FEAT-221 + children filed to `backlog/`

Parent/child shape chosen at Gary's request — *"I would be nice to dogfood this command
in this project by grouping cards related to the same feature."* Grouping verified
against the move engine: `find_parent`/`find_children` resolve `221` to the parent and
all three children, so `/fw-move 221 <target>` carries the set.

| Card | Scope |
|---|---|
| FEAT-221 | Parent — ADR-001 conflict, circuit-breaker, WIP/serial, batch membership, concurrency limits |
| FEAT-221.1 | Acceptance-criteria gate fires on either exit from `doing/`, not on `accept → done` |
| FEAT-221.2 | The command itself |
| FEAT-221.3 | ADR-001 amendment: per-batch checkpoint |

**Dogfooding caveat recorded:** FEAT-221.2 cannot implement itself, so this group is not
its own first batch run — the genuine test is the *next* feature group.

### TASK-219 extended (sixteen → eighteen conventions)

Two additions to Group 2, both board lifecycle policy rather than command behaviour:

- **`accept/`** — decide alongside FEAT-030 (hold/paused state): adjacent but not the
  same ("awaiting judgment on finished work" vs "paused mid-work"), different exits.
- **`blocked/` metadata for internally-blocked cards** — today's fields all assume an
  external party (`Blocked By`, `External Reference`, `Expected Resolution`). A card
  parked on an unanswered question fits none of them.

TASK-219 now **blocks FEAT-221**.

### diagram-index filed

`project-hub/docs/diagram-index.md` — published Lucid links for the master framework's
own diagrams. Two rows: the folder-structure mind-graph (consumed by ADR-009) and
`fw-implement-todo`.

---

## Decisions Made

1. **Diagram links live in `project-hub/docs/diagram-index.md`** — not
   `external-references/` (fails its deletion test), not `research/` (that is analysis).
   Registered in `framework.yaml` `sources:`.
2. **`accept/` is a general board state, not unattended-only** — owned by TASK-219
   Group 2, blocks FEAT-221.
3. **Acceptance-criteria gate keys on the *source* folder `doing/`**, not on a list of
   targets — correct for both `doing → accept` and `doing → done` by construction.
   `accept → done` is ungated: a human already said yes and `grep` does not overrule it.
   `doing → done` remains valid; `accept/` is optional, not mandatory.
4. **WIP limits unchanged; serial is a separate stricter floor** — ceiling vs. floor.
5. **Circuit-breaker is two-stage** — ask with `--wait` timeout, park to `blocked/` if
   unanswered. Never invent an answer; never halt the batch.
6. **`--wait <duration>`, default 60s** as a starting value; `--wait 0` = never ask.
7. **Parked cards are never re-opened mid-run** — removes reply ambiguity by
   construction rather than managing it.
8. **Batch roster is fixed at the review gate** — `todo/` is not re-scanned; cards
   returned mid-run wait for the next invocation and its own review.
9. **Serial execution is an intra-run guarantee only** — concurrent runs void it, stated
   as a known limitation; real locking deferred to TECH-049.
10. **Scope: the ADR-009 build only** (`workspaces/framework/`). The old framework is in
    maintenance. Gary: *"I agree only implement for new command."*
11. **ADR-001 is amended, not bypassed** — the checkpoint relocates per-card → per-batch.
    Amendment (FEAT-221.3) must land before the command (FEAT-221.2) ships.

---

## Open Questions (deliberately left for pre-implementation review)

- The `--wait` default — 60s is a starting value, expected to rise with real use.
- Should repeated timeouts short-circuit? Once the first shows nobody is there, parking
  the remainder immediately avoids eating N full timeouts.
- **Can `askUserQuestionTimeout` be set per-invocation?** It is a `settings.json` value;
  if it cannot be overridden per call, the command must reconcile its argument with the
  setting rather than silently ignore one. **Verify before implementing.**
- Is the advisory start-time marker worth building at all?
- Amend ADR-001 in place, or supersede it? Recommendation recorded: amend in place — a
  refinement of granularity, not a replacement.

---

## Files Created

- `project-hub/docs/diagram-index.md` — published diagram links for the master framework
- `project-hub/work/backlog/FEAT-221-unattended-todo-implementation.md` — parent
- `project-hub/work/backlog/FEAT-221.1-acceptance-gate-on-doing-exit.md`
- `project-hub/work/backlog/FEAT-221.2-fw-implement-todo-command.md`
- `project-hub/work/backlog/FEAT-221.3-adr-001-batch-checkpoint-amendment.md`
- `project-hub/poc/fw-implement-todo/Framework Planning - fw-implement-todo.png` —
  Gary's Lucid export (the source diagram)

## Files Modified

- `framework.yaml` — `sources:` gains `diagram-index`
- `project-hub/research/adr/009-workspace-model-and-fresh-build-in-place.md` — the
  mind-graph reference now carries the published Lucid link
- `project-hub/work/todo/TASK-219-board-conventions-for-the-new-build.md` — two Group 2
  conventions added (`accept/`, `blocked/` metadata); now blocks FEAT-221

## Files Moved

- `project-hub/research/diagram-index.md` → `project-hub/docs/diagram-index.md`
  (uncommitted intermediate; moved before first commit on Gary's correction)

---

## Current State

### In doing/
- *(empty)*

### In todo/
- 16 items, unchanged this session. TASK-219 is the next natural step — its Group 2
  (`accept/`) blocks FEAT-221.

### In backlog/
- FEAT-221 + three children (new)

### In done/ (awaiting release)
- *(empty)*

---

## Next Session

**TASK-219 Group 2** is the unblocking step: decide `accept/` against FEAT-030 (one
state or two), and widen `blocked/` metadata for internally-blocked cards. FEAT-221
cannot move until both are settled.

Group 1 of TASK-219 (staged to `todo/` on 2026-09-03) remains the other open front, with
its known FEAT-021 vs TECH-082 conflict — competing mechanisms for sub-item identity —
to be resolved first.

---

**Last Updated:** 2026-09-07

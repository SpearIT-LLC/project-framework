# Feature: Unattended Batch Implementation (`/fw-implement-todo`)

**ID:** FEAT-221
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-09-07
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->
**Theme:** Workflow
**Planning Period:** ADR-009 build

**Depends On:** TASK-219 (Group 2 — the `accept/` state and board lifecycle policy),
TECH-177 (the `[?]`/`[!]` markers)

---

## Summary

A command that implements every card in `todo/` in one unattended run: one
pre-implementation review pass across the whole batch, then card-by-card
implementation with no per-card stop. Cards land in `accept/` for the user's UAT
rather than going straight to `done/`.

**Parent card.** The work splits into three children that can land independently —
see *Children* below.

**Source diagram:** `Framework Planning — fw-implement-todo` (Lucid), exported to
`project-hub/poc/fw-implement-todo/`. Published link in
[diagram-index.md](../../docs/diagram-index.md).

---

## Problem Statement

**What problem does this solve?**

The current flow costs one human stop per card. `→ doing/` ends with *"STOP — wait
for user confirmation before implementing"*
([fw-move.md](../../../.claude/commands/fw-move.md)), so a run of eight ripe cards is
eight interruptions. For a solo developer with a well-groomed `todo/`, that is the
dominant cost of the workflow, and it is paid even when every card was already
reviewed and has no open questions.

**Who is affected?**

Solo developers running a groomed board — the framework's primary user (ADR-001,
*"Framework must work for solo developers"*).

**Why now?**

ADR-001 named its own revisit trigger: *"If Claude Code adds native planning-mode
features."* Unattended AI implementation is that class of change.

---

## The Conflict With ADR-001 (must be resolved, not ignored)

ADR-001 (Accepted, 2025-12-20) chose **mandatory checkpoint before implementation**
and states **"NEVER bypass approval checkpoint."** It also rejected Option 3
(planning-mode vs implementation-mode) as *"overkill for solo developers."*

**The proposed resolution — relocate, do not remove.** The checkpoint moves from
**per-card** to **per-batch**. Approval still precedes all code; the user still
approves the approach for every card; only the *granularity* changes. ADR-001's
stated harm — *"runaway implementation: code written without user approval of
approach"* — is not reintroduced, because the batch review approves each card's
approach before any card is implemented.

**This requires an ADR amendment, not a command that quietly ignores the policy.**
Amending ADR-001 is in scope for this card (child .3).

**What is explicitly NOT relaxed:**

- Ripeness is still judged by human+AI review, never by `grep` (ADR-007 D7 / BUG-184)
- The dependency gate on `→ doing` stays a hard block
- The acceptance-criteria gate stays a hard block — see FEAT-221.1
- The Implementation Rule stands: cards are implemented from `doing/`, moved by the
  gate, never implemented in place from `todo/`

---

## The Circuit-Breaker (the safeguard, distinct from the checkpoint)

Two different mechanisms, deliberately not conflated:

| | Checkpoint (ADR-001) | Circuit-breaker (this card) |
|---|---|---|
| Asks | "May I proceed?" | "Something blocks completing this card" |
| When | Once, up front, per batch | Exception path, mid-card |
| Batched? | Yes | No — never |

**The trigger is completeness, not just missing facts.** Anything that prevents
*complete* implementation trips it — an unanswerable question, a failed command, an
absent dependency, a file not where the card assumed. The AI never implements partially
and passes the card on: a half-done card arriving in `accept/` reads as finished, which
is worse than one honestly parked.

The circuit-breaker is **not new policy**. It is the existing Epistemic Standard
applied to unattended mode: *"When verification fails (file missing, command errors),
report the failure — never silently fall back to guessing"*
([CLAUDE.md](../../../CLAUDE.md)). The happy path is that the batch review catches
every open question and no card trips it.

**On trip: ask if someone is there; park if not.** Gary, 2026-09-07 — sometimes he is
at the keyboard or monitoring a remote session and can simply answer, letting the run
continue. Sometimes he is not. So the circuit-breaker is two-stage:

1. **Ask, with a timeout.** If answered → apply the answer, continue the card.
2. **No answer → park.** Move `doing → blocked`, record the blocking condition on the
   card, continue with the next card.

**Destination decided: `blocked/`** (Gary, 2026-09-07). See *Availability Detection*
below for the mechanism, and *Blocked Metadata* for the field problem it creates.

**And the tripped line is marked, with its reason** (Gary, 2026-09-07 — TECH-177's
`[?]`/`[!]` promoted from deferred for this). Three things happen before the card leaves
`doing/`:

1. `[?]` (an answer is needed) or `[!]` (a technical wall) on the **exact** line
2. **A note saying why** — what was attempted, what happened, what would clear it
3. `doing → blocked`

Both markers block `→ doing`, so a parked card cannot re-enter the queue until the
blocker is cleared. The folder is the *status*, the marker is the *location*, and the
note is the *reason* — `blocked/` alone gives none of the last two. Detail in FEAT-221.2.

**Parking is the fallback, not the first move.** Gary, 2026-09-07: mark and park applies
*"if the user is not able to answer/resolve the issue interactively during the run."* A
watching user resolves it and the card continues; only an unanswered trip parks.

**Rationale for park-not-halt:** halting on card 2 of 8 forfeits the unattended window,
which is the entire point of the command. The user returns to a batch report plus a
small pile of parked cards — strictly better than a run that stopped six cards ago and
waited.

---

## Availability Detection (the mechanism)

**Do not build a presence test or a bespoke timer.** Claude Code already provides the
exact primitive, and a hand-rolled one would be worse. Verified 2026-09-07 against the
Claude Code docs:

**Use `AskUserQuestion` with `askUserQuestionTimeout`.** Set in `settings.json` as
`"60s"`, `"5m"`, `"10m"`. On elapse the dialog auto-closes and the AI is told *the user
may be away from keyboard*, then decides whether to proceed or defer. This is
purpose-built for precisely this case: **the timeout IS the availability test.** Present
= answers in time; away = timeout fires. No separate probe is needed, and none is
possible.

**What does NOT exist** (confirmed, so nobody re-derives it later):

| Hoped-for mechanism | Reality |
|---|---|
| Env var / setting for interactive vs headless | **Does not exist.** No `CLAUDE_INTERACTIVE` or equivalent |
| Hook field revealing session type | **Does not exist.** Hooks see `permission_mode`, not session type |
| A hook that detects user presence | **Does not exist.** `Notification` says *Claude is waiting*, not *someone is watching* |
| Timeout on arbitrary prompts | **Only** on the `AskUserQuestion` dialog |

**Genuinely headless runs** (`claude -p`) are a different case and must be handled:
with `--permission-prompts none`, `AskUserQuestion` is **removed from the tool set** —
the AI cannot ask at all. Without that flag, a prompt in `-p` mode is **denied**, not
timed out. Either way there is no one to ask, so the correct behaviour is to skip
stage 1 and park immediately.

**The timeout is a command argument, not a fixed constant.** Gary, 2026-09-07:
*"60s is a very short time when a user is not expecting to be prompted."* Correct — the
prompt is unexpected by construction, so the user is not watching for it, and 60s
assumes attention the unattended case explicitly does not assume.

```
/fw-implement-todo [review] [--wait <duration>]
```

**Name:** `--wait`. Rejected `--time-to-blocked` / `--time-to-park` (they name the
failure, not the behaviour) and `--wait-for-prompt` (it is the *reply* being waited on,
not the prompt). `--wait` reads correctly at the call site: `--wait 10m`.

**Default: 60s** — as a *starting* value only, per Gary. Deliberately biased toward
keeping the run moving, on the reasoning that parking is cheap and reversible while a
stalled unattended run is the failure this command exists to prevent. Expect to raise
it once there is real usage; the argument exists so that does not require a code change.

**`--wait 0`** should mean *never ask, always park* — the honest way to say "I am
definitely not here," and cheaper than waiting out a timeout on every tripped card.

**Implementation note:** the underlying `askUserQuestionTimeout` is a `settings.json`
value, so per-invocation override needs verification — if it cannot be set per call,
the command must reconcile its argument with the setting rather than silently ignoring
one. Verify before implementing.

---

## Blocked Metadata (a real gap this creates)

`blocked/`'s existing fields are all external-party shaped — `Blocked By` (*external
party name*), `External Reference` (*URL, ticket, email thread*), `Expected Resolution`
(*date*). A batch-parked card fits none of them: the blocker is an unanswered question,
the reference is a card and a code path, and the resolution is "whenever the user reads
the batch report."

This is **not** a reason to reject `blocked/` — the transition and the semantics are
right, and inventing a second parked state would be worse. But the metadata needs either
a batch-parked variant or widened field definitions. **Owned by TASK-219** (it is board
lifecycle policy, not command behaviour); noted here because FEAT-221.2 cannot write a
useful parked card without it.

---

## Unblocking, and Why It Is Not a Live Conversation

Gary, 2026-09-07 raised the ambiguity: FEAT-001 parks to `blocked/` while FEAT-002 is
being implemented in the same session. The user sees 001 is blocked and types a reply —
**which card is that reply for?** The AI is mid-002; a bare answer is ambiguous and the
plausible failure is applying 001's answer to 002.

**Resolution: a parked card is parked, not pending.** `blocked/` is a park-and-forget
state reviewed *between* runs, not a live queue serviced during one. Precedent:
`BUG-144`, the only card in `blocked/` today, is an Anthropic bug report whose
`Follow-up Actions` are all "when resolved, do X" — nobody unblocks it mid-session.

Therefore:

- **The batch never re-opens a parked card during the run.** Once parked, that card is
  finished for this run, even if the user answers the question thirty seconds later.
- **The answer arrives as a normal reply to the batch report**, after the run ends,
  when there is no competing card to confuse it with.
- **Unblocking is a deliberate act:** `blocked → doing` (or `→ todo`), both already
  valid transitions, initiated by the user after the run.

**Why not accept a late answer and resume 001?** It reintroduces exactly the
interleaving hazard that made execution serial in the first place (see *WIP Limits and
Serial Execution*): resuming 001 while 002 is mid-flight means two implementations
touching the same tree with plans formed at different times. The whole design says one
card at a time; a late unblock would quietly violate it.

**Consequence to accept honestly:** a user who *is* watching, sees the park, and knows
the answer must still wait for the run to finish. That is a real cost. It is accepted
because the alternative — a live queue of parked cards competing for the same reply
channel — is ambiguous in exactly the way Gary identified, and ambiguity in an
unattended run is the thing being engineered against.

**Mitigation:** the batch report must make each parked card individually answerable —
card ID, the exact question, and enough context to answer without re-reading the card.
An answer given after the run is unambiguous because the report enumerates what is
being asked.

---

## Batch Membership: Fixed at Review, Not Re-read Each Loop

Gary, 2026-09-07 asked: if the user opens a **second session**, answers the blocking
question there, and moves the card back to `todo/` while the first session is still
running — does the batch pick it up on the next loop?

**Answer: no, and this must be explicit — the batch works a fixed roster.** The set of
cards is captured once, at the review gate, and does not change for the life of the run.
`todo/` is read once; it is not re-scanned between cards.

**Why a fixed roster:**

1. **The review gate is what authorises the run.** A card added mid-run was never
   reviewed, never checked for cross-card conflicts, and never approved by the human. A
   re-scanning loop would implement unreviewed work — which is precisely the ADR-001
   harm the batch checkpoint was carefully preserved to prevent (see *The Conflict With
   ADR-001*). Re-reading `todo/` would silently reopen the hole the amendment was
   written to keep closed.
2. **It would resurrect the card that was just parked.** A card parked for an
   unanswered question, then moved back to `todo/` by a second session, would be picked
   straight back up — with the answer living in the *other* session's context, not this
   run's. The parked card's whole point is that this run is finished with it.
3. **Non-termination.** A batch that re-reads its own source folder has no guaranteed
   end while anything can add to `todo/`.

**Therefore:** cards answered and returned to `todo/` mid-run are picked up by **the
next invocation**, not the current one. That is the correct granularity — the next run
performs its own review gate over them, which is what makes them safe to implement.

---

## Concurrent Sessions (a real hazard, only partly addressable here)

The second-session scenario exposes something broader: **nothing in the framework
prevents two sessions moving cards at the same time.** Verified 2026-09-07 —
`.claude/scripts/fw-move.sh` has no lock, no session identity, and no concurrency guard
of any kind.

That is tolerable today because moves are human-paced and interactive. **An unattended
batch changes the risk profile**: a long autonomous run is exactly when a second session
is most likely to be opened, because the user has nothing else to do in that window.

Concrete failure available today: session B moves a card out of `todo/` while session A's
batch, holding its fixed roster, later tries to move that same card `todo → doing`. The
file is gone. The batch must handle this rather than crash.

**In scope for this card:**

- Each card is re-verified to still be in `todo/` immediately before `todo → doing`.
  If it has moved, skip it and note it in the batch report — do not fail the run.
- The batch report names any roster card that vanished or moved mid-run.

**Out of scope (belongs to TECH-049, *Human-AI concurrent-work handoff*):** actual
locking, session identity, or a general answer to two agents sharing one board. This
card must not invent a locking scheme unilaterally; it must degrade safely without one.

### Serial execution is an intra-run guarantee only

**Stated plainly so the card does not promise more than it delivers.** Serial execution
(one card in `doing/` at a time) holds *within* a single batch run, because one loop
controls it. **Two concurrent batch runs void it.** Session A implementing FEAT-001
while session B implements FEAT-002 produces exactly the read-plan-write interleaving
that serial execution exists to prevent — two implementations against one tree, plans
formed at different moments.

**Skip-and-report does not address this.** Skip-and-report guards *roster staleness* — a
card that moved out from under the batch — so the run degrades instead of crashing.
That is a different problem from the serial guarantee, and it is worth not conflating
the two: two concurrent runs proceed happily past each other and collide only if they
happen to reach the same card file.

**What this card does:**

- Guarantees serial execution **within a run** — and says so in those words
- Skip-and-report for roster staleness (above)
- **Optional, advisory:** a start-time marker file, so a second invocation can say
  *"a batch appears to be running — continue?"* Advisory only. It is not a lock, must
  not be described as one, and must not block a legitimate run whose predecessor
  crashed holding the marker

**What this card does not do — and why.** No real lock. A correct one needs session
identity, staleness detection (what happens when a run dies holding it?), and a manual
override. That is **TECH-049**'s scope (*human-AI concurrent-work handoff*), and a
half-built lock is worse than a documented limitation: it invites trust it has not
earned.

**Known limitation, to be documented in the command's own help:** running two batches
concurrently voids the serial guarantee. Do not do it until TECH-049 lands.

---

## WIP Limits and Serial Execution

**No rule change. Batch honours WIP limits exactly as interactive use does.**

Serial execution is a *separate, stricter* constraint that sits on top of the WIP limit
— not a consequence of it, and not an exemption from it:

- **The WIP limit is a ceiling.** Batch respects it, unchanged.
- **Serial is a floor.** Batch runs one card at a time **even when the limit leaves
  room.** If `doing/.limit` is 4 and `doing/` is empty, the batch still runs one card at
  a time, not four.

**Why serial rather than filling the limit** (Gary, 2026-09-07 — this is the safeguard
the diagram sticky was reaching for): concurrent implementations compete for the same
resources, and worse, *one thread reads a file and forms a plan while another thread is
changing the very file that plan is based on.* The first thread then implements against
a foundation that no longer exists. The diagram sticky puts it as *"so that each
implementation is working from the same foundation."*

This is explicitly a **first-iteration safeguard**. Parallel batch execution is not
ruled out forever; it is ruled out until there is a real answer to read-plan-write
interleaving across cards. Do not treat serial as a performance bug to be optimised away.

`todo/.limit` is 10 and `todo/` currently holds 16 — already over, independent of this
card. Not this card's problem to fix, but the batch should not be surprised by it.

---

## Children

| ID | Scope | Why separable |
|---|---|---|
| FEAT-221.1 | Acceptance-criteria gate fires on `doing → accept` as well as `doing → done` | Pure gate correction; valuable the moment `accept/` exists, with or without this command |
| FEAT-221.2 | The `/fw-implement-todo` command itself — batch review, serial queue, circuit-breaker, batch report | The command proper |
| FEAT-221.3 | ADR-001 amendment: per-batch checkpoint | A decision record; must land before .2 ships, reviewable on its own |

---

## Acceptance Criteria

- [ ] All three children are complete
- [ ] ADR-001 carries the batch-checkpoint amendment with its rationale (not a silent bypass)
- [ ] A batch run of ≥3 cards completes with exactly one human approval up front
- [ ] Anything blocking complete implementation trips the breaker — never partial work
      passed on as finished
- [ ] A tripped card asks first, and continues the run if resolved during the run
- [ ] An unanswered question parks the card to `blocked/` and the run continues
- [ ] A genuinely headless run (`-p`) parks without attempting to ask
- [ ] `--wait <duration>` overrides the default; `--wait 0` parks without asking
- [ ] A parked card is never re-opened during the same run, even if answered late
- [ ] Batch membership is fixed at the review gate; `todo/` is not re-scanned mid-run
- [ ] A roster card moved by another session is skipped and reported, not fatal
- [ ] At no point does `doing/` hold more than one card during a batch run —
      including when the WIP limit would permit more
- [ ] The serial guarantee is documented as intra-run only, with concurrent runs named
      as a known limitation pointing at TECH-049
- [ ] Cards land in `accept/`, not `done/`
- [ ] The parked card carries both a marker on the exact line and a note saying why

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->

- [ ] **PRE-IMPLEMENTATION REVIEW COMPLETED**
- [ ] FEAT-221.3 — ADR-001 amendment (first: it authorises the rest)
- [ ] FEAT-221.1 — acceptance-criteria gate correction
- [ ] FEAT-221.2 — the command
- [ ] Plugin CHANGELOG updated

---

## Scope

**In scope:** the new ADR-009 build (`workspaces/framework/`) only.

**Out of scope:** the old framework (`framework/`, `.claude/`), in maintenance per its
`PROJECT-STATUS.md`. Decided 2026-09-07 — see Notes.

---

## Notes

- Gary, 2026-09-07: *"I would be nice to dogfood this command in this project by
  grouping cards related to the same feature."* Hence the parent/child shape.
  **Ordering constraint:** .2 cannot implement itself, so the genuine dogfood run is
  the *next* feature group after this one, not this one.
- Gary, 2026-09-07 on the safeguard: *"Don't plow through the card and make up answers
  we don't have facts for. The happy path is the review catches all the questions and
  we're able to implement end to end with no issues."*
- Gary, 2026-09-07: *"I agree only implement for new command"* — new build only.
- Gary, 2026-09-07: `accept/` is **not** unattended-only — it also covers *"waiting on
  someone outside the team to check some work."* That is why it belongs to TASK-219 as
  a general board state, not to this card.
- The diagram's `done/` sticky asked *"How to implement the UAT? Maybe we need a
  review/ folder?"* — answered by `accept/`, owned by TASK-219.

---

## Related

- **TASK-219** — owns the `accept/` state (Group 2). **Blocks this card.**
- **TECH-049** — human-AI concurrent-work handoff. Owns locking / session identity;
  this card degrades safely without them but does not solve them.
- **ADR-001** — the checkpoint policy this card amends
- **ADR-007 D7 / BUG-184** — ripeness is judged at `→ doing`, not by grep
- `project-hub/poc/fw-implement-todo/` — the source diagram
- [diagram-index.md](../../docs/diagram-index.md) — published Lucid link

---

**Last Updated:** 2026-09-07

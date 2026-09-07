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

> **Non-template section.** Kept because this was a design session: no code was written,
> so the reasoning *is* the work product. Same precedent as the 2026-08-18 ADR-009
> session. Without it the cards read as arbitrary — three of their load-bearing
> decisions are reversals of the AI's first position, and only the journey shows why.

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

> **Non-template section.** Kept because these are *unresolved* and therefore belong in
> neither Decisions Made (nothing was decided) nor Current State (they are not board
> state). One of them — whether `askUserQuestionTimeout` can be set per-invocation —
> can force a design change in FEAT-221.2, so it must not be lost.

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

### Next step

**TASK-219 Group 2** is the unblocking step: decide `accept/` against FEAT-030 (one
state or two), and widen `blocked/` metadata for internally-blocked cards. FEAT-221
cannot move until both are settled.

Group 1 of TASK-219 (staged to `todo/` on 2026-09-03) remains the other open front, with
its known FEAT-021 vs TECH-082 conflict — competing mechanisms for sub-item identity —
to be resolved first.

---

## Session-History Format Drift, and FEAT-222 (Later — Continuation)

Gary asked what this file did differently from the template and the 2026-08-18 /
2026-09-03 precedents. Checking rather than answering from memory produced a correction
and then a finding.

**The correction:** the AI had cited *both* precedents for the non-template *Journey*
section. Only 2026-08-18 supports it. 2026-09-03 follows the template exactly, folding
its journey into Work Completed as a "Process correction" bullet. The two precedents are
different shapes for different session types — 08-18 is a pure design session (Journey,
no Work Completed; the reasoning *was* the work), 09-03 an implementation session (Work
Completed, no Journey). This file is a hybrid neither used.

**Gary's rule, now governing:** *"I'm ok with adding to the history if there's a case
for it... But I do want to keep the template format at a minimum for consistency. An
added section is ok if we have a good reason."*

Applied to this file:

- **Next Session — removed**, folded into Current State as `### Next step`. It
  duplicated board state, so it had no case.
- **The Journey and Open Questions — kept**, each now carrying a one-line block quote
  stating why, so the justification travels with the file rather than living in a
  conversation.

**The finding:** there is no single template to deviate from. Three authored formats
disagree —

| Source | Notable sections |
|---|---|
| `workflow-guide.md#session-history` (the `sources:` source of truth) | Blockers Encountered, Next Steps, Lessons Learned, Duration |
| `.claude/commands/fw-session-history.md` (what runs) | Files Modified/Created/Moved, Current State — none of the above |
| TECH-072 (backlog) | Work Items Touched table, Blockers / Open Questions, Next Session |

The guide's stated location (`project-hub/history/`) is also wrong; actual is
`project-hub/history/sessions/`. And "Next Session" — the section removed above for
being non-template — is called for by the guide *and* TECH-072. No one can satisfy all
three.

**Decision (Gary):** *"I see we haven't migrated the session-history command to the new
framework yet. Let's fix it in the new command."* Fix forward, do not reconcile.
**FEAT-222** filed: author one format in the ADR-009 build, where no session-history
command exists yet. The old copies retire with the old framework rather than being
edited into agreement — editing all three would create a fourth thing to keep in sync,
which is the failure being ended.

**TECH-072 marked superseded** by FEAT-222, with its proposed Blockers/Next-Session
sections preserved as input to the format decision rather than discarded.

**Not done here:** the format itself. FEAT-222 carries four open questions — whether
Blockers and Next Steps are core or optional, whether Duration/Participants survive, how
"a good reason" is mechanized (ADR-008: prose is not a guardrail), and whether the
append-only principle carries as-is.

---

## "Never Read Them" — An AI Overreach, Corrected (Later — Continuation)

Gary, on FEAT-222's justification for authoring fresh: *"Why did we say 'never read them
as guidance for this workspace's design'? How are we supposed to learn from what we did
in the past and improve?"*

**The challenge was right and the card was wrong.** Checking ADR-009 rather than
defending the line: the ADR's intent is close to the *opposite* of how the AI applied it.

- **Option B (fresh repo) was rejected on exactly this ground.** Its recorded con: the
  ADRs, retrospectives and session logs *"stop being live context and become a
  disconnected archive,"* with the named failure being *"a settled decision gets
  re-proposed months later because the record that rejected it is no longer loaded."*
  Option C was chosen to keep history **connected and live**.
- **ADR-009 explicitly plans to mine the old docs:** TECH-187's restatement audit
  *"still determines which of `framework/docs/`'s 8,246 lines survive into the new
  build."* You cannot audit what you are forbidden to read.

**What the boundary actually guards** is narrower than the sentence implies:
`framework/CLAUDE.md` and `framework.yaml`'s `sources:` describe the *old structure as
current*. The AI loads them at session start and acts on a stale map — ADR-009 calls
this *"the BUG-170 silent-degradation class applied to instructions."*

The distinction the AI flattened:

| | Old framework's standing |
|---|---|
| **Design authority** — what the new build's structure *is* | None. This is what the boundary protects |
| **Evidence and lessons** — what was tried, what broke, why | Exactly what ADR-008, the retrospectives and 88 session logs exist for |

**Two fixes applied:**

1. **`workspaces/framework/CLAUDE.md` reworded.** *"Never read them as guidance for this
   workspace's design"* → *"holds no design authority here"*, naming the real hazard
   (stale `sources:`/`CLAUDE.md` treated as current instructions), plus a new paragraph:
   **"Read the history; don't inherit the structure."** It cites ADR-009's own reason for
   rejecting a fresh repo, and requires a carry-in to be a justified decision — a
   `git mv` with the reason written down — never an unexamined default.
2. **FEAT-222 reframed.** *"Author fresh"* now explicitly means *read all three formats
   carefully, then decide*: fresh is about **authority, not ignorance**. Added a
   "specifically worth learning from" list — the guide's Blockers/Next Steps (practice
   has been re-inventing "what's next" inside Current State ever since they were
   dropped), the command's Files/Current State sections, TECH-072's Work Items Touched
   table (the only proposal capturing board movement as *data*), and the fact that
   2026-08-18 and 2026-09-03 are different shapes for different session types. New
   acceptance criterion: each old format gets a recorded verdict.

**Also corrected in passing:** an unverified "three years of practice" claim in FEAT-222.
Actual: 88 session histories, 2025-12-19 → 2026-09-07.

**The wider lesson, worth keeping:** a boundary written to stop *structural* inheritance
was phrased as a blanket prohibition on reading, and the AI that misread it had authored
the surrounding cards. Given ADR-009 chose Option C *specifically* to keep history live,
a line that reads as "ignore history" undercuts the decision it implements.

---

**Last Updated:** 2026-09-07

# Task: The Remaining Board Conventions (Groups 2–5)

**ID:** TASK-223
**Type:** Task
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-09-10
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->
**Theme:** Framework Consistency

---

## Summary

The fourteen board conventions that did **not** block the work-item template. Split out of
**TASK-219** on 2026-09-10, which closed on the five (Group 1) that did.

Same contract as its parent: for each convention, **decide it against the new build, give
it a mechanism, and close the source card.** A convention decided but written only in prose
is not finished — that is ADR-008 Root 2, the failure this framework exists to avoid.

---

## Why this was split

TASK-219 had grown to nineteen conventions across five groups with one acceptance-criteria
block covering all of them, so the five that shipped could not be closed without the
fourteen that had not started. Gary, 2026-09-10: *"I'm thinking we're making our cards too
large."*

The split is along the line that already existed in the card: Group 1 blocked the
work-item template (and so the Boston Dynamics deadline); nothing here does.

**None of this is on the BD critical path.** What BD needs is `fw-new` (FEAT-175) and the
kanban row in `fw-move.sh`. Work these when that path is clear, or when one of them starts
blocking something real.

---

### Group 2 — Board lifecycle policy

| Source | Convention to settle |
|---|---|
| TECH-044 | Creation policy — create in `backlog/`, promote when committed |
| TECH-077 | Never-delete / archive-only. **Write it down and back it with a check**; TASK-218 honoured an unwritten rule |
| TECH-078 | Release archival — `done/` items to `history/releases/vX.Y.Z/`. No release tooling exists yet |
| FEAT-030 | A hold/paused state for board items. Operations has `onhold/`; kanban has no equivalent defined |
| FEAT-221 | **`accept/` — a state for work that is finished but not yet accepted.** Decide it alongside FEAT-030: the two are adjacent but not the same ("waiting on judgment of finished work" vs "paused mid-work"), and they have different exits. Blocks FEAT-221 |
| FEAT-221 | **`blocked/` metadata for internally-blocked cards.** Today's fields assume an external party (`Blocked By`, `External Reference`, `Expected Resolution`). A card parked by an unattended batch is blocked on an *unanswered question*, not a third party. Widen the fields or add a batch-parked variant. Blocks FEAT-221.2 |
| BUG-215 discussion | **`cancelled/` as a board folder — and the terminal-state set as a whole.** Cancelled is a traditional kanban lifecycle status, not a storage location. Today it is folded into `archive/`, which is doing double duty. **Decide the full set at once**, not folder-by-folder. See Group 2a |

### Group 2a — Settle the terminal states as a set (added 2026-09-07)

> **Largely answered by the authored structure diagram (2026-09-07).** Gary's Lucid
> repo-structure page — the same document as `fw-implement-todo`, indexed in
> [diagram-index.md](../../docs/diagram-index.md) — carries the intended folder set for
> the ADR-009 build. It is an **authored design**, not a proposal, so the questions below
> are mostly ratification rather than open decisions.
>
> ```
> kanban/     backlog  blocked  todo  doing  accept  done  cancelled
>             release/<product>          templates/ (marked "alt idea")
> operations/ open  onhold  closed
> kb/         <domain>/{cookbook,faq,reference,research}   index
> workspaces/ <created as needed>
> history/    sessions/YYYY/  retrospectives/  archive/
> ```
>
> **What this settles:**
> - **`accept/` exists** — first-class, sitting between `doing` and `done` exactly as the
>   `fw-implement-todo` flow requires. Question 1's answer for accept.
> - **`cancelled/` exists** — first-class, confirming the 2026-09-07 reasoning that
>   cancelled is a lifecycle status rather than a storage location.
> - **No `archive/` under `kanban/`.** With `cancelled/` first-class, archive's double
>   duty splits: `history/archive/` is the storage home. **This still needs deciding for
>   the 27 `deprecated/` cards** — they are neither cancelled nor released.
> - **`release/` is per-product** (`app1`, `app2` in the diagram), matching
>   `framework.yaml`'s `products[]` and the old board's `history/releases/<product>/`.
>
> **What it does not settle** — still genuinely open:
> - **FEAT-030's hold state.** No hold folder appears under `kanban/`. Either the state is
>   dropped for the board, or `blocked/` covers it, or the diagram predates the question.
> - **Where deprecated cards live** (see above).
> - **`templates/` under `kanban/`** is marked *"alt idea"* in the diagram — explicitly
>   unsettled by its author.
> - Questions 2, 3, 4 and 6 below (transitions into `cancelled/`, whether it is terminal,
>   whether the board gains a closure code, ID-safety of the new folders) are unaffected
>   by the diagram and still need answers.


Three folder questions arrived within one week (`accept/`, `cancelled/`, and FEAT-030's
hold state). Deciding them one at a time is how a board grows a fourth folder next month.
**Decide them together**, as one terminal/parked-state model.

**The `cancelled/` case** (Gary, 2026-09-07: *"Cancelled is a more traditional Kanban
lifecycle status"*):

- On the board, cancellation **already is a status change** — the transition matrix
  treats `todo -> archive` and `doing -> archive` as lifecycle moves, and `/fw-move`
  prompts for `Status: Cancelled`, `Cancelled Date:`, `Cancellation Reason:` on the way.
  The state is modelled; it is just stored in a folder named for storage.
- **`archive/` is doing double duty.** It holds cancelled cards *and* the 27
  `deprecated/` cards from TASK-218 — which are not a lifecycle outcome at all. Verified
  2026-09-07: 8 loose + 27 deprecated.
- Splitting `cancelled/` out makes location-is-status true on the board without an
  asterisk, and lets `/fw-wip` and reporting tell *"we decided not to"* from
  *"superseded by a rewrite."*

**Why the ops model does not simply port.** Operations has no `cancelled/` folder because
FEAT-193 ruled location = *flow* state, outcome = a `Resolution:` field
(`resolved | cancelled | duplicate | no-fault-found | rejected`). That worked there for a
specific reason, quoted from FEAT-193:

> *The kanban's separate `archive/` exists only because `done/` feeds a release sweep that
> cancelled items must not enter; ops `closed/` has no such fork.*

The board has a downstream consumer; operations does not. A cancelled card sitting in
`done/` behind a field would ship in a release archive the moment one consumer forgot to
filter. **The folder is doing protective work a field cannot** — which is why the two
namespaces may legitimately stay different, and why "make the board work like ops" is the
option to reject, not the default.

**Questions to settle together:**

1. **Does `cancelled/` exist?** If so, `archive/` reverts to meaning *put away* only
   (deprecated cards, retired work) and stops being a lifecycle destination.
2. **Which transitions reach it?** Cancellation is available from every pre-terminal
   state today (`backlog`/`todo`/`doing` -> `archive`, and `done -> archive` "rare,
   retroactive").
3. **Is it terminal like `done`?** `done -> *` is blocked; presumably `cancelled -> *` too.
4. **Does the board gain a closure code**, as ops has? Today cancellation carries
   free-text `Cancellation Reason:` only. `duplicate` vs `rejected` vs `cancelled` is the
   distinction ops found worth encoding, and reporting (FEAT-196) would want it here too.
   **Additive** — no structural risk either way.
5. **How does it interact with `accept/` and FEAT-030's hold state?** All three are new
   folders proposed within a week. One model, decided once.
6. **ID safety:** any new folder must live **under `work/`**. Both ID scanners walk that
   tree recursively; a sibling root would be invisible to the old one and risk ID
   reissue. (Same constraint recorded for `deprecated/` in this card's D8 review.)

**A year-bucket sweep for `archive/` was also raised and set aside** — porting ops'
`closed/YYYY/` bucketing to the board's 35-card `archive/`. It is a *grouping* action that
changes no status, so it is unrelated to the folder question and can land any time.

---

### Group 3 — Process and collaboration

| Source | Convention to settle |
|---|---|
| TECH-070 | Issue-response process (triage → assess → decide → resolve) |
| TECH-070.1 | Its validation sub-task — travels with TECH-070 |
| TECH-071 | Session handoff checklist — the new build has session history but no start/end checklist |
| TECH-049 | Human-AI concurrent-work handoff, especially around git operations |

### Group 4 — Templates the new build lacks

| Source | Convention to settle |
|---|---|
| TECH-073 | External-reference template |
| FEAT-149 | Meeting-record standard, incl. AI-participant transparency — `meetings/` folders are scaffolded with nothing to put in them |

### Group 5 — Already followed, not yet written

| Source | Convention to settle |
|---|---|
| DECISION-171 | The `fw-` namespace rule for artifacts in user-shared folders. The new build **follows it** — every command and script is `fw-*` — so this is live rationale. Record it as an ADR or a contract line; do not leave it as an unstated habit |

---

---

## Approach

**Do not do all fourteen at once.** They are independent; Group 2a is the only set that
must be decided together (the terminal-state model). Take a group when something needs it.

For each convention:

1. **Decide it against the new build**, not the old one. The source card's analysis is
   input; its paths and file targets are not.
2. **Give it a mechanism** — a template field, a script check, a hook, or an explicit
   statement that it is one of the rules that cannot be mechanized.
3. **Close the source card.** Record the outcome in it and move it to `done/`, or archive
   it with a closing note if it turned out to be superseded.

---

## Acceptance Criteria

- [ ] Every one of the fourteen has a recorded outcome: **defined** (with its mechanism),
      **decided-by-construction** (with the rationale written down), or **dropped** (with
      the reason)
- [ ] The never-delete rule (TECH-077) is written down and backed by a check, not habit
- [ ] The `fw-` namespace rule (DECISION-171) is recorded where a future contributor will
      find it
- [ ] The terminal/parked-state set is decided **as a set** (Group 2a) — `accept/`,
      `cancelled/`, FEAT-030's hold state — not folder-by-folder, with `archive/`'s
      meaning restated once they are settled
- [ ] `blocked/` metadata covers an internally-blocked card (unanswered question), not
      only an external party
- [ ] Every source card is closed, moved to `done/`, or archived with a closing note —
      none is left open describing a convention that is now defined
- [ ] Plugin CHANGELOG updated

---

## Notes

- **The folder scaffold already exists.** `templates/queues/kanban/` was built under
  TASK-219 with `accept/` and `cancelled/` present, from the authored repo-structure
  diagram. That settles *which folders exist*; it does **not** settle Group 2a's questions
  — transitions into `cancelled/`, whether it is terminal, whether the board gains a
  closure code, or where the 27 `deprecated/` cards live.
- The lesson that produced this split is worth keeping: a card owning nineteen decisions
  under one acceptance block cannot be closed until the least urgent one is done.

---

## Related

- **TASK-219** — the parent. Holds Group 1's five settled conventions and the work-item
  template they produced. Closed 2026-09-10.
- **TASK-218** (done) — its Section C6 holds the original per-card analysis.
- **FEAT-175** — the board create gate. Unblocked by TASK-219, not by this card.
- **ADR-009 D5** — the board crossover these conventions govern.
- **ADR-008** — Root 2 (*invariants written as prose degrade silently*) is why every
  convention here needs a mechanism, not just a decision.
- **ADR-006** — the work-item type taxonomy; the conventions here sit around it.

---

**Last Updated:** 2026-09-10

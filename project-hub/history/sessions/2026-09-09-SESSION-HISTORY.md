# Session History: 2026-09-09

**Date:** 2026-09-09
**Participants:** Gary Elliott, Claude Code
**Session Focus:** Roadmap maintenance — which exposed that the roadmap itself is the wrong shape

---

## Summary

Started as a small correction: the roadmap's checkbox legend still described the pre-`[h]`
marker set. Reconciling it also meant fixing board state that had drifted in two days —
the **second** such reconciliation in three days. That prompted the real question, and the
answer was already in the repo: FEAT-198 had decided there should be no spine-level
authored master roadmap, and `/fw-roadmap` already ships the themes/planning-periods model
the current file does not use.

---

## Work Completed

### ROADMAP-DELIVERABLES.md — legend corrected, board state reconciled

The stated ask. `[!]` was replaced by `[h]` on 2026-09-08 (it means *important* in every
Obsidian theme collection, not blocked) but the roadmap legend still listed the old set.
Legend now carries `[ ] [/] [x] [-] [?] [h]` plus a note on why `[!]` is not used.

Board state had also drifted since the 09-07 snapshot, so that was fixed in the same pass:

- **BUG-215** is in `doing/`, not `todo/`, and was rescoped to *parity across both
  namespaces*. Marked `[/]`.
- **TECH-177** is no longer a ride-along on BUG-215 — it grew into owning sub-task-level
  blocking for the framework, and is the next card.
- Counts: todo 16 → 15, doing 0 → 1.
- **D3b** no longer lists batch moves as a blocker (restored 09-07).
- **D1b**'s `accept/` row records that the authored repo-structure diagram settles
  `accept/` and `cancelled/` as first-class, and names the three things it does not settle.

### FEAT-198 — the roadmap shape, recorded where the decision already lived

Gary: *"the roadmap feels too heavy and the details should always be part of the
individual card. For me, I think the roadmap should be just a list of existing or planned
cards with a planned order. Add a little explanation of each phase with a reason. That's
all we need really."*

Recorded on **FEAT-198** rather than as a new card. That card already decided *"No
spine-level authored master roadmap exists in the new model; any cross-workspace view is
generated"* — so this is the concrete shape for a decision made 2026-08-20, not a new one.

Added to it: the judgment/derived split, the completion-criteria finding, the
cheap-divergence rule, and five acceptance criteria. `ROADMAP-DELIVERABLES.md` marked
**superseded in shape** at the top.

---

## Decisions Made

1. **A roadmap holds judgment and card ids; never card detail.**
   - Judgment = ordering, phase rationale, phase done-conditions. References = card ids.
     Folder, priority, status, summary all live on the card.
   - **Rationale — the file is its own evidence.** Hand-reconciled twice in three days
     (09-07, 09-09). Both times what drifted was the *derived* half. The ordering has
     never been wrong. The judgment held; the copy rotted.

2. **The "never finish a roadmap" pattern is unacknowledged mid-flight change, not
   indiscipline.**
   - Gary asked which it was. **Verified:** `ROADMAP-DELIVERABLES.md` carries no success
     criteria for any deliverable, so "halfway through and diverged" was never
     *observable* — there is no condition that was met or missed.
   - Diagnosis matters because the two causes want opposite responses: indiscipline says
     enforce harder, unacknowledged change says the roadmap could not absorb reality.
   - Evidence for the second: FEAT-221 and FEAT-222 were both filed mid-session (from a
     diagram and a slash command), and BUG-215 turned out to be a namespace problem, not
     a batch problem. None was indiscipline; the roadmap had nowhere to put any of it.

3. **Use the themes/planning-periods model the framework already ships.**
   - `/fw-roadmap` produces **Themes** (stable categories) and **Planning Periods**
     (temporal, each with a goal and **success criteria**); cards carry `Theme:` and
     `Planning Period:` fields to link back. A planning period with success criteria *is*
     a phase with a done-condition.
   - **Two roadmap models exist in this repo** — the shipped one, and the ad-hoc
     deliverable-ranked file we have actually been maintaining. The ad-hoc one is the one
     that rotted.

4. **Divergence must be cheap to record** — a one-line appended note (what changed, why,
   date), never a rewrite. If changing the plan is expensive, it happens informally and
   the roadmap silently stops being true.

5. **No third reconciliation of `ROADMAP-DELIVERABLES.md`.** Its own note set that
   threshold (*"worth a card if this reconciliation is needed a third time"*) and it has
   been reached. Read it for the ranking; go to the card for anything else.

---

## Files Modified

- `project-hub/planning/ROADMAP-DELIVERABLES.md` — legend corrected to the `[h]` set;
  board state reconciled; marked superseded in shape; second reconciliation note added
- `project-hub/work/backlog/FEAT-198-per-workspace-roadmaps.md` — the roadmap shape, the
  completion-criteria finding, cheap-divergence rule, five new acceptance criteria, one
  new open question

---

## Current State

### In doing/
- **BUG-215** — both halves shipped and tested; a built-plugin UAT pass is what closes it.

### In todo/
- 15 items. **TECH-177** is next — it owns the `[?]`/`[h]` gate behaviour that this
  roadmap's own marks depend on, and it blocks D3b.

### In done/ (awaiting release)
- 8 items, unchanged.

### Open question left on FEAT-198, deliberately

**Where does the framework's own roadmap live** once the spine master retires?
`workspaces/framework/` is a workspace, so its roadmap belongs there — but the board it
plans sits at the spine until the ADR-009 D5 crossover. Lean: it lives in the workspace
and references spine card ids, which are stable across the crossover.

---

## Boston Dynamics Deadline, and TASK-219 Group 1 (Later — Continuation)

**Continuation:** the morning ended on "start on TASK-219 Group 1." Before doing so, Gary
introduced a date that reordered everything.

### The BD deadline changed the question

Gary: the **Boston Dynamics** project starts **~2026-09-28** (give or take a week), in a
**fresh git repo**, migrating from
`SpearIT/Clients Current/Boston Dynamics` — *"After that time the new repo will be the
master."* He wants it on the new framework.

That turned "unsnarl three snowballed cards" into "what must the framework do in 19
days." Gary named the five features he needs:

| # | Feature | State (verified 2026-09-09) |
|---|---|---|
| 1 | **kanban** | **nothing** — no folders, no template, no create, no move |
| 2 | **session-history** | **nothing** — FEAT-222 |
| 3 | workspaces | **built** — `fw-new-workspace`, 4 type scaffolds |
| 4 | kb | **built** — `fw-new-kb-domain` |
| 5 | operations | **built** — records, queue, `fw-move-ops`, `fw-troubleshoot` |

Three of five are not merely present but **proven**: the 2026-08-26..29 UAT ran 30 tests
(UAT-00–29) in a throwaway repo with no `workspaces/framework/`, all passing except
UAT-13. UAT-02 built a **`bd-sow-001` project workspace** — the exact shape BD needs.

**So the critical path is kanban, and neither BUG-215 nor TECH-177 is on it.**

### Three AI errors corrected by checking

1. **"`/fw-new-workspace` has never built a project workspace in a real repo."** Wrong —
   UAT-02 did exactly that, and named it `bd-sow-001`. Asserted without checking the UAT
   results that were sitting in the repo.
2. **"ADR-009 D5 names `/fw-init` as generating `kanban/`, and it doesn't exist."** Wrong
   on both halves. The `fw-init` discussion is in **ADR-007**, where it was *deliberately
   not filed as a FEAT* (the name collides with Claude Code's built-in `/init`; it folded
   into OQ1 as a CLAUDE.md region-owner). **There is no scaffolding gap:** the create
   command scaffolds its queue on first use from `templates/queues/<ns>/`, exactly as
   `fw-new-ops-record.sh` already does for `operations/`.
3. **"FEAT-021 and TECH-082 are competing mechanisms."** Wrong, and it was on TASK-219 and
   in the roadmap — the AI had helped write it. See below.

### TASK-219 reframed before being worked

The card's stated objective — settle nineteen conventions, unblock FEAT-175 — no longer
matched what was needed. Gary: *"I'm still not clear on the objective of this card."* Fair;
the objective had drifted since it was written, and leaving that stale is the same failure
fixed on the roadmap this morning.

Restated with the BD date, **Group 1 marked the live slice**, the other fourteen
**deferred, not abandoned**. Ten-minute edit, done before any implementation.

### FEAT-021 vs TECH-082 — not a conflict

The 2026-09-03 note called them *"competing mechanisms for the same concept."* Reading both
in full says otherwise:

- **FEAT-021** — dotted ids (`FEAT-021.1`) for **tight coupling**: children live and die
  with the parent, move together, count as **one** WIP item. Its own decision table says to
  use *separate* numbering when work "can stand alone."
- **TECH-082** — a `Parent:` field for **provenance**: its motivating case is FEAT-025
  spawning TECH-068..081 — fourteen items that stand alone, are worked separately, but
  trace back.

FEAT-021 already carves out TECH-082's case. **Both adopted**, with the deciding question —
*does this make sense on its own?* — written into the template's comment header so it
travels with every card.

Also found: **FEAT-021 is largely already decided** (seven design decisions with rationale,
edge cases, WIP counting, depth limit) and the old engine already implements the mechanics
(`find_children`, parent+children auto-move). But it is written against the old framework —
`project-hub/framework/templates/`, `workflow-guide.md`, and types (`BUGFIX`, `BLOCKER`)
that no longer exist. The work was *extract what survives*, not *decide from scratch*.

### Group 1 settled, with mechanisms

| Source | Decision | Mechanism |
|---|---|---|
| FEAT-021 | Dotted ids, depth 3; `TYPE-nnn-slug.md`; ids run past 999 unpadded; one sequence per queue | `fw-next-id.sh`, `fw-new.sh`, `find_children` |
| TECH-082 | **Both** mechanisms, different jobs | `Parent:` field + the rule in the template header |
| TECH-041 | Sibling `<ID>/` bundle travels with the record | `fw-move.sh` bundle-move (inherited from ops) |
| TECH-027 | Reference by **id**, never path | `Related` section; `Depends On:` checked by the engine |
| TECH-033 | **Decided by construction** — the folder is the status | *Absence* of a `Status:` field; engine stamps `Completed:` |

**Type set not re-opened:** ADR-006 gives **FEAT, BUG, TECH, TASK, SPIKE** (amended down
from 8 on usage data, 2026-07-08). Legacy prefixes are **disk-derived, never authored** —
anything on disk outside the five is legacy by definition.

**One template, not five.** `work-item.md` serves all five types via a `Type:` field,
mirroring `ops-record.md` serving INC and REQ via `Kind:`. Five near-identical templates
would be five things to keep in sync — the ADR-008 failure this framework exists to prevent.

### Definitions confirmed (asked mid-session)

From the shipping README templates, verbatim:

- **Product** — *"created, delivered, and maintained — this workspace lives as long as the
  product does (it has a version 2)."* Requirements are **living and versioned**.
- **Project** — *"a finite initiative coordinated to completion: it reaches its goal,
  freezes, and never reopens — a follow-on is a new project."* Requirements **freeze at
  close**.

The test is lifecycle: does it have a version 2, or does it end. For BD: **an SOW is a
project named for the SOW**, and **product work always splits out** into its own workspace
from day one.

---

## Work Completed (afternoon)

### TASK-219 — reframed, Group 1 settled, moved to `doing/`

Built:
- `workspaces/framework/templates/records/work-item.md` — one template, five types
- `workspaces/framework/templates/queues/kanban/` — `backlog blocked todo doing accept
  done cancelled release`, `.limit` files (todo 10, doing 2), README carrying the flow
  and the rules

Group 2a's open questions (transitions into `cancelled/`, whether it is terminal, a board
closure code, where the 27 `deprecated/` cards live) are **not** answered by scaffolding
the folders and stay open.

---

## Decisions Made (afternoon)

7. **The BD critical path is kanban + session-history, not the three snowballed cards.**
   BUG-215's remaining UAT and TECH-177's gate work are both below the line — neither
   blocks BD.
8. **Order:** TASK-219 Group 1 → templates → FEAT-175 (`fw-new`) → kanban row in
   `fw-move.sh` → FEAT-222 → ADR-009 D5 amendment.
9. **ADR-009 D5 needs a small amendment before BD**, not after. D5 says the board crosses
   over at graduation as one atomic moment, with `kanban/` a throwaway fixture until then.
   BD is a **separate repo**, so D5's actual concern (two boards, one id namespace, in
   *this* repo) does not apply — but the text should say so rather than being contradicted
   in practice. **Not yet carded.**
10. **Group 1's five settled** with a mechanism named for each (table above).
11. **One work-item template, not five** — `Type:` field, per the `ops-record.md` precedent.

---

## Files Created (afternoon)

- `workspaces/framework/templates/records/work-item.md`
- `workspaces/framework/templates/queues/kanban/` — README, 8 folders, 2 `.limit` files

## Files Modified (afternoon)

- `project-hub/work/doing/TASK-219-*.md` — objective restated for BD; Group 1 marked live
  slice and recorded as settled; FEAT-021/TECH-082 correction; ADR-006 type set noted

## Files Moved (afternoon)

- `project-hub/work/todo/TASK-219-*.md` → `project-hub/work/doing/`

---

## Current State (end of day)

### In doing/ (2 items, at the WIP limit)
- **BUG-215** — both halves shipped; built-plugin UAT pass remains
- **TASK-219** — Group 1 settled; fourteen conventions deferred

### Next
**FEAT-175 (`fw-new`)** — now unblocked. It creates cards and scaffolds `kanban/` on first
use. Then the kanban row in `fw-move.sh`, then FEAT-222.

### Two things noted, not carded
- **The WIP counter counts `.gitkeep` and `.limit` as items** — it reported `3/2` when
  `doing/` held two cards. Harmless today, wrong at the boundary. Old engine.
- **ADR-009 D5 amendment** for BD-in-a-separate-repo (decision 9 above).

### Uncommitted, deliberately
`workspaces/framework/templates/records/contact.md` carries a `**Group:**` field added by
Gary. Unstaged from the Group 1 commit rather than buried in it.

---

**Last Updated:** 2026-09-09

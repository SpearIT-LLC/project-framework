# Task: Define the Board Conventions the New Build Is Missing

**ID:** TASK-219
**Type:** Task
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-09-02
**Workspace:** framework
**Completed:** 2026-09-10
**Theme:** Framework Consistency

---

## Objective (restated 2026-09-09 — BD deadline)

**The live objective is a work-item template so a real board can exist**, driven by the
Boston Dynamics project starting ~2026-09-28 in a fresh repo on the new framework.

That is narrower than this card's original framing (below), which aimed at unblocking
FEAT-175 with no date attached. What BD actually needs:

```
Group 1 (5 conventions) --> work-item template(s) --> FEAT-175 (fw-new)
                                                  --> kanban row in fw-move.sh
```

**Group 1 is the live slice.** The other fourteen conventions are **deferred, not
abandoned** — they keep their rows below and their source cards stay open. Nothing about
them blocks BD.

**Verified 2026-09-09, so the slice is honest:**

| Feature Gary named | State |
|---|---|
| workspaces | **built** — `fw-new-workspace`, 4 type scaffolds, UAT-01/02/05/06 |
| kb | **built** — `fw-new-kb-domain`, UAT-04/07/08/09 |
| operations | **built** — records, queue, `fw-move-ops`, `fw-troubleshoot`, UAT-14..26 |
| **kanban** | **nothing** — no folders, no template, no create, no move |
| **session-history** | **nothing** — FEAT-222 |

Scaffolding is **not** a separate init step: the create command builds its queue on first
use from `templates/queues/<ns>/` (`fw-new-ops-record.sh` does this for `operations/`), so
`fw-new` will scaffold `kanban/`. There is no `/fw-init` gap — that name belongs to an
ADR-007 discussion about a CLAUDE.md region-owner and was deliberately not filed.

---

## Summary

Sixteen board conventions exist as *analysis* on old cards and as **nothing at all** in
the ADR-009 build. This card owns them as a set: decide each convention against the new
build, write it where the new build can enforce it, and close or re-scope the source card.

It exists because the analysis currently lives in **TASK-218's C6 section — a card in
`done/`** that will move to a release archive at the next release. A live to-do list
inside a completed card is a bad home; that is the whole reason for this card.

> **Not a documentation task.** The output is a convention *plus its mechanism* — a
> template field, a script check, a hook, or an explicit "this one cannot be mechanized."
> A convention written only in prose is the failure mode ADR-008 named as Root 2.

---

## Why This Is High

**It blocks FEAT-175.** The board create gate must resolve a template per type, and the
new build ships **no work-item template of any kind** (`templates/records/` holds only
`contact.md`, `ops-record.md`, `ts-case.md`). Authoring those templates means answering
what fields a board item carries, how it is named and numbered, and how it references
other items — which is exactly this card's subject. Author the templates first and they
encode guesses.

It is also the natural companion to the **ADR-009 D5 board crossover**: the crossover
turns on the kanban namespace, and these are the rules that namespace runs by.

---

## Verified State (2026-09-02)

| Finding | Evidence |
|---|---|
| No work-item template exists | `workspaces/framework/templates/records/` = `contact.md`, `ops-record.md`, `ts-case.md` |
| The engine references a concept nothing defines | `fw-move.sh:6` treats **"child items"** as grouping that moves with its parent — but no card, doc, or script defines what a child item *is* |
| No never-delete policy | No match for a never-delete/archive-only rule in the new build's `CLAUDE.md`, `README.md`, or scripts — TASK-218 followed it anyway, from habit |
| No release tooling | `workspaces/framework/tools/` holds only `install-git-hooks.sh` and `pre-commit` |
| `meetings/` scaffolded, no template | `templates/workspaces/{floor,operations}/meetings/` exist; no meeting-record template ships |
| Kanban namespace inactive | `fw-move.sh:15-17` — the policy slot exists; the board crosses over at ADR-009 D5 |

---

## The Five (Group 1)

> **Split 2026-09-10.** This card originally owned nineteen conventions across five
> groups. The fourteen that did not block the work-item template moved to **TASK-223**;
> this card keeps the five that did, and closes on them. Gary: *"I'm thinking we're making
> our cards too large."* One acceptance block covering nineteen decisions meant the five
> that shipped could not be closed until the least urgent of the other fourteen was done.

**Source card** holds the analysis; this card holds the decision and the mechanism.

### Group 1 — Blocks the work-item template (and therefore FEAT-175)

> **Read before starting: FEAT-021 and TECH-082 are complementary, not competing.**
> The 2026-09-03 note (repeated in the roadmap) called them "competing mechanisms for the
> same concept." Reading both on 2026-09-09 says otherwise:
>
> - **FEAT-021** — dotted ids (`FEAT-021.1`) for **tight coupling**: children live and die
>   with the parent, move together, count as **one** WIP item. Its own decision table says
>   to use *separate* numbering when work "can stand alone" or "might be referenced
>   independently."
> - **TECH-082** — a `Parent:` field for **provenance**: its motivating case is FEAT-025
>   spawning TECH-068..081, fourteen items that stand alone, are worked separately, but
>   should trace back.
>
> FEAT-021 already carves out TECH-082's case. Likely outcome: **adopt both**, with a
> written rule for which applies when. Confirm at implementation rather than treating it
> as a fight to settle.
>
> **FEAT-021 is largely already decided** — seven design decisions with rationale, edge
> cases, WIP counting, depth limit, file naming — and the old engine already implements
> the mechanics (`find_children`, parent+children auto-move). **But it is written against
> the old framework**: `project-hub/framework/templates/`, `workflow-guide.md`, and types
> (`BUGFIX`, `BLOCKER`) that no longer exist. The work is *extract what survives and
> re-scope*, not *decide from scratch*.
>
> **Type set is settled — do not re-open it.** ADR-006 (Accepted 2026-07-07, amended
> 2026-07-08): **FEAT, BUG, TECH, TASK, SPIKE**. Reduced from 8 on usage data. Legacy
> prefixes are **disk-derived, never authored** — anything on disk outside the accepted
> five is legacy by definition, recognized for parsing, never offered for creation. Only a
> fixed spelling-alias map ships (FEATURE→FEAT, BUGFIX→BUG, DOC→DOCS, TECHDEBT→TECH).


| Source | Convention to settle |
|---|---|
| FEAT-021 | Numbering + naming: filename shape, hierarchical sub-ids (`FEAT-042.1`), depth limit, ID exhaustion. `fw-next-id.sh` implements a *sequence*; nothing defines the naming rules around it |
| TECH-082 | Parent/child work items — the definition `fw-move.sh:6` already assumes |
| TECH-041 | Supporting files sharing a parent ID. The new build's artifact bundle (`<ID>/`, moves with its record) is the same problem already half-solved for ops — decide whether board items inherit it verbatim |
| TECH-027 | Cross-reference convention for items that move between folders (a link by path breaks on every move) |
| TECH-033 | Status field vs. folder. The new build **chose** location-is-status; this card is the analysis behind that and the record of what `Status:` is for, if anything. Likely closes as *decided-by-construction* with the rationale written down |

### Group 1 — SETTLED 2026-09-09

Each of the five, with its mechanism. **Mechanism is the test this card is held to**, so
each row names where the rule is enforced, not just where it is described.

| Source | Decision | Mechanism |
|---|---|---|
| **FEAT-021** numbering/naming | Dotted ids `TYPE-nnn.m`, max depth 3. Filename `TYPE-nnn-slug.md`, uppercase prefix matching the `ID:` field. Ids run past 999 without padding (`FEAT-1000`). One shared sequence per queue. | `fw-next-id.sh` (sequence); `fw-new.sh` (filename shape — FEAT-175); `fw-move.sh` `find_children` (dotted children travel with the parent) |
| **TECH-082** parent/child | **Both mechanisms adopted, different jobs.** Dotted id = tight coupling, child dies with the parent, counts as *one* WIP item. `Parent:` field = provenance, child stands alone and counts as its *own* WIP item. Rule: *does this make sense on its own?* Yes → `Parent:`. No → dotted. | `Parent:` field in `templates/records/work-item.md`, with the rule stated in the template's own comment header so it travels with every card |
| **TECH-041** supporting files | A sibling folder named for the id (`FEAT-nnn/`) holds working material and moves with the record — same convention operations already uses for `INC-nnn/`. | `fw-move.sh` bundle-move (already implemented for ops; kanban inherits it via the policy table) |
| **TECH-027** cross-references | Reference by **id**, never by path. A path breaks on every move; an id survives. `Related` entries say *how* it relates. | `templates/records/work-item.md` — `Related` section; `Depends On:` is id-based and checked by `fw-move.sh` |
| **TECH-033** status vs folder | **Decided by construction: the folder is the status.** No `Status:` field on the template — a second home for status is a second thing to contradict the first. `Completed:` is stamped by the engine, not hand-written. | Absence of the field in the template; `fw-move.sh` stamps `Completed:` on `→ done` |

**Type set: FEAT, BUG, TECH, TASK, SPIKE** (ADR-006, not re-opened).

**One template, not five.** `templates/records/work-item.md` serves all five types with a
`Type:` field, mirroring `ops-record.md` serving both INC and REQ via `Kind:`. Five
near-identical templates would be five things to keep in sync — the ADR-008 failure this
framework exists to prevent.

**Built 2026-09-09:**
- `workspaces/framework/templates/records/work-item.md` — the record template
- `workspaces/framework/templates/queues/kanban/` — the queue scaffold: `backlog blocked
  todo doing accept done cancelled release` + `.limit` files (todo 10, doing 2) + README
  carrying the flow and the rules

**Still to build (FEAT-175 and the kanban policy row):** `fw-new.sh` to create cards and
scaffold `kanban/` on first use, and the kanban row in `fw-move.sh` wired to real
transitions and gates.

> **Note on `accept/` and `cancelled/`:** the scaffold includes both, per the authored
> repo-structure diagram. Group 2a's remaining questions (transitions into `cancelled/`,
> whether it is terminal, a board closure code, where the 27 `deprecated/` cards live)
> are **not** answered by scaffolding the folders and stay open below.

---

## Approach

**The five interlock and were settled as a single session** — numbering constrains
sub-items, which constrain cross-references, which constrain the template's fields. That
is why they were the slice worth taking first, and why they could not be taken
individually. The other fourteen could, and are now TASK-223.

For each convention:

1. **Decide it against the new build**, not the old one. The source card's analysis is
   input; its paths and file targets are not.
2. **Give it a mechanism** — a template field, a script check, a hook, or an explicit
   statement that it is one of the rules that cannot be mechanized.
3. **Close the source card.** If the convention is now defined and mechanised, the source
   card is done — record the outcome in it and move it to `done/`, or archive it with a
   closing note if it turned out to be superseded.

**A convention that is decided but written only in prose is not finished.** That is the
test this card is held to.

---

## Acceptance Criteria

- [x] Group 1's five are settled **before** any work-item template is authored *(2026-09-09)*
- [x] Each of the five has a recorded outcome **with its mechanism named**, not just a
      decision *(2026-09-09 — see the settled table above)*
- [x] A work-item template exists for the accepted types and encodes the Group 1
      conventions — unblocking FEAT-175 *(2026-09-09: one template, `Type:` field)*
- [x] The kanban queue scaffold exists alongside the operations one *(2026-09-09)*
- [x] The remaining fourteen conventions have a home — **TASK-223** *(2026-09-10)*
- [x] Plugin CHANGELOG updated *(2026-09-09)*

> **The five source cards** (FEAT-021, TECH-082, TECH-041, TECH-027, TECH-033) remain in
> `todo/`. Their conventions are settled and recorded here; closing them is bookkeeping
> that does not block anything, and is carried by **TASK-223**'s "every source card is
> closed" criterion.

## Implementation Checklist

- [x] **PRE-IMPLEMENTATION REVIEW** — confirm the grouping, confirm Group 1 goes first
- [x] Group 1 (FEAT-021, TECH-082, TECH-041, TECH-027, TECH-033) — decide as a set *(2026-09-09)*
- [x] Author the work-item template(s) from Group 1's outcome *(2026-09-09)*
- [x] Split the remaining fourteen to TASK-223 *(2026-09-10)*
- [x] Plugin CHANGELOG *(2026-09-09)*

## Documentation

| Surface | What it must say |
|---|---|
| Work-item template(s) | the conventions, encoded as structure rather than described |
| The new build's `CLAUDE.md` or an ADR | the rules that cannot be mechanized (never-delete, `fw-` namespace) |
| Plugin CHANGELOG | that board conventions are defined and what changed |

---

## Related

- **TASK-218** (done) — its **Section C6** holds the per-card analysis and the four
  verified findings. **Read it before starting.** This card exists so that content does
  not stay stranded in a completed card bound for a release archive.
- **FEAT-175** — the board create gate. **Blocked by Group 1**; it names these five cards
  as a prerequisite.
- **ADR-009 D5** — the board crossover these conventions govern.
- **ADR-008** — Root 2 (*invariants written as prose degrade silently*) is why every
  convention here needs a mechanism, not just a decision.
- **ADR-006** — the work-item type taxonomy; the conventions here sit around it, not on it.
- **TASK-223** — the fourteen conventions split out of this card on 2026-09-10.
- **FEAT-221** — unattended batch implementation. **Blocked by this card's Group 2**
  (`accept/`). Its children FEAT-221.1/.2/.3 carry the gate change, the command, and the
  ADR-001 amendment respectively.

---

**Last Updated:** 2026-09-10

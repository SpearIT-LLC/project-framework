# Task: Define the Board Conventions the New Build Is Missing

**ID:** TASK-219
**Type:** Task
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-09-02
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->
**Theme:** Framework Consistency

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

## The Sixteen

Grouped by what they block. **Source card** holds the analysis; this card holds the
decision and the mechanism.

### Group 1 — Blocks the work-item template (and therefore FEAT-175)

| Source | Convention to settle |
|---|---|
| FEAT-021 | Numbering + naming: filename shape, hierarchical sub-ids (`FEAT-042.1`), depth limit, ID exhaustion. `fw-next-id.sh` implements a *sequence*; nothing defines the naming rules around it |
| TECH-082 | Parent/child work items — the definition `fw-move.sh:6` already assumes |
| TECH-041 | Supporting files sharing a parent ID. The new build's artifact bundle (`<ID>/`, moves with its record) is the same problem already half-solved for ops — decide whether board items inherit it verbatim |
| TECH-027 | Cross-reference convention for items that move between folders (a link by path breaks on every move) |
| TECH-033 | Status field vs. folder. The new build **chose** location-is-status; this card is the analysis behind that and the record of what `Status:` is for, if anything. Likely closes as *decided-by-construction* with the rationale written down |

### Group 2 — Board lifecycle policy

| Source | Convention to settle |
|---|---|
| TECH-044 | Creation policy — create in `backlog/`, promote when committed |
| TECH-077 | Never-delete / archive-only. **Write it down and back it with a check**; TASK-218 honoured an unwritten rule |
| TECH-078 | Release archival — `done/` items to `history/releases/vX.Y.Z/`. No release tooling exists yet |
| FEAT-030 | A hold/paused state for board items. Operations has `onhold/`; kanban has no equivalent defined |

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

## Approach

**Do not do all sixteen at once.** Group 1 is the blocker and should go first as a single
session — the five interlock (numbering constrains sub-items, which constrain
cross-references, which constrain the template's fields). The others can follow
individually.

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

- [ ] Every one of the sixteen has a recorded outcome: **defined** (with its mechanism),
      **decided-by-construction** (with the rationale written down), or **dropped** (with
      the reason)
- [ ] Group 1's five are settled **before** any work-item template is authored
- [ ] A work-item template exists for the accepted types and encodes the Group 1
      conventions — unblocking FEAT-175
- [ ] The never-delete rule (TECH-077) is written down and backed by a check, not habit
- [ ] The `fw-` namespace rule (DECISION-171) is recorded where a future contributor will
      find it
- [ ] Every source card is closed, moved to `done/`, or archived with a closing note —
      none is left open describing a convention that is now defined
- [ ] Plugin CHANGELOG updated

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->

- [ ] **PRE-IMPLEMENTATION REVIEW** — confirm the grouping, confirm Group 1 goes first,
      and confirm sequencing against the D5 crossover and FEAT-175
- [ ] Group 1 (FEAT-021, TECH-082, TECH-041, TECH-027, TECH-033) — decide as a set
- [ ] Author the work-item template(s) from Group 1's outcome
- [ ] Group 2 — board lifecycle policy + mechanisms
- [ ] Group 3 — process and collaboration
- [ ] Group 4 — the two missing templates
- [ ] Group 5 — record the `fw-` namespace rule
- [ ] Close each source card
- [ ] Plugin CHANGELOG

---

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

---

**Last Updated:** 2026-09-02

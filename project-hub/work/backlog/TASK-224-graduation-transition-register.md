# Task: Graduation Transition Register — Deferred Items for the D5 Crossover

**ID:** TASK-224
**Type:** Task
**Priority:** Medium
**Version Impact:** None
**Created:** 2026-09-10
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->
**Theme:** Framework Consistency

---

## Summary

**The register of things deliberately deferred to graduation.** ADR-009 D5 describes the
crossover as *"a single atomic moment"* and ADR-009:342 lists what its one commit does —
but nothing owns the debt that accumulates *between now and then*. This card is that
owner: a running list, added to as the build turns up old-tree artifacts that are wrong,
dead, or misleading but not worth fixing before the old tree is deleted anyway.

**Why a card and not a note in an ADR:** the board is where we already look. A deferral
filed in an ADR requires remembering to reread that ADR; a card surfaces in `/fw-status`,
`/fw-backlog` and every board sweep. *(Gary, 2026-09-10: "in a year from now how do I
find it?")*

---

## How to use this card

**Adding:** when you decide "not worth fixing until the old tree goes," add a row below
with the date, what is wrong, and — critically — **why deferring is safe**. A row without
that reason is indistinguishable from something forgotten.

**At graduation:** work the table top to bottom. Most rows should resolve to *"deleted
with the old tree, nothing to do"* — that is the expected outcome and the reason
deferring was correct. Rows that do *not* self-resolve are the real work.

**This card does not gate anything.** It is a register, not a blocker. If an item becomes
urgent, promote it to its own card and strike it here.

---

## Register

### 1. ADR-006 D4/D5 name a superseded SoT location and mechanism

*(Added 2026-09-10, from FEAT-175.)*

- **D4** decides *"one authored source; the build derives each channel's copy"*
  (`Build-Plugin.ps1` generating the plugin editions' copies).
- **D5** names the shipped file as `.claude/scripts/work-item-types.txt`.

**Both are now false.** The framework **is** the plugin (ADR-009 D3), so there is one copy
by construction and nothing to derive — the same collapse that removed FEAT-179 and
SPIKE-178 from FEAT-175's dependencies. And the accepted-type set now lives in the
`TYPES:` block of `workspaces/framework/templates/records/work-item.md`, not in a
standalone file.

**Why deferring is safe:** ADR-006's *taxonomy* decisions (D1 five types, D2 disk-derived
legacy, D6 create-path enforcement) are all still correct and are what anyone actually
reads the ADR for. Only the location/mechanism half of D4/D5 is stale, and the file it
names is old-tree — it disappears in the deletion commit regardless.

**At graduation:** amend D4/D5 with a dated note in the ADR's existing amendment style,
recording that the SoT moved into the template *because a new type needs a template that
serves it* (making the coupling structural rather than remembered), that the marked block
is stripped from created cards so no card becomes a stale copy, and that D4's derivation
mechanism is moot. Do **not** restate the type list itself.

### 2. `.claude/scripts/work-item-types.txt` is a dead SoT

*(Added 2026-09-10, from FEAT-175. Related to row 1.)*

Verified 2026-09-10: **nothing reads it.** It was consumed by the old `/fw-new`, which the
ADR-009 build replaced. It still lists the same five types, so it is a stale second copy
of a list that now lives in the template — exactly the pattern ADR-008 exists to prevent.

**Why deferring is safe:** it is old-tree, does not ship, and has no reader, so it cannot
mislead the *running* system — only a human browsing the old tree. It is deleted with
`.claude/` at graduation.

**At graduation:** deleted with the old tree. Nothing to do beyond confirming row 1's
amendment carries its header rationale (the "legacy is disk-derived, nothing to ship"
reasoning) into ADR-006, since that reasoning is worth keeping and the file is where it
currently reads best.

### 3. `fw-move.sh` kanban transitions and gates are not ported

*(Added 2026-09-10, from FEAT-175. This one does NOT self-resolve.)*

`workspaces/framework/scripts/fw-move.sh` declares the `kanban` namespace and its folder
set, but its transitions and gates (dependency check, acceptance-criteria done-gate,
ripeness review at `→ doing`) are not ported — the script's own header says so, and moving
a created card reports *"declared but not active."* `fw-next-id.sh` likewise refuses the
`kanban` namespace until `kanban/` exists.

**Why deferring is safe:** the create side (FEAT-175) and the move side are independent,
and the folder set `/fw-new` produces matches what the engine already declares, so the
crossover stays a table edit rather than a second engine. The live board still runs on the
old root `/fw-move`.

**At graduation:** this is **real work, not cleanup** — it must land *with or before* the
`git mv project-hub/work/* kanban/` commit, or the crossover produces a board with no
working move engine. Size it properly when it is promoted.

---

## Acceptance Criteria

- [ ] Every row is resolved at graduation — actioned, or confirmed as deleted-with-the-old-tree
- [ ] Row 1: ADR-006 D4/D5 amended, without restating the type list
- [ ] Row 3 is promoted to its own card and sequenced **before** the board crossover commit
- [ ] No row is closed silently — each gets a one-line outcome

---

## Notes

**Deliberately not a blocker.** Registers that gate things get worked around; registers
that merely accumulate get read. If something here needs to block, it should be its own
card.

**Not everything deferred belongs here.** This is for *old-tree debt that graduation
resolves by deletion*. Ordinary "later" work is a normal backlog card — filing it here
would dilute the list until it stops being read, which is the failure mode this card is
guarding against.

---

## Related

- **ADR-009 D5** — the crossover this register serves; ADR-009:342 lists what the
  graduation commit does.
- **ADR-006 D4/D5** — the stale decisions in row 1.
- **ADR-008** — the Single-Source Rule that makes rows 1 and 2 worth recording rather
  than shrugging at.
- **FEAT-175** — the card that turned up all three rows.
- **TASK-218** — the disposition pass over old-tree cards; same "the old tree is going
  away" reasoning applied to work items rather than artifacts.

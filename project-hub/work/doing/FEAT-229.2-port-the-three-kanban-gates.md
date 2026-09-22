# Feature: Port the Three Kanban Gates, Checkbox-Aware From the Start

**ID:** FEAT-229.2
**Type:** Feature
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-09-22
**Workspace:** framework
**Depends On:** FEAT-229.1 (the namespace must be live for a gate to attach to)
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

Port the dependency gate and the acceptance-criteria gate into the ADR-009 engine, and add WIP
warnings. **Both gates are written checkbox-aware and defect-free the first time** — TECH-177's
contract, and the two known bugs in the old engine's versions that must not be carried across.

**This is where the judgment sits**, which is why it is its own card. FEAT-229.1 is a table
edit; this is three behaviours with a specification behind each.

## Current State (verified 2026-09-22)

**The new engine has none of this.** `workspaces/framework/scripts/fw-move.sh` is 263 lines,
five functions (`die`, `row`, `fail_item`, `gmv`, `move_one`): **zero** hits for `limit`, no
acceptance-criteria logic, no dependency check.

**That is the opportunity.** Writing fresh means not inheriting two defects the old engine
has carried for months (below). Neither is a dependency — they are old-engine bugs in code
being retired — but both are **warnings about what not to write**.

## Scope

### 1. The dependency gate (`→ doing`)

Reads `Depends On:`, verifies each named card is in `done/`, refuses otherwise **naming the
dependency's current folder**. Not bypassable by `--force` (old engine `check_dependencies`).

### 2. The acceptance-criteria gate (`→ done`) — with TECH-177's contract

**The contract is authored in `workspaces/framework/skills/fw-checkbox-states/SKILL.md`
(TECH-177, done 2026-09-22). Implement it; do not restate it (ADR-008).**

- `[ ]` **and** `[/]` block `→ done`
- `[x]` and `[-]` pass — **`[-]` by design**, not by the accident of a grep that only counts
  unchecked boxes
- `[?]` and `[h]` block `→ doing`, **naming the marked line and its note**
- Readiness (`→ todo`/`backlog`/`blocked`) unchanged: only `[ ]` blocks
- **The ADR-007 D7 boundary is documented where the gate lives** — a marker records an event
  that happened; it is not a ripeness judgment. Without this the next reader takes these
  markers as a general ripeness gate and D7 is quietly overturned.

**⚠️ Do not inherit TECH-166 item 4.** The old `check_acceptance_criteria` greps `- \[ \]`
**unanchored across the whole file**, so prose *quoting* a marker counts as a live unchecked
criterion — and the check ignores `--force`, so it is a hard block.

> **This is not theoretical: it blocked TECH-177 on 2026-09-22.** Line 33 of that card —
> historical prose inside backticks, describing the very problem the card fixes — was counted
> as an unchecked criterion. The only way through was **rewording a true sentence in the
> record to satisfy a faulty grep**, which is the dishonest-`[x]` failure TECH-177 exists to
> end. Filed as TECH-166 item 4 on **2026-07-02**; still open.

**The fix, per TECH-166's own prescription:** count checkboxes in the **Acceptance Criteria
section only**, or exclude fenced/inline-code and table-cell content.

### 3. WIP warnings

Loud on a move *into* an over-limit folder, **never blocking** (`kanban§5`). The limit is read
from the folder's `.limit` file — per-folder data the gate reads, not a constant.

**⚠️ Do not inherit BUG-240 either — the count is of *work items*, not files.** A dotted
family (`FEAT-229` + `.1/.2/.3`) is **one** WIP item (TASK-219 Group 1), not four. The old
engine has never collapsed dotted ids; the convention was settled 2026-09-09 and left a
paragraph. Collapse to the base id, then count distinct. A `Parent:`-field child has no dotted
suffix and correctly still counts as its own item.

**⚠️ Do not inherit BUG-174.** The old engine's count excludes `.limit` but **not `.gitkeep`**,
inflating every count by one. Verified 2026-09-22: `doing/` reported 3/2 holding **two** cards.
The kanban scaffold ships `.gitkeep` in every folder and `.limit` in `todo/`+`doing/`, so a
naive `find -type f` is wrong from day one. **Exclude all dotfiles.**

### Ripeness stays a judgment

**Never claimed as a script check** (ADR-007 D7). Enforced behaviourally by the command's
pre-implementation review, not by `grep`.

## Out of Scope

- **`accept/` and `cancelled/`** — FEAT-229.3.
- **Fixing BUG-174 / TECH-166 in the old engine.** They are Low/Medium in `backlog/`, and the
  old engine retires at the D5 crossover. **If this card gets them right, both become
  old-engine-only defects with a shelf life** — worth noting on those cards so nobody works
  them twice.
- **Terminal-state archival** (spikes to `history/spikes/`) — belongs with the terminal-state
  work in FEAT-229.3, since `cancelled/` is one of the terminals.

## Acceptance Criteria

- [ ] The dependency gate refuses `→ doing` when a `Depends On:` card is not in `done/`, naming
      that card's current folder; `--force` does not bypass it
- [ ] The acceptance gate implements TECH-177's contract exactly: `[ ]`/`[/]` block `→ done`,
      `[x]`/`[-]` pass, `[?]`/`[h]` block `→ doing` naming the marked line **and its note**,
      readiness unchanged
- [ ] **The checkbox scan is scoped to the Acceptance Criteria section** (or excludes
      inline-code and table content) — a card quoting `- [ ]` in prose moves to `done/`
      without being reworded. **Regression fixture: TECH-177's own line 33 case**
- [ ] **Counts exclude all dotfiles** — a folder holding two cards plus `.gitkeep` and `.limit`
      reports 2, not 3 or 4 (**BUG-174**)
- [ ] **Counts collapse dotted ids to their base** — a folder holding `FEAT-229` + `.1/.2/.3`
      plus one standalone card reports **2**, not 5 (**BUG-240**). The limit warning and the
      final count use **one** implementation, not two
- [ ] **A family move is gated as a family** (**BUG-239**): the dependency and acceptance gates
      run against **every member**, not only the named item, and a refusal names the
      responsible child. Tight coupling is preserved — no partial family move.

      > **Observed live on 2026-09-22 while moving this card's own family:** FEAT-229.3
      > declares `Depends On: TASK-223` (in `backlog/`) and entered `doing/` unchallenged,
      > because gates run at `fw-move.sh:336` on the named item while children are collected
      > at `:392` inside the move. BUG-239 carries the design question — a family's
      > dependencies are the union of its members', and the refusal must name which member.
- [ ] The WIP warning fires on a move *into* an over-limit folder and **never blocks**
- [ ] The ADR-007 D7 boundary is documented where the gate lives, not only on a card
- [ ] Ripeness is **not** claimed as a script check anywhere
- [ ] One engine serves both namespaces — no kanban-specific copy of the gate logic, verified
      at the call sites
- [ ] Validated: **AI** — each of the six checkbox states exercised against a seeded fixture,
      plus each gate's refusal · **Human** — a `[-]` criterion moves to `done/` and a `[/]`
      criterion is blocked, against the **installed plugin**, not the source tree (TECH-188).
      *(Moved from TECH-177 on 2026-09-22: validating the contract is part of implementing it.)*

## Related

- **FEAT-229** — parent · **FEAT-229.1** — the live namespace this attaches to.
- **TECH-177** (done 2026-09-22) — the authored contract. `skills/fw-checkbox-states/SKILL.md`.
- **TECH-166 item 4** — the unanchored checkbox grep. **Must not be inherited.**
- **BUG-174** — the dotfile count inflation. **Must not be inherited.**
- **BUG-240** — the WIP count does not collapse dotted ids to their base. **Must not be
  inherited**; TASK-219 settled the rule and never mechanized it.
- **BUG-239** — dotted children bypass every gate. **Carries the design question this card must
  answer** before writing the gates.
- **ADR-007 D7** — the ripeness boundary · **ADR-008** — why the contract is pointed at, not
  restated.

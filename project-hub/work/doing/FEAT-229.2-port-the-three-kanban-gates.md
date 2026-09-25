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

**⚠️ Do not inherit BUG-174.** The old engine's count excludes `.limit` but **not `.gitkeep`**,
inflating every count by one. Verified 2026-09-22: `doing/` reported 3/2 holding **two** cards.
The kanban scaffold ships `.gitkeep` in every folder and `.limit` in `todo/`+`doing/`, so a
naive `find -type f` is wrong from day one. **Exclude all dotfiles.**

### Ripeness stays a judgment

**Never claimed as a script check** (ADR-007 D7). Enforced behaviourally by the command's
pre-implementation review, not by `grep`.

## Out of Scope

- **`accept/` and `cancelled/`** — FEAT-229.3.
- **Dotted-id family semantics** — **FEAT-229.4**, split out 2026-09-22. Gating a family per
  member (**BUG-239**) and collapsing a family to one WIP item (**BUG-240**) both require
  addressable members, which **BUG-241** shows the engine does not have. Keeping them here
  would have made this card depend on an unfixed bug — the hidden-dependency pattern TECH-237
  exists to stop, hit for the third time in one session.

  **What this costs, stated plainly:** the WIP warning ships counting a dotted family as N
  rather than 1, so it over-warns until .4 lands. Cosmetic — the limit is warning-only — and
  it is the behaviour today regardless.

  **Every fixture this card validates against is flat** (FEAT-901…FEAT-911, no dots), so
  nothing here is left untested by the split.
- **Fixing BUG-174 / TECH-166 in the old engine.** They are Low/Medium in `backlog/`, and the
  old engine retires at the D5 crossover. **If this card gets them right, both become
  old-engine-only defects with a shelf life** — worth noting on those cards so nobody works
  them twice.
- **Terminal-state archival** (spikes to `history/spikes/`) — belongs with the terminal-state
  work in FEAT-229.3, since `cancelled/` is one of the terminals.

## Acceptance Criteria

- [x] The dependency gate refuses `→ doing` when a `Depends On:` card is not in `done/`, naming
      that card's current folder; `--force` does not bypass it
- [x] The acceptance gate implements TECH-177's contract exactly: `[ ]`/`[/]` block `→ done`,
      `[x]`/`[-]` pass, `[?]`/`[h]` block `→ doing` naming the marked line **and its note**,
      readiness unchanged
- [x] **The checkbox scan is scoped to the Acceptance Criteria section** (or excludes
      inline-code and table content) — a card quoting `- [ ]` in prose moves to `done/`
      without being reworded. **Regression fixture: TECH-177's own line 33 case**
- [x] **Counts exclude all dotfiles** — a folder holding two cards plus `.gitkeep` and `.limit`
      reports 2, not 3 or 4 (**BUG-174**)
- [x] The limit warning and the final count use **one** implementation, not two
- [x] The WIP warning fires on a move *into* an over-limit folder and **never blocks**
- [x] The ADR-007 D7 boundary is documented where the gate lives, not only on a card
- [x] Ripeness is **not** claimed as a script check anywhere
- [x] One engine serves both namespaces — no kanban-specific copy of the gate logic, verified
      at the call sites
- [h] Validated: **AI** — each of the six checkbox states exercised against a seeded fixture,
      plus each gate's refusal · **Human** — a `[-]` criterion moves to `done/` and a `[/]`
      criterion is blocked, against the **installed plugin**, not the source tree (TECH-188).
      *(Moved from TECH-177 on 2026-09-22: validating the contract is part of implementing it.)*
      **Hold:** AI half done 2026-09-23 (see FEAT-229 parent); the **Human** half needs the
      installed plugin — one publish cycle shared with the family.

## Related

- **FEAT-229** — parent · **FEAT-229.1** — the live namespace this attaches to.
- **TECH-177** (done 2026-09-22) — the authored contract. `skills/fw-checkbox-states/SKILL.md`.
- **TECH-166 item 4** — the unanchored checkbox grep. **Must not be inherited.**
- **BUG-174** — the dotfile count inflation. **Must not be inherited.**
- **FEAT-229.4** — dotted-id family semantics (**BUG-239**, **BUG-240**, **BUG-241**). Takes
  the family half of the gate work; depends on this card, not the reverse.
- **ADR-007 D7** — the ripeness boundary · **ADR-008** — why the contract is pointed at, not
  restated.


---

## Validation Run — 2026-09-22

Scratch repo, `--root`, fixtures from the generalized seeder. **Every branch of TECH-177's
contract exercised.**

| Case | Fixture | Expect | Result |
|---|---|---|---|
| All criteria `[x]` | FEAT-906 | move | ✅ exit 0 |
| `[/]` in progress | BUG-907 | **block** | ✅ *"0 unchecked, 1 in progress: both block → done/"* |
| `[-]` cancelled | TECH-908 | **pass by design** | ✅ exit 0 |
| Marker quoted in prose | FEAT-911 | **pass** (TECH-166 item 4) | ✅ exit 0 |
| `[?]` question | TASK-909 | block `→ doing`, name line + note | ✅ line and `**Question:**` both printed |
| `[h]` hold | SPIKE-910 | block `→ doing`, name line + note | ✅ line and `**Hold:**` both printed |
| Dep in `backlog/` + dep in `done/` | FEAT-904 | block, **name only the unmet one** | ✅ *"depends on TECH-903 (currently in backlog/)"* |
| Dep in `done/` only | FEAT-904 | move | ✅ exit 0 |
| `doing/` at 2 cards + 2 dotfiles, limit 2 | — | warn **2/2**, not 4/2 | ✅ warns and **still moves** |

**The FEAT-911 row is the one that matters most.** That fixture is the exact shape that
hard-blocked TECH-177 this morning: a marker quoted in prose, counted as a live criterion by a
whole-file grep. It now moves cleanly — **TECH-166 item 4 is not inherited.**

**Operations regression — clean, 5 cases.** `901→onhold` ✅ · `901→closed --resolution` ✅ ·
`906` terminal→open refused ✅ · `903→closed` with no code refused ✅ · a batch of three with
one bad id reported `moved: 2 skipped: 0 failed: 1`, exit 1, bundle inline ✅.

**Operations takes no gates** (`operations_GATES=""`) — a record there has no acceptance
criteria and no dependencies, and its one policy (a resolution code on `→ closed`) writes
stamps rather than merely refusing, so it stays in `move_one`.

### Design notes worth keeping

**Gates are data, not an if-chain.** `kanban_GATES="gate_dependencies gate_markers
gate_acceptance"` sits in the policy table beside `kanban_TRANSITIONS`, for the same reason:
policy belongs in the table. Adding a gate to a namespace is a row edit.

**All gates run; the move is refused once.** One invocation names *every* reason, rather than
making the user fix one thing and run again.

**Gates run after the transition check.** An illegal transition is a usage error and its
message is the useful one — listing unmet dependencies for a move that could never have
happened is noise.

**The WIP warning fires once per invocation, not per record.** A batch of three into an
over-limit folder is one situation a human is being told about, not three.
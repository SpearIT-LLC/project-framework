# Feature: Acceptance-Criteria Gate Fires on Either Exit From `doing/`

**ID:** FEAT-221.1
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-09-07
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->
**Theme:** Workflow

**Depends On:** TASK-219 (Group 2 — the `accept/` state must exist first)

---

## Summary

The acceptance-criteria hard block currently fires only on `→ done`. Once `accept/`
exists, `doing → accept` becomes a second exit from `doing/` and must carry the same
gate. `accept → done` must **not** carry it.

---

## Problem Statement

Today `.claude/scripts/fw-move.sh` blocks `→ done` when the item has unchecked `[ ]`
acceptance criteria. With `accept/` inserted, that single check sits at the wrong
boundary:

- `doing → accept` — **AI claims the work is complete.** This is the claim worth
  gating. Ungated, a card with half its criteria unchecked reaches the user for UAT.
- `accept → done` — **the human already said yes.** Gating here lets `grep` overrule a
  human acceptance decision, which inverts the authority.

**The rule:** the gate belongs on *exit from `doing/`*, not on *entry to `done/`*.

`doing → done` remains valid and keeps the gate — see Design Notes.

---

## Design Notes

**`doing → done` stays a valid transition.** `accept/` is optional, not mandatory.
Gary, 2026-09-07: *"doing --> done is still a valid workflow."* A solo developer who
is both implementer and acceptor does not need a UAT hop for every card. The gate must
therefore fire on **both** `doing → accept` and `doing → done`.

**Restating the gate placement:**

| Transition | Acceptance-criteria gate | Why |
|---|---|---|
| `doing → done` | ✅ enforced | Work claimed complete (existing behaviour, unchanged) |
| `doing → accept` | ✅ enforced (new) | Work claimed complete, awaiting someone else |
| `accept → done` | ❌ not enforced | Human acceptance already given; grep does not overrule it |
| `accept → doing` | ❌ n/a | Refine loop, returning to work |

**Implementation shape:** the check is currently keyed on the target folder. It should
be keyed on the **source** folder being `doing/` instead, which makes it correct for
both exits by construction rather than by enumerating targets.

---

## Scope

New ADR-009 build (`workspaces/framework/`) only. The old `.claude/scripts/fw-move.sh`
is in maintenance and does not get `accept/`.

**Note:** the new build has no board engine yet — its `fw-move.sh` handles the
`operations/` namespace only (verified 2026-09-07). This card lands whenever the board
crosses over per ADR-009 D5; it does not force that crossover.

---

## Acceptance Criteria

- [ ] Gate fires on `doing → accept` with unchecked criteria (hard block, exit 1)
- [ ] Gate fires on `doing → done` with unchecked criteria (unchanged behaviour)
- [ ] Gate does **not** fire on `accept → done`
- [ ] Gate does **not** fire on `accept → doing`
- [ ] The check is keyed on source folder `doing/`, not on a list of targets
- [ ] Transition matrix documentation reflects the gate placement
- [ ] Plugin CHANGELOG updated

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->

- [ ] **PRE-IMPLEMENTATION REVIEW COMPLETED**
- [ ] Move the gate from target-keyed to source-keyed
- [ ] Verify all four rows of the table above
- [ ] Documentation updated
- [ ] Plugin CHANGELOG updated

---

## Related

- **FEAT-221** — parent
- **TASK-219** — owns `accept/` itself
- `.claude/scripts/fw-move.sh` — the old engine, for reference only (not modified)

---

**Last Updated:** 2026-09-07

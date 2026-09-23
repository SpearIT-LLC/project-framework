# Bug: The New Engine Cannot Address a Dotted Child, and Silently Moves the Parent Instead

**ID:** BUG-241
**Type:** Bug
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-09-22
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

`workspaces/framework/scripts/fw-move.sh` **cannot locate a dotted child at all**, and asking
for one **silently resolves to its parent**. It also has no child-collection, so moving a
parent **splits the family**. Both behaviours are live in the ADR-009 engine today.

**This is not the old engine's BUG-239.** That one carries children *without gating* them.
This one cannot carry them, cannot address them, and acts on the wrong card without saying so.

## Bug Description

**Observed 2026-09-22 in a scratch repo, with `fw-new.sh --parent`:**

```
$ fw-new.sh FEAT parent-card            → kanban/backlog/FEAT-001-parent-card.md
$ fw-new.sh FEAT child-one --parent FEAT-001
                                        → kanban/backlog/FEAT-001.1-child-one.md

$ fw-move.sh kanban 001 todo
  OK       FEAT-001-parent-card.md → todo/

$ find kanban -name '*.md'
kanban/backlog/FEAT-001.1-child-one.md      ← LEFT BEHIND
kanban/todo/FEAT-001-parent-card.md
```

**The family split.** Then, trying to move the child by its own id:

```
$ fw-move.sh kanban FEAT-001.1 todo
  SKIPPED  FEAT-001-parent-card.md — already in todo/
exit 0
```

**It resolved `FEAT-001.1` to `FEAT-001`, reported a skip for a card the user did not name, and
exited 0.** No error, no warning.

### Mechanism (verified, `scripts/fw-move.sh:211-216`)

```bash
NUM="$(printf '%s' "$ID_IN" | grep -oE '[0-9]+$' || true)"
NUM_RE="$(printf '%s' "$NUM" | sed 's/^0*//')"
REL="$(... | grep -E "(^|/)[A-Za-z]+-0*${NUM_RE}-[^/]*\.md$" | head -1 ...)"
```

1. `[0-9]+$` on `FEAT-001.1` captures the **trailing** `1`, not `001.1`. The dotted suffix is
   the last number, so the parser takes the child index and discards the parent id.
2. `NUM_RE=1` then matches `FEAT-001-parent-card.md` via `0*1-`.
3. The locating pattern requires `-` immediately after the digits, so `FEAT-001.1-child-one.md`
   **can never match** — a dotted child is unreachable by any input.

**Two failures, one root:** the id grammar has no concept of a dotted id. `grep -c 'children'`
over the file returns **0** — there is no child handling to have a bug in.

## Impact

- **A dotted child cannot be moved.** Its only path is a manual `git mv`, around the chokepoint.
- **Asking for a child acts on the parent, silently, exiting 0.** The "SKIPPED … already in
  todo/" line names a card the user did not ask about; the wrong-target case would move one.
- **Moving a parent splits the family**, breaking the tight-coupling rule (TASK-219 Group 1:
  *the child lives and dies with the parent, moves with it*).
- **Latent, not yet damaging:** kanban is not the live board until the ADR-009 D5 crossover, and
  operations ids are never dotted. **It must be fixed before the crossover**, not after.

## Proposed Solution

**Give the id grammar a dotted form.** Sketch, not a decision:

- Parse the id as `(\d+)(\.\d+)*$` — the base number **plus** any dotted suffix — instead of the
  trailing integer.
- Locate on the full dotted id: `[A-Za-z]+-0*<base><suffix>-`.
- **An unmatched dotted id must fail loudly**, never fall back to the base. The current silent
  fallback is the worst property of this bug.
- **Child collection on a parent move** — the family moves together (BUG-239's union rule
  applies here too: gate every member, then move all or none).

## Scope

- **The new engine only.** The old engine handles children correctly for moving
  (`find_children`) — its defect is that it does not *gate* them, which is BUG-239.
- **Must land before the ADR-009 D5 crossover**, since the live board becomes kanban at that
  moment and dotted ids are in active use on it today (FEAT-229.1/.2/.3 among them).

## Acceptance Criteria

- [ ] A dotted child is addressable by its own id: `fw-move.sh kanban FEAT-001.1 todo` moves
      **that card**
- [ ] An id that matches nothing **fails**, naming the id. No silent fallback to the base id
- [ ] Moving a parent moves its children with it — the family never splits
- [ ] A child moved directly is reported as itself, never as its parent
- [ ] Depth 3 (`FEAT-001.1.1`) resolves correctly — the template permits it
- [ ] Operations is unaffected — its ids are never dotted; a regression pass proves it
- [ ] Validated: **AI** — parent move, direct child move, unmatched dotted id, and a depth-3
      id, each against a seeded fixture · **Human** — the same against the **installed plugin**

## Related

- **BUG-239** — dotted children bypass the **gates**. Same family semantics, different engine
  and different failure: there, children move ungated; here, they cannot move at all.
  **Fix together** — both are answered by "gate every member, then move all or none."
- **BUG-240** — the WIP count does not collapse dotted ids. The third member of the same
  family-semantics gap.
- **TASK-219 Group 1** — the tight-coupling rule this violates.
- **FEAT-229.2** — ports the gates. **This bug is in its path:** a gate that runs per-member
  needs members to be addressable first.
- **BUG-215** — established "only the number is used to locate the record", the simplification
  this bug is the cost of. Correct for operations; incomplete for a namespace with dotted ids.

---

## FIXED — 2026-09-22 (FEAT-229.4)

**All three failures are fixed** in `workspaces/framework/scripts/fw-move.sh`:

- The id grammar parses `[0-9]+(\.[0-9]+)*$`, so `FEAT-001.1` resolves to *that* card.
- **No fallback to the base id.** An unmatched dotted id fails, naming itself — the silent
  substitution that made this bug dangerous is gone.
- A parent move carries its family; a child move carries it too, since tight coupling is a
  property of the family rather than of which member was typed.
- `FULL_ID` keeps the dotted suffix, so a child's bundle no longer resolves to its parent's.

**Validated:** 9 cases including depth 3 and a `Parent:`-field child (which correctly does
*not* travel). Operations regression clean. **Ready to close** when FEAT-229.4 moves to `done/`.

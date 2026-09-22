# Bug: Dotted Children Bypass Every Move Gate

**ID:** BUG-239
**Type:** Bug
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-09-22
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

When a parent id is moved, its dotted children are carried along **without passing any gate**.
A child whose `Depends On:` is not satisfied enters `doing/` unchallenged; a child with
unchecked acceptance criteria would enter `done/` the same way. The gates run against the
**named** item only.

## Bug Description

**What happens (observed 2026-09-22, live):**

```
$ /fw-move 229 doing
✅ FEAT-229-build-the-kanban-board-in-the-new-engine.md → doing/
   ↳ FEAT-229.1-wire-kanban-transitions.md
   ↳ FEAT-229.2-port-the-three-kanban-gates.md
   ↳ FEAT-229.3-accept-and-cancelled-states.md
```

**FEAT-229.3 declares `Depends On: FEAT-229.2 (the gates), TASK-223`.** TASK-223 is in
`backlog/`. The dependency gate is **not bypassable by `--force`** — and it never ran.

**Why (verified in `.claude/scripts/fw-move.sh`):**

| Line | What happens |
|---|---|
| `336` | `check_dependencies "$source"` — runs on the **named** item |
| `392` | `children=$(find_children "$numeric_id")` — children collected **inside the move**, after all gates |

Children are a *move-time* concern; gates are a *pre-move* concern. The two never meet.

**Expected:** a child that cannot legally make the transition either blocks the whole family
move, or is reported and left behind. Silently carrying a blocked card into `doing/` defeats a
gate that is explicitly documented as not bypassable.

**Impact:** the dependency gate and the acceptance-criteria gate are both unenforced for any
dotted child. The acceptance case is the more serious of the two — it would let unfinished work
reach `done/`.

## The Design Question This Raises

**Gary, 2026-09-22:** *"That is a unique dependency I don't think we've had before. Perhaps the
rule should float up to the parent card, but how to designate the dependency is only on one
sub-card?"*

**Two conventions collide, and both are correct as written:**

- **Tight coupling** (TASK-219 Group 1): a dotted child *lives and dies with the parent, moves
  with it, counts as one WIP item*. It has no independent existence to hold back.
- **The dependency gate**: a card whose `Depends On:` is unsatisfied must not enter `doing/`.

**If the child cannot move alone, then the parent cannot move while any child is blocked** —
the family is one unit, so its dependencies are the union of its members'. That is the
"float up" Gary names, and it follows from tight coupling rather than being an extra rule.

**The open question is what the parent then reports.** A family blocked because *one* child
waits on TASK-223 must say so precisely — *which* child, *which* dependency — or the user sees
"FEAT-229 is blocked" with no way to find the cause. **This is the same `[h]`-vs-`Depends On:`
distinction TECH-177 drew**: the folder/field says *the family is stuck*; something must still
name *which member*.

**Candidate shapes (not decided):**

1. **Union with attribution** — the parent's gate checks every member's `Depends On:` and the
   refusal names the member. No new field; the data already exists on the child.
2. **A `Blocks Family:` marker** on the child, distinguishing "this child waits" from "the
   family waits". More precise, more machinery, and a second place for a dependency to live.
3. **Partial move** — move what can legally move, report the rest. **Rejected on its face:**
   it breaks tight coupling, which is the whole meaning of a dotted id.

**Option 1 is the likely answer** — it adds no field, and the union follows from the coupling
rule already settled. Recorded rather than decided; decide it when the gate is written.

## Scope

- **The new engine only.** `workspaces/framework/scripts/fw-move.sh` has no gates at all yet
  (verified 2026-09-22), so this is a defect to *avoid*, not one to fix there.
- **The old engine (`.claude/scripts/fw-move.sh`) is deliberately NOT fixed.** It retires at
  the ADR-009 D5 crossover. Same treatment as BUG-174 and TECH-166.

## Acceptance Criteria

- [ ] The design question is settled: how a child's dependency is expressed at the family
      level, and how the refusal names the responsible child
- [ ] A family move is refused when **any** member's `Depends On:` is unsatisfied, naming the
      child and the dependency's current folder
- [ ] A family move is refused when **any** member has blocking acceptance criteria on `→ done`
- [ ] Tight coupling is preserved — no partial family move
- [ ] Validated: **AI** — a family with one blocked child is refused, naming that child ·
      **Human** — the refusal message is enough to find the cause without reading every card

## Related

- **FEAT-229.2** — ports the gates into the new engine. **This bug must be answered there**, or
  the new gates inherit the hole. The observation came from moving FEAT-229's own family.
- **TASK-219 Group 1** — the tight-coupling rule (`counts as one WIP item`) that creates the
  collision.
- **TECH-177** — the `[h]` vs `Depends On:` micro/macro distinction, the same shape as the
  "which member is blocked" problem here.
- **BUG-174**, **TECH-166 item 4** — the other two old-engine gate defects the new engine must
  not inherit. **This is the third.**
- **BUG-240** — WIP counting ignores dotted-id collapsing. Same family, different mechanism.

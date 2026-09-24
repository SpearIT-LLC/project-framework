# Tech: Operations Breaks Folder-Is-State, and the Two Namespaces Teach Different Rules

**ID:** TECH-244
**Type:** Tech
**Priority:** Low
**Version Impact:** MINOR
**Created:** 2026-09-23
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

The board holds **folder = state** as an invariant. Operations does not: its folders carry the
*flow* state and the **outcome lives in a `Resolution:` field**. Both were decided deliberately,
but a reader who learns one namespace is then **wrong about the other** — and nothing warns them.

Decide whether that asymmetry is a principle worth keeping, worth documenting, or worth removing.

## Why It Exists

Raised by Gary, 2026-09-23, while settling TASK-242:

> *"In the kanban folders, the folder is the state. But I'm not crazy that operations doesn't
> exactly follow that principle. (that's outside the scope of this card but worth a discussion)."*

**Filed rather than discussed, because the observation evaporates and the cost is deferred, not
absent.** It was explicitly out of scope for TASK-242 and does not block anything today.

**No existing card covers this.** Checked 2026-09-23: **TECH-033** ("status field redundancy") is
about a redundant `Status:` *field on a board card* — settled by TASK-219 as *decided by
construction, the folder is the status, no field*. That is a different question: this one is about
**two namespaces disagreeing on what a folder means.**

## Current State

**The board:** folder is the status, full stop. TASK-219 settled it by construction — there is no
`Status:` field on the work-item template, because *"a second home for status is a second thing to
contradict the first."* With `cancelled/` becoming first-class (TASK-242), the board reaches
folder-is-state with no asterisk.

**Operations:** `open` · `onhold` · `closed`, plus
`Resolution: resolved | cancelled | duplicate | no-fault-found | rejected`.

**So `closed/` tells you a record stopped, not how it ended.** Two records side by side in
`closed/` may be a success and a rejection.

### The justification, quoted so it is not re-derived

FEAT-193 ruled this deliberately:

> *The kanban's separate `archive/` exists only because `done/` feeds a release sweep that
> cancelled items must not enter; ops `closed/` has no such fork.*

**The board has a downstream consumer; operations does not.** A cancelled card in `done/` behind a
field ships in a release archive the moment one consumer forgets to filter. The folder does
protective work a field cannot — **and operations has nothing to protect against.**

That reasoning is sound. The question is whether *sound* is sufficient.

## The Problem With It

**A reader who learns one namespace holds a false belief about the other.** That includes a fresh
AI session: read the board first and you conclude folder-is-state is a framework invariant; then
`closed/` silently means something else. Read ops first and you look for the board's
`Resolution:` field, which does not exist.

**It also cost real time on 2026-09-22.** TASK-242's analysis had to carry a *"why the ops model
does not simply port"* section purely to stop *"make the board work like ops"* being proposed as
the default. **That paragraph is the tax on an undocumented asymmetry**, and it will be re-paid
every time a state question touches both namespaces.

## Options (none chosen)

1. **Keep and document it.** One authored statement: *folder is flow state in every namespace;
   the board additionally makes outcome a folder because `done/` feeds a release sweep.* Cheapest,
   and the asymmetry becomes a stated rule rather than a surprise.
2. **Give ops a `cancelled/` folder** for symmetry. Consistent, but it adds a folder for a
   distinction ops never needed, and FEAT-193 rejected it on evidence.
3. **Give the board a `Resolution:` field** as well as folders. Rejected already in TASK-242 as
   speculative structure with no consumer — and it would mean two homes for one outcome.
4. **Reframe the invariant** so both fit without an exception, e.g. *"the folder is the flow
   state; an outcome is a folder only where a downstream consumer must filter on it."*

**Leaning: 1 or 4.** Both are documentation, not structure — which suits a difference that is
already justified and has broken nothing. **4 is more honest** if it can be stated crisply,
because it makes the rule cover both cases rather than naming an exception.

## Acceptance Criteria

- [ ] The asymmetry is either removed or **stated once, in an authored place**, so neither
      namespace teaches a rule the other breaks
- [ ] FEAT-193's justification is preserved in that statement — the reason is the load-bearing
      part, not the rule
- [ ] A reader arriving at either namespace first is not misled about the other
- [ ] If the invariant is reframed (option 4), the new wording covers both namespaces without
      naming an exception
- [ ] Validated: **Human** — a newcomer can say what a folder means in each namespace, and why
      they differ, from the repo alone

## Notes

**Priority Low, deliberately.** Nothing is broken; both namespaces work as designed. The cost is
paid in re-derivation — a paragraph of defensive explanation each time a state question spans
both — not in defects.

**Do not let this card grow into the parked-state decision.** TASK-242 owns that; this card owns
only the question of whether the two namespaces should agree about what a folder *is*.

## Related

- **FEAT-193** — the ops ruling: location = flow state, outcome = `Resolution:`. The decision
  this card re-examines, and whose reasoning any answer must preserve.
- **TASK-242** — the board's parked/terminal set. Makes the board's folder-is-state complete,
  which is what makes the contrast visible.
- **TASK-219** — settled the board's no-`Status:`-field rule by construction.
- **TECH-033** — the *board card's* redundant status field. **Different question**; closed by
  TASK-219's construction argument.
- **BUG-215** — one engine, one policy table per namespace. The asymmetry is expressible in that
  table, which is why it costs nothing mechanically.

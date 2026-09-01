# Task: Operations Becomes a Root Queue Namespace, Beside the Board

**ID:** TASK-213
**Type:** Task
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-09-01
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

Move operations out of `workspaces/` to the repo root, as a peer queue beside the
kanban board. Carries the ADR-009 amendment (D2) and the path changes.

Origin: Gary questioned whether `kb/` and `operations/` belong under `workspaces/` at
all — "the fact we had to treat them differently was the first tell." This item covers
**operations only**; kb is a separate discussion (see Related).

## The Reframe That Settled It

> "operations is a lot like kanban. It contains cards/tickets for a variety of
> projects/products. The only difference is in the origin of the card (FEAT, TASK, BUG,
> TECH vs INC, REQ)." — Gary, 2026-09-01

They are the same shape, and the code already says so:

| | kanban | operations |
|---|---|---|
| Location | `project-hub/work/` → `kanban/` at graduation (D5) | `workspaces/operations/` |
| Card scope | any workspace, via `Workspace:` | any workspace, no field |
| Status | first path segment (`todo/`, `doing/`) | first path segment (`open/`, `onhold/`) |
| Prefixes | FEAT, TASK, BUG, TECH | INC, REQ |
| Engine | root `/fw-move` | `fw-move.sh` — **same engine, different policy row** |

`fw-move.sh`'s header already declares `kanban` as a namespace with a reserved policy
slot, "so the crossover is a table entry, not a second engine." The convergence was
anticipated; this item finishes it.

**The anomaly is not that operations sits in `workspaces/` — it is that operations is a
queue pretending to be a workspace, while its twin sits at root.** That is why it opts
out of the shared floor (FEAT-193): a queue has no `deliverables/` or `agreements/`
because it is not engagement work, it is a card store.

## Why D5 Supports This

ADR-009 D5: at graduation, `git mv project-hub/work/* kanban/` — the board lands at the
**repo root**. The ADR-005 comparison table upholds "one Kanban board and one ID
namespace at the root."

So the end state already has a root-level card queue. Operations is a second card queue
with identical structure and a policy slot already reserved beside `kanban`, but is the
only one living inside `workspaces/`.

## What Needs Amending

**ADR-009 D2 says "root holds only the spine; all work is in a workspace."** Moving
operations out needs that amended. The argument: a queue of cards is not work, it is an
**index of** work — which is why the board itself was never a workspace either. D2's
intent (no loose work at root) is preserved; queues are spine, not work.

## Decisions (2026-09-01, Gary)

1. **Operations moves to root**, as a peer queue beside the board.
2. **Separate id sequences per namespace** — INC/REQ independent of FEAT/BUG/TASK/TECH.
   Already how the engine works (sequences are keyed per namespace); D5's warning about
   a shared ID namespace inviting collisions is the reason.
3. **Ops records gain `Workspace:`** — see TASK-214, filed separately.

## Scope

- ADR-009 amendment (D2), via change-log + in-place amendment note per the ADR
  discipline — the ADR is not rewritten.
- `fw-move.sh`: `OPS_ROOT` from `workspaces/operations` → root `operations/`.
- `fw-new-ops-record.sh`, `fw-next-id.sh`: same path change.
- `fw-new-workspace.sh`: `operations` stops being a workspace type. The four-type enum
  (TASK-197) becomes three — **check whether that reopens anything TASK-197 settled**.
- `templates/workspaces/operations/` → wherever root queue scaffolding lives.
- Contact record links: `../../kb/company/contacts/` in the ops template is relative and
  will change depth.
- `/fw-new-ops-record`, `/fw-move` command docs.

## Open Questions (resolve before → doing)

- [ ] **Does the operations scaffold get created by a command, and which one?** It is no
      longer `/fw-new-workspace operations`. Options: a new `/fw-new-queue`, folded into
      `/fw-init` alongside `kanban/`, or created on first `/fw-new-ops-record`.
- [ ] **Does this land before or after the D5 crossover?** If the board relocates to
      `kanban/` at graduation anyway, these are two migrations touching the same
      concern. Doing them as one design is cheaper; doing operations first means the
      root layout changes twice.
- [ ] **Does removing `operations` from the workspace type enum disturb TASK-197?** That
      taxonomy was settled over two sessions of scenario walking; verify the three
      remaining types still partition the scenario table cleanly.

## Acceptance Criteria

- [ ] ADR-009 D2 amended (change-log + in-place note), stating the queue-is-not-work
      distinction
- [ ] `operations/` at repo root; all scripts resolve it there
- [ ] `operations` removed from the workspace type enum with a pointer to the new path
- [ ] Existing `framework-uat` operations records migrate without id changes
- [ ] Verified against the built plugin, not the source tree (TECH-188)

## Related

- **TASK-214** — `Workspace:` field on ops records (the piece that makes root placement
  better rather than merely tidier).
- **BUG-215** — batch move regression in the new engine; independent of this move.
- **ADR-009 D2/D5** — the decisions this amends and leans on.
- **TASK-197** — workspace type taxonomy; the enum this changes.
- **FEAT-193** — operations scaffold trim (the floor opt-out that was the first tell).
- **kb placement** — the other half of Gary's question, not yet filed. Decision 5 of
  TASK-197 ("one activity may split across types") is the argument to address there.

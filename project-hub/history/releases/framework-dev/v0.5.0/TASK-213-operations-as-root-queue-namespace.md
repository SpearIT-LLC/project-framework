# Task: Operations Becomes a Root Queue Namespace, Beside the Board

**ID:** TASK-213
**Type:** Task
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-09-01
**Workspace:** framework
**Completed:** 2026-09-03

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

## Open Questions (resolved 2026-09-03, Gary, pre-implementation review)

- [x] **Does the operations scaffold get created by a command, and which one?**
      **Created on first `/fw-new-ops-record`.** Self-healing, no new command, and no
      dependency on `/fw-init` (promised but unbuilt). If `/fw-init` materializes it may
      also lay the scaffold; create-on-first-use stays as the fallback. Queue scaffolding
      moves from `templates/workspaces/operations/` to `templates/queues/operations/`
      (a queue is not a workspace type, so its template leaves that tree).
- [x] **Does this land before or after the D5 crossover?** **Before — now.** The
      crossover was designed as "a table entry, not a second engine," so it stays cheap
      whenever it lands; this is path churn, ranked first (roadmap D1) precisely because
      deferring it is expensive. `operations/` at root is not reworked when `kanban/`
      lands beside it at graduation — separate trees. Obligation: the root layout adopted
      here must let D5 drop `kanban/` in without touching `operations/` again.
- [x] **Does removing `operations` from the workspace type enum disturb TASK-197?**
      **No — verified 2026-09-03 against the TASK-197 record.** The taxonomy's
      discriminating tests (the close-test, product-persists, product-work-splits-out)
      never involve `operations`; scenario-table rows that land "operations" still land
      in operations — as root-queue records rather than a workspace, which is Decision 5's
      link-don't-merge pattern unchanged. The one TASK-197 artifact this touches is the
      scaffold-set list ("operations: own list per FEAT-193"), which relocates with the
      template, not a partition of the scenario table. Enum becomes three:
      product, project, knowledgebase.

## Acceptance Criteria

- [x] ADR-009 D2 amended (change-log + in-place note), stating the queue-is-not-work
      distinction
- [x] `operations/` at repo root; all scripts resolve it there
- [x] `operations` removed from the workspace type enum with a pointer to the new path
- [x] Existing `framework-uat` operations records migrate without id changes
- [x] Verified against the built plugin, not the source tree (TECH-188)

## Implementation Record (2026-09-03)

- **ADR-009**: D2 amendment note + change-log entry; root spine list now includes
  `operations/` (when present). Enum → product, project, knowledgebase.
- **Scripts**: `fw-move.sh`, `fw-next-id.sh`, `fw-new-ops-record.sh` resolve
  `$ROOT/operations`. `fw-new-ops-record.sh` creates the queue on first use from
  `templates/queues/operations/` (project `.claude/templates/queues/` overrides).
  `fw-new-workspace.sh` refuses `operations` with a pointer (same pattern as
  `application`/`sow`). **Scope addition — `fw-contacts.sh`**: an `Assigned: operations`
  contact resolved under `workspaces/` and would have silently skipped; generate,
  stale-removal, and `--check` now handle the root queue (link depth
  `../workspaces/kb/company/contacts/`). Justified by "all scripts resolve it there."
- **Templates**: `templates/workspaces/operations/` → `templates/queues/operations/`
  (`git mv`); queue README rewritten (was a workspace-README with `__NAME__`
  placeholder that the verbatim copy would have leaked). `ops-record.md` contact link
  depth fixed.
- **Docs**: `fw-move.md`, `fw-new-workspace.md`, `fw-new-ops-record.md`,
  `fw-troubleshoot` SKILL.md step 4 (anchor is now always available), UAT-03/14/15
  rewritten. `UAT-RESULTS-2026-08-26.md` untouched (dated record). CHANGELOG entry
  under [Unreleased].
- **framework-uat migrated**: `git mv workspaces/operations operations` — 15 renames,
  records INC-001/004/005, REQ-002/003 intact, committed in that repo.

**Verification — against the published marketplace copy (junction channel), not the
source tree:**

| Check | Result |
|---|---|
| `fw-next-id.sh operations` on migrated uat | **006** — bucketed + moved records all still count; no ID reissue |
| `fw-move.sh REQ-003 onhold` → `3 open` round-trip on uat | both succeed at root `operations/` |
| Kanban prefix guard (`FEAT-12 doing`) | still refused with the D5 pointer |
| Create-on-first-use in a scratch git repo | queue scaffolded (6 folders + README) + `INC-001` created, one command |
| `fw-new-workspace operations` | refused, pointer names `/fw-new-ops-record` |
| `fw-new-workspace product widget` in scratch | floor + product overlay compose intact (no regression from the floor-check simplification) |
| `fw-contacts.sh --check` on uat | OK — views match records |

Live-session smoke test after `/plugin marketplace update dev-marketplace` + restart
remains a user step (as in TASK-197).

## Related

- **TASK-214** — `Workspace:` field on ops records (the piece that makes root placement
  better rather than merely tidier).
- **BUG-215** — batch move regression in the new engine; independent of this move.
- **ADR-009 D2/D5** — the decisions this amends and leans on.
- **TASK-197** — workspace type taxonomy; the enum this changes.
- **FEAT-193** — operations scaffold trim (the floor opt-out that was the first tell).
- **kb placement** — the other half of Gary's question, not yet filed. Decision 5 of
  TASK-197 ("one activity may split across types") is the argument to address there.

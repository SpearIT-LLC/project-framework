# Feature: Operations Record ID Convention (ITIL Prefixes)

**ID:** FEAT-195
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-08-19
**Workspace:** framework
**Completed:** 2026-08-25

---

## Summary

Operations intake records get their own ID system — the same reasoning that gave the
kanban its own work-item IDs. ITIL prefixes, per-workspace sequence:

- `INC-###` — incidents
- `REQ-###` — requests

Customer ticket systems (Jira, ServiceNow, …) are recorded as a **cross-reference field
on the record, never as our primary key**. Decided 2026-08-19 with FEAT-193/194.

**Lifecycle (decided with FEAT-193):** location is the status — records move
`open/` → `onhold/` → `closed/` at the workspace level; the prefix carries the type.
Operations stays off the kanban board; `/fw-wip` and `/fw-status` surface active ops
records alongside kanban WIP for one view of everything in flight.

**Closed-folder growth:** `closed/` accumulates indefinitely, so closure includes a
periodic sweep into year buckets (`closed/2026/…`) — same shape as the board's
planning-period archival (FEAT-093). Sweep is a command/script, never a hand move.

---

## Rationale

- We don't control the customer's namespace — internal-only work can't mint a Jira ID.
- The mapping isn't 1:1 — one incident may relate to zero or several customer tickets; a
  field holds that, a filename can't.
- Our IDs must survive a customer changing tools.
- ITIL prefixes reused deliberately — no need to invent new vocabulary.

---

## Scope

**In scope:**
- The ID convention (prefix + sequence) and the cross-reference field in the
  incident/request record shape.
- Next-ID mechanics for the operations namespace. **Direction (Gary, 2026-08-19):**
  adapt the existing next-id script to take a namespace/folder root rather than writing
  a second one — it's the same function over different folders (kanban vs. operations).
  One authored home for the ID logic (ADR-008).
- Move mechanics, same treatment (Gary, 2026-08-19): adapt `fw-move` to the operations
  flow (`open/` → `onhold/` → `closed/`) rather than writing a second mover — `git mv`
  enforcement and the stamp-on-terminal-move behavior (Completed on kanban → done;
  a Closed date on ops → closed) are shared machinery. The kanban-specific gates
  (ripeness review, dependency check) must NOT apply to ops moves — the transition
  policy is per-namespace.

**Out of scope:**
- Migrating or renaming any existing records.
- Any sync or automation against customer systems — cross-reference is a manual field.

---

## Notes from FEAT-202 (2026-08-24) and FEAT-193 (2026-08-25)

- **Closure code (decided with FEAT-193, 2026-08-25):** no `cancelled/` folder — location is the
  flow state, outcome is a field. Closed records carry `**Resolution:**` with an ITIL-style
  closure code (resolved | cancelled | duplicate | no-fault-found | rejected) plus free-text
  reason; the `→ closed` move treatment prompts for it the way `→ done` stamps `Completed`.
  FEAT-196 reporting greps this field for fulfilled-vs-cancelled.

- **Artifact-bundle convention is this item's to define:** an ops record may
  carry a sibling folder (`INC-nnn/`) for working material, mirroring the
  kanban's artifact-folder pattern; troubleshooting working evidence lives
  there while the investigation runs (FEAT-202's case pattern).
- **The troubleshooting distillation gate becomes mechanism here:** the ops
  close flow should prompt the FEAT-202 close-gate (durable knowledge → kb
  research case / cookbook recipe, or explicit "nothing durable") when closing
  an INC. Until then it is convention in the fw-troubleshoot skill.

## Scope reality (pre-implementation review, 2026-08-25)

The "existing" next-id and `fw-move` are the *old* root engine serving the live board
(ADR-009 D5). The new build had no engine — this card is its first slice, built as **one
namespace-aware engine with only the operations policy populated** (Gary: "the same script
with different inputs or an internal toggle for kanban/ vs operations/"). The kanban policy
slot fills at board crossover by carrying the root `fw-move.sh` logic in — a table entry, not
a second engine. Two engines coexist until graduation, which ADR-009 accepts. Rule encoded:
**status is the first path segment under a namespace root; deeper folders (year buckets,
release buckets, artifact bundles, children) are grouping, never status** — Gary noted the
year folder matches the kanban's sub-folder concept; the recursive scan makes them one
mechanism. Surfacing ops records in a status/WIP view is out of scope (no new-build status
command yet — FEAT-163/196).

## Open Questions (resolve before → doing)

- [x] Sequence scope: one sequence per prefix (`INC-001` and `REQ-001` coexist) or one
      shared sequence per workspace? (Kanban precedent: shared namespace.)
      *Resolved 2026-08-25 (Gary): one shared sequence per operations workspace — kanban
      precedent; an id is unambiguous without its prefix (`fw-move.sh 12` works); one counter.*
- [x] Record template: does an incident/request record template ship with the scaffold,
      and where is its one home? Direction under discussion: authored in the plugin so
      updates propagate; a project's `.claude/templates/` acts as optional override.
      *Resolved 2026-08-25: ships in the plugin as `templates/records/ops-record.md` (one
      template, prefix chosen at creation); `.claude/templates/records/` overrides.*
- [x] Archival trigger: when does the `closed/` year-bucket sweep run (on close, on
      demand, or with the FEAT-093 planning-period archival)?
      *Resolved 2026-08-25: on demand — `fw-move.sh sweep`; rule = records closed in a prior
      calendar year move to `closed/YYYY/` (bundle too). Layout rule defined now because
      next-id and move must recurse into buckets; FEAT-199 can surface "sweep due" later.*

---

## Acceptance Criteria

- [x] ID convention documented in exactly one home; operations records named
      `INC-###-slug.md` / `REQ-###-slug.md`
      *(2026-08-25: the record template + create script header are the home; verified names)*
 *(2026-08-25: `Customer ref:` 0..n in ops-record.md)*
 *(2026-08-25: `fw-next-id.sh <namespace>` — ops now, kanban at crossover; recursive, shared sequence; empty-namespace case fixed during test)*
- [x] Move logic likewise: `fw-move` handles ops transitions with `git mv`, per-namespace
      transition policy (no kanban gates on ops moves), and a Closed stamp on → closed
      *(2026-08-25: `fw-move.sh` — ops policy, `--resolution` required + stamped, bundle moves, sweep;
      kanban prefixes refused with a pointer to the root /fw-move until crossover; no kanban gates)*
- [x] Verified against the built plugin, not the source tree *(2026-08-25: full cycle in a
      scratch git root — create INC/REQ, onhold↔open, closed with code, terminal guard, sweep,
      next-id counting buckets — then create + close from the published marketplace copy in the
      operations fixture)*

---

## Related

- **FEAT-193** — operations scaffold trim; these records flow through its `open/`,
  `onhold/`, `closed/` folders.
- **FEAT-093** — planning-period archival; the kanban counterpart of the closed sweep.
- **FEAT-194** — kb `company` domain; contacts referenced from records live there.
- **ADR-008** — Single-Source Rule; one home for ID logic and for the convention.

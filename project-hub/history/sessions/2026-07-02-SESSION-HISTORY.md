# Session History: 2026-07-02

**Date:** 2026-07-02
**Participants:** Gary Elliott, Claude Code
**Session Focus:** Decision swarm — project model for a single-customer, multi-SOW engagement (led to a new `engagement` project type)

---

## Summary

Ran a `/fw-swarm decision` to work out how a solo contractor should structure
repos for one customer with many independent SOWs. The conversation evolved
substantially through several user course-corrections: from "reuse the toolbox
type with nested project-hubs" to a clean model of **one repo per customer, one
framework spine, one Kanban board, SOWs as `stream` folders**, under a brand-new
fifth project type: **`engagement`**. Produced ADR-005, three backlog items
(FEAT-163/164/165), and meeting minutes. The schema edit that would add the
`engagement` type was deliberately *not* applied — it is tied to FEAT-165 so it
carries history into the distribution archive.

---

## Work Completed

### ADR-005: Multi-SOW Single-Customer Repo Model (`engagement` type)

- Decided: one private git repo per customer; **one** framework spine and **one**
  Kanban board at the customer root; bounded bodies of work live as `stream`
  folders under `streams/`.
- Rejected: repo-per-SOW (detaches shared context, N+1 repos for a solo dev) and
  git submodules (ceremony tax; prior negative experience).
- Rejected mid-session: reusing the `toolbox` type — replaced by a new `engagement`
  type (see Decisions).

### FEAT-163: Stream-Aware Reporting and History

- Report project status **by stream**; ensure session/git/release history can be
  organized by stream; surface unassigned items to make stream drift visible.
- Gated on deciding the stream field (reuse `Theme` vs. new `Stream`).

### FEAT-164: Scalable Stream Content Folder Structure

- Define the `streams/<slug>/` internal layout and a "start a new stream"
  procedure. Deliberately kept as a *sketch* in the ADR; the spec is this item's
  job (sketch → use → formalize).

### FEAT-165: Introduce `engagement` Project Type

- Add `engagement` to the `project.type` enum in `framework-schema.yaml` (schema
  edit deferred to this item so it carries history).
- **Audit every type-branching point.** Confirmed functional gap:
  `framework-roles.yaml` → `project_type_defaults` maps each type to a default AI
  role; `engagement` needs an entry or it falls through to `fallback_default`.
  Also: setup picker (auto-parses schema — verify), and docs enumerating the four
  types (CLAUDE.md, PROJECT-STRUCTURE.md, GLOSSARY.md, architecture-guide.md,
  NEW-PROJECT-CHECKLIST.md).

---

## Decisions Made

The value of this session was in the *evolution* of the model. Preserving the
journey, because each turn was a user course-correction that improved the design:

1. **One Kanban board, not many (course-correction #1):**
   - The team's first framing of the model implied *N* `project-hub/` boards (one
     per SOW). Gary flagged this breaks the whole point of Kanban for a one-person
     shop — one pair of hands should mean one board.
   - Resolved to a single spine + single board at the customer root, with the SOW
     as a *dimension* of the work, not a separate spine. Connected to the `toolbox`
     "one project, many tools" idea.

2. **Container term = `stream`, not `SOW` (course-correction #2):**
   - Gary noted "SOW" bakes in a granularity assumption: his new project is defined
     *by* SOW, but the HPC/Honda precedent has *multiple deliverables under one
     SOW*. The term must stay flexible.
   - Rejected `engagements/` (implies SOW-level), reusing `theme` (`Theme` already
     means *stable category* per ROADMAP-TEMPLATE — overloading it mixes permanent
     and temporary meanings), and `deliverables/` (a stream holds internal
     notes/research too, and the repo isn't the deliverable).
   - Landed on **`streams/`** with an optional `deliverables/` *subfolder* per
     stream for the client handoff boundary. **`Stream`** (which bounded work,
     temporary) kept distinct from **`Theme`** (what kind of work, stable category).

3. **New `engagement` project type, not `toolbox` reuse (course-correction #3):**
   - Gary asked whether a distinct 5th type would be cleaner long-term, given the
     tension already felt. He articulated the decisive distinction: `toolbox` is a
     flat set of **homogeneous peers** (utility scripts); a customer engagement is
     **heterogeneous activities** (org info, source, ops, knowledge base,
     deliverables) that **sprawl wider over a long engagement**. A toolbox doesn't
     grow into a KB + ops runbook + source tree; a customer does.
   - Dan (Senior Dev role) conceded his conservative "reuse for now" position given
     the distinction is structural and a real customer repo is imminent.
   - Named **`engagement`** (over `client` / `workspace`) — Gary's call, noting the
     schema *description* is the runtime clarity surface, so wording was made
     explicit.

4. **Stream field left open (by design):**
   - Whether "which stream" rides on the existing `Theme:` field or a new `Stream:`
     field is deferred to FEAT-163 / the scaffolding session. Team leans distinct
     to avoid overloading `Theme`.

5. **Schema change tied to a work item (course-correction #4):**
   - The `engagement` type was initially edited directly into
     `framework-schema.yaml` during the swarm. Gary directed that the change be
     tied to a work item so a new distribution archive carries its history.
   - The schema edit was **reverted**; `engagement` is implemented via FEAT-165.
     ADR-005, FEAT-165, and the minutes were updated to say the schema edit is
     *proposed/pending*, not applied.

---

## Files Created

- `project-hub/research/adr/005-multi-sow-customer-repo-model.md` — the decision record
- `project-hub/work/backlog/FEAT-163-theme-aware-reporting-and-history.md` — stream reporting/history
- `project-hub/work/backlog/FEAT-164-scalable-multi-sow-content-structure.md` — stream folder structure
- `project-hub/work/backlog/FEAT-165-engagement-project-type.md` — new type + type-branch audit
- `project-hub/meetings/2026-07-02-swarm-decision-multi-sow-customer-repo-model.md` — swarm minutes
- `project-hub/history/sessions/2026-07-02-SESSION-HISTORY.md` — this file

## Files Modified

- None to live framework code. The `framework-schema.yaml` edit made during the
  swarm was intentionally reverted (deferred to FEAT-165) — the file is unchanged
  from its committed state.

## Files Moved

- None.

---

## Current State

### In done/ (awaiting release)
- None from this session (planning/decision work only).

### In doing/
- None.

### In backlog/ (new)
- FEAT-163 — Stream-Aware Reporting and History
- FEAT-164 — Scalable Stream Content Folder Structure
- FEAT-165 — Introduce `engagement` Project Type (**suggested first pick** — it
  unblocks scaffolding the real engagement repo, since the type must exist before
  setup can select it)

### Open questions carried forward
- `Stream` vs. `Theme` field mechanism (FEAT-163 / scaffolding).
- `streams/<slug>/` internal layout spec (FEAT-164).
- `engagement` type wiring + audit (FEAT-165), incl. `project_type_defaults` role.

### Next session
- Scaffold the customer repo (`framework.yaml` → `type: engagement`, `customer/`,
  `streams/sow-01-<slug>/`) and settle the open questions against the real repo.

---

**Last Updated:** 2026-07-02

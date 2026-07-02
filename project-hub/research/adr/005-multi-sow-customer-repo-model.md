# ADR-005: Multi-SOW Single-Customer Repo Model (`engagement` Type)

**Status:** Proposed
**Date:** 2026-07-02
**Deciders:** Gary Elliott, Claude Code
**Impact:** Moderate
**Supersedes:** None

---

## Context

SpearIT engages clients through multiple Statements of Work (SOWs). For a single
customer, each SOW is a distinct engagement with its own clean start and finish,
but they share standing customer context (contacts, systems, credentials pointers,
prior decisions, standing docs). This does not map cleanly onto the framework's
four project types (`framework`, `application`, `library`, `toolbox`).

Driving needs, as scoped with the team:

- **The repo is a workspace, not a deliverable.** Deliverables ship *out* of the
  repo to the client; the repo itself is Gary's organization of the work.
- **"Done" = the SOW goes quiet but stays referenceable.** No independent
  release/versioning cadence is required per SOW; work items complete, history is
  retained, billing stops.
- **The sharpest pain is history**, not duplication — being able to look back and
  know what happened, when, for which SOW.
- **Solo contractor constraints.** One pair of hands. Low ceremony. No fleet of
  repos to administer.

The precedent cited was the HPC `HPCJobQueuePrototype` repo, which grew a
`customers/honda/*` structure organically (accretion, not design).

## Options Considered

### Option A: One repo per customer, streams as folders
A single private git repo per customer (project type resolved under **Decision** —
see the `engagement` vs. `toolbox` discussion below).
The customer root is the framework spine — **one** `PROJECT-STATUS.md`, **one**
`project-hub/` Kanban board. Shared context lives once at the root. Each bounded
body of work is a **stream** — a folder under `streams/` holding that stream's docs
and an optional `deliverables/` subfolder for shippable output.

**Terminology note:** the framework-level container is a **stream**, not "SOW."
A stream is a *bounded body of work* whose granularity the customer chooses — it may
be an SOW, a single deliverable, a phase, or an initiative. In Gary's new project a
stream ≈ an SOW; in the HPC/Honda precedent a stream ≈ a deliverable (several under
one SOW). Naming the container "SOW" would bake in one granularity; "stream" stays
neutral. **`Stream`** (which bounded body of work, temporary) is kept *distinct*
from **`Theme`** (what kind of work — the existing *stable category* dimension, e.g.
"Workflow," "Developer Guidance"). A work item may carry both.

**Pros:**
- Shared customer context lives once — no duplication.
- One Kanban board — matches "one pair of hands"; WIP limits remain meaningful.
- File-based work history (`project-hub/history/`) can be organized per stream
  while remaining one timeline.
- Cloning/backup pulls the whole customer, always coherent.

(Note: an earlier draft of this option proposed reusing the existing `toolbox`
type. That was rejected during the same session — see **Project type** below.)

**Cons:**
- Shared git commit timeline: `git log`/`git tag` are customer-wide; per-SOW views
  require path filters or tag namespacing.
- Concentrated blast radius for any secret accidentally committed (mitigated by
  "secrets never in repo").

### Option B: Repo per SOW + separate customer-context repo
Each SOW is its own git repo (clean isolated timeline, independent tags). A
separate customer-context repo holds shared info.

**Pros:** Pristine git *and* file history per SOW; independent release cadence.
**Cons:** N+1 repos to manage solo; shared context is *detached* from the SOWs
that use it; re-cloning/referencing context is manual friction. Overkill given the
repo is not a deliverable.

### Option C: Customer umbrella repo with SOWs as git submodules
Umbrella repo links each SOW repo as a submodule.

**Pros:** Clean per-SOW history *and* a unifying umbrella on paper.
**Cons:** Submodule ceremony — detached HEADs, pointer commits, two-step commits —
is a constant tax for a solo dev. The team has prior negative experience with
submodules. Rejected.

## Decision

**Chosen: Option A — one repo per customer, streams as folders — under a NEW
`engagement` project type (not `toolbox`).**

A **stream** is a bounded body of work (an SOW, deliverable, or phase — the customer
picks the granularity), not a separate framework spine. There is **one** framework
spine and **one** Kanban board at the customer root. Stream identity is carried on
work items; `Theme:` is retained for its existing *stable-category* meaning and is
orthogonal to which stream an item belongs to.

### Project type: introduce `engagement` (do NOT reuse `toolbox`)

The team initially proposed reusing `toolbox`, then rejected it. The two share a
*shape* ("one spine, many things under it") but differ in **organizing principle**:

- **`toolbox`** = a flat collection of **homogeneous peers** — many utility scripts,
  each an independent instance of the *same kind of thing*. Breadth is bounded to
  "more tools."
- **`engagement`** = a customer workspace holding **heterogeneous activities of
  different kinds** — project/org info, source code, operations, knowledge base,
  deliverables — under one customer, **sprawling wider over a long engagement**. A
  toolbox does not grow into an ops runbook + a knowledge base + a source tree; a
  customer engagement does.

Forcing these into one type is the same overload trap caught earlier with `Theme`.
So `engagement` is a distinct 5th `project.type`. **The schema change is not applied
by this ADR** — it is implemented through **FEAT-165** so that it flows through the
workflow and carries history into the distribution archive. Its detailed folder
structure is **not** specified here either — that is FEAT-164's job (sketch → use →
formalize). Adding the type also requires an **audit of every type-branching point**
(role `project_type_defaults`, the setup picker, type-enumerating docs, templates) —
tracked in FEAT-165. Confirmed audit surface: `framework-roles.yaml`
`project_type_defaults` maps each type to a default role; `engagement` needs an
entry or it falls through to `fallback_default`.

### Reference Layout

```
customer-<name>/               (private git repo, ONE framework project)
├── framework.yaml             type: engagement   (customer spine)
├── PROJECT-STATUS.md          ONE source of truth
├── CLAUDE.md
├── customer/                  shared: contacts, systems, standing docs, decisions
│                              (NO secrets — vault pointers only)
├── streams/
│   ├── sow-01-<slug>/         one bounded body of work (SOW, deliverable, or phase)
│   │   ├── notes/             internal working docs
│   │   ├── research/          internal
│   │   └── deliverables/      shippable output → handed to client
│   ├── sow-02-<slug>/
│   └── jobqueue/              (granularity is the customer's choice)
└── project-hub/               ONE Kanban board
    ├── work/
    │   ├── backlog/ todo/ doing/ done/
    │   └── (each item's frontmatter names its stream; Theme: stays optional)
    └── history/
        ├── sessions/          all sessions, one timeline (stream-labeled)
        └── releases/
            └── sow-02-<slug>/ releases grouped by stream when needed
```

**Stream identity on work items — open question (see below):** whether "which
stream" rides on the existing `Theme:` field or a new `Stream:` field is deferred to
the scaffolding session / FEAT-163. The team's lean is a distinct dimension, because
`Theme` already means *stable category* and overloading it with *temporary stream
container* mixes two meanings in one namespace.

## Consequences

**Easier:**
- Starting a new stream = a new folder + a stream value. No new repo, no new spine.
- Shared context is always at hand, never duplicated.
- One board answers "what am I working on right now" across all streams.

**Different / requires discipline:**
- Whichever field carries **stream identity** becomes **load-bearing**, not optional
  — every work item must name its stream, or per-stream reporting breaks.
- Git tags, if used per stream, must be namespaced (e.g. `sow-02/v1.0`).

**The framework gap this surfaces (the real follow-up work):**
A tagging field already exists (`Theme:` in FEATURE/BUG/TECH templates), but it
currently means *stable category*, not *stream*. What's missing is:
1. **Stream reporting** — `/fw-status` / `/fw-wip` have no stream filter/grouping.
2. **History records by stream** — session history and (where relevant) git/release
   history should be organizable by stream.
3. **A scalable content folder structure** for `streams/` and `customer/` so setup
   is repeatable.
4. **Decide the stream field** — reuse `Theme` vs. add a distinct `Stream` field
   (team leans distinct, to avoid overloading `Theme`).
5. **Introduce the `engagement` project type** in `framework-schema.yaml` and
   **audit every type-branching point** (role `project_type_defaults`, setup picker,
   type-enumerating docs/glossary, templates).

These are tracked as framework backlog items (FEAT-163, FEAT-164). This ADR lives
in the **framework repo** precisely because the model requires framework changes,
not just a usage convention.

## Risks

- **Stream drift** — items created without a stream value silently fall out of
  per-stream views. Warning sign: stream totals not reconciling with the board.
  Mitigation: make the stream field required-by-convention in this project type; the
  reporting command should surface unassigned items.
- **Shared git timeline confusion** — mitigated by path filters and tag namespacing;
  low impact since the repo is not a deliverable.
- **Secret blast radius** — a committed secret is permanent and customer-wide.
  Mitigation: secrets never in repo (vault pointers only); strict customer-root
  `.gitignore`. Customer repos are always private; contractor access is rare and
  repo-scoped.

---
*Generated by /fw-swarm decision on 2026-07-02.*

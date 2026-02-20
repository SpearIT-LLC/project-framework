# Planning Document Model

**Status:** Draft / Preliminary
**Created:** 2026-02-20
**Author:** Gary Elliott + Claude Code
**Related:** [project-guidance.md](../../project-hub/planning/design/project-guidance.md)

---

## Purpose

This document defines the relationships, ownership boundaries, and structure of the planning documents used in the SpearIT Framework. It is framework-level reference material — any command or process that produces or reads planning documents should be consistent with this model.

---

## Document Hierarchy

These documents are not more detailed versions of each other. They are **orthogonal views** of the same project at different timescales and stability levels.

```
Project Brief          ← identity: what, why, who (stable)
Project Outline        ← structure: planning periods, sequence, dependencies (evolves slowly)
Roadmap                ← execution: planning periods, goals, focus (living)
Backlog                ← tactics: specific work items (high churn)
```

Each answers a different question:

| Document | Question | Timescale | Changes When |
|---|---|---|---|
| `project-brief.md` | What is this project and why does it exist? | Project lifetime | Direction pivots |
| `project-outline.md` | How is the work structured and in what order? | Months | A planning period completes or project pivots |
| `ROADMAP.md` | What are we doing right now and what's next? | Weeks–months | Planning period ends |
| `work/backlog/` | What specific things need to get done? | Days–weeks | Work is done or priorities shift |

---

## Ownership Boundaries

Each document owns specific concerns. Duplication across documents is a design smell.

### Project Brief
**Owns:** Project identity — what it is, who it's for, why it matters, MVP definition, top risks.
**Does not own:** Planning period structure, roadmap goals, specific work items, implementation details.

### Project Outline
**Owns:** Planning period names, sequence, dependencies between periods, exit criteria per period, period-level risks.
**Does not own:** Specific work items, MVP feature details, roadmap goals, design decisions.
**Key principle:** If a specific backlog item or feature changes, the outline should not need to change.

### Roadmap
**Owns:** Planning periods (names, goals, success criteria, theme focus), future considerations, completed period history.
**Does not own:** Outline structure, project identity, specific work items.

### Backlog
**Owns:** Specific work items with acceptance criteria, implementation details, estimates.
**Does not own:** Anything above — work items reference phases and themes but don't define them.

---

## Physical Structure

### Current (MVP)

Planning documents are single files:

```
project-hub/planning/
├── project-brief.md         ← single file, hand-maintained
├── project-outline.md       ← single file, generated from period folders (future)
├── ROADMAP.md               ← single file, hand-maintained
└── archive/                 ← prior versions archived on overwrite
```

### Future: Folder-Based Outline

The project outline evolves toward a folder-based structure where **folders are the source of truth** and `project-outline.md` is a **generated artifact**:

```
project-hub/planning/
├── project-brief.md              ← source of truth, hand-maintained
├── project-outline.md            ← generated view, do not edit directly
├── ROADMAP.md                    ← source of truth, hand-maintained
├── periods/                      ← source of truth for outline (planning periods)
│   ├── 01-foundation/
│   │   └── overview.md           ← exit criteria, dependencies, risks (thin)
│   ├── 02-project-guidance/
│   │   └── overview.md
│   └── ...
└── archive/
```

**Principles:**
- Each `overview.md` is deliberately thin — exit criteria, dependencies, period-level risks only
- Details (design docs, research, decisions) live in the backlog and design docs, not in period folders
- `project-outline.md` is regenerated on demand — never edited directly
- A future command regenerates the outline from the `periods/` folders for quick reference or presentation

### Period `overview.md` — What Belongs

**Belongs:**
- Planning period name and one-line description
- Exit criteria — what "done" looks like for this period
- Dependencies — what this period depends on
- Period-level risks — risks specific to this period

**Does not belong:**
- Specific work items or feature lists
- MVP details
- Design decisions
- Anything that changes at backlog cadence

---

## Relationship to `/swarm`

The `/swarm` command produces the initial project brief and project outline. In MVP:
- Both are written as single files
- The outline is hand-maintained
- The folder-based outline structure is Future

When the folder-based model ships, `/swarm` will seed the `periods/` folders instead of writing a single outline file. The regeneration command will produce `project-outline.md` from those folders.

---

## Open Questions

- What triggers outline regeneration? A dedicated command? A flag on `/swarm`?
- Does each period folder eventually hold more than `overview.md` — e.g., period-scoped design docs?
- How does the Roadmap relate to period folders — do roadmap planning periods map 1:1 to outline periods, or are they independent?

---

*Preliminary — established during /swarm kick-off session on 2026-02-20. Update as the model stabilizes.*

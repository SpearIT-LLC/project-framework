# __NAME__

**Type:** project
**Purpose:** _PURPOSE_PENDING_

A project is a finite initiative coordinated to completion: it reaches its goal,
**freezes, and never reopens** — a follow-on is a new project. Its result is mostly a
changed state of the world, plus the artifacts that evidence it.

- **Contracted work (an SOW) is a project named for the SOW** (e.g. `bd-sow-001`):
  contract drafts and signed packets live in `agreements/`; key contract dates are
  transcribed into `requirements/` (the signed document stays the legal authority —
  the transcription is the machine-readable home).
- **Product work always splits out.** Software/tooling this project delivers is
  presumed to outlive acceptance and gets its own `product` workspace from day one.
  This workspace holds only work that dies at acceptance (drafts, analyses,
  coordination) and *references* the product workspaces it delivers.
- `requirements/` — what done means: requirements and acceptance criteria (tests are
  their executable form). **Freezes at close.**
- `deliverables/` — the handover packet: accepted report, signed acceptance/test
  evidence, as-builts, runbooks. Write-once at acceptance (see its README).
- Plans: tactical work is kanban items carrying `Workspace: __NAME__`; strategic
  direction is this workspace's `ROADMAP.md`, created on demand.

# __NAME__

**Type:** product
**Purpose:** _PURPOSE_PENDING_

A product is created, delivered, and **maintained** — this workspace lives as long as
the product does (it has a version 2). Executables, script libraries, packages, and
pipelines all qualify; one workspace per product, however many artifacts it contains.

- `requirements/` — the product's **living, versioned** requirements. Same concept
  the industry also calls "specs" — one name here, deliberately: a product's
  requirements evolve with each version, where a project's freeze at close.
  Acceptance tests are the executable form of requirements.
- `deliverables/` — handed-over-and-accepted only, write-once (see its README).
- Plans: tactical work is kanban items carrying `Workspace: __NAME__`; strategic
  direction is this workspace's `ROADMAP.md`, created on demand.

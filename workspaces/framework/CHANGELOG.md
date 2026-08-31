# Changelog — spearit-framework-dev

Plugin-scoped changelog (the framework IS the plugin, ADR-009 D3). Versions are
plain semver 0.x during the framework workspace build.

## [Unreleased]

### Added
- Operations records + the ADR-009 build's move engine: `fw-new-ops-record.sh` (create gate:
  `INC-`/`REQ-` records from one shared sequence via `fw-next-id.sh`, the one home for
  next-id logic across namespaces); `fw-move.sh` (namespace-aware: ops policy `open ↔ onhold
  → closed`, closed terminal, `--resolution` closure code stamped with `Closed:`, artifact
  bundles move with records, `sweep` year-buckets prior-year closed records; kanban policy
  slot fills at board crossover); `templates/records/ops-record.md`. Status is the first
  path segment under a namespace root — deeper folders are grouping, never status. (FEAT-195)
- Operations scaffold trimmed to flow folders `open/ onhold/ closed/` + `meetings/ agreements/
  reference/` — `intake/` tree replaced (location = status, `INC-`/`REQ-` prefix = type);
  operations opts out of the shared floor like kb. No `problems/`, `changes/`, or `cancelled/`
  folders by decision (troubleshooting case + kanban item; customer CM tool; `Resolution:`
  closure code). (FEAT-193)

### Changed

None

### Fixed
- Contact create gate no longer seeds placeholder tokens: a new record carries the display
  name (title-cased from the slug, corrected by hand where the slug is lossy) and empty
  `**Field:**` lines with `Assigned: Unassigned` — so a name-only record is a valid resting
  state instead of a forbidden one, and an interrupted add leaves nothing false on disk.
  Field guidance lives in the stripped comment header and the command. (BUG-212)
- `fw-new-workspace.sh` validates the template set (floor + type overlay) before creating
  anything — a project override missing an overlay now refuses cleanly naming the gap and
  the wholesale rule, instead of dying mid-copy and leaving a half-built workspace; override
  runs announce "Using project template override: …"; the command states that an override
  replaces the plugin templates entirely. (BUG-208, from UAT-06 ad-hoc)
- Contact records: creation is now a script gate (`fw-new-contact.sh <slug>` copies the
  template minus its header and seeds `kb/company/contacts/` + README on first use — no more
  hand-made registry folder); blank optionals stay as prompts instead of being deleted;
  `Assigned:` accepts `Unassigned`; `Affiliation` is `<org> (customer | vendor | subcontractor
  | spearit)`; `/fw-contacts <name> [change]` adds or updates a record and regenerates views;
  `fw-contacts.sh` errors name the actual gap in command syntax. (BUG-207, from UAT-10/13)

---

## [0.4.0] - 2026-08-24

Work items: FEAT-164, FEAT-190, FEAT-192, FEAT-194, FEAT-201, FEAT-202,
TASK-197 — archived at `project-hub/history/releases/framework-dev/v0.4.0/`.

### Added
- Framework workspace kickoff — `workspaces/framework/` established as the dev
  plugin's source tree, built fresh in place (ADR-009 Option C). (FEAT-190)
- `fw-troubleshoot` skill (the plugin's first skill) + `templates/records/ts-case.md`
  — systematic troubleshooting: search solved cases first, hypothesis–evidence
  loop with capture-as-you-go, close gate distilling a cookbook recipe (the
  findable solution card) backed by a `research/` case folder (evidence-scrub
  and script-promotion rules included). (FEAT-202)
- `/fw-contacts` + `templates/records/contact.md` — contacts get one authored
  home: per-contact records in the kb `company` domain, with repeatable
  `Assigned: <workspace> — <role>` declarations; every workspace `CONTACTS.md`
  is a generated view (created, refreshed, and removed by `fw-contacts.sh`).
  The `contacts/` folder leaves the workspace floor — scaffolded contact
  folders were the scattered-copies pattern ADR-008 forbids. (FEAT-194)
- `/fw-new-kb-domain <domain>` — grow the knowledgebase by a domain; creates
  `workspaces/kb` on first use; appends the domain's `INDEX.md` line;
  case-insensitive duplicate guard. `fw-new-workspace`'s kb path delegates here
  — either door, one code path. (FEAT-192)
- kb domain `research/` folder + seeded domain README carrying the
  reference-vs-research provenance rule, the kb-research vs project-hub-research
  boundary, and the `reference/` licensing note. (FEAT-201)
- Workspace template trees: `templates/workspaces/` (shared `floor/` + per-type
  overlays) as the one authored home for scaffold structure and seeded content;
  `fw-new-workspace.sh` composes floor + overlay; project-level
  `.claude/templates/workspaces/` override. (TASK-197 / FEAT-164)

### Changed
- Workspace type enum: **product, project, operations, knowledgebase** —
  `application` renamed `product`; `project` added; `sow` dropped (an SOW is a
  project named for the SOW). Retired names get pointer errors. (TASK-197)
- `fw-new-workspace` interface: type-first arguments (`<type> <name>`);
  `operations` and `kb` are fixed-name singletons; kb type accepts
  `KnowledgeBase|knowledgebase|kb|KB`; types case-insensitive; case-insensitive
  workspace collision guard. (FEAT-164)

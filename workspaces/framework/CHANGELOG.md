# Changelog — spearit-framework-dev

Plugin-scoped changelog (the framework IS the plugin, ADR-009 D3). Versions are
plain semver 0.x during the framework workspace build.

## [Unreleased]

### Added
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

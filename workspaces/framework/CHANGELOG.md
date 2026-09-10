# Changelog — spearit-framework-dev

Plugin-scoped changelog (the framework IS the plugin, ADR-009 D3). Versions are
plain semver 0.x during the framework workspace build.

## [Unreleased]

### Added
- **`Previously:` on contact records** — an assignment that has ended. When
  someone is replaced mid-engagement, their `Assigned:` line moves to
  `Previously:` instead of being deleted, and the successor gets their own
  `Assigned:` line. The generated view reads only `Assigned:` and so stays
  current, while the registry keeps the answer to "who set up the servers
  originally?" — a question that outlives the assignment and that nobody will
  think to answer with `git log`. **No dates:** a start date would have to be
  captured at assignment time to be true, and a field you must remember to fill
  at the right moment is a field that stays empty.

### Changed
- **`CONTACTS.md` groups people by `Group:`** — the dept/team within their org —
  so coverage is visible at a glance and there is an answer to "who else do I ask
  if this person is away". Groups alphabetical; unknown-group people last under
  *Group not recorded*; flat list when no groups are recorded, so existing views
  are unchanged until a `Group:` is filled in. **Affiliation is deliberately not
  shown in the view**: this is the file pasted into decks and project plans, and
  flagging who is a contractor there is not ours to publish. The fact stays in
  the record.
- **The move engine takes its namespace as an argument; it is never inferred.**
  `/fw-move` is renamed **`/fw-move-ops`** and always passes `operations` to
  `fw-move.sh`. Previously a bare numeric silently meant operations
  (`""|INC|REQ) NS="operations"`), so `fw-move 001,002,003 todo` resolved against
  operations and then failed because `todo` is not an operations folder — the wrong
  error, and a misroute waiting to happen at the ADR-009 D5 crossover. One command per
  namespace, and the script now carries a policy table (root, folders, transitions,
  terminal states) with a row per namespace. The `kanban` row is declared with its
  authored folder set but **not wired**: its transitions and gates are not ported, so
  it refuses with a pointer to the root `/fw-move` until crossover. (BUG-215)

### Fixed
- `fw-move-ops` accepts a **list of ids** again, restoring what the old engine had:
  `fw-move-ops "1, 2, 3" onhold`, comma- or space-separated, quoted or not. Items are
  validated and moved one at a time and the run continues past a failure, so a batch
  may partially apply — the `moved / skipped / failed` summary reports it, and a record
  already in the target is skipped rather than failed. Exit is non-zero if any item
  failed. `sweep` is unchanged. (BUG-215)

### Added
- A batch `fw-move-ops ... closed` **prompts for each record's resolution code in turn**.
  The code classifies one record, and the close gate is already per record (it also
  asks for a one-line reason and, for incidents, the durable-knowledge question), so
  one shared code paired with N individually-written outcomes would be incoherent.
  `--resolution` is therefore refused with a list and unchanged for a single id; with
  no terminal to prompt, those items fail cleanly rather than hanging on a read that
  cannot return. (BUG-215)
- CONTACTS.md views also refresh at **session start** (`SessionStart` hook on
  `startup|resume|clear`, `refresh-contacts.sh --all`). A record edited outside Claude
  Code — notepad, another editor, a merge — is invisible to `PostToolUse`, so the views
  stayed stale until the next in-Claude edit or commit. The session boundary is the
  earliest point those edits can be caught; pre-commit remains the later backstop.
  Silent no-op in repos with no contact registry, and never blocks a session opening.
  (BUG-212)
- CONTACTS.md views stay in step with the contact registry automatically, from both
  ends — the manual "rerun the script" step was a guardrail only if remembered, which
  the CLAUDE.md invariant rule forbids. Inside Claude Code: `hooks/hooks.json` +
  `hooks/refresh-contacts.sh` (PostToolUse on Edit/Write; no-op unless the edited path
  is a record under `workspaces/kb/company/contacts/`; never blocks the edit).
  Outside Claude Code (notepad, another editor, a merge): `fw-contacts.sh --check`
  verifies the committed views against the records and exits 1 with a diff, wired into
  `tools/pre-commit` and installed per-clone by `tools/install-git-hooks.sh`. `--check`
  generates into a throwaway mirror and diffs, so the view format has one implementation.
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
- **Operations is a root queue namespace, no longer a workspace** (TASK-213, ADR-009 D2
  amended): records live at `operations/` beside the future `kanban/` — a queue of cards
  is an index of work, not work, so queues are spine. `fw-move.sh`, `fw-next-id.sh`,
  `fw-new-ops-record.sh`, and `fw-contacts.sh` resolve `operations/` at the repo root;
  `operations` leaves the workspace type enum (→ `product`, `project`, `kb`) with a
  pointer error; the queue scaffold moved `templates/workspaces/operations/` →
  `templates/queues/operations/` and is created automatically on first
  `/fw-new-ops-record` (`.claude/templates/queues/` overrides). Separate ID sequences
  per namespace unchanged. Contact links from ops records now point to
  `../../workspaces/kb/company/contacts/`.
- `/fw-contacts refresh` regenerates the views — a self-documenting name for what was
  previously the bare, argument-less form (which still works). A command whose
  behaviour depends on remembering that no arguments means "refresh" is not
  self-documenting; `refresh` says it at the call site, and matches `/fw-move`'s
  existing bare-`sweep` keyword. Reserved word in that slot: a person actually named
  Refresh is addressed by slug (`/fw-contacts refresh-smith`).

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

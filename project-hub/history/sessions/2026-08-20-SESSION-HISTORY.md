# Session History: 2026-08-20

**Date:** 2026-08-20
**Participants:** Gary Elliott, Claude Code
**Session Focus:** TASK-197 refinement — workspace taxonomy open questions resolved; FEAT-198/199/200 filed

---

## Summary

Caught and corrected our own type drift (DECISION-197 used the retired `DECISION` type;
re-typed to TASK-197), then resolved all four of the item's open questions in a working
session: engagement instruments → kb `company` domain; the `deliverables/`
acceptance-boundary definition; the full six-type scaffold set locked with a
template-tree architecture; sow redefined as "a project wearing a contract" (dead-end
allowance retired); recurrence settled as schedule-definition + mint-on-observation.
Three new cards fell out: FEAT-198 (per-workspace roadmaps), FEAT-199 (deadline
awareness), FEAT-200 (schedule reminders / derived calendar).

---

## Work Completed

### TASK-197 (né DECISION-197): type correction

- Gary spotted at session start that DECISION-197 (filed yesterday) uses the `DECISION`
  work-item type that TECH-172 retires (record = ADR; the act of deciding is tracked by
  an ordinary work item). The accepted-type allowlist (`work-item-types.txt`, ADR-006)
  already excludes DECISION — the item was created by hand outside any create gate, on
  the visible precedent of four older DECISION items still in backlog.
- **Lesson re-confirmed:** a chokepoint that isn't called can't gate anything (the
  CLAUDE.md Implementation-Rule argument; FEAT-175's deterministic create gate is the
  mechanization). TECH-172 remains in todo/ and will disposition the older items.
- `git mv` rename → `TASK-197-workspace-type-taxonomy.md`, header re-typed, provenance
  note added. Only other references were yesterday's history/commits — left untouched
  as record. Then `/fw-move 197 todo`.

### TASK-197: all four open questions resolved (recorded in the item's "Resolved in refinement (2026-08-20)" section)

1. **Engagement-level instruments (MSA, NDA, rates) → kb `company` domain (FEAT-194).**
   Ops `agreements/` is scoped to operational agreements (FEAT-193) and an ops
   workspace is optional (BD-shape engagements have none), so it can't be the universal
   home. Spine-level folder rejected (ADR-009 D2).
2. **`project` scaffold = floor + `requirements/`.** No `plan/` folder: tactical plan is
   the board (`Workspace:` field), strategic plan is a workspace-owned roadmap
   (→ FEAT-198).
3. **`sow` scaffold = floor + `requirements/`** (`reports/` leaves per FEAT-196;
   `deliverables/` write-once per D4; no src-shaped folders ever).
4. **Recurring records (accounting): no taxonomy change.** Decomposes per Decision 5 —
   software = product workspace, recurring bookkeeping = ops records once live, linked
   not nested. Recurrence originates from a **schedule definition** in the ops workspace
   with **mint-on-observation** (script reads the definition at consulted chokepoints
   and creates due records — no daemon). Gary corrected the evidence table: SpearIT
   Accounting is a *product* today (own repo), ops comes later.

### New cards filed (each via `/fw-next-id`, accepted types)

- **FEAT-198 — per-workspace roadmaps.** Gary's insight: `/fw-roadmap` was conceived
  under repo-is-the-project; ADR-009 makes the repo the customer, so one spine roadmap
  no longer fits. Direction: roadmap is workspace-owned (`workspaces/<name>/ROADMAP.md`,
  product/project types, created on demand); close-test backs it (a project's roadmap
  freezes at close; a spine roadmap would accrete dead sections); engagement-level view
  is derived (FEAT-196), never a hand-kept master.
- **FEAT-199 — deadline awareness.** One `Due:` field convention shared by work items
  and ops records; overdue/due-soon surfaced deterministically at `/fw-status`//fw-wip`.
  From Gary: "reports, tasks, etc. with a documented deadline would be helpful if there
  were reminders."
- **FEAT-200 — schedule reminders / calendar view.** Gary's granularity question ("1
  calendar per person, per repo, or per workspace?") answered: **zero calendars are
  maintained — every calendar is a derived view** (ADR-008); granularity is a filter.
  Per-person = cross-repo aggregation (possibly .ics export), the part with independent
  life. Four dated-source shapes recorded for implementation review: cards (`Due:`),
  ops records (`Due:`), schedule definitions (recurring + one-shot), plan-artifact
  milestones (roadmap lines; sow contract dates transcribed into `requirements/` —
  the signed PDF stays legal authority, the transcription is the one parseable home).

---

## Decisions Made

1. **`deliverables/` keeps its name, gains one definition (all types that have it):**
   a file belongs there iff it was handed over and accepted — PMBOK's
   deliverable-vs-work-product line (PRINCE2's "product" vocabulary collides with our
   workspace type; construction's "handover dossier" is the same concept). Product →
   shipped snapshots; sow → as-delivered copies; project → the handover packet
   (as-builts, signed acceptance/test evidence, runbooks). Write-once at acceptance.
   Corollary: test *definitions* pair with requirements (executable acceptance
   criteria → `requirements/`); test *results* enter `deliverables/` only when owed.
2. **Scaffolds become template trees, script-composed.** Authored home
   `templates/workspaces/` in the plugin (source: `workspaces/framework/templates/`),
   as shared `floor/` + thin per-type overlays — never one tree per type (would restate
   the floor five times, ADR-008 root cause). Script stays the chokepoint (validation,
   refuse-if-exists, compose); `${CLAUDE_PLUGIN_ROOT}` resolves at runtime; a project's
   `.claude/templates/workspaces/` is the optional override (FEAT-195's channel).
   Folder semantics live as seeded READMEs authored once in the template. ADR-009 D3
   holds: the template IS the one home; the command is still the only path.
3. **Scaffold set locked (all six types):** floor = `meetings/ reference/ deliverables/
   contacts/ agreements/` (contacts pending FEAT-194); product = floor +
   `requirements/ poc/ src/ tests/ dist/`; project = floor + `requirements/`; sow =
   floor + `requirements/`; operations per FEAT-193; kb opts out (domains + INDEX).
4. **`requirements/` across all types, never `specs/`** — specs-vs-requirements is two
   names for one concept (the DECISION-vs-ADR lesson in miniature). The product
   overlay's seeded README states the lifecycle distinction once: living/versioned for
   a product, frozen-at-close for project/sow. (Gap fixed en route: the old
   `application` scaffold had no requirements home at all.)
5. **sow = a project wearing a contract** (Gary: "sow only handles the project side;
   any product gets its own folder"). Amends Decision 3's "referencing work rather than
   containing it": a sow contains its own project-side work (dies at acceptance),
   references all product-side work. Software is presumed to outlive acceptance →
   product workspace from day one (CATSettings included); **the dead-end allowance is
   retired** — no prophecy about follow-ons, no later migration. A sow never pairs with
   a project workspace (it subsumes that side); scaffold-identical to project, the type
   differs only in the commercial envelope and FEAT-196's contract baseline.
6. **Nothing dated needs to be a card.** Every notification needs one authored home
   *somewhere the framework reads* — card, ops record, schedule-definition entry, or
   plan-artifact milestone — with all views derived. Recorded in FEAT-200 for its
   implementation review, per Gary: "record the known inputs and we'll look at it
   again at implementation review."

---

## Files Modified

- `project-hub/work/todo/TASK-197-workspace-type-taxonomy.md` — re-typed from
  DECISION-197; all four open questions checked with resolutions; "Resolved in
  refinement (2026-08-20)" section added (template architecture, scaffold set,
  deliverables definition, sow reformulation, roadmap ownership); evidence table
  accounting row corrected; FEAT-198/199/200 added to Related.

## Files Created

- `project-hub/work/backlog/FEAT-198-per-workspace-roadmaps.md`
- `project-hub/work/backlog/FEAT-199-deadline-awareness-and-reminders.md`
- `project-hub/work/backlog/FEAT-200-schedule-reminders-and-calendar-view.md`
- `project-hub/history/sessions/2026-08-20-SESSION-HISTORY.md` — this file

## Files Moved

- `project-hub/work/backlog/DECISION-197-workspace-type-taxonomy.md` →
  `project-hub/work/todo/TASK-197-workspace-type-taxonomy.md` (git mv: rename + todo)

---

## Current State

### In doing/
- FEAT-164 — workspace scaffolding (`/fw-new-workspace`); now also the landing zone for
  the template-tree architecture decided today

### In todo/ (today's delta)
- TASK-197 — fully refined, no open questions; ripe for `→ doing` (pre-implementation
  review at the gate will re-walk deferred details)

### Next likely steps
- `/fw-move 197 doing` — ADR-009 amendment + scaffold/template implementation
  (coordinates with FEAT-193's script window and FEAT-164)
- TECH-172 (todo/) — retire DECISION type in content; disposition remaining open
  DECISION items (035, 036, 110, 162, 171)

---

## TASK-197 Implementation (Later Session)

**Continuation:** moved TASK-197 → doing (pre-implementation review) → implemented →
done, same day. WIP note: the move script reported 3/2 in doing/, actual was 2/2 —
BUG-174 (dotfile miscount) observed live.

### The sow type dropped at pre-implementation review

Gary challenged at review: *"Is there a reason to even have `sow` now that we've
defined it as a project? If I have an SOW, then I just give it the name of the SOW."*
Analysis agreed — after the morning's refinement the type carried nothing a project
doesn't (scaffold identical; write-once `deliverables/` generalized; contract =
content in `agreements/`; per-SOW identity = the workspace name). Dropping it also
un-tempts type-branched reporting (ADR-009 OQ5: type never branches runtime; report
baselines are content-driven). Third instance of the day's lesson: two names for one
concept (DECISION/ADR, specs/requirements, sow/project). **Final enum: product,
project, operations, knowledgebase.** The morning's five-type framing stands above as
the journey record.

### Implemented (all TASK-197 acceptance criteria checked)

- **ADR-009 amended in place** (D4-amendment precedent): OQ5 → four-type enum with
  rationale; D3 → the one authored home for structure + seeded content is the plugin's
  `templates/workspaces/` tree, script as sole chokepoint; change-log entry added.
- **Template trees authored** (`workspaces/framework/templates/workspaces/`): shared
  `floor/` + product/project/operations/knowledgebase overlays; seeded READMEs carry
  the semantics once — `deliverables/` acceptance-boundary rule (floor), requirements
  living-vs-frozen distinction (product), SOW-naming + product-splits-out guidance
  (project). kb overlay uses `_domain_/` placeholder renamed at creation.
- **`fw-new-workspace.sh` rewritten**: composes floor + overlay, `__NAME__`/`__DOMAIN__`
  substitution, project-level `.claude/templates/workspaces/` override, guards kept;
  `application`/`sow` rejected with pointer messages. Operations left with `intake/`
  deliberately — FEAT-193 is decided but in backlog; Implementation Rule held.
- **Command doc updated** (four types, SOW naming, template one-home).
- **Test workspaces regenerated from scratch** (Gary deleted the old set): `app1`
  product, `sow-001` project, `kb` + licensing, `operations`. Rejections and
  refuse-if-exists verified; override path verified via scratchpad fixture.
- **Built-artifact verification**: republished via `Publish-ToLocalMarketplace.ps1`;
  ran the script from the published marketplace junction against a scratch root —
  templates resolve beside the script in the artifact. Live-session smoke test after
  marketplace update + restart remains a user step.

### Also decided/answered (recorded in the owning items)

- **kb `company` domain** (Gary: "should kb/<company-name> be a default?") — direction
  in FEAT-194: literal name `company` (pointer stability; the repo is the customer),
  created on demand via `/fw-new-domain`, not scaffolded.
- **`intake/`** — already decided dead by FEAT-193: ops workspace root becomes the
  flow home (`open/onhold/closed`), Gary's kanban-root analogy exactly. Lands when
  193 moves to doing (now a small overlay edit).
- **Glob-scale concern** (`/fw-wip`, `/fw-next-id`) — dissolved: WIP reads only active
  folders; next-id is a filename-only script scan (subsecond at thousands);
  FEAT-195's year buckets keep active dirs small.
- **Released cards** — spine, per ADR-009 D2 (timeline never splits into workspace
  folders; `Workspace:` field carries scope). Gary's recollection of
  "in the workspace" was the `deliverables/` decision: shipped *files* → workspace,
  work-item *record* → spine. New wrinkle noted in FEAT-163: multi-product repos need
  workspace-qualified release buckets (`history/releases/dpmextract-v2.1/`).

### Files (this section)

- Modified: ADR-009 (amendments + changelog), `fw-new-workspace.sh`,
  `fw-new-workspace.md`, TASK-197 (sow-drop, acceptance criteria), FEAT-194 (seeding
  direction), FEAT-163 (release-bucket note)
- Created: `templates/workspaces/` tree (6 seeded .md + .gitkeep structure)
- Moved: TASK-197 todo → doing → done (Completed stamped by script)
- Regenerated (uncommitted test fixtures): `workspaces/{app1,kb,operations,sow-001}`

### Current State (end of day)

- **done/ (9):** TASK-197 newly complete
- **doing/:** FEAT-164 (the template architecture landed much of its scope — review
  its remaining criteria next session)
- **Next:** FEAT-193 → doing (ops overlay edit + regenerate operations workspace);
  live-session plugin smoke test; TECH-172 DECISION-type cleanup still queued

---

**Last Updated:** 2026-08-20

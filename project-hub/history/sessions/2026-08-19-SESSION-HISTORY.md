# Session History: 2026-08-19

**Date:** 2026-08-19
**Participants:** Gary Elliott, Claude Code
**Session Focus:** FEAT-164 testing (operations type) → operations workspace design review

---

## Summary

Resumed `/fw-new-workspace` testing with the operations type. The scaffold ran clean, but
reviewing its output turned into the real work of the session: a full design review of
the operations workspace that produced three new backlog items — FEAT-193 (scaffold
trim), FEAT-194 (kb `company` domain), FEAT-195 (record ID convention + lifecycle +
tooling adaptations). No implementation was touched; per the Implementation Rule the
script changes wait for the items to reach `doing/`.

---

## Work Completed

### FEAT-164: `/fw-new-workspace` — operations type test

- `/fw-new-workspace operations operations` ran clean: created
  `workspaces/operations/` with the current scaffold (floor + `intake/incidents`,
  `intake/requests`), README purpose filled in as a test-only placeholder.
- Not yet tested: the one-argument form (`fw-new-workspace.sh operations` with name
  defaulting to the type).
- The test workspace is deliberately **uncommitted** (like `app1`, `kb`, `sow-001`) —
  FEAT-193 includes regenerating it manually after the trim.

### Operations workspace design review → FEAT-193/194/195 filed

The scaffold review evolved through several reversals worth preserving:

1. **Gary's opening cut:** keep incidents/requests; drop `deliverables/` (the resolved
   records ARE the output); question `intake/` (what does the extra layer buy?),
   `contacts/` (scattered contact folders → hard to find; ALT: one company list with
   activity designations), `agreements/` (ok for SLAs), `meetings/` (ok if ops-specific).
2. **AI input:** agreed on flatten + drop deliverables; recognized Gary's contacts ALT
   as the Single-Source Rule applied to contacts; keep meetings and agreements
   (agreements scoped to operational — SLAs, vendor; client agreements stay with their
   SOW workspace).
3. **ITIL considered for intake growth:** candidates are problems, changes, events.
   All deliberately excluded: problems promoted from recurring incidents only when
   root-cause work is consciously funded; changes always live in the customer's
   change-management system (ServiceNow et al.) — the workspace holds pointers only.
4. **`company/` idea (Gary) → kb domain (AI):** Gary proposed a `company/` folder for
   fw-init (contacts, policies, org facts). Redirected to a `company` **knowledgebase
   domain** — the domain-first kb mechanism from ADR-009 D4 already exists, so no new
   top-level concept. Gary: "perfect solution."
5. **First settled tree** (superseded same session — see 6): `incidents/`, `requests/`,
   `meetings/`, `agreements/`, `reference/`.
6. **Kanban question (Gary) → location-is-status pivot:** Gary asked whether ops cards
   should ride the kanban and finish in an "operations done". Decided: **stay off the
   board** (kanban gates are built for planned work, not incident response; different ID
   namespaces) but **borrow location-is-status**: workspace-level flow folders
   `open/` → `onhold/` → `closed/`, type carried by filename prefix — the kanban's own
   folder=status / prefix=type pattern. This revised the tree from (5): category folders
   gave way to flow folders. One view of everything in flight comes from extending
   `/fw-wip` and `/fw-status`, not from merging boards. Incident-spawned project work
   becomes a cross-referenced kanban item — the systems link, they don't merge.
7. **`closed/` growth (Gary's gotcha):** periodic sweep into year buckets
   (`closed/2026/…`), the ops counterpart of FEAT-093 planning-period archival; sweep is
   a script, never a hand move. Trigger cadence left as an open question.

### Discovery: the shared scaffold floor

`fw-new-workspace.sh` builds application, sow, and operations from one `FLOOR` list
(`meetings reference deliverables contacts agreements`). The operations trim therefore
gives operations its own list, and whether `contacts/` leaves the floor for
application/sow too is explicitly parked as a FEAT-194 open question — not decided by
accident.

---

## Decisions Made

1. **Operations scaffold** (FEAT-193): `open/`, `onhold/`, `closed/`, `meetings/`,
   `agreements/`, `reference/`. Drops deliverables, contacts, and the intake layer.
2. **Company facts get one home** (FEAT-194): a kb `company` domain — contacts with
   activity-type designations, policies, org facts. Open: seeded by fw-init vs. created
   via `/fw-new-domain` (FEAT-192); floor-wide contacts removal; record format.
3. **Operations record IDs** (FEAT-195): ITIL prefixes `INC-###`/`REQ-###`, per-workspace
   sequence; customer tickets (Jira/ServiceNow) are a 0..n cross-reference field, never
   the primary key (their namespace isn't ours, mapping isn't 1:1, must survive customer
   tool changes).
4. **Tooling adapts, never duplicates** (Gary's direction, in FEAT-195): next-id and
   `fw-move` each keep one authored home, parameterized by namespace/folder root. Kanban
   gates (ripeness, dependency check) must NOT fire on ops moves — transition policy is
   per-namespace. Terminal-move stamping generalizes (Completed on → done, Closed on
   → closed).
5. **Scripts never delete** (Gary's caution, hardened into FEAT-193): the scaffold
   script keeps its refuse-if-exists guard; no delete/regenerate behavior in any script
   or command. Regenerating the test workspace is a one-time manual step, safe only
   because the placeholder is empty and uncommitted.
6. **Templates — direction under discussion** (recorded in FEAT-195): Gary leans "all
   templates in `.claude/`"; AI recommends authored-in-plugin (updates propagate with
   plugin version) with `.claude/templates/` as optional per-project override. Not yet
   settled.

---

## Files Created

- `project-hub/work/backlog/FEAT-193-operations-scaffold-trim.md` — scaffold trim +
  flow folders
- `project-hub/work/backlog/FEAT-194-company-domain-knowledgebase.md` — company facts'
  one home
- `project-hub/work/backlog/FEAT-195-operations-record-id-convention.md` — IDs,
  lifecycle, archival, tooling adaptations
- `workspaces/operations/` — test scaffold (uncommitted placeholder; regenerate under
  FEAT-193)

## Files Modified

- `workspaces/operations/README.md` — purpose set to test-only placeholder

---

## Current State

### In doing/
- FEAT-164 — workspace scaffolding (operations type tested this session; one-arg form
  still untested)

### In done/ (awaiting release)
- FEAT-165, FEAT-190, BUG-167, BUG-170, BUG-184, TECH-079, TECH-173

### Possible next steps
- Test the one-argument operations form and the remaining `/fw-new-workspace` error
  paths (FEAT-164).
- Ripeness review of FEAT-193/194/195; FEAT-195 may split (convention vs. tooling) if
  it feels like two items.
- Settle the template-home question (plugin-authored vs. `.claude`-authored).

---

## (Later) Afternoon Session — Reporting Design + Workspace Type Taxonomy

**Continuation:** After the morning commits, cleanup commits (research guide, settings,
Gary's retrospective notes — each separate per Gary), then two major design threads.

### FEAT-196: Workspace Progress Reporting (filed + largely designed)

Born from a catch while committing Gary's retro notes: his operations concept was
"requests, fulfilment, **reporting**" — and reporting was the leg FEAT-193/195 didn't
cover. Gary confirmed it as its own item: periodic reporting (activity, achievements,
impediments, progress) for **any** workspace; exec summary + customer detail; HTML/PDF
preferred over md (too verbose), ALT PPT; AI gathers/interprets → deterministic
assembly for consistency.

Decisions made across the afternoon (each committed as reached):

1. **`fw-report` owns `reports/` and its content** — created on first use, never at
   scaffold time (same principle that killed `deliverables/` for ops; works
   retroactively). Consequence: sow scaffold drops `reports/` when this lands.
2. **Input: one YAML per workspace per period** — facts gathered once, presented two
   ways. Schema-check script gates assembly (invariant in a chokepoint).
3. **Shared envelope, per-type activity rows** (same pattern as the scaffold's per-type
   `DIRS`): headline, outlook, metrics, timeline, achievements, impediments, activity,
   clarifications. Exec view is *composed* from shared fields — only headline/outlook
   are exec-exclusive (single-source inside the file). `clarifications` is the human
   channel: AI parks questions; assembly refuses while any are unanswered.
4. **One layered report, not two** (Gary's evolution mid-discussion): exec summary
   leads, linked detail behind it in the same document; exec-only email variant is a
   free byproduct.
5. **Timeline block** (Gary's gap: "execs always want to know when"):
   milestone/baseline/forecast/status/driver rows; execs read the baseline-vs-forecast
   *delta*; re-baseline is an explicit event, never a quiet edit.
6. **Baseline needs a commitment of record, not a WBS/Gantt** (Gary's gotcha): sow
   measures against the contract's milestones; agile products measure against release
   targets + velocity forecast (FEAT-104/093 already reach toward this); operations
   measures aging, not schedule. Consequence noted: each type eventually wants a
   lightweight plan-artifact convention (candidate future item, kept out of FEAT-196).

### DECISION-197: Workspace Type Taxonomy (the scenario walk)

Gary deliberately stress-tested the type list with a year of real work — BD (SOW-001
app+scripts; SOW-002 CATSettings; SOW-003 updates 001), Honda (HPC 2016→2019 upgrade;
DPMExtract pipeline; data requests), Toyota (CATIA/3DX + misc app support; package dev;
hundreds of admin scripts; install tests), and SpearIT itself (framework, accounting,
apps). The journey:

1. **HPC upgrade** exposed the gap: neither application (no product lifecycle) nor
   sow (contract is wrapper, not work) → a finite **project** type.
2. **BD-SOW-003 updating SOW-001's deliverable** exposed the big structural rule: the
   deliverable outlives the SOW, so **source never lives in the SOW workspace** —
   living source gets a product workspace; sow holds contract + acceptance + frozen
   deliverables and *references* the work. Dead-end allowance for small SOWs (002).
3. Gary added: sow workspace should hold contractual docs AND browsable frozen copies
   of delivered versions (git holds history but isn't accessible enough) → **write-once
   machine-written `deliverables/` snapshots** (guardrail: hand-edit one and it's
   `src.orig - Copy` again).
4. **Toyota support splitting across ops + product + kb** was reframed as the taxonomy
   *working* (link, don't merge — each part one home).
5. **Toyota's script hoard** dissolved via Gary's rename `application` → **`product`**
   (created/delivered/maintained — script libraries and packages stop being edge cases).
6. **SpearIT accounting** surfaced the recurring-records wrinkle (schedule-driven, not
   intake-driven — flow still works; origination is an open question).
7. Gary proposed the final five (product, project, knowledge, operations, contracts);
   settled as **product, project, sow, operations, knowledgebase** — "contracts" as a
   name was rejected because it hides the real open question of where engagement-level
   instruments (MSA/NDA) live. Product-vs-project discriminator: **the close test**
   (does the workspace ever close?).

Filed as DECISION-197 with the twelve-scenario evidence table; it amends ADR-009 and
is upstream of FEAT-193's script change.

### Commits (afternoon)
- `28133b6` research guide, `d8a47de` settings, `d02c82b` Gary's retro notes
- `10a8b03` FEAT-196 filed; `91b3f90` FEAT-196 reports/ ownership;
  `9f5c66e` FEAT-196 YAML shape/timeline/layered report
- `945d99f` DECISION-197

### Current state (end of day)
- In doing/: FEAT-164 (one-arg operations form still untested)
- Today's five design items in backlog/: FEAT-193/194/195/196, DECISION-197
- Likely order: DECISION-197 first (upstream of FEAT-193's script change)
- Still open: template home (plugin vs `.claude`), report presentation format
  (HTML→PDF vs PPT), cadence, MSA/NDA home, recurring records

---

**Last Updated:** 2026-08-19 (end of day)

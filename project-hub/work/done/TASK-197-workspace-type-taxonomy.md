# Task: Workspace Type Taxonomy — product, project, operations, knowledgebase

**ID:** TASK-197
**Type:** Task
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-08-19
**Workspace:** framework
**Completed:** 2026-08-20

---

## Summary

Amend ADR-009's workspace type enum, reshaped by a walkthrough of a year of real
engagements (2026-08-19 session) and refined 2026-08-20:

- **`product`** (renames `application`) — something we create, deliver, and maintain
- **`project`** (new) — a finite initiative we coordinate to completion; **subsumes
  sow** (2026-08-20 — see resolved section): an SOW is a project named for the SOW,
  whose contract is content, not a type
- **`operations`** — request/incident flow (FEAT-193/195 design)
- **`knowledgebase`** — domain-first knowledge (ADR-009 D4 amended)

Four types. Direction settled with Gary; this item carries the ADR-009 amendment and
the scaffold/schema changes. (As filed 2026-08-19 this was a five-type enum with `sow`
as a distinct commercial wrapper; the refinement below dissolved it into `project`.)

> Re-typed from DECISION-197 → TASK-197 (2026-08-20) per TECH-172's rule: the lasting
> record is an ADR (here, the ADR-009 amendment); the work of deciding/implementing is
> tracked by an ordinary work item. `DECISION` is not in the accepted type set (ADR-006).

---

## The Decisions

1. **`application` → `product`.** A product is defined by being created, delivered, and
   maintained — executables, script libraries, packages, pipelines all qualify. This
   dissolves the "toolbox" pressure (Toyota's hundreds of admin scripts are a product,
   not an edge case) and the one-workspace-per-product rule holds (Honda's DPMExtract:
   many console apps + scripts, one product workspace).

2. **`project` added — the close-test discriminates it from product.** A product
   persists (it has a version 2; the workspace lives as long as the thing does). A
   project **ends** — it reaches its goal, freezes, and never reopens; a follow-on is a
   new project. Secondary tell: a product accretes artifacts in `src/`; a project
   coordinates work whose result is mostly a changed state of the world, plus reports.
   Canonical case: Honda HPC Pack 2016→2019 upgrade — neither an application (no
   product lifecycle) nor an SOW (the contract is a wrapper, not the work).

3. **`sow` = commercial wrapper; the deliverable outlives the SOW, so source never
   lives in the SOW workspace.** Evidence: BD-SOW-003 updates what BD-SOW-001
   delivered — source inside SOW-001 would force a copy (drift; the `src.orig - Copy`
   tell) or a reach into a closed workspace. The living source gets a product
   workspace; SOW workspaces hold contract docs (drafts, signed PDFs), acceptance,
   reporting, and reference the product workspace. Instance-per-SOW stands (workspace
   named for the SOW id; lifecycle and reporting are per-SOW).
   - *Allowance:* a small, dead-end SOW (BD-SOW-002, CATSettings) may hold its own
     work — until a follow-on SOW proves continuity, at which point the work earns a
     product workspace.

4. **`deliverables/` in a sow workspace = as-delivered frozen snapshots, write-once,
   machine-written.** The browsable copy of exactly what shipped and was accepted
   (e.g. `deliverables/v1.2-2026-08-19/`), written by the release/delivery step and
   never edited by hand. Not ADR-008 duplication: it is an artifact of record, not a
   second working home. Git remains the authority for history; the snapshot exists for
   accessibility (Gary: git holds it but it's not as accessible).

5. **One real-world activity may split across types — that is the taxonomy working.**
   Toyota "application support" decomposes: ticket flow → operations; install/update/
   check tooling → product; procedures/how-tos → kb domains. Cross-references tie
   them; each part has one home. (Same link-don't-merge pattern as ops↔kanban.)

---

## Evidence: the scenario walk (four customers + SpearIT)

| Scenario | Lands as |
|---|---|
| BD-SOW-001 (app + ~5 scripts) | project `bd-sow-001` (contract + project-side work) + product workspace |
| BD-SOW-002 (CATSettings) | project `bd-sow-002` + product workspace (allowance retired) |
| BD-SOW-003 (update of 001) | new project `bd-sow-003`, same product workspace |
| Honda HPC 2016→2019 upgrade | project |
| Honda DPMExtract pipeline | product (one workspace, many exes) |
| Honda data extract/process requests | operations |
| Toyota CATIA/3DX + misc app support | operations + product (tooling) + kb (procedures) |
| Toyota package development + install tests | product (tests live with it) |
| Toyota admin script library | product (toolbox dissolved) |
| SpearIT Framework | product (`workspaces/framework`, the dogfood case) |
| SpearIT Accounting | product (the software) + operations records once live (schedule definition) + kb |
| SpearIT other apps | product each |

SpearIT itself is just another engagement where the customer is us — no special case.

---

## Open Questions (resolve before → doing)

- [x] **Engagement-level instruments** — resolved 2026-08-20: the kb `company` domain
      (FEAT-194) is the home. Ops `agreements/` stays scoped to operational agreements
      (FEAT-193), and an operations workspace is optional (BD-shape engagements have
      none), so it cannot be the universal home. Content shape lands with FEAT-194.
- [x] **Recurring records** — resolved 2026-08-20: no taxonomy change. Accounting
      decomposes per Decision 5: the accounting *software* is a product workspace; the
      recurring bookkeeping *activity* (once live) is operations records, linked not
      nested. Recurrence originates via a **schedule definition** in the ops workspace
      (recurring + one-shot entries) with **mint-on-observation**: a script reads the
      definition at the consulted chokepoints and creates due records — no daemon.
      Mechanics land in FEAT-195 (record shape), FEAT-199 (`Due:` surfacing), FEAT-200
      (calendar view; known date inputs recorded there — revisit at implementation
      review).
- [x] **`project` scaffold contents** — resolved 2026-08-20: floor + `requirements/`.
      No `plan/` folder: tactical plan is the board (`Workspace:` field, FEAT-163);
      strategic plan is a workspace-owned `ROADMAP.md` created on demand (FEAT-198).
- [x] **`sow` scaffold changes** — resolved 2026-08-20: floor + `requirements/` only
      (`reports/` leaves per FEAT-196); `deliverables/` write-once per D4 (guard lands
      in the release flow); no src-shaped folders ever. See the locked overlay set
      below. The dead-end-allowance question is resolved — see "sow = a project
      wearing a contract" in the resolved section.

---

## Resolved in refinement (2026-08-20)

- **`deliverables/` keeps its name and gains one definition across all types that have
  it:** a file belongs there iff it was handed over and accepted (PMBOK's
  deliverable-vs-work-product line). Product → shipped snapshots, sow → as-delivered
  copies (D4), project → the handover packet (accepted report, signed acceptance/test
  evidence, as-builts, runbooks). Write-once at acceptance; working copies stay where
  the work lives. Test *definitions* pair with requirements (they are the executable
  form of acceptance criteria → `requirements/`); test *results* enter `deliverables/`
  only when contractually owed.
- **Scaffolds become template trees, script-composed.** Authored home:
  `templates/workspaces/` in the plugin (source: `workspaces/framework/templates/`),
  as a shared `floor/` plus thin per-type overlays — never one full tree per type
  (that would restate the floor N times, the ADR-008 root cause). The script remains
  the sole chokepoint (name validation, refuse-if-exists, floor+overlay copy);
  resolved at runtime via `${CLAUDE_PLUGIN_ROOT}/templates/workspaces/`; a consuming
  project's `.claude/templates/workspaces/` is the optional override (same channel
  FEAT-195 set for record templates). Folder semantics (the deliverables/ definition
  above) live as seeded READMEs authored once in the template tree. ADR-009 D3 holds:
  the template *is* the one home; the command is still the only path to a workspace.
  Implementation lands with FEAT-164.
- **Scaffold set locked (2026-08-20, Gary):**
  - floor (authored once): `meetings/ reference/ deliverables/ contacts/ agreements/`
    — `contacts/` pending FEAT-194's floor question
  - **product**: floor + `requirements/ poc/ src/ tests/ dist/`
  - **project**: floor + `requirements/`
  - **sow**: floor + `requirements/`
  - **operations**: own list per FEAT-193 — `open/ onhold/ closed/ meetings/
    agreements/ reference/`
  - **knowledgebase**: opts out; domain tree + `INDEX.md`

  One name across types: **`requirements/`, never `specs/`** — specs-vs-requirements
  is two names for one concept (the DECISION-vs-ADR lesson), so the product overlay's
  seeded README states the distinction once: a product's requirements are living and
  versioned; a project's or sow's freeze at close. The question is answered in the
  template so it never needs re-answering. (Gap fixed en route: today's `application`
  scaffold had no requirements home at all.)
- **sow = a project wearing a contract (2026-08-20, Gary: "sow only handles the
  project side; any product gets its own folder").** Amends Decision 3's "referencing
  work rather than containing it": a sow *contains* its own project-side work (report
  drafts, analyses, coordination — artifacts that die at acceptance) and *references*
  all product-side work. Software/tooling is presumed to outlive acceptance, so it
  gets a product workspace from day one — CATSettings included; **the dead-end
  allowance is retired** (no prophecy about follow-ons, no later migration). A sow is
  never paired with a project workspace (it subsumes the project side); it pairs with
  product workspaces whenever software is involved. Scaffold-identical to project;
  the type differs in the commercial envelope: contract + acceptance in `agreements/`,
  write-once `deliverables/`, FEAT-196 baselining against the contract — whose key
  dates are transcribed machine-readably into `requirements/` (the signed PDF stays
  the legal authority; transcription is the one parseable home, ADR-008-ok).
- **Strategic plans are workspace-owned** (surfaced here, filed as FEAT-198):
  `ROADMAP.md` in product/project workspaces, created on demand; no spine master
  roadmap in the repo-is-the-customer model; milestones are dated roadmap lines the
  calendar (FEAT-200) derives from. No `plan/` folder in any overlay — tactical plan
  is the board, strategic plan is the workspace roadmap.
- **`sow` dropped as a type (2026-08-20, Gary at pre-implementation review: "If I
  have an SOW, then I just give it the name of the SOW").** After the refinement,
  the type carried nothing a project doesn't: scaffold identical, write-once
  `deliverables/` generalized to all types, contract + acceptance are content in
  `agreements/`, per-SOW identity is the workspace *name* (instance-per-SOW survives
  as a naming convention). FEAT-196's contract-vs-plan baseline becomes
  content-driven (whatever dated plan artifacts the workspace holds), which also
  fixes a quiet ADR-009 OQ5 violation — type must never branch runtime behavior.
  Third instance of today's lesson: two names for one concept (DECISION/ADR,
  specs/requirements, sow/project). The one real loss — "I have a new SOW" as
  intake intent — moves to FEAT-191's guided intake and the project template
  README ("contracted work is a project named for the SOW; contract in
  `agreements/`, key dates transcribed into `requirements/`"). **The enum is four:
  product, project, operations, knowledgebase.**

---

## Implementation Impact

- ADR-009 amendment (type enum → product/project/operations/knowledgebase; close-test;
  product-work-splits-out principle; D3 refined to template-tree one-home).
- `fw-new-workspace.sh`: template-tree compose (floor + overlays from
  `templates/workspaces/`, project `.claude/templates/workspaces/` override); rename
  `application` → `product`, add `project`, drop `sow`; operations list untouched
  (FEAT-193's change, still in backlog).
- Template trees authored: floor + product/project/operations/knowledgebase overlays,
  seeded READMEs (deliverables/ acceptance-boundary definition; per-type README with
  the requirements lifecycle distinction and, on project, the SOW-naming guidance).
- Command doc / help text for `/fw-new-workspace`.
- Write-once guard for `deliverables/` belongs to the release/delivery flow
  (`/fw-release`, FEAT-196 adjacency), not this item.

---

## Acceptance Criteria

- [x] ADR-009 amended via change-log + in-place amendment notes: four-type enum,
      sow-dropped rationale, template-tree refinement of D3, deliverables/requirements
      definitions
- [x] `fw-new-workspace.sh` composes from template trees: `product` = floor +
      `requirements/ poc/ src/ tests/ dist/`; `project` = floor + `requirements/`;
      `knowledgebase` unchanged in shape; `operations` unchanged pending FEAT-193
      (verified 2026-08-20: all four types generated correctly)
- [x] `application` and `sow` are rejected as types (with a pointer to `product` /
      "name the project for the SOW") — verified, guard refuses existing workspaces
- [x] Structure + seeded content authored once under `templates/workspaces/`; no
      document restates the trees; project-level `.claude/templates/workspaces/`
      override honored (verified via --root fixture in scratchpad)
- [x] `/fw-new-workspace` command doc reflects the four types and SOW naming guidance
- [x] Test workspaces regenerated via the script only (fresh after manual deletion):
      `app1` product, `sow-001` project, `kb` knowledgebase/licensing, `operations`
- [x] Built-plugin verification (TECH-188 standing check): published via
      `Publish-ToLocalMarketplace.ps1` 2026-08-20; `fw-new-workspace.sh` executed from
      the published marketplace copy (not the source tree) against a scratch root —
      templates resolved beside the script, project workspace generated correctly.
      (Live-session smoke test after `/plugin marketplace update` + restart remains a
      user step.)

---

## Related

- **ADR-009** — the decision this amends (D3 one-home script, D4 kb domains).
- **FEAT-164** — `/fw-new-workspace` (in doing/; scaffold script is where this lands).
- **FEAT-193/194/195** — operations trim, company kb domain, record IDs (same review).
- **FEAT-196** — reporting; project/product timelines baseline against plan artifacts,
  sow against the contract.
- **FEAT-165** — old framework's repo-level `engagement` type; different taxonomy
  level (the whole-customer container these workspaces live inside), not superseded.
- **FEAT-198/199/200** — filed from this item's 2026-08-20 refinement: per-workspace
  roadmaps; deadline awareness (`Due:` + surfacing); schedule reminders / derived
  calendar (known date inputs recorded there for implementation review).

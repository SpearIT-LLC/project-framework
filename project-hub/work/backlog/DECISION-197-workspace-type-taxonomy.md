# Decision: Workspace Type Taxonomy — product, project, sow, operations, knowledgebase

**ID:** DECISION-197
**Type:** Decision
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-08-19
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

Amend ADR-009's workspace type enum from four types to five, reshaped by a walkthrough
of a year of real engagements (2026-08-19 session):

- **`product`** (renames `application`) — something we create, deliver, and maintain
- **`project`** (new) — a finite initiative we coordinate to completion
- **`sow`** — the commercial wrapper: contract + acceptance + frozen deliverables,
  **referencing** work rather than containing it
- **`operations`** — request/incident flow (FEAT-193/195 design)
- **`knowledgebase`** — domain-first knowledge (ADR-009 D4 amended)

Four flow-shaped types plus one commercial wrapper. Direction settled with Gary;
this item carries the ADR-009 amendment and the scaffold/schema changes.

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
| BD-SOW-001 (app + ~5 scripts) | sow wrapper + product workspace |
| BD-SOW-002 (CATSettings) | sow holding own work (dead-end allowance) |
| BD-SOW-003 (update of 001) | new sow, same product workspace |
| Honda HPC 2016→2019 upgrade | project |
| Honda DPMExtract pipeline | product (one workspace, many exes) |
| Honda data extract/process requests | operations |
| Toyota CATIA/3DX + misc app support | operations + product (tooling) + kb (procedures) |
| Toyota package development + install tests | product (tests live with it) |
| Toyota admin script library | product (toolbox dissolved) |
| SpearIT Framework | product (`workspaces/framework`, the dogfood case) |
| SpearIT Accounting | operations (schedule-driven — see OQ) + kb + company domain |
| SpearIT other apps | product each |

SpearIT itself is just another engagement where the customer is us — no special case.

---

## Open Questions (resolve before → doing)

- [ ] **Engagement-level instruments** — MSA, NDA, rate agreements belong to no single
      SOW. Home candidates: operations `agreements/` (alongside SLAs) or the company kb
      domain (FEAT-194). Deliberately not solved by naming the type "contracts".
- [ ] **Recurring records** (SpearIT accounting): ops flow assumes intake-driven
      records; accounting's are opened by the calendar. The open/onhold/closed flow
      still works — decide how recurrence originates records (watch-item from FEAT-195).
- [ ] **`project` scaffold contents** — likely near sow's (floor + requirements) minus
      contract-specific parts; the script stays the one home (ADR-009 D3).
- [ ] **`sow` scaffold changes** — `deliverables/` gains its write-once meaning;
      `reports/` already leaves per FEAT-196. Does `src`-shaped anything remain? (No.)

---

## Implementation Impact

- ADR-009 amendment (type enum, sow-references-work principle, close-test).
- `fw-new-workspace.sh`: rename `application` → `product`, add `project` scaffold,
  adjust `sow` per the above. Coordinates with FEAT-193 (operations trim) — likely the
  same script change window.
- Command doc / help text for `/fw-new-workspace`.
- Write-once guard for sow `deliverables/` belongs to the release/delivery flow
  (`/fw-release`, FEAT-196 adjacency), not this item.

---

## Related

- **ADR-009** — the decision this amends (D3 one-home script, D4 kb domains).
- **FEAT-164** — `/fw-new-workspace` (in doing/; scaffold script is where this lands).
- **FEAT-193/194/195** — operations trim, company kb domain, record IDs (same review).
- **FEAT-196** — reporting; project/product timelines baseline against plan artifacts,
  sow against the contract.
- **FEAT-165** — old framework's repo-level `engagement` type; different taxonomy
  level (the whole-customer container these workspaces live inside), not superseded.

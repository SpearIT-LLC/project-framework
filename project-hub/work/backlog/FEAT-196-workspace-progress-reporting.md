# Feature: Workspace Progress Reporting

**ID:** FEAT-196
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-08-19
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

A simple, repeatable method to report progress on **any workspace** at periodic
intervals: activity, achievements, impediments, progress. Two audiences from the same
underlying data:

- **Executive summary** — short, presentation-grade.
- **Detailed activity report** — per-record detail for the customer.

Surfaced 2026-08-19: the operations design (FEAT-193/195) covered intake and lifecycle
but not the "reporting" leg of Gary's operations concept (requests, fulfilment,
reporting — 2026-07-23 retrospective notes).

---

## Direction (Gary, 2026-08-19)

- **Output format: HTML/PDF preferred** — markdown tends to be too verbose for customer
  presentation. ALT: PowerPoint. Format and presentation are a decision to make, not yet
  made.
- **Skeleton by script, content by AI:** likely a scripted skeleton builder taking
  YAML or markdown input (needs discussion), i.e. AI does the info-gathering and
  interpretation, then feeds a **deterministic assembly process for consistency** —
  the framework's standard hybrid (judgment in the AI step, invariants in the script).

## Data sources (by workspace type)

- Operations: flow folders (`open/`, `onhold/`), the year-bucketed `closed/`
  (FEAT-193/195) — designed to be report-friendly.
- Kanban board: done/released items per period (cf. FEAT-093 planning periods,
  FEAT-104 velocity tracking).
- Session histories: the narrative of what happened and why.
- SOW workspaces: deliverables/requirements/reports folders.

---

## Open Questions (resolve before → doing)

- [ ] Format decision: HTML→PDF vs. PPT (or both, from one source)? What does
      "presentation-grade" require?
- [ ] Cadence: on demand, or tied to planning periods (FEAT-093)?

## Decided (Gary, 2026-08-19)

- **Input format: one YAML file per workspace per period.** Facts gathered once,
  presented multiple ways. AI authors it (gathering + interpretation); a schema-check
  script gates assembly — the invariant lives in a chokepoint, not prose.
- **Envelope shared across all types; only activity-row shape and metric names are
  per-type** (same pattern as the scaffold's per-type `DIRS`). One assembly engine, one
  `/fw-report` command. Envelope: `workspace`, `period`, `headline`, `outlook`,
  `metrics`, `timeline`, `achievements`, `impediments`, `activity`, `clarifications`.
  - `headline`/`outlook` are the only exec-exclusive authored fields (pure judgment);
    the exec view is otherwise **composed** from shared fields — nothing restated
    (single-source inside the file).
  - `achievements`/`impediments` carry `refs:` to activity rows; `impediments` carry
    `needs:` — the explicit ask, often the exec's only action item.
  - `timeline` (Gary: "execs always want to know when") — rows of
    `milestone / baseline / forecast / status / driver`. The exec reads the
    baseline-vs-forecast **delta**; `driver` links to the record moving the date.
    `baseline` is the commitment of record — re-baselining is an explicit reported
    event, never a quiet edit. Most load-bearing for application and sow; optional for
    operations.
  - `activity` rows are column-shaped for direct table rendering. Per type:
    ops = INC/REQ records; sow = deliverables/milestones vs. plan;
    application = work items and releases.
  - `clarifications` is the human-input channel: AI parks questions it can't resolve;
    assembly refuses to run while any are unanswered — human judgment solicited exactly
    where needed, never silently skipped.
- **One layered report, not two.** Executive summary leads (headline → metrics →
  highlights → impediments/asks → timeline → outlook); linked detail sits behind it in
  the same document (HTML collapsibles / PDF appendix). An exec-only variant for email
  is a free byproduct of the same input.
- **`fw-report` has sole responsibility for the `reports/` folder and its content.**
  The folder is created on first use, never at scaffold time — folders exist when
  content exists, the flow's structure is authored in one home (the command, ADR-009
  D3 pattern), and it works retroactively on workspaces that predate reporting.
- Consequence: the `sow` scaffold drops `reports/` from `fw-new-workspace.sh` when this
  lands, so a report never has two possible homes.

---

## Acceptance Criteria

- [ ] One command produces both an executive summary and a detailed activity report for
      a chosen workspace and period
- [ ] `fw-report` creates `reports/` on first use; no scaffold pre-creates it (sow's
      `reports/` removed from `fw-new-workspace.sh`)
- [ ] Output is customer-presentable in the decided format (not raw markdown)
- [ ] Assembly is deterministic — same inputs, same structure; AI contributes gathering
      and interpretation, not layout
- [ ] Works against at least operations and sow workspace types
- [ ] Verified against the built plugin, not the source tree

---

## Related

- **FEAT-193 / FEAT-195** — operations flow folders and year-bucketed `closed/` are the
  primary data source for ops reporting.
- **FEAT-093** — planning-period archival; natural reporting cadence.
- **FEAT-104** — velocity tracking; kanban-side metrics.
- **2026-07-16 retrospective (2026-07-23 notes)** — operations = requests, fulfilment,
  reporting.

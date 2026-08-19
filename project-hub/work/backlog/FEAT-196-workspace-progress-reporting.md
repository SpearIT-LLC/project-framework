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
- [ ] Input format for the skeleton: YAML vs. md front-matter vs. direct from folder
      state?
- [ ] Cadence: on demand, or tied to planning periods (FEAT-093)?
- [ ] Scope of the command: one `/fw-report <workspace> [period]` for all types, or
      per-type variants?
- [ ] Where do generated reports live — the workspace's `reports/` (sow has one;
      operations has `reference/`)?

---

## Acceptance Criteria

- [ ] One command produces both an executive summary and a detailed activity report for
      a chosen workspace and period
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

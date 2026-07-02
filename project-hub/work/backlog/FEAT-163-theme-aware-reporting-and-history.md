# Feature: Stream-Aware Reporting and History

**ID:** FEAT-163
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-07-02
**Theme:** Workflow
**Planning Period:** [Optional]

---

## Summary

Add the ability to view and report project status **by stream**, and ensure session
history (and, where relevant, git/release history) can be organized by stream. This
is the missing half of the multi-SOW customer model (ADR-005): a tagging field
exists on work items (`Theme:`), but nothing consumes a stream dimension for
reporting, and it must first be decided whether "stream" reuses `Theme` or is a
distinct field.

## Motivation

Per ADR-005, a single customer repo (`type: toolbox`) hosts multiple **streams**
(a stream = an SOW, deliverable, or phase). With one shared Kanban board, the
contractor needs to slice the board and history by stream on demand — "show me only
sow-02 work," "what did I do for the jobqueue stream last month." Today `/fw-status`
and `/fw-wip` have no stream awareness.

## Scope

**In:**
- **Decide the stream field first** (ADR-005 open question): reuse the existing
  `Theme:` field or add a distinct `Stream:` field. Team leans distinct — `Theme`
  already means *stable category* and overloading it with *stream* mixes two
  meanings. This decision gates the rest of the item.
- Stream filter/grouping for status reporting — either `/fw-status --stream <value>`
  and `/fw-wip --stream <value>`, or a dedicated `/fw-stream` view (decide during
  design).
- Group-by-stream summary (counts per stream across backlog/todo/doing/done).
- **Surface unassigned items** — items with no stream should be reported as such, so
  stream drift is visible (see ADR-005 risk).
- Ensure **session history** (`/fw-session-history`) records/labels by stream so a
  per-stream history slice is possible.

**Out (this item):**
- Git tag namespacing per stream (deferred in ADR-005).
- The `streams/` / `customer/` content folder structure (see FEAT-164).

## Acceptance Criteria

- [ ] Stream-field decision recorded (reuse `Theme` vs. new `Stream` field).
- [ ] A command produces status grouped or filtered by stream.
- [ ] Work items lacking a stream value are counted and flagged, not silently dropped.
- [ ] Session history output can be filtered/labeled by stream.
- [ ] Reuses existing frontmatter parsing in `/fw-*` commands (no new parser).
- [ ] Documented in framework-commands reference.

## Notes

- The `Theme:` field is confirmed present in FEATURE, BUG, and TECH work-item
  templates (verified 2026-07-02). If the decision is a distinct `Stream:` field,
  the templates need that field added (low risk, optional field).
- Decide filter-on-existing-command vs. new `/fw-stream` command early — affects docs
  and discoverability.

## Related

- ADR-005 (multi-SOW / engagement customer repo model)
- FEAT-164 (scalable stream content folder structure)
- FEAT-165 (introduce the `engagement` project type)

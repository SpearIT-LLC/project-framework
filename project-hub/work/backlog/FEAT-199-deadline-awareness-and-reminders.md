# Feature: Deadline Awareness and Reminders

**ID:** FEAT-199
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-08-20
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

Anything in the framework with a documented deadline — reports due, operations records
with due dates, recurring obligations (month-end close), work items with committed
dates — should be surfaced before it is late. Today a deadline written in a record is
inert prose: the framework never reads it back, so reminding lives in the human's
calendar or nowhere.

Filed from TASK-197 refinement (Gary, 2026-08-20): "Reports, tasks, etc. with a
documented deadline would be helpful if there were reminders. That sounds like a card
by itself."

## Direction (proposed, confirm at design)

- **One conventional field, machine-readable** (e.g. `**Due:** YYYY-MM-DD`) usable on
  kanban work items and operations records alike — one convention, one parser
  (FEAT-163's shared-frontmatter-parser criterion applies).
- **Surface at the chokepoints that already run**: `/fw-status` and `/fw-wip` report
  due-soon and overdue entries. No daemon, no scheduler — the framework reminds when
  consulted, deterministically (script-computed from the field, not AI judgment).
- **Recurrence connects here**: a recurrence definition (FEAT-195 watch-item, TASK-197
  accounting case) is a standing source of future due dates; the same surfacing shows
  "record overdue to exist" alongside "record overdue to close."
- Out of scope: push notifications, calendar sync, external schedulers — value first
  via the consulted-chokepoint model; unattended reminding is a later layer if ever.

## Acceptance Criteria

- [ ] A due-date field convention documented in exactly one home, shared by work items
      and operations records
- [ ] `/fw-status` (and/or `/fw-wip`) lists overdue and due-soon items, computed by
      script, not judgment
- [ ] Items without the field are simply unlisted — absence is not an error
- [ ] Verified against the built plugin, not the source tree

## Related

- **TASK-197** — taxonomy refinement that surfaced this (accounting's calendar-driven
  obligations).
- **FEAT-195** — operations record convention; recurrence definitions produce due dates.
- **FEAT-196** — progress reporting; reports with deadlines are one of the inputs.
- **FEAT-163** — one shared parser across commands.
- **FEAT-104** — velocity tracking (backlog); adjacent date-aware reporting, not a
  dependency.

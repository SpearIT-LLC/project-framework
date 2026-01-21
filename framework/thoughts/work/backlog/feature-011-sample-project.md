# Feature: Trivial Sample Project

**ID:** FEAT-011
**Type:** Feature
**Priority:** Low
**Version Impact:** MINOR
**Created:** 2025-12-19

---

## Summary

Create a simple, complete example project demonstrating framework usage at each level (Minimal, Light, Standard).

---

## Problem Statement

Users learn best from examples. Current documentation explains framework but doesn't show it in action on a trivial project.

**Current state:** HPC project is only real-world example (too complex for beginners).

---

## Requirements

- [ ] Create trivial application (e.g., "Task Timer CLI" or "File Organizer")
- [ ] Implement 3 versions showing framework levels:
  - [ ] Minimal: Single script with README
  - [ ] Light: Multi-file tool with status tracking
  - [ ] Standard: Full application with planning, work items, decisions
- [ ] Show complete workflow: Research → Plan → Code → Release
- [ ] Include sample work items in thoughts/project/work/
- [ ] Include sample ADRs in thoughts/project/research/adr/
- [ ] Include sample session history
- [ ] Include sample retrospective

---

## Implementation Notes

**Proposed Project:** "Task Timer" CLI tool
- Minimal: Single script that starts/stops timer, saves to CSV
- Light: Multi-command tool with reporting, JSON config
- Standard: Full CLI with plugins, testing, documentation, planning artifacts

Should demonstrate:
- Framework structure at each level
- How work items flow through kanban
- How decisions are documented (ADRs)
- How releases are managed
- Real git history showing framework workflow

Location: `examples/task-timer-{minimal,light,standard}/`

---

**Last Updated:** 2025-12-19
**Status:** Backlog - Future (v2.2.0)

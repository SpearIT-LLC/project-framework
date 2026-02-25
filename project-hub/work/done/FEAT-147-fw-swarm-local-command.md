# Feature: `/fw-swarm` Local Framework Command

**ID:** FEAT-147
**Type:** Feature
**Priority:** Medium
**Created:** 2026-02-20

---

## Summary

Add `fw-swarm.md` as a local slash command available to all framework-based projects, mirroring the full `/spearit-framework:swarm` experience. Users who don't have the full plugin installed should still have access to the two-phase kick-off facilitation via `/fw-swarm`.

---

## Problem Statement

The `/spearit-framework:swarm` command is only available when the full plugin is installed. Projects bootstrapped from the starter template have no equivalent local command for facilitating a project kick-off conversation.

**Context:**
The `/fw-swarm` command follows the same pattern as other `fw-` commands — local equivalents of plugin commands that work without plugin installation.

**Impact:**
Any project using the starter template gets the full swarm experience out of the box.

---

## Requirements

**Must Have:**
- `fw-swarm.md` added to `.claude/commands/` (framework repo)
- `fw-swarm.md` added to `templates/starter/.claude/commands/`
- `fw-help.md` updated in both locations to list `/fw-swarm`
- Full fidelity with plugin `swarm.md` — same two-phase experience, same `--summary` flag

**Out of Scope (for this version):**
- Resolving the starter template duplication problem (tracked separately)
- Any behavioral changes to the swarm command itself

---

## Proposed Solution

Copy and adapt `plugins/spearit-framework/commands/swarm.md` to `fw-swarm.md` in both command locations. The command content is identical except the usage examples reference `/fw-swarm` instead of `/spearit-framework:swarm`.

---

## Acceptance Criteria

- [x] `fw-swarm.md` exists in `.claude/commands/`
- [x] `fw-swarm.md` exists in `templates/starter/.claude/commands/`
- [x] `fw-help.md` updated in both locations
- [x] `/fw-swarm` and `/fw-swarm --summary` both work correctly
- [x] Tested in framework project

---

## Implementation Notes

Source file: `plugins/spearit-framework/commands/swarm.md`

Only change needed when adapting: update usage examples from `/spearit-framework:swarm` to `/fw-swarm`.

The next-step suggestion at the end (`/spearit-framework:new`) should reference `/fw-new` for the local command context.

---

**Last Updated:** 2026-02-24
**Status:** Done
**Completed:** 2026-02-24

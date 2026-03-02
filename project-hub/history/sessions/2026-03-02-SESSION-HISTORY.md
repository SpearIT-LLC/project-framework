# Session History: 2026-03-02

**Date:** 2026-03-02
**Participants:** Gary Elliott, Claude Code
**Session Focus:** TECH-151 — Document Work Item Artifacts Pattern

---

## Summary

Completed TECH-151, documenting the "folder-follows-parent" artifacts pattern that had been
implemented for TECH-094 but never formally documented. Added a new "Work Item Artifacts" section
to workflow-guide.md, updated fw-move with artifact folder handling, added optional Artifacts
sections to all 5 work item templates, and updated CHANGELOG.md.

---

## Work Completed

### TECH-151: Document Artifacts Pattern

- Added "Work Item Artifacts" section to `workflow-guide.md` (new TOC entry #4, inserted
  between Workflow Transitions and Planning Guidelines)
- Documented pattern overview with directory structure example using TECH-094 as reference
- Documented lifecycle rules including the glob pattern (`WORK-ID*`) that captures both the
  `.md` file and artifact folder in a single operation
- Documented exceptions (cross-cutting research → `project-hub/research/`, stakeholder
  reports deferred to FEAT-015, large files/binaries deferred)
- Documented pre-commit hook behavior — hook skips `done/WORK-ID/` subfolders by design,
  since artifacts aren't work items and can be any file type
- Added artifact folder handling to `fw-move.md` Execute Move section — after script
  succeeds, check for `WORK-ID/` in source folder and `git mv` it to target; report to user
- Added commented-out optional `## Artifacts` section to all 5 work item templates
  (FEATURE, TECHDEBT, BUG, SPIKE, DECISION) — opt-in by default, no clutter on items
  that don't use the pattern
- Updated `framework/CHANGELOG.md` under `[Unreleased] → Added`
- Moved TECH-151 to `done/`

---

## Decisions Made

1. **Artifact folder handling — AI layer vs. script layer:**
   - Decision: Handle in AI layer (`fw-move.md`) rather than modifying `move.sh`
   - Rationale: Consistent with how other post-move steps are handled (session history,
     commit nudge, etc.); avoids modifying a validated script; simpler to maintain

2. **Template Artifacts section — commented-out vs. active:**
   - Decision: Commented out by default
   - Rationale: Not every work item needs an artifact folder; opt-in prevents clutter on
     items that don't use the pattern

3. **Section placement in workflow-guide.md:**
   - Decision: After "Workflow Transitions", before "Planning Guidelines"
   - Rationale: Artifacts are a workflow pattern — they belong near transition rules,
     not buried in planning or documentation sections

---

## Files Modified

- `framework/docs/collaboration/workflow-guide.md` — Added "Work Item Artifacts" section;
  TOC updated from 9 to 10 entries
- `.claude/commands/fw-move.md` — Added artifact folder check and move in Execute Move section
- `framework/templates/work-items/FEATURE-TEMPLATE.md` — Added optional Artifacts section
- `framework/templates/work-items/TECHDEBT-TEMPLATE.md` — Added optional Artifacts section
- `framework/templates/work-items/BUG-TEMPLATE.md` — Added optional Artifacts section
- `framework/templates/work-items/SPIKE-TEMPLATE.md` — Added optional Artifacts section
- `framework/templates/work-items/DECISION-TEMPLATE.md` — Added optional Artifacts section
- `framework/CHANGELOG.md` — Added TECH-151 entry under [Unreleased]
- `project-hub/work/doing/TECH-151-document-artifacts-pattern.md` — Completed date set
  (2026-03-02), acceptance criteria checked, implementation checklist fully checked

## Files Moved

- `project-hub/work/doing/TECH-151-document-artifacts-pattern.md` → `project-hub/work/done/`

---

## Current State

### In done/ (awaiting release)
- TECH-151: Document Artifacts Pattern (completed today)
- 7 other items from prior sessions (DECISION-097 and others)

### In doing/
- (empty)

---

**Last Updated:** 2026-03-02

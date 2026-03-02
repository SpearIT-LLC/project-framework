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

---

## Work Completed (Afternoon Session)

### FEAT-099: /fw-release Command — Phase 1 Implementation

- Opened FEAT-099 for review; identified stale dependency on TECH-079
- Removed TECH-079 from `Depends On` — FEAT-099 absorbs the empty guard behavior entirely;
  TECH-079 is redundant once the command exists
- Moved FEAT-099 → `doing/`
- Conducted extended pre-implementation design discussion covering 5 open questions before
  writing the command
- Created `.claude/commands/fw-release.md` — Phase 1 implementation (8-step process)
- Added `release` section to `framework.yaml` with multi-product archive path configuration
- Updated FEAT-099 implementation checklist (Phase 1 items marked complete) and CHANGELOG Notes

---

## Decisions Made (Afternoon Session)

1. **TECH-079 dependency removed:**
   - FEAT-099 implements the empty done/ guard as FR1 — TECH-079 (a doc-only item) becomes
     moot when the command exists; dependency removed to unblock the move to doing/

2. **CHANGELOG Notes missing → synthesize from work item (normal case):**
   - Only 2 of 7 current done/ items have a `## CHANGELOG Notes` section — reconstruction
     from Summary is the normal path, not the exception
   - Command checks for the section first, falls back to synthesis; presents result to user
     for review before writing anything to CHANGELOG.md

3. **Multi-product archive paths — `products[]` in `framework.yaml`:**
   - `fw-release [product-id]` argument sets archive path segment; no argument uses `default_product`
   - Consistent `products[]` structure for both single and multi-product repos
     (single-product = one entry in the list)
   - `default_product: framework` set for this repo

4. **Cross-product items — archive to highest-priority product:**
   - Items touching multiple products archive under the highest-priority product
     (lowest `priority` number in `framework.yaml`)
   - Both affected products' CHANGELOGs get the entry
   - AI recommends split at release time; user confirms before anything is written

5. **doing/ non-empty → block release (bypassable with --force):**
   - Rationale: half-implemented work not recorded = out-of-sync release
   - Mixed done/ items (cross-product) generate a warning + recommendation, not a hard block
   - Empty done/ is a hard block with no override

6. **No auto-push:**
   - Command ends with advisory: "Ready to push to GitHub: `git push origin main --tags`"
   - Developer decides when/whether to push; different teams have different opinions on
     AI-initiated pushes

7. **done/ item count correction:**
   - move.sh output `8/∞` counted the `.gitkeep` file — actual count is 7 work items
   - Morning session history was already correct ("7 other items")

---

## Files Created (Afternoon Session)

- `.claude/commands/fw-release.md` — Phase 1 `/fw-release` command (8 steps: config read,
  validation, version calc, CHANGELOG build, file updates, git tag, archival, summary)

## Files Modified (Afternoon Session)

- `project-hub/work/todo/FEAT-099-fw-release-command.md` — removed TECH-079 from Depends On
- `project-hub/work/doing/FEAT-099-fw-release-command.md` — Phase 1 checklist items marked
  complete; CHANGELOG Notes updated to reflect actual implementation
- `framework.yaml` — added `release` section with `default_product: framework` and
  `products[]` entries for framework, plugin-full, plugin-light

## Files Moved (Afternoon Session)

- `project-hub/work/todo/FEAT-099-fw-release-command.md` → `project-hub/work/doing/`

---

## Current State (End of Day)

### In done/ (awaiting release)
- TECH-151: Document Artifacts Pattern (completed this morning)
- DECISION-097: Release Sizing Policy
- FEAT-145, FEAT-147, FEAT-150, TECH-116, TECH-117 (from prior sessions)
- 7 items total

### In doing/
- FEAT-099: /fw-release Command (Phase 1 complete — testing + docs remain)

---

**Last Updated:** 2026-03-02

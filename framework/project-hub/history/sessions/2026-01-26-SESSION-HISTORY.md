# Session History: 2026-01-26

**Date:** 2026-01-26
**Participants:** Gary Elliott, Claude Code
**Session Focus:** TECH-075 spike workflow fix, TECH-036 documentation audit
**Role:** developer.iterate

---

## Summary

Fixed the spike workflow contradiction (TECH-075) by consolidating research and POC spike workflows into a single path through `poc/`. Started the documentation DRY audit (TECH-036), completing the discovery phase and identifying a file from the wrong project, some overlaps, and minor path errors.

---

## Work Completed

### TECH-075: Reconcile Spike Workflow vs Transition Matrix

- Consolidated Research Spike and POC Spike workflows into single workflow
- Made direct-to-`poc/` the preferred path (optional backlog queue allowed)
- Updated workflow-guide.md and template version
- Moved to done and committed

### TECH-036: Audit and Refactor Duplicate Documentation

- Moved from todo to doing
- Scoped CLAUDE.md files out (handled separately by TECH-061)
- Completed audit of 15+ documentation files
- Created TECH-036-audit-findings.md documenting:
  - documentation-standards.md is from wrong project (HPC Job Queue)
  - version-control-workflow.md vs workflow-guide.md overlap
  - QUICK-START.md path errors

---

## Decisions Made

1. **Spike workflow consolidation:**
   - Single workflow: `poc/` → `history/spikes/`
   - Preferred path is direct to `poc/` (less ceremony)
   - Optional: queue in `backlog/` first if not ready to start
   - Rationale: Aligns with industry norms, simplifies documentation

2. **CLAUDE.md cleanup separation:**
   - Keep TECH-061 separate from TECH-036
   - TECH-061 has specific "less is more" insights worth focused attention
   - Added cross-reference in TECH-036

3. **documentation-standards.md removal:**
   - File references "HPC Job Queue Prototype System" - wrong project
   - Recommend deletion (pending user approval)

---

## Files Modified

- `framework/docs/collaboration/workflow-guide.md` - Consolidated spike flow section
- `templates/standard/framework/docs/collaboration/workflow-guide.md` - Synced spike changes
- `framework/thoughts/work/doing/TECH-036-refactor-duplicate-documentation.md` - Added CLAUDE.md exclusion
- `framework/thoughts/work/done/TECH-075-spike-workflow-contradiction.md` - Updated solution, marked complete

## Files Created

- `framework/thoughts/work/doing/TECH-036-audit-findings.md` - Audit results documentation

## Files Moved

- `framework/thoughts/work/todo/TECH-075-*.md` → `framework/thoughts/work/done/`
- `framework/thoughts/work/todo/TECH-036-*.md` → `framework/thoughts/work/doing/`

---

## Current State

### In done/ (awaiting release)
- TECH-075: Reconcile Spike Workflow vs Transition Matrix
- FEAT-031: Topic Inventory (INDEX.md)

### In doing/
- TECH-036: Audit and Refactor Duplicate Documentation (audit complete, remediation pending)

---

## Commits

- `cf0e2fa` - chore: Move TECH-036 to doing, exclude CLAUDE.md (handled by TECH-061)
- `86f39ad` - fix(TECH-075): Consolidate spike workflow to use poc/ folder

---

## Session 2: TECH-036 Completion, Policy Updates

### TECH-036: Audit and Refactor Duplicate Documentation - COMPLETED

**Remediation completed:**
- Deleted `documentation-standards.md` (HPC project carryover)
- Created `DOCUMENT-TEMPLATE.md` demonstrating proper header/TOC format
- Fixed QUICK-START.md path references (lines 74, 246)
- Made version-control-workflow.md the SsoT for release process
- Updated framework.yaml with `release-process` and `issue-response` entries
- Updated documentation-dry-principles.md source-of-truth table
- Updated workflow-guide.md to reference version-control-workflow.md for release checklist
- Moved TECH-036 to done

### Policy Updates

1. **Release process:**
   - Changed from "one release per issue" to "batching allowed"
   - Updated release checklist for multiple work items

2. **Source of truth principle:**
   - SsoT authority established in central registries (framework.yaml, documentation-dry-principles.md)
   - Individual documents don't need explicit "this is SsoT" headers

### DECISION-050: Framework Distribution Model

- Moved to doing (with supporting docs)
- Decision already made - awaiting implementation work items
- Supporting docs: flow diagram, customization example

### DECISION-029: License Choice

- Briefly moved to doing, returned to backlog (not ready)

---

## Files Modified (Session 2)

- `framework.yaml` - Added release-process, issue-response source entries
- `framework/docs/collaboration/workflow-guide.md` - Release checklist now references version-control-workflow.md
- `framework/docs/collaboration/documentation-dry-principles.md` - Added release/issue-response to SsoT table
- `framework/docs/process/version-control-workflow.md` - Updated release policy to allow batching
- `QUICK-START.md` - Fixed stale path references

## Files Created (Session 2)

- `framework/templates/documentation/DOCUMENT-TEMPLATE.md`
- `templates/standard/framework/templates/documentation/DOCUMENT-TEMPLATE.md`

## Files Deleted (Session 2)

- `framework/docs/process/documentation-standards.md`

## Files Moved (Session 2)

- `TECH-036-*.md` → `done/`
- `DECISION-050-*.md` → `doing/`
- `DECISION-029-*.md` → `backlog/` (returned)

---

## Current State (Updated)

### In done/ (awaiting release)
- TECH-075: Reconcile Spike Workflow
- TECH-036: Documentation DRY Audit
- FEAT-031: Topic Inventory (INDEX.md)
- TECH-066: Migrate existing work items to new metadata
- TECH-068: Hotfix/Emergency workflow
- TECH-069: Cancellation process
- TECH-074: Include fw-commands in template
- TECH-076: Enforcement prompts
- FEAT-025 supporting docs

### In doing/
- DECISION-050: Framework Distribution Model (+ 2 supporting docs)

---

**Last Updated:** 2026-01-26

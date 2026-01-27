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

## Session 3: DECISION-050 Implementation

### DECISION-050: Framework Distribution Model - Implementation

Implemented the framework-as-dependency distribution model with automated build and setup tooling.

**Key deliverables:**

1. **Starter Template** (`templates/starter/`)
   - 36 files with `{{PLACEHOLDER}}` tokens
   - Root docs: README.md, CLAUDE.md, PROJECT-STATUS.md, CHANGELOG.md, INDEX.md, QUICK-START.md, framework.yaml
   - Project scaffolding: project-hub/, src/, tests/, docs/, poc/
   - Claude commands: .claude/commands/fw-*.md
   - NO framework/ folder (added during build from live source)

2. **Build Script** (`tools/Build-FrameworkArchive.ps1`)
   - Assembles distributable zip from:
     - `templates/starter/*` (scaffolding)
     - `framework/docs/` (live documentation)
     - `framework/templates/` (live templates)
     - `framework/tools/` (PowerShell tools)
   - Creates `.framework-version` file for tracking
   - Output: `distrib/spearit_framework_v{VERSION}.zip`

3. **Setup Script** (`tools/Setup-Project.ps1`)
   - Extracts archive to destination
   - Prompts for project name/description
   - Replaces all `{{PLACEHOLDER}}` tokens automatically
   - Initializes git repository with initial commit

4. **Updated NEW-PROJECT-CHECKLIST.md** (v4.0.0)
   - Added automated setup workflow
   - Updated manual setup to reference starter template
   - Added troubleshooting for new workflow

**End-to-end test verified:**
- Build archive: 196 KB with framework/docs, templates, tools
- Setup project: All 15 placeholders replaced, git initialized

---

## Files Created (Session 3)

- `tools/Build-FrameworkArchive.ps1` - Archive build script
- `tools/Setup-Project.ps1` - Project setup script
- `distrib/.gitkeep` - Keeps distrib folder in git
- `templates/starter/` - 36 files (full starter template structure)

## Files Modified (Session 3)

- `.gitignore` - Added `distrib/*.zip` and `distrib/temp/` exclusions
- `templates/NEW-PROJECT-CHECKLIST.md` - Updated to v4.0.0 with new workflow

---

## Current State (Updated)

### In done/ (awaiting release)
- TECH-075, TECH-036, FEAT-031, TECH-066, TECH-068, TECH-069, TECH-074, TECH-076

### In doing/
- DECISION-050: Framework Distribution Model (implementation complete, decision can move to done)

---

## Session 4: Distribution Archive Fixes and Build Improvements

### Distribution Structure Fix

Fixed mismatch between source and archive structure. The archive had `project-hub/` at root level while source has it inside `framework/`.

**Resolution:** Moved `templates/starter/project-hub/` to `templates/starter/framework/project-hub/` and updated all path references.

### Setup-Project.ps1 Redesign

The setup script wasn't included in the archive. Created a new in-place version that:
- Works from within extracted archive (no external ArchivePath parameter)
- Copies template contents to destination (excluding itself)
- Replaces `{{PLACEHOLDER}}` tokens
- Initializes git repository with initial commit

Archived the old external `tools/Setup-Project.ps1` to `framework/project-hub/history/archive/`.

### Build Script Improvements

Updated `tools/Build-FrameworkArchive.ps1`:
- **Removed `-Version` parameter** - Now auto-detects from `framework/PROJECT-STATUS.md`
- **Added pre-build check** - Warns if items exist in `done/` folder (unreleased work) with prompt to continue/cancel

### Schema and Validator Fix

Discovered `framework-schema.yaml` and `validate-framework.ps1` were outdated - missing the `sources` section added to `framework.yaml`.

**Fixes:**
- Added `sources` field to `framework-schema.yaml` as object type
- Fixed `validate-framework.ps1` to only parse `fields:` section (was incorrectly including `role_definition:` section)

### Process Gaps Identified

1. **Schema sync process**: Schema and validator should be checked/updated when `framework.yaml` changes
2. **Retroactive tracking**: Ad-hoc fixes (like schema fix) should have change tickets

---

## Files Modified (Session 4)

- `templates/starter/CLAUDE.md` - Updated paths from `project-hub/` to `framework/project-hub/`
- `templates/starter/PROJECT-STATUS.md` - Updated paths
- `templates/starter/INDEX.md` - Updated paths
- `templates/starter/README.md` - Updated paths
- `templates/starter/QUICK-START.md` - Updated paths
- `templates/starter/.claude/commands/*.md` - Updated all fw-command paths
- `templates/starter/Setup-Project.ps1` - Complete rewrite for in-place operation
- `tools/Build-FrameworkArchive.ps1` - Removed -Version param, added done/ check, auto-detect version
- `framework/docs/ref/framework-schema.yaml` - Added sources field definition
- `framework/tools/validate-framework.ps1` - Fixed to parse only fields: section

## Files Created (Session 4)

- `templates/starter/framework/project-hub/` - Moved from root level
- `templates/starter/framework/project-hub/work/backlog/.gitkeep`
- `templates/starter/framework/project-hub/work/doing/.gitkeep`
- `templates/starter/framework/project-hub/work/doing/.limit`
- `templates/starter/framework/project-hub/work/done/.gitkeep`
- `templates/starter/framework/project-hub/work/todo/.gitkeep`
- `templates/starter/framework/project-hub/history/sessions/.gitkeep`

## Files Moved (Session 4)

- `tools/Setup-Project.ps1` → `framework/project-hub/history/archive/Setup-Project-v1.ps1` (archived)
- `templates/starter/project-hub/*` → `templates/starter/framework/project-hub/`

## Files Deleted (Session 4)

- `templates/starter/project-hub/` (contents moved to framework/project-hub/)

---

## Current State (Updated)

### In done/ (awaiting release)
- TECH-084: Rename thoughts/ to project-hub/

### In doing/
- DECISION-050: Framework Distribution Model (+ 2 supporting docs)

---

## Commits (Session 4)

- `b74ccf0` - chore: Complete TECH-084, resume DECISION-050
- `9cad6f1` - feat(TECH-084): Rename thoughts/ to project-hub/

---

## Session 5: DECISION-050 Completion and Cleanup

### DECISION-050 Moved to Done

Core implementation of framework-as-dependency distribution model completed:
- Build script (`Build-FrameworkArchive.ps1`)
- Setup script (`Setup-Project.ps1`) - in-place from extracted archive
- Starter template with framework/ included
- `.framework-version` tracking
- Version auto-detection and done/ check

Updated DECISION-050 with implementation status and moved to done/ with supporting docs.

### FEAT-007 Updated

Added `-Framework` parameter design for validation script:
- Default mode: consumer project validation (folder structure, files, WIP limits, YAML schema)
- Framework mode: adds template sync, tooling checks, schema completeness
- Eliminates need for separate Test-ReleaseReadiness script

### TECH-085 Created

New work item to remove `examples/` folder - redundant with new distribution model.

### Process Discussion

- Reviewed workflow policy for done/ transitions
- Identified post-move actions (session history, commit) were missed

---

## Files Modified (Session 5)

- `framework/project-hub/work/backlog/feature-007-validation-script.md` - Added `-Framework` mode design, updated paths
- `framework/project-hub/work/done/DECISION-050-framework-distribution-model.md` - Added implementation status

## Files Created (Session 5)

- `framework/project-hub/work/backlog/TECH-085-remove-examples-folder.md`

## Files Moved (Session 5)

- `DECISION-050-framework-distribution-model.md` → `done/`
- `DECISION-050-customization-example.md` → `done/`
- `DECISION-050-framework-distribution-flow-diagram.md` → `done/`

---

## Current State (Updated)

### In done/ (awaiting release)
- TECH-084: Rename thoughts/ to project-hub/
- DECISION-050: Framework Distribution Model (+ 2 supporting docs)

### In doing/
- (empty)

---

## Session 6: TECH-086 POC Folder Location Fix

### TECH-086: Align POC Folder Location with ADR-004

Discovered documentation inconsistency: PROJECT-STRUCTURE-STANDARD.md showed `poc/` at project root, but ADR-004 decided it should be at `project-hub/poc/`.

**Analysis:**
- ADR-004 explicitly chose `project-hub/poc/` (sibling to `research/`)
- Framework itself correctly uses `framework/project-hub/poc/`
- Documentation and starter template incorrectly showed `poc/` at root

**Resolution:** Aligned documentation and template with ADR-004 decision.

**Files Modified:**
- `framework/docs/PROJECT-STRUCTURE-STANDARD.md` - Moved poc from root to under project-hub
- `framework/docs/process/distribution-build-checklist.md` - Updated checklist
- `tools/Build-FrameworkArchive.ps1` - Updated output text
- `framework/CHANGELOG.md` - Added to Unreleased

**Files Moved:**
- `templates/starter/poc/` → `templates/starter/framework/project-hub/poc/`

---

## Current State (Updated)

### In done/ (awaiting release)
- TECH-084: Rename thoughts/ to project-hub/
- TECH-086: Align POC folder location with ADR-004
- DECISION-050: Framework Distribution Model (+ 2 supporting docs)

### In doing/
- (empty)

---

**Last Updated:** 2026-01-26

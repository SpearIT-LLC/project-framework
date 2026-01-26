# TECH-036: Documentation Audit Findings

**Audit Date:** 2026-01-26
**Scope:** All framework documentation (excluding CLAUDE.md files - see TECH-061)

---

## Summary

Audited 15+ documentation files in framework/docs/, root files, and structure specifications. Found 2 significant issues, 1 moderate overlap, and several areas of good DRY practice.

**Remediation Status:** All critical and moderate issues RESOLVED. INDEX.md verification deferred to FEAT-031.

---

## Critical Findings

### 1. ~~WRONG PROJECT: documentation-standards.md~~ RESOLVED

**Location:** `framework/docs/process/documentation-standards.md`

**Issue:** This file explicitly referenced "HPC Job Queue Prototype System" and contained project-specific standards.

**Resolution:**
- Deleted the file
- Created `framework/templates/documentation/DOCUMENT-TEMPLATE.md` demonstrating proper header/TOC format
- Project-specific content (PowerShell, Unicode) already covered by code-quality-standards.md

**Status:** ✅ RESOLVED

---

### 2. ~~OVERLAP: version-control-workflow.md vs workflow-guide.md~~ RESOLVED

**Location:**
- `framework/docs/process/version-control-workflow.md` (1136 lines)
- `framework/docs/collaboration/workflow-guide.md` (1700+ lines)

**Overlapping Topics:**
| Topic | version-control-workflow.md | workflow-guide.md |
|-------|----------------------------|-------------------|
| Semantic versioning | Yes (lines 17-34) | Yes |
| Git branching | Yes (lines 38-97) | Partial |
| Release process | Yes (detailed) | ~~Yes~~ References version-control-workflow.md |
| Work item lifecycle | References workflow-guide | Source of truth |
| Issue response process | Yes (detailed, lines 483-867) | No |

**Resolution:**
- Made version-control-workflow.md the SsoT for release process and issue response
- Updated framework.yaml to reference version-control-workflow.md
- Updated workflow-guide.md to reference version-control-workflow.md instead of duplicating release checklist
- Updated documentation-dry-principles.md source-of-truth table
- Files now have clear separation: version-control-workflow.md = git/release/issue-response, workflow-guide.md = kanban/workflow

**Status:** ✅ RESOLVED

---

## Moderate Findings

### 3. ~~Stale References in QUICK-START.md~~ RESOLVED

**Location:** `QUICK-START.md`

**Issues:** Lines 74 and 246 referenced non-existent `framework/process/`

**Resolution:** Updated both references to `framework/docs/collaboration/workflow-guide.md`

**Status:** ✅ RESOLVED

---

## Good DRY Practices Observed

### Source of Truth Compliance

| Topic | Observed Pattern | Status |
|-------|------------------|--------|
| Project version | README.md → PROJECT-STATUS.md | ✅ Correct |
| Workflow process | Various → workflow-guide.md | ✅ Correct |
| DRY principles | Various → documentation-dry-principles.md | ✅ Correct |
| Project structure | Various → PROJECT-STRUCTURE-STANDARD.md | ✅ Correct |
| Repository structure | Various → REPOSITORY-STRUCTURE.md | ✅ Correct |

### Appropriate Separation

- **REPOSITORY-STRUCTURE.md** vs **PROJECT-STRUCTURE-STANDARD.md**: Appropriate - different scopes (repo root vs project)
- **code-quality-standards.md**: Self-contained coding standards, links to related docs
- **documentation-dry-principles.md**: Excellent source-of-truth mapping table

---

## Files Reviewed

| File | Lines | Notes |
|------|-------|-------|
| framework/docs/README.md | 25 | Index only, appropriate |
| framework/docs/REPOSITORY-STRUCTURE.md | 320 | Good, clear scope |
| framework/docs/PROJECT-STRUCTURE-STANDARD.md | 703 | Good, comprehensive |
| framework/docs/collaboration/workflow-guide.md | 1700+ | Source of truth for workflow |
| framework/docs/collaboration/documentation-dry-principles.md | 249 | Defines DRY policy |
| framework/docs/collaboration/code-quality-standards.md | 830 | Clean, focused |
| framework/docs/process/documentation-standards.md | 403 | **RESOLVED** - Deleted, replaced with DOCUMENT-TEMPLATE.md |
| framework/docs/process/version-control-workflow.md | 1136 | Overlaps with workflow-guide |
| README.md (root) | 336 | Good DRY practice |
| QUICK-START.md (root) | 261 | Minor path issues |

---

## Remediation Status

### Phase 1: documentation-standards.md - RESOLVED
- [x] Deleted `framework/docs/process/documentation-standards.md` (HPC project carryover)
- [x] Created `framework/templates/documentation/DOCUMENT-TEMPLATE.md` to replace it
- [x] Synced template to `templates/standard/`

**Resolution:** The useful formatting standards (TOC, version header) are now demonstrated by the template itself. Project-specific content (PowerShell versions, Unicode) was already covered by code-quality-standards.md.

### Phase 2: Fix Paths - RESOLVED
- [x] Updated QUICK-START.md line 74: `framework/process/` → `framework/docs/collaboration/workflow-guide.md`
- [x] Updated QUICK-START.md line 246: `framework/process/` → `framework/docs/collaboration/workflow-guide.md`

### Phase 3: Clarify Overlaps - RESOLVED
- [x] Add version-control-workflow.md reference to framework.yaml
  - Added `release-process: framework/docs/process/version-control-workflow.md#release-checklist`
  - Added `issue-response: framework/docs/process/version-control-workflow.md#issue-response-process`
- [x] Update workflow-guide.md release checklist to reference version-control-workflow.md
  - Replaced abbreviated checklist with link to version-control-workflow.md#release-checklist
- [x] Update documentation-dry-principles.md source-of-truth table
  - Added release process → version-control-workflow.md
  - Added issue response process → version-control-workflow.md

**Resolution:** Made version-control-workflow.md the single source of truth for release process. workflow-guide.md now references it instead of duplicating the checklist. Source-of-truth authority is established in the central registries (framework.yaml, documentation-dry-principles.md), not in individual document headers.

### Phase 4: Update INDEX.md - DEFERRED TO FEAT-031
- [ ] Verify INDEX.md reflects current source-of-truth mappings (belongs with FEAT-031 scope)

---

## Out of Scope (per TECH-036)

- CLAUDE.md files (handled by TECH-061)
- Template files (not documentation)
- Work item history files (not active documentation)

---

**Last Updated:** 2026-01-26

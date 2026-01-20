# Tech Debt: Simplify PROJECT-STATUS.md to Ultra-Minimal Format

**ID:** TECH-065
**Type:** Tech Debt
**Priority:** Medium
**Version Impact:** PATCH
**Created:** 2026-01-20
**Completed:** 2026-01-20

---

## Summary

PROJECT-STATUS.md is too complex and prone to becoming stale. Simplify to an ultra-minimal format that only contains version information and pointers to authoritative sources.

---

## Problem Statement

**What is the current state?**

PROJECT-STATUS.md contains:
- Version and date (authoritative)
- Duplicated feature lists (also in README.md)
- Template counts (maintenance burden)
- Phase implementation tables (frequently stale)
- Known issues section (duplicates work items)
- Pending work section (duplicates kanban board)
- Testing status (rarely updated)
- Dependency lists (rarely changes)
- Release history tables (duplicates CHANGELOG.md)
- Milestone planning (often outdated)

**Why is this a problem?**

1. **DRY violation:** Feature list duplicated between PROJECT-STATUS.md and README.md
2. **Staleness risk:** Many sections become outdated because they're manual and rarely reviewed
3. **Maintenance burden:** Updates require touching multiple places
4. **Confusion:** Users may find conflicting information between sources
5. **Policy friction:** Updates restricted to release time, but some sections need frequent updates

**What is the desired state?**

Ultra-minimal PROJECT-STATUS.md that contains only:
- Project name and version (authoritative, updated at release time)
- Brief status statement (e.g., "Production-ready")
- Pointers to authoritative sources:
  - README.md for features and getting started
  - CHANGELOG.md for version history
  - `/fw-status` for current workflow state

---

## Proposed Solution

Rewrite PROJECT-STATUS.md to approximately 20-30 lines:

```markdown
# SpearIT Project Framework - Project Status

**Current Version:** v3.4.0 (2026-01-19)
**Status:** Production-ready

---

## Quick Links

- **Features & Getting Started:** [README.md](../README.md)
- **Version History:** [CHANGELOG.md](CHANGELOG.md)
- **Current Workflow:** Run `/fw-status` command

---

## Maintainer

**Maintainer:** Gary Elliott (gary.elliott@spearit.solutions)
**Organization:** SpearIT, LLC
```

**Files Affected:**
- `framework/PROJECT-STATUS.md` - Complete rewrite to ultra-minimal format
- `framework/README.md` - Ensure feature list is complete and authoritative
- `framework/docs/collaboration/workflow-guide.md` - Update references to PROJECT-STATUS.md role

---

## Acceptance Criteria

- [x] PROJECT-STATUS.md reduced to ~20-30 lines (now 20 lines, down from 390)
- [x] Only version and status are maintained in PROJECT-STATUS.md
- [x] All other information referenced via pointers
- [x] README.md confirmed as authoritative source for features
- [x] Documentation updated to reflect new role of PROJECT-STATUS.md (no changes needed - existing docs describe purpose accurately)
- [x] No duplicate information between PROJECT-STATUS.md and other files

---

## Notes

- Consider future "project dashboard" feature (possibly FEAT-015) for dynamic status visualization
- This change aligns with experienced developer expectations: they look in README for features, CHANGELOG for history
- The version-at-release-time policy works well with this minimal format

---

## Related

- TECH-064: Standardize work item metadata (completed - triggered this discussion)
- FEAT-015: Potential future dashboard feature
- [workflow-guide.md](../../docs/collaboration/workflow-guide.md) - References PROJECT-STATUS.md update process

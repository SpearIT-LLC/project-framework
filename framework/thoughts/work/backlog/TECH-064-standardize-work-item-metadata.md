# Technical: Standardize Work Item Metadata Fields

**ID:** TECH-064
**Type:** Technical Debt
**Version Impact:** PATCH
**Status:** Backlog
**Created:** 2026-01-19
**Developer:** TBD

---

## Summary

Standardize metadata field naming across all work item templates to ensure consistent parsing by automation tools like `backlog-list.ps1`.

---

## Problem Statement

**What problem does this solve?**

Work item templates use inconsistent field names:
- `**Created:**` vs `**Date:**` for creation date
- `**Version Impact:**` (SemVer) vs `**Impact:**` (scope/significance)
- Some items missing fields entirely

This causes automation tools to need multiple fallback patterns and produces inconsistent output in reports.

**Current State:**
- Feature/Bugfix/Tech templates use `**Created:**` and `**Version Impact:**`
- Decision templates use `**Date:**` and `**Impact:**` (different meaning)
- Older items may be missing fields or use non-standard formats

---

## Proposed Solution

1. **Audit** all templates in `framework/templates/work-items/`
2. **Define** canonical field set with clear naming:
   - `**Created:**` - when the item was created (ISO date)
   - `**Version Impact:**` - SemVer impact (MAJOR/MINOR/PATCH) for releasable items
   - `**Decision Impact:**` - scope of decision (Major/Minor) for Decision items
3. **Update** all templates to use canonical names
4. **Document** the standard field set in workflow-guide.md
5. **Consider** migration script for existing items (optional)

---

## Acceptance Criteria

- [ ] All work item templates use consistent field names
- [ ] Field naming convention documented in workflow-guide.md
- [ ] `backlog-list.ps1` updated to use canonical names (remove fallbacks)
- [ ] Decision: whether to migrate existing items or grandfather them

---

## Dependencies

- None

## Related

- FEAT-018: Claude Command Framework (discovered during script development)
- `framework/tools/backlog-list.ps1` - current workarounds for inconsistency

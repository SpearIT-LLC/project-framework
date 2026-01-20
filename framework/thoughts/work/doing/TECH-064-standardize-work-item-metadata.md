# Technical: Standardize Work Item Metadata Fields

**ID:** TECH-064
**Type:** Tech Debt
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-01-19

---

## Summary

Standardize metadata field naming across all work item templates to ensure consistent parsing by automation tools.

---

## Problem Statement

Work item templates use inconsistent field names:
- `**Created:**` vs `**Date:**` for creation date
- `**Version Impact:**` (SemVer) vs `**Impact:**` (scope/significance)
- `**Status:**` field is redundant (folder location = status)
- Some items missing fields entirely
- Blocker type conflates dependency with work item type

This causes automation tools to need multiple fallback patterns and produces inconsistent output in reports.

---

## Decisions Made (2026-01-20)

### Work Item Types (5 total)
| Type | ID Prefix | Purpose |
|------|-----------|---------|
| Feature | FEAT- | New capability |
| Bug | BUG- | Defect fix (renamed from Bugfix) |
| Tech Debt | TECH- | Internal improvement |
| Decision | DECISION- | ADR / design choice |
| Spike | SPIKE- | Time-boxed research |

**Removed:** Blocker (use `Depends On` field instead)

### Required Metadata Fields (all types)
```markdown
**ID:** TYPE-NNN
**Type:** Feature | Bug | Tech Debt | Decision | Spike
**Priority:** High | Medium | Low
**Version Impact:** MAJOR | MINOR | PATCH | None
**Created:** YYYY-MM-DD
```

### Optional Metadata Fields
```markdown
**Assigned:** [Name]
**Severity:** Critical | High | Medium | Low  (Bug only)
**Depends On:** ITEM-NNN, ITEM-NNN
```

### Fields Removed
| Field | Reason |
|-------|--------|
| Status | Folder location is status (backlog/todo/doing/done) |
| Completed | Git history captures this; location indicates completion |
| Time Box | Ad-hoc if needed, not standard |
| Developer | Renamed to Assigned |

---

## Implementation Plan

### Phase 1: Template Updates
- [ ] Update FEATURE-TEMPLATE.md (add Priority, remove Status/Completed)
- [ ] Rename BUGFIX-TEMPLATE.md → BUG-TEMPLATE.md and standardize
- [ ] Update SPIKE-TEMPLATE.md (add Priority/Version Impact, remove Status)
- [ ] Create TECHDEBT-TEMPLATE.md
- [ ] Create DECISION-TEMPLATE.md
- [ ] Delete BLOCKER-TEMPLATE.md

### Phase 2: Tool Updates
- [ ] Update FrameworkWorkflow.psm1 to recognize BUG- and BUGFIX- prefixes
- [ ] Test Get-BacklogItems.ps1 with new templates
- [ ] Test Get-WorkflowStatus.ps1 with new templates
- [ ] Test Move-WorkItem.ps1 with new templates

### Phase 3: Documentation
- [ ] Document standard in workflow-guide.md
- [ ] Update any references to old field names

### Phase 4: Migration (deferred)
- Existing items grandfathered - no bulk migration
- New items use new standard
- Update items opportunistically when touched

---

## Acceptance Criteria

- [ ] All 5 work item templates use consistent field names
- [ ] Field naming convention documented in workflow-guide.md
- [ ] PowerShell tools work with both old and new formats
- [ ] BLOCKER-TEMPLATE.md removed

---

## Related

- TECH-033: Status Field Redundancy (addressed by this work)
- `framework/tools/Get-BacklogItems.ps1` - current workarounds for inconsistency

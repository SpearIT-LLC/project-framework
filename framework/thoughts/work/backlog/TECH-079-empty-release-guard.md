# Tech Debt: Add Empty Release Guard

**ID:** TECH-079
**Type:** Tech Debt
**Priority:** Low
**Version Impact:** PATCH
**Created:** 2026-01-23

---

## Summary

Add guidance to check for empty `done/` folder before initiating a release. Prevents accidental "empty" releases with no completed work items.

---

## Problem Statement

**What is the current state?**

- No guard against releasing when done/ is empty
- FEAT-015 tested this scenario - release proceeded without warning
- Version number incremented with no associated work items

**Why is this a problem?**

- Empty releases pollute version history
- Confusing CHANGELOG entries
- Wasted version numbers
- May indicate forgotten work items still in doing/

**What is the desired state?**

- Pre-release check: "Is done/ empty?"
- If empty, warn and prompt for confirmation
- Guidance on when empty release might be intentional

---

## Proposed Solution

Add pre-release validation to version-control-workflow.md:

```markdown
### Pre-Release Validation

Before starting a release:

1. **Check done/ folder:**
   ```powershell
   Get-ChildItem thoughts/work/done/*.md
   ```

2. **If empty:**
   - STOP - Verify this is intentional
   - Common reasons for empty release:
     - Documentation-only changes
     - Configuration changes
     - Dependency updates
   - If no valid reason, check doing/ for forgotten items

3. **If not empty:**
   - Proceed with release
   - All items in done/ will be included in CHANGELOG
```

**Files Affected:**
- `framework/docs/process/version-control-workflow.md` - Add pre-release validation
- `templates/standard/framework/docs/process/version-control-workflow.md` - Sync changes

---

## Acceptance Criteria

- [ ] Pre-release check for empty done/ documented
- [ ] Warning/confirmation guidance for empty releases
- [ ] Valid reasons for empty release documented
- [ ] Template synced to templates/standard/

---

## Notes

This is a documentation-only change. Future enhancement could add this check to a release script or fw-release command.

---

## Related

- FEAT-025: Manual Setup Validation (source of finding)
- TECH-078: Release archival process

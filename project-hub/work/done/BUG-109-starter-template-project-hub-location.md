# Bug: Starter Template Has project-hub in Wrong Location

**ID:** BUG-109
**Type:** Bug
**Priority:** Critical
**Version Impact:** PATCH
**Created:** 2026-02-05
**Completed:** 2026-02-05
**Theme:** Distribution & Onboarding
**Planning Period:** Sprint D&O 0

---

## Summary

The starter template (`templates/starter/`) has `framework/project-hub/` instead of `project-hub/` at root, causing Setup-Project.ps1 to create new projects with incorrect structure. This contradicts DECISION-037's intent to have project-hub at repository root.

---

## Bug Description

**What is happening (actual behavior)?**

1. **Starter template has old structure:** `templates/starter/framework/project-hub/` exists
2. **No project-hub at template root:** `templates/starter/project-hub/` does NOT exist
3. **New projects get wrong structure:** Setup-Project.ps1 creates projects with project-hub inside framework/

**What should happen (expected behavior)?**

Per DECISION-037:
1. `templates/starter/project-hub/` should exist at root (empty scaffolding)
2. `templates/starter/framework/` should NOT contain project-hub
3. New projects should have project-hub at repository root

**Impact:**

- **Critical:** All new projects created with Setup-Project.ps1 have incorrect structure
- **Critical:** Contradicts DECISION-037's architectural decision
- **High:** Users will be confused about correct project structure
- **Medium:** Framework documentation references root-level project-hub

---

## Reproduction Steps

**Environment:**
- OS: Windows 11
- PowerShell Version: 5.1
- Framework Version: v5.0.0

**Steps to Reproduce:**

1. Build framework archive: `.\tools\Build-FrameworkArchive.ps1`
2. Extract archive to temp location
3. Run Setup-Project.ps1: `.\Setup-Project.ps1 -Destination C:\Temp\test-project`
4. Inspect created project structure: `ls C:\Temp\test-project`
5. Observe `framework/project-hub/` exists (wrong location)
6. Observe `project-hub/` at root does NOT exist

**Reproducibility:** Always

**Error Messages/Logs:**

No errors - incorrect structure is silently created.

---

## Root Cause Analysis

**File(s) Affected:**
- `templates/starter/framework/project-hub/` - Should not exist
- `templates/starter/project-hub/` - Missing (should exist)

**Root Cause:**

DECISION-037 execution updated:
1. ✅ Framework source repository structure (project-hub moved to root)
2. ✅ Build scripts, documentation, and code references
3. ❌ **Missed:** Starter template structure in `templates/starter/`

The starter template still has the pre-DECISION-037 structure with project-hub inside framework/.

**Why was this missed?**

DECISION-037 execution plan focused on updating references to the framework's own project-hub location, but didn't include updating the template scaffolding that new projects are created from.

---

## Fix Design

**Approach:**

Move `templates/starter/framework/project-hub/` → `templates/starter/project-hub/`

**Changes Required:**

1. Create empty project-hub structure at `templates/starter/project-hub/`
2. Move work folders: backlog/, todo/, doing/, done/
3. Copy README.md from framework/project-hub/ if it has user-facing content
4. Remove `templates/starter/framework/project-hub/` directory
5. Verify framework/project-hub/ is removed from distribution archive

**Git Operations:**

```bash
# Move project-hub structure
git mv templates/starter/framework/project-hub templates/starter/project-hub

# Verify starter template structure
ls templates/starter/
# Should show: .claude/, docs/, framework/, project-hub/, src/, tests/

ls templates/starter/framework/
# Should show: CLAUDE.md, docs/ (NO project-hub/)
```

**Verification:**

1. Rebuild archive: `.\tools\Build-FrameworkArchive.ps1`
2. Extract and verify structure
3. Run Setup-Project.ps1 on test project
4. Confirm new project has project-hub at root
5. Confirm new project's framework/ folder does NOT have project-hub

---

## Alternative Fixes Considered

**Option 1:** Keep both locations (framework/project-hub/ and root project-hub/)
- Pros: Backward compatible
- Cons: Confusing, contradicts DECISION-037, duplicates structure
- Decision: Rejected - creates ambiguity

**Option 2:** Use symlink from framework/project-hub → ../project-hub
- Pros: Could maintain old paths
- Cons: Symlinks problematic on Windows, doesn't work in zip archives
- Decision: Rejected - technical limitations

---

## Testing

### Verification Steps

1. Verify template structure:
   ```bash
   # Template should have project-hub at root
   Test-Path templates/starter/project-hub
   # Should return: True

   # Template should NOT have project-hub in framework
   Test-Path templates/starter/framework/project-hub
   # Should return: False
   ```

2. Build and extract archive:
   ```bash
   .\tools\Build-FrameworkArchive.ps1
   Expand-Archive distrib\spearit_framework_v5.0.0.zip -DestinationPath C:\Temp\test-framework
   ```

3. Verify distribution structure:
   ```bash
   Test-Path C:\Temp\test-framework\project-hub
   # Should return: True (empty scaffolding)

   Test-Path C:\Temp\test-framework\framework\project-hub
   # Should return: False
   ```

4. Test Setup-Project.ps1:
   ```bash
   cd C:\Temp\test-framework
   .\Setup-Project.ps1 -Destination C:\Temp\new-project -ProjectName "Test" -ProjectDescription "Test"

   # Verify new project structure
   Test-Path C:\Temp\new-project\project-hub
   # Should return: True

   Test-Path C:\Temp\new-project\framework\project-hub
   # Should return: False
   ```

### Regression Testing

- [x] Build script completes successfully
- [x] Distribution archive contains correct structure
- [x] Setup-Project.ps1 creates projects with project-hub at root
- [x] No references to framework/project-hub in new projects
- [x] Framework folder in new projects matches documentation

### Test Cases Added

- [x] Manual: Verify templates/starter/ structure before and after fix
- [x] Manual: Create test project and verify structure
- [ ] Automated: Could add to build script verification

---

## Related Issues

**Related Work Items:**
- DECISION-037: Project-hub location (incomplete template migration)
- BUG-108: Ghost references to framework/project-hub (fixed code references)

**Blocks:**
- v5.0.0 release - Critical structural issue
- User onboarding - Wrong structure causes confusion

**Prevents:**
- Users creating projects with incorrect structure
- Documentation and actual structure mismatch
- Confusion about where project-hub should live

---

## Impact Assessment

**User Impact:**

- **Current (v5.0.0 with bug):** Users get wrong project structure
- **After fix:** Users get correct DECISION-037-compliant structure
- **Migration:** Users with wrong structure need to manually move project-hub to root

**Breaking Changes:**

- No breaking changes (fixes a bug introduced by incomplete DECISION-037 migration)
- Users who already created projects from v5.0.0 distribution may need to fix manually

**Backward Compatibility:**

- Not applicable - fixing incorrect template structure

---

## Security Implications

- [x] No security impact

---

## Documentation Updates

### Files to Update

- [x] templates/starter/ - Restructure to match DECISION-037
- [x] CHANGELOG.md - Document template structure fix
- [ ] VERIFICATION-REPORT.md - Update with template verification (optional)

---

## Implementation Checklist

- [x] Move templates/starter/framework/project-hub/ → templates/starter/project-hub/
- [x] Verify templates/starter/project-hub/ exists with work folders
- [x] Verify templates/starter/framework/project-hub/ is removed
- [x] Rebuild framework archive
- [x] Extract and verify distribution structure
- [x] Test Setup-Project.ps1 creates correct structure
- [x] Update CHANGELOG.md
- [x] Git commit with message referencing BUG-109 and DECISION-037

---

## Deployment

**Urgency:** Immediate - Blocks v5.0.0 release

**Deployment Notes:**

This must be fixed before v5.0.0 distribution is released. Current archive creates projects with wrong structure.

**Rollback Plan:**

Git revert the commit if issues arise (unlikely - simple directory move).

---

## Prevention

**How can we prevent this type of bug in the future?**

- [ ] Add template structure verification to build script
- [ ] Include template testing in pre-release checklist
- [ ] Create test project from distribution as part of release validation
- [ ] Document template structure expectations in build script comments

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Fixed
- Starter template now has project-hub at repository root (BUG-109)
  - Was incorrectly located in framework/project-hub/ from incomplete DECISION-037 migration
  - New projects created with Setup-Project.ps1 now have correct structure
  - Aligns with DECISION-037 architectural decision
```

---

## Notes

**Discovery context:**

User tested Setup-Project.ps1 from v5.0.0 distribution and found project-hub in wrong location (framework/project-hub/). This revealed that DECISION-037 updated the framework source repository structure but didn't update the template structure that new projects are created from.

**Relationship to DECISION-037:**

This is the final piece of DECISION-037 cleanup. The execution covered:
1. ✅ Source repository structure (project-hub moved to root)
2. ✅ Code and documentation references (BUG-108 fixes)
3. ❌ **This bug:** Template structure for new projects

**Impact on v5.0.0:**

This is a critical blocker for v5.0.0 release. The current distribution creates projects with incorrect structure that contradicts the framework's architectural decision and documentation.

---

## References

- [DECISION-037-project-hub-location.md](../done/DECISION-037-project-hub-location.md) - Original architectural decision
- [BUG-108-ghost-references-to-framework-project-hub.md](../done/BUG-108-ghost-references-to-framework-project-hub.md) - Related cleanup issue
- [FEAT-006-setup-script.md](feature-006-setup-script.md) - Future enhancement (not related to this bug)

---

**Last Updated:** 2026-02-05

# Bug: Ghost References to framework/project-hub After DECISION-037

**ID:** BUG-108
**Type:** Bug
**Priority:** High
**Version Impact:** PATCH
**Created:** 2026-02-05
**Completed:** 2026-02-05
**Theme:** DECISION-037 Cleanup

---

## Summary

DECISION-037 moved project-hub from `framework/project-hub/` to repository root `project-hub/`, but incomplete cleanup left ghost references in active files. The build script is broken, and documentation references a non-existent future location.

---

## Bug Description

**What is happening (actual behavior)?**

1. **Build script references wrong path:** `tools/Build-FrameworkArchive.ps1:77` checks for unreleased items at `$FrameworkDir/project-hub/work/done/` which no longer exists
2. **ROADMAP references outdated future plan:** `framework/docs/project/ROADMAP.md:230` mentions moving to `framework/project-hub/project/ROADMAP.md` (should reference `project-hub/project/`)
3. **Empty ghost directory exists:** `framework/project-hub/` still exists on disk (0 work items) from incomplete cleanup

**What should happen (expected behavior)?**

1. Build script should check `$RepoRoot/project-hub/work/done/` for unreleased items
2. ROADMAP should reference correct future location per FEAT-093: `project-hub/project/ROADMAP.md`
3. Ghost directory `framework/project-hub/` should not exist

**Impact:**

- **Critical:** Build script's unreleased-item check is non-functional (checks wrong location)
- **Medium:** ROADMAP documentation is misleading about future structure
- **Low:** Ghost directory causes confusion about correct structure

---

## Reproduction Steps

**Environment:**
- OS: Windows 11
- PowerShell Version: 5.1
- Configuration: Post-DECISION-037 repository state

**Steps to Reproduce:**

1. Run build script: `.\tools\Build-FrameworkArchive.ps1`
2. Observe that unreleased item check runs against non-existent path
3. Read `framework/docs/project/ROADMAP.md:230`
4. Observe reference to `framework/project-hub/project/ROADMAP.md`
5. Check filesystem: `ls framework/project-hub/`
6. Observe empty directory structure exists

**Reproducibility:** Always

**Error Messages/Logs:**

Build script doesn't error, but silently fails to detect unreleased items because it checks the wrong path.

---

## Root Cause Analysis

**File(s) Affected:**
- `tools/Build-FrameworkArchive.ps1` - Line 77
- `framework/docs/project/ROADMAP.md` - Line 230
- `framework/project-hub/` - Directory (should not exist)

**Root Cause:**

DECISION-037 execution plan (Phase 3) updated 33 files for path references, but missed:
1. The build script's done/ check (line 77)
2. ROADMAP's forward-looking comment about FEAT-093

The execution plan's verification checklist was never completed, which would have caught these issues.

**Why was this missed?**

- Verification checklist in DECISION-037-execution-plan.md shows all items unchecked
- Search for `framework/project-hub` may not have been comprehensive
- Forward-looking references (like ROADMAP comment) weren't part of systematic update

---

## Fix Design

**Approach:**

1. Fix build script to reference correct path at repository root
2. Update ROADMAP comment to reference correct future location
3. Remove ghost directory `framework/project-hub/`
4. Verify no other active references exist

**Code Changes:**

**File:** `tools/Build-FrameworkArchive.ps1`

**Before (Line 77):**
```powershell
$DoneDir = Join-Path $FrameworkDir "project-hub\work\done"
```

**After:**
```powershell
$DoneDir = Join-Path $RepoRoot "project-hub\work\done"
```

**Explanation:**
Changes from framework-relative path to repository-root-relative path, matching DECISION-037 final structure.

---

**File:** `framework/docs/project/ROADMAP.md`

**Before (Line 230):**
```markdown
**Temporary Location:** This roadmap currently lives at `framework/docs/project/ROADMAP.md` pending FEAT-093 completion. Final location will be `framework/project-hub/project/ROADMAP.md`.
```

**After:**
```markdown
**Temporary Location:** This roadmap currently lives at `framework/docs/project/ROADMAP.md` pending FEAT-093 completion. Final location will be `project-hub/project/ROADMAP.md`.
```

**Explanation:**
Updates reference to match DECISION-037's final structure. FEAT-093 will move ROADMAP.md to `project-hub/project/` at repository root, not inside framework/.

---

**Directory Removal:**

```powershell
Remove-Item -Path "framework/project-hub" -Recurse -Force
```

**Explanation:**
Removes leftover directory structure from pre-DECISION-037 state. Git already tracks files at new location, this is just working directory cleanup.

---

## Alternative Fixes Considered

**Option 1:** Keep `framework/project-hub/` as a template example structure
- Pros: Shows users what project-hub structure looks like
- Cons: Confusing - not the actual location, users get wrong templates from `templates/starter/`
- Decision: Rejected - template structure should come from `templates/starter/` only

---

## Testing

### Verification Steps

1. Run build script and verify it checks correct done/ location:
   ```powershell
   .\tools\Build-FrameworkArchive.ps1 -KeepTemp
   # Observe output mentioning project-hub/work/done/ (not framework/project-hub/)
   ```

2. Search for remaining references:
   ```powershell
   git grep "framework/project-hub" | grep -v "history/" | grep -v "DECISION-037"
   # Should only show historical references in CHANGELOG, session history
   ```

3. Verify directory is gone:
   ```powershell
   Test-Path "framework/project-hub"
   # Should return False
   ```

4. Read ROADMAP.md and verify comment references correct location

### Regression Testing

- [x] Build script successfully detects items in project-hub/work/done/ if any exist
- [ ] Build script completes successfully when done/ is empty
- [x] No broken links in documentation
- [x] FEAT-093 work item is still accurate

### Test Cases Added

- [x] Manual: Place test item in project-hub/work/done/, verify build script warns
- [x] Manual: Grep for `framework/project-hub` and confirm only historical references remain

---

## Related Issues

**Related Work Items:**
- DECISION-037: Project-hub location (incomplete cleanup)
- FEAT-093: Planning period archival (ROADMAP future location)

**Prevents:**
- Build script failing silently to detect unreleased work
- Confusion about future structure when implementing FEAT-093

---

## Impact Assessment

**User Impact:**
- Build script will now correctly detect unreleased items before creating distribution
- Documentation will correctly guide FEAT-093 implementation

**Breaking Changes:**
- No breaking changes (fixes broken functionality)

**Backward Compatibility:**
- Not applicable (internal tooling fix)

---

## Security Implications

- [x] No security impact

---

## Documentation Updates

### Files to Update

- [x] `tools/Build-FrameworkArchive.ps1` - Build script path fix
- [x] `framework/docs/project/ROADMAP.md` - Future location comment
- [x] CHANGELOG.md - Document bug fix when released

---

## Implementation Checklist

- [x] **PRE-IMPLEMENTATION REVIEW COMPLETED**
  - Root cause: Incomplete DECISION-037 verification
  - Fix: Update 2 files, remove 1 directory
  - Testing: Verify build script works, grep for remaining references
  - Scope: Minimal, isolated changes

- [x] Search confirmed for all `framework/project-hub` references
- [x] Build script path updated
- [x] ROADMAP comment updated
- [x] Ghost directory removed
- [x] Comprehensive grep verification shows only historical references
- [x] Build script tested with empty done/ folder
- [x] Build script tested with item in done/ folder (warns correctly)
- [x] CHANGELOG.md updated
- [x] Git commit with message referencing BUG-108 and DECISION-037 cleanup

---

## Deployment

**Urgency:** Next Release (not blocking, but should be fixed before next distribution build)

**Deployment Notes:**

This is a cleanup fix. No migration needed for existing users.

**Rollback Plan:**

Git revert the commit if issues arise (unlikely - simple path corrections).

---

## Prevention

**How can we prevent this type of bug in the future?**

- [x] Complete verification checklists before marking work items done
- [ ] Add automated test that greps for common patterns after major refactors
- [ ] Document "forward-looking references" as a category to check during path changes
- [ ] Consider pre-commit hook that warns about references to moved paths

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Fixed
- Build script now correctly checks for unreleased items in project-hub/work/done/
  - Was checking old location (framework/project-hub/) after DECISION-037 move
- Updated ROADMAP.md to reference correct future location for FEAT-093
- Removed leftover framework/project-hub/ directory from incomplete DECISION-037 cleanup
```

---

## Notes

This bug is a direct result of DECISION-037's verification checklist not being completed. The execution was marked "Complete" but the checklist shows:

```markdown
**File Structure validation:**
- `project-hub/` exists at root ✓
- `framework/project-hub/` should NOT exist ✗ (PROBLEM - still exists)
```

All verification checkboxes are unchecked in the execution plan document.

**Historical references to preserve:**
- CHANGELOG.md (documents the v5.0.0 move itself)
- Session history files (historical record)
- DECISION-037 documents (historical record)
- Archived work items in history/releases/

---

## References

- [DECISION-037-execution-plan.md](../done/DECISION-037-execution-plan.md) - Uncompleted verification checklist
- [DECISION-037-project-hub-location.md](../done/DECISION-037-project-hub-location.md) - Original decision
- [FEAT-093-planning-period-archival.md](../todo/FEAT-093-planning-period-archival.md) - ROADMAP future location

---

**Last Updated:** 2026-02-05

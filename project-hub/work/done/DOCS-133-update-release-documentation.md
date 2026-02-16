# DOCS-133: Update Documentation for Nested Release Structure

**ID:** DOCS-133
**Type:** Documentation
**Priority:** High
**Created:** 2026-02-13

---

## Summary

Update framework documentation to reflect new nested release structure (`releases/{product}/{version}/`) established in CHORE-131.

---

## Context

CHORE-131 reorganized releases from flat structure (`releases/v5.2.0/`) to nested product-based structure (`releases/framework/v5.2.0/`). Documentation still shows old pattern and needs updating for framework v5.2.0 release.

**Reference:** [CHORE-131-affected-files.md](../backlog/CHORE-131-affected-files.md) contains complete analysis of affected files.

---

## Scope

### Files to Update

**Priority 1 (Core workflow):**
1. `framework/docs/collaboration/workflow-guide.md` - Release process examples
2. `framework/CLAUDE.md` - AI navigation, structure reference
3. `framework/docs/PROJECT-STRUCTURE.md` - Structure diagram

**Priority 2 (Process docs):**
4. `framework/docs/process/version-control-workflow.md` - Archive step
5. `framework/docs/collaboration/architecture-guide.md` - Structure reference
6. `framework/docs/ref/framework-commands.md` - Release commands

**Priority 3 (Quick reference):**
7. `QUICK-START.md` - Workflow diagram
8. `README.md` - Workflow description
9. `framework/docs/collaboration/troubleshooting-guide.md` - Examples

### Pattern Changes

**Old (flat):**
```bash
mkdir -p project-hub/history/releases/v5.2.0
mv project-hub/work/done/*.md project-hub/history/releases/v5.2.0/
```

**New (nested by product):**
```bash
mkdir -p project-hub/history/releases/framework/v5.2.0
mv project-hub/work/done/*.md project-hub/history/releases/framework/v5.2.0/
```

**Workflow update:**
- Old: `backlog → todo → doing → done → history/releases/vX.Y.Z/`
- New: `backlog → todo → doing → done → history/releases/{product}/vX.Y.Z/`

**Products:**
- `plugin-light` - Lightweight plugin edition
- `plugin-full` - Full framework plugin (future)
- `framework` - Comprehensive framework

---

## Completion Criteria

- [x] All 9 documentation files updated with new path pattern
- [x] Examples use `releases/{product}/{version}/` format
- [x] Workflow diagrams show nested structure
- [x] Structure diagrams show product folders
- [x] No references to old flat `releases/vX.Y.Z/` pattern remain
- [x] All paths tested for accuracy

---

## Implementation Summary

**Completed:** 2026-02-13

### Files Updated (9 total)

**Priority 1 - Core Workflow:**
1. ✅ `framework/docs/collaboration/workflow-guide.md` - Updated all examples and workflow descriptions
2. ✅ `framework/CLAUDE.md` - Updated troubleshooting examples
3. ✅ `framework/docs/PROJECT-STRUCTURE.md` - Added product folders to structure diagram

**Priority 2 - Process Documentation:**
4. ✅ `framework/docs/process/version-control-workflow.md` - Updated archive step
5. ✅ `framework/docs/collaboration/architecture-guide.md` - Updated workflow diagrams (2 locations)
6. `framework/docs/ref/framework-commands.md` - N/A (only references folder name, not paths)

**Priority 3 - Quick Reference:**
7. ✅ `QUICK-START.md` - Updated workflow descriptions (2 locations)
8. ✅ `README.md` - Updated workflow diagram
9. ✅ `framework/docs/collaboration/troubleshooting-guide.md` - Updated retroactive fix examples

**Bonus:**
10. ✅ `framework/CLAUDE-QUICK-REFERENCE.md` - Updated release process and work item locations (3 locations)

### Pattern Changes Applied

All instances of:
- `releases/vX.Y.Z` → `releases/{product}/vX.Y.Z`
- `releases/v2.3.0` → `releases/framework/v2.3.0`
- Added product selection guidance where appropriate

### Verification

✅ No remaining `releases/v[0-9]` references in documentation (except historical release files)
✅ All examples use new nested pattern
✅ Structure diagrams show product folders
✅ Backup branch created for safety

---

## Implementation Notes

**Strategy:**
1. Use affected-files.md as checklist
2. Update Priority 1 files first (core workflow)
3. Search each file for `releases/v` and update to `releases/{product}/v`
4. Update structure diagrams to show nesting
5. Verify no broken references

**Historical releases:**
- Leave old framework releases (v2.x - v5.1.0) in flat structure
- They are historical artifacts, paths reflect structure at time of writing
- Only new releases use nested pattern

---

## Related Work Items

- **CHORE-131:** Reorganize Releases by Product (established the pattern)
- **Framework v5.2.0 release:** These docs are part of the release

---

## Verification (2026-02-16)

**Action:** Comprehensive review of all 9 files to verify updates were applied correctly.

**Method:** File-by-file grep and read verification documented in [DOCS-133-scratch-updates.md](../doing/DOCS-133-scratch-updates.md)

**Result:** ✅ All files confirmed correct:
- All path examples use `releases/{product}/vX.Y.Z` or `releases/framework/vX.Y.Z`
- Structure diagrams show product-based nesting
- Workflow descriptions include product selection
- Zero instances of old flat `releases/vX.Y.Z` pattern in current documentation

**Grep verification:**
```bash
grep -r "releases/v[0-9]" framework/docs/ QUICK-START.md README.md framework/CLAUDE.md
# Result: No matches (clean)
```

**Generic references preserved:**
- Directory listings: `ls project-hub/history/releases/` (correct - shows top-level)
- Glob patterns: `{work,releases,poc}/**/*.md` (correct - scans recursively)
- English text: "after releases" (correct - not a path)

**Conclusion:** DOCS-133 implementation verified complete and accurate.

---

**Last Updated:** 2026-02-16
**Completed:** 2026-02-13
**Verified:** 2026-02-16
**Status:** Done

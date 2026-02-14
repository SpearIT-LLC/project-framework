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

- [ ] All 9 documentation files updated with new path pattern
- [ ] Examples use `releases/{product}/{version}/` format
- [ ] Workflow diagrams show nested structure
- [ ] Structure diagrams show product folders
- [ ] No references to old flat `releases/vX.Y.Z/` pattern remain
- [ ] All paths tested for accuracy

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

**Last Updated:** 2026-02-13
**Status:** Doing

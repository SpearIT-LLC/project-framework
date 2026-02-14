# Implementation Plan: Update Release Documentation for Nested Structure

**Parent Work Item:** DOCS-133
**Created:** 2026-02-13
**Status:** Ready to implement

---

## Context

CHORE-131 reorganized releases from flat (`releases/v5.2.0/`) to nested product-based structure (`releases/framework/v5.2.0/`). Documentation currently shows old pattern and must be updated before framework v5.2.0 release.

**Problem:** 9+ documentation files contain outdated path examples and structure references.

---

## Objectives

1. Update all framework documentation to show new nested release pattern
2. Ensure examples are accurate and testable
3. Maintain consistency across all documentation
4. Preserve historical accuracy (don't update historical release docs)

---

## Affected Files Analysis

### Priority 1: Core Workflow Documentation (Critical)

**1. framework/docs/collaboration/workflow-guide.md**
- **Scope:** Release process section, archival examples
- **Changes needed:**
  - Update `mkdir -p project-hub/history/releases/v2.3.0` → `releases/framework/v2.3.0`
  - Update workflow diagram showing archive step
  - Add product selection guidance (which product am I releasing?)
- **Risk:** High - this is primary workflow reference

**2. framework/CLAUDE.md**
- **Scope:** AI navigation guide, quick reference examples
- **Changes needed:**
  - Update release archival instructions
  - Update structure reference showing `releases/` folder
- **Risk:** High - used in every AI session

**3. framework/docs/PROJECT-STRUCTURE.md**
- **Scope:** Complete project structure diagram
- **Changes needed:**
  - Show nested `releases/` structure with product folders
  - Add example showing plugin-light/, plugin-full/, framework/
- **Risk:** Medium - structural reference

### Priority 2: Process Documentation (Important)

**4. framework/docs/process/version-control-workflow.md**
- **Scope:** Git workflow, archival step
- **Changes needed:**
  - Update archive commands to include product folder
- **Risk:** Medium

**5. framework/docs/collaboration/architecture-guide.md**
- **Scope:** Architecture overview, folder structure
- **Changes needed:**
  - Update `history/releases/vX.Y.Z/` references
- **Risk:** Low

**6. framework/docs/ref/framework-commands.md**
- **Scope:** Command reference
- **Changes needed:**
  - Update release-related command examples
- **Risk:** Low

### Priority 3: Quick Reference (Nice-to-have)

**7. QUICK-START.md**
- **Scope:** Workflow diagram
- **Changes needed:**
  - Update `done → history/releases/` to show product nesting
- **Risk:** Low - quick reference only

**8. README.md**
- **Scope:** Repository overview, workflow description
- **Changes needed:**
  - Update workflow description: `work/done → history/releases/`
- **Risk:** Low

**9. framework/docs/collaboration/troubleshooting-guide.md**
- **Scope:** Examples for common issues
- **Changes needed:**
  - Update release directory examples
- **Risk:** Low

---

## Implementation Plan

### Phase 1: Preparation

**Step 1: Create backup branch (optional safety)**
```bash
git branch backup-before-docs-update
```

**Step 2: Read each file to understand current state**
- Document current references
- Identify all instances needing update
- Note any special cases

### Phase 2: Update Core Workflow Docs (Priority 1)

**Step 3: Update workflow-guide.md**

**Current state check:**
```bash
grep -n "releases/v" framework/docs/collaboration/workflow-guide.md
```

**Changes:**
1. Find all instances of `releases/vX.Y.Z` pattern
2. Replace with `releases/framework/vX.Y.Z` (since this is framework docs)
3. Add section explaining product-based organization:
   ```markdown
   ## Release Organization

   Releases are organized by product, then version:
   - `releases/plugin-light/vX.Y.Z/` - Plugin lightweight edition
   - `releases/framework/vX.Y.Z/` - Framework releases
   - `releases/plugin-full/vX.Y.Z/` - Full framework plugin (future)
   ```
4. Update archival examples:
   ```bash
   # Old
   mkdir -p project-hub/history/releases/v2.3.0

   # New
   mkdir -p project-hub/history/releases/framework/v2.3.0
   ```

**Verification:**
- Grep for remaining `releases/v` instances
- Verify examples are accurate
- Check workflow diagram updated

**Step 4: Update framework/CLAUDE.md**

**Changes:**
1. Update release archival quick reference
2. Update structure overview (if present)
3. Add product selection note

**Verification:**
- No flat `releases/v` references remain
- Examples match new pattern

**Step 5: Update framework/docs/PROJECT-STRUCTURE.md**

**Changes:**
1. Update structure diagram to show:
   ```
   project-hub/
   └── history/
       └── releases/
           ├── plugin-light/
           │   └── v1.0.0/
           ├── framework/
           │   ├── v5.1.0/
           │   └── v5.2.0/
           └── v2.1.0/ through v5.1.0/ (historical - flat structure)
   ```
2. Add note about historical vs current structure

**Verification:**
- Diagram accurately reflects reality
- Note explains mixed structure

### Phase 3: Update Process Docs (Priority 2)

**Step 6-8: Update version-control-workflow.md, architecture-guide.md, framework-commands.md**

**For each file:**
1. Read file
2. Find `releases/v` instances
3. Replace with `releases/framework/v`
4. Verify context makes sense
5. Commit individual file

**Pattern:**
```bash
# Read
grep -n "releases" framework/docs/process/version-control-workflow.md

# Edit (use Edit tool)

# Verify
grep -n "releases/v[0-9]" framework/docs/process/version-control-workflow.md
# Should return empty (all updated to releases/framework/v)
```

### Phase 4: Update Quick Reference (Priority 3)

**Step 9-11: Update QUICK-START.md, README.md, troubleshooting-guide.md**

**Same pattern:**
1. Read, identify, update, verify
2. Can batch these as single commit (lower risk)

### Phase 5: Verification

**Step 12: Global search for missed references**
```bash
# Should return ONLY historical release files (v2.x - v5.1.0)
grep -r "releases/v[0-9]" framework/docs/ QUICK-START.md README.md framework/CLAUDE.md

# Check for common typos
grep -r "releases/vX.Y.Z" framework/docs/
```

**Step 13: Verify examples are runnable**
- Check that all bash examples use correct paths
- Verify directory names match reality
- Test at least one example manually

**Step 14: Check for broken internal links**
```bash
# If docs link to release folders
grep -r "](.*releases/" framework/docs/
```

---

## Special Cases & Edge Cases

### Historical Release References

**DO NOT UPDATE:**
- References inside `project-hub/history/releases/v2.x/` through `v5.1.0/` files
- These are historical artifacts describing structure at time of writing
- Updating them would be revisionist history

**Example:**
- `releases/v3.0.0/FEAT-026-structure-migration.md` references old structure
- Leave as-is, it's historically accurate

### Version Placeholders

**Pattern:** `vX.Y.Z` or `v{version}`

**Update to:** `{product}/vX.Y.Z` or `{product}/v{version}`

**Where product context is framework:**
```markdown
# Before
mkdir -p releases/vX.Y.Z

# After
mkdir -p releases/framework/vX.Y.Z
```

### Multi-Product Examples

**If example could apply to any product:**
```markdown
# Generic pattern
releases/{product}/{version}/

# Specific examples
releases/plugin-light/v1.0.0/
releases/framework/v5.2.0/
```

---

## Rollback Plan

**If updates cause issues:**

1. **Revert specific commit:**
   ```bash
   git revert <commit-hash>
   ```

2. **Restore from backup branch:**
   ```bash
   git checkout backup-before-docs-update -- framework/docs/
   ```

3. **Cherry-pick good changes:**
   ```bash
   git cherry-pick <hash1> <hash2>
   ```

---

## Success Criteria

- [ ] All 9 files updated with new nested pattern
- [ ] No `releases/v[0-9]` references in current docs (only in historical releases)
- [ ] Examples use `releases/{product}/vX.Y.Z` or `releases/framework/vX.Y.Z`
- [ ] Structure diagrams show product-based nesting
- [ ] Workflow descriptions include product selection
- [ ] At least one example manually tested
- [ ] No broken internal links
- [ ] DOCS-133 moved to done with completion summary

---

## Estimated Effort

- **Phase 1 (Prep):** 5 minutes
- **Phase 2 (Core docs):** 15 minutes
- **Phase 3 (Process docs):** 10 minutes
- **Phase 4 (Quick ref):** 5 minutes
- **Phase 5 (Verification):** 10 minutes

**Total:** ~45 minutes

---

## Testing Plan

**Test 1: Grep verification**
```bash
# Should return empty (all updated)
grep -r "releases/v[0-9]" framework/docs/collaboration/workflow-guide.md
```

**Test 2: Example execution**
```bash
# Pick one example from workflow-guide.md
# Run it manually (dry-run if destructive)
# Verify paths exist and make sense
```

**Test 3: Link validation**
```bash
# If any markdown links to release folders
grep -r "](.*releases/" framework/docs/ | grep -v "releases/framework"
# Should only show historical references
```

---

## Post-Implementation

### Documentation to Create

**After DOCS-133 complete:**
- Update CHANGELOG.md to note documentation improvements
- Consider adding to PROJECT-STATUS.md

### Pattern to Document

**New standard for future releases:**
```
When releasing:
1. Determine product (framework, plugin-light, plugin-full)
2. Create releases/{product}/vX.Y.Z/
3. Move work items from done/ to release folder
4. Update CHANGELOG
5. Tag and publish
```

---

## Related Files

- **DOCS-133:** [work/doing/DOCS-133-update-release-documentation.md](DOCS-133-update-release-documentation.md)
- **CHORE-131:** [work/done/CHORE-131-reorganize-releases-by-product.md](../done/CHORE-131-reorganize-releases-by-product.md)
- **Affected files list:** [work/backlog/CHORE-131-affected-files.md](../backlog/CHORE-131-affected-files.md)

---

**Plan Status:** Ready to implement
**Estimated Effort:** 45 minutes
**Risk Level:** Medium (many files, core workflow impact)
**Next Action:** Phase 1 - Preparation and file analysis

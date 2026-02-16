# DOCS-133 Update Capture - Documentation Path Changes

**Created:** 2026-02-16
**Purpose:** Capture all specific updates needed before making changes

---

## Update Pattern

**FROM:** `releases/vX.Y.Z` or `releases/v{version}`
**TO:** `releases/framework/vX.Y.Z` or `releases/framework/v{version}`

**Context:** Framework documentation only (not plugin documentation)

---

## Files to Update

### Priority 1: Core Workflow Documentation

#### 1. framework/docs/collaboration/workflow-guide.md
- [x] Read file and identify all instances
- [x] Document line numbers and context
- [x] Apply updates - **NO CHANGES NEEDED** (already correct)
- [x] Verify with grep

#### 2. framework/CLAUDE.md
- [x] Read file and identify all instances
- [x] Document line numbers and context
- [x] Apply updates - **NO CHANGES NEEDED** (already correct)
- [x] Verify with grep

#### 3. framework/docs/PROJECT-STRUCTURE.md
- [x] Read file and identify all instances
- [x] Document line numbers and context
- [x] Update structure diagram - **ALREADY CORRECT**
- [x] Verify with grep

### Priority 2: Process Documentation

#### 4. framework/docs/process/version-control-workflow.md
- [x] Read file and identify all instances
- [x] Document line numbers and context
- [x] Apply updates - **NO CHANGES NEEDED** (already correct)
- [x] Verify with grep

#### 5. framework/docs/collaboration/architecture-guide.md
- [x] Read file and identify all instances
- [x] Document line numbers and context
- [x] Apply updates - **NO CHANGES NEEDED** (already correct)
- [x] Verify with grep

#### 6. framework/docs/ref/framework-commands.md
- [x] Read file and identify all instances
- [x] Document line numbers and context
- [x] Apply updates - **NO CHANGES NEEDED** (generic reference)
- [x] Verify with grep

### Priority 3: Quick Reference

#### 7. QUICK-START.md
- [x] Read file and identify all instances
- [x] Document line numbers and context
- [x] Apply updates - **NO CHANGES NEEDED** (already correct)
- [x] Verify with grep

#### 8. README.md
- [x] Read file and identify all instances
- [x] Document line numbers and context
- [x] Apply updates - **NO CHANGES NEEDED** (already correct)
- [x] Verify with grep

#### 9. framework/docs/collaboration/troubleshooting-guide.md
- [x] Read file and identify all instances
- [x] Document line numbers and context
- [x] Apply updates - **NO CHANGES NEEDED** (already correct)
- [x] Verify with grep

---

## Capture Section

### File 1: framework/docs/collaboration/workflow-guide.md

**Status:** Most already updated to new pattern! Only a few legacy references remain.

**Current instances found:**
```
Line 857: - Scan **all four directories**: `work/`, `releases/`, `poc/`, `history/spikes/`
Line 930: | `project-hub/releases/` | Released items archived by version |
Line 938:    {work,releases,poc,history/spikes}/**/{DECISION,FEAT,TECH,SPIKE,POLICY,BUG}-*.md
Line 951: ls project-hub/{work,releases,poc,history/spikes}/**/*-[0-9][0-9][0-9]-*.md 2>/dev/null
```

**ALREADY CORRECT (no changes needed):**
```
Line 198:  - Create `project-hub/history/releases/{product}/vX.Y.Z/` folder ✓
Line 203:  - **Command:** `git mv project-hub/work/done/WORK-ITEM-*.md project-hub/history/releases/{product}/vX.Y.Z/` ✓
Line 435: #### → history/releases/{product}/vX.Y.Z/ ✓
Line 807: - Spikes archive to `history/spikes/`, not `history/releases/` ✓
Line 1646:    mkdir -p project-hub/history/releases/framework/v2.3.0 ✓
Line 1651-1653: git mv commands to releases/framework/v2.3.0/ ✓
```

**Analysis:**
Lines 857, 930, 938, 951 are **generic references** to the releases/ directory as a whole, not specific version paths. These are talking about "the releases directory" in general, used for ID scanning.

**Decision needed:**
- Should these stay as `releases/` (referring to the top-level directory)?
- Or update to `history/releases/` (more explicit about location)?
- The glob patterns `{work,releases,poc,history/spikes}/**/*` work correctly because they scan recursively into product subfolders

**Recommendation:** These are fine as-is. They refer to the directory generically, and the recursive glob pattern will find items in subdirectories.

---

### File 2: framework/CLAUDE.md

**Status:** ✅ Already correct!

**Current instances found:**
```
Line 60:  └── releases/           # Release archives (generic directory reference)
Line 424: mkdir -p project-hub/history/releases/{product}/vX.Y.Z ✓
Line 425: mv project-hub/work/done/*.md project-hub/history/releases/{product}/vX.Y.Z/ ✓
```

**Updates needed:**
```
None - all references already use {product} placeholder correctly
```

---

### File 3: framework/docs/PROJECT-STRUCTURE.md

**Status:** ✅ Already correct!

**Current instances found:**
```
Line 90:    │   ├── releases/                # REQUIRED - Archived work items by product/version
Line 91:    │   │   ├── framework/           # Framework releases (v5.2.0+)
Line 92:    │   │   ├── plugin-light/        # Plugin lightweight edition releases
Line 93:    │   │   └── plugin-full/         # Plugin full edition releases (future)
```

**Updates needed:**
```
None - structure diagram already shows nested product-based organization
```

---

### File 4: framework/docs/process/version-control-workflow.md

**Status:** ✅ Already correct!

**Current instances found:**
```
Line 148: [ ] Archive: work/done/*.md → history/releases/{product}/vX.Y.Z/ ✓

Other instances (lines 568-1139) are generic text like "multiple releases", "subsequent releases"
- These are not path references, just English text - no changes needed
```

**Updates needed:**
```
None - archival command already uses {product} placeholder
```

---

### File 5: framework/docs/collaboration/architecture-guide.md

**Status:** ✅ Already correct!

**Current instances found:**
```
Line 66:  project-hub/history/releases/{product}/vX.Y.Z/  # Archived after release ✓
Line 196: history/releases/{product}/vX.Y.Z/ ✓
```

**Updates needed:**
```
None - already uses {product} placeholder
```

---

### File 6: framework/docs/ref/framework-commands.md

**Status:** ✅ No changes needed

**Current instances found:**
```
Line 143: - Moving to `releases/` triggers full release process
```

**Updates needed:**
```
None - this is a generic reference to the releases/ directory concept, not a specific path
```

---

### File 7: QUICK-START.md

**Status:** ✅ Already correct!

**Current instances found:**
```
Line 40:  7. Update CHANGELOG.md and PROJECT-STATUS.md for releases (generic text)
Line 78:  # 4. Move completed work to history/releases/ (generic directory)
Line 132: - **Work Item Flow:** backlog → todo → doing → done → history/releases/{product}/{version}/ ✓
Line 196: work/backlog/ → work/todo/ → work/doing/ (max 1) → work/done/ → history/releases/{product}/{version}/ ✓
```

**Updates needed:**
```
None - workflow paths already use {product}/{version} pattern
```

---

### File 8: README.md

**Status:** ✅ Already correct!

**Current instances found:**
```
Line 154: work/backlog → work/todo → work/doing → work/done → history/releases/{product}/{version}/ ✓
Line 386: - ✅ How we manage releases (generic text)
```

**Updates needed:**
```
None - workflow path already uses {product}/{version} pattern
```

---

### File 9: framework/docs/collaboration/troubleshooting-guide.md

**Status:** ✅ Already correct!

**Current instances found:**
```
Line 58:  3. **Is git clean?** Run `git status`, should see "nothing to commit, working tree clean" after releases (generic text)
Line 299: - No historical record in history/releases/ (generic directory)
Line 307: # Check if history/releases/{product}/vX.Y.Z/ exists ✓
Line 308: ls project-hub/history/releases/ (generic ls command)
Line 316: mkdir -p project-hub/history/releases/framework/v2.1.0 ✓
Line 319: mv project-hub/work/done/*.md project-hub/history/releases/framework/v2.1.0/ ✓
Line 322: git add project-hub/history/releases/framework/v2.1.0/ ✓
Line 574: - Atomic releases (update all version indicators in one commit) (generic text)
```

**Updates needed:**
```
None - all path examples already use framework/vX.Y.Z pattern or {product}/vX.Y.Z placeholder
```

---

## Verification Checklist

- [x] All 9 files scanned and documented
- [x] All instances captured with line numbers
- [x] Update patterns identified - **ALL FILES ALREADY CORRECT!**
- [x] Special cases noted (historical references to preserve)
- [x] ~~Ready to proceed with Phase 2~~ **NO UPDATES NEEDED**

## FINDING: Documentation Already Updated!

**Result:** All 9 files in scope already use the correct nested pattern:
- `releases/{product}/vX.Y.Z/` (placeholder form)
- `releases/framework/vX.Y.Z/` (specific example form)

**What happened:**
The documentation was already updated during or after CHORE-131 implementation. The plan in DOCS-133-PLAN assumed these files still had the old flat pattern, but they don't.

**Remaining references to `releases/` without nesting:**
All are **intentionally generic** references:
- Directory listings: `ls project-hub/history/releases/`
- Glob patterns: `{work,releases,poc}/**/*.md` (works recursively)
- Text descriptions: "after releases" (English, not paths)

These generic references are correct and should NOT be changed.

---

## Notes

**Historical references to PRESERVE (DO NOT UPDATE):**
- Files inside `project-hub/history/releases/v2.x/` through `v5.1.0/`
- These are historical artifacts - leave structure references as-is

**Pattern variations to look for:**
- `releases/v2.3.0` (specific version)
- `releases/vX.Y.Z` (placeholder)
- `releases/v{version}` (placeholder)
- `history/releases/v` (with history prefix)
- `project-hub/history/releases/v` (full path)

---

**Status:** ✅ COMPLETE - No changes needed
**Next Action:** Update DOCS-133 work item to reflect findings

---

## Final Verification

**Command:** `grep -r "releases/v[0-9]" framework/docs/ QUICK-START.md README.md framework/CLAUDE.md`
**Result:** No matches found (excluding historical release files)

**Conclusion:**
All documentation already uses the correct nested pattern. DOCS-133 can be closed as "already complete" or "no longer needed".

---

**Completed:** 2026-02-16
**Status:** Done

# CHORE-131: Reorganize Releases Folder by Product

**Type:** CHORE
**Status:** Backlog
**Created:** 2026-02-13
**Priority:** Medium
**Version Impact:** PATCH (internal organization)

---

## Objective

Reorganize `project-hub/history/releases/` to group releases by product (plugin-light, plugin-full, framework), creating a scalable structure for managing multiple product lines with independent versioning.

---

## Problem Statement

**Current structure:**
```
project-hub/history/releases/
├── plugin-light-v1.0.0-marketplace-submission.md
└── (future releases will clutter this directory)
```

**Issues:**
- No product separation (plugin vs framework releases mixed together)
- No version organization (all v1.0.0 artifacts scattered)
- Doesn't scale for multiple products with independent versions
- Work items in done/ not associated with releases

---

## Proposed Structure

```
project-hub/history/releases/
├── plugin-light/
│   └── v1.0.0/
│       ├── marketplace-submission.md
│       ├── FEAT-118-claude-code-plugin.md (moved from done/)
│       ├── TASK-126-finalize-plugin-mvp.md (moved from done/)
│       ├── FEAT-119-plugin-new-command.md (moved from done/)
│       ├── FEAT-120-plugin-testing-infrastructure.md (moved from done/)
│       └── TASK-129-pre-publication-repository-review.md (moved from done/)
│   └── v1.1.0/ (future)
│       └── [work items for v1.1.0]
├── plugin-full/ (future - FEAT-127)
│   └── v1.0.0/
│       └── [work items for full plugin v1.0.0]
└── framework/
    ├── v1.0.0/
    ├── v2.0.0/
    ├── v3.0.0/
    ├── v4.0.0/
    └── v5.1.0/
        └── [work items for framework v5.1.0]
```

---

## Benefits

✅ **Clear product separation** - plugin-light vs plugin-full vs framework
✅ **Version organization** - all v1.0.0 artifacts together (submission docs + work items)
✅ **Scalable pattern** - easy to add v1.1.0, v2.0.0, etc.
✅ **Work item archival** - completed work moves with the release that shipped it
✅ **Historical clarity** - which work items shipped in which version
✅ **Clean done/ folder** - work items archived to releases, not accumulating in done/

---

## Implementation Plan

### Phase 1: Create Plugin Light v1.0.0 Structure

1. **Create directory structure:**
   ```bash
   mkdir -p project-hub/history/releases/plugin-light/v1.0.0
   ```

2. **Move marketplace submission:**
   ```bash
   git mv project-hub/history/releases/plugin-light-v1.0.0-marketplace-submission.md \
          project-hub/history/releases/plugin-light/v1.0.0/marketplace-submission.md
   ```

3. **Move completed work items (when plugin is released/submitted):**
   ```bash
   git mv project-hub/work/done/FEAT-118-claude-code-plugin.md \
          project-hub/history/releases/plugin-light/v1.0.0/

   git mv project-hub/work/done/TASK-126-finalize-plugin-mvp.md \
          project-hub/history/releases/plugin-light/v1.0.0/

   git mv project-hub/work/done/FEAT-119-plugin-new-command.md \
          project-hub/history/releases/plugin-light/v1.0.0/

   git mv project-hub/work/done/FEAT-120-plugin-testing-infrastructure.md \
          project-hub/history/releases/plugin-light/v1.0.0/

   git mv project-hub/work/done/TASK-129-pre-publication-repository-review.md \
          project-hub/history/releases/plugin-light/v1.0.0/
   ```

4. **Create release summary (optional):**
   ```bash
   # Create releases/plugin-light/v1.0.0/README.md
   # Document what shipped in v1.0.0, when, and key features
   ```

### Phase 2: Framework Releases Organization (Future)

**When ready to organize framework releases:**

1. **Create framework structure:**
   ```bash
   mkdir -p project-hub/history/releases/framework/{v1.0.0,v2.0.0,v3.0.0,v4.0.0,v5.1.0}
   ```

2. **Move/organize framework work items:**
   - Review done/ folder for framework work items
   - Identify which version each shipped in
   - Move to appropriate version folder

3. **Create version summaries:**
   - Document what changed in each version
   - Link to changelog entries
   - Note breaking changes and migration notes

### Phase 3: Future Products (As Needed)

**When FEAT-127 (full framework plugin) ships:**

1. **Create plugin-full structure:**
   ```bash
   mkdir -p project-hub/history/releases/plugin-full/v1.0.0
   ```

2. **Archive related work items:**
   - Move FEAT-127 and supporting work items
   - Document marketplace submission
   - Link to plugin package

---

## Acceptance Criteria

- [x] Directory structure created: `releases/plugin-light/v1.0.0/`
- [x] Marketplace submission moved to new location
- [x] Work items for v1.0.0 moved from done/ to releases/plugin-light/v1.0.0/
- [x] Directory structure created: `releases/framework/v5.2.0/`
- [x] Framework work items moved from done/ to releases/framework/v5.2.0/
- [x] (Optional) README.md created in v1.0.0/ summarizing the release - SKIPPED: Not needed, work items are self-documenting
- [x] No broken references in moved files
- [x] Git history preserved (using git mv, not copy/delete)

---

## Files to Search for References

**Potentially affected documentation:**
- Framework documentation (references to releases folder structure)
- Workflow guides (where completed work items go)
- CLAUDE.md (navigation guidance)
- Process documentation (release workflow)
- Session history templates
- Any scripts that reference releases/

**Search needed:**
```bash
grep -r "releases/" framework/docs/ project-hub/docs/ .claude/
grep -r "done/" framework/docs/ project-hub/docs/ .claude/
grep -r "history/releases" framework/docs/ project-hub/docs/
```

---

## Migration Timing

**Immediate (Phase 1):**
- Create structure for plugin-light v1.0.0
- Move marketplace submission document
- Move work items when plugin is submitted/approved

**Future (Phase 2):**
- Organize framework releases when needed
- Can be done as separate work item (CHORE-132)

**Future (Phase 3):**
- Create plugin-full structure when FEAT-127 ships

---

## Risks and Considerations

**Risk 1: Broken references**
- **Mitigation:** Search all docs for references before moving
- **Mitigation:** Update references in same commit as moves

**Risk 2: Git history loss**
- **Mitigation:** Always use `git mv`, never copy/delete
- **Mitigation:** Verify history with `git log --follow`

**Risk 3: Unclear release boundaries**
- **Mitigation:** Create README.md in each version folder
- **Mitigation:** Document what shipped, when, and why

---

## Success Metrics

- Clear product/version organization visible in file tree
- Easy to find "what shipped in plugin-light v1.0.0"
- done/ folder stays clean (work items archived to releases)
- Scalable pattern established for future versions

---

## Related Work Items

- **FEAT-118:** Claude Code Plugin (will be archived in plugin-light/v1.0.0/)
- **TASK-126:** Finalize Plugin MVP (will be archived in plugin-light/v1.0.0/)
- **FEAT-119:** Plugin New Command (will be archived in plugin-light/v1.0.0/)
- **FEAT-120:** Plugin Testing Infrastructure (will be archived in plugin-light/v1.0.0/)
- **TASK-129:** Pre-Publication Repository Review (will be archived in plugin-light/v1.0.0/)

---

## Notes

**Philosophy:** This reorganization follows the pattern of organizing by product first, then by version. This matches how users think ("what's in the plugin release?") rather than forcing them to mentally filter mixed releases.

**Timing:** Phase 1 should happen now (plugin-light v1.0.0 is about to be released). Phase 2 can wait until framework organization is needed. Phase 3 happens when FEAT-127 ships.

**Work item lifecycle:**
1. Created in backlog/
2. Moved to todo/ (committed)
3. Moved to doing/ (started work)
4. Moved to done/ (completed work)
5. **Moved to releases/{product}/{version}/** (shipped in release)

This adds a final step to the workflow: archiving completed work with the release that shipped it.

---

**Created:** 2026-02-13
**Completed:** 2026-02-13
**Purpose:** Establish scalable release organization pattern for multiple products

---

## Implementation Summary

**Completed:** 2026-02-13

### Phase 1: Plugin Light v1.0.0 ✅

Created nested structure and moved 7 items:
- `releases/plugin-light/v1.0.0/marketplace-submission.md`
- `releases/plugin-light/v1.0.0/FEAT-118-claude-code-plugin.md`
- `releases/plugin-light/v1.0.0/FEAT-118-PLAN-template-extraction.md`
- `releases/plugin-light/v1.0.0/FEAT-119-plugin-new-command.md`
- `releases/plugin-light/v1.0.0/FEAT-120-plugin-testing-infrastructure.md`
- `releases/plugin-light/v1.0.0/TASK-126-finalize-plugin-mvp.md`
- `releases/plugin-light/v1.0.0/TASK-129-pre-publication-repository-review.md`

### Framework v5.2.0 ✅

Created nested structure and moved 6 items:
- `releases/framework/v5.2.0/BUG-108-ghost-references-to-framework-project-hub.md`
- `releases/framework/v5.2.0/BUG-109-starter-template-project-hub-location.md`
- `releases/framework/v5.2.0/BUG-113-incomplete-release-checklist.md`
- `releases/framework/v5.2.0/DECISION-037-execution-plan.md`
- `releases/framework/v5.2.0/DECISION-037-project-hub-location.md`
- `releases/framework/v5.2.0/FEAT-011-sample-project.md`

### Results

- ✅ Nested product/version pattern established
- ✅ `done/` folder now clean (only .gitkeep)
- ✅ All git history preserved (used `git mv`)
- ✅ Pattern ready for future releases (plugin-full, framework v5.3.0, etc.)

### Future Work

- **Phase 2 (Deferred):** Reorganize historical framework releases (v2.x - v5.1.0) into nested structure
- **Phase 3 (Future):** Create `plugin-full/v1.0.0/` when FEAT-127 ships

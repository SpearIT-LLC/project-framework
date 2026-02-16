# CHORE-131: Affected Files Analysis

**Work Item:** CHORE-131 - Reorganize Releases Folder by Product
**Analysis Date:** 2026-02-13

---

## Files That Reference releases/ Structure

### Framework Documentation (Need Updates)

**1. [framework/docs/collaboration/architecture-guide.md](framework/docs/collaboration/architecture-guide.md)**
- References: `history/releases/vX.Y.Z/`
- **Update needed:** Change to `history/releases/{product}/vX.Y.Z/`

**2. [framework/docs/collaboration/workflow-guide.md](framework/docs/collaboration/workflow-guide.md)**
- Multiple references to `history/releases/vX.Y.Z/`
- Release process section
- **Update needed:** Document product-based organization pattern

**3. [framework/docs/collaboration/troubleshooting-guide.md](framework/docs/collaboration/troubleshooting-guide.md)**
- Examples: `mkdir -p project-hub/history/releases/v2.1.0`
- Examples: `mv project-hub/work/done/*.md project-hub/history/releases/v2.1.0/`
- **Update needed:** Update examples to include product folder

**4. [framework/docs/process/version-control-workflow.md](framework/docs/process/version-control-workflow.md)**
- Archive step: `work/done/*.md → history/releases/vX.Y.Z/`
- **Update needed:** Update to `history/releases/{product}/vX.Y.Z/`

**5. [framework/docs/PROJECT-STRUCTURE.md](framework/docs/PROJECT-STRUCTURE.md)**
- Structure diagram shows `releases/` folder
- **Update needed:** Show nested product/version structure

**6. [framework/docs/ref/framework-commands.md](framework/docs/ref/framework-commands.md)**
- References moving to `releases/`
- **Update needed:** Update release process description

**7. [framework/CLAUDE.md](framework/CLAUDE.md)**
- Examples: `mkdir -p project-hub/history/releases/vX.Y.Z`
- Structure reference
- **Update needed:** Update examples and structure diagram

### Root Documentation (Need Updates)

**8. [QUICK-START.md](QUICK-START.md)**
- Flow diagram: `done → history/releases/`
- **Update needed:** Show `done → history/releases/{product}/{version}/`

**9. [README.md](README.md)**
- Workflow: `work/done → history/releases/`
- **Update needed:** Update workflow description

**10. [README-OLD.md](README-OLD.md)**
- Same reference (backup file)
- **Decision:** Leave as-is (historical backup)

**11. [VERIFICATION-REPORT.md](VERIFICATION-REPORT.md)**
- References archived work items in history/releases/
- **Decision:** Leave as-is (historical report)

### Project Hub Documentation (Need Review)

**12. [project-hub/docs/](project-hub/docs/)**
- May contain release process documentation
- **Action needed:** Review and update if necessary

---

## Update Strategy

### Priority 1: Core Workflow Documentation

**Must update before implementing reorganization:**

1. `framework/docs/collaboration/workflow-guide.md`
   - Primary workflow documentation
   - Most detailed release process

2. `framework/CLAUDE.md`
   - AI navigation guide
   - Used in every session

3. `framework/docs/PROJECT-STRUCTURE.md`
   - Structural reference
   - Shows expected organization

### Priority 2: Process Documentation

**Update during implementation:**

4. `framework/docs/process/version-control-workflow.md`
5. `framework/docs/collaboration/architecture-guide.md`
6. `framework/docs/ref/framework-commands.md`

### Priority 3: Quick Reference

**Update after implementation:**

7. `QUICK-START.md`
8. `README.md`
9. `framework/docs/collaboration/troubleshooting-guide.md`

### Priority 4: Reference Documentation

**Update if needed:**

10. `framework/docs/ref/GLOSSARY.md` (check if releases/ mentioned)
11. Project hub docs (review for release references)

---

## Recommended Update Pattern

### Old Pattern (Single Product)
```
history/releases/vX.Y.Z/
```

### New Pattern (Multi-Product)
```
history/releases/{product}/vX.Y.Z/

Where {product} is:
- plugin-light
- plugin-full
- framework
```

### Documentation Examples to Update

**Before:**
```bash
mkdir -p project-hub/history/releases/v2.1.0
mv project-hub/work/done/*.md project-hub/history/releases/v2.1.0/
```

**After:**
```bash
mkdir -p project-hub/history/releases/framework/v2.1.0
mv project-hub/work/done/*.md project-hub/history/releases/framework/v2.1.0/
```

---

## Work Item Flow Update

**Current:**
```
backlog → todo → doing → done → history/releases/vX.Y.Z/
```

**Updated:**
```
backlog → todo → doing → done → history/releases/{product}/vX.Y.Z/
```

---

## Implementation Approach

### Option 1: Update Docs First (Recommended)

1. Create CHORE-131
2. Update all documentation to reflect new structure
3. Implement reorganization
4. Verify documentation matches reality

**Pros:** Documentation drives implementation
**Cons:** Docs temporarily ahead of reality

### Option 2: Implement Then Document

1. Create CHORE-131
2. Reorganize folders
3. Update documentation to match
4. Verify completeness

**Pros:** Documentation matches reality immediately
**Cons:** Window where docs are wrong

### Recommendation: Option 1

Update workflow-guide.md and CLAUDE.md first (they guide implementation), then reorganize, then update reference docs.

---

## Verification Checklist

After implementation:

- [ ] All framework/docs/ references updated
- [ ] Root README.md updated
- [ ] QUICK-START.md updated
- [ ] framework/CLAUDE.md updated
- [ ] No broken links or references
- [ ] Examples use correct paths
- [ ] Structure diagrams show product folders

---

## Search Commands Used

```bash
# Find all references to releases/
grep -r "releases/" framework/docs/ project-hub/docs/ CLAUDE.md framework/CLAUDE.md

# Find history/releases references
grep -r "history/releases" framework/docs/ project-hub/docs/ *.md

# Find work/done references (related workflow)
grep -r "work/done" framework/docs/ project-hub/docs/
```

---

**Created:** 2026-02-13
**Completed:** 2026-02-13
**Purpose:** Document all files affected by releases/ reorganization
**Outcome:** Analysis complete - findings used in DOCS-133 documentation updates
**Status:** Done

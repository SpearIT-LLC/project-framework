# FEAT-026 Sub-Item Strategy

**Created:** 2026-01-06
**Status:** Active approach for FEAT-026 completion

---

## Overview

FEAT-026 revealed 12 issues during implementation that must be fixed before merge. We're using a hierarchical sub-item approach to manage these.

---

## Naming Convention

**Format:** `FEAT-026-{Priority}-{Category}-{description}.md`

**Components:**
- **FEAT-026** - Parent work item
- **Priority** - P1 (critical), P2 (high), P3 (medium - moved to backlog)
- **Category** - BUG, TECH, ENH
- **Description** - Short kebab-case description

**Examples:**
- `FEAT-026-P1-BUG-root-claude.md`
- `FEAT-026-P2-TECH-remove-enterprise.md`

**Benefits:**
- All FEAT-026 items group together alphabetically
- Priority visible in filename
- Easy to see what's critical vs. nice-to-have
- Parent-child relationship clear

---

## Status Tracking: Pure Option 1

**Decision:** Folder location IS status. No duplicate tracking.

**How it works:**
1. All sub-items start in `framework/thoughts/work/doing/`
2. As each is completed, move to `framework/thoughts/work/done/`
3. Folder location is single source of truth
4. No checklist in main FEAT-026 file (prevents dual source of truth)

**Check progress:**
```bash
# What's left to do
ls framework/thoughts/work/doing/FEAT-026-P*

# What's done
ls framework/thoughts/work/done/FEAT-026-P*
```

**Why Pure Option 1:**
- Single source of truth (folder location)
- Can't get out of sync (no checklist to maintain)
- Visual and simple
- Follows framework workflow principles
- Maximum accuracy

**Completion:**
- FEAT-026 complete when all FEAT-026-P* files are in done/

---

## Current Sub-Items

### P1 - Critical (Must fix before merge)
1. FEAT-026-P1-BUG-root-claude
2. FEAT-026-P1-BUG-path-audit
3. FEAT-026-P1-BUG-framework-structure
4. FEAT-026-P1-BUG-quick-start-separation
5. FEAT-026-P1-BUG-framework-folder-rename

### P2 - High Priority (Should fix before merge)
6. FEAT-026-P2-TECH-remove-enterprise
7. FEAT-026-P2-TECH-doc-dedup
8. FEAT-026-P2-TECH-remove-fake-numbers
9. FEAT-026-P2-TECH-claude-md-cleanup
10. FEAT-026-P2-TECH-step-count-alignment
11. FEAT-026-P2-TECH-workflow-simplification
12. FEAT-026-P2-TECH-version-references

### Future Work (In backlog)
See: `framework/thoughts/work/backlog/FEAT-026-future-enhancements.md`

---

## Workflow

1. **Pick next sub-item** (start with P1s)
2. **Implement fix** following sub-item document
3. **Test/verify** fix works
4. **Commit changes** to feature branch
5. **Move sub-item file** to done/
   ```bash
   git mv framework/thoughts/work/doing/FEAT-026-PX-XXX-name.md \
           framework/thoughts/work/done/
   ```
6. **Commit the move**
7. **Repeat** until all sub-items in done/

---

## Prototype Status

This hierarchical sub-item approach is a **prototype**. We're testing it on FEAT-026 to see if it works well for complex features with discovered issues.

**If successful:**
- Document in FEAT-021 (templates and workflow)
- Add to framework guidelines
- Create templates for sub-item structure

**Learning goals:**
- Does hierarchical naming help?
- Is Pure Option 1 tracking accurate?
- Does this reduce cognitive load?
- Is it worth the added complexity?

---

## Git mv Agreement Violation Note

**Important lesson learned:**

During FEAT-026 implementation, we agreed to COPY files for safety but used `git mv` instead. This violated our agreement even though it worked out.

**Prevention for future:**
- Critical constraints should be in work item file (not just conversation)
- Before major operations, explicitly confirm approach
- Add "Critical Constraints" section to work item template

This has been noted as process improvement for FEAT-021.

---

**Last Updated:** 2026-01-06
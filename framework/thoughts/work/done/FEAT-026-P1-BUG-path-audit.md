# FEAT-026 Sub-Item: Audit and Fix File Path References

**ID:** FEAT-026-P1-BUG-path-audit
**Parent:** FEAT-026-structure-migration
**Type:** Bug (Broken References)
**Priority:** P1 (Critical - must fix before merge)
**Status:** Todo
**Created:** 2026-01-06

---

## Summary

Comprehensive audit needed to find and fix all invalid file path references across documentation after structure migration.

---

## Problem

The FEAT-026 migration moved many files to new locations. Documentation may contain references to old paths that are now broken.

**Known issues from followup:**
- CLAUDE-QUICK-REFERENCE.md - All file paths need review and update (line 44)
- framework/CLAUDE.md - Critical folder paths are wrong (line 31)
- Multiple docs may reference old `thoughts/project/` paths

---

## Scope

**Files to audit:**
- All README.md files (root, framework/, project-hello-world/)
- All markdown files in framework/
- QUICK-START.md
- CLAUDE.md files (root once created, framework/, project-hello-world/)
- INDEX.md files
- Template files

**Common path changes to check:**
- `thoughts/project/collaboration/` → `framework/collaboration/`
- `thoughts/framework/templates/` → `framework/templates/`
- `thoughts/project/planning/backlog/` → `framework/thoughts/work/backlog/`
- `thoughts/project/work/*` → `framework/thoughts/work/*`
- Root-level docs → `framework/` (CHANGELOG, PROJECT-STATUS, INDEX, etc.)

---

## Implementation Approach

1. **Automated search** for common old paths
2. **Manual review** of each documentation file
3. **Fix** all broken references
4. **Verify** links work (spot check key files)

---

## Search Commands

```bash
# Find references to old paths
grep -r "thoughts/project" --include="*.md" .
grep -r "thoughts/framework/templates" --include="*.md" .
grep -r "PROJECT-STATUS.md" --include="*.md" . | grep -v "framework/"
grep -r "CHANGELOG.md" --include="*.md" . | grep -v "framework/"
```

---

## Completion Criteria

- [ ] All markdown files audited for path references
- [ ] All broken paths fixed
- [ ] Key navigation links spot-checked
- [ ] No references to `thoughts/project/` (except in history/migration docs)
- [ ] All references to moved docs updated (CHANGELOG, PROJECT-STATUS, etc.)
- [ ] Changes committed to feature branch

---

**Last Updated:** 2026-01-06
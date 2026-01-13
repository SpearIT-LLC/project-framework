# REFACTOR-052: Pre-Change Audit Report

**Date:** 2026-01-13
**Status:** Phase 0 Complete - Ready for Phase 2

---

## Executive Summary

**Total References Found:**
- `project-hello-world`: 263 references
- `project-templates`: 177 references
- `monorepo`: 135 references

**Categorization:**
- **Historical files (SKIP):** ~99 references in history/ folders
- **Active core docs (UPDATE):** ~23 critical navigation files
- **Work items (UPDATE):** This work item itself, plus references in backlog
- **Structure docs (UPDATE):** REPOSITORY-STRUCTURE.md, PROJECT-STRUCTURE-STANDARD.md

---

## Update Strategy

### Files to SKIP (Historical Preservation)

**Reason:** Historical accuracy - these files document past states and decisions

**Categories to skip:**
1. `framework/thoughts/history/sessions/*.md` - Session histories (historical record)
2. `framework/thoughts/history/releases/v3.0.0/*.md` - v3.0.0 release archives
3. `framework/thoughts/history/releases/v3.0.1/*.md` - v3.0.1 release archives
4. `framework/thoughts/history/releases/v3.1.0/*.md` - v3.1.0 release archives

**Intentional references to preserve:**
- `framework/thoughts/research/package-ecosystem-terminology-patterns.md` - Discusses old/new structure
- `framework/thoughts/work/backlog/REFACTOR-052-adopt-industry-standard-repo-structure.md` - This work item

**Total SKIP count:** ~99 references in history/ folders

---

## Update Strategy by Phase

### Phase 2: project-hello-world → examples/hello-world/

**Critical files (Tier 1):**
- [ ] `./CLAUDE.md` (root) - Multiple references
- [ ] `./QUICK-START.md` (if exists)
- [ ] `framework/CLAUDE.md` - References example project
- [ ] `framework/README.md` - References example
- [ ] `framework/INDEX.md` - May reference example
- [ ] `framework/PROJECT-STATUS.md` - References example
- [ ] `framework/docs/REPOSITORY-STRUCTURE.md` - Defines structure
- [ ] `framework/docs/PROJECT-STRUCTURE-STANDARD.md` - References example

**Work items (Tier 2):**
- [ ] `DECISION-035-root-status-reference.md` - May reference project
- [ ] `DECISION-036-template-access-strategy.md` - May reference project
- [ ] `DECISION-050-framework-distribution-model.md` - May reference project
- [ ] All work items in backlog/ that reference the path

**Expected updates:** ~23 active documentation files + work items in backlog

**Historical files to SKIP:** 99 references in history/ folders

---

### Phase 3: project-templates → templates/

**Critical files (Tier 1):**
- [ ] `./CLAUDE.md` (root) - Multiple references
- [ ] `framework/CLAUDE.md` - References templates
- [ ] `framework/README.md` - References template selection
- [ ] `framework/INDEX.md` - Extensive template documentation
- [ ] `framework/docs/REPOSITORY-STRUCTURE.md` - Defines structure
- [ ] `framework/docs/README.md` - May reference templates

**Work items (Tier 2):**
- [ ] `DECISION-036-template-access-strategy.md` - Core discussion about templates
- [ ] Any work items referencing template paths

**Expected updates:** ~15-20 active files

**Historical files to SKIP:** References in v3.0.0, v3.0.1 releases (already archived)

---

### Phase 4: monorepo → framework source repository

**Critical files (Tier 1):**
- [ ] `./CLAUDE.md` (root) - Primary usage of term
- [ ] `framework/docs/REPOSITORY-STRUCTURE.md` - Defines repository type
- [ ] `framework/docs/PROJECT-STRUCTURE-STANDARD.md` - Uses term
- [ ] `framework/docs/README.md` - May use term
- [ ] `framework/PROJECT-STATUS.md` - Uses term
- [ ] `framework/README.md` - May use term

**Work items (Tier 2):**
- [ ] `DECISION-035-root-status-reference.md` - Extensive monorepo discussion
- [ ] `DECISION-036-template-access-strategy.md` - Discusses monorepo assumption
- [ ] `DECISION-050-framework-distribution-model.md` - Core discussion of paradigm shift

**Intentional preservations:**
- [ ] `package-ecosystem-terminology-patterns.md` - Research doc (discusses old term)
- [ ] `REFACTOR-052` work item - This document (discusses both terms)

**Expected updates:** ~10-15 active files

**Historical files to SKIP:** All session histories and release archives

---

## Validation Checklist

After each phase, run these validations:

### Phase 2 Validation (project-hello-world)
```powershell
# Should return ZERO matches (excluding history/)
grep -r "project-hello-world" . --include="*.md" | grep -v "history/"
```

**Expected result:** Only matches in history/ folders (if any)

### Phase 3 Validation (project-templates)
```powershell
# Should return ZERO matches (excluding history/)
grep -r "project-templates" . --include="*.md" | grep -v "history/"
```

**Expected result:** Only matches in history/ folders (if any)

### Phase 4 Validation (monorepo)
```powershell
# Should return only intentional matches
grep -r "monorepo" . --include="*.md" | grep -v "history/"
```

**Expected result:** Only matches in:
- `package-ecosystem-terminology-patterns.md` (research)
- `REFACTOR-052-adopt-industry-standard-repo-structure.md` (this work item)

---

## Key Findings

### 1. Historical Archive Volume
- **99 references** in history/ folders
- Confirms need for explicit "SKIP" list
- Historical files should NOT be updated

### 2. Core Documentation Impact
- **~23 critical files** require updates for project-hello-world
- Navigation docs (CLAUDE.md, README.md) most affected
- Structure specification docs need comprehensive updates

### 3. Work Item References
- Multiple work items in backlog/ reference old paths
- DECISION-035, DECISION-036, DECISION-050 heavily affected
- These should be updated (not historical)

### 4. Terminology Consistency
- "monorepo" used in ~135 locations
- Most are historical (can skip)
- ~10-15 active files need terminology updates

---

## Risk Mitigation

### Lesson from FEAT-026: Don't Miss References

**Strategy:**
1. ✅ **Comprehensive audit complete** (this report)
2. ✅ **Explicit SKIP list defined** (history/ folders)
3. ✅ **Tier-based update plan** (Critical → Work items → Optional)
4. 🔲 **Validation gates** (grep after each phase)
5. 🔲 **User review gates** (after each phase)

### Validation Script

Will create `validate-paths.ps1` in Phase 6 to automate final validation.

---

## Next Steps

1. ✅ **Phase 0 complete** - Audit finished
2. 🔲 **Phase 2 ready** - Begin project-hello-world migration
   - Start with directory rename (git mv)
   - Then update all Tier 1 docs
   - Then update Tier 2 work items
   - Validate with grep
   - Get user approval

---

## Appendix: Audit Files

**Generated files:**
- `audit-hello-world.txt` - All 263 references
- `audit-templates.txt` - All 177 references
- `audit-monorepo.txt` - All 135 references

**Analysis method:**
```bash
grep -r "project-hello-world" . --include="*.md" > audit-hello-world.txt
grep -r "project-templates" . --include="*.md" > audit-templates.txt
grep -r "monorepo" . --include="*.md" > audit-monorepo.txt
```

**Historical file detection:**
```bash
grep "history/" audit-hello-world.txt | wc -l
# Returns: 99 references
```

---

**Phase 0 Status:** ✅ COMPLETE
**Ready for:** Phase 2 (project-hello-world migration)
**Blockers:** None - awaiting user approval to proceed

---

**Last Updated:** 2026-01-13

# REFACTOR-052: Adopt Industry-Standard Repository Structure

**ID:** 052
**Type:** Refactoring
**Priority:** High
**Status:** Backlog
**Created:** 2026-01-13
**Related:** DECISION-050, package-ecosystem-terminology-patterns.md
**Blocks:** FEAT-025 (Manual Setup Validation)

---

## Summary

Restructure repository to align with industry-standard package development conventions from npm, pip, and bundler ecosystems. Rename `project-hello-world/` → `examples/hello-world/`, `project-templates/` → `templates/`, and update all documentation to use standard terminology ("framework source repository," "bundled dependency model," etc.).

**Key Insight:** Using industry-standard terminology and structure makes the framework instantly recognizable to developers familiar with package ecosystems.

---

## Problem Statement

**Issue:** Current repository structure uses custom naming conventions that don't align with established patterns from npm, pip, and bundler:

**Current structure:**
```
project-framework/              # Called "monorepo"
├── framework/                  # "THE framework"
├── project-hello-world/        # Custom naming
└── project-templates/          # Redundant prefix
```

**Industry standard pattern:**
```
package-name/                   # "Package source repository"
├── src/ or lib/               # Source code
├── examples/                  # Example projects (universal)
├── templates/                 # Starter templates
└── dist/                      # Built distributions (optional)
```

**Problems:**
1. `project-hello-world/` - Custom naming, not recognizable
2. `project-templates/` - Redundant "project-" prefix
3. "Monorepo" terminology - Incorrect after framework-as-dependency model
4. Documentation uses custom terms instead of industry standards
5. Path references will be outdated after restructuring
6. New developers unfamiliar with established conventions

**Who is affected:**
- **New users** - Unfamiliar structure increases cognitive load
- **Existing documentation** - 23+ work items reference old paths
- **FEAT-025** - Blocked by outdated path references
- **Future automation** - Scripts will reference new paths

---

## Requirements

### Functional Requirements

**Directory restructuring:**
- [ ] Rename `project-hello-world/` → `examples/hello-world/`
- [ ] Rename `project-templates/` → `templates/`
- [ ] Update git history to preserve history (git mv)
- [ ] Verify all symlinks/references still work after rename

**Core documentation updates:**
- [ ] Update root `README.md` - repository description and structure
- [ ] Update root `CLAUDE.md` - navigation paths and terminology
- [ ] Update `QUICK-START.md` - path references
- [ ] Update `framework/CLAUDE.md` - context references
- [ ] Update `examples/hello-world/CLAUDE.md` - path references

**Critical path documentation:**
- [ ] Update `NEW-PROJECT-CHECKLIST.md` - template paths
- [ ] Update `DECISION-050` - add reference to research document
- [ ] Update `DECISION-036` - path references (already resolved)

**Terminology standardization:**
- [ ] Replace "monorepo" with "framework source repository"
- [ ] Use "framework source" or "canonical source" for top-level framework/
- [ ] Use "installed framework" or "local copy" for project framework/
- [ ] Use "bundled dependency model" instead of "framework-as-dependency"
- [ ] Use "examples" and "starter templates" consistently

### Non-Functional Requirements

- [ ] Zero breaking changes to framework structure
- [ ] Git history preserved for renamed directories
- [ ] All internal links remain functional
- [ ] Clear communication of terminology changes
- [ ] Professional, industry-aligned language

---

## Design

### Architecture Impact

**Directories renamed:**
```
Before:                          After:
project-framework/              project-framework/
├── framework/                  ├── framework/
├── project-hello-world/   →    ├── examples/
│   └── ...                     │   └── hello-world/
└── project-templates/     →    └── templates/
    ├── minimal/                    ├── minimal/
    ├── light/                      ├── light/
    └── standard/                   └── standard/
```

**Files requiring updates:**

**Tier 1: Critical (blocks FEAT-025):**
- `README.md` (root)
- `CLAUDE.md` (root)
- `QUICK-START.md`
- `framework/CLAUDE.md`
- `examples/hello-world/CLAUDE.md`
- `templates/*/NEW-PROJECT-CHECKLIST.md`
- `framework/docs/REPOSITORY-STRUCTURE.md` - Repository structure reference doc
- `framework/docs/PROJECT-STRUCTURE-STANDARD.md` - Project structure reference doc

**Tier 2: High priority (immediate work items):**
- `DECISION-050-framework-distribution-model.md`
- `DECISION-036-template-access-strategy.md`
- `FEAT-025-manual-setup-validation.md`
- `FEAT-037-project-config-file.md`

**Tier 3: Remaining work items (23 files):**
- Can be updated in batch or gradually as touched

---

## Implementation Approach

### Phase 0: Pre-Change Audit (Comprehensive)

**Before any changes, run complete audit:**

```powershell
# Audit all references to paths and terminology
grep -r "project-hello-world" . --include="*.md" > audit-hello-world.txt
grep -r "project-templates" . --include="*.md" > audit-templates.txt
grep -r "monorepo" . --include="*.md" > audit-monorepo.txt

# Review audit files, categorize each finding
# Critical / High / Medium / Low / Skip
```

**Deliverable:** Audit report with categorized findings and explicit "update" or "skip" decisions for each file.

---

### Phase 1: Research Documentation (Completed ✓)

**Status:** Complete (2026-01-13)

**Deliverable:** `framework/thoughts/research/package-ecosystem-terminology-patterns.md`
- Documents npm, pip, bundler structure patterns
- Provides industry terminology mapping
- Establishes recommendations with rationale

---

## Path-by-Path Migration Strategy

**Key principle:** Migrate one path at a time. Rename → Fix all docs → Validate → User review → Next path.

**Why this approach:**
- Focused scope (only thinking about ONE path at a time)
- Immediate validation (grep confirms zero old references after each step)
- Incremental progress (each step independently valuable)
- Easier rollback (only undo ONE change if issues arise)
- Natural validation gates (binary pass/fail per path)

---

### Phase 2: Migrate project-hello-world → examples/hello-world/

**Step 2.1: Rename directory**

```powershell
# Create examples/ directory
mkdir examples

# Move project-hello-world to examples/hello-world
git mv project-hello-world examples/hello-world

# Commit immediately (preserve history)
git commit -m "refactor(REFACTOR-052): Rename project-hello-world → examples/hello-world

- Aligns with npm, pip, bundler conventions (universal examples/ folder)
- Git history preserved with git mv
- Part of REFACTOR-052: Industry-standard repository structure"
```

**Validation checkpoint:**
- [ ] Git history preserved: `git log --follow examples/hello-world/README.md`
- [ ] Directory exists: `ls examples/hello-world`
- [ ] Old directory gone: `ls project-hello-world` (should error)

**STOP - Validate before proceeding**

---

**Step 2.2: Find all references**

```powershell
# Find all markdown files referencing old path
grep -r "project-hello-world" . --include="*.md"

# Save to file for tracking
grep -r "project-hello-world" . --include="*.md" > fix-hello-world-refs.txt

# Review list, identify:
# - Files to update (active docs, navigation)
# - Files to skip (historical archives)
```

**Deliverable:** List of files to update with old path references

---

**Step 2.3: Fix ALL references**

Update every file in the list (except explicitly skipped historical files):
- [ ] README.md (root)
- [ ] CLAUDE.md (root)
- [ ] QUICK-START.md
- [ ] framework/CLAUDE.md
- [ ] framework/docs/REPOSITORY-STRUCTURE.md
- [ ] framework/docs/PROJECT-STRUCTURE-STANDARD.md
- [ ] All work items referencing the path
- [ ] All templates referencing the path
- [ ] Any other files found in grep

**Change:**
- `project-hello-world/` → `examples/hello-world/`

```powershell
# Commit all doc updates together
git commit -m "docs(REFACTOR-052): Update all project-hello-world path references

- Updated navigation docs (README, CLAUDE, QUICK-START)
- Updated structure specifications
- Updated work items and templates
- All references now point to examples/hello-world/"
```

---

**Step 2.4: Validate - Zero old references**

```powershell
# Grep for old path - should return ZERO hits (except historical archives)
grep -r "project-hello-world" . --include="*.md"

# Exclude historical archives from check
grep -r "project-hello-world" . --include="*.md" --exclude-dir="history"
```

**Expected result:** Zero matches (or only intentional matches in skip list)

**If validation fails:** Fix missed references, commit, re-validate

**Validation checklist:**
- [ ] Grep returns zero old path references (excluding historical)
- [ ] Spot check 3-5 updated files - links work
- [ ] `examples/hello-world/CLAUDE.md` has correct relative paths
- [ ] Navigation from root README works

**STOP - User review before proceeding to next path**

---

### Phase 3: Migrate project-templates → templates/

**Step 3.1: Rename directory**

```powershell
# Move project-templates to templates
git mv project-templates templates

# Commit immediately (preserve history)
git commit -m "refactor(REFACTOR-052): Rename project-templates → templates

- Removes redundant 'project-' prefix
- Aligns with industry conventions (descriptive directory names)
- Git history preserved with git mv
- Part of REFACTOR-052: Industry-standard repository structure"
```

**Validation checkpoint:**
- [ ] Git history preserved: `git log --follow templates/standard/NEW-PROJECT-CHECKLIST.md`
- [ ] Directory exists: `ls templates`
- [ ] Old directory gone: `ls project-templates` (should error)

**STOP - Validate before proceeding**

---

**Step 3.2: Find all references**

```powershell
# Find all markdown files referencing old path
grep -r "project-templates" . --include="*.md"

# Save to file for tracking
grep -r "project-templates" . --include="*.md" > fix-templates-refs.txt

# Review list, identify files to update vs skip
```

**Deliverable:** List of files to update

---

**Step 3.3: Fix ALL references**

Update every file in the list:
- [ ] README.md (root)
- [ ] CLAUDE.md (root)
- [ ] QUICK-START.md
- [ ] framework/CLAUDE.md
- [ ] framework/docs/REPOSITORY-STRUCTURE.md
- [ ] framework/docs/PROJECT-STRUCTURE-STANDARD.md
- [ ] All work items referencing the path
- [ ] Template files themselves (if they reference their own path)

**Change:**
- `project-templates/` → `templates/`

```powershell
# Commit all doc updates
git commit -m "docs(REFACTOR-052): Update all project-templates path references

- Updated navigation docs
- Updated structure specifications
- Updated work items
- All references now point to templates/"
```

---

**Step 3.4: Validate - Zero old references**

```powershell
# Grep for old path - should return ZERO hits (except historical)
grep -r "project-templates" . --include="*.md" --exclude-dir="history"
```

**Expected result:** Zero matches (or only intentional matches in skip list)

**Validation checklist:**
- [ ] Grep returns zero old path references (excluding historical)
- [ ] Spot check 3-5 updated files - links work
- [ ] Template checklists reference correct paths
- [ ] Navigation from root README works

**STOP - User review before proceeding to terminology**

---

### Phase 4: Update Terminology (monorepo → framework source repository)

**Step 4.1: Find all references**

```powershell
# Find all markdown files with "monorepo"
grep -r "monorepo" . --include="*.md"

# Save to file
grep -r "monorepo" . --include="*.md" > fix-monorepo-refs.txt

# Review list, create explicit skip list:
# - Historical archives (intentionally preserved)
# - Research documents discussing old structure
# - This work item itself (REFACTOR-052)
```

**Deliverable:** List of files to update + explicit skip list

---

**Step 4.2: Fix ALL references**

Update every file NOT in skip list:
- [ ] README.md (root)
- [ ] CLAUDE.md (root)
- [ ] framework/docs/REPOSITORY-STRUCTURE.md
- [ ] framework/docs/PROJECT-STRUCTURE-STANDARD.md
- [ ] All work items using the term

**Change:**
- "monorepo" → "framework source repository"
- "THE framework" → "framework source" or "canonical framework source"
- "project copy" → "installed framework" or "local framework copy"
- "framework-as-dependency" → "bundled dependency model"

```powershell
# Commit terminology updates
git commit -m "docs(REFACTOR-052): Replace 'monorepo' with 'framework source repository'

- Updated terminology to align with industry standards
- 'framework source repository' reflects new bundled dependency model
- See: framework/thoughts/research/package-ecosystem-terminology-patterns.md"
```

---

**Step 4.3: Validate - Only expected references remain**

```powershell
# Grep for "monorepo" - should only find skip list items
grep -r "monorepo" . --include="*.md" --exclude-dir="history"
```

**Expected result:** Only matches in explicitly skipped files (research doc, this work item)

**Validation checklist:**
- [ ] Grep returns only expected matches (skip list)
- [ ] REPOSITORY-STRUCTURE.md uses new terminology consistently
- [ ] PROJECT-STRUCTURE-STANDARD.md uses new terminology
- [ ] Navigation docs (README, CLAUDE) use new terminology

**STOP - User review before final steps**

---

### Phase 5: Update Structure Documentation

**Comprehensive review and final updates:**

At this point, paths and terminology have been updated throughout. Phase 5 focuses on ensuring structure documentation is completely accurate and internally consistent.

**Step 5.1: Review REPOSITORY-STRUCTURE.md**

Already updated in previous phases, but verify:
- [ ] All path references correct
- [ ] Terminology consistent
- [ ] Structure diagrams accurate
- [ ] Cross-references work

**Step 5.2: Review PROJECT-STRUCTURE-STANDARD.md**

Already updated in previous phases, but verify:
- [ ] References to REPOSITORY-STRUCTURE.md accurate
- [ ] Terminology consistent
- [ ] No stale path references

**Step 5.3: Spot-check navigation**
- [ ] Test navigation from README → structure docs
- [ ] Test cross-references between docs
- [ ] Verify terminology consistent across all docs

```powershell
# Commit any final doc adjustments
git commit -m "docs(REFACTOR-052): Final structure documentation review

- Verified all cross-references work
- Ensured terminology consistency
- Structure specifications fully updated"
```

---

### Phase 6: Final Validation & CHANGELOG

**Add to `framework/CHANGELOG.md`:**

```markdown
## [Unreleased]

### Changed
- **REFACTOR-052: Adopt Industry-Standard Repository Structure**
  - Renamed `project-hello-world/` → `examples/hello-world/` (aligns with npm/pip/bundler)
  - Renamed `project-templates/` → `templates/` (removes redundant prefix)
  - Updated terminology: "framework source repository" (not "monorepo")
  - Updated all core documentation with new paths and industry-standard terms
  - See research: [package-ecosystem-terminology-patterns.md](thoughts/research/package-ecosystem-terminology-patterns.md)
  - **Migration Note:** If referencing old paths, update to new structure
```

---

### Phase 6: Batch Update Remaining Work Items (Optional)

**Defer to future work or handle incrementally:**

The grep search found 23 work items referencing old paths. These can be:
- **Option A:** Updated in batch after Phase 5
- **Option B:** Updated gradually as each work item is touched
- **Option C:** Create follow-up work item: "Update work item path references"

**Recommendation:** Option B (incremental) - less overhead, happens naturally

---

## Success Metrics

**How do we know this work is complete?**

1. ✅ Directories renamed with git history preserved
2. ✅ All Tier 1 documentation updated and functional
3. ✅ All Tier 2 work items updated
4. ✅ CHANGELOG.md entry added
5. ✅ No broken links in core navigation
6. ✅ Terminology consistent across critical docs
7. ✅ FEAT-025 unblocked (can reference correct paths)
8. ✅ Git repository structure matches industry standards

**Validation:**
- Clone fresh repo, verify structure is intuitive
- Check all links in README.md, CLAUDE.md work
- Verify examples/ and templates/ are recognizable
- Read documentation as new user - feels professional?

---

## Dependencies

**Requires:**
- Research document completed ✓ (package-ecosystem-terminology-patterns.md)
- Git repository with commit access
- No active branches depending on old paths

**Blocks:**
- **FEAT-025** (Manual Setup Validation) - References outdated paths
- Any template packaging work
- Any automation depending on directory structure

**Related:**
- **DECISION-050** - Framework distribution model (this implements structural aspect)
- **FEAT-037** - Project config file (will use new paths)

---

## Lessons from FEAT-026

**What went wrong in FEAT-026:**
1. **Missed path references** - Many files had outdated paths after migration
2. **Validation was insufficient** - Spot checks missed systematic issues
3. **Duplication and contradictions** - Docs repeated info, sometimes conflicting
4. **No comprehensive audit** - Grep searches done ad-hoc, not systematically
5. **Follow-up bugs** - Created 6+ P1 bugs and 8+ P2 tech debt items

**Key insight:** Structural changes create cascading updates that are hard to predict without systematic validation.

---

## Mitigation Strategy (Learning from FEAT-026)

### Strategy 1: Comprehensive Pre-Change Audit

**Before making any changes:**

1. **Identify all files referencing old paths/terminology:**
   ```powershell
   # Exhaustive grep searches
   grep -r "project-hello-world" . --include="*.md" > audit-hello-world.txt
   grep -r "project-templates" . --include="*.md" > audit-templates.txt
   grep -r "monorepo" . --include="*.md" > audit-monorepo.txt
   ```

2. **Categorize findings:**
   - Critical (navigation docs, structure specs)
   - High (active work items, templates)
   - Medium (historical docs, completed work)
   - Low (old session history - archive only)

3. **Create comprehensive update checklist:**
   - Every file gets explicit "update" or "skip" decision
   - Document why files are skipped
   - No assumptions about what needs updating

---

### Strategy 2: Staged Implementation with Validation Gates

**Don't do everything at once. Use validation gates:**

**Gate 1: Directory Rename Only**
- Rename directories
- Commit immediately
- Verify git history preserved
- **STOP - Validate before proceeding**

**Gate 2: Tier 1 Critical Docs**
- Update navigation and structure docs
- Commit
- **Validation:** Fresh clone, test all links, verify navigation works
- **STOP - Get user review**

**Gate 3: Tier 2 Work Items**
- Update active work items
- Commit
- **Validation:** Check all work items render correctly
- **STOP - Get user review**

**Gate 4: Batch Updates**
- Update remaining files
- Commit
- **Final validation**

**Key principle:** Small commits, validate each stage, user review gates

---

### Strategy 3: Automated Path Validation

**Create validation script:**

```powershell
# validate-paths.ps1
# Check for broken path references

$errors = @()

# Check for old path references
$oldPaths = @(
    "project-hello-world",
    "project-templates",
    "project-framework/"
)

foreach ($path in $oldPaths) {
    $results = grep -r $path . --include="*.md" 2>$null
    if ($results) {
        $errors += "Found old path '$path' in:"
        $errors += $results
    }
}

# Check for old terminology
$oldTerms = @(
    "monorepo"
)

foreach ($term in $oldTerms) {
    $results = grep -r $term . --include="*.md" 2>$null
    if ($results) {
        # Filter out: this file, research doc (intentional), historical docs
        # Report remaining
    }
}

if ($errors.Count -gt 0) {
    Write-Host "Validation FAILED - Found issues:"
    $errors | ForEach-Object { Write-Host $_ }
    exit 1
} else {
    Write-Host "Validation PASSED - No old paths found"
    exit 0
}
```

**Run this after each phase:**
- Before committing
- After user review
- Before marking work item complete

---

### Strategy 4: Explicit "Won't Update" List

**Document files we're NOT updating and why:**

**Historical files (leave as-is):**
- `framework/thoughts/history/sessions/*.md` - Historical record
- `framework/thoughts/history/releases/v3.0.0/*.md` - Archived release
- Reason: Historical accuracy, not referenced by users

**Intentional references (leave as-is):**
- `package-ecosystem-terminology-patterns.md` - Discusses old structure
- `REFACTOR-052` work item itself - References old/new paths
- Reason: Context requires old terminology

**To be updated later (defer):**
- Remaining 15-20 work items (Tier 3) - Update as touched
- Reason: Low priority, not blocking, can be incremental

**This prevents "did we forget this?" uncertainty**

---

### Strategy 5: Validation Checklist (Run Before Completion)

**Manual validation (15 min):**
- [ ] Clone repo fresh in new location
- [ ] Read root README.md - does structure make sense?
- [ ] Read root CLAUDE.md - can AI navigate?
- [ ] Check examples/hello-world exists and is accessible
- [ ] Check templates/ exists and is accessible
- [ ] Read REPOSITORY-STRUCTURE.md - accurate?
- [ ] Read PROJECT-STRUCTURE-STANDARD.md - accurate?
- [ ] Click 5 random links in docs - all work?
- [ ] Run grep for "project-hello-world" - only expected hits?
- [ ] Run grep for "project-templates" - only expected hits?
- [ ] Run grep for "monorepo" - only expected hits?

**Automated validation:**
- [ ] Run validate-paths.ps1 script
- [ ] All checks pass

**User acceptance:**
- [ ] User reviews structure in fresh clone
- [ ] User confirms navigation is clear
- [ ] User approves terminology changes

---

## Risks and Mitigations

### Risk 1: Repeating FEAT-026 Problems
**Risk:** Miss path references, create follow-up bugs

**Likelihood:** HIGH (happened before, lots of files)

**Mitigation:**
- **Comprehensive pre-change audit** (Strategy 1)
- **Validation gates between phases** (Strategy 2)
- **Automated validation script** (Strategy 3)
- **Explicit won't-update list** (Strategy 4)
- **Thorough final validation** (Strategy 5)

---

### Risk 2: Breaking External References
**Risk:** External documentation or tools reference old paths

**Likelihood:** Low (framework not publicly released)

**Mitigation:**
- Complete before public release
- Add migration note in CHANGELOG
- Update any external docs immediately

---

### Risk 3: User Confusion During Transition
**Risk:** User pulls changes mid-refactoring, sees inconsistent state

**Likelihood:** Medium (if done in main branch)

**Mitigation:**
- Consider using feature branch
- Complete all Tier 1 changes before pushing
- Clear communication about changes in progress

---

### Risk 4: Git History Loss
**Risk:** Using wrong command loses file history

**Likelihood:** Low (using `git mv`)

**Mitigation:**
- Use `git mv` (preserves history)
- Test with `git log --follow` after rename
- Commit immediately after rename

---

## Implementation Checklist

### Phase 0: Pre-Change Audit
- [ ] Run grep audit for "project-hello-world"
- [ ] Run grep audit for "project-templates"
- [ ] Run grep audit for "monorepo"
- [ ] Categorize all findings (Critical/High/Medium/Low/Skip)
- [ ] Create explicit "update" or "skip" decisions for each file
- [ ] Document skip list with rationale

### Phase 1: Research (Complete ✓)
- [x] Research npm, pip, bundler patterns
- [x] Document findings in research/
- [x] Establish recommendations

### Phase 2: Migrate project-hello-world → examples/hello-world/

**Step 2.1: Rename**
- [ ] Create examples/ directory
- [ ] `git mv project-hello-world examples/hello-world`
- [ ] Commit immediately
- [ ] Verify git history preserved
- [ ] **STOP - Validate**

**Step 2.2: Find references**
- [ ] Grep for "project-hello-world" references
- [ ] Save to fix-hello-world-refs.txt
- [ ] Review and categorize (update vs skip)

**Step 2.3: Fix ALL references**
- [ ] Update all files found in grep (except skip list)
- [ ] Commit doc updates
- [ ] **Validate:** Grep returns zero old references (excluding historical)
- [ ] Spot check 3-5 files, test links
- [ ] **STOP - User review**

### Phase 3: Migrate project-templates → templates/

**Step 3.1: Rename**
- [ ] `git mv project-templates templates`
- [ ] Commit immediately
- [ ] Verify git history preserved
- [ ] **STOP - Validate**

**Step 3.2: Find references**
- [ ] Grep for "project-templates" references
- [ ] Save to fix-templates-refs.txt
- [ ] Review and categorize

**Step 3.3: Fix ALL references**
- [ ] Update all files found in grep (except skip list)
- [ ] Commit doc updates
- [ ] **Validate:** Grep returns zero old references (excluding historical)
- [ ] Spot check 3-5 files, test links
- [ ] **STOP - User review**

### Phase 4: Update Terminology

**Step 4.1: Find references**
- [ ] Grep for "monorepo" references
- [ ] Save to fix-monorepo-refs.txt
- [ ] Create explicit skip list (historical, research docs, this work item)

**Step 4.2: Fix ALL references**
- [ ] Update all files NOT in skip list
- [ ] Commit terminology updates
- [ ] **Validate:** Grep returns only skip list matches
- [ ] Review terminology consistency
- [ ] **STOP - User review**

### Phase 5: Structure Documentation Review
- [ ] Review REPOSITORY-STRUCTURE.md (verify accuracy)
- [ ] Review PROJECT-STRUCTURE-STANDARD.md (verify accuracy)
- [ ] Test navigation and cross-references
- [ ] Commit any final adjustments

### Phase 6: CHANGELOG & Final Validation
- [ ] Add CHANGELOG.md entry
- [ ] Include migration note

**Final validation checklist:**
- [ ] Clone repo fresh in new location
- [ ] Read root README.md - structure makes sense?
- [ ] Read root CLAUDE.md - AI can navigate?
- [ ] Check examples/hello-world accessible
- [ ] Check templates/ accessible
- [ ] Click 5 random links - all work?
- [ ] Run final grep validation (zero old references except skip list)
- [ ] User acceptance test

### Phase 7: Complete
- [ ] Final commit
- [ ] Mark work item complete
- [ ] Update DECISION-050 reference list

---

## Future Work

**Remaining work items (23 files):**
- Can be updated incrementally as touched
- Or create follow-up work item for batch update
- Not blocking - low priority

**Optional enhancements:**
- Add `dist/` folder for packaged templates (future)
- Consider `.github/` workflows referencing new paths (if applicable)

---

## Notes

**Priority:** High
- Blocks FEAT-025 (manual setup validation)
- Critical for professional appearance
- Should complete before further development

**Why this matters:**
Using industry-standard structure and terminology makes the framework immediately recognizable to developers from npm, pip, or bundler ecosystems. Reduces cognitive load for new users.

**Inspiration:**
- npm: `examples/` for demonstration projects
- pip: `src/` layout for source, examples/ for demos
- bundler: Standard gem structure with examples/

**Research Reference:**
See [package-ecosystem-terminology-patterns.md](../../research/package-ecosystem-terminology-patterns.md) for complete industry analysis and recommendations.

**Discovered During:**
Discussion about DECISION-050 framework distribution model and monorepo terminology (2026-01-13 session).

---

**Last Updated:** 2026-01-13

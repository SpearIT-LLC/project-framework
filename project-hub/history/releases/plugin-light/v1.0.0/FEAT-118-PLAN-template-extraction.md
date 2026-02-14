# Implementation Plan: Template Extraction for `/new` Command

**Parent Work Item:** FEAT-118 (Claude Code Plugin)
**Created:** 2026-02-11
**Status:** Ready to implement

---

## Context

The `/spearit-framework-light:new` command file ([commands/new.md](../../../plugins/spearit-framework-light/commands/new.md)) is 544 lines, making it difficult to maintain. Large template definitions (~180 lines) should be extracted into separate files.

**Related Session History:** [2026-02-11 Afternoon Session](../../history/sessions/2026-02-11-SESSION-HISTORY.md#afternoon-session-plugin-command-testing-and-refactoring-planning)

---

## Objectives

1. ✅ Extract work item templates (FEAT, BUG, CHORE) into separate template files
2. ✅ Reduce `new.md` from 544 lines to ~200 lines
3. ✅ Verify custom `templates/` folder copies to plugin cache
4. ✅ Implement fallback if templates don't copy
5. ✅ Document pattern for potential framework adoption

---

## Current State

**File:** `plugins/spearit-framework-light/commands/new.md`
- **Total lines:** 544
- **Templates:** ~180 lines (FEAT, BUG, CHORE)
- **Examples:** ~178 lines (conversational examples + full example)
- **Core logic:** ~186 lines (execution flow, instructions)

**Structure:**
```
commands/new.md (544 lines)
├── Role & Mindset (20 lines)
├── Usage (10 lines)
├── Core Information (10 lines)
├── Execution Flow (370 lines)
│   ├── Step 1: Parse Command (20 lines)
│   ├── Step 2: Engage Conversationally (110 lines - examples)
│   ├── Step 3: Get Next ID (10 lines)
│   ├── Step 4: Propose Structure (30 lines)
│   ├── Step 5: Generate Work Item (180 lines - TEMPLATES)
│   ├── Step 6-8: Create, Git, Confirm (30 lines)
├── Graceful Degradation (12 lines)
├── Performance Requirements (8 lines)
├── For AI Assistants (27 lines)
├── Example: Full FEAT Creation (68 lines)
└── Design Philosophy (3 lines)
```

---

## Proposed Structure

**After refactoring:**
```
plugins/spearit-framework-light/
├── commands/
│   └── new.md               (~200 lines - core logic)
├── templates/               (NEW)
│   ├── FEAT-template.md     (Detailed feature template)
│   ├── BUG-template.md      (Detailed bug template)
│   └── CHORE-template.md    (Simplified chore template)
└── ...
```

---

## Implementation Steps

### Step 1: Create Templates Folder

**Action:** Create `plugins/spearit-framework-light/templates/` directory

**Verification:**
```bash
ls -la plugins/spearit-framework-light/templates/
```

---

### Step 2: Extract FEAT Template

**Action:** Create `templates/FEAT-template.md`

**Content:** Extract from `new.md` lines 207-285 (FEAT Template section)

**Template structure:**
```markdown
# Feature: {Title}

**ID:** {TYPE-ID}
**Type:** Feature
**Priority:** {Priority}
**Created:** {Date}

---

## Summary

{2-3 sentence summary from discovery}

---

## Problem Statement

{Detailed problem from conversation}

**Context:**
{Why now? What's driving this?}

**Impact:**
{Who benefits? How much?}

---

## Requirements

{Functional requirements discovered}

**Must Have:**
- {Core requirement 1}
- {Core requirement 2}

**Out of Scope (for this version):**
- {Explicitly excluded item 1}
- {Explicitly excluded item 2}

---

## Proposed Solution

{High-level approach discussed}

**Technical Approach:**
{If discussed in discovery}

**Constraints:**
{Technical or business constraints}

---

## Acceptance Criteria

{Testable criteria from conversation}
- [ ] {Criterion 1}
- [ ] {Criterion 2}
- [ ] {Criterion 3}

---

## Implementation Notes

{Any technical details, dependencies, or considerations from discovery}

---

## Questions / Open Issues

{Unresolved items to address during implementation}

---

**Last Updated:** {Date}
**Status:** Backlog
```

---

### Step 3: Extract BUG Template

**Action:** Create `templates/BUG-template.md`

**Content:** Extract from `new.md` lines 287-350 (BUG Template section)

**Template structure:**
```markdown
# Bug: {Title}

**ID:** {TYPE-ID}
**Type:** Bug
**Priority:** {Based on severity/impact}
**Created:** {Date}

---

## Summary

{Brief description}

---

## Bug Description

**Observed Behavior:**
{What actually happens}

**Expected Behavior:**
{What should happen}

**Impact:**
- Severity: {Critical/High/Medium/Low}
- Users Affected: {Who/how many}
- Workaround: {If available}

---

## Reproduction Steps

{Clear steps to reproduce}
1. {Step 1}
2. {Step 2}
3. {Observe: incorrect behavior}

---

## Root Cause

{If identified during discovery, otherwise "To be determined"}

---

## Fix Criteria

- [ ] {Specific fix criterion 1}
- [ ] {Specific fix criterion 2}
- [ ] Regression tests added

---

## Notes

{Any additional context or observations}

---

**Last Updated:** {Date}
**Status:** Backlog
```

---

### Step 4: Extract CHORE Template

**Action:** Create `templates/CHORE-template.md`

**Content:** Extract from `new.md` lines 352-390 (CHORE Template section)

**Template structure:**
```markdown
# Chore: {Title}

**ID:** {TYPE-ID}
**Type:** Chore
**Priority:** {Priority}
**Created:** {Date}

---

## Summary

{What needs to be done}

---

## Scope

{Detailed scope from discovery}

---

## Completion Criteria

- [ ] {Criterion 1}
- [ ] {Criterion 2}

---

## Dependencies

{If any}

---

**Last Updated:** {Date}
**Status:** Backlog
```

---

### Step 5: Update new.md to Reference Templates

**Action:** Modify `commands/new.md`

**Changes:**

1. **Replace Step 5 content** (currently lines 203-390):

```markdown
### Step 5: Generate Detailed Work Item

**Templates Location:** `plugins/spearit-framework-light/templates/`

Use the appropriate template based on work item type:
- **FEAT:** Read `templates/FEAT-template.md`
- **BUG:** Read `templates/BUG-template.md`
- **CHORE:** Read `templates/CHORE-template.md`

**Process:**
1. Read the template file for the work item type
2. Replace all `{placeholders}` with information gathered during conversation:
   - `{Title}` - Original title from user
   - `{TYPE-ID}` - e.g., "FEAT-043"
   - `{Priority}` - High/Medium/Low (inferred from conversation)
   - `{Date}` - Current date (YYYY-MM-DD)
   - `{Summary}` - 2-3 sentence summary from discovery
   - `{Problem}` - Problem statement from conversation
   - etc.
3. Remove any sections that weren't discussed (e.g., if no constraints, remove "Constraints:" section)
4. Ensure all placeholder text is replaced with actual content from conversation
```

2. **Add template reading instruction** in "For AI Assistants" section:

```markdown
**Tools to use:**
- Glob: Find existing work items for ID assignment
- Read: Read template files from templates/ directory
- Write: Create work item file
- Bash: Git add file
- (NO AskUserQuestion - just converse naturally)
```

**Expected result:** `new.md` reduces from 544 lines to ~200 lines

---

### Step 6: Test Template Copying to Cache

**Action:** Verify that `templates/` folder copies to plugin cache during installation

**Testing procedure:**
```powershell
# 1. Update marketplace
.\tools\Publish-ToLocalMarketplace.ps1

# 2. Reinstall plugin
/plugin uninstall spearit-framework-light
/plugin install spearit-framework-light@dev-marketplace --scope local

# 3. Check cache directory
dir $env:USERPROFILE\.claude\plugins\cache\spearit-framework-light\
```

**Success criteria:**
- `templates/` folder exists in cache
- All three template files present
- Files readable by plugin commands

**If test passes:** ✅ Document pattern as successful
**If test fails:** ⚠️ Proceed to Step 7 (implement fallback)

---

### Step 7: Implement Fallback (If Needed)

**Action:** If `templates/` folder doesn't copy to cache, revert to inline templates

**Fallback approach:**
1. Keep extracted template files in repo (for documentation/reference)
2. Update `new.md` to include inline templates in AI instructions section
3. Use condensed template format (essential structure only)
4. Add comment: "Note: External templates not supported, using inline version"

**Condensed inline template example:**
```markdown
### Generate Work Item (Inline Template)

**FEAT:**
```
# Feature: {Title}
**ID:** {TYPE-ID} | **Type:** Feature | **Priority:** {Priority} | **Created:** {Date}

## Summary
{Summary from discovery}

## Problem Statement
{Problem} | **Context:** {Why now} | **Impact:** {Who benefits}

## Requirements
**Must Have:** {Requirements}
**Out of Scope:** {Exclusions}

## Acceptance Criteria
- [ ] {Criteria from conversation}

**Status:** Backlog
```
```

**Note:** Only implement fallback if Step 6 fails

---

## Testing Plan

### Functional Testing

**Test 1: Template file existence**
```bash
# Verify all templates created
ls plugins/spearit-framework-light/templates/
# Expected: FEAT-template.md, BUG-template.md, CHORE-template.md
```

**Test 2: Template content**
```bash
# Verify templates have placeholder variables
grep -E '\{[A-Za-z-]+\}' plugins/spearit-framework-light/templates/*.md
# Expected: Multiple matches showing {Title}, {TYPE-ID}, etc.
```

**Test 3: Command references templates**
```bash
# Verify new.md references template files
grep -i "templates/" plugins/spearit-framework-light/commands/new.md
# Expected: References to templates/ directory
```

### Integration Testing

**Test 4: Cache copying**
```powershell
# After reinstalling plugin, check cache
dir $env:USERPROFILE\.claude\plugins\cache\spearit-framework-light\templates\
# Expected: Templates folder with all files
```

**Test 5: Command execution** (Next session after implementation)
```
/spearit-framework-light:new
# Expected: Command reads templates, creates work item successfully
```

---

## Success Criteria

- [x] `templates/` folder created with 3 template files
- [x] Each template file contains complete work item structure
- [x] All placeholder variables documented and consistent
- [x] `new.md` updated to reference external templates
- [x] `new.md` reduced from 544 to ~200 lines
- [ ] Templates copy to plugin cache during installation
- [ ] Command successfully reads and uses templates
- [ ] Pattern documented for framework consideration

---

## Risks & Mitigation

| Risk | Impact | Mitigation |
|------|--------|------------|
| Templates don't copy to cache | High | Implement fallback (inline templates) |
| Template variables inconsistent | Medium | Document all variables, test substitution |
| Command can't find templates | High | Add error handling, fallback to inline |
| Breaking change for existing installs | Low | Plugin not published yet, safe to change |

---

## Rollback Plan

**If template extraction causes issues:**

1. **Immediate rollback:**
   ```bash
   git checkout HEAD -- plugins/spearit-framework-light/commands/new.md
   rm -rf plugins/spearit-framework-light/templates/
   ```

2. **Restore functionality:**
   ```powershell
   .\tools\Publish-ToLocalMarketplace.ps1
   /plugin marketplace update dev-marketplace
   # Restart VSCode
   ```

3. **Investigate issue:**
   - Check cache directory structure
   - Review debug logs for file access errors
   - Test with inline templates if external files unsupported

---

## Post-Implementation

### Documentation Updates

**If successful:**
1. Update [plugin-best-practices.md](../../research/plugin-best-practices.md) with "Template Extraction Pattern"
2. Add example to plugin README showing templates folder
3. Consider promoting pattern to full framework documentation

### Framework Adoption Consideration

**If pattern successful in plugin:**
- Propose adding `templates/` folder to framework structure
- Work item templates as separate files
- Document templates as separate files
- Easier customization for framework users

---

## Related Files

- **Command file:** [plugins/spearit-framework-light/commands/new.md](../../../plugins/spearit-framework-light/commands/new.md)
- **Parent work item:** [FEAT-118-claude-code-plugin.md](FEAT-118-claude-code-plugin.md)
- **Session history:** [2026-02-11-SESSION-HISTORY.md](../../history/sessions/2026-02-11-SESSION-HISTORY.md)
- **Standards research:** [plugin-anthropic-standards.md](../../research/plugin-anthropic-standards.md)

---

**Plan Status:** Ready to implement
**Estimated Effort:** 1-2 hours
**Next Action:** Create templates folder and extract FEAT template

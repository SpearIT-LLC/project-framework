# Feature: Work Item Numbering and Naming Standards

**ID:** FEAT-021
**Type:** Feature
**Priority:** Low
**Version Impact:** PATCH
**Created:** 2025-12-22

---

## Summary

Establish comprehensive standards for work item numbering and file naming, including:
- Hierarchical numbering system for sub-features (FEAT-020.1, FEAT-020.2)
- File naming conventions (uppercase abbreviated prefixes)
- Number exhaustion handling (what happens at FEAT-999)
- Template self-documentation (naming instructions in templates)

---

## Problem Statement

**What problems does this solve?**

**Problem 1: No hierarchical numbering system**
- Work items use flat numbering (FEAT-001, FEAT-002)
- No standard way to indicate parent-child relationships
- Test scenarios and sub-features appear as independent items
- Hard to track scope and dependencies

**Problem 2: Inconsistent file naming**
- Some files use `feature-NNN-description.md` (lowercase)
- Others use `FEAT-NNN-description.md` (uppercase)
- No documented standard, causes confusion
- Files in same directory use different conventions

**Problem 3: No number exhaustion plan**
- What happens when we reach FEAT-999?
- No documented strategy for numbering beyond 3 digits
- Creates uncertainty for long-term projects

**Problem 4: Templates don't specify naming**
- Templates say "ID: FEAT-NNN" but don't specify filename
- Contributors must guess or find examples
- Leads to inconsistent file naming

**Problem 5: Work folder limits**
- How are 'doing' items affected by sub-features?
- Does a sub-feature go in the doing folder?
- Should the .limit file only count the top level number?
- e.g. 021, 021.1 and 021.2 are all considered the same item for work limit?

**Examples of current inconsistency:**
- `feature-004-visual-diagrams.md` through `feature-019-release-checklist.md` (lowercase)
- `FEAT-020-MIGRATION-MATRIX.md`, `FEAT-020-TESTING-PLAN.md` (uppercase)
- `FEAT-021-hierarchical-work-item-numbering.md` (uppercase)

**Who is affected?**

- AI collaborators creating work items (which convention to follow?)
- Human developers navigating work item files (confusing to find)
- Project managers tracking feature scope (can't see hierarchy)
- Framework users adopting this system (no clear guidance)

**Current workaround (if any):**

Manual cross-references, descriptive names, and guessing based on recent examples. Not standardized.

---

## Requirements

### Functional Requirements - Hierarchical Numbering

- [ ] Define standard numbering convention for hierarchical work items
- [ ] Support parent.child notation (e.g., FEAT-020.1, FEAT-020.2.1)
- [ ] Support multiple levels of nesting (at least 3 levels)
- [ ] Maintain backward compatibility with existing flat-numbered items
- [ ] Work with all work item types (FEAT, BUGFIX, BLOCKER, etc.)

### Functional Requirements - File Naming

- [ ] Define single standard file naming convention
- [ ] Choose between lowercase/uppercase, full-word/abbreviated
- [ ] Apply consistently across all work item types
- [ ] Make templates self-documenting (include naming in template)

### Functional Requirements - Number Exhaustion

- [ ] Define what happens at FEAT-999
- [ ] Provide clear guidance for numbering beyond 999
- [ ] Support automatic continuation (e.g., FEAT-1000, FEAT-1001)
- [ ] Document in templates and workflow guide

### Functional Requirements - WIP Limits with Hierarchical Numbering

- [ ] Define how WIP limits count hierarchical items
- [ ] Clarify if FEAT-021, FEAT-021.1, FEAT-021.2 count as 1 item or 3 items
- [ ] Document where sub-features are stored (doing/ folder structure)
- [ ] Update workflow-guide.md with WIP limit counting rules

### Documentation Requirements

- [ ] Update all templates in `project-hub/framework/templates/`
  - [ ] FEATURE-TEMPLATE.md
  - [ ] BUGFIX-TEMPLATE.md
  - [ ] BLOCKER-TEMPLATE.md
  - [ ] FEASIBILITY-TEMPLATE.md
  - [ ] RESEARCH-TEMPLATE.md
  - [ ] TEST-SCENARIO-TEMPLATE.md (if exists, or create)
- [ ] Update collaboration/workflow-guide.md with numbering conventions
- [ ] Add numbering examples to CLAUDE.md or CLAUDE-QUICK-REFERENCE.md
- [ ] Update INDEX.md with numbering convention reference

### Examples to Document

- [ ] Parent feature with sub-features
- [ ] Test scenarios under a parent feature
- [ ] Multi-level nesting (feature → sub-feature → specific test)
- [ ] When to use sub-numbering vs separate feature

---

## Proposed Approach

### Part 1: Hierarchical Numbering Convention

**Format:** `[TYPE]-[PARENT].[CHILD].[GRANDCHILD]`

**Examples:**
- `FEAT-020` - Parent feature (collaboration documentation)
- `FEAT-020.1` - First sub-feature (user login test scenario)
- `FEAT-020.2` - Second sub-feature (shopping cart test scenario)
- `FEAT-020.2.1` - Grandchild (specific test case under shopping cart)
- `BUGFIX-015.1` - Bug fix sub-task

**Maximum Depth:** 3 levels (parent.child.grandchild)

**Rationale:** If you need more than 3 levels, the parent is too large and should be broken down.

---

### Part 2: File Naming Convention

**Standard:** Uppercase abbreviated type prefix matching ID field

**Format:** `[TYPE]-[NUMBER]-[brief-description].md`

**Examples:**
- `FEAT-021-work-item-numbering.md`
- `BUGFIX-042-login-validation.md`
- `BLOCKER-003-database-connection.md`
- `RESEARCH-007-technology-evaluation.md`
- `FEAT-020.1-user-login-test.md` (hierarchical)

**Rationale:**
- **Uppercase:** Matches how we reference items in text and commit messages
- **Abbreviated:** Shorter, cleaner, industry standard (JIRA, GitHub use PROJ-123)
- **Consistent with ID:** File `FEAT-021-...md` contains `**ID:** FEAT-021`
- **Easy to scan:** Uppercase stands out in file listings

**Migration Strategy for Existing Files:**
- Existing lowercase files (`feature-004-...`) remain valid
- New convention applies to all new work items going forward
- Optional: Rename old files in a separate cleanup task (not required)
- Document both conventions in workflow-guide.md during transition

---

### Part 3: Number Exhaustion Handling

**At FEAT-999, automatically continue to FEAT-1000**

**Format:** No zero-padding beyond initial NNN format

**Examples:**
- `FEAT-001` through `FEAT-999` (3 digits, zero-padded)
- `FEAT-1000`, `FEAT-1001`, ... `FEAT-9999` (4 digits, no padding)
- `FEAT-10000`, `FEAT-10001`, ... (5 digits, no padding)

**File Naming Examples:**
- `FEAT-999-last-three-digit.md`
- `FEAT-1000-first-four-digit.md`
- `FEAT-1001-next-item.md`

**Rationale:**
- Simple, no special handling needed
- Natural continuation of numbering sequence
- Extremely unlikely to reach 10,000 features in a single project
- If you do reach 10k features, numbering is the least of your problems!

**Template Guidance:**
```markdown
<!--
NUMBER FORMAT:
  - Use zero-padded 3-digit numbers: FEAT-001, FEAT-002, ... FEAT-999
  - After FEAT-999, continue naturally: FEAT-1000, FEAT-1001, etc.
  - No special action needed at 999, just increment normally
-->
```

### When to Use Hierarchical Numbering

**Use sub-numbering when:**
- Sub-task is tightly coupled to parent feature
- Sub-task only makes sense in context of parent
- Sub-task is temporary (e.g., test scenario)
- Sub-task is part of a larger breakdown

**Use separate numbering when:**
- Work item can stand alone
- Work item might be reused or referenced independently
- Work item spans multiple parent features
- Work item is a distinct user-facing feature

### Part 4: WIP Limits with Hierarchical Numbering

**Rule: Count only the parent feature toward WIP limit**

**Rationale:**
- FEAT-021, FEAT-021.1, and FEAT-021.2 all count as **1 item** toward WIP limit
- Parent and all children are considered a single logical unit of work
- You're working on one feature that happens to have sub-tasks
- Sub-features don't exist independently from parent

**Storage Location:**
- **Parent feature** goes in `work/doing/` when actively being worked
- **All sub-features** also go in `work/doing/` alongside parent
- When parent completes, move parent AND all children to `work/done/` together

**Examples:**

**Scenario 1: Starting work on FEAT-021 with sub-features**
```
work/doing/
  ├── FEAT-021-work-item-numbering.md       (parent)
  ├── FEAT-021.1-hierarchical-numbering.md  (child)
  └── FEAT-021.2-file-naming-convention.md  (child)

WIP count: 1 (only the parent counts)
```

**Scenario 2: Checking WIP limit before starting new feature**
```bash
# Check WIP limit
cat project-hub/project/work/doing/.limit
# Output: 2

# Count only top-level items (no dots in number)
ls project-hub/project/work/doing/*.md | grep -v '\.' | wc -l
# Output: 1 (only FEAT-021)

# Can start new feature? Yes (1 < 2)
```

**Scenario 3: Completing FEAT-021**
```bash
# Move parent and all children together
mv work/doing/FEAT-021*.md work/done/

# Result:
work/done/
  ├── FEAT-021-work-item-numbering.md
  ├── FEAT-021.1-hierarchical-numbering.md
  └── FEAT-021.2-file-naming-convention.md
```

**WIP Limit Counting Script (for workflow validation):**
```bash
#!/bin/bash
# Count WIP items (top-level only)
# Counts FEAT-021 but NOT FEAT-021.1, FEAT-021.2

cd project-hub/project/work/doing/

# Count files that match [TYPE]-[NNN]-*.md (no dot after number)
count=$(ls *.md 2>/dev/null | grep -E '^[A-Z]+-[0-9]{3,}-' | grep -v '\.' | wc -l)

limit=$(cat .limit 2>/dev/null || echo "2")

echo "WIP: $count / $limit"

if [ $count -ge $limit ]; then
  echo "❌ WIP limit reached! Complete current work before starting new features."
  exit 1
else
  echo "✅ Can start new work item ($((limit - count)) slots available)"
  exit 0
fi
```

---

### Part 5: Template Updates

**Add to TOP of each template (FEATURE, BUGFIX, BLOCKER, etc.):**

```markdown
<!--
==============================================================================
WORK ITEM NAMING AND NUMBERING GUIDE
==============================================================================

FILENAME CONVENTION:
  Save this file as: [TYPE]-[NUMBER]-[brief-description].md

  Examples:
    - FEAT-021-work-item-numbering.md
    - BUGFIX-042-login-validation.md
    - BLOCKER-003-database-connection.md
    - FEAT-020.1-test-scenario.md (hierarchical sub-feature)

  Use UPPERCASE abbreviated type prefix matching the ID field below.

NUMBERING CONVENTION:
  - Use zero-padded 3-digit numbers: FEAT-001, FEAT-002, ... FEAT-999
  - After FEAT-999, continue naturally: FEAT-1000, FEAT-1001, etc.
  - For sub-features, use dot notation: FEAT-020.1, FEAT-020.2, FEAT-020.2.1
  - Maximum 3 levels: parent.child.grandchild

WHEN TO USE HIERARCHICAL NUMBERING:
  - Use FEAT-XXX.Y when work is tightly coupled to parent feature
  - Use separate FEAT-YYY when work can stand alone independently

  See workflow-guide.md for detailed guidelines.

==============================================================================
-->

# Feature: [Feature Name]

**ID:** FEAT-NNN (Next available number - check existing items)
```

**Add AFTER front matter in each template:**

```markdown
## Hierarchical Numbering (If Applicable)

**Parent Feature:** [e.g., FEAT-020] (only if this is a sub-feature)

**Sub-Features:** (only if this work item has children)
- [ ] [ID].1 - [Description]
- [ ] [ID].2 - [Description]
- [ ] [ID].3 - [Description]

**Note:** Leave blank if not using hierarchical numbering.
```

---

## Acceptance Criteria

### Template Updates
- [ ] All work item templates include hierarchical numbering section
- [ ] Templates provide clear guidance on when to use sub-numbering
- [ ] Templates include examples

### Documentation Updates
- [ ] workflow-guide.md has complete numbering convention section
- [ ] CLAUDE.md or CLAUDE-QUICK-REFERENCE.md references numbering system
- [ ] Examples show both flat and hierarchical numbering
- [ ] INDEX.md updated with numbering convention reference

### Real-World Validation
- [ ] FEAT-020 test scenarios renumbered to FEAT-020.1 through FEAT-020.4
- [ ] Numbering system tested with AI (can AI follow the convention?)
- [ ] Numbering system tested with humans (is it intuitive?)

### Backward Compatibility
- [ ] Existing flat-numbered items (FEAT-001 through FEAT-020) remain valid
- [ ] No requirement to retroactively renumber existing items
- [ ] Documentation explains both old and new conventions

---

## Implementation Plan

### Phase 1: Define Standards (Documentation)

**1.1 Document in workflow-guide.md:**
- [ ] Add "Work Item Numbering and Naming" section
- [ ] Document hierarchical numbering (parent.child.grandchild)
- [ ] Document file naming convention (UPPERCASE-NNN-description.md)
- [ ] Document number exhaustion handling (999 → 1000)
- [ ] Provide decision tree: when to use hierarchical vs flat
- [ ] Include examples for all scenarios

**1.2 Update CLAUDE.md or CLAUDE-QUICK-REFERENCE.md:**
- [ ] Add quick reference to numbering conventions
- [ ] Link to workflow-guide.md for details

**1.3 Update INDEX.md:**
- [ ] Add reference to numbering standards

---

### Phase 2: Update All Templates

**Templates to update (add naming guide to TOP of each):**
- [ ] FEATURE-TEMPLATE.md
- [ ] BUGFIX-TEMPLATE.md
- [ ] BLOCKER-TEMPLATE.md
- [ ] FEASIBILITY-TEMPLATE.md
- [ ] RESEARCH-TEMPLATE.md
- [ ] TEST-SCENARIO-TEMPLATE.md (create if doesn't exist)
- [ ] ADR-MAJOR-TEMPLATE.md (if it uses numbering)
- [ ] ADR-MINOR-TEMPLATE.md (if it uses numbering)

**Each template gets:**
1. HTML comment block at top with naming/numbering guide
2. "Hierarchical Numbering (If Applicable)" section after front matter
3. Updated examples showing new convention

---

### Phase 3: Validate with Real Use Cases

**3.1 FEAT-020 test scenarios (already done!):**
- [x] FEAT-020.1 through FEAT-020.4 already using hierarchical numbering
- [ ] Verify file naming follows convention
- [ ] Use as example in documentation

**3.2 Create test work item with AI:**
- [ ] Ask AI to create a feature with sub-features
- [ ] Verify AI reads template naming guide
- [ ] Verify AI applies convention correctly
- [ ] Document any issues found

**3.3 Human usability test:**
- [ ] Have human create work item from template
- [ ] Observe if naming guide is clear
- [ ] Collect feedback on template clarity
- [ ] Refine based on feedback

---

### Phase 4: Optional Migration of Existing Files

**NOT REQUIRED, but available as separate task:**
- Rename `feature-004-...` through `feature-019-...` to `FEAT-004-...` through `FEAT-019-...`
- Update any cross-references
- Document both conventions during transition period
- **Decision:** Can defer or skip entirely (backward compatible)

---

## Design Decisions

### Decision 1: Dot Notation vs Other Separators

**Options:**
- Dot notation: `FEAT-020.1` ✅ **RECOMMENDED**
- Dash notation: `FEAT-020-1` ❌ (conflicts with existing dash usage)
- Underscore: `FEAT-020_1` ❌ (less common, harder to read)
- Slash: `FEAT-020/1` ❌ (problems with file paths)

**Chosen:** Dot notation (standard in versioning systems, clear hierarchy)

### Decision 2: Depth Limit

**Options:**
- Unlimited depth ❌ (gets unwieldy)
- 2 levels: `FEAT-020.1` ❌ (may not be enough)
- 3 levels: `FEAT-020.1.1` ✅ **RECOMMENDED**
- 4+ levels ❌ (over-engineering)

**Chosen:** 3 levels maximum (parent.child.grandchild)
**Rationale:** If you need more than 3 levels, the parent feature is probably too large and should be broken down.

### Decision 3: File Naming Convention

**Options:**
- Lowercase full word: `feature-021-description.md` ❌
- Uppercase full word: `FEATURE-021-description.md` ❌
- Lowercase abbreviated: `feat-021-description.md` ❌
- Uppercase abbreviated: `FEAT-021-description.md` ✅ **CHOSEN**

**Rationale:**
- Matches ID field in document (`**ID:** FEAT-021`)
- Matches how we reference in text and commits
- Industry standard (JIRA, GitHub, etc.)
- Easier to scan visually
- Shorter and cleaner

### Decision 4: Number Exhaustion Strategy

**Options:**
- Reset to FEAT-001 after 999 ❌ (causes duplicates)
- Use letters after 999 (FEAT-99A) ❌ (non-standard)
- Require manual intervention at 999 ❌ (unnecessary friction)
- Automatic continuation to FEAT-1000 ✅ **CHOSEN**

**Rationale:**
- Natural, no special handling
- Extremely unlikely scenario for most projects
- Simple to implement and understand
- Consistent with version numbering (1.0.0 → 1.0.10)

### Decision 5: WIP Limit Counting with Hierarchical Items

**Options:**
- Count each file separately (FEAT-021, FEAT-021.1, FEAT-021.2 = 3 items) ❌
- Count only parent (all three = 1 item) ✅ **CHOSEN**
- Make it configurable ❌ (adds complexity)

**Rationale:**
- Parent and children are a logical unit of work
- You're working on ONE feature with sub-tasks
- Prevents gaming the system (break every feature into tiny sub-features to bypass WIP limits)
- Matches mental model: "I'm working on FEAT-021"
- Sub-features don't exist independently from parent

**Implementation:**
- WIP counting script: `grep -E '^[A-Z]+-[0-9]{3,}-' | grep -v '\.'`
- Only counts files without dots in the number portion
- FEAT-021 counts, FEAT-021.1 doesn't

### Decision 6: Sub-feature Storage Location

**Options:**
- Sub-features in separate subdirectory ❌ (breaks flat kanban structure)
- Sub-features stay in backlog/ while parent in doing/ ❌ (confusing)
- Sub-features go to doing/ with parent ✅ **CHOSEN**

**Rationale:**
- All related work items co-located in same folder
- Easy to move together (mv FEAT-021*.md)
- Easy to see all sub-features at a glance
- Maintains flat folder structure (no nested directories)

### Decision 7: Backward Compatibility

**Approach:**
- ✅ Keep all existing flat numbering valid
- ✅ Keep existing lowercase filenames valid (`feature-NNN-...`)
- ✅ No requirement to renumber old items
- ✅ Document both conventions during transition
- ✅ New items use new standard going forward

**Rationale:** Minimize disruption, allow gradual adoption, avoid breaking existing references

---

## Testing Strategy

### AI Understanding Test

**Scenario:** Ask AI to create a feature with test scenarios

**Test Prompt:**
```
"Create a feature for user profile editing with 3 test scenarios"
```

**Expected AI Behavior:**
1. Creates parent: `FEAT-022-user-profile-editing.md`
2. Recognizes test scenarios should be sub-features
3. Creates:
   - `FEAT-022.1-basic-edit-test.md`
   - `FEAT-022.2-validation-test.md`
   - `FEAT-022.3-save-error-test.md`
4. Parent feature references children in "Sub-Features" section
5. Children reference parent in "Parent Feature" field

**Success Criteria:**
- [ ] AI uses hierarchical numbering without prompting
- [ ] AI explains the numbering choice
- [ ] File names and IDs match convention

### Human Understanding Test

**Scenario:** New contributor creates a bug fix with sub-tasks

**Test:**
1. Ask human to create a bug fix with 2 related sub-tasks
2. Provide access to templates and documentation
3. Observe WITHOUT GUIDANCE

**Success Criteria:**
- [ ] Human finds numbering guidance in template
- [ ] Human correctly uses sub-numbering (BUGFIX-XXX.1, BUGFIX-XXX.2)
- [ ] Human understands when to use vs not use sub-numbering
- [ ] Takes ≤5 minutes to understand convention

---

## Edge Cases

### Edge Case 1: Sub-feature outlives parent

**Scenario:** FEAT-020.1 is completed and useful, but FEAT-020 is cancelled

**Solution:**
- Sub-feature can remain as FEAT-020.1 (shows historical context)
- OR can be promoted to standalone feature with new number (FEAT-025)
- Document decision in work item
- Update cross-references

### Edge Case 2: Multiple parents

**Scenario:** Work item relates to both FEAT-020 and FEAT-030

**Solution:**
- Choose primary parent for numbering
- Cross-reference other parent in "Related Work Items" section
- If truly equal importance, it should probably be standalone feature

### Edge Case 3: Grandchild exceeds depth limit

**Scenario:** Need FEAT-020.1.1.1 (4 levels)

**Solution:**
- Break down FEAT-020 into smaller parent features
- Or promote FEAT-020.1 to standalone parent (renumber to FEAT-023)
- Maximum 3 levels enforced in templates and documentation

### Edge Case 4: Reaching FEAT-999

**Scenario:** Project has 999 features and needs to create FEAT-1000

**Solution:**
- Simply continue to FEAT-1000 (no special handling)
- File: `FEAT-1000-description.md` (no zero padding)
- ID field: `**ID:** FEAT-1000`
- Numbering continues naturally: FEAT-1001, FEAT-1002, etc.

**Note:** If you reach 1000 features in a single project, consider:
- Is this really one project, or multiple projects?
- Should some features be archived/consolidated?
- But the numbering system supports it regardless!

### Edge Case 5: Sub-feature completed before parent

**Scenario:** FEAT-021.1 is done, but FEAT-021 is still in progress

**Solution:**
- Keep FEAT-021.1 in `work/doing/` with parent
- Mark FEAT-021.1 status as "Done" in document
- When parent completes, move ALL children together to `work/done/`
- Sub-features always move as a unit with parent

**Rationale:** Maintains co-location, prevents scattered files

### Edge Case 6: WIP limit counting with multiple features

**Scenario:** `doing/` contains FEAT-021, FEAT-021.1, FEAT-021.2, FEAT-022

**WIP Count:**
```bash
# Files in doing/:
FEAT-021-work-item-numbering.md
FEAT-021.1-hierarchical-numbering.md
FEAT-021.2-file-naming.md
FEAT-022-another-feature.md

# Count: 2 (FEAT-021 and FEAT-022)
# FEAT-021.1 and FEAT-021.2 don't count
```

**Rule:** Only files matching `^[A-Z]+-[0-9]+-` (no dot) count toward limit

### Edge Case 7: Mixing old and new naming conventions

**Scenario:** Directory has both `feature-020-...md` and `FEAT-021-...md`

**Solution:**
- Both are valid during transition period
- Document in workflow-guide.md that both exist
- All NEW items use uppercase convention
- Optional cleanup task can rename old files later
- No breaking of existing references

**WIP Counting:** Script handles both conventions (checks for dot separator, not case)

---

## Version Impact

**Impact Type:** PATCH

**Rationale:**
- This is a documentation and process improvement
- No breaking changes to existing work items
- Backward compatible (old numbering still valid)
- Enhances framework capability without changing core behavior

---

## Risks and Mitigation

### Risk 1: Confusion with existing flat numbering

**Mitigation:**
- Clear documentation of both conventions
- Examples showing both flat and hierarchical
- Decision tree for "which to use when"

### Risk 2: AI might not follow convention consistently

**Mitigation:**
- Add to CLAUDE.md AI Workflow Checkpoint Policy
- Include in code-quality-standards.md equivalent for work items
- Test thoroughly with AI before release

### Risk 3: Over-nesting (too many levels)

**Mitigation:**
- Document 3-level maximum in templates
- Provide guidance on when to break down vs nest
- Include in workflow-guide.md

---

## Success Metrics

**Post-Implementation (1 month):**
- [ ] 80%+ of new sub-features use hierarchical numbering
- [ ] Zero reported confusion or misunderstanding
- [ ] AI correctly applies numbering in 95%+ of cases
- [ ] Humans find numbering intuitive (survey/feedback)

**Long-Term (3 months):**
- [ ] Clear improvement in feature organization
- [ ] Easier to track related work items
- [ ] Positive feedback from contributors

---

## Related Work Items

**Parent Feature:** None (standalone feature)

**Related Features:**
- FEAT-020: Collaboration Documentation System (first use case for hierarchical numbering)

**Depends On:**
- None

**Blocks:**
- None (nice-to-have improvement)

---

## Notes

- First use case: FEAT-020.1 through FEAT-020.4 (test scenarios)
- Should be validated with both AI and human contributors
- Consider creating TEST-SCENARIO-TEMPLATE.md as part of this work
- May inspire similar hierarchical approaches for ADRs or other documents

---

## Changelog

**2025-12-22 - Added WIP Limit Guidance:**
- Added Problem 5: Work folder limits with hierarchical numbering
- Added Part 4: WIP Limits with Hierarchical Numbering
- Added Decision 5: WIP Limit Counting (parent only, children don't count)
- Added Decision 6: Sub-feature Storage Location (co-located with parent)
- Renumbered previous Decision 5 to Decision 7 (Backward Compatibility)
- Added Edge Case 5: Sub-feature completed before parent
- Added Edge Case 6: WIP limit counting with multiple features
- Renumbered previous Edge Case 5 to Edge Case 7
- Added WIP counting script example
- Updated Functional Requirements with WIP limits section

**2025-12-22 - Expanded Scope:**
- Expanded from "hierarchical numbering only" to comprehensive naming/numbering standards
- Added Part 2: File Naming Convention (UPPERCASE-NNN-description.md)
- Added Part 3: Number Exhaustion Handling (999 → 1000 auto-continuation)
- Added Part 5: Template self-documentation with HTML comment guide
- Added Design Decision 3: File Naming Convention rationale
- Added Design Decision 4: Number Exhaustion Strategy rationale
- Added Edge Case 4: Reaching FEAT-999
- Updated Implementation Plan with 4 phases
- Updated requirements to cover all three parts

**2025-12-22 - Initial Creation:**
- Created backlog item for hierarchical numbering only
- Status: Backlog (awaiting approval)

---

**Last Updated:** 2025-12-22
**Status:** Backlog

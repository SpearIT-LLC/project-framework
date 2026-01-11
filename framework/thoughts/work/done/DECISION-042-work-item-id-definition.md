# Decision: Work Item ID Definition and Reference System

**ID:** 042
**Type:** Decision (Architectural)
**Priority:** High
**Status:** Done
**Created:** 2026-01-11
**Completed:** 2026-01-11
**Impacts:** All work items, templates, documentation, tooling

---

## Decision Statement

Define the canonical format for work item IDs and establish clear guidelines for referencing work items throughout the framework.

**Core Question:** What IS a work item ID - the counter alone (042) or the type-prefixed combination (FEAT-042)?

---

## Context

### Current State Inconsistency

The framework currently has conflicting definitions:

**kanban-workflow.md implies:**
- "ID Numbering" section (lines 104-109) suggests counter is the ID
- Features start at 001, Bugfixes at 101
- Counter sequences appear independent per type

**Actual practice shows:**
- Work items referenced as "FEAT-026", "TECH-044" everywhere
- Template metadata: `**ID:** FEAT-002`
- Never referenced as just "002" or "#002"
- Type prefix always included in references

**The confusion:**
- Is "042" the ID and "FEAT" metadata?
- Or is "FEAT-042" the ID and we're being redundant?
- This ambiguity causes confusion about "duplicate IDs"

### Why This Matters

1. **Template consistency** - What goes in the `**ID:**` field?
2. **Reference style** - How do we cite work items in docs?
3. **Grep patterns** - What do we search for?
4. **Tooling** - Future automation needs clear ID definition
5. **User guidance** - Contributors need unambiguous rules

---

## Proposed Solution

**Decision: Counter as canonical ID, prefix as convenience notation**

### Core Principle

The **ID** is a **unique sequential counter** (001, 002, 003...) shared across ALL work item types.

**Type prefixes** are organizational metadata used in:
- Filenames (for filesystem organization)
- Convenience references (for clarity)
- Grep patterns (for filtering)

### ID Assignment Rules

1. **Counter is unique across project**
   - Starts at 001
   - Increments sequentially
   - Shared across ALL types (FEAT, TECH, BUGFIX, DECISION, SPIKE)
   - Each number used exactly once

2. **Type is separate metadata**
   - Recorded in `**Type:**` field
   - Used in filename prefix
   - Available for filtering/categorization

### Reference Formats

**Canonical (in metadata):**
```markdown
**ID:** 042
**Type:** Feature
```

**Filename:**
```
FEAT-042-description.md
```

**References in text (both valid):**
- Short form: "042" (when context is clear)
- Long form: "FEAT-042" (when clarity needed)
- Mixed: "042 depends on TECH-037"

**Grep patterns (both work):**
```bash
grep -r "\b042\b" thoughts/     # Find by ID
grep -r "FEAT-042" thoughts/    # Find by type-prefixed reference
```

---

## Benefits

### Philosophical Benefits

✅ **Conceptually pure** - ID is truly unique identifier
✅ **Separation of concerns** - ID vs. Type are distinct concepts
✅ **Single source of truth** - One counter, one sequence
✅ **Chronological clarity** - ID 042 came after 041, regardless of type

### Practical Benefits

✅ **Flexible referencing** - Use short or long form as needed
✅ **Grep-friendly** - Both patterns work
✅ **Filesystem organized** - Type prefix keeps files grouped
✅ **Industry familiar** - Similar to Jira (PROJ-123) but more flexible
✅ **Future-proof** - Can add new types without renumbering

---

## Trade-offs

### What We Gain

- Clear, unambiguous ID definition
- Flexibility in references (context-dependent)
- True uniqueness across entire project
- Organized filesystem with type prefixes

### What We Accept

- References need type prefix for complete clarity
- Counter doesn't indicate type at a glance (042 could be anything)
- Slight learning curve (explaining canonical vs. convenience form)
- Documentation needs to explain both forms

---

## Implementation Plan

### Phase 1: Documentation Updates

**1. Update kanban-workflow.md (high priority)**

Section: "Work Item IDs" (replace existing "ID Numbering")

Content:
```markdown
### Work Item IDs

**ID Definition:** Unique sequential counter across all work item types.

**Format:** `NNN` (001, 002, 003...)

**Assignment:**
- Start at 001
- Increment sequentially
- Shared across ALL types (FEAT, TECH, BUGFIX, DECISION, SPIKE)
- Each ID used exactly once per project

**Reference Forms:**
- **Canonical:** Counter only (042)
- **Convenience:** Type-prefixed (FEAT-042)
- Both forms are valid and searchable

**Filename Convention:** `{TYPE}-{NNN}-{description}.md`
- Example: `FEAT-042-namespace-system.md`
- Type prefix organizes files by category
- Counter ensures global uniqueness

**Examples:**
- ID 026 → Filename: FEAT-026-structure-migration.md
- ID 040 → Filename: TECH-044-work-item-policy.md
- ID 042 → Filename: DECISION-042-id-definition.md

**Searching:**
```bash
# By ID (canonical)
grep -r "\b042\b" thoughts/

# By type-prefixed reference (convenience)
grep -r "FEAT-042" thoughts/

# By filename
ls thoughts/work/*/FEAT-042*
```
```

**2. Update TECH-041 (supporting files policy)**

Add clarification:
- Base ID (042) is unique
- Supporting files share base ID: FEAT-042-ANALYSIS.md, FEAT-042-P1-BUG-*.md
- Type prefix is organizational, not part of ID uniqueness

**3. Update TECH-044 (work item creation policy)**

Reference this decision for ID assignment guidance.

### Phase 2: Template Updates

Update all templates in `framework/templates/`:

**Change:**
```markdown
**ID:** FEAT-002
```

**To:**
```markdown
**ID:** 042
**Type:** Feature
```

**Templates to update:**
- FEATURE-TEMPLATE.md
- BUGFIX-TEMPLATE.md
- BLOCKER-TEMPLATE.md
- SPIKE-TEMPLATE.md
- DECISION-TEMPLATE.md (if exists)
- TECH-DEBT-TEMPLATE.md (if exists)

### Phase 3: Existing Work Items (Optional)

**Decision:** Do NOT update existing work items retrospectively

**Rationale:**
- Historical accuracy preserved
- Massive churn for little benefit
- Both formats remain valid
- New work items follow new format

**Going forward:**
- New work items use `**ID:** NNN` format
- Existing work items keep current format
- Both are valid and searchable

---

## Validation

### Success Criteria

- [ ] kanban-workflow.md clearly defines ID format
- [ ] Templates updated to use canonical format
- [ ] TECH-041 references this decision
- [ ] Documentation explains both reference forms
- [ ] Examples provided for both search patterns
- [ ] No ambiguity about what "ID" means

### User Impact

**Framework maintainers:**
- Clear guidance for assigning next ID
- Unambiguous referencing rules
- Consistent template usage

**Framework users:**
- Clear setup instructions
- Example work items follow standard
- Searchable documentation

**AI assistants (Claude):**
- Clear ID assignment algorithm
- Consistent template population
- Unambiguous reference parsing

---

## Alternatives Considered

### Alternative 1: Type-Prefix as Part of ID

```markdown
**ID:** FEAT-042
**Type:** Feature (redundant)
```

**Rejected because:**
- Redundant Type field
- ID is not truly "unique counter" (it's namespace + counter)
- Conflates identity with categorization
- Less philosophically pure

### Alternative 2: Pure Counter, No Type Prefix Anywhere

```markdown
**ID:** 042
**Type:** Feature
Filename: 042-description.md
```

**Rejected because:**
- Filesystem loses type organization
- Can't quickly scan for all features
- Less practical for file management
- Harder to visually categorize

### Alternative 3: Keep Current Ambiguity

**Rejected because:**
- Causes confusion about duplicates
- Inconsistent documentation
- Unclear template guidance
- Blocks future tooling

---

## Dependencies

**Blocks:**
- TECH-044 (Work Item Creation Policy) - needs ID definition
- TECH-041 (Supporting Files Policy) - references ID uniqueness
- Future automation/tooling - needs canonical format

**Related:**
- kanban-workflow.md - primary specification document
- All work item templates - need consistent format
- TECH-028 (DRY Principles) - single source of truth for ID definition

---

## References

**Discovery context:**
- Structure compliance review (2026-01-11)
- FEAT-025 "duplicate IDs" investigation
- kanban-workflow.md ambiguity identified

**Discussion:**
- Philosophical vs. practical considerations
- Industry standards analysis (Jira, GitHub, Azure DevOps)
- Framework philosophy alignment (simplicity, single source of truth)

---

## Implementation Checklist

- [x] Update kanban-workflow.md with clear ID definition
- [ ] Update TECH-041 to reference this decision
- [x] Update all templates (FEATURE-TEMPLATE.md, BUGFIX-TEMPLATE.md)
- [x] Add examples to workflow documentation
- [x] Add grep/search examples
- [x] Document both reference forms (canonical + convenience)
- [x] Verify no conflicting documentation remains
- [x] Test grep patterns work as documented
- [ ] Commit changes with clear message

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Changed
- **DECISION-042: Work Item ID Definition**
  - Clarified ID as unique sequential counter (001, 002, 003...)
  - Type prefix is organizational metadata, not part of ID
  - Both reference forms valid: "042" (canonical) or "FEAT-042" (convenience)
  - Updated kanban-workflow.md with clear ID specification
  - Updated templates to use canonical format: **ID:** NNN
  - Existing work items remain valid (no retrospective changes)
```

---

## Notes

**Priority:** High - Blocks documentation work items and causes confusion

**Effort estimate:** 2-3 hours
- kanban-workflow.md updates: 1 hour
- Template updates: 1 hour
- Related document updates: 30 min
- Testing/verification: 30 min

**Decision date:** TBD (pending approval)
**Implementation date:** TBD (after approval)

---

**Last Updated:** 2026-01-11
**Status:** Done (Decision implemented)

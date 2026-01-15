# Technical: Document Work Item Creation Policy

**ID:** 044
**Type:** Technical (Documentation/Policy)
**Version Impact:** PATCH (clarifies existing process)
**Status:** Backlog
**Created:** 2026-01-10
**Completed:** N/A
**Developer:** TBD

---

## Summary

Add explicit policy to workflow-guide.md stating that all new work items must be created in `thoughts/work/backlog/` with Status: Backlog, and only move to todo/ when committed to work on soon.

---

## Problem Statement

**What problem does this solve?**

The kanban workflow documentation shows work items flowing through backlog → todo → doing → done, but doesn't explicitly state WHERE new work items should be created. This led to confusion during FEAT-038, FEAT-039, and DECISION-036 creation where work items were initially created in todo/ instead of backlog/.

**Current State:**
- workflow-guide.md shows the flow but doesn't state the creation policy
- Work items were created in wrong location (todo/ instead of backlog/)
- Policy is implied but not documented

**Who is affected?**

- AI assistants creating work items (may put them in wrong location)
- Framework contributors (may not know where to start new work items)
- Users adopting the framework (unclear where work items begin)

**Current workaround (if any):**

Manual correction after creation, or verbal instruction.

---

## Requirements

### Functional Requirements

- [ ] Add explicit policy statement to workflow-guide.md
- [ ] Clarify that new work items START in backlog/
- [ ] Explain when to move from backlog/ to todo/
- [ ] Update workflow diagram/description if needed
- [ ] Make policy clear for both humans and AI

### Non-Functional Requirements

- [ ] Clarity: Policy must be unambiguous
- [ ] Visibility: Policy should be easy to find in documentation
- [ ] Consistency: Should align with existing workflow description

---

## Design

### Architecture Impact

**Files Modified:**
- `framework/docs/process/workflow-guide.md` - Add explicit policy section

**Possible Files Modified (if needed):**
- `framework/docs/collaboration/workflow-guide.md` - Reference policy if mentioned

### Implementation Approach

**Option 1: Add Policy Section (Recommended)**

Add a new "Work Item Creation Policy" section near the beginning of workflow-guide.md:

```markdown
## Work Item Creation Policy

**Rule:** All new work items MUST be created in `thoughts/work/backlog/` with `Status: Backlog`.

**Process:**
1. Create new work item file in `thoughts/work/backlog/`
2. Set Status field to `Backlog`
3. Fill out work item template
4. Work item stays in backlog/ until committed to work on soon
5. Move to todo/ only when ready to commit to implementation

**Rationale:**
- Backlog is for all planned work (may or may not happen)
- Todo is for committed work (will happen soon)
- This separation helps prioritize and manage WIP limits

**When to move backlog → todo:**
- Work item is prioritized for next sprint/iteration
- Prerequisites are met
- WIP limit in todo/ allows (default: max 10 items)
```

**Option 2: Add to Existing Workflow Section**

Enhance the existing "Work Item Lifecycle" section with creation policy:

```markdown
### Creating New Work Items

**All work items start in backlog:**
1. Create file in `thoughts/work/backlog/`
2. Use appropriate template (FEATURE-TEMPLATE.md, BUGFIX-TEMPLATE.md, etc.)
3. Set Status: Backlog
4. Fill out requirements and design sections

Move to todo/ only when committed to work on it soon.
```

**Option 3: Add to Quick Reference**

If workflow-guide.md has a quick reference section, add:

```markdown
- ✅ Create new work items in backlog/
- ✅ Set Status: Backlog initially
- ❌ Don't create in todo/ or doing/
```

**Recommendation:** Option 1 (dedicated section) for maximum clarity.

### Alternative Approaches Considered

**Option A: Don't document, rely on workflow diagram**
- Pros: Less documentation
- Cons: Ambiguous, led to current confusion
- Decision: Rejected - need explicit statement

**Option B: Document in multiple places**
- Pros: Higher visibility
- Cons: Duplication, maintenance burden
- Decision: Partial - main policy in workflow-guide.md, brief reference elsewhere if needed

**Option C: Create automated check**
- Pros: Enforces policy automatically
- Cons: Overkill for simple policy
- Decision: Future consideration, document first

---

## Dependencies

**Requires:**
- workflow-guide.md exists (yes)

**Blocks:**
- None (informational only)

**Related:**
- FEAT-038 (Update v3.0.0 Path References) - Will update workflow-guide.md anyway, can include this

---

## Testing Plan

### Validation Checklist

**Policy Statement:**
- [ ] Policy clearly states work items created in backlog/
- [ ] Policy states Status: Backlog initially
- [ ] Policy explains when to move to todo/
- [ ] Policy is near beginning of document (high visibility)

**Clarity Test:**
- [ ] Someone unfamiliar with framework can understand where to create work items
- [ ] AI assistants can parse and follow the policy
- [ ] No ambiguity about creation location

**Integration:**
- [ ] Policy aligns with existing workflow description
- [ ] Policy doesn't contradict other documentation
- [ ] Workflow diagram (if present) matches policy

---

## Implementation Checklist

- [ ] Review workflow-guide.md current structure
- [ ] Decide on placement (new section vs. enhance existing)
- [ ] Write policy statement
- [ ] Add to workflow-guide.md
- [ ] Update "Last Updated" date
- [ ] Verify clarity with test read
- [ ] Check if workflow-guide.md needs update
- [ ] Commit changes

---

## Success Metrics

**How do we know this is successful?**

1. ✅ Policy explicitly documented in workflow-guide.md
2. ✅ Clear statement: "Create new work items in backlog/"
3. ✅ Future work items created in correct location
4. ✅ No confusion about where to start new work items

**Failure Criteria:**
- Policy still ambiguous
- Work items still created in wrong location
- Policy contradicts workflow description

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Added
- **TECH-044: Document Work Item Creation Policy**
  - Added explicit policy to workflow-guide.md
  - Clarified that all new work items start in backlog/ with Status: Backlog
  - Explained when to move from backlog/ to todo/
  - Prevents confusion about work item creation location
```

---

## Notes

**Priority:** Low-Medium - Important for clarity but not blocking

**Discovery Context:**
During creation of FEAT-038, FEAT-039, and DECISION-036, work items were initially placed in todo/ instead of backlog/. This revealed that the policy is implied by the workflow but never explicitly stated.

**Can be combined with FEAT-038:**
Since FEAT-038 is already updating workflow-guide.md for path references, this policy addition could be included in that work item to minimize the number of updates to the file.

**Alternative:** If keeping separate, mark as dependent on FEAT-038 to avoid merge conflicts.

---

## References

- [workflow-guide.md](../../docs/process/workflow-guide.md) - File to be updated
- [workflow-guide.md](../../docs/collaboration/workflow-guide.md) - May need reference
- This issue discovered during FEAT-038, FEAT-039, DECISION-036 creation

---

**Last Updated:** 2026-01-10

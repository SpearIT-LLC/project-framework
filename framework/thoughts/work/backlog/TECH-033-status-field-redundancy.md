# TECH-033: Review Status Field Redundancy in Work Items

**ID:** TECH-033
**Type:** Technical Debt / Process Review
**Priority:** Low
**Status:** Backlog
**Created:** 2026-01-08
**Related:** FEAT-026

---

## Summary

Review whether the status field in work item files is redundant with folder location, and decide whether to simplify or repurpose it.

---

## Problem Statement

**Issue identified during:** FEAT-026 workflow documentation review

Current situation:
- Work item files contain a "Status" field (Backlog, Todo, Doing, Done, Released)
- Work items also live in folders that represent status (backlog/, todo/, doing/, done/, releases/)
- **The folder IS the status** in our file-based workflow

**This creates potential issues:**
- Redundancy: Status is tracked in two places
- Risk of inconsistency: File status field might not match folder location
- Maintenance burden: Must update both when status changes
- Unclear which is "source of truth"

**Who is affected?**
- Developers moving work items through workflow
- Anyone reading work item files
- Automation that might rely on status field

**Current workaround:**
- Status field exists but may become stale
- Primary status is folder location

---

## Investigation Required

### Questions to Answer

1. **Is status field currently used?**
   - Check if any tools or scripts read the status field
   - Determine if it provides value beyond folder location

2. **Do users rely on status field?**
   - When reading a work item file, is status field helpful?
   - Or is folder location always the source of truth?

3. **Could field be repurposed?**
   - Sub-status within doing/ (e.g., "doing - blocked", "doing - review")
   - Historical tracking (original status when archived)
   - Other metadata

---

## Options

### Option 1: Remove Status Field Entirely

**Approach:** Remove status field from templates and documents

**Rationale:**
- Folder location IS the status
- Eliminates redundancy
- One less field to maintain
- Simpler work item files

**Pros:**
- ✅ Eliminates redundancy
- ✅ Reduces maintenance burden
- ✅ Single source of truth (folder)
- ✅ Simpler templates

**Cons:**
- ❌ Status not visible when reading file in isolation
- ❌ Harder to track status history
- ❌ Breaking change for existing items

**Implementation:**
- Update all work item templates
- Document that folder is status
- Gradually remove from existing items (optional)

---

### Option 2: Keep Field, Point to Folder

**Approach:** Status field says "See folder location"

**Example:**
```markdown
**Status:** See folder location (backlog/ | todo/ | doing/ | done/ | releases/)
```

**Rationale:**
- Makes explicit that folder is source of truth
- Keeps field for reference but avoids inconsistency
- Educates users about workflow

**Pros:**
- ✅ Explicit about folder-based status
- ✅ No maintenance burden (static text)
- ✅ Educates about workflow
- ✅ Non-breaking change

**Cons:**
- ❌ Still redundant (but explicit)
- ❌ Takes up space in file

---

### Option 3: Repurpose for Sub-Status

**Approach:** Use status field for additional detail within doing/

**Example:**
```markdown
**Status:** Doing - Blocked (waiting on DECISION-029)
**Status:** Doing - In Review
**Status:** Doing - Testing
```

**Rationale:**
- Provides value beyond folder location
- Useful for doing/ items with different sub-states
- Eliminates pure redundancy

**Pros:**
- ✅ Adds information not in folder
- ✅ Useful for tracking within doing/
- ✅ Maintains consistency (folder + detail)

**Cons:**
- ❌ More complex workflow
- ❌ May be over-engineering
- ❌ Additional maintenance burden

---

### Option 4: Keep As-Is

**Approach:** Accept redundancy, document folder as primary

**Rationale:**
- Not causing major problems
- Familiar to users
- Easy to ignore if not needed

**Pros:**
- ✅ No changes required
- ✅ Maintains current practice

**Cons:**
- ❌ Redundancy remains
- ❌ Risk of inconsistency
- ❌ Doesn't address the issue

---

## Recommendation

**Initial recommendation:** Option 2 (Keep field, point to folder)

**Reasoning:**
- Explicit about workflow without breaking changes
- Low effort implementation
- Educates users
- Can always move to Option 1 or 3 later if needed

**Alternative:** Option 1 (Remove) if we want maximum simplicity

---

## Implementation

### If Option 1 (Remove):

- [ ] Update all 4 work item templates (remove status field)
- [ ] Document in workflow-guide.md that folder is status
- [ ] Update CLAUDE.md with clarification
- [ ] Optionally update existing work items (low priority)

### If Option 2 (Point to folder):

- [ ] Update all 4 work item templates
- [ ] Change status field to: `**Status:** See folder location`
- [ ] Document in workflow-guide.md
- [ ] Optionally update existing work items

### If Option 3 (Sub-status):

- [ ] Update templates with sub-status guidance
- [ ] Document sub-status conventions
- [ ] Provide examples
- [ ] Update existing doing/ items

---

## Completion Criteria

- [ ] Decision made on which option to implement
- [ ] Templates updated (if applicable)
- [ ] Documentation updated
- [ ] Rationale documented
- [ ] Changes committed

---

## References

- Source: framework/thoughts/research/backlog-ideas-from-feat-026.md (Item #5)
- Origin: FEAT-026-followup.md line 33-34 (Step 7 discussion)
- Related: FEAT-030 (hold/ folder - related to status tracking)

---

## Notes

**Not urgent:**
- Current redundancy isn't causing major problems
- Can be addressed when updating templates for other reasons
- More important to document than to perfect

**Philosophy:**
- File-based workflow: folder location IS the status
- Status field should either add value or be removed
- Avoid redundancy that risks inconsistency

---

**Last Updated:** 2026-01-08

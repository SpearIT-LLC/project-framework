# Technical Debt: Document Work Item ID Discovery Policy

**ID:** 046
**Type:** Technical Debt / Documentation
**Priority:** Medium
**Status:** Backlog
**Created:** 2026-01-11
**Related:** DECISION-042, TECH-044, workflow-guide.md

---

## Summary

Document the official policy for discovering the next available work item ID. Specify the algorithm, scan scope, and rationale for the approach to ensure consistent ID assignment across the framework.

---

## Problem Statement

**Current situation:**

DECISION-042 defines what work item IDs are (unique sequential counters), but does not specify HOW to find the next available ID when creating a new work item.

**The gap:**

The framework lacks documentation on:
1. Which directories to scan when finding the next ID
2. The algorithm for determining the next available ID
3. Whether to parse filenames or file contents
4. Whether to include archived work items in the scan
5. Rationale for the chosen approach

**Who is affected?**

- Framework maintainers creating work items manually
- AI assistants (Claude) helping with work item creation
- Future automation tools that need to assign IDs
- Contributors unfamiliar with the implicit process

**Impact:**

Without clear guidance:
- Risk of ID collisions from incorrect scanning
- Inefficient token usage from unclear search scope
- Inconsistent approaches across different creation methods
- Difficulty implementing future automation

---

## Solution

Document the official policy for discovering the next available work item ID.

### Proposed Policy

**Finding Next Available ID**

**Method:** Scan filenames to find the maximum ID currently in use.

**Scan Scope:**

Scan both top-level directories containing work items:
- `work/` (includes all subdirectories: backlog, doing, done, todo, archive)
- `releases/` (includes all version subdirectories)

**Algorithm:**

1. **Glob pattern:** `{work,releases}/**/{DECISION,FEAT,TECH,SPIKE,POLICY,BUGFIX}-*.md`
2. **Parse IDs:** Extract numeric ID from each filename (e.g., `FEAT-042-description.md` → `042`)
3. **Find maximum:** Determine the highest ID across all matches
4. **Calculate next:** Next available ID = max + 1

**Examples:**

```bash
# Find all work item files in both locations
ls {work,releases}/**/{DECISION,FEAT,TECH,SPIKE,POLICY,BUGFIX}-*.md

# If current max ID found is 045
# Then next available ID is 046
```

**Rationale:**

- ✅ **Always accurate:** Self-healing, no sync issues
- ✅ **Efficient:** Filename parsing only, no file content reads required
- ✅ **Simple:** No state files to maintain or keep in sync
- ✅ **Git-friendly:** No merge conflicts on metadata files
- ✅ **Comprehensive:** Covers all work items regardless of status or location
- ✅ **Future-proof:** Works with any subdirectory structure

**Why scan both work/ and releases/?**

- `work/` contains active work items (backlog, doing, done, todo, archive)
- `releases/` contains work items associated with specific releases
- Both directories can contain the most recent ID
- Scanning both ensures no ID collisions

**Why include archive/?**

- Archive is part of `work/` directory structure
- Archived items still consume their assigned ID
- If an archived item is reactivated, it keeps its original ID
- No need to special-case or skip subdirectories

**Why parse filenames instead of file contents?**

- More efficient (no file reads required)
- Faster (filesystem operations only)
- Reliable (filename is source of truth per DECISION-042)
- Simpler implementation

---

## Implementation Plan

### Phase 1: Documentation

**1. Add ID Discovery section to workflow-guide.md**

Location: After the "Work Item IDs" section

Content:
```markdown
### Finding Next Available ID

When creating a new work item, find the next available ID by scanning existing work items:

**Algorithm:**
1. Scan both `work/` and `releases/` directories for all work item files
2. Use glob pattern: `{work,releases}/**/{DECISION,FEAT,TECH,SPIKE,POLICY,BUGFIX}-*.md`
3. Extract numeric IDs from filenames
4. Find the maximum ID
5. Next available ID = max + 1

**Example:**
```bash
# Find all work items
ls {work,releases}/**/*-[0-9][0-9][0-9]-*.md

# Parse IDs and find maximum
# If max is 045, next ID is 046
```

**Rationale:**
- Ensures no ID collisions
- Self-healing (always accurate)
- Efficient (filename parsing only)
- No state files to maintain
```

**2. Reference in TECH-044 (Work Item Creation Policy)**

Add a reference to this ID discovery algorithm when documenting the work item creation process.

**3. Update DECISION-042 references**

Add a note in DECISION-042 pointing to this policy for the ID discovery algorithm.

### Phase 2: Validation

- [ ] Verify the glob pattern matches all work item types
- [ ] Test algorithm with current framework structure
- [ ] Confirm no edge cases missed (archive, releases, etc.)
- [ ] Validate documentation is clear and unambiguous

### Phase 3: Implementation Examples

Provide example implementations in different contexts:
- Manual (bash command line)
- AI assistant (Claude Code instructions)
- Future automation (pseudocode)

---

## Validation

### Success Criteria

- [ ] workflow-guide.md includes ID discovery algorithm
- [ ] TECH-044 references this policy
- [ ] DECISION-042 updated with cross-reference
- [ ] Clear examples provided for all use cases
- [ ] No ambiguity about which directories to scan
- [ ] Algorithm is efficient and token-friendly

### User Impact

**Framework maintainers:**
- Clear process for finding next ID
- No guesswork about which directories to scan
- Confidence in ID uniqueness

**AI assistants:**
- Explicit algorithm to follow
- Efficient token usage (filename parsing only)
- No risk of ID collisions in solo developer workflow

**Future automation:**
- Well-defined algorithm for implementation
- Clear scope and validation rules
- Consistent behavior across tools

**Current Limitation:**
- ⚠️ **Solo developer only** - This algorithm does not handle concurrent ID creation in distributed team environments
- Small team support requires additional work (see FEAT-047)

---

## Alternatives Considered

### Alternative 1: Maintain .nextId State File

**Approach:** Keep a file containing the next available ID number

**Rejected because:**
- ❌ Could drift out of sync with actual files
- ❌ Git merge conflicts in collaborative environments
- ❌ Single point of failure if corrupted
- ❌ Adds cognitive overhead for manual workflow
- ❌ Conflicts with manual-first philosophy

### Alternative 2: Scan only work/ directory

**Approach:** Only check `work/` and ignore `releases/`

**Rejected because:**
- ❌ Risk of ID collision if releases/ contains newer IDs
- ❌ Not comprehensive
- ❌ Requires manual coordination between directories
- ❌ User explicitly confirmed releases/ must be included

### Alternative 3: Scope scan to exclude done/ or archive/

**Approach:** Only scan `backlog/`, `doing/`, `todo/`

**Rejected because:**
- ❌ Most recent ID could be in `done/`
- ❌ Archived items still consume their IDs
- ❌ Creates edge cases and special rules
- ❌ Not simpler than scanning all subdirectories

### Alternative 4: Read file contents for ID metadata

**Approach:** Parse `**ID:** NNN` from file contents

**Rejected because:**
- ❌ More expensive (requires file reads)
- ❌ Slower (I/O overhead)
- ❌ Filename is source of truth per DECISION-042
- ❌ No benefit over filename parsing

---

## Dependencies

**Related:**
- DECISION-042 - Defines what work item IDs are
- TECH-044 - Work item creation policy needs ID discovery
- workflow-guide.md - Primary specification document

**Blocks:**
- Future automation tools
- AI assistant optimization
- Work item creation documentation

---

## References

**Discussion context:**
- ID discovery optimization discussion (2026-01-11)
- Token efficiency considerations
- Manual workflow usability requirements

**Related decisions:**
- DECISION-042: Work Item ID Definition
- Framework philosophy: Manual-first, automation-friendly

---

## Notes

**Priority:** Medium - Important for consistency but not blocking current work

**Effort estimate:** 1-2 hours
- workflow-guide.md updates: 30 min
- DECISION-042 cross-reference: 15 min
- TECH-044 reference: 15 min
- Examples and validation: 30 min

**Implementation approach:** Documentation-only change, no code required

---

**Last Updated:** 2026-01-11
**Status:** Backlog (awaiting approval)

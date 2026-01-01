# Bug Fix: Stale Target Version Metadata in Work Item Templates

**ID:** BUGFIX-006
**Type:** Bugfix
**Version Impact:** PATCH (backward-compatible template/documentation fix)
**Status:** Doing
**Severity:** Medium
**Priority:** P2
**Version Found:** v2.2.3
**Version Fixed:** N/A
**Created:** 2026-01-01
**Fixed:** N/A
**Developer:** Claude & User

---

## Summary

Work item templates include a "Target Version" field that becomes stale when items sit in backlog for extended periods, creating confusion about version authority. The field implies it's authoritative but isn't, causing version mismatches and incorrect expectations. Fix: Remove "Target Version" field, rely on PROJECT-STATUS.md (single source of truth) + "Version Impact" field, calculate actual version at Step 9 (release time).

---

## Bug Description

**What is happening (actual behavior)?**

Work item templates (FEATURE-TEMPLATE.md, BUGFIX-TEMPLATE.md, etc.) include this field:
```markdown
**Target Version:** vX.Y.Z (e.g., v1.2.1)
```

**Problem flow:**
1. User creates FEAT-025 in backlog on 2025-12-01
2. Fills in "Target Version: v2.3.0" (current is v2.2.2, so next MINOR = v2.3.0)
3. FEAT-025 sits in backlog for 3 months
4. Meanwhile: BUGFIX-002 (v2.2.3), BUGFIX-005 (v2.2.4), FEAT-026 (v2.3.0), BUGFIX-007 (v2.3.1)
5. 2026-03-01: User asks AI to implement FEAT-025
6. **AI reads work item:** "Target Version: v2.3.0"
7. **But current version is:** v2.3.1 (from PROJECT-STATUS.md)
8. **Conflict:** Work item says v2.3.0 (stale), reality is v2.3.1

**Current workaround:**
- AI calculates version at Step 9 from PROJECT-STATUS.md anyway
- But creates confusion: "Wait, I thought this was v2.3.0?"
- Users see stale metadata and question it

**What should happen (expected behavior)?**

Work item templates should NOT have a "Target Version" field. Instead:

1. **Version Impact field** (already exists): `PATCH | MINOR | MAJOR`
2. **Single source of truth:** PROJECT-STATUS.md "Current Version"
3. **Calculate at release time (Step 9):**
   - AI reads PROJECT-STATUS.md: Current = v2.2.3
   - AI reads work item: Version Impact = PATCH
   - AI calculates: Next = v2.2.3 + PATCH = v2.2.4
   - AI presents: "Current version v2.2.3 + PATCH impact = v2.2.4. Proceed with release?"
   - User confirms or adjusts

**Benefits:**
- ✅ No stale metadata (version calculated just-in-time)
- ✅ Single source of truth (PROJECT-STATUS.md)
- ✅ Clear authority (not ambiguous)
- ✅ Flexible (release order doesn't matter)
- ✅ User confirmation at release time

**Impact:**

- **Medium severity:** Causes confusion, potential version mismatches in communication
- **Affects:** All work item templates, all work items with "Target Version" field
- **Risk:** Users/AI assume wrong version, documentation references incorrect version
- **Current mitigation:** AI calculates from PROJECT-STATUS.md at Step 9 anyway (but confusing)

---

## Reproduction Steps

**Environment:**
- Framework: Standard (v2.2.3)
- Work item templates: FEATURE-TEMPLATE.md, BUGFIX-TEMPLATE.md, etc.

**Steps to Reproduce:**

1. Create work item from template (e.g., FEAT-025)
2. Fill in "Target Version: v2.3.0" (based on current v2.2.2 + MINOR)
3. Leave work item in backlog for several weeks/months
4. Meanwhile, release other work items (version increments to v2.3.1)
5. Move FEAT-025 to doing/
6. **Observe:** Work item still says "Target Version: v2.3.0"
7. **But current version:** v2.3.1 (from PROJECT-STATUS.md)
8. **Result:** Stale metadata, confusion about which version is authoritative

**Reproducibility:** Always (any work item that sits in backlog while versions change)

**Evidence:**

From 2026-01-01 session:
```
User: "Even though the work item identifies a TARGET version, that really is not the authoritative source for versioning. An item could stay in the backlog for weeks and months before it's addressed. We need an independent arbiter for versioning. What do you think?"

Claude: "You're absolutely right - we have a version authority problem..."
```

---

## Root Cause Analysis

**File(s) Affected:**
- `thoughts/framework/templates/FEATURE-TEMPLATE.md` - Line 6: **Target Version:** field
- `thoughts/framework/templates/BUGFIX-TEMPLATE.md` - Line 6: **Target Version:** field
- `thoughts/framework/templates/BLOCKER-TEMPLATE.md` - Line 6: **Target Version:** field (if exists)
- `thoughts/framework/templates/SPIKE-TEMPLATE.md` - Line 6: **Target Version:** field (if exists)
- All existing work items with this field (informational only, don't need to update)

**Root Cause:**

**Design flaw:** Templates include "Target Version" field that:
1. **Implies authority** - Field name suggests "this is the target version"
2. **Lacks actual authority** - Real version comes from PROJECT-STATUS.md + calculation
3. **Gets stale** - Value becomes outdated as time passes and other releases happen
4. **Creates confusion** - Users/AI see conflicting version information

**Why was this missed?**

1. Initial template design assumed work items would be implemented quickly (no backlog delay)
2. Didn't anticipate long-lived backlog items
3. Field seemed helpful ("what version are we targeting?")
4. Actual version calculation happens at Step 9, so field is redundant

**The real version authority is:**
- PROJECT-STATUS.md "Current Version" = single source of truth for "where we are now"
- Work item "Version Impact" = what type of increment this causes
- Calculation at Step 9 = current + impact = next version

**The "Target Version" field adds:**
- ❌ Stale metadata
- ❌ False authority
- ❌ Confusion
- ✅ Nothing useful (redundant with calculation)

---

## Fix Design

**Approach:** Remove "Target Version" field from templates, update Step 9 to explicitly calculate and present version for user confirmation.

### Changes Required

**1. Update Work Item Templates**

**Files to modify:**
- `thoughts/framework/templates/FEATURE-TEMPLATE.md`
- `thoughts/framework/templates/BUGFIX-TEMPLATE.md`
- `thoughts/framework/templates/BLOCKER-TEMPLATE.md` (if field exists)
- `thoughts/framework/templates/SPIKE-TEMPLATE.md` (if field exists)

**Remove this line:**
```markdown
**Target Version:** vX.Y.Z (e.g., v1.2.1)
```

**Keep these lines (no change):**
```markdown
**Version Impact:** PATCH | MINOR | MAJOR
**Version Found:** [e.g., v1.0.0] (for bugfixes)
**Version Fixed:** [e.g., v1.0.1 or N/A]
```

**Result after change:**
```markdown
**ID:** FEAT-NNN
**Type:** Feature
**Version Impact:** MINOR (new functionality, backward-compatible)
**Status:** [Backlog | Todo | Doing | Done | Released]
**Priority:** [P0 | P1 | P2 | P3]
**Created:** [YYYY-MM-DD]
**Developer:** [Name]
```

**2. Update CLAUDE.md Step 9 (Complete & Release)**

Add explicit version calculation step:

**Current Step 9:**
```markdown
**9. Complete & Release** ⚠️ CRITICAL: Atomic Release Process
   - Work is done, tested, AND APPROVED
   - **STOP - Before committing:** Prepare version updates atomically
```

**Updated Step 9:**
```markdown
**9. Complete & Release** ⚠️ CRITICAL: Atomic Release Process
   - Work is done, tested, AND APPROVED
   - **STOP - Calculate next version:**
     - Read PROJECT-STATUS.md "Current Version" (e.g., v2.2.3)
     - Read work item "Version Impact" (PATCH | MINOR | MAJOR)
     - Calculate next version:
       - PATCH: Increment patch (v2.2.3 → v2.2.4)
       - MINOR: Increment minor, reset patch (v2.2.3 → v2.3.0)
       - MAJOR: Increment major, reset minor and patch (v2.2.3 → v3.0.0)
     - **ASK FOR CONFIRMATION:** "Current version v2.2.3 + PATCH impact = v2.2.4. Proceed with release v2.2.4?"
     - User confirms or corrects version
   - **STOP - Before committing:** Prepare version updates atomically
```

**3. Update workflow-guide.md (if it references Target Version)**

Search for "Target Version" references and update/remove.

**4. Existing Work Items (Backlog/Todo/Doing)**

**Do NOT update existing work items** - they're already created.

Just add a note to this bugfix work item:
```markdown
**Note:** Existing work items in backlog/todo/doing may still have "Target Version" field. This is informational only. AI will calculate actual version from PROJECT-STATUS.md at Step 9 (release time).
```

---

## Implementation Plan

### Phase 1: Template Updates
1. Remove "Target Version" line from FEATURE-TEMPLATE.md
2. Remove "Target Version" line from BUGFIX-TEMPLATE.md
3. Remove "Target Version" line from BLOCKER-TEMPLATE.md (if exists)
4. Remove "Target Version" line from SPIKE-TEMPLATE.md (if exists)

### Phase 2: CLAUDE.md Update
1. Add version calculation step to Step 9 (Complete & Release)
2. Include explicit calculation formula
3. Add user confirmation question with calculated version

### Phase 3: Documentation Cleanup
1. Search for "Target Version" references in collaboration docs
2. Update/remove any references that assume field exists
3. Add note about version calculation at Step 9

### Phase 4: Verification
1. Create new work item from updated template
2. Verify "Target Version" field is gone
3. Verify "Version Impact" field still present
4. Test Step 9 version calculation process

---

## Testing Strategy

### Test Cases

**TC1: New work item from updated template**
- Create work item from FEATURE-TEMPLATE.md
- **Verify:** No "Target Version" field
- **Verify:** "Version Impact" field present
- **Pass criteria:** Template doesn't include stale metadata field

**TC2: Version calculation at Step 9**
- Current version: v2.2.3
- Work item: Version Impact = PATCH
- AI calculates: v2.2.3 + PATCH = v2.2.4
- AI presents: "Current version v2.2.3 + PATCH impact = v2.2.4. Proceed?"
- User confirms
- **Pass criteria:** Version calculated correctly, user prompted for confirmation

**TC3: Version calculation with MINOR impact**
- Current version: v2.2.3
- Work item: Version Impact = MINOR
- AI calculates: v2.2.3 + MINOR = v2.3.0
- **Pass criteria:** Minor increments, patch resets to 0

**TC4: Version calculation with MAJOR impact**
- Current version: v2.2.3
- Work item: Version Impact = MAJOR
- AI calculates: v2.2.3 + MAJOR = v3.0.0
- **Pass criteria:** Major increments, minor and patch reset to 0

**TC5: Existing work item with old "Target Version" field**
- Old work item has "Target Version: v2.3.0"
- Current version is v2.3.1
- AI ignores stale "Target Version" field
- AI calculates from PROJECT-STATUS.md + Version Impact
- **Pass criteria:** Stale field doesn't affect release

### Validation Checklist

- [ ] All templates updated (Target Version field removed)
- [ ] CLAUDE.md Step 9 includes version calculation
- [ ] Version calculation formula documented
- [ ] User confirmation step added
- [ ] No references to "Target Version" field in active docs (except historical)
- [ ] Test work item created from updated template (no Target Version field)
- [ ] Next 3 releases use version calculation process

---

## Alternative Fixes Considered

**Option A: Auto-update "Target Version" at Step 7 (Move to doing/)**
- AI recalculates target version when moving from todo/ → doing/
- Updates work item with fresh version
- **Rejected:** Extra bookkeeping, still creates authority confusion

**Option B: Keep "Target Version" as informational only**
- Add note: "(Informational only - actual version calculated at release)"
- **Rejected:** Confusing to have two version fields with different authority

**Option C: Rename "Target Version" to "Initial Target Version"**
- Clarifies it's a snapshot from creation time
- **Rejected:** Still stale, still confusing, doesn't solve problem

**Option D: Remove "Target Version", calculate at Step 9 (Selected)**
- Clean single source of truth
- No stale metadata
- User confirmation at release time
- **Selected:** Best balance of clarity and accuracy

---

## Success Criteria

- [ ] "Target Version" field removed from all work item templates
- [ ] CLAUDE.md Step 9 includes version calculation step
- [ ] Version calculation formula documented (PATCH/MINOR/MAJOR)
- [ ] User confirmation added to Step 9
- [ ] No confusion about version authority in next 5 releases
- [ ] All new work items use Version Impact field only

---

## Impact Assessment

**User Impact:**
- ✅ Positive: No more stale version metadata
- ✅ Positive: Clear version authority (PROJECT-STATUS.md)
- ✅ Positive: User confirms version at release time
- ⚠️ Neutral: Existing work items still have old field (informational only)

**Breaking Changes:**
- ❌ None - templates are just defaults
- Existing work items unchanged
- No functional impact on release process

**Documentation Debt:**
- ✅ Reduces: Eliminates stale metadata field
- ✅ Simplifies: One less field to maintain

---

## Related Issues

**Complements:**
- BUGFIX-002: Missing post-implementation review checkpoint
- BUGFIX-005: Missing pre-implementation review checkpoint
- Pattern: Discovered through dogfooding and user questioning

**Relationship:**
- PROJECT-STATUS.md: Single source of truth for current version
- Work item "Version Impact": Declares increment type
- Step 9 calculation: Combines both for next version

---

## Prevention Strategy

**How to prevent similar stale metadata issues:**

1. **Metadata audit:**
   - Review all template fields
   - Identify which are "calculated" vs "user input"
   - Remove/mark calculated fields that get stale

2. **Authority principle:**
   - One field, one authority
   - If field is calculated, don't store it (calculate just-in-time)
   - If field is authoritative, document it clearly

3. **Template design checklist:**
   - Does this field get stale over time? → Remove or recalculate
   - Is this field redundant with another source? → Remove
   - Is authority clear? → Document or fix

---

## CHANGELOG Notes

**Fixed:**
- Removed stale "Target Version" field from work item templates
- Version now calculated at release time from PROJECT-STATUS.md + Version Impact
- Eliminates confusion about version authority

**Changed:**
- CLAUDE.md Step 9: Added explicit version calculation step
- Templates: Removed "Target Version" field, kept "Version Impact" field
- Release process: User confirms calculated version before proceeding

---

## Notes

**Discovery:**

User identified this issue during BUGFIX-002 release when questioning version authority:
> "Even though the work item identifies a TARGET version, that really is not the authoritative source for versioning. An item could stay in the backlog for weeks and months before it's addressed. We need an independent arbiter for versioning."

**Why this is a bug, not a feature:**
- It's a design flaw in templates (broken invariant)
- Field creates false authority and stale metadata
- Not adding new capability, fixing existing dysfunction
- Severity: Low-Medium (confusion, not breakage)

**Implementation strategy:**
- Fix templates (source of issue)
- Update Step 9 to make calculation explicit
- Let existing work items keep old field (informational only)
- Future work items won't have stale metadata

---

## Related

- PROJECT-STATUS.md: Single source of truth for current version
- CLAUDE.md Step 9: Release process (updated to include version calculation)
- Work item templates: Fixed to remove stale metadata field

---

## Changelog

- 2026-01-01: Bug identified by user during BUGFIX-002 release discussion
- 2026-01-01: BUGFIX-006 created in backlog
- 2026-01-01: Moved backlog → todo → doing
- 2026-01-01: Implementation started

---

## Implementation Notes

**Changes Made:**

1. **Work Item Templates (master docs - updated first):**
   - FEATURE-TEMPLATE.md: Removed "Target Version" line (was line 6)
   - BUGFIX-TEMPLATE.md: Removed "Target Version" line (was line 6)
   - BLOCKER-TEMPLATE.md: No "Target Version" field (already correct)
   - SPIKE-TEMPLATE.md: No "Target Version" field (already correct)

2. **workflow-guide.md - Versioning & Releases (master - added before CLAUDE.md):**
   - Lines 821-903: Added comprehensive "Versioning & Releases" section
   - Includes complete version calculation formula (PATCH/MINOR/MAJOR)
   - Step-by-step process for Step 9
   - Edge cases (multiple work items, user overrides, pre-release versions)
   - Rationale for calculating at release time
   - Note about removing "Target Version" field

3. **CLAUDE.md Step 9 (derived - updated after workflow-guide.md):**
   - Line 213: Added "Calculate next version" bullet with brief formula
   - Updated Version Update Steps to reference calculated version
   - Concise version that references workflow-guide.md for details

4. **BUGFIX-006 work item:**
   - Updated with implementation notes (this section)

**Files Modified:**
- [FEATURE-TEMPLATE.md](../../../project-framework-template/standard/thoughts/framework/templates/FEATURE-TEMPLATE.md) - Removed Target Version field
- [BUGFIX-TEMPLATE.md](../../../project-framework-template/standard/thoughts/framework/templates/BUGFIX-TEMPLATE.md) - Removed Target Version field
- [workflow-guide.md](../../collaboration/workflow-guide.md) - Lines 821-903 (83 lines added)
- [CLAUDE.md](../../../CLAUDE.md) - Line 213, updated Version Update Steps
- [BUGFIX-006-stale-target-version-metadata.md](BUGFIX-006-stale-target-version-metadata.md) - This file

**Implementation followed universal documentation principle:**
- ✅ Updated master docs FIRST (templates, workflow-guide.md)
- ✅ Then updated derived doc (CLAUDE.md)
- ✅ Information flow: detailed → summary

**Testing Status:**
- ✅ FEATURE-TEMPLATE.md has no "Target Version" field
- ✅ BUGFIX-TEMPLATE.md has no "Target Version" field
- ✅ workflow-guide.md has complete version calculation guidance
- ✅ CLAUDE.md Step 9 has brief version calculation bullet
- ✅ No other "Target Version" references in workflow-guide.md

**Next Steps:**
- Present completed work for user review (Step 8.5)
- After approval, move to done/ and prepare release

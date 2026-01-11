# FEAT-032: Support Multiple Work Items Per Release

**ID:** 032
**Type:** Feature (Workflow Enhancement)
**Priority:** Medium
**Status:** Done
**Created:** 2026-01-08
**Completed:** 2026-01-11
**Related:** FEAT-026, FEAT-028
**Version Impact:** MINOR

---

## Summary

Document and implement support for releasing multiple work items together under the same version number (e.g., three bug fixes shipped as v2.2.6).

---

## Problem Statement

**Issue identified during:** FEAT-026 workflow documentation review

Current workflow documentation implies one work item per release:
- Each work item gets its own version bump
- Release process documentation focuses on single-item releases
- Unclear how to handle grouped releases (e.g., 3 bug fixes in one version)

**Real-world scenario:**
- Sprint completed with 3 bug fixes
- Logical to release all together as v2.2.6
- Need clear process for grouping and tracking

**Who is affected?**
- Developers releasing multiple fixes/features together
- Users reading CHANGELOG.md (need clear version history)
- Framework maintainers (need consistent release process)

**Current workaround:**
- Undefined - current workflow doesn't address this scenario

---

## Requirements

### Functional Requirements

- [ ] Document how to group multiple work items for single release
- [ ] Define CHANGELOG.md format for multi-item releases
- [ ] Establish version bumping strategy for grouped releases
- [ ] Define release history organization for grouped items
- [ ] Update release process documentation

### Non-Functional Requirements

- [ ] Clarity: Process should be clear and unambiguous
- [ ] Flexibility: Support both single-item and multi-item releases
- [ ] Traceability: Easy to find what was in each release
- [ ] Compatibility: Work with existing workflow structure

---

## Design

### Approach 1: Release Groups (Recommended)

**Create release group concept:**

```
thoughts/work/releases/
├── v2.2.6-group/
│   ├── BUGFIX-042-fix-auth.md
│   ├── BUGFIX-043-fix-validation.md
│   └── BUGFIX-044-fix-logging.md
└── v2.2.7/
    └── FEAT-033-new-feature.md
```

**Process:**
1. Move all items for release to done/
2. Create release group folder: `releases/v2.2.6-group/`
3. Move all items into group folder
4. Update CHANGELOG.md with all items under one version

**CHANGELOG.md format:**
```markdown
## [2.2.6] - 2026-01-15

### Fixed
- BUGFIX-042: Authentication token refresh issue
- BUGFIX-043: Input validation on user forms
- BUGFIX-044: Logging format for error messages

### Notes
- This release contains 3 bug fixes grouped together
```

### Approach 2: Single Lead Item

**Designate one item as "lead":**
- One work item represents the release (e.g., BUGFIX-042)
- Other items documented as "Released with BUGFIX-042"
- All items archived separately but linked

**Pros/Cons:**
- Simpler folder structure
- Harder to see grouping at a glance
- May not reflect reality (no true "lead" item)

---

## Decisions Needed

### 1. Version Bumping Strategy

**Question:** When releasing multiple items, how to determine version bump?

**Options:**
- Use highest semantic version impact (MINOR beats PATCH)
- Explicit decision per release (documented in release notes)
- Predetermined (e.g., sprints always MINOR)

**Recommendation:** Highest semantic impact
- 3 PATCH items → PATCH version bump
- 2 PATCH + 1 MINOR → MINOR version bump
- Any MAJOR → MAJOR version bump

### 2. CHANGELOG Organization

**Question:** How to organize CHANGELOG for grouped releases?

**Options:**
- Group by semantic version type (all Fixed together)
- List chronologically as completed
- Group by feature area

**Recommendation:** Group by semantic version type (matches semantic versioning conventions)

### 3. Release History Location

**Question:** Where to store grouped release history?

**Options:**
- Separate folder: `releases/v2.2.6-group/`
- Single folder with subdirs: `releases/v2.2.6/item1.md`, `releases/v2.2.6/item2.md`
- Flat with naming: `releases/v2.2.6-BUGFIX-042.md`

**Recommendation:** Approach 1 (group folder) - clear and organized

---

## Implementation

### Phase 1: Document Process

- [ ] Add "Multiple Items Per Release" section to workflow-guide.md
- [ ] Document grouping decision process
- [ ] Provide examples and templates
- [ ] Update CLAUDE.md with release group concept

### Phase 2: Update Templates

- [ ] Update work item templates with "Release Version" field
- [ ] Add note about potential grouped releases
- [ ] Update release checklist template (if exists)

### Phase 3: Update Release Automation

- [ ] Update FEAT-028 release script to support groups (if applicable)
- [ ] Add validation for grouped releases
- [ ] Support creating release group folders

---

## Documentation Updates

### Files to Update

- [ ] framework/process/workflow-guide.md - Add grouped release section
- [ ] framework/CLAUDE.md - Update release history structure
- [ ] QUICK-START.md - Note possibility of grouped releases
- [ ] Work item templates - Add release version field

### Example Documentation Section

```markdown
## Releasing Multiple Work Items Together

When releasing multiple items as one version:

1. Complete all items (move to done/)
2. Decide version number based on highest impact
3. Create release group folder: `releases/vX.Y.Z-group/`
4. Move all items to group folder
5. Update CHANGELOG.md with all items under one version
6. Tag release: `git tag vX.Y.Z`

**Version Bumping:**
- Use highest semantic version impact among all items
- PATCH + PATCH = PATCH
- PATCH + MINOR = MINOR
- Any MAJOR = MAJOR
```

---

## Completion Criteria

- [x] Grouped release process documented
- [x] Version bumping strategy defined
- [x] CHANGELOG format documented
- [x] Examples provided
- [x] Templates updated (not needed - existing templates sufficient)
- [x] Workflow-guide.md updated
- [x] CLAUDE.md updated

## Implementation Summary

**What was done:**

1. **workflow-guide.md** - Added comprehensive "Releasing Multiple Work Items Together" section:
   - Version bumping rules (highest impact wins)
   - Step-by-step grouped release process
   - CHANGELOG format guidance
   - Release folder structure examples
   - When to use single vs grouped releases

2. **CLAUDE.md** - Updated Step 9 with grouped release guidance:
   - Version calculation for multiple items
   - CHANGELOG organization
   - Archive process for grouped releases
   - Link to detailed documentation

**Files modified:**
- [framework/docs/collaboration/workflow-guide.md](../../../docs/collaboration/workflow-guide.md#releasing-multiple-work-items-together)
- [framework/CLAUDE.md](../../../CLAUDE.md) (Step 9)

**Key decisions:**
- Single release folder contains all work items (simple, clear)
- Highest Version Impact wins (MAJOR > MINOR > PATCH)
- CHANGELOG organized by semantic version categories
- Both single and grouped releases supported (use judgment)

---

## Alternatives Considered

**Option 1: Enforce one item per release**
- Pros: Simpler, matches current docs
- Cons: Not realistic for real projects
- Decision: Support reality, allow grouping

**Option 2: No special handling**
- Pros: No changes needed
- Cons: Confusion and inconsistent practices
- Decision: Explicit guidance prevents confusion

**Option 3: Require umbrella work item**
- Pros: Forces explicit planning
- Cons: Extra overhead, doesn't match typical workflow
- Decision: Allow ad-hoc grouping (more flexible)

---

## Success Metrics

- Clear process for grouped releases
- Consistent CHANGELOG.md formatting
- No confusion about release organization
- Support for real-world release scenarios

---

## References

- Source: framework/thoughts/research/backlog-ideas-from-feat-026.md (Item #4)
- Origin: FEAT-026-followup.md line 34-35 (Step 9 discussion)
- Related: FEAT-028 (release automation may need updates)

---

## Notes

**Real-world examples to support:**
- Three bug fixes in one release
- Sprint containing multiple features
- Hot-fix bundle (multiple urgent fixes)
- Themed release (related features)

**Keep flexible:**
- Don't force grouping when single item makes sense
- Don't force splitting when grouping makes sense
- Support both patterns

---

**Last Updated:** 2026-01-08

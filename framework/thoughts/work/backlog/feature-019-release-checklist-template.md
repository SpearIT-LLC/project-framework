# Feature: Release Checklist Template

**ID:** FEAT-019
**Type:** Feature (Template)
**Version Impact:** MINOR (adds new template)
**Target Version:** v2.2.0
**Status:** Backlog
**Created:** 2025-12-20
**Completed:** N/A
**Developer:** TBD

---

## Summary

Create a RELEASE-CHECKLIST-TEMPLATE.md that AI can copy and use before each release to ensure atomic release process and prevent version inconsistencies discovered during v2.1.0 dogfooding.

---

## Problem Statement

**What problem does this solve?**

During v2.1.0 release, we discovered that AI (and humans) can forget critical release steps:
- Updating PROJECT-STATUS.md version
- Updating CHANGELOG.md with version section
- Committing version updates atomically with implementation
- Creating git tags
- Archiving completed work items

The version-control-workflow.md has a comprehensive Release Checklist (lines 113-149), but it's embedded in a long process document. A dedicated, copy-pasteable checklist template makes the process more reliable.

**Who is affected?**

- AI assistants performing releases
- Solo developers managing releases
- Teams ensuring consistent release process
- Framework maintainers

**Current workaround (if any):**

- Reference version-control-workflow.md lines 113-149
- CLAUDE.md now has step 9 with release guidance (v2.1.0)
- Manual checklist in head / copy-paste from workflow doc

---

## Requirements

### Functional Requirements

- [ ] Template file: `RELEASE-CHECKLIST-TEMPLATE.md`
- [ ] Markdown checklist format (GitHub-compatible checkboxes)
- [ ] Sections matching version-control-workflow.md Release Checklist
- [ ] Pre-release checks
- [ ] Version determination logic
- [ ] Atomic release steps (PROJECT-STATUS + CHANGELOG + commit + tag)
- [ ] Post-release cleanup
- [ ] Placeholders for: version number, work item ID, description
- [ ] Instructions for use
- [ ] Reference to version-control-workflow.md

### Non-Functional Requirements

- [ ] Performance: N/A (static template)
- [ ] Security: N/A (documentation)
- [ ] Compatibility: Works with all framework levels (Light/Standard)
- [ ] Documentation: Add to QUICK-REFERENCE.md section 4, update INDEX.md

---

## Design

### Template Location

**In framework templates:**
- `thoughts/framework/templates/RELEASE-CHECKLIST-TEMPLATE.md`

**Usage:**
- AI copies template to project root as `RELEASE-CHECKLIST.md`
- AI fills in placeholders (version, work item, description)
- AI checks off items as completed
- After release, delete or archive checklist

### Template Structure

```markdown
# Release Checklist: vX.Y.Z

**Work Item:** FEAT-NNN or BUGFIX-NNN
**Description:** [Brief description]
**Release Date:** YYYY-MM-DD
**Version Impact:** MAJOR | MINOR | PATCH

---

## Pre-Release Checks

- [ ] All tests pass
- [ ] Feature/bugfix branch merged to main (if applicable)
- [ ] Work item moved to work/done/
- [ ] Work item has CHANGELOG notes section
- [ ] Implementation complete and tested
- [ ] Session history updated (thoughts/history/sessions/YYYY-MM-DD-SESSION-HISTORY.md)
  - Work completed documented
  - Decisions made recorded
  - Key learnings captured

---

## Determine Version

**Current Version:** [Check PROJECT-STATUS.md]
**Version Impact:** [From work item metadata]
**New Version:** vX.Y.Z

**Calculation:**
- [ ] Read current version from PROJECT-STATUS.md
- [ ] Apply semantic versioning rule (MAJOR.MINOR.PATCH)
- [ ] New version calculated: v_____

---

## Atomic Release (do together)

### Update PROJECT-STATUS.md
- [ ] Update "Current Version" in header: v_____
- [ ] Update "Last Updated" date: YYYY-MM-DD
- [ ] Add to release history table

### Update CHANGELOG.md
- [ ] Move [Unreleased] content to [vX.Y.Z] - YYYY-MM-DD
- [ ] Copy CHANGELOG notes from work item document
- [ ] Add version to release history
- [ ] Create fresh [Unreleased] section

### Commit & Tag
- [ ] Stage all changes: `git add -A`
- [ ] Commit: `git commit -m "Release: vX.Y.Z - [Description]"`
- [ ] Create tag: `git tag -a vX.Y.Z -m "[Release notes]"`
- [ ] Verify commit and tag created

### Push
- [ ] Push commits: `git push origin main`
- [ ] Push tags: `git push origin main --tags`
- [ ] Verify on remote

---

## Post-Release

- [ ] Verify tag on remote: `git tag -l vX.Y.Z`
- [ ] Archive work item: work/done/[item].md → history/releases/vX.Y.Z/[item].md
- [ ] Delete feature/bugfix branch: `git branch -d feature/NNN-name`
- [ ] Update CLAUDE.md if architecture/standards changed
- [ ] Update roadmap.md if applicable
- [ ] Delete this checklist or archive to history/releases/vX.Y.Z/

---

## Notes

**Reference:** [version-control-workflow.md](../process/version-control-workflow.md) lines 101-149

**Why atomic?** Version number must match implementation commit. Never commit implementation separate from version bump.

---

**Completed:** YYYY-MM-DD
**Released By:** [Name]
```

### Alternative Approaches Considered

**Option A:** Make checklist part of FEATURE-TEMPLATE.md
- Pros: Single template, always available
- Cons: Clutters feature template, not all features trigger releases
- Decision: Separate template better

**Option B:** Automated script instead of checklist
- Pros: Can't forget steps, fully automated
- Cons: Less flexible, harder to review before release
- Decision: Template first, automation later (FEAT-020?)

**Option C:** Integrate into CI/CD
- Pros: Enforced automatically
- Cons: Framework doesn't assume CI/CD, many projects won't have it
- Decision: Manual checklist works for all projects

---

## Dependencies

**Requires:**
- version-control-workflow.md (already exists)
- CLAUDE.md step 9 update (completed v2.1.0)

**Blocks:**
- None

**Related:**
- FEAT-007: Validation Script (could validate checklist completion)
- version-control-workflow.md (this template implements its checklist)

---

## Testing Plan

### Manual Testing Steps

1. Use template for next release (v2.2.0 or v2.1.1)
2. Copy template, fill in placeholders
3. Follow checklist step-by-step
4. Verify all steps completed
5. Compare to version-control-workflow.md checklist
6. Verify version consistency post-release

### Success Criteria

- [ ] All release steps completed without missing any
- [ ] Version numbers consistent (STATUS, CHANGELOG, git tag)
- [ ] Work item properly archived
- [ ] Release process takes < 10 minutes
- [ ] No steps forgotten

---

## Security Considerations

- [x] Input validation implemented - N/A (template)
- [x] No credential exposure in logs - N/A
- [x] Path traversal prevention - N/A
- [x] Error messages don't leak sensitive info - N/A
- [x] Follows principle of least privilege - N/A

---

## Documentation Updates

### Files to Update

- [ ] INDEX.md - Add RELEASE-CHECKLIST-TEMPLATE to template section
- [ ] QUICK-REFERENCE.md - Add release checklist to section 4
- [ ] STRUCTURE.md - List new template

### New Documentation Needed

- [ ] RELEASE-CHECKLIST-TEMPLATE.md - The template itself
- [ ] Usage instructions in template header

---

## Implementation Checklist

- [ ] Design reviewed and approved
- [ ] Template created in thoughts/framework/templates/
- [ ] References version-control-workflow.md
- [ ] Placeholders clearly marked
- [ ] Tested on actual release
- [ ] INDEX.md updated
- [ ] QUICK-REFERENCE.md updated
- [ ] STRUCTURE.md updated
- [ ] CHANGELOG.md updated

---

## Rollout Plan

**Deployment Steps:**

1. Create RELEASE-CHECKLIST-TEMPLATE.md
2. Add to Standard framework templates
3. Update documentation references
4. Use on next release (dogfooding)
5. Refine based on feedback
6. Release in v2.2.0

**Rollback Plan:**

Remove template file if not useful - no other changes required

---

## Success Metrics

**How do we know this feature is successful?**

- Zero version inconsistencies in releases after adoption
- Releases complete in < 10 minutes using checklist
- AI successfully uses checklist without missing steps
- Users report feeling more confident about releases
- FEAT-007 validation passes after every release

---

## Timeline

| Phase | Estimated Hours | Actual Hours | Status |
|-------|-----------------|--------------|--------|
| Planning | 0.5 hours | TBD | Backlog |
| Implementation | 1 hour | TBD | Backlog |
| Testing | 0.5 hours | TBD | Backlog |
| Documentation | 0.5 hours | TBD | Backlog |
| **Total** | **2.5 hours** | **TBD** | |

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Added
- Release Checklist Template (RELEASE-CHECKLIST-TEMPLATE.md)
  - Step-by-step checklist for atomic releases
  - Prevents version inconsistencies
  - Based on version-control-workflow.md Release Checklist
  - Includes pre-release, atomic release, and post-release steps
```

---

## Notes

**Origin:** Discovered during v2.1.0 release that we committed implementation and version bump separately, violating atomic release principle.

**Relationship to other features:**
- Implements checklist from version-control-workflow.md as template
- Complements CLAUDE.md step 9 (provides concrete checklist)
- Could be validated by FEAT-007 validation script

**Future enhancement:** FEAT-020 could automate this checklist as a script

---

## References

- [version-control-workflow.md](../../thoughts/framework/process/version-control-workflow.md) - Lines 101-149
- [CLAUDE.md](../../../CLAUDE.md) - Step 9: Complete & Release
- v2.1.0 retrospective - Where this need was identified
- FEAT-007 - Validation script (related)

---

**Last Updated:** 2025-12-20

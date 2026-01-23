# Tech Debt: Document Rollback/Revert Policy

**ID:** TECH-070
**Type:** Tech Debt
**Priority:** High
**Version Impact:** PATCH
**Created:** 2026-01-23

---

## Summary

The framework has template placeholders for rollback plans but no actual documented process for when and how to execute rollbacks.

---

## Problem Statement

**What is the current state?**

- `**Rollback Plan:**` placeholder exists in FEATURE-TEMPLATE.md and BUG-TEMPLATE.md
- Troubleshooting guide has `git revert` snippets
- No documented process for:
  - When to rollback vs. fix forward
  - Version numbering for rollbacks
  - CHANGELOG format for reverted changes
  - Work item type for rollbacks
  - Tag handling (delete old tag? keep it?)
  - How to handle already-archived work items

**Why is this a problem?**

- Teams must make ad-hoc decisions under pressure during rollback scenarios
- Inconsistent version numbering after rollbacks
- CHANGELOG entries may be unclear
- Git history may be unclear

**What is the desired state?**

- Clear rollback policy with step-by-step process
- Consistent versioning after rollbacks
- Clear CHANGELOG entries

---

## Proposed Solution

Add rollback policy section to `version-control-workflow.md`:

**Proposed 6-Step Rollback Process:**
1. Create BUG work item describing the issue requiring rollback
2. Use `git revert <commit>` to create reverting commit (preserves history)
   - If conflicts, abort and revert manually
3. Keep original release tag (don't delete - it's part of history)
4. Release as new version (PATCH for same-day, MINOR if behavior changes)
5. CHANGELOG entry under "Removed" or "Changed" with "Reverts [version]" note
6. Original work items stay archived (don't move back)

**When to Rollback vs Fix Forward:**
- Rollback if: Issue is severe and fix is complex
- Fix forward if: Issue is minor or fix is simple
- User judgment call with guidance

**Version Numbering:**
- Same-day rollback: PATCH increment (v1.0.1)
- Next-day or behavior change: MINOR increment

**CHANGELOG Format:**
```markdown
## [1.0.1] - 2026-01-23

### Removed
- Reverts v1.0.0: [Feature name] - [Reason for rollback]
```

**Files Affected:**
- `framework/docs/process/version-control-workflow.md` - Add Rollback Policy section
- `templates/standard/framework/docs/process/version-control-workflow.md` - Sync changes

---

## Acceptance Criteria

- [ ] Rollback policy documented in version-control-workflow.md
- [ ] When to rollback vs fix forward guidance provided
- [ ] Version numbering rules for rollbacks defined
- [ ] CHANGELOG format for reverted changes shown
- [ ] Example rollback scenario documented
- [ ] Template synced to templates/standard/

---

## Notes

Discovered during FEAT-025 validation testing. FEAT-012 in project-hello-world tested rollback workflow and found no documented policy.

---

## Related

- FEAT-025: Manual Setup Validation (source of finding)
- TECH-068: Hotfix/emergency workflow
- TECH-069: Work item cancellation process

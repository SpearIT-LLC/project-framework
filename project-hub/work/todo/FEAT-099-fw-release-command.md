# Feature: /fw-release Command

**ID:** FEAT-099
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-01-30
**Theme:** Workflow

**Depends On:** DECISION-097, TECH-079

---

## Summary

Automate the release process with a `/fw-release` command that validates readiness, calculates version numbers, updates files, creates tags, and archives work items - reducing manual steps and enforcing quality gates.

---

## Problem Statement

**What problem does this solve?**

Current release process is manual with 20+ checklist items in version-control-workflow.md. This creates:
- Risk of forgotten steps (forgot to update CHANGELOG, forgot to move work items)
- Inconsistent release quality (no automated validation)
- Repetitive manual work (update multiple files with same version number)
- No enforcement of sizing policy (DECISION-097)
- No empty release guard (TECH-079)

**Who is affected?**

- Framework maintainers performing releases
- Users of projects built with the framework (will inherit command)
- Claude performing release operations

**Current workaround (if any):**

Manually follow 20-step checklist in version-control-workflow.md. Prone to errors and missed steps.

---

## Requirements

### Functional Requirements

- [ ] FR1: Validate done/ folder has at least one work item (TECH-079)
- [ ] FR2: Calculate next version from work item metadata (highest Version Impact)
- [ ] FR3: Warn if release size exceeds recommendations (DECISION-097)
- [ ] FR4: Update PROJECT-STATUS.md with new version and date
- [ ] FR5: Update CHANGELOG.md (move Unreleased → vX.Y.Z, add work items)
- [ ] FR6: Create git commit with release message
- [ ] FR7: Create annotated git tag (vX.Y.Z)
- [ ] FR8: Move work items from done/ to history/releases/vX.Y.Z/
- [ ] FR9: Move work item artifacts folders with parent items
- [ ] FR10: Optionally push to remote (prompt user)
- [ ] FR11: Display release summary and next steps

### Non-Functional Requirements

- [ ] Accuracy: Consistent results every time, no missed steps
- [ ] Repeatability: Same process for every release, deterministic behavior
- [ ] Security: No credential exposure, safe path handling
- [ ] Compatibility: Works with existing manual process, backward compatible
- [ ] Documentation: Clear usage guide, examples, troubleshooting

---

## Design

### Architecture Impact

**Files Added:**
- `.claude/commands/fw-release.md` - Command implementation (skill)
- `framework/tools/Invoke-Release.ps1` - PowerShell release automation script (if needed)

**Files Modified:**
- `framework/docs/process/version-control-workflow.md` - Add /fw-release documentation
- `framework/docs/ref/framework-commands.md` - Add command reference
- `framework/CHANGELOG.md` - Document new command

**Configuration Changes:**

Optional framework.yaml configuration:
```yaml
release:
  auto_push: false              # Auto push tags after release
  require_changelog_notes: true # Validate work items have CHANGELOG notes
  max_recommended_size: 8       # From DECISION-097
```

### Implementation Approach

**Two-Phase Approach:**

**Phase 1: Claude Command (Skill)**
- Implement as `.claude/commands/fw-release.md`
- Claude reads done/ items, calculates version, updates files
- Uses existing tools (Read, Edit, Bash)
- Good for: Rapid iteration, easy to test

**Phase 2: PowerShell Script (Optional Enhancement)**
- Extract logic to `framework/tools/Invoke-Release.ps1`
- Command calls script for core operations
- Good for: Manual releases, CI/CD integration, non-Claude workflows

**Start with Phase 1, add Phase 2 if demand warrants.**

### Key Components

**1. Pre-Release Validation**
```markdown
- Check done/ folder not empty (TECH-079)
- Check all items have Status=Done, Completed date
- Check work items have CHANGELOG notes sections
- Warn if size > recommended (DECISION-097)
- Prompt user to confirm version calculation
```

**2. Version Calculation**
```markdown
- Read all work items in done/
- Extract Version Impact field (MAJOR | MINOR | PATCH)
- Use highest impact: MAJOR > MINOR > PATCH
- Calculate next version from current (PROJECT-STATUS.md)
- Display calculated version, ask confirmation
```

**3. File Updates**
```markdown
PROJECT-STATUS.md:
- Update "Current Version: vX.Y.Z"
- Update "Last Updated: YYYY-MM-DD"

CHANGELOG.md:
- Find [Unreleased] section
- Rename to [vX.Y.Z] - YYYY-MM-DD
- Extract CHANGELOG notes from each work item
- Group by type (Added, Changed, Fixed, etc.)
- Reset [Unreleased] sections to "None"
- Update Version History table
```

**4. Git Operations**
```markdown
- Commit changes: "chore: Release vX.Y.Z - Description"
- Create annotated tag: git tag -a vX.Y.Z -m "Description"
- Optionally push: git push origin main --tags
```

**5. Work Item Archival**
```markdown
- Create history/releases/vX.Y.Z/ folder
- Move each work item: git mv work/done/ITEM-*.md history/releases/vX.Y.Z/
- Move artifacts folders: git mv work/done/ITEM-NNN/ history/releases/vX.Y.Z/
- Commit archival: "chore: Archive vX.Y.Z work items"
```

**6. Release Summary**
```markdown
Display:
- Version released: vX.Y.Z
- Items included: N work items
- CHANGELOG preview
- Tag created: Yes/No
- Pushed to remote: Yes/No
- Next steps: (manual verification, announce release, etc.)
```

### Alternative Approaches Considered

**Option 1: Fully Automated (No Prompts)**
- Pros: Zero user interaction, fastest
- Cons: Scary for users, no review before committing
- Decision: Too aggressive, users want control

**Option 2: Interactive with Dry-Run**
- Pros: User can preview changes before executing
- Cons: More complex implementation
- Decision: Good for future enhancement, not MVP

**Option 3: Separate Commands per Step**
- `/fw-release-validate`, `/fw-release-tag`, `/fw-release-archive`
- Pros: Fine-grained control, composable
- Cons: More complex, defeats purpose of automation
- Decision: Single command with optional flags better

---

## Dependencies

**Requires:**
- DECISION-097: Release Sizing Policy (for size warnings)
- TECH-079: Empty Release Guard (for validation)
- Artifacts pattern (TECH-097) - for moving artifact folders

**Blocks:**
- None (enhancement, doesn't block other work)

**Related:**
- TECH-098: Auto-Branching (could create release branch automatically)
- FEAT-089: Project Patterns (release strategy per project type)

---

## Testing Plan

### Unit Tests

- [ ] Test: Empty done/ folder → blocks with error
- [ ] Test: Version calculation (MAJOR > MINOR > PATCH)
- [ ] Test: CHANGELOG.md parsing and updating
- [ ] Test: PROJECT-STATUS.md version update
- [ ] Test: Work item archival (files and folders)

### Integration Tests

- [ ] Test: Full release with 1 item
- [ ] Test: Full release with 8 items (sweet spot)
- [ ] Test: Release with 15 items (triggers size warning)
- [ ] Test: Release with artifacts folders (move with parent)
- [ ] Test: Dry-run mode (preview without executing)

### Edge Cases

- [ ] Edge: done/ has only artifact folders, no work items
- [ ] Edge: Work item missing CHANGELOG notes section
- [ ] Edge: Current version is v1.9.9 → v2.0.0 (MAJOR bump)
- [ ] Edge: Git tag already exists (duplicate release)
- [ ] Edge: Uncommitted changes in working directory
- [ ] Edge: Remote push fails (network issue)

### Manual Testing Steps

1. **Setup:** Place 3 work items in done/ with CHANGELOG notes
2. **Execute:** Run `/fw-release`
3. **Verify:**
   - Validation passes
   - Version calculated correctly (e.g., v1.2.0 → v1.3.0)
   - PROJECT-STATUS.md updated
   - CHANGELOG.md updated with all 3 items
   - Git tag created
   - Work items moved to releases/v1.3.0/
   - Summary displayed

---

## Security Considerations

- [x] Input validation: Version numbers match semver pattern
- [x] No credential exposure: No passwords or tokens in logs
- [x] Path traversal prevention: Validate work item paths before moving
- [x] Error messages don't leak sensitive info
- [x] Follows principle of least privilege: Only git operations needed

---

## Documentation Updates

### Files to Update

- [ ] `framework/docs/process/version-control-workflow.md` - Add /fw-release section
- [ ] `framework/docs/ref/framework-commands.md` - Add command reference
- [ ] `framework/CLAUDE.md` - Mention automated release capability
- [ ] `framework/QUICK-START.md` - Update release instructions

### New Documentation Needed

- [ ] Usage examples (simple release, large release, dry-run)
- [ ] Troubleshooting guide (common errors and fixes)
- [ ] Manual override instructions (when to use manual process)

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->
<!-- User can say "continue to completion" to approve remaining steps at once. -->

- [ ] **PRE-IMPLEMENTATION REVIEW COMPLETED**
  - AI presents: Command behavior, validation logic, file updates, alternatives
  - User explicitly approves before proceeding

- [ ] Phase 1: Create fw-release.md skill
- [ ] Implement pre-release validation (empty guard, size warning)
- [ ] Implement version calculation from work item metadata
- [ ] Implement PROJECT-STATUS.md update logic
- [ ] Implement CHANGELOG.md update logic
- [ ] Implement git tag creation
- [ ] Implement work item archival (files + folders)
- [ ] Implement release summary display
- [ ] Test with 1 item, 8 items, 15 items (size warning)
- [ ] Test with artifacts folders
- [ ] Document in version-control-workflow.md
- [ ] Add to framework-commands.md reference
- [ ] Update CHANGELOG.md
- [ ] Phase 2 evaluation: PowerShell script needed?

---

## Rollout Plan

**Deployment Steps:**

1. Create `.claude/commands/fw-release.md` command
2. Document in workflow guides
3. Test with framework v1.3.0 release (current 9 items in done/)
4. Announce in CHANGELOG
5. Iterate based on feedback

**Rollback Plan:**

If issues found, continue using manual release process from version-control-workflow.md. Command is additive, doesn't break existing workflow.

---

## Success Metrics

**How do we know this feature is successful?**

- Metric 1: Zero missed release steps (validation catches all required updates)
- Metric 2: Consistent release quality (same process every time)
- Metric 3: Reduced manual checklist items (20 manual steps → 1 command)
- Metric 4: Adoption rate (used for 100% of releases after introduction)

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Added
- `/fw-release` command - Automated release process
  - Validates done/ folder not empty (TECH-079)
  - Calculates version from work item metadata
  - Warns if release size exceeds recommendations (DECISION-097)
  - Updates PROJECT-STATUS.md and CHANGELOG.md
  - Creates git tag
  - Archives work items to history/releases/vX.Y.Z/
  - Moves artifact folders with parent work items
  - Displays release summary
```

---

## Notes

**Design Philosophy:**

- **Guided automation** - Validate, prompt, execute (not fully automatic)
- **Fail-safe** - Block on errors, don't silently proceed
- **Transparent** - Show what will happen before doing it
- **Reversible** - Git makes everything reversible

**Integration with DECISION-097:**

Command enforces sizing policy:
- 10+ items: "⚠️ You have 12 items. Consider this is large for a single release."
- 15+ items: "⚠️ You have 17 items. Strongly recommend releasing or splitting by theme."
- User can override: "Proceed anyway? (y/n)"

**Future Enhancements:**

- Dry-run mode: `fw-release --dry-run`
- Version override: `fw-release --version 2.0.0`
- Skip prompts: `fw-release --yes`
- GitHub release creation: `fw-release --github-release`
- Release notes auto-generation: AI summarizes changes

---

## References

- `framework/docs/process/version-control-workflow.md` - Manual release checklist (lines 112-149)
- DECISION-097: Release Sizing Policy
- TECH-079: Empty Release Guard
- TECH-097: Artifacts Pattern (for folder movement)

---

**Last Updated:** 2026-01-30

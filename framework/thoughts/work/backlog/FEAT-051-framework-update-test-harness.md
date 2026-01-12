# Feature: Framework Update Test Harness

**ID:** FEAT-051
**Type:** Feature (Testing Infrastructure)
**Version Impact:** MINOR (adds testing capability)
**Status:** Backlog
**Created:** 2026-01-12
**Completed:** N/A
**Developer:** Gary Elliott

---

## Summary

Create a test harness with read-only baseline versions of the framework at each release version to enable regression testing of the framework update mechanism across all versions.

---

## Problem Statement

**What problem does this solve?**

When implementing DECISION-050 (Framework-as-Dependency), we need a version-agnostic update script that works consistently across all framework versions (v1→v2, v10→v11, etc.). To validate this:

1. **Version-agnostic testing** - Ensure update script works the same way across all versions
2. **Regression prevention** - Catch breaking changes to update mechanism
3. **Confidence in updates** - Validate update strategies (preserve, replace, interactive)
4. **Documentation of behavior** - Test cases serve as behavioral specification

Without a test harness:
- Manual testing is time-consuming and error-prone
- Can't validate version-agnostic design claim
- Risk breaking older projects when framework evolves
- No automated validation of update scenarios

**Who is affected?**

- Framework developers implementing update tooling
- Users updating their projects across framework versions
- Future maintainers validating framework changes
- Anyone debugging update issues

**Current workaround:**

Manual testing with ad-hoc framework copies - not reproducible or comprehensive

---

## Requirements

### Functional Requirements

- [ ] Maintain read-only baseline copies of framework at each released version
- [ ] Test harness can run update scenarios against any baseline version
- [ ] Support testing all three update strategies:
  - [ ] preserveCustomizations - Keep user modifications, update non-customized files
  - [ ] replaceAll - Replace everything with new framework version
  - [ ] interactive - Prompt for conflict resolution (simulated)
- [ ] Validate customization detection (`grep -r "<!-- CUSTOM:"`)
- [ ] Test clean update (no customizations)
- [ ] Test partial update (some files customized)
- [ ] Test full replacement (all files replaced)
- [ ] Generate test report showing pass/fail for each scenario
- [ ] Verify `.framework-version` file updated correctly
- [ ] Test version skipping (v2.0.0 → v4.0.0)

### Non-Functional Requirements

- [ ] Performance: Test suite completes in < 2 minutes
- [ ] Security: Tests run in isolated environment, don't affect production files
- [ ] Compatibility: Works on Windows (PowerShell 5.1+)
- [ ] Documentation: Test harness usage documented
- [ ] Maintainability: Easy to add new baseline versions
- [ ] Portability: Test harness can be packaged with framework

---

## Design

### Architecture Impact

**Files Added:**
- `framework/tests/` - Test infrastructure (new folder)
  - `framework/tests/README.md` - Test harness documentation
  - `framework/tests/baselines/` - Read-only framework versions
    - `framework/tests/baselines/v2.0.0/` - Framework at v2.0.0
    - `framework/tests/baselines/v2.5.0/` - Framework at v2.5.0
    - `framework/tests/baselines/v3.0.0/` - Framework at v3.0.0
  - `framework/tests/scenarios/` - Test case definitions
    - `clean-update.yaml` - No customizations
    - `preserve-customizations.yaml` - User modifications preserved
    - `replace-all.yaml` - Complete replacement
  - `framework/tests/Test-FrameworkUpdate.ps1` - Test runner script
  - `framework/tests/results/` - Test output (gitignored)

**Configuration Changes:**

None - test harness is self-contained

**Data Schema Changes:**

Test scenario definition format:
```yaml
# scenarios/clean-update.yaml
scenario:
  name: "Clean Update (No Customizations)"
  description: "Update from v2.5.0 to v3.0.0 with no user customizations"
  baseline_version: "2.5.0"
  target_version: "3.0.0"
  strategy: preserveCustomizations
  customizations: []
  expected_outcome:
    success: true
    files_updated: 15
    files_preserved: 0
    conflicts: 0
    framework_version: "3.0.0"
```

### Implementation Approach

**Phase 1: Baseline Infrastructure (MVP)**
1. Create `framework/tests/` folder structure
2. Copy framework snapshots to `baselines/` for v2.5.0, v3.0.0
3. Document baseline maintenance process
4. Create simple test script to validate baseline integrity

**Phase 2: Test Runner**
1. Implement `Test-FrameworkUpdate.ps1` script
2. Read test scenario definitions from YAML
3. Set up isolated test workspace
4. Run update script against baseline
5. Validate outcomes match expectations
6. Generate pass/fail report

**Phase 3: Test Scenarios**
1. Define 5-10 common update scenarios
2. Cover all update strategies
3. Test version skipping
4. Test edge cases (empty customizations, all files customized)

**Key Components:**

1. **Baseline Management**
   - Store compressed archives: `baselines/framework-v2.5.0.zip`
   - Extract to temp workspace for testing
   - Never modify baselines (read-only)
   - Document how to add new baselines when framework releases

2. **Test Runner**
   ```powershell
   # Example usage
   .\Test-FrameworkUpdate.ps1 -Scenario "clean-update"
   .\Test-FrameworkUpdate.ps1 -AllScenarios
   .\Test-FrameworkUpdate.ps1 -BaselineVersion "2.5.0" -TargetVersion "3.0.0"
   ```

3. **Isolated Test Workspace**
   - Create temp directory for each test run
   - Copy baseline to workspace
   - Apply test customizations (if any)
   - Run update script
   - Validate results
   - Clean up temp directory

4. **Validation Logic**
   - Verify file count matches expected
   - Check `.framework-version` file content
   - Validate customization tags preserved
   - Ensure no baseline corruption

### Alternative Approaches Considered

**Option A: Docker-based testing**
- Pros: Complete isolation, reproducible environment
- Cons: Requires Docker, overkill for file-based testing
- Decision: Rejected - too complex for this use case

**Option B: Git-based baselines (tags)**
- Pros: Leverage git history, no storage duplication
- Cons: Requires git knowledge, less portable
- Decision: Rejected - prefer self-contained approach

**Option C: Synthetic baselines (generated)**
- Pros: No storage overhead, can generate any version
- Cons: Complex generation logic, not true baselines
- Decision: Rejected - prefer authentic framework snapshots

---

## Dependencies

**Requires:**
- DECISION-050: Framework-as-Dependency Model (adopted)
- Framework Update Script (to be implemented in separate FEAT)
- Baseline versions at each framework release

**Blocks:**
- None - this is infrastructure for future validation

**Related:**
- DECISION-050: Framework Distribution Model
- FEAT-XXX: Framework Update Script (depends on this for testing)
- FEAT-005: ZIP Distribution (baselines can use ZIP packages)

---

## Testing Plan

### Unit Tests

- [ ] Test baseline extraction from archive
- [ ] Test workspace isolation (no cross-contamination)
- [ ] Test scenario YAML parsing
- [ ] Test customization detection logic
- [ ] Test cleanup after test run

### Integration Tests

- [ ] Run all defined scenarios
- [ ] Verify baseline integrity maintained
- [ ] Test concurrent test runs (if needed)
- [ ] Validate test report generation

### Edge Cases

- [ ] Missing baseline version - graceful error
- [ ] Corrupted baseline archive - detection and warning
- [ ] Invalid scenario definition - validation error
- [ ] Disk space exhausted - cleanup and error
- [ ] Test interruption (Ctrl+C) - partial cleanup

### Manual Testing Steps

1. Create test baselines for v2.5.0 and v3.0.0
2. Define 3 test scenarios (clean, preserve, replace)
3. Run test harness: `.\Test-FrameworkUpdate.ps1 -AllScenarios`
4. Verify test report shows expected results
5. Modify a baseline and verify test fails
6. Restore baseline and verify test passes

---

## Security Considerations

- [x] Input validation implemented - Validate scenario files, baseline paths
- [x] No credential exposure in logs - N/A (file operations only)
- [x] Path traversal prevention - Restrict to tests/ directory
- [x] Error messages don't leak sensitive info - Generic file operation errors
- [x] Follows principle of least privilege - Read baselines, write to temp workspace only

**Additional Considerations:**
- Baselines are read-only (immutable)
- Test workspace is isolated (temp directory)
- No network access required
- No execution of untrusted code

---

## Documentation Updates

### Files to Update

- [ ] DECISION-050-framework-distribution-model.md - Reference this feature
- [ ] framework/README.md - Link to test documentation
- [ ] framework/CONTRIBUTING.md (future) - Testing guidelines

### New Documentation Needed

- [ ] framework/tests/README.md - Test harness overview and usage
- [ ] Baseline maintenance guide - How to add new baselines at each release
- [ ] Test scenario authoring guide - How to write new test scenarios
- [ ] Troubleshooting guide - Common test failures and fixes

---

## Implementation Checklist

- [ ] Design reviewed and approved
- [ ] `framework/tests/` folder structure created
- [ ] Baseline storage strategy implemented
- [ ] Test runner script implemented
- [ ] Test scenario format defined
- [ ] 3-5 initial test scenarios written
- [ ] Test harness documentation written
- [ ] Manual testing completed
- [ ] Integration with CI/CD (if applicable)
- [ ] CHANGELOG.md updated

---

## Rollout Plan

**Deployment Steps:**

1. Create `framework/tests/` infrastructure
2. Document baseline creation process
3. Capture baselines for v2.5.0 and v3.0.0 (or current versions)
4. Implement basic test runner (Phase 1)
5. Add 3 core test scenarios
6. Validate test harness with manual runs
7. Document usage in framework/tests/README.md
8. Include in next framework release

**Rollback Plan:**

Remove `framework/tests/` folder - no impact on framework functionality

---

## Success Metrics

**How do we know this feature is successful?**

- Test harness runs all scenarios without errors
- Update script validated across 3+ framework versions
- Test suite catches at least 1 regression during development
- New baselines added for each framework release
- Test execution time < 2 minutes for full suite
- Zero false positives (tests pass when they should)
- Zero false negatives (tests fail when they should)

---

## Timeline

| Phase | Estimated Hours | Actual Hours | Status |
|-------|-----------------|--------------|--------|
| Design | 2 hours | TBD | Backlog |
| Baseline Infrastructure | 3 hours | TBD | Backlog |
| Test Runner Implementation | 5 hours | TBD | Backlog |
| Test Scenarios | 3 hours | TBD | Backlog |
| Documentation | 2 hours | TBD | Backlog |
| Testing & Validation | 2 hours | TBD | Backlog |
| **Total** | **17 hours** | **TBD** | |

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Added
- Framework Update Test Harness (FEAT-051)
  - Read-only baseline versions for regression testing
  - Test runner script for automated validation
  - Test scenarios covering update strategies (preserve, replace, interactive)
  - Version-agnostic testing infrastructure
  - Documentation for test harness usage and baseline maintenance
```

---

## Notes

**Design Principles:**

1. **Version-agnostic** - Same tests work across all framework versions
2. **Baseline immutability** - Never modify baselines, always read-only
3. **Isolation** - Each test run in isolated workspace
4. **Authenticity** - Use real framework snapshots, not synthetic versions
5. **Simplicity** - Start with minimal infrastructure, expand as needed

**Baseline Storage Strategy:**

Store baselines as compressed archives to save space:
```
framework/tests/baselines/
├── framework-v2.0.0.zip
├── framework-v2.5.0.zip
├── framework-v3.0.0.zip
└── README.md  # Explains baseline maintenance
```

**Test Scenario Example:**
```yaml
scenario:
  name: "Preserve Customizations"
  baseline_version: "2.5.0"
  target_version: "3.0.0"
  strategy: preserveCustomizations

  # Apply customizations before test
  customizations:
    - file: "framework/templates/work-items/FEATURE-TEMPLATE.md"
      tag: "<!-- CUSTOM: v2.5.0, 2026-01-10 -->"
      section: "## Custom Section"
      content: "User-specific content here"

  # Expected results after update
  expected_outcome:
    success: true
    files_updated: 12
    files_preserved: 1  # FEATURE-TEMPLATE.md
    conflicts: 0
    framework_version: "3.0.0"

  # Validate specific conditions
  validations:
    - check: "file_exists"
      path: ".framework-version"
      contains: "3.0.0"
    - check: "customization_preserved"
      path: "framework/templates/work-items/FEATURE-TEMPLATE.md"
      contains: "<!-- CUSTOM: v2.5.0, 2026-01-10 -->"
```

**Integration with Update Script:**

This test harness validates the update script (to be implemented separately). The update script should:
1. Accept baseline path and target version
2. Apply update strategy (preserve/replace/interactive)
3. Return exit code and summary
4. Update `.framework-version` file

The test harness wraps this and validates outcomes.

---

## References

- [DECISION-050: Framework Distribution Model](DECISION-050-framework-distribution-model.md)
- [DECISION-050 Flow Diagrams](DECISION-050-framework-distribution-flow-diagram.md) - See "Update Flow" diagram
- [FEAT-005: ZIP Distribution](feature-005-zip-distribution.md) - Baseline storage could use ZIP packages
- Testing inspiration: npm/pip package update testing strategies

---

**Last Updated:** 2026-01-12

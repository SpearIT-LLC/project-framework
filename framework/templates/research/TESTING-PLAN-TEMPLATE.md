# [Feature/Component] Testing Plan

**Purpose:** [What are we testing and why?]
**Scope:** [What's included/excluded from testing?]
**Test Date:** YYYY-MM-DD
**Tester:** [Name or Role]

---

## Table of Contents

1. [Test Objectives](#test-objectives)
2. [Test Type Classification](#test-type-classification)
3. [Test Categories](#test-categories)
4. [Success Criteria](#success-criteria)
5. [Test Execution Protocol](#test-execution-protocol)
6. [Test Results](#test-results)

---

## Test Objectives

### Primary Goals

**What are we testing?**
- [Specific capability or feature being tested]
- [Expected behavior or outcome]

**Why are we testing it?**
- [Business or technical reason]
- [Risk being mitigated]

**What defines success?**
- [Quantifiable success criteria]
- [Acceptance threshold]

---

## Test Type Classification

**Reference:** [ADR-002: Test Type Taxonomy](../../research/adr/002-test-type-taxonomy.md)

### Test Subject (Choose One)

- [ ] **Process Tests** - Testing workflow/documentation adherence
  - Artifacts: Planning documents, workflow traces
  - No code required
  - Example: "Does AI read security-policy.md before planning?"

- [ ] **Implementation Tests** - Testing code/output quality
  - Artifacts: Code, tests, running software
  - Code required
  - Example: "Does generated code use bcrypt correctly?"

### Traditional Type (Optional - use when helpful)

**Functional Tests:**
- [ ] Unit - Single component in isolation
- [ ] Integration - Multiple components together
- [ ] E2E - Complete user scenario

**Non-Functional Tests:**
- [ ] Performance - Speed, throughput, scalability
- [ ] Security - Vulnerabilities, exploits
- [ ] Usability - Can users actually use it?

**Quality Assurance Tests:**
- [ ] Regression - Old functionality still works
- [ ] Consistency - No contradictions
- [ ] Compliance - Meets requirements

### Automation Level (Optional)

- [ ] Automated - No human intervention
- [ ] Manual - Requires human judgment
- [ ] Hybrid - Automated execution, manual verification

---

## Test Categories

### Category 1: [Category Name]

**Purpose:** [What does this category test?]

**Tests in this category:**
- Test 1.1: [Test name]
- Test 1.2: [Test name]

---

#### Test 1.1: [Test Name]

**Test Type:** [Subject] / [Traditional Type] / [Automation Level]
**Example:** Process / Functional-Unit / Automated

**Test Prompt/Scenario:**
```
[Exact input or scenario description]
```

**Expected Behavior:**
1. [Expected step 1]
2. [Expected step 2]
3. [Expected step 3]

**Actual Behavior:**
_[To be filled during test execution]_

**Artifacts Required:**
- [ ] [File or output that must be created]
- [ ] [Evidence that must be collected]

**Success Indicators:**
- [ ] [Specific measurable indicator 1]
- [ ] [Specific measurable indicator 2]

**Failure Indicators:**
- [ ] [What would indicate failure 1]
- [ ] [What would indicate failure 2]

**Pass/Fail:** _[To be determined]_

**Notes:**
_[Observations, context, issues discovered]_

---

### Category 2: [Category Name]

**Purpose:** [What does this category test?]

_(Repeat test template for each test in category)_

---

## Success Criteria

### Overall Success Threshold

**This testing plan is successful if:**
- [ ] [X%] of tests pass
- [ ] All critical tests pass
- [ ] No blockers discovered
- [ ] [Other criteria]

**Critical tests (must pass):**
- Test X.Y: [Test name]
- Test X.Z: [Test name]

**Non-critical tests (should pass):**
- Test X.Y: [Test name]

---

### Per-Category Success Criteria

**Category 1:** [X/Y] tests must pass (Z% threshold)
**Category 2:** [X/Y] tests must pass (Z% threshold)

---

## Test Execution Protocol

### Setup

**Prerequisites:**
- [Required tools, environment, access]
- [Data or fixtures needed]
- [Configuration required]

**Setup Steps:**
```bash
# Commands to set up test environment
```

---

### Execution Steps

**For each test:**

1. **Prepare:**
   - Review test specification
   - Ensure prerequisites met
   - Clear state from previous tests

2. **Execute:**
   - Present test prompt/scenario exactly as written
   - Observe behavior WITHOUT guidance (for process tests)
   - Record observations in real-time

3. **Verify:**
   - Check all success indicators
   - Check for failure indicators
   - Collect required artifacts

4. **Record:**
   - Update "Actual Behavior" section
   - Mark success/failure indicators
   - Record Pass/Fail
   - Document notes/observations

---

### Cleanup

**Post-test steps:**
```bash
# Commands to clean up test environment
# Archive test artifacts
# Reset state
```

---

## Test Results

### Summary

**Total Tests:** [X]
**Passed:** [X] (X%)
**Failed:** [X] (X%)
**Skipped:** [X] (X%)

**Status:** [PASSED | FAILED | IN PROGRESS]

---

### Results by Category

**Category 1:** [X/Y] passed (Z%)
- Test 1.1: [PASS | FAIL | SKIP]
- Test 1.2: [PASS | FAIL | SKIP]

**Category 2:** [X/Y] passed (Z%)
- Test 2.1: [PASS | FAIL | SKIP]

---

### Critical Findings

**Failures (if any):**

#### Test X.Y: [Test Name] - FAILED
- **Issue:** [What failed]
- **Impact:** [Critical | High | Medium | Low]
- **Root Cause:** [Why it failed]
- **Recommended Fix:** [How to fix]

---

### Overall Assessment

**Status:** [PASSED | FAILED | BLOCKED | NEEDS REWORK]

**Key Findings:**
- [Finding 1]
- [Finding 2]

**Recommendations:**
- [Recommendation 1]
- [Recommendation 2]

**Next Steps:**
1. [Action item 1]
2. [Action item 2]

---

## AI Guidance Notes

**For AI Assistants executing this test plan:**

1. **Check test type classification** - If ambiguous, prompt user for clarification using ADR-002 guidance
2. **Create actual artifacts** - For process tests, create planning documents even if not implementing
3. **Stop at checkpoints** - For process tests, respect workflow checkpoints (don't bypass approvals)
4. **Record evidence** - Document which files you read, what lines, what you learned
5. **Self-report accurately** - Record actual behavior, not ideal behavior

**Ambiguous test type prompt:**
```
The test type seems ambiguous for Test X.Y. Please clarify:

Test Subject:
[ ] Process (testing workflow adherence)
[ ] Implementation (testing code quality)

[If Implementation] Traditional Type:
[ ] Functional (Unit/Integration/E2E)
[ ] Non-Functional (Performance/Security/Usability)
[ ] Quality Assurance (Regression/Consistency/Compliance)
```

---

## References

- [ADR-002: Test Type Taxonomy](../../research/adr/002-test-type-taxonomy.md)
- [testing-strategy.md](../../collaboration/testing-strategy.md)
- [workflow-guide.md](../../collaboration/workflow-guide.md)

---

**Template Version:** 1.0.0
**Last Updated:** 2025-12-29
**Maintained By:** Framework Team

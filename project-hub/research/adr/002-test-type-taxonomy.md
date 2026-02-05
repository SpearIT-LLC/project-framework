# ADR-002: Test Type Taxonomy for Framework Testing

**Status:** Accepted
**Date:** 2025-12-29
**Deciders:** Framework Team
**Impact:** Minor
**Scope:** Testing methodology, test plan templates
**Supersedes:** None

---

## Context

While executing FEAT-020 testing, we discovered ambiguity around what "type" of test we were conducting. Were we testing:
- **Process adherence** (does AI follow workflow)?
- **Implementation quality** (does AI write good code)?
- **Performance** (how fast can AI find information)?
- **Security** (can AI be bypassed)?

Without clear taxonomy, we risk:
- Creating tests that don't match their stated purpose
- Mixing concerns within single tests
- Unclear success criteria
- Difficulty comparing test results across projects

**Need:** Define standard test types that work across all framework levels and project types.

---

## Options

### Option 1: Simple Binary (Process vs Implementation)
**Description:** Two types only
- Process Tests: Workflow adherence, documentation reading
- Implementation Tests: Code quality, actual output

**Pros:**
- Simple to understand
- Covers FEAT-020 needs
- Easy to categorize

**Cons:**
- Doesn't cover performance, security, usability
- May need expansion later
- Doesn't map to traditional testing vocabulary (unit, integration, E2E)

### Option 2: Traditional Software Testing Types
**Description:** Use standard software testing taxonomy
- Unit, Integration, E2E, Performance, Security, UAT

**Pros:**
- Familiar to developers
- Well-documented in industry
- Comprehensive coverage

**Cons:**
- Designed for code testing, not process/documentation testing
- Doesn't distinguish "process" from "implementation"
- May be confusing when testing documentation (what's a "unit" of documentation?)

### Option 3: Three-Dimensional Taxonomy (Selected)
**Description:** Classify tests by three orthogonal dimensions:

**Dimension 1: Test Subject**
- Process Tests: Workflow, documentation adherence
- Implementation Tests: Code quality, actual output

**Dimension 2: Traditional Type (when applicable)**
- Functional: Unit, Integration, E2E
- Non-Functional: Performance, Security, Usability
- Quality Assurance: Regression, Consistency, Compliance

**Dimension 3: Automation Level**
- Automated: Can run without human intervention
- Manual: Requires human judgment
- Hybrid: Automated execution, manual verification

**Pros:**
- Flexible: Works for both process and implementation testing
- Comprehensive: Covers all test scenarios
- Clear: Each dimension has distinct purpose
- Extensible: Can add new types within dimensions

**Cons:**
- More complex than binary approach
- Requires documentation and examples
- May be overkill for simple projects

---

## Decision

We chose **Option 3: Three-Dimensional Taxonomy** because:

1. **Addresses root cause:** The confusion came from conflating "what we're testing" (process vs implementation) with "how we're testing it" (unit vs integration)
2. **Future-proof:** Can handle performance, security, and other test types without redesign
3. **Maps to FEAT-020:** Our existing tests fit cleanly into this taxonomy
4. **Maintains simplicity when needed:** Projects can use only dimensions they need

**Implementation:**
- Document taxonomy in test plan template
- Add "Test Type" field to all test specifications
- AI should prompt if test type is ambiguous

**Example Usage:**
```markdown
**Test Type:** Process / Functional-Unit / Automated
- Process: Testing workflow adherence
- Functional-Unit: Testing single component (doc reading)
- Automated: No human intervention needed
```

---

## Consequences

### Good
- Clear test categorization prevents confusion
- Easy to filter tests by type (run all automated tests, all security tests, etc.)
- Taxonomy scales from Minimal to Enterprise framework levels
- AI can prompt when test type is unclear

### Bad
- Requires learning three dimensions instead of simple "process vs implementation"
- Test specifications become more verbose
- Need to update all existing test templates

### Mitigation
- Provide decision tree for test type classification
- Create examples for each common combination
- Allow simplified notation (e.g., "Process-Unit" instead of full three dimensions when automation level is obvious)

### Revisit if
- Teams find three dimensions too complex in practice
- New test types emerge that don't fit dimensions
- Automated test tooling requires different taxonomy

---

## Test Type Classification Guide

### Dimension 1: Test Subject (REQUIRED)

**Process Tests:**
- **What:** Does system follow documented workflow/process?
- **Artifacts:** Planning documents, decision records, workflow traces
- **No code required:** Tests process adherence, not implementation
- **Example:** "Does AI read security-policy.md before implementing?"

**Implementation Tests:**
- **What:** Does implementation meet quality/functionality requirements?
- **Artifacts:** Code, tests, running software
- **Code required:** Tests actual implementation output
- **Example:** "Does generated code use bcrypt correctly?"

**Decision Rule:**
- If you're testing "did they follow the process?" → Process Test
- If you're testing "does the output work correctly?" → Implementation Test

### Dimension 2: Traditional Type (OPTIONAL - use when helpful)

**Functional Tests:**
- Unit: Single component in isolation
- Integration: Multiple components together
- E2E: Complete user scenario

**Non-Functional Tests:**
- Performance: Speed, throughput, scalability
- Security: Vulnerabilities, exploits, access control
- Usability: Can users actually use it?

**Quality Assurance Tests:**
- Regression: Old functionality still works
- Consistency: No contradictions/conflicts
- Compliance: Meets documented requirements

**Decision Rule:**
- Use this dimension when it clarifies test scope
- Skip when test is obviously one type
- Most helpful for Implementation Tests

### Dimension 3: Automation Level (OPTIONAL - document when relevant)

**Automated:** Can run without human intervention
**Manual:** Requires human judgment/interaction
**Hybrid:** Automated execution, manual verification

**Decision Rule:**
- Document when automation strategy matters
- Skip for simple tests where it's obvious

---

## Examples

### Example 1: FEAT-020 Test 1.1 (Security-Sensitive Feature)
```markdown
**Test Type:** Process / Functional-Unit / Automated
**Explanation:**
- Process: Testing if AI reads security-policy.md (workflow adherence)
- Functional-Unit: Testing single behavior (doc reading)
- Automated: AI self-test, no human needed
```

### Example 2: FEAT-020 Test 4.1 (Complete Workflow)
```markdown
**Test Type:** Process / Functional-Integration / Automated
**Explanation:**
- Process: Testing complete workflow adherence
- Functional-Integration: Multiple components (read docs, create plan, ask approval)
- Automated: AI self-test, no human needed
```

### Example 3: FEAT-020 Test 5.1 (Human Navigation)
```markdown
**Test Type:** Process / Non-Functional-Usability / Manual
**Explanation:**
- Process: Testing if humans can navigate documentation
- Non-Functional-Usability: Testing ease of use
- Manual: Requires actual human tester
```

### Example 4: Hypothetical Code Security Test
```markdown
**Test Type:** Implementation / Non-Functional-Security / Automated
**Explanation:**
- Implementation: Testing actual code output
- Non-Functional-Security: Testing for vulnerabilities
- Automated: Can run security scanner automatically
```

### Example 5: Hypothetical Performance Test
```markdown
**Test Type:** Process / Non-Functional-Performance / Automated
**Explanation:**
- Process: Testing how fast AI finds documentation
- Non-Functional-Performance: Testing speed
- Automated: Can measure time automatically
```

---

## AI Guidance: Detecting Ambiguous Test Types

**When AI should prompt for clarification:**

1. **Test description mentions both process and implementation**
   - ❌ Ambiguous: "Test that AI creates secure login code"
   - ✓ Clear: "Test that AI reads security-policy.md before creating login plan" (Process)
   - ✓ Clear: "Test that generated login code uses bcrypt" (Implementation)

2. **Test could be multiple types**
   - ❌ Ambiguous: "Test caching performance"
   - Could be: Process-Performance (how fast AI decides on caching?)
   - Could be: Implementation-Performance (how fast is cached code?)
   - **AI should ask:** "Are we testing how quickly AI makes the caching decision, or testing the performance of the implemented cache?"

3. **Automation level unclear**
   - ❌ Ambiguous: "Test user experience"
   - Could be: Automated (analytics tracking)
   - Could be: Manual (human observation)
   - **AI should ask:** "Should this be automated (metrics) or manual (human observation)?"

**Prompt Template:**
```
The test type seems ambiguous. Please clarify:

Test Subject:
[ ] Process (testing workflow/documentation adherence)
[ ] Implementation (testing code/output quality)

If Implementation, what traditional type?
[ ] Functional (Unit/Integration/E2E)
[ ] Non-Functional (Performance/Security/Usability)
[ ] Quality Assurance (Regression/Consistency/Compliance)

Automation:
[ ] Automated
[ ] Manual
[ ] Hybrid
```

---

## References

- [FEAT-020-TESTING-PLAN.md](../../work/doing/FEAT-020-TESTING-PLAN.md) - Original test plan
- [FEAT-020-TEST-RESULTS.md](../../work/doing/FEAT-020-TEST-RESULTS.md) - Test results using this taxonomy
- [testing-strategy.md](../../collaboration/testing-strategy.md) - General testing guidance

---

**Last Updated:** 2025-12-29
**Status:** Accepted and implemented in FEAT-020

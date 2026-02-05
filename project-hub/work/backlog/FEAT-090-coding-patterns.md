# Feature: Coding Strategy Patterns

**ID:** FEAT-090
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-01-27

---

## Summary

Document the recommended coding strategy progression (MVP → Tests → Refactor → Security → Performance) to guide incremental, quality-focused development.

---

## Problem Statement

**What problem does this solve?**

Developers often struggle with:
- When to optimize vs when to ship
- How much testing is enough
- Whether to refactor now or later
- Balancing speed with quality

Without clear guidance, projects either:
- Over-engineer early (premature optimization)
- Under-engineer throughout (technical debt accumulation)
- Lack consistent quality standards across codebase

**Who is affected?**

- Developers implementing features
- AI assistants making code recommendations
- Teams maintaining code quality standards

**Current workaround (if any):**

Implicit knowledge ("just know when it's good enough") or ad-hoc decisions.

---

## Requirements

### Functional Requirements

- [ ] Document the 5-phase coding strategy progression
- [ ] Define what "done" means for each phase
- [ ] Explain when to move to the next phase
- [ ] Provide phase-specific anti-patterns
- [ ] Include examples of applying the progression

### Non-Functional Requirements

- [ ] Compatibility: Aligns with framework's incremental philosophy
- [ ] Documentation: Clear enough for junior developers to follow
- [ ] Flexibility: Phases can be adapted based on context (spike vs production)

---

## Design

### The 5-Phase Progression

**Phase 1: MVP (Minimum Viable Product)**
- **Goal:** Get it working
- **Focus:** Core functionality only
- **Done when:** Feature demonstrates intended behavior
- **Skip:** Edge cases, error handling, optimization
- **Example:** Script runs successfully for happy path

**Phase 2: Tests**
- **Goal:** Establish confidence
- **Focus:** Test coverage for core functionality
- **Done when:** Critical paths have passing tests
- **Types:** Unit tests for functions, integration tests for workflows
- **Example:** Test harness validates core behavior

**Phase 3: Refactor**
- **Goal:** Improve code quality
- **Focus:** Readability, maintainability, organization
- **Done when:** Code follows standards, no duplication, clear structure
- **Keep:** Same functionality, same test results
- **Example:** Extract functions, rename variables, organize modules

**Phase 4: Security**
- **Goal:** Eliminate vulnerabilities
- **Focus:** Input validation, error handling, credential management
- **Done when:** Security checklist passes (see security-policy.md)
- **Check:** Injection risks, path traversal, credential exposure
- **Example:** Sanitize user input, validate file paths, secure secrets

**Phase 5: Performance**
- **Goal:** Optimize efficiency
- **Focus:** Speed, memory usage, resource consumption
- **Done when:** Performance meets requirements
- **Measure:** Profile before optimizing, verify improvements
- **Example:** Cache results, parallelize operations, reduce I/O

### When to Skip Phases

**For Spikes/POCs:**
- Stop after Phase 1 (MVP)
- Document findings and discard code

**For Internal Tools:**
- May skip Phase 5 (Performance) if "fast enough"
- Phases 2-4 still recommended

**For Production Code:**
- All phases required
- Phase 5 intensity depends on scale/load

### Implementation Approach

Create documentation in one of these locations:
- `framework/docs/patterns/coding-strategy-progression.md`
- `framework/docs/collaboration/coding-standards.md` (add section)

**Content structure:**
```markdown
# Coding Strategy Progression

## Overview
[Why this progression matters]

## The 5 Phases
[Each phase detailed with goals, criteria, examples]

## Decision Tree
[Flowchart or guide for when to skip/adapt phases]

## Anti-Patterns
[Common mistakes in each phase]

## Examples
[Real scenarios applying the progression]
```

---

## Dependencies

**Requires:**
- None

**Blocks:**
- None

**Related:**
- FEAT-089: Project Patterns - Architecture patterns (complementary)
- Existing docs: coding-standards.md, security-policy.md

---

## Acceptance Criteria

- [ ] Coding strategy progression documented
- [ ] All 5 phases explained with goals and done criteria
- [ ] Decision tree for when to skip/adapt phases
- [ ] Anti-patterns documented for each phase
- [ ] At least 2 end-to-end examples provided
- [ ] Synced to templates/starter/ for distribution
- [ ] Referenced from coding-standards.md or integrated into it

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Added
- Coding strategy progression documentation (MVP → Tests → Refactor → Security → Performance)
  - 5-phase approach to incremental, quality-focused development
  - Decision guidance for when to skip/adapt phases
  - Examples and anti-patterns for each phase
```

---

## Notes

Concept originated from [misc-thoughts-and-planning.md](../research/misc-thoughts-and-planning.md#Coding-Strategy).

**Original idea:**
```
## Coding Strategy
How should human or AI approach a problem?
- MVP (just get it working)
- Establish tests
- Refactor (improve code quality and organization but same functionality)
- Optimize for security
- Optimize for performance and efficiency
```

**Key Insight:** This progression prevents both premature optimization (Phase 5 too early) and reckless shipping (skipping Phases 2-4 for production code).

**Target Audience:** Human developers AND AI assistants making implementation decisions.

---

**Last Updated:** 2026-01-27

# Feature: Project Type Patterns

**ID:** FEAT-089
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-01-27

---

## Summary

Document architectural and design patterns specific to each project type (framework, application, library, toolbox) to guide developers toward proven practices.

---

## Problem Statement

**What problem does this solve?**

Developers starting a new project (or converting an existing one) don't have clear guidance on:
- Recommended architecture patterns for their project type
- Common design decisions and their trade-offs
- Best practices specific to frameworks vs applications vs libraries vs toolboxes

**Who is affected?**

- Developers setting up new projects
- Teams adopting the framework
- AI assistants recommending project structure

**Current workaround (if any):**

Users rely on:
- General software engineering knowledge
- Trial and error
- Inconsistent patterns across projects

---

## Requirements

### Functional Requirements

- [ ] Document 2-3 key patterns for each project type
- [ ] Include when to use each pattern and why
- [ ] Provide concrete examples for each pattern
- [ ] Store patterns in framework/docs/patterns/ (or similar location)

### Non-Functional Requirements

- [ ] Compatibility: Patterns should align with existing framework structure
- [ ] Documentation: Patterns should reference relevant framework docs
- [ ] Extensibility: Easy to add new patterns as they emerge

---

## Design

### Project Types to Cover

Based on `framework-schema.yaml` project.type enum:
1. **framework** - Process/methodology documentation
2. **application** - Standalone software application
3. **library** - Reusable code package
4. **toolbox** - Collection of utility scripts

### Pattern Categories (per project type)

**For each project type, document:**
- Architecture patterns (how to structure the codebase)
- Configuration patterns (how to handle settings)
- Documentation patterns (what docs are essential)
- Testing patterns (what testing approach makes sense)
- Deployment patterns (how to package/distribute)

### Example Patterns

**Framework Projects:**
- Pattern: Living documentation (docs that evolve with the framework)
- Pattern: Dogfooding (use the framework to manage itself)
- Pattern: Single source of truth registries (framework.yaml, INDEX.md)

**Application Projects:**
- Pattern: Configuration layers (defaults → environment → user)
- Pattern: Feature flags for gradual rollout
- Pattern: Layered architecture (UI → Business Logic → Data Access)

**Library Projects:**
- Pattern: Minimal dependencies (reduce consumer burden)
- Pattern: Semantic versioning strictness
- Pattern: Public vs internal API separation

**Toolbox Projects:**
- Pattern: Independent scripts (can run standalone)
- Pattern: Shared utilities module (common functions)
- Pattern: Consistent CLI interface across tools

### Implementation Approach

1. Create `framework/docs/patterns/` directory (or use existing if present)
2. Create pattern document per project type:
   - `framework/docs/patterns/framework-project-patterns.md`
   - `framework/docs/patterns/application-project-patterns.md`
   - `framework/docs/patterns/library-project-patterns.md`
   - `framework/docs/patterns/toolbox-project-patterns.md`
3. Each document contains 2-3 key patterns with:
   - Pattern name
   - When to use it
   - Why it works
   - Example implementation
   - Anti-patterns to avoid

---

## Dependencies

**Requires:**
- None

**Blocks:**
- None

**Related:**
- FEAT-052: Task-Based Project Templates - Workflow phases for project types (complementary)
- FEAT-090: Coding Patterns - Coding strategy progression (complementary)
- TECH-087: Project Type Selection - Uses project types defined in schema

---

## Acceptance Criteria

- [ ] Pattern documents created for all 4 project types
- [ ] Each project type has 2-3 documented patterns
- [ ] Each pattern includes: name, use case, rationale, example, anti-patterns
- [ ] Patterns synced to templates/starter/ for distribution
- [ ] INDEX.md updated with patterns section
- [ ] Glossary updated if new terms introduced

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Added
- Project type pattern documentation
  - Framework project patterns
  - Application project patterns
  - Library project patterns
  - Toolbox project patterns
  - Guides developers toward proven practices specific to their project type
```

---

## Notes

Concept originated from [misc-thoughts-and-planning.md](../research/misc-thoughts-and-planning.md#Project-Templates).

**Key Distinction:**
- **FEAT-052 (Task-Based Templates)**: What phases/workflow rigor for project types
- **FEAT-089 (Project Patterns)**: What architecture/design patterns for project types

**Inspiration:** "Identify a few key patterns for each of the project types we've identified but not too many at first."

**Best Practices Focus:** These patterns represent what the best developers use, guided by the framework, not arbitrary rules.

---

**Last Updated:** 2026-01-27

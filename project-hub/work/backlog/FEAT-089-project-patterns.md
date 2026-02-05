# Feature: Project Type Patterns

**ID:** FEAT-089
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-01-27

---

## Summary

Document architectural and design patterns specific to each project type (framework, application, library, toolbox) to guide developers toward proven practices. Includes defining typical **feature structure** for each project type to support roadmap planning and work organization.

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
- **Feature structure** (major feature areas that define the project)
- Architecture patterns (how to structure the codebase)
- Configuration patterns (how to handle settings)
- Documentation patterns (what docs are essential)
- Testing patterns (what testing approach makes sense)
- Deployment patterns (how to package/distribute)

### Feature Structure Definition

**Purpose:** Each project type has typical feature areas that:
1. Define the scope of what the project delivers
2. Provide structure for roadmap planning (FEAT-095)
3. Help organize backlog work items by feature area
4. Guide project definition and vision (FEAT-087)

**Example Feature Structures:**

**Framework Projects:**
- Workflow (kanban process, transitions, releases)
- Project Guidance (planning, roadmaps, reporting, organization)
- Developer Guidance (coding standards, methods, testing, security)

**Application Projects:**
- User Management (auth, profiles, permissions)
- Core Features (domain-specific functionality)
- Data Management (storage, sync, export/import)
- Integration (APIs, third-party services)

**Library Projects:**
- Core API (primary functionality)
- Extensions (optional add-ons)
- Documentation (API docs, examples, guides)
- Developer Tools (testing utilities, debugging)

**Toolbox Projects:**
- Script Collection (individual utilities)
- Shared Infrastructure (common functions, logging)
- Documentation (command reference, examples)
- Distribution (packaging, installation)

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
- DECISION-105: Retire Multi-Level Framework Concept - Clear positioning needed for pattern documentation

**Blocks:**
- None

**Related:**
- FEAT-052: Task-Based Project Templates - Workflow phases for project types (complementary)
- FEAT-090: Coding Patterns - Coding strategy progression (complementary)
- TECH-087: Project Type Selection - Uses project types defined in schema
- FEAT-095: AI-Guided Roadmap - Uses feature structure from patterns to organize roadmaps
- FEAT-087: Project Definition - Establishes feature structure during project setup

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

**Integration with Roadmap Planning (2026-02-01):**

Feature structure definition creates natural flow from project setup to roadmap planning:

1. **Project Definition (FEAT-087):** Vision + identify feature areas for project type
2. **Project Organization (FEAT-089):** Pattern guidance + scan backlog by feature area
3. **Roadmap Planning (FEAT-095):** Timeline-based roadmap showing feature progression (Q1: F1, F2; Q2: F3)

**Benefit:** Roadmap planning becomes faster and more data-driven because feature structure already exists. Vision questions happen once during project definition, not every roadmap cycle.

**Example:**
- Framework project establishes: Workflow, Project Guidance, Developer Guidance
- FEAT-095 roadmap then shows: "Q1: Project Guidance features (fw-roadmap, planning patterns)"
- Not: "What are your strategic themes?" (abstract synthesis every time)

---

**Last Updated:** 2026-02-01

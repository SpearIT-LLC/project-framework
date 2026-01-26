# Feature: Task-Based Project Templates

**ID:** FEAT-052
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-01-26

---

## Summary

Replace the size-based template concept (minimal/light/standard) with task-based project templates that guide appropriate rigor based on what you're building, not project size.

---

## Problem Statement

**What is the current state?**

- The old template system used size-based tiers (minimal, light, standard)
- This conflated two concerns: scaffolding structure and workflow rigor
- Project size doesn't map well to needed rigor (a small app may need more planning than a large script)
- The tiered templates were removed in favor of a single `starter/` template (DECISION-050)

**Why is this a problem?**

- Users don't know how much planning/documentation is appropriate for their project
- Different types of projects need different workflows regardless of size
- No guidance on what phases a project should go through

**What is the desired state?**

- Single scaffolding template (`starter/`) for all projects
- Task-based templates that define appropriate phases and rigor for different project types
- Framework workflow remains the same, but templates guide users through appropriate phases

---

## Proposed Solution

Create task-based project templates that define:
- Expected phases (as work items or a checklist)
- What documentation is appropriate at each phase
- What reviews/gates make sense
- Suggested WIP limits or time-boxes

**Example Templates:**

| Template | Use Case | Phases |
|----------|----------|--------|
| Quick Script | Single script, personal tool | Build → Document |
| Feature Enhancement | Adding to existing codebase | Requirements → Design review → Build → Test → Deploy |
| New Application | Greenfield project | Discovery → Architecture → MVP → Iterate → Stabilize |
| Migration/Refactor | Changing existing code | Audit → Plan → Execute incrementally → Verify |
| Research/Spike | Exploring unknowns | Define question → Time-box → Summarize → Decide |

**Implementation Approach:**

1. Templates could be markdown checklists in `framework/templates/project-types/`
2. Each template provides a starting set of work items or a checklist for the project type
3. User selects template during project setup or can adopt one later
4. Templates are guidance, not enforcement

---

## Acceptance Criteria

- [ ] At least 3 task-based templates defined (e.g., Quick Script, New Application, Research/Spike)
- [ ] Each template includes: purpose, expected phases, suggested work items, documentation guidance
- [ ] Templates stored in `framework/templates/project-types/` or similar location
- [ ] Setup process can optionally apply a project template
- [ ] Documentation updated to explain task-based template concept

---

## Notes

Concept originated from discussion about removing obsolete size-based templates (2026-01-26).

Key insight: The framework workflow is universal. What varies is how much rigor is appropriate, and that's determined by what you're building, not how big it is.

See also: [misc-thoughts-and-planning.md#Project-Templates](../research/misc-thoughts-and-planning.md#Project-Templates)

---

## Related

- DECISION-050: Framework Distribution Model (established single starter/ template)
- Removes: minimal/, light/, standard/ template folders (done 2026-01-26)

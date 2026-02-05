# Tech Debt: Add Claude Model Selection Guidance

**ID:** TECH-083
**Type:** Tech Debt
**Priority:** Low
**Version Impact:** PATCH
**Created:** 2026-01-23
**Theme:** Project Guidance

---

## Summary

Add guidance for selecting appropriate Claude models during project setup and for different work types/roles.

---

## Problem Statement

**What is the current state?**

- No guidance on which Claude model to use
- No per-project model configuration in template
- Users may not know models have different strengths

**Why is this a problem?**

- Suboptimal model selection for task type
- Opus better for complex planning, Sonnet for implementation, Haiku for quick tasks
- Cost/performance trade-offs not documented

**What is the desired state?**

- Clear guidance on model selection by role/task
- Optional: default model configuration in template
- Users can make informed choices

---

## Proposed Solution

**Option A: Advisory Documentation Only**
- Add "Model Selection" section to NEW-PROJECT-CHECKLIST.md
- Brief guidance on when to use Opus vs Sonnet vs Haiku
- No enforcement, users switch manually

**Option B: Role-Based Recommendations**
- Add `recommended_model` field to framework-roles.yaml
- Document model recommendations per role/phase
- Still advisory, not enforced

**Option C: Template Configuration**
- Add `.claude/settings.json` to template with default model
- Document how to change it
- Projects start with a sensible default

**Considerations:**
- Most users stick with one model per session
- Frequent switching adds friction
- Guidance should be practical, not prescriptive
- Model availability and pricing may change

---

## Acceptance Criteria

- [ ] Model selection guidance documented somewhere accessible
- [ ] Role/task recommendations provided
- [ ] Users can easily find and understand the guidance

---

## Notes

Raised during TECH-069 session. Deferred for later consideration - need to think through practical implications.

---

## Related

- framework-roles.yaml (potential location for role recommendations)
- NEW-PROJECT-CHECKLIST.md (potential location for setup guidance)

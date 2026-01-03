# Framework Structure Retrospective

**Date:** 2026-01-02
**Participants:** Gary Elliott, Claude Code
**Type:** Collaborative Discussion
**Related Work Items:** FEAT-025 (Manual Setup Validation)
**Framework Version:** v2.2.5

---

## Context

This retrospective was triggered by FEAT-025 brainstorming, which revealed the need to step back and gain clarity on what we're delivering and how before proceeding with implementation.

**Purpose:** Understand where we are, define where we're going, and decide how to get there.

---

## What Went Well

### 1. File-Based Kanban Workflow ✅
- Git-friendly, no external tools required
- Visual in file explorer, AI can navigate easily
- Successfully used on HPC project and framework project

### 2. Multi-Level Framework (Minimal/Light/Standard) ✅
- Acknowledges different project needs
- HPC project validated Standard level
- Provides upgrade path

### 3. AI Integration (CLAUDE.md + ADR-001) ✅
- Clear expectations for AI behavior
- Checkpoint policy (ADR-001) prevents runaway implementations
- User maintains control

### 4. Template System ✅
- Reduces decision fatigue
- Copy-paste simplicity
- Consistent structure across work items

### 5. Dogfooding ✅
- Applying framework to itself surfaces real issues
- Discovered Target Version staleness, numbering collisions
- Validates workflow in practice

---

## What Didn't Go Well

### 1. No MVP Definition ❌
**What happened:** Built features iteratively without defining minimum viable product

**Impact:**
- Scope creep (19 templates - all needed?)
- Hard to explain "what is this?" concisely
- Complexity barrier for new users

**Lesson:** MVP definition is foundation, not optional

### 2. Structure Too Deep ❌
**What happened:** Paths like `thoughts/project/planning/backlog/` are 4 levels deep

**Impact:**
- Cognitive load navigating files
- Longer paths in references
- File operations more verbose

**Lesson:** Flatten hierarchies - every level must earn its place

### 3. Template Proliferation Without Validation ❌
**What happened:** Created 19 templates without testing if all were needed

**Impact:**
- New users potentially overwhelmed
- Maintenance burden
- Unclear which are essential vs optional

**Lesson:** Add templates when pain point proven, not preemptively

---

## Key Insights

### Evolution of Goals
**Original focus (v1-v2):** Framework mechanics (structure, workflow, templates)

**Evolved focus (v3):** User experience and onboarding
- Speed to first success
- Quick and positive first experience
- Intuitive guidance discovery
- Clear learning paths (AI and human)

**This is natural progression:** First prove concepts work, then make them usable by others.

### Framework Development vs Framework Usage
**Realization:** We've never actually applied this framework template to a fresh project yet.
- Framework grew organically from HPC project
- Extracted practices into standalone framework
- Framework has been evolving separately
- **We're building for an experience we haven't validated**

**Implication:** Need to validate with real usage (hello-world project)

### Target Audience Clarity
**Decision:** Solo developers and small teams (1-3 people) is the sweet spot
- File-based Kanban doesn't scale beyond this
- Larger teams should use tools like Jira
- Don't try to be everything to everyone

---

## Decisions Made

### DECISION-001: One Framework → One Project (MVP)
**What:** Defer multi-project support until proven need

**Rationale:**
- Simplifies git workflow (no nested repos)
- Simpler user mental model
- Reduces structural complexity
- User wanting multiple projects downloads framework multiple times

**Trade-off:** User must manage framework updates across multiple copies

**Alternative considered:** Multi-project with shared framework folder
- **Rejected:** Complex git issues, unvalidated use case

**Date:** 2026-01-02

### DECISION-002: Framework IS a Project
**What:** Framework uses same structure it recommends

**Rationale:**
- Dogfooding validates the framework
- Clear separation: framework/ and project-*/ folders at same level
- No mental model shift between "framework stuff" and "project stuff"
- User projects reference framework rather than duplicating it

**Date:** 2026-01-02

### DECISION-003: Focus on Standard Level Only (MVP)
**What:** Build only Standard framework level for v3.0.0

**Rationale:**
- Reduces scope, maintains focus
- Largest deliverable = most learning
- Minimal and Light can come later
- Can extract smaller levels from working Standard

**Trade-off:** Delays lighter-weight options

**Date:** 2026-01-02

### DECISION-004: Reorganize Before Building
**What:** Restructure current project before adding hello-world

**Rationale:**
- Current structure doesn't support vision
- Better to fix foundation before building on it
- Breaking change accepted for v3.0.0

**Approach:**
1. Map current → target structure
2. Create migration plan
3. Execute reorganization
4. Build hello-world as validation

**Date:** 2026-01-02

### DECISION-005: All Templates Essential (for now)
**What:** Presume all 19 templates are essential during reorganization

**Rationale:**
- Don't lose focus on structure reorganization
- Can audit templates later
- Better to have and not use than need and not have (for MVP)

**Revisit:** After v3.0.0 structure stable

**Date:** 2026-01-02

### DECISION-006: Validate with Hello-World Shell
**What:** Build hello-world project structure (no code implementation)

**Success criteria:**
- Can navigate easily
- Documentation clear
- Workflow makes sense
- "AS IF freshly unzipped" test

**Date:** 2026-01-02

---

## Questions Resolved

**Q: What prompted this retrospective?**
A: Wanting to step back and get clarity on what and how we're delivering before diving into FEAT-025.

**Q: What's the core value for first-time users?**
A: Speed to first success. Fast, positive first experience.

**Q: Why would users want multiple projects under one framework?**
A: Couldn't articulate clear scenario. Deferred until proven need.

**Q: What problem does the proposed structure solve?**
A: Framework and projects treated the same (both are projects), clearer separation, scalable, project guidance can override framework.

**Q: How would project reference framework?**
A: Project's CLAUDE.md references ../framework/ for standards (details TBD during implementation).

---

## Next Actions

### Immediate (This Session)
1. ✅ Complete retrospective
2. ⏭️ Document decisions (this file)
3. ⏭️ Map current → target structure
4. ⏭️ Create migration plan
5. ⏭️ Record session history

### Short Term (Next Session)
1. Execute reorganization
2. Build hello-world shell
3. Validate structure
4. Address FEAT-025

### Future
1. Create retrospective template (new work item needed)
2. Audit templates for MVP (after structure stable)
3. External user testing

---

## Collaboration Principles Reinforced

**Critical lesson from this retrospective:**

**We don't make things up. We deliver facts and can offer opinions based on known facts.**

This applies equally to:
- Code implementation
- Documentation
- Retrospectives
- Planning

**Example violation:** Stating "2-4 hour setup time" without measurement
**Correction:** Acknowledge we don't have data, ask for real experience

---

## Appendices

### A. Referenced Documents
- [FEAT-025-brainstorming.md](../work/todo/FEAT-025-brainstorming.md)
- [README.md](../../../README.md) - Original goals (Philosophy section)
- [PROJECT-STATUS.md](../../../PROJECT-STATUS.md)

### B. Metrics (Known Facts Only)
- Framework Version: v2.2.5
- Templates: 19
- Collaboration Guides: 7
- Process Docs: 3
- Pattern Docs: 3
- Projects Using Framework: 2 (HPC, framework itself)
- External Users: 0
- Projects Created from Template: 0 (framework not yet used on fresh project)

---

**Retrospective Completed:** 2026-01-02
**Format:** Collaborative discussion (not monologue document)
**Status:** ✅ Complete - Ready for Planning Phase

**Key Takeaway:** Natural evolution from "make it work" to "make it usable" - we're at the pivot point.

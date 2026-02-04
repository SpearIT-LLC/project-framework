# Decision: Retire Multi-Level Framework Concept

**ID:** DECISION-105
**Type:** Decision
**Priority:** High
**Version Impact:** MAJOR
**Created:** 2026-02-04
**Theme:** Distribution & Onboarding
**Planning Period:** Sprint D&O 2

---

## Summary

Formally retire the "Minimal/Light/Standard" framework levels concept and replace it with a single unified framework that adapts through project templates and AI guidance (FEAT-089).

---

## Context

**What triggered this decision?**

During FEAT-095 completion, discovered extensive references to the obsolete "multi-level framework" concept (Minimal/Light/Standard) throughout documentation. This concept was previously abandoned in favor of a unified framework approach, but documentation was never fully updated.

**What are the constraints?**

- 117+ files contain references to Minimal/Light/Standard framework levels
- Core user-facing documentation (README, QUICK-START, CLAUDE.md) still describes the old model
- FEAT-089 (Project Organization) depends on having clean positioning
- Historical files should remain unchanged (archived context)
- Must maintain backward compatibility during transition

**Current State:**

The framework is currently positioned as:
> "A comprehensive, multi-level project management framework designed to bring structure, consistency, and AI integration to software projects of any size."

This positioning is confusing because:
1. "Multi-level" refers to an abandoned implementation model
2. The framework IS comprehensive for ALL projects, not just large ones
3. We adapt to project needs through templates + AI guidance, not separate framework "levels"

---

## Options Considered

### Option A: Keep Multi-Level Concept, Improve Documentation

**Description:** Retain the Minimal/Light/Standard model and fix documentation to accurately reflect it.

**Pros:**
- No conceptual change required
- Existing template structure can remain
- Users familiar with levels don't need to adapt

**Cons:**
- The concept was already abandoned (decision already made)
- Adds artificial complexity (users must "choose a level")
- Contradicts unified framework vision
- Requires maintaining 3 separate documentation sets
- Doesn't align with FEAT-089 (AI-guided project organization)

### Option B: Unified Framework with Project Templates (Recommended)

**Description:** One framework that adapts to ANY project through:
1. **Project templates** - Scaffolding for different project types/sizes (FEAT-089)
2. **AI guidance** - `/fw-setup`, `/fw-organize` help users configure appropriately
3. **Progressive adoption** - Users start minimal, add structure as needed

**Pros:**
- ✅ Simpler mental model: "One framework, adapts to your needs"
- ✅ Aligns with FEAT-089 vision (AI-guided project organization)
- ✅ Eliminates "which level do I choose?" decision paralysis
- ✅ Emphasizes adaptability over rigid tiers
- ✅ Matches how users actually work (start small, grow organically)
- ✅ Reduces documentation burden (one framework to document)

**Cons:**
- Requires documentation overhaul (117+ file references)
- Requires clear positioning statement
- Existing users need migration guidance (minor, concept was already abandoned)

### Option C: Defer Decision, Document Both Models

**Description:** Acknowledge both models exist, document transition plan, implement gradually.

**Pros:**
- Avoids immediate documentation changes
- Provides time for careful migration

**Cons:**
- Perpetuates confusion
- Delays FEAT-089 clarity
- Requires maintaining dual documentation
- Increases cognitive load on new users

---

## Decision

**Chosen Option:** Option B - Unified Framework with Project Templates

**Rationale:**

1. **Already decided**: The multi-level concept was abandoned; we're just formalizing it
2. **Clearer positioning**: "One framework that adapts" > "Choose between 3 levels"
3. **Enables FEAT-089**: Project templates + AI guidance is the RIGHT way to handle project variability
4. **Reduces complexity**: Users don't choose a "level", they use framework features as needed
5. **Natural progression**: Start minimal (README), add structure (work items), grow organically

**Approved Positioning Statements:**

Two versions approved for different contexts:

**Version 1 (Concise)** - For README opening, elevator pitch, quick reference:
> The **SpearIT Project Framework** is a file-based workflow and AI collaboration partner for solo developers and small teams building software or documentation projects.

**Version 2 (Verbose)** - For detailed intro, About sections, comprehensive description:
> The **SpearIT Project Framework** is a file-based workflow and AI collaboration partner for solo developers and small teams. Using markdown files and scripting tools, it provides Kanban work tracking, strategic roadmaps, AI-guided planning, and documentation standards—without requiring external services or databases.

**Usage guidance:**
- README.md "What Is This?" section: Use Version 1 as opening line
- Elevator pitch / Quick Start: Use Version 1 only
- Detailed intro / About pages: Use Version 2
- Implementation specifics (which version in which file) determined during TECH-106

**Key principles:**
- **Adaptive, not tiered**: Framework adapts to project needs, not predefined levels
- **Progressive adoption**: Start simple, add structure as value becomes clear
- **AI-guided**: Tools like `/fw-setup` and `/fw-organize` help users configure appropriately
- **One framework**: Same core concepts (work items, workflow, documentation) scale naturally

**Trade-offs Accepted:**

- Documentation overhaul required (117+ files to update)
- Historical references remain (acceptable—they're archived context)
- Need clear migration messaging (minimal impact—concept was already abandoned)

---

## Consequences

**What changes as a result of this decision?**

1. **User-facing documentation** updated to remove Minimal/Light/Standard references
2. **Positioning statement** changed from "multi-level framework" to "adaptive framework"
3. **FEAT-089** unblocked - clear foundation for project template work
4. **README.md** rewritten with clearer value proposition
5. **QUICK-START.md** simplified (no "choose your level" step)
6. **CLAUDE.md** updated (remove level-based instructions)
7. **GLOSSARY.md** updated (already partially complete)

**What follow-up work is needed?**

- [ ] TECH-106: Remove Minimal/Light/Standard references from active docs
  - README.md (root)
  - framework/README.md
  - QUICK-START.md
  - framework/CLAUDE.md + templates/starter/framework/CLAUDE.md
  - framework/INDEX.md
  - framework/docs/ref/GLOSSARY.md (complete multi-level removal)
  - workflow-guide.md
  - architecture-guide.md
  - PROJECT-STRUCTURE-STANDARD.md
- [ ] Update FEAT-089 prerequisite to include DECISION-105
- [ ] Note DECISION-105 finding in FEAT-095 work item
- [ ] Document positioning statement in framework/docs/collaboration/ or ROADMAP.md

---

## Implementation Checklist

- [x] **PRE-IMPLEMENTATION REVIEW COMPLETED**
  - Decision context documented
  - Options evaluated with pros/cons
  - User approved unified framework approach

- [ ] All options evaluated with pros/cons
- [ ] Decision made and rationale documented
- [ ] Consequences identified
- [ ] Follow-up work items created (TECH-106)
- [ ] Decision record reviewed and approved
- [ ] FEAT-089 updated with prerequisite
- [ ] FEAT-095 updated with finding note
- [ ] CHANGELOG.md updated (at release)

---

## Related

- **FEAT-089**: Project Organization (depends on this decision for clear positioning)
- **FEAT-095**: AI-Guided Roadmap Creation (discovered this issue during completion)
- **TECH-106**: Execute documentation cleanup (follow-up work item)
- Historical context: v3.0.0 introduced "Standard" structure (see FEAT-026)

---

## Notes

**Historical Context:**

The Minimal/Light/Standard concept emerged from FEAT-026 (v3.0.0) as a way to handle project variability. It made sense at the time, but created unnecessary complexity:
- Users struggled with "which level do I need?"
- Documentation burden (3x the work)
- Artificial boundaries (what if you need "Light + some Standard features"?)

**Better approach:** One framework with progressive adoption. Users naturally start minimal (README) and add structure as they see value.

**Why now?** FEAT-095 work exposed how deeply embedded this concept is. Better to formally retire it before FEAT-089 work begins.

---

**Last Updated:** 2026-02-04

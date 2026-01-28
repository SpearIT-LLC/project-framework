# Feature: Framework Glossary

**ID:** FEAT-088
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-01-27

---

## Summary

Create a comprehensive glossary (GLOSSARY.md) defining framework-specific terminology and concepts, placed in framework/docs/ref/ and linked from QUICK-START.md.

---

## Problem Statement

**What problem does this solve?**

The framework uses domain-specific terminology (work item, kanban, SsoT, WIP limit, checkpoint, transition, spike, POC, etc.) that may be unfamiliar to new users or need consistent interpretation by AI assistants.

**Who is affected?**

- New users learning the framework
- AI assistants interpreting framework documentation
- Teams needing shared vocabulary

**Current workaround (if any):**

Terms are defined inline throughout documentation, leading to:
- Inconsistent definitions
- Redundant explanations
- No single reference for terminology
- CLAUDE.md files unnecessarily large with term definitions

---

## Requirements

### Functional Requirements

- [ ] Create GLOSSARY.md in framework/docs/ref/
- [ ] Define all framework-specific terms alphabetically
- [ ] Include cross-references to detailed documentation
- [ ] Link glossary from QUICK-START.md
- [ ] Update CLAUDE.md files to reference glossary instead of defining terms inline

### Non-Functional Requirements

- [ ] Compatibility: All documentation remains functional
- [ ] Documentation: INDEX.md updated with glossary entry
- [ ] DRY: Glossary becomes single source of truth for term definitions

---

## Design

### Terms to Include (minimum)

**Workflow Terms:**
- Backlog, Todo, Doing, Done
- Work Item (Feature, Bug, Tech Debt, Spike, Decision)
- Transition
- WIP Limit
- Checkpoint
- Pre-implementation review

**Project Terms:**
- Framework (as in "this framework")
- Project type (framework, application, library, toolbox)
- Deliverable type (code, documentation, hybrid)
- Project hub
- Session history

**Process Terms:**
- Kanban
- SsoT (Single Source of Truth)
- DRY (Don't Repeat Yourself)
- POC (Proof of Concept)
- Spike
- Bootstrap block

**File/Structure Terms:**
- CLAUDE.md
- framework.yaml
- PROJECT-STATUS.md
- CHANGELOG.md

### Implementation Approach

**Format:**

```markdown
# Glossary

## B

### Backlog
Work items that have been defined but not yet prioritized for immediate work. Located in `project-hub/work/backlog/`.

See: [Workflow Guide](../collaboration/workflow-guide.md#workflow-phases)

### Bootstrap Block
Critical instructions that AI assistants must read and execute at the start of every session.

See: [CLAUDE.md](../../CLAUDE.md)

## K

### Kanban
File-based workflow system using folders to represent work states (backlog, todo, doing, done).

See: [Workflow Guide](../collaboration/workflow-guide.md)
```

**Location:**
- `framework/docs/ref/GLOSSARY.md`

**Link from:**
- `QUICK-START.md` - Section 11 (Getting Help)
- `framework/INDEX.md` - Reference section

---

## Dependencies

**Requires:**
- None

**Blocks:**
- None

**Related:**
- TECH-061: CLAUDE.md Duplication Review - Glossary enables term definitions to be removed from CLAUDE.md
- FEAT-052: Task-Based Project Templates - May reference glossary terms

---

## Acceptance Criteria

- [x] GLOSSARY.md created in framework/docs/ref/
- [x] Minimum 20 terms defined with cross-references (30 terms delivered)
- [x] Linked from QUICK-START.md Section 11
- [x] Added to framework/INDEX.md
- [x] Synced to templates/starter/ for distribution
- [x] Documentation updated in CHANGELOG.md

**Status:** Done
**Completed:** 2026-01-28

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Added
- Framework glossary (GLOSSARY.md) defining terminology and concepts
  - Located in framework/docs/ref/
  - Linked from QUICK-START.md
  - Single source of truth for term definitions
```

---

## Notes

Concept originated from [misc-thoughts-and-planning.md](../research/misc-thoughts-and-planning.md#DRY-Documentation).

Key insight: "Add glossary for human use (Quick-start.md?)" - helps both humans and AI maintain consistent terminology.

**Synergy with TECH-061:** Glossary enables CLAUDE.md cleanup by becoming the authority for term definitions, reducing CLAUDE.md size.

---

**Last Updated:** 2026-01-27

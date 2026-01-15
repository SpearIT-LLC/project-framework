# DOC-058: Workflow Transitions Documentation

**ID:** DOC-058
**Type:** Documentation
**Priority:** High
**Status:** Done
**Created:** 2026-01-15
**Consolidates:** DOC-054, FEAT-057

---

## Summary

Add comprehensive workflow transitions section to workflow-guide.md that covers:
1. Valid/invalid state transition rules (from DOC-054)
2. Per-transition checklists (from FEAT-057)
3. Machine-readable policy reference via framework.yaml (from FEAT-057)

**Problem:** AI violates workflow in two ways:
- Invalid transitions (e.g., backlog → doing, skipping todo)
- Missing transition procedures (e.g., skipping Pre-Implementation Review when moving to doing/)

---

## Problem Statement

**Issues identified:**
- DOC-053: AI moved item directly backlog → done, bypassing workflow
- TECH-043: AI moved item to doing/ without Pre-Implementation Review

**Root causes:**
- No explicit valid/invalid transition matrix
- Transition checklists buried ~1200 lines into workflow-guide.md
- No trigger mechanism when AI moves files

**Who is affected:**
- AI assistants (need clear rules and triggers)
- Users (expect consistent workflow behavior)
- Validation tooling (TECH-055 will use these rules)

---

## Solution

### Part 1: Transition Rules Matrix (from DOC-054)

Add explicit table of valid/invalid transitions:

| From | To | Valid? | Reason |
|------|----|----|--------|
| backlog | todo | ✅ | Standard flow - committing to work |
| backlog | doing | ❌ | Must commit to work (todo) first |
| backlog | done | ❌ | Must be worked on |
| todo | doing | ✅ | Starting work |
| todo | backlog | ✅ | Deprioritizing |
| todo | done | ❌ | Must actually do the work (doing first) |
| doing | done | ✅ | Completing work |
| doing | todo | ✅ | Pausing work |
| doing | backlog | ❌ | Use todo as intermediate state |
| done | history | ✅ | Post-release archival |
| done | * | ❌ | No reopening (create new work item) |

### Part 2: Per-Transition Checklists (from FEAT-057)

When moving a work item, complete the checklist for the target folder:

**→ backlog/**
- [ ] Work item created from template
- [ ] ID assigned (scan all work/ locations first)

**→ todo/**
- [ ] User has approved the work
- [ ] Priority set

**→ doing/**
- [ ] Transition is valid (check matrix)
- [ ] Read ENTIRE work item document
- [ ] Identify open questions (TODO, TBD, DECIDE)
- [ ] Present pre-implementation summary to user
- [ ] Wait for confirmation before implementing

**→ done/**
- [ ] Transition is valid (check matrix)
- [ ] All completion criteria in work item are checked
- [ ] Status field updated to "Done"

**→ history/**
- [ ] Work has been released/deployed
- [ ] Move after release only

### Part 3: Policy Reference (from FEAT-057)

**framework.yaml addition:**
```yaml
policies:
  workflow: framework/docs/collaboration/workflow-guide.md
  onTransition: framework/docs/collaboration/workflow-guide.md#workflow-transitions
```

**CLAUDE.md instruction:**
```markdown
## Workflow Transitions

When moving work items between workflow folders, read and follow the `onTransition` policy in `framework.yaml` before proceeding.
```

### Chain of Responsibility

```
CLAUDE.md (instruction to check framework.yaml on transitions)
    ↓
framework.yaml (points to onTransition policy location)
    ↓
workflow-guide.md#workflow-transitions (rules + checklists)
```

---

## Implementation Plan

1. Add "Workflow Transitions" section to workflow-guide.md
   - Add transition validity matrix
   - Add per-transition checklists
   - Consolidate existing Step 7.5 content

2. Update framework.yaml
   - Add `policies` section
   - Add `onTransition` reference

3. Update framework-schema.yaml
   - Add `policies` section to schema

4. Update framework/CLAUDE.md
   - Add workflow transitions instruction

5. Test with a real work item transition

---

## Completion Criteria

- [x] workflow-guide.md has "Workflow Transitions" section with:
  - [x] Valid/invalid transition matrix
  - [x] Per-transition checklists
  - [x] Invalid transition handling example
- [x] framework.yaml has `policies.onTransition` reference
- [x] framework-schema.yaml updated for policies section
- [x] framework/CLAUDE.md has workflow transitions instruction
- [x] Tested: AI follows rules when moving item (this work item transition: todo → doing)
- [ ] Changes committed

---

## Dependencies

**Requires:**
- workflow-guide.md exists ✓
- framework.yaml exists ✓

**Enables:**
- TECH-055 (validation script - uses these rules)

**Related:**
- DOC-053 - Workflow violation that exposed transition gap
- TECH-043 - Implementation that exposed checklist gap
- FEAT-037 - Established framework.yaml pattern

---

## Notes

**Why consolidate DOC-054 + FEAT-057:**
Both addressed workflow transition problems from different angles. DOC-054 focused on "what's allowed" while FEAT-057 focused on "what to do". A single comprehensive section serves both needs without duplication.

---

**Last Updated:** 2026-01-15

# FEAT-057: Workflow Transition Checklists

**ID:** FEAT-057
**Type:** Feature
**Priority:** High
**Status:** Backlog
**Created:** 2026-01-14
**Related:** TECH-043, FEAT-037

---

## Summary

Add workflow transition checklists to ensure AI follows proper procedures when moving work items between workflow folders (backlog → todo → doing → done).

**Problem:** AI consistently skips the Pre-Implementation Review (Step 7.5) when moving items to `doing/`. The policy exists in workflow-guide.md but isn't being triggered.

---

## Problem Statement

**Issue identified during:** TECH-043 implementation

The workflow guide documents what should happen when work items transition between folders (particularly Step 7.5 for `doing/`), but:
- The documentation is buried ~1200 lines into workflow-guide.md
- There's no trigger mechanism when AI moves files
- AI relies on memory of policy, which fails

**Who is affected?**
- AI assistants (need clear triggers for workflow steps)
- Users (expect consistent workflow behavior)

**Evidence:**
- TECH-043: Moved to doing/, immediately started implementation without pre-implementation review
- This has happened multiple times previously

---

## Solution

### Approach: Policy Reference in framework.yaml

Add `onTransition` policy to `framework.yaml` pointing to a consolidated transitions section in workflow-guide.md.

**framework.yaml addition:**
```yaml
policies:
  workflow: framework/docs/collaboration/workflow-guide.md
  onTransition: framework/docs/collaboration/workflow-guide.md#workflow-transitions
```

**workflow-guide.md addition:**
```markdown
## Workflow Transitions {#workflow-transitions}

When moving a work item between folders, complete the checklist for the target folder:

### → backlog/
- [ ] Work item created from template
- [ ] ID assigned (scan all locations first)

### → todo/
- [ ] User has approved the work
- [ ] Priority set

### → doing/
- [ ] Read ENTIRE work item document
- [ ] Identify open questions (TODO, TBD, DECIDE)
- [ ] Present pre-implementation summary to user
- [ ] Wait for confirmation before implementing

### → done/
- [ ] All completion criteria checked
- [ ] Status updated to "Done"
```

**CLAUDE.md instruction:**
```markdown
## Workflow Transitions

When moving work items between workflow folders, read and follow the `onTransition` policy in `framework.yaml` before proceeding.
```

### Why This Approach

1. **Single source of truth** - Checklists live in workflow-guide.md (no new files)
2. **Machine-readable trigger** - framework.yaml tells AI where to look
3. **DRY compliant** - References existing documentation
4. **Already proven** - AI reads framework.yaml at session start (FEAT-037)

### Chain of Responsibility

```
CLAUDE.md (instruction to check framework.yaml on transitions)
    ↓
framework.yaml (points to onTransition policy location)
    ↓
workflow-guide.md#workflow-transitions (actual checklists)
```

---

## Implementation Plan

1. Add "Workflow Transitions" section to workflow-guide.md
   - Consolidate existing Step 7.5 content
   - Add checklists for all four transitions

2. Update framework.yaml
   - Add `policies` section
   - Add `onTransition` reference

3. Update framework-schema.yaml
   - Add `policies` section to schema

4. Update CLAUDE.md
   - Add workflow transitions instruction

5. Test with a real work item transition

---

## Completion Criteria

- [ ] workflow-guide.md has consolidated "Workflow Transitions" section
- [ ] framework.yaml has `policies.onTransition` reference
- [ ] framework-schema.yaml updated for policies section
- [ ] CLAUDE.md has workflow transitions instruction
- [ ] Tested: AI follows checklist when moving item to doing/
- [ ] Changes committed

---

## Alternatives Considered

### Alternative 1: Per-folder .checklist.md files
```
thoughts/work/doing/.checklist.md
thoughts/work/done/.checklist.md
```
**Rejected:** Creates duplication, more files to maintain, violates DRY principles we just documented in TECH-043.

### Alternative 2: Checklist in framework.yaml directly
```yaml
workflow:
  transitions:
    doing:
      - "Read entire work item"
      - "Present summary to user"
```
**Rejected:** Mixes configuration with documentation. framework.yaml should point to docs, not contain them.

---

## References

- TECH-043: DRY Documentation Principles (established policy this follows)
- FEAT-037: Project Configuration File (established framework.yaml pattern)
- workflow-guide.md: Pre-Implementation Review (Step 7.5) - existing content to consolidate

---

**Last Updated:** 2026-01-14

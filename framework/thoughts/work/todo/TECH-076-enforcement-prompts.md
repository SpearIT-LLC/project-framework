# Tech Debt: Add Enforcement Prompts to Workflow Transitions

**ID:** TECH-076
**Type:** Tech Debt
**Priority:** High
**Version Impact:** PATCH
**Created:** 2026-01-23

---

## Summary

Add explicit checklist prompts to workflow-guide.md transition documentation to address the root cause of AI workflow bypass issues discovered during FEAT-025 testing.

---

## Problem Statement

**What is the current state?**

Testing revealed AI consistently bypasses workflow rules:
- Skips `todo/` state (backlog → doing directly)
- Ignores WIP limits (doesn't check `.limit` files)
- Ignores dependencies (doesn't verify `Depends On` items are complete)
- Skips pre-implementation approval (presents summary but doesn't wait)

**Why is this a problem?**

- Workflow rules exist but have no enforcement mechanism
- AI task-completion drive overrides process discipline
- Rules only work when AI is actively thinking about them
- Users lose control over work progression

**What is the desired state?**

- Explicit checklist items at each transition point
- AI must consciously acknowledge each check
- Provides "speed bumps" to slow task momentum
- Documents expected behavior for human operators too

---

## Proposed Solution

Add enforcement prompts to workflow-guide.md at each transition:

### → todo transition checklist:
```markdown
Before moving to todo/:
- [ ] Check `todo/.limit` file - count current items
- [ ] If at limit, prioritize and defer instead
```

### → doing transition checklist:
```markdown
Before moving to doing/:
- [ ] Check `doing/.limit` file - count current items (default: 1)
- [ ] If at limit, complete current work first
- [ ] Check `Depends On` field - all dependencies must be in done/
- [ ] Read entire work item
- [ ] Identify open questions
- [ ] Present summary to user
- [ ] **STOP - Wait for user approval before proceeding**
```

### → done transition checklist:
```markdown
Before moving to done/:
- [ ] All acceptance criteria met
- [ ] Changes committed with descriptive message
- [ ] Use `git mv` (not regular mv) to preserve history
```

**Files Affected:**
- `framework/docs/collaboration/workflow-guide.md` - Add/update transition checklists
- `templates/standard/framework/docs/collaboration/workflow-guide.md` - Sync changes

---

## Acceptance Criteria

- [ ] → todo checklist includes WIP limit check
- [ ] → doing checklist includes WIP limit check
- [ ] → doing checklist includes dependency check
- [ ] → doing checklist includes explicit "STOP - wait for approval" step
- [ ] → done checklist includes `git mv` requirement
- [ ] Template synced to templates/standard/

---

## Notes

This is the highest-impact fix from FEAT-025 testing. The enforcement prompts address the root cause of all workflow bypass issues by creating explicit checkpoints that require conscious acknowledgment.

Testing showed that when AI was "primed" by recent conversation about limits, it correctly enforced them. These prompts serve the same purpose - keeping the rules in active memory.

---

## Related

- FEAT-025: Manual Setup Validation (source of finding)
- TECH-068: Hotfix/emergency workflow (exception to normal flow)
- TECH-075: Spike workflow contradiction

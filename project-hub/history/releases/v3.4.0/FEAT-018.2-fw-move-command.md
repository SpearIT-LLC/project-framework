# FEAT-018.2: /fw-move Command

**ID:** FEAT-018.2
**Type:** Feature (Sub-task of FEAT-018)
**Version Impact:** MINOR (part of parent feature)
**Target Version:** TBD (releases with FEAT-018)
**Status:** Done
**Created:** 2026-01-19
**Completed:** 2026-01-19
**Developer:** TBD

---

## Summary

Implement the `/fw-move` command that moves work items between workflow folders with policy enforcement, transition validation, and proper git operations.

---

## Problem Statement

**What problem does this solve?**

Moving work items between folders requires:
1. Knowing the valid transitions (e.g., backlog → doing is invalid)
2. Using `git mv` instead of regular move
3. Checking WIP limits before moving to doing/
4. Optionally updating status field in document

This command encapsulates all these requirements into a single operation.

**Who is affected?**

- Users managing work item workflow
- AI assistants helping with project management

**Current workaround (if any):**

Manual `git mv` commands with manual transition validation

---

## Requirements

### Functional Requirements

- [ ] `/fw-move <item-id> <target-folder>` moves work item
- [ ] Validates transition against workflow matrix
- [ ] Rejects invalid transitions with explanation
- [ ] Uses `git mv` for file operations
- [ ] Checks WIP limit before moving to doing/
- [ ] Reports success with confirmation message
- [ ] Handles item not found gracefully

### Non-Functional Requirements

- [ ] Performance: < 2 seconds
- [ ] Security: Only operates within thoughts/work/ directory
- [ ] Compatibility: Works with Standard framework structure
- [ ] Documentation: Add to CLAUDE.md command registry

---

## Design

### Implementation Approach

**Phase 1 (MVP):** AI-driven with policy enforcement
- AI reads workflow-guide.md transition matrix
- Validates requested transition
- Executes `git mv` command
- Reports result

**Command Syntax:**

```
/fw-move <item-id> <target-folder>

Arguments:
  item-id        Work item ID or filename (e.g., FEAT-018, feature-018-*)
  target-folder  One of: backlog, todo, doing, done
```

**Transition Validation (from workflow-guide.md):**

| From | To | Valid? |
|------|----|----|
| backlog | todo | ✅ |
| backlog | doing | ❌ |
| todo | doing | ✅ |
| todo | backlog | ✅ |
| doing | done | ✅ |
| doing | todo | ✅ |
| done | * | ❌ |

**Example Interactions:**

Valid move:
```
User: /fw-move FEAT-042 todo
AI: Moving FEAT-042 from backlog to todo...
    ✅ Moved FEAT-042-feature-name.md to thoughts/work/todo/
```

Invalid move:
```
User: /fw-move FEAT-042 doing
AI: ❌ Cannot move FEAT-042 directly from backlog to doing.
    Valid path: backlog → todo → doing
    Would you like me to move it to todo first?
```

WIP limit exceeded:
```
User: /fw-move FEAT-042 doing
AI: ❌ Cannot move FEAT-042 to doing - WIP limit reached.
    Current: 2 items in doing/ (limit: 2)
    Complete or pause current work first.
```

---

## Dependencies

**Requires:**
- FEAT-018 (parent) - Command framework infrastructure
- workflow-guide.md transition matrix

**Blocks:**
- Nothing

**Related:**
- FEAT-018.4 (/fw-wip-check) - Used to check limits
- workflow-guide.md#workflow-transitions

---

## Testing Plan

### Manual Testing Steps

1. Move item from backlog → todo (valid)
2. Attempt backlog → doing (invalid, should reject)
3. Move item to doing when at WIP limit (should reject)
4. Move item from doing → done (valid)
5. Attempt to move from done (should reject)
6. Try with non-existent item ID

### Edge Cases

- [ ] Item ID not found (search and suggest)
- [ ] Multiple files match ID pattern (ask for clarification)
- [ ] Target folder doesn't exist (create or error?)
- [ ] Git not available (graceful error)

---

## Implementation Checklist

- [x] Transition validation logic documented
- [x] WIP limit checking integrated
- [x] Git mv operation specified
- [x] Error messages for all invalid cases
- [x] Success confirmation format defined
- [x] Manual testing completed

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Added
- `/fw-move` command for moving work items with policy enforcement
  - Validates transitions against workflow matrix
  - Checks WIP limits before moving to doing/
  - Uses git mv for proper version control
```

---

## References

- Parent: [FEAT-018: Claude Command Framework](feature-018-claude-command-framework.md)
- [workflow-guide.md#workflow-transitions](../../docs/collaboration/workflow-guide.md#workflow-transitions)

---

**Last Updated:** 2026-01-19

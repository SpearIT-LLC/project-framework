# /fw-move - Move Work Item Between Folders

Move a work item between workflow folders with policy enforcement, transition validation, and proper git operations.

## Usage

```
/fw-move <item-id> <target-folder>
```

## Arguments

- `item-id` (required): Work item ID (e.g., FEAT-018, BUGFIX-001) or partial filename
- `target-folder` (required): One of: `backlog`, `todo`, `doing`, `done`

## Behavior

1. **Find the item**: Search `thoughts/work/` subfolders for a file matching the item-id
2. **Validate transition**: Check against the transition matrix (see below)
3. **Check WIP limit**: If moving to `doing/`, verify WIP limit not exceeded
4. **Execute move**: Use `git mv` to move the file
5. **Report result**: Confirm success or explain why the move was rejected

## Transition Validity Matrix

| From | To | Valid? | Reason |
|------|----|----|--------|
| backlog | todo | ✅ | Standard flow - committing to work |
| backlog | doing | ❌ | Must commit to work (todo) first |
| todo | doing | ✅ | Starting work |
| todo | backlog | ✅ | Deprioritizing work |
| doing | done | ✅ | Completing work |
| doing | todo | ✅ | Pausing work |
| done | history | ✅ | Post-release archival |
| done | backlog | ❌ | No reopening - create a new work item instead |
| done | todo | ❌ | No reopening - create a new work item instead |
| done | doing | ❌ | No reopening - create a new work item instead |

## Per-Transition Checklists

### → todo/
- [ ] Transition is valid (check matrix)
- [ ] User has approved the work
- [ ] Priority understood

### → doing/
- [ ] Transition is valid (check matrix)
- [ ] WIP limit not exceeded (check `doing/.limit`, default 2)
- [ ] Note: Hierarchical items (FEAT-018 + FEAT-018.1) count as 1 WIP item

### → done/
- [ ] Transition is valid (check matrix)
- [ ] All completion criteria met
- [ ] User has approved the completed work

## Examples

```
/fw-move FEAT-042 todo      # Move from backlog to todo
/fw-move FEAT-042 doing     # Start work (moves to doing)
/fw-move FEAT-042 done      # Complete work (moves to done)
/fw-move BUGFIX-001 backlog # Deprioritize back to backlog
```

## Error Handling

**Invalid transition:**
```
❌ Cannot move FEAT-042 directly from backlog to doing.
   Valid path: backlog → todo → doing
   Would you like me to move it to todo first?
```

**WIP limit exceeded:**
```
❌ Cannot move FEAT-042 to doing - WIP limit reached.
   Current: 2 items in doing/ (limit: 2)
   Complete or pause current work first.
```

**Item not found:**
```
❌ Could not find work item 'FEAT-999'.
   Did you mean one of these?
   - FEAT-018 (in doing/)
   - FEAT-037 (in backlog/)
```

## Policy Reference

This command enforces the transition policy defined in:
`framework/docs/collaboration/workflow-guide.md#workflow-transitions`

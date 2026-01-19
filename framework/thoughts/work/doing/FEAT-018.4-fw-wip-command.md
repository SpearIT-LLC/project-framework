# FEAT-018.4: /fw-wip Command

**ID:** FEAT-018.4
**Type:** Feature (Sub-task of FEAT-018)
**Version Impact:** MINOR (part of parent feature)
**Target Version:** TBD (releases with FEAT-018)
**Status:** Done
**Created:** 2026-01-19
**Completed:** N/A
**Developer:** TBD

---

## Summary

Implement the `/fw-wip` command that displays current work items in the doing/ folder with expanded sub-items.

---

## Problem Statement

**What problem does this solve?**

Before starting new work, users need to:
1. Check how many items are in doing/
2. Read the .limit file to know the WIP limit
3. Determine if they can start new work

This command provides instant WIP status.

**Who is affected?**

- Users managing their work queue
- AI assistants before moving items to doing/
- Project managers monitoring workflow health

**Current workaround (if any):**

Manual `ls thoughts/work/doing/` and `cat thoughts/work/doing/.limit`

---

## Requirements

### Functional Requirements

- [ ] `/fw-wip-check` shows WIP limit status
- [ ] Displays current count vs limit
- [ ] Lists all items currently in doing/
- [ ] Shows clear indicator: ✅ under limit, ⚠️ at limit, ❌ over limit
- [ ] Suggests action if at/over limit

### Non-Functional Requirements

- [ ] Performance: < 1 second
- [ ] Security: Read-only operation
- [ ] Compatibility: Works with Standard framework structure
- [ ] Documentation: Add to CLAUDE.md command registry

---

## Design

### Implementation Approach

**Phase 1 (MVP):** Reuse Get-WorkflowStatus.ps1 + AI formatting
- Uses same `Get-WorkflowStatus.ps1` script as /fw-status (DRY)
- Script provides all workflow data including WIP info
- /fw-wip-check displays filtered view (doing/ details only)
- Script outputs JSON, AI formats for display

**Shared Script: Get-WorkflowStatus.ps1**
- Located in `framework/tools/`
- Single source of truth for workflow status data
- /fw-status uses full output
- /fw-wip-check uses doing/ subset (limit, count, items)
- Supports hierarchical counting (FEAT-018 + children = 1 WIP item)

**Output Format:**

Under limit:
```
WIP Status: ✅ Under Limit
─────────────────────────────────────────────────────

Current: 1 of 2 (1 slot available)

In Progress:
  • FEAT-018: Claude Command Framework
    Started: 2026-01-19

You can start one more work item.
```

At limit:
```
WIP Status: ⚠️ At Limit
─────────────────────────────────────────────────────

Current: 2 of 2 (no slots available)

In Progress:
  • FEAT-018: Claude Command Framework
  • BUGFIX-042: Authentication token refresh

Complete or pause current work before starting new items.
Use /fw-move <item> todo to pause work.
```

Over limit (shouldn't happen, but handle it):
```
WIP Status: ❌ Over Limit
─────────────────────────────────────────────────────

Current: 3 of 2 (1 over limit!)

In Progress:
  • FEAT-018: Claude Command Framework
  • BUGFIX-042: Authentication token refresh
  • FEAT-043: New feature

⚠️ WIP limit exceeded. Consider moving items back to todo/.
```

---

## Dependencies

**Requires:**
- FEAT-018 (parent) - Command framework infrastructure
- thoughts/work/doing/.limit file

**Blocks:**
- Nothing

**Related:**
- FEAT-018.2 (/fw-move) - Uses WIP check before moving to doing/
- FEAT-018.3 (/fw-status) - Includes WIP info in status

---

## Testing Plan

### Manual Testing Steps

1. Run with 0 items in doing/ (under limit)
2. Run with items equal to limit (at limit)
3. Run with items over limit (over limit warning)
4. Run with missing .limit file (use default of 2)
5. Verify item names extracted correctly

### Edge Cases

- [ ] .limit file missing (default to 2, suggest creating)
- [ ] .limit file has invalid content (default to 2, warn)
- [ ] Empty doing/ folder (show "no work in progress")
- [ ] Hierarchical items (FEAT-018 + FEAT-018.1 count as 1)

---

## Implementation Checklist

- [x] Output format defined for all states
- [x] .limit file reading specified
- [x] Default limit behavior documented
- [x] Hierarchical counting rule documented
- [x] Manual testing completed

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Added
- `/fw-wip-check` command for WIP limit monitoring
  - Shows current vs limit with visual indicator
  - Lists all items in progress
  - Suggests actions when at/over limit
```

---

## Notes

**Hierarchical WIP Counting:**
Per ADR-003/workflow-guide.md, parent and all children count as 1 item toward WIP limit.
- FEAT-018 + FEAT-018.1 + FEAT-018.2 = 1 WIP item (not 3)

---

## References

- Parent: [FEAT-018: Claude Command Framework](feature-018-claude-command-framework.md)
- [workflow-guide.md](../../docs/collaboration/workflow-guide.md) - WIP limit documentation

---

**Last Updated:** 2026-01-19

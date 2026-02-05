# FEAT-018.3: /fw-status Command

**ID:** FEAT-018.3
**Type:** Feature (Sub-task of FEAT-018)
**Version Impact:** MINOR (part of parent feature)
**Target Version:** TBD (releases with FEAT-018)
**Status:** Done
**Created:** 2026-01-19
**Completed:** 2026-01-19
**Developer:** TBD

---

## Summary

Implement the `/fw-status` command that shows a summary of the current project status including version, work items in progress, and workflow health.

---

## Problem Statement

**What problem does this solve?**

Getting a quick overview of project status currently requires:
1. Reading PROJECT-STATUS.md for version
2. Listing files in doing/ for current work
3. Checking done/ for items awaiting release
4. Manually counting items in each folder

This command provides a single-command overview.

**Who is affected?**

- Users checking project state
- AI assistants resuming work on a project
- Project managers tracking progress

**Current workaround (if any):**

Manual file inspection and reading multiple documents

---

## Requirements

### Functional Requirements

- [ ] `/fw-status` shows project status summary
- [ ] Displays current version from PROJECT-STATUS.md
- [ ] Lists items currently in doing/
- [ ] Shows count of items in each workflow folder
- [ ] Indicates WIP limit status (at limit, under limit)
- [ ] Shows items in done/ awaiting release

### Non-Functional Requirements

- [ ] Performance: < 3 seconds (file scanning)
- [ ] Security: Read-only operation
- [ ] Compatibility: Works with Standard framework structure
- [ ] Documentation: Add to CLAUDE.md command registry

---

## Design

### Implementation Approach

**Phase 1 (MVP):** PowerShell script + AI formatting
- Create `Get-WorkflowStatus.ps1` in `framework/tools/`
- Script outputs JSON with all workflow data
- AI formats JSON for display
- Script can run standalone or be called by slash command

**Script: Get-WorkflowStatus.ps1**
- Reads PROJECT-STATUS.md for version
- Counts items in each workflow folder (backlog, todo, doing, done)
- Reads doing/.limit file for WIP limit
- Applies hierarchical counting (FEAT-018 + FEAT-018.x = 1 WIP item)
- Outputs JSON for machine consumption or table for human consumption
- Shared with /fw-wip-check (DRY - single source of truth for workflow data)

**Output Format:**

```
Project Status: SpearIT Project Framework
─────────────────────────────────────────────────────

Version: v3.3.0 (2026-01-17)

Workflow Summary:
  Backlog:  12 items
  Todo:      3 items
  Doing:     1 item  (limit: 2) ✅
  Done:      1 item  ⚠️ Ready for release

Currently In Progress:
  • FEAT-018: Claude Command Framework

Awaiting Release:
  • DOC-063: Add README Update Step to Release Process

Recent Activity:
  Last release: v3.3.0 (2026-01-17)
```

**Compact Format Option:**

```
/fw-status --compact

v3.3.0 | Backlog: 12 | Todo: 3 | Doing: 1/2 | Done: 1 ⚠️
```

---

## Dependencies

**Requires:**
- FEAT-018 (parent) - Command framework infrastructure
- PROJECT-STATUS.md file

**Blocks:**
- Nothing

**Related:**
- FEAT-018.4 (/fw-wip-check) - Overlaps with WIP status

---

## Testing Plan

### Manual Testing Steps

1. Run `/fw-status` with items in various folders
2. Run with empty folders (graceful handling)
3. Run with items in done/ (shows release warning)
4. Run at WIP limit (shows limit status)
5. Verify version matches PROJECT-STATUS.md

### Edge Cases

- [ ] PROJECT-STATUS.md missing (show error, suggest creating)
- [ ] Empty project (no work items in any folder)
- [ ] Many items in backlog (summarize, don't list all)

---

## Implementation Checklist

- [x] Output format defined
- [x] File scanning logic specified
- [x] Version extraction from PROJECT-STATUS.md
- [x] WIP limit display integrated
- [x] Release warning for done/ items
- [x] Manual testing completed

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Added
- `/fw-status` command for project status overview
  - Shows current version and workflow summary
  - Lists items in progress and awaiting release
  - Indicates WIP limit status
```

---

## References

- Parent: [FEAT-018: Claude Command Framework](feature-018-claude-command-framework.md)

---

**Last Updated:** 2026-01-19

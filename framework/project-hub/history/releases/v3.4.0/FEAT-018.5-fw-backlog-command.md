# FEAT-018.5: /fw-backlog Command

**ID:** FEAT-018.5
**Type:** Feature (Sub-task of FEAT-018)
**Version Impact:** MINOR (part of parent feature)
**Target Version:** TBD (releases with FEAT-018)
**Status:** Done
**Created:** 2026-01-19
**Completed:** 2026-01-19
**Developer:** TBD

---

## Summary

Implement the `/fw-backlog` command that helps users review and prioritize backlog items, then move approved items to the todo folder with proper workflow compliance.

**Note:** This sub-task supersedes FEAT-017 (Backlog Review Command), incorporating its requirements into the FEAT-018 command framework.

---

## Problem Statement

**What problem does this solve?**

After implementing the AI Workflow Checkpoint Policy (ADR-001), users and AI need an easy way to:
1. Review what's in the backlog
2. Discuss priorities
3. Move items to todo/ with proper approval
4. Ensure workflow compliance without manual folder operations

Currently, reviewing the backlog requires:
- Manually listing files in thoughts/work/backlog/
- Opening each file to understand content
- Manually moving files with git mv
- Updating status fields in documents

**Who is affected?**

- Users managing project planning
- AI assistants helping with project management
- Teams using the Standard framework

**Current workaround (if any):**

Manual file operations and ad-hoc conversation about priorities

---

## Requirements

### Functional Requirements

- [ ] `/fw-backlog` lists all items in backlog with summary
- [ ] Shows item metadata (ID, type, version impact, created date)
- [ ] Allows interactive prioritization discussion
- [ ] `/fw-backlog move <item-id>` moves item to todo/ (with confirmation)
- [ ] Respects workflow transition rules (uses /fw-move internally)
- [ ] Provides summary of what was reviewed/moved

### Non-Functional Requirements

- [ ] Performance: Scans backlog in < 2 seconds
- [ ] Security: N/A (local file operations)
- [ ] Compatibility: Works with Standard framework structure
- [ ] Documentation: Add to CLAUDE.md command registry

---

## Design

### Implementation Approach

**Phase 1 (MVP):** AI-driven conversation command
- AI reads backlog/ folder
- Parses each .md file for metadata
- Presents formatted list to user
- User selects items to move
- AI performs moves using /fw-move logic

**Output Format - List View:**

```
Backlog Review
─────────────────────────────────────────────────────

12 items in backlog

ID          Type      Impact   Created     Summary
────────────────────────────────────────────────────────────
FEAT-037    Feature   MINOR    2026-01-10  Project config file
FEAT-038    Feature   MINOR    2026-01-11  Template validation
BUGFIX-012  Bugfix    PATCH    2026-01-12  Fix path handling
TECH-033    Tech Debt PATCH    2026-01-08  Status field review
...

Commands:
  /fw-backlog detail <id>  - Show full details for an item
  /fw-backlog move <id>    - Move item to todo/
  /fw-backlog prioritize   - Interactive prioritization session
```

**Output Format - Detail View:**

```
/fw-backlog detail FEAT-037

FEAT-037: Project Config File
─────────────────────────────────────────────────────

Type: Feature
Version Impact: MINOR
Created: 2026-01-10

Summary:
Add project-config.yaml file for multi-project repositories
to enable context switching between projects.

Problem:
Currently, CLAUDE.md at root must manually direct to correct
project CLAUDE.md. A config file would automate this.

Dependencies:
- None

Move to todo? Use: /fw-backlog move FEAT-037
```

**Interactive Prioritization:**

```
/fw-backlog prioritize

Starting interactive prioritization...

Item 1 of 12: FEAT-037 - Project config file (MINOR)

Options:
  [1] Move to todo (high priority)
  [2] Keep in backlog (not yet)
  [3] Show details
  [4] Skip for now

Your choice:
```

---

## Dependencies

**Requires:**
- FEAT-018 (parent) - Command framework infrastructure
- FEAT-018.2 (/fw-move) - For moving items to todo/

**Blocks:**
- Nothing

**Related:**
- FEAT-017 (superseded by this)

---

## Testing Plan

### Manual Testing Steps

1. Run `/fw-backlog` - verify all items displayed
2. Run `/fw-backlog detail <id>` - verify details shown
3. Run `/fw-backlog move <id>` - verify item moved to todo/
4. Run with empty backlog - verify graceful handling
5. Run `/fw-backlog prioritize` - test interactive flow

### Edge Cases

- [ ] Empty backlog (show helpful message)
- [ ] Malformed metadata in backlog item (skip or warn)
- [ ] Item ID not found (suggest similar)
- [ ] User cancels during prioritization (no changes made)

---

## Implementation Checklist

- [x] List format defined
- [x] Detail format defined
- [x] Move integration with /fw-move
- [x] Interactive prioritization flow designed
- [x] Metadata parsing logic specified
- [x] Error handling for all cases
- [x] Manual testing completed

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Added
- `/fw-backlog` command for backlog review and prioritization
  - Lists all backlog items with metadata
  - Detail view for individual items
  - Move items to todo with confirmation
  - Interactive prioritization mode
```

---

## Notes

- This command makes ADR-001 policy easier to follow
- Supersedes FEAT-017 (Backlog Review Command)
- Could be extended with filtering, sorting options in future

---

## References

- Parent: [FEAT-018: Claude Command Framework](feature-018-claude-command-framework.md)
- Supersedes: [FEAT-017: Backlog Review Command](../todo/feature-017-backlog-review-command.md)
- [ADR-001: AI Workflow Checkpoint Policy](../../research/adr/001-ai-workflow-checkpoint-policy.md)

---

**Last Updated:** 2026-01-19

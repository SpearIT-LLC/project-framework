# FEAT-018.1: /fw-help Command

**ID:** FEAT-018.1
**Type:** Feature (Sub-task of FEAT-018)
**Version Impact:** MINOR (part of parent feature)
**Target Version:** TBD (releases with FEAT-018)
**Status:** Done
**Created:** 2026-01-19
**Completed:** 2026-01-19
**Developer:** TBD

---

## Summary

Implement the `/fw-help` command that lists all available framework commands with brief descriptions, providing command discovery for users.

---

## Problem Statement

**What problem does this solve?**

Users need a way to discover what framework commands are available. Without a help command, users must read documentation or guess command names.

**Who is affected?**

- Users learning the framework command system
- Users who forget command names
- AI assistants needing to reference available commands

**Current workaround (if any):**

Read CLAUDE.md or ask for help in conversation

---

## Requirements

### Functional Requirements

- [ ] `/fw-help` lists all available `/fw-*` commands
- [ ] Each command shows: name, brief description (1 line)
- [ ] `/fw-help <command>` shows detailed help for specific command
- [ ] Output is formatted for readability (table or list)
- [ ] Indicates which commands are implemented vs planned

### Non-Functional Requirements

- [ ] Performance: Instant response (no file scanning needed)
- [ ] Security: N/A (read-only, no file operations)
- [ ] Compatibility: Works with any framework project
- [ ] Documentation: Self-documenting (is the documentation)

---

## Design

### Implementation Approach

**Phase 1 (MVP):** Documentation-based
- Command registry maintained in CLAUDE.md
- AI reads registry and presents formatted list
- No code required

**Output Format:**

```
Available Framework Commands (/fw-*)

Command          Description
─────────────────────────────────────────────────────
/fw-help         Show this help message
/fw-move         Move work item between folders
/fw-status       Show project status summary
/fw-wip-check    Check WIP limits and current work
/fw-backlog      Review and prioritize backlog items

Use /fw-help <command> for detailed help on a specific command.
```

**Detailed Help Format:**

```
/fw-move - Move work item between folders

Usage: /fw-move <item-id> <target-folder>

Arguments:
  item-id        Work item ID (e.g., FEAT-018, BUGFIX-001)
  target-folder  One of: backlog, todo, doing, done

Examples:
  /fw-move FEAT-042 todo    Move FEAT-042 to todo/
  /fw-move BUGFIX-001 doing Start work on BUGFIX-001

Notes:
- Validates transition against workflow matrix
- Uses git mv for file operations
- Updates status field in document
```

---

## Dependencies

**Requires:**
- FEAT-018 (parent) - Command framework infrastructure

**Blocks:**
- Nothing (discovery command, can be implemented first)

**Related:**
- All other FEAT-018.x commands (documented by this command)

---

## Testing Plan

### Manual Testing Steps

1. Run `/fw-help` - verify all commands listed
2. Run `/fw-help fw-move` - verify detailed help shown
3. Run `/fw-help invalid` - verify graceful error message
4. Verify output formatting is readable

### Edge Cases

- [ ] Unknown command name (suggest similar or show general help)
- [ ] Command name with/without `/fw-` prefix (handle both)

---

## Implementation Checklist

- [x] Command registry defined in CLAUDE.md
- [x] List format documented
- [x] Detailed help format for each command documented
- [x] Error handling for unknown commands
- [x] Manual testing completed

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Added
- `/fw-help` command for discovering available framework commands
```

---

## References

- Parent: [FEAT-018: Claude Command Framework](feature-018-claude-command-framework.md)

---

**Last Updated:** 2026-01-19

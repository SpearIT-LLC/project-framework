# Feature: Claude Command Framework for Project Operations

**ID:** FEAT-018
**Type:** Feature
**Version Impact:** MINOR (adds new capability)
**Target Version:** v2.2.0 or v2.3.0
**Status:** Backlog
**Created:** 2025-12-20
**Completed:** N/A
**Developer:** TBD

---

## Summary

Create a standardized framework for Claude commands that operate on the project framework (e.g., `/backlog-review`, `/plan-sprint`, `/release`, `/wip-check`). This provides reusable infrastructure for workflow automation commands.

---

## Problem Statement

**What problem does this solve?**

As we add more Claude commands to help with framework operations (starting with FEAT-017 backlog review), we need:

1. **Consistent command structure** - All commands follow same pattern
2. **Reusable utilities** - Don't duplicate metadata parsing, file operations
3. **Discoverability** - Users can find available commands easily
4. **Documentation standard** - Each command documented consistently
5. **Extensibility** - Easy to add new commands

Without a framework, each command will:
- Duplicate file I/O logic
- Parse metadata differently
- Have inconsistent user interfaces
- Be documented ad-hoc
- Be hard to maintain

**Who is affected?**

- Framework developers adding new commands
- Users wanting to discover and use commands
- AI assistants executing commands
- Project maintainers

**Current workaround (if any):**

Ad-hoc commands documented in CLAUDE.md with no shared infrastructure

---

## Requirements

### Functional Requirements

- [ ] Command registry/documentation system
- [ ] Shared utilities for common operations:
  - [ ] File scanning (backlog/, todo/, doing/, done/)
  - [ ] Metadata parsing (ID, Type, Status, Version Impact, etc.)
  - [ ] File movement (backlog → todo → doing → done)
  - [ ] Status updates in document frontmatter
  - [ ] WIP limit checking
  - [ ] Changelog generation helpers
- [ ] Command discovery mechanism (list available commands)
- [ ] Consistent command syntax (e.g., `/command-name`)
- [ ] Help system for each command
- [ ] Error handling patterns

### Non-Functional Requirements

- [ ] Performance: Commands execute in < 5 seconds
- [ ] Security: Only operate within project directory
- [ ] Compatibility: Works with Standard framework, optional for Light/Minimal
- [ ] Documentation: CLAUDE.md section, command reference guide
- [ ] Testability: Shared utilities have unit tests

---

## Design

### Architecture Impact

**Files Modified:**
- `CLAUDE.md` - Add "Claude Commands" section
- `QUICK-REFERENCE.md` - Add commands section (if implemented)
- `INDEX.md` - Link to command reference

**Files Added:**
- `thoughts/framework/tools/claude-commands/` - Command infrastructure
  - `README.md` - Command framework documentation
  - `command-utils.psm1` - PowerShell utilities (if using scripts)
  - Or: Documentation-only for conversation-based commands
- `thoughts/framework/tools/claude-commands/commands/` - Individual command docs
  - `backlog-review.md` - FEAT-017
  - `wip-check.md`
  - `release.md`
  - etc.

**Configuration Changes:**
None initially

**Data Schema Changes:**
None - operates on existing framework structure

### Implementation Approach

**Phase 1: Documentation Framework (MVP)**
- Create command documentation standard
- Document available commands in CLAUDE.md
- Provide conversation-based implementation guidance
- No code initially - pure AI-driven

**Phase 2: PowerShell Utilities (Optional)**
- Shared PowerShell module for common operations
- Commands call PS scripts for heavy lifting
- AI orchestrates and presents results

**Phase 3: Claude Code Skills (Future)**
- When Claude Code supports custom skills/hooks
- Formal skill registration
- IDE integration potential

**Recommended approach:** Start with Phase 1, evolve to Phase 2/3 based on usage

**Key Components:**

1. **Command Registry**
   - CLAUDE.md section listing all commands
   - Each command has: name, purpose, syntax, example

2. **Shared Utilities (Future)**
   - File scanner: `Get-FrameworkWorkItems -Folder backlog`
   - Metadata parser: `Get-WorkItemMetadata -Path feature-001.md`
   - File mover: `Move-WorkItem -From backlog -To todo -Item FEAT-001`
   - Status updater: `Update-WorkItemStatus -Item FEAT-001 -Status "Todo"`
   - WIP checker: `Test-WipLimit -Folder doing`

3. **Command Template**
   - Standard structure for adding new commands
   - Help text format
   - Error handling patterns

4. **Discovery System**
   - `/help` - List all available commands
   - `/help command-name` - Show command details

### Alternative Approaches Considered

**Option A:** Pure documentation (no code)
- Pros: Simple, no dependencies, works immediately
- Cons: AI must implement logic each time, potential inconsistency
- Decision: Good for Phase 1

**Option B:** Full PowerShell framework
- Pros: Consistent, testable, reusable
- Cons: Complexity, requires PowerShell knowledge
- Decision: Good for Phase 2 if Phase 1 proves valuable

**Option C:** Python/Node.js framework
- Pros: Cross-platform, rich ecosystem
- Cons: Adds dependencies, framework is PowerShell-focused
- Decision: Rejected - stick with PowerShell for Windows focus

---

## Dependencies

**Requires:**
- ADR-001: AI Workflow Checkpoint Policy (foundation for workflow commands)
- Standard framework structure

**Blocks:**
- FEAT-017: Backlog Review Command (will use this framework)
- Future workflow automation features

**Related:**
- All future workflow commands will build on this

---

## Proposed Commands (Initial Set)

### Workflow Commands
- `/backlog-review` - Review and prioritize backlog (FEAT-017)
- `/plan-sprint` - Plan next sprint by moving items to todo
- `/wip-check` - Check WIP limits and current work
- `/release` - Prepare release (update docs, changelog, version)

### Information Commands
- `/help` or `/commands` - List available commands
- `/status` - Show project status summary
- `/roadmap` - Display roadmap with current progress

### Utility Commands
- `/cleanup` - Archive old done items, organize history
- `/validate` - Check framework structure compliance

---

## Testing Plan

### Manual Testing Steps

1. Document 3-5 initial commands
2. Test each command with framework project
3. Verify consistency across commands
4. Test discovery mechanism (`/help`)
5. Validate error handling

### Edge Cases

- [ ] Invalid command name (suggest similar commands)
- [ ] Command execution fails (show helpful error)
- [ ] Empty results (e.g., empty backlog) - graceful message
- [ ] Malformed work items (skip with warning)

---

## Security Considerations

- [x] Input validation implemented - Validate command names, paths
- [x] No credential exposure in logs - N/A
- [x] Path traversal prevention - Restrict to project directory
- [x] Error messages don't leak sensitive info - Generic errors only
- [x] Follows principle of least privilege - Read/write project files only

---

## Documentation Updates

### Files to Update

- [ ] CLAUDE.md - Add "Claude Commands" section with registry
- [ ] QUICK-REFERENCE.md - Add commands section (section 4 or new section)
- [ ] INDEX.md - Link to command documentation

### New Documentation Needed

- [ ] thoughts/framework/tools/claude-commands/README.md - Framework overview
- [ ] Command template for adding new commands
- [ ] Usage examples for each command

---

## Implementation Checklist

- [ ] Design reviewed and approved
- [ ] Command documentation standard created
- [ ] Initial command set documented (3-5 commands)
- [ ] CLAUDE.md updated with command registry
- [ ] Help system implemented
- [ ] Manual testing completed (each command)
- [ ] QUICK-REFERENCE.md updated
- [ ] CHANGELOG.md updated

---

## Rollout Plan

**Deployment Steps:**

1. Create command framework documentation
2. Document initial command set (3-5 commands)
3. Update CLAUDE.md with registry
4. Test commands with framework project
5. Document in QUICK-REFERENCE.md
6. Release in v2.2.0 or v2.3.0

**Rollback Plan:**

Remove command documentation from CLAUDE.md - no code to rollback in Phase 1

---

## Success Metrics

**How do we know this feature is successful?**

- Users regularly use 2+ commands
- Commands reduce manual file operations
- Consistent command structure across all commands
- Easy to add new commands (< 1 hour per command)
- Command framework referenced in other framework projects

---

## Timeline

| Phase | Estimated Hours | Actual Hours | Status |
|-------|-----------------|--------------|--------|
| Phase 1 Planning | 2 hours | TBD | Backlog |
| Phase 1 Implementation (Docs) | 4 hours | TBD | Backlog |
| Phase 1 Testing | 2 hours | TBD | Backlog |
| Phase 2 (PS Utils) - Optional | 10 hours | TBD | Backlog |
| **Phase 1 Total** | **8 hours** | **TBD** | |

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Added
- Claude Command Framework
  - Standardized command structure for workflow operations
  - Command registry in CLAUDE.md
  - Initial command set: /help, /backlog-review, /wip-check, /status
  - Shared documentation patterns for extensibility
```

---

## Notes

- **Start simple** - Phase 1 documentation-only approach validates concept
- **Evolve based on usage** - Only add PowerShell utilities if needed
- **Extensibility is key** - Make it easy to add commands
- **Integration with Claude Code** - Watch for native skill support
- **Cross-project potential** - Could extract as standalone framework extension

**Naming consideration:**
- `/command-name` format matches Claude Code conventions
- Use descriptive, action-oriented names
- Prefix with category if many commands (e.g., `/workflow-plan`, `/workflow-release`)

---

## References

- [ADR-001: AI Workflow Checkpoint Policy](../../research/adr/001-ai-workflow-checkpoint-policy.md)
- [kanban-workflow.md](../../../project-framework-template/standard/thoughts/framework/process/kanban-workflow.md)
- [CLAUDE.md](../../../CLAUDE.md)
- Related: FEAT-017 (Backlog Review Command) - First command using this framework

---

**Last Updated:** 2025-12-20

# Feature: Backlog Review Command for Claude

**ID:** FEAT-017
**Type:** Feature
**Version Impact:** MINOR (adds new capability)
**Target Version:** v2.2.0
**Status:** Backlog
**Created:** 2025-12-20
**Completed:** N/A
**Developer:** TBD

---

## Summary

Create a Claude command (e.g., `/backlog-review` or `/plan`) that helps users review and prioritize backlog items, then move approved items to the todo folder with proper workflow compliance.

---

## Problem Statement

**What problem does this solve?**

After implementing the AI Workflow Checkpoint Policy (ADR-001), users and AI need an easy way to:
1. Review what's in the backlog
2. Discuss priorities
3. Move items to todo/ with proper approval
4. Ensure workflow compliance without manual folder operations

Currently, reviewing the backlog requires:
- Manually listing files in `thoughts/project/planning/backlog/`
- Opening each file to understand content
- Manually moving files to `work/todo/`
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

- [ ] Command accessible via `/backlog-review` or `/plan`
- [ ] Lists all items currently in backlog with summary
- [ ] Shows item metadata (ID, type, target version, created date)
- [ ] Allows interactive prioritization discussion
- [ ] Moves approved items to work/todo/ with user confirmation
- [ ] Updates status field in moved documents
- [ ] Respects todo/ WIP limits (max 10)
- [ ] Provides summary of what was moved

### Non-Functional Requirements

- [ ] Performance: Scans backlog in < 2 seconds
- [ ] Security: N/A (local file operations)
- [ ] Compatibility: Works with Standard framework structure
- [ ] Documentation: Add to QUICK-REFERENCE.md, update CLAUDE.md

---

## Design

### Architecture Impact

**Files Modified:**
- `CLAUDE.md` - Add backlog review command documentation
- `QUICK-REFERENCE.md` - Add command to section 4 (Common Operations)
- Future: Claude Code skill/hook integration

**Files Added:**
- Potentially: `thoughts/framework/tools/backlog-review.ps1` (helper script)
- Or: Integration with Claude Code native commands

**Configuration Changes:**
None initially - pure conversation-based command

**Data Schema Changes:**
None

### Implementation Approach

**Option 1: Conversation-Based Command (MVP)**
- Claude reads backlog/ folder
- Parses each .md file for metadata
- Presents formatted list to user
- User selects items to move
- Claude performs moves and updates

**Option 2: PowerShell Helper Script**
- Script in thoughts/framework/tools/
- Outputs JSON or formatted text
- Claude calls script, presents results, takes action

**Option 3: Claude Code Skill**
- Future: Formal skill integration
- Registered command in Claude Code
- More robust, reusable across projects

**Recommended approach:** Start with Option 1 (conversation-based), evolve to Option 3 when Claude Code skills are available

**Key Components:**

1. **Backlog Scanner:** Read all .md files in planning/backlog/
2. **Metadata Parser:** Extract ID, Type, Version Impact, Summary
3. **Interactive UI:** Present options, get user selection
4. **Workflow Enforcer:** Check limits, move files, update status
5. **Summary Reporter:** Show what changed

### Alternative Approaches Considered

**Option A:** Always show backlog at start of conversation
- Pros: Keeps backlog top of mind
- Cons: Noise if user has specific task
- Decision: On-demand command better

**Option B:** Automatic prioritization based on version targets
- Pros: Less user decision-making
- Cons: Removes user control, defeats purpose of checkpoint
- Decision: User must explicitly prioritize

---

## Dependencies

**Requires:**
- ADR-001: AI Workflow Checkpoint Policy (implemented)
- CLAUDE.md workflow guidelines (implemented)
- Standard framework structure

**Blocks:**
- Nothing currently

**Related:**
- FEAT-018: Claude Command Framework (could share infrastructure)
- FEAT-016: Quick Reference Guide (document command there)

---

## Testing Plan

### Manual Testing Steps

1. Create 5-10 test feature files in backlog/
2. Run `/backlog-review` command
3. Verify all items displayed with correct metadata
4. Select 2 items to move to todo/
5. Confirm files moved and status updated
6. Verify todo/ limit respected
7. Run command with empty backlog - verify graceful handling

### Edge Cases

- [ ] Empty backlog (show helpful message)
- [ ] Malformed metadata in backlog item (skip or warn)
- [ ] Todo/ folder at limit (prevent move, show message)
- [ ] User cancels mid-review (no changes made)

---

## Security Considerations

- [x] Input validation implemented - N/A (local files)
- [x] No credential exposure in logs - N/A
- [x] Path traversal prevention - Use relative paths only
- [x] Error messages don't leak sensitive info - Show generic errors
- [x] Follows principle of least privilege - File read/move only

---

## Documentation Updates

### Files to Update

- [ ] CLAUDE.md - Add `/backlog-review` command documentation
- [ ] QUICK-REFERENCE.md - Add to section 4 (Common Operations)
- [ ] INDEX.md - Link to command documentation if detailed guide created

### New Documentation Needed

- [ ] Command usage examples in CLAUDE.md
- [ ] Workflow integration notes

---

## Implementation Checklist

- [ ] Design reviewed and approved
- [ ] Command documented in CLAUDE.md
- [ ] Metadata parsing logic implemented
- [ ] File move operations implemented
- [ ] Status update logic implemented
- [ ] Limit checking implemented
- [ ] Manual testing completed
- [ ] Edge cases tested
- [ ] Documentation updated
- [ ] CHANGELOG.md updated

---

## Rollout Plan

**Deployment Steps:**

1. Update CLAUDE.md with command documentation
2. Test with framework project backlog
3. Update QUICK-REFERENCE.md
4. Release in v2.2.0

**Rollback Plan:**

Remove command documentation from CLAUDE.md - no code to rollback

---

## Success Metrics

**How do we know this feature is successful?**

- Backlog review becomes regular part of workflow
- Users report easier prioritization process
- Fewer manual file operations required
- Workflow compliance improves (items properly moved through stages)

---

## Timeline

| Phase | Estimated Hours | Actual Hours | Status |
|-------|-----------------|--------------|--------|
| Planning | 1 hour | TBD | Backlog |
| Implementation | 3 hours | TBD | Backlog |
| Testing | 1 hour | TBD | Backlog |
| Documentation | 1 hour | TBD | Backlog |
| **Total** | **6 hours** | **TBD** | |

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Added
- `/backlog-review` command for Claude
  - Interactive backlog review and prioritization
  - Automated file movement with workflow compliance
  - Respects todo/ WIP limits
  - Summary reporting
```

---

## Notes

- This command makes ADR-001 policy easier to follow
- Could be foundation for other workflow commands (/sprint-plan, /release, etc.)
- Future: Integrate with Claude Code native command system
- Consider: Visual backlog view (table format) vs. conversational list

---

## References

- [ADR-001: AI Workflow Checkpoint Policy](../../research/adr/001-ai-workflow-checkpoint-policy.md)
- [kanban-workflow.md](../../../project-framework-template/standard/thoughts/framework/process/kanban-workflow.md)
- [CLAUDE.md](../../../CLAUDE.md)
- Related: FEAT-018 (Claude Command Framework)

---

**Last Updated:** 2025-12-20

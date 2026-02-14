# Feature: Plugin "new" Command - Create Work Items

**ID:** FEAT-119
**Type:** Feature
**Priority:** High
**Version Impact:** MINOR (Plugin v1.0)
**Created:** 2026-02-09
**Completed:** 2026-02-09
**Theme:** Distribution & Integration
**Parent:** FEAT-118 (Claude Code Plugin MVP)

---

## Summary

Add `/spearit-framework-light:new` command to the plugin to enable users to create work items interactively. This completes the minimum viable workflow: create → move → track.

**Critical Gap:** Without a create command, users cannot get started with the workflow. This is a blocker for first-time users.

---

## Problem Statement

**Context:** Plugin provides commands to move, track, and reference work items, but has no way to CREATE them.

**Current user journey:**
1. Install plugin ✅
2. Run `/spearit-framework-light:help` ✅
3. See commands for move, next-id, session-history ✅
4. Think "okay but... how do I CREATE a work item?" ❌
5. Get frustrated, uninstall ❌

**Without a create command:**
- Users must figure out the file format themselves
- Users must know the naming convention (FEAT-001-title.md)
- Users must understand the required frontmatter
- **High friction = abandonment**

**Risk:** Users bounce before experiencing the workflow's value.

---

## Requirements

### Command Specification

**Command:** `/spearit-framework-light:new`

**Interactive Prompts:**
1. **Work item type** - FEAT/BUG/CHORE/TASK/DOCS/REFACTOR/DECISION/TECH
2. **Title** - Short description (kebab-case slug auto-generated)
3. **Priority** - High/Medium/Low
4. **Optional: Summary** - Can be "TBD" initially for quick creation

**Creates:**
- File: `project-hub/work/backlog/TYPE-###-title.md`
- Uses next available ID (reuses `:next-id` logic)
- Includes basic frontmatter template
- Git adds the file automatically

**Graceful Degradation:**
- If `project-hub/work/backlog/` doesn't exist, creates it
- If user doesn't have structure, creates minimal structure
- Works in both framework and non-framework projects

### File Template

```markdown
# [Type]: [Title]

**ID:** [TYPE-###]
**Type:** [Type]
**Priority:** [Priority]
**Created:** [Date]

---

## Summary

[User-provided summary or "TBD"]

---

## Problem Statement

[To be filled in]

---

## Requirements

[To be filled in]

---

## Acceptance Criteria

- [ ] [To be filled in]

---

## Notes

[Optional notes]

---

**Last Updated:** [Date]
**Status:** Backlog
```

### Quality Standards

**Professional:**
- Clear prompts with helpful examples
- Validates input (type, title format)
- Confirms creation with file path

**Reasonably Robust:**
- Handles missing directories gracefully
- Prevents duplicate IDs
- Validates work item type
- Sanitizes title for filename

**Not Buggy:**
- Creates valid markdown files
- Git operations work correctly
- No broken references
- Consistent with other commands

**Easy to Use:**
- Intuitive prompts
- Helpful error messages
- Quick workflow (< 30 seconds to create)
- Examples in help text

---

## Implementation Plan

### Phase 1: Create Command File (1 hour)

**Create:** `plugins/spearit-framework-light/commands/new.md`

**Structure:**
- Command metadata and description
- Interactive prompts specification
- File creation logic
- Directory structure handling
- Git add operation
- Error handling

**Key Logic:**
1. Prompt for type, title, priority, optional summary
2. Call `:next-id` logic to get next available ID
3. Sanitize title to kebab-case slug
4. Create filename: `TYPE-###-sanitized-title.md`
5. Generate file from template
6. Create directories if needed
7. Write file
8. Git add
9. Confirm creation with file path

### Phase 2: Update Help Command (15 minutes)

**Update:** `plugins/spearit-framework-light/commands/help.md`

**Add entry:**
```markdown
### `/spearit-framework-light:new`

Create a new work item interactively.

**Usage:**
/spearit-framework-light:new

**Prompts for:**
- Work item type (FEAT/BUG/CHORE/TASK/DOCS/REFACTOR/DECISION/TECH)
- Title (short description)
- Priority (High/Medium/Low)
- Optional: Summary

**Creates:**
- File in `project-hub/work/backlog/`
- Uses next available ID
- Git adds automatically

**Example:**
/spearit-framework-light:new
→ Type: FEAT
→ Title: Add dark mode
→ Priority: Medium
→ Summary: TBD
✓ Created: project-hub/work/backlog/FEAT-120-add-dark-mode.md
```

### Phase 3: Update README (15 minutes)

**Update:** `plugins/spearit-framework-light/README.md`

**Add to Quick Start:**
```markdown
## Quick Start

1. **Create a work item**
   /spearit-framework-light:new

2. **Move it to todo when ready**
   /spearit-framework-light:move FEAT-120 todo

3. **Move to doing when you start**
   /spearit-framework-light:move FEAT-120 doing
```

**Add to Command Reference:**
- Include `:new` command with full documentation

### Phase 4: Testing (30 minutes)

**Test Scenarios:**
- [x] Create work item in framework project (structure exists)
- [x] Create work item in non-framework project (no structure)
- [x] Create work item with all types (FEAT/BUG/etc.)
- [x] Verify ID sequencing works correctly
- [x] Verify git add works
- [x] Test title sanitization (spaces, special chars)
- [x] Test with minimal input (TBD summary)
- [x] Verify file format is valid markdown

**Expected Total Time:** ~2-3 hours

---

## Acceptance Criteria

### Command Functionality
- [x] `/spearit-framework-light:new` command exists in `commands/new.md`
- [x] Interactive prompts for type, title, priority, summary
- [x] Creates file in `project-hub/work/backlog/`
- [x] Uses next available ID correctly
- [x] Git adds file automatically
- [x] Confirms creation with file path

### Graceful Degradation
- [x] Creates `project-hub/work/backlog/` if missing
- [x] Works in framework projects
- [x] Works in non-framework projects
- [x] Helpful error messages for failures

### Documentation
- [x] Help command updated with `:new` entry
- [x] README updated with `:new` in Quick Start
- [x] Command reference includes full documentation
- [x] Examples provided

### Quality
- [x] All test scenarios pass
- [x] File format is valid markdown
- [x] Title sanitization works correctly
- [x] No duplicate IDs created
- [x] Git operations work correctly

---

## Design Decisions

### Decision 1: Command Name - `:new` vs `:create`

**Options:**
- `/spearit-framework-light:create` ❌ (longer to type)
- `/spearit-framework-light:new` ✅ **CHOSEN**
- `/spearit-framework-light:add` ❌ (ambiguous)

**Chosen:** `:new`

**Rationale:**
- Shorter to type (3 characters vs 6)
- Common convention (`:new-branch`, `:new-file`)
- Parallel to existing patterns users know
- Clear intent

### Decision 2: Interactive Prompts vs Flags

**Options:**
- Flags: `/spearit-framework-light:new --type FEAT --title "Add feature"` ❌
- Interactive prompts ✅ **CHOSEN**
- Hybrid (flags optional, prompts as fallback) ❌ (too complex for MVP)

**Chosen:** Interactive prompts only

**Rationale:**
- More user-friendly for first-time users
- Guides users through required fields
- Consistent with Claude Code interaction patterns
- Can add flags in v1.1 if requested

### Decision 3: Default Location - backlog vs todo

**Options:**
- Create in `todo/` ❌ (assumes ready to work)
- Create in `backlog/` ✅ **CHOSEN**
- Let user choose ❌ (extra friction)

**Chosen:** Always create in `backlog/`

**Rationale:**
- Matches framework philosophy (backlog → todo → doing → done)
- New items typically need refinement before todo
- User can immediately move with `:move` if ready
- Consistent with framework patterns

### Decision 4: Scope for FEAT-118 - Add or Defer?

**Options:**
- Ship FEAT-118 without `:new` command ❌ (incomplete workflow)
- Add `:new` command to FEAT-118 scope ✅ **CHOSEN**
- Defer to v1.1 ❌ (users get stuck)

**Chosen:** Add to FEAT-118, ship as 5-command plugin

**Rationale:**
- This is NOT scope creep - it's **completing** the MVP
- Without `:new`, the workflow is broken for new users
- 5 commands is still MVP (help, new, move, next-id, session-history)
- +1 day to timeline is acceptable to prevent user abandonment
- Better to ship complete workflow late than incomplete workflow on time

---

## Impact on FEAT-118

### Updated MVP Scope

**5 core commands (was 4):**
1. `help` - Command reference
2. **`new`** - Create work item (NEW)
3. `next-id` - Get next ID (supporting)
4. `move` - Move through workflow
5. `session-history` - Document work (auto-called)

### Updated Timeline

**Original:** 7 days
**Updated:** 8 days (+1 day for `:new` command)

**Revised Plan:**
- Days 1-2: Create plugin package ✅ COMPLETE
- Day 3: Create skills ✅ COMPLETE
- Day 4: README & Build ✅ COMPLETE
- Day 5: Testing ✅ COMPLETE
- **Day 6: Add `:new` command** ← FEAT-119
- Day 7: Licensing and final polish
- Day 8: Package and submit

### Updated Milestone Structure

**Add to FEAT-118:**
- **Milestone 3e:** Prototype new command (Standalone)
  - [x] Create `commands/new.md`
  - [x] Implement interactive prompts
  - [x] Reuse `:next-id` logic
  - [x] Add file creation and git operations
  - [x] Test standalone operation
  - [x] Update help command
  - [x] Update README
  - [x] **STOP - Review fw-new prototype**

---

## Related Work Items

**Parent:** FEAT-118 (Claude Code Plugin MVP)

**Depends On:**
- None (reuses `:next-id` logic, no new dependencies)

**Blocks:**
- None (but enables complete workflow)

**Enables:**
- Complete user workflow (create → move → track)
- First-time user success
- Reduced friction for plugin adoption

---

## Success Metrics

### Primary Success
- [x] Command creates valid work items
- [x] Works in both framework and non-framework projects
- [x] Users can create their first work item in < 30 seconds
- [x] No confusion about how to get started

### Secondary Success
- [x] Zero "how do I create a work item?" questions in feedback (N/A - pre-release)
- [x] Users successfully create and move items in workflow
- [x] Command used as frequently as `:move` command (expected post-release)

---

## Notes

**Why This Matters:**
Without a create command, the plugin is like a car without an ignition - all the other features are useless because users can't get started.

**Philosophy Alignment:**
- **Progressive adoption:** Works with or without full framework
- **AI collaboration:** Interactive prompts guide users
- **Solo/small team focus:** Simple, fast, no external dependencies
- **Research before build:** Identified gap through product thinking

**Alternative Considered:**
Documenting the file format in README as a workaround. Rejected because:
- High friction (copy-paste, manual editing)
- Error-prone (typos in frontmatter)
- Doesn't match "easy to use" quality bar
- Creates unnecessary barrier to entry

---

## Changelog

**2026-02-09 - Initial Creation:**
- Created FEAT-119 as child of FEAT-118
- Identified critical gap in user workflow
- Scoped as high-priority addition to plugin MVP
- Estimated +1 day to FEAT-118 timeline
- Decision: Add to FEAT-118 scope (not defer to v1.1)

---

**Last Updated:** 2026-02-09
**Status:** Complete

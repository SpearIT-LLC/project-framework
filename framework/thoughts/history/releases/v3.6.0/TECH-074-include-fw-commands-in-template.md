# Tech Debt: Include fw- Commands and Tools in Template Package

**ID:** TECH-074
**Type:** Tech Debt
**Priority:** High
**Version Impact:** PATCH
**Created:** 2026-01-23

---

## Summary

The `/fw-*` Claude Code slash commands and supporting PowerShell scripts are not included in the template package. Users who set up new projects don't get the framework workflow commands or tools.

---

## Problem Statement

**What is the current state?**

- Framework project has `.claude/commands/fw-*.md` (8 commands)
- Framework project has `framework/tools/*.ps1` (7 scripts)
- `templates/standard/` does not include `.claude/commands/` folder
- `templates/standard/framework/tools/` is empty (only `.gitkeep`)
- `/fw-move` is referenced in workflow-guide.md but not available to new projects
- fw- commands depend on tools scripts (e.g., `/fw-next-id` calls `Get-NextWorkItemId.ps1`)
- Users must manually copy commands and tools or work without them

**Why is this a problem?**

- New projects lack workflow automation commands
- Commands won't work without supporting scripts
- Documentation references commands that don't exist
- Inconsistent experience between framework development and user projects

**What is the desired state?**

- Template package includes all fw- commands
- Template package includes all framework tools
- New projects have full workflow command support
- Documentation matches available features

---

## Proposed Solution

Add `.claude/commands/` and `framework/tools/` to template package:

**Commands to Include (8):**
1. `fw-backlog.md` - Backlog review and prioritization
2. `fw-help.md` - Framework command help
3. `fw-move.md` - Move work item between folders
4. `fw-next-id.md` - Get next available work item ID
5. `fw-session-history.md` - Generate session history
6. `fw-status.md` - Project status summary
7. `fw-topic-index.md` - Framework topic index
8. `fw-wip.md` - Show work in progress

**Tools to Include (7):**
1. `Get-NextWorkItemId.ps1` - Gets next available work item ID
2. `Move-WorkItem.ps1` - Moves work items between folders (with git mv)
3. `Get-BacklogItems.ps1` - Lists backlog items
4. `Get-WorkflowStatus.ps1` - Shows workflow status
5. `Get-FrameworkIndex.ps1` - Gets framework topic index
6. `FrameworkWorkflow.psm1` - PowerShell module for workflow functions
7. `validate-framework.ps1` - Validates framework structure

**Build Process Addition:**
```powershell
# Step 3: Sync Framework Tools
New-Item -ItemType Directory -Path templates/standard/framework/tools -Force
Copy-Item framework/tools/*.ps1 templates/standard/framework/tools/
Copy-Item framework/tools/*.psm1 templates/standard/framework/tools/

# Step 4: Sync Claude Commands
New-Item -ItemType Directory -Path templates/standard/.claude/commands -Force
Copy-Item .claude/commands/fw-*.md templates/standard/.claude/commands/
```

**Files Created:**
- `templates/standard/.claude/commands/fw-*.md` (8 files)
- `templates/standard/framework/tools/*.ps1` (6 files)
- `templates/standard/framework/tools/*.psm1` (1 file)

---

## Acceptance Criteria

- [x] `.claude/commands/` folder exists in templates/standard/
- [x] All 8 fw- commands copied to template
- [x] `framework/tools/` folder populated in templates/standard/
- [x] All 7 tools scripts copied to template
- [ ] Commands work in fresh project (test with project-hello-world)
- [x] NEW-PROJECT-CHECKLIST.md updated to verify commands and tools exist
- [x] distribution-build-checklist.md includes command and tools sync steps

---

## Notes

Discovered during FEAT-025 validation testing. The fw- commands were immediately missed when testing workflow in project-hello-world.

**Completed 2026-01-23:**
- Copied 8 fw- commands to `templates/standard/.claude/commands/`
- Copied 7 tools (6 .ps1, 1 .psm1) to `templates/standard/framework/tools/`
- NEW-PROJECT-CHECKLIST.md already updated (FEAT-025)
- distribution-build-checklist.md already updated (FEAT-025)

**Remaining:** Fresh project test (optional - can be done during next validation cycle).

---

## Related

- FEAT-025: Manual Setup Validation (source of finding)
- TECH-075: Reconcile spike workflow contradiction

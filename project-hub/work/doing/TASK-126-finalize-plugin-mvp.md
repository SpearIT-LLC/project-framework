# TASK-126: Finalize framework-light Plugin MVP for Submission

**Type:** TASK
**Status:** Doing
**Created:** 2026-02-12
**Related:** FEAT-118 (scope refinement)

---

## Objective

Reduce plugin scope to a focused MVP with 3 core commands (help, new, move) by removing session-history and next-id commands before marketplace submission.

## Context

After prototyping 5 commands, product review identified:
- **session-history**: Documentation feature, not core workflow → Defer to full framework plugin
- **next-id**: Implementation detail leaking into UI → Integrate into `new` command

**MVP Value Proposition:**
"Start using the SpearIT framework workflow in minutes. Create and organize work items right from Claude."

## Scope

### 1. Preserve Removed Features

- [ ] Copy `commands/session-history.md` to safe location
  - Option A: `project-hub/work/backlog/deferred/session-history.md`
  - Option B: `plugins/spearit-framework/commands/` (future full framework plugin)
- [ ] Copy session history template to same location
- [ ] Document location in FEAT-118 for future reference

### 2. Integrate next-id into new Command

- [ ] Update `commands/new.md` to auto-assign next available ID
  - **Approach:** Copy AI-driven scanning logic from `next-id.md` (standalone model, no scripts)
  - Add instruction: "Scan project-hub/work/ and history/ for highest ID, increment by 1"
  - Handle edge cases: empty directory (start at 001), gaps in sequence (use max + 1)
  - Remove any manual ID input requirements from user interaction
- [ ] Test `new` command generates correct sequential IDs
- [ ] Verify behavior with empty work directory
- [ ] Verify behavior with gaps in ID sequence

**Note:** Use AI-driven scanning (consistent with standalone plugin model), not bash scripts/functions.

### 3. Remove Command Files

- [ ] Delete `commands/next-id.md` (after backup/git history confirms safe)
- [ ] Delete `commands/session-history.md` (after backup)
- [ ] Remove associated templates (if standalone)

### 4. Update Plugin Metadata

- [ ] **package.json**
  - Remove `session-history` from skills array
  - Remove `next-id` from skills array
  - Verify description still accurate (no removed features mentioned)
  - Confirm version remains `1.0.0`
- [ ] **README.md**
  - Update command list (3 commands only)
  - Update feature descriptions
  - Update usage examples if needed

### 5. Update Documentation

- [ ] **help.md** - List only 3 commands (help, new, move)
- [ ] **CHANGELOG.md** - Document scope reduction with rationale
  - "Focused MVP on core workflow commands"
  - "Deferred session-history to full framework plugin"
  - "Integrated ID assignment into new command"
- [ ] **Skills documentation** (if separate from package.json)

### 6. Build & Distribution

- [ ] Run `Build-Plugin.ps1` to regenerate distribution
- [ ] Verify `distrib/plugin-light/spearit-framework-light-v1.0.0.zip` updated
- [ ] Update local marketplace: `Publish-ToLocalMarketplace.ps1 -Build`

### 7. Testing

- [ ] **Command availability**
  - `/spearit-framework-light:help` shows only 3 commands
  - `/spearit-framework-light:session-history` returns "command not found"
  - `/spearit-framework-light:next-id` returns "command not found"
- [ ] **new command**
  - Creates work item with auto-assigned ID
  - Handles first work item (ID 001)
  - Handles gaps in sequence
  - ID increments correctly
- [ ] **Integration test**
  - Create work item → verify in backlog
  - Move work item → verify in new location
  - Help → verify clean output

**Note:** Plugin commands use `/spearit-framework-light:*` namespace. Local framework commands (if installed) use `/fw-*` prefix.

### 8. Plugin Installation Test

- [ ] Uninstall current plugin (if installed)
- [ ] Clean install from local marketplace
- [ ] Verify only 3 skills appear in `/help`
- [ ] Execute each command to verify functionality

### 9. Update Related Work Items

- [ ] Update FEAT-118 status note:
  ```
  Status: Scope refined → Continued in TASK-126
  Removed features (session-history, next-id) deferred to full framework.
  ```
- [ ] Close/resolve any issues in FEAT-118 related to removed commands

---

## Acceptance Criteria

- [ ] Plugin contains exactly 3 commands: help, new, move
- [ ] `new` command automatically assigns sequential IDs
- [ ] All documentation reflects 3-command scope
- [ ] Plugin builds and installs cleanly
- [ ] All 3 commands tested and working
- [ ] Removed features preserved for future use
- [ ] CHANGELOG documents rationale for changes

---

## Decision Record

**Why remove session-history?**
- Documentation feature, not core workflow
- More complex, less frequently used
- Better served in full framework plugin

**Why remove next-id?**
- Implementation detail, not user concern
- `new` command should handle ID assignment internally
- Reduces cognitive load and command bloat

**MVP focuses on:**
- Discovery (help)
- Creation (new with auto-ID)
- Organization (move)

---

## Next Steps After Completion

1. Final submission review (FEAT-118 or new work item)
2. Marketplace submission
3. Plan full framework plugin (includes session-history)

---

## Notes

- Session history deferred, not abandoned
- Clean MVP = easier user onboarding
- Full framework provides upgrade path for power users

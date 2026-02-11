# Plugin Testing - Implementation Summary

**Date:** 2026-02-10
**Updated:** 2026-02-10 (FEAT-120 - Local marketplace approach)
**Related:** FEAT-118 (Claude Code Plugin MVP), FEAT-120 (Plugin Testing Infrastructure)

---

## Problem Statement

We needed a reliable way to test Claude Code plugins in both CLI and VSCode during development. Initial approach used manual cache manipulation, later replaced with Anthropic's official local marketplace pattern.

---

## Solution Implemented

Created comprehensive testing infrastructure with three testing methods:

### 1. CLI Testing (Fast Iteration)

**Command:**
```bash
claude --plugin-dir ./plugins/spearit-framework-light
```

**Use case:** Active development, quick iterations
**Pro:** Immediate changes, no cache management
**Con:** CLI only, doesn't test VSCode integration

### 2. Local Marketplace Installation (VSCode Testing)

**Script:** `tools/Publish-ToLocalMarketplace.ps1`

**Commands:**
```powershell
# Create/update local marketplace
.\tools\Publish-ToLocalMarketplace.ps1

# One-time setup (add marketplace)
/plugin marketplace add ../claude-local-marketplace

# Install plugin
/plugin install spearit-framework-light@dev-marketplace --scope local

# After changes (update and refresh)
.\tools\Publish-ToLocalMarketplace.ps1
/plugin marketplace update dev-marketplace
# Restart VSCode
```

**Use case:** VSCode integration testing
**Pro:** Uses official Anthropic plugin system, tests actual installation flow
**Con:** Requires VSCode restart for changes

### 3. ZIP Package Testing (Pre-Release)

**Command:**
```powershell
.\tools\Build-Plugin.ps1
Expand-Archive distrib\plugin-light\*.zip -Destination C:\temp\test
claude --plugin-dir C:\temp\test\spearit-framework-light
```

**Use case:** Final validation before release
**Pro:** Tests exact user experience
**Con:** Slowest method

---

## Files Created

### Helper Script
- **`tools/Publish-ToLocalMarketplace.ps1`** (~200 lines)
  - Auto-detects plugins in `plugins/` directory
  - Reads metadata from `plugin.json`
  - Creates marketplace.json at `../claude-local-marketplace/`
  - Supports `-Build` flag to build first
  - Supports `-Clean` flag to reset marketplace
  - Shows next-step instructions

### Documentation
- **`plugins/TESTING.md`** - Quick reference guide (updated for marketplace approach)
- **`plugins/MIGRATION-CACHE-TO-MARKETPLACE.md`** - Migration guide from old approach
- **`project-hub/research/plugin-best-practices.md`** - Updated with marketplace workflow
- **`project-hub/research/plugin-testing-summary.md`** (this file)

### Deprecated Scripts (Removed in FEAT-120)
- ~~`tools/Install-PluginToCache.ps1`~~ - Replaced by marketplace approach
- ~~`tools/Uninstall-PluginFromCache.ps1`~~ - Replaced by `/plugin uninstall`

---

## Key Findings from Research

### Local Marketplace Support
- **Official pattern:** Anthropic documents local marketplace as THE way to test locally
- **Location:** `../claude-local-marketplace/` (parallel to project repo)
- **Marketplace types:** GitHub repos, Git URLs, **local paths**, remote URLs
- **Source pointing:** Marketplace points to plugin source directory (no copying needed)
- **Ephemeral:** Marketplace can be deleted/recreated anytime

### VSCode Integration
- **Settings shared:** VSCode uses same `~/.claude/settings.json` as CLI
- **Plugin management:** Same marketplace system as CLI
- **Restart required:** VSCode must be restarted after marketplace updates
- **No special config:** No `--plugin-dir` equivalent for VSCode (use marketplace)

### Testing Discoveries
- CLI `--plugin-dir` fastest for active development
- Local marketplace tests actual installation UX
- Debug flag essential: `claude --debug --plugin-dir ...`
- Test from repository root (commands may need project structure)
- Marketplace approach uses official plugin system (better than cache manipulation)

---

## Testing Workflow

### During Active Development
```powershell
# 1. Make changes to plugin files

# 2. Test immediately with CLI
claude --plugin-dir ./plugins/spearit-framework-light --debug

# 3. If tests pass, commit
git commit -am "feat: Update X command"
```

### Before Milestones
```powershell
# 1. Update local marketplace
.\tools\Publish-ToLocalMarketplace.ps1

# 2. Refresh marketplace in Claude Code
/plugin marketplace update dev-marketplace

# 3. Restart VSCode

# 4. Test all commands
/spearit-framework-light:help
/spearit-framework-light:new
/spearit-framework-light:move
/spearit-framework-light:next-id
/spearit-framework-light:session-history

# 5. If all pass, mark milestone complete
```

### Before Release
```powershell
# 1. Build final package
.\tools\Build-Plugin.ps1

# 2. Extract and test
Expand-Archive distrib\plugin-light\*.zip -Destination C:\temp\release-test
claude --plugin-dir C:\temp\release-test\spearit-framework-light

# 3. Run full test suite

# 4. Tag release
git tag -a v1.0.0 -m "Release v1.0.0"
```

---

## Testing Checklist Template

**Each Command:**
- [ ] Invokes with namespace (`/plugin:command`)
- [ ] Help text correct
- [ ] Parameters validated
- [ ] Error messages clear
- [ ] Performance acceptable (budget: <5s utilities, <30s complex)
- [ ] No unexpected Task agents spawning
- [ ] Works in target environment (with structure)
- [ ] Graceful degradation (without structure)

**Plugin Overall:**
- [ ] Loads without errors (`--debug`)
- [ ] All commands in `/plugin list`
- [ ] No conflicts with local commands
- [ ] README documentation accurate
- [ ] Version correct in plugin.json
- [ ] LICENSE file present

**VSCode Integration:**
- [ ] Plugin in `/plugin list`
- [ ] Commands auto-complete
- [ ] Identical behavior to CLI
- [ ] No console errors
- [ ] Restart makes changes visible

---

## Performance Budgets

**Token usage:**
- Simple utilities: <1k tokens
- File operations: <2k tokens
- Complex operations: <5k tokens

**Execution time:**
- Simple utilities: <5 seconds
- File operations: <10 seconds
- Complex operations: <30 seconds

**Red flags:**
- Simple command >2k tokens → Likely spawning agents
- Command >10 seconds → Inefficient operations
- Inconsistent timing → External calls

---

## Common Issues & Solutions

### Issue: Plugin not found in VSCode
**Solution:**
1. Check marketplace added: `/plugin marketplace list`
2. Check plugin installed: `/plugin list`
3. If marketplace missing: `/plugin marketplace add ../claude-local-marketplace`
4. If plugin missing: `/plugin install spearit-framework-light@dev-marketplace --scope local`
5. Restart VSCode

### Issue: Changes not reflected
**Solution:**
1. Update marketplace: `.\tools\Publish-ToLocalMarketplace.ps1`
2. Refresh in Claude: `/plugin marketplace update dev-marketplace`
3. Restart VSCode
4. Changes should now be visible

### Issue: Command works in CLI, not VSCode
**Solution:**
1. Verify plugin installed (not just marketplace added): `/plugin list`
2. Restart VSCode (required for changes)
3. Check for VSCode-specific errors in console

### Issue: Command slow/expensive
**Solution:**
1. Run with `--debug` flag
2. Look for Task agent spawning
3. Add "Do NOT use Task tool" instructions
4. Add performance budgets

### Issue: Marketplace validation error "plugins.0.source: Invalid input"
**Root Cause:** Local marketplaces require plugin files to be **inside** the marketplace directory structure, not externally referenced.

**Solution:**
1. Use **directory junctions** (symlinks) to make plugin source appear inside marketplace
2. Script creates junction: `marketplace/plugin-name → project/plugins/plugin-name`
3. Set source field to: `"source": "./plugin-name"`
4. This enables live development while satisfying Claude Code validation

**Why this works:**
- Claude Code validates that source path resolves within marketplace
- Junction makes external plugin directory appear local
- Changes to source files are immediately reflected (no copying needed)
- Cross-platform compatible with forward slashes

**Technical Details:**
```powershell
# Create junction on Windows (symlink equivalent)
New-Item -ItemType Junction -Path "$marketplace/$pluginName" -Target "$source/$pluginName"

# marketplace.json source field
"source": "./$pluginName"  # Points to junction within marketplace
```

**What doesn't work:**
- ❌ Absolute paths: `"C:/path/to/plugin"`
- ❌ External relative paths: `"../project/plugins/plugin"`
- ❌ Backslashes: `"..\\project\\plugins\\plugin"`
- ✅ Local relative with forward slash: `"./plugin-name"` (inside marketplace)

---

## Resources

- **Quick reference:** `/plugins/TESTING.md`
- **Migration guide:** `/plugins/MIGRATION-CACHE-TO-MARKETPLACE.md`
- **Full workflow:** `/project-hub/research/plugin-best-practices.md#plugin-testing-workflow`
- **Standards:** `/project-hub/research/plugin-anthropic-standards.md`
- **Marketplace script:** `/tools/Publish-ToLocalMarketplace.ps1`
- **Build script:** `/tools/Build-Plugin.ps1`

---

## Web Sources

- [Discover and install plugins](https://code.claude.com/docs/en/discover-plugins)
- [Create and distribute a plugin marketplace](https://code.claude.com/docs/en/plugin-marketplaces)
- [Add from local paths](https://code.claude.com/docs/en/discover-plugins#add-from-local-paths)
- [Plugins Reference](https://code.claude.com/docs/en/plugins-reference)

---

**Last Updated:** 2026-02-10 (Updated for FEAT-120 - Local marketplace approach)
**Status:** Complete - Testing infrastructure uses official Anthropic patterns

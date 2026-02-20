# Plugin Testing - Implementation Summary

**Date:** 2026-02-10
**Updated:** 2026-02-11 (Added two-level plugin architecture and project-level enablement)
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
1. **Did you change `plugin.json`?**
   - **No** (just command files): Just restart VSCode - symlink handles it
   - **Yes** (metadata changed):
     1. Update marketplace: `.\tools\Publish-ToLocalMarketplace.ps1`
     2. Refresh in Claude: `/plugin marketplace update dev-marketplace`
     3. Restart VSCode
2. If still not working, check plugin is installed: `/plugin list`

**Why this happens:** The marketplace uses directory junctions (symlinks) to the plugin source. Code changes are immediately visible through the symlink - only `plugin.json` metadata requires republishing to the marketplace.

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

### Issue: Plugin uninstall fails with contradictory errors
**Symptom:** VSCode UI and CLI give different error messages about plugin scope:
- VSCode: "Plugin is installed in local scope, not user. Use --scope local to uninstall."
- CLI with `--scope local`: "Plugin is not installed in local scope."
- `claude plugin list` shows: "Scope: local"

**Root Cause:** Bug in Claude CLI's uninstall logic when dealing with local-scoped plugins installed from directory-based marketplaces.

**Solution - Manual Uninstall:**

1. **Delete cached plugin directory:**
   ```powershell
   Remove-Item -Recurse -Force "~/.claude/plugins/cache/{marketplace-name}/{plugin-name}"
   ```

2. **Edit installed_plugins.json:**
   - Location: `~/.claude/plugins/installed_plugins.json`
   - Remove the plugin entry from the `plugins` object:
   ```json
   {
     "version": 2,
     "plugins": {
       "plugin-name@marketplace": [...]  // Delete this entire entry
     }
   }
   ```

3. **Restart VSCode/Claude Code**

4. **Verify removal:** `claude plugin list`

**Understanding Claude's Plugin Storage:**

During troubleshooting, we discovered Claude's internal plugin storage structure:

```
~/.claude/plugins/
├── marketplaces/
│   └── claude-plugins-official/     # GitHub marketplaces cloned here
├── cache/
│   ├── claude-plugins-official/     # Installed plugins from official
│   └── dev-marketplace/             # Installed plugins from local marketplace
│       └── spearit-framework-light/
│           └── 1.0.0/               # Plugin files cached here
├── known_marketplaces.json          # Marketplace registry
└── installed_plugins.json           # Plugin installation metadata
```

**Key insights:**
- **GitHub marketplaces** are cloned to `marketplaces/` directory
- **Directory marketplaces** (local dev) are NOT copied, just referenced
- **All installed plugins** are cached to `cache/{marketplace}/{plugin}/{version}/` regardless of source type
- **Metadata is separate** from cache - both must be cleaned for manual uninstall
- **Storage is well-structured JSON** that can be safely edited manually when CLI fails

**known_marketplaces.json structure:**
```json
{
  "dev-marketplace": {
    "source": {
      "source": "directory",
      "path": "c:\\Users\\...\\claude-local-marketplace"
    },
    "installLocation": "c:\\Users\\...\\claude-local-marketplace",
    "lastUpdated": "2026-02-11T02:33:35.500Z"
  }
}
```

**installed_plugins.json structure:**
```json
{
  "version": 2,
  "plugins": {
    "spearit-framework-light@dev-marketplace": [
      {
        "scope": "local",
        "installPath": "C:\\Users\\...\\cache\\dev-marketplace\\spearit-framework-light\\1.0.0",
        "version": "1.0.0",
        "installedAt": "2026-02-11T14:03:54.639Z",
        "lastUpdated": "2026-02-11T14:03:54.639Z",
        "projectPath": "c:\\Users\\...\\project-framework"
      }
    ]
  }
}
```

### Issue: Plugin reinstalls after manual removal
**Symptom:** After deleting cache and clearing `installed_plugins.json`, restarting Claude CLI reinstalls the plugin automatically.

**Root Cause:** Project-level `enabledPlugins` setting in `.claude/settings.local.json` tells Claude CLI to auto-install the plugin for this project.

**Solution - Understanding Plugin Architecture:**

Claude Code uses a **two-level plugin architecture**:

#### Global Level: `~/.claude/plugins/`
- **Installed plugins** (`installed_plugins.json`) - which plugins exist on the system
- **Plugin cache** (`cache/{marketplace}/{plugin}/{version}/`) - the actual plugin files
- **Scope metadata** - whether plugin is `user` (all projects) or `local` (specific project)
- **Marketplace registry** (`known_marketplaces.json`) - available plugin sources

#### Project Level: `.claude/settings.local.json`
- **Enabled plugins** (`enabledPlugins` object) - which installed plugins are active for *this* project
- Can enable/disable any installed plugin regardless of its installation scope
- Setting is checked on CLI startup and triggers auto-installation if needed

#### Plugin States in Project Settings

```json
// Enabled: Plugin is active for this project
"enabledPlugins": {
  "plugin-name@marketplace": true
}

// Disabled: Plugin is associated but not loaded (fast re-enable)
"enabledPlugins": {
  "plugin-name@marketplace": false
}

// Removed: Plugin has no association with this project
"enabledPlugins": {}
```

#### Managing Plugin State During Development

**For active testing:**
```json
"enabledPlugins": {
  "spearit-framework-light@dev-marketplace": true
}
```

**To pause testing (keeps cache, fast resume):**
```json
"enabledPlugins": {
  "spearit-framework-light@dev-marketplace": false
}
```

**To completely remove from project (deletes cache):**
```json
"enabledPlugins": {}
```

#### Complete Uninstall Procedure

To remove a plugin from ALL projects:

1. **Remove from project settings** (`.claude/settings.local.json`):
   - Set to `false` (disable) or `{}` (remove)

2. **Delete global cache:**
   ```powershell
   Remove-Item -Recurse -Force "~/.claude/plugins/cache/{marketplace}/{plugin}"
   ```

3. **Edit global metadata** (`~/.claude/plugins/installed_plugins.json`):
   - Remove the plugin entry from `plugins` object

4. **Restart VSCode/Claude Code**

5. **Verify:** `claude plugin list` should not show the plugin

**Key Insight:** Project settings drive installation. Even if you clear global state, Claude CLI will reinstall if project has `enabledPlugins: true`. Always start with project settings when uninstalling.

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

## Update: 2026-02-20 — Cache Accumulation Problem & Tooling Refactor

### What We Learned

The `/plugin marketplace update dev-marketplace` command does **not** clean stale cache
versions. Each publish creates a new versioned folder under `~/.claude/plugins/cache/dev-marketplace/{plugin}/`.
The `installed_plugins.json` file stays pinned to whichever version was first installed,
regardless of how many times you update the marketplace.

After several development cycles, this resulted in:
- 10 stale version folders in cache
- `installed_plugins.json` pointing to `1.0.3` while source was at `1.0.4`
- Plugin commands loading from old cached versions

### What Changed

**`Publish-ToLocalMarketplace.ps1` was simplified to a single responsibility:**

Always performs a full clean reset — no parameters needed:
1. Wipes the marketplace directory
2. Deletes `~/.claude/plugins/cache/dev-marketplace/` (all versions)
3. Removes dev-marketplace entries from `installed_plugins.json`
4. Recreates marketplace with fresh junctions

Previous `-Clean`, `-Build`, and `-Plugin` flags were removed:
- `-Clean` was inconsistently applied; now clean is always the default behavior
- `-Build` belonged in `Build-Plugin.ps1`, not here — junctions make builds unnecessary for testing
- `-Plugin` scoping on clean left the other plugin's stale cache intact

**Bug fixed:** `Remove-Item -Recurse` on a Windows junction follows the junction and
deletes the target contents (your source files). Replaced with `[System.IO.Directory]::Delete()`
which removes only the junction point.

### Revised Understanding of the Cache

The version-per-folder cache structure means:
- Old versions are never automatically evicted
- `installed_plugins.json` must be manually updated to point to new versions
- The only reliable way to get a clean state is to delete the entire plugin's cache folder

This is why the script now always does a full wipe rather than attempting incremental updates.

---

**Last Updated:** 2026-02-20
**Status:** Complete - Testing infrastructure uses official Anthropic patterns

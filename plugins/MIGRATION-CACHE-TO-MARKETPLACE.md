# Migration Guide: Cache Scripts → Local Marketplace

**Date:** 2026-02-10
**Related:** FEAT-120 (Plugin Testing Infrastructure Refactor)

---

## Overview

This guide helps you migrate from the **old cache manipulation approach** to the **new local marketplace approach** for plugin testing.

**Why the change?**
- ✅ Uses Anthropic's official plugin system
- ✅ Tests actual user installation flow
- ✅ Proper scope management (user/project/local)
- ✅ Simpler, better documented
- ✅ Works identically in CLI and VSCode

---

## What Changed

### Old Approach (Deprecated)
```powershell
# Install to cache manually
.\tools\Install-PluginToCache.ps1 -Force

# Uninstall from cache manually
.\tools\Uninstall-PluginFromCache.ps1 -Plugin spearit-framework-light -Force
```

**Problems:**
- Bypassed official plugin system
- Direct cache manipulation (brittle)
- Didn't test real installation flow
- Non-standard approach

### New Approach (Recommended)
```powershell
# One-time setup: Create local marketplace
.\tools\Publish-ToLocalMarketplace.ps1
/plugin marketplace add ../claude-local-marketplace
/plugin install spearit-framework-light@dev-marketplace --scope local

# After changes: Update and refresh
.\tools\Publish-ToLocalMarketplace.ps1
/plugin marketplace update dev-marketplace
# Restart VSCode
```

**Benefits:**
- Uses official `/plugin install` workflow
- Tests actual user experience
- Documented by Anthropic
- Simpler mental model

---

## Migration Steps

### Step 1: Clean Up Old Installation

If you have the plugin installed via cache scripts:

```powershell
# Uninstall from cache (if previously installed)
.\tools\Uninstall-PluginFromCache.ps1 -Plugin spearit-framework-light -Force

# Or manually delete cache directory
Remove-Item -Recurse -Force "$env:USERPROFILE\.claude\plugins\cache\spearit-framework-light"

# Restart VSCode
# Verify removal with /plugin list
```

### Step 2: Set Up Local Marketplace (One-Time)

```powershell
# Navigate to project repo
cd C:\...\project-framework

# Create local marketplace
.\tools\Publish-ToLocalMarketplace.ps1

# Add marketplace to Claude Code (in Claude CLI or VSCode)
/plugin marketplace add ../claude-local-marketplace

# Install plugin
/plugin install spearit-framework-light@dev-marketplace --scope local

# Restart VSCode
```

**Verify installation:**
```
/plugin list
```
You should see `spearit-framework-light` listed.

### Step 3: Update Your Workflow

**Old workflow:**
```powershell
# Make changes → Reinstall cache → Restart
.\tools\Install-PluginToCache.ps1 -Force
```

**New workflow:**
```powershell
# Make changes → Update marketplace → Refresh → Restart
.\tools\Publish-ToLocalMarketplace.ps1
/plugin marketplace update dev-marketplace
# Restart VSCode
```

---

## Common Migration Issues

### Issue: "Marketplace not found"

**Cause:** Marketplace path is relative, must run from project root

**Solution:**
```powershell
# Ensure you're in project root
cd C:\Users\gelliott\OneDrive\Documents\SpearIT\Projects\project-framework

# Then add marketplace
/plugin marketplace add ../claude-local-marketplace
```

### Issue: "Plugin already installed in cache"

**Cause:** Old cache installation still present

**Solution:**
```powershell
# Remove old cache version
.\tools\Uninstall-PluginFromCache.ps1 -Plugin spearit-framework-light -Force

# Restart VSCode

# Install via marketplace
/plugin install spearit-framework-light@dev-marketplace --scope local
```

### Issue: Changes not reflected after update

**Cause:** Forgot to refresh marketplace or restart

**Solution:**
```powershell
# After updating marketplace, MUST refresh
/plugin marketplace update dev-marketplace

# AND restart VSCode (required)
```

### Issue: Want to reset everything

**Cause:** Testing environment got messy

**Solution:**
```powershell
# 1. Uninstall plugin
/plugin uninstall spearit-framework-light

# 2. Recreate marketplace
.\tools\Publish-ToLocalMarketplace.ps1 -Clean

# 3. Reinstall
/plugin install spearit-framework-light@dev-marketplace --scope local

# 4. Restart VSCode
```

---

## Side-by-Side Comparison

| Task | Old (Cache Scripts) | New (Local Marketplace) |
|------|---------------------|-------------------------|
| **Initial setup** | `Install-PluginToCache.ps1 -Force` | `Publish-ToLocalMarketplace.ps1`<br>`/plugin marketplace add`<br>`/plugin install` |
| **After changes** | `Install-PluginToCache.ps1 -Force`<br>Restart VSCode | `Publish-ToLocalMarketplace.ps1`<br>`/plugin marketplace update`<br>Restart VSCode |
| **Uninstall** | `Uninstall-PluginFromCache.ps1 -Plugin X -Force` | `/plugin uninstall X` |
| **Clean slate** | `Uninstall-PluginFromCache.ps1 -All -Force` | `Publish-ToLocalMarketplace.ps1 -Clean`<br>`/plugin install ...` |
| **Check status** | `dir %USERPROFILE%\.claude\plugins\cache\` | `/plugin list`<br>`/plugin marketplace list` |

---

## FAQ

### Do I need to keep the old scripts?

**No.** The cache scripts (`Install-PluginToCache.ps1` and `Uninstall-PluginFromCache.ps1`) are deprecated and will be removed. Use the marketplace approach going forward.

### Can I still use `--plugin-dir` for CLI testing?

**Yes!** CLI testing with `--plugin-dir` is still the fastest method for active development:
```bash
claude --plugin-dir ./plugins/spearit-framework-light
```

The marketplace approach is specifically for **VSCode integration testing**.

### Where is the marketplace located?

**Location:** `../claude-local-marketplace/` (parallel to project repo)

This is an **ephemeral testing directory** that can be deleted and recreated anytime. It's not tracked in git and exists solely for local testing.

### What if I already have a plugin installed via cache?

**Recommendation:** Uninstall the cache version and reinstall via marketplace to ensure clean state:

```powershell
# Remove cache version
.\tools\Uninstall-PluginFromCache.ps1 -Plugin spearit-framework-light -Force

# Install via marketplace
/plugin install spearit-framework-light@dev-marketplace --scope local
```

### Do I need to recreate the marketplace after every change?

**Only if metadata changed.** The marketplace.json points to the plugin source directory, so code changes are picked up automatically after a restart. Only run `Publish-ToLocalMarketplace.ps1` if you changed `plugin.json` fields (version, name, etc.).

**Code changes:** Just restart VSCode
**Metadata changes:** Run script, update marketplace, restart VSCode

### Can I use both approaches at the same time?

**Not recommended.** Having the same plugin installed via both cache and marketplace can cause conflicts. Choose one approach (marketplace recommended).

---

## Benefits of Local Marketplace Approach

### For Development
- ✅ Tests actual installation UX
- ✅ Proper scope management (local, project, user)
- ✅ Version tracking
- ✅ Matches production installation flow

### For Documentation
- ✅ Officially documented by Anthropic
- ✅ Clear, standard workflow
- ✅ Easy to explain to contributors
- ✅ Future-proof (won't break with updates)

### For Maintenance
- ✅ Less code to maintain (~200 lines vs 798)
- ✅ Uses platform features (not hacks)
- ✅ Clearer mental model
- ✅ Easier troubleshooting

---

## Getting Help

**Resources:**
- Quick reference: [TESTING.md](TESTING.md)
- Detailed workflow: [../project-hub/research/plugin-best-practices.md](../project-hub/research/plugin-best-practices.md)
- Official docs: [code.claude.com/docs/en/plugin-marketplaces](https://code.claude.com/docs/en/plugin-marketplaces)

**Common issues:**
- See "Common Issues" section in [TESTING.md](TESTING.md)
- Check debug logs: `claude --debug`
- Verify marketplace: `/plugin marketplace list`
- Verify installation: `/plugin list`

---

**Last Updated:** 2026-02-10
**Status:** Active - Use this guide to migrate from cache to marketplace approach

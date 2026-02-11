# Plugin Testing Quick Reference

Quick reference for testing Claude Code plugins during development.

---

## Quick Start

### CLI Testing (Fastest)

```bash
# Navigate to repo root
cd %USERPROFILE%\OneDrive\Documents\SpearIT\Projects\project-framework

# Test plugin directly
claude --plugin-dir ./plugins/spearit-framework-light

# With debug logging
claude --plugin-dir ./plugins/spearit-framework-light --debug
```

### VSCode Testing (One-Time Setup)

```powershell
# 1. Create local marketplace
.\tools\Publish-ToLocalMarketplace.ps1

# 2. Add marketplace to Claude Code (in Claude CLI or VSCode)
/plugin marketplace add ../claude-local-marketplace

# 3. Install plugin
/plugin install spearit-framework-light@dev-marketplace --scope local
```

**After changes to plugin:**
```powershell
# Update marketplace (if metadata changed)
.\tools\Publish-ToLocalMarketplace.ps1

# Refresh in Claude Code
/plugin marketplace update dev-marketplace

# Restart Claude Code/VSCode
```

---

## Testing Methods Comparison

| Method | Speed | VSCode | Use Case |
|--------|-------|--------|----------|
| `--plugin-dir` | ⚡ Fast | ❌ No | Active development |
| Local marketplace | 🐌 Moderate | ✅ Yes | Integration testing |
| ZIP package | 🐌 Slowest | ✅ Yes | Pre-release validation |

---

## Helper Scripts

### Publish-ToLocalMarketplace.ps1

```powershell
# Create/update local marketplace
.\tools\Publish-ToLocalMarketplace.ps1

# Build plugin first, then update marketplace
.\tools\Publish-ToLocalMarketplace.ps1 -Build

# Reset marketplace (delete and recreate)
.\tools\Publish-ToLocalMarketplace.ps1 -Clean
```

**What it does:**
1. Auto-detects plugins in `plugins/` directory
2. Reads metadata from `plugin.json`
3. Creates marketplace.json at `../claude-local-marketplace/`
4. Shows next-step instructions for first-time setup

**Marketplace location:** `../claude-local-marketplace/` (parallel to project repo)

**Use cases:**
- Initial setup for local testing
- Update marketplace after metadata changes
- Reset testing environment with `-Clean`
- Build and publish in one step with `-Build`

### Build-Plugin.ps1

```powershell
# Build all plugins
.\tools\Build-Plugin.ps1

# Build specific plugin
.\tools\Build-Plugin.ps1 -Plugin spearit-framework-light
```

**Output:** `distrib/plugin-light/spearit-framework-light-vX.Y.Z.zip`

---

## Common Issues

### "Plugin not found" in VSCode

**Solution:**
1. Check marketplace: `/plugin marketplace list`
2. Check installed: `/plugin list`
3. If marketplace not added: `/plugin marketplace add ../claude-local-marketplace`
4. If not installed: `/plugin install spearit-framework-light@dev-marketplace --scope local`
5. Restart VSCode

### Need clean baseline for testing

**Solution:**
1. Uninstall: `/plugin uninstall spearit-framework-light`
2. Restart VSCode
3. Verify removal: `/plugin list`
4. Reinstall fresh: `/plugin install spearit-framework-light@dev-marketplace --scope local`

### Changes not reflected after installation

**Solution:**
1. Update marketplace: `.\tools\Publish-ToLocalMarketplace.ps1`
2. Refresh in Claude: `/plugin marketplace update dev-marketplace`
3. Restart VSCode/Claude Code
4. Changes should now be visible

### Command works in CLI but not VSCode

**Solution:**
1. Verify plugin installed: `/plugin list` (should show spearit-framework-light)
2. Restart VSCode (required for changes)
3. If still missing, reinstall via marketplace

### Performance issues (slow commands)

**Check:**
1. Run with `--debug` flag
2. Look for "Task tool" or agent spawning in logs
3. Review command file for vague instructions
4. Add explicit "Do NOT use Task tool" directives

---

## Testing Checklist

**Each Command:**
- [ ] Invokes with correct namespace
- [ ] Help text displays
- [ ] Parameters validated
- [ ] Error messages clear
- [ ] Performance acceptable
- [ ] No unexpected agents
- [ ] Works with/without project structure

**Plugin Overall:**
- [ ] Loads without errors (`--debug`)
- [ ] Listed in `/plugin list`
- [ ] No command conflicts
- [ ] README matches reality
- [ ] Version correct in plugin.json
- [ ] LICENSE present

**VSCode:**
- [ ] Appears in `/plugin list`
- [ ] Commands auto-complete
- [ ] Works identically to CLI
- [ ] No console errors

---

## Local Marketplace

**Location:** `../claude-local-marketplace/` (parallel to project repo)
**Purpose:** Ephemeral testing infrastructure for local development
**Can be deleted/recreated anytime** - it's just testing infrastructure

## Resources

- **Plugin overview:** [README.md](README.md)
- **Detailed workflow:** [../project-hub/research/plugin-best-practices.md](../project-hub/research/plugin-best-practices.md#plugin-testing-workflow)
- **Plugin standards:** [../project-hub/research/plugin-anthropic-standards.md](../project-hub/research/plugin-anthropic-standards.md)
- **Marketplace script:** [../tools/Publish-ToLocalMarketplace.ps1](../tools/Publish-ToLocalMarketplace.ps1)
- **Build script:** [../tools/Build-Plugin.ps1](../tools/Build-Plugin.ps1)
- **Migration guide:** [MIGRATION-CACHE-TO-MARKETPLACE.md](MIGRATION-CACHE-TO-MARKETPLACE.md)

## Official Documentation

- [Discover and install plugins](https://code.claude.com/docs/en/discover-plugins)
- [Create and distribute a plugin marketplace](https://code.claude.com/docs/en/plugin-marketplaces)
- [Add from local paths](https://code.claude.com/docs/en/discover-plugins#add-from-local-paths)

---

**Last Updated:** 2026-02-10

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
# CRITICAL: Cache updates require version number changes!
# Claude Code uses semantic versioning to determine if cache needs updating.

# 1. Bump version in plugin.json
#    Example: 1.0.0-dev1 → 1.0.0-dev2

# 2. Build and publish (includes -AllowPrerelease for dev versions)
.\tools\Publish-ToLocalMarketplace.ps1 -Build

# 3. Update marketplace metadata
/plugin marketplace update dev-marketplace

# 4. Update installed plugin
/plugin update spearit-framework-light@dev-marketplace --scope local

# 5. Restart VSCode

# 6. Verify changes
/plugin list  # Should show new version number
```

**Why version bumping is required:**
- The marketplace uses a directory junction (symlink) to your source: `marketplace/plugin-name → plugins/plugin-name`
- BUT the installed plugin is **copied** to cache at install time: `~/.claude/plugins/cache/dev-marketplace/spearit-framework-light/VERSION/`
- Cache only updates when the version number changes
- Same version = no recopy, even after `/plugin marketplace update`

**Development versioning strategy:**
- Use pre-release versions during development: `1.0.0-dev1`, `1.0.0-dev2`, etc.
- Reset to clean version for production: `1.0.0`
- See "Development Versioning" section below for details

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
# Build for production (strict version validation - rejects pre-release versions)
.\tools\Build-Plugin.ps1 -Plugin spearit-framework-light

# Build for development (allows pre-release versions like 1.0.0-dev1)
.\tools\Build-Plugin.ps1 -Plugin spearit-framework-light -AllowPrerelease
```

**Output:** `distrib/plugin-light/spearit-framework-light-vX.Y.Z.zip`

**Version validation:**
- **Strict mode (default):** Only accepts clean semver (e.g., `1.0.0`, `2.1.3`)
- **Permissive mode (-AllowPrerelease):** Accepts pre-release versions (e.g., `1.0.0-dev1`, `2.0.0-beta.1`)
- Prevents invalid versions from causing marketplace submission failures
- `Publish-ToLocalMarketplace.ps1 -Build` automatically adds `-AllowPrerelease` for development workflow

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

**Root Cause:** Cache updates require version number changes (discovered 2026-02-12)

**Solution:**
1. **Bump version** in `.claude-plugin/plugin.json`
   - Example: `1.0.0-dev1` → `1.0.0-dev2`
   - Use pre-release versions during development (see "Development Versioning" below)

2. **Run complete update workflow:**
   ```powershell
   .\tools\Publish-ToLocalMarketplace.ps1 -Build
   /plugin marketplace update dev-marketplace
   /plugin update spearit-framework-light@dev-marketplace --scope local
   # Restart VSCode
   ```

3. **Verify:** `/plugin list` should show new version number

**Why this happens:**
- Claude Code uses semantic versioning to determine cache updates
- Same version = no recopy from marketplace to cache
- The marketplace junction is live, but VSCode loads from **cached copy**

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

## Development Versioning

**Problem:** Cache updates require version number changes

**Solution:** Use pre-release versions during development

**Workflow:**
```powershell
# Start development
# Set version in plugin.json: "1.0.0-dev1"

# Make changes, test
.\tools\Publish-ToLocalMarketplace.ps1 -Build
# ... test in VSCode ...

# More changes needed? Bump version
# Update plugin.json: "1.0.0-dev1" → "1.0.0-dev2"
.\tools\Publish-ToLocalMarketplace.ps1 -Build
# ... test again ...

# Ready for production? Reset to clean version
# Update plugin.json: "1.0.0-dev5" → "1.0.0"
.\tools\Build-Plugin.ps1 -Plugin spearit-framework-light  # Strict mode
```

**Version format requirements:**
- **Valid:** `1.0.0-dev1`, `1.0.0-dev2`, `2.0.0-beta.1`, `1.0.0-rc.1`
- **Invalid:** `1.0.0.1` (4-part), `1.0.0_dev1` (underscore), `1.0.0-` (empty suffix)
- Must start with `-` for pre-release or `+` for build metadata
- Use semantic versioning (MAJOR.MINOR.PATCH)

**Key insight:** Version bumping is **required** for cache updates, not optional.

---

## Local Marketplace Architecture

**Location:** `../claude-local-marketplace/` (parallel to project repo)
**Purpose:** Ephemeral testing infrastructure for local development
**Can be deleted/recreated anytime** - it's just testing infrastructure

**How it works (Two-Level Architecture):**

1. **Marketplace Level:** Uses directory junctions (symlinks) pointing to plugin source
   ```
   marketplace/spearit-framework-light → project/plugins/spearit-framework-light
   ```

2. **Cache Level:** Installed plugins are **copied** to cache at install/update time
   ```
   ~/.claude/plugins/cache/dev-marketplace/spearit-framework-light/VERSION/
   ```

**Critical understanding:**
- Marketplace junction is live (changes immediately visible in marketplace)
- Cache is a **copy** (requires version bump + update to refresh)
- VSCode loads from **cache**, not marketplace
- Version number drives cache updates (same version = no recopy)

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

**Last Updated:** 2026-02-12 (Updated with version bumping workflow and cache architecture)

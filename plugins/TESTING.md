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

### VSCode Testing

```powershell
# Install to cache
.\tools\Install-PluginToCache.ps1 -Force

# Restart VSCode

# Test commands
/spearit-framework-light:help
/spearit-framework-light:new
/spearit-framework-light:next-id
```

---

## Testing Methods Comparison

| Method | Speed | VSCode | Use Case |
|--------|-------|--------|----------|
| `--plugin-dir` | ⚡ Fast | ❌ No | Active development |
| Cache install | 🐌 Slow | ✅ Yes | Integration testing |
| ZIP package | 🐌 Slowest | ✅ Yes | Pre-release validation |

---

## Helper Scripts

### Install-PluginToCache.ps1

```powershell
# Basic usage (builds and installs)
.\tools\Install-PluginToCache.ps1

# Force reinstall
.\tools\Install-PluginToCache.ps1 -Force

# Skip build (faster for minor changes)
.\tools\Install-PluginToCache.ps1 -NoBuild -Force

# Specific plugin
.\tools\Install-PluginToCache.ps1 -Plugin spearit-framework-light -Force
```

**What it does:**
1. Validates plugin structure
2. Runs Build-Plugin.ps1 (unless `-NoBuild`)
3. Clears cache (if `-Force`)
4. Copies to `%USERPROFILE%\.claude\plugins\cache\`
5. Verifies installation

### Uninstall-PluginFromCache.ps1

```powershell
# List installed plugins
.\tools\Uninstall-PluginFromCache.ps1

# Uninstall specific plugin (with confirmation)
.\tools\Uninstall-PluginFromCache.ps1 -Plugin spearit-framework-light

# Uninstall without confirmation
.\tools\Uninstall-PluginFromCache.ps1 -Plugin spearit-framework-light -Force

# Clear entire cache (nuclear option)
.\tools\Uninstall-PluginFromCache.ps1 -All -Force
```

**What it does:**
1. Lists installed plugins (if no args)
2. Shows plugin info before removal
3. Removes from cache
4. Verifies removal

**Use cases:**
- Return to baseline state for clean testing
- Remove development versions before marketplace install
- Clear cache when troubleshooting
- Test fresh installation experience

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
1. Check cache: `dir %USERPROFILE%\.claude\plugins\cache\`
2. Reinstall: `.\tools\Install-PluginToCache.ps1 -Force`
3. Restart VSCode

### Need clean baseline for testing

**Solution:**
1. Uninstall: `.\tools\Uninstall-PluginFromCache.ps1 -Plugin spearit-framework-light -Force`
2. Restart VSCode
3. Verify removal: `/plugin list`
4. Reinstall fresh: `.\tools\Install-PluginToCache.ps1 -Force`

### Changes not reflected after cache install

**Solution:**
1. Close VSCode completely
2. Reopen VSCode
3. Test commands again

### Command works in CLI but not VSCode

**Solution:**
1. Verify you installed to cache: `.\tools\Install-PluginToCache.ps1 -Force`
2. Restart VSCode (required for changes)
3. Check `/plugin list` to verify installation

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

## Cache Locations

- **Windows:** `%USERPROFILE%\.claude\plugins\cache\`
- **Mac/Linux:** `~/.claude/plugins/cache/`

## Resources

- **Plugin overview:** [README.md](README.md)
- **Detailed workflow:** [../project-hub/research/plugin-best-practices.md](../project-hub/research/plugin-best-practices.md#plugin-testing-workflow)
- **Plugin standards:** [../project-hub/research/plugin-anthropic-standards.md](../project-hub/research/plugin-anthropic-standards.md)
- **Build process:** [../tools/Build-Plugin.ps1](../tools/Build-Plugin.ps1)

---

**Last Updated:** 2026-02-10

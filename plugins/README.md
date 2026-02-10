# Plugin Development

This directory contains Claude Code plugins developed from the SpearIT Project Framework.

---

## Current Plugins

### [spearit-framework-light/](spearit-framework-light/)

Lightweight edition plugin for solo developers. Provides file-based Kanban workflow without requiring full framework installation.

**Version:** 1.0.0 (in development)
**Commands:** 5 (help, new, move, next-id, session-history)
**Target:** Solo developers using Claude Code

---

## Quick Start

### Testing a Plugin

See **[TESTING.md](TESTING.md)** for complete testing workflow.

**Quick commands:**
```powershell
# CLI testing (fastest)
claude --plugin-dir ./plugins/spearit-framework-light

# VSCode testing
.\tools\Install-PluginToCache.ps1 -Force
# Restart VSCode

# Build package
.\tools\Build-Plugin.ps1
```

### Building a Plugin

1. Develop plugin in `plugins/<plugin-name>/`
2. Test with CLI: `claude --plugin-dir ./plugins/<plugin-name>`
3. Build package: `.\tools\Build-Plugin.ps1 -Plugin <plugin-name>`
4. Output: `distrib/plugin-<edition>/<plugin-name>-vX.Y.Z.zip`

---

## Documentation

### Quick Reference
- **[TESTING.md](TESTING.md)** - Testing workflow, helper scripts, common issues

### Detailed Guides
- **[../project-hub/research/anthropic-plugin-standards.md](../project-hub/research/anthropic-plugin-standards.md)** - Official Anthropic plugin structure and requirements
- **[../project-hub/research/claude-plugin-best-practices.md](../project-hub/research/claude-plugin-best-practices.md)** - Lessons learned, performance optimization, testing strategies
- **[../project-hub/research/plugin-testing-summary.md](../project-hub/research/plugin-testing-summary.md)** - Implementation summary and key findings

### Helper Scripts
- **[../tools/Build-Plugin.ps1](../tools/Build-Plugin.ps1)** - Build distributable ZIP package
- **[../tools/Install-PluginToCache.ps1](../tools/Install-PluginToCache.ps1)** - Install plugin to cache for VSCode testing
- **[../tools/Uninstall-PluginFromCache.ps1](../tools/Uninstall-PluginFromCache.ps1)** - Remove plugin from cache (return to baseline)

---

## Plugin Editions

The SpearIT Project Framework is distributed as multiple plugin editions:

| Edition | Namespace | Scope | Target Audience |
|---------|-----------|-------|-----------------|
| **Light** | `spearit-framework-light` | 5 core commands | Solo developers |
| **Full** | `spearit-framework` | Complete framework | Teams and advanced users |

**Current status:**
- ✅ Lightweight edition: In development (FEAT-118)
- ⏳ Full edition: Planned for future release

---

## Development Workflow

### Active Development
```bash
# Make changes to plugin files
# Test immediately with CLI (no cache management)
cd %USERPROFILE%\OneDrive\Documents\SpearIT\Projects\project-framework
claude --plugin-dir ./plugins/spearit-framework-light --debug
```

### Integration Testing
```powershell
# Install to cache for VSCode testing
.\tools\Install-PluginToCache.ps1 -Force

# Restart VSCode
# Test all commands in VSCode
```

### Pre-Release Testing
```powershell
# Build final package
.\tools\Build-Plugin.ps1

# Test extracted ZIP
Expand-Archive distrib\plugin-light\*.zip -Destination C:\temp\test
claude --plugin-dir C:\temp\test\spearit-framework-light
```

---

## Related Work Items

**Current development:**
- FEAT-118: Claude Code Plugin MVP (Lightweight Edition)
- FEAT-119: Plugin "new" Command ✅ Complete

**See:** [../project-hub/work/doing/](../project-hub/work/doing/)

---

**Last Updated:** 2026-02-10

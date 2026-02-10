# Plugin Testing - Implementation Summary

**Date:** 2026-02-10
**Related:** FEAT-118 (Claude Code Plugin MVP)

---

## Problem Statement

We needed a reliable way to test Claude Code plugins in both CLI and VSCode during development. The challenge: plugins are **copied to cache** (not symlinked) for security, requiring manual cache management.

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

### 2. Cache Installation (VSCode Testing)

**Script:** `tools/Install-PluginToCache.ps1`

**Commands:**
```powershell
# Full install (build + cache)
.\tools\Install-PluginToCache.ps1 -Force

# Quick install (no build)
.\tools\Install-PluginToCache.ps1 -NoBuild -Force
```

**Use case:** VSCode integration testing
**Pro:** Tests real installation experience
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
- **`tools/Install-PluginToCache.ps1`** (300+ lines)
  - Auto-detects plugins
  - Builds plugin (optional)
  - Clears cache
  - Copies to `%USERPROFILE%\.claude\plugins\cache\`
  - Verifies installation
  - Shows next steps

### Documentation
- **`plugins/TESTING.md`** (root) - Quick reference guide
- **`project-hub/research/claude-plugin-best-practices.md`** - Updated with full testing workflow section
- **`project-hub/research/anthropic-plugin-standards.md`** - Added testing cross-references
- **`project-hub/research/plugin-testing-summary.md`** (this file)

---

## Key Findings from Research

### Cache Behavior
- **Location (Windows):** `%USERPROFILE%\.claude\plugins\cache\`
- **Location (Mac/Linux):** `~/.claude/plugins/cache/`
- **Behavior:** Plugins are **copied**, not symlinked
- **Reason:** Security - prevents access to files outside plugin
- **Impact:** Manual cache clearing required for updates

### VSCode Integration
- **Settings shared:** VSCode uses same `~/.claude/settings.json` as CLI
- **Plugin management:** Same cache location as CLI
- **Restart required:** VSCode must be restarted to see cache changes
- **No special config:** No `--plugin-dir` equivalent for VSCode

### Testing Discoveries
- CLI `--plugin-dir` bypasses cache (fastest for development)
- VSCode requires cache installation + restart
- Debug flag essential: `claude --debug --plugin-dir ...`
- Test from repository root (commands may need project structure)

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
# 1. Install to cache for VSCode testing
.\tools\Install-PluginToCache.ps1 -Force

# 2. Restart VSCode

# 3. Test all commands
/spearit-framework-light:help
/spearit-framework-light:new
/spearit-framework-light:move
/spearit-framework-light:next-id
/spearit-framework-light:session-history

# 4. If all pass, mark milestone complete
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
1. `.\tools\Install-PluginToCache.ps1 -Force`
2. Restart VSCode completely
3. Verify with `/plugin list`

### Issue: Changes not reflected
**Solution:**
1. Clear cache: Remove `%USERPROFILE%\.claude\plugins\cache\spearit-framework-light`
2. Reinstall: `.\tools\Install-PluginToCache.ps1 -Force`
3. Restart VSCode

### Issue: Command works in CLI, not VSCode
**Solution:**
1. Verify cache install (not just CLI test)
2. Restart VSCode (required)
3. Check for VSCode-specific errors in console

### Issue: Command slow/expensive
**Solution:**
1. Run with `--debug` flag
2. Look for Task agent spawning
3. Add "Do NOT use Task tool" instructions
4. Add performance budgets

---

## Resources

- **Quick reference:** `/plugins/TESTING.md`
- **Full workflow:** `/project-hub/research/claude-plugin-best-practices.md#plugin-testing-workflow`
- **Standards:** `/project-hub/research/anthropic-plugin-standards.md`
- **Helper script:** `/tools/Install-PluginToCache.ps1`
- **Build script:** `/tools/Build-Plugin.ps1`

---

## Web Sources

- [Claude Code VSCode Docs](https://code.claude.com/docs/en/vs-code)
- [Plugins Reference](https://code.claude.com/docs/en/plugins-reference)
- [Plugin Cache Issue #15642](https://github.com/anthropics/claude-code/issues/15642)
- [Per-Project Cache Issue #15329](https://github.com/anthropics/claude-code/issues/15329)

---

**Last Updated:** 2026-02-10
**Status:** Complete - Testing infrastructure ready for use

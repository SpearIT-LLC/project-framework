# Feature: Full Plugin - Build & Testing

**ID:** FEAT-127.4
**Parent:** FEAT-127 (Full Framework Plugin)
**Type:** Feature
**Priority:** High
**Created:** 2026-02-16
**Depends On:** FEAT-127.2, FEAT-127.3

---

## Summary

Extend Build-Plugin.ps1 to support building the spearit-framework plugin, test all 5 commands together, and verify no conflicts when both light and full plugins are installed simultaneously.

---

## Problem Statement

The build script currently only supports spearit-framework-light. Need to:
- Build spearit-framework plugin (v1.0.0)
- Test complete 5-command suite
- Verify namespace separation (light vs full)
- Ensure both plugins can coexist
- Package for eventual marketplace submission

---

## Requirements

**Must Have:**
- Build-Plugin.ps1 supports `-Plugin spearit-framework` parameter
- Builds `distrib/plugin-full/spearit-framework-v1.0.0.zip`
- All 5 commands tested (help, new, move, session-history, roadmap)
- Both plugins installed simultaneously (no conflicts)
- Version set to 1.0.0 (production-ready)

**Testing Checklist:**
- `/spearit-framework:help` - Lists all 5 commands
- `/spearit-framework:new` - Creates work item with auto-ID
- `/spearit-framework:move` - Moves items through workflow
- `/spearit-framework:session-history` - Creates session file
- `/spearit-framework:roadmap` - Creates ROADMAP.md

**Coexistence Testing:**
- Both plugins installed at same time
- Commands use correct namespaces
- No file conflicts
- No command name collisions
- Skills load independently

**Out of Scope:**
- Marketplace submission (separate work item if/when ready)
- Comprehensive documentation (basic README sufficient)
- Performance optimization (inherit from light plugin)

---

## Proposed Solution

### Technical Approach

**1. Extend Build Script:**

Update `tools/Build-Plugin.ps1`:

**Current:**
```powershell
param(
    [switch]$Build,
    [switch]$AllowPrerelease
)
# Hardcoded to spearit-framework-light
```

**Updated:**
```powershell
param(
    [string]$Plugin = "spearit-framework-light",  # Default to light
    [switch]$Build,
    [switch]$AllowPrerelease
)

# Support multiple plugins
$pluginPath = "plugins/$Plugin"
if (-not (Test-Path $pluginPath)) {
    Write-Error "Plugin not found: $Plugin"
    exit 1
}

# Output to plugin-specific directory
$outputDir = "distrib/plugin-full" if ($Plugin -eq "spearit-framework") else "distrib/plugin-light"
```

**Or simpler:** Auto-discover plugins:
```powershell
# Build all plugins in plugins/ directory
Get-ChildItem plugins/ -Directory | ForEach-Object {
    Build-PluginPackage -Path $_.FullName
}
```

**2. Version Update:**
```json
{
  "version": "1.0.0-dev3"  // → "1.0.0"
}
```

**3. Build Plugin:**
```powershell
.\tools\Build-Plugin.ps1 -Plugin spearit-framework -Build
```

**4. Test Locally:**
```powershell
# Publish to dev marketplace
.\tools\Publish-ToLocalMarketplace.ps1 -Plugin spearit-framework -Build

# Update marketplace
/plugin marketplace update dev-marketplace

# Install full plugin
/plugin install spearit-framework@dev-marketplace

# Verify light plugin still installed
/plugin list

# Test both work
/spearit-framework-light:help
/spearit-framework:help
```

**5. Test All Commands:**
- Create test work item with `/spearit-framework:new`
- Move test item with `/spearit-framework:move`
- Create session history with `/spearit-framework:session-history`
- Create test roadmap with `/spearit-framework:roadmap`
- Verify help lists all commands

**6. Clean Up Test Artifacts:**
- Delete test work items
- Keep session history (documents testing)
- Keep roadmap if useful, delete if test-only

**7. Final Package:**
```powershell
# Build production package (v1.0.0)
.\tools\Build-Plugin.ps1 -Plugin spearit-framework -Build
# Output: distrib/plugin-full/spearit-framework-v1.0.0.zip
```

---

## Acceptance Criteria

**Build Script:**
- [ ] Build-Plugin.ps1 supports `-Plugin spearit-framework` parameter
- [ ] OR auto-discovers all plugins/ subdirectories
- [ ] Builds to `distrib/plugin-full/spearit-framework-v1.0.0.zip`
- [ ] Package size reasonable (< 100 KB)
- [ ] Package structure validates (correct .claude-plugin/ format)

**Plugin Testing:**
- [ ] Version set to 1.0.0 (no dev suffix)
- [ ] All 5 commands execute without errors
- [ ] `/spearit-framework:help` - Lists all commands correctly
- [ ] `/spearit-framework:new` - Creates work item with auto-ID
- [ ] `/spearit-framework:move` - Moves items correctly
- [ ] `/spearit-framework:session-history` - Creates session file
- [ ] `/spearit-framework:roadmap` - Creates ROADMAP.md

**Coexistence Testing:**
- [ ] Light plugin remains installed during testing
- [ ] Full plugin installs without conflicts
- [ ] Both plugins list correctly (`/plugin list`)
- [ ] Commands use correct namespaces (`:light` vs no suffix)
- [ ] No file conflicts (separate cache directories)
- [ ] Skills load independently (no interference)

**Documentation:**
- [ ] README.md updated (if needed)
- [ ] CHANGELOG.md updated (v1.0.0 entry)
- [ ] Build instructions documented
- [ ] Testing checklist documented (for future)

---

## Implementation Notes

**Build Script Extensions:**

**Option A: Plugin Parameter (SELECTED)**
```powershell
.\tools\Build-Plugin.ps1 -Plugin spearit-framework-light  # Light plugin
.\tools\Build-Plugin.ps1 -Plugin spearit-framework        # Full plugin
```

**Option B: Auto-Discovery (REJECTED)**
```powershell
.\tools\Build-Plugin.ps1 -BuildAll  # Builds both plugins
```

**Decision:** Option A (explicit plugin parameter required)
- **Rationale:** Prevents accidental changes to plugins not being actively worked on
- Clearer intent, easier to debug
- Safer during development (no unintended side effects)

**Testing Strategy:**

**Phase 1: Individual Testing** (light plugin already done)
- Test full plugin commands individually
- Verify each command works as expected

**Phase 2: Coexistence Testing** (unique to this work item)
- Install both plugins
- Verify namespace separation
- Test commands from both
- Verify no interference

**Phase 3: Integration Testing**
- Use full plugin to manage full plugin development (dogfooding)
- Create work items, move through workflow
- Document session using session-history command
- Verify realistic usage scenario

**Plugin Version Strategy:**
- **Light:** v1.0.0 (shipped, awaiting marketplace approval)
- **Full:** v1.0.0-dev1 → dev2 → dev3 → **1.0.0 (this work item)**

**Package Output:**
```
distrib/
├── plugin-light/
│   └── spearit-framework-light-v1.0.0.zip  (shipped Feb 13)
└── plugin-full/
    └── spearit-framework-v1.0.0.zip        (this work item)
```

**Dependencies:**
- Requires: FEAT-127.2 (session-history must work)
- Requires: FEAT-127.3 (roadmap must work)
- Blocked until: All commands integrated and tested
- No external blockers (build infrastructure exists)

**Risk Assessment:** LOW-MEDIUM
- Build script extension: Low risk (straightforward)
- Coexistence testing: Medium risk (untested scenario)
- Command testing: Low risk (inherit from light plugin + isolated new commands)

---

## Related Work Items

**Parent:** FEAT-127 - Full Framework Plugin

**Prerequisites:**
- FEAT-127.1 - Structure & Core Commands (foundation)
- FEAT-127.2 - Session History (must be working)
- FEAT-127.3 - Roadmap Command (must be working)

**Reference:**
- FEAT-118 - Light Plugin (build process reference)
- TASK-126 - Plugin MVP Testing (testing approach)
- FEAT-120 - Plugin Testing Infrastructure (local marketplace)

**Future:**
- Marketplace submission (separate decision/work item)
- v1.1 features based on feedback
- Documentation enhancements

---

## Notes

**Why Final Step:**
- Can't test until all commands integrated
- Build script needs all files present
- Package validation requires complete plugin
- Coexistence testing needs both plugins complete

**Dogfooding Opportunity:**
Use full plugin commands to:
- Document FEAT-127.4 session (`/spearit-framework:session-history`)
- Create work items for v1.1 ideas (`/spearit-framework:new`)
- Move FEAT-127.x items to done (`/spearit-framework:move`)

**Success Looks Like:**
```
$ /plugin list
Installed plugins:
- spearit-framework-light@dev-marketplace (v1.0.0)
- spearit-framework@dev-marketplace (v1.0.0)

$ /spearit-framework:help
Available commands:
- help              Command reference
- new               Create work items
- move              Move items through workflow
- session-history   Document work sessions
- roadmap           AI-guided roadmap planning

$ /spearit-framework-light:help
Available commands:
- help              Command reference
- new               Create work items
- move              Move items through workflow
```

**Estimated Effort:** 1 session
- Build script: 30 minutes
- Testing: 30-45 minutes
- Documentation: 15 minutes

---

**Last Updated:** 2026-02-16
**Status:** Backlog (blocked by FEAT-127.2, FEAT-127.3)

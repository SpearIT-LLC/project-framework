# Feature: Plugin Testing Infrastructure - Local Marketplace Approach

**ID:** FEAT-120
**Type:** Feature (Infrastructure)
**Priority:** High
**Version Impact:** PATCH
**Created:** 2026-02-10
**Theme:** Developer Experience
**Blocks:** FEAT-118 (Milestone 8)
**Target:** Complete before FEAT-118 final packaging

---

## Summary

Refactor plugin testing infrastructure to use Anthropic's official local marketplace pattern instead of manual cache manipulation. This aligns our testing workflow with Anthropic's documented best practices and provides better testing of the actual user installation experience.

**Key Change:** Replace `Install-PluginToCache.ps1` / `Uninstall-PluginFromCache.ps1` with `Publish-ToLocalMarketplace.ps1` that uses `/plugin install` workflow.

**Scope Note:** This is **testing infrastructure only** - not release automation. Release automation for plugins was deferred (see session history 2026-02-10, Late Evening Session). This work enables local testing via official Anthropic patterns.

---

## Problem Statement

### Current Approach (Cache Manipulation)

**What we built (Feb 10):**
- `Install-PluginToCache.ps1` - Manually copies plugin to `~/.claude/plugins/cache/`
- `Uninstall-PluginFromCache.ps1` - Manually removes plugin from cache

**Problems:**
1. **Bypasses official plugin system** - Direct cache manipulation, not using `/plugin install`
2. **Doesn't test real installation flow** - Users will use `/plugin install`, we should too
3. **No scope management** - Cache has no concept of user/project/local scope
4. **Non-standard approach** - Anthropic doesn't document this method
5. **Brittle** - Depends on cache implementation details that could change

### Discovered Better Approach (Feb 10 Research)

**Anthropic officially supports local marketplaces:**

From [official docs](https://code.claude.com/docs/en/discover-plugins#add-from-local-paths):
```shell
/plugin marketplace add ./my-marketplace
/plugin install test-plugin@marketplace-name
```

**This is THE documented way to test plugins locally.**

---

## Research Findings

### Key Discovery: Local Marketplace Support

**Source:** https://code.claude.com/docs/en/plugin-marketplaces

Anthropic's plugin system supports **four marketplace sources:**
1. GitHub repositories (`owner/repo`)
2. Git URLs (GitLab, Bitbucket, self-hosted)
3. **Local paths** (`./my-marketplace`) ← THIS!
4. Remote URLs (`https://example.com/marketplace.json`)

### How Local Marketplaces Work

**One-time setup:**
1. Create `plugins/.claude-plugin/marketplace.json` (catalog)
2. Add marketplace: `/plugin marketplace add ./plugins`
3. Install plugin: `/plugin install plugin-name@plugins --scope local`

**After changes:**
1. Update marketplace: `/plugin marketplace update plugins`
2. Restart Claude Code (auto-update picks up changes)

**Benefits:**
- ✅ Uses official plugin system
- ✅ Tests actual installation UX
- ✅ Proper scope management (user/project/local)
- ✅ Version tracking
- ✅ Can enable auto-update for dev
- ✅ Works in both CLI and VSCode
- ✅ Documented and supported by Anthropic

---

## Proposed Solution

### New Script: `Publish-ToLocalMarketplace.ps1`

**Purpose:** Generate/update ephemeral local marketplace for testing

**Scope:** Testing infrastructure ONLY - not release automation (deferred to plugin-full)

**Features:**
- Creates `../claude-local-marketplace/.claude-plugin/marketplace.json`
- Reads plugin metadata from existing `plugin.json` (no version bumping)
- `-Clean` flag to delete and recreate marketplace
- `-Build` flag to run Build-Plugin.ps1 first
- Clear instructions for first-time setup and iteration

**Marketplace is ephemeral:**
- Located parallel to project repo: `../claude-local-marketplace/`
- Disposable testing infrastructure
- Can be deleted/recreated anytime
- Not tracked in git (outside repo)
- No version complexity during development

### Remove Cache Scripts

**Delete:**
- `tools/Install-PluginToCache.ps1` (570 lines)
- `tools/Uninstall-PluginFromCache.ps1` (228 lines)

**Rationale:**
- Local marketplace provides same functionality via official path
- Simpler mental model (one way to do things)
- Less code to maintain
- Better documentation

---

## Implementation Plan

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->

### Milestone 1: Research and Documentation (COMPLETE)
- [x] Research Anthropic's local marketplace support
- [x] Document findings in session history
- [x] Compare cache manipulation vs local marketplace approach
- [x] Create FEAT-120 work item with comprehensive plan
- [x] **STOP - Review research and plan**

### Milestone 2: Create Publish-ToLocalMarketplace.ps1
- [x] Create script skeleton with parameter definitions
- [x] Implement marketplace.json generation logic
- [x] Add `-Clean` flag for marketplace reset
- [x] Add `-Build` flag integration
- [x] Implement plugin auto-detection from plugins/ directory
- [x] Add validation (plugin.json exists, required fields present)
- [x] Add clear status messages and next-step instructions
- [x] Test script creates valid marketplace.json
- [x] **STOP - Review script implementation**

### Milestone 3: Update Documentation
- [x] Update `plugins/TESTING.md` with local marketplace workflow
- [x] Update `plugins/README.md` references
- [x] Update `project-hub/research/plugin-best-practices.md`
- [x] Update `project-hub/research/plugin-testing-summary.md`
- [x] Create migration guide (old → new workflow)
- [x] **STOP - Review documentation updates**

### Milestone 4: Remove Cache Scripts
- [ ] Remove `tools/Install-PluginToCache.ps1`
- [ ] Remove `tools/Uninstall-PluginFromCache.ps1`
- [ ] Update references in documentation
- [ ] Update git history (commit with clear message)
- [ ] **STOP - Review cleanup**

### Milestone 5: End-to-End Testing
- [ ] Clean test: Delete any existing marketplace/cache
- [ ] Run `Publish-ToLocalMarketplace.ps1`
- [ ] Verify marketplace.json created correctly in `../claude-local-marketplace/`
- [ ] Test in Claude Code: `/plugin marketplace add ../claude-local-marketplace`
- [ ] Test install: `/plugin install spearit-framework-light@dev-marketplace --scope local`
- [ ] Test all commands work
- [ ] Make changes to plugin, test update workflow
- [ ] Test `-Clean` flag
- [ ] Test `-Build` flag
- [ ] Document any issues found
- [ ] **STOP - Review test results**

### Milestone 6: Final Documentation
- [ ] Update session history with outcomes
- [ ] Document lessons learned
- [ ] Update FEAT-118 dependencies (unblock Milestone 8)
- [ ] Mark FEAT-120 complete
- [ ] **COMPLETE**

---

## Acceptance Criteria

### Script Functionality
- ✅ `Publish-ToLocalMarketplace.ps1` creates valid marketplace.json at `../claude-local-marketplace/`
- ✅ Supports `-Clean` flag for marketplace reset
- ✅ Supports `-Build` flag to build first
- ✅ Auto-detects plugins from plugins/ directory
- ✅ Shows clear next-step instructions
- ✅ Handles errors gracefully

### Documentation
- ✅ TESTING.md updated with new workflow
- ✅ Clear migration guide from old approach
- ✅ Best practices doc reflects official pattern
- ✅ All references to cache scripts removed

### Testing
- ✅ Marketplace creation works
- ✅ Plugin installation via `/plugin install` works
- ✅ Update workflow (marketplace update + restart) works
- ✅ All plugin commands function correctly
- ✅ Can reset marketplace with `-Clean`

### Quality
- ✅ Uses official Anthropic patterns
- ✅ Simpler than previous approach
- ✅ Well-documented rationale
- ✅ Tests actual user installation flow

---

## Technical Details

### Marketplace.json Structure

**Location:** `../claude-local-marketplace/.claude-plugin/marketplace.json`

```json
{
  "name": "dev-marketplace",
  "owner": {
    "name": "Development"
  },
  "plugins": [
    {
      "name": "spearit-framework-light",
      "source": "../project-framework/plugins/spearit-framework-light",
      "description": "File-based Kanban workflow for solo developers",
      "version": "1.0.0"
    }
  ]
}
```

**Note:** `source` points back to actual plugin directory in project repo.

### Testing Workflow

**One-time setup:**
```powershell
# 1. Create marketplace (from project-framework directory)
.\tools\Publish-ToLocalMarketplace.ps1

# 2. Add to Claude Code
/plugin marketplace add ../claude-local-marketplace

# 3. Install plugin
/plugin install spearit-framework-light@dev-marketplace --scope local
```

**After changes:**
```powershell
# Update marketplace (if metadata changed)
.\tools\Publish-ToLocalMarketplace.ps1

# Refresh in Claude Code
/plugin marketplace update dev-marketplace

# Restart Claude Code (picks up changes)
```

**Reset testing environment:**
```powershell
# Clean slate
.\tools\Publish-ToLocalMarketplace.ps1 -Clean

# Reinstall
/plugin install spearit-framework-light@dev-marketplace --scope local
```

---

## Dependencies

### Blocks
- **FEAT-118 Milestone 8** - Final packaging requires proper testing infrastructure

### Related Work
- Built on research from FEAT-118 Milestone 7 (testing phase)
- Informed by `plugin-anthropic-standards.md` research
- Leverages `Build-Plugin.ps1` (existing)

---

## Risks and Mitigation

### Risk: Marketplace update doesn't pick up changes
**Mitigation:** Document restart requirement clearly, test auto-update behavior

### Risk: Users confused by new workflow
**Mitigation:** Clear migration guide, examples in TESTING.md

### Risk: Plugin.json missing required fields
**Mitigation:** Script validates before generating marketplace.json

---

## Success Metrics

### Quantitative
- Lines of code reduced (570 + 228 = 798 → ~200 for new script)
- Testing workflow steps (old: 3 scripts, new: 1 script + /plugin commands)
- Documentation pages updated (4 files)

### Qualitative
- Uses official Anthropic patterns ✅
- Easier to understand ✅
- Tests actual installation flow ✅
- Simpler maintenance ✅

---

## Alternatives Considered

### Alternative 1: Keep Cache Scripts (Rejected)
**Pros:** Already built, working
**Cons:** Non-standard, doesn't test real flow, more complex
**Decision:** Reject - local marketplace is strictly better

### Alternative 2: Hybrid Approach (Rejected)
**Pros:** Offers both methods
**Cons:** Confusing, more documentation, unclear which to use
**Decision:** Reject - one clear path is better

### Alternative 3: CLI Testing Only (Rejected)
**Pros:** Simple (claude --plugin-dir)
**Cons:** Doesn't test VSCode, misses installation UX issues
**Decision:** Reject - need VSCode testing

---

## Plugin System Internals (Discovered 2026-02-11)

### Storage Structure

During troubleshooting of plugin uninstall issues, discovered Claude's internal plugin storage structure:

```
~/.claude/plugins/
├── marketplaces/
│   └── claude-plugins-official/     # GitHub marketplaces are cloned here
├── cache/
│   ├── claude-plugins-official/     # Installed plugins from official marketplace
│   └── dev-marketplace/             # Installed plugins from local marketplace
│       └── spearit-framework-light/
│           └── 1.0.0/               # Plugin files cached here
├── known_marketplaces.json          # Marketplace registry
└── installed_plugins.json           # Plugin installation metadata
```

### Marketplace Types Behavior

**GitHub-based marketplaces** (official):
- Claude clones the entire marketplace to `marketplaces/` directory
- `known_marketplaces.json` → `installLocation` points to the cloned directory
- Example: `claude-plugins-official`

**Directory-based marketplaces** (local dev):
- Claude does NOT copy the marketplace
- `known_marketplaces.json` → `installLocation` points to original source directory
- Example: `../claude-local-marketplace` stays in place

**Plugin installation** (both types):
- When you run `/plugin install`, files are ALWAYS cached to `cache/{marketplace}/{plugin}/{version}/`
- This happens regardless of marketplace type
- Cached files are what Claude actually loads when using the plugin

### Metadata Files

**known_marketplaces.json:**
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

**installed_plugins.json:**
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

### Bug: Uninstall Fails for Local-Scoped Plugins

**Problem:** `claude plugin uninstall` command has contradictory error messages:

- **From VSCode UI:** "Plugin is installed in local scope, not user. Use --scope local to uninstall."
- **From CLI with --scope local:** "Plugin is not installed in local scope. Use --scope to specify the correct scope."
- **From plugin list:** Shows correctly as "Scope: local"

**Root cause:** Bug in Claude CLI's uninstall logic when dealing with local-scoped plugins installed from directory-based marketplaces.

**Workaround - Manual Uninstall:**

1. Delete cached plugin:
   ```powershell
   Remove-Item -Recurse -Force "~/.claude/plugins/cache/{marketplace}/{plugin-name}"
   ```

2. Edit `~/.claude/plugins/installed_plugins.json`:
   - Remove the plugin entry from `plugins` object
   - Save the file

3. Restart VSCode/Claude Code

4. Verify with `claude plugin list`

**Key insight:** The plugin storage is well-structured and can be safely edited manually when CLI commands fail.

---

## Notes

### Timeline
- **Created:** 2026-02-10
- **Discovered:** Local marketplace support during FEAT-118 testing research
- **Decision:** Pivot to official approach before final packaging
- **Target:** Complete before FEAT-118 Milestone 8

### Key Insight
> "The local marketplace isn't a workaround - it's THE documented way to test plugins locally. We should use it."

### Related Documentation
- [Discover and install plugins - Claude Code Docs](https://code.claude.com/docs/en/discover-plugins)
- [Create and distribute a plugin marketplace - Claude Code Docs](https://code.claude.com/docs/en/plugin-marketplaces)
- `project-hub/research/plugin-anthropic-standards.md`
- `project-hub/research/plugin-best-practices.md`

---

**Status:** Milestone 3 complete - Documentation updated
**Next Step:** Begin Milestone 4 (Remove cache scripts)

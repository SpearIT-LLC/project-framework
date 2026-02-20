# Plugin Testing Guide

How to test Claude Code plugins during development and prepare them for release.

---

## Testing Workflow

### During Development (VSCode)

Repeat this loop until satisfied:

```powershell
# 1. Reset and republish
.\tools\Publish-ToLocalMarketplace.ps1

# 2. In Claude Code
/plugin marketplace update dev-marketplace

# 3. Restart Claude Code

# 4. Test
```

> **Why all three steps?** Step 1 wipes the marketplace and Claude cache, then republishes fresh junctions. Step 2 tells Claude to re-read the marketplace. Step 3 loads the updated cache into the session. All three are required on each cycle.

### During Development (CLI)

For quick iteration without VSCode, test directly from source:

```bash
claude --plugin-dir ./plugins/spearit-framework-light
claude --plugin-dir ./plugins/spearit-framework-light --debug
```

No cache, no restart — changes are immediate. Use this for fast feedback on command logic.

---

## One-Time Setup

If starting from scratch (new machine or fresh install):

```powershell
# 1. Create marketplace and publish plugins
.\tools\Publish-ToLocalMarketplace.ps1

# 2. Add marketplace to Claude Code (one-time)
/plugin marketplace add ../claude-local-marketplace

# 3. Install plugins
/plugin install spearit-framework-light@dev-marketplace --scope local
/plugin install spearit-framework@dev-marketplace --scope local

# 4. Restart Claude Code
```

---

## Release Workflow

When testing is complete and you're ready to publish:

```powershell
# 1. Bump version in .claude-plugin/plugin.json
#    e.g. 1.0.3 → 1.0.4

# 2. Build distributable package
.\tools\Build-Plugin.ps1 -Plugin spearit-framework-light

# 3. Upload zip to GitHub (self-publish)

# 4. Submit to Anthropic (marketplace publish)
```

---

## Scripts

### Publish-ToLocalMarketplace.ps1

Resets the dev environment and republishes all plugins. Always a full clean slate — wipes the marketplace directory, Claude cache, and `installed_plugins.json` entries for `dev-marketplace`, then recreates junctions for all plugins found in `plugins/`.

```powershell
.\tools\Publish-ToLocalMarketplace.ps1
```

Auto-discovers plugins by scanning `plugins/` for subfolders containing `.claude-plugin/plugin.json`. No hardcoded plugin names.

### Build-Plugin.ps1

Builds a distributable `.zip` for release. Not used during testing — the marketplace uses live junctions pointing at source files.

```powershell
# Production build (strict semver only — rejects pre-release)
.\tools\Build-Plugin.ps1 -Plugin spearit-framework-light

# Development build (allows pre-release versions)
.\tools\Build-Plugin.ps1 -Plugin spearit-framework-light -AllowPrerelease
```

**Output:** `distrib/plugin-light/spearit-framework-light-vX.Y.Z.zip`

---

## Testing Checklist

**Each Command:**
- [ ] Invokes with correct namespace (`/plugin-name:command`)
- [ ] Help text displays correctly
- [ ] Parameters validated, errors are clear
- [ ] Performance acceptable (<10s for file ops, <30s for complex)
- [ ] No unexpected Task agents spawning

**Plugin Overall:**
- [ ] Loads without errors (`--debug`)
- [ ] Listed in `/plugin list` with correct version
- [ ] No command conflicts with other plugins or local commands
- [ ] Version correct in `.claude-plugin/plugin.json`
- [ ] LICENSE file present

**VSCode Integration:**
- [ ] Appears in `/plugin list`
- [ ] Commands auto-complete
- [ ] Behavior identical to CLI

---

## Troubleshooting

### Plugin not found in VSCode

```powershell
/plugin marketplace list   # Is dev-marketplace registered?
/plugin list               # Is the plugin installed?
```

If marketplace missing: `/plugin marketplace add ../claude-local-marketplace`
If plugin missing: `/plugin install spearit-framework-light@dev-marketplace --scope local`

### Changes not reflected after restart

Run the full reset cycle — partial updates leave stale cache:

```powershell
.\tools\Publish-ToLocalMarketplace.ps1
/plugin marketplace update dev-marketplace
# Restart Claude Code
```

### Command works in CLI but not VSCode

1. Verify installed (not just marketplace added): `/plugin list`
2. Restart VSCode
3. Run with `--debug` and check for errors

### Command is slow or spawning unexpected agents

1. Run with `--debug` and look for Task agent spawning
2. Add explicit "Do NOT use Task tool" directives to the command file
3. See [`research/plugins-performance-optimization.md`](../research/plugins-performance-optimization.md)

### Manual cache reset (if script can't run)

```powershell
Remove-Item -Recurse -Force "$env:USERPROFILE\.claude\plugins\cache\dev-marketplace"
# Edit installed_plugins.json — remove *@dev-marketplace entries
# Then re-run Publish-ToLocalMarketplace.ps1
```

---

## Resources

- **Architecture & concepts:** [`project-hub/research/plugin-testing-summary.md`](../project-hub/research/plugin-testing-summary.md)
- **Performance optimization:** [`research/plugins-performance-optimization.md`](../research/plugins-performance-optimization.md)
- **Plugin standards:** [`project-hub/research/plugin-anthropic-standards.md`](../project-hub/research/plugin-anthropic-standards.md)
- **Publish script:** [`tools/Publish-ToLocalMarketplace.ps1`](../tools/Publish-ToLocalMarketplace.ps1)
- **Build script:** [`tools/Build-Plugin.ps1`](../tools/Build-Plugin.ps1)

---

**Last Updated:** 2026-02-20

# Development Guide - SpearIT Framework Light Plugin

## Version Management

**⚠️ IMPORTANT: Update version after every change!**

When you make ANY change to the plugin (commands, skills, templates, README, etc.):

1. **Increment the dev version** in `.claude-plugin/plugin.json`
   - Pattern: `1.0.0-devN` where N increments with each change
   - Example: `1.0.0-dev3` → `1.0.0-dev4` → `1.0.0-dev5`
   - **Never bump major or minor during development** — only N changes until a clean release
   - `1.0.0` (no suffix) = production release only

2. **Why this matters:**
   - Claude Code caches plugins by version
   - Same version = stale cache = changes not picked up
   - Different version = fresh install = changes work

3. **When to increment:**
   - ✅ After editing command files
   - ✅ After updating README or docs
   - ✅ After changing templates
   - ✅ After modifying plugin.json metadata
   - ✅ After ANY file change in the plugin directory

## Development Workflow

### Local Testing Setup

1. **Publish to local marketplace:**
   ```powershell
   .\tools\Publish-ToLocalMarketplace.ps1
   ```

2. **Update marketplace in Claude Code:**
   ```
   /plugin marketplace update dev-marketplace
   ```

3. **Restart VSCode/Claude Code**

### Making Changes

1. **Edit plugin files** (commands, templates, etc.)
2. **⚠️ UPDATE VERSION** in `.claude-plugin/plugin.json`
3. **Test:**
   - Restart VSCode/Claude Code
   - Try the changed command
   - Verify behavior

### Testing Without Rebuilding

Since the plugin uses directory junctions (symlinks), changes to source files are immediately visible to the marketplace. However, you still need to:

1. **Increment version** (forces cache refresh)
2. **Restart** (picks up new version)

No need to rebuild the archive unless you're creating a distribution package.

## Quick Checklist

Before committing changes:

- [ ] All changes tested and working
- [ ] Version number incremented in `plugin.json`
- [ ] README updated if user-facing changes
- [ ] Changes documented in commit message

## Common Gotchas

**Problem:** "My changes aren't showing up!"
- **Solution:** Did you increment the version? Restart VSCode?

**Problem:** "Command is still using old behavior"
- **Solution:** Check that plugin.json version changed. Completely restart VSCode (not just reload).

**Problem:** "Getting 'command not found' errors"
- **Solution:** Verify command file exists and marketplace is updated.

## Performance Considerations

Commands should complete in:
- Simple moves (backlog/todo/done/archive): 5-8 seconds
- Complex moves with AI (doing): 12-18 seconds

See [research/plugins-performance-optimization.md](../../research/plugins-performance-optimization.md) for comprehensive performance analysis.

## Plugin Architecture

**What's fast:**
- Exact bash scripts (single API round-trip)
- Direct tool calls (Glob, Read, Bash)

**What's slow:**
- AI reasoning and interpretation
- Multiple round-trips for sequential operations
- Complex formatted output generation

**Design principle:** Use AI only where it adds value. Everything else should be scripted.

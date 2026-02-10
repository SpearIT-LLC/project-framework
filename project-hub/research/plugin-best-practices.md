# Claude Code Plugin Best Practices

**Date Started:** 2026-02-09
**Purpose:** Document lessons learned and best practices from building Claude Code plugins
**Source:** Hands-on experience building spearit-framework-light plugin (FEAT-118)

---

## Command Performance Optimization

### Problem: Commands Spawning Unnecessary Task Agents

**Symptom:** Simple utility commands become slow and expensive.

**Example: next-id command**
- Before optimization: 15.3k tokens, 53 seconds
- After optimization: <1k tokens, <5 seconds (15x faster, 15x cheaper)

**Root Cause:**
Command instruction files (`.md` in `commands/`) are interpreted by Claude as natural language instructions. Vague language like "extract IDs" or "find maximum" can trigger Claude to interpret this as requiring AI reasoning and spawn Task agents for what should be simple file operations.

### Solution: Defensive Command Writing

Commands that perform simple operations (file scanning, regex parsing, basic calculations) must include explicit performance requirements.

**Template for Simple Commands:**

```markdown
## For AI Assistants

**Implementation Instructions:**

**CRITICAL: Do NOT use Task tool or spawn agents. This must be done directly with Glob tool and simple regex parsing.**

When the user runs `/plugin:command`:

1. **Use Glob tool ONLY** to search for files
   - Call Glob with pattern: project-hub/work/**/*.md

2. **YOU parse the filenames directly** (no Task agent needed)
   - Regex pattern: `([A-Z]+)-(\d{3})-.*\.md`
   - Extract group 2 (the numeric portion)

3. **YOU find maximum ID directly** (no Task agent needed)
   - Take all extracted integers
   - Use simple max() operation

**PERFORMANCE REQUIREMENT:** This command should complete in under 5 seconds and use under 1k tokens. It is a simple file scanning and regex operation - NO AI reasoning or Task agents required.
```

### Key Principles

1. **Explicit prohibition** - State "Do NOT use Task tool or spawn agents" at the top
2. **Positive framing** - Say "YOU do X directly" not just "extract X"
3. **Performance budgets** - State expected time and token usage
4. **Tool specificity** - Say "Use Glob tool ONLY" not "search for files"
5. **Clarify simplicity** - Explain why agents aren't needed

### When to Apply Defensive Instructions

**Apply for:**
- File scanning operations (Glob)
- Filename or content parsing (regex)
- Simple calculations (math)
- String formatting operations
- ID generation/incrementation
- File existence checks

**Don't apply for (agents ARE appropriate):**
- Commands requiring reasoning about code
- Commands that need to understand context
- Commands that make judgment calls
- Commands that generate new content
- Commands that analyze code quality
- Commands that summarize information

### Testing for Performance Issues

**Red flags:**
- Simple command uses >2k tokens
- Simple command takes >10 seconds
- Debug logs show unexpected Task tool usage
- Command behavior is unpredictable

**Fix:**
1. Add explicit "Do NOT use Task tool" instruction
2. Add performance requirement with budget
3. Use positive framing ("YOU do X directly")
4. Test again to verify improvement

---

## Command Isolation and Namespacing

### Problem: Plugin Commands Showing Wrong Content

**Symptom:** Plugin help command displayed local framework commands instead of plugin commands.

**Root Cause:**
When a plugin is loaded in a project that also has local commands in `.claude/commands/`, Claude may scan all available commands rather than just the plugin's commands.

### Solution: Explicit Path Specification

Specify WHERE to read from, not just where NOT to read.

**Bad (Negative framing):**
```markdown
Do NOT list commands from the local `.claude/commands/` directory.
```

**Good (Positive framing):**
```markdown
**Command Source:** Read ONLY from the plugin's commands directory at `plugins/spearit-framework-light/commands/`.

**Where to find command files:**
- Read from: `plugins/spearit-framework-light/commands/` directory
- Available files: `help.md`, `move.md`, `next-id.md`, `session-history.md`
- Do NOT read from: `.claude/commands/` or any other location
```

### Key Principles

1. **Positive instructions** - Say where TO read, not just where NOT to read
2. **Absolute paths** - Use full paths from project root
3. **Enumerate files** - List expected files explicitly
4. **Negative as backup** - Add "do not read from X" after positive instruction

### When to Apply

**Always specify explicit paths for:**
- Help commands that list available commands
- Commands that read from plugin resources
- Commands that load configuration
- Commands that access documentation

**Why it matters:**
- Plugins can be loaded in any project environment
- Local commands may have similar names
- User trust depends on predictable behavior
- Debugging is harder when paths are inferred

---

## Plugin.json Schema Strictness

### Problem: Undocumented Schema Validation

**Symptom:** Plugin fails to load with validation errors for fields that seem reasonable.

**Example errors encountered:**
- `author: Invalid input: expected object, received string`
- `Unrecognized key: displayName`
- `Unrecognized key: title`

**Solution:** Start with minimal schema, add fields incrementally.

### Minimal Working Schema

```json
{
  "name": "plugin-name",
  "version": "1.0.0"
}
```

This minimal schema WILL load. Add other fields only after testing.

### Schema Validation Strategy

1. **Start minimal** - Use only `name` and `version`
2. **Test loading** - Verify plugin loads with `--debug` flag
3. **Add one field** - Add a single additional field (e.g., `description`)
4. **Test again** - Check debug logs for validation errors
5. **Iterate** - Continue adding fields one at a time

### Fields We Know Work

```json
{
  "name": "spearit-framework-light",
  "version": "1.0.0"
}
```

### Fields That Failed Validation (v2.1.37)

- `displayName` - Rejected as unrecognized
- `title` - Rejected as unrecognized
- `author` as string - Required object format (but object also failed)

**Note:** These fields may be documented but not yet implemented in the schema validator. Always test with actual CLI.

---

## File Naming Conventions

### Problem: Command Files Need Prefix Removal

**Symptom:** Plugin commands invoked as `/plugin:fw-command` instead of `/plugin:command`.

**Root Cause:**
File names map to command suffixes after the namespace. A file named `fw-help.md` creates command `/plugin:fw-help`, not `/plugin:help`.

### Solution: Remove Prefixes from Command Files

**Local commands (keep prefix for clarity):**
```
.claude/commands/
├── fw-help.md       # Invoked as: /fw-help
├── fw-move.md       # Invoked as: /fw-move
└── fw-next-id.md    # Invoked as: /fw-next-id
```

**Plugin commands (remove prefix):**
```
plugins/spearit-framework-light/commands/
├── help.md          # Invoked as: /spearit-framework-light:help
├── move.md          # Invoked as: /spearit-framework-light:move
└── next-id.md       # Invoked as: /spearit-framework-light:next-id
```

### Naming Rules

1. **File name = command suffix** after the namespace
2. **Namespace is automatic** from plugin name in plugin.json
3. **No prefix needed** in plugin files (namespace provides context)
4. **Command title in file** should include full invocation path

**Example command file:**
```markdown
# /spearit-framework-light:help - Framework Command Help

Show available framework commands or get help on a specific command.
```

---

## Debug Workflow

### Using Debug Logs Effectively

**Enable debug mode:**
```bash
claude --debug --plugin-dir ./plugins/spearit-framework-light
```

**Log location:**
```
C:\Users\{username}\.claude\debug\{session-id}.txt
```

### Key Debug Information

**Plugin loading:**
- Search for: "Loaded inline plugin from path"
- Confirms plugin directory was found
- Shows how many commands/skills loaded

**Validation errors:**
- Search for: "Invalid input" or "Unrecognized key"
- Shows which plugin.json fields failed
- Helps identify schema issues

**Command execution:**
- Search for: "Metadata string for"
- Shows which command was invoked
- Includes command file content being processed

### Debug Strategy

1. **Start with debug on** - Always test new plugins with `--debug`
2. **Check loading first** - Verify plugin appears in debug log
3. **Test simple command** - Try help command first
4. **Review execution path** - Check for unexpected Task agent usage
5. **Measure performance** - Note token usage and time in logs

---

## Plugin Testing Workflow

### Overview

Claude Code plugins are **copied to cache** rather than symlinked (for security). This means you must manually update the cache after making changes during development.

**Cache Location (Windows):** `%USERPROFILE%\.claude\plugins\cache\`

**Cache Location (Mac/Linux):** `~/.claude/plugins/cache/`

### Testing Methods

There are **three** ways to test plugins during development:

#### Method 1: CLI with --plugin-dir (Fastest for Iteration)

**Best for:** Quick iterations during active development

```bash
# Navigate to repository root
cd C:\...\project-framework

# Test plugin directly from development directory
claude --plugin-dir ./plugins/spearit-framework-light
```

**Pros:**
- ✅ No cache management needed
- ✅ Changes reflected immediately
- ✅ Fast iteration cycle
- ✅ Debug output available with --debug flag

**Cons:**
- ❌ CLI only (doesn't test VSCode integration)
- ❌ Must be in correct working directory

**Usage:**
```bash
# Start with debug logging
claude --plugin-dir ./plugins/spearit-framework-light --debug

# Test commands
/spearit-framework-light:help
/spearit-framework-light:next-id
```

#### Method 2: Manual Cache Installation (VSCode Testing)

**Best for:** Testing VSCode integration, testing "real" installation experience

Use the helper script to install to cache:

```powershell
# Install plugin to cache (builds first)
.\tools\Install-PluginToCache.ps1

# Force reinstall (for updates)
.\tools\Install-PluginToCache.ps1 -Force

# Skip build step (faster for minor changes)
.\tools\Install-PluginToCache.ps1 -NoBuild -Force

# Specific plugin
.\tools\Install-PluginToCache.ps1 -Plugin spearit-framework-light -Force
```

**What the script does:**
1. Validates plugin structure
2. Runs `Build-Plugin.ps1` (unless `-NoBuild`)
3. Clears existing cache (if `-Force`)
4. Copies plugin to `%USERPROFILE%\.claude\plugins\cache\`
5. Verifies installation
6. Shows next steps

**After installation:**
1. Restart VSCode (required for changes to take effect)
2. Open Claude Code in VSCode
3. Type `/plugin list` to verify installation
4. Test commands: `/spearit-framework-light:help`

**Return to baseline:**
```powershell
# Uninstall plugin completely
.\tools\Uninstall-PluginFromCache.ps1 -Plugin spearit-framework-light -Force

# Restart VSCode
# Verify removal with /plugin list
```

**Pros:**
- ✅ Tests VSCode integration
- ✅ Tests actual installation experience
- ✅ Shared cache with CLI (works in both)
- ✅ Automated via script
- ✅ Easy uninstall for baseline testing

**Cons:**
- ❌ Requires VSCode restart after updates
- ❌ Manual cache clearing needed for changes
- ❌ Slower iteration cycle

#### Method 3: Build and Test ZIP Package (Pre-Release Testing)

**Best for:** Final validation before marketplace submission

```powershell
# Build distributable ZIP
.\tools\Build-Plugin.ps1

# Extract to temp location
Expand-Archive distrib\plugin-light\spearit-framework-light-v1.0.0.zip -Destination C:\temp\plugin-test

# Test from extracted location
cd C:\...\project-framework
claude --plugin-dir C:\temp\plugin-test\spearit-framework-light
```

**Pros:**
- ✅ Tests exact package users will receive
- ✅ Validates build process
- ✅ Catches packaging issues

**Cons:**
- ❌ Slowest method (full build each time)
- ❌ Not suitable for active development

### Recommended Testing Workflow

**During Active Development:**
```powershell
# 1. Make changes to plugin files
# 2. Test immediately with CLI
claude --plugin-dir ./plugins/spearit-framework-light

# 3. If changes work, commit
git add plugins/spearit-framework-light/
git commit -m "feat: Add X to Y command"
```

**Before Major Milestones:**
```powershell
# 1. Install to cache for VSCode testing
.\tools\Install-PluginToCache.ps1 -Force

# 2. Restart VSCode

# 3. Test all commands in VSCode
/spearit-framework-light:help
/spearit-framework-light:new
/spearit-framework-light:move FEAT-001 todo
/spearit-framework-light:next-id
/spearit-framework-light:session-history

# 4. If all tests pass, proceed
```

**Before Release:**
```powershell
# 1. Build final package
.\tools\Build-Plugin.ps1

# 2. Extract and test ZIP
Expand-Archive distrib\plugin-light\spearit-framework-light-v1.0.0.zip -Destination C:\temp\release-test
claude --plugin-dir C:\temp\release-test\spearit-framework-light

# 3. If tests pass, tag release
git tag -a v1.0.0 -m "Release v1.0.0"
git push --tags
```

### Testing Checklist

**For Each Command:**
- [ ] Command invokes correctly with namespace
- [ ] Help text displays correctly
- [ ] Required parameters validated
- [ ] Optional parameters work as expected
- [ ] Error messages are clear and actionable
- [ ] Performance is acceptable (<5s for utilities, <30s for complex)
- [ ] No unexpected Task agent spawning
- [ ] Works in target environment (with project structure)
- [ ] Graceful degradation (without project structure)

**For Plugin Overall:**
- [ ] Plugin loads without errors (`--debug` shows no issues)
- [ ] All commands listed in `/plugin:help`
- [ ] No conflicts with local commands
- [ ] README documentation matches reality
- [ ] Version number is correct in plugin.json
- [ ] LICENSE file present and correct
- [ ] Skills load properly (check Claude's context understanding)

**For VSCode Integration:**
- [ ] Plugin appears in `/plugin list`
- [ ] Commands auto-complete with namespace
- [ ] Commands work identically to CLI
- [ ] No VSCode-specific errors in console
- [ ] Restart VSCode makes changes take effect

### Test in Correct Environment

**Wrong:**
```bash
cd C:\blank-folder
claude --plugin-dir C:\...\plugins\spearit-framework-light
```
Commands that expect project structure will fail.

**Right:**
```bash
cd C:\...\project-framework
claude --plugin-dir ./plugins/spearit-framework-light
```
Commands can access project files if needed.

### Common Testing Mistakes

**1. Testing from wrong directory**
```bash
# ❌ Wrong - plugin can't find project files
cd C:\temp
claude --plugin-dir C:\...\plugins\spearit-framework-light

# ✅ Right - plugin has access to project structure
cd C:\...\project-framework
claude --plugin-dir ./plugins/spearit-framework-light
```

**2. Forgetting to restart VSCode after cache update**
```powershell
# ❌ Wrong - changes won't be visible
.\tools\Install-PluginToCache.ps1 -Force
# ... continues testing in same VSCode session

# ✅ Right - restart VSCode first
.\tools\Install-PluginToCache.ps1 -Force
# Close VSCode → Reopen → Test commands
```

**3. Testing old version after rebuild**
```powershell
# ❌ Wrong - cache still has old version
.\tools\Build-Plugin.ps1
# Tests in VSCode without updating cache

# ✅ Right - update cache after rebuild
.\tools\Build-Plugin.ps1
.\tools\Install-PluginToCache.ps1 -Force
# Restart VSCode → Test
```

**4. Not using --debug flag when troubleshooting**
```bash
# ❌ Wrong - can't see what's happening
claude --plugin-dir ./plugins/spearit-framework-light

# ✅ Right - see loading and execution details
claude --plugin-dir ./plugins/spearit-framework-light --debug
```

### Performance Testing

**Track these metrics for each command:**
- Token usage (from debug logs or CLI output)
- Execution time (from debug logs)
- Task agent spawning (from debug logs)

**Performance budgets:**
- Simple utilities: <1k tokens, <5 seconds
- File operations: <2k tokens, <10 seconds
- Complex operations: <5k tokens, <30 seconds

**Red flags:**
- Simple command uses >2k tokens → Likely spawning agents
- Command takes >10 seconds → Check for inefficient operations
- Inconsistent execution time → May be making external calls

---

## Memory Capture Strategy

### When to Document Lessons

**Document immediately when:**
- You encounter an unexpected behavior
- You fix a performance issue
- You discover an undocumented constraint
- You solve a debugging challenge
- You optimize a pattern

### Where to Document

1. **MEMORY.md** - Short, focused lesson (auto-loaded in future sessions)
2. **Best practices doc** - Detailed explanation with examples (this file)
3. **Research doc** - If discovering new factual information about Claude Code

### What to Capture

**Essential elements:**
- Problem description (what went wrong)
- Root cause (why it happened)
- Solution (how to fix it)
- Example code (before/after if applicable)
- When to apply (relevance criteria)

**Keep it actionable:**
- Focus on "how to avoid" not just "what happened"
- Provide templates or patterns to copy
- Include test strategies
- Note performance impacts

---

## Future Best Practices

This document will grow as we learn more. Areas to explore:

- MCP server integration patterns
- Agent definition best practices
- Skills organization strategies
- Multi-command workflow patterns
- Plugin versioning strategies
- Migration/upgrade patterns

---

**Started:** 2026-02-09 (during FEAT-118 testing)
**Status:** Active - Growing with experience
**Related:** See `plugin-anthropic-standards.md` for official documentation

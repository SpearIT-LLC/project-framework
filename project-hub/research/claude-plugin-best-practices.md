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

## Testing Strategy

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

### Test Phases

1. **Plugin loads** - Verify with `--debug` flag
2. **Help command** - Test command listing
3. **Simple utility** - Test non-destructive commands (like next-id)
4. **Complex commands** - Test commands that modify files
5. **Error cases** - Test with missing directories, bad input
6. **Performance** - Measure token usage and time

### What to Test

- ✅ Command invocation works
- ✅ Namespace is correct
- ✅ Help displays correct commands
- ✅ Performance is reasonable
- ✅ No conflicts with local commands
- ✅ Error messages are clear
- ✅ Commands work in target environment

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
**Related:** See `anthropic-plugin-standards.md` for official documentation

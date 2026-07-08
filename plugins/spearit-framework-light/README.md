# SpearIT Project Framework - Lightweight Edition

**Version:** 1.0.0
**Author:** Gary Elliott / SpearIT Solutions
**License:** MIT

File-based Kanban workflow for solo developers. Manage work items (backlog → todo → doing → done) directly in your repository without external tools.

---

## What is This?

A **Claude Code plugin** that brings lightweight project management to any git repository:

- **Work items are markdown files** (FEAT-042-user-auth.md)
- **Workflow state is folder location** (backlog/, todo/, doing/, done/)
- **AI enforces workflow policies** (WIP limits, dependencies, transition rules)
- **Everything tracked in git** (no external services required)

Perfect for solo developers who want simple, transparent project tracking that works with AI collaboration.

---

## Quick Start

### Installation

1. Install the plugin in Claude Code:
   ```
   [Installation instructions will be provided after marketplace approval]
   ```

2. (Optional) Create the workflow structure in your project:
   ```bash
   mkdir -p project-hub/work/{backlog,todo,doing,done}
   mkdir -p project-hub/history/{archive,sessions,releases}
   ```

   The plugin will offer to create this structure automatically if it doesn't exist.

### 5-Minute Workflow

**1. Create a work item:**
```
/spearit-framework-light:new
```
Follow the interactive prompts:
- Type: `FEAT`
- Title: `Add user login`
- Priority: `High`
- Summary: `Add basic username/password login functionality`

Creates: `project-hub/work/backlog/FEAT-001-add-user-login.md`

**2. Move through workflow:**
```
/spearit-framework-light:move FEAT-001 todo      # Commit to work
/spearit-framework-light:move FEAT-001 doing     # Start work
[... implement the feature ...]
/spearit-framework-light:move FEAT-001 done      # Complete work
```

That's it! Your work items are tracked as files in git with complete history.

---

## Features

### 3 Core Commands

| Command | Purpose |
|---------|---------|
| `/spearit-framework-light:help` | Command reference and documentation |
| `/spearit-framework-light:new` | AI-guided work item planning with interactive breakdown and approval |
| `/spearit-framework-light:move` | Move work items through workflow with policy enforcement |

### Workflow Enforcement

✅ **Transition validation** - Only valid state changes allowed
✅ **WIP limits** - Enforce focus (configurable via `.limit` files)
✅ **Dependency checking** - Can't start work until dependencies complete
✅ **Pre-implementation review** - Understand before building
✅ **Completion criteria** - All acceptance criteria must be met

### AI Collaboration

The plugin includes **skills** that teach Claude about the methodology:
- File-based Kanban workflow concepts
- Work item structure and management
- Transition policies and enforcement

Claude will understand your workflow and help enforce best practices automatically.

---

## Commands Reference

### `/spearit-framework-light:new`

**AI-guided work item planning** - Let Claude help you think through what you're building.

**Syntax:**
```
/spearit-framework-light:new
```

**How it works:**
1. **You describe** what you want to build (high-level idea)
2. **Claude analyzes** your codebase and proposes a breakdown
3. **You review** the suggested approach, scope, and acceptance criteria
4. **Claude creates** a structured work item ready for implementation

**Interactive Prompts:**
- **Type:** FEAT, BUG, TECH, TASK, SPIKE (canonical set, ADR-006)
- **Title:** Short description (auto-converted to kebab-case filename)
- **Priority:** High, Medium, Low
- **Summary:** Describe your idea at any level of detail

**What makes this powerful:**
- 🤖 **AI analyzes your codebase** - Understands existing patterns and architecture
- 📋 **Structured breakdown** - Suggests tasks, dependencies, and acceptance criteria
- ✅ **You stay in control** - Review and approve before creating the work item
- 🎯 **Better planning** - Catch issues and clarify scope before coding starts

**Examples:**
```
/spearit-framework-light:new
→ Type: FEAT
→ Title: Add dark mode
→ Priority: High
→ Summary: Users want a dark theme option. Should persist preference.

[Claude analyzes codebase and proposes:]
- Theme context with localStorage persistence
- CSS variable system for colors
- Toggle component in settings
- Migration path for existing users

[You review and approve]
✓ Created: project-hub/work/backlog/FEAT-043-add-dark-mode.md
```

**Creates file in:** `project-hub/work/backlog/` (all new items start in backlog)

**Auto-generates:**
- Next available ID (scans existing work items automatically)
- Kebab-case filename from title
- AI-generated implementation plan with tasks and criteria
- Git adds file automatically

**Graceful:** Creates `project-hub/work/backlog/` directory if it doesn't exist.

**Note:** The planning conversation is the secret sauce - Claude helps you think through edge cases, dependencies, and scope before you commit to building.

---

### `/spearit-framework-light:move`

Move work items between workflow folders with policy enforcement.

**Syntax:**
```
/spearit-framework-light:move <item-id> <target-folder>
```

**Examples:**
```
/spearit-framework-light:move FEAT-042 todo      # Commit to work
/spearit-framework-light:move FEAT-042 doing     # Start work
/spearit-framework-light:move FEAT-042 done      # Complete work
/spearit-framework-light:move FEAT-042 backlog   # Deprioritize
/spearit-framework-light:move FEAT-042 archive   # Cancel work
```

**Valid folders:** backlog, todo, doing, done, archive, releases

**Enforces:**
- Transition validity (e.g., can't skip from backlog → doing)
- WIP limits (default: 1 item in doing/ for solo developers)
- Dependency satisfaction (all dependencies must be in done/)
- Completion criteria (all acceptance criteria checked)

---

### `/spearit-framework-light:help`

Show available commands or detailed help for a specific command.

**Syntax:**
```
/spearit-framework-light:help [command-name]
```

**Examples:**
```
/spearit-framework-light:help           # List all commands
/spearit-framework-light:help move      # Detailed help for move
```

---

## Work Item Types

| Type | Purpose | Example |
|------|---------|---------|
| **FEAT** | New feature or functionality | `FEAT-042-user-authentication.md` |
| **BUG** | Bug fix or defect | `BUG-018-login-redirect-loop.md` |
| **TECH** | Work on the system — tech debt, internal improvement, docs, chores, refactors | `TECH-007-migrate-to-async-api.md` |
| **TASK** | Discrete operational/setup work (maps to a Jira/GitHub Task) | `TASK-021-migrate-ci-runner.md` |
| **SPIKE** | Research or investigation | `SPIKE-003-evaluate-caching.md` |

> Canonical **5** per ADR-006 (reduced from an earlier 8: DOCS/CHORE/REFACTOR fold into TECH).
> Legacy prefixes on existing items (e.g. `DECISION`, `BUGFIX`, `CHORE`) are recognized for parsing
> but never offered for creation. `DECISION` is retired — record decisions as ADRs
> (`project-hub/research/adr/`).

---

## Workflow States

```
backlog/  →  todo/  →  doing/  →  done/  →  releases/
              ↑          ↓
              └──────────┘
                (pause)
```

**backlog/** - Ideas and future work (no commitment)
**todo/** - Committed work (prioritized queue)
**doing/** - Active work (WIP limited, focus enforced)
**done/** - Completed work (awaiting release)
**archive/** - Cancelled or superseded work
**releases/** - Released work (archived post-release)

---

## Configuration

### WIP Limits

Create `.limit` files to configure Work In Progress limits:

```bash
# Limit doing/ to 1 item (solo developer focus)
echo "1" > project-hub/work/doing/.limit

# Limit todo/ to 5 items (prevent backlog creep)
echo "5" > project-hub/work/todo/.limit
```

**Defaults:**
- `doing/`: 1 item (enforces focus)
- `todo/`: No limit (configurable)

### Dependencies

Specify dependencies in work item metadata:

```markdown
**Depends On:** FEAT-038, TECH-015
```

The move command will block moving to `doing/` until all dependencies are in `done/`.

---

## Philosophy

This plugin embodies:

- **Simplicity:** Files and folders over complex tools
- **Focus:** WIP limits prevent context switching
- **Transparency:** See entire workflow in file tree
- **Commitment:** Explicit transitions from "maybe" to "yes"
- **Completion:** Finish what you start
- **History:** Archive, don't delete (preserve lessons)
- **AI Collaboration:** Teach Claude your methodology through skills

---

## When This Works Well

✅ Solo developers working independently
✅ Projects tracked in git repositories
✅ Working with AI assistants (Claude Code)
✅ Want lightweight process without heavy tools
✅ Value transparency and simplicity

## When to Consider Alternatives

❌ Teams (ID collision risk - use full framework instead)
❌ Need rich reporting/analytics dashboards
❌ External stakeholders require specific PM tools
❌ Regulatory compliance needs specific audit formats

**Note for teams:** The full SpearIT Project Framework includes centralized ID management suitable for team collaboration.

---

## Part of the SpearIT Project Framework

This plugin is the **Lightweight Edition** - a subset of the comprehensive SpearIT Project Framework.

**What's included in this plugin:**
- 3 core workflow commands (help, new, move)
- Automatic work item ID assignment
- Works in any git repository
- Install and use immediately
- Perfect for existing projects

**Coming soon:** A full framework edition with additional commands (session history, status tracking, backlog management, roadmap planning) is in development.

For more information: **https://github.com/SpearIT-LLC/project-framework**

---

## Performance Notes

**Move command execution time:** 9-16 seconds per operation

Claude Code plugins work by providing instructions that the AI interprets and executes. Each operation requires API round-trips (network + LLM processing), which introduces latency that cannot be eliminated without architectural changes to Claude Code itself.

**What we've optimized:**
- ✅ Script-based execution (reduced from 38s to 9-16s - **58% faster**)
- ✅ Single bash call per operation (minimized API round-trips)
- ✅ Embedded validation logic (no unnecessary AI reasoning)

**Performance breakdown:**
- Simple moves (backlog/todo/done/archive): **9-11 seconds**
- Move to doing (includes pre-implementation review): **12-18 seconds**

**Why the review adds value:**
The extra time when moving to `doing/` includes:
- Reading the work item to understand scope
- Checking dependencies and open questions
- Presenting a pre-implementation summary
- Getting your approval before starting work

This "pause and review" moment prevents costly mistakes and is intentionally preserved.

**Future improvements:**
If Claude Code adds support for direct script execution (bypassing AI interpretation), performance could improve to 1-2 seconds per operation. Until then, this plugin represents the optimal performance achievable within current architectural constraints.

**For power users:** If you need instant execution, the framework repository includes standalone bash scripts that can be run directly without plugin overhead.

---

## Support

- **Issues:** Report bugs or request features at the GitHub repository
- **Documentation:** Full methodology in plugin skills (loaded automatically)
- **Help:** Use `/spearit-framework-light:help` for command reference

---

## License

MIT License - See LICENSE file for details

Copyright (c) 2026 Gary Elliott / SpearIT Solutions

---

**Version:** 1.0.0
**Last Updated:** 2026-02-12

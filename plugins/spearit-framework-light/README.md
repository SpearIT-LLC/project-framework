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

**1. Get next work item ID:**
```
/spearit-framework-light:next-id
```
Returns: `FEAT-001`

**2. Create a work item:**
Create `project-hub/work/backlog/FEAT-001-add-login.md`:
```markdown
# Feature: Add User Login

**ID:** FEAT-001
**Type:** Feature
**Priority:** High
**Created:** 2026-02-09

## Summary
Add basic username/password login functionality.

## Acceptance Criteria
- [ ] Users can log in with username/password
- [ ] Invalid credentials show error message
- [ ] Successful login redirects to dashboard
```

**3. Move through workflow:**
```
/spearit-framework-light:move FEAT-001 todo      # Commit to work
/spearit-framework-light:move FEAT-001 doing     # Start work
[... implement the feature ...]
/spearit-framework-light:move FEAT-001 done      # Complete work
```

**4. Track your session:**
```
/spearit-framework-light:session-history "FEAT-001 implementation"
```

That's it! You now have a complete audit trail of your work in git.

---

## Features

### 4 Core Commands

| Command | Purpose |
|---------|---------|
| `/spearit-framework-light:move` | Move work items through workflow with policy enforcement |
| `/spearit-framework-light:next-id` | Get next available work item ID |
| `/spearit-framework-light:session-history` | Generate session history from git and conversation |
| `/spearit-framework-light:help` | Command reference and documentation |

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

### `/spearit-framework-light:next-id`

Get the next available work item ID by scanning existing work items.

**Syntax:**
```
/spearit-framework-light:next-id [type]
```

**Examples:**
```
/spearit-framework-light:next-id          # Returns next available ID
/spearit-framework-light:next-id FEAT     # Get next FEAT ID specifically
```

**Scans:**
- All workflow folders (backlog, todo, doing, done)
- Archive and release history
- Returns next sequential number

---

### `/spearit-framework-light:session-history`

Generate or update session history document from git commits and conversation context.

**Syntax:**
```
/spearit-framework-light:session-history [focus]
```

**Examples:**
```
/spearit-framework-light:session-history
/spearit-framework-light:session-history "FEAT-042 implementation"
```

**Creates:** `project-hub/history/sessions/YYYY-MM-DD-SESSION-HISTORY.md`

**Includes:**
- Work completed
- Decisions made and rationale
- Files created/modified/moved
- Current project state

**Philosophy:** Session history shows the journey, not just the destination (append-only).

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
| **TECH** | Technical debt or refactoring | `TECH-007-migrate-to-async-api.md` |
| **SPIKE** | Research or investigation | `SPIKE-003-evaluate-caching.md` |
| **DECISION** | Architecture decision record | `DECISION-001-database-selection.md` |

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
- 4 core workflow commands
- Works in any git repository
- Install and use immediately
- Perfect for existing projects

**Coming soon:** A comprehensive edition with complete project scaffolding, templates, and additional commands is in development.

For more information: **https://github.com/spearit-solutions/project-framework**

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
**Last Updated:** 2026-02-09

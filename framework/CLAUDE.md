# General Project Instructions

**For AI Assistants:** This is your collaboration contract with users. Read this first, then consult [collaboration docs](docs/collaboration/) for detailed guidance.

*Note: Bootstrap block lives in root CLAUDE.md - that's what loads at session start.*

**Quick Reference:** See [CLAUDE-QUICK-REFERENCE.md](CLAUDE-QUICK-REFERENCE.md) for critical rules and decision trees.

**Last Updated:** 2026-01-17

---

## Quick Start for AI

**New to this project?** Read in this order:
1. This file (CLAUDE.md) - Critical rules and quick references
2. [collaboration/README.md](docs/collaboration/README.md) - Navigation to detailed guides
3. Relevant collaboration docs as needed (see AI Reading Protocol below)

---

## Project Overview

### What Is This?

The **SpearIT Project Framework** is a comprehensive, multi-level project management framework designed to bring structure, consistency, and AI integration to software projects of any size.

**Key Innovation:** Scales from single scripts to full applications using a 3-dimension classification system.

**This Project Uses:** Standard Framework (see Framework Levels Overview below)

---

## Architecture: Project Folders

```
ProjectRoot/
├── <project_specific>/         # Project specific folders. Create at root as needed.
├── CHANGELOG.md                # Version history and changes (Keep a Changelog format)
├── CLAUDE.md                   # This file - AI collaboration contract
├── CLAUDE-QUICK-REFERENCE.md   # Critical rules (<200 lines)
├── INDEX.md                    # Project specific index of documents
├── PROJECT-STATUS.md           # SINGLE SOURCE OF TRUTH for version & status
├── README.md                   # Project specific overview and documentation
├── docs/                       # Project documentation
│   └── collaboration/          # Universal collaboration guides (humans & AI)
├── process/                    # Workflow documentation
├── templates/                  # Planning templates (COPY these, don't edit)
├── patterns/                   # Implementation patterns
└── project-hub/                   # Work management and history
    ├── work/                   # Kanban workflow for active work
    │   ├── backlog/            # Future work (not approved yet)
    │   ├── todo/               # Planned work items (approved, not started)
    │   ├── doing/              # Currently in progress (WIP limit enforced)
    │   │   └── .limit          # WIP limit for doing/ (default: 2)
    │   └── done/               # Completed work items (awaiting release)
    ├── research/               # Project research, ADRs
    │   └── adr/                # Architecture Decision Records
    ├── retrospectives/         # Project retrospectives
    └── history/                # Daily session history, releases archive
        ├── sessions/           # Daily session logs
        └── releases/           # Release archives
```

**Critical Folders:**
- `docs/collaboration/` - **Universal collaboration guides** (read these for detailed guidance)
- `templates/` - **Copy-paste starting points** (never edit templates directly)
- `project-hub/work/` - **Kanban workflow** (backlog → todo → doing → done)

---

## AI Reading Protocol

**When do I read which documentation?**

### Decision Tree

```
Resuming work or checking status?
└─ Read work items in work/doing/ to check completion status

Starting work on project?
├─ Need workflow process? → docs/collaboration/workflow-guide.md
├─ Need coding standards? → docs/collaboration/code-quality-standards.md
├─ Need testing guidance? → docs/collaboration/testing-strategy.md
├─ Need security guidance? → docs/collaboration/security-policy.md
└─ Need framework understanding? → docs/collaboration/architecture-guide.md

Encountering problem?
└─ docs/collaboration/troubleshooting-guide.md

Making architectural decision?
├─ Need ADR guidance? → docs/collaboration/workflow-guide.md (ADR section)
└─ Need framework context? → docs/collaboration/architecture-guide.md

Reviewing code?
├─ docs/collaboration/code-quality-standards.md
├─ docs/collaboration/security-policy.md
└─ docs/collaboration/testing-strategy.md

Not sure which doc?
└─ docs/collaboration/README.md (navigation index)
```

### Proactive Reading Patterns

**When resuming work or checking project status:**
1. **ALWAYS read work items in `work/doing/` to check completion status**
2. Check if all tasks/checklists within work items are complete
3. If incomplete: Offer to continue the work
4. If complete: Offer to move to `done/` and proceed with release
5. **NEVER suggest next actions without verifying current work state**

**Before writing ANY code:**
1. Read [code-quality-standards.md](docs/collaboration/code-quality-standards.md) for coding standards
2. Read [security-policy.md](docs/collaboration/security-policy.md) if handling user input, auth, or data
3. Read [testing-strategy.md](docs/collaboration/testing-strategy.md) for testing approach

**Before starting feature implementation:**
1. Read [workflow-guide.md](docs/collaboration/workflow-guide.md) for workflow process
2. Follow AI Workflow Checkpoint Policy (below)

**When stuck or encountering issues:**
1. Read [troubleshooting-guide.md](docs/collaboration/troubleshooting-guide.md) for common issues

### Documentation Hierarchy

```
CLAUDE.md (This File)
    ↓ Quick references, critical rules
docs/collaboration/ Guides
    ↓ Detailed guidance with examples
templates/
    ↓ Copy-paste starting points
```

**Strategy:** This file = quick reference. Collaboration docs = full details. Templates = implementation starting points.

---

## AI Roles

The framework supports context-aware AI roles that help the AI adopt appropriate mindsets for different types of work.

### How Roles Work

1. **Check `framework.yaml`** for the `roles` section
2. **Read the definitions file** specified in `roles.definitions`
3. **Apply the default role** specified in `roles.default`, or use `project_type_defaults` if no default is set
4. **Switch roles conversationally** when the user indicates a different type of work

### Role Selection

Roles are triggered through conversation, not automatic path matching:

- User says "Let's work on the backlog" → Adopt **scrum-master** role
- User says "I need to fix a bug" → Adopt **developer** role
- User says "Time to release" → Adopt **release-manager** role
- User says "Document this decision" → Adopt **architect** or **technical-writer** role

### Mid-Session Context Switch

If the user's request doesn't match the current role context, ask before switching:

> "We've been working on code changes. This request involves moving work items - should I switch to workflow management mode, or is this a quick aside?"

### Role Format

Roles use the naming pattern: `{experience}-{variant}-{base_role}`

Examples:
- `senior-production-developer` - Senior developer focused on production-quality code
- `senior-api-developer` - Senior developer focused on API design
- `senior-scrum-master` - Senior scrum master for workflow governance

### Fallback Behavior

- No `roles` section in framework.yaml → Use `fallback_default` from definitions file (typically `senior-claude`)
- `roles` section present but no `default` → Use `project_type_defaults` mapping based on `project.type`

### Reference

- Role definitions: See path in `framework.yaml` → `roles.definitions`
- Schema: [framework/docs/ref/framework-schema.yaml](docs/ref/framework-schema.yaml)

---

## AI Workflow Checkpoint Policy (CRITICAL - ADR-001)

**MANDATORY:** When user requests a new feature, you MUST follow this workflow with three approval checkpoints.

**The 11-Step Workflow:**
```
1. User Request → 2. Research → 3. Backlog → 4. Present Plan [CHECKPOINT] →
5. User Approval → 6. Check WIP → 7. Move to Doing → 7.5. Review Approach [CHECKPOINT] →
8. Implement → 8.5. Review & Approval [CHECKPOINT] → 9. Release → Done
```

### The Three Mandatory Checkpoints

**Step 4: Present Plan to User** ⚠️ CHECKPOINT
- After creating backlog item, summarize approach and files affected
- **ASK FOR EXPLICIT APPROVAL:** "Should I proceed with implementing [WORK-ITEM-ID]?"
- ❌ DON'T: Move to todo/doing without approval

**Step 7.5: Pre-Implementation Review** ⚠️ CHECKPOINT
- After moving to doing/ and before coding, read the complete work item thoroughly
- Identify open questions, design decisions, alternatives (search for: TODO, TBD, Question, DECIDE, Option A/B/C)
- Summarize approach and files to modify
- **ASK FOR CONFIRMATION:** "Before I begin implementation, I've reviewed [WORK-ITEM-ID]. The approach is [summary]. [Open questions if any]. Do you agree with this approach?"
- ❌ DON'T: Start coding without reviewing work item and confirming approach

**Step 8.5: Review & Approval** ⚠️ CHECKPOINT
- After implementation, present completed work for user review
- Summarize changes made (files created/modified) and test results
- **ASK FOR EXPLICIT APPROVAL:** "The work is complete and ready for review. Would you like to review the changes before I move to done/ and proceed with release?"
- ❌ DON'T: Move to done/ without user approval

### Critical Rules

**Never skip checkpoints:**
- Step 4 ensures user controls priorities and timing
- Step 7.5 confirms approach with fresh context before coding
- Step 8.5 ensures user reviews work before release

**Respect WIP limits:**
- Check `project-hub/work/doing/.limit` before moving items to doing/
- If at limit, complete current work first

**Follow kanban flow:**
- Items move: backlog → todo → doing → done
- Never jump straight to doing/ without approval
- Never set status to "Doing" without user approval

**Workflow Transitions:**
- When moving work items between folders, read and follow the `onTransition` policy in `framework.yaml`
- Check transition validity matrix before moving (e.g., backlog → doing is INVALID)
- Complete per-transition checklist for target folder
- See [workflow-guide.md#workflow-transitions](docs/collaboration/workflow-guide.md#workflow-transitions) for full rules

**Release atomically (Step 9):**
- Calculate version: Read PROJECT-STATUS.md + work item Version Impact → calculate next version → confirm with user
  - **Grouped releases:** Multiple items in done/? Use highest Version Impact (MAJOR > MINOR > PATCH)
- Update PROJECT-STATUS.md + CHANGELOG.md + README.md (if new features affect user-facing docs) + move to done/ → commit + tag together
  - **Grouped releases:** List all items in CHANGELOG under one version, organized by category (Added/Changed/Fixed)
- Archive immediately: Create `project-hub/history/releases/vX.Y.Z/` → **USE git mv** to move all work items from done/
  - Command: `git mv project-hub/work/done/WORK-ITEM-* project-hub/history/releases/vX.Y.Z/`
  - ⚠️ CRITICAL: Use `git mv` (move), NOT `cp` (copy) - prevents duplicates
  - Commit: `git commit -m "chore: Archive vX.Y.Z work items"`
  - **Grouped releases:** All items go into same release folder (e.g., `releases/v2.3.0/` contains multiple work items)
- Verify: Check done/ is empty: `ls project-hub/work/done/*.md` (should return empty)
- Why atomic? Version must match implementation. Why archive? Maintains WIP limits, preserves complete history.
- **Full grouped release process:** See [workflow-guide.md](docs/collaboration/workflow-guide.md#releasing-multiple-work-items-together)

### Rationale

This policy ensures:
- User maintains control (Step 4 approval)
- AI confirms approach with fresh context (Step 7.5 review)
- User reviews all work before release (Step 8.5 approval)
- WIP limits prevent context switching
- Open questions addressed before implementation
- No surprises - user sees and approves changes

**Reference:** [ADR-001: AI Workflow Checkpoint Policy](project-hub/research/adr/001-ai-workflow-checkpoint-policy.md)

**Full Workflow Details:** See [Workflow Guide](docs/collaboration/workflow-guide.md) for complete 11-step process, work item numbering, templates, and examples.

---

## Project Classification & Framework Selection
<NOTE: This section needs rework. We no longer have 3 framework levels.>

Before starting any project, determine the appropriate framework level based on these three dimensions:

### The Three Dimensions

**1. Scope & Complexity:**
- Script → Tool → Application → System

**2. Lifespan & Evolution:**
- Throwaway → Short-term → Maintained → Critical

**3. Team & Collaboration:**
- Solo/Personal → Solo/Professional → Small Team → Large Team

### Framework Selection Matrix

| If you selected... | Use Framework Level |
|-------------------|---------------------|
| Script + Throwaway/Short-term + Solo/Personal | **Minimal** |
| Script/Tool + Maintained + Solo/Professional | **Light** |
| Tool/Application + Maintained + Solo/Professional or Small Team | **Standard** |
| Application/System + Maintained/Critical + Any team size | **Full** |

### Framework Levels Overview

**Minimal Framework:**
- README.md with embedded "Why" section
- Optional git, optional CHANGELOG
- For: Single scripts, throwaway projects, personal automation

**Light Framework:**
- README.md, PROJECT-STATUS.md, CHANGELOG.md
- Simplified project-hub/project/history/ for decisions
- No kanban workflow, lightweight git
- For: Small tools, medium lifespan, solo with handoff

**Standard Framework:**
- Complete project-hub/ structure with kanban workflow
- Formal planning and releases
- For: Applications, ongoing maintenance, small teams
- Formal ADRs, comprehensive retrospectives
- Production-ready documentation
- For: Full applications, small teams, moderate to complex architectures

**Setup Guide:** See templates package

**Full Architecture:** [collaboration/architecture-guide.md](docs/collaboration/architecture-guide.md)

---

## Core Standards Summary

### Code Quality

**Key Principles:**
- Functions ≤ 50 lines
- DRY (Don't Repeat Yourself)
- Single Responsibility per function
- Descriptive naming (no `tmp`, `data`, `handleStuff`)
- Fail fast on invalid input

**Example - Fail Fast:**
```javascript
function divide(a, b) {
  if (typeof a !== 'number' || typeof b !== 'number') {
    throw new TypeError('Both arguments must be numbers');
  }
  if (b === 0) throw new Error('Division by zero');
  return a / b;
}
```

**Full Details:** [collaboration/code-quality-standards.md](docs/collaboration/code-quality-standards.md)

---

### Security

**Critical Rules:**
- ✅ Parameterized queries (NEVER concatenate user input in SQL)
- ✅ Validate ALL user input (allowlist > blocklist)
- ✅ Hash passwords with bcrypt (NEVER plain text, MD5, or SHA without salt)
- ✅ Sanitize HTML output (use DOMPurify or similar)
- ❌ NEVER use eval() with user input
- ❌ NEVER store secrets in code (use environment variables)

**Example - SQL Injection Prevention:**
```javascript
// ❌ BAD
const query = `SELECT * FROM users WHERE email = '${email}'`;

// ✅ GOOD
const query = 'SELECT * FROM users WHERE email = ?';
await db.query(query, [email]);
```

**Full Details:** [collaboration/security-policy.md](docs/collaboration/security-policy.md)

---

### Testing

**TDD Mindset:**
- Red (failing test) → Green (passing test) → Refactor
- Write tests for bug fixes and new features
- Test edge cases: empty/null, boundaries, invalid states

**Coverage Targets:**
- Core logic: 90-100%
- Services: 80-90%
- UI: 60-80%

**Edge Cases Always Test:**
- Empty/null/undefined inputs
- Boundary values (max/min)
- Invalid states
- Wrong types

**Full Details:** [collaboration/testing-strategy.md](docs/collaboration/testing-strategy.md)

---

### Documentation

**Core Files (Root):**
- README.md - Project overview
- PROJECT-STATUS.md - **SINGLE SOURCE OF TRUTH** for version & status
- CHANGELOG.md - Version history ([Keep a Changelog](https://keepachangelog.com/) format)
- INDEX.md - Navigation guide

**Session History:**
- Format: `YYYY-MM-DD-SESSION-HISTORY.md`
- Location: `project-hub/history/sessions/`
- Content: What was done, decisions made, blockers, next steps

**Work Items:**
- Use templates from `templates/`
- Location: `project-hub/work/` (backlog/todo/doing/done)

**Full Details:** [collaboration/workflow-guide.md](docs/collaboration/workflow-guide.md)

---

### Git Workflow

**Branches:**
- Feature branches for all work (`feature/name`, `bugfix/issue-123`)
- Merge via Pull Request
- Avoid direct commits to main

**Commit Messages:**
- Conventional commits (`feat:`, `fix:`, `docs:`)
- Include work item ID if applicable
- Concise one-line summary

**Atomic Releases:**
- All version updates in single commit with implementation
- Create annotated git tag
- Push with --tags

**Full Details:** [collaboration/workflow-guide.md](docs/collaboration/workflow-guide.md#git-workflow)

---

## Architecture Decision Records (ADRs)

**Quick Decision Tree:**

Need to document a decision between alternatives?
```
├─ YES → Create ADR
└─ NO → Just implement (or use code comment)
```

Which template?
```
├─ Affects 3+ files OR hard to change later OR significant trade-offs → MAJOR
└─ Simple, 1-2 files, easy to change → MINOR
```

**When in doubt:** Start with MINOR, upgrade to MAJOR if you discover complexity

**Templates:**
- MAJOR: `templates/ADR-MAJOR-TEMPLATE.md`
- MINOR: `templates/ADR-MINOR-TEMPLATE.md`

**Storage:** `project-hub/research/adr/NNN-decision-name.md`

**Examples:**
- MAJOR: Database choice, authentication architecture, state management
- MINOR: JSON library, log format, file naming convention

**Full Details:** [collaboration/workflow-guide.md](docs/collaboration/workflow-guide.md#architecture-decision-records-adrs) for complete guidance on when to create, upgrading MINOR to MAJOR, lifecycle, and examples.

---

## Working with Claude (Collaboration Tips)

### Mode Clarity
- Distinguish between planning mode and implementation mode
- When exploring: "I'm researching options"
- When ready to code: "Let's implement approach X"

### Standards Adherence
- Explicitly reference collaboration docs before coding
- Example: "Let me check code-quality-standards.md first"
- Review project-specific conventions

### Context Management
- Propose bounded tasks that fit in conversation context
- Break large features into smaller steps
- Save progress frequently in planning documents

### Proactive Clarification
- Ask essential questions upfront
- "What's the one thing this must accomplish?"
- "Are there constraints I should know about?"

**Full Details:** [collaboration/workflow-guide.md](docs/collaboration/workflow-guide.md#collaboration-practices)

---

## Emergency Reference

### Top 5 Common Issues

**1. WIP Limit Violation**
```bash
cat project-hub/work/doing/.limit
ls project-hub/work/doing/*.md | wc -l
# If count > limit: move items to todo/ or complete to done/
```

**2. Version Mismatch**
```bash
grep "Current Version" PROJECT-STATUS.md
git describe --tags --abbrev=0
# Should match! If not, update PROJECT-STATUS.md and commit
```

**3. Bypassed Approval Checkpoint (ADR-001)**
- Symptom: Feature implemented without "Should I proceed?"
- Fix: Document violation in retrospective, review ADR-001

**4. Modified Template Instead of Instance**
```bash
# CORRECT: Copy template first
cp templates/FEATURE-TEMPLATE.md project-hub/work/backlog/feature-123.md
# Edit the copy, NOT the template
```

**5. Forgot to Archive After Release**
```bash
mkdir -p project-hub/history/releases/vX.Y.Z
mv project-hub/work/done/*.md project-hub/history/releases/vX.Y.Z/
```

**Full Troubleshooting:** [collaboration/troubleshooting-guide.md](docs/collaboration/troubleshooting-guide.md)

### Claude Code Permissions

**Quick Setup for Non-Destructive Operations:**

The project includes comprehensive permission configuration in `.claude/settings.local.json` that allows all read-only operations without approval prompts:

**Allowed Tools (no prompts):**
- `Read(**)` - Read any project files
- `Glob` - Pattern-based file search
- `Grep` - Content search
- `Task` - Sub-agents for complex work
- Safe Bash commands: `ls`, `cat`, `pwd`, `git status`

**Security:** Sensitive files should be in `.gitignore` (`.env`, `secrets/`, credentials, etc.)

**Configuration Location:** `.claude/settings.local.json`

---

## Framework Commands (`/fw-*`)

Framework commands provide shortcuts for common workflow operations. All commands use the `/fw-` prefix.

### Command Registry

| Command | Description | Status |
|---------|-------------|--------|
| `/fw-help` | List available commands or get help on a specific command | Active |
| `/fw-move` | Move work item between folders with policy enforcement | Active |
| `/fw-status` | Show project status summary | Active |
| `/fw-wip-check` | Check WIP limits and current work | Active |
| `/fw-backlog` | Review and prioritize backlog items | Active |

### Using Commands

**Syntax:** `/fw-<command> [arguments]`

**Examples:**
```
/fw-help                    # List all commands
/fw-help move               # Get help on /fw-move
/fw-status                  # Show project status
/fw-move FEAT-042 todo      # Move FEAT-042 to todo/
/fw-wip-check               # Check WIP limit status
/fw-backlog                 # Review backlog items
```

### Command Reference

#### /fw-help

List available commands or get detailed help on a specific command.

```
/fw-help [command-name]

Arguments:
  command-name   (optional) Command to get help for (without /fw- prefix)

Examples:
  /fw-help           List all available commands
  /fw-help move      Show detailed help for /fw-move
```

---

#### /fw-move

Move a work item between workflow folders with transition validation.

```
/fw-move <item-id> <target-folder>

Arguments:
  item-id        Work item ID (e.g., FEAT-018, BUGFIX-001)
  target-folder  One of: backlog, todo, doing, done

Examples:
  /fw-move FEAT-042 todo     Move from backlog to todo
  /fw-move FEAT-042 doing    Start work (moves to doing)
  /fw-move FEAT-042 done     Complete work (moves to done)

Notes:
  - Validates transitions (e.g., backlog → doing is invalid)
  - Checks WIP limit before moving to doing/
  - Uses git mv for version control
```

**Valid Transitions:**
| From | To | Valid |
|------|----|-------|
| backlog | todo | ✅ |
| backlog | doing | ❌ (use todo first) |
| todo | doing | ✅ |
| todo | backlog | ✅ |
| doing | done | ✅ |
| doing | todo | ✅ |
| done | * | ❌ (create new item) |

---

#### /fw-status

Show project status summary including version, current work, and workflow health.

```
/fw-status [--compact]

Options:
  --compact    Show single-line summary

Output includes:
  - Current version (from PROJECT-STATUS.md)
  - Items in each workflow folder
  - WIP limit status
  - Items awaiting release
```

---

#### /fw-wip-check

Check Work In Progress limits and list items currently in doing/.

```
/fw-wip-check

Output includes:
  - Current count vs limit
  - List of items in progress
  - Status indicator (✅ under, ⚠️ at, ❌ over limit)
```

---

#### /fw-backlog

Review and prioritize backlog items interactively.

```
/fw-backlog [subcommand] [item-id]

Subcommands:
  (none)           List all backlog items
  detail <id>      Show full details for an item
  move <id>        Move item to todo/ (with confirmation)
  prioritize       Interactive prioritization session

Examples:
  /fw-backlog                   List all backlog items
  /fw-backlog detail FEAT-037   Show details for FEAT-037
  /fw-backlog move FEAT-037     Move FEAT-037 to todo/
```

---

### Adding New Commands

New commands should follow this pattern:

1. **Naming:** `/fw-<verb>` or `/fw-<noun>` (e.g., `/fw-release`, `/fw-roadmap`)
2. **Documentation:** Add to registry table and command reference section
3. **Work item:** Create FEAT-018.x sub-task for implementation
4. **Consistency:** Follow existing argument and output patterns

**Reference:** [FEAT-018: Claude Command Framework](project-hub/work/doing/feature-018-claude-command-framework.md)

---

## Related Documentation

**Quick Reference:**
- [CLAUDE-QUICK-REFERENCE.md](CLAUDE-QUICK-REFERENCE.md) - Critical rules and decision trees (<200 lines)

**Detailed Collaboration Guides:**
- [collaboration/README.md](docs/collaboration/README.md) - Navigation index
- [collaboration/workflow-guide.md](docs/collaboration/workflow-guide.md) - Complete workflow process
- [collaboration/code-quality-standards.md](docs/collaboration/code-quality-standards.md) - Coding standards
- [collaboration/testing-strategy.md](docs/collaboration/testing-strategy.md) - Testing approach
- [collaboration/security-policy.md](docs/collaboration/security-policy.md) - Security requirements
- [collaboration/architecture-guide.md](docs/collaboration/architecture-guide.md) - Framework design
- [collaboration/troubleshooting-guide.md](docs/collaboration/troubleshooting-guide.md) - Common issues

**Templates:**
- [templates/](templates/) - Copy-paste starting points

**Project Info:**
- [PROJECT-STATUS.md](PROJECT-STATUS.md) - Current version and status (SINGLE SOURCE OF TRUTH)
- [CHANGELOG.md](CHANGELOG.md) - Version history
- [README.md](README.md) - Project overview
- [INDEX.md](INDEX.md) - Documentation index

---

**Last Updated:** 2026-01-16
**Framework Level:** Standard (see [PROJECT-STATUS.md](PROJECT-STATUS.md) for current version)

# General Project Instructions

**For AI Assistants:** This is your collaboration contract with users. Read this first, then consult [collaboration docs](thoughts/project/collaboration/) for detailed guidance.

**Quick Reference:** See [CLAUDE-QUICK-REFERENCE.md](CLAUDE-QUICK-REFERENCE.md) for critical rules and decision trees.

**Last Updated:** 2025-12-22

---

## Quick Start for AI

**New to this project?** Read in this order:
1. This file (CLAUDE.md) - Critical rules and quick references
2. [collaboration/README.md](thoughts/project/collaboration/README.md) - Navigation to detailed guides
3. Relevant collaboration docs as needed (see AI Reading Protocol below)

---

## Project Overview

### What Is This?

The **SpearIT Project Framework** is a comprehensive, multi-level project management framework designed to bring structure, consistency, and AI integration to software projects of any size.

**Key Innovation:** Scales from single scripts to enterprise systems using a 3-dimension classification system.

**This Project Uses:** Standard Framework Level

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
└── thoughts/                   # Project documentation and framework
    ├── project/                # Project specific content
    │   ├── work/               # Kanban workflow for active work
    │   │   ├── todo/           # Planned work items (approved, not started)
    │   │   ├── doing/          # Currently in progress (WIP limit enforced)
    │   │   │   └── .limit      # WIP limit for doing/ (default: 2)
    │   │   └── done/           # Completed work items (awaiting release)
    │   ├── planning/backlog/   # Future work (not approved yet)
    │   ├── collaboration/      # Universal collaboration guides (humans & AI)
    │   ├── reference/          # Current project reference docs
    │   ├── research/           # Project research, ADRs
    │   ├── retrospectives/     # Project retrospectives
    │   ├── history/            # Daily session history, releases archive
    │   └── archive/            # Historical/outdated docs
    └── framework/              # Reusable across projects
        ├── process/            # Workflow documentation
        ├── templates/          # Planning templates (COPY these, don't edit)
        ├── patterns/           # Implementation patterns
        └── tools/              # Framework tooling
```

**Critical Folders:**
- `thoughts/project/collaboration/` - **Universal collaboration guides** (read these for detailed guidance)
- `thoughts/framework/templates/` - **Copy-paste starting points** (never edit templates directly)

---

## AI Reading Protocol

**When do I read which documentation?**

### Decision Tree

```
Resuming work or checking status?
└─ Read work items in work/doing/ to check completion status

Starting work on project?
├─ Need workflow process? → collaboration/workflow-guide.md
├─ Need coding standards? → collaboration/code-quality-standards.md
├─ Need testing guidance? → collaboration/testing-strategy.md
├─ Need security guidance? → collaboration/security-policy.md
└─ Need framework understanding? → collaboration/architecture-guide.md

Encountering problem?
└─ collaboration/troubleshooting-guide.md

Making architectural decision?
├─ Need ADR guidance? → collaboration/workflow-guide.md (ADR section)
└─ Need framework context? → collaboration/architecture-guide.md

Reviewing code?
├─ collaboration/code-quality-standards.md
├─ collaboration/security-policy.md
└─ collaboration/testing-strategy.md

Not sure which doc?
└─ collaboration/README.md (navigation index)
```

### Proactive Reading Patterns

**When resuming work or checking project status:**
1. **ALWAYS read work items in `work/doing/` to check completion status**
2. Check if all tasks/checklists within work items are complete
3. If incomplete: Offer to continue the work
4. If complete: Offer to move to `done/` and proceed with release
5. **NEVER suggest next actions without verifying current work state**

**Before writing ANY code:**
1. Read [code-quality-standards.md](thoughts/project/collaboration/code-quality-standards.md) for coding standards
2. Read [security-policy.md](thoughts/project/collaboration/security-policy.md) if handling user input, auth, or data
3. Read [testing-strategy.md](thoughts/project/collaboration/testing-strategy.md) for testing approach

**Before starting feature implementation:**
1. Read [workflow-guide.md](thoughts/project/collaboration/workflow-guide.md) for workflow process
2. Follow AI Workflow Checkpoint Policy (below)

**When stuck or encountering issues:**
1. Read [troubleshooting-guide.md](thoughts/project/collaboration/troubleshooting-guide.md) for common issues

### Documentation Hierarchy

```
CLAUDE.md (This File)
    ↓ Quick references, critical rules
collaboration/ Guides
    ↓ Detailed guidance with examples
framework/templates/
    ↓ Copy-paste starting points
```

**Strategy:** This file = quick reference. Collaboration docs = full details. Templates = implementation starting points.

---

## AI Workflow Checkpoint Policy (CRITICAL - ADR-001)

**MANDATORY:** When user requests a new feature, you MUST follow this workflow to maintain process integrity.

**The Standard Workflow:**
```
User Request → Backlog → [CHECKPOINT: User Approval] → Todo → Doing → Done → Release
```

### The 11 Steps

**1. User Requests Feature** (e.g., "Add a quick reference guide")
   - ✅ DO: Listen and understand the requirement
   - ❌ DON'T: Start implementing immediately

**2. Brief Research** (30 seconds)
   - Does this already exist in the project?
   - Is there a better existing solution?
   - Quick viability check

**3. Create Backlog Item**
   - Use appropriate template (FEATURE-TEMPLATE.md, BUGFIX-TEMPLATE.md, etc.)
   - Determine next number by scanning ALL locations (see workflow-guide.md "Work Item Numbering")
   - Place in `thoughts/project/planning/backlog/`
   - Set status to "Backlog" in the document
   - ✅ Backlog is a "safe space" - user can add many ideas without implementation pressure

**4. Present Plan to User** ⚠️ MANDATORY CHECKPOINT
   - Summarize the approach
   - List files that will be created/modified
   - Estimate effort/scope
   - **ASK FOR EXPLICIT APPROVAL:** "Should I proceed with implementing this?"
   - ❌ DON'T: Move forward without approval

**5. Wait for User Approval**
   - User says "Yes/Go ahead/Proceed" → Continue to step 6
   - User says "No/Wait/Not now" → Stop, leave in backlog
   - User asks questions → Answer, adjust plan, ask again

**6. Check WIP Limits** (Before moving to doing/)
   - Check `thoughts/project/work/doing/.limit` file
   - Count files in `thoughts/project/work/doing/`
   - If at limit → **Stop, complete current work first**
   - If under limit → Proceed

**7. Move Through Workflow**
   - Move file: `planning/backlog/` → `work/todo/`
   - Update status in document to "Todo"
   - Move file: `work/todo/` → `work/doing/`
   - Update status in document to "Doing"

**7.5. Pre-Implementation Review** ⚠️ CHECKPOINT
   - AI reads the complete work item document thoroughly
   - AI identifies open questions, design decisions, and alternatives
   - AI summarizes the implementation approach and files to modify
   - **ASK FOR CONFIRMATION:** "Before I begin implementation, I've reviewed [WORK-ITEM-ID]. The approach is [summary]. [Open questions if any]. Do you agree with this approach?"
   - User confirms or provides additional guidance
   - ❌ DON'T: Start implementing without reviewing work item and confirming approach

**8. Implement**
   - Follow the plan (as confirmed in Step 7.5)
   - Write code, tests, documentation
   - Keep CHANGELOG notes in work item document

**8.5. Review & Approval** ⚠️ CHECKPOINT
   - AI presents completed work for user review
   - Summarize changes made (files created/modified)
   - Present testing results
   - **ASK FOR EXPLICIT APPROVAL:** "The work is complete and ready for review. Would you like to review the changes before I move to done/ and proceed with release?"
   - User reviews and approves/requests changes
   - ❌ DON'T: Move to done/ without approval

**9. Complete & Release** ⚠️ CRITICAL: Atomic Release Process
   - Work is done, tested, AND APPROVED
   - **Calculate next version:** Read PROJECT-STATUS.md current version + work item Version Impact, calculate next version (PATCH increments patch, MINOR increments minor/resets patch, MAJOR increments major/resets minor+patch), confirm with user before proceeding
   - **STOP - Before committing:** Prepare version updates atomically

   **Version Update Steps (do together):**
   - a. Use calculated version from above (confirmed by user)
   - b. Update PROJECT-STATUS.md (version, date, history)
   - c. Update CHANGELOG.md ([Unreleased] → [vX.Y.Z])
   - d. Move file: `work/doing/` → `work/done/`
   - e. Update work item status to "Done" and add completion date

   **Commit & Tag (atomic):**
   - Commit ALL changes together: `git commit -m "Release: vX.Y.Z - Description"`
   - Create annotated tag: `git tag -a vX.Y.Z -m "Release notes"`
   - Push with tags: `git push origin main --tags`

   **Archive (immediately after release):**
   - Create `thoughts/project/history/releases/vX.Y.Z/` folder
   - Move ALL work item files from `work/done/` to release folder
     - Primary: FEAT-XXX.md, BUGFIX-XXX.md
     - Supporting: FEAT-XXX-*.md, feature-XXX-*.md (migration matrices, test plans, results)
   - Commit: `git commit -m "Archive: vX.Y.Z work items"`
   - Result: done/ folder should be empty

   **Why atomic?** Version number must match implementation commit. Never commit implementation separate from version bump.

   **Why archive immediately?** Maintains WIP limits, preserves complete feature history together, clear done/ folder. See ADR-003.

### Example Interaction

```
User: "Add feature X"

Claude: "I understand you want feature X. Let me create a backlog item for this.

[Creates FEAT-NNN in planning/backlog/]

I propose implementing this by:
- Creating/modifying these files: [list]
- Approach: [summary]
- Estimated scope: [hours/complexity]

This would add [functionality description].

Should I proceed with implementing FEAT-NNN?"

User: "Yes, go ahead"

Claude: "Great! Moving FEAT-NNN through the workflow..."
[Checks WIP limits]
[Moves backlog → todo → doing]
[Implements]
```

### What NOT to Do

❌ Jump straight to implementation without creating backlog item
❌ Create items directly in `work/doing/` folder
❌ Set item status to "Doing" or "Todo" without user approval
❌ Implement before moving through the workflow folders
❌ Exceed WIP limits
❌ Skip the approval checkpoints (Step 4, Step 7.5, and Step 8.5)
❌ Start implementing without reviewing work item and confirming approach
❌ Move to done/ without user review and approval

### Rationale

This policy ensures:
- User maintains control over priorities and timing (Step 4 approval)
- AI confirms approach with fresh context before implementing (Step 7.5 review)
- User reviews all work before release (Step 8.5 approval)
- Framework workflow is respected (dogfooding our own process)
- WIP limits prevent context switching
- Clear audit trail of what was approved
- Backlog grows naturally without implementation pressure
- Open questions and design decisions are addressed before implementation
- No surprises - user sees and approves changes before they're released

**Reference:** [ADR-001: AI Workflow Checkpoint Policy](thoughts/project/research/adr/001-ai-workflow-checkpoint-policy.md)

**Full Workflow Details:** See [collaboration/workflow-guide.md](thoughts/project/collaboration/workflow-guide.md)

---

## Project Classification & Framework Selection

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
| System + Critical + Large Team | **Enterprise** (custom) |

### Framework Levels Overview

**Minimal Framework:**
- README.md with embedded "Why" section
- Optional git, optional CHANGELOG
- For: Single scripts, throwaway projects, personal automation

**Light Framework:**
- README.md, PROJECT-STATUS.md, CHANGELOG.md
- Simplified thoughts/project/history/ for decisions
- No kanban workflow, lightweight git
- For: Small tools, medium lifespan, solo with handoff

**Standard Framework:**
- Full documentation suite
- Complete thoughts/ structure with kanban workflow
- Formal planning and releases
- For: Applications, ongoing maintenance, small teams

**Full Framework:**
- Everything in Standard plus enhanced governance
- Formal ADRs, comprehensive retrospectives
- Enterprise-ready documentation
- For: Critical systems, large teams, complex architectures

**Setup Guide:** [NEW-PROJECT-CHECKLIST.md](project-framework-template/NEW-PROJECT-CHECKLIST.md)

**Full Architecture:** [collaboration/architecture-guide.md](thoughts/project/collaboration/architecture-guide.md)

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

**Full Details:** [collaboration/code-quality-standards.md](thoughts/project/collaboration/code-quality-standards.md)

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

**Full Details:** [collaboration/security-policy.md](thoughts/project/collaboration/security-policy.md)

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

**Full Details:** [collaboration/testing-strategy.md](thoughts/project/collaboration/testing-strategy.md)

---

### Documentation

**Core Files (Root):**
- README.md - Project overview
- PROJECT-STATUS.md - **SINGLE SOURCE OF TRUTH** for version & status
- CHANGELOG.md - Version history ([Keep a Changelog](https://keepachangelog.com/) format)
- INDEX.md - Navigation guide

**Session History:**
- Format: `YYYY-MM-DD-SESSION-HISTORY.md`
- Location: `thoughts/project/history/`
- Content: What was done, decisions made, blockers, next steps

**Work Items:**
- Use templates from `thoughts/framework/templates/`
- Location: `thoughts/project/work/` (todo/doing/done)

**Full Details:** [collaboration/workflow-guide.md](thoughts/project/collaboration/workflow-guide.md)

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

**Full Details:** [collaboration/workflow-guide.md](thoughts/project/collaboration/workflow-guide.md#git-workflow)

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
- MAJOR: `thoughts/framework/templates/ADR-MAJOR-TEMPLATE.md`
- MINOR: `thoughts/framework/templates/ADR-MINOR-TEMPLATE.md`

**Storage:** `thoughts/project/research/adr/NNN-decision-name.md`

**Examples:**
- MAJOR: Database choice, authentication architecture, state management
- MINOR: JSON library, log format, file naming convention

**Full Details:** [collaboration/workflow-guide.md](thoughts/project/collaboration/workflow-guide.md#architecture-decision-records-adrs) for complete guidance on when to create, upgrading MINOR to MAJOR, lifecycle, and examples.

---

## Workflow Phases Quick Reference

All projects follow this core workflow:

1. **Research/Explore** - Validate the problem and solution space
2. **Define** - Establish project boundaries and success criteria
3. **Plan** - Design the implementation approach
4. **Code** - Implement incrementally (respect WIP limits)
5. **Commit/Release** - Ship the value (atomic releases)

**Key Principles:**
- **For complex tasks, output a clear plan first**
- Research → Define → Plan → Code → Release
- **User Approval:** Pause for confirmation after major design decisions
- **Error Recovery:** Backtrack and rethink rather than persisting with broken approach

**Full Details:** [collaboration/workflow-guide.md](thoughts/project/collaboration/workflow-guide.md#development-workflow-phases)

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

**Full Details:** [collaboration/workflow-guide.md](thoughts/project/collaboration/workflow-guide.md#collaboration-practices)

---

## Emergency Reference

### Top 5 Common Issues

**1. WIP Limit Violation**
```bash
cat thoughts/project/work/doing/.limit
ls thoughts/project/work/doing/*.md | wc -l
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
cp thoughts/framework/templates/FEATURE-TEMPLATE.md thoughts/project/planning/backlog/feature-123.md
# Edit the copy, NOT the template
```

**5. Forgot to Archive After Release**
```bash
mkdir -p thoughts/project/history/releases/v2.1.0
mv thoughts/project/work/done/*.md thoughts/project/history/releases/v2.1.0/
```

**Full Troubleshooting:** [collaboration/troubleshooting-guide.md](thoughts/project/collaboration/troubleshooting-guide.md)

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

## Command Center

*(Reserved for future use - project-specific quick commands)*

---

## Related Documentation

**Quick Reference:**
- [CLAUDE-QUICK-REFERENCE.md](CLAUDE-QUICK-REFERENCE.md) - Critical rules and decision trees (<200 lines)

**Detailed Collaboration Guides:**
- [collaboration/README.md](thoughts/project/collaboration/README.md) - Navigation index
- [collaboration/workflow-guide.md](thoughts/project/collaboration/workflow-guide.md) - Complete workflow process
- [collaboration/code-quality-standards.md](thoughts/project/collaboration/code-quality-standards.md) - Coding standards
- [collaboration/testing-strategy.md](thoughts/project/collaboration/testing-strategy.md) - Testing approach
- [collaboration/security-policy.md](thoughts/project/collaboration/security-policy.md) - Security requirements
- [collaboration/architecture-guide.md](thoughts/project/collaboration/architecture-guide.md) - Framework design
- [collaboration/troubleshooting-guide.md](thoughts/project/collaboration/troubleshooting-guide.md) - Common issues

**Templates:**
- [thoughts/framework/templates/](thoughts/framework/templates/) - Copy-paste starting points

**Project Info:**
- [PROJECT-STATUS.md](PROJECT-STATUS.md) - Current version and status (SINGLE SOURCE OF TRUTH)
- [CHANGELOG.md](CHANGELOG.md) - Version history
- [README.md](README.md) - Project overview
- [INDEX.md](INDEX.md) - Documentation index

---

**Last Updated:** 2025-12-22
**Framework Version:** Standard (v2.1.0)

# General Project Instructions

## Overview
This doc provides general instructions for any project


## Architecture 
### Project Folders
```
ProjectRoot/
├── <project_specific>/         # Project specific folders. Create at root as needed.
├── CHANGELOG.md                # Version history and changes (Keep a Changelog format)
├── INDEX.md                    # Project specific index of documents
├── README.md                   # Project specific overview and documentation
└── thoughts/                   # Project documentation and framework
    ├── project/                # Project specific content
    │   ├── work/               # Kanban workflow for active work
    │   │   ├── todo/           # Planned work items
    │   │   ├── doing/          # Currently in progress (max 2)
    │   │   │   └── .limit      # WIP limit for doing/ (default: 2)
    │   │   └── done/           # Completed work items
    │   ├── reference/          # Current project reference docs
    │   ├── archive/            # Historical/outdated docs
    │   ├── research/           # Project research
    │   ├── retrospectives/     # Project retrospectives
    │   └── history/            # Daily session history (YYYY-MM-DD-SESSION-HISTORY.md)
    └── framework/              # Reusable across projects
        ├── process/            # Workflow documentation
        ├── templates/          # Planning templates
        ├── patterns/           # Implementation patterns
        └── tools/              # Framework tooling
```

## Command Center


## Code Style Guidelines
- **Coding Standards:** See project-specific `thoughts/project/reference/coding-standards.md` (if it doesn't exist, create one based on project needs)


## Testing Instructions
- Always follow TDD mindset: for any bug fix or new feature, consider writing tests first or immediately after coding.
- Aim for high coverage on core logic (services, reducers, etc.). Include edge cases (invalid inputs, error states) in tests.
- Keep tests clear and focused.


## Error Handling
- Diagnose, Don’t Guess: When encountering a bug or failing test, first explain possible causes step-by-step : docs.claude.com. Check assumptions, inputs, and relevant code paths.
- Graceful Handling: Code should handle errors gracefully. For example, use try/catch around async calls, and return user-friendly error messages or fallback values when appropriate.
- Logging: Include helpful console logs or error logs for critical failures (but avoid log spam in production code).
- No Silent Failures: Do not swallow exceptions silently. Always surface errors either by throwing or logging them.


## Clean Code Guidelines
- Function Size: Aim for functions ≤ 50 lines. If a function is doing too much, break it into smaller helper functions.
- Single Responsibility: Each function/module should have one clear purpose. Don’t lump unrelated logic together.
- Naming: Use descriptive names. Avoid generic names like `tmp`, `data`, `handleStuff`. For example, prefer `calculateInvoiceTotal` over `doCalc`.
- DRY Principle: Do not duplicate code. If similar logic exists in two places, refactor into a shared function (or clarify why both need their own implementation).
- Comments: Explain non-obvious logic, but don’t over-comment self-explanatory code. Remove any leftover debug or commented-out code.


## Security Guidelines
- Input Validation: Validate all inputs (especially from users or external APIs). Never trust user input – e.g., check for valid email format, string length limits, etc.
- Authentication: Never store passwords in plain text. Use bcrypt with a salt for hashing passwords. Implement account lockout or rate limiting on repeated failed logins.
- Database Safety: Use parameterized queries or an ORM to prevent SQL injection. Do not concatenate user input in SQL queries directly.
- XSS & CSRF: Sanitize any HTML or user-generated content before rendering (consider using a library like DOMPurify). Use CSRF tokens for state-changing form submissions.
- Dependencies: Be cautious of eval or executing dynamic code. Avoid introducing packages with known vulnerabilities (Claude should prefer built-in solutions if external libs are risky).


## Documentation Standards

### Core Documentation Files
Every project should have these files in the root:
- **README.md** - Project overview, getting started guide, usage examples
- **CHANGELOG.md** - Version history following [Keep a Changelog](https://keepachangelog.com/) format
- **PROJECT-STATUS.md** - THE SINGLE SOURCE OF TRUTH for current version and implementation status
- **INDEX.md** - Navigation guide to all documentation (optional but recommended)

### Status Tracking Convention

**Single Source of Truth:** PROJECT-STATUS.md
- **THE ONLY PLACE** for current version number and implementation status
- All other documents should reference it, not duplicate the information
- Example reference format:
  ```markdown
  **Current Version & Status:** See [PROJECT-STATUS.md](PROJECT-STATUS.md)
  ```

**Why This Matters:**
- Eliminates version number drift across documents
- Single update point during releases
- Always current, no stale status information
- Reduces maintenance burden

**In README.md, CLAUDE.md, and other docs:**
```markdown
# Project Name

**Current Version & Status:** See [PROJECT-STATUS.md](PROJECT-STATUS.md)
**Last Updated:** YYYY-MM-DD
**Project Lead:** Name
```

**In PROJECT-STATUS.md:**
```markdown
# Project Name - Project Status

**Last Updated:** YYYY-MM-DD
**Updated By:** Name
**Current Version:** vX.Y.Z (YYYY-MM-DD)
**Core Implementation:** [Status description]
**Ongoing Enhancements:** [Status description]
```

### Document "Last Updated" Field
- Update "Last Updated" date when content materially changes
- Leave unchanged for typo fixes or minor formatting
- Include version number if document is versioned
- Example: "Last Updated: 2025-12-18"

### Session History
- **Format:** One document per day
- **Naming:** `YYYY-MM-DD-SESSION-HISTORY.md`
- **Location:** `thoughts/project/history/`
- **Purpose:** Capture daily activity, decisions, and context for future reference
- **Content:** What was done, decisions made, blockers encountered, next steps

### Work Item Documentation
Use templates in `thoughts/framework/templates/`:

**FEATURE-TEMPLATE.md** - For new features
- Feature description and rationale
- User stories or use cases
- Technical approach and dependencies
- Implementation steps
- Testing plan
- Documentation requirements

**BUGFIX-TEMPLATE.md** - For bug fixes
- Bug description (actual vs expected behavior)
- Reproduction steps
- Root cause analysis
- Fix design and testing
- Prevention strategies

**BLOCKER-TEMPLATE.md** - For blockers
- Problem statement and severity
- Root cause and impact
- Resolution plan with timeline
- Alternatives and workarounds
- Status updates

**Location:** `thoughts/project/work/` (todo/doing/done folders)

### Code Documentation Requirements

**Must have:**
- Function/method documentation (language-specific format)
- Parameter descriptions
- Usage examples
- Update README when behavior changes

**Should have:**
- Architecture rationale documented
- Decision documentation for alternatives considered
- Test cases for new functionality

### Project Retrospectives

After major milestones (v1.0, project completion, major features), create retrospectives:

**Location:** `thoughts/project/retrospectives/YYYY-MM-DD-retrospective.md`

**Standard Structure:**
- **What Went Well** - Successes and effective practices
- **What Didn't Go Well** - Challenges and mistakes
- **Process Improvements** - Actionable changes for future work
- **Key Learnings** - Technical and process insights

**Purpose:** Continuous improvement and knowledge capture for future projects

**Categories for Key Learnings:**
- Technical (architecture, tools, patterns)
- Process (workflow, communication, planning)

### Emergency Troubleshooting (Project-Specific)

Each project should include an "Emergency Reference" section in their project-specific CLAUDE.md:

**Structure:**
```markdown
## Emergency Reference

### System Not Working? Check These First
1. [Most common failure mode and how to identify it]
2. [Configuration issues and where to check]
3. [Dependency problems and verification steps]
4. [Log locations and what to look for]
5. [Common user errors and solutions]

### Quick Diagnostics
```[language]
# Commands to check system state
# Commands to verify configuration
# Commands to view logs
# Commands to test key functionality
```
```

**Purpose:** Quick reference for troubleshooting when system isn't working as expected

## Working with Claude (AI Assistant)

### Effective Collaboration

**Mode Clarity:**
- Distinguish between planning mode and implementation mode
- When exploring: "I'm researching options"
- When ready to code: "Let's implement approach X"
- Ask clarification: "Are we planning or building?"

**Standards Adherence:**
- Claude should explicitly reference standards documents before coding
- Example: "Let me check coding-standards.md first"
- Review project-specific conventions before writing code

**Context Management:**
- Propose bounded tasks that fit in conversation context
- Break large features into smaller, discrete steps
- Save progress frequently in planning documents
- Use work item documentation to track complex tasks

**Proactive Clarification:**
- Ask essential questions upfront
- "What's the one thing this must accomplish?"
- "Are there constraints I should know about?"
- "Should this follow an existing pattern?"

### Communication Best Practices

**What Works Well:**
- Push back with clear reasoning when approach seems suboptimal
- Provide multiple options with trade-offs
- Create visual diagrams for complex workflows
- Accept and incorporate critical feedback
- Comprehensive documentation that captures context

**Task Breakdown:**
- Ask for breakdown when scope seems large
- Clarify planning vs implementation mode
- Reference relevant documentation during discussion
- Propose checkpoints for review and feedback

**When Things Go Wrong:**
- Backtrack and rethink rather than persisting with broken approach
- Explain why current approach isn't working
- Propose alternative solutions
- Ask for clarification if requirements are ambiguous

## Collaboration & Workflow
- Git Branches: Create feature branches for all work (e.g., `feature/login-form`, `bugfix/issue-123`). Branch from and merge back to your main development branch via Pull Request. Avoid committing directly to your main branch.
- Commit Messages: Use conventional commits (e.g., `feat: `, `fix: `, `docs: ` prefixes). Include JIRA ticket ID or planning task ID in commit if available. Keep message concise (one line summary, optional details after).
- Pull Requests: When a task is done, have Claude open a PR with a brief description of changes and tag the relevant reviewers (e.g., `@frontend-team` for UI changes).
- Documentation: If code changes affect user-facing behavior or APIs, update the relevant Markdown docs in the `thoughts/` folder as part of the same PR.
- Code Reviews: Claude should assist in code reviews if asked (e.g., static analysis for bugs, ensure style guide adherence) and only approve when all checks pass.
- Record all completed features and bugfixes to the `./CHANGELOG.md`.
- Update `./PROJECT-STATUS.md` when version changes or major milestones are reached.
- Save a summary of all activity in a `thoughts/project/history/YYYY-MM-DD-SESSION-HISTORY.md` file.


## Edge Case Considerations
- Always consider edge and corner cases for any logic:
- Empty or null inputs (e.g., an empty list, missing fields, zero values).
- Max/min values and overflow (e.g., extremely large numbers, very long text).
- Invalid states (e.g., end date before start date, negative quantities).
- Concurrency issues (e.g., two users editing the same data simultaneously).
- If an edge case is identified, handle it in code or at least flag it with a comment/TODO.
- Prefer to fail fast on bad input (throw an error or return a safe default) rather than proceeding with wrong assumptions.


## Project Classification & Framework Selection

Before starting any project, determine the appropriate framework level based on these three dimensions:

### Dimension 1: Scope & Complexity
- **Script** - Single file, linear execution, < 500 lines
- **Tool** - 2-10 files, simple architecture, focused purpose
- **Application** - 10-50 files, modular architecture, multiple features
- **System** - 50+ files, distributed components, complex integrations

### Dimension 2: Lifespan & Evolution
- **Throwaway** - One-time use, no maintenance expected
- **Short-term** - Weeks to months, minimal evolution
- **Maintained** - Ongoing updates, multi-year lifespan
- **Critical** - Production dependency, requires formal governance

### Dimension 3: Team & Collaboration
- **Solo/Personal** - Just you, no handoff planned
- **Solo/Professional** - You now, but future-you or handoff likely
- **Small Team** - 2-5 developers, informal coordination
- **Large Team** - 6+ developers, requires formal process

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
- Appropriate for: Single scripts, throwaway projects, personal automation

**Light Framework:**
- README.md, PROJECT-STATUS.md, CHANGELOG.md
- Simplified thoughts/project/history/ for decisions
- No kanban workflow, lightweight git
- Appropriate for: Small tools, medium lifespan, solo with handoff

**Standard Framework:**
- Full documentation suite
- Complete thoughts/ structure with kanban workflow
- Formal planning and releases
- Appropriate for: Applications, ongoing maintenance, small teams

**Full Framework:**
- Everything in Standard plus enhanced governance
- Formal ADRs, comprehensive retrospectives
- Enterprise-ready documentation
- Appropriate for: Critical systems, large teams, complex architectures

See [NEW-PROJECT-CHECKLIST.md](project-framework-template/NEW-PROJECT-CHECKLIST.md) for detailed setup instructions for each level.

## Workflow & Planning Guidelines

### Development Workflow Phases

All projects follow this core workflow, with depth varying by framework level:

1. **Research/Explore** - Validate the problem and solution space
   - Define the problem clearly
   - Research existing solutions
   - Assess feasibility
   - Make go/no-go decision
   - Document in `thoughts/project/research/` (Standard/Full) or README (Minimal/Light)

2. **Define** - Establish project boundaries and success criteria
   - Write project definition (what, why, who, unique value)
   - Set measurable success criteria
   - Define scope boundaries (what we're NOT building)
   - Document in `thoughts/project/reference/project-definition.md` (Standard/Full) or README (Minimal/Light)

3. **Plan** - Design the implementation approach
   - Create roadmap with version targets
   - Break down into features/work items
   - Identify dependencies and risks
   - Estimate effort
   - Document in `thoughts/project/planning/` (Standard/Full) or simple task list (Minimal/Light)

4. **Code** - Implement incrementally
   - One work item at a time (respect WIP limits)
   - Follow coding standards
   - Write tests
   - Document as you go

5. **Commit/Release** - Ship the value
   - Follow version control workflow
   - Update CHANGELOG and PROJECT-STATUS
   - Tag releases
   - Move to work/done/ (Standard/Full) or mark complete (Minimal/Light)

### Key Principles

- **For complex or multi-step tasks, output a clear plan first**
- **Research -> Define -> Plan -> Code -> Commit/Release**
- **Incremental Development:** Implement in logical chunks, verify alignment after each
- **Think Aloud:** Use extended reasoning for complex decisions
- **User Approval:** Pause for confirmation after major design decisions
- **Error Recovery:** Backtrack and rethink rather than persisting with broken approach

### Research Phase Guidelines

**When to do explicit research:**
- New project (always - even for scripts!)
- Considering new technology/library/pattern
- User reports problem you don't understand
- Performance/scale issues
- Security concerns

**Research depth by framework level:**

**Minimal:** Embedded in README.md
```markdown
## Why This Script Exists

**Problem:** [What problem does this solve?]
**Alternatives Considered:** [Why not use existing tool X, Y, Z?]
**Decision:** [Why this approach?]
```

**Light:** Simple justification document
- `thoughts/project/research/justification.md`
- Problem statement (1 paragraph)
- Existing solutions checked (bulleted list)
- Why custom solution (2-3 sentences)

**Standard/Full:** Complete research documentation
- `thoughts/project/research/problem-statement.md` - Clear problem definition
- `thoughts/project/research/landscape-analysis.md` - Existing solutions review
- `thoughts/project/research/feasibility.md` - Can/should we build this?
- `thoughts/project/research/project-justification.md` - Go/no-go decision
- `thoughts/project/reference/project-definition.md` - What we're building

**Research exit criteria:**
- Problem clearly defined
- Existing solutions reviewed
- Unique value identified OR decision to use existing solution
- Feasibility confirmed
- Explicit go/no-go decision documented

**Key Question:** "Are we recreating the wheel, or do we have something useful to add?"

### Planning Guidelines

- Issues are tracked in a folder-based kanban workflow in `thoughts/project/work` (Standard/Full)
- Research and reference docs are in `thoughts/project/reference`
- Always ask: "What's the one thing this must accomplish?" before elaborate planning

### AI Workflow Checkpoint Policy (Standard Framework)

**CRITICAL:** When user requests a new feature, you MUST follow this workflow to maintain process integrity.

**The Standard Workflow:**
```
User Request → Backlog → [CHECKPOINT: User Approval] → Todo → Doing → Done → Release
```

**Step-by-Step Process:**

1. **User Requests Feature** (e.g., "Add a quick reference guide")
   - ✅ DO: Listen and understand the requirement
   - ❌ DON'T: Start implementing immediately

2. **Brief Research** (30 seconds)
   - Does this already exist in the project?
   - Is there a better existing solution?
   - Quick viability check

3. **Create Backlog Item**
   - Use appropriate template (FEATURE-TEMPLATE.md, BUGFIX-TEMPLATE.md, etc.)
   - Place in `thoughts/project/planning/backlog/`
   - Set status to "Backlog" in the document
   - ✅ Backlog is a "safe space" - user can add many ideas without implementation pressure

4. **Present Plan to User** ⚠️ MANDATORY CHECKPOINT
   - Summarize the approach
   - List files that will be created/modified
   - Estimate effort/scope
   - **ASK FOR EXPLICIT APPROVAL:** "Should I proceed with implementing this?"
   - ❌ DON'T: Move forward without approval

5. **Wait for User Approval**
   - User says "Yes/Go ahead/Proceed" → Continue to step 6
   - User says "No/Wait/Not now" → Stop, leave in backlog
   - User asks questions → Answer, adjust plan, ask again

6. **Check WIP Limits** (Before moving to doing/)
   - Check `thoughts/project/work/doing/.limit` file
   - Count files in `thoughts/project/work/doing/`
   - If at limit → **Stop, complete current work first**
   - If under limit → Proceed

7. **Move Through Workflow**
   - Move file: `planning/backlog/` → `work/todo/`
   - Update status in document to "Todo"
   - Move file: `work/todo/` → `work/doing/`
   - Update status in document to "Doing"

8. **Implement**
   - Follow the plan
   - Write code, tests, documentation
   - Keep CHANGELOG notes in work item document

9. **Complete & Release** ⚠️ CRITICAL: Atomic Release Process
   - Work is done and tested
   - **STOP - Before committing:** Prepare version updates atomically

   **Version Update Steps (do together):**
   a. Check version impact from work item metadata (MAJOR/MINOR/PATCH)
   b. Calculate new version number from current version
   c. Update PROJECT-STATUS.md:
      - "Current Version" in header
      - "Last Updated" date
      - Add to release history table
   d. Update CHANGELOG.md:
      - Move [Unreleased] content to [vX.Y.Z] - YYYY-MM-DD
      - Copy CHANGELOG notes from work item document
      - Create fresh [Unreleased] section
   e. Move file: `work/doing/` → `work/done/`
   f. Update work item status to "Done" and add completion date

   **Commit & Tag (atomic):**
   - Commit ALL changes together: `git commit -m "Release: vX.Y.Z - Description"`
   - Create annotated tag: `git tag -a vX.Y.Z -m "Release notes"`
   - Push with tags: `git push origin main --tags`

   **Why atomic?** Version number must match implementation commit. Never commit implementation separate from version bump.

   **Reference:** [version-control-workflow.md](project-framework-template/standard/thoughts/framework/process/version-control-workflow.md) lines 101-149 for complete checklist

**Example Interaction:**

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

**What NOT to Do:**

❌ Jump straight to implementation without creating backlog item
❌ Create items directly in `work/doing/` folder
❌ Set item status to "Doing" or "Todo" without user approval
❌ Implement before moving through the workflow folders
❌ Exceed WIP limits
❌ Skip the approval checkpoint

**Rationale:**

This policy ensures:
- User maintains control over priorities and timing
- Framework workflow is respected (dogfooding our own process)
- WIP limits prevent context switching
- Clear audit trail of what was approved
- Backlog grows naturally without implementation pressure

**Reference:** See [ADR-001: AI Workflow Checkpoint Policy](thoughts/project/research/adr/001-ai-workflow-checkpoint-policy.md)


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

**Full Details:** See [workflow-guide.md](thoughts/project/collaboration/workflow-guide.md#architecture-decision-records-adrs) for complete guidance on when to create, upgrading MINOR to MAJOR, lifecycle, and examples.


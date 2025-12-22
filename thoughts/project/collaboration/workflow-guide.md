# Project Workflow Guide

**Version:** 1.0.0
**Last Updated:** 2025-12-22
**Audience:** All contributors (human and AI)

---

## Purpose

This guide provides detailed workflow processes for working on this project. It covers git workflows, planning processes, documentation standards, and collaboration practices.

For quick reference, see [CLAUDE.md](../../../CLAUDE.md) for summaries and checklists.

---

## Table of Contents

1. [Development Workflow Phases](#development-workflow-phases)
2. [Research Phase](#research-phase)
3. [Planning Guidelines](#planning-guidelines)
4. [Documentation Standards](#documentation-standards)
5. [Git Workflow](#git-workflow)
6. [Architecture Decision Records (ADRs)](#architecture-decision-records-adrs)
7. [Collaboration Practices](#collaboration-practices)

---

## Development Workflow Phases

All projects follow this core workflow, with depth varying by framework level:

### 1. Research/Explore

**Purpose:** Validate the problem and solution space before investing effort.

**Activities:**
- Define the problem clearly
  - What problem are we solving?
  - Who experiences this problem?
  - How painful is it?
- Research existing solutions
  - What tools/libraries already exist?
  - What do competitors use?
  - What have we tried before?
- Assess feasibility
  - Can we build this with available resources?
  - Do we have the required skills/time?
  - What are the risks?
- Make go/no-go decision
  - Should we build this?
  - Should we use an existing solution?
  - Should we defer or cancel?

**Documentation:**
- **Standard/Full frameworks:** `thoughts/project/research/`
  - `problem-statement.md` - Clear problem definition
  - `landscape-analysis.md` - Existing solutions review
  - `feasibility.md` - Can/should we build this?
  - `project-justification.md` - Go/no-go decision
- **Light framework:** `thoughts/project/research/justification.md` (simplified)
- **Minimal framework:** Embedded in README.md "Why This Exists" section

**Exit Criteria:**
- Problem clearly defined
- Existing solutions reviewed
- Unique value identified OR decision to use existing solution
- Feasibility confirmed
- Explicit go/no-go decision documented

**Key Question:** "Are we recreating the wheel, or do we have something useful to add?"

### 2. Define

**Purpose:** Establish project boundaries and success criteria.

**Activities:**
- Write project definition
  - What are we building?
  - Why are we building it?
  - Who is it for?
  - What makes it unique/valuable?
- Set measurable success criteria
  - What does "done" look like?
  - What are the key metrics?
  - How will we measure success?
- Define scope boundaries
  - What IS in scope?
  - What is NOT in scope? (critical!)
  - What might we do later?

**Documentation:**
- **Standard/Full:** `thoughts/project/reference/project-definition.md`
- **Light:** Brief section in README.md
- **Minimal:** Embedded in README.md

**Exit Criteria:**
- Clear definition of what we're building
- Measurable success criteria
- Explicit scope boundaries (in AND out)
- Stakeholder agreement on definition

### 3. Plan

**Purpose:** Design the implementation approach.

**Activities:**
- Create roadmap with version targets
  - What goes in v1.0?
  - What's for v1.1, v1.2, v2.0?
  - What are the milestones?
- Break down into features/work items
  - Use FEATURE-TEMPLATE.md for features
  - Use BUGFIX-TEMPLATE.md for bugs
  - Use BLOCKER-TEMPLATE.md for blockers
  - Use SPIKE-TEMPLATE.md for investigations
- Identify dependencies and risks
  - What depends on what?
  - What could go wrong?
  - What are our unknowns?
- Estimate effort
  - Rough sizing (small/medium/large)
  - Time estimates if needed
  - Resource requirements

**Documentation:**
- **Standard/Full:** `thoughts/project/planning/`
  - `roadmap.md` - Version plan
  - `backlog/` - Features not yet started
  - `work/todo/` - Committed next work
  - `work/doing/` - Currently in progress (WIP limited)
  - `work/done/` - Completed work
- **Light:** Simple task list in README or STATUS
- **Minimal:** Informal notes or none

**Planning Principle:** "What's the one thing this must accomplish?"

Ask this before elaborate planning. Keep planning proportional to project size.

### 4. Code

**Purpose:** Implement incrementally with quality.

**Activities:**
- One work item at a time (respect WIP limits)
  - Check `thoughts/project/work/doing/.limit`
  - Default WIP limit: 1-2 items
  - Complete before starting new work
- Follow coding standards
  - See [code-quality-standards.md](code-quality-standards.md)
  - Language-specific conventions
  - Project-specific patterns
- Write tests
  - See [testing-strategy.md](testing-strategy.md)
  - TDD when practical
  - Cover edge cases
- Document as you go
  - Update README for behavior changes
  - Add code comments for non-obvious logic
  - Keep CHANGELOG notes in work item

**Code Review:**
- Self-review before committing
- Peer review via Pull Request (teams)
- Address feedback promptly
- Check coding standards compliance

### 5. Commit/Release

**Purpose:** Ship the value with proper versioning.

**Activities:**
- Follow version control workflow
  - See [version-control-workflow.md](../../framework/process/version-control-workflow.md)
  - Semantic versioning (MAJOR.MINOR.PATCH)
  - Atomic releases (version + implementation together)
- Update CHANGELOG and PROJECT-STATUS
  - Move [Unreleased] to [vX.Y.Z]
  - Update version in PROJECT-STATUS.md
  - Update "Last Updated" date
- Tag releases
  - `git tag -a vX.Y.Z -m "Release notes"`
  - Push tags: `git push --tags`
- Move to work/done/
  - **Standard/Full:** File moves from doing/ → done/
  - **Light/Minimal:** Mark as complete

**For detailed release process, see CLAUDE.md Step 9 or version-control-workflow.md lines 101-149.**

---

## Research Phase

### When to Do Explicit Research

Always research before implementing:
- **New project** (always - even for scripts!)
- **New technology/library/pattern** being considered
- **User reports problem** you don't understand
- **Performance/scale issues** arise
- **Security concerns** identified

Don't skip research. It prevents wasted effort.

### Research Depth by Framework Level

#### Minimal Framework

Embedded in README.md:

```markdown
## Why This Script Exists

**Problem:** [What problem does this solve?]

**Alternatives Considered:** [Why not use existing tool X, Y, Z?]

**Decision:** [Why this approach?]
```

**Example:**
```markdown
## Why This Script Exists

**Problem:** Manually copying 50+ files for each new project is error-prone and takes 30 minutes.

**Alternatives Considered:**
- Cookiecutter: Too complex for our simple needs
- Manual copy: Current problem we're solving
- Git template repo: Requires git knowledge users don't have

**Decision:** Simple bash script that prompts for project name and copies templates.
Takes 30 seconds, no dependencies, works for our team.
```

#### Light Framework

Simple justification document at `thoughts/project/research/justification.md`:

**Structure:**
- Problem statement (1 paragraph)
- Existing solutions checked (bulleted list)
- Why custom solution (2-3 sentences)
- Decision (go/no-go)

**Example:**
```markdown
# Project Justification

## Problem
Current code review process takes 2-3 days because reviewers don't know which
files changed or why. This delays releases and frustrates developers.

## Existing Solutions Checked
- GitHub PR interface: Too cluttered, hard to see "why"
- ReviewBoard: Requires server setup, overkill for 3-person team
- Gerrit: Same - too complex for our needs

## Why Custom Solution
Simple Python script that:
1. Reads git diff
2. Extracts file list + commit messages
3. Generates markdown summary with context

Takes ~2 hours to build, solves our specific workflow, no infrastructure.

## Decision
**GO** - Build custom script. Low effort, high value for our workflow.
```

#### Standard/Full Framework

Complete research documentation in `thoughts/project/research/`:

**Required Documents:**

1. **problem-statement.md** - Clear problem definition
   - What is the problem?
   - Who experiences it?
   - How painful is it? (quantify if possible)
   - What happens if we don't solve it?

2. **landscape-analysis.md** - Existing solutions review
   - What tools/libraries exist?
   - What are their pros/cons?
   - Cost comparison (if applicable)
   - Why aren't they suitable?

3. **feasibility.md** - Can/should we build this?
   - Technical feasibility
   - Resource requirements (time, people, skills)
   - Risk assessment
   - Dependencies and constraints

4. **project-justification.md** - Go/no-go decision
   - Build vs buy vs defer
   - Expected ROI
   - Timeline implications
   - Final recommendation

5. **project-definition.md** (in reference/) - What we're building
   - Created after go decision
   - Detailed scope
   - Success criteria
   - Architecture approach

### Research Exit Criteria

Before leaving research phase:
- [ ] Problem clearly defined and documented
- [ ] At least 3 existing solutions reviewed
- [ ] Unique value articulated (or decision to use existing solution)
- [ ] Feasibility confirmed (technical, resource, timeline)
- [ ] Explicit go/no-go decision documented
- [ ] If "go", project definition created

**Anti-pattern:** Jumping to planning/coding without research because "we already know what to build." Research validates assumptions and often reveals better approaches.

---

## Planning Guidelines

### Kanban Workflow (Standard/Full Frameworks)

Work items flow through folders:

```
thoughts/project/
├── planning/backlog/     # Ideas and future work
├── work/todo/            # Committed next (prioritized)
├── work/doing/           # Currently in progress (WIP limited)
└── work/done/            # Completed (awaiting release)
```

**Workflow:**
```
User Idea → Backlog → [User Approval] → Todo → Doing → Done → Release → Archive
```

**WIP Limits:**
- Check `thoughts/project/work/doing/.limit` file
- Default: 1-2 items maximum in doing/
- Never exceed WIP limit
- Complete current work before starting new

**For AI assistants:** See CLAUDE.md "AI Workflow Checkpoint Policy" for mandatory approval checkpoints.

### Work Item Templates

Located in `thoughts/framework/templates/`:

#### FEATURE-TEMPLATE.md
Use for new capabilities or enhancements.

**Sections:**
- Summary (1-2 sentences)
- Problem Statement
- Requirements (functional and non-functional)
- Design (proposed approach)
- Dependencies
- Testing Plan
- Security Considerations
- Documentation Updates
- Implementation Checklist
- CHANGELOG Notes

**When to use:** Adding new functionality or significant enhancement.

#### BUGFIX-TEMPLATE.md
Use for correcting defects.

**Sections:**
- Summary
- Bug Description (actual vs expected)
- Reproduction Steps
- Root Cause Analysis
- Fix Design
- Testing Plan
- Prevention Strategy
- CHANGELOG Notes

**When to use:** Fixing incorrect behavior.

#### BLOCKER-TEMPLATE.md
Use for critical issues preventing progress.

**Sections:**
- Summary
- Problem Statement
- Severity/Impact
- Root Cause
- Resolution Plan
- Timeline
- Alternatives/Workarounds
- Status Updates

**When to use:** Critical issue blocking current work or users.

#### SPIKE-TEMPLATE.md
Use for research/investigation.

**Sections:**
- Summary
- Research Question
- Success Criteria
- Approach
- Time Box
- Findings
- Decision/Next Steps

**When to use:** Need to investigate unknowns before planning solution.

### Always Ask First

Before elaborate planning:
**"What's the one thing this must accomplish?"**

Keep planning proportional to:
- Project size (Minimal needs less than Full)
- Uncertainty (more unknowns = more planning)
- Risk (higher risk = more planning)
- Team size (larger team = more coordination)

Don't over-plan simple tasks. Don't under-plan complex systems.

---

## Documentation Standards

### Core Documentation Files

Every project should have these files in the root:

- **README.md** - Project overview, getting started, usage
- **CHANGELOG.md** - Version history ([Keep a Changelog](https://keepachangelog.com/) format)
- **PROJECT-STATUS.md** - Single source of truth for version and status
- **INDEX.md** - Documentation navigation (optional but recommended)

### Single Source of Truth: PROJECT-STATUS.md

**Critical Principle:** Current version and implementation status live in ONE place only.

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

**Never duplicate version numbers or status across files.** Always reference PROJECT-STATUS.md.

### Document "Last Updated" Field

- **Update** "Last Updated" date when content materially changes
- **Leave unchanged** for typo fixes or minor formatting
- **Include version** if document is versioned
- **Format:** "Last Updated: YYYY-MM-DD"

### Session History

**Format:** One document per day

**Naming:** `YYYY-MM-DD-SESSION-HISTORY.md`

**Location:** `thoughts/project/history/`

**Purpose:** Capture daily activity, decisions, and context for future reference

**Content:**
- What was done
- Decisions made
- Blockers encountered
- Next steps
- Lessons learned

**Example:**
```markdown
# Session History: 2025-12-22

**Date:** 2025-12-22
**Participants:** Gary Elliott, Claude Code
**Session Focus:** CLAUDE.md Optimization
**Duration:** ~3 hours

## Summary
[Brief overview of session]

## Work Completed
[What was accomplished]

## Decisions Made
[Key decisions with rationale]

## Blockers Encountered
[Issues and how resolved]

## Next Steps
[What's next]
```

### Code Documentation Requirements

**Must have:**
- Function/method documentation (language-specific format)
- Parameter descriptions (types, constraints, defaults)
- Return value documentation
- Usage examples for public APIs
- Update README when behavior changes

**Should have:**
- Architecture rationale documented (why not just what)
- Decision documentation for alternatives considered
- Test cases for new functionality
- Performance characteristics (if relevant)

**Example (JavaScript):**
```javascript
/**
 * Calculate invoice total including tax and discounts.
 *
 * @param {number} subtotal - Pre-tax subtotal in dollars
 * @param {number} taxRate - Tax rate as decimal (0.08 = 8%)
 * @param {number} discountPercent - Discount as percentage (10 = 10% off)
 * @returns {number} Final total in dollars, rounded to 2 decimals
 *
 * @example
 * calculateTotal(100, 0.08, 10) // Returns 97.20
 * // (100 - 10%) * (1 + 8%) = 90 * 1.08 = 97.20
 */
function calculateTotal(subtotal, taxRate, discountPercent) {
  const afterDiscount = subtotal * (1 - discountPercent / 100);
  return Math.round(afterDiscount * (1 + taxRate) * 100) / 100;
}
```

### Project Retrospectives

**When to create:**
- Major milestones (v1.0, v2.0)
- Project completion
- Major features complete
- After significant issues/failures

**Location:** `thoughts/project/retrospectives/YYYY-MM-DD-retrospective.md`

**Standard Structure:**

1. **What Went Well** - Successes and effective practices
2. **What Didn't Go Well** - Challenges and mistakes
3. **Process Improvements** - Actionable changes for future work
4. **Key Learnings** - Technical and process insights

**Categories for Key Learnings:**
- Technical (architecture, tools, patterns)
- Process (workflow, communication, planning)
- Team (collaboration, roles, communication)
- External (dependencies, vendors, customers)

**Purpose:** Continuous improvement and knowledge capture for future projects

**Example:**
```markdown
# Retrospective: v1.0 Release

**Date:** 2025-12-22
**Milestone:** v1.0 Release
**Participants:** Full team

## What Went Well
- TDD approach caught 12 bugs before production
- Daily standups kept everyone aligned
- Documentation-first approach reduced questions

## What Didn't Go Well
- Underestimated testing time by 50%
- Code review bottleneck (single reviewer)
- Late discovery of integration issue

## Process Improvements
- Add test time multiplier of 1.5x to estimates
- Implement round-robin code review assignments
- Add integration testing to sprint checklist

## Key Learnings

### Technical
- FastAPI framework was excellent choice (easy to learn, fast)
- PostgreSQL full-text search adequate for our scale
- Docker Compose simplified local development

### Process
- Feature flags enabled safer releases
- Automated deployment saved 2 hours per release
- Weekly demos to stakeholders prevented scope drift
```

---

## Git Workflow

### Branch Strategy

**Branch Types:**

| Branch | Purpose | Naming | Lifespan |
|--------|---------|--------|----------|
| `main` | Released versions only | `main` | Permanent |
| Feature | New capabilities | `feature/NNN-brief-name` | Until merged |
| Bugfix | Non-critical fixes | `bugfix/NNN-brief-name` | Until merged |
| Hotfix | Critical emergency fixes | `hotfix/NNN-brief-name` | Short (hours/days) |

**Use work item ID in branch name when available.**

### Starting New Work

```bash
# For features (use feature ID in branch name if available)
git checkout main
git pull
git checkout -b feature/020-claude-optimization

# For bugfixes (use bugfix ID)
git checkout main
git pull
git checkout -b bugfix/101-memory-leak

# For hotfixes (critical - use ID if available)
git checkout main
git pull
git checkout -b hotfix/102-security-patch
```

### Commit Messages

**Format:** Conventional commits

```
<type>: <description>

[optional body]

[optional footer]
```

**Types:**
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation only
- `style:` - Formatting, missing semicolons, etc.
- `refactor:` - Code change that neither fixes a bug nor adds a feature
- `perf:` - Performance improvement
- `test:` - Adding or correcting tests
- `chore:` - Maintenance (dependencies, build, etc.)

**Examples:**
```bash
git commit -m "feat: Add quick reference guide (FEAT-016)"

git commit -m "fix: Correct memory leak in event handler (BUGFIX-101)"

git commit -m "docs: Update installation instructions"

git commit -m "refactor: Extract validation logic to separate module"
```

**Include work item ID when available.**

### Pull Requests (Teams)

**When a task is done:**

1. **Create PR with description:**
   - What changed
   - Why it changed
   - How to test
   - Screenshots (if UI changes)
   - Link to work item

2. **Tag relevant reviewers:**
   - `@frontend-team` for UI changes
   - `@backend-team` for API changes
   - `@security-team` for security changes

3. **Address feedback:**
   - Respond to comments
   - Make requested changes
   - Re-request review

4. **Merge when approved:**
   - All checks pass
   - Required approvals received
   - No merge conflicts
   - Squash or merge (per project convention)

### Code Review Checklist

**Reviewer checks:**
- [ ] Code follows project standards
- [ ] Tests included and passing
- [ ] No security vulnerabilities
- [ ] Documentation updated
- [ ] No commented-out code
- [ ] Meaningful variable names
- [ ] Edge cases handled
- [ ] Performance acceptable

**For AI code reviews:** Focus on static analysis, style adherence, and security. Flag potential issues for human review.

---

## Architecture Decision Records (ADRs)

### When to Create an ADR

Create an ADR when you:
- Make a technical choice between alternatives
- Establish a pattern or standard
- Choose an algorithm, library, or approach
- Make architectural decisions

**Don't create ADRs for:**
- Obvious/trivial choices with no alternatives
- Temporary workarounds
- Implementation details (those go in code comments)

**Key principle:** If you're choosing between options and future developers might ask "why did we do it this way?", create an ADR.

### Template Selection: MAJOR vs MINOR

#### Use MAJOR Template When ANY Apply

- Affects system architecture or core design
- Impacts 3+ modules/files
- Significant trade-offs (performance, security, maintainability)
- Hard/expensive to change later
- Will be referenced by future decisions
- Took significant time to evaluate (>1 hour discussion)

**Examples:**
- Choosing state management approach (Redux vs Context vs Zustand)
- Selecting database (PostgreSQL vs MongoDB vs DynamoDB)
- Defining authentication architecture (JWT vs sessions vs OAuth)
- Dependency resolution algorithm design

#### Use MINOR Template When

- Limited scope (1-2 files)
- Clear winner among options
- Low risk if changed later
- Straightforward trade-offs

**Examples:**
- JSON library choice (fast-json-stringify vs built-in)
- Log format selection (JSON vs text)
- File naming convention
- Code formatting tool (Prettier vs ESLint-only)

#### When in Doubt

Start with MINOR, upgrade to MAJOR if you discover complexity.

### Template Locations

- **MAJOR:** `thoughts/framework/templates/ADR-MAJOR-TEMPLATE.md`
- **MINOR:** `thoughts/framework/templates/ADR-MINOR-TEMPLATE.md`

### Naming Convention

- Numbered sequentially: `001-decision-title.md`, `002-next-decision.md`
- Use lowercase with hyphens
- Both MAJOR and MINOR share same numbering sequence (chronological order)
- Store in `thoughts/project/research/adr/`

**Examples:**
```
thoughts/project/research/adr/
├── 001-ai-workflow-checkpoint-policy.md (MAJOR)
├── 002-json-library-selection.md (MINOR)
├── 003-authentication-architecture.md (MAJOR)
└── 004-log-format.md (MINOR)
```

### Upgrading MINOR to MAJOR

If a MINOR decision becomes more significant:

1. Create new ADR with next number using MAJOR template
2. Add `**Supersedes:** ADR-XXX` to new ADR
3. Add `**Reason for upgrade:**` explanation
4. Update original ADR status to `Superseded by ADR-YYY`
5. Link from relevant reference docs

**Upgrade triggers:**
- Scope expands to 3+ modules
- Affects system architecture
- Complex trade-offs discovered
- Becomes reference point for other decisions
- Performance/scale becomes critical

**Example:**
```markdown
# ADR-005: JSON Library Selection (MAJOR)

**Status:** Accepted
**Date:** 2025-12-22
**Supersedes:** ADR-002
**Reason for upgrade:** Performance testing revealed 40% throughput improvement
possible. Now affects 8 modules and API response times. Upgraded to MAJOR for
full trade-off analysis.
```

### ADR Lifecycle

```
[Decision Needed]
    |
    v
[Create ADR with Status: Proposed]
    |
    v
[Evaluate options, discuss with team]
    |
    v
[Update ADR with analysis]
    |
    v
[Update Status: Accepted]
    |
    v
[Implement decision]
    |
    v
[Link from relevant docs]
    |
    v
[If superseded later: Status: Superseded by ADR-XXX]
```

**ADR is a living document:** Update it as understanding evolves during evaluation.

### ADR Status Values

- **Proposed** - Under discussion, not yet decided
- **Accepted** - Approved and being/to be implemented
- **Implemented** - Decision implemented in code
- **Superseded by ADR-XXX** - Replaced by newer decision
- **Rejected** - Considered but not chosen (document why!)

---

## Collaboration Practices

### Effective AI Collaboration

#### Mode Clarity

Distinguish between planning mode and implementation mode:

- **When exploring:** "I'm researching options for X"
- **When ready to code:** "Let's implement approach X"
- **When unclear:** "Are we planning or building?"

This prevents AI from jumping to implementation during planning discussions.

#### Standards Adherence

AI should explicitly reference standards before coding:

- "Let me check code-quality-standards.md first"
- "I see the security policy requires..."
- "Following the testing strategy for this type of component..."

Prevents AI from inventing conventions or ignoring project standards.

#### Context Management

- Propose bounded tasks that fit in conversation context
- Break large features into smaller, discrete steps
- Save progress frequently in planning documents
- Use work item documentation to track complex tasks
- Reference existing documentation instead of recreating

#### Proactive Clarification

Ask essential questions upfront:
- "What's the one thing this must accomplish?"
- "Are there constraints I should know about?"
- "Should this follow an existing pattern?"
- "Do you want me to plan first or implement?"

Better to ask than assume.

### Communication Best Practices

#### What Works Well

- **Push back** with clear reasoning when approach seems suboptimal
- **Provide options** with trade-offs instead of single recommendation
- **Create visual diagrams** for complex workflows
- **Accept and incorporate** critical feedback gracefully
- **Document comprehensively** to capture context for future

#### Task Breakdown

- Ask for breakdown when scope seems large
- Clarify planning vs implementation mode
- Reference relevant documentation during discussion
- Propose checkpoints for review and feedback
- Don't try to solve everything in one session

#### When Things Go Wrong

- **Backtrack and rethink** rather than persisting with broken approach
- **Explain why** current approach isn't working
- **Propose alternatives** with different trade-offs
- **Ask for clarification** if requirements are ambiguous
- **Admit uncertainty** rather than guessing

### For Human Contributors

- Be explicit about mode (planning vs implementing)
- Provide context about constraints and priorities
- Review work item documents before starting work
- Update documentation as you work, not after
- Ask questions early, not after implementation

---

## References

- [CLAUDE.md](../../../CLAUDE.md) - Quick reference and AI workflow
- [code-quality-standards.md](code-quality-standards.md) - Coding standards
- [security-policy.md](security-policy.md) - Security requirements
- [testing-strategy.md](testing-strategy.md) - Testing approach
- [version-control-workflow.md](../../framework/process/version-control-workflow.md) - Git and release process
- [kanban-workflow.md](../../framework/process/kanban-workflow.md) - Work item lifecycle

---

**Last Updated:** 2025-12-22
**Version:** 1.0.0
**Next Review:** After 10 projects use this guide

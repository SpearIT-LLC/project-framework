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
3. [Workflow Transitions](#workflow-transitions)
4. [Planning Guidelines](#planning-guidelines)
5. [Documentation Standards](#documentation-standards)
6. [Git Workflow](#git-workflow)
7. [Architecture Decision Records (ADRs)](#architecture-decision-records-adrs)
8. [AI Roles and Workflow](#ai-roles-and-workflow)
9. [Collaboration Practices](#collaboration-practices)

---

## Development Workflow Phases

All projects follow this core workflow, with depth varying by project needs:

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

The framework supports `project-hub/research/` for detailed research documentation:
- `problem-statement.md` - Clear problem definition
- `landscape-analysis.md` - Existing solutions review
- `feasibility.md` - Can/should we build this?
- `project-justification.md` - Go/no-go decision

For simpler projects, you may use a single `justification.md` or embed research in README.md "Why This Exists" section.

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

For comprehensive projects, create `project-hub/external-references/project-definition.md`. For simpler projects, a section in README.md is sufficient.

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
  - Use BUG-TEMPLATE.md for bugs
  - Use TECHDEBT-TEMPLATE.md for tech debt
  - Use DECISION-TEMPLATE.md for decisions
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

The framework provides `project-hub/` structure for work tracking:
- `roadmap.md` - Version plan
- `work/backlog/` - Features not yet started
- `work/todo/` - Committed next work
- `work/doing/` - Currently in progress (WIP limited)
- `work/done/` - Completed work

For simpler projects, a task list in README or STATUS may be sufficient.

**Planning Principle:** "What's the one thing this must accomplish?"

Ask this before elaborate planning. Keep planning proportional to project size.

### 4. Code

**Purpose:** Implement incrementally with quality.

**Activities:**
- One work item at a time (respect WIP limits)
  - Check `project-hub/work/doing/.limit`
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
- Update README.md (if applicable)
  - Review if new features affect user-facing documentation
  - Add new capabilities, configuration options, or usage examples
  - Update feature lists, installation instructions, or quick start guides
  - Skip if release is internal refactoring or bug fixes with no user-visible changes
- Tag releases
  - `git tag -a vX.Y.Z -m "Release notes"`
  - Push tags: `git push --tags`
- Move to work/done/
  - File moves from doing/ → done/
- **Archive work items:**
  - Immediately after release tag is created
  - Create `project-hub/history/releases/vX.Y.Z/` folder
  - Move ALL related work item files from done/ to release folder
    - Primary work items (FEAT-XXX.md, BUGFIX-XXX.md)
    - Supporting documents (FEAT-XXX-*.md, feature-XXX-*.md)
    - Test plans, results, migration matrices, planning docs
  - **Command:** `git mv project-hub/work/done/WORK-ITEM-*.md project-hub/history/releases/vX.Y.Z/`
  - **CRITICAL:** Use `git mv` (move), NOT `cp` (copy) - prevents duplicates
  - Commit: `git commit -m "chore: Archive vX.Y.Z work items"`
  - **Verify:** Check done/ is empty: `ls project-hub/work/done/*.md` (should return empty)
  - Result: done/ folder should be empty after archival
  - **See ADR-003 for complete archival process and common mistakes**

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

### Research Depth Based on Project Needs

Apply research depth proportional to project complexity, risk, and uncertainty. The framework supports comprehensive research documentation while allowing simpler approaches for straightforward projects.

#### Lightweight Research (Simple Projects)

For scripts, small utilities, or well-understood problems, embed research directly in README.md:

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

#### Mid-Depth Research (Moderate Complexity)

For projects with some uncertainty or moderate investment, create a simple justification document at `project-hub/research/justification.md`:

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

#### Comprehensive Research (Complex/High-Risk Projects)

For significant projects with high uncertainty, investment, or risk, use complete research documentation in `project-hub/research/`:

**Research Documents:**

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

5. **project-definition.md** (in external-references/) - What we're building
   - Created after go decision
   - Detailed scope
   - Success criteria
   - Architecture approach

**When to use comprehensive research:**
- Significant time/resource investment (months of work)
- High technical or business risk
- Multiple stakeholders or teams involved
- Unfamiliar technology or domain
- Compliance or regulatory requirements

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

## Workflow Transitions

When moving work items between workflow folders, follow these rules and checklists.

### Transition Validity Matrix

Not all transitions are valid. Use this matrix to determine if a transition is allowed:

| From | To | Valid? | Reason |
|------|----|----|--------|
| backlog | todo | ✅ | Standard flow - committing to work |
| backlog | doing | ❌ | Must commit to work (todo) first |
| backlog | done | ❌ | Must be worked on |
| todo | doing | ✅ | Starting work |
| todo | backlog | ✅ | Deprioritizing |
| todo | done | ❌ | Must actually do the work (doing first) |
| doing | done | ✅ | Completing work |
| doing | todo | ✅ | Pausing work |
| doing | backlog | ❌ | Use todo as intermediate state |
| done | history | ✅ | Post-release archival |
| done | * | ❌ | No reopening (create new work item) |
| backlog | archive | ✅ | Cancellation (most common) |
| todo | archive | ✅ | Cancellation (commitment withdrawn) |
| doing | archive | ✅ | Cancellation (work abandoned) |
| done | archive | ✅ | Cancellation (rare, retroactive) |

**Invalid Transition Handling:**

If you attempt an invalid transition:
1. Stop immediately
2. Identify the correct intermediate state
3. Follow the valid path (e.g., backlog → todo → doing, not backlog → doing)

**Example - Invalid Request:**
```
User: "Move FEAT-042 from backlog directly to doing"
AI: "I cannot move directly from backlog to doing. The valid path is:
     1. backlog → todo (commit to work)
     2. todo → doing (start work)
     Should I move FEAT-042 to todo first?"
```

### Per-Transition Checklists

When moving a work item, complete the checklist for the target folder. Use `git mv` for all moves to preserve history.

**⚠️ Sync Warning:** These checklists are duplicated in `.claude/commands/fw-move.md` for enforcement. Any changes here must be synced to fw-move.md to maintain consistency.

#### → backlog/
- [ ] Work item created from template
- [ ] ID assigned (scan ALL work/ locations and history/releases/ first)
- [ ] Commit new work item(s) (immediately or after batch creation)

#### → todo/
- [ ] Transition is valid (check matrix above)
- [ ] User has approved the work
- [ ] Priority set
- [ ] If `todo/.limit` exists, check WIP limit not exceeded (parent + children = 1 item)
- [ ] Use `git mv` to move file

#### → doing/
- [ ] Transition is valid (check matrix above)
- [ ] If `doing/.limit` exists, check WIP limit not exceeded (parent + children = 1 item)
- [ ] Check `Depends On` field - all dependencies must be in done/
- [ ] Use `git mv` to move file

**Pre-Implementation Review** (on move OR when user requests):
- [ ] Read ENTIRE work item document
- [ ] Identify open questions (search for: TODO, TBD, DECIDE, Question, Option A/B/C)
- [ ] Present pre-implementation summary to user
- [ ] **STOP - Wait for user confirmation before implementing**

#### → done/
- [ ] Transition is valid (check matrix above)
- [ ] All completion criteria in work item are checked
- [ ] Status field updated to "Done"
- [ ] User has approved the completed work
- [ ] Use `git mv` to move file

**Post-Move Actions:**
- [ ] Update session history (`/fw-session-history`)
- [ ] Commit the changes

#### → history/releases/vX.Y.Z/
- [ ] Transition is valid (check matrix above)
- [ ] Use `git mv` to move files
- [ ] Verify done/ is empty after archival

**Full Release Process:** See [version-control-workflow.md#release-checklist](../process/version-control-workflow.md#release-checklist) for the complete release checklist.

#### → history/archive/ (Cancellation)
- [ ] Transition is valid (check matrix above)
- [ ] Cancellation reason documented in work item
- [ ] Status and date fields added (see Cancellation Process below)
- [ ] Use `git mv` to move file
- [ ] Session history updated noting the cancellation

### Cancellation Process

When work items are cancelled, outdated, or superseded, they move to `history/archive/` rather than being deleted. This preserves context and lessons learned.

#### When to Cancel vs Deprioritize

| Situation | Action | Destination |
|-----------|--------|-------------|
| Work no longer needed | Cancel | archive/ |
| Requirements changed fundamentally | Cancel | archive/ |
| Superseded by different approach | Cancel | archive/ |
| Lower priority, may do later | Deprioritize | backlog/ |
| Blocked temporarily | Pause | todo/ or backlog/ |

**Rule of thumb:** If the work item as written will *never* be done, cancel it. If it *might* be done later, deprioritize it.

#### Required Cancellation Metadata

Add these fields to the work item before archiving:

```markdown
**Status:** Cancelled
**Cancelled Date:** YYYY-MM-DD
**Cancellation Reason:** [Brief explanation]
```

**Optional fields:**
```markdown
**Superseded By:** ITEM-NNN
**Lessons Learned:** [What we learned from this]
```

#### Cancellation Steps

1. **Update the work item** with cancellation metadata (Status, Date, Reason)
2. **Add lessons learned** if applicable (optional but valuable)
3. **Move to archive:** `git mv project-hub/work/[folder]/ITEM-NNN-*.md project-hub/history/archive/`
4. **Update session history** noting the cancellation
5. **Commit:** `git commit -m "chore: Cancel ITEM-NNN - [brief reason]"`

#### Example Cancellation

**Before (in backlog/):**
```markdown
# Feature: Add PDF Export

**ID:** FEAT-042
**Type:** Feature
**Priority:** Medium
**Created:** 2026-01-10

## Summary
Add ability to export reports as PDF files.
```

**After (in archive/):**
```markdown
# Feature: Add PDF Export

**ID:** FEAT-042
**Type:** Feature
**Priority:** Medium
**Created:** 2026-01-10
**Status:** Cancelled
**Cancelled Date:** 2026-01-23
**Cancellation Reason:** Users prefer CSV export; PDF adds complexity without demand.

## Summary
Add ability to export reports as PDF files.

## Lessons Learned
- Validated with 5 users before cancelling - none needed PDF
- CSV export covers 95% of use cases
- Consider user research before committing to export formats
```

### Policy Reference

The workflow transition rules are referenced in `framework.yaml`:

```yaml
policies:
  workflow: framework/docs/collaboration/workflow-guide.md
  onTransition: framework/docs/collaboration/workflow-guide.md#workflow-transitions
```

**AI assistants:** When moving work items between folders, read and follow the `onTransition` policy before proceeding.

---

## Workflow Enforcement

The framework provides a three-layer enforcement system to ensure workflow policies are followed mechanically, not just documented.

### Three-Layer Architecture

```
┌─────────────────────────────────────────────────────────┐
│  Layer 1: /fw-move skill (proactive guidance)           │
│  - Embedded checklists in command                       │
│  - Validates preconditions before executing git mv      │
│  - Blocks transitions when requirements not met         │
│  - Offers to fix missing fields automatically           │
├─────────────────────────────────────────────────────────┤
│  Layer 2: Work item templates (structured execution)    │
│  - Implementation Checklist with enforcement comment    │
│  - Step-by-step execution protocol                      │
│  - AI must stop at each step for approval               │
├─────────────────────────────────────────────────────────┤
│  Layer 3: Pre-commit hook (safety net)                  │
│  - Validates work items in done/ before commits         │
│  - Blocks commits if state inconsistent                 │
│  - Can be bypassed with --no-verify if needed           │
└─────────────────────────────────────────────────────────┘
```

### Layer 1: /fw-move Enforcement

The `/fw-move` command mechanically enforces transition policies:

**Precondition Validation:**
- Checks transition validity against the matrix
- Reads work item file completely
- Verifies required fields (Status, Completed date, Priority)
- Checks dependencies (all must be in done/)
- Validates WIP limits not exceeded
- Scans for unchecked acceptance criteria

**Behavior on Failure:**
- STOPS immediately if any check fails
- Reports exactly what's missing
- Offers to fix issues automatically
- Does NOT proceed until requirements met

**Example:**
```
User: /fw-move FEAT-042 done

AI: ❌ Cannot move FEAT-042 to done - preconditions not met:
   - Status field not set to "Done"
   - Completed date missing
   - 2 acceptance criteria still unchecked

   Would you like me to fix these issues?
```

### Layer 2: Implementation Checklist Enforcement

Work item templates include an Implementation Checklist with enforcement comment:

```markdown
## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->
<!-- User can say "continue to completion" to approve remaining steps at once. -->

- [ ] Step 1
- [ ] Step 2
- [ ] Step 3
```

**Enforcement Protocol (5 mandatory rules):**

1. **Complete items in strict order** - Do not skip ahead unless user explicitly requests
2. **Mark items complete immediately** - Update `[ ]` to `[x]` as soon as step finishes
3. **STOP at each unchecked item** - Wait for explicit user approval before proceeding
   - Exception: User says "continue to completion" to approve all remaining
4. **Read work item file before every edit** - File may be updated during work
5. **Use TodoWrite tool** - Track progress and provide visibility to user

**User Override Phrases:**
- "continue to completion" → Approve all remaining checklist items at once
- "skip to step N" → Jump ahead (only when explicitly requested)

**When This Applies:**
- Automatically enforced when enforcement comment is present
- Activated after `/fw-move ITEM doing` completes
- Gives user control over implementation pace

### Layer 3: Pre-Commit Hook

**Hook Location:** `.claude/hooks/Validate-WorkItems.ps1`

**Validation Rules:**
The hook validates ALL files in `done/` before allowing commits:
1. **Status field** must be "Done"
2. **Completed date** must exist
3. **Acceptance Criteria** must all be checked (no `- [ ]` after the "## Acceptance Criteria" heading)

**Behavior:**
- Runs automatically before git commit commands (Claude Code PreToolUse hook)
- Lists all validation failures, not just the first one
- Blocks commit (exit code 2) if any validation fails
- Provides clear error messages with file names and specific issues

**Bypass When Needed:**
```bash
git commit --no-verify -m "message"
```

Use `--no-verify` for:
- Emergency commits when hook has bugs
- Committing test files (TEST-NNN-*.md)
- Committing artifact/deliverable files
- When you need to commit the hook fixes themselves

**Example Output:**
```
Work item validation failed:
  FEAT-042-api-endpoint.md: Missing 'Status: Done'
  FEAT-042-api-endpoint.md: Has unchecked acceptance criteria
  TECH-081-setup.md: Missing 'Completed' date

To override this check, use: git commit --no-verify
```

### Design Philosophy

**Why Three Layers?**

- **Layer 1 (/fw-move):** Proactive - guides before action, prevents mistakes
- **Layer 2 (Checklist):** Structured - controls implementation pace
- **Layer 3 (Hook):** Reactive - catches anything that slips through

**Trade-offs:**
- Layer 1 is proactive but only enforced when using /fw-move
- Layer 3 is reactive (catches after attempt) but always active
- Together they provide defense in depth

**Historical Context:**
This system was implemented via TECH-094 after FEAT-091 was committed with incomplete metadata. The root cause: fw-move *instructed* Claude to follow checklists but didn't *enforce* compliance mechanically. The three-layer system ensures policies are followed reliably, not just documented.

---

## Planning Guidelines

### Kanban Workflow

Work items flow through folders:

```
project-hub/
├── work/backlog/         # Ideas and future work
├── work/todo/            # Committed next (prioritized)
├── work/doing/           # Currently in progress (WIP limited)
├── work/done/            # Completed (awaiting release)
├── poc/                  # POC spikes with code artifacts (no WIP limit)
└── research/             # Analysis, ADRs, landscape reviews
```

**Workflow:**
```
User Idea → Backlog → [User Approval] → Todo → Doing → Done → Release → Archive
```

**WIP Limits:**
- Check `project-hub/work/doing/.limit` file for your project's configured limit
- Framework default: 1 item (solo developer) or 2 items (small team)
- Projects can set their own limits based on team size and workflow
- Complete current work before starting new (up to your limit)

#### WIP Limit Flexibility

WIP limits are user-defined tools for maintaining focus, not rigid laws. The `.limit` file value is yours to set based on your project's needs.

**Setting Your Project's WIP Limit:**

```bash
# Solo developer (recommended default)
echo "1" > project-hub/work/doing/.limit

# Small team or parallel workstreams
echo "2" > project-hub/work/doing/.limit

# Larger team (consider if this is really needed)
echo "3" > project-hub/work/doing/.limit
```

Choose a limit that enforces focus without being unrealistic for your context.

**Pattern 1: Pause & Resume (Recommended)**

When new work arrives while you're at your WIP limit:

1. Move current work item from `doing/` back to `todo/`
2. Create and move new item to `doing/`
3. Complete new item
4. Resume previous work

**When to use:**
- Current work can wait (not time-critical)
- New work is urgent but not "drop everything"
- You want enforced single-item focus

**Overhead:** ~2 minutes of git mv commands. This is the default approach.

**Pattern 2: Temporary WIP Bump**

Temporarily increase your WIP limit when parallel work is genuinely needed.

**When appropriate:**
- Production issue while mid-flight on a feature (costly to context-switch)
- Blocking another team member who needs unblocking without abandoning your work
- Time-boxed parallel work ("I'll spend 2 hours on this bug, then back to feature")

**Guardrails:**
- Document *why* you're bumping WIP (in work item or session history)
- Set a time limit ("WIP+1 until EOD" or "until BUG-123 ships")
- Return to your normal WIP as soon as one item completes
- Temporary bumps should be exceptions, not the norm

**How to temporarily bump:**
```bash
# Check current limit
cat project-hub/work/doing/.limit  # Shows: 1

# Increase temporarily
echo "2" > project-hub/work/doing/.limit

# After completing one item, restore your normal limit
echo "1" > project-hub/work/doing/.limit
```

**Guidance Principles:**

1. **Pause & Resume is usually sufficient** - The overhead is low, and it maintains clean single-item focus
2. **Most "emergencies" don't require WIP bump** - Production issues can often use pause/resume
3. **WIP limits exist for a reason** - They prevent context-switching chaos and ensure completion
4. **When in doubt, pause and resume** - It's the simpler, safer pattern

**Anti-pattern:** Permanently increasing WIP limit because "we always have urgent interrupts." If this happens frequently, the problem is prioritization or team structure, not the WIP limit. Consider whether your baseline limit is set appropriately for your context.

**For AI assistants:** See CLAUDE.md "AI Workflow Checkpoint Policy" for mandatory approval checkpoints.

### Spike Flow (Research/Investigation)

Spikes follow a different workflow than features/bugfixes. They use the `poc/` folder for active investigation.

```
poc/SPIKE-NNN-description/
    ├── SPIKE-NNN-description.md
    └── [code artifacts, if any]
    ↓ (findings documented, investigation complete)
history/spikes/SPIKE-NNN-description/
    ├── SPIKE-NNN-description.md
    └── [code artifacts, if any]
```

**Optional: Queue spikes in backlog first**
If you have a spike idea but aren't ready to start, you may create a spike doc in `work/backlog/` and move it to `poc/` when ready. Most spikes start directly in `poc/`.

**Optional cleanup after production implementation:**
If the spike informed a production implementation, you may delete code artifacts from `history/spikes/` while keeping the spike document (preserves lessons learned).

**Key differences from standard flow:**
- Spikes start directly in `poc/` folder (or optionally queue in `backlog/` first)
- Spikes do NOT go through `todo/` or `doing/`
- Spikes do NOT trigger releases
- Spikes archive to `history/spikes/`, not `history/releases/`
- No WIP limits on `poc/` folder

**When to use a spike:**
- Need to investigate unknowns before planning solution
- Research question with time-boxed investigation
- Technology evaluation or proof-of-concept

### Roadmap Integration

**Location:** `project-hub/roadmap.md`

**Purpose:** Track high-level version goals and reference work items by ID.

**Example format:**
```markdown
## v1.2.0 - Configuration Enhancements

**Status:** In Progress

**Planned Features:**
- [x] FEAT-001: Manifest defaults - RELEASED v1.1.0
- [ ] FEAT-002: Namespace system - In doing
- [ ] FEAT-003: Environment validation - In backlog

**Current Work:**
- 🔄 FEAT-002: Namespace system - In doing
```

**Loose coupling principle:**
- Roadmap references work items by ID (FEAT-002), not file path
- Work items move between folders without breaking roadmap links
- Grep-friendly: `grep -r "FEAT-002"` finds all references

### Work Item Numbering

Work item numbers are **sequential and globally unique** across all work item types within a project.

**Format:** `[TYPE]-[NNN]` where:
- `TYPE` = FEAT, BUG, TECH, DECISION, SPIKE
- `NNN` = Zero-padded 3-digit number (001-999), then continues naturally (1000+)

**Examples:** `FEAT-021`, `BUG-005`, `TECH-033`, `DECISION-042`, `FEAT-1000`

#### Finding the Next Number

**See [Finding Next Available ID](#finding-next-available-id) for the complete algorithm.**

Key points:
- All work item types share a **common ID namespace** (FEAT, BUG, TECH, DECISION, SPIKE, POLICY)
- Scan **all four directories**: `work/`, `releases/`, `poc/`, `history/spikes/`
- Extract max ID from filenames, then increment by 1

**Why scan all locations?**
- Work items move through lifecycle (backlog → todo → doing → done → archive)
- Spikes live in `poc/` and archive to `history/spikes/`
- If you only scan one folder, you'll miss items elsewhere
- Creates collision risk: Two different items with same number
- See BUGFIX-001 for detailed analysis of this issue

#### Hierarchical Numbering (Sub-Items)

For sub-features or test scenarios that are tightly coupled to a parent:

**Format:** `[TYPE]-[PARENT].[CHILD].[GRANDCHILD]`

**Examples:**
- `FEAT-020` - Parent feature
- `FEAT-020.1` - First sub-feature
- `FEAT-020.2` - Second sub-feature
- `FEAT-020.2.1` - Grandchild (specific test under FEAT-020.2)

**Maximum depth:** 3 levels (parent.child.grandchild)

**When to use hierarchical numbering:**
- Sub-item is tightly coupled to parent
- Sub-item only makes sense in context of parent
- Test scenarios, migration matrices, detailed test plans

**When to use separate numbering:**
- Work item can stand alone independently
- Work item might be reused or referenced elsewhere
- Work item is a distinct user-facing feature

**WIP Limit Note:** Parent and all children count as **1 item** toward WIP limit. See ADR-003 for details.

#### Number Exhaustion (999+)

After `FEAT-999`, continue naturally to `FEAT-1000`, `FEAT-1001`, etc.

**No special handling required.** Simply increment and drop zero-padding.

If your project reaches 1000+ features, consider whether it should be split into multiple projects, but the numbering system supports any count.

### Finding Next Available ID

When creating a new work item or spike, find the next available ID by scanning all existing items.

**Common ID Namespace:**

All work item types share a **single ID counter**:
- Features (FEAT-NNN)
- Bugs (BUG-NNN)
- Tech Debt (TECH-NNN)
- Decisions (DECISION-NNN)
- Spikes (SPIKE-NNN)
- Policy (POLICY-NNN)

This means if the last created item was FEAT-067, the next spike would be SPIKE-068 (not SPIKE-001).

**Benefits:**
- One algorithm for all item types
- No ID collisions (e.g., SPIKE-042 and FEAT-042 cannot both exist)
- Simple to answer "what's ID 42?" without specifying type
- Single function in tooling

**Scan Scope:**

Scan **all four directories** containing work items:

| Directory | Contains |
|-----------|----------|
| `project-hub/work/` | Active items (backlog, todo, doing, done) |
| `project-hub/releases/` | Released items archived by version |
| `project-hub/poc/` | POC spikes with code artifacts |
| `project-hub/history/spikes/` | Archived spike folders |

**Algorithm:**

1. Glob all work item files:
   ```
   {work,releases,poc,history/spikes}/**/{DECISION,FEAT,TECH,SPIKE,POLICY,BUG}-*.md
   ```

2. Extract numeric IDs from filenames (e.g., `FEAT-042-description.md` → `042`)

3. Find the maximum ID across all matches

4. Next available ID = max + 1

**Example (bash):**

```bash
# Find all work items and spikes
ls project-hub/{work,releases,poc,history/spikes}/**/*-[0-9][0-9][0-9]-*.md 2>/dev/null

# Parse IDs and find maximum
# If max is 067, next ID is 068
```

**Example (PowerShell):**

```powershell
# Use Get-NextWorkItemId from FrameworkWorkflow.psm1
Import-Module ./tools/FrameworkWorkflow.psm1
Get-NextWorkItemId -ProjectHubPath "project-hub"
# Returns: 068
```

**Rationale:**
- Ensures no ID collisions across all item types
- Self-healing (always accurate, no state drift)
- Efficient (filename parsing only, no file content reads)
- No state files to maintain or keep in sync
- Git-friendly (no merge conflicts on metadata files)

**Related:** See DECISION-042 for work item ID definition, TECH-046 for policy details.

### Work Item Templates

Located in `framework/templates/work-items/`:

#### Standard Metadata Fields (All Types)

All work item templates use consistent metadata fields:

```markdown
**ID:** TYPE-NNN
**Type:** Feature | Bug | Tech Debt | Decision | Spike
**Priority:** High | Medium | Low
**Version Impact:** MAJOR | MINOR | PATCH | None
**Created:** YYYY-MM-DD
```

**Optional fields:**
```markdown
**Assigned:** [Name]
**Severity:** Critical | High | Medium | Low  (Bug only)
**Depends On:** ITEM-NNN, ITEM-NNN
```

**Note:** Status is determined by folder location (backlog/todo/doing/done), not a metadata field.

#### Work Item Types (5 total)

| Type | Template | ID Prefix | Purpose |
|------|----------|-----------|---------|
| Feature | FEATURE-TEMPLATE.md | FEAT- | New capability or enhancement |
| Bug | BUG-TEMPLATE.md | BUG- | Defect fix |
| Tech Debt | TECHDEBT-TEMPLATE.md | TECH- | Internal improvement |
| Decision | DECISION-TEMPLATE.md | DECISION- | ADR / design choice |
| Spike | SPIKE-TEMPLATE.md | SPIKE- | Time-boxed research |

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

#### BUG-TEMPLATE.md
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

#### TECHDEBT-TEMPLATE.md
Use for internal improvements and refactoring.

**Sections:**
- Summary
- Problem Statement (current state, why problematic, desired state)
- Proposed Solution
- Files Affected
- Acceptance Criteria
- Notes
- Related items

**When to use:** Code cleanup, performance improvements, documentation updates, internal tooling.

#### DECISION-TEMPLATE.md
Use for architecture decisions that need documentation.

**Sections:**
- Summary
- Context (why decision is needed)
- Options Considered
- Decision
- Consequences
- Related items

**When to use:** Technical choices between alternatives, establishing patterns or standards.

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

#### Deprecated: BLOCKER-TEMPLATE.md

The Blocker type has been removed. Use the `Depends On` field instead to track dependencies between work items.

### Always Ask First

Before elaborate planning:
**"What's the one thing this must accomplish?"**

Keep planning proportional to:
- Project size (scripts need less than multi-year systems)
- Uncertainty (more unknowns = more planning)
- Risk (higher risk = more planning)
- Team size (larger team = more coordination)

Don't over-plan simple tasks. Don't under-plan complex systems.

---

## Project Roadmap

A project roadmap provides strategic direction beyond the immediate backlog. It organizes work into themes with 6-12 month horizons, helping teams prioritize and measure progress toward long-term goals.

### Location

`docs/project/ROADMAP.md` (consistent path for all projects)

### Purpose

**Roadmap vs Backlog:**
- **Roadmap** = Strategic direction (themes, milestones, why)
- **Backlog** = Tactical execution (specific work items, how)

**The roadmap answers:**
- Where is this project going?
- What are our strategic priorities?
- Why are we building these features?
- How do individual work items fit into the bigger picture?

### Structure

**Theme-based organization** (recommended):
- Group related initiatives into strategic themes
- Themes span multiple work items
- Progress measured by completing work items within themes

**Example themes:**
- AI Integration & Clarity
- Developer Guidance & Patterns
- Quality & Release Automation
- Distribution & Setup Excellence

### Roadmap-to-Backlog Workflow

1. **Define themes** in `docs/project/ROADMAP.md`
2. **Create work items** in backlog to support themes
3. **Reference themes** in work item metadata: `**Theme:** [Theme Name]`
4. **Measure progress** by tracking completed work items per theme
5. **Review quarterly** to adjust themes based on learnings

### When to Use Themes

**Use theme metadata in work items when:**
- Work supports a larger strategic initiative
- You want to track progress toward roadmap goals
- Multiple work items contribute to the same theme

**Skip theme metadata for:**
- Ad-hoc bug fixes
- Small maintenance tasks
- Work that doesn't align with any current theme

### Template and Examples

- **Template:** `framework/templates/planning/ROADMAP-TEMPLATE.md`
- **Real example:** `docs/project/ROADMAP.md` (this framework's roadmap)
- **Starter template:** `templates/starter/docs/project/ROADMAP.md`

### Best Practices

**Do:**
- Review and update roadmap quarterly
- Link roadmap themes to work items
- Use roadmap to explain prioritization decisions
- Treat roadmap as a guide, not a commitment

**Don't:**
- Let roadmap become stale (quarterly reviews prevent this)
- Create too many themes (2-4 active themes is ideal)
- Use roadmap as a rigid schedule (themes, not deadlines)
- Duplicate backlog content in roadmap (different levels of detail)

### Roadmap Anti-Patterns

- **The Wishlist**: Every idea goes in roadmap → Loses strategic focus
- **The Commitment**: Roadmap treated as promises → Can't adapt to learnings
- **The Duplicate Backlog**: Listing all work items → Loses strategic view
- **The Stale Document**: Never updated → Becomes irrelevant

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

**Location:** `project-hub/history/`

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

**Important: Append-Only Principle**

Session history is a historical record - preserve the journey, not just the destination.

When updating an existing session history file:

✅ **DO:**
- Append new sections for continued work
- Show evolution of thinking throughout the day
- Preserve original decisions/conclusions even if later superseded
- Add "(Later)" or "(Afternoon Session)" markers when continuing discussions
- Document how you arrived at final decisions

❌ **DON'T:**
- Replace earlier content with final decisions
- Rewrite history to show only the end state
- Delete original "pending" or "TBD" status when decisions are made later

**Example of proper evolution:**

Morning (original):
```markdown
### 2. Database Schema Design (Pending)
**Status:** Three options under consideration, final decision next session
```

Afternoon (append, don't replace):
```markdown
### 2. Database Schema Design - Final Decision (Afternoon Session)
**Continuation:** Resumed schema discussion from morning
**Final decision:** Option B (normalized schema with caching layer)
**Rationale:** Better data integrity, performance concerns addressed with Redis cache
```

This preserves the historical record of HOW decisions evolved, not just WHAT was decided.

**Automation:**
- Use `/fw-session-history` skill to generate/update session history
- See: [fw-session-history command](../../.claude/commands/fw-session-history.md)

---

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

**Location:** `project-hub/retrospectives/YYYY-MM-DD-retrospective.md`

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

## Versioning & Releases

### Version Calculation (Step 9)

**Purpose:** Calculate the next version number at release time based on current version and work item impact.

**Why calculate at release time?**
- Prevents stale version metadata in work items
- PROJECT-STATUS.md is the single source of truth
- Flexible - release order doesn't matter
- User confirms version before release

**Version Calculation Formula:**

Given current version and Version Impact from work item:

**PATCH (v2.2.4 → v2.2.5):**
- Backward-compatible bug fixes
- Documentation updates
- Internal refactoring with no API changes
- **Formula:** Increment patch number only
- **Example:** v2.2.4 + PATCH = v2.2.5

**MINOR (v2.2.4 → v2.3.0):**
- New features (backward-compatible)
- New APIs or capabilities
- Deprecations (but not removals)
- **Formula:** Increment minor, reset patch to 0
- **Example:** v2.2.4 + MINOR = v2.3.0

**MAJOR (v2.2.4 → v3.0.0):**
- Breaking changes
- API removals or incompatible changes
- Major architectural shifts
- **Formula:** Increment major, reset minor and patch to 0
- **Example:** v2.2.4 + MAJOR = v3.0.0

**Step 9 Process:**

1. **Read current version from PROJECT-STATUS.md:**
   ```bash
   grep "Current Version" PROJECT-STATUS.md
   # Current Version: v2.2.4 (2026-01-01)
   ```

2. **Read Version Impact from work item:**
   ```markdown
   **Version Impact:** PATCH
   ```

3. **Calculate next version:**
   - Current: v2.2.4
   - Impact: PATCH
   - Next: v2.2.4 + PATCH = v2.2.5

4. **Present to user for confirmation:**
   ```
   Current version v2.2.4 + PATCH impact = v2.2.5. Proceed with release v2.2.5?
   ```

5. **User confirms or corrects:**
   - User says "yes" → Proceed with v2.2.5
   - User says "actually make it MINOR" → Recalculate to v2.3.0
   - User provides specific version → Use that version

**Edge Cases:**

**Multiple work items in single release:**
- Use the highest impact (MAJOR > MINOR > PATCH)
- Example: 2 PATCH + 1 MINOR = MINOR release

**User overrides calculated version:**
- User preference always wins
- Document the override reason in commit message

**Pre-release versions:**
- Follow semver: v2.3.0-beta.1, v2.3.0-rc.1
- Not covered in this framework (extend as needed)

**Note:** Work item templates no longer include "Target Version" field. This field caused staleness and version authority confusion. Version is always calculated at release time from PROJECT-STATUS.md + Version Impact.

**Related:** See CLAUDE.md Step 9 for concise checklist version.

### Releasing Multiple Work Items Together

**Scenario:** You have completed multiple work items (e.g., 3 bug fixes, 2 features) and want to release them together under one version number.

**Why group releases?**
- Logical grouping (e.g., all security fixes)
- Sprint or milestone completion
- Multiple small items don't warrant separate releases
- Related changes that should ship together

#### Version Bumping for Grouped Releases

**Rule:** Use the **highest semantic version impact** among all items.

**Examples:**
- 3 PATCH items → PATCH version bump
  - v2.2.4 + (PATCH + PATCH + PATCH) = v2.2.5
- 2 PATCH + 1 MINOR → MINOR version bump
  - v2.2.4 + (PATCH + PATCH + MINOR) = v2.3.0
- Any MAJOR → MAJOR version bump
  - v2.2.4 + (PATCH + MINOR + MAJOR) = v3.0.0

#### Grouped Release Process

**Step-by-step:**

1. **Complete all items** - Move all items to `work/done/`

2. **Calculate version number:**
   - Read current version from PROJECT-STATUS.md
   - Determine highest version impact among all items
   - Calculate next version (e.g., v2.2.4 + MINOR = v2.3.0)

3. **Create grouped release folder:**
   ```bash
   mkdir -p project-hub/history/releases/v2.3.0
   ```

4. **Move all items to release folder:**
   ```bash
   git mv project-hub/work/done/FEAT-032-*.md project-hub/history/releases/v2.3.0/
   git mv project-hub/work/done/DECISION-042-*.md project-hub/history/releases/v2.3.0/
   git mv project-hub/work/done/FEAT-040-*.md project-hub/history/releases/v2.3.0/
   ```

5. **Update CHANGELOG.md** - Add all items under one version:
   ```markdown
   ## [2.3.0] - 2026-01-11

   ### Added
   - FEAT-032: Support for multiple work items per release
   - FEAT-040: Framework structure compliance fixes

   ### Changed
   - DECISION-042: Work item ID definition clarification

   ### Notes
   This release contains 3 work items grouped together.
   ```

6. **Update PROJECT-STATUS.md:**
   ```markdown
   **Current Version:** v2.3.0 (2026-01-11)
   ```

7. **Commit and tag:**
   ```bash
   git add .
   git commit -m "chore: Release v2.3.0 (FEAT-032, DECISION-042, FEAT-040)"
   git tag -a v2.3.0 -m "Release v2.3.0: Multiple work items support"
   git push && git push --tags
   ```

8. **Verify done/ is empty:**
   ```bash
   ls project-hub/work/done/*.md  # Should return empty
   ```

#### CHANGELOG Format for Grouped Releases

**Organize by semantic versioning category:**

```markdown
## [2.3.0] - 2026-01-11

### Added
- Work items that add new features or capabilities

### Changed
- Work items that modify existing behavior (backward-compatible)

### Deprecated
- Work items that deprecate features (not removed yet)

### Removed
- Work items that remove features (breaking change)

### Fixed
- Work items that fix bugs

### Security
- Work items that address security issues

### Notes
[Optional context about the grouped release]
```

**Multiple items in same category:**
```markdown
### Fixed
- BUGFIX-101: Authentication token refresh issue
- BUGFIX-102: Input validation on user forms
- BUGFIX-103: Logging format for error messages
```

#### Release History Organization

**Folder structure:**
```
project-hub/history/releases/
├── v2.2.5/
│   └── BUGFIX-100-auth-fix.md
├── v2.3.0/                        # Grouped release
│   ├── FEAT-032-multiple-items.md
│   ├── DECISION-042-id-definition.md
│   └── FEAT-040-structure-compliance.md
└── v2.3.1/
    └── BUGFIX-104-validation-fix.md
```

**Each release gets one folder** - whether it contains 1 item or 10 items.

#### Single vs Grouped: When to Use Each

**Use single-item release when:**
- Critical bug fix needed immediately
- Major feature ready independently
- Breaking change that needs its own version
- Clear logical separation from other work

**Use grouped release when:**
- Multiple related items complete together
- Sprint/milestone completion
- Several small items (PATCH-level changes)
- Logical thematic grouping

**No wrong answer** - Use judgment. Both patterns are supported.

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

- **MAJOR:** `project-hub/framework/templates/ADR-MAJOR-TEMPLATE.md`
- **MINOR:** `project-hub/framework/templates/ADR-MINOR-TEMPLATE.md`

### Naming Convention

- Numbered sequentially: `001-decision-title.md`, `002-next-decision.md`
- Use lowercase with hyphens
- Both MAJOR and MINOR share same numbering sequence (chronological order)
- Store in `project-hub/research/adr/`

**Examples:**
```
project-hub/research/adr/
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

## AI Roles and Workflow

The framework supports context-aware AI roles that shape how the AI approaches different types of work. Roles provide mindsets - internal voices that guide judgment and behavior.

### Role Definitions

Roles are defined in `framework/docs/ref/framework-roles.yaml` with this structure:

- **13 base roles** organized into 6 families (creation, validation, governance, strategy, operations, perspective)
- **Experience tiers** (mid-level, senior) with distinct mindsets
- **Variants** that specialize the approach (e.g., `developer.prototype` vs `developer.production`)

### Roles and Workflow Phases

Different roles naturally align with different workflow phases:

| Phase | Typical Roles | Why |
|-------|---------------|-----|
| Research/Explore | `analyst`, `architect` | Evaluating options, designing approaches |
| Define/Plan | `product_owner`, `scrum_master` | Setting requirements, organizing work |
| Code | `developer` (+ variants) | Building the solution |
| Review | `qa_engineer`, `security_analyst` | Validating quality |
| Release | `release_manager` | Version integrity, deployment readiness |

### Conversational Role Activation

Roles are activated through conversation, not automatic path detection:

**At session start:**
```
AI: "What kind of work are we doing today?"
User: "Let's work on the backlog"
AI: [Adopts scrum_master role]
```

**Mid-session context switch:**
```
User: "Move FEAT-042 to doing"
AI: "We've been working on code. This is a workflow action - should I switch to workflow management mode?"
```

### Variant Selection

Variants change the *approach* to work. The AI uses conversational hints (triggers) to suggest variants:

```
User: "Let's prototype a new feature"
AI: [Recognizes "prototype" trigger → adopts developer.prototype]
Mindset: "Speed over polish. Prove the concept. Don't overthink."
```

vs.

```
User: "This needs to be production-ready"
AI: [Recognizes "production" trigger → adopts developer.production]
Mindset: "Maintainable, tested, robust. Handle errors gracefully."
```

### Roles Requiring Context

Some roles need domain clarification before activation. These have a `requires_context` field:

| Role | Question Asked |
|------|----------------|
| `subject_matter_expert` | "What domain should I focus my expertise on?" |
| `compliance` | "What regulatory or compliance framework applies?" |
| `analyst` | "What are we analyzing?" |

**Example:**
```
User: "I need you to be a subject matter expert"
AI: "What domain should I focus my expertise on? (e.g., Legal/contracts, Healthcare/HIPAA, Financial services)"
User: "Cloud infrastructure"
AI: [Adopts subject_matter_expert with cloud infrastructure context]
```

### Role-Based Workflow Enforcement

The `scrum_master` role enforces workflow transitions:

**Mindset:** *"Is the process being followed? What's blocked?"* (mid-level) / *"Is this process helping? What's the team really struggling with?"* (senior)

When in scrum_master role, the AI:
1. Reads `onTransition` policy before moving work items
2. Validates transitions against the matrix (see [Workflow Transitions](#workflow-transitions))
3. Pushes back on invalid transitions
4. Checks WIP limits before moving items to doing

**Example - Invalid Transition Blocked:**
```
User: "Move FEAT-042 from backlog to doing"
AI (scrum_master): "I cannot move directly from backlog to doing. The valid path is:
     1. backlog → todo (commit to work)
     2. todo → doing (start work)
     Should I move FEAT-042 to todo first?"
```

### Default Role Behavior

When no specific role is active, the AI uses `senior-claude`:

**Mindset:** *"Help accomplish the task while following framework conventions. Consider whether this is the right approach. Raise concerns if something seems off."*

Project-specific defaults can be configured in `framework.yaml`:

```yaml
roles:
  definitions: framework/docs/ref/framework-roles.yaml
  default: senior-production-developer
```

### Reference

- **Role definitions:** `framework/docs/ref/framework-roles.yaml`
- **Role schema:** `framework/docs/ref/framework-schema.yaml`
- **Configuration:** `framework.yaml` → `roles` section

---

## Collaboration Practices

### Effective AI Collaboration

#### Role Awareness

Before starting work, clarify the appropriate role:

- **When exploring options:** "I'll approach this as an architect - evaluating trade-offs"
- **When implementing:** "Switching to developer mode - focusing on quality code"
- **When reviewing:** "Let me review this as a QA engineer"

This makes the AI's stance explicit and helps users understand the perspective being applied.

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

#### Pre-Implementation Review (Step 7.5)

**When:** After moving a work item to `work/doing/` and before starting implementation.

**Purpose:** Ensure AI has fresh context, identifies open questions, and confirms approach with user.

**What AI Should Do:**

1. **Read the complete work item document thoroughly**
   - Not just the summary - read the entire document
   - Pay special attention to design discussions and alternatives
   - Don't rely on memory from when the item was created

2. **Scan for open items and unresolved decisions:**
   - Search for keywords: "TODO", "TBD", "Question:", "Decision needed:", "DECIDE:"
   - Look for sections: "Design Discussion", "Alternatives Considered", "Open Questions"
   - Identify Option A/B/C patterns indicating multiple approaches
   - Check for comments like "User should decide..." or "To be determined..."

3. **Review the implementation approach:**
   - What files will be created or modified?
   - What is the core strategy?
   - Are there dependencies on other work items?
   - Is the approach still valid given current project state?

4. **Present summary to user:**
   - Brief description of what the work item accomplishes
   - List of files that will be affected
   - Any open questions or decisions needed
   - Recommendation for addressing open items (if any)

5. **Ask for confirmation before implementing:**
   - Use the standard question from CLAUDE.md Step 7.5
   - Wait for user response
   - Update work item document with any new guidance

**Example Patterns to Detect:**

```markdown
# In work item - these signal open questions:
"Option A: ... Option B: ... Option C: ..."
"TODO: Decide which approach to use"
"Question: Should we use X or Y?"
"TBD: Database schema design"
"User should review alternatives before implementation"
"DECIDE: Migration strategy"
```

**What to Present:**

```
Before I begin implementation, I've reviewed WORK-ITEM-ID. Here's what I understand:

**Approach:** [1-2 sentence summary of implementation strategy]

**Files to modify:**
- file1.md (add Step 7.5 section)
- file2.md (update references)

**Open questions:**
[List any TODO/TBD/Options, or state "None identified"]

[If open questions exist:]
My recommendation: [Proposed approach with brief rationale]

Do you agree with this approach, or would you like to provide additional guidance before I start?
```

**Benefits:**

- Catches stale context (work item created weeks ago)
- Surfaces design decisions that need user input
- Prevents implementing wrong approach
- Gives user control over implementation direction
- Complements Step 8.5 (post-implementation review)

**Related:** See CLAUDE.md Step 7.5 for concise checklist version.

**Documentation Update Order (Universal Principle):**

**Rule:** Always update master documentation BEFORE derived summaries or references.

**Common Documentation Hierarchies:**

1. **collaboration/* → CLAUDE.md**
   - Master: collaboration/workflow-guide.md, code-quality-standards.md, security-policy.md, etc.
   - Derived: CLAUDE.md (quick reference summaries)

2. **PROJECT-STATUS.md → README.md**
   - Master: PROJECT-STATUS.md (single source of truth for version, status)
   - Derived: README.md (may reference or summarize status)

3. **ADRs → implementation docs**
   - Master: project-hub/project/research/adr/*.md (decision records)
   - Derived: Code comments, implementation notes referencing decisions

4. **Templates → instances**
   - Master: project-hub/framework/templates/*.md (never edit directly)
   - Derived: Work items, documents created from templates

**Update Sequence:**

1. **Update master documentation FIRST**
   - Write complete detailed guidance
   - Include examples, rationale, edge cases
   - Ensure thorough coverage of the topic
   - Think through implications fully

2. **Then update derived summaries/references**
   - Extract essential information from master
   - Summarize into concise format appropriate for context
   - Reference master for full details
   - Ensure consistency with master

**Rationale:**
- Master is the authoritative source
- Derived documents are summaries or references
- Information flows: detailed → summary (not summary → detailed)
- Thinking through detailed guidance first ensures better summaries
- If interrupted, at least the authoritative source is updated
- Prevents master and derived getting out of sync
- Makes it clear which document has authority when conflicts arise

**Example Application:**

When adding Step 7.5 to the workflow:
- ✅ CORRECT: Update workflow-guide.md (master) → then CLAUDE.md (summary)
- ❌ INCORRECT: Update CLAUDE.md → then workflow-guide.md (backwards)

When documenting a security policy:
- ✅ CORRECT: Update security-policy.md (master) → then CLAUDE.md Core Standards summary
- ❌ INCORRECT: Update CLAUDE.md → then backfill security-policy.md

**This principle applies universally across all framework documentation.**

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
- [version-control-workflow.md](../process/version-control-workflow.md) - Git and release process

---

**Last Updated:** 2026-01-25
**Version:** 1.3.0
**Next Review:** After 10 projects use this guide

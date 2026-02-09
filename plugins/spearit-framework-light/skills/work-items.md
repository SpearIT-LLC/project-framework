# Skill: Work Items - Creating and Managing

## What is a Work Item?

A **work item** is a markdown file that describes something to build, fix, or decide. Each work item has:

- **Unique ID:** TYPE-NNN format (e.g., FEAT-042, BUG-018)
- **Filename:** `TYPE-NNN-descriptive-title.md`
- **Location:** One workflow folder (backlog, todo, doing, done)
- **Metadata:** Structured frontmatter (type, priority, status, dates)
- **Content:** Problem, solution, acceptance criteria, decisions

## Work Item Types

### FEAT (Feature)
New functionality or capability

**Example:** `FEAT-042-user-authentication.md`

### BUG (Bug Fix)
Defect or error correction

**Example:** `BUG-018-login-redirect-loop.md`

### TECH (Technical Debt)
Code quality, refactoring, or infrastructure

**Example:** `TECH-007-migrate-to-async-api.md`

### SPIKE (Research/Exploration)
Time-boxed investigation or proof of concept

**Example:** `SPIKE-003-evaluate-caching-strategies.md`

### DECISION (Architecture Decision)
Significant architectural or design choice requiring documentation

**Example:** `DECISION-001-database-selection.md`

## Work Item Structure (Typical)

```markdown
# Feature: [Title]

**ID:** FEAT-042
**Type:** Feature
**Priority:** High
**Created:** 2026-02-08
**Updated:** 2026-02-09

## Summary
[2-3 sentence description]

## Problem Statement
[What problem does this solve?]

## Requirements
- Functional requirement 1
- Functional requirement 2

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2

## Design Decisions
[Key choices made]

## Implementation Notes
[Technical details, constraints, dependencies]
```

## Creating Work Items

**Step 1:** Get next available ID
```
/spearit-framework-light:next-id
```

**Step 2:** Create markdown file in `project-hub/work/backlog/`
```
TYPE-NNN-descriptive-title.md
```

**Step 3:** Fill in structure
- Set metadata (ID, type, priority, dates)
- Write problem statement
- Define acceptance criteria
- Add design notes as needed

**Step 4:** Commit to git
```bash
git add project-hub/work/backlog/TYPE-NNN-*.md
git commit -m "feat: Add TYPE-NNN - Brief description"
```

## Managing Work Items

### Moving Through Workflow
Use the move command with policy enforcement:
```
/spearit-framework-light:move FEAT-042 todo
/spearit-framework-light:move FEAT-042 doing
/spearit-framework-light:move FEAT-042 done
```

### Updating Work Items
Edit the markdown file directly:
- Check off acceptance criteria: `- [x]`
- Add implementation notes
- Document decisions made
- Update metadata (dates, status)

### Cancelling Work
Move to archive with cancellation metadata:
```markdown
**Status:** Cancelled
**Cancelled Date:** 2026-02-09
**Cancellation Reason:** Requirements changed; superseded by FEAT-050
```

Then: `/spearit-framework-light:move FEAT-042 archive`

## Best Practices

✅ **One work item = One logical unit** (feature, bug, decision)
✅ **Keep acceptance criteria testable** (can verify done/not done)
✅ **Update as you learn** (work items evolve during implementation)
✅ **Commit frequently** (track changes in git)
✅ **Archive don't delete** (preserve context and lessons)

# Framework Glossary

**Version:** 1.0.0
**Last Updated:** 2026-01-28

This glossary defines framework-specific terminology and concepts. For detailed information, follow the cross-references to related documentation.

---

## A

### ADR (Architecture Decision Record)
A structured document recording significant architectural decisions, their context, and rationale. ADRs are stored in `project-hub/decisions/` and follow a numbered sequence.

See: [Workflow Guide - ADRs](../collaboration/workflow-guide.md#architecture-decision-records-adrs)

---

## B

### Backlog
Work items that have been defined but not yet prioritized for immediate work. Located in `project-hub/work/backlog/`. Items in backlog are considered "defined but not committed."

See: [Workflow Guide - Development Workflow Phases](../collaboration/workflow-guide.md#development-workflow-phases)

### Bootstrap Block
Critical instructions at the top of CLAUDE.md that AI assistants must read and execute at the start of every session. Contains essential setup steps and reading requirements.

See: [CLAUDE.md](../../CLAUDE.md)

### Bug
A work item type representing defects or incorrect behavior in the system. Uses the BUG-TEMPLATE.md format and is tracked with a BUG-NNN identifier.

See: [Workflow Guide - Work Item Templates](../collaboration/workflow-guide.md#work-item-templates)

---

## C

### CHANGELOG.md
A chronological record of all notable changes to the project, organized by version. Follows Keep a Changelog format with Added, Changed, Deprecated, Removed, Fixed, and Security sections.

See: [Workflow Guide - Documentation Standards](../collaboration/workflow-guide.md#documentation-standards)

### Checkpoint
A mandatory pause point in the workflow where AI assistants must wait for explicit user approval before proceeding. Used to ensure alignment before implementing changes.

See: [CLAUDE.md - AI Workflow Checkpoint Policy](../../CLAUDE.md#ai-workflow-checkpoint-policy-critical---adr-001)

### CLAUDE.md
Project-specific instructions and context for AI assistants. Contains bootstrap blocks, reading protocols, workflow checkpoints, and navigation guides. Every project has both a root CLAUDE.md and framework/CLAUDE.md.

See: [CLAUDE.md](../../CLAUDE.md), [Framework CLAUDE.md](../../framework/CLAUDE.md)

---

## D

### Deliverable Type
What your project produces: `code` (runnable software), `documentation` (guides, standards), or `hybrid` (both). Defined in framework.yaml.

See: [Framework Schema](framework-schema.yaml)

### Doing
Work items currently in progress. Located in `project-hub/work/doing/`. Subject to WIP (Work In Progress) limits to maintain focus and prevent context switching.

See: [Workflow Guide - Development Workflow Phases](../collaboration/workflow-guide.md#development-workflow-phases)

### Done
Completed work items awaiting release. Located in `project-hub/work/done/`. Items move here after all acceptance criteria are met and user approval is received.

See: [Workflow Guide - Development Workflow Phases](../collaboration/workflow-guide.md#development-workflow-phases)

### DRY (Don't Repeat Yourself)
A principle emphasizing that every piece of knowledge should have a single, authoritative representation. Applied to documentation, code, and configuration throughout the framework.

See: [Documentation DRY Principles](../collaboration/documentation-dry-principles.md)

---

## F

### Feature
A work item type representing new functionality or capabilities. Uses the FEATURE-TEMPLATE.md format and is tracked with a FEAT-NNN identifier.

See: [Workflow Guide - Work Item Templates](../collaboration/workflow-guide.md#work-item-templates)

### Framework
The SpearIT Project Framework - a structured approach to project organization, documentation, and AI collaboration. Available in Standard, Light, and Minimal levels.

See: [README.md](../../../README.md)

### framework.yaml
Machine-readable project configuration file at the repository root. Contains project metadata, policy references, role definitions, and source-of-truth index for framework topics.

See: [Framework Schema](framework-schema.yaml)

---

## K

### Kanban
File-based workflow system using folders to represent work states (backlog, todo, doing, done). Work items are markdown files that move between folders as they progress.

See: [Workflow Guide - Development Workflow Phases](../collaboration/workflow-guide.md#development-workflow-phases)

---

## P

### POC (Proof of Concept)
A lightweight implementation created to validate technical feasibility or explore an approach. POCs are stored in `project-hub/poc/` and are not subject to WIP limits.

See: [Workflow Guide - Development Workflow Phases](../collaboration/workflow-guide.md#development-workflow-phases)

### Planning Period
A flexible, user-defined timeframe for organizing roadmap work temporally. Planning periods have goals, success criteria, and focus on specific themes. They answer "What are we trying to achieve in this timeframe?"

**Common types:**
- **Time-boxed**: Sprints (1-4 weeks), Quarters (3 months)
- **Milestone-based**: "MVP Complete", "Beta Launch", "v2.0 Release"
- **Phase-based**: "Discovery", "Alpha", "Production"
- **Ad-hoc**: "Post-Refactor", "After User Testing", "Holiday Season"

Planning periods are organizational labels for grouping work, not enforced deadlines. Users choose their own naming convention. Work items can optionally reference planning periods in metadata. Planning periods are defined in ROADMAP.md and archived when complete.

See: [ROADMAP-TEMPLATE.md](../../templates/planning/ROADMAP-TEMPLATE.md), [Roadmap](#roadmap), [Theme](#theme)

### Pre-Implementation Review
A checkpoint where AI assistants read the entire work item, identify open questions, present an implementation summary, and wait for user confirmation before proceeding.

See: [Workflow Guide - Workflow Transitions](../collaboration/workflow-guide.md#workflow-transitions)

### Project Hub
The `project-hub/` directory containing all project management artifacts: work items, decisions, research, planning documents, and history.

See: [Project Structure Standard](../PROJECT-STRUCTURE-STANDARD.md)

### PROJECT-STATUS.md
A living document summarizing current project state, recent changes, active work, and upcoming priorities. Updated with each release.

See: [Workflow Guide - Documentation Standards](../collaboration/workflow-guide.md#documentation-standards)

### Project Type
What type of project you're building: `application` (end-user software), `library` (reusable code), `framework` (process/structure), or `toolbox` (utilities collection). Defined in framework.yaml.

See: [Framework Schema](framework-schema.yaml)

---

## R

### Roadmap
A strategic document defining project direction through stable themes and temporal planning periods. Roadmaps answer "What are the major categories of work?" (themes) and "What are we focusing on now?" (planning periods).

**Structure:**
- **Themes**: 3-5 stable categories organizing all project work
- **Planning Periods**: Time-bound sections with goals, success criteria, and theme focus
- **Future Considerations**: Ideas not yet assigned to planning periods

**Roadmap vs Backlog:**
- **Roadmap** = Strategic direction (themes, goals, outcomes)
- **Backlog** = Tactical work items (specific features/bugs)

Roadmaps focus on strategic framing (why, what outcomes) rather than tactical details (specific work items). Created and updated using the `/fw-roadmap` skill.

See: [ROADMAP-TEMPLATE.md](../../templates/planning/ROADMAP-TEMPLATE.md), [Theme](#theme), [Planning Period](#planning-period)

---

## S

### Session History
A chronological record of work performed during AI collaboration sessions. Located in `project-hub/history/sessions/`. Documents what was accomplished, decisions made, and lessons learned.

See: [Workflow Guide - Session History](../collaboration/workflow-guide.md#session-history)

### Spike
A time-boxed investigation work item used to research unknowns, evaluate options, or assess feasibility. Uses the SPIKE-TEMPLATE.md format and is tracked with a SPIKE-NNN identifier.

See: [Workflow Guide - Work Item Templates](../collaboration/workflow-guide.md#work-item-templates)

### SsoT (Single Source of Truth)
The authoritative source for a specific piece of information. Framework emphasizes identifying and maintaining clear SsoT for all documentation and configuration.

See: [Documentation DRY Principles](../collaboration/documentation-dry-principles.md)

---

## T

### Tech Debt
A work item type representing technical improvements, refactoring, or cleanup needed to maintain code quality. Uses the TECHDEBT-TEMPLATE.md format and is tracked with a TECH-NNN identifier.

See: [Workflow Guide - Work Item Templates](../collaboration/workflow-guide.md#work-item-templates)

### Theme
A stable category of project work that organizes all work items and persists throughout the project lifecycle. Themes answer "What are the major categories of this project?" and rarely change unless the project fundamentally pivots.

**Examples:**
- "Distribution & Onboarding" - Setup, installation, first-use experience
- "Workflow" - Work item management, release automation
- "Project Guidance" - Planning, roadmaps, status, strategic tools
- "Developer Guidance" - Code standards, patterns, best practices

**Key characteristics:**
- 3-5 themes per project (too many = unfocused)
- Stable over time (not temporal like planning periods)
- Every work item should map to a theme
- Themes provide consistent categorization across planning periods

Themes are defined in ROADMAP.md and referenced in work item metadata. All planning periods focus on one or more themes, but not all themes are active simultaneously.

See: [ROADMAP-TEMPLATE.md](../../templates/planning/ROADMAP-TEMPLATE.md), [Roadmap](#roadmap), [Planning Period](#planning-period)

### Todo
Work items committed for immediate attention. Located in `project-hub/work/todo/`. Represents prioritized work ready to start.

See: [Workflow Guide - Development Workflow Phases](../collaboration/workflow-guide.md#development-workflow-phases)

### Transition
Moving a work item from one workflow folder to another (e.g., backlog → todo → doing → done). Each transition has specific validation rules and checklists.

See: [Workflow Guide - Workflow Transitions](../collaboration/workflow-guide.md#workflow-transitions)

---

## W

### WIP Limit (Work In Progress Limit)
A constraint on the number of concurrent work items allowed in a workflow stage. Enforced via `.limit` files in todo/ and doing/ folders. Default limit is 1-2 items.

See: [Workflow Guide - Development Workflow Phases](../collaboration/workflow-guide.md#development-workflow-phases)

### Work Item
A trackable unit of work (Feature, Bug, Tech Debt, Spike, or Decision). Represented as markdown files following standardized templates with unique identifiers. Synonymous with "ticket" (Jira), "card" (Kanban), or "work package" (traditional PM).

See: [Workflow Guide - Work Item Templates](../collaboration/workflow-guide.md#work-item-templates)

---

**Total Terms Defined:** 33

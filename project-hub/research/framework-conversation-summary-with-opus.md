# Framework Discussion Summary

*Captured from Claude.ai conversation — January 2026*

---

## Project Overview

A structured framework for working through problems and issues using AI collaboration. Built over approximately one month in Claude Code.

### Core Architecture

- **File-based Kanban workflow** — Files are "cards" or "work items"; folders represent stages (backlog, todo, doing, done, release)
- **Markdown cards** — Created using developed templates for consistency
- **Documented workflow** — Complete workflow rules defined in a dedicated document
- **Role system** — Roles defined in YAML with associated mindsets that shape AI behavior

### Current Scope

- Solo use
- Future plans include team use and potential GitHub/Jira integration

---

## Key Design Decisions

### Why File-Based?

The file system acts as the workflow engine. This approach is:

- Simple and portable
- Version-control friendly (works naturally with git)
- No database or special tooling required to view or edit
- Artifacts are human-readable and shareable

### Why Constrain AI to Human Processes?

This framework intentionally structures AI collaboration around visible, file-based artifacts and explicit workflow stages. This isn't a limitation—it's a feature.

**For the human:**
- Transparency over capability — Work is inspectable, interruptible, and verifiable at each step
- Verification requires structure — Discrete states create checkpoints for "yes, this is right" before moving on
- Trust is earned incrementally — Visible, controllable process reveals where AI can be trusted and where it can't

**For the AI:**
- Persistent files compensate for context window limits
- Files act as shared state and external memory across sessions
- Clear rules reduce ambiguity about what to do next

**The bottom line:** Delegating work isn't the same as abdicating responsibility. Unstructured AI agency produces opaque results requiring full auditing after the fact. Structure is how trust gets built incrementally.

---

## Roles and Mindsets

The framework uses defined roles (e.g., Senior Developer, Mid-Level Security Analyst, Scrum Master) stored in YAML with associated mindsets.

### Why Roles Matter

Without a role, Claude defaults to general-purpose assistant mode—helpful, compliant, literal. Assigning a role shifts behavior significantly:

- **Executor → Collaborator** — A role activates implied process knowledge and professional judgment
- **Example:** "Move feat-001 to doing" gets executed literally. "You're a Scrum Master, move this feature to doing" triggers policy checks and process enforcement.

### Implications

- **Roles as a control lever** — Dial autonomy and judgment up or down by role selection
- **Context-dependent roles** — Same person might assign "Senior Developer" for implementation but "QA Analyst" for review
- **Documentable behaviors** — Role definitions can specify expected behaviors, checks, and questions

---

## Future Considerations

### Team Use / Integration

When expanding to team use, a key decision will be source-of-truth:

- Framework as source → Issues pushed to GitHub/Jira
- External system as source → Cards pulled into framework
- Hybrid approach

The file-based architecture should translate reasonably well, especially if already in git.

---

## Readme Paragraph (Draft)

For inclusion in project documentation:

> **Why constrain AI to a human workflow?**
>
> This framework intentionally structures AI collaboration around visible, file-based artifacts and explicit workflow stages. This isn't a limitation—it's a feature. Unstructured AI agency produces opaque results that require full auditing after the fact. A shared workflow creates transparency: work is inspectable, interruptible, and verifiable at each step. It also benefits the AI itself—persistent files compensate for context limits, and clear rules reduce ambiguity about what to do next. Delegating work isn't the same as abdicating responsibility; structure is how trust gets built incrementally.

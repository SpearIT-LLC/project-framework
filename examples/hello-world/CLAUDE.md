# Claude Context: Project Hello World

This file provides context for AI assistants (like Claude) working on this project.

## Project Overview

**Type:** Demonstration / Reference Implementation
**Status:** Active Example
**Framework:** [Standard Project Framework](../framework/CLAUDE.md)

This is a minimal "Hello World" application that demonstrates proper structure and organization using the Standard Project Framework. It serves as a reference for starting new projects.

## Working with This Project

### Framework Integration

This project follows the Standard Project Framework. **Always consult the framework documentation first:**

- **Framework Documentation:** [../framework/](../framework/)
- **Process Guidelines:** [../framework/process/](../framework/process/)
- **Collaboration Patterns:** [../framework/collaboration/](../framework/collaboration/)
- **Templates:** [../framework/templates/](../framework/templates/)

### Project Structure

```
examples/hello-world/
├── src/              # Application source code
│   └── hello-world.js
├── tests/            # Test files
│   └── hello-world.test.js
├── docs/             # Project-specific documentation
└── thoughts/         # Project tracking (work items, decisions, history)
    ├── work/         # Current and planned work
    ├── history/      # Releases, sessions, spikes
    ├── research/     # ADRs and technical research
    ├── retrospectives/
    ├── reference/
    ├── external-references/
    └── archive/
```

### Work Item Management

Use the framework's work item workflow:

1. **New items:** `thoughts/work/backlog/` (use framework templates)
2. **Planned:** `thoughts/work/todo/` (ready to start)
3. **In progress:** `thoughts/work/doing/` (limit: 1 per person)
4. **Completed:** `thoughts/work/done/`

### Creating Work Items

Use framework templates from [../framework/templates/work-items/](../framework/templates/work-items/):

- `FEAT-NNN-title.md` - New features
- `BUG-NNN-title.md` - Bug fixes
- `TECH-NNN-title.md` - Technical improvements
- `SPIKE-NNN-title.md` - Research/investigation

### Decision Making

Document architectural decisions using:
- Framework template: [../framework/templates/decisions/ADR-NNNN-title.md](../framework/templates/decisions/ADR-NNNN-title.md)
- Save to: `thoughts/research/adr/`

### Session History

Track work sessions using:
- Framework template: [../framework/templates/documentation/session-history-template.md](../framework/templates/documentation/session-history-template.md)
- Save to: `thoughts/history/sessions/YYYY-MM-DD-session-N.md`

## Communication Guidelines

- **Professional tone:** Objective, factual, solution-focused
- **Concise output:** CLI-friendly, markdown formatted
- **Avoid emojis:** Unless explicitly requested
- **No superlatives:** Focus on facts over praise
- **Question assumptions:** Investigate before confirming

## Project-Specific Context

### Technology Stack

- **Language:** JavaScript (Node.js)
- **Testing:** Jest (optional)
- **Dependencies:** None (minimal example)

### Key Files

- [src/hello-world.js](src/hello-world.js) - Main application
- [tests/hello-world.test.js](tests/hello-world.test.js) - Test suite
- [README.md](README.md) - Project overview
- [PROJECT-STATUS.md](PROJECT-STATUS.md) - Current status

### Development Guidelines

1. Keep it simple - this is a demonstration project
2. Follow framework conventions
3. Document any changes in CHANGELOG.md
4. Update PROJECT-STATUS.md when status changes
5. Use framework templates for all work items

## Quick Reference

- **Framework docs:** [../framework/](../framework/)
- **Templates:** [../framework/templates/](../framework/templates/)
- **Process guides:** [../framework/process/](../framework/process/)
- **Patterns:** [../framework/patterns/](../framework/patterns/)

## Version

**Last Updated:** 2026-01-06
**Framework Version:** 2.2.x

# {{PROJECT_NAME}}

**Version:** 0.1.0
**Last Updated:** {{DATE}}

---

## Overview

{{PROJECT_DESCRIPTION}}

---

## Quick Start

```powershell
# Example usage
.\src\Main.ps1
```

---

## Project Structure

```
{{PROJECT_NAME}}/
├── README.md                   # This file
├── PROJECT-STATUS.md           # Current version and status
├── CHANGELOG.md                # Version history
├── CLAUDE.md                   # AI assistant instructions
├── INDEX.md                    # Documentation navigation
├── framework.yaml              # Project configuration
│
├── framework/                  # Framework documentation and templates
│   ├── docs/                   # Collaboration guides, patterns, process docs
│   └── templates/              # Work item and documentation templates
│
├── src/                        # Source code
├── tests/                      # Test files
├── docs/                       # Project-specific documentation
│
└── project-hub/                   # Project thinking and workflow
    ├── work/                   # Kanban workflow
    │   ├── backlog/            # Future work (not yet committed)
    │   ├── todo/               # Committed next work
    │   ├── doing/              # Active work (WIP limit: 1)
    │   └── done/               # Completed, awaiting release
    ├── history/                # Session logs and archived releases
    │   ├── sessions/           # Daily session history files
    │   ├── releases/           # Archived work items by version
    │   ├── spikes/             # Completed research investigations
    │   └── archive/            # Superseded documents
    ├── research/               # Research and decisions
    │   └── adr/                # Architecture Decision Records
    ├── retrospectives/         # Project retrospectives
    └── external-references/    # Cached authoritative references
```

---

## Getting Started

See [QUICK-START.md](QUICK-START.md) for common operations and workflow reference.

### Key Documents

| Document | Purpose |
|----------|---------|
| [PROJECT-STATUS.md](PROJECT-STATUS.md) | Current version and feature status |
| [CHANGELOG.md](CHANGELOG.md) | Version history |
| [CLAUDE.md](CLAUDE.md) | AI assistant instructions |
| [framework/docs/collaboration/workflow-guide.md](framework/docs/collaboration/workflow-guide.md) | Work item workflow |

---

## Development

### Creating Work Items

```powershell
# Copy a feature template
Copy-Item framework/templates/work-items/FEAT-NNN-template.md project-hub/work/backlog/FEAT-001-feature-name.md

# Move through workflow (use git mv to preserve history)
git mv project-hub/work/backlog/FEAT-001-*.md project-hub/work/todo/
git mv project-hub/work/todo/FEAT-001-*.md project-hub/work/doing/
git mv project-hub/work/doing/FEAT-001-*.md project-hub/work/done/
```

### Making Decisions

```powershell
# Copy ADR template for architectural decisions
Copy-Item framework/templates/decisions/ADR-NNNN-template.md project-hub/research/adr/ADR-0001-decision-name.md
```

---

## License

[Your license here]

---

**Last Updated:** {{DATE}}

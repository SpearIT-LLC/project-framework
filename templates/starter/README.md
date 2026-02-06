# {{PROJECT_NAME}}

**Version:** 0.1.0
**Last Updated:** {{DATE}}

---

## Overview

{{PROJECT_DESCRIPTION}}

---

## Author

**{{AUTHOR_NAME}}** {{AUTHOR_EMAIL}}

> *Source of Truth: See `framework.yaml` → `project.author` for authoritative author information.*

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
├── PROJECT-STATUS.md           # Current version and status (SSOT)
├── CHANGELOG.md                # Version history
├── CLAUDE.md                   # AI assistant instructions
├── INDEX.md                    # Documentation navigation
├── QUICK-START.md              # Quick reference guide
├── framework.yaml              # Project configuration (SSOT for metadata)
│
├── src/                        # Source code
├── tests/                      # Test files
├── docs/                       # Project-specific documentation
│
├── framework/                  # Framework documentation and tools
│   ├── docs/                   # Collaboration guides, patterns, process
│   ├── templates/              # Work item and documentation templates
│   └── tools/                  # PowerShell workflow tools
│
└── project-hub/                # Project workflow and history (at root level)
    ├── work/                   # Active work items (Kanban workflow)
    │   ├── backlog/            # Future work (not yet committed)
    │   ├── todo/               # Committed next work
    │   ├── doing/              # Active work (WIP limit: 1-2)
    │   └── done/               # Completed, awaiting release
    ├── history/                # Completed work and history
    │   ├── sessions/           # Session history logs
    │   ├── releases/           # Released work items by version
    │   └── archive/            # Cancelled or superseded work
    ├── research/               # Research and ADRs
    ├── retrospectives/         # Project retrospectives
    └── external-references/    # Cached authoritative references
```

**See also:** [framework/docs/PROJECT-STRUCTURE.md](framework/docs/PROJECT-STRUCTURE.md) for complete specification

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
Copy-Item framework/templates/work-items/FEATURE-TEMPLATE.md project-hub/work/backlog/FEAT-001-feature-name.md

# Move through workflow (use git mv to preserve history)
git mv project-hub/work/backlog/FEAT-001-*.md project-hub/work/todo/
git mv project-hub/work/todo/FEAT-001-*.md project-hub/work/doing/
git mv project-hub/work/doing/FEAT-001-*.md project-hub/work/done/
```

### Making Decisions

```powershell
# Copy ADR template for architectural decisions
Copy-Item framework/templates/decisions/ADR-MINOR-TEMPLATE.md project-hub/research/adr/ADR-0001-decision-name.md
```

---

## License

[Your license here]

---

**Last Updated:** {{DATE}}

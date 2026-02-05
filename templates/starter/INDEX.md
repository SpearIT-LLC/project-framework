# {{PROJECT_NAME}} - Documentation Index

**Last Updated:** {{DATE}}

---

## Quick Links

| Document | Purpose |
|----------|---------|
| [README.md](README.md) | Project overview |
| [PROJECT-STATUS.md](PROJECT-STATUS.md) | Current version and status |
| [CHANGELOG.md](CHANGELOG.md) | Version history |
| [CLAUDE.md](CLAUDE.md) | AI assistant instructions |

---

## Root Documents

- **[README.md](README.md)** - Project overview and getting started
- **[PROJECT-STATUS.md](PROJECT-STATUS.md)** - Current version, feature status, pending work
- **[CHANGELOG.md](CHANGELOG.md)** - Version history (Keep a Changelog format)
- **[CLAUDE.md](CLAUDE.md)** - AI assistant instructions and conventions
- **[INDEX.md](INDEX.md)** - This file
- **[framework.yaml](framework.yaml)** - Machine-readable project configuration

---

## Framework Documentation

Location: `framework/`

### Collaboration Guides

Location: `framework/docs/collaboration/`

- **[workflow-guide.md](framework/docs/collaboration/workflow-guide.md)** - Work item lifecycle and kanban workflow

### Process Documentation

Location: `framework/docs/process/`

- **[version-control-workflow.md](framework/docs/process/version-control-workflow.md)** - Git workflow and release process

### Patterns

Location: `framework/docs/patterns/`

- Implementation patterns for common scenarios

### Templates

Location: `framework/templates/`

**Work Item Templates** (`framework/templates/work-items/`):
- `FEATURE-TEMPLATE.md` - Feature planning
- `BUG-TEMPLATE.md` - Bug fix documentation
- `TECHDEBT-TEMPLATE.md` - Technical improvements
- `SPIKE-TEMPLATE.md` - Research/investigation

**Decision Templates** (`framework/templates/decisions/`):
- `ADR-MINOR-TEMPLATE.md` - Architecture decision records
- `ADR-MAJOR-TEMPLATE.md` - Major architecture decisions

**Documentation Templates** (`framework/templates/documentation/`):
- Session history, changelog, and other documentation templates

**Research Templates** (`framework/templates/research/`):
- Problem statements, feasibility studies, project definitions

---

## Project Documentation

Location: `project-hub/`

### Active Work (Kanban)

Location: `project-hub/work/`

- **[backlog/](project-hub/work/backlog/)** - Future work (not yet committed)
- **[todo/](project-hub/work/todo/)** - Committed next work (limit: 10)
- **[doing/](project-hub/work/doing/)** - Active work (limit: 1)
- **[done/](project-hub/work/done/)** - Completed, awaiting release

### History

Location: `project-hub/history/`

- **[sessions/](project-hub/history/sessions/)** - Daily session history files
- **[releases/](project-hub/history/releases/)** - Archived work items by version
- **[spikes/](project-hub/history/spikes/)** - Completed research investigations
- **[archive/](project-hub/history/archive/)** - Superseded documents

### Research

Location: `project-hub/research/`

- **[adr/](project-hub/research/adr/)** - Architecture Decision Records

### Retrospectives

Location: `project-hub/retrospectives/`

- Project retrospectives after major milestones

### External References

Location: `project-hub/external-references/`

- Cached authoritative references (RFCs, specs, standards)

---

## Project-Specific Documentation

Location: `docs/`

- Add project documentation here as needed

---

## Navigation by Audience

### For Developers

1. [CLAUDE.md](CLAUDE.md) - Project conventions
2. [framework/docs/collaboration/workflow-guide.md](framework/docs/collaboration/workflow-guide.md) - Workflow
3. [PROJECT-STATUS.md](PROJECT-STATUS.md) - Current status

### For AI Assistants

1. [CLAUDE.md](CLAUDE.md) - Primary instructions
2. [framework.yaml](framework.yaml) - Project configuration
3. [framework/](framework/) - Framework documentation

---

## Search Tips

**Find by work item ID:**
```powershell
Get-ChildItem -Recurse project-hub/work -Filter "*FEAT-001*"
```

**Find all ADRs:**
```powershell
Get-ChildItem project-hub/research/adr/
```

**Find recent session histories:**
```powershell
Get-ChildItem project-hub/history/sessions/ | Sort-Object LastWriteTime -Descending | Select-Object -First 5
```

---

**Last Updated:** {{DATE}}

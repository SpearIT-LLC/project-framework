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
- `FEAT-NNN-template.md` - Feature planning
- `BUG-NNN-template.md` - Bug fix documentation
- `TECH-NNN-template.md` - Technical improvements
- `SPIKE-NNN-template.md` - Research/investigation

**Decision Templates** (`framework/templates/decisions/`):
- `ADR-NNNN-template.md` - Architecture decision records

**Documentation Templates** (`framework/templates/documentation/`):
- `session-history-template.md` - Daily session logs

**Research Templates** (`framework/templates/research/`):
- Problem statements, feasibility studies, project definitions

---

## Project Documentation

Location: `thoughts/`

### Active Work (Kanban)

Location: `thoughts/work/`

- **[backlog/](thoughts/work/backlog/)** - Future work (not yet committed)
- **[todo/](thoughts/work/todo/)** - Committed next work (limit: 10)
- **[doing/](thoughts/work/doing/)** - Active work (limit: 1)
- **[done/](thoughts/work/done/)** - Completed, awaiting release

### History

Location: `thoughts/history/`

- **[sessions/](thoughts/history/sessions/)** - Daily session history files
- **[releases/](thoughts/history/releases/)** - Archived work items by version
- **[spikes/](thoughts/history/spikes/)** - Completed research investigations
- **[archive/](thoughts/history/archive/)** - Superseded documents

### Research

Location: `thoughts/research/`

- **[adr/](thoughts/research/adr/)** - Architecture Decision Records

### Retrospectives

Location: `thoughts/retrospectives/`

- Project retrospectives after major milestones

### External References

Location: `thoughts/external-references/`

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
Get-ChildItem -Recurse thoughts/work -Filter "*FEAT-001*"
```

**Find all ADRs:**
```powershell
Get-ChildItem thoughts/research/adr/
```

**Find recent session histories:**
```powershell
Get-ChildItem thoughts/history/sessions/ | Sort-Object LastWriteTime -Descending | Select-Object -First 5
```

---

**Last Updated:** {{DATE}}

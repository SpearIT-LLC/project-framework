# Project Thoughts & Tracking

This directory contains the project's tracking structure, following the Standard Project Framework.

## Structure

```
project-hub/
├── work/                 # Work item workflow
│   ├── backlog/         # Future work (unscheduled)
│   ├── todo/            # Ready to start (planned, max 10)
│   ├── doing/           # In progress (limit: 1 per person)
│   └── done/            # Completed work
├── history/             # Historical records
│   ├── releases/        # Release notes and history
│   ├── sessions/        # Session-by-session history
│   └── spikes/          # Spike/POC results
├── research/            # Research and decisions
│   └── adr/            # Architectural Decision Records
├── retrospectives/      # Retrospective notes
├── reference/          # Project reference materials
├── external-references/ # Links to external resources
└── archive/            # Archived content
```

## Workflow

### Work Items

1. **Create:** Use framework templates from [../../framework/templates/work-items/](../../framework/templates/work-items/)
2. **Backlog:** New items start in `work/backlog/`
3. **Plan:** Move to `work/todo/` when ready (max 10 items)
4. **Start:** Move to `work/doing/` when starting (limit: 1 per person)
5. **Complete:** Move to `work/done/` when finished

### Decisions

- Use ADR template: [../../framework/templates/decisions/ADR-NNNN-title.md](../../framework/templates/decisions/ADR-NNNN-title.md)
- Save to: `research/adr/`

### Sessions

- Use session template: [../../framework/templates/documentation/session-history-template.md](../../framework/templates/documentation/session-history-template.md)
- Save to: `history/sessions/YYYY-MM-DD-session-N.md`

## Framework Integration

This structure follows the [Standard Project Framework](../../framework/). See framework documentation for:

- Templates: [../../framework/templates/](../../framework/templates/)
- Process: [../../framework/process/](../../framework/process/)
- Patterns: [../../framework/collaboration/](../../framework/collaboration/)

## Getting Started

1. Review framework workflows: [../../framework/process/](../../framework/process/)
2. Use framework templates: [../../framework/templates/](../../framework/templates/)
3. Follow WIP limits (doing: 1, todo: 10)
4. Document decisions as ADRs
5. Track sessions in history/

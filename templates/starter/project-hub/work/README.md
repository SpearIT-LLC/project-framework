# Work Items (Kanban Board)

This folder implements a file-based Kanban workflow for tracking work items.

## Workflow

```
backlog/ → todo/ → doing/ → done/ → history/releases/vX.Y.Z/
```

## Folders

| Folder | Purpose | WIP Limit |
|--------|---------|-----------|
| `backlog/` | Future work ideas, not yet committed | None |
| `todo/` | Committed work for upcoming development | 10 |
| `doing/` | Currently active work (focus!) | **1** |
| `done/` | Completed work awaiting release | None |

## Rules

1. **One at a time**: Only 1 item in `doing/` at once
2. **Use git mv**: Move files with `git mv` to preserve history
3. **Templates**: Copy from `framework/templates/work-items/`

## Moving Work Items

```powershell
# Move to next stage
git mv backlog/FEAT-001-*.md todo/
git mv todo/FEAT-001-*.md doing/
git mv doing/FEAT-001-*.md done/

# Archive after release
git mv done/*.md ../history/releases/v1.0.0/
```

## Templates

- `FEATURE-TEMPLATE.md` - New features
- `BUG-TEMPLATE.md` - Bug fixes
- `TECHDEBT-TEMPLATE.md` - Technical improvements
- `SPIKE-TEMPLATE.md` - Research/investigation
- `DECISION-TEMPLATE.md` - Decisions requiring documentation

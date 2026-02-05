# Quick Start Guide

**Purpose:** Quick reference for working with this project's framework.

**Last Updated:** {{DATE}}

---

## Common Operations

### Start New Feature

```powershell
# Copy template
Copy-Item framework/templates/work-items/FEATURE-TEMPLATE.md project-hub/work/backlog/FEAT-001-name.md

# Edit the file, then move through workflow
git mv project-hub/work/backlog/FEAT-001-*.md project-hub/work/todo/
git mv project-hub/work/todo/FEAT-001-*.md project-hub/work/doing/
git mv project-hub/work/doing/FEAT-001-*.md project-hub/work/done/
```

### Fix a Bug

```powershell
Copy-Item framework/templates/work-items/BUG-TEMPLATE.md project-hub/work/backlog/BUG-001-name.md
# Move through workflow: backlog → todo → doing → done
```

### Make Architectural Decision

```powershell
Copy-Item framework/templates/decisions/ADR-MINOR-TEMPLATE.md project-hub/research/adr/ADR-0001-name.md
```

### Create Release

```powershell
# 1. Update CHANGELOG.md with changes
# 2. Update PROJECT-STATUS.md with new version
# 3. Commit and tag
git add -A
git commit -m "Release: vX.Y.Z"
git tag vX.Y.Z
git push origin main --tags

# 4. Archive completed work
git mv project-hub/work/done/*.md project-hub/history/releases/vX.Y.Z/
```

### End of Day

```powershell
Copy-Item framework/templates/documentation/SESSION-HISTORY-TEMPLATE.md project-hub/history/sessions/$(Get-Date -Format 'yyyy-MM-dd')-SESSION-HISTORY.md
# Document what you did, decisions made, blockers
```

---

## Workflow

```
project-hub/work/backlog/ → todo/ → doing/ → done/ → history/releases/vX.Y.Z/
```

| Folder | Purpose | Limit |
|--------|---------|-------|
| `backlog/` | Future work, not committed | None |
| `todo/` | Committed next work | 10 |
| `doing/` | Active work (focus!) | 1 |
| `done/` | Completed, awaiting release | None |

---

## Key Rules

- **Single Source of Truth:** Version and status ONLY in [PROJECT-STATUS.md](PROJECT-STATUS.md)
- **WIP Limit:** Max 1 item in `doing/` at once (check `.limit` file)
- **Use git mv:** For moving work items (preserves history)
- **Semantic Versioning:** MAJOR.MINOR.PATCH (breaking.feature.bugfix)

---

## Templates Reference

| Template | Use When | Location |
|----------|----------|----------|
| FEATURE | New feature | `framework/templates/work-items/` |
| BUG | Bug fix | `framework/templates/work-items/` |
| TECHDEBT | Technical improvement | `framework/templates/work-items/` |
| SPIKE | Research/investigation | `framework/templates/work-items/` |
| ADR | Architectural decision | `framework/templates/decisions/` |
| Session history | End of day | `framework/templates/documentation/` |

---

## Framework Commands (AI Assistants)

| Command | Description |
|---------|-------------|
| `/fw-help` | List available commands |
| `/fw-move` | Move work item between folders |
| `/fw-status` | Show project status |
| `/fw-wip` | Check WIP limits |
| `/fw-backlog` | Review backlog items |

---

## Troubleshooting

**"Lost in the workflow"**
→ Think: backlog (someday) → todo (planned) → doing (now, max 1) → done (shipped)

**"When do I create an ADR?"**
→ When you choose between 2+ approaches OR make a decision future-you needs context for

**"Too much overhead"**
→ Skip what doesn't help. The framework serves you, not the other way around.

---

## Key Documents

| Document | Purpose |
|----------|---------|
| [PROJECT-STATUS.md](PROJECT-STATUS.md) | Version and status (SsoT) |
| [CHANGELOG.md](CHANGELOG.md) | Version history |
| [CLAUDE.md](CLAUDE.md) | AI assistant instructions |
| [framework/docs/collaboration/workflow-guide.md](framework/docs/collaboration/workflow-guide.md) | Detailed workflow |

---

**Last Updated:** {{DATE}}

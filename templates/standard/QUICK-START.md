# Quick Start Guide

**Purpose:** Quick reference for working with this project's framework.

**Last Updated:** {{DATE}}

---

## Common Operations

### Start New Feature

```powershell
# Copy template
Copy-Item framework/templates/work-items/FEAT-NNN-template.md thoughts/work/backlog/FEAT-001-name.md

# Edit the file, then move through workflow
git mv thoughts/work/backlog/FEAT-001-*.md thoughts/work/todo/
git mv thoughts/work/todo/FEAT-001-*.md thoughts/work/doing/
git mv thoughts/work/doing/FEAT-001-*.md thoughts/work/done/
```

### Fix a Bug

```powershell
Copy-Item framework/templates/work-items/BUG-NNN-template.md thoughts/work/backlog/BUG-001-name.md
# Move through workflow: backlog → todo → doing → done
```

### Make Architectural Decision

```powershell
Copy-Item framework/templates/decisions/ADR-NNNN-template.md thoughts/research/adr/ADR-0001-name.md
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
git mv thoughts/work/done/*.md thoughts/history/releases/vX.Y.Z/
```

### End of Day

```powershell
Copy-Item framework/templates/documentation/session-history-template.md thoughts/history/sessions/2026-01-21-SESSION-HISTORY.md
# Document what you did, decisions made, blockers
```

---

## Workflow

```
thoughts/work/backlog/ → todo/ → doing/ → done/ → history/releases/vX.Y.Z/
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
| FEAT-NNN | New feature | `framework/templates/work-items/` |
| BUG-NNN | Bug fix | `framework/templates/work-items/` |
| TECH-NNN | Technical improvement | `framework/templates/work-items/` |
| SPIKE-NNN | Research/investigation | `framework/templates/work-items/` |
| ADR-NNNN | Architectural decision | `framework/templates/decisions/` |
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

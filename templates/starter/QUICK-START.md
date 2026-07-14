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

## Templates

Work item templates live in `framework/templates/work-items/`; ADR templates in
`framework/templates/decisions/`; session history in `framework/templates/documentation/`.

**Accepted work item types** are the single source of truth in
[.claude/scripts/work-item-types.txt](.claude/scripts/work-item-types.txt) — creation is enforced
against it, so it cannot drift. **When to use each** is explained in
[workflow-guide.md](framework/docs/collaboration/workflow-guide.md#work-item-templates). Or just ask
the AI to create the item and it will pick the type and template.

---

## Framework Commands (AI Assistants)

Framework commands (`/fw-*`) are shortcuts for common workflow operations. Run `/fw-help` to list
what is available in this project — it reads the installed commands, so it is never out of date.

**Full reference:** [framework/docs/ref/framework-commands.md](framework/docs/ref/framework-commands.md)

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

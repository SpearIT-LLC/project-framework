# Claude Context: {{PROJECT_NAME}}

> **BOOTSTRAP BLOCK - Execute on every session start**
>
> 1. **Ask:** "What kind of work are we doing today?" (unless user already stated intent)
> 2. **Read:** `framework.yaml` → check project configuration
> 3. **On work item actions** (move, create, status change): Use `git mv` for file operations in `project-hub/work/`
> 4. **Before writing code:** State what you plan to do and wait for approval

**Last Updated:** {{DATE}}

---

## Epistemic Standards

**Facts must be verified before stating.** Read the file, run the command, check the source. If you cannot verify, say so explicitly.

**Interpretation and opinions are welcome** but must be clearly labeled ("I believe...", "This suggests...", "My interpretation is...").

---

## Project Configuration

Read `framework.yaml` at the project root for machine-readable project context.

---

## What This Project Does

{{PROJECT_DESCRIPTION}}

---

## Key Documents (Sources of Truth)

| Document | Purpose |
|----------|---------|
| [PROJECT-STATUS.md](PROJECT-STATUS.md) | Version and status (SsoT) |
| [CHANGELOG.md](CHANGELOG.md) | Version history |
| [framework.yaml](framework.yaml) | Project configuration |

---

## Framework Documentation

| Topic | Document |
|-------|----------|
| Work item workflow | [framework/docs/collaboration/workflow-guide.md](framework/docs/collaboration/workflow-guide.md) |
| Git and releases | [framework/docs/process/version-control-workflow.md](framework/docs/process/version-control-workflow.md) |
| Templates | [framework/templates/](framework/templates/) |

---

## Project Structure

```
{{PROJECT_NAME}}/
├── framework/              # Framework docs and templates (vendored)
├── src/                    # Source code
├── tests/                  # Test files
├── docs/                   # Project documentation
└── project-hub/
    ├── work/               # Kanban: backlog → todo → doing → done
    ├── history/            # Sessions, releases, archive
    ├── research/           # ADRs and investigations
    ├── retrospectives/     # Project retrospectives
    └── external-references/# Cached authoritative references
```

---

## Workflow Quick Reference

**Work item flow:** `project-hub/work/backlog/` → `todo/` → `doing/` → `done/`

**WIP Limits:** `doing/` = 1, `todo/` = 10

**Templates:** Copy from `framework/templates/work-items/`

---

## Project-Specific Notes

[Add coding standards, architecture decisions, and conventions specific to this project]

---

**Last Updated:** {{DATE}}

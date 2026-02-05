# Claude Context: SpearIT Project Framework

> **BOOTSTRAP BLOCK - Execute on every session start**
>
> 1. **Ask:** "What kind of work are we doing today?" (unless user already stated intent)
> 2. **Read:** `framework.yaml` → check `roles.default` for your starting role
> 3. **On work item actions** (move, create, status change): Read `policies.onTransition` BEFORE acting
> 4. **On file operations in `project-hub/work/`**: Use `git mv`, never `Move-Item` or `cp`
> 5. **Before writing code:** State what you plan to do and wait for approval

This file provides navigation and context for AI assistants working in this framework source repository.

**Last Updated:** 2026-01-17

---

## Epistemic Standards

**Facts must be verified before stating.** Read the file, run the command, check the source. If you cannot verify, say so explicitly.

**Interpretation and opinions are welcome** but must be clearly labeled ("I believe...", "This suggests...", "My interpretation is...").

**Never present inference as fact.** If a source is referenced, it must have been read. When verification fails (file missing, command errors, etc.), report the failure rather than silently falling back to guessing.

---

## Project Configuration

Read `framework.yaml` at the repo root for machine-readable project context. See [framework/docs/ref/framework-schema.yaml](framework/docs/ref/framework-schema.yaml) for valid values and field descriptions.

Use these values to understand project context rather than inferring from structure.

---

## Repository Structure

```
project-framework/
├── framework/                   # The Standard Project Framework itself
├── templates/                   # Template packages for new projects
├── tools/                       # Build and setup scripts
├── README.md                    # Repository overview and getting started
├── QUICK-START.md              # Quick reference guide
└── CLAUDE.md                   # This file - Repository navigation
```

---

## Which Project Are You Working On?

### Working on the Framework Itself?

**Read:** [framework/CLAUDE.md](framework/CLAUDE.md)

The framework project contains:
- Process documentation ([framework/docs/process/](framework/docs/process/))
- Collaboration guides ([framework/docs/collaboration/](framework/docs/collaboration/))
- Templates ([framework/templates/](framework/templates/))
- Patterns ([framework/docs/patterns/](framework/docs/patterns/))
- Framework work items and history ([project-hub/](project-hub/))

### Working on Template Packages?

**Location:** [templates/](templates/)

This folder contains the `starter/` template for creating new projects. The template provides complete project scaffolding with framework included (framework-as-dependency model per DECISION-050).

---

## Repository Workflow

### Understanding the Separation

- **framework/** = The framework documentation, process, templates, and tracking
- **templates/** = Packages for bootstrapping new projects
- **tools/** = Build scripts for creating distribution archives

### Where Do Changes Go?

- **Framework improvements** → Work in [framework/](framework/)
- **Template updates** → Work in [templates/](templates/)
- **Build tooling** → Work in [tools/](tools/)

### Work Item Tracking

Framework work items: [project-hub/work/](project-hub/work/)

**Current active work:** Always check `project-hub/work/doing/` for in-progress framework improvements.

---

## First Time in This Repo?

1. **Read** [README.md](README.md) - Understand what the framework is
2. **Read** [framework/CLAUDE.md](framework/CLAUDE.md) - Framework-specific context
3. **Check** [project-hub/work/doing/](project-hub/work/doing/) - See what's in progress
4. **Consult** [framework/collaboration/](framework/collaboration/) - Detailed collaboration guides

---

## Quick Reference

- **Framework status:** [framework/PROJECT-STATUS.md](framework/PROJECT-STATUS.md)
- **Framework changelog:** [framework/CHANGELOG.md](framework/CHANGELOG.md)
- **Quick start guide:** [QUICK-START.md](QUICK-START.md)
- **New project setup:** [templates/NEW-PROJECT-CHECKLIST.md](templates/NEW-PROJECT-CHECKLIST.md)

---

**Remember:** This repository is the framework source. Use `templates/starter/` to create new projects via the distribution archive.

---

**Last Updated:** 2026-01-26
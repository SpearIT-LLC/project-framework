# Claude Context: SpearIT Project Framework (Monorepo)

This file provides navigation and context for AI assistants working in this monorepo.

**Last Updated:** 2026-01-06

---

## Monorepo Structure

This repository contains multiple related projects:

```
project-framework/
├── framework/                   # The Standard Project Framework itself
├── project-hello-world/         # Reference implementation (example project)
├── project-templates/           # Template packages for new projects
├── README.md                    # Monorepo overview and getting started
├── QUICK-START.md              # Quick reference guide
└── CLAUDE.md                   # This file - Monorepo navigation
```

---

## Which Project Are You Working On?

### Working on the Framework Itself?

**Read:** [framework/CLAUDE.md](framework/CLAUDE.md)

The framework project contains:
- Process documentation ([framework/process/](framework/process/))
- Collaboration guides ([framework/collaboration/](framework/collaboration/))
- Templates ([framework/templates/](framework/templates/))
- Patterns ([framework/patterns/](framework/patterns/))
- Framework work items and history ([framework/thoughts/](framework/thoughts/))

### Working on the Hello World Example?

**Read:** [project-hello-world/CLAUDE.md](project-hello-world/CLAUDE.md)

The hello-world project is a reference implementation showing how to use the framework.

### Working on Template Packages?

**Location:** [project-templates/](project-templates/)

This folder contains template packages for creating new projects at different framework levels:
- Minimal (single scripts)
- Light (small tools)
- Standard (full applications)

These are starter templates that users copy to begin new projects.

---

## Monorepo Workflow

### Understanding the Separation

- **framework/** = The framework documentation, process, templates, and tracking
- **project-hello-world/** = An example project that uses the framework
- **project-templates/** = Packages for bootstrapping new projects

### Where Do Changes Go?

- **Framework improvements** → Work in [framework/](framework/)
- **Example updates** → Work in [project-hello-world/](project-hello-world/)
- **Template updates** → Work in [project-templates/](project-templates/)

### Work Item Tracking

Each project has its own thoughts/ structure:

- Framework work items: [framework/thoughts/work/](framework/thoughts/work/)
- Hello-world work items: [project-hello-world/thoughts/work/](project-hello-world/thoughts/work/)

**Current active work:** Always check `framework/thoughts/work/doing/` for in-progress framework improvements.

---

## First Time in This Repo?

1. **Read** [README.md](README.md) - Understand what the framework is
2. **Read** [framework/CLAUDE.md](framework/CLAUDE.md) - Framework-specific context
3. **Check** [framework/thoughts/work/doing/](framework/thoughts/work/doing/) - See what's in progress
4. **Consult** [framework/collaboration/](framework/collaboration/) - Detailed collaboration guides

---

## Quick Reference

- **Framework status:** [framework/PROJECT-STATUS.md](framework/PROJECT-STATUS.md)
- **Framework changelog:** [framework/CHANGELOG.md](framework/CHANGELOG.md)
- **Quick start guide:** [QUICK-START.md](QUICK-START.md)
- **Template selection:** [project-templates/README-TEMPLATE-SELECTION.md](project-templates/README-TEMPLATE-SELECTION.md)

---

**Remember:** This is a monorepo. Always identify which project you're working on before making changes.
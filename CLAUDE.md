# Claude Context: SpearIT Project Framework

This file provides navigation and context for AI assistants working in this framework source repository.

**Last Updated:** 2026-01-14 (Added Epistemic Standards section)

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

This repository contains multiple related projects:

```
project-framework/
├── framework/                   # The Standard Project Framework itself
├── examples/hello-world/        # Reference implementation (example project)
├── templates/           # Template packages for new projects
├── README.md                    # Repository overview and getting started
├── QUICK-START.md              # Quick reference guide
└── CLAUDE.md                   # This file - Repository navigation
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

**Read:** [examples/hello-world/CLAUDE.md](examples/hello-world/CLAUDE.md)

The hello-world project is a reference implementation showing how to use the framework.

### Working on Template Packages?

**Location:** [templates/](templates/)

This folder contains template packages for creating new projects at different framework levels:
- Minimal (single scripts)
- Light (small tools)
- Standard (full applications)

These are starter templates that users copy to begin new projects.

---

## Repository Workflow

### Understanding the Separation

- **framework/** = The framework documentation, process, templates, and tracking
- **examples/hello-world/** = An example project that uses the framework
- **templates/** = Packages for bootstrapping new projects

### Where Do Changes Go?

- **Framework improvements** → Work in [framework/](framework/)
- **Example updates** → Work in [examples/hello-world/](examples/hello-world/)
- **Template updates** → Work in [templates/](templates/)

### Work Item Tracking

Each project has its own thoughts/ structure:

- Framework work items: [framework/thoughts/work/](framework/thoughts/work/)
- Hello-world work items: [examples/hello-world/thoughts/work/](examples/hello-world/thoughts/work/)

**Current active work:** Always check `framework/thoughts/work/doing/` for in-progress framework improvements.

### Context Switching (Important!)

**Work items must be created in the correct project:**
- Issues about the framework itself → `framework/thoughts/work/`
- Issues about the hello-world example → `examples/hello-world/thoughts/work/`
- Issues about template packages → `templates/thoughts/work/`

**To switch project context:**
1. User explicitly states which project (e.g., "switch to examples/hello-world")
2. AI reads that project's CLAUDE.md and understands context
3. All subsequent work items go in that project's thoughts/work/ folder

**When referencing work items:**
- Work item location implies project context
- "Work on FEAT-039" → Check where FEAT-039 exists → Use that project's context
- Cross-project references should be explicit: "Create a work item in hello-world for X"

**Note:** A more robust solution using project-config.yaml files is being designed in [framework/thoughts/work/backlog/FEAT-037-project-config-file.md](framework/thoughts/work/backlog/FEAT-037-project-config-file.md). This interim guidance will be superseded when that feature is implemented.

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
- **Template selection:** [templates/README-TEMPLATE-SELECTION.md](templates/README-TEMPLATE-SELECTION.md)

---

**Remember:** This repository contains multiple projects. Always identify which project you're working on before making changes.

---

**Last Updated:** 2026-01-14
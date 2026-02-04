# Standard Project Framework

**Version:** See [PROJECT-STATUS.md](PROJECT-STATUS.md)
**Last Updated:** 2026-01-19
**Organization:** SpearIT, LLC

---

## What Is This?

The **SpearIT Project Framework** is a file-based workflow and AI collaboration partner for solo developers and small teams building software or documentation projects.

---

## Key Features

**Research-Driven Development**
- Built-in research phase with 5 templates
- Validate problem before investing in solution
- Answer: "Are we recreating the wheel, or do we have something useful to add?"

**File-Based Kanban Workflow**
- Simple folder-based work tracking
- Flow: backlog → todo → doing → done → history/releases/
- No external tools required

**AI Integration**
- CLAUDE.md templates help Claude Code understand your project
- `framework.yaml` provides machine-readable project configuration
- Context-aware AI roles (scrum-master, developer, architect, etc.)
- Explicit role activation: "Adopt the scrum master role"
- Claude Command Framework (`/fw-*` commands) for workflow operations
- Consistent structure improves AI assistance quality

**Claude Commands (`/fw-*`)**
- `/fw-help` - Discover available framework commands
- `/fw-move` - Move work items with policy enforcement
- `/fw-status` - Show project status summary
- `/fw-wip` - Check WIP limit status
- `/fw-backlog` - Review and prioritize backlog items

**19 Production Templates**
- Planning, work items, decisions, research
- Copy-paste starting points
- Consistent structure across projects

**PowerShell CMD Wrappers**
- Four production-ready CMD wrapper templates
- Let users double-click PowerShell scripts in Windows
- Professional deployment ready

---

## Framework Structure

This folder contains the Standard Framework implementation:

```
framework/
├── README.md                    # This file - Framework overview
├── PROJECT-STATUS.md            # Current framework version & status
├── CHANGELOG.md                 # Version history
├── CLAUDE.md                    # AI collaboration guide
├── INDEX.md                     # Documentation index
├── framework.yaml               # Project configuration (machine-readable)
├── docs/                        # Framework documentation
│   ├── collaboration/           # Universal collaboration guides
│   ├── ref/                     # Reference material (schemas, role definitions)
│   ├── PROJECT-STRUCTURE-*.md   # Structure specifications
│   └── REPOSITORY-STRUCTURE.md  # Repository structure
├── templates/                   # 19 framework templates
├── patterns/                    # Implementation patterns
└── project-hub/                    # Framework development tracking
    ├── work/                    # Framework work items (kanban)
    ├── research/                # Framework ADRs
    ├── retrospectives/          # Framework retrospectives
    └── history/                 # Framework session & release history
```

---

## Quick Start

**For Repository Overview:**
See [../README.md](../README.md) for repository structure and getting started.

**For New Projects:**
1. Follow [../templates/NEW-PROJECT-CHECKLIST.md](../templates/NEW-PROJECT-CHECKLIST.md)
2. Customize templates with your project details

**To Create a New Project:**
Use `../tools/Build-FrameworkArchive.ps1` to create a distribution, then run `Setup-Project.ps1` to scaffold a new project.

---

## Documentation

**Core Documentation:**
- [PROJECT-STATUS.md](PROJECT-STATUS.md) - Current version & status
- [CHANGELOG.md](CHANGELOG.md) - Version history
- [INDEX.md](INDEX.md) - Complete documentation index
- [CLAUDE.md](CLAUDE.md) - AI collaboration guide

**Key Documentation:**
- [docs/collaboration/](docs/collaboration/) - Universal collaboration guides (humans & AI)
- [docs/PROJECT-STRUCTURE.md](docs/PROJECT-STRUCTURE.md) - Project structure specification

**Templates:**
- [templates/](templates/) - 19 production-ready templates
- Copy templates, don't edit them directly
- Use for planning, work items, decisions, research

**Process Documentation:**
- [process/](process/) - Workflow and process guides

---

## Philosophy

**Core Principles:**

1. **Research Before Build** - Validate problem before investing in solution
2. **Single Source of Truth** - PROJECT-STATUS.md for version/status (never duplicate)
3. **Incremental Development** - One work item at a time, verify alignment
4. **Document Deviations** - Customizations documented in CLAUDE.md
5. **Progressive Adoption** - Start simple, add structure as value becomes clear

**Workflow Phases:**

All projects follow this core workflow:
1. Research/Explore - Validate problem and solution space
2. Define - Establish boundaries and success criteria
3. Plan - Design implementation approach
4. Code - Implement incrementally
5. Commit/Release - Ship the value

---

## Dogfooding

**Meta Note:** This framework manages itself using its own workflow system.

This serves as:
1. **Validation** - Proves framework works for framework development
2. **Example** - Real-world example of framework usage
3. **Improvement** - Surfaces pain points and areas for enhancement

Check [project-hub/](project-hub/) to see the framework in action on itself.

---

## Support

**Maintainer:** Gary Elliott (gary.elliott@spearit.solutions)
**Organization:** SpearIT, LLC
**Documentation:** See [INDEX.md](INDEX.md) for complete navigation

---

**Get Started:** [../README.md](../README.md) → [../templates/NEW-PROJECT-CHECKLIST.md](../templates/NEW-PROJECT-CHECKLIST.md)

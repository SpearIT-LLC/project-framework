# Standard Project Framework

**Version:** See [PROJECT-STATUS.md](PROJECT-STATUS.md)
**Last Updated:** 2026-01-11
**Organization:** SpearIT, LLC

---

## What Is This?

This is the **Standard Project Framework** - a comprehensive, multi-level project management framework designed to bring structure, consistency, and AI integration to software projects of any size.

The framework provides three scaling levels (Minimal, Light, Standard) that adapt to your project's scope, lifespan, and team size.

---

## Key Features

**Multi-Level Scaling**
- Choose the right amount of structure for your project
- Start small, upgrade as your project grows
- Three levels: Minimal (2 files) → Light (7 files) → Standard (50+ files)

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
- Consistent structure improves AI assistance quality
- Framework-aware AI can navigate documentation

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
├── docs/                        # Framework documentation
│   ├── collaboration/           # Universal collaboration guides
│   ├── PROJECT-STRUCTURE-*.md   # Structure specifications
│   └── REPOSITORY-STRUCTURE.md  # Monorepo structure
├── process/                     # Workflow documentation
├── templates/                   # 19 framework templates
├── patterns/                    # Implementation patterns
└── thoughts/                    # Framework development tracking
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
1. Read [../templates/README-TEMPLATE-SELECTION.md](../templates/README-TEMPLATE-SELECTION.md)
2. Choose your framework level (Minimal, Light, or Standard)
3. Follow [../templates/NEW-PROJECT-CHECKLIST.md](../templates/NEW-PROJECT-CHECKLIST.md)

**For Reference Implementation:**
See [../examples/hello-world/](../examples/hello-world/) for a complete Standard framework example.

---

## Documentation

**Core Documentation:**
- [PROJECT-STATUS.md](PROJECT-STATUS.md) - Current version & status
- [CHANGELOG.md](CHANGELOG.md) - Version history
- [INDEX.md](INDEX.md) - Complete documentation index
- [CLAUDE.md](CLAUDE.md) - AI collaboration guide

**Key Documentation:**
- [docs/collaboration/](docs/collaboration/) - Universal collaboration guides (humans & AI)
- [docs/PROJECT-STRUCTURE-STANDARD.md](docs/PROJECT-STRUCTURE-STANDARD.md) - Standard level structure spec
- [docs/PROJECT-STRUCTURE-LIGHT.md](docs/PROJECT-STRUCTURE-LIGHT.md) - Light level structure spec
- [docs/PROJECT-STRUCTURE-MINIMAL.md](docs/PROJECT-STRUCTURE-MINIMAL.md) - Minimal level structure spec

**Templates:**
- [templates/](templates/) - 19 production-ready templates
- Copy templates, don't edit them directly
- Use for planning, work items, decisions, research

**Process Documentation:**
- [process/](process/) - Workflow and process guides

---

## Philosophy

**Core Principles:**

1. **Right-Sized Framework** - Use appropriate structure for project size
2. **Research Before Build** - Validate problem before investing in solution
3. **Single Source of Truth** - PROJECT-STATUS.md for version/status (never duplicate)
4. **Incremental Development** - One work item at a time, verify alignment
5. **Document Deviations** - Customizations documented in CLAUDE.md

**Workflow Phases:**

All projects follow this core workflow:
1. Research/Explore - Validate problem and solution space
2. Define - Establish boundaries and success criteria
3. Plan - Design implementation approach
4. Code - Implement incrementally
5. Commit/Release - Ship the value

Depth varies by framework level.

---

## Dogfooding

**Meta Note:** This framework uses its own Standard framework for development.

This serves as:
1. **Validation** - Proves framework works for framework development
2. **Example** - Real-world example of framework usage
3. **Improvement** - Surfaces pain points and areas for enhancement

Check [thoughts/](thoughts/) to see the framework in action on itself.

---

## Support

**Maintainer:** Gary Elliott (gary.elliott@spearit.solutions)
**Organization:** SpearIT, LLC
**Documentation:** See [INDEX.md](INDEX.md) for complete navigation

---

**Get Started:** [../README.md](../README.md) → [../templates/README-TEMPLATE-SELECTION.md](../templates/README-TEMPLATE-SELECTION.md)

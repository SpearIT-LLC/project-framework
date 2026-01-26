# Project Framework Template Structure

**Last Updated:** 2025-12-19
**Version:** 2.0.0

---

## Overview

This document shows the actual structure of the project framework template package.

---

## Top-Level Structure

```
project-framework-template/
├── README.md                       # Package overview and quick start
├── README-TEMPLATE-SELECTION.md    # Guide to choosing framework level
├── NEW-PROJECT-CHECKLIST.md        # Setup instructions for all levels
├── UPGRADE-PATH.md                 # How to upgrade between levels
├── STRUCTURE.md                    # This file
│
├── minimal/                        # Single script framework (2 files)
├── light/                          # Small tool framework (7 files)
└── standard/                       # Full application framework (50+ files)
```

**Note:** Guide documents (README-TEMPLATE-SELECTION.md, NEW-PROJECT-CHECKLIST.md, etc.) are at package root. Template files are organized in framework-level folders (minimal/, light/, standard/).

---

## Minimal Framework Structure

**For:** Single scripts, throwaway projects, personal automation

```
minimal/
├── README.md           # Template with "Why This Script Exists" section
└── .gitignore          # Basic gitignore for scripts
```

**File count:** 2 files

---

## Light Framework Structure

**For:** Small tools, medium lifespan, solo with handoff expected

```
light/
├── README.md                           # Detailed project README
├── PROJECT-STATUS.md                   # Version tracking
├── CHANGELOG.md                        # Change history
├── CLAUDE.md                           # Optional 1-page project guide
├── .gitignore                          # Standard gitignore
│
└── project-hub/
    └── project/
        ├── history/
        │   └── .gitkeep                # Session notes go here
        │
        └── research/
            └── justification-template.md   # Simple research justification
```

**File count:** 7 files

---

## Standard Framework Structure

**For:** Applications, ongoing maintenance, teams, critical systems

```
standard/
├── README.md                           # Complete project README
├── CLAUDE.md                           # Full project-specific guide
├── PROJECT-STATUS.md                   # Detailed status tracking
├── CHANGELOG.md                        # Keep a Changelog format
├── INDEX.md                            # Documentation navigation
├── .gitignore                          # Comprehensive gitignore
│
└── project-hub/
    ├── framework/                      # Reusable framework (shared across projects)
    │   ├── FRAMEWORK-CHANGELOG.md      # Framework evolution tracking
    │   │
    │   ├── collaboration/              # Workflow and collaboration guides
    │   │   └── workflow-guide.md
    │   │
    │   ├── process/                    # How-to-work documentation
    │   │   ├── documentation-standards.md
    │   │   └── version-control-workflow.md
    │   │
    │   ├── templates/                  # Document and code templates
    │   │   ├── ADMIN-QUICK-START-TEMPLATE.md
    │   │   ├── ADR-MAJOR-TEMPLATE.md
    │   │   ├── ADR-MINOR-TEMPLATE.md
    │   │   ├── BLOCKER-TEMPLATE.md
    │   │   ├── BUGFIX-TEMPLATE.md
    │   │   ├── CHANGELOG-TEMPLATE.md
    │   │   ├── CLAUDE-TEMPLATE.md
    │   │   ├── FEASIBILITY-TEMPLATE.md             # Research phase
    │   │   ├── FEATURE-TEMPLATE.md
    │   │   ├── INDEX-TEMPLATE.md
    │   │   ├── LANDSCAPE-ANALYSIS-TEMPLATE.md      # Research phase
    │   │   ├── PROBLEM-STATEMENT-TEMPLATE.md       # Research phase
    │   │   ├── PROJECT-DEFINITION-TEMPLATE.md      # Research phase
    │   │   ├── PROJECT-JUSTIFICATION-TEMPLATE.md   # Research phase
    │   │   ├── PROJECT-STATUS-TEMPLATE.md
    │   │   ├── PROJECT-TEMPLATE.md
    │   │   ├── README-TEMPLATE.md
    │   │   ├── SPIKE-TEMPLATE.md
    │   │   ├── USER-QUICK-START-TEMPLATE.md
    │   │   │
    │   │   └── wrappers/               # Code templates
    │   │       └── cmd/                # PowerShell wrappers
    │   │           ├── README.md
    │   │           ├── WRAPPER.cmd
    │   │           ├── WRAPPER-ENHANCED.cmd
    │   │           ├── WRAPPER-PS7.cmd
    │   │           └── WRAPPER-ADMIN.cmd
    │   │
    │   ├── patterns/                   # Implementation patterns
    │   │   ├── cmd-wrappers.md
    │   │   ├── config-management.md
    │   │   └── powershell-modules.md
    │   │
    │   └── tools/                      # Framework tooling (empty placeholder)
    │       └── .gitkeep
    │
    └── project/                        # Project-specific content
        ├── archive/                    # Historical/outdated docs
        │   └── .gitkeep
        │
        ├── history/                    # Daily session history
        │   ├── .gitkeep
        │   ├── releases/               # Release-specific docs
        │   │   └── .gitkeep
        │   └── spikes/                 # Spike/experiment results
        │       └── .gitkeep
        │
        ├── planning/                   # Project planning
        │   ├── backlog/                # Planned features
        │   │   └── .gitkeep
        │   └── roadmap-template.md     # Roadmap template
        │
        ├── reference/                  # Current project docs
        │   └── .gitkeep
        │
        ├── research/                   # Project research
        │   ├── adr/                    # Architecture Decision Records
        │   │   └── .gitkeep
        │   └── .gitkeep
        │
        ├── retrospectives/             # Project retrospectives
        │   └── .gitkeep
        │
        └── work/                       # Kanban workflow
            ├── todo/                   # Planned work
            │   ├── .gitkeep
            │   └── .limit              # WIP limit (default: 10)
            ├── doing/                  # In progress
            │   ├── .gitkeep
            │   └── .limit              # WIP limit (default: 1)
            └── done/                   # Completed work
                └── .gitkeep
```

**File count:** 50+ files

---

## Template Counts Summary

| Framework Level | Files | Folders |
|----------------|-------|---------|
| Minimal | 2 | 1 |
| Light | 7 | 4 |
| Standard | 50+ | 25+ |

---

## Key Files by Purpose

### Core Documentation (All Levels)
- **README.md** - Project overview, usage, installation
- **CHANGELOG.md** - Version history (Light, Standard)
- **PROJECT-STATUS.md** - Current status and version (Light, Standard)
- **INDEX.md** - Documentation navigation (Standard only)
- **CLAUDE.md** - AI assistant project guide (Light optional, Standard required)

### Research Phase (Standard Only)
- **PROBLEM-STATEMENT-TEMPLATE.md** - Define the problem
- **LANDSCAPE-ANALYSIS-TEMPLATE.md** - Analyze existing solutions
- **FEASIBILITY-TEMPLATE.md** - Assess feasibility
- **PROJECT-JUSTIFICATION-TEMPLATE.md** - BUILD/BUY/ADAPT/ABANDON decision
- **PROJECT-DEFINITION-TEMPLATE.md** - Project scope and goals

### Work Item Templates (Standard Only)
- **FEATURE-TEMPLATE.md** - New feature planning
- **BUGFIX-TEMPLATE.md** - Bug fix documentation
- **BLOCKER-TEMPLATE.md** - Blocker tracking
- **SPIKE-TEMPLATE.md** - Research spike documentation

### Decision Documentation (Standard Only)
- **ADR-MAJOR-TEMPLATE.md** - Major architectural decisions
- **ADR-MINOR-TEMPLATE.md** - Minor technical decisions

### Code Templates (Standard Only)
- **WRAPPER.cmd** - Basic PowerShell wrapper
- **WRAPPER-ENHANCED.cmd** - Enhanced wrapper (recommended)
- **WRAPPER-PS7.cmd** - PowerShell 7 preferred wrapper
- **WRAPPER-ADMIN.cmd** - Administrator required wrapper

### Process Documentation (Standard Only)
- **workflow-guide.md** - Work item lifecycle and workflow
- **version-control-workflow.md** - Git branching and releases
- **documentation-standards.md** - Doc formatting standards

### Pattern Documentation (Standard Only)
- **cmd-wrappers.md** - CMD wrapper pattern
- **config-management.md** - Configuration pattern
- **powershell-modules.md** - Module structure pattern

---

## Usage

### For New Projects

1. Choose framework level using [README-TEMPLATE-SELECTION.md](README-TEMPLATE-SELECTION.md)
2. Copy entire `minimal/`, `light/`, or `standard/` folder to your project location
3. Rename folder to your project name
4. Follow setup checklist in [NEW-PROJECT-CHECKLIST.md](NEW-PROJECT-CHECKLIST.md)
5. Customize templates with your project details

### For Existing Projects

1. Assess current project state
2. Choose appropriate framework level
3. Follow "Existing Project Integration" in [NEW-PROJECT-CHECKLIST.md](NEW-PROJECT-CHECKLIST.md)
4. Migrate content from existing docs
5. Adopt workflow incrementally

---

## Verification

### Check Minimal Template

```bash
ls minimal/
# Should see: README.md, .gitignore
```

### Check Light Template

```bash
find light/ -type f | wc -l
# Should see: ~7 files
```

### Check Standard Template

```bash
find standard/ -type f | wc -l
# Should see: 50+ files

ls standard/project-hub/framework/templates/
# Should include all templates including PROBLEM-STATEMENT-TEMPLATE.md, etc.

ls standard/project-hub/framework/templates/wrappers/cmd/
# Should see: WRAPPER*.cmd files (not TEMPLATE-WRAPPER*.cmd)
```

---

## Related Documents

- [README-TEMPLATE-SELECTION.md](README-TEMPLATE-SELECTION.md) - Choose your framework level
- [NEW-PROJECT-CHECKLIST.md](NEW-PROJECT-CHECKLIST.md) - Setup instructions
- [UPGRADE-PATH.md](UPGRADE-PATH.md) - Upgrade between levels

---

**Version:** 2.0.0
**Last Updated:** 2025-12-19

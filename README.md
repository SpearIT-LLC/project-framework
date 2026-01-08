# SpearIT Project Framework

**Current Version & Status:** See [framework/PROJECT-STATUS.md](framework/PROJECT-STATUS.md)
**Last Updated:** 2026-01-06
**Maintainer:** Gary Elliott (gary.elliott@spearit.solutions)
**Organization:** SpearIT, LLC

---

## What Is This?

The **SpearIT Project Framework** is a comprehensive, multi-level project management framework designed to bring structure, consistency, and AI integration to software projects of any size.

This repository is organized as a monorepo containing:
- **framework/** - The Standard Project Framework implementation and documentation
- **project-hello-world/** - Reference implementation demonstrating framework usage
- **project-templates/** - Template packages for new projects (Minimal, Light, Standard levels)

**Key Innovation:** This framework scales from single scripts to full applications using a 3-level system (Minimal, Light, Standard) that adapts to your project's scope, lifespan, and team size.

---

## Quick Start

**Want the fastest path?** See [QUICK-START.md](QUICK-START.md) for a bare-bones, get-functional guide. ⚡

**See the framework in action:** Check out [project-hello-world/](project-hello-world/) for a complete reference implementation.

### For New Projects

1. **Choose your framework level:**
   - Read [README-TEMPLATE-SELECTION.md](project-templates/README-TEMPLATE-SELECTION.md)
   - Answer 3 simple questions about your project
   - Get recommended framework level

2. **Copy the appropriate template:**
   ```bash
   # For single scripts
   cp -r project-templates/minimal /path/to/your-project

   # For small tools
   cp -r project-templates/light /path/to/your-project

   # For applications
   cp -r project-templates/standard /path/to/your-project
   ```

3. **Follow the setup checklist:**
   - Open [NEW-PROJECT-CHECKLIST.md](project-templates/NEW-PROJECT-CHECKLIST.md)
   - Follow the instructions for your framework level
   - Customize templates with your project details

### For Existing Projects

1. **Assess your project:**
   - Determine current scope, lifespan, and team size
   - Choose appropriate framework level

2. **Integrate the framework:**
   - Follow "Existing Project Integration" section in [NEW-PROJECT-CHECKLIST.md](project-templates/NEW-PROJECT-CHECKLIST.md)
   - Migrate existing documentation
   - Adopt workflow incrementally

---

## What's Included

### Framework Levels

**Minimal Framework** (2 files, 10-15 min setup)
- For single scripts, throwaway projects, personal automation
- Basic README with "Why This Exists" section

**Light Framework** (7 files, 30-60 min setup)
- For small tools with medium lifespan
- Version tracking (PROJECT-STATUS.md)
- Change history (CHANGELOG.md)
- Decision documentation

**Standard Framework** (50+ files)
- For applications, teams, ongoing projects
- Complete documentation suite
- File-based kanban workflow
- 19 templates for planning, work items, and decisions
- Research phase support (5 templates)
- CMD wrappers for PowerShell scripts (4 variants)
- AI integration (CLAUDE.md)

---

## Key Features

### Multi-Level Scaling
Choose the right amount of structure for your project. Start small, upgrade as your project grows.

### Research-Driven Development
Built-in research phase with 5 templates helps you answer: "Are we recreating the wheel, or do we have something useful to add?"

### File-Based Kanban Workflow
Simple folder-based work tracking:
```
work/backlog → work/todo → work/doing → work/done → history/releases/
```

### AI Integration
CLAUDE.md templates help Claude Code understand your project architecture, coding standards, and common patterns.

### Architecture Decision Records
Two-tier ADR system (Major/Minor) with upgrade path for documenting important decisions.

### PowerShell CMD Wrappers
Four production-ready CMD wrapper templates let users double-click PowerShell scripts in Windows.

### Upgrade Paths
Clear migration guides for moving between framework levels as your project evolves.

---

## Documentation

### Core Documentation
- **[README-TEMPLATE-SELECTION.md](project-templates/README-TEMPLATE-SELECTION.md)** - Choose your framework level ⭐
- **[NEW-PROJECT-CHECKLIST.md](project-templates/NEW-PROJECT-CHECKLIST.md)** - Setup instructions ⭐
- **[framework/PROJECT-STATUS.md](framework/PROJECT-STATUS.md)** - Current version and status
- **[framework/CHANGELOG.md](framework/CHANGELOG.md)** - Version history
- **[framework/INDEX.md](framework/INDEX.md)** - Complete documentation index
- [UPGRADE-PATH.md](project-templates/UPGRADE-PATH.md) - Migration between levels
- [STRUCTURE.md](project-templates/STRUCTURE.md) - Template structure reference

### Reference Implementation
- **[project-hello-world/](project-hello-world/)** - Complete working example of Standard framework

### Template Package
- [project-templates/](project-templates/) - Complete template package
- [minimal/](project-templates/minimal/) - Minimal framework templates
- [light/](project-templates/light/) - Light framework templates
- [standard/](project-templates/standard/) - Standard framework templates

---

## Philosophy

### Core Principles

1. **Right-Sized Framework** - Use appropriate structure for project size
2. **Research Before Build** - Validate problem before investing in solution
3. **Single Source of Truth** - PROJECT-STATUS.md for version/status (never duplicate)
4. **Incremental Development** - One work item at a time, verify alignment
5. **Document Deviations** - Customizations documented in CLAUDE.md

### Workflow Phases

All projects follow this core workflow:
1. **Research/Explore** - Validate problem and solution space
2. **Define** - Establish boundaries and success criteria
3. **Plan** - Design implementation approach
4. **Code** - Implement incrementally
5. **Commit/Release** - Ship the value

Depth varies by framework level.

---

## Who Is This For?

### Solo Developers
- Structure for personal projects without overhead
- Future-proof for handoff or collaboration
- AI integration for working with Claude Code

### Small Teams (2-5 people)
- Shared workflow and documentation standards
- File-based kanban (no tools required)
- Clear process documentation

### Professional Projects
- Research phase prevents reinventing the wheel
- Architecture decision records capture context
- Formal release process with changelogs

### AI-Assisted Development
- CLAUDE.md templates help AI understand your project
- Consistent structure improves AI assistance quality
- Framework-aware AI can navigate documentation

---

## Project Status

**Current Version:** v3.0.0 (2026-01-07)
**Status:** In Development (Migration Branch)

See [framework/PROJECT-STATUS.md](framework/PROJECT-STATUS.md) for detailed status.

### What's Complete
- ✅ Multi-level framework system (Minimal/Light/Standard)
- ✅ 19 templates including research phase (5 templates)
- ✅ CMD wrappers (4 variants)
- ✅ Setup checklists and upgrade paths
- ✅ Complete documentation suite
- 🚧 Dogfooding (framework using its own Standard framework)

### What's Next
- 📋 ZIP distribution package
- 📋 Interactive setup script
- 📋 Validation script
- 📋 Visual diagrams

See [framework/CHANGELOG.md](framework/CHANGELOG.md) for version history.

---

## Examples

### Scenario 1: Quick Automation Script
**Project:** Daily backup automation (PowerShell)
**Framework Level:** Minimal
**Files:** 2 (README.md, backup.ps1)

### Scenario 2: CLI Utility Tool
**Project:** Data conversion utility
**Framework Level:** Light
**Files:** 7 core docs + tool code

### Scenario 3: Web Application
**Project:** Internal dashboard application
**Framework Level:** Standard
**Features:** Full planning, kanban workflow, team collaboration

---

## Real-World Usage

**Projects Using Framework:**
- HPC Job Queue Prototype (Standard framework) - Origin project

**Feedback:**
- Kanban workflow effective for solo developer
- Research phase templates saved time by avoiding unnecessary features
- CLAUDE.md integration significantly improved AI assistance quality

**Lessons Learned:**
- Initial setup time investment pays off within first month
- Framework prevents "documentation drift"
- WIP limits (doing=1) enforce focus

---

## Distribution

### Current Options

**Git Clone:**
```bash
git clone https://github.com/spearit-solutions/project-framework.git
cd project-framework/project-templates
# Copy appropriate level to your project
```

**Manual Download:**
- Download repository as ZIP
- Extract and copy desired framework level

### Planned
- Pre-packaged ZIP files for each framework level
- Interactive setup script
- Automated distribution process

---

## Version Strategy

**Framework Version:** See [framework/PROJECT-STATUS.md](framework/PROJECT-STATUS.md) for current version
- Major version for breaking structure changes
- Minor version for new features/templates
- Patch version for bug fixes/documentation

**Document Versions:** Each document tracks its own "Last Updated" date
- No version bump required for unrelated changes
- Maintains clarity about when specific docs were modified

**Template Versions:** Inherit framework version unless independently versioned

See [Version Strategy Documentation](framework/thoughts/reference/version-strategy.md) *(planned)* for details.

---

## Contributing

**Status:** Framework currently maintained by SpearIT, LLC

**Future:** CONTRIBUTING.md planned for future release

**Feedback Welcome:**
- Issues, suggestions, and pull requests welcome
- Contact: gary.elliott@spearit.solutions

---

## License

See [LICENSE](LICENSE) file for details.

---

## Dogfooding

**Meta Note:** This framework project uses its own Standard framework for development. This serves as:
1. **Validation** - Proves framework works for framework development
2. **Example** - Real-world example of framework usage
3. **Improvement** - Surfaces pain points and areas for enhancement

Check [framework/thoughts/](framework/thoughts/) to see the framework in action on itself, or [project-hello-world/](project-hello-world/) for a simpler reference implementation.

---

## Support

**Maintainer:** Gary Elliott (gary.elliott@spearit.solutions)
**Organization:** SpearIT, LLC
**Documentation:** See [framework/INDEX.md](framework/INDEX.md) for complete doc navigation

---

## Credits

**Created By:** Gary Elliott
**Organization:** SpearIT, LLC
**Inspired By:** Practical experience with HPC Job Queue Prototype project
**First Release:** 2025-12-18 (v1.0.0)
**Multi-Level Framework:** 2025-12-19 (v2.0.0)

---

**Get Started:** [README-TEMPLATE-SELECTION.md](project-templates/README-TEMPLATE-SELECTION.md) → [NEW-PROJECT-CHECKLIST.md](project-templates/NEW-PROJECT-CHECKLIST.md)

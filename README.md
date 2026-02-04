# SpearIT Project Framework

**Current Version & Status:** See [framework/PROJECT-STATUS.md](framework/PROJECT-STATUS.md)
**Last Updated:** 2026-01-06
**Maintainer:** Gary Elliott (gary.elliott@spearit.solutions)
**Organization:** SpearIT, LLC

---

## What Is This?

The **SpearIT Project Framework** is a file-based workflow and AI collaboration partner for solo developers and small teams building software or documentation projects.

This repository contains:
- **framework/** - The Standard Project Framework implementation and documentation
- **templates/** - Template packages for new projects
- **tools/** - Build and setup scripts for distribution

---

## Quick Start

**Want the fastest path?** See [QUICK-START.md](QUICK-START.md) for a bare-bones, get-functional guide. ⚡

**Create a new project:** Use `tools/Build-FrameworkArchive.ps1` to create a distribution, then run `Setup-Project.ps1` to scaffold a new project.

### For New Projects

1. **Create a distribution package:**
   ```bash
   tools/Build-FrameworkArchive.ps1
   ```

2. **Run the setup script:**
   ```bash
   Setup-Project.ps1
   ```

3. **Follow the setup checklist:**
   - Open [NEW-PROJECT-CHECKLIST.md](templates/NEW-PROJECT-CHECKLIST.md)
   - Follow the setup instructions
   - Customize templates with your project details

### For Existing Projects

1. **Assess your project:**
   - Determine current scope, lifespan, and team size

2. **Integrate the framework:**
   - Follow "Existing Project Integration" section in [NEW-PROJECT-CHECKLIST.md](templates/NEW-PROJECT-CHECKLIST.md)
   - Migrate existing documentation
   - Adopt workflow incrementally

---

## What's Included

- Complete documentation suite
- File-based kanban workflow
- Templates for planning, work items, and decisions
- Research phase support
- CMD wrappers for PowerShell scripts
- AI integration (CLAUDE.md)

---

## Key Features

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

---

## Documentation

### Core Documentation
- **[NEW-PROJECT-CHECKLIST.md](templates/NEW-PROJECT-CHECKLIST.md)** - Setup instructions ⭐
- **[framework/PROJECT-STATUS.md](framework/PROJECT-STATUS.md)** - Current version and status
- **[framework/CHANGELOG.md](framework/CHANGELOG.md)** - Version history
- **[framework/INDEX.md](framework/INDEX.md)** - Complete documentation index
- [STRUCTURE.md](templates/STRUCTURE.md) - Template structure reference

### Template Package
- [templates/starter/](templates/starter/) - Complete project scaffolding with framework included

---

## Philosophy

### Core Principles

1. **Research Before Build** - Validate problem before investing in solution
2. **Single Source of Truth** - PROJECT-STATUS.md for version/status (never duplicate)
3. **Incremental Development** - One work item at a time, verify alignment
4. **Document Deviations** - Customizations documented in CLAUDE.md
5. **Progressive Adoption** - Start simple, add structure as value becomes clear

### Workflow Phases

All projects follow this core workflow:
1. **Research/Explore** - Validate problem and solution space
2. **Define** - Establish boundaries and success criteria
3. **Plan** - Design implementation approach
4. **Code** - Implement incrementally
5. **Commit/Release** - Ship the value

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
- ✅ Complete documentation suite
- ✅ Templates including research phase
- ✅ CMD wrappers (4 variants)
- ✅ Setup checklists
- ✅ File-based kanban workflow
- 🚧 Dogfooding (framework managing itself)

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
**Setup:** Basic README with "Why This Exists" section
**Time:** 10-15 minutes

### Scenario 2: CLI Utility Tool
**Project:** Data conversion utility
**Setup:** Version tracking, changelog, decision documentation
**Time:** 30-60 minutes

### Scenario 3: Web Application
**Project:** Internal dashboard application
**Setup:** Full planning, kanban workflow, team collaboration
**Time:** Progressive adoption as project grows

---

## Real-World Usage

**Projects Using Framework:**
- HPC Job Queue Prototype - Origin project

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
cd project-framework/templates
# Copy appropriate level to your project
```

**Manual Download:**
- Download repository as ZIP
- Extract and use starter template

### Planned
- Pre-packaged distribution ZIP file
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

See [Version Strategy Documentation](framework/project-hub/external-references/version-strategy.md) for details.

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

**Meta Note:** This framework project manages itself using its own workflow system. This serves as:
1. **Validation** - Proves framework works for framework development
2. **Example** - Real-world example of framework usage
3. **Improvement** - Surfaces pain points and areas for enhancement

Check [framework/project-hub/](framework/project-hub/) to see the framework in action on itself, or use the starter template ([templates/starter/](templates/starter/)) to create a new project.

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

**Get Started:** [NEW-PROJECT-CHECKLIST.md](templates/NEW-PROJECT-CHECKLIST.md)

# SpearIT Project Framework

**Current Version & Status:** See [framework/PROJECT-STATUS.md](framework/PROJECT-STATUS.md)
**Last Updated:** 2026-02-13
**Maintainer:** Gary Elliott (gary.elliott@spearit.solutions)
**Organization:** SpearIT, LLC

---

## What Is This?

The **SpearIT Project Framework** is a file-based workflow and AI collaboration partner for solo developers and small teams building software or documentation projects.

This repository contains **two complementary products:**

### 🔌 Plugin (Lightweight Edition)
Install in any project to get file-based Kanban workflow immediately. No project restructuring required.

### 📚 Framework (Comprehensive Edition)
Complete project scaffolding with templates, documentation patterns, and full methodology.

**Choose your path:** Plugin for quick start → Framework when you're ready for comprehensive structure.

---

## Quick Start

### Option 1: Install the Plugin (Recommended for First-Time Users)

**Try the workflow in minutes:**

```bash
# Via Anthropic Marketplace (coming soon)
# Search for: SpearIT Framework - Lightweight Edition

# Via GitHub (development)
# See: plugins/spearit-framework-light/README.md
```

**What you get:**
- ✅ File-based Kanban workflow (backlog → todo → doing → done)
- ✅ AI-assisted work item creation with auto-ID assignment
- ✅ Workflow management with AI-guided planning
- ✅ Works in any project structure
- ✅ No external dependencies

**Perfect for:**
- Trying before committing to full framework
- Adding workflow to existing projects
- Lightweight project tracking
- Solo developers and small teams

**Learn more:** [plugins/spearit-framework-light/README.md](plugins/spearit-framework-light/README.md)

### Option 2: Use the Full Framework (For New Projects)

**Get complete project scaffolding:**

1. **Create a distribution package:**
   ```bash
   tools/Build-FrameworkArchive.ps1
   ```

2. **Run the setup script:**
   ```bash
   Setup-Framework.ps1
   ```

3. **Follow the setup checklist:**
   - Open [NEW-PROJECT-CHECKLIST.md](templates/NEW-PROJECT-CHECKLIST.md)
   - Follow the setup instructions
   - Customize templates with your project details

**What you get:**
- ✅ Complete documentation suite
- ✅ All workflow commands and automation
- ✅ Project templates and patterns
- ✅ Research phase support
- ✅ Architecture decision records
- ✅ PowerShell scripts and wrappers
- ✅ AI integration (CLAUDE.md)

**Perfect for:**
- New projects starting from scratch
- Teams wanting comprehensive structure
- Long-term professional projects
- Full project lifecycle support

---

## Repository Contents

### 🔌 `/plugins/` - Plugin Development
- **spearit-framework-light/** - Lightweight Edition plugin (v1.0.0)
  - 3 core commands (help, new, move)
  - 3 skills for AI context
  - Standalone operation (no framework required)

### 📚 `/framework/` - Framework Source
- **docs/** - Process documentation, collaboration guides, patterns
- **templates/** - Work items, decisions, planning documents
- **tools/** - PowerShell scripts for workflow automation

### 📦 `/templates/` - Project Templates
- **starter/** - Complete project scaffolding with framework included

### 🛠️ `/tools/` - Build Scripts
- Distribution archive creation
- Plugin packaging
- Setup automation

### 📊 `/project-hub/` - Development Tracking
- **Purpose:** Dogfooding - framework managing itself
- **Contents:** Work items, decisions, session histories
- **Note:** This shows the framework in action! Feel free to explore to see how we use it.

---

## Plugin vs Framework: Which Should I Choose?

### Choose the Plugin if:
- ✅ You have an existing project
- ✅ You want to try the workflow quickly
- ✅ You need lightweight tracking only
- ✅ You don't want to restructure your project
- ✅ You're evaluating before full commitment

**Time to start:** 5 minutes

### Choose the Framework if:
- ✅ You're starting a new project
- ✅ You want comprehensive scaffolding
- ✅ You need templates, patterns, and guides
- ✅ You're building a long-term professional project
- ✅ You want the complete methodology

**Time to start:** 30-60 minutes

### Use Both:
Many users start with the plugin, then graduate to the full framework when starting their next project. They're designed to work together!

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

### Getting Started
- **[QUICK-START.md](QUICK-START.md)** - Bare-bones, get-functional guide ⚡
- **[NEW-PROJECT-CHECKLIST.md](templates/NEW-PROJECT-CHECKLIST.md)** - Setup instructions for framework
- **[Plugin README](plugins/spearit-framework-light/README.md)** - Plugin installation and usage

### Core Documentation
- **[framework/PROJECT-STATUS.md](framework/PROJECT-STATUS.md)** - Current version and status
- **[framework/CHANGELOG.md](framework/CHANGELOG.md)** - Version history
- **[framework/INDEX.md](framework/INDEX.md)** - Complete documentation index
- **[STRUCTURE.md](templates/STRUCTURE.md)** - Template structure reference

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

## Version Strategy

**Plugin Version:** v1.0.0 (production-ready)
- Semantic versioning independent from framework
- See: [plugins/spearit-framework-light/CHANGELOG.md](plugins/spearit-framework-light/CHANGELOG.md)

**Framework Version:** v3.0.0 (in development)
- Major version for breaking structure changes
- Minor version for new features/templates
- Patch version for bug fixes/documentation
- See: [framework/PROJECT-STATUS.md](framework/PROJECT-STATUS.md)

**Why different versions?**
- Plugin is a new product (starting at v1.0.0)
- Framework is mature (evolved through multiple versions)
- Each can evolve independently based on user feedback

---

## Project Status

### Plugin (Lightweight Edition) - v1.0.0
**Status:** ✅ Production-ready, marketplace submission pending

**What's Complete:**
- ✅ 3 core commands (help, new, move)
- ✅ 3 skills for AI context
- ✅ Professional documentation
- ✅ Comprehensive testing (CLI + VSCode)
- ✅ ZIP package (51.3 KB)

**What's Next:**
- 📋 Anthropic marketplace submission
- 📋 User feedback collection
- 📋 v1.1 feature planning based on adoption

### Framework (Comprehensive Edition) - v3.0.0
**Status:** 🚧 In Development (Migration Branch)

**What's Complete:**
- ✅ Complete documentation suite
- ✅ Templates including research phase
- ✅ CMD wrappers (4 variants)
- ✅ Setup checklists
- ✅ File-based kanban workflow
- 🚧 Dogfooding (framework managing itself)

**What's Next:**
- 📋 ZIP distribution package
- 📋 Interactive setup script
- 📋 Validation script
- 📋 Visual diagrams

---

## Real-World Usage

**Projects Using Framework:**
- SpearIT Project Framework (dogfooding - this project manages itself)
- HPC Job Queue Prototype (origin project)

**Lessons Learned:**
- Initial setup time investment pays off within first month
- Framework prevents "documentation drift"
- WIP limits (doing=1) enforce focus
- Research phase templates save time by avoiding unnecessary features
- CLAUDE.md integration significantly improves AI assistance quality

---

## Examples

### Scenario 1: Quick Automation Script
**Project:** Daily backup automation (PowerShell)
**Setup:** Basic README with "Why This Exists" section
**Time:** 10-15 minutes
**Recommendation:** Use plugin for quick tracking

### Scenario 2: CLI Utility Tool
**Project:** Data conversion utility
**Setup:** Version tracking, changelog, decision documentation
**Time:** 30-60 minutes
**Recommendation:** Use framework with basic templates

### Scenario 3: Web Application
**Project:** Internal dashboard application
**Setup:** Full planning, kanban workflow, team collaboration
**Time:** Progressive adoption as project grows
**Recommendation:** Start with plugin, graduate to framework

---

## Installation

### Installing the Plugin

```bash
# Via Anthropic Marketplace (coming soon)
# 1. Open Claude Code
# 2. Search plugins: "SpearIT Framework"
# 3. Install "Lightweight Edition"

# Via GitHub (development/testing)
# See detailed instructions in: plugins/spearit-framework-light/README.md
```

### Installing the Framework

```bash
# Clone repository
git clone https://github.com/SpearIT-LLC/project-framework.git
cd project-framework

# Create distribution archive
tools/Build-FrameworkArchive.ps1

# Extract to your project and run setup
# Follow: templates/NEW-PROJECT-CHECKLIST.md
```

---

## Contributing

**Current Status:** Framework and plugin maintained by SpearIT, LLC

**Feedback Welcome:**
- 🐛 Issues and bug reports
- 💡 Feature suggestions
- ❓ Questions about usage
- 📖 Documentation improvements

**How to provide feedback:**
- Open an issue on GitHub
- Email: gary.elliott@spearit.solutions

**Future Plans:**
- Detailed CONTRIBUTING.md coming soon
- Community contributions welcomed after v1.0 plugin stabilizes

---

## License

MIT License - See [LICENSE](LICENSE) file for details.

Both the plugin and framework are MIT licensed for maximum flexibility and adoption.

---

## Dogfooding

**Meta Note:** This framework project manages itself using its own workflow system.

Check out [`project-hub/`](project-hub/) to see:
- ✅ How we track work items (backlog → doing → done)
- ✅ How we document decisions
- ✅ How we plan features
- ✅ How we manage releases

This serves as:
1. **Validation** - Proves framework works for framework development
2. **Example** - Real-world example of framework in action
3. **Improvement** - Surfaces pain points and areas for enhancement

---

## Support

**Maintainer:** Gary Elliott
**Email:** gary.elliott@spearit.solutions
**Organization:** SpearIT, LLC

**Documentation:**
- Framework: [framework/INDEX.md](framework/INDEX.md)
- Plugin: [plugins/spearit-framework-light/README.md](plugins/spearit-framework-light/README.md)

---

## Credits

**Created By:** Gary Elliott
**Organization:** SpearIT, LLC
**Inspired By:** Practical experience with HPC Job Queue Prototype project

**Key Milestones:**
- **2025-12-18** - Framework v1.0.0 (first release)
- **2025-12-19** - Framework v2.0.0 (multi-level support)
- **2026-01-07** - Framework v3.0.0 (framework-as-dependency)
- **2026-02-13** - Plugin v1.0.0 (marketplace-ready)

---

**Ready to start?**
- **Try it quickly:** [Plugin README](plugins/spearit-framework-light/README.md)
- **Full setup:** [NEW-PROJECT-CHECKLIST.md](templates/NEW-PROJECT-CHECKLIST.md)
- **Learn more:** [framework/INDEX.md](framework/INDEX.md)

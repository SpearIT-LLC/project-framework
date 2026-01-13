# SpearIT Project Framework Template Package

**Version:** 2.0.0
**Last Updated:** 2025-12-19
**Purpose:** Reusable project framework templates for new projects

---

## What Is This?

This is the complete **SpearIT Project Framework template package** - a collection of ready-to-use project templates that scale from single scripts to full applications.

**Choose your framework level:**
- [README-TEMPLATE-SELECTION.md](README-TEMPLATE-SELECTION.md) - **Start here** to determine which framework level you need

**Setup instructions:**
- [NEW-PROJECT-CHECKLIST.md](NEW-PROJECT-CHECKLIST.md) - Complete setup guide for all levels

---

## Framework Levels

### Minimal Framework ([minimal/](minimal/))
**For:** Single scripts, throwaway projects, personal automation
- **Files:** 2 (README.md, .gitignore)
- **Use when:** Single file script, one-time use, personal tool

### Light Framework ([light/](light/))
**For:** Small tools, medium lifespan, handoff expected
- **Files:** 7 (README, PROJECT-STATUS, CHANGELOG, CLAUDE.md, thoughts/)
- **Use when:** 2-10 files, maintained for months, possible collaboration

### Standard Framework ([standard/](standard/))
**For:** Applications, teams, ongoing projects, critical systems
- **Files:** 50+ (complete documentation, kanban workflow, 19 templates)
- **Use when:** 10+ files, team collaboration, formal releases, architecture decisions

---

## Quick Start

### Step 1: Choose Framework Level
Read [README-TEMPLATE-SELECTION.md](README-TEMPLATE-SELECTION.md) and answer 3 questions:
1. **Scope & Complexity** - Script, Tool, Application, or System?
2. **Lifespan & Evolution** - Throwaway, Short-term, Maintained, or Critical?
3. **Team & Collaboration** - Solo, Solo+Handoff, Small Team, or Large Team?

### Step 2: Copy Template
```bash
# For single scripts
cp -r minimal/ /path/to/your-project

# For small tools
cp -r light/ /path/to/your-project

# For applications
cp -r standard/ /path/to/your-project
```

### Step 3: Follow Checklist
Open [NEW-PROJECT-CHECKLIST.md](NEW-PROJECT-CHECKLIST.md) and follow the instructions for your framework level.

---

## What's Included

### Guide Documents (This Folder)
- **[README-TEMPLATE-SELECTION.md](README-TEMPLATE-SELECTION.md)** - Choose your framework level ⭐
- **[NEW-PROJECT-CHECKLIST.md](NEW-PROJECT-CHECKLIST.md)** - Setup instructions ⭐
- [UPGRADE-PATH.md](UPGRADE-PATH.md) - Upgrade between framework levels
- [STRUCTURE.md](STRUCTURE.md) - Template structure reference
- This README - Package overview

### Template Folders
- [minimal/](minimal/) - Minimal framework templates (2 files)
- [light/](light/) - Light framework templates (7 files)
- [standard/](standard/) - Standard framework templates (50+ files)

---

## Framework Features

### Multi-Level Scaling
Start with the right amount of structure. Upgrade as your project grows.

### Research-Driven Development (Standard)
5 research phase templates help you answer: "Are we recreating the wheel?"

### File-Based Kanban Workflow (Standard)
Simple folder-based work tracking: `planning/backlog → work/todo → work/doing → work/done`

### AI Integration
CLAUDE.md templates for working with Claude Code and other AI assistants.

### Architecture Decision Records (Standard)
Two-tier ADR system (Major/Minor) for documenting important decisions.

### PowerShell CMD Wrappers (Standard)
4 production-ready CMD wrapper templates for double-click PowerShell execution.

### Upgrade Paths
Clear migration guides in [UPGRADE-PATH.md](UPGRADE-PATH.md).

---

## Documentation

| Document | Purpose |
|----------|---------|
| [README-TEMPLATE-SELECTION.md](README-TEMPLATE-SELECTION.md) | **Choose framework level** (start here) |
| [NEW-PROJECT-CHECKLIST.md](NEW-PROJECT-CHECKLIST.md) | **Setup instructions** for each level |
| [UPGRADE-PATH.md](UPGRADE-PATH.md) | Migrate between framework levels |
| [STRUCTURE.md](STRUCTURE.md) | Template structure reference |
| This README | Package overview |

---

## Migration Note (v1.0.0 → v2.0.0)

**If you copied templates from v1.0.0:**

In v1.0.0, template files existed at the root of this folder (README.md, CLAUDE.md, etc.).

**In v2.0.0:**
- ✅ Templates moved to framework-level folders (minimal/, light/, standard/)
- ❌ Root-level templates removed (they were redundant with standard/)
- ✅ Guide documents remain at root (README-TEMPLATE-SELECTION.md, NEW-PROJECT-CHECKLIST.md, etc.)

**Action Required:**
- Existing projects using v1.0.0 templates: No action needed - continue using them
- New projects: Copy from appropriate framework level folder (minimal/, light/, or standard/)

**Rationale:**
- Eliminates confusion about which files to copy
- Each framework level is self-contained in its own folder
- Guide documents are clearly separated from templates

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 2.0.0 | 2025-12-19 | Multi-level framework system, removed legacy root templates |
| 1.0.0 | 2025-12-18 | Initial framework template package |

See parent [CHANGELOG.md](../CHANGELOG.md) for detailed framework version history.

---

## Support

**Questions?**
- Review [README-TEMPLATE-SELECTION.md](README-TEMPLATE-SELECTION.md) for framework selection
- Check [NEW-PROJECT-CHECKLIST.md](NEW-PROJECT-CHECKLIST.md) for setup guidance
- Read [STRUCTURE.md](STRUCTURE.md) for template structure details
- See [UPGRADE-PATH.md](UPGRADE-PATH.md) for upgrade guidance

**Maintainer:** Gary Elliott (gary.elliott@spearit.solutions)
**Organization:** SpearIT, LLC

---

**Get Started:** [README-TEMPLATE-SELECTION.md](README-TEMPLATE-SELECTION.md) → [NEW-PROJECT-CHECKLIST.md](NEW-PROJECT-CHECKLIST.md)

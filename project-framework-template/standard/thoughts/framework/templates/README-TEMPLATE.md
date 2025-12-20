# SpearIT Project Framework Template

**Version:** 1.0.0
**Last Updated:** 2025-12-18
**Purpose:** Reusable project framework for new projects

---

## What Is This?

This is a complete project framework template package that provides:

✅ **Documentation structure** - README, PROJECT-STATUS, CHANGELOG, INDEX templates
✅ **Workflow system** - File-based kanban for one-person teams
✅ **Process documentation** - Version control, release process, documentation standards
✅ **Work item templates** - Feature, Bugfix, Blocker, Spike, ADR templates
✅ **Folder structure** - Organized planning, work, reference, and history folders
✅ **AI integration** - CLAUDE.md templates for working with Claude Code

---

## Quick Start

### For New Projects (Greenfield)

1. **Copy this entire folder to your new project location:**
   ```bash
   cp -r project-framework-template /path/to/new-project-name
   cd /path/to/new-project-name
   ```

2. **Follow the checklist:**
   - Open `NEW-PROJECT-CHECKLIST.md`
   - Follow "Greenfield Project Setup" section
   - Complete all checklist items

3. **Start working:**
   - Initialize git repository
   - Customize templates
   - Create first work item
   - Begin development

### For Existing Projects (Integration)

1. **Copy framework to existing project:**
   ```bash
   # From project root
   cp -r /path/to/project-framework-template/CLAUDE.md ../
   cp -r /path/to/project-framework-template/thoughts/framework thoughts/
   ```

2. **Follow the checklist:**
   - Open `NEW-PROJECT-CHECKLIST.md`
   - Follow "Existing Project Integration" section
   - Complete all checklist items

3. **Migrate work:**
   - Capture in-progress work
   - Capture planned work
   - Create initial roadmap
   - Continue development with framework

---

## What's Included

### Root Templates

- **NEW-PROJECT-CHECKLIST.md** - Complete setup guide for new and existing projects
- **README-TEMPLATE.md** - Project README template
- **PROJECT-STATUS-TEMPLATE.md** - Status tracking template
- **CHANGELOG-TEMPLATE.md** - Version history template (Keep a Changelog format)
- **INDEX-TEMPLATE.md** - Documentation navigation template
- **CLAUDE-TEMPLATE.md** - Project-specific AI instructions template

### Framework (thoughts/framework/)

**Process Documentation:**
- `process/kanban-workflow.md` - File-based kanban workflow
- `process/version-control-workflow.md` - Git and release process
- `process/documentation-standards.md` - Documentation formatting

**Templates:**
- `templates/FEATURE-TEMPLATE.md` - Feature planning
- `templates/BUGFIX-TEMPLATE.md` - Bug fix documentation
- `templates/BLOCKER-TEMPLATE.md` - Blocker tracking
- `templates/SPIKE-TEMPLATE.md` - Research/investigation
- `templates/ADR-MAJOR-TEMPLATE.md` - Major architecture decisions
- `templates/ADR-MINOR-TEMPLATE.md` - Minor architecture decisions

**Patterns:** (if applicable to your project type)
- `patterns/powershell-modules.md`
- `patterns/config-management.md`
- `patterns/cmd-wrappers.md`

### Project Structure (thoughts/project/)

**Empty folder structure ready for your work:**
```
thoughts/project/
├── planning/
│   ├── roadmap.md (template included)
│   └── backlog/
├── work/
│   ├── todo/ (.limit = 10)
│   ├── doing/ (.limit = 1)
│   └── done/
├── reference/
├── archive/
├── research/
│   └── adr/
├── retrospectives/
└── history/
    ├── releases/
    └── spikes/
```

---

## How to Use

### Step 1: Copy Template

```bash
# For new project
cp -r project-framework-template /path/to/new-project-name

# For existing project (copy pieces)
cp CLAUDE.md /path/to/existing-project/../
cp -r thoughts/framework /path/to/existing-project/thoughts/
```

### Step 2: Rename Templates

```bash
cd /path/to/new-project-name

# Rename all *-TEMPLATE.md files
mv README-TEMPLATE.md README.md
mv PROJECT-STATUS-TEMPLATE.md PROJECT-STATUS.md
mv CHANGELOG-TEMPLATE.md CHANGELOG.md
mv INDEX-TEMPLATE.md INDEX.md
mv CLAUDE-TEMPLATE.md CLAUDE.md
```

### Step 3: Customize Documents

1. Update README.md with project details
2. Update PROJECT-STATUS.md with initial version
3. Update CHANGELOG.md with project name
4. Update CLAUDE.md with project-specific information
5. Update roadmap.md with project vision

### Step 4: Initialize Git

```bash
git init
git add .
git commit -m "Initial project setup from framework template"
git tag -a v0.1.0 -m "Initial setup"
```

### Step 5: Start Working

1. Create first feature in `thoughts/project/planning/backlog/`
2. Move to `thoughts/project/work/todo/`
3. Move to `thoughts/project/work/doing/`
4. Begin implementation

---

## Key Concepts

### File-Based Kanban

Work items flow through folders:
```
planning/backlog → work/todo → work/doing → work/done → history/releases/vX.Y.Z/
```

**WIP Limits:**
- doing/ = 1 item (one thing at a time)
- todo/ = 10 items (committed next work)

### Work Item IDs

Naming convention: `{type}-{id}-{description}.md`

**Examples:**
- `feature-001-user-authentication.md`
- `bugfix-101-memory-leak.md`
- `spike-api-investigation.md`

### Release Process

1. Work item moves to `work/done/`
2. Update PROJECT-STATUS.md
3. Update CHANGELOG.md from work item notes
4. Git commit, tag, push
5. Archive to `history/releases/vX.Y.Z/`

### Documentation Standards

- **PROJECT-STATUS.md** = Single source of truth for version/status
- **CHANGELOG.md** = Keep a Changelog format
- **Session histories** = Daily YYYY-MM-DD-SESSION-HISTORY.md files
- **Retrospectives** = After major milestones

---

## Customization

### Required Customizations

You MUST customize these for your project:
- [ ] README.md - Project description, setup, usage
- [ ] PROJECT-STATUS.md - Initial version, status
- [ ] CHANGELOG.md - Project name
- [ ] CLAUDE.md - Project-specific architecture, commands, conventions
- [ ] roadmap.md - Project vision and goals

### Optional Customizations

You MAY customize these:
- WIP limits (default: doing/=1, todo/=10)
- Folder structure (add project-specific folders)
- Templates (add project-specific fields)
- Workflows (document deviations in CLAUDE.md)

**Document all deviations in CLAUDE.md!**

---

## Support for Multiple Projects

If you have multiple projects, you can share the generic CLAUDE.md:

```
ParentFolder/
├── CLAUDE.md (generic framework - shared)
├── Project1/
│   ├── CLAUDE.md (project-specific - inherits from ../CLAUDE.md)
│   └── thoughts/framework/ (copy of framework)
├── Project2/
│   ├── CLAUDE.md (project-specific - inherits from ../CLAUDE.md)
│   └── thoughts/framework/ (copy of framework)
```

Each project-specific CLAUDE.md should reference the parent:
```markdown
**Inherits:** [Generic framework guidelines](../CLAUDE.md)
```

---

## What to NOT Copy (Project-Specific)

When using this template, DO NOT copy these from HPC project:
- ❌ HPC-specific code (scripts/, Jobs/, etc.)
- ❌ Populated work items (backlog/*.md, work/*/*.md)
- ❌ History files (history/*.md)
- ❌ Retrospectives (retrospectives/*.md)
- ❌ Reference docs (reference/*.md)

These are HPC-specific and should be created fresh for your project.

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2025-12-18 | Initial framework template package |

---

## Questions?

- Review `NEW-PROJECT-CHECKLIST.md` for step-by-step guidance
- Read `thoughts/framework/process/kanban-workflow.md` for workflow details
- Read `thoughts/framework/process/version-control-workflow.md` for release process
- Check templates in `thoughts/framework/templates/` for work item structure

---

## License

[Same as your project license]

---

**Created:** 2025-12-18
**Maintained By:** [Your Name/Organization]

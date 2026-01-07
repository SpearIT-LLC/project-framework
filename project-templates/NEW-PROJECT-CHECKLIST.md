# New Project Setup Checklist

**Version:** 2.0.0
**Last Updated:** 2025-12-19

---

## Overview

This checklist guides setup of a new project using the SpearIT project framework. The framework supports multiple levels from single scripts to full applications.

**Start here:** Complete Phase 0 to determine which framework level you need, then follow the appropriate setup path.

---

## Phase 0: Project Classification & Framework Selection

Answer these questions to determine the appropriate framework level:

### Dimension 1: Scope & Complexity

What is the expected size and complexity of this project?

- [ ] **Script** - Single file, linear execution, < 500 lines
- [ ] **Tool** - 2-10 files, simple architecture, focused purpose
- [ ] **Application** - 10-50 files, modular architecture, multiple features
- [ ] **System** - 50+ files, distributed components, complex integrations

### Dimension 2: Lifespan & Evolution

How long will this project be maintained?

- [ ] **Throwaway** - One-time use, no maintenance expected
- [ ] **Short-term** - Weeks to months, minimal evolution
- [ ] **Maintained** - Ongoing updates, multi-year lifespan
- [ ] **Critical** - Production dependency, requires formal governance

### Dimension 3: Team & Collaboration

Who will work on this project?

- [ ] **Solo/Personal** - Just you, no handoff planned
- [ ] **Solo/Professional** - You now, but future-you or handoff likely
- [ ] **Small Team** - 2-5 developers, informal coordination
- [ ] **Large Team** - 6+ developers, requires formal process

### Framework Selection Decision

| If you selected... | Use Framework Level | Jump to Section |
|-------------------|---------------------|-----------------|
| Script + Throwaway/Short-term + Solo/Personal | **Minimal** | [Minimal Setup](#minimal-framework-setup) |
| Script/Tool + Maintained + Solo/Professional | **Light** | [Light Setup](#light-framework-setup) |
| Tool/Application + Maintained + Solo/Professional or Small Team | **Standard** | [Standard Setup](#standard-framework-setup-new-projects) |
| Application/System + Maintained/Critical + Any team size | **Full** | [Standard Setup](#standard-framework-setup-new-projects)* |

*Full Framework = Standard Framework + enhanced ADRs and governance (customized during project)

**Selected Framework Level:** _______________

**Rationale:** _________________________________________

**Date:** _______________

---

## Minimal Framework Setup

**For:** Single scripts, throwaway projects, personal automation

### Required Files

- [ ] **Create your script file** (e.g., `process-data.py`, `backup.ps1`)
- [ ] **Create README.md** from `minimal/README.md` template
  - [ ] Update project name
  - [ ] Describe what the script does
  - [ ] Add usage examples
  - [ ] Complete "Why This Script Exists" section:
    - What problem does this solve?
    - What alternatives did you consider?
    - Why this approach?
  - [ ] Add author and date

### Optional Files

- [ ] **Create .gitignore** (if using git)
- [ ] **Create CHANGELOG.md** (if making multiple versions)

### Git Setup (Optional)

- [ ] Initialize git repository: `git init`
- [ ] Initial commit: `git add . && git commit -m "Initial commit"`
- [ ] Tag if sharing: `git tag v1.0`

**Setup Complete!** You're ready to code.

**Future:** If project grows, see [UPGRADE-PATH.md](UPGRADE-PATH.md) for upgrading to Light framework.

---

## Light Framework Setup

**For:** Small tools, medium lifespan, solo with handoff expected

### Phase 1: Copy Framework Files

- [ ] **Copy light framework template to project location**
  - Copy `project-framework-template/light/*` to your project folder

### Phase 2: Customize Core Documents

- [ ] **Update README.md**
  - [ ] Set project name
  - [ ] Update description
  - [ ] Add installation instructions
  - [ ] Add usage examples
  - [ ] Set author and date

- [ ] **Update PROJECT-STATUS.md**
  - [ ] Set project name
  - [ ] Set initial version (v0.1.0)
  - [ ] Set creation date
  - [ ] Update author name

- [ ] **Update CHANGELOG.md**
  - [ ] Set project name in header
  - [ ] Keep [Unreleased] section
  - [ ] Add initial [0.1.0] entry

- [ ] **Customize CLAUDE.md** (optional, 1-page only)
  - [ ] Set project name
  - [ ] Add quick description
  - [ ] List key commands
  - [ ] Note any project-specific conventions

### Phase 3: Research & Justification

- [ ] **Create thoughts/project/research/justification.md**
  - [ ] Problem statement (1 paragraph)
  - [ ] List existing solutions you checked
  - [ ] Explain why custom solution (2-3 sentences)

### Phase 4: Git Setup

- [ ] **Initialize git repository**
  ```bash
  git init
  git add .
  git commit -m "Initial project setup from Light framework"
  git tag -a v0.1.0 -m "Initial setup"
  ```

**Setup Complete!** Begin development.

**Future:** If project grows beyond 10 files or needs kanban workflow, see [UPGRADE-PATH.md](UPGRADE-PATH.md) for upgrading to Standard framework.

---

## Standard Framework Setup (New Projects)

**For:** Applications, ongoing maintenance, small teams, critical systems

Also called "Full Framework" when using comprehensive ADRs and governance.

### Phase 1: Initial Structure

- [ ] **Copy framework template package to new project location**
  - Copy entire `project-framework-template/` folder
  - Rename to your project name

- [ ] **Initialize git repository**
  ```bash
  cd /path/to/new-project
  git init
  git add .
  git commit -m "Initial project setup from framework template"
  ```

- [ ] **Customize root documents** (files are ready to use - just edit!)

- [ ] **Update README.md**
  - [ ] Replace `[Project Name]` with actual project name
  - [ ] Update project description
  - [ ] Add project lead name
  - [ ] Set creation date
  - [ ] Update folder structure if different

- [ ] **Update PROJECT-STATUS.md**
  - [ ] Set project name
  - [ ] Set initial version (v0.1.0)
  - [ ] Set creation date
  - [ ] Update project lead name

- [ ] **Update CHANGELOG.md**
  - [ ] Set project name in header
  - [ ] Keep [Unreleased] section
  - [ ] Add initial [0.1.0] entry with "Initial project setup"

- [ ] **Update INDEX.md** (if using)
  - [ ] Set project name
  - [ ] Update document links as you create them
  - [ ] Remove sections not applicable

- [ ] **Customize project-specific CLAUDE.md**
  - [ ] Set project name and description
  - [ ] Update "What This System Is" section
  - [ ] Update "What This System Is NOT" section
  - [ ] Add project-specific coding standards
  - [ ] Add project-specific commands
  - [ ] Remove HPC-specific examples
  - [ ] Keep reference to generic `../CLAUDE.md`

---

### Phase 2: Research & Problem Validation

**Purpose:** Validate that this project is worth doing before investing in detailed planning.

- [ ] **Define the problem**
  - [ ] Create `thoughts/project/research/problem-statement.md`
  - [ ] Use PROBLEM-STATEMENT-TEMPLATE.md from `thoughts/framework/templates/`
  - [ ] Write clear 1-2 paragraph problem description
  - [ ] Identify who experiences this problem
  - [ ] Quantify impact (time, cost, frustration)
  - [ ] Define success criteria (what does "solved" mean?)

- [ ] **Research existing solutions**
  - [ ] Create `thoughts/project/research/landscape-analysis.md`
  - [ ] Use LANDSCAPE-ANALYSIS-TEMPLATE.md from `thoughts/framework/templates/`
  - [ ] List commercial solutions
  - [ ] List open-source solutions
  - [ ] List relevant patterns/approaches
  - [ ] Analyze strengths/weaknesses of each
  - [ ] Identify gaps our solution would fill

- [ ] **Assess feasibility**
  - [ ] Create `thoughts/project/research/feasibility.md`
  - [ ] Use FEASIBILITY-TEMPLATE.md from `thoughts/framework/templates/`
  - [ ] Technical: Do we have/can we learn required skills?
  - [ ] Technical: Are required tools/platforms available?
  - [ ] Resource: Time available vs estimated effort?
  - [ ] Value: Benefit worth the effort vs buying/adapting existing?

- [ ] **Make go/no-go decision**
  - [ ] Create `thoughts/project/research/project-justification.md`
  - [ ] Use PROJECT-JUSTIFICATION-TEMPLATE.md from `thoughts/framework/templates/`
  - [ ] Document decision: BUILD, BUY, ADAPT, or ABANDON
  - [ ] If BUILD: Explain unique value we're adding
  - [ ] If BUY/ADAPT: Document which solution and why
  - [ ] If ABANDON: Document learnings, archive project
  - [ ] Get stakeholder approval if applicable

- [ ] **Create project definition** (if GO decision)
  - [ ] Create `thoughts/project/reference/project-definition.md`
  - [ ] Use PROJECT-DEFINITION-TEMPLATE.md from `thoughts/framework/templates/`
  - [ ] What are we building? (1-2 sentence elevator pitch)
  - [ ] Why are we building it? (problem statement)
  - [ ] Who is it for? (target users/use cases)
  - [ ] What makes it different? (unique value)
  - [ ] What does success look like? (measurable outcomes)
  - [ ] What are we NOT building? (scope boundaries)

**Exit criteria:** Clear project definition exists OR decision to abandon/buy documented

---

### Phase 3: Project Planning

**Prerequisites:** Phase 2 complete with GO decision and project definition written

- [ ] **Create initial roadmap**
  - [ ] Open `thoughts/project/planning/roadmap.md`
  - [ ] Define high-level project goals
  - [ ] Identify initial version targets (v0.1.0, v0.2.0, v1.0.0)
  - [ ] List major features/capabilities

- [ ] **Create initial backlog items** (optional - can do as you go)
  - [ ] Create 2-3 initial feature docs in `thoughts/project/planning/backlog/`
  - [ ] Use `feature-NNN-description.md` naming convention
  - [ ] Use FEATURE-TEMPLATE.md for structure
  - [ ] Start IDs at FEAT-001

- [ ] **Move first item to work/todo/**
  - [ ] Select highest priority backlog item
  - [ ] Move to `thoughts/project/work/todo/`
  - [ ] Update roadmap to reflect status

---

### Phase 4: First Commit and Work

- [ ] **Commit initial setup**
  ```bash
  git add .
  git commit -m "Project setup: Initial documentation and framework"
  git tag -a v0.1.0 -m "Initial project setup"
  ```

- [ ] **Start first work item**
  - [ ] Move one item from todo/ to doing/
  - [ ] Create git branch: `git checkout -b feature/001-description`
  - [ ] Begin implementation

- [ ] **Verify WIP limits**
  - [ ] Check `thoughts/project/work/doing/.limit` contains "1"
  - [ ] Check `thoughts/project/work/todo/.limit` contains "10"

**Setup Complete!** Follow the Standard workflow for ongoing development.

---

## Existing Project Integration (Projects Already Started)

Use this section when adding the framework to a project that's already underway.

### Phase 1: Assessment

- [ ] **Assess current project state**
  - [ ] What version is the project? (Determine current version number)
  - [ ] What documentation exists? (README, docs, etc.)
  - [ ] What version control is used? (Git, other, none?)
  - [ ] What work items are in progress?
  - [ ] What work items are planned?

- [ ] **Decide integration approach**
  - [ ] **Option A: Clean slate** - Archive old docs, start fresh with framework
  - [ ] **Option B: Gradual migration** - Keep existing docs, add framework alongside
  - [ ] **Option C: Hybrid** - Migrate some, keep some (recommended)

---

### Phase 2: Framework Integration

- [ ] **Copy framework to existing project**
  - [ ] Copy `CLAUDE.md` (generic) to project root **parent directory**
  - [ ] Copy `thoughts/framework/` folder to project
  - [ ] Create `thoughts/project/` folder structure

- [ ] **Create project-specific CLAUDE.md**
  - [ ] Copy `CLAUDE-TEMPLATE.md` → project root `CLAUDE.md`
  - [ ] Document existing project architecture
  - [ ] Document existing coding standards
  - [ ] Reference generic `../CLAUDE.md`
  - [ ] Add "Migrated from existing project" note

- [ ] **Integrate or create PROJECT-STATUS.md**
  - [ ] If exists: Add framework-standard header
  - [ ] If new: Use PROJECT-STATUS-TEMPLATE.md
  - [ ] Document current version
  - [ ] Document completed work to date
  - [ ] List all major components/modules with status

- [ ] **Integrate or create CHANGELOG.md**
  - [ ] If exists: Verify Keep a Changelog format
  - [ ] If not compatible: Create new, archive old as CHANGELOG-OLD.md
  - [ ] If new: Use CHANGELOG-TEMPLATE.md
  - [ ] Add [Unreleased] section
  - [ ] Document recent changes if possible

- [ ] **Integrate or create README.md**
  - [ ] If exists: Add PROJECT-STATUS.md reference to header
  - [ ] If exists: Add "Last Updated" field
  - [ ] If new: Use README-TEMPLATE.md

- [ ] **Create INDEX.md** (optional but recommended)
  - [ ] Use INDEX-TEMPLATE.md
  - [ ] Link to existing documentation
  - [ ] Organize by framework categories

---

### Phase 3: Work Item Migration

- [ ] **Capture in-progress work**
  - [ ] List all current work (what you're actively working on)
  - [ ] Create feature/bugfix docs in `thoughts/project/work/doing/`
  - [ ] Use appropriate templates (FEATURE, BUGFIX, SPIKE)
  - [ ] Assign IDs starting at FEAT-001, BUG-101

- [ ] **Capture planned work**
  - [ ] List all planned features/fixes
  - [ ] Create docs in `thoughts/project/planning/backlog/`
  - [ ] Use appropriate templates
  - [ ] Continue ID sequence from in-progress items

- [ ] **Capture completed work (optional)**
  - [ ] Review git history or existing docs
  - [ ] Create retrospective feature docs in `thoughts/project/history/releases/vX.Y.Z/`
  - [ ] Document major features/changes
  - [ ] This helps build institutional knowledge

- [ ] **Create initial roadmap**
  - [ ] Document overall project vision
  - [ ] List completed major features (if known)
  - [ ] List in-progress items with IDs
  - [ ] List planned items with IDs
  - [ ] Set version targets (next minor, next major)

---

### Phase 4: Git Integration

- [ ] **Verify git repository exists**
  ```bash
  git status  # Should show existing repo
  ```

- [ ] **Create framework integration branch** (optional but recommended)
  ```bash
  git checkout -b framework/integration
  ```

- [ ] **Commit framework files**
  ```bash
  git add CLAUDE.md thoughts/ README.md PROJECT-STATUS.md CHANGELOG.md INDEX.md
  git commit -m "Framework: Integrate SpearIT project framework

  - Added generic CLAUDE.md and project-specific CLAUDE.md
  - Added thoughts/framework/ with templates and processes
  - Created thoughts/project/ folder structure
  - Integrated PROJECT-STATUS.md as single source of truth
  - Updated/created CHANGELOG.md with Keep a Changelog format
  - Created INDEX.md for documentation navigation
  - Migrated existing work items to framework structure
  "
  ```

- [ ] **Merge to main** (if using integration branch)
  ```bash
  git checkout main
  git merge framework/integration
  git branch -d framework/integration
  ```

- [ ] **Tag current version** (if not already tagged)
  ```bash
  git tag -a vX.Y.Z -m "Current version at framework integration"
  ```

---

### Phase 5: Workflow Adoption

- [ ] **Verify WIP limits**
  - [ ] Check `thoughts/project/work/doing/.limit` contains "1"
  - [ ] Check `thoughts/project/work/todo/.limit` contains "10"
  - [ ] Adjust if needed based on team size

- [ ] **Review kanban workflow documentation**
  - [ ] Read `thoughts/framework/process/kanban-workflow.md`
  - [ ] Understand folder structure and flow
  - [ ] Review work item naming conventions

- [ ] **Review version control workflow**
  - [ ] Read `thoughts/framework/process/version-control-workflow.md`
  - [ ] Understand release process
  - [ ] Review git branching strategy

- [ ] **Plan retrospective** (recommended)
  - [ ] Schedule retrospective after 5 releases
  - [ ] Review WIP limits
  - [ ] Assess framework fit
  - [ ] Adjust as needed

---

## Phase 4 (All Projects): First Session History

- [ ] **Create first session history document**
  - [ ] Create `thoughts/project/history/YYYY-MM-DD-SESSION-HISTORY.md`
  - [ ] Document today's setup work
  - [ ] List decisions made
  - [ ] Note any deviations from standard framework
  - [ ] Set tone for future session histories

---

## Phase 5 (All Projects): Verification

- [ ] **Verify folder structure**
  ```bash
  # Should see:
  # - CLAUDE.md (generic, in parent if multiple projects)
  # - ProjectName/CLAUDE.md (project-specific)
  # - ProjectName/README.md
  # - ProjectName/PROJECT-STATUS.md
  # - ProjectName/CHANGELOG.md
  # - ProjectName/INDEX.md (optional)
  # - ProjectName/thoughts/framework/
  # - ProjectName/thoughts/project/planning/
  # - ProjectName/thoughts/project/work/todo/
  # - ProjectName/thoughts/project/work/doing/
  # - ProjectName/thoughts/project/work/done/
  # - ProjectName/thoughts/project/history/
  ```

- [ ] **Verify .limit files**
  ```bash
  cat thoughts/project/work/doing/.limit   # Should contain "1"
  cat thoughts/project/work/todo/.limit    # Should contain "10"
  ```

- [ ] **Verify git setup**
  ```bash
  git status                # Should show clean or expected state
  git tag -l                # Should show version tags
  git log --oneline -5      # Should show commits
  ```

- [ ] **Test Claude integration**
  - [ ] Open Claude Code in project directory
  - [ ] Verify CLAUDE.md is loaded (check /context command)
  - [ ] Ask Claude about project structure
  - [ ] Verify Claude understands framework

---

## Phase 6 (All Projects): First Work Item

- [ ] **Select first work item to complete with framework**
  - [ ] Choose small, well-defined item
  - [ ] Move to work/doing/
  - [ ] Create git branch: `git checkout -b feature/NNN-description`

- [ ] **Work through complete workflow**
  - [ ] Implement feature/fix
  - [ ] Update work item doc with progress
  - [ ] Keep CHANGELOG notes in work item
  - [ ] Test thoroughly

- [ ] **Execute first release with framework**
  - [ ] Move item to work/done/
  - [ ] Follow version-control-workflow.md release checklist
  - [ ] Update PROJECT-STATUS.md
  - [ ] Update CHANGELOG.md
  - [ ] Commit, tag, push
  - [ ] Archive to history/releases/vX.Y.Z/

- [ ] **Reflect on process**
  - [ ] Did workflow feel natural?
  - [ ] Any friction points?
  - [ ] Document in session history
  - [ ] Adjust if needed (and document why)

---

## Customization Notes

### When to Deviate from Framework

**It's OK to customize if:**
- Project has unique constraints (language, platform, team size)
- Different tooling required (not git, not markdown)
- Different workflow better suits project (explain in CLAUDE.md)

**Document all deviations in project-specific CLAUDE.md:**
```markdown
## Deviations from Framework

### WIP Limit = 2 (instead of 1)
**Reason:** Team of 2 developers, each works on separate items
**Decision Date:** YYYY-MM-DD
**Review:** Next retrospective
```

---

## Common Issues and Solutions

### Issue: Project doesn't use git
**Solution:** Framework still works, manual versioning in PROJECT-STATUS.md
**Note:** Document version control approach in CLAUDE.md

### Issue: Team larger than 1-2 people
**Solution:** Increase WIP limits, consider separate doing/ folders per person
**Note:** Document in CLAUDE.md, may need different workflow

### Issue: Existing documentation conflicts
**Solution:** Archive old docs to thoughts/project/archive/, reference in INDEX.md
**Note:** Document migration decisions in session history

### Issue: Project already has version 5.2.1
**Solution:** Continue with existing version numbering, document in PROJECT-STATUS.md
**Note:** Framework works with any version scheme

---

## Success Criteria

**You've successfully integrated the framework when:**

✅ Claude can answer questions about project structure
✅ Work items flow smoothly through kanban folders
✅ Releases follow documented process
✅ PROJECT-STATUS.md stays current
✅ CHANGELOG.md stays current
✅ Session histories capture decisions
✅ Retrospectives identify improvements
✅ Framework feels helpful, not burdensome

---

## Related Documents

- [kanban-workflow.md](thoughts/framework/process/kanban-workflow.md) - Work item lifecycle
- [version-control-workflow.md](thoughts/framework/process/version-control-workflow.md) - Release process
- [documentation-standards.md](thoughts/framework/process/documentation-standards.md) - Doc formatting

---

## Next Steps After Setup

1. **First work item** - Complete one feature/bugfix using framework
2. **First retrospective** - After 5 releases, review what's working
3. **Adjust as needed** - Framework should serve project, not constrain it
4. **Share learnings** - Update framework if you discover better patterns

---

**Setup Complete?** Move this checklist to `thoughts/project/reference/` for future reference.

**Questions?** Review CLAUDE.md or consult framework documentation.

---

**Last Updated:** 2025-12-18
**Version:** 1.0.0

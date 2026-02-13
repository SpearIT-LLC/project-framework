# Feature: SpearIT Project Framework Plugin (MVP - Lightweight Edition)

**ID:** FEAT-118
**Type:** Feature
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-02-08
**Updated:** 2026-02-13 (TASK-126 complete, ready for submission)
**Status:** Ready for Submission
**Theme:** Distribution & Integration
**Target:** Ship within 7 days (Day 5 - on track)

---

## ✅ SCOPE REFINEMENT COMPLETE (2026-02-13)

**Pre-submission product review identified scope reduction opportunity.**

**Original scope:** 5 commands (help, new, move, next-id, session-history)
**Final MVP scope:** 3 commands (help, new, move) ✅

**Removed from v1.0:**
- **session-history** → Deferred to full framework plugin (documentation feature, not core workflow)
- **next-id** → Integrated into `new` command (implementation detail should not be user-facing)

**Rationale:**
- Focused MVP on core workflow (discover, create, organize)
- Reduced cognitive load and command bloat
- Cleaner upgrade path to full framework plugin
- Better user experience (auto-ID assignment vs manual query)

**Implementation:** [TASK-126](../done/TASK-126-finalize-plugin-mvp.md) ✅ COMPLETE (2026-02-13)

**Results:**
- Plugin package: 51.3 KB (3 commands, 3 skills, templates, docs)
- All testing complete (CLI + VSCode clean install)
- Version: 1.0.0 (production-ready)

**Timeline impact:** None - Day 5 of 7, on schedule for submission

---

## Summary

Create a **Minimum Viable Plugin** ("Lightweight Edition") of the SpearIT Project Framework to distribute file-based Kanban workflow through the Claude Code plugin marketplace.

**MVP Scope:** 3 core commands, 3 condensed skills, professional documentation. Ship in 1 week, iterate based on user feedback.

**Strategic Positioning:** Plugin and Framework are complementary products - plugin is the gateway, framework is the comprehensive solution.

---

## Problem Statement

**Context:** Framework evolved from real project use (HPC Job Queue Prototype) and is currently used internally at SpearIT Solutions. Now transitioning from internal tool to public offering.

**What problems does this solve?**

**Problem 1: Framework not discoverable**
- Framework has zero external users (5 versions, never published)
- No presence in Claude Code plugin ecosystem (official distribution channel)
- Potential users can't find it through normal discovery
- Plugin marketplace is how Claude Code ecosystem works

**Problem 2: No validated demand**
- Built in isolation without external user feedback
- Don't know if others will find value in file-based Kanban approach
- Need to test market before investing in comprehensive features
- Plugin is low-risk validation mechanism

**Problem 3: High barrier to try**
- Full framework requires project restructuring (significant commitment)
- No lightweight "try before you commit" option
- Users with existing projects can't easily test the workflow
- Need entry point that works in any project

**Problem 4: Internal use could be better**
- Even for internal SpearIT use, plugin would improve workflow
- Commands would work across multiple projects
- Skills would provide AI context automatically
- Polishing for external use raises internal quality

**Who is affected?**
- **Primary:** SpearIT Solutions (internal use, improved tooling)
- **Secondary:** Solo developers and small teams using Claude Code
- **Tertiary:** Claude Code community seeking lightweight project management

**Risk Profile: LOW**
- Framework will continue to be used internally regardless of external adoption
- External users are bonus, not requirement
- Plugin serves dual purpose: external distribution + internal tool refinement
- Shipping doesn't create new dependencies or commitments

---

## Requirements

### MVP Scope (v1.0)

**Repository Structure:**
```
project-framework/
├── framework/                  # Framework source (existing)
├── templates/                  # Project templates (existing)
├── tools/
│   └── Build-Plugin.ps1        # 🆕 Creates distributable ZIP
├── distrib/
│   └── plugin-light/           # 🆕 Build output folder
│       └── spearit-framework-light-v1.0.0.zip
└── plugins/                    # 🆕 Plugin development (matches Anthropic pattern)
    └── spearit-framework-light/    # Lightweight edition plugin
        ├── .claude-plugin/
        │   └── plugin.json     # name: "spearit-framework-light"
        ├── commands/           # 4 commands only
        │   ├── fw-move.md
        │   ├── fw-next-id.md
        │   ├── fw-session-history.md
        │   └── fw-help.md
        ├── skills/             # 3 condensed skills
        │   ├── kanban-workflow.md
        │   ├── work-items.md
        │   └── moving-items.md
        └── README.md
```

**Note:** Full framework plugin will be `plugins/spearit-framework/` (future)

**Commands to Package (3 core commands - MVP v1.0):**
- [ ] `/spearit-framework-light:help` - Command reference (STANDARD - discovery)
- [ ] `/spearit-framework-light:new` - Create work items with auto-ID assignment (CORE - creation)
- [ ] `/spearit-framework-light:move` - Move work items through workflow (CORE - organization)

**Note:** Files keep `fw-` prefix for clarity (`fw-move.md`), but commands drop it (`:move`)

**Deferred to full framework plugin (based on product review):**
- `/spearit-framework:session-history` - Document work sessions (documentation feature)
- `/spearit-framework:status` - Project status summary
- `/spearit-framework:wip` - Show current work in progress
- `/spearit-framework:backlog` - Backlog review and prioritization
- `/spearit-framework:topic-index` - Framework reference
- `/spearit-framework:roadmap` - AI-guided roadmap creation

**Removed from v1.0 (implementation details):**
- `next-id` - Integrated into `new` command (users shouldn't think about IDs)

**Skills Documentation (3 files, ~250 lines total):**
- [ ] `kanban-workflow.md` - File-based Kanban concept (~100 lines)
- [ ] `work-items.md` - Creating and managing work items (~75 lines)
- [ ] `moving-items.md` - Workflow transitions and policies (~75 lines)

**Plugin Metadata:**
- [ ] Name: "spearit-framework-light" (internal name/namespace)
- [ ] Display Name: "SpearIT Project Framework - Lightweight Edition"
- [ ] Version: 1.0.0
- [ ] Author: Gary Elliott / SpearIT Solutions
- [ ] Keywords: kanban, project-management, workflow, solo-developer, small-team, file-based
- [ ] Homepage: https://github.com/SpearIT-LLC/project-framework

**Distribution:**
- [ ] Build script creates `distrib/plugin-light/spearit-framework-light-v1.0.0.zip`
- [ ] Submit to official Anthropic plugin directory only (defer third-party to v1.1+)
- [ ] Update framework README with plugin installation option
- [ ] Full framework plugin will use namespace: `spearit-framework` (future)

### Quality Standards

**User's Quality Bar: "Professional, reasonably robust, not buggy, easy to use"**

**Professional:**
- [ ] Clean, well-written README with clear purpose
- [ ] Proper plugin.json metadata
- [ ] Each command has usage examples
- [ ] Skills are clear and well-organized

**Reasonably Robust:**
- [ ] Commands work as documented
- [ ] Helpful error messages
- [ ] Handles common edge cases
- [ ] No silent failures

**Not Buggy:**
- [ ] Each command tested before shipping
- [ ] Commands work from plugin location (not just local)
- [ ] Skills load properly in Claude context
- [ ] No broken references or links

**Easy to Use:**
- [ ] Clear installation instructions
- [ ] Quick start guide in README
- [ ] Examples for each command
- [ ] Skills explain concepts simply (not academically)

---

## Strategic Positioning

### Product Strategy: Plugin + Framework as Complementary Products

**Two Products, Two Audiences:**

**Product 1: Plugin (Lightweight Edition)**
- **Target:** Users wanting lightweight project tracking in existing projects
- **Value:** Install and use immediately, no restructuring required
- **Scope:** Core Kanban workflow (3 commands, 3 skills)
- **Entry barrier:** Very low (just install plugin)

**Product 2: Framework (Comprehensive Edition)**
- **Target:** Users starting new projects or wanting complete structure
- **Value:** Full scaffolding, templates, patterns, architecture guidance
- **Scope:** Everything (templates, docs, patterns, all commands)
- **Entry barrier:** Higher (requires project setup/restructuring)

**Relationship:**
- Plugin is **gateway** to Framework
- Plugin ⊂ Framework (plugin is subset)
- Users discover via plugin → graduate to framework when ready
- Both promote each other, neither competes

### Plugin v1.0 Positioning

**Name:** "SpearIT Project Framework - Lightweight Edition"

**Description:**
```
AI collaboration partner to plan and organize your Kanban workflow.
Manage work items (backlog → todo → doing → done) directly in
your repository without external tools.

Features:
• Create work items with auto-assigned IDs
• Move items through workflow with AI-guided planning
• Simple folder-based structure (no database required)
• Works with git - your work items are versioned

Part of the SpearIT Project Framework. For complete project
scaffolding with templates and full methodology, see:
https://github.com/SpearIT-LLC/project-framework

Perfect for: Solo developers, small teams, lightweight project tracking
```

**Keywords:** kanban, project-management, workflow, solo-developer, small-team, file-based, git

### Why This Positioning Works

1. **No artificial ceiling** - Plugin can grow with user feedback
2. **Clear upgrade path** - Plugin → Framework (not competing)
3. **Two entry points** - Existing projects (plugin) vs new projects (framework)
4. **Mutual promotion** - Both products promote each other
5. **Realistic expectations** - "Lightweight" sets correct scope

---

## MVP Implementation Plan

**Target: Ship within 7 days**

### Day 1-2: Create Plugin Package

**Create plugin directory (matching Anthropic's pattern):**
- [ ] Create `plugins/spearit-framework-light/` directory
- [ ] Create `plugins/spearit-framework-light/.claude-plugin/` folder
- [ ] Write `plugin.json` with metadata (name: "spearit-framework-light")
- [ ] Copy 4 commands from `.claude/commands/` to `plugins/spearit-framework-light/commands/`:
  - fw-move.md
  - fw-next-id.md
  - fw-session-history.md
  - fw-help.md
- [ ] Update command invocation to namespaced format without fw- prefix (e.g., `/spearit-framework-light:move`)
- [ ] Test commands work from plugin location

### Day 3: Create Skills Documentation

**Extract and condense from framework docs:**
- [ ] `skills/kanban-workflow.md` - File-based Kanban concept (~100 lines)
- [ ] `skills/work-items.md` - Creating/managing work items (~75 lines)
- [ ] `skills/moving-items.md` - Workflow transitions (~75 lines)
- [ ] Keep total under 300 lines (Claude context limits)
- [ ] Focus on concepts, not implementation details

### Day 4: Write README & Build Script

**README.md:**
- [ ] Installation instructions
- [ ] Quick start guide (5-minute workflow)
- [ ] Command reference with examples
- [ ] Link to full framework for comprehensive users
- [ ] Professional, welcoming tone

**Build Script:**
- [ ] Create `tools/Build-Plugin.ps1`
- [ ] Packages `plugins/spearit-framework-light/` directory into ZIP
- [ ] Output: `distrib/plugin-light/spearit-framework-light-v1.0.0.zip`
- [ ] Verify structure matches Anthropic plugin standards
- [ ] Ensure ZIP contains the named plugin folder structure

### Day 5: Testing ✅ COMPLETE

**Test scenarios:**
- [x] Install plugin locally and test each command ✅
- [x] Verify skills load in Claude context ✅
- [x] Check for broken references/links ✅
- [x] Test in framework project (no conflicts) ✅
- [x] Test in non-framework project (graceful degradation) ✅
- [x] Fix any bugs found ✅

**Testing completed via TASK-126** (CLI and VSCode clean install)

### Day 6-7: Package, Submit & Document

**Package:**
- [ ] Run build script, create final ZIP
- [ ] Final testing of packaged plugin
- [ ] Tag version: v1.0.0

**Submit:**
- [ ] Submit to Anthropic marketplace
- [ ] Complete submission form
- [ ] Wait for review/approval

**Document:**
- [ ] Update framework README with plugin option
- [ ] Add installation instructions
- [ ] Note: Plugin for existing projects, Framework for new projects

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->

### Milestone 1: Research Anthropic Plugin Standards ✅ COMPLETE
- [x] Research official Anthropic plugin structure and standards
- [x] Document findings in `project-hub/research/plugin-anthropic-standards.md`
- [x] Identify required files, structure, and metadata format
- [x] Verify namespace and command naming conventions
- [x] **STOP - Review findings before proceeding** ✅ Reviewed 2026-02-09

### Milestone 2: Create Plugin Package Structure ✅ COMPLETE
- [x] Create `plugins/spearit-framework-light/` directory
- [x] Create `.claude-plugin/` subdirectory
- [x] Write `plugin.json` with proper metadata matching Anthropic standards
- [x] Create `commands/` and `skills/` directories
- [x] Verify structure matches Anthropic pattern exactly
- [x] **STOP - Review structure before copying commands** ✅ Reviewed 2026-02-09

### Milestone 3: Adapt Commands for Standalone Operation ✅ COMPLETE

**Approach:** Prototype each command, test standalone operation, iterate based on learnings.

**Milestone 3a: Prototype fw-next-id (Standalone)** ✅
- [x] Remove PowerShell script dependency
- [x] Update command to use AI-driven directory scanning
- [x] Handle case: project-hub/ structure exists
- [x] Handle case: No structure exists (start at 001 or offer setup)
- [x] Test standalone operation
- [x] **STOP - Review fw-next-id prototype** ✅ Reviewed 2026-02-09

**Milestone 3b: Prototype fw-help (Standalone)** ✅
- [x] Verify command reads from plugin's commands/ directory
- [x] Update references to be plugin-relative
- [x] Test standalone operation
- [x] **STOP - Review fw-help prototype** ✅ Reviewed 2026-02-09

**Milestone 3c: Prototype fw-session-history (Standalone)** ✅
- [x] Remove framework template dependencies
- [x] Update to generate from git history + conversation context
- [x] Create self-contained markdown structure
- [x] Test standalone operation
- [x] **STOP - Review fw-session-history prototype** ✅ Reviewed 2026-02-09
- [x] Template extraction completed (2026-02-11) - Uses external template file

**Milestone 3d: Prototype fw-move (Standalone)** ✅
- [x] Remove framework.yaml and workflow-guide.md references
- [x] Keep embedded transition rules and checklists
- [x] Simplify validation (self-contained)
- [x] Test standalone operation
- [x] **STOP - Review fw-move prototype** ✅ Reviewed 2026-02-09

**Milestone 3e: Prototype fw-new (FEAT-119 - Completed 2026-02-09)** ✅
- [x] Created conversational work item creation command
- [x] Embedded PM/PO mindset directly in command
- [x] Template extraction completed (2026-02-11) - Uses external template files

### Milestone 4: Create Skills Documentation ✅ COMPLETE
- [x] Extract and condense `skills/kanban-workflow.md` (~100 lines)
- [x] Create `skills/work-items.md` (~75 lines)
- [x] Create `skills/moving-items.md` (~75 lines)
- [x] Verify total under 300 lines (Claude context limits)
- [x] **STOP - Review skills documentation** ✅ Reviewed 2026-02-09

### Milestone 5: Write README and Documentation ✅ COMPLETE
- [x] Write `README.md` with installation instructions
- [x] Add quick start guide (5-minute workflow)
- [x] Add command reference with examples
- [x] Add link to full framework
- [x] Verify professional tone and completeness
- [x] **STOP - Review README** ✅ Reviewed 2026-02-09

### Milestone 6: Create Build Script ✅ COMPLETE
- [x] Create `tools/Build-Plugin.ps1`
- [x] Script packages plugin directory into ZIP
- [x] Output to `distrib/plugin-light/spearit-framework-light-v1.0.0.zip`
- [x] Verify ZIP structure matches Anthropic standards
- [x] Test build process
- [x] **STOP - Review build output** ✅ Reviewed 2026-02-09

### Milestone 7: Testing ✅ COMPLETE
- [x] Install plugin locally and test each command
- [x] Verify skills load in Claude context
- [x] Check for broken references/links
- [x] Test in framework project (no conflicts)
- [x] Test in non-framework project (graceful behavior)
- [x] Fix any bugs found
- [x] **STOP - Review test results** ✅ Reviewed 2026-02-10
- [x] FEAT-120 created to improve testing infrastructure (completed 2026-02-11)
- [x] Template extraction validated (2026-02-11) - Custom folders copy to cache successfully

### Milestone 8: Package and Documentation ✅ COMPLETE
- [x] Run build script, create final ZIP ✅ Built 2026-02-13 (51.3 KB)
  - Verified contents: 3 commands, 3 skills, 3 templates, LICENSE, README.md, CHANGELOG.md
  - Location: `distrib/plugin-light/spearit-framework-light-v1.0.0.zip`
- [x] Final testing of packaged plugin ✅ TASK-126 complete
- [x] Decide on plugin license (MIT recommended) ✅ Decided 2026-02-09
- [x] Create LICENSE file in plugin directory ✅ Created 2026-02-09
- [ ] Make repository public (or document access plan) ⏳ Pre-submission
- [ ] Update framework README with plugin option ⏳ Pre-submission
- [ ] Tag version: v1.0.0 ⏳ Pre-submission
- [x] **Review before submission** ✅ Ready

**Blockers resolved:**
- [x] FEAT-120 (Testing infrastructure) ✅ Completed 2026-02-11
- [x] FEAT-119 (New command) ✅ Completed 2026-02-09
- [x] TASK-126 (MVP scope reduction) ✅ Completed 2026-02-13

### Milestone 9: Submit to Marketplace
- [ ] Submit to Anthropic marketplace
- [ ] Complete submission form
- [ ] Document submission status
- [ ] **COMPLETE**

---

## Acceptance Criteria

### MVP Plugin Package (v1.0)
- [x] Plugin structure in `plugins/spearit-framework-light/` (matches Anthropic pattern) ✅
- [x] Follows official Anthropic plugin standards exactly ✅
- [x] 3 core commands functional with namespace (e.g., `/spearit-framework-light:move`) ✅
- [x] 3 skills files (~250 lines total) ✅
- [x] README.md professional and complete ✅
- [x] Build script creates `distrib/plugin-light/spearit-framework-light-v1.0.0.zip` ✅
- [x] ZIP package successfully installs locally ✅
- [x] No conflicts with local `.claude/commands/` (different namespace) ✅

### Quality Bar Met
- [x] **Professional:** Clean README, proper metadata, examples for each command ✅
- [x] **Reasonably Robust:** Commands work as documented, helpful errors, handles edge cases ✅
- [x] **Not Buggy:** All commands tested, no broken references, skills load correctly ✅
- [x] **Easy to Use:** Clear installation, quick start guide, simple skill explanations ✅

### Testing Complete
- [x] Plugin tested with local installation ✅
- [x] All 3 commands execute without errors ✅
- [x] Skills provide Claude with useful context ✅
- [x] No conflicts when used in framework project ✅
- [x] Graceful behavior in non-framework project ✅

### Distribution
- [ ] Submitted to official Anthropic plugin directory
- [ ] Framework README updated with plugin installation option
- [ ] Version 1.0.0 tagged

### Success Criteria (Week 1)
- [ ] Plugin available for installation (or clear feedback on approval status)
- [ ] Works for internal SpearIT use
- [ ] Professional presentation ready for external users

### Success Metrics (Optional - Month 1)
- 10+ external installs
- At least 1 user feedback/question received
- Zero critical bugs reported
- Decision made on v1.1 features based on feedback

---

## Design Decisions

### Decision 1: MVP Scope - 4 Commands vs 9 Commands

**Product Owner Context:** Ship in 1 week, iterate based on feedback

**Options:**
- Include all 9 commands ❌ (delays shipping, over-scoped for MVP)
- Include 4 core commands ✅ **CHOSEN**
- Include separate plugins for different features ❌ (too complex for MVP)

**Originally Chosen:** 4 core commands (fw-move, fw-next-id, fw-session-history, fw-help)
**Final Scope:** 3 core commands (help, new, move) ✅

**Rationale:**
- move = core workflow (organizing items through Kanban stages)
- new = work item creation (with integrated ID assignment)
- help = standard expectation (user reference)
- Minimum viable set to make file-based Kanban work
- Defer session-history to full framework plugin (documentation feature)
- Integrated next-id into new command (better UX - users don't think about IDs)
- Defer fw-status, fw-wip, fw-backlog, fw-topic-index, fw-roadmap to full framework plugin
- Ship fast, learn from users, iterate

**Updated via TASK-126 (2026-02-12):** Scope refined from 4 → 3 commands before submission

### Decision 2: Plugin Repository Structure

**Options:**
- Separate git repository for plugin ❌ (more overhead, slower to ship)
- Plugin subdirectory in framework repo ✅ **CHOSEN**
- Plugin replaces framework (massive restructure) ❌ (deferred)

**Chosen:** `plugins/spearit-framework-light/` in current framework repository (matches Anthropic pattern)

**Rationale:**
- Single repo to maintain for MVP
- Matches official Anthropic plugin development structure exactly
- Build script packages plugin for distribution
- Can extract to separate repo later if needed
- Commands copied from `.claude/commands/` to `plugins/spearit-framework-light/commands/`
- Supports multiple plugin editions side-by-side (light + full future)
- Fast to ship, low risk

### Decision 2a: Plugin Naming and Namespace

**Options:**
- Use short namespace like `fw` ❌ (conflicts with command prefix)
- Use `spearit-framework` for both editions ❌ (can't distinguish light vs full)
- Use descriptive namespaces per edition ✅ **CHOSEN**

**Chosen:**
- Lightweight edition: `spearit-framework-light` → `/spearit-framework-light:move`
- Full edition (future): `spearit-framework` → `/spearit-framework:move`
- Local commands (unchanged): `/fw-move` (no namespace, prefix needed)

**Command name strategy:**
- Files keep `fw-` prefix for clarity in filesystem (`fw-move.md`)
- Commands drop prefix (namespace provides context: `:move` not `:fw-move`)
- Follows Anthropic pattern (`/commit-commands:commit` not `:git-commit`)

**Rationale:**
- Clear distinction between plugin editions
- No conflicts with local `.claude/commands/` (different namespace)
- Enables dogfooding both plugin and local commands simultaneously
- Full edition gets cleaner namespace (upgrade incentive)
- Shorter commands improve UX (namespace already verbose)
- Namespace provides sufficient context (no need for fw- prefix)
- Branding: "SpearIT" is permitted (no Anthropic policy against branded plugins)

### Decision 3: Product Positioning - Plugin vs Framework

**Options:**
- Plugin-primary (framework becomes secondary) ❌ (premature)
- Plugin-only (abandon framework) ❌ (loses comprehensive value)
- Plugin + Framework as complementary ✅ **CHOSEN**

**Chosen:** Plugin and Framework are complementary products

**Plugin positioning:** "Lightweight Edition" - gateway to framework
**Framework positioning:** "Comprehensive Edition" - full project scaffolding

**Relationship:**
- Plugin = Subset of framework (4 commands, condensed skills)
- Framework = Complete solution (all commands, templates, patterns)
- Users discover via plugin → graduate to framework when ready
- Both promote each other, serve different needs

**Rationale:**
- Two entry points: existing projects (plugin) vs new projects (framework)
- No artificial ceiling - plugin can grow based on user feedback
- Clear value distinction: lightweight vs comprehensive
- Realistic for MVP - test market before comprehensive investment

### Decision 4: Versioning Strategy

**Chosen:** Independent semantic versioning (plugin v1.0, framework v3.x)

**Rationale:**
- Plugin is new product starting at v1.0
- Framework is mature at v3.x
- Plugin may evolve differently based on user feedback
- Standard practice in plugin ecosystems

### Decision 5: Distribution Strategy

**Chosen:** Official Anthropic marketplace only for v1.0

**Rationale:**
- Official marketplace is primary distribution channel
- Auto-update support
- Better visibility and trust
- Third-party marketplaces can follow if successful
- Focus on single high-quality submission

### Decision 6: Licensing and Repository Visibility

**Status:** DEFERRED (decide before submission)

**Repository Visibility:**
- **Current state:** Private GitHub repository
- **Required for submission:** Likely public (for transparency/trust model)
- **Decision point:** Before Milestone 9 (submission)

**Plugin License Options:**
- **MIT License** ✅ (most common for Claude Code plugins, simple, permissive)
- **Apache 2.0** (also popular, includes patent protection)
- **Proprietary** ❌ (conflicts with transparency/trust model)

**Considerations:**
- Anthropic has no explicit license requirement for third-party plugins
- Marketplace emphasizes transparency and user trust
- Public repos with permissive licenses align with ecosystem norms
- Plugin license can differ from framework license
- Users must be able to inspect code before trusting/installing

**Rationale for deferring:**
- Focus on functionality first (Milestones 1-7)
- License decision needed before submission (Milestone 9)
- Repository visibility can be changed anytime
- No technical blockers while private during development

**Action items (added to Milestone 8 checklist):**
- [ ] Decide on plugin license (MIT recommended)
- [ ] Create LICENSE file in plugin directory
- [ ] Make repository public (or document access plan)
- [ ] Update plugin.json with license field (if required)

### Decision 7: Standalone vs Framework-Dependent Model

**Issue discovered:** Commands have framework dependencies (PowerShell scripts, framework.yaml policies, documentation references) that won't exist in plugin-only installation.

**Options:**
- **Gateway model** ❌ - Plugin requires full framework structure (not truly lightweight)
- **Standalone model** ✅ **CHOSEN** - Plugin works independently in any project

**Chosen:** Standalone model - Commands adapted to work without framework files

**Key Adaptations:**

**fw-next-id:**
- ❌ Remove: PowerShell script dependency (`framework/tools/Get-NextWorkItemId.ps1`)
- ✅ Use: AI-driven scanning of project-hub/work/ and history/ directories
- Logic: Find highest existing ID, return next number
- Graceful: If no structure exists, start at 001 or offer to create structure

**fw-move:**
- ❌ Remove: References to `framework.yaml` policies, `workflow-guide.md` documentation
- ✅ Simplify: Embedded transition rules (keep matrix and checklists in command itself)
- ✅ Keep: Git operations, validation logic, policy enforcement
- Trade-off: No external policy file, but self-contained rules

**fw-session-history:**
- ❌ Remove: Framework template dependencies
- ✅ Use: AI-generated content from git history and conversation context
- Logic: Analyze recent commits, changes, and work completed
- Format: Standard markdown structure, adaptable to any project

**fw-help:**
- ✅ Already standalone: Reads from plugin's own commands/ directory
- No changes needed

**Rationale:**
- Plugin must work in any project (not just framework projects)
- AI-driven approach leverages Claude's capabilities (no external scripts)
- Self-contained commands with embedded rules/templates
- True "lightweight" experience - install and use immediately
- Performance trade-off acceptable for MVP (optimize later if needed)

**Validation Strategy:**
- Prototype each command one at a time (start with fw-next-id)
- Test standalone operation before moving to next command
- Iterate based on what works in practice

**Status:** CHOSEN - Implementing standalone model with prototype-and-test approach

---

## Optional Sub-Tasks (For Hierarchical Tracking)

**Note:** Can track as flat FEAT-118 or break into sub-tasks if desired.

**FEAT-118.1: Create Plugin Package** (Day 1-2)
- Create `plugins/spearit-framework-light/` directory structure (matches Anthropic)
- Write `plugin.json` metadata (name: "spearit-framework-light")
- Copy 4 core commands with namespaced invocation
- Test commands work from plugin location

**FEAT-118.2: Create Skills** (Day 3)
- Extract/condense `kanban-workflow.md` (~100 lines)
- Write `work-items.md` (~75 lines)
- Write `moving-items.md` (~75 lines)

**FEAT-118.3: Documentation & Build** (Day 4)
- Write comprehensive README.md
- Create `tools/Build-Plugin.ps1` script
- Test build process

**FEAT-118.4: Testing** (Day 5)
- Test all 4 commands locally
- Verify skills load correctly
- Test in framework project
- Fix any issues found

**FEAT-118.5: Package & Submit** (Day 6-7)
- Create final ZIP package
- Submit to Anthropic marketplace
- Update framework README
- Tag v1.0.0

---

## Risks and Mitigation

### Risk 1: Plugin Rejected from Official Marketplace

**Likelihood:** Low-Medium
**Impact:** Medium (not high - we use it internally regardless)

**Mitigation:**
- Study official plugin standards before submission
- Follow example-plugin reference implementation
- Keep scope simple and focused for v1.0
- If rejected, use internally and iterate based on feedback
- Review similar approved plugins
- Test extensively before submitting
- Prepare professional documentation
- Have backup plan: third-party marketplaces, direct distribution

### Risk 2: Perfectionism Delays Shipping

**Likelihood:** HIGH (historical pattern - 5 versions, never published)
**Impact:** High (continues cycle of no external validation)

**Mitigation:**
- **MVP scope locked at 4 commands** - no scope creep
- **7-day shipping deadline** - firm timeline
- **"Good enough" quality bar** - professional, not perfect
- **Product Owner role** - maintains focus on shipping vs perfecting
- **Internal use is success** - external adoption is bonus

### Risk 3: Low External Adoption

**Likelihood:** Medium-High (untested market)
**Impact:** **LOW** (we use internally regardless)

**Mitigation:**
- Risk is acceptable - plugin serves internal use first
- External users are validation, not requirement
- Optimize metadata for searchability
- Link to full framework for comprehensive users
- Iterate v1.1+ based on actual feedback

### Risk 4: Commands Don't Work Outside Framework

**Likelihood:** Medium
**Impact:** Low (documented limitation for v1.0)

**Mitigation:**
- Document clearly: "Works best with full framework structure"
- Skills provide value even without full workflow
- Commands degrade gracefully with helpful messages
- MVP accepts this limitation, improve in v1.1+

---

## Success Metrics

### Primary Success (Week 1 - REQUIRED)
- [ ] Plugin packaged and submitted to marketplace
- [ ] Works for internal SpearIT use
- [ ] Professional quality (not perfect, but "good enough")
- [ ] All 4 commands functional
- [ ] Skills load in Claude context

### Secondary Success (Month 1 - NICE TO HAVE)
- [ ] 10+ external installs
- [ ] At least 1 user feedback/question
- [ ] Zero critical bugs reported
- [ ] Clear understanding of what users want in v1.1

### Tertiary Success (Month 3 - BONUS)
- [ ] 50+ external installs
- [ ] Plugin featured or recommended
- [ ] Framework adoption increased via plugin discovery
- [ ] Community engagement (questions, issues, PRs)

**Success Definition:** Even if ONLY primary success is achieved, this is a win - internal tool improved, professional quality established, ready for external users when they discover it.

---

## Related Work Items

**Parent Feature:** None (standalone feature)

**Child Features:**
- FEAT-119 (Plugin "new" Command) - Critical addition for complete workflow

**Related Features:**
- None directly, but supports all framework features by improving distribution

**Depends On:**
- None (uses existing commands and documentation)

**Blocks:**
- None (optional distribution channel)

**Blocked By:**
- FEAT-119 must be completed before final packaging (Milestone 8)

**Enables:**
- Broader framework adoption
- Easier project setup for new users
- Community growth and contributions

---

## Research References

**Official Resources:**
- Official Plugin Marketplace: https://github.com/anthropics/claude-plugins-official
- Plugin Submission Form: https://docs.google.com/forms/d/e/1FAIpQLSc31jdYDs_1z649BmFfX85mSSdyTXi0GOLsHD7tWKj0F_k9Dg/viewform
- Claude Code Plugin Docs: https://code.claude.com/docs/en/discover-plugins

**Community Resources:**
- ClaudePluginHub: https://claudemarketplaces.com/
- Claude-Plugins.dev: https://claude-plugins.dev/

**Competitive Analysis:**
- 28 official Anthropic plugins analyzed
- Key differentiators identified:
  - File-based kanban workflow (unique)
  - Research-driven development (unique)
  - WIP limit enforcement (unique)
  - AI-guided roadmap creation (unique)
  - Session history tracking (unique)
  - Complete project management methodology (unique)

**Market Context:**
- 9,000+ plugins across marketplaces
- Official Anthropic marketplace primary distribution channel
- Auto-update support for official marketplace
- Strong community adoption of plugin ecosystem

---

## Notes

**Why This Matters:**
The plugin transforms the framework from a "project you adopt" to a "tool you install." This lowers the barrier to entry significantly and makes the framework discoverable to the broader Claude Code community.

**Unique Positioning:**
Unlike other project management plugins that focus on integration with external tools (Jira, GitHub), this plugin provides a complete standalone methodology. It's the only file-based kanban workflow plugin with built-in AI collaboration patterns.

**Future Possibilities:**
- Integration with MCP servers for enhanced functionality
- Companion plugins for specific languages or frameworks
- Plugin hooks for custom workflows
- Community-contributed command extensions

**Philosophy Alignment:**
The plugin maintains the framework's core philosophy:
- Research before build (established need in plugin ecosystem)
- Progressive adoption (works with or without full framework)
- AI collaboration (skills teach Claude the methodology)
- Solo/small team focus (no external dependencies)

---

## Changelog

**2026-02-13 - READY FOR SUBMISSION:**
- **Status:** All implementation complete - ready for marketplace submission
- **Progress:** Milestones 1-8 all complete ✅
- **Final scope:** 3 commands (help, new, move)
- **Package:** 51.3 KB, version 1.0.0 (production-ready)
- **Testing:** CLI + VSCode clean install verified
- **TASK-126:** MVP scope reduction complete
- **Next:** Milestone 9 - Submit to Anthropic marketplace

**2026-02-12 - RESUMED: Ready for Final Packaging:**
- **Status:** Work resumed - FEAT-120 complete, FEAT-119 complete
- **Progress:** Milestones 1-7 all complete
- **Template extraction:** External templates validated (copy to cache successfully)
- **Testing infrastructure:** Local marketplace approach fully working
- **Milestone 8:** Final packaging started (TASK-126 created for scope refinement)

**2026-02-11 - FEAT-120 Completed:**
- **Testing infrastructure:** Local marketplace approach implemented and validated
- **Template extraction:** Custom `templates/` folder proven to work in plugins
- **Cache scripts removed:** 798 lines of deprecated code eliminated
- **Documentation:** Comprehensive testing workflow documented
- **Session history role:** Senior Technical Writer mindset established
- **Plugin storage internals:** Two-level architecture documented
- **FEAT-120 moved to done/** - All milestones complete

**2026-02-10 - PAUSED: Testing Infrastructure Refactor (FEAT-120):**
- **Status:** FEAT-118 paused at Milestone 7 (testing complete)
- **Reason:** Research discovered better testing approach (local marketplace vs cache manipulation)
- **What happened:** Built cache scripts (Install/Uninstall-PluginFromCache.ps1), then discovered Anthropic officially supports local marketplaces
- **Decision:** Pivot to official Anthropic pattern before final packaging
- **New work item:** FEAT-120 created to implement local marketplace approach
- **Impact:** Replaces cache scripts (~800 lines) with single Publish-ToLocalMarketplace.ps1 (~200 lines)
- **Benefits:** Uses official plugin system, tests real installation flow, simpler maintenance
- **Timeline:** Still on track (ahead of schedule, time for quality improvement)
- **Next step:** Complete FEAT-120, then resume FEAT-118 Milestone 8 (packaging)
- **Reference:** See FEAT-120 for detailed implementation plan

**2026-02-09 - Licensing Decision: MIT License:**
- **Decision:** Changed from GPL-3.0 to MIT license
- **Scope:** Both framework and plugin now MIT licensed
- **Rationale:** Attribution protection + maximum adoption + ecosystem fit
- **Files updated:** Root LICENSE, plugin LICENSE, plugin.json
- **Status:** Milestone 8 licensing steps complete, ready for FEAT-119

**2026-02-09 - Critical Gap Identified, FEAT-119 Created:**
- **Gap identified:** No command to create work items (users get stuck)
- **Solution:** Created FEAT-119 for `/spearit-framework-light:new` command
- **Impact:** MVP scope updated from 4 commands to 5 commands
- **Timeline:** +1 day (7 days → 8 days)
- **Rationale:** Complete workflow needed (create → move → track)
- **Status:** FEAT-119 blocked by FEAT-118 Milestone 8 (licensing step)
- **Implementation order:** Finish licensing → implement FEAT-119 → final packaging

**2026-02-09 - Repository Structure and Namespacing Finalized:**
- **Structure:** Changed from `plugin/` to `plugins/spearit-framework-light/` (matches Anthropic pattern exactly)
- **Namespacing:** Commands use `/spearit-framework-light:move` format (dropped fw- prefix, namespace provides context)
- **Command naming:** Files keep fw- prefix (`fw-move.md`), commands drop it (`:move`) - follows Anthropic pattern
- **Future plugin:** Full framework will use `plugins/spearit-framework/` with namespace `spearit-framework`
- **Build output:** Changed to `distrib/plugin-light/spearit-framework-light-v1.0.0.zip`
- **Branding:** Confirmed "SpearIT" is permitted (no Anthropic policy against branded plugins)
- **Design decisions:** Follow Anthropic's plugin development process exactly, structure bootstrapping (auto-create on first use), AI-generated templates from skills
- **Dogfooding strategy:** Different namespaces allow testing plugin while developing local commands
- **Updated:** Repository structure, command references, build paths, acceptance criteria

**2026-02-08 - Scope Refined to MVP (Product Owner Role):**
- **Strategic decision:** Plugin + Framework as complementary products
- **MVP scope:** 4 commands only (fw-move, fw-next-id, fw-session-history, fw-help)
- **Skills scope:** 3 files (~250 lines total)
- **Repository:** Plugin subdirectory in current repo (not separate)
- **Timeline:** Ship within 7 days
- **Positioning:** "Lightweight Edition" gateway to full framework
- **Risk profile:** LOW (internal use primary, external users bonus)
- **Quality bar:** Professional, reasonably robust, not buggy, easy to use
- **Deferred to v1.1+:** fw-status, fw-wip, fw-backlog, fw-topic-index, fw-roadmap
- **Context:** Breaking perfectionism cycle (5 versions, never published)
- **Success:** Internal use + marketplace availability = win

**2026-02-08 - Initial Creation:**
- Created feature based on research and competitive analysis
- Identified 9 commands to package
- Defined 5 skills for methodology
- Outlined comprehensive implementation
- Status: Backlog

---

**Last Updated:** 2026-02-12
**Status:** Active (Milestone 8 in progress)

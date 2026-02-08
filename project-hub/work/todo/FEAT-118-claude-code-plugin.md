# Feature: SpearIT Project Framework Plugin (MVP - Lightweight Edition)

**ID:** FEAT-118
**Type:** Feature
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-02-08
**Updated:** 2026-02-08 (Scope refined to MVP)
**Theme:** Distribution & Integration
**Target:** Ship within 7 days

---

## Summary

Create a **Minimum Viable Plugin** ("Lightweight Edition") of the SpearIT Project Framework to distribute file-based Kanban workflow through the Claude Code plugin marketplace.

**MVP Scope:** 4 core commands, 3 condensed skills, professional documentation. Ship in 1 week, iterate based on user feedback.

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
├── plugin/                     # 🆕 Plugin package (subdirectory in current repo)
│   ├── .claude-plugin/
│   │   └── plugin.json
│   ├── commands/               # 4 commands only
│   │   ├── fw-move.md
│   │   ├── fw-next-id.md
│   │   ├── fw-session-history.md
│   │   └── fw-help.md
│   ├── skills/                 # 3 condensed skills
│   │   ├── kanban-workflow.md
│   │   ├── work-items.md
│   │   └── moving-items.md
│   └── README.md
└── tools/Build-Plugin.ps1      # 🆕 Creates distributable ZIP
```

**Commands to Package (4 core commands - MVP):**
- [ ] `/fw-move` - Move work items through workflow (CORE - most used)
- [ ] `/fw-next-id` - Get next work item ID (CORE - most used)
- [ ] `/fw-session-history` - Document work (DEPENDENCY - auto-called by fw-move)
- [ ] `/fw-help` - Command reference (STANDARD - user expectation)

**Deferred to v1.1+ (after user feedback):**
- `/fw-status` - Project status summary
- `/fw-wip` - Show current work in progress
- `/fw-backlog` - Backlog review and prioritization
- `/fw-topic-index` - Framework reference
- `/fw-roadmap` - AI-guided roadmap creation

**Skills Documentation (3 files, ~250 lines total):**
- [ ] `kanban-workflow.md` - File-based Kanban concept (~100 lines)
- [ ] `work-items.md` - Creating and managing work items (~75 lines)
- [ ] `moving-items.md` - Workflow transitions and policies (~75 lines)

**Plugin Metadata:**
- [ ] Name: "SpearIT Project Framework"
- [ ] Display Name: "SpearIT Project Framework - Lightweight Edition"
- [ ] Version: 1.0.0
- [ ] Author: Gary Elliott / SpearIT Solutions
- [ ] Keywords: kanban, project-management, workflow, solo-developer, small-team, file-based

**Distribution:**
- [ ] Build script creates `spearit-project-framework-v1.0.0.zip`
- [ ] Submit to official Anthropic plugin directory only (defer third-party to v1.1+)
- [ ] Update framework README with plugin installation option

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
- **Scope:** Core Kanban workflow (4 commands, 3 skills)
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
File-based Kanban workflow for solo developers and small teams.
Manage work items (backlog → todo → doing → done) directly in
your repository without external tools.

Features:
• Move work items through workflow with policy enforcement
• Track work with session history
• Simple folder-based structure (no database required)
• Works with git - your work items are versioned

Part of the SpearIT Project Framework. For complete project
scaffolding with templates and full methodology, see:
https://github.com/spearit-solutions/project-framework

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

**Create plugin directory:**
- [ ] Create `plugin/` subdirectory in current repo
- [ ] Create `.claude-plugin/` folder
- [ ] Write `plugin.json` with metadata
- [ ] Copy 4 commands from `.claude/commands/`:
  - fw-move.md
  - fw-next-id.md
  - fw-session-history.md
  - fw-help.md
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
- [ ] Packages `plugin/` directory into ZIP
- [ ] Output: `dist/spearit-project-framework-v1.0.0.zip`
- [ ] Verify structure matches plugin standards

### Day 5: Testing

**Test scenarios:**
- [ ] Install plugin locally and test each command
- [ ] Verify skills load in Claude context
- [ ] Check for broken references/links
- [ ] Test in framework project (no conflicts)
- [ ] Test in non-framework project (graceful degradation)
- [ ] Fix any bugs found

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

## Acceptance Criteria

### MVP Plugin Package (v1.0)
- [ ] Plugin structure in `plugin/` subdirectory of current repo
- [ ] Follows official Anthropic plugin standards
- [ ] 4 core commands functional (fw-move, fw-next-id, fw-session-history, fw-help)
- [ ] 3 skills files (~250 lines total)
- [ ] README.md professional and complete
- [ ] Build script creates distributable ZIP
- [ ] ZIP package successfully installs locally

### Quality Bar Met
- [ ] **Professional:** Clean README, proper metadata, examples for each command
- [ ] **Reasonably Robust:** Commands work as documented, helpful errors, handles edge cases
- [ ] **Not Buggy:** All commands tested, no broken references, skills load correctly
- [ ] **Easy to Use:** Clear installation, quick start guide, simple skill explanations

### Testing Complete
- [ ] Plugin tested with local installation
- [ ] All 4 commands execute without errors
- [ ] Skills provide Claude with useful context
- [ ] No conflicts when used in framework project
- [ ] Graceful behavior in non-framework project

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

**Chosen:** 4 core commands (fw-move, fw-next-id, fw-session-history, fw-help)

**Rationale:**
- fw-move + fw-next-id = core workflow (most used)
- fw-session-history = dependency (auto-called by fw-move)
- fw-help = standard expectation (user reference)
- Minimum viable set to make file-based Kanban work
- Defer fw-status, fw-wip, fw-backlog, fw-topic-index, fw-roadmap to v1.1+
- Ship fast, learn from users, iterate

### Decision 2: Plugin Repository Structure

**Options:**
- Separate git repository for plugin ❌ (more overhead, slower to ship)
- Plugin subdirectory in framework repo ✅ **CHOSEN**
- Plugin replaces framework (massive restructure) ❌ (deferred)

**Chosen:** `plugin/` subdirectory in current framework repository

**Rationale:**
- Single repo to maintain for MVP
- Build script packages plugin for distribution
- Can extract to separate repo later if needed
- Commands copied from `.claude/commands/` to `plugin/commands/`
- Fast to ship, low risk

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

---

## Optional Sub-Tasks (For Hierarchical Tracking)

**Note:** Can track as flat FEAT-118 or break into sub-tasks if desired.

**FEAT-118.1: Create Plugin Package** (Day 1-2)
- Create `plugin/` directory structure
- Write `plugin.json` metadata
- Copy 4 core commands
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

**Related Features:**
- None directly, but supports all framework features by improving distribution

**Depends On:**
- None (uses existing commands and documentation)

**Blocks:**
- None (optional distribution channel)

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

**Last Updated:** 2026-02-08
**Status:** Backlog (Ready to move to doing/)

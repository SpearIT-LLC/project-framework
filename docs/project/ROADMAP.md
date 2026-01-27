# SpearIT Project Framework - Roadmap

**Last Updated:** 2026-01-27
**Next Review:** 2026-04-27 (Quarterly)

---

## Purpose

This roadmap defines the strategic direction for the SpearIT Project Framework. It organizes work into themes that guide prioritization and measure progress toward long-term goals.

**Roadmap vs Backlog:**
- **Roadmap** = Strategic direction (6-12 month horizon, themes and milestones)
- **Backlog** = Tactical work items (specific features/bugs supporting themes)

---

## Current Focus (Q1 2026)

### Theme: Distribution & Setup Excellence
**Goal:** Make framework adoption effortless

**Status:** 🚧 In Progress

**Key Milestones:**
- ✅ Framework-as-dependency model (DECISION-050)
- ✅ Build and setup automation (Build-FrameworkArchive.ps1, Setup-Project.ps1)
- ✅ Folder structure alignment (TECH-085, TECH-086)
- ✅ Setup process improvements (TECH-081)
- 🚧 Project type selection during setup (TECH-087)

**Success Metrics:**
- Setup time under 5 minutes from download
- Zero manual file editing required during setup
- Users understand project type implications

**What's Next:**
- Complete TECH-087 (project type selection)
- Test end-to-end setup flow with real users

---

## Next Phase (Q2 2026)

### Theme: AI Integration & Clarity
**Goal:** Improve framework-AI collaboration effectiveness

**Why This Matters:** AI assistants are primary framework users. Better collaboration means better outcomes.

**Key Initiatives:**
- TECH-061: CLAUDE.md optimization (reduce to <100 lines, clearer bootstrap)
- FEAT-088: Framework glossary (consistent terminology)
- FEAT-059: Context-aware AI roles (if prioritized)

**Success Metrics:**
- AI applies policies without repeated reminders
- Critical patterns applied consistently
- Term confusion eliminated

---

### Theme: Developer Guidance & Patterns
**Goal:** Help developers make good decisions quickly

**Why This Matters:** Users shouldn't have to reinvent patterns we've already solved.

**Key Initiatives:**
- ✅ FEAT-091: Project roadmap structure (this document)
- FEAT-089: Project type patterns (architecture guidance)
- FEAT-090: Coding strategy patterns (MVP → Performance progression)
- FEAT-052: Task-based project templates (workflow guidance per project type)

**Success Metrics:**
- Developers know which patterns apply to their project type
- Consistent quality across different projects
- Reduced "analysis paralysis" during setup

---

### Theme: Quality & Release Automation
**Goal:** Catch issues before they reach users

**Why This Matters:** Manual validation is error-prone. Automation ensures consistency.

**Key Initiatives:**
- FEAT-007: Validation script with -Framework mode
- FEAT-028: Release automation script
- FEAT-051: Framework update test harness

**Success Metrics:**
- Zero broken distributions released
- Release process takes <15 minutes
- Structure violations caught automatically

---

## Future Considerations (Q3+ 2026)

### Visual Communication
- FEAT-034: Projects showcase (examples of framework in use)
- FEAT-004: Visual diagrams (architecture, workflow)

### Workflow Enhancements
- FEAT-030: Hold folder (for blocked work items)
- FEAT-021: Hierarchical work item numbering
- FEAT-024: Renumber workflow steps sequentially

### Extensibility
- FEAT-047: Small team ID collision support
- GitHub/Jira integration (research phase needed)
- Multi-language documentation support

---

## Deferred / On Hold

### Low Priority
- DECISION-029: License choice (framework, not urgent)
- DECISION-035: Root status reference (needs more context)
- BUGFIX-045: Complete bash write/edit permissions

### Research Needed
- GitHub Issues integration (complexity vs benefit unclear)
- Jira integration (most teams use one or the other, not framework)
- Visual roadmap generation (mermaid charts)

---

## Completed Milestones

### Q4 2025 / Q1 2026
- ✅ **Framework Distribution Model** (DECISION-050)
  - Achieved framework-as-dependency architecture
  - Build and setup automation scripts
  - Single starter template replaces size-based templates

- ✅ **Structure Cleanup**
  - Renamed thoughts/ to project-hub/ (TECH-084)
  - Removed obsolete examples/ folder (TECH-085)
  - Aligned POC folder with ADR-004 (TECH-086)

- ✅ **Setup Experience Improvements** (TECH-081)
  - Clear "After Setup" guidance
  - AI integration documented
  - GitHub setup instructions

---

## Theme Definitions

### AI Integration & Clarity
Improving how AI assistants understand and apply framework policies. Focuses on reducing cognitive load, clarifying critical behaviors, and consistent terminology.

### Developer Guidance & Patterns
Providing clear architectural and process patterns for different project types. Helps developers apply best practices without guessing.

### Quality & Release Automation
Automated validation and release processes. Ensures consistent quality and reduces manual error.

### Distribution & Setup Excellence
Making framework adoption as smooth as possible. Focuses on initial user experience from download to first work item.

### Visual Communication
Using diagrams, examples, and visual aids to communicate framework concepts more effectively than text alone.

### Workflow Enhancements
Improvements to the kanban workflow, work item management, and process tooling.

---

## How to Use This Roadmap

**For Maintainers:**
1. When prioritizing backlog items, consider which theme they support
2. Review roadmap quarterly, adjust themes based on what we've learned
3. Themes inform decisions ("Does this align with our current focus?")

**For Contributors:**
1. Understand strategic direction before proposing features
2. Reference relevant themes in work item proposals
3. Roadmap explains "why" behind priorities

**For AI Assistants:**
1. Use themes for context when the user asks "what should we work on?"
2. Reference roadmap when prioritizing between competing work items
3. Roadmap provides strategic framing for technical decisions

---

**Note:** This roadmap is a guide, not a commitment. Themes and priorities may shift based on user feedback, technical discoveries, or changing requirements. The roadmap informs decisions; it doesn't constrain them.

---

**Created:** 2026-01-27
**Owner:** Gary Elliott (gary.elliott@spearit.solutions)

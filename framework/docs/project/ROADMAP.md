# SpearIT Project Framework - Roadmap

**Last Updated:** 2026-02-04
**Next Review:** 2026-05-04 (Quarterly recommended)

---

## Purpose

The SpearIT Project Framework is a file-based workflow and AI collaboration partner for solo developers and small teams building software or documentation projects.

**Key Innovation:** The framework provides a complete, batteries-included solution with Kanban work tracking, strategic roadmaps, AI-guided planning, and documentation standards—all using markdown files and scripting tools, without requiring external services or databases.

**Key Concepts:**
- **Themes** = Stable categories of work (what the project IS)
- **Planning Periods** = Time-bound focus areas (what you're working on NOW)

**Roadmap vs Backlog:**
- **Roadmap** = Strategic direction (themes, planning periods, goals)
- **Backlog** = Tactical work items (specific features/bugs supporting themes)

---

## Project Themes

These are the major categories that organize ALL project work. Themes are stable - they don't change unless the project fundamentally pivots.

### 1. Distribution & Onboarding
Activities related to creating a distribution package to the first time user experience. Covers packaging, installation, setup automation, and ensuring users can go from download to productive use quickly.

### 2. Workflow
File-based Kanban workflow including templates, related documentation, skill commands, issue creation in backlog through release. Encompasses the complete work item lifecycle and release management.

### 3. Project Guidance
How AI guides the user through industry tested patterns from project definition, organization, reporting, retrospectives, sprint planning. Focuses on strategic/planning level guidance typically provided by project managers and scrum masters.

### 4. Developer Guidance
How AI guides the user through industry tested patterns for how to solve and test problems. Focuses on tactical/implementation level guidance typically provided by senior developers, testers, and security roles.

---

## Current Planning Period: Sprint D&O 0 (Prerequisites)

**Duration:** ~3-5 days
**Primary Theme:** Distribution & Onboarding
**Goal:** Complete foundational decisions and cleanup required before Sprint D&O 1

**Success Criteria:**
- Multi-level framework concept officially retired (DECISION-105)
- Positioning statements approved and documented
- Documentation updated to reflect unified framework model (TECH-106)
- Project-hub location decision resolved (DECISION-037)

**Key Outcomes:**
- Clear, honest positioning for system requirements documentation
- Clean documentation foundation for distribution work
- Structural decisions finalized

**Committed Work:**
- DECISION-105: Retire Multi-Level Framework Concept
- TECH-106: Remove Multi-Level Framework References
- DECISION-037: Project-Hub Location

**Status:** 🏃 In Progress

---

## Next Planning Period: Sprint D&O 1

**Duration:** ~1 week
**Primary Theme:** Distribution & Onboarding
**Goal:** Create MVP distribution package and setup process that works end-to-end

**Success Criteria:**
- Distribution ZIP file exists and contains all necessary files
- User setup instructions exist and are clear
- Setup script runs without errors
- Setup script helps define project basics (interactive configuration)
- Complete flow (download → setup) takes under 10 minutes

**Key Outcomes:**
- Users can download a complete, ready-to-use framework package
- Interactive setup guides project configuration without manual editing
- Clear validation ensures correct installation
- First-time users achieve productive setup in under 10 minutes

**Committed Work:**
- FEAT-107: System Requirements Documentation

**Status:** 📋 Planned

---

## Future Planning Periods

### Planning Period: Sprint D&O 2 - Validation

**Duration:** TBD
**Primary Theme:** Distribution & Onboarding
**Goal:** Implement validation tooling to verify project structure integrity and version compatibility

**Key Outcomes:**
- Projects can be validated automatically for structural correctness
- Version mismatches between project and framework are detected
- Clear error messages guide users to fix configuration issues
- Validation remains local (no external dependencies)

---

### Planning Period: Sprint D&O 3 - Upgrade

**Duration:** TBD
**Primary Theme:** Distribution & Onboarding
**Goal:** Enable seamless framework version upgrades for existing projects

**Key Outcomes:**
- Users can upgrade to latest framework version with single command
- Migration paths handle breaking changes automatically
- Backup/rollback capability protects against upgrade failures
- Clear upgrade report shows what changed

---

### Planning Period: Sprint D&O 4 - Polish

**Duration:** TBD
**Primary Theme:** Distribution & Onboarding
**Goal:** TBD - Refinements and UX improvements based on learnings from D&O 1-3

**Ideas:**
- UX improvements discovered during D&O 1-3
- Performance optimizations for setup/validation
- Additional automation opportunities
- Documentation refinements

---

### Planning Period: Sprint PG 1 - MVP (Project Guidance)

**Duration:** TBD
**Primary Theme:** Project Guidance
**Goal:** Define project template pattern and implement AI-guided planning workflow

**Key Outcomes:**
- "Hello world" application project pattern is defined and validated
- AI guides users through project planning stages like a senior PM/Scrum Master would
- Users can plan an application project from idea → roadmap → work items
- Focus on guidance quality over code complexity - the work is trivial, the guidance is valuable

---

## Future Considerations

Ideas and initiatives not yet assigned to planning periods.

**By Theme:**

### Workflow
- Release automation enhancements
- Work item template improvements
- Additional skill commands for workflow management
- Hierarchical work item organization

### Developer Guidance
- Coding patterns and best practices documentation
- Testing strategy guidance
- Security guidance templates
- Session handoff patterns for AI collaboration

**Note:** These will be prioritized and assigned to planning periods after Sprint PG 1 completes.

---

## Deferred / On Hold

_No items currently deferred._

---

## Completed Planning Periods

_No completed planning periods yet - this is the initial roadmap._

---

## How to Use This Roadmap

**For Project Members:**
1. **Themes** help categorize work - every work item should map to a theme
2. **Planning Periods** show current focus - not all themes are active simultaneously
3. Review roadmap at planning period boundaries, adjust based on learnings
4. Themes are stable; planning periods evolve

**For Stakeholders:**
1. Understand project direction without diving into backlog details
2. See progress through completed planning periods
3. Provide feedback on theme priorities and planning period goals

**For AI Assistants:**
1. Use themes for context when prioritizing or creating work items
2. Reference current planning period when answering "what should we work on?"
3. Planning periods provide strategic framing for technical decisions
4. Suggest work items connect to themes via metadata (Theme field in work item frontmatter)

**Relationship: Themes ↔ Planning Periods ↔ Work Items:**
- **Themes** = Stable project categories (e.g., "Distribution & Onboarding", "Project Guidance")
- **Planning Periods** = Temporal goals focusing on 1-2 themes (e.g., "Sprint D&O 1")
- **Work Items** = Tactical tasks supporting themes, optionally tagged with planning period

**Naming Convention for Planning Periods:**
- Format: `Sprint [Theme-Shorthand] [Number]`
- Examples: Sprint D&O 1, Sprint PG 1, Sprint WF 1, Sprint DG 1
- Theme shorthand helps identify focus; number provides uniqueness

**Updating Planning Periods:**
- Use `/fw-roadmap` to create initial roadmap
- Update specific periods with natural language: "Let's update Sprint D&O 4 in the roadmap"
- Or use positional syntax: `/fw-roadmap update "Sprint D&O 4"`
- Review quarterly to adjust themes and plan upcoming periods

---

**Note:** This roadmap is a guide, not a commitment. Planning periods may shift based on feedback, discoveries, or changing requirements. The roadmap informs decisions; it doesn't constrain them.

---

**Created:** 2026-02-04
**Owner:** Gary Elliott / SpearIT, LLC

**Temporary Location:** This roadmap currently lives at `framework/docs/project/ROADMAP.md` pending FEAT-093 completion. Final location will be `framework/project-hub/project/ROADMAP.md`.

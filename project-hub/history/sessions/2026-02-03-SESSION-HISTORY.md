# Session History: 2026-02-03

**Date:** 2026-02-03
**Participants:** Gary Elliott, Claude Code (Sonnet 4.5)
**Session Focus:** FEAT-095 testing, roadmap planning exploration, epic structure design
**Role:** Senior Architect

---

## Summary

Tested FEAT-095 MVP v1.1 (/fw-roadmap skill) by creating a strategic roadmap for the framework project. Discovered the MVP generated tactical sprint-level planning instead of strategic roadmap. Through extensive discussion, refined understanding that roadmaps should define epics/themes (strategic) while backlog contains features (tactical). Designed epic-based structure using metadata references to avoid workflow complexity and sync issues.

---

## Work Completed

### FEAT-095: AI-Guided Roadmap Questionnaire

**Testing Results:**
- ✅ Successfully executed end-to-end roadmap creation
- ✅ Categorized all 55 backlog items into 4 pillars (Workflow, Project Guidance, Developer Guidance, Distribution & Onboarding)
- ✅ Created feature-based timeline for Planning Period 1 (Foundation + Distribution Excellence)
- ⚠️ Generated tactical sprint plan instead of strategic roadmap
- ⚠️ ROADMAP.md created at temporary location (framework/docs/project/) pending DECISION-037 + FEAT-093

**Key Insights:**
- Roadmap planning felt like sprint planning (too detailed, too tactical)
- Need to distinguish strategic roadmap from detailed execution planning
- Projects of all sizes benefit from high-level goals without getting into feature details
- Epic-based structure provides right level of abstraction

**Output:**
- Generated framework/docs/project/ROADMAP.md (56 backlog items organized, Planning Period 1 detailed)
- Location temporary until project-hub reorganization (FEAT-093)

### FEAT-104: Velocity Tracking (New Work Item)

**Created exploration work item** based on observation that time estimates need validation through actual velocity data. Documented three approaches (work item metadata, retrospective metrics, dedicated metrics file) with recommendation to start lightweight (Option 2: retrospective metrics only).

**Status:** Backlog - Research phase, feasibility TBD

---

## Decisions Made

### 1. Roadmap Should Be Strategic, Not Tactical

**Decision:** ROADMAP.md should contain epics/themes with goals and success criteria, NOT detailed feature lists or sprint-by-sprint breakdowns.

**Rationale:**
- Current MVP output felt like sprint planning, not roadmap planning
- Example: "Create self-contained Kanban workflow" (strategic) vs "FEAT-001, FEAT-002, FEAT-003" (tactical)
- All projects benefit from high-level goals regardless of size
- Backlog already contains feature details; roadmap shouldn't duplicate

**Impact:** FEAT-095 scope needs adjustment to focus on epic/theme creation instead of sprint planning

### 2. Themes + Planning Periods Model (FINAL DESIGN)

**Decision:** Use Themes (stable categories) + Planning Periods (flexible time-based organization), NOT rigid "Epic" concept.

**Model:**
```
Themes (Stable)
  └─ Planning Periods (Flexible, user-defined)
      └─ Work Items (Tactical)
```

**Rationale:**
- FEAT-092 already solved flexibility with "Planning Periods" (user names them: sprints/quarters/epics/phases)
- Adding rigid "Epic" concept contradicts this flexibility
- Themes provide stable categorization without archival complexity
- Avoids all three epic lifecycle problems (Options A/B/C all rejected)

**Implementation:**
- **Themes** = Stable project categories (Distribution & Onboarding, Workflow, Project Guidance)
  - Declared in ROADMAP.md, never archive (they're what the project IS)
  - Work items reference theme: `Theme: Distribution & Onboarding`
- **Planning Periods** = User-named time-based organization (from FEAT-092)
  - Strategic framing (goal, success criteria, which themes)
  - Archive when complete (FEAT-093)
  - Examples: "Sprint 1", "Q1 2026", "Foundation Phase", "Initial Setup Epic"
- **Work Items** = Tactical implementation
  - `Theme:` [stable category]
  - `Planning Period:` [optional temporal reference]

**Why This Works:**
- ✅ No archival complexity (themes are stable, don't archive)
- ✅ No sync issues (themes don't go stale)
- ✅ Preserves FEAT-092 flexibility (planning periods remain abstract)
- ✅ Maintains framework voice ("guidance not enforcement", "loose coupling")
- ✅ Simple - no registry files, no validation logic, no fragility

**Terminology Decision:**
- "Theme" chosen over: Feature Area, Domain, Pillar, Value Stream, Track
- Standard agile term, flexible, open to user interpretation
- Works for functional, strategic, or technical organization

### 3. Framework Positioning Statement

**Decision:** Framework is a "strategic thinking partner and **workflow system**" (not just "documentation system").

**Statement:**
> "A strategic thinking partner and workflow system for developers who want clarity without overhead."

**Rationale:**
- Captures active workflow nature (not passive documentation)
- Emphasizes AI collaboration + simplicity
- Should be added to README.md

### 4. Framework "Sweet Spot" and Voice

**Decision:** Framework excels at guidance and AI-collaborative thinking, NOT at being a database or PM enforcement tool.

**Strengths (Where We Excel):**
- AI-collaborative strategic thinking (challenging questions, role-based guidance)
- Transparent, version-controlled documentation
- Guidance without enforcement (flexible, adapts to user)
- Simplicity for solo devs and small teams

**Limitations (Where We Don't Compete):**
- ❌ Referential integrity, automatic sync, complex queries
- ❌ Workflow enforcement and validation
- ❌ Real-time collaboration, database features

**Philosophy:**
- "Guidance not enforcement" - no validation, no sync logic
- "Loose coupling" - no fragility from broken references
- "Clarity without overhead" - simple text fields, readable files

**Analogy:** Like Excel for project planning - powerful and flexible, but shouldn't build complex interconnected sheets (gets brittle)

### 5. ROADMAP.md Location Deferred to FEAT-093

**Decision:** ROADMAP.md currently at `framework/docs/project/` (temporary location) until DECISION-037 + FEAT-093 complete.

**Sequence:**
1. DECISION-037 (Sprint 1, Planning Period 1) - Resolve project-hub location (root vs framework/)
2. FEAT-093 (Future) - Reorganize project-hub structure, move ROADMAP.md to final location (`project-hub/project/ROADMAP.md`)

**Rationale:** Avoid getting sidetracked with structural changes while testing FEAT-095. Wait for proper sequencing of prerequisite decisions.

### 6. /fw-roadmap Remains Single Command (Supersedes Earlier Discussion)

**Decision:** Do NOT create separate `/fw-planning-period` command. `/fw-roadmap` handles strategic planning using Themes + Planning Periods model.

**Rationale:**
- Planning Periods already handle flexibility (can be strategic OR tactical, user decides)
- Themes + Planning Periods model solves the strategic/tactical distinction
- No need for separate command - complexity without clear value
- Keeping it simple aligns with framework voice

### 6. Velocity Tracking Is Optional Enhancement

**Decision:** Time estimation improvement through velocity tracking is valuable but should be optional, lightweight, and deferred to separate work item (FEAT-104).

**Rationale:**
- Framework targets solo devs and small teams (not enterprise)
- Heavy process overhead contradicts framework simplicity
- Start with retrospective-level metrics if implemented at all
- Research needed to validate value vs overhead trade-off

---

## Files Created

### framework/docs/project/ROADMAP.md
**Purpose:** Framework project strategic roadmap (temporary location)

**Content:**
- Planning Period 1: Foundation + Distribution Excellence (5 sprints, 17 items)
- Planning Period 2: Workflow + Project Guidance (preview)
- Future Considerations: Developer Guidance and remaining items
- 4-pillar structure (Workflow, Project Guidance, Developer Guidance, Distribution & Onboarding)

**Status:** Tactical sprint-level detail (needs refactoring to strategic epic-level per decisions above)

**Location Note:** Temporary at `framework/docs/project/` until FEAT-093 moves to `project-hub/project/`

### framework/project-hub/work/backlog/FEAT-104-velocity-tracking.md
**Purpose:** Exploration work item for velocity tracking feasibility

**Content:**
- Research questions about value vs overhead
- Three implementation options (lightweight to heavyweight)
- Recommendation: Start with retrospective metrics (Option 2)
- Decision criteria for implementation

**Priority:** Low (optional enhancement, research phase)

---

## Files Modified

### framework/project-hub/work/doing/FEAT-095-ai-roadmap-questionnaire.md

**Changes:**
1. **Added "Design Refinement: Themes vs Epics" section** documenting final design decisions
2. **Model definition:** Themes (stable) → Planning Periods (flexible) → Work Items (tactical)
3. **Terminology decision:** "Theme" chosen over alternatives with full rationale
4. **ROADMAP.md structure:** Examples showing themes section + planning period sections
5. **Next steps:** Updated implementation checklist including glossary, work item template, README updates

**Rationale:** Capture complete design discussion and finalized approach for FEAT-095 v1.2 implementation

### framework/project-hub/work/todo/FEAT-093-planning-period-archival.md (from earlier session)

**Changes:**
1. **Added Prerequisites Section:**
   - DECISION-037 must be resolved first (know final project-hub location)
   - Current ROADMAP.md at temporary location (framework/docs/project/)

2. **Updated Phase 1 Migration Steps:**
   - Step 1: Wait for DECISION-037 completion
   - Step 4: Move ROADMAP.md from temp location to project-hub/project/
   - Step 7: Update /fw-roadmap skill to write to new location

3. **Updated Dependencies:**
   - Added DECISION-037 as prerequisite
   - Added FEAT-095 as prerequisite (marked complete)
   - Marked FEAT-091 as complete

**Rationale:** Ensure FEAT-093 accounts for roadmap relocation after project-hub location decision finalized

---

## Key Observations & Learnings

### MVP Testing Insights

**Time Expectations:**
- Actual: Conversation took full 15-25 minutes as stated upfront ✅
- User feedback: "Time estimates seemed generous" - suggests velocity tracking could help

**Roadmap Format:**
- Created feature-based timeline (Q1: Features 1-4; Q2: Features 5-8)
- User feedback: "Felt more like sprint planning than roadmap planning"
- Insight: Even feature-based format too granular for strategic roadmap

**User Mental Model:**
- Roadmap = High-level capabilities/epics ("Create self-contained Kanban workflow")
- Sprint planning = Detailed features/tasks ("FEAT-001: folder structure, FEAT-002: templates")
- MVP blurred this distinction

### Design Philosophy Discussion

**Simplicity vs Completeness:**
- User: "We can't lose sight of framework simplicity. I'm exploring boundaries of where we can go."
- Recognized risk of over-engineering (epic work items, hierarchical folders, complex sync)
- Chose metadata-only approach to preserve workflow simplicity

**Sweet Spot Discovery:**
- Small projects (1-3 months): Roadmap = Sprint plan (same thing)
- Medium projects (6-12 months): Might need both strategic and tactical views
- Large projects (12+ months): Definitely need separate strategic roadmap

**Framework target audience:** Mostly small-to-medium, so keeping it simple is correct choice

### Epic Structure Evolution (Continued in Afternoon Session)

**Morning conclusion:** Epic definitions in ROADMAP.md, work items reference via metadata

**Afternoon deep dive:** Explored epic lifecycle options:
- Option A: Epics persist indefinitely (contradicts archival)
- Option B: Epics archive with periods (requires transition logic for open work items)
- Option C: EPIC-REGISTRY.md (adds file, duplication/sync issues)

**Key realization:** Introducing rigid "Epic" concept contradicts FEAT-092's flexible Planning Period design

**Final solution:** Don't prescribe "epics" - use Themes (stable categories) + Planning Periods (flexible, user-named)
- Users CAN call planning periods "epics" if they want
- Themes provide stable categorization without archival complexity
- Planning Periods remain abstract (sprint/quarter/epic/phase - user decides)

### Framework Identity Discussion

**Key question:** "Where can we excel? What is our 'voice'?"

**Insights:**
- Framework strengths: AI collaboration, strategic thinking, transparent documentation, guidance without enforcement
- Framework limitations: Can't be a database (referential integrity, sync, validation)
- Sweet spot: Strategic partner for solo devs/small teams, not enterprise PM tool
- Philosophy: "Guidance not enforcement", "loose coupling", "clarity without overhead"
- Analogy: Excel for project planning (powerful but shouldn't build complex interconnected sheets)

**Impact on design:** Reinforced decision to keep things simple - metadata references, no validation, no sync logic, no fragility

---

## Open Questions & Next Steps

### For FEAT-095 (AI-Guided Roadmap) - v1.2 Implementation

**Design finalized:**
1. Update `/fw-roadmap` skill to ask about themes FIRST (stable structure)
2. Then ask about current planning period (goal, timeframe, success criteria)
3. Generate ROADMAP.md with themes section + planning period sections
4. Strategic questions (capabilities/goals), not tactical (feature lists)
5. Work items referenced, not enumerated (no sync issues)

**Next actions:**
- [ ] Update `/fw-roadmap` skill with themes-first approach
- [ ] Add strategic question set (goals/success vs features/tasks)
- [ ] Update ROADMAP.md generation to include themes section
- [ ] Test on framework project with refined approach

### For Framework Documentation

**Action needed:**
- [ ] Add Theme field to work item template: `**Theme:** [e.g., "Distribution & Onboarding"]`
- [ ] Update glossary with Theme and Planning Period definitions (FEAT-088)
- [ ] Add positioning statement to README: "A strategic thinking partner and workflow system for developers who want clarity without overhead"
- [ ] Update ROADMAP-TEMPLATE.md to reflect themes + planning periods structure
- [ ] Update workflow guide with strategic roadmap examples

### For FEAT-093 (Planning Period Archival)

**No change needed:** Themes are stable and don't archive. Planning periods archive as originally designed.

---

## Current State

### In doing/
- **FEAT-095:** AI-Guided Roadmap Questionnaire
  - MVP v1.1 tested
  - Insights gathered, improvements identified
  - Ready for v1.2 refactoring (epic-based approach)

### In backlog/
- **FEAT-104:** Velocity Tracking (newly created)
- **55 other backlog items** (categorized into 4 pillars during session)

### In todo/
- **FEAT-093:** Planning Period Archival (updated with roadmap relocation plan)

---

## Conversation Highlights

**User Quote (on roadmap vs sprint planning):**
> "I think projects of all sizes can benefit from high level goals without getting sucked into the details. e.g. Create a self-contained Kanban workflow without external tooling requirements. Compared to feat-001 create kanban folder structure, feat-002 create work item templates, etc."

**User Quote (on framework simplicity):**
> "We can't loose sight of the simplicity of the framework. I know I'm asking questions that can make it more complex but I'm exploring the boundaries of where we can go."

**User Quote (on framework identity):**
> "Should we be looking at planning as loose direction or rigid commitments? Realistically our file based system can't do everything without adding fragility. Where can we excel?"

**Key Insights:**
- Morning: Roadmaps should be strategic (epics/themes) while backlog contains tactical work (features)
- Afternoon: Don't prescribe "epics" - use flexible Themes + Planning Periods model instead
- Framework excels at AI-collaborative strategic thinking and guidance, not database-like enforcement
- Final model: Theme (stable) → Planning Period (flexible, user-named) → Work Item (tactical)

---

**Session Duration:** Full day (morning + afternoon strategic discussions)
**Next Session Focus:** Implement FEAT-095 v1.2 with Themes + Planning Periods model, update work item template, glossary, and README

---

**Last Updated:** 2026-02-03

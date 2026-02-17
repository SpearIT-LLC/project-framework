# SpearIT Framework - Roadmap

**Last Updated:** 2026-02-17
**Next Review:** 2026-05-17 (Quarterly)

---

## Purpose

This roadmap defines the strategic direction for the SpearIT Framework - a system that brings AI-guided professional project practices to solo developers and individual contributors. It organizes work into stable **themes** (project categories) and temporal **planning periods** (time-bound goals).

**Key Concepts:**
- **Themes** = Stable categories of work (what the project IS)
- **Planning Periods** = Time-bound focus areas (what you're working on NOW)

**Roadmap vs Backlog:**
- **Roadmap** = Strategic direction (themes, planning periods, goals)
- **Backlog** = Tactical work items (specific features/bugs supporting themes)

**Target Users:**
- **Primary:** Solo developers and individual contributors - including contractors embedded in larger organizations who need to report progress upward
- **Secondary:** Small teams up to ~5 people

**Value Proposition:**
Competitors offer task tracking. SpearIT offers something different: an AI that embodies professional roles (Product Owner, Scrum Master, Senior Dev) to give solo developers the expert team experience without the overhead.

---

## Project Themes

These are the major categories that organize ALL project work. Themes are stable - they don't change unless the project fundamentally pivots.

### 1. Project Guidance
High-level, strategic guidance before and above the code. An AI-assembled expert team assesses project ideas, determines what disciplines are needed, ensures adequate research and MVP definition before building begins, and conducts periodic reviews. The `/swarm` command lives here - giving solo developers access to the kind of expert team scrutiny that normally only exists in well-resourced organizations.

### 2. Developer Guidance
Structured AI expertise at the code level. Applies project context (decisions made, patterns established, standards agreed) to code reviews, architecture challenges, and technical feasibility assessments. Keeps the solo developer thinking like a senior team, not an isolated coder. Builds on patterns established in Project Guidance. *(Future work)*

### 3. Workflow
The file-based Kanban system that underpins everything. Work item lifecycle (backlog → todo → doing → done), Kanban policies, transition rules, and the tracking loop that keeps work organized and visible. The foundation that Project Guidance, Developer Guidance, and Reporting all build on.

### 4. Reporting & Visibility
AI-generated communication artifacts that eliminate the pain of manual status reporting. Session histories, project roadmaps, and status summaries that a solo IC can share with clients, managers, or stakeholders - in seconds, not hours. Meaningful reporting requires a project plan; this theme depends on Project Guidance to be fully realized.

### 5. Distribution & Onboarding
Getting users started. Plugin-first delivery via the Anthropic marketplace, setup experience, documentation, and the migration path from Light Plugin (try) → Full Plugin (AI guidance) → Framework ZIP (power user scripts). Both plugins maintained; Framework ZIP serves users who want speed via scripts.

---

## Current Planning Period: PI MVP

**Duration:** ~3-4 weeks (targeting mid-March 2026)
**Primary Themes:** Project Guidance, Distribution & Onboarding
**Secondary Themes:** Workflow, Reporting & Visibility
**Goal:** Ship the full plugin with its differentiating capability - users can install it, run `/swarm`, and experience an AI-guided project kick-off that no other tool in the Claude Code ecosystem offers.

**Success Criteria:**
- Both plugins (Light v1.0, Full v1.0) available in the Anthropic marketplace
- `/swarm` command ships: AI assembles appropriate expert disciplines, conducts kick-off conversation, produces project brief + starter backlog
- Full plugin clearly positioned as "AI-guided professional practices" - distinct from Light plugin's workflow-only value
- Reporting artifacts (session history, roadmap) work meaningfully in context of a swarm-initiated project
- SpearIT internal projects using Full plugin (dogfooding validates before external feedback arrives)

**Status:** 🚧 In Progress

---

## Future Planning Periods

### PI: Developer Intelligence
**Primary Theme:** Developer Guidance
**Goal:** AI expert perspectives at the code level - context-aware code reviews, architecture challenges, and standards enforcement that knows your project's decisions and patterns. Builds directly on Project Guidance patterns established in PI MVP.

*Details to be defined after PI MVP completes and user feedback is collected.*

---

### PI: Growth & Feedback
**Primary Themes:** Distribution & Onboarding, Workflow
**Goal:** Respond to real adoption - refine based on marketplace feedback, address gaps surfaced by actual usage patterns, and assess small team viability based on what we learn from real users.

*Details to be defined after PI: Developer Intelligence completes.*

---

## Future Considerations

Ideas and initiatives not yet assigned to planning periods.

**By Theme:**

### Project Guidance
- Periodic review command (ongoing team check-ins, not just kick-off)
- Retrospective command (end-of-period structured reflection)
- Dynamic discipline expansion (e.g., "this project needs a data scientist")
- Sprint/planning period planning support (FEAT-092 - depends on `/swarm` first)

### Developer Guidance
- Code review command with project context awareness
- Architecture decision support
- Technical feasibility assessment

### Workflow
- Workflow validation script (catch Kanban rule violations)
- Small team git coordination patterns (if team adoption proves viable)

### Reporting & Visibility
- Status summary command (generate stakeholder update in seconds)
- Progress report against planning period goals

### Distribution & Onboarding
- Jira integration (deferred - requires small team validation first)
- Visual diagrams and project dashboards

---

## Deferred / On Hold

*None yet - will be populated as decisions are made.*

---

## Completed Planning Periods

*None yet - PI MVP is the first formal planning period. Earlier work (Framework v1-v5, Light Plugin v1.0) preceded this roadmap.*

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

**Relationship: Themes ↔ Planning Periods ↔ Work Items:**
- **Themes** = Stable project categories
- **Planning Periods** = Temporal goals focusing on 1-2 primary themes
- **Work Items** = Tactical tasks in `project-hub/work/` supporting themes

**Planning Period Naming Convention:**
- `PI MVP` = First period proving the Project Intelligence concept
- `PI: [Descriptive Name]` = Subsequent periods named by their primary goal
- If two periods share a similar goal, append a number: `PI: Developer Intelligence 1`

**Design Documents:**
Detailed feature design (UX flows, conversation design, outputs) lives in:
`project-hub/planning/design/`

---

**Note:** This roadmap is a guide, not a commitment. Planning periods may shift based on feedback, discoveries, or changing requirements.

---

**Created:** 2026-02-17

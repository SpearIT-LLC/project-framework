# /spearit-framework:roadmap - AI-Guided Roadmap Creation

Create a strategic project roadmap through AI-guided conversational planning. This command generates a **ROADMAP.md file** with clear project themes and planning periods by challenging vague goals and pushing for strategic clarity.

## Usage

```
/spearit-framework:roadmap
```

**What you'll get:** A ROADMAP.md file with 2-5 project themes (stable work categories), a current planning period with goals/success criteria, and optional future planning periods.

**Time Expectation:** 15-25 minute strategic conversation to establish direction.

---

## Role & Mindset

**For this command, adopt a Senior Product Owner mindset:**

### Core Responsibilities
- Challenge vague goals and push for strategic clarity
- Ask "Why do users need this? What problem are we really solving?"
- Help users distinguish strategic direction from tactical details
- Push back on scattered priorities - force focus

### Senior Behaviors
- Don't just transcribe answers - challenge them
- Ask "Why?" to get to root problems
- Question vague language ("better", "improve", "optimize")
- Ensure roadmaps stay strategic (goals, outcomes) not tactical (work item IDs, feature lists)

### Conversational Tone

**For early-stage/vague projects:**
- Warm, encouraging, patient - "Let's figure this out together"
- Reduce anxiety: "It's fine if things aren't clear yet"
- Scaffold thinking: Offer examples and starting points
- Normalize evolution: "These themes can change as you learn"
- Frame as exploration, not interrogation

**For established projects:**
- Direct, focused, challenging - "Let's sharpen this"
- Push for precision: "What does 'better' actually mean?"
- Question assumptions: "Why these themes? How are they distinct?"
- Frame as refinement, not creation

**Always:**
- Conversational, not formal - use contractions, natural language
- Socratic method - questions reveal thinking, not just extract answers
- Acknowledge good thinking: "That's a clear distinction" or "Good - that's specific"
- Summarize periodically: "So far I'm hearing..." to build shared understanding
- No jargon unless user introduces it first

**Example tone differences:**

Early-stage:
> "I'm hearing that users would track work items and visualize progress. That suggests two natural areas to me: Work Management and Visibility. Does that resonate? Or would you frame it differently?"

Established:
> "You said 'improve user experience.' What specific outcome would that create? What can users do afterward that they can't do now?"

---

## Before Starting

1. **Check for existing context:**
   - Look for `ROADMAP.md` in project root
   - Look for `README.md` to understand project vision
   - Look for work items in `project-hub/work/backlog/` (if structure exists)
   - If no context found, start from scratch

2. **Set expectations with user:**
   ```
   This will take about 15-25 minutes. At the end, you'll have:

   📄 ROADMAP.md file in your project root containing:
   - 2-5 project themes (stable categories organizing all your work)
   - Current planning period with clear goals and success criteria
   - Optional: Future planning periods sketched out

   I'll guide you through strategic questions to:
   - Clarify what your project IS (themes)
   - Define what you're focusing on NOW (current planning period)
   - Push back on vague goals to create actionable direction

   This roadmap will help you make prioritization decisions and communicate
   project direction to stakeholders.

   Ready to begin?
   ```

---

## Conversation Flow

### Phase 1: Context Gathering

**Read existing project documentation (if available):**
1. Check `README.md` for project vision/purpose
2. Check existing `ROADMAP.md` for established themes
3. Scan `project-hub/work/backlog/` for work items (if directory exists)

**Set context for user:**
- If vision exists: Reference it
- If themes already exist: Confirm whether to use existing or revise
- If work items found: Provide overview: "[N] work items found, grouped roughly into [X] areas"

---

### Section 1: Establish Project Themes (Stable Categories)

**Goal:** Identify 3-5 stable thematic categories that organize ALL project work.

**Key concept to convey:**
> "Themes are the stable **categories** of your project - they don't change unless your project fundamentally pivots. They answer 'What are the major areas of this project?'"

---

#### For Early-Stage / Vague Projects

**If the user says themes are unclear or "we're still figuring it out":**

1. **Start with what you're building, not how:**
   - "What problem does this project solve? Who are the users?"
   - "If this project succeeds, what can users DO that they can't do today?"
   - Use their answers to infer natural categories

2. **Offer architecture-based starter themes:**
   - Every project has some version of these foundational areas:
     - **Foundation / Core** - The essential building blocks (data models, APIs, infrastructure)
     - **User Experience / Interface** - How users interact with the system
     - **Distribution / Setup** - How users discover, install, and start using it
     - **Quality / Reliability** - Testing, monitoring, error handling, performance

   Ask: "Which of these feel relevant? What would you call them in your context?"

3. **Use work-backward questioning:**
   - "When this project launches, what would the demo show?"
   - "What are the 3 major capabilities you need to build?"
   - Each major capability often suggests a theme

4. **Acknowledge themes will evolve:**
   - "It's fine if themes shift as you learn. We're articulating your *current* understanding."
   - "Themes create focus NOW, even if they change later."
   - "Better to have imperfect themes than no organizing structure."

5. **Reduce scope pressure:**
   - "Let's start with 2-3 themes. You can add more as the project clarifies."
   - "Not every theme needs to be active in the first planning period."

**Example conversation flow:**
```
AI: "What problem does this project solve?"
User: "We're building a tool to help developers manage project workflows."

AI: "So users would be able to...?"
User: "Track work items, visualize progress, automate releases."

AI: "I hear three natural areas:
1. Work Management (tracking, organizing items)
2. Visibility (dashboards, status, reporting)
3. Automation (releases, CI/CD integration)

Do these resonate as your major themes? Or would you frame them differently?"
```

---

#### For Established Projects

**Ask strategic questions:**
- "Looking at your project, what are the major **areas of work** or **categories** that organize everything you do?"
- If user has existing themes: "Should we keep these themes, or do they need adjustment?"
- If work items found: "I see work items clustering around [X, Y, Z]. Do these sound like your main themes?"

**Push for stability and clarity:**
- Challenge if >5 themes: "That's a lot of categories. Can any be combined?"
- Challenge if themes overlap: "How is [Theme A] different from [Theme B]?"
- Ensure themes are descriptive: "What does [vague name] actually mean?"
- Confirm themes cover all work: "Would every work item fit into one of these themes?"

---

**Output Section 1:** Draft 2-5 theme names with 1-2 sentence descriptions. Get approval.

**Example output format:**
```markdown
## Project Themes
1. **[Theme Name]** - [1-2 sentence description]
2. **[Theme Name]** - [1-2 sentence description]
3. **[Theme Name]** - [1-2 sentence description]
```

---

### Section 2: Define Current Planning Period

**Goal:** Create strategic framing for current/next work period.

**Key concept to convey:**
> "Planning Periods organize work **temporally** - they have goals, timeframes, and focus on specific themes. You name them however makes sense: 'Sprint 3', 'Q1 2026', 'Beta Phase', 'Foundation Epic', etc."

**Ask about timeframe and naming:**
- "How do you organize your work over time? Sprints? Quarters? Project phases? Milestones?"
- "What should we call this planning period?" (Provide examples based on their answer)

**Ask strategic questions about current focus:**
- "What's the **goal** for this planning period? What are you trying to achieve?"
- "Which **themes** (from Section 1) will you focus on during this period?"
- "What would **success** look like at the end of this period?"
- "Roughly how long do you expect this period to take?" (Estimate, not commitment)

**Push for strategic clarity:**
- Challenge vague goals: "What does 'improve X' actually mean? What's the specific outcome?"
- Question scattered focus: "That's 4 themes simultaneously. Can you prioritize 1-2 primary themes?"
- Ensure measurable success: "How will you know this period succeeded? What will be different?"

**CRITICAL: Push back on work item specifics:**
- **Roadmaps are strategic, not tactical** - Follow industry norms
- If user mentions specific work items (FEAT-005, feature names): "Let's describe the **outcome** instead. What will users be able to do?"
- Redirect from features to user value: "Not 'implement feature X', but 'users can accomplish Y'"
- **No work item IDs in roadmap** - Those belong in backlog

**Output Section 2:** Draft planning period section with name, goal, themes, duration estimate, success criteria. Get approval.

**Example output format:**
```markdown
## Planning Period: [User's Name] - [Optional Subtitle]
**Themes:** [Primary Theme], [Secondary Theme]
**Goal:** [What you're trying to achieve]
**Duration:** [Estimate, e.g., "~6 weeks (3 sprints)" or "Q1 2026"]
**Success Criteria:**
- [Measurable outcome 1]
- [Measurable outcome 2]
- [Measurable outcome 3]
```

---

### Section 3: Future Planning Periods (Optional)

**Ask if user wants to sketch future periods:**
- "Do you want to plan future periods now, or focus only on the current one?"

**If yes, ask for each future period:**
- Name, themes, high-level goal
- Keep it lightweight - future periods can be refined later

**If no:**
- Note that future sections will be placeholders (TBD)

---

### Section 4: Generate ROADMAP.md

After all sections are approved:

1. **Synthesize conversation** into ROADMAP.md structure:

   **File structure (in order):**
   - **Title & metadata**: Project name, last updated, next review date
   - **Purpose section**: Use vision from README.md if available, or create brief statement
   - **Project Themes section** (Section 1 output): List 3-5 themes with descriptions
   - **Current Planning Period section** (Section 2 output): Current focus with goal, themes, success criteria
   - **Future Planning Periods** (Section 3 output or TBD): Placeholder or sketched future periods
   - **Future Considerations**: TBD placeholder (can be filled in later)
   - **Deferred / On Hold**: Empty initially
   - **Completed Planning Periods**: None yet (first roadmap)
   - **How to Use This Roadmap**: Standard guidance section

2. **Write ROADMAP.md** to project root:
   ```
   ROADMAP.md
   ```

3. **Add to git** (if in git repository):
   ```bash
   git add ROADMAP.md
   ```

4. **Summarize what was created**:
   - Highlight the themes established: "Your project is organized into [N] themes: [list]"
   - Describe current planning period: "Your current focus is [period name] with goal: [goal]"
   - Explain relationship: "Themes are stable categories. Planning periods organize work temporally."
   - Remind about work items: "Consider adding Theme field to work items to connect them to roadmap themes"

---

## Key Behaviors

**Strategic Pushback:**
- Don't just transcribe answers - challenge them
- Ask "Why?" to get to root problems
- Question vague language ("better", "improve", "optimize")
- Challenge scattered themes: "Can these be combined? Are they truly distinct?"
- Push back on too many simultaneous priorities in a planning period

**Clarity on Themes vs Planning Periods:**
- **Themes** = Stable categories (what the project IS)
- **Planning Periods** = Temporal organization (what you're focusing on NOW)
- Reinforce this distinction throughout the conversation
- Example: "All 4 themes exist throughout the project, but this planning period focuses primarily on Themes 1 and 2"

**Theme Evolution (for early-stage projects):**
- Acknowledge that themes may evolve as the project matures
- "Stable" doesn't mean "unchangeable" - it means "not changing every sprint"
- Early-stage projects: Start with 2-3 themes based on current understanding
- Reassure users: "It's better to have imperfect themes now than no structure"
- Themes create forcing function to articulate current thinking, even if vague
- Can revisit and refine themes in future roadmap updates

**Iterative Refinement:**
- Build section-by-section with approval checkpoints
- Don't generate the full roadmap in one shot
- Allow user to revise earlier sections if later questions reveal new insights

**Focus & Constraint:**
- Encourage 2-5 themes total (stable categories)
- Early-stage: OK to start with 2-3 themes
- Established projects: Typically 3-5 themes
- For planning periods, encourage 1-2 primary themes, max 3
- Push back on "everything is important" - force prioritization
- Help user prioritize by asking trade-off questions

---

## Output

Creates `ROADMAP.md` in project root with:
- **Project Themes section** (3-5 stable categories organizing all work)
- **Current Planning Period** (goal-focused, time-bound, strategic framing)
- Clear distinction between themes (stable) and planning periods (temporal)
- Structure ready for periodic updates

---

## Template Structure

Use this structure when generating ROADMAP.md:

```markdown
# [Project Name] - Roadmap

**Last Updated:** YYYY-MM-DD
**Next Review:** YYYY-MM-DD (Quarterly recommended)

---

## Purpose

This roadmap defines the strategic direction for [Project Name]. It organizes work into stable **themes** (project categories) and temporal **planning periods** (time-bound goals).

**Key Concepts:**
- **Themes** = Stable categories of work (what the project IS)
- **Planning Periods** = Time-bound focus areas (what you're working on NOW)

**Roadmap vs Backlog:**
- **Roadmap** = Strategic direction (themes, planning periods, goals)
- **Backlog** = Tactical work items (specific features/bugs supporting themes)

---

## Project Themes

These are the major categories that organize ALL project work. Themes are stable - they don't change unless the project fundamentally pivots.

### 1. [Theme Name]
[1-2 sentence description]

### 2. [Theme Name]
[1-2 sentence description]

### 3. [Theme Name]
[1-2 sentence description]

---

## Current Planning Period: [Period Name]

**Duration:** [Estimate]
**Primary Themes:** [Theme 1], [Theme 2]
**Goal:** [What you're trying to achieve this period]

**Success Criteria:**
- [Measurable outcome 1]
- [Measurable outcome 2]
- [Measurable outcome 3]

**Status:** 🚧 In Progress

---

## Future Planning Periods

### Planning Period: [Next Period Name]

**Duration:** [Estimate]
**Primary Themes:** [Theme X], [Theme Y]
**Goal:** [High-level goal for this period]

*Details to be defined closer to start date.*

---

## Future Considerations

Ideas and initiatives not yet assigned to planning periods.

**By Theme:**

### [Theme Name]
- [Idea or initiative]

### [Theme Name]
- [Idea or initiative]

---

## Deferred / On Hold

*None yet - will be populated as decisions are made.*

---

## Completed Planning Periods

*None yet - will be populated as planning periods are completed.*

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
- **Planning Periods** = Temporal goals focusing on 1-2 themes
- **Work Items** = Tactical tasks supporting themes

---

**Note:** This roadmap is a guide, not a commitment. Planning periods may shift based on feedback, discoveries, or changing requirements.

---

**Created:** YYYY-MM-DD
```

---

## Notes

**Design Philosophy:**
- **Themes answer:** "What are the major categories of work in this project?"
- **Planning Periods answer:** "What are we trying to achieve in this timeframe?"
- **Strategic focus:** Goals, outcomes, user value - NOT work item IDs or feature names
- **Roadmaps = strategic framing** - Backlog = tactical work items

**Flexibility:**
- Works in any project structure (with or without project-hub/)
- Adapts to user's time organization (sprints, quarters, phases, milestones)
- Can be run multiple times to refine existing roadmap
- No dependencies on other framework commands or configuration files
- Handles early-stage projects (vague ideas) and established projects (clear themes)
- Themes can evolve - roadmap captures current understanding, not eternal truth

---

**Last Updated:** 2026-02-16

# /fw-roadmap - AI-Guided Roadmap Creation

Create a strategic project roadmap through AI-guided conversational questioning. This skill helps you build a focused, measurable roadmap by challenging vague goals and pushing for strategic clarity.

## Usage

```
/fw-roadmap                          # Create new roadmap (guided conversation)
/fw-roadmap update "Sprint D&O 4"   # Update specific planning period
```

**Natural language also supported:**
- "Let's update Sprint D&O 4 in the roadmap"
- "Review the roadmap with me"
- "Refine the themes in our roadmap"

## Behavior

**Time Expectation:** This is a strategic conversation that typically takes 15-25 minutes. Let the user know upfront.

**Role & Model:**
- Use the **Senior Product Owner** role from `framework-roles.yaml`
- Use **Opus** model for strategic synthesis and nuanced questioning
- Mindset: "Why do users need this? What problem are we really solving? What shouldn't we build?"

**Before Starting:**
1. Check if `docs/project/ROADMAP.md` exists
2. Read project context:
   - `framework.yaml` - Project metadata and configuration
   - `PROJECT-STATUS.md` - Current state and version
   - `README.md` - Check for project vision/definition (particularly "What Is This?" section)
   - `project-hub/work/backlog/` - Scan for existing work items (count and group by feature/theme)
3. Set expectations: "This will take about 15-25 minutes. I'll guide you through strategic questions to create a focused roadmap."
4. Confirm mode with user

**Conversation Flow:**

### Phase 1: Context Gathering
**Read existing project documentation:**
1. Check README.md "What Is This?" section for project vision/purpose
2. Check existing ROADMAP.md for established themes (if it exists)
3. Scan backlog to understand work item distribution

**Set context for user:**
- If vision exists: Reference it, note you'll use it for the roadmap
- If themes already exist in ROADMAP.md: Confirm whether to use existing or revise
- Provide backlog overview: "[N] work items found, grouped roughly into [X] areas"

### Section 1: Establish Project Themes (Stable Categories)
**Goal:** Identify 3-5 stable thematic categories that organize ALL project work.

**Key concept to convey:**
"Themes are the stable **categories** of your project - they don't change unless your project fundamentally pivots. They answer 'What are the major areas of this project?'"

**Ask strategic questions:**
- "Looking at your project, what are the major **areas of work** or **categories** that organize everything you do?"
- If user has existing themes in ROADMAP.md: "Should we keep these themes, or do they need adjustment?"
- Use backlog analysis: "I see work items clustering around [X, Y, Z]. Do these sound like your main themes?"

**Framework example (if helpful):**
"For context, the SpearIT Framework uses 4 themes:
1. **Distribution & Onboarding** - Setup, installation, first-use experience
2. **Workflow** - Work item management, release automation
3. **Project Guidance** - Planning, roadmaps, status, strategic tools
4. **Developer Guidance** - Code standards, patterns, best practices

Your themes will be different based on your project type."

**Push for stability and clarity:**
- Challenge if >5 themes: "That's a lot of categories. Can any be combined?"
- Challenge if themes overlap: "How is [Theme A] different from [Theme B]?"
- Ensure themes are descriptive: "What does [vague name] actually mean?"
- Confirm themes cover all work: "Would every work item fit into one of these themes?"

**Output Section 1:** Draft 3-5 theme names with 1-2 sentence descriptions. Get approval.

**Example output format:**
```
## Project Themes
1. **[Theme Name]** - [1-2 sentence description]
2. **[Theme Name]** - [1-2 sentence description]
3. **[Theme Name]** - [1-2 sentence description]
```

### Section 2: Define Current Planning Period
**Goal:** Create strategic framing for current/next work period.

**Key concept to convey:**
"Planning Periods organize work **temporally** - they have goals, timeframes, and focus on specific themes. You name them however makes sense: 'Sprint 3', 'Q1 2026', 'Beta Phase', 'Foundation Epic', etc."

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
- **No work item IDs in roadmap** - Those belong in backlog, tagged with planning period
- Suggest future `/fw-planning-period` command for detailed tactical planning

**Output Section 2:** Draft planning period section with name, goal, themes, duration estimate, success criteria. Get approval.

**Example output format:**
```
## Planning Period: [User's Name] - [Optional Subtitle]
**Themes:** [Primary Theme], [Secondary Theme]
**Goal:** [What you're trying to achieve]
**Duration:** [Estimate, e.g., "~6 weeks (3 sprints)" or "Q1 2026"]
**Success Criteria:**
- [Measurable outcome 1]
- [Measurable outcome 2]
- [Measurable outcome 3]
```

### Section 3: Future Planning Periods (Optional)
**Ask if user wants to sketch future periods:**
- "Do you want to plan future periods now, or focus only on the current one?"

**If yes, ask for each future period:**
- Name, themes, high-level goal
- Keep it lightweight - future periods can be refined later

**If no:**
- Note that future sections will be placeholders (TBD)

### Section 4: Generate ROADMAP.md
After all sections are approved:

1. **Synthesize conversation** into ROADMAP.md structure:
   - Use `framework/templates/planning/ROADMAP-TEMPLATE.md` as structure reference

   **File structure (in order):**
   - **Title & metadata**: Project name, last updated, next review date
   - **Purpose section**: Use vision from README.md if available, or create brief statement
   - **Project Themes section** (Section 1 output): List 3-5 themes with descriptions
   - **Current Planning Period section** (Section 2 output): Current focus with goal, themes, success criteria
   - **Future Planning Periods** (Section 3 output or TBD): Placeholder or sketched future periods
   - **Future Considerations**: TBD placeholder (can be filled in later)
   - **Deferred / On Hold**: Empty initially
   - **Completed Milestones**: None yet (first roadmap)
   - **How to Use This Roadmap**: Standard guidance section

2. **Write ROADMAP.md** to correct location:
   - **Temporary location:** `docs/project/ROADMAP.md` (until FEAT-093 completes)
   - **Final location:** `project-hub/project/ROADMAP.md` (after project-hub reorganization)
   - Add note about temporary location in roadmap footer

3. **Summarize what was created**:
   - Highlight the themes established: "Your project is organized into [N] themes: [list]"
   - Describe current planning period: "Your current focus is [period name] with goal: [goal]"
   - Explain relationship: "Themes are stable categories. Planning periods organize work temporally."
   - Note update options: "You can update planning periods by saying 'Let's update Sprint X' or `/fw-roadmap update \"Sprint X\"`"
   - Remind about work items: "Consider adding Theme field to work items to connect them to roadmap themes"
   - Note roadmap location: "Roadmap is at temporary location pending FEAT-093 completion"

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

**Iterative Refinement:**
- Build section-by-section with approval checkpoints
- Don't generate the full roadmap in one shot
- Allow user to revise earlier sections if later questions reveal new insights

**Focus & Constraint:**
- Encourage 3-5 themes total (stable categories)
- For planning periods, encourage 1-2 primary themes, max 3
- Push back on "everything is important" - force prioritization
- Help user prioritize by asking trade-off questions

## Examples

```
/fw-roadmap    # Start roadmap creation conversation
```

## Output

Creates `docs/project/ROADMAP.md` with:
- **Project Themes section** (3-5 stable categories organizing all work)
- **Current Planning Period** (goal-focused, time-bound, strategic framing)
- Themes vs Planning Periods distinction clearly established
- Structure ready for periodic updates and archival (FEAT-093)

## Notes

**Version: v1.3 (Industry-Standard Strategic Roadmaps)**
- Implements two-level model: Themes (stable) + Planning Periods (temporal)
- Creation mode + natural language updates for planning periods
- Actively pushes back on tactical details (work item IDs, feature lists)
- Follows industry norms: roadmaps are strategic, not tactical

**Design Philosophy:**
- **Themes answer:** "What are the major categories of work in this project?"
- **Planning Periods answer:** "What are we trying to achieve in this timeframe?"
- **Strategic focus:** Goals, outcomes, user value - NOT work item IDs or feature names
- **Roadmaps = strategic framing** - Backlog = tactical work items
- Suggest `/fw-planning-period` (future command) for detailed tactical planning

**Natural Language Updates:**
- Users can update planning periods conversationally: "Let's update Sprint D&O 4"
- Or use positional syntax: `/fw-roadmap update "Sprint D&O 4"`
- AI reads existing roadmap, guides refinement of specific section
- No special modes or flags required

**Roadmap Location:**
- **Current (temporary):** `docs/project/ROADMAP.md` (until FEAT-093 completes)
- **Future (permanent):** `project-hub/project/ROADMAP.md` (after project-hub reorganization)
- Skill adds note about temporary location in roadmap footer

**Future Enhancements:**
- Store themes in framework.yaml for project-wide consistency
- Theme definitions can mature over time through `/fw-roadmap` conversations
- FEAT-089 may provide typical theme templates for different project types
- `/fw-planning-period` command for detailed sprint/period planning
- PROJECT-STATUS.md synchronization
- Automatic retrospective creation at planning period boundaries (FEAT-093)

## Data Sources

- **Template**: `framework/templates/planning/ROADMAP-TEMPLATE.md`
- **Project context**: `framework.yaml`, `PROJECT-STATUS.md`
- **Work items**: `project-hub/work/backlog/` (scan for context)

## Related Commands

- `/fw-status` - Shows current project state (useful before roadmap creation)
- `/fw-backlog` - Review backlog items that might inform themes

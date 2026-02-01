# /fw-roadmap - AI-Guided Roadmap Creation

Create a strategic project roadmap through AI-guided conversational questioning. This skill helps you build a focused, measurable roadmap by challenging vague goals and pushing for strategic clarity.

## Usage

```
/fw-roadmap
```

## Behavior

**Role & Model:**
- Use the **Senior Product Owner** role from `framework-roles.yaml`
- Use **Opus** model for strategic synthesis and nuanced questioning
- Mindset: "Why do users need this? What problem are we really solving? What shouldn't we build?"

**Before Starting:**
1. Check if `ROADMAP.md` exists in project root
2. Read project context:
   - `framework.yaml` - Project metadata and configuration
   - `PROJECT-STATUS.md` - Current state and version
   - `project-hub/work/backlog/` - Scan for existing work items (count only, don't read all)
3. Confirm mode with user: "I see you don't have a roadmap yet. I'll help you create one through strategic questioning."

**Conversation Flow (3 Sections):**

### Section 1: Project Vision & Purpose
Ask strategic questions to understand the "why":
- "What problem does your project solve? Be specific about who experiences this problem."
- "Why does this problem matter? What happens if it's not solved?"
- "Who benefits from your project? What value do they get?"

**Push back on vague answers:**
- If user says "better X" → "What does 'better' mean? Compared to what baseline?"
- If user lists features → "Those are solutions. What's the underlying problem?"
- Challenge assumptions and ask "Why?" until you reach the root purpose

**Draft the Purpose section**, get user approval before proceeding.

### Section 2: Strategic Themes
Synthesize user's vision into 2-4 focused themes:
- "Based on what you've shared, I see [list potential themes]. Are these the right areas of focus?"
- **Challenge scattered priorities**: "That's [count] different areas. If you could only pick 2-3 for the next 6 months, which would have the biggest impact?"
- **Question misalignment**: "You said [X] is most important, but these themes focus on [Y]. Should we adjust?"
- **Identify gaps**: "You mentioned [concern] earlier, but no theme addresses it. Should we add one?"

**For each theme:**
- Ask: "What's the goal for [theme name]? What are you trying to achieve?"
- Push for clarity: "How will you know when this theme is successful?"
- Suggest concise theme names (2-4 words each)

**Draft the themes with goals**, get approval before metrics.

### Section 3: Success Metrics
For each approved theme, ask:
- "How will you measure progress on [theme name]?"
- "What does 'done' look like for this theme?"

**Push for specificity:**
- If vague → "Can you measure that? What would you count or observe?"
- If unmeasurable → "That's hard to track. What's a proxy metric you could use?"
- If too many metrics → "Which 2-3 metrics matter most?"

**Success metric guidelines:**
- 2-3 metrics per theme (not more)
- Must be measurable or observable
- Should indicate progress toward theme goal
- Can be quantitative (numbers) or qualitative (states/milestones)

**Draft success metrics for all themes**, get final approval.

### Section 4: Generate ROADMAP.md
After all three sections are approved:

1. **Synthesize conversation** into ROADMAP.md structure:
   - Use `framework/templates/planning/ROADMAP-TEMPLATE.md` as structure reference
   - **Current Focus section**: Include approved themes with goals, status (📋 Planned), success metrics
   - **Purpose section**: Use the vision/purpose from Section 1
   - **Theme Definitions section**: 1-2 sentence definitions for each theme
   - Leave placeholder sections: Next Phase (TBD), Future Considerations (TBD), Completed Milestones (none yet)

2. **Write ROADMAP.md** to project root

3. **Summarize what was created**:
   - List the [N] themes
   - Highlight key success metrics
   - Note next steps: "You can update ROADMAP.md manually, or use `/fw-roadmap` again for periodic reviews (future version)"

## Key Behaviors

**Strategic Pushback:**
- Don't just transcribe answers - challenge them
- Ask "Why?" to get to root problems
- Question vague language ("better", "improve", "optimize")
- Surface conflicts between stated priorities and proposed themes

**Iterative Refinement:**
- Build section-by-section with approval checkpoints
- Don't generate the full roadmap in one shot
- Allow user to revise earlier sections if themes reveal new insights

**Focus & Constraint:**
- Encourage 2-4 themes, challenge 5+
- Push back on "everything is important"
- Help user prioritize by forcing trade-off questions

## Examples

```
/fw-roadmap    # Start roadmap creation conversation
```

## Output

Creates `ROADMAP.md` in project root with:
- Clear project purpose
- 2-4 focused strategic themes
- Measurable success metrics for each theme
- Structure ready for periodic updates

## Notes

**MVP Scope (v1.0):**
- Creation mode only (not review/update mode)
- Basic roadmap generation
- Does not automatically create work items or update PROJECT-STATUS.md

**Future Enhancements:**
- Review mode for periodic roadmap updates
- Work item integration (suggest placeholders for themes)
- Planning period documentation
- PROJECT-STATUS.md synchronization

## Data Sources

- **Template**: `framework/templates/planning/ROADMAP-TEMPLATE.md`
- **Project context**: `framework.yaml`, `PROJECT-STATUS.md`
- **Work items**: `project-hub/work/backlog/` (scan for context)

## Related Commands

- `/fw-status` - Shows current project state (useful before roadmap creation)
- `/fw-backlog` - Review backlog items that might inform themes

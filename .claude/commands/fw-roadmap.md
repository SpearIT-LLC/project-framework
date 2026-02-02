# /fw-roadmap - AI-Guided Roadmap Creation

Create a strategic project roadmap through AI-guided conversational questioning. This skill helps you build a focused, measurable roadmap by challenging vague goals and pushing for strategic clarity.

## Usage

```
/fw-roadmap
```

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

### Phase 1: Vision Check
**Check for existing vision/definition:**
- If README.md has "What Is This?" section with clear vision → Reference it, don't re-ask
- If PROJECT-STATUS.md has clear project definition → Use it
- If neither exists → Do strategic vision questions (but note this is better suited for project definition work)

**If vision exists:**
"I see your project vision in README.md. Let me reference that rather than re-asking foundational questions. We'll focus on planning the feature timeline."

**If no vision exists:**
"I don't see a clear project definition yet. I can help create one, but ideally this would be documented in your README.md first. Should we:
1. Proceed with vision questions now (I'll help, but you should document this in README.md later)
2. Pause while you document vision in README.md, then return to roadmap planning"

### Section 1: Project Vision & Purpose (If Needed)
**Only if no vision exists in project documentation.**

Ask strategic questions to understand the "why":
- "What problem does your project solve? Be specific about who experiences this problem."
- "Why does this problem matter? What happens if it's not solved?"
- "Who benefits from your project? What value do they get?"

**Push back on vague answers:**
- If user says "better X" → "What does 'better' mean? Compared to what baseline?"
- If user lists features → "Those are solutions. What's the underlying problem?"
- Challenge assumptions and ask "Why?" until you reach the root purpose

**Draft the Purpose section** (remind user to add this to README.md), get approval before proceeding.

### Section 2: Roadmap Structure (Timeframe & Format)
**Ask about planning approach:**
- "How do you want to organize your roadmap?"
  - **Feature-based timeline**: Features/initiatives progressing through quarters/phases (Q1: F1, F2; Q2: F3, F4)
  - **Theme-based strategic**: Strategic themes with success metrics (OKR style)

**Most users want feature-based showing "what gets built when."** Recommend this unless they specifically want strategic themes.

**For Feature-Based (Recommended):**
1. Ask about timeframe: "What planning periods make sense? Quarters? Milestones? Project phases?"
2. Scan backlog: "I see [N] work items. Let me group them by feature area..."
3. Ask about prioritization: "Which features should be built first? What's the logical order?"
4. Draft feature progression timeline with user approval

**For Theme-Based:**
1. Synthesize vision into 2-4 focused themes
2. Challenge scattered priorities (>4 themes)
3. Question misalignment between stated priorities and themes
4. For each theme: goal, success criteria, concise name (2-4 words)
5. Draft themes with goals, get approval

**Output Section 2:** Draft roadmap structure (either feature timeline or strategic themes), get approval before metrics.

### Section 3: Success Metrics & Completion Criteria
**For Feature-Based Roadmaps:**
- Ask: "What defines 'done' for each feature?"
- Push for specific completion criteria (not just "feature works")
- Examples: "User can X", "Performance meets Y", "Documentation complete"

**For Theme-Based Roadmaps:**
For each approved theme, ask:
- "How will you measure progress on [theme name]?"
- "What does 'done' look like for this theme?"

**Push for specificity:**
- If vague → "Can you measure that? What would you count or observe?"
- If unmeasurable → "That's hard to track. What's a proxy metric you could use?"
- If too many metrics → "Which 2-3 metrics matter most?"

**Success metric guidelines:**
- 2-3 metrics per feature/theme (not more)
- Must be measurable or observable
- Can be quantitative (numbers) or qualitative (states/milestones)

**Draft success metrics/completion criteria**, get final approval.

### Section 4: Generate ROADMAP.md
After all sections are approved:

1. **Synthesize conversation** into ROADMAP.md structure:
   - Use `framework/templates/planning/ROADMAP-TEMPLATE.md` as structure reference
   - **Purpose section**: Use vision from README.md or Section 1
   - **Current Focus section**:
     - Feature-based: List features by planning period with completion criteria
     - Theme-based: List themes with goals, status (📋 Planned), success metrics
   - **Theme/Feature Definitions**: 1-2 sentence definitions
   - Leave placeholder sections: Next Phase (TBD), Future Considerations (TBD), Completed Milestones (none yet)

2. **Write ROADMAP.md** to `docs/project/ROADMAP.md` (NOT project root)

3. **Summarize what was created**:
   - List the structure created (feature-based or theme-based)
   - Highlight key features/themes and their metrics
   - Note next steps: "You can update ROADMAP.md manually, or use `/fw-roadmap` again for periodic reviews (future version)"
   - Remind: "If you created new vision content, consider adding it to README.md as well"

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

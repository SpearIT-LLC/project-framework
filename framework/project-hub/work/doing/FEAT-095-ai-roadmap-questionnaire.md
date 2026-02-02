# Feature: AI-Guided Roadmap Questionnaire

**ID:** FEAT-095
**Type:** Feature
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-01-28
**Theme:** AI Integration & Clarity

---

## Summary

Create an AI-guided conversational questionnaire (`/fw-roadmap`) that helps users collaboratively build and review project roadmaps through strategic questioning, clarification, and constructive pushback.

---

## Problem Statement

**What problem does this solve?**

Creating a roadmap is intimidating:
- Blank page problem: Users don't know where to start
- Strategic thinking is hard: Translating ideas into themes/metrics is difficult
- No accountability: Users can create vague or problematic roadmaps without challenge
- Solo projects: No one to bounce ideas off or validate thinking

**Current state:**
- Users must write roadmaps manually from template
- No guidance on what makes a good roadmap
- No prompting for strategic thinking
- Template is static, doesn't adapt to answers

**Who is affected?**
- New projects setting initial direction
- Existing projects conducting periodic reviews (sprints, quarters, milestones, phases)
- Solo developers lacking a strategic sounding board
- Teams wanting structured roadmap discussions

**Current workaround (if any):**
- Manually fill in ROADMAP-TEMPLATE.md
- User initiates unstructured conversation with AI
- Ad-hoc roadmap discussions without framework

---

## Requirements

### Functional Requirements

**Core Capabilities:**
- [ ] `/fw-roadmap` skill that launches conversational questionnaire
- [ ] Detect if ROADMAP.md exists → branch to creation vs review mode
- [ ] Read project context (framework.yaml, PROJECT-STATUS.md, backlog) before questioning
- [ ] Ask strategic questions conversationally with follow-ups
- [ ] Push back on vague answers and problematic ideas
- [ ] Draft roadmap sections iteratively with user feedback
- [ ] Write or update ROADMAP.md based on conversation
- [ ] Support both initial creation and periodic reviews (any timeframe: sprints, quarters, phases)

**Creation Mode Questions (Examples):**
- Vision: "What problem does your project solve? Who benefits?"
- Timeframe: "How do you want to organize your roadmap? (sprints, quarters, milestones, phases, etc.)"
- Success: "[Timeframe-specific], what would make you say 'this project is succeeding'?"
- Priorities: "What are the 2-4 major areas of work you need to focus on?"
- Constraints: "What dependencies, risks, or limitations should we consider?"
- Metrics: "How will you measure progress in each area?"

**Review Mode Questions (Examples):**
- Progress: "Which themes have made progress? What's blocked?"
- Learnings: "What surprised you? What changed since last review?"
- Pivot: "Should any priorities shift based on what you've learned?"
- Refinement: "What needs to be added, removed, or reprioritized?"

*Note: Questions adapt to project's chosen timeframe (see "Flexible Timeframe Support" in Design section)*

**AI Behavior:**
- Challenge vague goals ("What does 'better performance' actually mean?")
- Question misaligned priorities ("You said X is most important, but your success metrics focus on Y")
- Push for measurable outcomes ("How will you know when this is done?")
- Identify gaps ("You mentioned scalability concerns but no theme addresses them")
- Suggest connections ("This aligns with work item FEAT-088, should we reference it?")

### Non-Functional Requirements

- [ ] **Model:** Use Opus for strategic conversations (per user preference)
- [ ] **Role:** Invoke as Senior Product Owner for strategic framing
- [ ] **Token Efficiency:** Consider hybrid approach (script + AI) if token usage problematic
- [ ] **Flexibility:** Support any planning timeframe (sprints, quarters, milestones, phases, ad-hoc)
- [ ] **Documentation:** Clear guidance on when to use this vs manual editing
- [ ] **Integration:** Works with existing roadmap structure (FEAT-091)

---

## Design

### Architecture: Hybrid Approach for Token Efficiency

**Option A: Pure Conversational (High Tokens)**
- AI asks questions, user responds, AI follows up
- Pros: Best user experience, most flexible, natural pushback
- Cons: High token usage (multiple turns)

**Option B: Script Collection + AI Synthesis (Lower Tokens)**
- Phase 1: PowerShell script collects structured answers via prompts
- Phase 2: AI receives collected data, challenges/refines in one session
- Pros: Efficient for data collection, AI focuses on high-value synthesis
- Cons: Less natural, harder to implement conditional logic in script

**Option C: Hybrid - Conversational with Structured Sections (Recommended)**
- AI guides conversation but breaks into sections
- User provides answers to section, AI synthesizes and challenges before moving on
- Reduces back-and-forth while preserving conversational quality
- Pros: Balance of efficiency and quality
- Cons: Requires careful section design

**Proposed Structure:**

```
/fw-roadmap
├── Detect mode (creation vs review)
├── Read project context
├── Section 1: Project Vision & Goals
│   ├── Ask vision questions
│   ├── User responds (multiple points OK)
│   ├── AI challenges/clarifies/synthesizes
│   └── Draft vision section → Get approval
├── Section 2: Current Focus & Themes
│   ├── Ask about priorities and areas
│   ├── User responds
│   ├── AI challenges/refines into themes
│   └── Draft themes → Get approval
├── Section 3: Success Metrics
│   ├── For each theme, ask "how do you measure success?"
│   ├── AI pushes for specificity
│   └── Draft metrics → Get approval
├── Section 4: Next Phase & Future
│   ├── Ask about future initiatives
│   ├── AI helps organize by timeframe
│   └── Draft future sections → Get approval
└── Write/update ROADMAP.md
```

### Flexible Timeframe Support

**Alignment with FEAT-092:**
Like sprint support (FEAT-092), roadmap reviews support flexible timeframes rather than prescriptive scheduling.

**Supported Planning Periods:**
- **Sprints:** 1-4 week iterations (agile teams)
- **Quarters:** 3-month planning cycles (strategic projects)
- **Milestones:** Feature-based checkpoints (product development)
- **Project Phases:** Discovery, Alpha, Beta, GA (stage-based projects)
- **Ad-hoc:** "When we complete Theme X" or "After user feedback"

**How It Works:**
1. **Creation Mode:** AI asks "How do you want to organize your roadmap?" (offers examples, accepts custom)
2. **Review Mode:** AI reads existing roadmap structure and adapts questions accordingly
3. **No Enforcement:** Timeframes are guidance, not deadlines
4. **Actual Dates:** Recorded when themes start/complete for retrospective data

**Example Questions Adapt:**
- Sprint-based: "Which themes should be in Sprint 3?"
- Quarter-based: "What should we focus on in Q2?"
- Milestone-based: "What needs to happen before Beta launch?"
- Phase-based: "What defines success for the Alpha phase?"

**Rationale:** Projects have different cadences. The questionnaire adapts to the team's natural rhythm rather than imposing artificial structure.

### Role & Model Selection

**Role: Senior Product Owner**
- From [framework-roles.yaml](framework/docs/ref/framework-roles.yaml:484-496)
- Mindset: "Why do users need this? What problem are we really solving? What shouldn't we build?"
- Perfect fit for roadmap strategic thinking

**Model: Opus**
- Strategic synthesis and nuanced questioning
- Better at constructive pushback
- Excels at connecting disparate ideas
- Worth the cost for high-value, low-frequency activity

**Activation:**
```yaml
# In skill implementation
model: opus
role: senior-product-owner
```

### Question Design Principles

**1. Start Broad, Then Focus**
```
❌ "What features do you want?"
✅ "What problem does your project solve?"
   → "Who experiences this problem?"
   → "How do you know this is a real problem?"
```

**2. Push for Specificity**
```
User: "We need better performance"
AI: "What does 'better' mean?
     - Current: [What's the baseline?]
     - Target: [What's acceptable?]
     - Measure: [How will you know?]"
```

**3. Challenge Assumptions**
```
User: "We need these 8 major themes"
AI: "That's a lot to focus on. If you could only pick 2-3 for the next 6 months,
     which would have the biggest impact? What happens if the others wait?"
```

**4. Connect to Reality**
```
AI: "I see you have 15 work items in your backlog. Which themes do they support?
     [Lists themes with no backlog support]
     These themes have no work items yet. Should we create some, or reconsider these themes?"
```

**5. Surface Conflicts**
```
AI: "You said 'user experience' is your top priority, but all your success metrics
     are about performance. Should we adjust the priority or add UX metrics?"
```

### Integration Points

**With Existing Features:**
- **FEAT-091 (Roadmap structure):** Generates content matching template
- **Work items:** Can suggest creating work items for themes
- **PROJECT-STATUS.md:** Can update "What's Next" section to align
- **Session history:** Records the roadmap planning session

**With Future Features:**
- **FEAT-093 (Planning archival):** Periodic review mode can trigger archive at planning period boundaries
- **FEAT-092 (Sprints):** Can help plan sprint themes from roadmap
- **FEAT-015 (Executive summary):** Roadmap provides baseline for status

---

## Technical Approach

### Skill Structure

**File:** `framework/.claude/commands/fw-roadmap.md` (and `templates/starter/.claude/commands/fw-roadmap.md`)

**Skill Content:**
```markdown
You are conducting a roadmap planning session using the Senior Product Owner role with Opus model.

**Context Gathered:**
{auto-injected: project config, existing roadmap if any, backlog summary}

**Your Mission:**
Help the user build a strategic roadmap through conversational questioning. You must:
1. Ask insightful questions that expose strategic thinking
2. Challenge vague or problematic ideas constructively
3. Push for measurable outcomes
4. Synthesize their answers into coherent themes
5. Draft sections iteratively and get approval before proceeding

**Mode Detected:** {Creation | Periodic Review}

[Detailed instructions for each mode...]

**Section-by-Section Process:**
1. Project Vision (Creation) / Progress Review (Review mode)
2. Current Focus & Themes
3. Success Metrics
4. Next Phase & Future Considerations
5. Generate/Update ROADMAP.md

**Remember:**
- Use Senior Product Owner mindset: "Why? What problem? What shouldn't we build?"
- Push back when answers are vague
- Connect to existing work items when relevant
- Keep themes focused (2-4 is ideal, challenge >5)
```

### Script Alternative (If Needed)

If token usage proves problematic, implement:

**File:** `framework/tools/scripts/Start-RoadmapQuestionnaire.ps1`

```powershell
# Collects structured answers efficiently
# Then passes to AI for synthesis/challenge
# AI only involved in high-value refinement phase
```

**Decision:** Start with pure conversational skill, add script optimization if needed.

---

## User Experience Flow

### Scenario: New Project Creation

```
User: /fw-roadmap

AI: I'll help you create a roadmap for [Project Name]. Let's start with the big picture.

    **What problem does your project solve?**
    Be specific about who experiences this problem and why it matters.

User: It's a framework for managing software projects with AI collaboration...

AI: I see three themes here:
    1. "File-based workflow" - You mention not wanting external tools
    2. "AI collaboration" - Seamless human-AI teamwork
    3. "Best practices" - Capturing what works

    Are these the right themes, or am I missing something?

User: Yes, but also documentation and templates...

AI: Those feel more like *how* you solve the problem than *what* you're solving.

    Could "documentation and templates" be **outputs** of the "best practices" theme
    rather than separate themes? That would keep you focused on 3 core areas instead of 5.

    What do you think?

[Continues with strategic questioning and refinement...]
```

### Scenario: Periodic Review

```
User: /fw-roadmap

AI: I see you last updated your roadmap 2026-01-27. Let's review progress.

    Your current planning period themes were:
    1. Distribution & Setup Excellence ✅ (You marked complete)
    2. AI Integration & Clarity 🚧 (FEAT-088 in progress)
    3. Developer Guidance & Patterns 🚧 (FEAT-089, FEAT-090 in backlog)

    **Let's start with Distribution & Setup Excellence.**
    You marked it complete. What did you accomplish? What did you learn?

[Continues through each theme, then asks about new priorities...]
```

---

## Terminology: Planning Periods

### Standardization Decision

**Term:** `planning_period`

**Rationale:**
- Already in use in FEAT-093 (Planning Period Archival)
- Time-neutral: works for sprints, quarters, milestones, phases, ad-hoc
- Natural in conversation: "What planning period are we in?"
- Clear purpose: connects to planning activity
- Appropriate length for metadata fields

**Not Used:**
- ❌ `roadmap_group` - Too vague, doesn't convey time aspect
- ❌ `sprint_name` - Too specific, excludes other timeframe types
- ❌ `timebox_name` - Technical jargon

### User Comprehension Strategy

**Challenge:** The term is accessible, but the **free-form naming concept** needs explanation:
1. Users choose their own naming convention (not prescribed)
2. Any cadence works (sprints, quarters, phases, ad-hoc)
3. It's guidance, not enforcement (no deadlines/validation)

**Progressive Disclosure Approach:**

**1. Quick-Start Guide (First Exposure)**
```markdown
### Planning Periods

The framework uses **planning periods** to organize roadmap work.
You choose what works for your project:

- **Sprints**: "Sprint 1", "Sprint 2" (1-4 weeks each)
- **Quarters**: "Q1 2026", "Q2 2026" (3 months each)
- **Milestones**: "MVP", "Beta Launch", "GA" (feature-based)
- **Phases**: "Discovery", "Alpha", "Production" (stage-based)
- **Custom**: "Pre-Launch", "Summer Push", "After Redesign"

**Key point:** Planning periods are names YOU pick for organizing work,
not deadlines the framework enforces.
```

**2. ROADMAP-TEMPLATE.md (Contextual Guidance)**
```markdown
## Current Focus ([Your Planning Period Name])

**About Planning Periods:**
Replace "[Your Planning Period Name]" with whatever makes sense:
- "Sprint 3" if you work in sprints
- "Q1 2026" if you plan quarterly
- "Beta Phase" if you organize by project stages
- "Next 6 Weeks" or any custom name

Planning periods help organize work but aren't enforced deadlines.
```

**3. /fw-roadmap Skill (AI Conversational Guidance)**
When AI asks about timeframes during creation mode:
```
AI: "How do you want to organize your roadmap?

     Some teams use sprints (1-4 weeks), others use quarters (3 months),
     or milestone-based periods like 'MVP', 'Beta', 'Launch'.

     What rhythm makes sense for your project?"
```

**4. Framework Glossary (FEAT-088) (Reference Definition)**
```markdown
### Planning Period

A flexible, user-defined timeframe for organizing roadmap work. Common types:

- **Time-boxed**: Sprints (1-4 weeks), Quarters (3 months)
- **Milestone-based**: "MVP Complete", "Beta Launch", "v2.0 Release"
- **Phase-based**: "Discovery", "Alpha", "Production"
- **Ad-hoc**: "Post-Refactor", "After User Testing", "Holiday Season"

**Key Characteristics:**
- User chooses naming convention (not prescribed by framework)
- Used for organizing and grouping work, not enforcement
- No automatic deadlines or validation
- Can mix types in same project (e.g., quarterly themes with sprint execution)

**Usage:** Work items can reference planning periods in metadata.
Roadmaps organize themes by planning periods. Retrospectives mark
planning period boundaries.

**See also:** Roadmap (FEAT-091), Sprint Support (FEAT-092),
Planning Period Archival (FEAT-093)
```

**5. Work Item Template (Inline Comment)**
```yaml
**Planning Period:** [Optional - e.g., "Sprint 3", "Q2 2026", "Beta Phase"]
```

### Documentation Goals

**For All Skill Levels:**
- ✅ Experienced: Quick-start gives concept + examples, they move on
- ✅ Intermediate: Examples + AI guidance helps them choose
- ✅ Learning: Template comments + glossary provides full understanding

**Addresses Common Questions:**
- "Do I HAVE to use planning periods?" → No, they're optional
- "Can I change my planning period type?" → Yes, framework adapts
- "What if mine don't fit these categories?" → Use any names that make sense
- "Are planning periods enforced?" → No, they're organizational labels

---

## Acceptance Criteria

### MVP (v1.0) - In Scope

**Implementation:**
- [x] `/fw-roadmap` skill created in `.claude/commands/` (repo root)
- [x] Skill synced to `templates/starter/.claude/commands/`
- [x] Uses Senior Product Owner role + Opus model
- [x] Added to `/fw-help` command output (both locations)
- [ ] Reads project context before questioning (framework.yaml, PROJECT-STATUS.md)
- [ ] Creation mode only (no review mode detection needed for MVP)

**Behavior (3-Section Conversation):**
- [ ] Section 1: Asks strategic vision/purpose questions
- [ ] Section 2: Synthesizes themes (2-4) from user input
- [ ] Section 3: Defines success metrics for each theme
- [ ] Pushes back on vague answers (demonstrated in testing)
- [ ] Challenges scattered priorities (>4 themes)
- [ ] Drafts sections iteratively with approval checkpoints
- [ ] Generates ROADMAP.md with proper structure

**Documentation (MVP):**
- [ ] Skill file contains clear usage instructions
- [ ] Brief mention in session history when complete
- [ ] ROADMAP.md generated matches template structure

**Quality:**
- [ ] Tested on framework project (creation mode)
- [ ] Generates valid ROADMAP.md
- [ ] User feedback: Conversation feels strategic (not just form-filling)

### Post-MVP (v1.1+) - Deferred

**Features:**
- [ ] Review mode (periodic roadmap updates)
- [ ] Backlog integration (suggest work items at end)
- [ ] Retrospective integration (FEAT-093)
- [ ] PROJECT-STATUS.md synchronization
- [ ] Planning period documentation in Quick-Start, ROADMAP-TEMPLATE, Glossary
- [ ] Work item template planning period field

**Documentation:**
- [ ] Full workflow-guide.md section
- [ ] Example session included in docs
- [ ] Guidance on when to use vs manual editing
- [ ] Token usage measurement and optimization if needed

---

## Open Questions

### 1. Script vs Pure Conversational

**Question:** Should we implement the script alternative for token efficiency?

**Context:** Pure conversational is better UX but uses more tokens. Script collects data first, then AI refines.

**Decision:** ✅ **DECIDED - Use pure conversational approach.** Defer token optimization to future release if needed. MVP focuses on creation mode with 3-section conversation (Vision → Themes → Metrics).

### 2. Backlog Integration

**Question:** Should `/fw-roadmap` automatically create work items for themes with no backlog support?

**Pros:**
- Actionable roadmap immediately
- Prevents "strategic vision with no execution"
- Links themes to work

**Cons:**
- May feel pushy or premature
- User might want to create work items separately
- Adds complexity to skill

**Decision:** ✅ **DECIDED - Offer at the END with proposed list.** After completing the roadmap conversation, provide a proposed list of work items that could support the themes, then offer to create placeholder or detailed work items. Consider storing the proposed work item list in the roadmap itself.

**Deferred to:** Post-MVP (v1.1+)

### 3. Retrospective Integration

**Question:** Should review mode automatically trigger retrospective creation (FEAT-093)?

**Context:** Periodic reviews often happen at planning period boundaries (end of sprint, quarter, milestone, etc.). Could create retrospective as part of review process.

**Decision:** ✅ **DECIDED - Defer to post-MVP.** Get basics working first, then enhance. Keep `/fw-roadmap` focused on roadmap content initially.

**Deferred to:** Post-MVP (v1.1+) when FEAT-093 is implemented

---

## Dependencies

**Requires:**
- FEAT-091: Project Roadmap structure ✅ (Done)

**Blocks:**
- None (can be used immediately after implementation)

**Related:**
- FEAT-092: Sprint support (roadmap planning could include sprint assignment)
- FEAT-093: Planning archival (review mode touches on retrospective themes)
- FEAT-015: Executive summary (roadmap provides baseline for health checks)

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Added
- AI-guided roadmap questionnaire (`/fw-roadmap`)
  - Conversational roadmap creation and periodic reviews
  - Strategic questioning with constructive pushback
  - Automatic detection of vague goals and misaligned priorities
  - Iterative section drafting with user approval
  - Uses Senior Product Owner role with Opus model
  - Supports flexible timeframes (sprints, quarters, milestones, project phases)
```

---

## Notes

**Design Philosophy:**
- **Conversational:** Not a form to fill out, but a strategic dialogue
- **Challenging:** AI should push back, not just transcribe answers
- **Iterative:** Build sections one at a time with approval
- **Context-aware:** Reads project state before questioning

**User's Vision:**
> "I do think it needs to be very conversational. AI should pushback for clarity and potentially problematic ideas."

**Key Insight:**
Roadmap quality depends on strategic thinking, not just filling in blanks. The questionnaire's value is in **forcing** strategic reflection through good questions and constructive challenges.

**Why Opus?**
- This is strategic synthesis work, Opus's strength
- Low-frequency, high-value activity (periodic reviews, not daily work)
- Nuanced questioning and pushback requires stronger reasoning
- Token cost justified by output quality

**Why Senior Product Owner Role?**
- Focuses on "why" and strategic vision
- Mindset: "What problem are we really solving? What shouldn't we build?"
- Perfect alignment with roadmap's purpose

**Anti-patterns to Avoid:**
- ❌ Questionnaire becomes a rigid form
- ❌ AI accepts all answers without challenge
- ❌ Generating roadmap in one shot without iteration
- ❌ Ignoring existing project context
- ❌ Creating 10 themes because user mentioned 10 ideas

**Success Looks Like:**
- ✅ User feels heard but challenged
- ✅ Roadmap has 2-4 focused themes, not scattered priorities
- ✅ Success metrics are specific and measurable
- ✅ User understands *why* themes are prioritized this way
- ✅ Backlog work items align with roadmap themes

---

## Testing Insights (2026-02-01)

### MVP Test Results

**What Worked:**
- ✅ End-to-end flow functional (Vision → Themes → Metrics → Generate)
- ✅ Strategic questioning and pushback effective
- ✅ Produced valid, well-structured ROADMAP.md
- ✅ Senior Product Owner role provided good strategic framing

**Issues Discovered:**

1. **File Location Bug:**
   - Generated at project root instead of `docs/project/ROADMAP.md`
   - Need to update skill instructions

2. **Duration Exceeded Expectations:**
   - Took 25-35 minutes vs expected 5 minutes (5-7x longer)
   - Need upfront time expectation setting
   - Consider "quick mode" for users with existing vision/structure

3. **Roadmap Format Mismatch:**
   - Created theme-based strategic roadmap (OKR style)
   - User expected feature-based roadmap (Q1: F1, F2; Q2: F3, F4)
   - Theme-based feels like sprint planning, not product roadmap

### Key Insight: Feature-Based vs Theme-Based Roadmaps

**User Mental Model:**
Roadmaps show **feature progression over time**:
```
Q1 2026: Framework Command Suite (fw-roadmap, fw-status, fw-backlog)
Q2 2026: Application Planning Pattern (project setup, work breakdown)
Q3 2026: Onboarding Automation (quick-start, setup scripts)
```

**What MVP Created:**
Abstract strategic themes with metrics (more like OKRs):
```
Theme 1: Project Guidance & Planning (PRIMARY)
Theme 2: Framework Adoption & Onboarding (SECONDARY)
```

**Resolution:** Support feature-based roadmaps showing timeline of what's being built.

### Integration with Project Definition (Critical Discovery)

**Natural Information Flow:**

1. **Project Definition (FEAT-087)** - Happens once at project start
   - Define vision and problem
   - Identify major **feature areas** for project type
   - Document in README.md / PROJECT-STATUS.md

2. **Project Organization (FEAT-089)** - Maps work to features
   - Scan backlog and cluster by feature area
   - Establish planning patterns per project type

3. **Roadmap Planning (FEAT-095)** - Timeline-based planning
   - **Prerequisite:** Feature structure exists
   - Questions shift from "what are we building?" to "when and in what order?"
   - Output: Feature-based roadmap showing Q1, Q2, Q3 progression

**Benefit:** Vision questions happen once (FEAT-087), not every roadmap review.

### Recommended v1.1+ Improvements

1. **Vision Scanning:** Check README/PROJECT-STATUS for existing vision before asking foundational questions
2. **Backlog Analysis:** Scan work items to suggest data-driven feature areas/themes
3. **Feature-Based Format:** Default to timeline-oriented roadmap (Q1: F1, F2; Q2: F3)
4. **Time Expectations:** State upfront: "15-25 minutes" or offer quick mode
5. **File Path Fix:** Generate at `docs/project/ROADMAP.md` per workflow guide

---

**Last Updated:** 2026-02-01

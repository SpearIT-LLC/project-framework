# Session History: 2026-02-04

**Date:** 2026-02-04
**Participants:** Gary Elliott, Claude Code (Sonnet 4.5)
**Session Focus:** FEAT-095 - /fw-roadmap MVP v1.2 → v1.3 improvements
**Role:** Senior Architect

---

## Summary

Tested `/fw-roadmap` skill MVP v1.2 with live framework roadmap creation, received detailed feedback on 5 key issues (roadmap duplication, tactical vs strategic focus, work item IDs, naming conventions, update process). Updated skill to v1.3 with industry-standard strategic focus, natural language update support, and active pushback against tactical details. Revised framework roadmap from tactical (work item IDs, completion criteria) to strategic (outcomes, user value).

---

## Work Completed

### FEAT-095: Framework Roadmap Ideas - MVP v1.3 Improvements

**MVP v1.2 Testing:**
- Ran `/fw-roadmap` skill to create fresh framework roadmap
- User went through full conversational flow (Themes + Planning Periods model)
- Identified themes: Distribution & Onboarding, Workflow, Project Guidance, Developer Guidance
- Defined Sprint D&O 1-4 sequence + Sprint PG 1

**User Feedback (5 Key Issues):**
1. **Multiple roadmap copies** - Found duplicates at root, framework, and starter template
2. **Too tactical** - Skill felt like "sprint planning light", too focused on work items
3. **Work item IDs in roadmap** - Violated "keep roadmaps high-level" principle
4. **Naming convention** - Good capture of `Sprint {theme-shorthand} {number}`, should be in framework.yaml
5. **Update process** - Needed clear way to update specific planning periods

**Improvements Implemented:**

1. **Strategic Focus (Industry Norms):**
   - Added CRITICAL guidance to push back on work item specifics
   - Redirect from features to outcomes: "What will users be able to do?"
   - No work item IDs in roadmap - those belong in backlog
   - Suggest future `/fw-planning-period` command for tactical details

2. **Natural Language Updates:**
   - Users can say: "Let's update Sprint D&O 4 in the roadmap"
   - Or use positional syntax: `/fw-roadmap update "Sprint D&O 4"`
   - No special flags or modes required
   - Documented both approaches in skill usage

3. **Roadmap Cleanup:**
   - Deleted root `docs/project/ROADMAP.md` (wrong location)
   - Deleted `templates/starter/docs/project/ROADMAP.md` (users generate fresh)
   - Kept `framework/docs/project/ROADMAP.md` as temporary location
   - Documented final location: `project-hub/project/ROADMAP.md` (after FEAT-093)

4. **Framework Roadmap Revision:**
   - Removed all work item IDs (FEAT-005, DECISION-037, etc.)
   - Changed from "Key Work" to "Key Outcomes"
   - Focus on user value, not implementation details
   - Example: "Users can download a complete package" instead of "Create feature-005"

5. **Skill Documentation (v1.3):**
   - Version updated: v1.2 → v1.3 "Industry-Standard Strategic Roadmaps"
   - Added natural language update examples
   - Documented roadmap location (temporary + future)
   - Added future enhancements: themes in framework.yaml, FEAT-089 integration

---

## Decisions Made

### 1. Roadmaps Follow Industry Norms - Strategic, Not Tactical

**Context:** MVP v1.2 felt like "sprint planning light" with too much tactical detail (work item IDs, feature names, completion criteria).

**Decision:** Follow industry-standard roadmap conventions - strategic direction only, no tactical work item details.

**Rationale:**
- Industry roadmaps contain: vision, themes, high-level goals, success metrics
- Industry roadmaps DON'T contain: specific feature IDs, task breakdowns, estimated hours
- Backlog is the right place for tactical work items
- Roadmaps provide strategic framing; backlog provides tactical execution

**Impact:**
- AI actively pushes back when users mention work item IDs
- Redirects to outcomes: "What will users be able to do?" not "implement feature X"
- Suggest future `/fw-planning-period` command for detailed tactical planning
- Revised framework roadmap to remove all work item IDs

### 2. Roadmap Location - Temporary + Final

**Context:** Found 3 copies of ROADMAP.md (root, framework, starter template). DECISION-037 and session history indicated roadmap should go in `project-hub/project/` after FEAT-093.

**Decision:**
- **Temporary location:** `docs/project/ROADMAP.md` (until FEAT-093 completes)
- **Final location:** `project-hub/project/ROADMAP.md` (after project-hub reorganization)
- Remove from starter template - users generate fresh with `/fw-roadmap`

**Rationale:**
- Avoid duplication - one source of truth
- FEAT-093 will reorganize project-hub structure (project/, history/archive/)
- Users generating fresh roadmaps ensures they go through strategic conversation
- Framework dogfoods its own structure

**Impact:**
- Deleted root and starter template copies
- Skill documents temporary location in roadmap footer
- Skill will write to final location once FEAT-093 completes

### 3. Natural Language Update Support (Option C)

**Context:** User asked how to update predefined planning periods (e.g., Sprint D&O 4 when details become clear).

**Options Considered:**
- A: `/fw-roadmap update "Sprint D&O 4"` (positional syntax)
- B: `/fw-roadmap --review` (flag-based mode)
- C: Natural language - "Let's update Sprint D&O 4"

**Decision:** Support both Option A (positional) and Option C (natural language). Do NOT add Option B (--review flag).

**Rationale:**
- Natural language is most user-friendly, consistent with AI interaction model
- Positional syntax consistent with other framework commands (no -- flags used)
- `--review` flag would be novel, breaks framework conventions
- Natural language handles both update and review use cases

**Impact:**
- Documented both approaches in skill usage section
- No special modes or flags required
- Users choose whichever feels natural to them

### 4. Themes in framework.yaml (Future Enhancement)

**Context:** User suggested capturing naming convention and themes in framework.yaml for project-wide consistency.

**Decision:** Document as future enhancement, implement when themes mature.

**Proposed Structure:**
```yaml
themes:
  - id: distribution-onboarding
    name: Distribution & Onboarding
    shorthand: D&O
    description: "..."

planning:
  periodNamingConvention: "Sprint {shorthand} {number}"
  currentPeriod: "Sprint D&O 1"
```

**Rationale:**
- Themes are vague at project start, mature over time
- Initial `/fw-roadmap` run can establish themes
- FEAT-089 may provide typical theme templates for project types
- Work items can reference themes for consistency
- Skills can auto-suggest theme names

**Impact:**
- Documented in skill "Future Enhancements" section
- Integration with FEAT-089 (project patterns)
- Revisit when themes stabilize

### 5. Future /fw-planning-period Command

**Context:** Roadmaps should stay strategic, but users still need detailed tactical planning.

**Decision:** Suggest future `/fw-planning-period` command for detailed sprint/period planning.

**Purpose:**
- Bridge between strategic roadmap and tactical backlog
- Guide detailed planning for a specific planning period
- Help users break down outcomes into work items
- Maintain separation: roadmap = strategic, planning period = tactical

**Impact:**
- Mentioned in skill when pushing back on tactical details
- "Let's describe outcomes for the roadmap. For detailed work item planning, we'll add a `/fw-planning-period` command in the future"
- Clear separation of concerns: `/fw-roadmap` = strategic, `/fw-planning-period` = tactical

---

## Files Modified

### Framework Roadmap
- `framework/docs/project/ROADMAP.md` - Complete rewrite from tactical to strategic format
  - Removed all work item IDs (FEAT-005, DECISION-037, etc.)
  - Changed "Key Work" sections to "Key Outcomes"
  - Focus on user value and outcomes instead of implementation details
  - Added note about temporary location pending FEAT-093
  - Updated to use Themes + Planning Periods model (Sprint D&O 1-4, Sprint PG 1)

### fw-roadmap Skill
- `.claude/commands/fw-roadmap.md` - Updated to v1.3
  - Added natural language update usage examples
  - Added CRITICAL section on pushing back against work item specifics
  - Updated file location to temporary + future paths
  - Documented natural language update behavior
  - Added future enhancements (themes in framework.yaml, /fw-planning-period)
  - Version: v1.2 → v1.3 "Industry-Standard Strategic Roadmaps"

- `templates/starter/.claude/commands/fw-roadmap.md` - Synced v1.3 updates to starter template

---

## Files Deleted

- `docs/project/ROADMAP.md` - Wrong location (root level), removed to avoid duplication
- `templates/starter/docs/project/ROADMAP.md` - Removed from template, users generate fresh with `/fw-roadmap`

---

## Current State

### In doing/
- FEAT-095: Framework Roadmap Ideas - MVP v1.3 complete, testing validated, ready for done/

### Work Remaining (FEAT-095)
- Update FEAT-095 work item with v1.3 completion notes
- Consider creating FEAT-XXX for /fw-planning-period command (future)
- Consider creating work item for themes in framework.yaml (future)

---

## Key Learnings

**Strategic vs Tactical:**
- Early versions of features often drift toward tactical details
- Important to test with real usage and get user feedback
- Industry norms exist for good reasons - follow them unless file-based limitations require adaptation

**Naming Conventions:**
- `Sprint {theme-shorthand} {number}` pattern is clear and scalable
- Theme shorthands help identify focus (D&O, PG, WF, DG)
- Could eventually move to framework.yaml for consistency

**Natural Language AI Interaction:**
- Users prefer conversational updates over learning new syntax
- Positional args better than flags for framework command consistency
- Don't over-engineer modes when natural language handles it

**Roadmap Evolution:**
- Themes start vague, mature over time through conversation
- Planning periods get refined as they approach
- Roadmap is living document, not static plan
- FEAT-089 integration could provide typical themes for project types

---

**Last Updated:** 2026-02-04

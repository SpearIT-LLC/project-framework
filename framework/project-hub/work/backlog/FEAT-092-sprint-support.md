# Feature: Optional Sprint Support

**ID:** FEAT-092
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-01-27
**Theme:** Developer Guidance & Patterns

---

## Summary

Add optional sprint support to the framework, enabling teams to organize work into time-boxed iterations with lightweight ceremony and planning tools.

---

## Problem Statement

**What problem does this solve?**

Teams working in sprints need:
- Way to organize work items into time-boxed iterations
- Sprint planning and retrospective support
- Progress tracking within sprints
- Integration with existing roadmap and kanban workflow

**Who is affected?**

- Teams using agile/scrum methodologies
- Solo developers who prefer sprint cadence
- Projects needing predictable delivery rhythm

**Current workaround (if any):**

- Manual sprint planning in notes or external tools
- No structured retrospective process
- Sprint context lives only in memory or ad-hoc docs

---

## Requirements

### Functional Requirements

- [ ] Sprints must be **optional** (projects can ignore sprint features)
- [ ] Sprint configuration in framework.yaml
- [ ] Sprint planning support (select work items, set goals)
- [ ] Sprint retrospective support (review completed work, lessons learned)
- [ ] Integration with roadmap structure
- [ ] Work item sprint assignment (optional metadata)

### Non-Functional Requirements

- [ ] Compatibility: Works with existing kanban workflow
- [ ] Flexibility: Supports various sprint lengths and ceremony styles
- [ ] Simplicity: Minimal overhead, no complex tooling
- [ ] Documentation: Clear guidance on when/how to use sprints

---

## Design

### Open Questions (Discussion Points)

**1. Sprint Template**
- Do we need a sprint document template?
- What would it contain? (Goals, work items, retrospective notes?)
- Location: `project-hub/sprints/sprint-NN.md` or integrated into roadmap?

**2. Configuration (framework.yaml)**
```yaml
sprints:
  enabled: true           # yes/no or true/false?
  duration: "2wk"         # 1wk, 2wk, 3wk, 1mo, flexible
  ceremony: "informal"    # formal, informal
  start_day: "Monday"     # Sprint start day of week
```

**Questions:**
- Should `duration` be enforced or just guidance?
- What's the difference between formal vs informal ceremony?
- Do we need more config options?

**3. Organization: Metadata vs Folders**

**Option A: Metadata in Work Items**
```markdown
**Sprint:** Sprint 3 (2026-02-10 to 2026-02-23)
```
- Pros: Work items stay in kanban folders, no structure change
- Cons: Duration duplicated across work items (not DRY)

**Option B: Sprint Folders**
```
project-hub/
└── sprints/
    ├── sprint-01/
    │   ├── sprint-plan.md
    │   ├── retrospective.md
    │   └── work-items -> symlinks to work/?
    └── sprint-02/
```
- Pros: Single source of truth for sprint dates
- Cons: Adds complexity, symlinks may not work on all platforms

**Option C: Roadmap Integration**
- Sprints defined only in roadmap (ROADMAP.md)
- Work items reference: `**Sprint:** Sprint 3`
- Sprint dates live in roadmap only (SsoT)
- Pros: No duplication, roadmap is sprint plan
- Cons: Work items reference sprint by name, not dates

**Recommendation:** Option C - Roadmap as sprint SsoT

**4. Sprint Metadata Single Source of Truth**

Problem: If work items say `**Sprint:** Sprint 3 (2026-02-10 to 2026-02-23)`, dates are duplicated.

**Proposed Solution:**
- Work items: `**Sprint:** Sprint 3` (name only)
- Roadmap: Sprint 3 definition with dates
- Tool resolves sprint name to dates from roadmap

**5. Framework Skills**

```
/fw-sprint-planning [sprint-name]
/fw-retrospective [sprint-name]
```

**Sprint Planning:**
- Review roadmap themes
- Select work items from backlog for sprint
- Update roadmap with sprint assignments
- Optionally create sprint document

**Retrospective:**
- Review completed work items (what got done)
- Document lessons learned
- Adjust velocity estimates
- Plan next sprint assignments in roadmap

---

## Proposed Sprint Workflow

### Sprint Structure in Roadmap

```markdown
## SPRINT 1 (2026-01-27 to 2026-02-09) - CURRENT
**Theme:** Developer Guidance & Patterns
**Goal:** Establish foundational developer guidance artifacts

**Committed:**
- FEAT-091: Roadmap structure ✅
- FEAT-088: Framework glossary 🚧
- FEAT-089: Project patterns 📋

**Stretch Goals:**
- FEAT-090: Coding patterns

**Sprint Retrospective:** [Link to retro doc]

## SPRINT 2 (2026-02-10 to 2026-02-23) - PLANNED
**Theme:** AI Integration & Clarity
...
```

### Work Item Sprint Metadata

```markdown
**ID:** FEAT-088
**Type:** Feature
**Priority:** High
**Sprint:** Sprint 1
**Theme:** Developer Guidance & Patterns
```

### Sprint Ceremonies

**Sprint Planning (Start):**
1. Review roadmap themes
2. Select work items from backlog
3. Assign to sprint in roadmap
4. Optionally add sprint metadata to work items
5. Commit sprint plan

**Daily (Informal):**
- Work through `doing/` folder
- Update work item status
- Move completed items to `done/`

**Retrospective (End):**
1. Review what got done (scan `done/` folder)
2. Document lessons learned
3. Update velocity/capacity estimates
4. Plan next sprint in roadmap
5. Archive or carry over incomplete work

---

## Integration with Existing Features

**Roadmap (FEAT-091):**
- Roadmap becomes the sprint planning document
- Current sprint = top section
- Upcoming sprints below
- Themes organize sprint work

**Kanban Workflow:**
- No change to folder structure
- Work items flow: backlog → todo → doing → done
- Sprint is a planning/grouping layer on top

**Session History:**
- Sprint retrospective references session history
- Retrospective extracts lessons from daily sessions

---

## Alternative Approaches Considered

**Approach 1: Sprints as Folders**
- Create `project-hub/sprints/sprint-NN/` folders
- Move work items into sprint folders
- **Rejected:** Too much structure, breaks kanban flow

**Approach 2: Sprint Tracking in Separate Tool**
- Use external tool (Jira, Trello, etc.)
- Framework only for work item details
- **Rejected:** Goes against file-based philosophy

**Approach 3: No Sprint Support**
- Just use roadmap with loose time groupings
- **Rejected:** Teams need sprint cadence for predictability

---

## Dependencies

**Requires:**
- FEAT-091: Project Roadmap (provides sprint planning structure)

**Blocks:**
- None

**Related:**
- FEAT-015: Executive Summary (could report sprint progress)
- Session history (feeds into retrospectives)

---

## Acceptance Criteria

- [ ] Sprint configuration added to framework.yaml schema
- [ ] Sprint planning workflow documented
- [ ] Retrospective workflow documented
- [ ] `/fw-sprint-planning` skill created
- [ ] `/fw-retrospective` skill created
- [ ] Work item templates updated with optional Sprint field
- [ ] Roadmap template updated with sprint example
- [ ] Documentation covers when to use sprints (and when not to)

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Added
- Optional sprint support for agile teams
  - Sprint configuration in framework.yaml
  - Sprint planning and retrospective workflows
  - /fw-sprint-planning and /fw-retrospective skills
  - Roadmap integration for sprint tracking
  - Optional sprint metadata in work items
```

---

## Notes

**Design Philosophy:**
- **Optional:** Sprints should feel like an enhancement, not a requirement
- **Lightweight:** Minimal ceremony, no heavy process
- **Flexible:** Support 1-4 week sprints, formal or informal
- **Integrated:** Works with existing roadmap and kanban

**Key Decision:** Roadmap as sprint SsoT
- Sprint dates and assignments live in roadmap
- Work items reference sprint by name only
- Eliminates duplication while maintaining clarity

**When to Use Sprints:**
- Team wants predictable delivery cadence
- Regular retrospectives add value
- Need to coordinate multiple people
- Planning ahead helps focus

**When to Skip Sprints:**
- Solo developer with fluid schedule
- Maintenance-only project
- Sprint ceremony feels like overhead
- Just starting out (add sprints later if needed)

**Related Discussion:**
- Original concept from roadmap design discussion (2026-01-27)
- User feedback: "Sprint grouping might be better than quarterly milestones"
- Collaborative planning emphasized over top-down assignment

---

**Last Updated:** 2026-01-27

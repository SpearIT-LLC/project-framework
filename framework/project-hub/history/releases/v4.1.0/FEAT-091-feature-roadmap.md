# Feature: Project Roadmap Structure

**ID:** FEAT-091
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Status:** Done
**Created:** 2026-01-27
**Completed:** 2026-01-27

---

## Summary

Define a roadmap structure and process to help projects maintain strategic direction, measure progress, and prioritize work beyond the immediate backlog.

---

## Problem Statement

**What problem does this solve?**

Projects currently lack:
- Long-term strategic direction beyond the backlog
- Clear milestones to measure progress against
- Framework for prioritizing competing initiatives
- Way to communicate project vision to stakeholders

**Current state:**
- Work items exist in backlog without strategic context
- No distinction between "urgent" and "important"
- Difficult to answer "where is this project going?"
- No baseline for project health checks (FEAT-015) to measure against

**Who is affected?**

- Project maintainers planning next steps
- Teams coordinating on larger initiatives
- Stakeholders wanting project visibility
- AI assistants needing context for prioritization

**Current workaround (if any):**

- Ad-hoc planning in individual work items
- Mental model of "what comes next" not documented
- PROJECT-STATUS.md "What's Next" section (limited to 2-3 items)

---

## Requirements

### Functional Requirements

- [ ] Define roadmap file structure and format
- [ ] Specify what belongs in roadmap vs backlog
- [ ] Establish roadmap review/update cadence
- [ ] Create template for roadmap items
- [ ] Document how roadmap informs prioritization

### Non-Functional Requirements

- [ ] Compatibility: Works with existing kanban workflow
- [ ] Flexibility: Adapts to different project types and scales
- [ ] Maintainability: Low overhead, doesn't become stale
- [ ] Documentation: Clear distinction from backlog, clear purpose

---

## Design

### Roadmap Structure Options

**Option 1: Time-based roadmap**
- Organize by quarters or releases
- Good for: Applications with release cycles
- Example: Q1 2026, Q2 2026, Future

**Option 2: Theme-based roadmap**
- Organize by strategic themes
- Good for: Frameworks, ongoing projects
- Example: Performance, User Experience, Documentation, Integrations

**Option 3: Milestone-based roadmap**
- Organize by major milestones
- Good for: Projects with clear phases
- Example: MVP, Beta, GA, v2.0

**Recommended:** Hybrid approach - themes with milestones

### Proposed File Location

**Option A:** `project-hub/roadmap/`
- Separate folder parallel to work/ and history/
- Contains: ROADMAP.md, possibly theme-specific files

**Option B:** `ROADMAP.md` at project root
- High visibility
- Parallel to PROJECT-STATUS.md

**Option C:** `project-hub/planning/ROADMAP.md`
- Grouped with other planning artifacts

### Roadmap vs Backlog

| Roadmap | Backlog |
|---------|---------|
| Strategic direction | Tactical work items |
| 6-12 month horizon | Immediate next steps |
| Themes and milestones | Specific features/bugs |
| "Where we're going" | "What we're doing" |
| Updated quarterly | Updated continuously |

**Workflow:**
1. Roadmap defines strategic themes
2. Work items created in backlog to support themes
3. Work items reference roadmap themes in metadata
4. Progress toward themes measured by completed work items

### Example Roadmap Structure

```markdown
# Project Roadmap

**Last Updated:** 2026-01-27
**Next Review:** 2026-04-27

## Current Focus (Q1 2026)

### Theme: Distribution & Setup
**Goal:** Make it easy to adopt the framework

**Key Initiatives:**
- ✅ Framework-as-dependency distribution model (DECISION-050)
- ✅ Build and setup automation
- 🚧 Project type selection during setup (TECH-087)
- 📋 Interactive setup wizard

**Success Metrics:**
- Setup time under 5 minutes
- Zero manual file editing required

## Next Phase (Q2 2026)

### Theme: AI Integration
**Goal:** Improve framework-AI collaboration

**Key Initiatives:**
- CLAUDE.md optimization (TECH-061)
- Framework glossary (FEAT-088)
- Context-aware roles (FEAT-059)

### Theme: Quality & Validation
**Goal:** Catch issues before they reach users

**Key Initiatives:**
- Validation script (FEAT-007)
- Release automation (FEAT-028)
- Test harness (FEAT-051)

## Future Considerations

- GitHub/Jira integration (research needed)
- Multi-language documentation support
- Visual roadmap generation
```

### Integration with Existing Features

**FEAT-015 (Executive Summary):**
- Roadmap provides baseline for "on track" assessment
- Executive summary reports progress toward roadmap themes

**Project Health Check:**
- Measures actual work against roadmap commitments
- Identifies drift from strategic direction

---

## Dependencies

**Requires:**
- None (can start with basic ROADMAP.md)

**Blocks:**
- FEAT-015: Executive Summary (needs roadmap for context)

**Related:**
- PROJECT-STATUS.md "What's Next" section (roadmap is expanded version)
- FEAT-052: Task-Based Templates (templates may reference roadmap)

---

## Acceptance Criteria

- [x] Roadmap structure and format defined
- [x] ROADMAP.md template created in framework/templates/
- [x] Roadmap documentation added to workflow-guide.md
- [x] Framework project adopts roadmap structure (dogfooding)
- [x] Roadmap synced to templates/starter/
- [x] Clear guidance on roadmap vs backlog distinction

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Added
- Project roadmap structure and template
  - Strategic direction beyond immediate backlog
  - Theme-based organization with milestones
  - Quarterly review cadence
  - Integrated with PROJECT-STATUS.md and backlog workflow
```

---

## Notes

Concept originated from [misc-thoughts-and-planning.md](../research/misc-thoughts-and-planning.md#Roadmap).

**Original idea:**
```
## Roadmap
Define a clear roadmap.
Perhaps document the high level map with mermaid?

- File based Kanban workflow
- Roles
- Project templates
- Slash commands
- Code standards for popular languages?
- GitHub Workflow
- Jira Workflow
- Multi AI model support?
- Performance optimizations
```

**User's vision:** "I still like the idea of a feature roadmap for planning purposes. We can brainstorm the details but this would help guide both the framework project and user projects to help keep it on track. Then the executive summary, feat-015, or a project health check has something to measure against."

**Key Insight:** Roadmap provides strategic context that the backlog lacks. It answers "why are we building this?" and helps prioritize between competing work items.

**Anti-pattern to avoid:** Roadmap becoming a commitment rather than a guide. It should inform decisions, not constrain them.

---

**Last Updated:** 2026-01-27

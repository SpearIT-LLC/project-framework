# Feature: /fw-tour Command

**ID:** FEAT-115
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-02-06
**Theme:** Distribution & Onboarding
**Planning Period:** Sprint D&O 1

---

## Summary

Create a `/fw-tour` skill that provides a guided tour of the framework with options for quick overview vs. detailed exploration.

---

## Problem Statement

**What problem does this solve?**

New users need orientation to the framework, but the current tour (when requested) is too verbose and overwhelming.

**Discovered in:** FEAT-011 validation (hello-father project)
- User feedback: "Tour of the framework was a bit too verbose but it was thorough"
- Impact: Information overload on first interaction
- No way to get a quick overview vs. deep dive

**Current state:**
- Ad-hoc tour when user asks for framework overview
- No structured, reusable tour content
- No quick vs. detailed options

**Who is affected?**
- New users onboarding to the framework
- Users returning after long absence
- Users wanting to explore specific areas

---

## Requirements

### Functional Requirements

- [ ] Create `/fw-tour` skill with tour options:
  - [ ] Quick tour (5-10 key points, 2-3 minutes)
  - [ ] Standard tour (comprehensive overview, 10-15 minutes)
  - [ ] Topic-specific tours (e.g., "tour workflows", "tour work items")
- [ ] Interactive tour flow:
  - [ ] Present information in digestible chunks
  - [ ] Offer "learn more" or "skip" options
  - [ ] Show examples from current project
- [ ] Tour content covers:
  - [ ] Project structure (project-hub, framework folders)
  - [ ] Work item workflow (backlog → todo → doing → done)
  - [ ] Key commands (/fw-status, /fw-move, /fw-next-id, etc.)
  - [ ] Roles system
  - [ ] Where to find documentation

### Non-Functional Requirements

- [ ] Concise: Quick tour under 500 words
- [ ] Actionable: Include "try it" suggestions
- [ ] Progressive: Easy to go from quick → detailed
- [ ] Reusable: Can be invoked at any time

---

## Design

### Tour Levels

**Quick Tour (Default):**
```
/fw-tour

Welcome to SpearIT Project Framework! 👋

Quick Tour (3 minutes):
1. 📁 Structure: project-hub/ contains your work items, research, history
2. 🎯 Workflow: backlog → todo → doing → done → releases
3. 🤖 Commands: /fw-status, /fw-move, /fw-next-id
4. 📝 Work Items: Markdown files tracked in Git
5. 🎭 Roles: Switch AI personas (architect, developer, reviewer)

Try it: /fw-status (see your current work)

Want more? /fw-tour --detailed
```

**Detailed Tour:**
```
/fw-tour --detailed

[Progressive sections with examples from project]
- Project structure walkthrough
- Work item lifecycle explained
- Command reference
- Roles and collaboration patterns
- Where to find docs
```

**Topic Tours:**
```
/fw-tour workflows
/fw-tour work-items
/fw-tour commands
/fw-tour roles
```

### Implementation Approach

**Option A: Skill with embedded content**
- Content in skill prompt
- Pros: Self-contained, easy to update
- Cons: Large skill file

**Option B: Skill + markdown content files**
- Tour content in `framework/docs/tours/`
- Skill reads and presents content
- Pros: Easier to maintain content, reusable in docs
- Cons: Additional files to sync

**Recommendation:** Option B - content in markdown files

### File Structure

```
framework/docs/tours/
├── quick-tour.md
├── detailed-tour.md
├── workflows-tour.md
├── work-items-tour.md
└── commands-tour.md
```

---

## Acceptance Criteria

- [ ] `/fw-tour` command created and working
- [ ] Quick tour (default) is concise and actionable
- [ ] Detailed tour option available (`--detailed`)
- [ ] Tour content is accurate and up-to-date
- [ ] Examples reference user's actual project
- [ ] Tour can be invoked at any time (not just first run)
- [ ] User feedback: Less overwhelming than current ad-hoc tour

---

## Dependencies

**Related:**
- FEAT-011: Discovered the verbosity issue during validation
- FEAT-107: Onboarding experience improvements

---

## Open Questions

### 1. Should tour run automatically on first setup?

**Options:**
- A: Setup script offers to run tour
- B: Tour runs automatically after setup
- C: User must invoke manually

**Recommendation:** Option A (offer, don't force)

### 2. Should tour be interactive or static?

**Interactive:** Asks questions, responds to input
**Static:** Presents information, user reads

**Recommendation:** Static with "try it" prompts (simpler, reusable)

---

## CHANGELOG Notes

```markdown
### Added
- `/fw-tour` command for guided framework orientation
  - Quick tour (default): 5 key points in 3 minutes
  - Detailed tour: Comprehensive walkthrough
  - Topic-specific tours available
```

---

## Notes

**Design Philosophy:**
- Just-in-time learning (show what's needed, when needed)
- Progressive disclosure (quick → detailed on demand)
- Actionable (tell user what to try, not just what exists)

**Success Metric:**
- User can get oriented in 3-5 minutes
- Clear next steps after tour
- Positive feedback vs. current ad-hoc approach

---

**Last Updated:** 2026-02-06

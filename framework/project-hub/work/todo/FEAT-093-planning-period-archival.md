# Feature: Planning Period Archival System

**ID:** FEAT-093
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-01-27
**Theme:** Workflow Enhancements

---

## Summary

Implement a systematic archival process for completed planning periods (sprints, quarters, milestones) that includes retrospective capture, completion reporting, and organized historical storage. Reorganize project-hub structure to separate active planning from archived history.

---

## Problem Statement

**What problem does this solve?**

Currently:
- No structured process for archiving completed planning periods
- ROADMAP.md will grow indefinitely without archival strategy
- Retrospectives are ad-hoc, not integrated into workflow
- No clear location for storing completed period documentation
- Active planning docs mixed with historical information

**Who is affected?**

- Project maintainers who need clean, focused roadmaps
- Teams wanting to preserve retrospective insights
- Anyone trying to understand project history and evolution
- AI assistants needing to distinguish active vs historical planning

**Current workaround (if any):**

- Manual section management in ROADMAP.md
- Retrospectives in ad-hoc notes or not captured at all
- Historical context lives only in git history
- Planning documents grow without pruning strategy

---

## Requirements

### Functional Requirements

- [ ] Reorganize project-hub structure with project/ and history/archive/ folders
- [ ] Move active ROADMAP.md to project-hub/project/
- [ ] Create /fw-retrospective skill for completion reporting
- [ ] Create /fw-archive skill for archiving completed periods
- [ ] Support multiple planning styles (sprint, quarterly, milestone)
- [ ] Archive format preserves plan + retrospective + metrics
- [ ] Archival process integrated into period completion workflow

### Non-Functional Requirements

- [ ] Works regardless of planning style configured
- [ ] Archive files are self-contained and readable standalone
- [ ] Process is simple enough for solo developers
- [ ] Clear guidance on when to archive (after retrospective)
- [ ] Archived content removed from active roadmap

---

## Proposed Solution

### 1. Reorganized Structure

```
framework/project-hub/
├── project/                       # Active planning (NEW)
│   ├── ROADMAP.md                 # Moved from docs/project/
│   └── (future: OKRs, milestones, etc.)
├── work/                          # Existing kanban
│   ├── backlog/
│   ├── todo/
│   ├── doing/
│   └── done/
├── history/
│   ├── archive/                   # Completed planning periods (NEW)
│   │   ├── sprint-01.md
│   │   ├── sprint-02.md
│   │   ├── q1-2026.md
│   │   └── milestone-mvp.md
│   ├── sessions/                  # Existing
│   └── decisions/                 # Existing
├── research/                      # Existing
└── external-references/           # Existing
```

**Rationale:**
- **project/** = Active planning and strategy
- **history/archive/** = Completed planning periods with retrospectives
- **docs/** = Technical/solution documentation (separated from project management)

### 2. Archival Workflow

**Step 1: Completion Report**
```bash
/fw-retrospective "Sprint 3"
```

Generates report with:
- What was committed (from roadmap/project plan)
- What got done (scan done/ folder for period)
- What didn't finish (remaining in todo/doing)
- Velocity metrics
- Timeline information

**Step 2: Retrospective**

User reviews report and adds:
- What went well
- What to improve
- Lessons learned
- Adjustments for next period

Can be done:
- Inline in the report
- As conversation with AI
- In team meeting notes

**Step 3: Archive**
```bash
/fw-archive "Sprint 3"
```

This skill:
1. Extracts relevant section from ROADMAP.md
2. Combines with retrospective notes
3. Creates `project-hub/history/archive/sprint-03.md`
4. Removes archived content from ROADMAP.md
5. Commits changes

### 3. Archive File Format

```markdown
# Sprint 3 (2026-02-10 to 2026-02-23) - COMPLETED

**Planning Style:** Sprint
**Theme:** AI Integration & Clarity
**Duration:** 2 weeks
**Committed:** 5 items
**Completed:** 4 items (80%)
**Carried Over:** 1 item

---

## Committed Work

- ✅ FEAT-088: Framework glossary
- ✅ TECH-061: CLAUDE.md optimization
- ✅ FEAT-059: Context-aware roles
- ✅ FEAT-007: Validation script
- 🔄 FEAT-089: Project patterns (moved to Sprint 4)

---

## Retrospective

**What Went Well:**
- Clear theme focus kept work aligned
- Validation script unblocked testing workflows
- Good collaboration on glossary definitions

**What to Improve:**
- FEAT-089 scope was larger than estimated
- Need better dependency identification upfront
- Should have broken pattern work into phases

**Lessons Learned:**
- Pattern documentation needs dedicated design time
- Validation infrastructure pays immediate dividends
- Theme-based planning helps maintain coherence

**Adjustments for Next Period:**
- Break large features into smaller chunks
- Add explicit design phase to estimation
- Review dependencies during planning

---

## Metrics

- **Velocity:** 4 completed / 5 committed = 80%
- **Cycle Time:** Average 3.5 days per feature
- **Blockers:** 1 (external dependency on FEAT-059)
- **Scope Changes:** 1 item re-scoped and carried over

---

**Archived:** 2026-02-24
**Archived By:** /fw-archive skill
**Next Period:** Sprint 4 (2026-02-24 to 2026-03-09)
```

### 4. Framework Skills

#### /fw-retrospective

**Purpose:** Generate completion report for a planning period

**Usage:**
```bash
/fw-retrospective "Sprint 3"
/fw-retrospective "Q1 2026"
/fw-retrospective "MVP Milestone"
```

**Behavior:**
1. Read ROADMAP.md to find period definition
2. Scan done/ folder for items completed during period
3. Check todo/doing for uncommitted items from period
4. Calculate metrics (velocity, completion rate)
5. Generate structured report
6. Prompt user to add retrospective notes

#### /fw-archive

**Purpose:** Archive a completed planning period

**Usage:**
```bash
/fw-archive "Sprint 3"
```

**Behavior:**
1. Verify period is complete (ask user to confirm)
2. Check for retrospective notes (prompt if missing)
3. Extract period section from ROADMAP.md
4. Combine plan + retrospective + metrics
5. Create archive file in project-hub/history/archive/
6. Remove archived content from ROADMAP.md
7. Commit changes with message "Archive Sprint 3"

**Safeguards:**
- Confirm before removing from roadmap
- Preserve archive file if it already exists (append -v2, etc.)
- Show diff of ROADMAP.md changes before commit

### 5. Configuration (Optional)

Add to framework.yaml:

```yaml
planning:
  style: sprint              # sprint, quarterly, milestone, continuous
  archive_trigger: manual    # manual or automatic (after retrospective)
```

---

## Integration with Existing Features

### FEAT-092 (Sprint Support)
- This archival system works WITH sprint planning
- Sprint completion triggers retrospective → archive workflow
- Archive preserves sprint goals, commitments, and outcomes
- **Relationship:** FEAT-093 provides the archival infrastructure, FEAT-092 provides sprint-specific planning features

### FEAT-091 (Roadmap)
- ROADMAP.md moves to project-hub/project/
- Stays focused on current + next 2-3 periods
- Completed periods archived rather than deleted
- Roadmap stays lean and forward-focused

### Session History
- Archived planning periods can reference session history
- Session history provides detailed implementation context
- Planning archives provide strategic context

---

## Migration Plan

### Phase 1: Structure Reorganization
1. Create `framework/project-hub/project/` folder
2. Create `framework/project-hub/history/archive/` folder
3. Move `docs/project/ROADMAP.md` → `project-hub/project/ROADMAP.md`
4. Update all references to ROADMAP.md location
5. Update framework documentation

### Phase 2: Archive Q1 2026 (Completed)
1. Extract Q1 2026 section from ROADMAP.md
2. Add retrospective notes
3. Create `project-hub/history/archive/q1-2026.md`
4. Remove Q1 section from active ROADMAP.md

### Phase 3: Implement Skills
1. Create /fw-retrospective skill
2. Create /fw-archive skill
3. Document usage in workflow guides
4. Test with Q2 2026 (when complete)

---

## Alternative Approaches Considered

### Option 1: Keep ROADMAP.md in docs/project/
**Rejected:** Mixes project management (project-hub) with technical docs (docs/)

### Option 2: Collapse completed sections instead of archiving
**Rejected:** Still grows ROADMAP.md over time, loses retrospective context

### Option 3: No archival, just delete completed sections
**Rejected:** Loses strategic history and retrospective insights

### Option 4: Archive in git tags/branches instead of files
**Rejected:** Less discoverable, requires git knowledge to access

---

## Dependencies

**Requires:**
- FEAT-091: Project roadmap (provides structure to archive)

**Blocks:**
- None

**Related:**
- FEAT-092: Sprint support (uses this archival infrastructure)
- Session history (complements planning archives)

---

## Acceptance Criteria

### Structure
- [ ] project-hub/project/ folder created
- [ ] project-hub/history/archive/ folder created
- [ ] ROADMAP.md moved to project-hub/project/
- [ ] All references updated to new location

### Skills
- [ ] /fw-retrospective skill created and tested
- [ ] /fw-archive skill created and tested
- [ ] Skills documented in framework documentation
- [ ] Skills handle edge cases (missing retrospective, already archived, etc.)

### Documentation
- [ ] Workflow guide updated with archival process
- [ ] ROADMAP.md template updated with archival guidance
- [ ] Archive file template created
- [ ] Migration guide for existing projects

### Validation
- [ ] Q1 2026 successfully archived as proof of concept
- [ ] ROADMAP.md stays focused on current + future
- [ ] Archive files are readable and self-contained
- [ ] Process works for different planning styles

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Added
- Planning period archival system
  - /fw-retrospective skill for completion reporting
  - /fw-archive skill for archiving completed periods
  - project-hub/project/ folder for active planning
  - project-hub/history/archive/ folder for completed periods
  - Retrospective capture as part of period completion

### Changed
- ROADMAP.md moved from docs/project/ to project-hub/project/
- Project management artifacts consolidated under project-hub/

### Migration
- Update references to ROADMAP.md location
- Optionally archive completed planning periods using /fw-archive
```

---

## Notes

**Design Philosophy:**
- Planning stays lean and forward-focused
- History is preserved, not lost
- Retrospectives are first-class artifacts
- Works for any planning style (sprint, quarterly, milestone)
- Simple enough for solo developers, scales to teams

**Key Decisions:**
- Archive after retrospective (not automatically when period ends)
- Separate active planning (project/) from history (history/archive/)
- Archive files are self-contained (plan + retro + metrics)
- Process is manual by default (prevents premature archival)

**When to Archive:**
1. All committed work is done (or explicitly carried over)
2. Retrospective is complete
3. Next period is planned
4. Team/user is ready to close the chapter

**Benefits:**
- Clean separation: active vs historical
- Retrospectives become part of workflow
- Strategic history preserved alongside tactical history (session/decisions)
- ROADMAP.md stays focused and readable
- Works with any planning style

---

## Related

- FEAT-091: Project roadmap structure
- FEAT-092: Optional sprint support (uses this archival system)
- Session history in project-hub/history/sessions/
- ADRs in project-hub/history/decisions/

---

**Last Updated:** 2026-01-27

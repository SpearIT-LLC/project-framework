# Backlog Ideas from FEAT-026

**Created:** 2026-01-06
**Source:** FEAT-026-followup.md discussion
**Status:** Idea collection (not yet work items)
**Location:** framework/thoughts/research/ (moved from work/backlog/ on 2026-01-08)

---

## Summary

This document captures enhancement ideas and discussion items discovered during FEAT-026 implementation. These are NOT part of FEAT-026 and should become separate work items in the future.

---

## Work Items Created

**Instructions:** As you create work items from the ideas below, add them here with creation date. When all desired items are created, move this file to history/archive/.

- **2026-01-08:** TECH-028-dry-documentation-principles.md (Item #2 - Policy)
- **2026-01-08:** DECISION-029-license-choice.md (Item #6)
- **2026-01-08:** FEAT-030-add-hold-folder.md (Item #1)
- **2026-01-08:** FEAT-031-index-source-of-truth-registry.md (Item #3 - Tooling)
- **2026-01-08:** FEAT-032-multiple-items-per-release.md (Item #4)
- **2026-01-08:** TECH-033-status-field-redundancy.md (Item #5)
- **2026-01-08:** FEAT-034-projects-showcase.md (Item #7)
- **2026-01-08:** DECISION-035-root-status-reference.md (Item #8)
- **2026-01-08:** TECH-036-refactor-duplicate-documentation.md (Item #2, #3 - Implementation)
- **2026-01-08:** FEAT-037-project-config-file.md (New - emerged from TECH-028 discussion)

**Workflow for DRY Documentation:**
- TECH-028: Establish DRY principles (policy)
- FEAT-031: Implement INDEX.md registry (tooling)
- TECH-036: Audit and refactor existing docs (implementation)

**New Feature (emerged from discussion):**
- FEAT-037: Project config file - provides context and master policy index for AI/tooling

**Note:** Items #9 and #10 not created as separate work items:
- Item #9 (Standard Framework Level definition) - May be addressed by FEAT-026-P2 cleanup work
- Item #10 (Large team references review) - Overlaps with FEAT-026-P2-TECH-remove-enterprise

---

## Enhancement Ideas

### 1. Add work/hold/ Folder to Workflow
**Priority:** Medium
**Type:** ENH (Enhancement)
**Description:** Add a work/hold/ folder for work items that are paused due to urgent interruptions.

**Rationale:**
- Acknowledges reality - urgent items sometimes interrupt planned work
- Better than ad-hoc solutions
- Provides explicit structure for paused work

**From:** FEAT-026-followup.md line 8

**Suggested work item:** FEAT-NNN-add-hold-folder.md

---

### 2. Document DRY Principles for Documentation
**Priority:** High
**Type:** TECH (Process Improvement)
**Description:** Add DRY (Don't Repeat Yourself) principles to documentation guidelines.

**Rationale:**
- Every policy should have single source of truth
- Some duplication OK for reference but always link to source
- Prevents contradictions and maintenance burden

**From:** FEAT-026-followup.md line 39

**Suggested work item:** TECH-NNN-dry-docs-principle.md

**Should include:**
- Document DRY principle in framework guidelines
- Add to collaboration/ or process/ documentation
- Update INDEX.md to track source-of-truth for topics

---

### 3. INDEX.md as Source-of-Truth Registry
**Priority:** Medium
**Type:** ENH (Enhancement)
**Description:** Enhance INDEX.md to explicitly track which file is the source-of-truth for each topic.

**Rationale:**
- Helps prevent duplication
- Clear reference for where to update information
- Supports DRY documentation principle

**From:** FEAT-026-followup.md line 11

**Suggested work item:** FEAT-NNN-index-sot-registry.md

**Example format:**
```markdown
## Topic: Workflow Steps
- **Source of Truth:** framework/process/workflow-guide.md
- **References:** CLAUDE.md (overview), QUICK-START.md (quick ref)
```

---

### 4. Support Multiple Work Items Per Release
**Priority:** Medium
**Type:** ENH (Workflow Enhancement)
**Description:** Document or implement support for releasing multiple work items together under same version.

**Rationale:**
- Real-world scenario: 3 bug fixes might ship together as v2.2.6
- Current workflow assumes one item per release
- Need to clarify how to handle grouped releases

**From:** FEAT-026-followup.md line 34-35 (Step 9 discussion)

**Suggested work item:** FEAT-NNN-multi-item-release.md

**Should address:**
- How to group multiple items for single release
- CHANGELOG.md handling
- Release history organization
- Version bumping strategy

---

### 5. Review Status Field Redundancy
**Priority:** Low
**Type:** TECH (Process Review)
**Description:** Review whether status field in work item files is redundant with folder location.

**Rationale:**
- Folder IS the status (backlog/, todo/, doing/, done/)
- Status field in file might be redundant
- Could simplify or remove field

**From:** FEAT-026-followup.md line 33-34 (Step 7 discussion)

**Suggested work item:** TECH-NNN-status-field-redundancy.md

**Options:**
1. Remove status field entirely (folder is status)
2. Keep field but say "See location"
3. Use field for sub-status (e.g., "doing - blocked")

---

### 6. License Decision
**Priority:** High (blocking public release)
**Type:** DECISION
**Description:** Create work item to decide which license to use for the framework.

**From:** FEAT-026-followup.md line 26

**Suggested work item:** DECISION-NNN-license-choice.md or ADR

**Should consider:**
- MIT vs Apache vs GPL
- Business requirements
- Open source strategy
- Attribution requirements

---

### 7. Projects Showcase
**Priority:** Low
**Type:** ENH (Documentation)
**Description:** Add mechanism for listing other projects using the framework.

**From:** FEAT-026-followup.md line 24

**Suggested work item:** FEAT-NNN-projects-showcase.md

**Could include:**
- Add section to README.md
- Separate PROJECTS.md file
- Contribution process for adding projects
- Showcase successful framework usage

---

## Discussion Items (Need Investigation)

### 8. Root Status Reference Decision
**Type:** DECISION
**Description:** Decide if root README should reference framework/PROJECT-STATUS.md or have its own.

**From:** FEAT-026-followup.md line 20-21

**Options:**
- Keep as-is (framework is main project)
- Add root-level PROJECT-STATUS.md
- Create MONOREPO-STATUS.md

**Suggested work item:** DECISION-NNN-root-status-reference.md

---

### 9. Standard Framework Level Definition
**Type:** TECH (Documentation)
**Description:** Clearly define what "Standard Framework Level" means.

**From:** FEAT-026-followup.md line 29

**Note:** This might be addressed by FEAT-026-P2-TECH-claude-md-cleanup

**Suggested work item:** TECH-NNN-define-standard-level.md (if needed after P2 cleanup)

---

### 10. Large Team References Review
**Type:** TECH (Documentation)
**Description:** Review and clarify or remove references to large teams.

**From:** FEAT-026-followup.md line 38-39

**Rationale:**
- Current framework realistically not for large teams
- Should we remove large team references?
- Or clarify scope and limitations?

**Note:** Overlaps with FEAT-026-P2-TECH-remove-enterprise

**Suggested work item:** May not need separate item after P2 cleanup

---

## Additional Notes

### Conceptual Model Clarification
**From:** FEAT-026-followup.md lines 20, 66

We don't have "framework levels" - we have:
- ONE framework (The Standard Project Framework)
- Multiple project template packages (Minimal, Light, Standard)

This conceptual clarity should inform all future documentation work.

---

### Hello-World Language Choice
**From:** FEAT-026-followup.md line 54

examples/hello-world/ uses JavaScript, but PowerShell might be more appropriate.
- Don't change now
- Address in future enhancement to hello-world project

---

## Workflow for This File

When ready to create work items:
1. Copy relevant section above
2. Use appropriate template from framework/templates/work-items/
3. Create as FEAT-NNN, TECH-NNN, or DECISION-NNN in work/backlog/
4. Add entry to "Work Items Created" section above with date
5. When all desired items created, move this file to history/archive/

---

**Created:** 2026-01-06
**Moved to research/:** 2026-01-08
**Items Captured:** 10 enhancement ideas + additional notes
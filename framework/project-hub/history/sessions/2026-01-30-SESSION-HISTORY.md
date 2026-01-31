# Session History: 2026-01-30

**Date:** 2026-01-30
**Participants:** User, Claude Code
**Session Focus:** Artifacts Pattern Design and TEST File Cleanup
**Role:** senior-architect

---

## Summary

Continuation session from TECH-094 completion. Identified orphaned TEST-006 file in doing/ and evolved the discussion into designing a comprehensive artifacts management pattern. Decided on folder-follows-parent approach where all associated files (tests, research, deliverables, temp files) live in `WORK-ID/` subfolder that moves with the parent work item.

---

## Work Completed

### Artifacts Management Pattern Design

**Problem Identified:**
- TEST-006 still in doing/ after TECH-094 moved to done/
- TEST-001 through TEST-005 scattered in done/
- No clear guidance on handling test artifacts, research files, deliverables, temp files
- No documented lifecycle for associated files

**Discussion Evolution:**
1. Initial observation: TEST files should have been sub-tasks of TECH-094
2. Recognized pattern: Multiple types of associated files (test, research, audit, temp)
3. Question: Can we treat them all the same?
4. Explored options:
   - Parent-based artifacts folder
   - Type-based folders (research/, tests/, deliverables/, temp/)
   - Hybrid approach
5. **User's insight:** "What if all associated docs lived in a sub-folder and followed the parent?"

**Pattern Decided:**

```
work/doing/
  TECH-094-fw-move-enforcement.md          # Work item
  TECH-094/                                 # Artifacts folder
    test-001-valid-item.md
    test-002-missing-status.md
    research-hooks-capabilities.md
    hook-testing-notes.txt
    diagram.png
```

**Key Principles:**
- **Any file type** - .md, .txt, .json, .png, code files, whatever
- **Folder follows parent** - Move/delete work item → folder moves/deletes too
- **Self-documenting** - Folder name matches work item ID
- **No special folders needed** - Don't need project-hub/tests/, /deliverables/, /temp/
- **Simple lifecycle** - One git mv operation moves everything

**Integration with fw-move:**
- Command checks for `WORK-ID/` folder
- Moves both work item file and folder together
- No orphaned artifacts

---

## Decisions Made

**1. Folder-Follows-Parent Pattern for All Artifacts:**
- **Decision:** All work item associated files live in `WORK-ID/` subfolder
- **Rationale:**
  - Natural colocation - everything related lives together
  - Simple lifecycle - folder follows parent everywhere
  - Self-documenting structure
  - Works for any content type
  - No special folder taxonomy needed
- **User preference:** "I'm not crazy about splitting up files because it might be easy to forget they exist"

**2. Research Files Exception:**
- **Decision:** Cross-cutting research stays in `project-hub/research/`
- **Rationale:** Research often informs multiple work items, needs discoverability
- **Work items reference research:** "See research/claude-hooks-research.md"

**3. Stakeholder Deliverables - Deferred:**
- **Decision:** Keep in subfolder for now (`TECH-061/audit-report.md`)
- **Future consideration:** "Revisit with FEAT-015 - might need `project-hub/reports/` folder"
- **Rationale:** Don't over-engineer before seeing actual usage patterns

**4. Large Files - Deferred:**
- **Decision:** Capture in follow-up work item
- **Options to explore:**
  - User prompt when encountering large files
  - Project configuration setting (`framework.yaml`)
  - .gitignore patterns with external storage references
  - Size threshold policy
- **Rationale:** Edge case that needs more research and real-world experience

**5. Terminology:**
- **Term chosen:** "Artifacts" (concise, widely understood in project management)
- **Alternatives considered:** Associated files, supporting files, supplementary materials

---

## Decisions Pending

**Immediate Next Steps:**
1. Clean up TEST files using new artifacts pattern
2. Create work item to document artifacts pattern in workflow-guide.md
3. Update fw-move to handle folder-follows-parent logic
4. Update work item templates with artifacts guidance

**Future Work Items:**
- Edge case refinement (large files, reports folder, etc.)
- fw-move enhancement for artifact folder handling
- Documentation updates

---

## Files Modified

None yet - planning session only.

---

## Files Created

None yet - planning session only.

---

## Current State

### In done/ (awaiting release)
- TECH-094: Workflow Enforcement System
- TECH-084, TECH-085, TECH-086, TECH-081, FEAT-091, TECH-087, DECISION-050
- TEST-001, TEST-002, TEST-003, TEST-004, TEST-005 (orphaned, need cleanup)

### In doing/
- TEST-006 (orphaned, need cleanup)

### In todo/ (7 items)
- TECH-070: Issue Response Process (High)
- TECH-070.1: Validate Issue Response Process (Medium)
- FEAT-095: AI Roadmap Questionnaire (High)
- FEAT-093: Planning Period Archival (High)
- FEAT-092: Sprint Support (Medium/effective High)

### In backlog/
- TECH-096: Enforce Policies for Manual Operations (Low)

---

## Key Insights

**1. Simplicity Beats Taxonomy:**
- Proposed complex folder hierarchies (tests/, deliverables/, temp/)
- User's insight: Just put everything in a subfolder with parent's name
- Result: Simpler, more maintainable, self-documenting

**2. Structure Enforces Lifecycle:**
- Folder structure naturally enforces parent-child relationship
- No need for Parent fields, dot notation, or complex tracking
- Git operations handle the rest

**3. Don't Over-Engineer Edge Cases:**
- Large files, stakeholder reports, etc. are edge cases
- Better to document simple pattern first, refine based on real usage
- Noted for future work items rather than blocking progress

**4. User Feedback Drives Better Design:**
- Initial proposals were complex, multi-folder hierarchies
- User's "what if folder follows parent" was the breakthrough
- Sometimes the simplest solution is the best one

---

## Pattern Comparison

**Rejected Approaches:**

*Sub-task Pattern (TECH-070.1 style):*
- Pros: Formal tracking, status visibility
- Cons: Every test file becomes a work item, clutters work folders
- Why rejected: Too heavyweight for artifacts

*Type-Based Folders:*
- Pros: Browse all tests in one place, all research in one place
- Cons: Fragments artifacts, hard to see complete picture of work item
- Why rejected: User preference for colocation

**Adopted Approach:**

*Folder-Follows-Parent:*
- Pros: Simple, self-documenting, natural lifecycle, works for any content
- Cons: Research that informs multiple items needs special handling
- Why adopted: Matches user's mental model, simplest that could possibly work

---

**Last Updated:** 2026-01-30

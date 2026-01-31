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

## Session 2: Workflow Policy Development

**Session Focus:** Release sizing and branching strategy discussions

### Work Items Created

**DECISION-097: Release Sizing Policy**

**Trigger:** 9 items in done/ - more than typical. Question: What's the right amount for a release?

**Options Considered:**
1. No guidance (status quo) - Maximum flexibility, but inconsistent
2. Strict limits by version type - Clear but too rigid
3. Gentle guidance with progressive nudging - **CHOSEN**
4. Project-type-specific policies - Defer to FEAT-089

**Decision:**
- Sweet spot: 3-8 items per MINOR release
- AI nudges at 10 items: "Consider releasing"
- AI recommends at 15+ items: "Recommend releasing or splitting"
- Quality gates matter more than count
- User always has final say

**Rationale:**
- Helpful without being authoritarian
- Balances CHANGELOG clarity with release overhead
- Proven simple pattern first, refine based on experience
- Leaves door open for project-type variations

**Follow-up Work:**
- Add "Release Sizing" section to version-control-workflow.md
- Update fw-status to show item count with indicators
- Add AI logic for release suggestions
- Revisit with FEAT-089 for project-type variations

**TECH-098: Auto-Branching Strategy**

**Trigger:** Question about whether to create branches for work items. Industry best practices?

**Problem:**
- Current workflow is trunk-based (work on main directly)
- No guidance on when to branch vs. trunk
- No tooling support for consistent branching
- Manual branch creation prone to inconsistent naming

**Proposed Solution:**
1. Document branching strategies (trunk-based vs. feature branches)
2. Add project configuration option in framework.yaml
3. Integrate auto-branching with fw-move (optional)
4. Recommend strategy based on project type (after FEAT-089)

**Configuration Concept:**
```yaml
workflow:
  branching:
    strategy: auto      # or: manual, never
    pattern: "{type}-{id}-{slug}"
    auto_branch_for:
      - FEAT
      - SPIKE
      - DECISION
```

**When to Branch:**
- FEAT items (larger scope, multi-session)
- SPIKE items (experimental, might abandon)
- DECISION items (might want review)

**When to Use Trunk:**
- TECH items (small improvements)
- BUG items (quick fixes)
- Single-session work

**Philosophy:**
- Default to simplicity (trunk-based unless configured)
- User always in control
- Consistent naming prevents ad-hoc variations
- After FEAT-089, can recommend based on project type

### Decisions Made (Session 2)

**6. Release Sizing Approach:**
- **Decision:** Gentle guidance over strict enforcement
- **User insight:** "AI prompts would be polite and professional but not mandatory"
- **Rationale:** Helpful suggestions without being authoritarian

**7. Project-Type Variations Timing:**
- **Decision:** Single reasonable policy now, multi-project types later
- **User guidance:** "Later we can consider multi-project types, perhaps after feat-089? Keep it simple, prove the pattern, then expand?"
- **Rationale:** Don't over-engineer before we have evidence we need complexity

**8. Branching Strategy Approach:**
- **Decision:** Document and explore, don't implement immediately
- **Priority:** Low (TECH-098 in backlog)
- **Rationale:** Current trunk-based works well, but worth having capability for users' projects

### Files Created (Session 2)

- `framework/project-hub/work/backlog/DECISION-097-release-sizing-policy.md` - Release sizing guidelines
- `framework/project-hub/work/backlog/TECH-098-auto-branching-strategy.md` - Auto-branching exploration

### Key Insights (Session 2)

**1. Guidance vs. Enforcement:**
- User preference for "polite and professional" AI suggestions
- Never mandatory, never blocking
- Provide context and recommendations, user decides

**2. Prove Pattern First, Expand Later:**
- Same philosophy as artifacts pattern
- Simple defaults that work for 80% of cases
- Expand based on real experience, not theoretical complexity
- FEAT-089 as future expansion point

**3. Work Item Numbering Discovery:**
- DECISIONs use common namespace (not separate sequence)
- DECISION-050 exists → next is DECISION-097
- All types (FEAT, BUG, TECH, DECISION, SPIKE) share same ID pool

**4. Industry Practices Inform, Don't Dictate:**
- Reviewed continuous delivery, agile, trunk-based, feature branch approaches
- Framework context different from deployed services
- Adapt practices to framework needs (docs/templates, gradual adoption)

---

**Last Updated:** 2026-01-30

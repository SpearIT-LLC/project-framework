# Session History: 2026-01-12

**Date:** January 12, 2026
**Participants:** User (gelliott), Claude (Sonnet 4.5)
**Duration:** ~2 hours
**Focus:** Work item prioritization, DECISION-036 analysis, framework distribution model

---

## Summary

Started with prioritizing todo/ items, discovered DECISION-036 (template access) is actually a symptom of a larger architectural question about framework distribution. Created DECISION-050 to capture the "framework-as-dependency" model and deferred DECISION-036 pending that decision.

**Key insight:** The framework should be treated like a package dependency - each project gets its own copy, with version tracking and selective updates, rather than all projects referencing a shared framework.

---

## What We Did

### 1. Prioritized Todo Items

**Context:** User requested ranking of all work items in `framework/thoughts/work/todo/`

**Analysis completed:**
- Read and analyzed 11 todo items
- Identified dependencies and blocking relationships
- Ranked by priority (P0-P4)

**Priority ranking:**
- **P0 Critical:** DECISION-036 (template access strategy)
- **P1 High:** FEAT-025-ALIGNMENT-ANALYSIS, FEAT-025, TECH-043
- **P2 Important:** FEAT-037, FEAT-031, TECH-046
- **P3 Enhancement:** FEAT-022, FEAT-018, feature-017
- **P4 Exploratory:** FEAT-025-brainstorming

**Recommended execution order:** DECISION-036 → FEAT-025 → TECH-043 → FEAT-037

---

### 2. Started Work on DECISION-036

**Context:** User said "Let's work on decision-036"

**Learning moment:** Initially jumped into analysis without following proper workflow. User correctly pointed out policy requires:
1. Check WIP limit in doing/
2. Move work item from todo/ → doing/
3. Then begin work

**Action taken:**
- Checked doing/ WIP limit (0 items, within limit of 1)
- Moved DECISION-036 from todo/ to doing/
- Then proceeded with analysis

**Policy reinforcement:** When user says "let's work on [work-item]", that signals:
- Move to doing/
- Follow kanban workflow properly
- Don't just dive into the work

---

### 3. Analyzed DECISION-036 Options

**Initial analysis:**
- Reviewed 5 options for template access (copy, reference, minimal set, online, hybrid)
- Recommended Option 1 (copy templates) for self-containment

**User feedback:** "I'm not crazy about copying the templates unless we need to override something"

**Revised analysis:**
- Explored Option 2 (reference framework templates)
- Discussed for monorepo vs standalone projects
- Realized: Projects using the framework ARE in monorepo, not standalone

**Key clarification:** If someone uses this framework, they work IN the monorepo structure. The framework IS the project structure.

---

### 4. Discovered Broader Architectural Question

**Three critical questions emerged:**

**Q1: Search order - FIFO vs LIFO?**
- If both `project/templates/` and `framework/templates/` exist, which wins?
- Project-first (LIFO) recommended - standard pattern like CSS, PATH, npm

**Q2: Partial overrides - Version drift problem**
- User customizes one template, framework updates others
- How to get improvements without losing customizations?
- Options: Accept ownership, version tracking, file checksums, config-based overrides
- Recommended: Start simple (accept ownership), evolve if needed

**Q3: Framework freeze for archival**
- When project is "done", bundle framework with it?
- Options: Git history sufficient, version tracking in config, export/freeze command
- Recommended: Version tracking in config (FEAT-037)

**Realization:** These problems affect ALL framework content, not just templates!

---

### 5. Framework-as-Dependency Paradigm Shift

**User's insight:** "What if a new project gets a copy of the entire framework, minus history. Then we provide a method to update the framework."

**This changed everything.** Treating framework like a package dependency:

**Benefits:**
- ✅ Self-contained - Project has everything
- ✅ Customizable - User owns their copy
- ✅ Upgradeable - Update when ready
- ✅ Stable - Project controls timing
- ✅ Portable - Zip and go
- ✅ Simple mental model

**Distribution model:**
```
project-foo/
├── framework/              # Local copy with version tracking
│   ├── templates/
│   ├── process/
│   ├── collaboration/
│   └── .framework-version
├── src/
└── thoughts/
```

**Update mechanism:**
```powershell
Update-Framework.ps1 -Version latest
```

---

### 6. Created DECISION-050

**Created:** [DECISION-050-framework-distribution-model.md](../work/backlog/DECISION-050-framework-distribution-model.md)

**Comprehensive documentation includes:**
- Core questions from our discussion
- 4 distribution model options
- Detailed analysis of framework-as-dependency approach
- 6 open questions requiring resolution
- Impact analysis on current monorepo
- Recommendation: Adopt framework-as-dependency model

**Key sections:**
- Search order strategy (project-first)
- Partial override handling (accept ownership)
- Archival approach (version tracking in config)
- Version tracking mechanism (.framework-version file)
- Update mechanism (MVP: manual, later: script)
- Framework exclusions (exclude framework/thoughts/)
- Integration with FEAT-037 (project config)
- Dogfooding strategy (after FEAT-025 validation)

---

### 7. Deferred DECISION-036

**Rationale:** Template access cannot be properly decided without first resolving the broader framework distribution model.

**Actions taken:**
- Updated DECISION-036 status to "Deferred"
- Added deferral note explaining the broader question
- Added "Blocked By: DECISION-050"
- Moved DECISION-036 from doing/ back to backlog/

**Key insight:** DECISION-036 is a symptom, DECISION-050 addresses the root cause.

---

### 8. NPM Discussion

**User question:** "Do you think our framework is a realistic candidate to become an npm package in the future?"

**Analysis:**
- **Technically possible** - NPM can distribute any files
- **Philosophically wrong** - Framework is language-agnostic, not Node.js-specific
- **Wrong audience** - PowerShell/Python developers shouldn't need Node.js
- **Wrong mechanism** - NPM packages are ephemeral (node_modules/), framework should be committed

**Better distribution options:**
- GitHub releases (recommended)
- Git clone/submodule
- PowerShell Gallery (if framework grows tooling)
- Simple zip download

**Key insight:** Use NPM's **update philosophy** (versioning, selective updates, ownership), but not NPM itself for distribution.

**User's wisdom:** "I don't want to overcomplicate it. There is beauty in simplicity."

**Simple approach:**
- Copy framework into project
- It's yours now
- Update from source when ready
- No fancy infrastructure needed

---

## Decisions Made

### Workflow Process Decision
- When user says "let's work on [work-item]", immediately move to doing/ before analysis
- Follow kanban workflow: Check WIP → Move to doing → Begin work
- Reinforces proper work item lifecycle

### DECISION-036 Status
- **Deferred** pending DECISION-050 resolution
- Template access is a symptom, not the root problem
- Will be resolved naturally once framework distribution model is decided

### DECISION-050 Created
- Captured framework-as-dependency model
- Documented all discussion points and open questions
- Recommended approach: Framework-as-dependency with simple distribution
- Ready for decision and implementation planning

### Distribution Philosophy
- Keep it simple
- No npm, no complex package management
- Files in folders, copy when needed, update when ready
- Build tooling only if usage validates the need

---

## Files Modified

**Created:**
- `framework/thoughts/work/backlog/DECISION-050-framework-distribution-model.md` - Framework distribution model decision

**Modified:**
- `framework/thoughts/work/backlog/DECISION-036-template-access-strategy.md` - Added deferral note, blocked by DECISION-050

**Moved:**
- `DECISION-036-template-access-strategy.md` - todo/ → doing/ → backlog/ (workflow: started, then deferred)

---

## Insights & Lessons Learned

### For AI (Claude)
1. **Follow workflow policy strictly** - When user says "work on X", move to doing/ first
2. **Recognize broader patterns** - Template access was symptom of larger architectural question
3. **Ask clarifying questions** - "Standalone project without framework" revealed conceptual confusion
4. **Simple is better** - User values simplicity over sophisticated tooling
5. **Capture discussions comprehensively** - DECISION-050 preserves all context from conversation

### For Framework Development
1. **Framework-as-dependency is the right model** - Aligns with target audience (solo developers)
2. **Self-containment matters** - Projects should be portable and offline-capable
3. **Version drift is acceptable** - For documentation/process framework, stability > latest
4. **Distribution mechanism is separate from concept** - NPM's philosophy is good, NPM itself is wrong tool
5. **Start simple, evolve** - Manual copy for MVP, tooling only if validated by usage

### For Project Management
1. **Deferring is valid** - When work item reveals bigger question, create proper work item and defer
2. **Priority rankings help** - Clear P0-P4 ordering provides roadmap
3. **Dependencies matter** - DECISION-036 blocks FEAT-025, both blocked by DECISION-050
4. **One thing at a time** - WIP limit of 1 keeps focus

---

## Open Questions & Follow-up Items

### Immediate Next Steps
1. **DECISION-050 requires discussion and decision**
   - Major architectural change
   - Impacts FEAT-025 validation
   - Affects all future project setup

2. **After DECISION-050 resolved:**
   - Implement chosen distribution model
   - Update NEW-PROJECT-CHECKLIST.md
   - Update template packages
   - Resolve DECISION-036 as consequence

### Future Considerations
1. **Dogfooding:** When to apply framework-as-dependency to project-hello-world?
   - Recommendation: After FEAT-025 validation completes

2. **Update tooling:** Build `Update-Framework.ps1` if usage validates need
   - Start with manual instructions (MVP)
   - Add scripting if users request it

3. **Public distribution:** If framework goes public, use GitHub releases + simple zip download

---

## Statistics

**Work Items Analyzed:** 11
**Work Items Created:** 1 (DECISION-050)
**Work Items Modified:** 1 (DECISION-036)
**Work Items Moved:** 1 (DECISION-036: todo → doing → backlog)
**Workflow State:** Clean (doing/ empty, WIP = 0/1)

**Key Files:**
- Created: DECISION-050-framework-distribution-model.md (~650 lines)
- Modified: DECISION-036-template-access-strategy.md (added deferral note)

---

## Context for Next Session

**Current State:**
- **DECISION-050** - In backlog, needs discussion and decision (P0 priority)
- **DECISION-036** - In backlog, deferred pending DECISION-050
- **doing/** - Empty (WIP = 0)

**Recommended Next Actions:**
1. Discuss and decide DECISION-050
2. After decision: Implement framework distribution model
3. Then: Resolve DECISION-036 as natural consequence
4. Then: Proceed with FEAT-025 validation

**Critical Path:**
```
DECISION-050 → DECISION-036 → FEAT-025 → [Blocks FEAT-005/006]
```

**Alternative Path (if DECISION-050 deferred):**
- Work on independent items: TECH-043, TECH-046, FEAT-037
- These don't block or depend on distribution model decision

---

## Quotes

> "I'm not crazy about copying the templates unless we need to override something." - User, revealing preference for DRY over duplication

> "What if a new project gets a copy of the entire framework, minus history. Then we provide a method to update the framework." - User, proposing framework-as-dependency model

> "I don't want to overcomplicate it. There is beauty in simplicity." - User, emphasizing minimalist approach

---

---

## Session Continuation (After Context Compaction)

### 9. DECISION-050 Completion

**Context:** User decided to proceed with DECISION-050 implementation. Worked through all key decisions step by step.

**Supporting documents created:**

1. **[DECISION-050-framework-distribution-flow-diagram.md](../work/backlog/DECISION-050-framework-distribution-flow-diagram.md)**
   - 5 Mermaid diagrams explaining framework-as-dependency model
   - Framework lifecycle, setup flow, update flow
   - Work item context separation
   - Visual clarification of dual identity (project vs dependency)

2. **[DECISION-050-customization-example.md](../work/backlog/DECISION-050-customization-example.md)**
   - Before/after examples of customization tagging
   - 10+ tagging options explored
   - Comparison matrices for different approaches
   - Simplified and refined based on user feedback

**User feedback on examples:**
- Initial examples too verbose (medical device regulatory content)
- Requested simplification: "trim it down to the essentials"
- Changed to Hamburger Condiment Policy example (simpler, clearer)
- Multiple iterations to find right balance

---

### 10. Customization Tagging Decision

**Evolution of approach:**

**Initial proposal:** Three keywords (CUSTOM, MODIFIED, CUSTOMIZED)
- User questioned: "Do we really need 3 keywords to denote effectively the same thing?"
- **Decision:** Single keyword `CUSTOM` for all customizations

**Final tagging standard:**
```markdown
<!-- File header (required) -->
<!-- CUSTOM: v3.0.0, 2026-01-12 -->

# Feature: [Feature Name]
...

<!-- Section-level tag -->
## New Section
<!-- CUSTOM: v3.0.0, 2026-01-12 -->
[custom content]

<!-- Inline tag (with closing) -->
## Existing Section
- Original content
<!-- CUSTOM: v3.0.0, 2026-01-12 -->
- Custom addition
<!-- /CUSTOM -->
```

**Rationale:**
- Simple, single keyword
- Version and date for tracking
- File header + section/inline tags
- Context is self-evident from content

---

### 11. Update Strategy Refinement

**Terminology confusion resolved:**

**User question:** "If we're merging the framework into the user project, then does the 'Project-first override' matter anymore?"

**Clarification:** Not about search order (no multiple frameworks), but about **customization preservation** during updates:
- preserveCustomizations - Keep user modifications
- replaceAll - Overwrite everything
- interactive - Prompt for decisions

**Label evolution:**
- Initial: "Safest - Recommended" and "Risky"
- User feedback: "I'm not sure I like the 'Safest - Recommended', 'Risky' tags"
- **Decision:** Neutral descriptive labels (preserveCustomizations, replaceAll, interactive)
- User: "I like the new labels because depending on the framework improvement, the risky thing COULD be not to update"

---

### 12. Version-Agnostic Update Script Design

**User insight:** "I also like a strategy were the update framework script is version agnostic. Same script that works for v1 as it will for v20."

**Implementation approach:**
- Simple `grep -r "<!-- CUSTOM:"` to detect customizations
- Algorithm looks only for tags, not framework internals
- No version-specific logic
- Works across all framework versions

**User confirmation:** "Should the compare just be a simple grep?"
- **Answer:** Yes - simple, reliable, version-agnostic

---

### 13. Test Harness Strategy

**User proposed:** "Which also makes me think of our testing strategy. We're going to have to maintain a copy of the framework at every level in a test area."

**Test harness design:**
- Read-only baseline versions at each framework release
- Test cases for different update scenarios
- Validate update script behavior across versions
- Version-agnostic testing approach

**Decision:** Create separate work item for test harness
- User confirmed: "Yes the test harness should be it's own work item"

**Created:** [FEAT-051-framework-update-test-harness.md](../work/backlog/FEAT-051-framework-update-test-harness.md)
- Read-only baselines stored as compressed archives
- Test runner validates update scenarios
- YAML-based test case definitions
- 17 hour implementation estimate

---

### 14. DECISION-050 Finalization

**Status change:** Proposed → **Decided**

**Key decisions documented:**
1. ✅ Distribution Model: Framework-as-dependency
2. ✅ Override Strategy: Project-first (customizations take precedence)
3. ✅ Customization Ownership: User owns customized files
4. ✅ Customization Tagging: Single `CUSTOM` keyword with version and date
5. ✅ Version Tracking: `.framework-version` file + `project-config.yaml` integration
6. ✅ Framework Exclusions: Exclude `framework/thoughts/` from user copies
7. ✅ Update Strategy: Manual (MVP), build tooling later if validated
8. ✅ Implementation Timing: After FEAT-025 validates current setup
9. ✅ Archival Strategy: Version tracking in config (sufficient)

**Future implementation work items identified:**
- FEAT-XXX: Implement framework-as-dependency for project-hello-world (dogfooding)
- FEAT-XXX: Update template packages to include framework/
- FEAT-XXX: Create .framework-version tracking
- FEAT-XXX: Document customization tagging standard
- FEAT-XXX: Framework Update Script (version-agnostic)
- FEAT-051: Framework Update Test Harness (created)

---

### 15. DECISION-036 Resolution

**Status change:** Deferred → **Decided (Resolved by DECISION-050)**

**Resolution:** Templates are embedded in framework/ copy that each project receives
- Option 1 from original analysis (copy templates) adopted
- Natural consequence of framework-as-dependency model
- Self-contained, portable, customizable

---

## Additional Files Modified (Session Continuation)

**Created:**
- `framework/thoughts/work/backlog/DECISION-050-framework-distribution-flow-diagram.md` - Visual documentation (5 Mermaid diagrams)
- `framework/thoughts/work/backlog/DECISION-050-customization-example.md` - Tagging examples and options
- `framework/thoughts/work/backlog/FEAT-051-framework-update-test-harness.md` - Test infrastructure work item

**Modified:**
- `framework/thoughts/work/backlog/DECISION-050-framework-distribution-model.md` - Status updated, DECISION SUMMARY added, future work items listed
- `framework/thoughts/work/backlog/DECISION-036-template-access-strategy.md` - Status updated, Resolution section added

---

## Key Insights (Session Continuation)

### Visual Documentation Value
- User feedback: "The diagrams helped alot. We should do more of those."
- Mermaid diagrams extremely effective for explaining architecture
- Flow diagrams clarify complex concepts better than text alone

### Simplicity Over Complexity
- Started with verbose examples, user requested simplification
- "Do we really need 3 keywords?" - Reduced to one
- Simple grep detection over complex parsing
- Manual MVP over sophisticated tooling

### Version-Agnostic Design
- Script should work the same for v1→v2 as v10→v11
- Look for tags, not framework internals
- Test harness validates across all versions
- Future-proof architecture

### Neutral Language
- Avoid judgmental labels ("risky", "safest")
- Descriptive names better than prescriptive
- User may need "risky" option depending on context

---

## Final Status

**DECISION-050:** ✅ **Decided** - Framework-as-dependency model adopted
**DECISION-036:** ✅ **Decided (Resolved)** - Templates embedded in framework copy
**FEAT-051:** ✅ **Created** - Test harness work item in backlog

**Work completed:**
- Major architectural decision made and documented
- Supporting visual documentation created
- Customization tagging standard defined
- Update strategy designed
- Test infrastructure planned
- Implementation roadmap identified

**Clean state:**
- doing/ empty (WIP = 0/1)
- All decisions documented
- Supporting materials complete
- Ready for implementation phase

---

**Session End:** 2026-01-12 (evening)
**Status:** DECISION-050 complete, DECISION-036 resolved, FEAT-051 created
**Next Focus:** Implementation work items or proceed with FEAT-025

---

**Last Updated:** 2026-01-12

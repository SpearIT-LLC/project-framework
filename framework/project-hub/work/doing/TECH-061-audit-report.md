# CLAUDE.md Duplication Audit Report

**Work Item:** TECH-061
**Date:** 2026-01-28
**Files Analyzed:**
- `/CLAUDE.md` (114 lines)
- `/framework/CLAUDE.md` (728 lines)

---

## Executive Summary

**Current State:**
- Root CLAUDE.md: 114 lines (target: <100 lines) - ✅ Already under target
- Framework CLAUDE.md: 728 lines (no specific target, but goal is to reduce cognitive load)
- Bootstrap block: 10 lines (target: <20 lines) - ✅ Already under target

**Key Findings:**
1. ✅ **No direct duplication** between the two files - they have distinct purposes
2. ⚠️ **Some overlap in concepts** but presented at different levels of detail
3. ✅ **Clear separation of concerns** is already established
4. ❌ **Opportunity to leverage FEAT-088 Glossary** - many inline term definitions could reference glossary instead
5. ⚠️ **Bootstrap block currently in root file** - working as intended per design
6. ❌ **Framework CLAUDE.md has extensive reference content** that could be streamlined

---

## File-by-File Analysis

### `/CLAUDE.md` (Root Repository File)

**Purpose:** Navigation and repository routing for multi-project structure

**Current Length:** 114 lines

**Content Breakdown:**

| Section | Lines | Category | Assessment |
|---------|-------|----------|------------|
| Bootstrap Block | 10 | Bootstrap-critical | ✅ Keep - concise, essential |
| Navigation intro | 3 | Bootstrap-critical | ✅ Keep |
| Epistemic Standards | 8 | Bootstrap-critical | ✅ Keep - establishes fact-checking expectation |
| Project Configuration | 4 | Reference | ✅ Keep - points to framework.yaml |
| Repository Structure | 12 | Reference | ✅ Keep - navigation aid |
| Which Project routing | 28 | Navigation-critical | ✅ Keep - core purpose of this file |
| Repository Workflow | 22 | Reference | ✅ Keep - framework/templates/tools distinction |
| First Time guide | 8 | Navigation-critical | ✅ Keep |
| Quick Reference links | 7 | Reference | ✅ Keep |
| Final reminder | 4 | Navigation-critical | ✅ Keep |

**Duplication Check:**
- ✅ No content duplicated from framework/CLAUDE.md
- ✅ Serves distinct purpose (repository routing vs. framework collaboration)

**Recommendations:**
1. ✅ **No changes needed** - already serves its purpose well at 114 lines
2. Consider: Could "Epistemic Standards" move to a collaboration doc? Currently it's valuable at the entry point.

---

### `/framework/CLAUDE.md` (Framework Collaboration Contract)

**Purpose:** Detailed collaboration guidance for working within the framework

**Current Length:** 728 lines

**Content Breakdown:**

| Section | Lines | Category | Issues/Opportunities |
|---------|-------|----------|---------------------|
| Header & intro | 9 | Bootstrap-critical | ✅ Keep |
| Quick Start for AI | 7 | Bootstrap-critical | ✅ Keep |
| Project Overview | 10 | Reference | Could reference README.md |
| Architecture: Project Folders | 34 | Reference | **REDUCE:** Move detailed structure to docs, keep high-level |
| AI Reading Protocol | 68 | Bootstrap-critical | **REDUCE:** Decision tree is good, patterns section is verbose |
| AI Roles | 46 | Reference | ✅ Keep - important for role selection |
| AI Workflow Checkpoint Policy | 79 | Bootstrap-critical | **REDUCE:** Core rule is buried, detailed steps could be reference |
| Project Classification | 50 | Reference | **OUTDATED:** Note says "needs rework", references old 3 framework levels |
| Core Standards Summary | 93 | Reference | **REDUCE:** Detailed examples could move to collaboration docs |
| ADRs | 28 | Reference | ✅ Keep - concise decision tree format |
| Working with Claude | 24 | Reference | ✅ Keep - useful collaboration tips |
| Emergency Reference | 34 | Reference | ✅ Keep - valuable quick fixes |
| Claude Code Permissions | 17 | Reference | ✅ Keep - setup guidance |
| Framework Commands | 140 | Reference | **REDUCE:** Detailed command docs could be external |
| Related Documentation | 24 | Reference | ✅ Keep - navigation aid |

**Total Bootstrap-Critical Content:** ~163 lines (AI Reading Protocol + Checkpoint Policy)
**Total Reference Content:** ~565 lines

---

## Duplication Analysis

### Direct Duplication
**Finding:** ✅ **NONE** - The two files have distinct purposes and no overlapping content.

### Conceptual Overlap
Areas where similar concepts appear but at different levels:

| Concept | Root CLAUDE.md | Framework CLAUDE.md | Assessment |
|---------|---------------|-------------------|------------|
| Bootstrap block | ✅ Contains actual block | ⚠️ References it | ✅ Correct - root is canonical |
| Project structure | High-level folders | Detailed folder tree | ✅ Appropriate detail levels |
| Navigation | Repository routing | Framework docs routing | ✅ Different scopes |
| Workflow | Not covered | Full checkpoint policy | ✅ Correct separation |

**Finding:** ✅ **Overlap is intentional and appropriate** - different levels of abstraction for different audiences.

---

## Content Categorization

### Bootstrap-Critical Content (Must be read every session)

**Current state:**
- Bootstrap block (root): 10 lines ✅
- AI Reading Protocol: 68 lines ⚠️ (decision tree is good, patterns section verbose)
- Checkpoint Policy: 79 lines ❌ (too long, core rule buried)

**Proposed reduction:**
```
Current bootstrap-critical: ~157 lines
Target: ~50-60 lines (with aggressive focus on "must know to start")
```

**Bootstrap block (keep as-is):**
```markdown
> 1. Ask: "What kind of work are we doing today?"
> 2. Read: framework.yaml → check roles.default
> 3. On work item actions: Read policies.onTransition BEFORE acting
> 4. On file operations in project-hub/work/: Use git mv
> 5. Before writing code: State what you plan to do and wait for approval
```

**Checkpoint policy (distill to essence):**
```markdown
## The One Rule (Before Coding)

**Before writing code:** Read the work item completely, state your approach, and wait for approval.

This ensures:
- You understand the full context
- User controls the direction
- No surprises or wasted effort

[Full workflow details: workflow-guide.md#workflow-transitions]
```

### Reference Content (Look up when needed)

**Well-organized reference (keep):**
- AI Roles section - concise, scannable
- ADR decision tree - quick reference format
- Emergency Reference - quick fixes
- Framework Commands - ⚠️ could be external

**Verbose reference (candidates for reduction):**
- Architecture: Project Folders (34 lines) → Point to docs/PROJECT-STRUCTURE-STANDARD.md
- Core Standards Summary (93 lines) → Keep decision trees, remove detailed examples
- Framework Commands (140 lines) → Move to separate reference doc
- Project Classification (50 lines) → Remove outdated section

### Redundant Content (Remove or consolidate)

**Identified redundancies:**

1. **Term definitions** - Should reference GLOSSARY.md (FEAT-088):
   - "WIP Limit" defined inline → Reference glossary
   - "Kanban" explained → Reference glossary
   - "ADR" explained → Reference glossary
   - "Work Item" explained → Reference glossary

2. **Detailed structure** - Duplicates PROJECT-STRUCTURE-STANDARD.md:
   - 34-line folder tree → Link to structure doc instead

3. **Detailed examples** - Duplicates collaboration docs:
   - SQL injection example (12 lines) → security-policy.md has this
   - Fail-fast example (9 lines) → code-quality-standards.md has this
   - TDD explanation (10 lines) → testing-strategy.md has this

4. **Outdated sections:**
   - "Project Classification & Framework Selection" (50 lines) - Note says "needs rework"

**Estimated savings:** ~200-250 lines from removing redundancies

---

## Recommendations

### Priority 1: Leverage FEAT-088 Glossary

**Action:** Replace inline term definitions with glossary references

**Examples:**
```markdown
# Current (inline definition):
WIP Limit - A constraint on concurrent work items, enforced via .limit files

# Proposed (glossary reference):
WIP Limit - See [GLOSSARY.md](docs/ref/GLOSSARY.md#wip-limit)
```

**Affected terms:** WIP Limit, Kanban, ADR, Work Item, Checkpoint, Bootstrap Block, SsoT, DRY

**Estimated savings:** ~30-40 lines

### Priority 2: Distill Checkpoint Policy to Core Rule

**Current:** 79 lines with detailed 11-step workflow

**Proposed:** ~15-20 lines with core rule + reference to workflow-guide.md

```markdown
## AI Workflow Checkpoint Policy (ADR-001)

**The Core Rule:** Before writing code, read the work item completely, state your approach, and wait for approval.

**Why:** Ensures you have full context, user controls direction, and no work is wasted.

**The Three Checkpoints:**
1. **Step 4:** Present plan → Get approval before moving to doing/
2. **Step 7.5:** Review approach → Confirm before coding
3. **Step 8.5:** Review implementation → Approve before done/

**Full workflow:** See [workflow-guide.md#workflow-transitions](docs/collaboration/workflow-guide.md#workflow-transitions)
**Rationale:** See [ADR-001](project-hub/research/adr/001-ai-workflow-checkpoint-policy.md)
```

**Estimated savings:** ~60 lines

### Priority 3: Externalize Framework Commands

**Current:** 140 lines of detailed command documentation

**Proposed:** Create `/framework/docs/ref/framework-commands.md` and reference it

**In CLAUDE.md (reduced):**
```markdown
## Framework Commands (/fw-*)

Quick shortcuts for workflow operations:
- /fw-help - Command help
- /fw-move - Move work items with validation
- /fw-status - Project status summary
- /fw-wip - Check WIP limits
- /fw-backlog - Review backlog

**Full reference:** [framework-commands.md](docs/ref/framework-commands.md)
```

**Estimated savings:** ~120 lines

### Priority 4: Remove Outdated Content

**Action:** Delete "Project Classification & Framework Selection" section (50 lines)

**Reason:** Note indicates "needs rework" and references obsolete 3-level framework model

**Estimated savings:** ~50 lines

### Priority 5: Replace Detailed Examples with References

**Current examples to move:**
- SQL injection prevention (12 lines) → already in security-policy.md
- Fail-fast example (9 lines) → already in code-quality-standards.md
- TDD explanation (10 lines) → already in testing-strategy.md

**Proposed approach:** Keep decision trees and quick rules, remove verbose examples

**Estimated savings:** ~40-50 lines

### Priority 6: Streamline Folder Structure Section

**Current:** 34-line detailed ASCII tree

**Proposed:** High-level structure + reference to PROJECT-STRUCTURE-STANDARD.md

```markdown
## Architecture Quick Reference

**Key folders:**
- `docs/collaboration/` - Universal collaboration guides
- `templates/` - Copy-paste starting points (never edit templates)
- `project-hub/work/` - Kanban workflow (backlog → todo → doing → done)

**Full structure:** See [PROJECT-STRUCTURE-STANDARD.md](docs/PROJECT-STRUCTURE-STANDARD.md)
```

**Estimated savings:** ~20 lines

---

## Projected Impact

### Estimated Line Reductions

| Action | Current Lines | Proposed Lines | Savings |
|--------|--------------|----------------|---------|
| Glossary references | ~40 | ~10 | ~30 |
| Checkpoint policy distillation | 79 | ~20 | ~60 |
| Framework commands externalization | 140 | ~20 | ~120 |
| Remove outdated section | 50 | 0 | ~50 |
| Replace examples with references | ~50 | ~10 | ~40 |
| Streamline folder structure | 34 | ~15 | ~20 |
| **TOTAL** | **~393** | **~75** | **~320** |

### Post-Cleanup Projection

**Framework CLAUDE.md:**
- Current: 728 lines
- After cleanup: ~408 lines
- **Reduction: 44%**

**Bootstrap-critical content:**
- Current: ~157 lines
- After distillation: ~50-60 lines
- **Reduction: 62%**

**Benefits:**
- ✅ More focused, memorable guidance
- ✅ Reduced cognitive load for session start
- ✅ Leverages FEAT-088 Glossary as intended
- ✅ Better separation of quick-reference vs. detailed-reference
- ✅ Eliminates redundancy with collaboration docs

---

## Implementation Plan

### Phase 1: Create External References (No deletions yet)
1. ✅ Create `framework/docs/ref/framework-commands.md` with full command details
2. Update framework/INDEX.md to include new reference doc

### Phase 2: Leverage FEAT-088 Glossary
1. Replace term definitions with glossary references
2. Add "See GLOSSARY.md for terminology" note at top

### Phase 3: Streamline Checkpoint Policy
1. Distill 11-step workflow to core rule + 3 checkpoints
2. Add references to workflow-guide.md for full details

### Phase 4: Remove Redundancies
1. Delete outdated "Project Classification" section
2. Remove detailed code examples (keep in collaboration docs)
3. Streamline folder structure section

### Phase 5: Validation
1. Manual testing: Verify all links work
2. Verify bootstrap block still < 20 lines
3. Verify navigation is still clear
4. Test with sample session to ensure nothing is lost

---

## Risk Assessment

### Low Risk ✅
- Leveraging glossary - new resource, no content lost
- Externalizing commands - moves to discoverable location
- Removing outdated section - already flagged for removal

### Medium Risk ⚠️
- Distilling checkpoint policy - must preserve critical checkpoints
- Streamlining examples - must not lose decision-making guidance

### Mitigation
- Create external docs BEFORE removing content from CLAUDE.md
- Review each deletion with user before committing
- Keep full examples in collaboration docs (no content truly deleted)

---

## Success Criteria Validation

### Quantitative Targets

| Metric | Current | Target | After Cleanup | Status |
|--------|---------|--------|---------------|--------|
| /CLAUDE.md line count | 114 | < 100 | 114 (no changes) | ⚠️ Close |
| Bootstrap block lines | 10 | < 20 | 10 (no changes) | ✅ Met |
| framework/CLAUDE.md lines | 728 | (no target) | ~408 | ✅ 44% reduction |
| Bootstrap-critical lines | ~157 | ~50-60 | ~50-60 | ✅ On target |

### Qualitative Goals

- ✅ **No duplicated content** - Already met, will improve with glossary references
- ✅ **AI can navigate** - Root file navigation intact
- ✅ **Critical policies memorable** - Checkpoint policy will be more focused
- ✅ **Reference material discoverable** - Moving to external docs improves this

---

## Synergy with FEAT-088

**As designed:** The glossary enables cleanup by becoming the term authority.

**Terms to reference (instead of define inline):**
- Work Item
- WIP Limit
- Kanban
- Checkpoint
- Bootstrap Block
- ADR
- SsoT
- DRY
- POC/Spike
- Session History
- Transition

**Impact:** Cleaner, more maintainable guidance with single source of truth for terminology.

---

## Recommendations Summary

### Root CLAUDE.md
✅ **No changes recommended** - Already concise at 114 lines and serves its purpose well.

### Framework CLAUDE.md

**Immediate actions:**
1. Create framework-commands.md reference doc
2. Replace term definitions with glossary references
3. Distill checkpoint policy to core rule + checkpoints
4. Remove outdated "Project Classification" section
5. Streamline examples (keep decision trees, reference docs for details)

**Expected outcome:**
- More focused, memorable guidance
- 44% reduction in length (728 → ~408 lines)
- Better leverage of existing docs (glossary, collaboration guides)
- Clearer separation of bootstrap-critical vs. reference content

**Preservation:**
- All content preserved in appropriate locations (glossary, collaboration docs, external references)
- No loss of guidance or examples
- Improved discoverability through better organization

---

## Next Steps

**User Decision Points:**
1. Approve creation of framework-commands.md external reference
2. Approve distilled checkpoint policy format
3. Approve removal of outdated "Project Classification" section
4. Approve plan to leverage FEAT-088 Glossary for term references

**Implementation Sequence:**
1. Create new external docs (additive, no deletions)
2. Update framework/INDEX.md
3. Make CLAUDE.md changes with user approval at each phase
4. Verify all links and navigation
5. Update CHANGELOG.md

---

**Last Updated:** 2026-01-28
**Status:** Awaiting user review and approval

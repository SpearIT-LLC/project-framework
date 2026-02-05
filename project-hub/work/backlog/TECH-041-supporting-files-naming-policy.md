# Technical Debt: Document Supporting Files Naming Policy

**ID:** TECH-041
**Type:** Tech Debt
**Priority:** Medium
**Version Impact:** PATCH
**Created:** 2026-01-11
**Theme:** Workflow

---

## Summary

Document the policy for supporting files and sub-documents that share a parent work item ID. Clarify naming conventions, when to use them, and how they relate to the unique ID requirement.

---

## Problem Statement

**Current situation:**

The framework has a stated policy that work item IDs should be unique and sequential (workflow-guide.md:104-109), but actual practice shows complex work items often have multiple supporting documents sharing the same base ID:

**Examples found:**
- `FEAT-026-universal-structure-decisions.md` (main work item)
- `FEAT-026-collision-analysis.md` (supporting analysis)
- `FEAT-026-P1-BUG-framework-structure.md` (sub-task/bug)
- `FEAT-026-followup.md` (followup notes)
- 22 total FEAT-026 files in v3.0.0 release

- `FEAT-025-manual-setup-validation.md` (main)
- `FEAT-025-ALIGNMENT-ANALYSIS.md` (analysis)
- `FEAT-025-brainstorming.md` (planning)

**The gap:**

The official policy doesn't address:
1. Supporting documents for complex work items (analysis, brainstorming)
2. Sub-tasks or phased work within a parent work item
3. Naming conventions for these supporting files
4. When to create supporting files vs. new work items
5. How supporting files relate to the "unique ID" policy

**Who is affected?**

- Framework maintainers creating work items
- AI assistants (Claude) helping with work item creation
- Future contributors unfamiliar with implicit conventions

**Current workaround:**

Implicit naming patterns observed:
- `-ANALYSIS` suffix for analysis documents
- `-brainstorming` for planning/ideation
- `-P1-BUG-`, `-P2-TECH-` for prioritized sub-tasks
- `-followup` for post-completion notes
- `-MIGRATION-CHECKPOINT`, `-TEST-RESULTS` for process artifacts

---

## Solution

Document the official policy for supporting files and their naming conventions.

### Proposed Policy Elements

**1. Main Work Item Definition:**
- Each work item has ONE primary document: `TYPE-NNN-description.md`
- This is the source of truth for the work item
- Contains requirements, design, implementation checklist
- Location: `project-hub/work/{backlog,todo,doing,done}/`

**2. Supporting Files:**
- Complex work items MAY have supporting documents sharing the base ID
- Supporting files use suffixes to indicate their purpose
- All files with same base ID move together through workflow
- Supporting files are co-located with main work item

**3. Naming Convention:**

```
TYPE-NNN-description.md              # Main work item (REQUIRED)
TYPE-NNN-SUFFIX.md                   # Supporting file (OPTIONAL)
```

**Standard Suffixes:**

| Suffix | Purpose | When to Use |
|--------|---------|-------------|
| `-ANALYSIS` | Pre-implementation analysis | Complex problem requiring research before design |
| `-brainstorming` | Ideation and exploration | Multiple approaches considered |
| `-ALIGNMENT-ANALYSIS` | Scope/approach alignment | Clarifying scope or comparing approaches |
| `-followup` | Post-completion notes | Discovered issues or future improvements |
| `-CHECKPOINT` | Progress snapshot | Long-running work with milestones |
| `-TEST-RESULTS` | Testing artifacts | Significant testing phase |
| `-MIGRATION-*` | Migration artifacts | Data/structure migration details |
| `-Pn-TYPE-description` | Prioritized sub-task | Work item spawns child tasks (P1=high, P2=medium, etc.) |

**4. When to Create Supporting Files:**

**Use supporting files when:**
- Analysis needed before design can be finalized
- Multiple approaches require documentation/comparison
- Work item has distinct sub-tasks that should track together
- Process artifacts (test results, checkpoints) need preservation

**Create separate work items when:**
- Sub-work can be done independently
- Sub-work might be deferred or cancelled separately
- Sub-work has different version impact than parent
- Sub-work is discovered after parent completion

**5. Unique ID Policy Clarification:**

- Base work item ID (TYPE-NNN) must be unique
- Supporting files share the parent's base ID
- Count: One TYPE-NNN per project (not per file)
- Supporting files don't consume new ID numbers

**6. Workflow Movement:**

All files sharing a base ID move together:
```bash
# Move main + supporting files together
git mv project-hub/work/todo/FEAT-025* project-hub/work/doing/
```

---

## Implementation Approach

**Location:** Update `framework/docs/process/workflow-guide.md`

**Section to add:** "Supporting Files and Sub-Documents" (after ID Numbering section)

**Content structure:**
1. Overview of supporting files concept
2. Standard naming conventions (table)
3. When to use supporting files vs. new work items (decision tree)
4. Clarification of unique ID policy
5. Workflow movement examples
6. Examples from actual framework work items (FEAT-026, FEAT-025)

**Related updates:**
- TECH-044 may reference this for work item creation guidance
- CLAUDE.md may reference for AI work item creation

---

## Completion Criteria

- [ ] Supporting files policy documented in workflow-guide.md
- [ ] Standard suffix table provided with guidance
- [ ] Decision criteria documented (supporting file vs. new work item)
- [ ] Unique ID policy clarified to address supporting files
- [ ] Workflow movement examples provided
- [ ] Real examples referenced (FEAT-026, FEAT-025)
- [ ] Changes committed
- [ ] workflow-guide.md "Last Updated" date updated

---

## References

**Current policy:**
- [workflow-guide.md](../../docs/process/workflow-guide.md) - ID Numbering section (lines 104-109)

**Examples demonstrating current practice:**
- `project-hub/history/releases/v3.0.0/FEAT-026-*.md` - 22 supporting files
- `project-hub/work/todo/FEAT-025-*.md` - 3 files (main + analysis + brainstorming)
- `project-hub/history/releases/v2.2.0/FEAT-020-*.md` - Testing artifacts

**Related work items:**
- TECH-044 (Document Work Item Creation Policy) - May reference this
- TECH-028 (DRY Documentation Principles) - Applies to preventing duplicate policy statements

---

## Notes

**Discovery context:** Found during structure compliance review when checking for policy violations. Multiple FEAT-025 files appeared to violate unique ID policy, but actually represent established (undocumented) practice.

**Priority rationale:** Medium - not blocking current work, but needed for:
- Clarity for future contributors
- AI assistant guidance on work item creation
- Preventing confusion about "duplicate" IDs

**Implementation estimate:** 1-2 hours (straightforward documentation of existing practice)

---

**Last Updated:** 2026-01-11
**Status:** Backlog

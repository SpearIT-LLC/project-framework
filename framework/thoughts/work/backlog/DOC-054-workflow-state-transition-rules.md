# DOC-054: Document Workflow State Transition Rules

**ID:** 054
**Type:** Documentation
**Priority:** High
**Status:** Backlog
**Created:** 2026-01-13
**Related:** FEAT-037 (project-config.yaml), TECH-055 (work item move script), TECH-056 (workflow doc consolidation)

---

## Summary

Add explicit state transition rules to kanban-workflow.md to prevent invalid work item movements (e.g., backlog → doing, backlog → done). These rules will be enforceable by AI and provide clear validation logic.

**Context:** During DOC-053 work, AI violated workflow by moving item directly from backlog → done, bypassing todo and doing stages. Need explicit, enforceable rules to prevent this.

---

## Problem Statement

**Issue:** Current kanban-workflow.md documents how to move items between folders but doesn't explicitly forbid invalid transitions. AI can accidentally move items through invalid state transitions.

**Examples of invalid transitions:**
- backlog → doing (must go through todo first)
- backlog → done (must be worked on)
- todo → done (must be in doing first)
- done → doing (no reopening, create new item)

**Who is affected:**
- AI assistants (need clear rules to follow)
- Human contributors (need to understand valid workflow)
- Validation tooling (TECH-055 will use these rules)

**Current state:**
- Movement commands documented ✅
- `{TYPE-ID}-*` pattern documented ✅ (just added)
- Valid transitions NOT explicitly documented ❌
- Invalid transitions NOT explicitly forbidden ❌
- No validation mechanism ❌

---

## Requirements

### Functional Requirements

**Add to kanban-workflow.md:**
- [ ] Create "State Transition Rules (ENFORCED)" section
- [ ] Table showing all possible transitions with Valid/Invalid
- [ ] Reason for each invalid transition
- [ ] Pre-flight checklist for AI before moving items
- [ ] Validation steps (source matches status, target is valid, WIP limits)

**Content requirements:**
- [ ] Explicitly list all valid transitions (backlog→todo, todo→doing, etc.)
- [ ] Explicitly forbid invalid transitions (backlog→doing, backlog→done, etc.)
- [ ] Clear reasoning for why each transition is forbidden
- [ ] Examples of correct workflow paths
- [ ] What to do if invalid transition requested (explain valid path)
- [ ] Completion criteria validation rule (all checkboxes checked before doing→done)

### Non-Functional Requirements

- Clear table format (easy to scan)
- Strong language ("ENFORCED", "CRITICAL", "MUST")
- AI-friendly structure (explicit, no ambiguity)
- Reference from troubleshooting-guide.md

---

## Design

### Proposed Section Location

Add after "Moving Items Between Folders" section in kanban-workflow.md (around line 276)

### Proposed Content Structure

```markdown
## State Transition Rules (ENFORCED)

**Critical: AI must validate transitions before moving files**

### Valid Transitions

| From | To | Valid? | Reason |
|------|----|----|--------|
| backlog | todo | ✅ | Standard flow - committing to work |
| backlog | doing | ❌ | Must commit to work (todo) first |
| backlog | done | ❌ | Must be worked on |
| todo | doing | ✅ | Starting work |
| todo | backlog | ✅ | Deprioritizing |
| todo | done | ❌ | Must actually do the work (doing first) |
| doing | done | ✅ | Completing work |
| doing | todo | ✅ | Pausing work |
| doing | backlog | ❌ | Use todo as intermediate state |
| done | history | ✅ | Post-release archival |
| done | doing | ❌ | No reopening (create new work item) |
| done | todo | ❌ | No reopening (create new work item) |
| done | backlog | ❌ | No reopening (create new work item) |

### Workflow Paths

**Standard path (feature development):**
backlog → todo → doing → done → history

**Pause and resume:**
todo → doing → todo → doing → done

**Deprioritize:**
todo → backlog

**Invalid shortcuts:**
- ❌ backlog → doing (bypass todo)
- ❌ backlog → done (bypass work)
- ❌ todo → done (bypass doing)

### Before Moving a Work Item

AI must check these in order:

1. ✅ **Source folder exists** - Work item is actually in the source folder
2. ✅ **Status field matches** - Status in file matches folder location
3. ✅ **Transition is valid** - Check table above
4. ✅ **WIP limits respected** - Target folder has capacity
5. ✅ **All {TYPE-ID}-* files included** - Move complete work item
6. ✅ **Completion criteria met (doing→done only)** - All checkboxes in "Completion Criteria" section must be checked before moving to done/

**If any check fails:** Explain issue to user, suggest correct path

### Completion Criteria Validation (doing → done)

**CRITICAL:** Before moving a work item from `doing/` to `done/`:

1. Read the work item's "Completion Criteria" section
2. Verify ALL checkboxes are checked `[x]`
3. Items marked "Future" or "Out of Scope" do not block completion
4. If unchecked items exist, ask user before proceeding

**Gap discovered (2026-01-14):** AI moved FEAT-037 to done/ without verifying completion criteria. The "Future" section had unchecked items that were ambiguously scoped.

### Invalid Transition Requested

**User:** "Move FEAT-042 from backlog to doing"

**AI Response:**
"Invalid transition: backlog → doing. Work items must move through todo first.

Valid path:
1. Move FEAT-042 from backlog → todo (commit to working on it)
2. Move FEAT-042 from todo → doing (start work)

Would you like me to move it to todo first?"
```

---

## Implementation Approach

### Step 1: Draft Content
- Create section with transition rules table
- Add pre-flight checklist
- Add example invalid transition handling

### Step 2: Add to kanban-workflow.md
- Insert after "Moving Items Between Folders" section
- Update table of contents if exists
- Cross-reference from troubleshooting-guide.md

### Step 3: Validation
- Review with user
- Test clarity with AI (does it understand?)
- Ensure table is complete (all state pairs)

---

## Success Metrics

**How do we know this work is complete?**

1. ✅ State transition rules explicitly documented
2. ✅ Table shows all valid/invalid transitions
3. ✅ Pre-flight checklist for AI provided
4. ✅ Examples of handling invalid requests included
5. ✅ AI can reference and follow these rules
6. ✅ TECH-055 script can use these rules for validation

**Validation:**
- AI reads rules and correctly prevents invalid transitions
- Human can quickly scan table to understand workflow
- Rules are unambiguous and enforceable

---

## Dependencies

**Requires:**
- `{TYPE-ID}-*` pattern already documented ✓ (just added)
- kanban-workflow.md exists ✓

**Enables:**
- TECH-055 (validation script - uses these rules)
- FEAT-037 (project-config.yaml - can reference these rules)

**Related:**
- DOC-053 - Workflow violation that exposed this gap

---

## Notes

**Priority:** High
- Prevents workflow violations by AI
- Foundation for TECH-055 validation script
- Clarifies workflow for all contributors

**Why this matters:**
Explicit rules prevent AI from accidentally skipping workflow stages. Makes validation possible (both AI self-check and tooling).

**Implementation time:** ~30 minutes
- Draft content: 15 min
- Add to doc: 10 min
- Review: 5 min

---

**Last Updated:** 2026-01-13

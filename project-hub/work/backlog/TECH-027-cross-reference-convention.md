# TECH-027: Establish Cross-Reference Convention for Work Items

**ID:** TECH-027
**Type:** Tech Debt
**Priority:** Medium
**Version Impact:** PATCH
**Created:** 2026-01-07
**Theme:** Workflow

---

## Summary

Establish and document convention for cross-referencing work items in a file-based workflow where work items move through folders (backlog → todo → doing → done → releases/archive).

---

## Problem Statement

**Issue identified during:** FEAT-026 archive relocation (2026-01-07)

Work items frequently reference other work items, but file-based workflows have a limitation:
- Work items move through folders as they progress (backlog/, todo/, doing/, done/)
- Work items get archived to history/releases/ or history/archive/
- Relative path links break when files move
- Absolute paths don't exist in file-based systems

**Example of broken reference:**
```markdown
**See:** [FEAT-026-future-enhancements.md](../../backlog/FEAT-026-future-enhancements.md) #2
```
This link breaks when FEAT-026-future-enhancements moves from backlog/ to todo/.

---

## Solution

Establish **ID-only cross-reference convention** for work items.

### Work Item Cross-References

**Use:** Work item ID (filename without .md) only, no paths or links

**Format:**
- `FEAT-NNN` - Reference to entire work item
- `FEAT-NNN-description` - Full work item ID (more descriptive)
- `FEAT-NNN #2` - Reference to specific section within work item
- `FEAT-NNN (Brief context)` - ID with context note

**Examples:**
```markdown
## Dependencies

**Requires:**
- FEAT-025 (authentication refactor must be completed first)

**Blocks:**
- FEAT-028 (waiting on this API design)

**Related:**
- SPIKE-015 (explored alternative approach)
- BUGFIX-042 (similar issue in user service)
```

```markdown
**Status:** Cancelled
**Cancellation Reason:** Superseded by TECH-045-new-authentication-approach
**See also:** FEAT-026-future-enhancements #2 - DRY documentation principles
```

**Rationale:**
- ✅ Work item IDs are stable (we don't rename work items)
- ✅ Never breaks (no path to become invalid)
- ✅ Search-friendly (Ctrl+Shift+F finds all references)
- ✅ Simple and clean
- ✅ Works regardless of folder location

**Trade-off:**
- ❌ Not clickable in editors (acceptable for cross-references)

---

### Framework/Project Documentation Links

**Discussion point from user:**
"To be discussed is do we allow links to framework or project docs? My first thought is yes but they cannot be relative links."

**Proposed approach:**

For framework documentation (process/, patterns/, collaboration/, docs/):
- **Use absolute repository paths** from project root
- These files are stable and don't move through workflows

**Examples:**
```markdown
## References

- Process: See framework/docs/process/workflow-guide.md
- Pattern: See framework/docs/patterns/error-handling.md
- Collaboration: See framework/collaboration/ai-workflow.md
- ADR: See project-hub/research/adr/ADR-003.md
```

**Why absolute from repository root:**
- ✅ Framework docs are stable (don't move through folders)
- ✅ Works from any project in monorepo
- ✅ Clear what's being referenced
- ✅ Clickable in modern editors

**Alternative for user projects:**
- User projects would use paths relative to their project root
- Example: `docs/architecture/api-design.md` (not framework docs)

**To be decided:**
- Should we document this distinction?
- Should templates show examples of both?
- Should we clarify when to use work item IDs vs. doc paths?

---

## Implementation

### 1. Update Work Item Templates

Update all 4 work item templates:
- `framework/templates/work-items/FEATURE-TEMPLATE.md`
- `framework/templates/work-items/BUGFIX-TEMPLATE.md`
- `framework/templates/work-items/SPIKE-TEMPLATE.md`
- `framework/templates/work-items/BLOCKER-TEMPLATE.md`

**Add to Dependencies section:**
```markdown
## Dependencies

**Cross-Reference Convention:**
- Work items: Use ID only (e.g., FEAT-025, SPIKE-015)
- Framework docs: Use absolute path from repo root (e.g., framework/docs/process/workflow-guide.md)
- Rationale: Work items move through folders; IDs are stable. Framework docs are stable.

**Requires:**
- FEAT-NNN (description of dependency)

**Blocks:**
- FEAT-NNN (description of blocked item)

**Related:**
- FEAT-NNN (description of relationship)
```

**Update References section:**
```markdown
## References

- Work item references: FEAT-024, SPIKE-015 #3, BUGFIX-042
- Framework docs: framework/docs/process/workflow-guide.md
- External resources: [Title](https://example.com/url)

**Note:** Work item IDs are stable across folder moves. Use ID only (no path).
```

### 2. Document Convention

Add section to collaboration guide or process documentation:

**Location:** `framework/docs/collaboration/work-item-cross-references.md` (new file)

**Or add to existing:** `framework/docs/process/workflow-guide.md`

**Content:** Explain the convention, rationale, examples

### 3. Update Existing Work Items (Optional)

**Low priority:** Update existing work items to follow convention

**Can be done incrementally:**
- Fix broken links as encountered
- Update during work item edits
- Not urgent (search still works)

---

## Completion Criteria

- [ ] Convention documented in new or existing process doc
- [ ] All 4 work item templates updated with convention note
- [ ] Examples added to templates (Dependencies and References sections)
- [ ] Decision documented about framework/project doc linking (absolute paths)
- [ ] Changes committed

---

## Notes

**Discovered during:** FEAT-026 archive relocation
- First cancelled work item revealed link breakage issue
- Prompted discussion about stable references

**Philosophy:**
- Keep it simple - file-based workflow has constraints
- IDs over paths - IDs are stable, paths change
- Search is powerful - modern editors make ID lookup easy

**Future consideration:**
- Could create automation to validate cross-references
- Could generate cross-reference map/graph
- Not urgent - convention is sufficient for now

---

## References

- Work item FEAT-026-P2-TECH-doc-dedup (cancelled, first use case)
- Decision DECISION-017: Archive relocation (prompted this discussion)

---

**Last Updated:** 2026-01-07

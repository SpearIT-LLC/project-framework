# FEAT-026 Sub-Item: Reduce CLAUDE.md Workflow Duplication

**ID:** FEAT-026-P2-TECH-workflow-simplification
**Parent:** FEAT-026-structure-migration
**Type:** Technical Debt
**Priority:** P2 (Should fix before merge)
**Status:** Todo
**Created:** 2026-01-06

---

## Summary

Reduce excessive workflow detail duplication between CLAUDE.md and workflow-guide.md.

---

## Problem

**From followup line 36:**
"Is the workflow too detailed in CLAUDE.md? Is there too much duplication from the workflow-guide.md?"

CLAUDE.md contains detailed workflow information that duplicates content in dedicated workflow guides. This creates:
- Maintenance burden (update in multiple places)
- Risk of contradictions
- Longer CLAUDE.md file

---

## Current State

**framework/CLAUDE.md:**
- Contains detailed workflow steps (11 steps mentioned)
- Includes examples, process details
- Duplicates information from process guides

**framework/process/workflow-guide.md (if it exists):**
- Detailed workflow documentation
- Source-of-truth for process

---

## Strategy

**CLAUDE.md should contain:**
- High-level workflow overview
- Quick reference for AI context
- Links to detailed process docs
- Framework-specific guidance for AI assistants

**CLAUDE.md should NOT contain:**
- Step-by-step detailed procedures (link to process/ docs instead)
- Extensive examples (brief ones OK, link for more)
- Information that belongs in process documentation

**Process docs should contain:**
- Detailed step-by-step workflows
- Comprehensive examples
- Edge cases and troubleshooting

---

## Implementation

1. **Review** current CLAUDE.md workflow content
2. **Identify** what duplicates process documentation
3. **Reduce** CLAUDE.md to high-level overview
4. **Add links** from CLAUDE.md to detailed process docs
5. **Ensure** process docs are comprehensive
6. **Keep** AI-specific guidance in CLAUDE.md

**Example structure for CLAUDE.md:**
```markdown
## Workflow Overview

The framework follows this high-level workflow:
1. Research → 2. Define → 3. Plan → 4. Code → 5. Release

For detailed workflow documentation, see:
- [Workflow Guide](process/workflow-guide.md)
- [Work Item Management](process/kanban-workflow.md)

### AI-Specific Workflow Guidance
[AI-specific tips that don't belong in process docs]
```

---

## Completion Criteria

- [ ] CLAUDE.md workflow content reviewed
- [ ] Duplicated content identified
- [ ] CLAUDE.md reduced to overview + links
- [ ] Process docs verified as comprehensive
- [ ] AI-specific guidance retained in CLAUDE.md
- [ ] No loss of important information
- [ ] Changes committed

---

**Last Updated:** 2026-01-06
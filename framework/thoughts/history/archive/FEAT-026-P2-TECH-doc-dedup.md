# FEAT-026 Sub-Item: Clean Up Documentation Duplication

**ID:** FEAT-026-P2-TECH-doc-dedup
**Parent:** FEAT-026-structure-migration
**Type:** Technical Debt
**Priority:** P2 (Should fix before merge)
**Status:** Cancelled
**Created:** 2026-01-06
**Cancelled:** 2026-01-07
**Cancellation Reason:** Superseded by future work item TECH-NNN-dry-docs-principle
**See:** [FEAT-026-future-enhancements.md](../../backlog/FEAT-026-future-enhancements.md) #2 - Document DRY Principles for Documentation

---

## Summary

Clean up documentation duplication and contradictions across repository.

---

## Problem

**From followup line 9:**
"I'm seeing a lot of repetition in the documentation and sometimes it contradicts itself."

Duplication issues:
- Same information repeated in multiple files
- When one file is updated, others become stale
- Contradictions between files
- Violates DRY principle

---

## Known Examples

**From followup:**
- Line 36: "Is the workflow too detailed in CLAUDE.md? Is there too much duplication from the workflow-guide.md?"
- Line 45: "We reference The 9 Steps, but CLAUDE references 11. This is another case of duplication."
- Line 46: "I think this is repeated info" (in CLAUDE-QUICK-REFERENCE.md line 129)

---

## Investigation Needed

1. **Identify all duplicated content**
   - Workflow descriptions
   - Step counts (9 vs 11)
   - Framework structure explanations
   - Template instructions

2. **Find contradictions**
   - Version numbers
   - Process descriptions
   - Status claims

3. **Map source-of-truth** for each topic

---

## Strategy

**DRY Principle:**
1. **Each topic has ONE source-of-truth**
2. **Other files reference/link** to that source
3. **Brief summaries OK** with link to detailed version

**Example:**
- Detailed workflow: framework/process/workflow-guide.md (source of truth)
- CLAUDE.md: Brief overview + link to workflow-guide.md
- QUICK-START.md: Quick reference + link to workflow-guide.md

---

## Implementation

1. **Audit** all documentation files
2. **Identify** duplicated content
3. **Designate** source-of-truth for each topic
4. **Reduce** other instances to summaries + links
5. **Document** in INDEX.md what the source-of-truth is for each topic

---

## Completion Criteria

- [ ] All documentation files audited
- [ ] Duplications identified and cataloged
- [ ] Source-of-truth designated for each topic
- [ ] Excessive duplication removed
- [ ] Contradictions resolved
- [ ] Links added to source-of-truth
- [ ] Changes committed

---

**Last Updated:** 2026-01-06
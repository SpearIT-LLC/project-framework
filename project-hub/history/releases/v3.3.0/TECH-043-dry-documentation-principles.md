# Technical: Document DRY Principles for Documentation

**ID:** 043
**Type:** Technical Debt / Process Improvement
**Priority:** High
**Status:** In Progress
**Created:** 2026-01-08
**Related:** FEAT-026
**Blocks:** FEAT-031, TECH-036

---

## Summary

Establish and document DRY (Don't Repeat Yourself) principles for framework documentation to prevent contradictions and reduce maintenance burden.

**Scope:** This work item focuses on documenting the policy and principles only. Implementation (INDEX.md registry and documentation refactoring) are separate work items.

---

## Problem Statement

**Issue identified during:** FEAT-026 implementation

Currently, the framework lacks explicit guidelines about information duplication in documentation:
- Multiple documents may contain similar or overlapping information
- No clear guidance on what constitutes the "source of truth" for a topic
- Risk of contradictions when information is updated in one place but not others
- Increased maintenance burden from duplicated content

**Who is affected?**
- Framework maintainers (developers working on documentation)
- Users who may encounter contradictory information

**Current workaround:**
- Ad-hoc decisions about where to document information
- Manual checking for duplicates during updates

---

## Solution

Document DRY principles for framework documentation with clear guidelines.

### Core Principles

1. **Single Source of Truth:** Every policy, process, or concept should have ONE authoritative document
2. **Reference, Don't Duplicate:** Other documents can reference the source but should not duplicate the information
3. **Acceptable Duplication:** Brief summaries or context are OK if they link to the authoritative source
4. **Clear Attribution:** When referencing, always link to the source of truth

### Implementation Approach

**Create new documentation file:**
- Location: `framework/collaboration/documentation-dry-principles.md` or
- Alternative: Add section to existing `framework/process/` documentation

**Content should include:**
- Explanation of DRY principle applied to documentation
- Guidelines for identifying source-of-truth documents
- Examples of good vs. bad duplication
- Process for updating information (update source, verify references)
- How to handle cross-cutting concerns
- **Session history location:** Define `thoughts/history/sessions/` as single source of truth for session history file location specification

**Note on INDEX.md:**
- INDEX.md registry will be implemented in FEAT-031 (separate work item)
- Documentation refactoring will be handled in TECH-036 (separate work item)
- This work item focuses on establishing the principles that guide those implementations

---

## Completion Criteria

- [x] DRY documentation principles documented in appropriate location
- [x] Examples provided (good reference vs. problematic duplication)
- [x] Guidelines added for maintainers on where to document new information
- [x] Process documented for updating information across multiple references
- [x] Reference to FEAT-031 (INDEX.md registry) included
- [x] Reference to TECH-036 (documentation refactoring) included
- [x] Changes committed

**Out of Scope (separate work items):**
- Implementing INDEX.md registry (FEAT-031)
- Auditing existing documentation for duplication (TECH-036)
- Refactoring duplicated content (TECH-036)

---

## Implementation Checklist

- [x] Create or update documentation file
- [x] Add DRY principles explanation
- [x] Provide concrete examples
- [x] Document process for updates
- [x] Note relationship to FEAT-031 and TECH-036
- [x] Verify no contradictions with existing docs

---

## References

- Blocks: FEAT-031 (INDEX.md as source-of-truth registry - implements tooling)
- Blocks: TECH-036 (documentation refactoring - applies policy to existing docs)
- Source: framework/thoughts/research/backlog-ideas-from-feat-026.md (Item #2)
- Origin: FEAT-026-followup.md line 39

## Workflow

**Sequence:** TECH-043 → FEAT-031 → TECH-036

1. **TECH-043 (this item):** Establish DRY policy and principles
2. **FEAT-031:** Implement INDEX.md registry to track source-of-truth
3. **TECH-036:** Audit and refactor existing documentation to follow policy

---

**Last Updated:** 2026-01-14

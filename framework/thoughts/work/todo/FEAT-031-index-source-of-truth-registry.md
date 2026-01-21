# FEAT-031: INDEX.md as Source-of-Truth Registry

**ID:** FEAT-031
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-01-08

---

## Summary

Enhance INDEX.md to explicitly track which file is the authoritative source-of-truth for each major topic in the framework, providing tooling to support DRY documentation principles established in TECH-043.

**Scope:** This work item implements the INDEX.md registry mechanism. Policy is established in TECH-043, and refactoring existing docs happens in TECH-036.

---

## Problem Statement

**Issue identified during:** FEAT-026 implementation and DRY documentation discussions

Current INDEX.md lists files but doesn't explicitly identify:
- Which document is the authoritative source for a topic
- Which documents are references/summaries vs. primary sources
- Where to update information when changes are needed

**This creates problems:**
- Unclear where to document new information
- Risk of updating wrong document or missing updates
- Difficulty maintaining DRY principles
- No clear ownership of topics

**Who is affected?**
- Framework maintainers (where to update documentation)
- Contributors (where to add new information)
- Users searching for authoritative information

**Current workaround:**
- Ad-hoc decisions about source documents
- Manual searching for related documentation

---

## Requirements

### Functional Requirements

- [ ] Enhance INDEX.md to track source-of-truth for major topics
- [ ] Use consistent format for marking authoritative sources
- [ ] Include references to related/summary documents
- [ ] Make it easy to find where to update information
- [ ] Keep INDEX.md maintainable (not overly complex)

### Non-Functional Requirements

- [ ] Readability: Format should be scannable and clear
- [ ] Maintainability: Easy to update as docs evolve
- [ ] Compatibility: Works with existing INDEX.md structure
- [ ] Documentation: Clear explanation of the registry concept

---

## Design

### Proposed Format

Add "source-of-truth" metadata to INDEX.md entries:

```markdown
## Topic: Workflow Process

**Source of Truth:** framework/process/workflow-guide.md
**References:**
- CLAUDE.md (overview and quick reference)
- QUICK-START.md (condensed guide)
- framework/collaboration/ai-workflow.md (AI-specific details)

**Description:** Complete workflow documentation from backlog to release.

---

## Topic: Work Item Structure

**Source of Truth:** framework/templates/work-items/FEATURE-TEMPLATE.md
**References:**
- TECH-027 (cross-reference conventions)
- workflow-guide.md (work item lifecycle)

**Description:** Authoritative structure and format for work items.

---

## Topic: DRY Documentation

**Source of Truth:** TECH-043 (when implemented)
**References:**
- This INDEX.md (tracking source-of-truth)

**Description:** Principles for avoiding documentation duplication.
```

### Alternative: Add Metadata to Existing Sections

Instead of separate "Topic" sections, enhance existing INDEX.md structure:

```markdown
### Process Documentation (framework/process/)

- **workflow-guide.md** - [SOURCE OF TRUTH] Complete workflow steps
  - Referenced by: CLAUDE.md, QUICK-START.md
- **release-process.md** - [SOURCE OF TRUTH] Release procedures
  - Referenced by: FEAT-028 automation
```

---

## Implementation Approach

### Phase 1: Add Registry Concept

1. Add explanation section at top of INDEX.md:
   ```markdown
   ## About This Index

   This index tracks framework documentation and identifies the authoritative
   source-of-truth for each topic. When updating information:
   - Update the SOURCE OF TRUTH document first
   - Then update any references to maintain consistency
   - See TECH-043 for DRY documentation principles
   ```

2. Add [SOURCE OF TRUTH] tags to key documents

### Phase 2: Enhance with References

3. Add "Referenced by" information to source documents
4. Document reference relationships

### Phase 3: Maintain

5. Update INDEX.md when adding new documentation
6. Review periodically for accuracy

---

## Files to Update

- [ ] framework/INDEX.md - Add registry concept and metadata
- [ ] TECH-043 - Link to INDEX.md as registry
- [ ] CLAUDE.md - Reference INDEX.md for source-of-truth lookup

---

## Completion Criteria

- [ ] INDEX.md includes explanation of source-of-truth concept
- [ ] Major topics have identified authoritative sources
- [ ] Format is consistent and maintainable
- [ ] Documentation updated (TECH-043, CLAUDE.md)
- [ ] Examples provided for future additions

---

## Alternatives Considered

**Option 1: Separate SOURCE-OF-TRUTH.md file**
- Pros: Dedicated registry, doesn't clutter INDEX.md
- Cons: Adds another file to maintain, splits related info
- Decision: Enhance INDEX.md (already central documentation registry)

**Option 2: Add metadata to each doc file**
- Pros: Information lives with the document
- Cons: Harder to get overview, more maintenance
- Decision: Central registry (INDEX.md) provides better overview

**Option 3: Do nothing (rely on intuition)**
- Pros: No work required
- Cons: Doesn't solve the problem, continues confusion
- Decision: Explicit registry worth the effort

---

## Success Metrics

- Reduced time finding where to update information
- Fewer documentation contradictions
- Clearer guidelines for contributors
- Better adherence to DRY principles

---

## References

- Requires: TECH-043 (DRY documentation principles - establishes policy)
- Blocks: TECH-036 (documentation refactoring - needs registry first)
- Source: framework/thoughts/research/backlog-ideas-from-feat-026.md (Item #3)
- Origin: FEAT-026-followup.md line 11
- Example format included in backlog-ideas-from-feat-026.md lines 77-82

## Workflow

**Sequence:** TECH-043 → FEAT-031 (this item) → TECH-036

1. **TECH-043:** Establish DRY policy and principles (prerequisite)
2. **FEAT-031 (this item):** Implement INDEX.md registry to track source-of-truth
3. **TECH-036:** Apply policy by auditing and refactoring existing documentation

---

## Notes

**Design philosophy:**
- Keep simple - perfect is enemy of good
- Focus on major topics first
- Can expand over time as needed
- Should help, not burden, maintainers

**Relationship to TECH-043:**
- TECH-043 establishes DRY principles
- FEAT-031 provides tooling (INDEX.md registry) to support those principles
- These complement each other

---

**Last Updated:** 2026-01-08

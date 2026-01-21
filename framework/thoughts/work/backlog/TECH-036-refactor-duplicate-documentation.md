# TECH-036: Audit and Refactor Duplicate Documentation

**ID:** TECH-036
**Type:** Tech Debt
**Priority:** Medium
**Version Impact:** PATCH
**Created:** 2026-01-08

---

## Summary

Audit existing framework documentation for duplicated content and refactor to follow DRY principles established in TECH-043, using the INDEX.md registry from FEAT-031.

**Scope:** This work item focuses on applying the DRY policy to existing documentation. Policy is in TECH-043, tooling is in FEAT-031.

---

## Problem Statement

**Issue identified during:** TECH-043 and FEAT-031 planning

Once DRY principles are documented (TECH-043) and the INDEX.md registry is implemented (FEAT-031), we need to apply those principles to existing framework documentation:
- Audit existing docs for duplicated information
- Identify source-of-truth for each duplicated topic
- Refactor duplicates to reference the source instead
- Update INDEX.md registry with findings

**Who is affected?**
- Framework maintainers (cleaner, DRY documentation)
- Users (consistent, non-contradictory information)
- Contributors (clear where to update information)

**Current state:**
- Some documentation duplication exists
- No systematic audit has been performed
- Unknown scope until investigation

---

## Requirements

### Functional Requirements

- [ ] Audit all framework documentation for duplicated content
- [ ] Identify source-of-truth document for each duplicated topic
- [ ] Refactor duplicates to reference source (not duplicate content)
- [ ] Update INDEX.md registry with source-of-truth mappings
- [ ] Verify no contradictions remain
- [ ] Maintain all necessary information (nothing lost)

### Non-Functional Requirements

- [ ] Preserve: Information remains accessible
- [ ] Improve: Reduced duplication, clearer structure
- [ ] Document: Changes tracked in work item or commit messages
- [ ] Validate: Review by maintainer before completion

---

## Implementation Approach

### Phase 1: Audit (Discovery)

**Goal:** Identify duplicated content across framework documentation

**Process:**
1. Read all documentation files in:
   - framework/process/
   - framework/collaboration/
   - framework/patterns/
   - framework/docs/
   - Root files (README.md, CLAUDE.md, QUICK-START.md, etc.)

2. Document findings:
   - Topic/concept duplicated
   - Files containing duplication
   - Proposed source-of-truth
   - Proposed refactoring approach

**Output:** Audit report (can be added to this work item)

---

### Phase 2: Prioritize

**Goal:** Decide which duplications to address first

**Criteria:**
- High risk of contradiction (information that changes)
- Frequently referenced topics
- Large duplications (most maintenance burden)

**Output:** Prioritized list of refactorings

---

### Phase 3: Refactor

**Goal:** Apply DRY principles to duplicated content

**For each duplication:**
1. Confirm source-of-truth document (may need to designate one)
2. Update source document if needed (ensure complete, accurate)
3. Replace duplicates with references to source
4. Update INDEX.md with source-of-truth mapping
5. Test/verify: All information still accessible

**Pattern for references:**
```markdown
## Topic Name

Brief summary (1-2 sentences).

**See:** [Detailed Guide](path/to/source-of-truth.md) for complete information.
```

---

### Phase 4: Verify

**Goal:** Ensure refactoring maintains quality

**Checks:**
- [ ] All information still accessible
- [ ] No contradictions remain
- [ ] References are clear and helpful
- [ ] INDEX.md accurately reflects sources
- [ ] Documentation follows TECH-043 principles

---

## Known Candidates for Review

**To be identified during audit, but potential areas include:**

1. **Workflow documentation**
   - Appears in: CLAUDE.md, QUICK-START.md, workflow-guide.md
   - Candidate source: workflow-guide.md

2. **Work item structure**
   - Appears in: Templates, workflow-guide.md, possibly CLAUDE.md
   - Candidate source: FEATURE-TEMPLATE.md (with workflow-guide.md for lifecycle)

3. **Framework purpose/overview**
   - Appears in: Root README.md, framework/README.md, possibly others
   - Candidate source: Root README.md (with framework/README.md for details)

4. **Collaboration guidelines**
   - Appears in: CLAUDE.md, collaboration/ files
   - Candidate source: collaboration/ files (CLAUDE.md references)

**Note:** These are preliminary. Actual audit may reveal different patterns.

---

## Completion Criteria

- [ ] Audit completed (all documentation reviewed)
- [ ] Findings documented (duplications identified)
- [ ] Refactoring completed for prioritized items
- [ ] INDEX.md updated with source-of-truth mappings
- [ ] No information lost (all content still accessible)
- [ ] No contradictions remain
- [ ] Changes committed with clear descriptions
- [ ] TECH-043 principles followed throughout

---

## Out of Scope

- Creating new documentation (focus on refactoring existing)
- Large-scale restructuring (keep file organization as-is)
- Style/formatting changes (unless needed for clarity)
- Content updates beyond resolving duplication

---

## Dependencies

**Prerequisites:**
- TECH-043 (DRY principles documented)
- FEAT-031 (INDEX.md registry implemented)

**Relationship:**
- This work item APPLIES the policy from TECH-043
- This work item USES the tooling from FEAT-031
- Cannot start until both prerequisites are complete

---

## Success Metrics

- Measurable reduction in duplicated content
- Clear source-of-truth for major topics (tracked in INDEX.md)
- No contradictory information found during review
- Maintainer can easily find where to update information

---

## References

- Requires: TECH-043 (DRY documentation principles)
- Requires: FEAT-031 (INDEX.md source-of-truth registry)
- Related: framework/thoughts/research/backlog-ideas-from-feat-026.md (Item #2, #3)

---

## Workflow

**Sequence:** TECH-043 → FEAT-031 → TECH-036 (this item)

1. **TECH-043:** Establish DRY policy and principles (prerequisite)
2. **FEAT-031:** Implement INDEX.md registry to track source-of-truth (prerequisite)
3. **TECH-036 (this item):** Audit and refactor existing documentation to follow policy

---

## Notes

**Approach:**
- Start with audit - don't assume we know all duplications
- Be pragmatic - some duplication may be acceptable (brief summaries)
- Follow TECH-043 principles for what's acceptable
- Use INDEX.md (FEAT-031) to track decisions

**Timing:**
- Can start audit during TECH-043/FEAT-031 work (research)
- Should not refactor until TECH-043 principles are documented
- Should not finalize until INDEX.md registry exists (FEAT-031)

**Scope management:**
- This could be a large task depending on audit findings
- Consider breaking into sub-tasks if audit reveals significant work
- Focus on high-value duplications first

---

**Last Updated:** 2026-01-08

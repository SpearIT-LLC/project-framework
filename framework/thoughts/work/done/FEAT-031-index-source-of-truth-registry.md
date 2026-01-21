# FEAT-031: Source-of-Truth Topic Registry

**ID:** FEAT-031
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-01-08

---

## Summary

Create a machine-readable source-of-truth registry for framework topics, with tooling to support human discoverability. Originally scoped for INDEX.md, but implemented in `framework.yaml` after analysis showed this was a better fit.

**Implemented Solution:**
- `framework.yaml` sources section = Machine-readable registry (source of truth)
- `Get-FrameworkIndex.ps1` = Human-friendly output generator
- `/fw-index` = AI command for topic lookup

**Scope:** This work item implements the registry mechanism. Policy is established in TECH-043, and refactoring existing docs happens in TECH-036.

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

- [x] Track source-of-truth for major topics
- [x] Use consistent format for marking authoritative sources
- [x] Include anchor links to specific sections
- [x] Make it easy to find where to update information
- [x] Keep registry maintainable

### Non-Functional Requirements

- [x] Machine-readable: YAML format in framework.yaml
- [x] Human-readable: PowerShell script generates formatted output
- [x] AI-accessible: /fw-index command for topic lookup
- [x] Maintainability: Single source of truth (framework.yaml)

---

## Design

### Implemented Solution: framework.yaml sources section

After analyzing options (see FEAT-031-topic-inventory.md), we chose to implement the registry in `framework.yaml` rather than INDEX.md:

```yaml
# framework.yaml sources section (excerpt)
sources:
  # Workflow & Process
  workflow-process: framework/docs/collaboration/workflow-guide.md#development-workflow-phases
  workflow-transitions: framework/docs/collaboration/workflow-guide.md#workflow-transitions

  # Standards & Policies
  code-quality: framework/docs/collaboration/code-quality-standards.md
  testing: framework/docs/collaboration/testing-strategy.md
  security: framework/docs/collaboration/security-policy.md

  # AI Collaboration
  ai-reading-protocol: framework/CLAUDE.md#ai-reading-protocol
  ai-roles: framework/docs/ref/framework-roles.yaml
  ...
```

### Why framework.yaml over INDEX.md?

| Criteria | framework.yaml | INDEX.md |
|----------|----------------|----------|
| Machine-readable | Yes (YAML) | No (Markdown) |
| AI can parse | Trivial | Regex needed |
| Extends existing pattern | Yes (policies: section) | Yes |
| Human-discoverable | Via script/command | Direct |

**Decision:** Use framework.yaml as source of truth, generate human output on demand via tooling. This keeps the registry always current with no drift between machine and human views.

---

## Implementation

### Completed Work

1. **Topic Inventory** (FEAT-031-topic-inventory.md)
   - Cataloged 26 major topics
   - Identified 12 unique authoritative source files
   - Added anchor links for precise navigation
   - Analyzed duplication (none problematic)

2. **framework.yaml sources section**
   - Added comprehensive sources section with all topics
   - Includes anchor links to specific sections
   - Grouped by category (workflow, standards, AI, structure, patterns)

3. **Get-FrameworkIndex.ps1**
   - Human-friendly output generator
   - Supports filtering by topic pattern
   - JSON output for tooling integration
   - Groups topics by category in table view

4. **/fw-index command**
   - AI command for topic lookup
   - Calls Get-FrameworkIndex.ps1
   - Examples: `/fw-index`, `/fw-index workflow*`, `/fw-index security`

---

## Files Created/Updated

- [x] `framework.yaml` - Added sources section (source of truth)
- [x] `framework/tools/Get-FrameworkIndex.ps1` - Human-friendly output script
- [x] `.claude/commands/fw-index.md` - AI command definition
- [x] `framework/thoughts/work/doing/FEAT-031-topic-inventory.md` - Working research file

---

## Completion Criteria

- [x] Major topics have identified authoritative sources (26 topics cataloged)
- [x] Format is consistent and maintainable (YAML in framework.yaml)
- [x] Machine-readable for AI/tooling (YAML format)
- [x] Human-readable output available (Get-FrameworkIndex.ps1)
- [x] AI command available (/fw-index)
- [ ] Test script runs successfully
- [ ] Changes committed

---

## Alternatives Considered

**Option A: Expand framework.yaml** (CHOSEN)
- Pros: Machine-readable, extends existing pattern, single config file
- Cons: Less discoverable for humans (solved with script)
- Decision: Best fit for AI-first workflow

**Option B: Enhance INDEX.md**
- Pros: Human-readable, visible in navigation
- Cons: Requires regex to parse, manual maintenance
- Decision: Not chosen - doesn't fit machine-readable need

**Option C: Hybrid (both files)**
- Pros: Best of both worlds
- Cons: Two files to maintain, risk of drift
- Decision: Not chosen - unnecessary complexity

**Option D: Close as not needed**
- Pros: No work required
- Cons: Misses opportunity to make sources explicit
- Decision: Not chosen - registry provides clear value

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

**Last Updated:** 2026-01-21

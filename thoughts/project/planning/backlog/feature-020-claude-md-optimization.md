# Feature: CLAUDE.md Optimization for Scalability

**ID:** FEAT-020
**Type:** Feature (Documentation Architecture)
**Version Impact:** MINOR (improves existing capability)
**Target Version:** v2.2.0
**Status:** Backlog
**Created:** 2025-12-20
**Completed:** N/A
**Developer:** TBD

---

## Summary

Restructure CLAUDE.md to use hierarchical documentation pattern, reducing size from 654 lines (5.1k tokens) to ~400-500 lines while maintaining effectiveness through strategic use of supporting documents and AI reading protocols.

---

## Problem Statement

**What problem does this solve?**

As framework matures, CLAUDE.md is growing:
- **Current:** 654 lines, 5.1k tokens (2.5% of context)
- **Context usage:** 178k / 200k (89%) - approaching limit
- **Growth trajectory:** Will continue expanding as we add guidance

**Specific issues:**
1. **Information density:** AI must parse entire file to find relevant guidance
2. **Maintainability:** Updates require editing large monolithic file
3. **Redundancy:** Detailed explanations duplicate content in other framework docs
4. **Scalability:** Can't continue adding guidance without hitting limits
5. **Cognitive load:** Hard to find specific guidance in 654 lines

**Who is affected?**

- AI assistants parsing CLAUDE.md (slower comprehension)
- Framework maintainers (harder to update)
- Users adopting framework (CLAUDE.md is a template)
- Future features (limited space for new guidance)

**Current workaround (if any):**

None - just accepting that CLAUDE.md is large and growing

---

## Requirements

### Functional Requirements

**Core Structure:**
- [ ] Reduce CLAUDE.md to 400-500 lines (target: 3-3.5k tokens)
- [ ] Maintain all critical guidance (AI Workflow Policy, Release Process)
- [ ] Create CLAUDE-QUICK-REFERENCE.md (<200 lines, critical checklists)
- [ ] Create supporting documentation in thoughts/project/reference/ai-collaboration/
- [ ] Implement "AI Reading Protocol" section
- [ ] All cross-references must be working markdown links

**Content Migration:**
- [ ] Keep actionable checklists in CLAUDE.md
- [ ] Move explanatory content to supporting docs
- [ ] Keep critical rules ("NEVER", "ALWAYS")
- [ ] Move examples and use cases to guides
- [ ] Keep emergency troubleshooting summary
- [ ] Move detailed troubleshooting to guide

**AI Reading Protocol:**
- [ ] Document when AI should read supporting docs
- [ ] Provide decision tree: "If you need X, read Y"
- [ ] Include proactive reading patterns
- [ ] Reference Grep/Read tools for finding info

### Non-Functional Requirements

- [ ] Performance: CLAUDE.md loads and parses faster (measurable via context usage)
- [ ] Security: N/A (documentation)
- [ ] Compatibility: Works with existing framework structure
- [ ] Documentation: Update INDEX.md, STRUCTURE.md
- [ ] Maintainability: Easier to update individual guides than monolithic file

---

## Design

### Proposed Structure

#### New File Organization

```
ProjectRoot/
├── CLAUDE.md                        # 400-500 lines (restructured)
├── CLAUDE-QUICK-REFERENCE.md        # <200 lines (new)
└── thoughts/
    └── project/
        └── reference/
            └── ai-collaboration/    # New folder
                ├── README.md        # Index of AI collaboration docs
                ├── workflow-deep-dive.md
                ├── architecture-deep-dive.md
                ├── code-quality-standards.md
                ├── testing-strategy.md
                ├── security-policy.md
                └── troubleshooting-guide.md
```

#### CLAUDE.md Restructured (500 lines target)

```markdown
# CLAUDE.md (Restructured)

## Quick Start (50 lines)
- Read this first!
- Critical rules summary
- Link to CLAUDE-QUICK-REFERENCE.md
- Link to ai-collaboration/ index

## Project Overview (50 lines)
- What this project is
- Key folders and files
- Architecture at high level
**Deep Dive:** [architecture-deep-dive.md](...)

## AI Collaboration Guidelines (200 lines) ⭐ KEEP
### AI Workflow Checkpoint Policy
[Current 9-step process - keep verbatim]

### Release Process
[Current step 9 detailed - keep verbatim]

### AI Reading Protocol (NEW)
[When to read what - decision tree]

## Code Quality (75 lines)
- Critical coding standards (summary)
- Testing principles (summary)
- Security rules (critical only)
**Full Details:** [code-quality-standards.md](...)

## Documentation Standards (50 lines)
- Single Source of Truth (PROJECT-STATUS.md)
- "Last Updated" policy
- Core documentation files
**Full Details:** [documentation-standards.md](...)

## Workflow & Planning (50 lines)
- Research → Define → Plan → Code → Release (keep)
- Kanban workflow summary
- ADR when to create (keep decision tree)
**Full Details:** [workflow-deep-dive.md](...)

## Emergency Reference (25 lines)
- System not working? Quick checks
- Common errors and immediate fixes
**Full Details:** [troubleshooting-guide.md](...)
```

#### CLAUDE-QUICK-REFERENCE.md (200 lines target)

```markdown
# CLAUDE.md Quick Reference

## AI Workflow Checkpoint Policy (9 steps)
[Exact copy from CLAUDE.md]

## Release Process Checklist
[Exact copy from CLAUDE.md step 9]

## Critical Rules
- NEVER: [List of nevers]
- ALWAYS: [List of always]

## Quick Decision Trees
- Creating ADR? [Decision tree]
- Release ready? [Checklist]
- Need approval? [When to ask]

## Emergency Fixes
[Top 5 common issues and 1-line fixes]
```

#### Supporting Documentation

**thoughts/project/reference/ai-collaboration/README.md:**
```markdown
# AI Collaboration Documentation

Index of detailed AI collaboration guides.

## Quick Access
- **Need workflow details?** → [workflow-deep-dive.md](workflow-deep-dive.md)
- **Need architecture context?** → [architecture-deep-dive.md](architecture-deep-dive.md)
- **Need coding standards?** → [code-quality-standards.md](code-quality-standards.md)
- **Need testing guidance?** → [testing-strategy.md](testing-strategy.md)
- **Need security rules?** → [security-policy.md](security-policy.md)
- **System not working?** → [troubleshooting-guide.md](troubleshooting-guide.md)

## Reading Protocol
See CLAUDE.md "AI Reading Protocol" section for when to read what.
```

### Content Migration Plan

**From CLAUDE.md → workflow-deep-dive.md:**
- Research Phase Guidelines (detailed explanations)
- Planning Guidelines (detailed)
- Architecture Decision Records (full explanation)
- Collaboration & Workflow (git details)
- Examples and use cases

**From CLAUDE.md → code-quality-standards.md:**
- Clean Code Guidelines (detailed examples)
- Function size rationale
- DRY principle examples
- Comment philosophy

**From CLAUDE.md → security-policy.md:**
- Input validation (detailed rules)
- Authentication (detailed implementation)
- Database safety (detailed examples)
- XSS & CSRF (detailed prevention)
- Dependency management (detailed)

**From CLAUDE.md → testing-strategy.md:**
- Testing Instructions (detailed)
- TDD mindset (with examples)
- Coverage targets (detailed)
- Edge case examples

**From CLAUDE.md → troubleshooting-guide.md:**
- Emergency Troubleshooting (expanded)
- Common errors (full list with solutions)
- System diagnostics (detailed commands)
- Log locations and interpretation

### AI Reading Protocol (NEW Section)

```markdown
## AI Reading Protocol

**Principle:** CLAUDE.md tells you WHAT to do. Supporting docs tell you HOW and WHY.

**Before starting work on:**
- New feature → Read FEATURE-TEMPLATE.md, create backlog item
- Bug fix → Read BUGFIX-TEMPLATE.md, check related ADRs
- Architecture decision → Read ADR-MAJOR-TEMPLATE.md examples in thoughts/project/research/adr/
- Release → Verify you've read version-control-workflow.md lines 101-149
- Unclear requirements → Use AskUserQuestion tool

**When encountering:**
- Process question → Grep thoughts/framework/process/ or read workflow-deep-dive.md
- Template question → Read thoughts/framework/templates/
- Pattern question → Read thoughts/framework/patterns/
- Coding standards → Read code-quality-standards.md
- Security requirement → Read security-policy.md
- Testing approach → Read testing-strategy.md
- Architecture context → Read architecture-deep-dive.md
- System not working → Read troubleshooting-guide.md

**Proactive Reading:**
- Read work item template BEFORE creating work item
- Read ADR examples BEFORE writing new ADR
- Read release checklist BEFORE releasing
- Grep for similar past decisions BEFORE making new decisions

**Never guess. Read the docs.**
```

---

## Dependencies

**Requires:**
- Existing CLAUDE.md (will be restructured)
- Existing framework docs to extract content from

**Blocks:**
- None

**Related:**
- FEAT-016: Quick Reference Guide (similar concept, different audience)
- ADR-001: AI Workflow Checkpoint Policy (must preserve verbatim)
- All framework process documents (will be referenced)

---

## Testing Plan

### Manual Testing Steps

1. **Context Usage Test:**
   - Measure current CLAUDE.md tokens: 5.1k
   - Implement restructure
   - Measure new CLAUDE.md tokens: target <3.5k
   - Verify 30%+ reduction

2. **AI Comprehension Test:**
   - Ask AI to find specific guidance (e.g., "How do I create an ADR?")
   - Verify AI can find answer in restructured docs
   - Compare speed: current vs. restructured

3. **Completeness Test:**
   - Verify all current CLAUDE.md guidance is still accessible
   - Check all cross-references work
   - Ensure no critical guidance lost

4. **Maintainability Test:**
   - Make a test update to coding standards
   - Verify easier to update in separate file vs. monolithic
   - Check cross-references still work

### Success Criteria

- [ ] CLAUDE.md reduced to 400-500 lines (<3.5k tokens)
- [ ] CLAUDE-QUICK-REFERENCE.md created (<200 lines)
- [ ] All critical guidance still accessible
- [ ] AI can find guidance using Reading Protocol
- [ ] All cross-references functional
- [ ] Context usage improved by 30%+

---

## Security Considerations

- [x] Input validation implemented - N/A (documentation)
- [x] No credential exposure in logs - N/A
- [x] Path traversal prevention - N/A
- [x] Error messages don't leak sensitive info - N/A
- [x] Follows principle of least privilege - N/A

---

## Documentation Updates

### Files to Update

- [ ] CLAUDE.md - Complete restructure
- [ ] INDEX.md - Add CLAUDE-QUICK-REFERENCE.md and ai-collaboration/ folder
- [ ] STRUCTURE.md - Document new ai-collaboration/ folder
- [ ] QUICK-REFERENCE.md - Maybe add reference to CLAUDE-QUICK-REFERENCE.md

### New Documentation Needed

- [ ] CLAUDE-QUICK-REFERENCE.md
- [ ] thoughts/project/reference/ai-collaboration/README.md
- [ ] thoughts/project/reference/ai-collaboration/workflow-deep-dive.md
- [ ] thoughts/project/reference/ai-collaboration/architecture-deep-dive.md
- [ ] thoughts/project/reference/ai-collaboration/code-quality-standards.md
- [ ] thoughts/project/reference/ai-collaboration/testing-strategy.md
- [ ] thoughts/project/reference/ai-collaboration/security-policy.md
- [ ] thoughts/project/reference/ai-collaboration/troubleshooting-guide.md

---

## Implementation Checklist

### Phase 1: Preparation
- [ ] Audit current CLAUDE.md (identify what to keep/move)
- [ ] Create content migration matrix
- [ ] Design reviewed and approved

### Phase 2: Supporting Docs
- [ ] Create ai-collaboration/ folder structure
- [ ] Create README.md index
- [ ] Migrate workflow content → workflow-deep-dive.md
- [ ] Migrate architecture content → architecture-deep-dive.md
- [ ] Migrate code quality → code-quality-standards.md
- [ ] Migrate testing → testing-strategy.md
- [ ] Migrate security → security-policy.md
- [ ] Migrate troubleshooting → troubleshooting-guide.md

### Phase 3: CLAUDE.md Restructure
- [ ] Create CLAUDE-QUICK-REFERENCE.md (critical checklists)
- [ ] Restructure CLAUDE.md (new outline)
- [ ] Add AI Reading Protocol section
- [ ] Add cross-references to supporting docs
- [ ] Verify all critical guidance preserved

### Phase 4: Validation
- [ ] Test AI can find guidance using new structure
- [ ] Verify all cross-references work
- [ ] Measure token reduction
- [ ] User review and feedback

### Phase 5: Documentation
- [ ] Update INDEX.md
- [ ] Update STRUCTURE.md
- [ ] Update CHANGELOG.md

---

## Rollout Plan

**Deployment Steps:**

1. **Create supporting docs** (ai-collaboration/ folder)
2. **Create CLAUDE-QUICK-REFERENCE.md**
3. **Test supporting docs** (verify content complete)
4. **Restructure CLAUDE.md** (use new outline)
5. **Update cross-references** (ensure all links work)
6. **Test with AI** (verify guidance findable)
7. **Update documentation** (INDEX, STRUCTURE)
8. **Release in v2.2.0**

**Rollback Plan:**

If restructure causes issues:
1. Revert CLAUDE.md to previous version
2. Keep supporting docs (no harm)
3. Can retry restructure with adjustments

**Migration for existing projects:**
- Existing projects using old CLAUDE.md: No forced migration
- New projects: Use restructured version
- Update guide in UPGRADE-PATH.md

---

## Success Metrics

**How do we know this feature is successful?**

- CLAUDE.md size reduced by 30%+ (654 lines → 400-500 lines)
- Context usage improved (5.1k tokens → <3.5k tokens)
- AI can find guidance faster (subjective but measurable)
- Maintainability improved (easier to update individual guides)
- No critical guidance lost (completeness test passes)
- User feedback positive (easier to understand)

---

## Timeline

| Phase | Estimated Hours | Actual Hours | Status |
|-------|-----------------|--------------|--------|
| Planning | 1 hour | TBD | Backlog |
| Content Audit | 2 hours | TBD | Backlog |
| Supporting Docs | 4 hours | TBD | Backlog |
| CLAUDE.md Restructure | 3 hours | TBD | Backlog |
| Testing & Validation | 2 hours | TBD | Backlog |
| Documentation | 1 hour | TBD | Backlog |
| **Total** | **13 hours** | **TBD** | |

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Changed
- CLAUDE.md restructured for scalability (654 → 500 lines, 30% reduction)
  - Hierarchical documentation pattern
  - Critical checklists retained in CLAUDE.md
  - Detailed content moved to supporting docs
  - AI Reading Protocol added

### Added
- CLAUDE-QUICK-REFERENCE.md - Critical checklists (<200 lines)
- thoughts/project/reference/ai-collaboration/ documentation
  - workflow-deep-dive.md
  - architecture-deep-dive.md
  - code-quality-standards.md
  - testing-strategy.md
  - security-policy.md
  - troubleshooting-guide.md
- AI Reading Protocol section in CLAUDE.md
```

---

## Notes

**Origin:** Context usage at 89% (178k/200k) with CLAUDE.md using 5.1k tokens. Need to optimize for scalability as framework matures.

**Key Insight:** Human documentation patterns (quick reference + detailed manual) work for AI too. AI can dynamically read supporting docs when needed using Read tool.

**Critical Requirement:** Must preserve AI Workflow Checkpoint Policy (ADR-001) and Release Process verbatim in CLAUDE.md. These are process-critical.

**Template Impact:** This restructure should also be applied to:
- project-framework-template/standard/CLAUDE.md (template version)
- project-framework-template/light/CLAUDE.md (if exists)

**Future Opportunity:** FEAT-018 (Claude Command Framework) could include `/docs` command to search ai-collaboration/ folder.

---

## References

- Current CLAUDE.md - 654 lines, 5.1k tokens
- Context usage stats - 178k/200k (89%)
- [ADR-001](../research/adr/001-ai-workflow-checkpoint-policy.md) - Must preserve
- Human analogy: Quick reference card + detailed manual
- Industry best practice: 300-500 lines for AI instruction files

---

## Alternative Approaches Considered

**Option A:** Leave CLAUDE.md as-is, accept growth
- Pros: No work required
- Cons: Will hit context limits, harder to maintain
- Decision: Rejected - not scalable

**Option B:** Split into multiple CLAUDE-*.md files
- Pros: Logical separation
- Cons: AI might not know which file to read
- Decision: Rejected - single CLAUDE.md + supporting docs better

**Option C:** Extreme minimalism - <200 lines CLAUDE.md
- Pros: Maximum context savings
- Cons: Too minimal, AI would miss critical guidance
- Decision: Rejected - balance needed

**Option D:** Hierarchical documentation (chosen)
- Pros: Scalable, maintainable, follows DRY
- Cons: Requires AI to read multiple docs
- Decision: Chosen - best balance

---

**Last Updated:** 2025-12-20

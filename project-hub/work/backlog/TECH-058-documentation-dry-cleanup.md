# TECH-058: Documentation DRY Cleanup

**ID:** TECH-058
**Type:** Tech Debt
**Priority:** Medium
**Version Impact:** PATCH
**Created:** 2026-01-14
**Theme:** Workflow

---

## Summary

Clean up collaboration documentation to comply with DRY principles established in TECH-043. Audit identified 6 issues across 5 files.

---

## Problem Statement

**Issue identified during:** TECH-043 implementation (DRY principles audit)

The collaboration documentation is ~98% compliant with DRY principles, but 6 specific issues were identified that should be addressed to maintain documentation quality.

**Who is affected?**
- AI assistants (unclear sources of truth cause confusion)
- Users (unnecessary links add noise)
- Maintainers (stale references create confusion)

---

## Issues to Fix

### High Priority

#### 1. security-policy.md - Unnecessary References
**Location:** Lines ~1021-1024 ("Related Documentation" section)
**Issue:** Tangential "see also" links that violate principle #5 (Reference with Purpose)
**Fix:** Remove the "Related Documentation" section - readers navigate from CLAUDE.md or README.md

#### 2. architecture-guide.md - Stale Planned Feature
**Location:** Lines ~435-450 ("AI Reading Protocol (Planned)")
**Issue:** References a planned feature that's either implemented differently or not at all
**Fix:** Either complete the implementation in CLAUDE.md, or remove "Planned" references

#### 3. workflow-guide.md - Session History Source Unclear
**Location:** Lines ~573-612 (Session History template)
**Issue:** Session history format documented in multiple places without clear single source
**Fix:** Clarify workflow-guide.md as the source, ensure other docs link rather than duplicate

### Medium Priority

#### 4. testing-strategy.md - Unclear Relationship
**Location:** Lines ~941-943 and ~482-521
**Issue:** Error handling coverage overlaps with code-quality-standards.md without clarifying the relationship
**Fix:** Add note: "For implementation patterns, see Code Quality Standards. This section covers testing strategies for error cases."

#### 5. documentation-dry-principles.md - Missing Self-Reference
**Location:** Lines ~65-76 (Sources of Truth table)
**Issue:** Document doesn't list itself as source for documentation standards
**Fix:** Add row: `| Documentation standards | docs/collaboration/documentation-dry-principles.md |`

### Low Priority

#### 6. workflow-guide.md - Fragile Path Reference
**Location:** Line ~174
**Issue:** External path reference to version-control-workflow.md may be fragile
**Fix:** Verify path is correct; consider if content should be consolidated

---

## Implementation Checklist

- [ ] security-policy.md: Remove unnecessary "Related Documentation" section
- [ ] architecture-guide.md: Resolve "AI Reading Protocol (Planned)" status
- [ ] workflow-guide.md: Clarify Session History as single source
- [ ] testing-strategy.md: Add clarifying note about error handling relationship
- [ ] documentation-dry-principles.md: Add self-reference to sources table
- [ ] workflow-guide.md: Verify external path reference
- [ ] Changes committed

---

## Completion Criteria

- [ ] All 6 issues addressed
- [ ] No new DRY violations introduced
- [ ] Documentation still coherent and navigable
- [ ] Changes committed

---

## References

- TECH-043: DRY Documentation Principles (established the policy)
- TECH-036: Documentation Refactoring (broader refactoring effort)
- Audit performed: 2026-01-14

---

**Last Updated:** 2026-01-14

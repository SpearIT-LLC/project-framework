# Technical: Review CLAUDE.md Files for Duplication/Redundancy

**ID:** 061
**Type:** Technical
**Version Impact:** PATCH (documentation cleanup)
**Status:** Backlog
**Created:** 2026-01-17
**Completed:** N/A
**Developer:** Claude

---

## Summary

Review `/CLAUDE.md` and `/framework/CLAUDE.md` for duplication or redundancy. Ensure clear separation of concerns: root file for navigation/bootstrap, framework file for detailed guidance.

---

## Problem Statement

**What problem does this solve?**

The repository has two CLAUDE.md files with potentially overlapping content:
- `/CLAUDE.md` (~140 lines) - Repository navigation, routes to sub-projects
- `/framework/CLAUDE.md` (~580 lines) - Full workflow, roles, standards, policies

As the framework evolves (especially with FEAT-059 roles and FEAT-060 bootstrap), there's risk of:
- Duplicated guidance in both files
- Conflicting instructions
- Unclear which file is authoritative for what
- Maintenance burden keeping both in sync

**Who is affected?**

- AI assistants (confused by duplicate/conflicting guidance)
- Maintainers (updating same info in two places)

**Current workaround (if any):**

None - this is a proactive cleanup task.

---

## Requirements

### Functional Requirements

- [ ] Audit both files for overlapping content
- [ ] Identify any conflicting guidance
- [ ] Define clear responsibility for each file
- [ ] Remove duplication (keep content in one authoritative location)
- [ ] Add cross-references where appropriate

### Non-Functional Requirements

- [ ] Compatibility: No behavior change, just cleaner organization
- [ ] Documentation: Both files should be self-explanatory about their purpose

---

## Design

### Proposed Separation of Concerns

| File | Purpose | Contains |
|------|---------|----------|
| `/CLAUDE.md` | Repository entry point | Navigation, bootstrap, project routing |
| `/framework/CLAUDE.md` | Framework collaboration contract | Full workflow, roles, standards, policies |

### Audit Checklist

- [ ] Check for duplicated "Project Configuration" sections
- [ ] Check for duplicated workflow descriptions
- [ ] Check for duplicated framework structure descriptions
- [ ] Verify role/policy guidance only lives in `/framework/CLAUDE.md`
- [ ] Verify navigation/routing only lives in `/CLAUDE.md`

---

## Dependencies

**Requires:**
- FEAT-060 (bootstrap block) - Should be done first to establish the pattern

**Blocks:**
- None

**Related:**
- FEAT-059 (context-aware AI roles)
- FEAT-060 (framework bootstrap block)

---

## Implementation Checklist

- [ ] Audit both files for duplication
- [ ] Document findings
- [ ] Remove duplicated content
- [ ] Add/update cross-references
- [ ] Verify both files are internally consistent
- [ ] Manual testing: AI can navigate correctly from root to framework

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Changed
- Cleaned up duplication between root CLAUDE.md and framework/CLAUDE.md
  - Root file: navigation and bootstrap only
  - Framework file: detailed collaboration guidance
```

---

## Notes

This task should be done after FEAT-060 (bootstrap block) to ensure the pattern is established before cleanup.

---

**Last Updated:** 2026-01-17

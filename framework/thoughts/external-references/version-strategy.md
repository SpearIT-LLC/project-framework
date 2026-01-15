# Version Strategy - SpearIT Project Framework

**Last Updated:** 2025-12-19
**Version:** 1.0.0
**Author:** Gary Elliott

---

## Overview

This document clarifies how versioning works for the SpearIT Project Framework itself and the templates it contains. Understanding the distinction between **framework versions** and **document versions** is critical to avoid unnecessary version bumps across all files.

---

## Core Principle: Separate Version Tracking

The framework uses **two independent versioning systems**:

1. **Framework Version** - Overall release version of the framework package
2. **Document Versions** - Individual "Last Updated" dates in each document

**Why?** Changing one template shouldn't require version bumps across all 50+ files in the framework.

---

## Framework Versioning

### What Is the Framework Version?

The **framework version** represents the overall state of the entire SpearIT Project Framework package as a cohesive unit.

**Tracked in:** [PROJECT-STATUS.md](../../../PROJECT-STATUS.md)
**Current Framework Version:** v2.0.0 (as of 2025-12-19)

### Semantic Versioning

The framework follows [Semantic Versioning 2.0.0](https://semver.org/):

```
MAJOR.MINOR.PATCH
  X   . Y   . Z
```

**MAJOR version (X.0.0)** - Breaking changes
- Incompatible structure changes
- Removal of framework levels
- Breaking changes to template structure
- Workflow changes that require migration

**Examples:**
- v1.0.0 → v2.0.0: Introduction of multi-level framework (Minimal/Light/Standard)
- v2.0.0 → v3.0.0: Complete restructure of thoughts/ folder (hypothetical)

**MINOR version (x.Y.0)** - New features, backward compatible
- New framework level added
- New templates added
- New patterns or processes documented
- Enhanced tooling that doesn't break existing usage

**Examples:**
- v2.0.0 → v2.1.0: Added ZIP distribution package and setup script
- v2.1.0 → v2.2.0: Added automation scripts and sample projects

**PATCH version (x.y.Z)** - Bug fixes, backward compatible
- Typo fixes in templates
- Documentation clarifications
- Bug fixes in scripts
- Minor improvements that don't change structure

**Examples:**
- v2.1.0 → v2.1.1: Fixed typos in FEATURE-TEMPLATE.md
- v2.1.1 → v2.1.2: Clarified instructions in NEW-PROJECT-CHECKLIST.md

---

## Document Versioning

### What Are Document Versions?

**Document versions** are tracked independently using "Last Updated" dates in each file's header.

**Format:**
```markdown
**Last Updated:** YYYY-MM-DD
```

**Optional version field for major documents:**
```markdown
**Last Updated:** YYYY-MM-DD
**Version:** X.Y.Z
```

### When to Update "Last Updated"

**Update the date when:**
- ✅ Content materially changes (new sections, restructured content)
- ✅ Instructions are clarified or corrected
- ✅ Examples are added or changed
- ✅ Structure is modified

**Do NOT update the date for:**
- ❌ Typo fixes (grammar, spelling)
- ❌ Minor formatting changes (whitespace, line breaks)
- ❌ Cross-reference link updates (unless content changes)

### Document-Specific Versions (Optional)

Some documents may track their own version numbers for significant changes:

**Documents that track versions:**
- NEW-PROJECT-CHECKLIST.md (v2.0.0) - Significant changes warrant version tracking
- STRUCTURE.md (v2.0.0) - Structure changes require versioning
- UPGRADE-PATH.md (v1.0.0) - Process changes tracked

**Documents that use dates only:**
- Most templates (FEATURE-TEMPLATE.md, etc.) - Date is sufficient
- Pattern documentation - Date is sufficient
- Process documentation - Date is sufficient

**Rule of thumb:** If users might reference "version X of this document," give it a version number. Otherwise, date is sufficient.

---

## Template Versioning

### Templates Inherit Framework Version

Templates within the framework package inherit the framework version **unless they have independent reasons to track separately**.

**Default behavior:**
- Template created in framework v2.0.0 → Template is v2.0.0 (implicitly)
- Template updated in framework v2.1.0 → Template now v2.1.0 (implicitly)
- No version field needed in template header

**Optional explicit versioning:**
- If template undergoes major breaking change, can add version field
- Example: FEATURE-TEMPLATE.md v2.0.0 (breaking field changes)

**Current practice:** Templates use "Last Updated" date only, inherit framework version implicitly.

---

## Version Tracking Examples

### Example 1: New Template Added

**Scenario:** Add new template RETROSPECTIVE-TEMPLATE.md in framework v2.1.0

**Framework Version:** v2.0.0 → v2.1.0 (minor - new feature)
**CHANGELOG.md entry:**
```markdown
## [2.1.0] - 2025-12-25

### Added
- RETROSPECTIVE-TEMPLATE.md for project retrospectives
```

**RETROSPECTIVE-TEMPLATE.md header:**
```markdown
**Last Updated:** 2025-12-25
(No version field - inherits framework v2.1.0)
```

**Other templates:** No changes, dates unchanged

---

### Example 2: Typo Fix in Template

**Scenario:** Fix typo in FEATURE-TEMPLATE.md

**Framework Version:** v2.1.0 → v2.1.1 (patch - bug fix)
**CHANGELOG.md entry:**
```markdown
## [2.1.1] - 2025-12-26

### Fixed
- Typo in FEATURE-TEMPLATE.md section header
```

**FEATURE-TEMPLATE.md header:**
```markdown
**Last Updated:** 2025-12-15  ← Unchanged (typo doesn't warrant date update)
```

**Other templates:** No changes

---

### Example 3: Breaking Change to Workflow

**Scenario:** Change kanban workflow from 3 folders (todo/doing/done) to 5 folders (backlog/todo/doing/review/done)

**Framework Version:** v2.1.1 → v3.0.0 (major - breaking change)
**CHANGELOG.md entry:**
```markdown
## [3.0.0] - 2026-01-15

### Changed
- **BREAKING:** Kanban workflow now uses 5 folders instead of 3
- Added review/ folder for code review stage
- Backlog separated from todo

### Migration
- See UPGRADE-PATH.md for migration instructions
```

**workflow-guide.md:**
```markdown
**Last Updated:** 2026-01-15
**Version:** 3.0.0  ← Explicit version for major process change
```

**Other docs:** Updated dates only where content changed

---

## Release Process and Versioning

### Standard Release Workflow

1. **Work completed** in thoughts/project/work/doing/
2. **Update PROJECT-STATUS.md** with new version and changes
3. **Update CHANGELOG.md** with version entry
4. **Update "Last Updated"** in changed documents only
5. **Git commit** with version in message
6. **Git tag** with version number
7. **Move work items** to thoughts/project/work/done/
8. **Archive to** thoughts/project/history/releases/vX.Y.Z/

### Version Decision Checklist

**Deciding framework version bump:**

```
Is there a breaking change?
  ├─ Yes → MAJOR version (X.0.0)
  │
  └─ No → Is there a new feature/template?
         ├─ Yes → MINOR version (x.Y.0)
         │
         └─ No → Bug fix or doc improvement?
                └─ Yes → PATCH version (x.y.Z)
```

**Deciding document date update:**

```
Did content materially change?
  ├─ Yes → Update "Last Updated" date
  │
  └─ No → Leave date unchanged
```

---

## Version Communication

### Where Framework Version Appears

**Primary location:**
- [PROJECT-STATUS.md](../../../PROJECT-STATUS.md) - **Single source of truth**

**Referenced in:**
- [README.md](../../../README.md) - Links to PROJECT-STATUS.md
- [CHANGELOG.md](../../../CHANGELOG.md) - Version entries
- Git tags - `git tag -a vX.Y.Z`

**NOT duplicated in:**
- Individual templates (they inherit implicitly)
- Random places in documentation

### Where Document Versions/Dates Appear

**In each document header:**
```markdown
**Last Updated:** YYYY-MM-DD
```

**Optional version for major docs:**
```markdown
**Last Updated:** YYYY-MM-DD
**Version:** X.Y.Z
```

---

## FAQ

### Q: Do I need to update all template "Last Updated" dates when releasing a new framework version?

**A: No.** Only update dates on documents that actually changed. If FEATURE-TEMPLATE.md wasn't modified in v2.1.0, leave its date unchanged.

### Q: Should templates have version numbers in their headers?

**A: Generally no.** Templates inherit the framework version. Only add explicit version if template has independent versioning needs (rare).

### Q: What if I fix a typo - do I bump the version?

**A: Patch version only.** Framework v2.1.0 → v2.1.1. Don't update document dates for typos.

### Q: How do I know what framework version a template is part of?

**A: Check git history.** Look at git tags to see when template was added or last modified. Or check PROJECT-STATUS.md for framework version at time of change.

### Q: Can document versions differ from framework version?

**A: Yes, optionally.** A document can track its own version (e.g., NEW-PROJECT-CHECKLIST.md v2.0.0) while framework is v2.1.0. This indicates the document hasn't changed since v2.0.0.

### Q: What version should I use when starting a new project from templates?

**A: Note the framework version you copied from.** Example: "Created from SpearIT Project Framework v2.1.0 Standard template."

---

## Examples from Real Projects

### HPC Job Queue Prototype

**Framework version used:** v1.0.0 (before multi-level framework)
**Template modifications:** Customized FEATURE-TEMPLATE.md with HPC-specific fields
**Versioning:** Project tracks its own version (currently v1.2.0), independent of framework version

**Key insight:** Project can evolve independently after copying templates. Framework version is just the starting point.

### SpearIT Project Framework (This Project)

**Framework version:** v2.0.0
**Dogfooding status:** Uses Standard framework template on itself
**Versioning:** PROJECT-STATUS.md shows framework version v2.0.0

**Key insight:** Framework using itself proves versioning strategy works in practice.

---

## Version History of This Document

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2025-12-19 | Initial version strategy documentation |

---

## Related Documentation

- [PROJECT-STATUS.md](../../../PROJECT-STATUS.md) - Current framework version (single source of truth)
- [CHANGELOG.md](../../../CHANGELOG.md) - Detailed version history
- [version-control-workflow.md](../../framework/process/version-control-workflow.md) - Release process *(template)*
- [Semantic Versioning](https://semver.org/) - Version numbering standard

---

**Last Updated:** 2025-12-19
**Version:** 1.0.0
**Maintained by:** Gary Elliott (gary.elliott@spearit.solutions)

# Tech Debt: Create External Reference Template

**ID:** TECH-073
**Type:** Tech Debt
**Priority:** Medium
**Version Impact:** PATCH
**Created:** 2026-01-23

---

## Summary

No external reference template exists. The `project-hub/external-references/README.md` explains what to store but not how to format references.

---

## Problem Statement

**What is the current state?**

- `project-hub/external-references/README.md` explains purpose
- No naming convention documented (kebab-case? topic-based?)
- No required metadata fields defined (Source, URL, Retrieved date?)
- No template in `framework/templates/`

**Why is this a problem?**

- Inconsistent external reference format
- Missing provenance information (when was it retrieved? from where?)
- New users don't know how to structure references

**What is the desired state?**

- Standard external reference template with metadata header
- Clear naming convention
- Consistent format across all framework users

---

## Proposed Solution

Create `EXTERNAL-REFERENCE-TEMPLATE.md` in `framework/templates/documentation/`:

**Proposed Template:**
```markdown
# [Topic] Reference

**Source:** [Authoritative source name]
**Retrieved:** YYYY-MM-DD
**URL:** [Original URL]
**Version:** [Version or "current" if no versioning]

---

## Summary

[Brief description of what this reference covers and why it's useful]

---

## Content

[Organized content from the source]

### [Section 1]

[Content]

### [Section 2]

[Content]

---

## Notes

- This is a cached reference for convenience
- Original documentation at [source] is authoritative
- If outdated, re-fetch from source URL

---

**Last Updated:** YYYY-MM-DD
```

**Proposed Naming Convention:**
- Use kebab-case: `topic-subtopic.md`
- Examples:
  - `powershell-console-colors.md`
  - `git-rebase-workflow.md`
  - `semver-specification.md`

**Files Created:**
- `framework/templates/documentation/EXTERNAL-REFERENCE-TEMPLATE.md`
- `templates/standard/framework/templates/documentation/EXTERNAL-REFERENCE-TEMPLATE.md`

**Files Updated:**
- `project-hub/external-references/README.md` - Add link to template and naming convention

---

## Acceptance Criteria

- [ ] Template created in framework/templates/documentation/
- [ ] Metadata header includes Source, Retrieved, URL, Version
- [ ] Naming convention documented
- [ ] Template synced to templates/standard/
- [ ] external-references/README.md updated with template reference

---

## Notes

Discovered during FEAT-025 validation testing. FEAT-013 in project-hello-world tested external references and found no template or format guide.

---

## Related

- FEAT-025: Manual Setup Validation (source of finding)

# Feature: Create project-guide.md

**ID:** FEAT-102
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-02-02
**Theme:** Project Guidance

---

## Summary

Create `framework/docs/collaboration/project-guide.md` containing project-level guidance extracted from workflow-guide.md, including structure, setup, configuration patterns, and project definition standards.

---

## Problem Statement

**What is the current state?**

Project-level guidance (how to set up projects, configure framework.yaml, organize structure) is currently embedded in workflow-guide.md alongside workflow process and developer standards.

**Why is this needed?**

1. **Separation of concerns** - Project guidance is distinct from workflow process
2. **Target audience** - Project setup is typically done once, workflow is daily
3. **Discoverability** - Easier to find "how to configure my project" in dedicated doc
4. **Maintainability** - Changes to project patterns don't affect workflow docs

**What is the desired state?**

A dedicated `project-guide.md` containing:
- Project structure guidance
- framework.yaml configuration
- Project definition patterns (from TECH-101)
- CLAUDE.md customization
- Template selection and customization
- Project setup best practices

---

## Proposed Solution

1. **Analyze workflow-guide.md** - Identify all project-level guidance sections
2. **Create project-guide.md** with:
   - Project structure overview
   - framework.yaml configuration guide
   - Project definition pattern (README.md + framework.yaml)
   - CLAUDE.md customization guidance
   - Sources index usage
   - Project setup checklist references

3. **Update workflow-guide.md** - Remove project-level sections, add references to project-guide.md
4. **Update framework.yaml sources** - Add entries pointing to project-guide.md
5. **Update cross-references** - Fix links from other docs

**Dependencies:**
- TECH-100: Split workflow-guide.md (parent issue)

---

## Acceptance Criteria

- [ ] project-guide.md exists in framework/docs/collaboration/
- [ ] Contains all project-level guidance from workflow-guide.md
- [ ] Includes project definition pattern from TECH-101
- [ ] Well-structured with clear sections and TOC
- [ ] framework.yaml sources updated to reference project-guide.md
- [ ] workflow-guide.md updated to remove project content and add references
- [ ] Cross-references from other docs updated
- [ ] No broken links

---

## Notes

- Part of TECH-100 (splitting workflow-guide.md)
- Should include guidance from TECH-101 about project definitions
- Consider if this should also cover template customization

---

## Related

- TECH-100: Split workflow-guide.md (parent issue)
- TECH-101: Document project definition SsoT pattern (content dependency)
- FEAT-103: Create developer-guide.md (parallel work)

---

**Last Updated:** 2026-02-02

# Tech Debt: Split workflow-guide.md into focused documents

**ID:** TECH-100
**Type:** Tech Debt
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-02-02
**Theme:** Workflow

---

## Summary

Split `framework/docs/collaboration/workflow-guide.md` into three focused documents: workflow-guide.md (process), project-guide.md (project-level guidance), and developer-guide.md (code/testing/security standards).

---

## Problem Statement

**What is the current state?**

`workflow-guide.md` has grown to cover three distinct concerns:
1. **Workflow** - Process, transitions, work item flow, kanban
2. **Project guidance** - Structure, configuration, documentation patterns, project setup
3. **Developer guidance** - Code quality, testing, security practices

The document is getting long and mixing concerns that could be better separated.

**Why is this a problem?**

1. **Discoverability** - Hard to find specific guidance in a large document
2. **Mixed concerns** - Workflow process mixed with code standards
3. **Navigation** - Users must scroll through unrelated content
4. **Maintenance** - Updates to one concern require navigating entire document
5. **Reference clarity** - framework.yaml sources map to one large document

**What is the desired state?**

Three focused documents:
- **workflow-guide.md** - Process and work item flow only
- **project-guide.md** - Project structure, setup, configuration patterns
- **developer-guide.md** - Code quality, testing, security standards

Each document is focused, navigable, and clearly referenced in framework.yaml sources.

---

## Proposed Solution

1. **Analyze workflow-guide.md** - Identify sections for each new document
2. **Create project-guide.md** (FEAT-102)
3. **Create developer-guide.md** (FEAT-103)
4. **Update workflow-guide.md** - Keep only workflow/process content
5. **Update framework.yaml sources** - Point to appropriate documents
6. **Update cross-references** - Fix links in other docs

**Dependencies:**
- FEAT-102: Create project-guide.md
- FEAT-103: Create developer-guide.md

---

## Acceptance Criteria

- [ ] workflow-guide.md contains only workflow/process content
- [ ] project-guide.md exists with project-level guidance
- [ ] developer-guide.md exists with code/testing/security guidance
- [ ] framework.yaml sources updated to point to correct documents
- [ ] Cross-references in other docs updated
- [ ] No broken links
- [ ] All three documents are well-structured and navigable

---

## Notes

- Identified during discussion about where to document project definition SsoT pattern
- Related to TECH-067 (consolidate AI sections) - may affect scope
- Should consider if this affects template documentation

---

## Related

- TECH-101: Document project definition SsoT pattern (trigger for this issue)
- FEAT-102: Create project-guide.md (implementation)
- FEAT-103: Create developer-guide.md (implementation)
- TECH-067: Consolidate AI sections into workflow-guide.md (may be affected)

---

**Last Updated:** 2026-02-02

# Feature: Create developer-guide.md

**ID:** FEAT-103
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-02-02

---

## Summary

Create `framework/docs/collaboration/developer-guide.md` containing developer-focused guidance extracted from workflow-guide.md, including code quality standards, testing practices, and security guidelines.

---

## Problem Statement

**What is the current state?**

Developer guidance (code quality, testing, security) is currently embedded in workflow-guide.md alongside workflow process and project setup guidance.

**Why is this needed?**

1. **Separation of concerns** - Developer practices are distinct from workflow process
2. **Target audience** - Developers need quick access to coding standards
3. **Discoverability** - Easier to find "what are our code standards" in dedicated doc
4. **Maintainability** - Changes to code practices don't affect workflow docs
5. **Reference clarity** - Clear place for code review standards and practices

**What is the desired state?**

A dedicated `developer-guide.md` containing:
- Code quality standards
- Testing strategy and practices
- Security guidelines
- Error handling patterns
- Code review practices
- Development best practices

---

## Proposed Solution

1. **Analyze workflow-guide.md** - Identify all developer-focused sections
2. **Check existing specialized docs** - Review code-quality-standards.md, testing-strategy.md, security-policy.md
3. **Create developer-guide.md** as either:
   - **Option A:** Index/hub pointing to specialized docs (code-quality-standards.md, testing-strategy.md, etc.)
   - **Option B:** Consolidated document with all developer guidance
   - **Recommendation:** Option A to avoid duplicating detailed guides

4. **Update workflow-guide.md** - Remove developer sections, add references to developer-guide.md
5. **Update framework.yaml sources** - Add entries pointing to developer-guide.md
6. **Update cross-references** - Fix links from other docs

**Dependencies:**
- TECH-100: Split workflow-guide.md (parent issue)

---

## Acceptance Criteria

- [ ] developer-guide.md exists in framework/docs/collaboration/
- [ ] Contains or references all developer-focused guidance
- [ ] Clarifies relationship to detailed guides (code-quality-standards.md, etc.)
- [ ] Well-structured with clear sections and TOC
- [ ] framework.yaml sources updated to reference developer-guide.md
- [ ] workflow-guide.md updated to remove developer content and add references
- [ ] Cross-references from other docs updated
- [ ] No broken links
- [ ] No duplication with existing detailed guides

---

## Notes

- Part of TECH-100 (splitting workflow-guide.md)
- Need to decide if this is a hub or consolidated doc
- Should clarify relationship to existing detailed guides

---

## Related

- TECH-100: Split workflow-guide.md (parent issue)
- FEAT-102: Create project-guide.md (parallel work)
- Existing detailed docs:
  - framework/docs/collaboration/code-quality-standards.md
  - framework/docs/collaboration/testing-strategy.md
  - framework/docs/collaboration/security-policy.md

---

**Last Updated:** 2026-02-02

# Tech Debt: Document project definition SsoT pattern

**ID:** TECH-101
**Type:** Tech Debt
**Priority:** Medium
**Version Impact:** PATCH
**Created:** 2026-02-02

---

## Summary

Document the pattern for where project definitions should live: structured metadata in framework.yaml, prose definition in README.md#what-is-this, with explicit pointer via sources.project-definition.

---

## Problem Statement

**What is the current state?**

The framework has:
- `framework.yaml` with project metadata (name, type, deliverable)
- `README.md` with "What Is This?" section containing project definition prose
- No explicit documentation about which is the SsoT for project definition

**Why is this a problem?**

1. **Ambiguity** - Not clear if definition should be in framework.yaml, README, or both
2. **Duplication risk** - Users might duplicate definition across files
3. **Missing guidance** - No documented pattern for where project definitions belong
4. **Schema incomplete** - framework-schema.yaml doesn't document this pattern

**What is the desired state?**

Clear documented pattern:
- README.md#what-is-this is the SsoT for prose project definition
- framework.yaml contains minimal structured metadata only
- framework.yaml uses `sources.project-definition` to point to README.md
- Pattern is documented in framework-schema.yaml
- Guidance exists about where to put project definitions (likely in new project-guide.md)

---

## Proposed Solution

1. **Update framework-schema.yaml:**
   - Document `sources.project-definition` as recommended pattern
   - Add guidance that README.md#what-is-this is the SsoT for prose
   - Clarify framework.yaml is for structured metadata only

2. **Update framework.yaml:**
   - Add `sources.project-definition: README.md#what-is-this`
   - Add `sources.project-features: README.md#key-features`

3. **Document pattern in project-guide.md** (once FEAT-102 is complete):
   - Where project definitions should live
   - Difference between metadata and definition
   - How to use sources to point to definitions

**Dependencies:**
- TECH-100: Split workflow-guide.md (creates context for where to document)
- FEAT-102: Create project-guide.md (target location for guidance)

---

## Acceptance Criteria

- [ ] framework-schema.yaml documents sources.project-definition pattern
- [ ] framework.yaml includes project-definition and project-features in sources
- [ ] Pattern guidance added to appropriate documentation
- [ ] Template framework.yaml files updated to include pattern
- [ ] No duplication of project definition across files

---

## Notes

- Identified during FEAT-095 work (roadmap creation)
- Led to discovery that workflow-guide.md is getting too long
- This is a smaller, focused fix that can be done independent of TECH-100

---

## Related

- TECH-100: Split workflow-guide.md (context for where to document)
- FEAT-102: Create project-guide.md (future home for guidance)
- FEAT-095: Framework roadmap ideas (trigger for this issue)

---

**Last Updated:** 2026-02-02

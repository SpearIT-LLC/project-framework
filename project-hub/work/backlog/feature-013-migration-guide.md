# Feature: Migration Guide from Other Frameworks

**ID:** FEAT-013
**Type:** Feature
**Priority:** Low
**Version Impact:** MINOR
**Created:** 2025-12-19
**Theme:** Distribution & Onboarding

---

## Summary

Create migration guides for projects using other popular frameworks (basic Git/Markdown, Jira, Trello, Azure DevOps) to adopt SpearIT framework.

---

## Problem Statement

Projects already using other systems need guidance on migrating to framework without losing work history or context.

---

## Requirements

- [ ] Migration guide from "Basic Git + README" approach
- [ ] Migration guide from Jira projects
- [ ] Migration guide from Trello boards
- [ ] Migration guide from Azure DevOps
- [ ] Mapping work items between systems
- [ ] Preserving history and context
- [ ] Incremental migration approach (don't stop working during migration)

---

## Content Outline

### From Basic Git + README
- Map existing structure to framework folders
- Create initial work items from git history
- Document decisions retroactively as ADRs

### From Jira
- Export Jira issues as work items
- Map issue types (Story→FEATURE, Bug→BUGFIX)
- Preserve labels and priorities
- Archive closed issues to project-hub/project/history/

### From Trello
- Export boards to project-hub/project/work/ folders
- Map lists to kanban folders
- Convert cards to work item documents

---

**Last Updated:** 2025-12-19
**Status:** Backlog - Future (v2.3.0)

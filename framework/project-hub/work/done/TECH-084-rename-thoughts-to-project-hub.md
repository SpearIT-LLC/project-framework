# Tech Debt: Rename thoughts/ to project-hub/

**ID:** TECH-084
**Type:** Tech Debt
**Priority:** Medium
**Version Impact:** MAJOR
**Created:** 2026-01-26
**Completed:** 2026-01-26

---

## Summary

Rename the `thoughts/` folder to `project-hub/` across all framework documentation, templates, and examples for improved clarity and discoverability.

---

## Problem Statement

**What is the current state?**

The framework used `thoughts/` as the folder name for project management artifacts:
- `thoughts/work/` - Kanban workflow (backlog, todo, doing, done)
- `thoughts/history/` - Session logs
- `thoughts/research/` - ADRs and spikes
- `thoughts/retrospectives/`
- `thoughts/external-references/`

**Why is this a problem?**

- "thoughts" is abstract and doesn't clearly communicate the folder's purpose
- New users may not intuitively understand what belongs there
- Industry conventions favor more descriptive names

**What is the desired state?**

Rename to `project-hub/` which:
- Clearly indicates "central place for project management"
- Is human-friendly and discoverable
- Follows modern naming conventions

---

## Proposed Solution

Global rename of `thoughts/` to `project-hub/` across:

1. **Framework documentation** - All process, collaboration, and pattern docs
2. **Framework templates** - Work item, decision, and documentation templates
3. **Starter templates** - `templates/standard/` files
4. **Examples** - `examples/hello-world/`
5. **Root CLAUDE.md files** - At repo and project levels
6. **Checklists** - `NEW-PROJECT-CHECKLIST.md` and similar
7. **PowerShell scripts** - All .ps1 and .psm1 files with path references

**Files Affected:**
- 105 markdown files (excluding history/)
- 8 PowerShell script files
- 2 YAML files
- Physical folder renames in framework/, examples/, and templates/

---

## Acceptance Criteria

- [x] All references to `thoughts/` updated to `project-hub/` (excluding history/)
- [x] Physical folders renamed in `framework/`
- [x] Physical folders renamed in `examples/hello-world/`
- [x] Physical folders renamed in `templates/standard/`
- [x] Framework documentation updated
- [x] Templates updated
- [x] CLAUDE.md files updated
- [x] PowerShell scripts and modules updated
- [x] YAML configuration files updated
- [x] Git history preserved (used `git mv`)

---

## Notes

- This is a breaking change for existing users (hence MAJOR version impact)
- History files intentionally excluded from text replacement to preserve historical accuracy
- PowerShell parameter renamed: `ThoughtsPath` → `ProjectHubPath`

---

## Related

- [DECISION-050](../todo/DECISION-050-framework-distribution-flow-diagram.md) - Framework distribution model (can now proceed with new naming)

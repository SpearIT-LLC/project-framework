# Tech Debt: Rename thoughts/ to project-hub/

**ID:** TECH-084
**Type:** Tech Debt
**Priority:** Medium
**Version Impact:** MAJOR
**Created:** 2026-01-26

---

## Summary

Rename the `thoughts/` folder to `project-hub/` across all framework documentation, templates, and examples for improved clarity and discoverability.

---

## Problem Statement

**What is the current state?**

The framework uses `thoughts/` as the folder name for project management artifacts:
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
3. **Starter templates** - `templates/starter/` files
4. **Examples** - `examples/hello-world/`
5. **Root CLAUDE.md files** - At repo and project levels
6. **Checklists** - `NEW-PROJECT-CHECKLIST.md` and similar

**Files Affected:**
- Estimated 30-50 files with `thoughts/` references
- Physical folder renames in examples and templates

---

## Acceptance Criteria

- [ ] All references to `thoughts/` updated to `project-hub/`
- [ ] Physical folders renamed in `examples/hello-world/`
- [ ] Physical folders renamed in `templates/starter/`
- [ ] Framework documentation updated
- [ ] Templates updated
- [ ] CLAUDE.md files updated
- [ ] No broken links or references
- [ ] Git history preserved (use `git mv`)

---

## Notes

- This is a breaking change for existing users (hence MAJOR version impact)
- Should be done before DECISION-050 distribution work is implemented
- Use `git mv` for folder renames to preserve history

---

## Related

- [DECISION-050](../doing/DECISION-050-framework-distribution-flow-diagram.md) - Framework distribution model (depends on this rename)

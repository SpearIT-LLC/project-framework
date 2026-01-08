# Framework Changelog

All notable changes to the project framework and processes will be documented in this file.

This file tracks process improvements, tooling updates, and infrastructure changes that are reusable across projects. For application-specific changes, see CHANGELOG.md.

## [Unreleased]

### Fixed
- Moved .limit file from work/ to work/doing/ for proper WIP limit scoping
- Pattern now supports future Kanban stages (testing/, review/) with independent limits

## [1.0.0] - 2025-11-27

### Added
- Kanban workflow structure (thoughts/project/work/todo/doing/done folders)
- WIP limit system using .limit file (default: 2 items in doing/)
- Type prefix naming convention: {type}.{description}.md
- Four work types: blocker, bugfix, feature, project
- Framework folder (thoughts/framework/) for reusable cross-project content
- Project folder (thoughts/project/) for HPC-specific content
- Process documentation in framework/process/
  - version-control-workflow.md (migrated from plans/)
  - documentation-standards.md (migrated from plans/)
- Reusable templates in framework/templates/
  - BLOCKER-TEMPLATE.md (migrated from plans/blockers/)
  - BUGFIX-TEMPLATE.md (migrated from plans/bugfixes/)
  - FEATURE-TEMPLATE.md (migrated from plans/features/)
  - PROJECT-TEMPLATE.md (new)
- Pattern documentation in framework/patterns/
  - powershell-modules.md (new - module structure, CmdletBinding, exports)
  - config-management.md (new - local/shared config pattern)
  - cmd-wrappers.md (new - batch wrapper patterns for PowerShell)
- Project reference documentation in project/reference/ (11 docs migrated from plans/)
- Project work Kanban in project/work/ (16 items migrated: 12 features, 3 blockers/bugfixes, 1 project)

### Changed
- Reorganized thoughts/ from type-based folders (plans/blockers/, plans/bugfixes/, plans/features/) to Kanban-based folders (work/todo/, work/doing/, work/done/)
- File naming from blocker-name.md to blocker.name.md (dot delimiter for type prefix)
- Separated reusable framework content from project-specific content
- Moved research/, retrospectives/, history/ under project/ folder

### Removed
- Old plans/ folder structure (all content migrated)
- Type-specific subfolders (blockers/, bugfixes/, features/)

### Migration Summary
- 87 total files migrated successfully
- 10 framework files created/migrated
- 77 project files migrated
- All documentation references updated (CLAUDE.md, README.md, CONFIG-README.md, CHANGELOG.md, PROJECT-STATUS.md)
- Zero broken links verified

### Rationale
- Enable visual workflow management (folder location = current status)
- Support future project reuse (copy framework/ to new projects)
- Maintain focus with WIP limits (max 2 in doing/ at once)
- Clear separation of process (framework) vs implementation (project)
- Simplify type identification (filename prefix vs folder location)

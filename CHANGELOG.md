# Changelog - SpearIT Project Framework

All notable changes to the SpearIT Project Framework will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

**Project:** SpearIT Project Framework
**Maintainer:** Gary Elliott (gary.elliott@spearit.solutions)
**Organization:** SpearIT, LLC

---

## [Unreleased]

### Planned
- Visual diagrams for folder structure and workflow
- ZIP distribution package
- Interactive setup script
- Validation script

---

## [2.0.0] - 2025-12-19

### Added
- **Dogfooding:** Framework now uses its own Standard framework for development
- PROJECT-STATUS.md for framework project (single source of truth for version)
- CHANGELOG.md for framework project version history
- INDEX.md for framework project documentation navigation
- thoughts/project/ structure for framework development (kanban workflow)
- thoughts/project/reference/version-strategy.md - Version strategy documentation
- project-framework-template/README.md - Package overview with migration notes

### Changed
- **BREAKING:** Removed legacy root templates from project-framework-template/
  - Removed duplicate README.md, CLAUDE.md, PROJECT-STATUS.md, CHANGELOG.md, INDEX.md, thoughts/
  - Templates now exclusively in framework-level folders (minimal/, light/, standard/)
  - Guide documents remain at package root
- Updated README.md with comprehensive project overview
- Updated STRUCTURE.md to remove legacy template references

### Previous v2.0.0 Changes

### Added
- **Multi-level framework system** - Minimal, Light, Standard, Enterprise
- **Framework selection guide** (README-TEMPLATE-SELECTION.md) - 3-dimension classification
- **Setup checklists** (NEW-PROJECT-CHECKLIST.md) - All levels with phase-by-phase instructions
- **Upgrade paths** (UPGRADE-PATH.md) - Migration guides between framework levels
- **Structure documentation** (STRUCTURE.md) - Complete template structure reference
- **Research phase templates** (5 templates):
  - PROBLEM-STATEMENT-TEMPLATE.md
  - LANDSCAPE-ANALYSIS-TEMPLATE.md
  - FEASIBILITY-TEMPLATE.md
  - PROJECT-JUSTIFICATION-TEMPLATE.md
  - PROJECT-DEFINITION-TEMPLATE.md
- **Minimal framework template** - 2 files for single scripts
- **Light framework template** - 7 files for small tools
- **Standard framework template** - 50+ files for applications
- WIP limit configuration files (.limit) in kanban folders

### Changed
- **BREAKING:** Reorganized template structure into framework levels (minimal/, light/, standard/)
- **BREAKING:** Root-level templates marked as legacy (deprecated)
- NEW-PROJECT-CHECKLIST.md updated with Phase 0 (framework selection)
- NEW-PROJECT-CHECKLIST.md restructured by framework level
- Version numbering updated to v2.0.0 across core documents

### Fixed
- Template file naming consistency (removed TEMPLATE- prefix from wrappers)
- Documentation cross-references between templates

### Deprecated
- Root-level templates in project-framework-template/ (use level-specific folders instead)

---

## [1.0.0] - 2025-12-18

### Added
- Initial framework template package extracted from HPC Job Queue Prototype
- Core documentation templates:
  - README-TEMPLATE.md
  - PROJECT-STATUS-TEMPLATE.md
  - CHANGELOG-TEMPLATE.md
  - INDEX-TEMPLATE.md
  - CLAUDE-TEMPLATE.md
- Work item templates:
  - FEATURE-TEMPLATE.md
  - BUGFIX-TEMPLATE.md
  - BLOCKER-TEMPLATE.md
  - SPIKE-TEMPLATE.md
- Decision templates:
  - ADR-MAJOR-TEMPLATE.md
  - ADR-MINOR-TEMPLATE.md
- Quick start templates:
  - USER-QUICK-START-TEMPLATE.md
  - ADMIN-QUICK-START-TEMPLATE.md
- CMD wrapper templates (4 variants):
  - WRAPPER.cmd (basic)
  - WRAPPER-ENHANCED.cmd (recommended)
  - WRAPPER-PS7.cmd (PowerShell 7 preferred)
  - WRAPPER-ADMIN.cmd (administrator required)
- Process documentation:
  - kanban-workflow.md
  - version-control-workflow.md
  - documentation-standards.md
- Pattern documentation:
  - powershell-modules.md
  - config-management.md
  - cmd-wrappers.md
- Complete thoughts/ folder structure
- File-based kanban workflow (todo/doing/done)
- WIP limits (doing=1, todo=10)
- Generic CLAUDE.md for framework guidelines
- Project-specific CLAUDE.md template
- README.md for template package
- LICENSE file

### Documentation
- NEW-PROJECT-CHECKLIST.md for greenfield and existing project setup
- Template structure documentation
- Wrapper template README with usage examples

---

## [0.1.0] - 2025-11-25 (Approximate)

### Added
- Initial extraction of framework patterns from HPC project
- Basic template structure
- CMD wrapper patterns
- Process documentation drafts

### Notes
- This version represents the framework as it existed within HPC project before extraction
- Exact date approximate based on HPC project history

---

## Version Strategy

### Framework Versioning
- **Framework version** (this file): Tracks overall framework release version
- **Current framework version:** v2.0.0

### Template Versioning
- Individual templates may track their own versions for significant changes
- Templates inherit framework version unless independently versioned
- Document versions tracked in "Last Updated" field in each file

### Semantic Versioning
- **Major (X.0.0):** Breaking changes, incompatible structure changes
- **Minor (x.Y.0):** New features, templates, or levels added
- **Patch (x.y.Z):** Bug fixes, documentation improvements, clarifications

### Examples
- v1.0.0 → v2.0.0: Multi-level framework system (breaking structure change)
- v2.0.0 → v2.1.0: Added distribution packaging and setup scripts (new features)
- v2.1.0 → v2.1.1: Fixed typos in templates (patch)

---

## Migration Notes

### Upgrading from v1.0.0 to v2.0.0

**Breaking Changes:**
- Template files moved from root to framework-level folders (minimal/, light/, standard/)
- If you copied v1.0.0 templates, they still work but are considered legacy
- NEW-PROJECT-CHECKLIST.md has new Phase 0 for framework selection

**Migration Steps:**
1. If using old templates, continue using them (no forced migration)
2. For new projects, use appropriate framework level folder
3. For existing projects, follow "Existing Project Integration" in NEW-PROJECT-CHECKLIST.md
4. Review UPGRADE-PATH.md for guidance between framework levels

**Recommendation:**
- Existing projects: No immediate action required
- New projects: Use framework-level folders (minimal/, light/, standard/)

---

## Links

- [Framework Repository](https://github.com/spearit-solutions/project-framework) *(if applicable)*
- [Issue Tracker](https://github.com/spearit-solutions/project-framework/issues) *(if applicable)*
- [HPC Job Queue Prototype](../HPCJobQueuePrototype/) *(original source project)*

---

**Maintained by:** Gary Elliott (gary.elliott@spearit.solutions)
**Last Updated:** 2025-12-19

# Changelog - SpearIT Framework (Comprehensive Edition)

All notable changes to the comprehensive edition plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Planned for v1.0.0
- Build script extension and coexistence testing (FEAT-127.4)

---

## [1.0.0-dev3] - 2026-02-16

### Added
- Roadmap command (`/spearit-framework:roadmap`)
  - AI-guided strategic roadmap creation through conversational planning
  - Establishes project themes (stable categories) and planning periods (temporal goals)
  - Adapted from framework fw-roadmap command for standalone plugin use
  - Works in any project structure (with or without project-hub/)
  - Creates ROADMAP.md in project root with comprehensive strategic planning structure

### Changed
- Updated `help.md` - Roadmap now marked as ✅ Available
- All 5 commands now complete and functional

### Notes
- Adapted from `.claude/commands/fw-roadmap.md` (framework command)
- Removed framework-specific dependencies (framework.yaml, project-hub assumptions)
- Simplified for standalone plugin use while preserving strategic planning guidance
- Completes FEAT-127.3 (Roadmap Command)

---

## [1.0.0-dev2] - 2026-02-16

### Added
- Session history command (`/spearit-framework:session-history`)
  - Generates or updates daily session history documents
  - Captures work completed, decisions made, and files modified
  - Append-only principle for historical record keeping
  - Template-based output with placeholder substitution

### Changed
- Updated `help.md` - Session-history now marked as ✅ Available
- Updated session-history command namespace from `-light` to full framework

### Notes
- Session-history command was preserved from early light plugin development (FEAT-118)
- Command and template verified and integrated into full plugin
- Completes FEAT-127.2 (Session History Integration)

---

## [1.0.0-dev1] - 2026-02-16

### Added
- Initial plugin structure and directory layout
- Plugin metadata (plugin.json) with comprehensive edition identity
- Core commands from light edition:
  - `help` - Command reference (updated to list 5 commands)
  - `new` - AI-guided work item planning
  - `move` - Work item workflow transitions
- Skills documentation (3 skills):
  - kanban-workflow.md
  - work-items.md
  - moving-items.md
- Work item templates (4 templates):
  - FEAT-template.md
  - BUG-template.md
  - CHORE-template.md
  - session-history-template.md (preserved from early development)
- README.md with comprehensive edition positioning
- Feature comparison table (light vs comprehensive)

### Preserved
- Session history command (from FEAT-118 early development)
- Session history template

### Coming Soon
- `/spearit-framework:session-history` - Session documentation (v1.0.0)
- `/spearit-framework:roadmap` - AI-guided roadmap planning (v1.0.0)

### Notes
- This is the foundation release (FEAT-127.1)
- Session-history and roadmap commands marked as "coming soon" in help
- Plugin can coexist with spearit-framework-light (different namespaces)

---

## Development History

**Parent Work Item:** FEAT-127 - Full Framework Plugin

**Child Work Items:**
- FEAT-127.1 - Structure & Core Commands (this release)
- FEAT-127.2 - Session History Integration (next)
- FEAT-127.3 - Roadmap Command (next)
- FEAT-127.4 - Build & Testing (final)

**Reference Implementation:**
- Based on spearit-framework-light v1.0.0 (shipped 2026-02-13)
- Inherits optimizations from TECH-135 (move command performance)

---

**Last Updated:** 2026-02-16

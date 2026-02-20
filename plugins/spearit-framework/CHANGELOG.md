# Changelog - SpearIT Framework (Comprehensive Edition)

All notable changes to the comprehensive edition plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0-dev3] - 2026-02-19

### Added
- Roadmap command (`/spearit-framework:roadmap`)
  - AI-guided strategic roadmap creation through conversational planning
  - Establishes project themes (stable categories) and planning periods (temporal goals)
  - Adapted from framework fw-roadmap command for standalone plugin use
  - Works in any project structure (with or without project-hub/)
  - Creates ROADMAP.md in project root with comprehensive strategic planning structure
- **FEAT-141: Batch Move Support**
  - Move multiple items via comma-separated IDs (e.g., `move 140,141 done`)
  - Supports full IDs, bare numbers, and mixed formats
  - Per-item skip-and-continue error handling (not-found, already-in-target, invalid transition)
  - WIP limit checked once before batch, not per item
  - Backwards compatible — single-item syntax unchanged
- **FEAT-143: Blocked state support in move command**
  - Move items to/from `blocked/` folder for external dependency tracking

### Changed
- Updated `help.md` - Roadmap now marked as ✅ Available
- All 5 commands now complete and functional
- **FEAT-141: Move command script consolidation**
  - Single consolidated script replaces per-target scripts (80% code reduction)
  - File matching now uses numeric ID only (strips FEAT-/BUG-/CHORE- prefix)
  - Added `cd "$(git rev-parse --show-toplevel)"` to fix CWD assumption bug
  - `find | grep -E` pipeline replaces `find -iname` for cleaner regex matching
  - `|| true` guards on all grep pipelines prevent pipefail abort on empty results

### Fixed
- **BUG-140: Child item detection**
  - Fixed inverted grep filter causing dotted IDs (e.g., FEAT-127.4) to fail move detection
- **Pipefail bug in untracked file fallback**
  - `elif ! git ls-files ...` silently aborted inside `set -uo pipefail` context
  - Fixed by assigning result to explicit `is_tracked` variable using `&& ... || ...` pattern

### Notes
- Roadmap adapted from `.claude/commands/fw-roadmap.md` (framework command)
- Removed framework-specific dependencies (framework.yaml, project-hub assumptions)
- Production build verified via `Build-Plugin.ps1 -Plugin spearit-framework`
- Verified coexistence with spearit-framework-light (no conflicts)

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

### Notes
- Foundation release (FEAT-127.1)
- Plugin can coexist with spearit-framework-light (different namespaces)

---

**Last Updated:** 2026-02-19

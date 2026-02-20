# Changelog

All notable changes to the SpearIT Project Framework - Lightweight Edition plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.4] - 2026-02-19

### Fixed

- **FEAT-141/SPIKE-142: Pipefail bug in untracked file fallback**
  - `elif ! git ls-files ...` silently aborted inside `set -uo pipefail` context
  - Fixed by assigning result to explicit `is_tracked` variable using `&& ... || ...` pattern

---

## [1.0.3] - 2026-02-18

### Changed

- **FEAT-141: Move command script consolidation**
  - Single consolidated script replaces 5 per-target scripts (80% code reduction)
  - File matching now uses numeric ID only (strips FEAT-/BUG-/CHORE- prefix) — `feat-141`, `FEAT-141`, and `141` all resolve identically
  - Added `cd "$(git rev-parse --show-toplevel)"` to fix CWD assumption bug
  - `find | grep -E` pipeline replaces `find -iname` for cleaner regex matching
  - `|| true` guards on all grep pipelines prevent pipefail abort on empty results

---

## [1.0.2] - 2026-02-17

### Added

- **FEAT-141: Batch Move Support**
  - Move multiple items in one command via comma-separated IDs (e.g., `move 140,141 done`)
  - Supports full IDs, bare numbers, and mixed formats
  - Per-item skip-and-continue error handling (not-found, already-in-target, invalid transition)
  - WIP limit checked once before batch, not per item
  - Backwards compatible — single-item syntax unchanged

### Fixed

- **BUG-140: Child item detection** (applied during FEAT-141 implementation)
  - Fixed inverted grep filter causing dotted IDs (e.g., FEAT-127.4) to fail move detection

---

## [1.0.0] - 2026-02-12

### Added
- `/spearit-framework-light:help` - Command reference and documentation
- `/spearit-framework-light:new` - Create work items with auto-assigned IDs
- `/spearit-framework-light:move` - Move work items through workflow with policy enforcement
- AI-driven ID assignment (scans existing work items automatically)
- Work item templates (FEAT, BUG, CHORE)
- Skills documentation for AI collaboration
- WIP limit enforcement
- Transition validation and workflow policies
- Dependency checking
- MIT License

### Changed
- **MVP Scope Refinement** (2026-02-12 pre-release):
  - Focused on 3 core commands for cleaner user experience
  - Integrated ID assignment into `new` command (users don't need to think about IDs)
  - Deferred session-history to full framework plugin (documentation feature, not core workflow)

### Removed
- **session-history command** - Deferred to full framework plugin
  - Reason: Documentation feature, not core workflow
  - Status: Preserved in `plugins/spearit-framework/` for future release
- **next-id command** - Integrated into `new` command
  - Reason: Implementation detail should not be user-facing
  - Functionality: Now handled automatically by `new` command

### Technical
- Standalone plugin model (no external script dependencies)
- AI-driven file scanning using Glob tool
- Self-contained command logic
- Graceful degradation (works with or without project structure)

---

## Product Philosophy

This lightweight plugin delivers the minimum viable workflow:
1. **Discover** what's available (`help`)
2. **Create** work items with zero friction (`new` with auto-ID)
3. **Organize** work through states (`move` with policy enforcement)

Future features (status, backlog management, session history, roadmap planning) will be available in the full framework plugin.

---

## Migration Notes

If upgrading from development versions with 5 commands:
- `/spearit-framework-light:next-id` → Use `/spearit-framework-light:new` (IDs assigned automatically)
- `/spearit-framework-light:session-history` → Will be available in full framework plugin

---

**Maintained by:** Gary Elliott / SpearIT Solutions
**License:** MIT
**Repository:** https://github.com/SpearIT-LLC/project-framework

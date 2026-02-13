# Changelog

All notable changes to the SpearIT Project Framework - Lightweight Edition plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

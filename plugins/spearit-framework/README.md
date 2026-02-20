# SpearIT Project Framework - Comprehensive Edition

Complete project management suite for power users. This plugin includes all framework features as Claude Code commands, building on the lightweight edition with advanced capabilities.

---

## Overview

The **SpearIT Project Framework - Comprehensive Edition** provides a complete project management toolset integrated directly into Claude Code. Perfect for power users who need the full framework feature set.

**What's included:**
- ✅ Core workflow commands (help, new, move)
- ✅ Session tracking (session-history)
- ✅ Strategic planning (roadmap)

---

## Installation

**Requirements:**
- Claude Code (VSCode extension or CLI)
- Local dev-marketplace configured (for development)

**Install from dev marketplace:**
```
/plugin install spearit-framework@dev-marketplace
```

---

## Commands (5 Total)

### Core Workflow
- **`/spearit-framework:help`** - Command reference and help
- **`/spearit-framework:new`** - AI-guided work item planning with interactive breakdown
- **`/spearit-framework:move`** - Move work items through workflow with policy enforcement

### Advanced Features
- **`/spearit-framework:session-history`** - Document work sessions with structured templates ✅
- **`/spearit-framework:roadmap`** - AI-guided roadmap planning and strategic organization ✅

---

## Upgrading from Light Edition

**Can both plugins coexist?** Yes! Different namespaces prevent conflicts:
- Light edition: `/spearit-framework-light:*`
- Comprehensive edition: `/spearit-framework:*`

**When to upgrade:**
- You need session history tracking
- You want AI-guided roadmap planning
- You're ready for the complete feature set

**Migration:** No migration needed - both plugins work independently with the same project-hub/ structure.

---

## Feature Comparison

| Feature | Light Edition | Comprehensive Edition |
|---------|---------------|----------------------|
| Help command | ✅ | ✅ |
| Create work items (`new`) | ✅ | ✅ |
| Move items (`move`) | ✅ | ✅ |
| Session history | ❌ | ✅ |
| Roadmap planning | ❌ | ✅ |
| Command count | 3 | 5 |
| Namespace | `spearit-framework-light` | `spearit-framework` |

**Deferred to v1.1+:**
- Status summary (`status`)
- Work in progress (`wip`)
- Backlog review (`backlog`)
- Topic index (`topic-index`)

---

## Quick Start

1. **Install the plugin:**
   ```
   /plugin install spearit-framework@dev-marketplace
   ```

2. **See available commands:**
   ```
   /spearit-framework:help
   ```

3. **Create your first work item:**
   ```
   /spearit-framework:new
   ```

4. **Move items through workflow:**
   ```
   /spearit-framework:move FEAT-001 doing
   ```

---

## Documentation

**Skills (Background Knowledge):**
- [kanban-workflow.md](skills/kanban-workflow.md) - Understanding the Kanban workflow
- [work-items.md](skills/work-items.md) - Work item types and structure
- [moving-items.md](skills/moving-items.md) - Workflow transitions and policies

**Templates:**
- [FEAT-template.md](templates/FEAT-template.md) - Feature work items
- [BUG-template.md](templates/BUG-template.md) - Bug work items
- [CHORE-template.md](templates/CHORE-template.md) - Chore/maintenance work items
- [session-history-template.md](templates/session-history-template.md) - Session history

---

## Status

**Current release:** Pre-release (development) — see [CHANGELOG.md](CHANGELOG.md) for version history.

**Planned for v1.1+:** Additional commands based on feedback (status, wip, backlog, topic-index)

---

## About

**Plugin Namespace:** `spearit-framework`
**Author:** Gary Elliott / SpearIT Solutions
**License:** MIT
**Framework Version:** Compatible with SpearIT Project Framework v1.0+

**Related Work:**
- Light Edition: `spearit-framework-light` (3 commands, quick onboarding)
- Full Framework: See [framework/](../../framework/) for complete documentation

---

## Support & Feedback

**Issues:** Report at the framework repository
**Documentation:** See framework docs for detailed process guides
**Changelog:** See [CHANGELOG.md](CHANGELOG.md) for version history

---

**Last Updated:** 2026-02-19

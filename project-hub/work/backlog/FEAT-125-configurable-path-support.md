# Feature: Add Configurable Path Support to Plugin Commands

**ID:** FEAT-125
**Type:** Feature
**Priority:** Medium
**Created:** 2026-02-11

---

## Summary

Enable plugin commands to use custom directory structures instead of hardcoded `project-hub/` paths. Users with existing project structures (`.work/`, `docs/work-items/`, etc.) should not be forced to adopt framework-standard paths, creating duplicate or conflicting directory structures.

---

## Problem Statement

Plugin commands currently hardcode paths to `project-hub/work/` and `project-hub/history/sessions/`, which creates UX problems for users with different organizational preferences.

**Context:**
While developing the SpearIT Framework Light plugin, we discovered that commands like `/new` and `/session-history` force users into a specific directory structure. Users who prefer `.work/` or `docs/items/` have no way to configure this, leading to:
1. Unwanted directory creation
2. Duplicate competing structures in the same project
3. Repeated prompts to "fix" non-standard structures

**Impact:**
- **Users with custom structures**: Frustrated by forced conventions
- **Non-framework projects**: May prefer lighter-weight folder organization
- **Framework projects**: Standard paths work fine (no impact)

**When this matters:**
- Plugin is used outside framework projects
- Users have established conventions they want to preserve
- Projects have multiple tools/plugins with different expectations

---

## Requirements

**Affected Commands:**
ALL plugin commands with hardcoded default paths:
- `/new` - Creates work items in `project-hub/work/backlog/`
- `/move` - Moves between workflow folders (`backlog/`, `todo/`, `doing/`, `done/`)
- `/session-history` - Saves to `project-hub/history/sessions/`
- Future commands that interact with file structure

**Must Have:**
- Respect user's preferred directory structure
- Never badger users about "incorrect" paths
- Maintain backward compatibility with existing projects
- Default to `project-hub/` when no preference specified

**Out of Scope (for first implementation):**
- Migration tools for moving existing structures
- Multi-project configuration sharing
- Cloud-synced preferences

---

## Proposed Solution

**Three approaches considered - defer decision to implementation:**

### Option A: Configuration File (Most Flexible)

Support `.claude/settings.local.json` or similar:

```json
{
  "plugins": {
    "spearit-framework-light": {
      "paths": {
        "work": {
          "backlog": ".work/backlog",
          "todo": ".work/todo",
          "doing": ".work/doing",
          "done": ".work/done"
        },
        "history": {
          "sessions": ".sessions"
        }
      }
    }
  }
}
```

**Pros:**
- Explicit user control
- Portable configuration
- Clear override mechanism

**Cons:**
- Requires settings management
- Manual configuration needed
- More complex to implement

---

### Option B: Smart Discovery (Auto-detect)

Automatically detect existing structure:

**Algorithm:**
1. Search for existing work items (`**/backlog/*.md`, `**/doing/*.md`)
2. Infer structure from what exists
3. If multiple structures found → ask user once, remember choice
4. If no structure found → ask user preference, create chosen structure

**Pros:**
- Zero configuration for most users
- Works with any existing structure
- Intelligent adaptation

**Cons:**
- Discovery logic can be tricky
- Ambiguous when multiple structures exist
- May make wrong inference

---

### Option C: Common Root Variable (Simplest)

User's preferred approach from discussion:

```
$ProjectHubRoot = "project-hub" (default)

Derived paths:
  work     = $ProjectHubRoot/work
  history  = $ProjectHubRoot/history
  sessions = $ProjectHubRoot/history/sessions
  backlog  = $ProjectHubRoot/work/backlog
  todo     = $ProjectHubRoot/work/todo
  doing    = $ProjectHubRoot/work/doing
  done     = $ProjectHubRoot/work/done
```

**Configuration example:**
```json
{
  "plugins": {
    "spearit-framework-light": {
      "projectHubRoot": ".work"
    }
  }
}
```

**Results in:**
```
.work/
├── work/
│   ├── backlog/
│   ├── todo/
│   ├── doing/
│   └── done/
└── history/
    └── sessions/
```

**Pros:**
- Simple to implement
- Single configuration value
- Maintains relative structure
- Easy to understand

**Cons:**
- Less flexible than Option A (can't customize individual folders)
- Still requires subfolder structure (`work/`, `history/`)
- Doesn't support completely custom layouts

---

### Hybrid Approach (Recommended for Discussion)

**Priority order for path resolution:**

1. **Check `.claude/settings.local.json`** for explicit user configuration
2. **Check `framework.yaml`** for framework-defined paths (if framework project)
3. **Smart discovery** of existing work items → infer structure
4. **Ask user once** if nothing found → save preference
5. **Default** to `project-hub/` (framework standard)

This combines flexibility (explicit config) with intelligence (discovery) and good defaults.

---

## Technical Approach

**Path Discovery Module:**
```typescript
interface PathConfig {
  workRoot: string;      // Base path for work items
  historyRoot: string;   // Base path for history
  backlog: string;       // Calculated or explicit
  todo: string;
  doing: string;
  done: string;
  sessions: string;
}

function discoverPaths(): PathConfig {
  // 1. Check settings
  // 2. Check framework.yaml
  // 3. Search for existing items
  // 4. Use defaults
}
```

**Commands update:**
- Replace hardcoded paths with `discoverPaths()` calls
- Cache discovered paths per session
- Update documentation with configuration examples

---

## Acceptance Criteria

- [ ] Plugin respects custom path configuration when provided
- [ ] Defaults to `project-hub/` when no configuration exists
- [ ] Never creates unwanted duplicate directory structures
- [ ] Configuration is project-specific (`.claude/settings.local.json`)
- [ ] All path-using commands (`/new`, `/move`, `/session-history`) use discovered paths
- [ ] Documentation explains configuration options
- [ ] Backward compatible with existing projects using default paths

---

## Implementation Notes

**Phase 1 (MVP):**
- Implement Option C (common root variable)
- Read from `.claude/settings.local.json`
- Default to `project-hub/`
- Update `/new` and `/session-history` commands

**Phase 2 (Enhanced):**
- Add smart discovery
- Support framework.yaml integration
- Extend to all path-using commands

**Phase 3 (Full flexibility):**
- Implement Option A (per-folder configuration)
- Migration tooling
- Multi-project templates

**Dependencies:**
- Requires settings management in plugin
- May need Claude Code SDK updates for settings access

---

## Questions / Open Issues

**For implementation:**
1. Should we support both Option A (full control) and Option C (common root)?
2. How do we handle migration from hardcoded paths to configurable paths?
3. Should discovery be one-time (ask once) or continuous (re-check each session)?
4. What's the best UX for asking user preference when structure doesn't exist?
5. Should we validate that configured paths exist before using them?

**For design:**
1. Is `.claude/settings.local.json` the right place for this config?
2. Should framework.yaml override user settings or vice versa?
3. How do we handle conflicting configurations (user vs framework)?

**Related work:**
- FEAT-118: Claude Code plugin (parent work item)
- Framework path standardization discussions

---

**Last Updated:** 2026-02-11
**Status:** Backlog

# Session History: 2026-02-20

**Date:** 2026-02-20
**Participants:** User, Claude Code
**Session Focus:** Roadmap review, FEAT-137 backlog planning, plugin cache investigation

---

## Summary

Short session resuming from yesterday's releases. Reviewed roadmap progress against PI MVP success criteria, identified the critical path (FEAT-137 / `/swarm` command), moved FEAT-137 to todo, and investigated an apparent move command regression that turned out to be a cached plugin version issue.

---

## Work Completed

### Roadmap Review

- Assessed PI MVP progress against 5 success criteria
- Foundation work complete (plugins shipped, workflow solid)
- Primary value delivery not yet started: `/swarm` command (FEAT-137) and marketplace submission
- Critical path identified: FEAT-137 → marketplace submission for both plugins

### FEAT-137 → todo/

- Moved FEAT-137 (Plugin Project Guidance Commands) from backlog to todo
- `/spearit-framework:move` command failed due to cached plugin version issue (see Decisions)
- Moved manually via `git mv`

### Plugin Cache Investigation

- `/spearit-framework:move` skill loaded into session contained old `grep -v "\."` script — identical to the pattern fixed in BUG-140
- Confirmed plugin source files (`plugins/spearit-framework/commands/move.md`) use the correct `grep -iE` pattern
- Root cause: dev-marketplace cache contains pre-BUG-140-fix version of the plugin
- Resolution: update dev-marketplace (`Publish-ToLocalMarketplace.ps1 -Build` + `/plugin marketplace update dev-marketplace` + VSCode restart)

---

## Decisions Made

1. **Plugin cache predates BUG-140 fix:** The installed plugin in this VSCode session was built before the move command fix was applied. The source is correct; the cache is stale. No code changes needed — marketplace update sufficient.

2. **FEAT-137 is the PI MVP critical path item:** Everything else (marketplace submission, full plugin positioning, reporting in swarm context) depends on the `/swarm` command existing first.

---

## Files Moved

- `project-hub/work/backlog/FEAT-137-plugin-project-guidance-commands.md` → `project-hub/work/todo/`

---

## Current State

### In todo/
- FEAT-092 (sprint support)
- FEAT-137 (plugin project guidance commands — `/swarm`)

### In doing/
- *(none)*

### In blocked/
- BUG-144 (Anthropic namespace collision bug — issue #26906; check back by 2026-02-22)

---

## Continuation Session (Afternoon)

### Plugin Cache Investigation - Continued

- Moved FEAT-137 to `doing/` (again via manual script due to same cache issue)
- Conducted deeper audit of the cache vs. source state
- Confirmed `grep -v "\."` bug isolated to `move.md` only — no other commands (`new`, `session-history`, `roadmap`, `help`) use file-find logic
- Identified full version misalignment across three sources:

| Source | spearit-framework | spearit-framework-light |
|--------|-------------------|-------------------------|
| marketplace.json | `1.0.0-dev3` ✅ | `1.0.0` ❌ (stale) |
| plugin.json (junction) | `1.0.0-dev3` ✅ | `1.0.4` ✅ |
| installed_plugins.json | `1.0.0-dev2` ❌ | `1.0.3` ❌ |

- Root cause: versions were published out of order (dev suffixes mixed with semver releases), leaving the cache pinned to old versions while the marketplace junction was updated separately

### Fix Applied

- Updated `marketplace.json` → set `spearit-framework-light` to `1.0.4`
- Pending: run `/plugin marketplace update dev-marketplace` + VSCode restart to push cache to current versions

### FEAT-137 Pre-Implementation Review

- Reviewed work item in `doing/`
- No open questions, no unmet dependencies
- Ready to implement: 3 new command files (`status.md`, `backlog.md`, `plan.md`) + `help.md` update + plugin v1.1.0 bump

---

## Continuation Session (Later Afternoon) — Publish-ToLocalMarketplace Refactor

### Context

Continued investigating the plugin cache problem. The root cause was that
`installed_plugins.json` pointed to stale cached versions even after running
`/plugin marketplace update dev-marketplace`. Decided to fix the tooling to
prevent this class of problem recurring.

### Plugin Cache — Full Flush

- Manually reset `installed_plugins.json` to `{}` (empty plugins)
- Identified 10 stale version folders accumulated in `~/.claude/plugins/cache/dev-marketplace/`
- Root cause of accumulation: each publish created a new versioned folder; the update
  command never cleaned old ones, and `installed_plugins.json` stayed pinned to whatever
  version was first installed

### Publish-ToLocalMarketplace.ps1 Refactor

Significant rethink of the script's purpose and scope through a series of design decisions:

**Decision 1: `-Clean` should always purge the Claude cache too**
- Original: `-Clean` only wiped the marketplace directory
- Changed: `-Clean` now also deletes `~/.claude/plugins/cache/dev-marketplace/` and
  removes dev-marketplace entries from `installed_plugins.json`
- Rationale: the two are inseparable — cleaning one without the other is what caused
  the stale cache problem

**Decision 2: `-Plugin` scoping on `-Clean` is unnecessary complexity**
- Initially added per-plugin clean logic (clean only one plugin's cache/junction)
- Reversed: clean is always full wipe, regardless of `-Plugin`
- Rationale: partial clean leaves the other plugin's stale state intact, which can
  still interfere; full clean is always safe

**Decision 3: `-Build` doesn't belong in this script**
- `Build-Plugin.ps1` is a separate script for release preparation
- The marketplace uses junctions pointing at source files — no build needed for testing
- Rationale: junctions mean source changes are live immediately; `-Build` was solving
  a problem that doesn't exist in the testing workflow

**Decision 4: No parameters needed at all**
- Since clean is always full and build is never needed for testing, the script has
  one job: reset the env and republish all plugins
- Running without arguments is now the correct and only invocation

**Bug fixes applied during review:**
- `Remove-Item -Recurse` on junction would follow the junction and delete actual plugin
  source files — replaced with `[System.IO.Directory]::Delete()` (removes junction only)
- Strict mode null guard: added `| Where-Object { $_ }` when reading existing
  marketplace entries to prevent throw on null plugins array

### Finalized Testing Workflow

```
Loop until satisfied:
  1. .\tools\Publish-ToLocalMarketplace.ps1   ← reset + republish
  2. /plugin marketplace update dev-marketplace
  3. Restart Claude Code
  4. Test

When done:
  5. Bump version in plugin.json
  6. .\tools\Build-Plugin.ps1
  7. Upload to GitHub (self-publish)
  8. Submit to Anthropic (marketplace publish)
```

Key insight: steps 1-4 loop as a unit. Step 1 alone isn't sufficient — Claude
needs the marketplace update + restart to pick up cache changes.

### Documentation Updates (End of Session)

After finalizing the script, updated documentation to match:

- **`plugins/TESTING.md`** — Full rewrite. Now focused purely on *how* to test:
  dev loop, CLI testing, one-time setup, release workflow, checklist, troubleshooting.
  All references to old `-Clean`/`-Build`/`-Plugin` flags removed.

- **`project-hub/research/plugin-testing-summary.md`** — Appended dated update section
  explaining the cache accumulation root cause, what changed in the script, and the
  revised understanding of the cache eviction model. Original content preserved per
  append-only principle.

**Separation of concerns established:**
- Research doc = *what* the system does and *why* (architecture, findings, history)
- TESTING.md = *how* to use it (current workflow, scripts, steps)

---

**Last Updated:** 2026-02-20

# Feature: claude-project.yaml - Project-Agnostic Context Config

**ID:** FEAT-139
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-02-17
**Theme:** Project Guidance
**Planning Period:** v1.3

**Depends On:** FEAT-137 (Project Guidance Commands)

---

## Summary

Define a lightweight `claude-project.yaml` (or `.spearit.yaml`) configuration file that gives Claude a single, predictable place to find project conventions — where work items live, where sessions are stored, what the project is called, etc. This makes plugin commands work in any project structure, not just the SpearIT framework.

---

## Problem Statement

**What problem does this solve?**

The plugin commands currently assume the SpearIT framework directory structure (`project-hub/work/`, session files in `project-hub/history/`, etc.). Any user without that exact structure gets a degraded or broken experience. Claude has to guess or ask — inconsistent and slow.

A config file gives Claude a single source of truth for project conventions, analogous to what `framework.yaml` does in the framework repo.

**Who is affected?**

Anyone using the `spearit-framework` plugin on a project that doesn't use the full SpearIT framework structure — which is most potential marketplace users.

**Current workaround (if any):**

Users either adopt the full framework structure, or the commands partially fail. No graceful fallback exists.

---

## Proposed Solution

### Config File: `claude-project.yaml`

A lightweight YAML file at the project root (or `.claude/`) that Claude reads at command invocation time.

**Minimal viable schema:**

```yaml
# claude-project.yaml
project:
  name: "My Project"
  description: "What this project does"

structure:
  work_items: "project-hub/work"        # Where kanban folders live
  sessions: "project-hub/history"       # Where session history goes
  roadmap: "ROADMAP.md"                 # Roadmap file location
  backlog: "project-hub/work/backlog"   # Explicit backlog path (optional override)

conventions:
  item_id_prefix: true      # Use typed IDs (FEAT-, BUG-, etc.)
  wip_limits: true          # Respect .limit files
```

**Fallback behavior:**
- If `claude-project.yaml` not found → try `framework.yaml` (existing framework projects)
- If neither found → use SpearIT framework defaults
- If defaults don't match reality → command reports what it found and asks user to confirm

### Discovery Order

```
1. claude-project.yaml (project root)
2. .claude/claude-project.yaml
3. framework.yaml (legacy/framework projects)
4. SpearIT defaults (project-hub/work/ structure)
```

---

## Requirements

### Functional Requirements

- [ ] Define `claude-project.yaml` schema (documented in plugin README and skills)
- [ ] Plugin commands read config file at invocation if present
- [ ] Graceful fallback to framework.yaml, then defaults
- [ ] `status` command uses config paths instead of hardcoded paths
- [ ] `backlog` command uses config paths instead of hardcoded paths
- [ ] `session-history` command uses config session path
- [ ] `roadmap` command uses config roadmap path
- [ ] Schema documented in plugin README.md

### Non-Functional Requirements

- [ ] Config file is optional — existing framework projects continue to work unchanged
- [ ] Schema is minimal — don't over-engineer for hypothetical future fields
- [ ] Human-readable — YAML, not JSON

---

## Design

### Implementation Approach

Each command that reads project structure gets a preamble:

```markdown
## Project Context

Before executing, check for project configuration:
1. Read `claude-project.yaml` if present
2. Fall back to `framework.yaml` if present
3. Otherwise use defaults: work items at `project-hub/work/`

Use the resolved paths for all file operations in this command.
```

This is added to the command markdown files — no code changes required, pure instruction-layer configuration.

### Files to Update

- `plugins/spearit-framework/commands/status.md` — add config discovery preamble
- `plugins/spearit-framework/commands/backlog.md` — add config discovery preamble
- `plugins/spearit-framework/commands/plan.md` — add config discovery preamble
- `plugins/spearit-framework/commands/session-history.md` — add config discovery preamble
- `plugins/spearit-framework/commands/roadmap.md` — add config discovery preamble
- `plugins/spearit-framework/README.md` — document claude-project.yaml schema
- `plugins/spearit-framework/CHANGELOG.md` — v1.3 entry
- `plugins/spearit-framework/.claude-plugin/plugin.json` — bump to v1.3.0

### Files to Add

- `templates/claude-project.yaml` — starter template for new projects (in plugin templates/)

---

## Dependencies

**Requires:**
- FEAT-137 (Project Guidance Commands) — commands must exist before making them config-aware

**Blocks:**
- Future passive skill work — passive skills need project context to interject intelligently

**Related:**
- FEAT-137 — Project Guidance Commands
- FEAT-138 — Developer Guidance Commands (also benefits from config awareness)
- `framework.yaml` — existing schema this should be compatible with

---

## Acceptance Criteria

- [ ] `claude-project.yaml` schema defined and documented
- [ ] All project-path-dependent commands updated with config discovery
- [ ] Tested on a project WITHOUT framework structure (custom paths)
- [ ] Tested on existing framework project (no regression)
- [ ] Starter template included in plugin
- [ ] Plugin version bumped to 1.3.0 and rebuilt

---

## Notes

**Why not just extend framework.yaml?**

`framework.yaml` is the framework's config — it carries framework-specific semantics and assumptions. `claude-project.yaml` is the plugin's config — lighter, simpler, user-facing. They can coexist and the plugin can read both (framework.yaml as a fallback).

**Schema discipline:**
Start minimal. Don't add fields speculatively. Every field in the schema should be consumed by an existing command. Add fields when commands need them, not before.

**Future: passive skills need this.**
A passive skill that interjects intelligently ("before you write code, have you reviewed the schema?") needs to know where the project's relevant files live. This config is the prerequisite for ambient guidance.

---

**Last Updated:** 2026-02-17

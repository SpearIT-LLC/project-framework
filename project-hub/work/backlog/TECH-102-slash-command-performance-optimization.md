# TECH-102: Slash Command Performance Optimization

**ID:** TECH-102
**Type:** Tech Debt
**Priority:** Low
**Version Impact:** PATCH
**Created:** 2026-01-21
**Theme:** Workflow
**Planning Period:** Sprint WF 2

---

## Summary

Investigate and implement performance improvements for `/fw-*` slash commands, balancing user experience (speed) against token efficiency.

## Status

- **Status:** Backlog

## Context

Discussion during FEAT-031 identified that `/fw-*` commands have performance characteristics worth optimizing. Current implementation uses PowerShell scripts which provide token efficiency but have startup overhead.

## Current State

- Commands call PowerShell scripts via `Bash` tool
- Scripts parse files (YAML, markdown) and return compact output
- Token-efficient: scripts return aggregated results vs raw file contents
- User experience: noticeable delay from PowerShell startup time

## Options Explored

### 1. Claude Reads Files Directly (Rejected)
- Eliminates script startup overhead
- **Downside:** 2-4x more tokens per command
- `/fw-next-id` worst case: scans 50+ files to return one number

### 2. Lighter Runtime
- Replace PowerShell with faster interpreter (Python, Node, compiled binary)
- **Concern:** Adds/shifts prerequisite dependencies

### 3. Pre-compiled Cache/Index
- Generate JSON cache updated when source files change
- Scripts read cache instead of parsing
- Could be git hook or manual refresh

### 4. MCP Server (Future)
- Persistent process holds parsed data in memory
- First call has startup cost, subsequent calls instant
- Different integration model

## Recommendation

Keep scripts for token efficiency. Consider:

1. **Startup optimization:** Profile PowerShell scripts, minimize module loads
2. **Caching:** Add JSON cache for expensive operations (e.g., topic index)
3. **Lazy loading:** Only load `powershell-yaml` when needed

## Affected Commands

| Command | Current Script | Notes |
|---------|---------------|-------|
| `/fw-index` | `Get-FrameworkIndex.ps1` | Parses YAML, needs `powershell-yaml` |
| `/fw-status` | `Get-WorkflowStatus.ps1` | Counts files, reads PROJECT-STATUS.md |
| `/fw-wip` | `Get-WorkflowStatus.ps1 -Current` | Lists doing/ folder |
| `/fw-next-id` | `Get-NextWorkItemId.ps1` | Scans all work items |
| `/fw-move` | None (logic in instructions) | Uses `git mv` |
| `/fw-backlog` | None | Could benefit from script |
| `/fw-session-history` | None | Writes files directly |
| `/fw-help` | None | Reads `.md` files |

## Acceptance Criteria

- [ ] Measurable improvement in command response time
- [ ] No increase in token usage per command
- [ ] No new required dependencies (optional dependencies OK)
- [ ] Scripts remain usable outside Claude Code

## Related

- FEAT-031: Index source of truth registry (introduced `/fw-index`)
- `powershell-yaml` module dependency

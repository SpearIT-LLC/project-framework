# Session History: 2026-02-21

**Date:** 2026-02-21
**Participants:** Gary Elliott, Claude Code
**Session Focus:** FEAT-137 — Plugin Project Guidance Commands (status + backlog)

---

## Summary

Designed and implemented the `status` and `backlog` guidance commands for the `spearit-framework` full plugin. Scoped `preflight` (formerly `plan`) out into its own work item (FEAT-148) after a naming and design discussion. Updated FEAT-137 to reflect actual scope and progress.

---

## Work Completed

### FEAT-137: Plugin - Project Guidance Commands

- Moved FEAT-137 from todo/ to doing/ (WIP limit exceeded — now 3/2, noted)
- Wrote `plugins/spearit-framework/commands/status.md` — self-contained bash script + AI synthesis, ports `fw-status` logic without PowerShell dependency; Role: Project Health Monitor
- Wrote `plugins/spearit-framework/commands/backlog.md` — self-contained bash script + AI synthesis, ports `fw-backlog` logic; subcommands: `full`, `detail <id>`, `prioritize`; Role: Discerning Project Manager; no internal move coupling — directs user to `/spearit-framework:move <id> todo`
- Updated `plugins/spearit-framework/commands/help.md` — 8 commands listed (was 6)
- Updated FEAT-137 work item to reflect actual scope, completed requirements, and remaining work

### FEAT-148: Plugin - Preflight Command (new work item created)

- Created `project-hub/work/backlog/FEAT-148-plugin-preflight-command.md`
- Scoped out from FEAT-137 due to distinct design (no script, different role/mindset) and naming decision
- Naming considered: `plan`, `review`, `review-work-item`, `inspect`, `brief`, `preflight` — settled on `preflight` (aviation metaphor: safety check before takeoff)

---

## Decisions Made

1. **`status` and `backlog` are ports, not net-new:**
   - These commands replicate `fw-status` and `fw-backlog` behavior for the plugin, rewritten as self-contained markdown command files with embedded bash scripts instead of PowerShell
   - Rationale: plugin commands must be self-contained; no external script dependencies

2. **`backlog` does not call `/move` internally:**
   - Backlog command surfaces pull candidates and tells the user which move command to run — no internal coupling to the move command
   - Rationale: simpler, no command-to-command dependency, move is already a dedicated command

3. **`preflight` scoped to FEAT-148:**
   - Originally `plan` in FEAT-137 spec; renamed and extracted after recognizing it has a distinct design (no bash script needed, pure AI read + analysis) and the naming warranted its own decision conversation
   - Rationale: keeps FEAT-137 focused on porting fw-status/fw-backlog; FEAT-148 can be designed cleanly without rushing

4. **Command naming: `preflight` over `plan`, `review`, `inspect`:**
   - `plan` clashes with roadmap/swarm (those create plans; this is a check before acting)
   - `preflight` is distinct, memorable, and accurate — aviation metaphor maps well to "before you take off, confirm everything is ready"

---

## Files Created

- `plugins/spearit-framework/commands/kanban-state.md` — New plugin command: project kanban state (renamed from status.md)
- `plugins/spearit-framework/commands/backlog.md` — New plugin command: backlog review and prioritization
- `project-hub/work/backlog/FEAT-148-plugin-preflight-command.md` — New work item for preflight command

## Files Modified

- `plugins/spearit-framework/commands/help.md` — Updated to 8 commands (added kanban-state, backlog); fixed /fw-help hallucination with explicit prohibition
- `project-hub/work/doing/FEAT-137-plugin-project-guidance-commands.md` — Updated scope, requirements, design, acceptance criteria, and notes to reflect session decisions

## Files Moved (Later)

- `project-hub/work/todo/FEAT-137-plugin-project-guidance-commands.md` → `project-hub/work/doing/`
- `plugins/spearit-framework/commands/status.md` → `plugins/spearit-framework/commands/kanban-state.md` (renamed)

---

## Current State

### In done/ (awaiting release)
- None

### In doing/
- FEAT-137: Plugin - Project Guidance Commands (status + backlog written; CHANGELOG + version bump remaining)
- FEAT-146: Swarm Command Implementation

---

## Decisions Made (Later)

5. **`status` command renamed to `kanban-state`:**
   - `/spearit-framework:status` risked confusion with Anthropic's built-in status concept
   - Alternatives considered: `kanban-status`, `kanban-state`, `workflow`, `workflow-status`, `project-health`
   - Settled on `kanban-state` — unambiguous, matches the mental model (reading the board), distinct from anything Anthropic ships

6. **Role renamed from "Project Health Monitor" to "Kanban Board Reader":**
   - "Project Health Monitor" implied judgment about project health — this command doesn't do that
   - It reads the board and reports what's there; "Kanban Board Reader" accurately describes the function

7. **`kanban-state` output codified as a 3-column box table:**
   - Live CLI output rendered a box table; decided to codify it rather than leave it to AI judgment
   - Column 3 header: "Limit" (previously unnamed in the original spec)
   - WIP limit always shown as `N / limit` when a `.limit` file exists — not gated on hitting the limit

8. **WIP indicators are data, not judgment:**
   - ✅/⚠/❌ appended to the `N / limit` fraction in the Limit column
   - WIP warning footer left to AI judgment (additive, not a duplicate since it's more descriptive)

9. **`current` argument removed from `kanban-state`:**
   - The compact "show only doing/ items" view provides minimal value given low WIP limits (typically 2)
   - Full output already surfaces doing/ items clearly — no filtering needed

## Files Modified (Later)

- `plugins/spearit-framework/commands/kanban-state.md` — Role renamed, output format codified (box table + Limit column), `current` argument removed, bash script updated to read todo/.limit
- `plugins/spearit-framework/commands/help.md` — Added explicit prohibition on /fw-help hallucination
- `project-hub/work/backlog/FEAT-139-claude-project-yaml-config.md` — Updated file references (status.md → kanban-state.md, plan.md → preflight.md)

---

**Last Updated:** 2026-02-21

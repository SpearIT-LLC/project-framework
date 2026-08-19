# Applying Claude Code Dynamic Workflows to Consulting Activities

*Working document — Gary's consulting practice*
*Last updated: 2026-08-05*

## Background: Graph Engineering and Dynamic Workflows

Graph engineering is the practice of representing AI work as an executable graph: agents, tools, deterministic functions, validators, and human decision points, with designed dependencies, validation gates, and recovery paths. The core insight is that real-world agent work has predictable structure — a graph encodes the valid paths, where the model gets to choose, and where the system enforces deterministic behavior.

Claude Code's **dynamic workflows** are a lightweight, practical implementation of this idea:

- Claude writes the graph as a JavaScript script (`agent()` nodes, `pipeline()` fan-outs, verification stages).
- A runtime executes it in the background; intermediate results live in script variables, not Claude's context.
- A successful run can be saved (`/workflows` → `s`) as a reusable slash command — the repeatable graph.

Docs: https://code.claude.com/docs/en/workflows

## Activity Ranking (simplest → hardest to workflow-ify)

| # | Activity | Workflow fit | Notes |
|---|----------|--------------|-------|
| 1 | Manuals & documentation | Excellent — start here | Repeatable, naturally parallel (one agent per file/module), low blast radius, easy to verify |
| 2 | CAD install & support (CATIA / 3DEXPERIENCE) | Partial | Procedural checklists fit *skills* better; workflows shine for environment audits across many machines' logs/configs |
| 3 | Operations support | Good | Triage pattern: gather evidence in parallel, cross-check, rank. Each incident differs |
| 4 | Software development | Mixed | Routine coding = normal Claude Code; workflows fit wide passes (audits, migrations, per-file PR review) |
| 5 | System architecture | Valuable but least repeatable | "Draft from several independent angles, then compare" pattern; helps scope risk for fixed-price quotes |

## Chunk 1: Documentation Workflow

**Engagement shape:** inventory → parallel per-module drafting → consistency/accuracy verification → assembly.

### First dry run (read-mostly, one project, one directory)

```
use a workflow to inventory every public class and script under src/, draft a one-page reference section per module in docs/drafts/, then have a verifier agent check each draft against the actual code for accuracy before reporting
```

### Before running

1. `/config workflowSizeGuideline=small` — keeps runs under ~5 agents while learning the mechanics.
2. Target one directory, not the whole repo, to gauge token spend.
3. Watch progress with `/workflows` (drill into phases and agents; `p` pause, `x` stop).

### After a good run

- Press `s` in `/workflows` to save the script:
  - `.claude/workflows/` — project-scoped, shared with anyone who clones the repo.
  - `~/.claude/workflows/` — personal, available in every project.
- The saved workflow runs as `/<name>` and can take input via `args` (e.g., target paths).
- For fixed-price work: a saved workflow means known process, known cost per run.

## Permission Prompt Fatigue — Setup Checklist

Do this before workflow experiments:

- [ ] **Allowlist routine commands** in `.claude/settings.json` (project) or `~/.claude/settings.json` (global): `dotnet build`, `dotnet test`, PowerShell invocations, git commands. Allowlisted tools never prompt.
- [ ] **Permission mode**: switch to `acceptEdits` (Shift+Tab cycles modes) so file edits stop prompting; shell commands outside the allowlist still ask.
- [ ] **For workflows**: subagents always run in `acceptEdits` and inherit the allowlist — pre-allowlist the commands agents will need to avoid mid-run interruptions.

## Useful Commands Reference

| Command | Purpose |
|---------|---------|
| `ultracode: <task>` | Run one task as a workflow (keyword form, session effort unchanged) |
| `/effort ultracode` | Session-wide: xhigh effort + auto-orchestration for every substantive task (heavy; not the daily driver) |
| `/effort high` | Drop back for routine work |
| `/workflows` | List/watch/manage runs; `s` saves a script as a command |
| `/deep-research <question>` | Bundled research workflow |
| `/config workflowSizeGuideline=small` | Aim for <5 agents per run |
| Option+W / Alt+W | Dismiss an accidental ultracode keyword trigger |

## Roadmap / TODO

- [ ] **Chunk 1:** Design and dry-run the documentation workflow on a real project (pick target, define phases, run on one directory, verify, save)
- [ ] Chunk 2: CAD environment-audit workflow (log/config sweep) + install checklist as a skill
- [ ] Chunk 3: Operations triage workflow (parallel evidence gathering → cross-check → ranked findings)
- [ ] Chunk 4: Per-file PR review workflow for software development engagements
- [ ] Chunk 5: Architecture "multi-angle draft and compare" workflow; evaluate for fixed-price scoping
- [ ] Maintain `WORKFLOWS.md` documenting each saved workflow (purpose, inputs, cost profile, when to use)

# Command-Tier Drift Inventory

**Date:** 2026-06-30
**Author:** Gary Elliott + Claude Code
**Purpose:** Fact base for DECISION-162 — measure behavioral drift between the framework's `/fw-*` commands and the two plugin command sets.

---

## The three intentional tiers

Per the maintainer (2026-06-30), the tiers are **intentional** and differ in *how many* commands they offer:

| Tier | Location | Invocation | Scope |
|------|----------|-----------|-------|
| Full framework | `.claude/commands/fw-*` | `/fw-*` | Superset — all 11 commands |
| Advanced plugin | `plugins/spearit-framework/commands/` | `/spearit-framework:*` | Most functionality — 8 commands |
| Light plugin | `plugins/spearit-framework-light/commands/` | `/spearit-framework-light:*` | Basic / mostly Kanban — 3 commands |

Different command **counts** are by design. The concern is whether the commands the tiers **share** have drifted in **behavior** (beyond the expected namespace renaming).

---

## Command presence map

| command | fw (.claude) | full plugin | light plugin |
|---------|:---:|:---:|:---:|
| help | ✅ | ✅ | ✅ |
| move | ✅ | ✅ | ✅ |
| backlog | ✅ | ✅ | — |
| roadmap | ✅ | ✅ | — |
| session-history | ✅ | ✅ | — |
| swarm | ✅ | ✅ | — |
| new | — | ✅ | ✅ |
| kanban-state | — | ✅ | — |
| next-id | ✅ | — | — |
| release | ✅ | — | — |
| status | ✅ | — | — |
| topic-index | ✅ | — | — |
| wip | ✅ | — | — |

Notable: `new` exists in both plugins but **not** in `fw-*` (the framework uses `next-id` + manual/templated creation). `kanban-state` is full-plugin-only.

---

## Behavioral drift (differing lines after normalizing namespace prefixes)

Method: strip `/spearit-framework:` and `/spearit-framework-light:` → `/fw-` so only *behavioral* differences remain, then `diff` and count changed lines.

| command | fw ↔ full | fw ↔ light | full ↔ light |
|---------|:---:|:---:|:---:|
| help | 62 | 49 | 45 |
| move | **427** | **427** | **0** |
| backlog | 207 | — | — |
| roadmap | 436 | — | — |
| session-history | 68 | — | — |
| swarm | **697** | — | — |
| new | — | — | 0 |

### Findings

1. **The two plugins are in sync with each other.** `move` and `new` are **0 differing lines** between full and light. The plugin family is internally consistent.
2. **`fw-*` has diverged massively from the plugins.** `swarm` 697, `roadmap` 436, `move` 427, `backlog` 207 differing lines — these are functional, not cosmetic.
3. **Direction of drift: `fw-*` is ahead.** The framework's commands gained functionality the plugins never received (e.g. `fw-move` has `--force`, batch IDs, `blocked/`, `move.sh` integration — the same advances that were found drifted in the *starter* copies during TECH-159). The "advanced plugin" is effectively running older command logic than the framework.
4. **Structural difference even where small:** `session-history` (68 lines) differs in mechanism — `fw-*` embeds the template inline; the plugin reads an external `plugins/spearit-framework/templates/session-history-template.md`.

---

## Implication

This is unintended **behavioral lag**, not the intentional tier-count difference. It is the same class of problem TECH-159 fixed for the starter (parallel copies drifting), now across the plugin boundary. The open question (DECISION-162): should the plugins catch up to `fw-*`, and should shared commands pull from a single source so they can't lag again — balanced against the tiers being deliberately different in scope?

---

## Related

- **DECISION-162** — disposition of this drift (the decision this inventory informs).
- **TECH-161** — narrow session-history rollover fix (must touch both fw + full-plugin copies; see its Files Affected).
- **TECH-159** — eliminated the analogous starter-command drift; precedent for "copy from one source" thinking.

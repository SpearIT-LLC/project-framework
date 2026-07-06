# Session History: 2026-07-06

**Date:** 2026-07-06
**Participants:** Gary Elliott, Claude Code
**Session Focus:** Started BUG-170 (move.sh distribution) — a design question about `.claude/` folder organization cascaded into a namespacing convention (DECISION-171) and, deeper, the discovery that the framework's `DECISION-*` type duplicates industry-standard ADRs (TECH-172).

---

## Summary

Set out to queue BUG-170 for work; a single organizational question — *"could a `scripts/` folder live under `.claude/` like the plugin folders?"* — opened two nested design threads. First: since `.claude/` is a folder a downstream user also owns, framework files there need collision-safe namespacing → **DECISION-171** (`fw-` prefix for framework artifacts in user-shared folders). Second, while classifying that decision: the framework has **two overlapping concepts for one industry idea** — compliant ADRs *and* a bespoke `DECISION-*` work-item type → **TECH-172** to reconcile onto the ADR standard. No code changed; two planning items filed, BUG-170 queued.

---

## Work Completed

### BUG-170: `move.sh` Not Shipped — queued
- Moved `backlog/ → todo/` via `/fw-move` (required `--force`: the bug has intentional unchecked criteria + Option A/B fix-design, all legitimate readiness "issues" for an un-started bug).
- Fix design sharpened this session: a **third option** beats the two filed — relocate the engine to `.claude/scripts/fw-move.sh` (co-located with its command, named per DECISION-171). Verified the build's copy step is `.claude/commands/*.md`-only, so the build must widen regardless of where the script lands.

### DECISION-171: `fw-` Namespace for Shared-Folder Artifacts — filed (Accepted)
- Records the rule: framework files placed in user-shared folders (`.claude/`) carry the `fw-` prefix.
- Chose `fw-` over `sprit-`/`spearit-`: **zero migration** (11 existing `fw-*` commands already compliant), short, extends the existing pattern. Documented the **per-surface** split as intentional: `fw-` (files) / `SPRIT_` (env vars) / `spearit-framework:` (plugin namespace).

### TECH-172: Reconcile `DECISION-*` onto the ADR Standard — filed (todo)
- Full reconcile plan: retire `DECISION-*` as an offered type; standardize on *ADR = the record; track the act of deciding with a SPIKE/TASK whose deliverable is an ADR.*
- Includes a **complete straggler inventory** (15+ locations: docs, templates, plugins, tooling) and the critical nuance to **keep the `DECISION-` prefix valid** in tooling for legacy items.

---

## Decisions Made

1. **`.claude/scripts/` is a valid home for `move.sh` — and better than BUG-170's filed options.**
   - `.claude/` already carries non-standard content (a hook, the `fw-*` commands), so it's not "Claude's private folder" — it's the framework's delivery surface. Co-locating the engine with its command mirrors the plugin's self-contained model.

2. **`.claude/` is a *user-shared* folder → framework files must be namespaced (DECISION-171).**
   - Triggered by Gary: *"since a downstream user could use that folder, take extra care to avoid collisions — we already do it with `fw-` on commands."* Reinforced by **BUG-144** (a real, filed `.claude/` name-collision that silently mis-dispatched — proof the risk is live), and by the **brownfield-merge scenario** (merging the full framework into an existing repo that already has its own `.claude/`). Merge-safety recorded as a forward constraint, not filed as work.

3. **Prefix = `fw-` (not `sprit-`/`spearit-`).** Gary raised `sprit-` (his env-var prefix) as a brand-preserving middle option; weighed and rejected for files because it would make 11 shipped commands non-compliant (breaking rename or fractured convention) for a marginal safety gain. `SPRIT_` stays for env vars.

4. **⚠️ The `DECISION-*` type duplicates ADRs — reconcile onto the standard (TECH-172).**
   - Gary asked whether the framework is compliant with industry-standard ADR/decision definitions. Investigation: industry has **one** concept (ADR = decision record); the framework grew a **second** (`DECISION-*` work item). Evidence — workflow-guide **line 1127** defines the Decision type's purpose as literally *"ADR / design choice"*; the compliant §ADR never mentions it; GLOSSARY's ADR path is stale (`project-hub/decisions/`, nonexistent). Git-traced origin: introduced 2026-01-20 under **TECH-064**'s template-standardization sweep — an accident, not a designed split.
   - Scope-vs-artifact framings both explored and set aside (the data has global `DECISION`s and narrow `ADR`s, so neither axis actually separates them). Chose **full reconcile**, TECH item first to record the plan.

5. **Sequencing:** TECH-172 should land before/with BUG-170 so BUG-170 cites the permanent **ADR-006** (DECISION-171 converts into it) rather than a soon-renamed `DECISION-171`.

---

## Files Created
- `project-hub/work/backlog/DECISION-171-fw-namespace-for-shared-folder-artifacts.md`
- `project-hub/work/todo/TECH-172-reconcile-decision-type-with-adr-standard.md`
- `project-hub/history/sessions/2026-07-06-SESSION-HISTORY.md` — this file.

## Files Moved
- `project-hub/work/backlog/BUG-170-...md` → `.../todo/` (via `/fw-move --force`).

---

## Current State

### In done/ (awaiting release)
- BUG-167, FEAT-165, TECH-079 (all from prior sessions — release still pending)

### In doing/
- (empty)

### In todo/ (notable)
- **BUG-170** — move.sh distribution fix (queued)
- **TECH-172** — reconcile DECISION-*/ADR (approved, plan recorded)

### In backlog/ (notable)
- **DECISION-171** — `fw-` namespace rule (Accepted; becomes ADR-006 under TECH-172)

---

## Next Steps

1. **TECH-172 before BUG-170** — reconcile the DECISION/ADR overlap so BUG-170 cites `ADR-006`. Its first step writes ADR-006 (converting DECISION-171's content).
2. **Then BUG-170** — implement `.claude/scripts/fw-move.sh` + widen the build copy step + update references + retire the orphan `Move-WorkItem.ps1`; verify against a *built* archive.
3. **Still pending:** the release of BUG-167 + FEAT-165 + TECH-079 (in `done/` across sessions).

---

**Last Updated:** 2026-07-06

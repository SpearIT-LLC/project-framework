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

---

## (Later) — Plan Hardening: DECISION-item disposition, gotcha review, type-enforcement mechanism

**Continuation:** After committing the initial DECISION-171 / TECH-172 / BUG-170 batch, Gary probed the plan for holes. Three rounds of hardening followed — none changed the *direction*, all closed *gaps* — plus a new sibling item (TECH-173) and a machine-readable type master.

> Note (append-only): the original "Next Steps"/"Current State" above still say DECISION-171 becomes "ADR-006". That was accurate when written; it was later corrected to "next available ADR number" (see Decision 6 below). Original text preserved intentionally.

### TECH-172 — three amendments (mis-classification fix)
- **Gary's catch:** "Does TECH-172 have a plan for existing *open* DECISION items?" It did not — worse, it **mis-classified** them. The original "leave archived 029…162 alone" list wrongly swept **035, 036, 110, 162** (which are *open in `backlog/`*, not history) into the untouchable-history bucket.
- **Fix (3 edits):** replaced the flat list with a verified **three-bucket table** (archived/released · cancelled · **open/undecided** · this-session's); added an acceptance criterion + checklist step to **disposition the open items** (re-type or tag "resolve as ADR when worked") — with a guardrail that their *substance* is NOT force-decided, only their type/handling.

### TECH-172 — hardening from a gotcha review
- Gary asked for other gotchas. Probed the plan against real files; surfaced and folded in:
  - **Removed hard-coded `ADR-006`** (all 6 refs) → "next available number." *Rule established:* a work item must never dictate a future item's number — IDs are allocated at runtime. (This dissolved two of the raised gotchas outright.)
  - **Implementation Cautions block:** line-number drift (edit by anchor, not line — 1031→1033 already drifted); "decision" is overloaded (don't touch `/fw-swarm decision`, "decisions made", ADR prose); plus a *verified-safe* list (move.sh doesn't hard-code DECISION; plugins ship no DECISION template; schema has no type enum) so the implementer doesn't re-investigate.

### TECH-173 — NEW: Enforce Accepted Work-Item Types (the mechanism)
- **Gary's upgrade of a passive "deprecation note" into active enforcement.** Filed a sibling TECH item: a canonical **accepted** set (enforced at creation) + a **recognized** superset (parses legacy items).
- **Drift evidence captured:** "valid types" is stated in 3 disagreeing places — workflow-guide "5 total", ID-namespace prose (+POLICY), `.psm1 $validPrefixes` (+POLICY, +BUGFIX).
- **Correction logged:** `BUGFIX→BUG` was a *deliberate past rename*, not drift → it's the worked example of *recognized-but-not-accepted* (legacy).
- **Then Gary's two refinements:**
  1. **Authoring-vs-reference distinction** — named explicitly: create-mode consumers (new flow, templates, `/fw-next-id`) use the accepted set; reference-mode consumers (move.sh, .psm1, status/history scans) use the recognized superset. This is the *conceptual* form of the two-list model.
  2. **Machine-readable master** — Gary recalled project *types* have a schema SoT but work-item types never did (verified: `project.type` is an enum in `framework-schema.yaml`; no `work_item.type` exists). Added a `work_item.type` master mirroring it, with `status: accepted | legacy` per type — the single field that *encodes* the authoring-vs-reference distinction. All human-facing lists then **reference the master** (DRY), eliminating the drift structurally.

### Decisions Made (afternoon)

6. **Work items never hard-code future item numbers** — IDs are runtime-generated; plans reference "next available," not a specific number.
7. **Type-drift closed structurally, not by note** (TECH-173) — Gary's goal is explicitly to *finish the framework's holes* so they don't recur, because they're blocking the launch of **3 other projects** (up from 1 at session start). Prioritize closing holes over polish.
8. **Authoring vs. historical-reference is the governing distinction** for type-aware artifacts; a per-type `status` field in a schema master makes it machine-readable and DRY.
9. **Kept it types-focused, not a broad ADR** — Gary chose "consistent + DRY + a yaml master" over a general framework-wide principle ADR; folded into TECH-173.

### Files Created (afternoon)
- `project-hub/work/todo/TECH-173-enforce-accepted-work-item-types.md`

### Files Modified (afternoon)
- `project-hub/work/todo/TECH-172-...md` — disposition plan (3 edits), de-hardcoded ADR number, Implementation Cautions, TECH-173 cross-link.

### Commits (afternoon)
- `5fb8a63` — TECH-172 disposition plan for open DECISION items
- `accc1a3` — File TECH-173; harden TECH-172
- `13e70c3` — TECH-173 schema master + authoring-vs-reference modes

### Updated Cluster & Sequencing
- **DECISION-171** (fw- rule → ADR) · **TECH-173** (mechanism: type master + enforcement) · **TECH-172** (content cleanup) · **BUG-170** (original bug).
- **Recommended order: TECH-173 → TECH-172 → BUG-170** (mechanism first, so retirement sticks and legacy parses; then content; then the bug that cites the ADR).

---

**Last Updated:** 2026-07-06 (afternoon)

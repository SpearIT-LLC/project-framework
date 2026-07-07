# Session History: 2026-07-07

**Date:** 2026-07-07
**Participants:** Gary Elliott, Claude Code
**Session Focus:** Ratified ADR-006 (work-item type taxonomy), re-scoped TECH-173 to implement it,
then implemented BUG-170 end-to-end — relocating the `/fw-move` engine into the distribution and
proving the fix against a built archive.

---

## Summary

Two arcs. First, **ratified ADR-006** by resolving its three open points (all as recommended) and
flipped it Proposed → Accepted; **TECH-173** was re-scoped from its superseded "YAML enum" spec to
"implement ADR-006." Second, **implemented BUG-170** in six verified steps: relocated the `/fw-move`
engine `framework/scripts/move.sh` → `.claude/scripts/fw-move.sh` (Option C), widened the build to
ship `.claude/scripts/`, retired the orphan `Move-WorkItem.ps1`, and **verified end-to-end against a
built-and-extracted archive** — the shipped engine moved a test item AND stamped its `Completed`
date, closing the BUG-167 loop downstream. BUG-170 moved to `done/`.

---

## Work Completed

### ADR-006: Work-Item Type Taxonomy — ratified (Accepted)
- Resolved the three open decisions, all as recommended:
  - **D1a — keep SPIKE** (1 use, but architecturally distinct + agile standard).
  - **D1b — keep TASK + REFACTOR distinct** → canonical set is the full **8**: FEAT, BUG, TECH,
    DOCS, CHORE, REFACTOR, TASK, SPIKE.
  - **D5 — flat TAB-delimited SoT** (`name<TAB>status[<TAB>alias-target]`), chosen over CSV/JSON
    (JSON would add a `jq` dependency the bash engine must avoid).
- Flipped Status: Proposed → Accepted; locked the D5 example spec (with `#` header + `status` legend).

### TECH-173: Enforce Accepted Work-Item Types — re-scoped
- Superseded the original "`work_item.type` YAML enum in `framework-schema.yaml`" spec (ADR-006 D7
  keeps the schema as-is). Re-pointed to "implement ADR-006": flat TAB SoT, build-derived per
  channel, deterministic enforcement at the create/move gate.
- Rewrote Summary, Acceptance Criteria, Implementation Checklist against ADR-006; retained the old
  spec below a marked line for provenance. Still parked in `doing/`.

### BUG-170: `move.sh` Not Shipped — implemented + completed
- **Chose Option C** (a third option beating the filed A/B): relocate the engine to
  `.claude/scripts/fw-move.sh`, co-located with its `fw-move.md` command and `fw-`-named per
  DECISION-171. Mirrors the plugin's self-contained model; positions TECH-173's type-SoT to live
  beside the engine (ADR-006 D4).
- **Six steps, each verified before proceeding:**
  1. `git mv` engine → `.claude/scripts/fw-move.sh`; updated its header/usage comments; `bash -n` OK; ran.
  2. Updated the 3 path refs in `fw-move.md` + 3 **live** work items (TECH-166, TECH-169, TECH-172).
     Historical docs (releases/poc/done/archive) left untouched per Gary's rule.
  3. Widened `Build-FrameworkArchive.ps1` with a `.claude/scripts/*.sh` copy step (Step 1.6);
     documented as §7.5 in the distribution-build checklist. PowerShell parse OK.
  4. `git rm` orphan `Move-WorkItem.ps1` (verified nothing live invoked it — the `.psm1:14` mention
     was a doc comment, not an import); cleaned the `.psm1` "Used by" note + checklist entry.
  5. **Built the archive + extracted it to a scratch project + ran `fw-move.sh TEST-001 done`** →
     item moved AND `**Completed:** 2026-07-07` auto-stamped by the *shipped* engine. This is the
     deepest acceptance criterion: the BUG-167 belt now fires downstream.
  6. Populated the CHANGELOG `[Unreleased]` (Added/Changed/Removed/Fixed); ticked all 3 regression
     boxes in the bug.
- Moved BUG-170 → `done/`; the relocated engine auto-stamped its own `Completed` date (dogfood).

---

## Decisions Made

1. **ADR-006 ratified with the recommended set** — canonical 8 types (SPIKE, TASK, REFACTOR all
   kept), flat TAB-delimited SoT. First ADR ratified under TECH-172's "ADR is the record" standard.
2. **BUG-170 fixed via Option C** (relocate to `.claude/scripts/fw-move.sh`), not the filed A/B —
   co-locates engine with command, realizes the `fw-` namespace (DECISION-171), and sets up
   TECH-173's SoT to sit beside the engine.
3. **Historical documents are never edited** (Gary's rule) — releases, poc/, done/, archive/ keep
   their point-in-time path references; only *live* items (backlog/todo/doing) were updated. This
   superseded my initial three-option question about how to handle stale refs.
4. **Do not rebuild+commit a released archive during fix work** (Gary's catch: *"Why are we changing
   a released archive?"*). Building the v5.5.0 zip to *verify* is correct; the rebuilt zip was
   **reverted, not committed** — the archive is regenerated at release time via `/fw-release`. This
   is already documented at `distribution-build-checklist.md:19-25` ("the ONE method"); the lesson
   was to consult that doc before build/archive actions, not that the rule was novel.

---

## Files Created
- `project-hub/history/sessions/2026-07-07-SESSION-HISTORY.md` — this file.

## Files Modified
- `project-hub/research/adr/006-work-item-type-taxonomy.md` — Status → Accepted; D1/D5 resolved.
- `project-hub/work/doing/TECH-173-...md` — re-scoped to implement ADR-006.
- `.claude/commands/fw-move.md` — 3 path refs → `.claude/scripts/fw-move.sh`.
- `.claude/scripts/fw-move.sh` — header/usage comments updated to new path (content = former move.sh).
- `tools/Build-FrameworkArchive.ps1` — new `.claude/scripts/*.sh` copy step (Step 1.6).
- `framework/CHANGELOG.md` — `[Unreleased]` populated for BUG-170.
- `framework/docs/process/distribution-build-checklist.md` — dropped orphan; added §7.5 (.claude/scripts).
- `framework/tools/FrameworkWorkflow.psm1` — "Used by" comment updated (orphan removed).
- `project-hub/work/backlog/TECH-166-...md`, `TECH-169-...md`; `project-hub/work/todo/TECH-172-...md`
  — path refs updated; TECH-169 got a dated BUG-170 relocation note.

## Files Moved
- `framework/scripts/move.sh` → `.claude/scripts/fw-move.sh` (the engine relocation).
- `project-hub/work/todo/BUG-170-...md` → `.../doing/` → `.../done/`.

## Files Removed
- `framework/tools/Move-WorkItem.ps1` — orphan pre-FEAT-145 mover (228 lines).

---

## Current State

### In done/ (awaiting release) — 4 items
- BUG-167, FEAT-165, TECH-079 (prior sessions) + **BUG-170** (this session). Under the release-nudge
  threshold (no nudge).

### In doing/
- **TECH-173** — parked; re-scoped to "implement ADR-006," ready to build next.

### In todo/
- **TECH-172** (DECISION→ADR content cleanup), plus FEAT-092/163/164.

### In backlog/
- **DECISION-171** (fw- namespace → becomes an ADR under TECH-172), TECH-166, TECH-169, others.

### In research/adr/
- **ADR-006** (**Accepted**).

---

## Next Steps

1. **Implement TECH-173** (now unblocked — ADR-006 Accepted). Its checklist opens with a
   pre-implementation review gate. Author the flat TAB SoT in `.claude/scripts/` (beside the engine),
   wire deterministic enforcement into `fw-move.sh`, add the `Build-Plugin.ps1` derivation step, DRY
   the human-facing lists.
2. **Then TECH-172** (retire DECISION in docs/templates/plugins; relies on TECH-173's recognized set).
3. **Release** BUG-167 + FEAT-165 + TECH-079 + BUG-170 when ready (via `/fw-release` — which rebuilds
   the archive under the new version, now including `.claude/scripts/fw-move.sh`).

---

## Known Issues / Follow-ups
- **BUG-174 filed (backlog)** — WIP/final-move count in `fw-move.sh` includes `.gitkeep` (excludes
  only `.limit`), inflating every count by 1: "5/∞" for a 4-item done/, "2/2"→"3/2" for doing/. Root
  cause pinned to lines 340 + 515 (`! -name ".limit"` → should be `! -name ".*"`); the other
  `find -type f` sites are grep-filtered and safe. File moves are correct — display only. Gary
  diagnosed the dotfile cause directly.

---

**Last Updated:** 2026-07-07

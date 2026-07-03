# Session History: 2026-07-03

**Date:** 2026-07-03
**Participants:** Gary Elliott, Claude Code
**Session Focus:** Quick wins — TECH-079 (empty-release guard) and TECH-168 (Completed-date enforcement); the latter unravelled into a distribution-gap investigation (BUG-170).

---

## Summary

Shipped TECH-079 (a small doc guard against empty releases). Attempted TECH-168 (a
pre-commit hook to enforce `Completed` dates in `done/`), built it end-to-end, then
**rolled it back** after discovering a git hook can't reliably ship or auto-install in a
distributed framework. That investigation surfaced a deeper, previously-invisible bug —
`framework/scripts/move.sh` (the `/fw-move` engine since FEAT-145) is **not in the
distribution archive**, so `/fw-move` silently degrades to AI-interpreted moves in
archive-built projects, losing all deterministic guarantees including BUG-167's stamp.
Filed as **BUG-170**.

---

## Work Completed

### TECH-079: Empty-Release Guard (✅ Done)

- Added a **Pre-Release Validation** section to
  `framework/docs/process/version-control-workflow.md` (before the Release Checklist):
  check `done/` before releasing; STOP + confirm if empty; documented valid reasons
  (docs-only / config / dependency updates); point to `doing/` for forgotten items.
- Guidance, not a hard block — consistent with the framework's "never blocks, user
  decides" stance.
- Moved to `done/` via `move.sh`; the BUG-167 auto-stamp correctly wrote
  `**Completed:** 2026-07-03` (live confirmation the belt works *in this repo*).

### TECH-168: Completed-Date Pre-Commit Hook (↩️ Built, then ROLLED BACK)

- **Built:** `framework/hooks/pre-commit` (rejects staged `done/` items lacking a real
  `Completed:` date, reusing move.sh's exact regex) + `tools/Install-GitHooks.ps1`
  (sets `core.hooksPath`) + updated the false CLAUDE.md "hook validates done/" claim.
- **Verified working:** dated item committed cleanly; undated item was blocked with an
  actionable message. Both behaviors confirmed live, test artifacts cleaned up.
- **Then rolled back entirely** (see Decisions). All files deleted, `core.hooksPath`
  unset, CLAUDE.md and the TECH-168 item restored to committed state, item returned to
  `backlog/`. As if it never happened.

### BUG-170: `move.sh` Not Shipped in Distribution (📋 Filed, backlog, High)

- New bug capturing that `framework/scripts/move.sh` is absent from the archive while the
  shipped `fw-move.md` still calls it. Corrected mid-authoring (see Decisions) from a
  wrong "command is broken" framing to the real "silently degrades to AI-interpreted
  moves" failure mode.

---

## Decisions Made

1. **Target two quick wins from the BUG-167 follow-up cluster.**
   - Chose TECH-079 (warmup) + TECH-168 (the "suspenders" backstop) — context was warm
     from the just-shipped BUG-167.

2. **TECH-168 install approach: `core.hooksPath` + block-on-fail.**
   - Initially chose version-controlled `framework/hooks/` activated via installer script,
     with the hook exiting 1 (per TECH-168's acceptance criteria). Both later mooted by
     the rollback.

3. **⚠️ ROLLBACK of TECH-168 — a git hook is the wrong mechanism for a distributed
   framework.** (Gary's call, well-reasoned.)
   - **Why:** git hooks live in `.git/config` / `.git/hooks/`, which no clone or archive
     carries. `core.hooksPath` is local config — never distributed. So the hook can
     *never* auto-activate downstream; it always needs a per-machine install step that
     solo-dev users will routinely skip → the exact silent-lapse failure BUG-167 fought.
   - **Also:** the files were placed where the archive doesn't even look
     (`framework/hooks/`, repo-root `tools/`), so they wouldn't ship regardless.
   - **Process note:** Claude marked TECH-168 "done" before checking distribution. That
     was premature — the acceptance criterion "installable via a documented step" was met
     *for this repo* but not for consuming projects, which is the point of a framework.

4. **The "two movers" question — resolved from documented history.**
   - There are not two competing movers. Per FEAT-145 (v5.3.0, motivated by TECH-117
     perf work + SPIKE-142/145): `framework/scripts/move.sh` (bash) is the **canonical
     execution engine**; `framework/tools/Move-WorkItem.ps1` (PowerShell) is the
     **pre-FEAT-145 orphan** it replaced. The orphan still ships and its header still
     falsely says "Production script for /fw-move" — this masks the real engine and
     caused the confusion. Gary correctly recalled the `.sh` was chosen for performance.

5. **⚠️ CORRECTED BUG-170's framing — silent degradation, not a hard break.** (Triggered
   by two Gary observations: "I've used fw-move on many projects with no issues" and
   "are you figuring out intent and doing the action yourself rather than the script?")
   - **The insight:** when `move.sh` is missing, the AI reads `fw-move.md`, sees the
     script isn't there, and **performs the move itself by interpreting intent**
     (`git mv`). So `/fw-move` never *appears* to fail — it silently reverts to the
     AI-interpreted, per-operation execution FEAT-145 eliminated, losing every
     deterministic guarantee (transition hard-blocks, dependency/AC checks, batch
     handling, and the BUG-167 `Completed` stamp). This is arguably worse than a hard
     error because nothing signals the safety net is gone.
   - **Scope corrected:** archive / `Setup-Framework.ps1` projects only. The **plugin**
     path is unaffected (its `move.md` embeds inline bash, no `move.sh` dependency) —
     though the plugin has its own gap: no `Completed` stamp at all.
   - **Meta-lesson:** the framework's guardrails are only as real as their deterministic
     execution. Enforcement expressed as "instructions the AI follows" degrades silently
     to AI judgment when the underlying script is absent — the core risk behind the whole
     command-tier-drift effort.

---

## Files Modified

- `framework/docs/process/version-control-workflow.md` — added Pre-Release Validation
  section (TECH-079).

## Files Created

- `project-hub/work/backlog/BUG-170-move-sh-not-shipped-in-distribution.md` — the
  distribution-gap bug (with a corrected-framing trail in its header).
- `project-hub/history/sessions/2026-07-03-SESSION-HISTORY.md` — this file.

## Files Moved

- `project-hub/work/todo/TECH-079-empty-release-guard.md` → `.../done/` (Completed
  auto-stamped 2026-07-03).
- `project-hub/work/backlog/TECH-168-...` → `todo` → `doing` → **back to `backlog/`**
  (built then rolled back; net position unchanged from session start).

## Files Created-then-Deleted (rollback — recorded for the journey)

- `framework/hooks/pre-commit` — the enforcement hook (deleted).
- `tools/Install-GitHooks.ps1` — the installer (deleted).
- `core.hooksPath` git config — set then unset.

---

## Current State

### In done/ (awaiting release)
- BUG-167 (completed-field contradiction) — from prior session
- FEAT-165 (engagement project type) — from prior session
- **TECH-079 (empty-release guard) — this session**

### In doing/
- (empty)

### Notable backlog additions/returns
- **BUG-170 (High)** — `move.sh` not shipped → `/fw-move` silently degrades downstream.
- **TECH-168** — returned to backlog; needs re-scoping (see Next Steps).

---

## Next Steps (for the re-plan)

1. **BUG-170 first (High).** Fix the belt's distribution before any backstop: either add
   `framework/scripts/` to `Build-FrameworkArchive.ps1`'s copy list, or relocate
   `move.sh` into an already-shipped subtree — and retire/relabel the orphan
   `Move-WorkItem.ps1`. Verify end-to-end in a *built* project (extract archive, run
   `/fw-move → done`, confirm the stamp fires).
2. **Re-scope TECH-168.** Drop the git-hook approach. Target an enforcement surface that
   provably ships *and* runs downstream — likely a `/fw-release` preflight check (since
   `.claude/commands/` ship and the AI reads them). Depends on BUG-170 being fixed first.
3. **Plugin `Completed`-stamp gap.** The plugin `move.md` inline scripts have no
   `Completed` handling — fold into TECH-169 (reconcile `/fw-move` command copies).
4. **Standing lesson:** any "enforcement" that lives only as AI instructions degrades
   silently when its deterministic backing is absent. Prefer shipping-and-running
   surfaces; verify against a *built* artifact, not just the source repo.

---

**Last Updated:** 2026-07-03

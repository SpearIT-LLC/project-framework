# Bug: `move.sh` Not Shipped in Distribution Archive — `/fw-move` Silently Degrades to AI-Interpreted Moves

**ID:** BUG-170
**Type:** Bug
**Priority:** High
**Version Impact:** PATCH
**Created:** 2026-07-03
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->
**Theme:** Distribution & Onboarding

<!-- Discovered 2026-07-03 while researching TECH-168 (Completed-date enforcement).
     The hook work stalled on "where does enforcement actually run downstream?" —
     which surfaced that the belt (move.sh) itself doesn't reach consuming projects. -->

<!-- CORRECTED 2026-07-03: initial framing said /fw-move is "broken" downstream.
     The user (who uses the fw-* archive commands, not the plugin) reports /fw-move
     works everywhere. Root cause of that discrepancy: the AI reads fw-move.md, finds
     move.sh missing, and performs the move itself by interpreting intent. So the
     command never visibly fails — it silently degrades. That is the actual bug, and
     it's arguably worse than a hard failure. Title/summary/impact rewritten to match. -->

---

## Summary

The `/fw-move` execution engine — `framework/scripts/move.sh` (canonical since
FEAT-145, v5.3.0) — is **not included in the distribution archive**. The build copies
`framework/{docs,templates,tools}` but not `framework/scripts/`, while the **shipped**
`.claude/commands/fw-move.md` still instructs the AI to run `bash
framework/scripts/move.sh`.

The command does **not** error out. Instead, the AI reads `fw-move.md`, finds the
referenced script absent, and **completes the move itself by interpreting the command's
intent** — `git mv`-ing the file directly. So `/fw-move` *appears* to work in
archive-built projects, but it has **silently reverted to the exact AI-interpreted,
per-operation execution FEAT-145 replaced** — losing every deterministic guarantee the
script provides, including the BUG-167 `Completed`-date auto-stamp. The failure is
invisible: nothing signals that the safety net is gone.

---

## Bug Description

**What is happening (actual behavior)?**

- The build ([tools/Build-FrameworkArchive.ps1](../../../tools/Build-FrameworkArchive.ps1))
  copies only these framework subtrees into the zip: `docs/` (Step 3), `templates/`
  (Step 4), `tools/` (Step 5), plus `CLAUDE.md` and `PROJECT-STATUS.md`. It does **not**
  copy `framework/scripts/`.
- The shipped `.claude/commands/fw-move.md` references `framework/scripts/move.sh` in
  three places (lines 22, 75, 156 — verified inside `spearit_framework_v5.5.0.zip`).
- At runtime the AI encounters the missing script and **falls back to doing the move by
  hand** (parse ID → `git mv`). The move succeeds; the guardrails do not run.

**What should happen (expected behavior)?**

The command the archive ships and the scripts it ships must agree, so `/fw-move` runs the
deterministic engine (with its hard blocks + auto-stamp) rather than silently degrading
to AI judgment. Either `move.sh` ships alongside `fw-move.md`, or the shipped command is
rewritten to not depend on it.

**Impact:**

- **Silent, not loud.** Because the AI routes around the missing script, users (e.g. the
  reporter, who uses the `fw-*` archive commands everywhere) see `/fw-move` "work" and
  never suspect a problem. This is why the bug went unnoticed. It is arguably *worse* than
  a hard error, which would at least be visible.
- **All deterministic guarantees are lost downstream** whenever the AI does the move
  instead of `move.sh`:
  - Hard-block transition matrix (invalid transitions like done→todo)
  - Dependency validation (Depends On → must be in done/)
  - Acceptance-criteria enforcement before → done
  - Batch / child-item / any-extension handling
  - **BUG-167 `Completed`-date auto-stamp** — never fires; the silent-lapse failure
    BUG-167 fixed is fully alive again in archive-built projects.
- **FEAT-145's performance win is silently reverted** — back to AI-interpreted,
  per-operation moves, the exact thing TECH-117/FEAT-145 set out to eliminate.
- **Scope:** archive / `Setup-Framework.ps1` projects. The **plugin** path is unaffected —
  the plugin `move.md` copies embed their own inline bash (no `move.sh` dependency),
  though note they have their own gap: no `Completed` stamp at all (see Notes / TECH-169).
- **BUG-167's belt is inert downstream.** The `Completed`-date auto-stamp lives in
  `move.sh`; if `move.sh` isn't present, the date is never written in consuming projects —
  the exact silent-lapse failure BUG-167 set out to fix, still live outside this repo.
- Severity: **High** — a core workflow command is broken end-to-end in the shipped product,
  though it works perfectly in this source repo (which masks it).

---

## Reproduction Steps

**Steps to Reproduce:**

1. Build the archive: `.\tools\Build-FrameworkArchive.ps1`.
2. Inspect contents: `unzip -l distrib/framework/spearit_framework_vX.Y.Z.zip | grep scripts`
   → no `framework/scripts/` entries; `move.sh` absent.
3. `unzip -p <zip> .claude/commands/fw-move.md | grep move.sh`
   → command still says `bash framework/scripts/move.sh <ids> <target>`.
4. In a project created from the archive, run `/fw-move <id> doing` → the referenced
   script does not exist, so the AI silently completes the move by hand. The move
   *succeeds*; observe that **no `Completed` date is stamped** on a `→ done` move and
   that none of `move.sh`'s hard-block checks ran. That silent success — not an error —
   is the bug.

**Reproducibility:** Always (the degradation is deterministic; its *invisibility* is the
danger).

**Evidence captured (2026-07-03), against `spearit_framework_v5.5.0.zip`:**
- Zip contains `framework/tools/Move-WorkItem.ps1` (dated 2026-01-26) — see Root Cause.
- Zip contains **no** `framework/scripts/*` entries.
- Shipped `fw-move.md` lines 22/75/156 reference `framework/scripts/move.sh`.

---

## Root Cause Analysis

**File(s) Affected:**
- `tools/Build-FrameworkArchive.ps1` — copy list omits `framework/scripts/`.
- (Downstream symptom) `.claude/commands/fw-move.md` — assumes `move.sh` is present.

**Root Cause:**

FEAT-145 (v5.3.0) introduced `move.sh` as the fast, deterministic `/fw-move` execution
engine and **deliberately placed it in `framework/scripts/`** (FEAT-145 notes: *"keeps it
alongside other framework tooling, separate from POC/test artifacts"*). But the
distribution build was never updated to ship `framework/scripts/`. The new engine landed
in a directory the archive doesn't carry.

**The orphan `.ps1` that masks the problem:** `framework/tools/Move-WorkItem.ps1` is the
**pre-FEAT-145** PowerShell mover that `move.sh` replaced. It still lives in `tools/`
(which *does* ship), and its header still self-describes as *"Production script for
/fw-move command."* That header is now **stale** — `move.sh` is the production engine.
Because the orphan ships and looks authoritative, the two together create the "two movers"
confusion (noted this session) and hide the fact that the real engine is missing.

**Why was this missed?**

The source repo has `framework/scripts/move.sh` on disk, so `/fw-move` works flawlessly
here. The gap only manifests in a *built* project, which normal in-repo development never
exercises. Nothing tests the archive's `/fw-move` end-to-end.

---

## Fix Design (decide during implementation — do NOT pre-commit an approach)

Two coherent directions; pick one and make the shipped command + shipped scripts agree:

**Option A — Ship `framework/scripts/` (align package with the canonical design).**
- Add a `framework/scripts/` copy step to `Build-FrameworkArchive.ps1` (mirroring the
  existing `tools/` step). Then `move.sh` reaches consuming projects and `/fw-move` works
  as designed, belt included.
- Simplest fix; honors FEAT-145's intent.

**Option B — Relocate `move.sh` into an already-shipped subtree** (e.g.
`framework/tools/`) and update all references (`fw-move.md` × the `.claude/` copy, plus
any plugin copies — see TECH-169).
- Avoids touching the build, but rewrites the FEAT-145 path decision and touches more
  reference sites.

**Either way — retire the orphan.** Remove/replace `framework/tools/Move-WorkItem.ps1`
and its `FrameworkWorkflow.psm1` wiring, or at minimum correct its "Production script"
header so it stops masquerading as the engine. (Confirm nothing live still depends on it
first.)

---

## Testing

### Verification Steps

1. Build the archive.
2. `unzip -l <zip>` → confirm `move.sh` is present at the path `fw-move.md` references.
3. Extract to a scratch project; run `/fw-move <id> done`; confirm the move succeeds
   **and** a `**Completed:** <today>` date is stamped (proves the belt now works
   downstream — closes the BUG-167 loop for consuming projects).

### Regression Testing

- [ ] Source-repo `/fw-move` still works (no path regressions).
- [ ] Archive `/fw-move` works end-to-end in a freshly-built project.
- [ ] BUG-167 `Completed` stamp fires in a built project.

---

## Notes

- **Higher priority than TECH-168 (the "suspenders").** No point enforcing the
  `Completed` date with a backstop while the belt that *writes* it doesn't even ship.
  Fix the belt's distribution first.
- **TECH-168 re-scope implication:** a git pre-commit hook was the wrong backstop for a
  distributed framework — it can't auto-install on clone (`core.hooksPath` is local git
  config, never carried by a clone/archive), and would depend on a per-machine step
  solo-dev users will skip. When TECH-168 is re-planned, target a surface that provably
  **ships and runs** downstream (e.g. a `/fw-release` preflight check, since
  `.claude/commands/` do ship and the AI reads them). The session that filed this bug
  built and then rolled back the hook after this became clear.
- Overlaps the command-tier drift cluster (DECISION-162, TECH-161, TECH-169). TECH-169
  (reconcile `/fw-move` command copies) and this bug share a root: FEAT-145's engine
  change didn't fully propagate to every layer.

---

## Related

- FEAT-145 (v5.3.0) — introduced `move.sh` in `framework/scripts/` (the engine that
  doesn't ship)
- TECH-117 (v5.3.0) — the performance investigation that motivated the `.sh` engine
- SPIKE-142 / SPIKE-145 — POCs that validated the bash engine + script-layer policy
- BUG-167 — restored + auto-stamps the `Completed` field via `move.sh` (the belt this bug
  shows is inert downstream)
- TECH-168 — pre-commit hook backstop (to be re-scoped; see Notes)
- TECH-169 — reconcile `/fw-move` command copies; DECISION-162, TECH-161 — command-tier drift
- TECH-159 (v5.5.0) — the build's "single build method"; this fix extends its copy list

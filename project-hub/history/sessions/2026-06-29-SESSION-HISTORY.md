# Session History: 2026-06-29

**Date:** 2026-06-29
**Participants:** Gary Elliott, Claude Code
**Session Focus:** TECH-159 — eliminate templates/starter duplication (build copies canonical fresh); enable /fw-swarm + /fw-release in new projects

---

## Summary

Started by catching up from the 2026-06-25 session and answering three questions: where we left off, whether the `templates/starter` duplicate was fixed, and using `/fw-swarm` + `/fw-release` in a new project. The duplicate-file question opened a broader thread: the user's principle that `templates/starter/` must contain **zero** duplicate-of-source files — anything the distribution needs should be copied **fresh from canonical** by `Build-FrameworkArchive.ps1` so it can never go stale. Audited the starter tree, filed and implemented **TECH-159** to enforce that principle, and in the process caught and fixed two real defects (backslash zip paths; a drift-guard that destroyed the artifact on failure). Filed **TECH-160** for the parallel plugin-build concern. TECH-159 left in `doing/` for user review per request.

---

## Work Completed

### Catch-up / Answering the opening questions

- Read the 2026-06-25 session history. Confirmed: TECH-155 done (in `done/`, awaiting release), FEAT-157 + TECH-158 filed to backlog. Open follow-up: **TECH-156 Part A** (`/fw-release` missing from distribution).
- **"Did we fix the duplicate file in templates/starter?"** — YES, for the original case: TECH-155 deleted the stale `templates/starter/framework/CLAUDE.md` and added build Step 5.5 to copy canonical. Verified gone.
- **swarm + release in a new project:** `/fw-swarm` ships in the bundle; `/fw-release` did NOT (the TECH-156 Part A gap). This blocked the user's actual goal.

### Starter duplication audit

- Wrote `project-hub/research/starter-duplication-audit.md`. Classified every `templates/starter/` file as DUPLICATE-OF-SOURCE vs STARTER-ORIGINAL.
- **Group 1 — `.claude/commands/*.md` (10 files):** copies of repo-root `.claude/commands/`. Only `fw-roadmap.md` byte-identical; **9 already drifted** (e.g. starter `fw-move.md` a generation behind — no `--force`/batch/`blocked`/`move.sh`; `fw-status.md` missing `blocked/` + thresholds). `fw-release.md` absent (= TECH-156 Part A).
- **Group 2 — `templates/starter/framework/` (2 files):** entire subtree is duplicates. `framework-commands.md` identical; `GLOSSARY.md` **already drifted** (missing IC + PI terms, 33 vs 35). Build Step 3 already supplies these from canonical.
- **Groups 3 & 4 — keep:** root placeholder docs (carry `{{PLACEHOLDER}}` markers), `Setup-Framework.ps1`, `.gitkeep`/`.limit`. Confirmed STARTER-ORIGINAL by spot-check.

### TECH-159 implementation (folder by folder)

- **Group 2:** `git rm -r templates/starter/framework/` (Step 3 already covers ref docs — no new build code).
- **Group 1:** `git rm templates/starter/.claude/commands/*.md`; added a build step copying canonical `.claude/commands/*.md` fresh (scoped to `*.md`, excludes the framework's own `.claude/hooks/` + `settings*.json`). Closes TECH-156 Part A automatically.
- **Drift-guard:** build fails if `templates/starter/.claude/commands/` or `templates/starter/framework/` reappears with tracked files (TECH-074 precedent). **Verified it fires** (planted decoy → build aborted).
- **Integration test:** rebuilt bundle → headless `Setup-Framework.ps1` into a throwaway project → consuming project has all 11 commands incl. `/fw-release`, `fw-move`/`fw-status`/`GLOSSARY`/`framework-commands` **byte-identical to canonical**, and **no dev-tooling leak** (no hooks/settings).
- **Link Integrity Gate:** zero TECH-159-introduced broken links (remaining reported items = pre-existing TECH-158 stale links + known root-file walker false-positives).

### "Enforce one method" thread (user question about removals)

- User asked what happens when a file is **removed** from `.claude/commands/` or `framework/`. Answer: removals propagate cleanly — both are full mirrors of canonical because the build uses a **fresh temp dir each run** (lines 111–113 wipe temp unconditionally); Step 1.5 also empties its dest dir explicitly. No stragglers — *provided the one method is used*.
- User: "enforce one method so we don't worry about rogue builds." Defined **rogue = any framework archive not produced by `/fw-release` → `Build-FrameworkArchive.ps1`**. Plugin builds = separate matter (should behave the same, different details).
- Chose **document-the-rule** enforcement (no live hook/gate infra exists; building one was out of proportion). Added a "Single Build Method (Required)" section to `distribution-build-checklist.md` and a `.NOTES` block to the build script header.

---

## Decisions Made

1. **`templates/starter/` must hold zero duplicate-of-source files (user principle).**
   - Anything the distribution needs is copied fresh from canonical at build time. Generalizes the TECH-155 `framework/CLAUDE.md` pattern to all such files. Rationale: drifted copies were already shipping stale commands + glossary to new projects.

2. **TECH-159 kept framework-only; plugin split to TECH-160.**
   - User: "the plugin builds are a separate matter, although they should behave the same from an execution perspective." Avoided widening an already-scope-expanded item into a second product.

3. **Scope expansion #1 (user-approved): fix the backslash-path zip bug within TECH-159.**
   - The bundle stored backslash separators (`.claude\commands\...`) that break macOS/Linux extraction. **Proven pre-existing/environmental** — the original pre-TECH-159 script reproduces it in the same session (a `Compress-Archive`/.NET behavior, not caused by the de-dup). Fixed by replacing `Compress-Archive` with direct `System.IO.Compression` writing forward-slash entry names.

4. **Scope expansion #2 (user-approved): fix drift-guard ordering within TECH-159.**
   - The guard initially ran AFTER the script deletes the existing zip, so a guard failure **destroyed the good committed artifact**. Moved the guard to pre-flight (before any destructive cleanup). Verified: failed guard now leaves the zip byte-identical (same SHA-256).

5. **Enforcement = document the rule, not a code gate.**
   - No live pre-commit/PreToolUse hook exists (the array in `.claude/settings.json` is empty; `Validate-WorkItems.ps1` is present but unwired). A hard gate would mean new checkpoint infrastructure — disproportionate. Rule documented in the checklist + script header instead.

---

## Epistemic Notes

- The backslash-vs-forward-slash separator difference between the committed bundle (forward) and rebuilds (backslash) was isolated by **running the original pre-TECH-159 script in the same session** — it also produced backslashes, proving the cause is environmental, not the TECH-159 edits. (Important: do not attribute this defect to the de-dup work.)
- The Link Integrity Gate's ~20 "broken" reports were triaged, not taken at face value: 4 are root-file walker false-positives (targets verified to exist in the integrated project), the rest are pre-existing TECH-158 stale links + crude-walker artifacts. The one TECH-159-relevant link (`fw-session-history.md` from workflow-guide) **resolves** because the command now ships.
- Drift-guard and artifact-preservation were **verified by test** (planted decoy, SHA comparison), not asserted.

---

## Files Created

- `project-hub/research/starter-duplication-audit.md` - Per-file duplication audit + implementation outcome note
- `project-hub/work/backlog/TECH-160-align-plugin-build-execution-model.md` - Plugin build alignment (forward-slash zip, mirror semantics)
- `project-hub/history/sessions/2026-06-29-SESSION-HISTORY.md` - This session history

## Files Modified

- `tools/Build-FrameworkArchive.ps1` - Pre-flight drift-guard; copy canonical `.claude/commands/*.md` fresh; forward-slash `System.IO.Compression` zip; `.NOTES` single-build-method rule
- `framework/CHANGELOG.md` - TECH-159 Added/Changed/Removed entries
- `framework/docs/process/distribution-build-checklist.md` - New "Single Build Method (Required)" section
- `project-hub/work/doing/TECH-159-...md` - Acceptance criteria checked, implementation checklist done, scope-expansion notes, Completed date
- `distrib/framework/spearit_framework_v5.4.0.zip` - Rebuilt (11 commands incl. fw-release, forward-slash paths)

## Files Removed

- `templates/starter/.claude/commands/*.md` (10 files) - Drifted duplicates of canonical commands
- `templates/starter/framework/docs/ref/GLOSSARY.md`, `framework-commands.md` - Duplicates of canonical ref docs

## Files Moved

- `project-hub/work/backlog/TECH-159-...` → `todo/` → `doing/` (backlog → todo → doing, `--force` on readiness false-positives)

---

## Current State (end of session)

### In done/ (awaiting release)
- TECH-155 (from 2026-06-25)

### In doing/
- TECH-159 (implementation complete + verified; **left in doing/ for user review** per request — not yet moved to done)

### In todo/
- TECH-156 (Part A subsumed by TECH-159; Part B done 2026-06-25 — candidate to close/recategorize), FEAT-092, TECH-079

### In backlog/ (new this session)
- TECH-160 (plugin build execution-model alignment, Medium)

### Git
- 2 commits earlier this session (file TECH-159 + audit; move to doing). Implementation changes committed at session pause (this commit).

---

## Next Steps

1. **User review of TECH-159** (in `doing/`), then `/fw-move 159 done` (acceptance criteria already checked).
2. Reconcile **TECH-156**: Part A is now subsumed; Part B was done 2026-06-25 — decide whether to close TECH-156 or archive it.
3. **TECH-160** (plugin build): port forward-slash zip + verify mirror semantics; optionally extract a shared zip helper.
4. Release-time: TECH-159's bundle changes ship via `/fw-release`; new projects then get `/fw-swarm` + `/fw-release` current.
5. Still open from prior sessions: FEAT-157 (provenance stamp), TECH-158 (structural-stale links), scratch/ → poc/ cleanup (unfiled), SpearIT-KB notify at release.

---

**Last Updated:** 2026-06-29

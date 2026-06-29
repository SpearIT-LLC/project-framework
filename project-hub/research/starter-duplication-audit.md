# templates/starter — Duplication Audit

**Date:** 2026-06-29
**Author:** Gary Elliott + Claude Code
**Principle (user):** `templates/starter/` must contain **ZERO files that are copies of a canonical source elsewhere in the repo.** Anything the distribution needs that already exists in source must be copied **fresh by `Build-FrameworkArchive.ps1`** at build time, so it can never go stale.
**Precedent:** TECH-155 applied exactly this to `framework/CLAUDE.md` — deleted the starter duplicate, added Step 5.5 to copy canonical at build time.

---

## Method

For each file under `templates/starter/`, classify as one of:

- **DUPLICATE-OF-SOURCE** — a canonical version exists elsewhere in the repo; the starter copy is either byte-identical or has already drifted. → **Remove from starter; copy fresh in the build script.**
- **STARTER-ORIGINAL** — genuine scaffolding the new project starts with (placeholder root docs, empty-folder `.gitkeep`/`.limit`, the setup script). → **Keep in starter.**

Comparisons run with `diff`. "DRIFTED" means the starter copy already disagrees with canonical — proof the duplication is actively harmful, not theoretical.

---

## Findings

### Group 1 — `.claude/commands/*.md` (DUPLICATE-OF-SOURCE) ⚠️ already drifted

Canonical source: repo-root `.claude/commands/`. Starter ships 10; root has 11.

| File | vs root canonical | Notes |
|------|-------------------|-------|
| `fw-roadmap.md` | IDENTICAL | pure duplicate |
| `fw-help.md` | **DRIFTED** | starter has old swarm description |
| `fw-move.md` | **DRIFTED** | starter missing `--force`, batch IDs, `blocked/`, `move.sh` integration |
| `fw-status.md` | **DRIFTED** | starter missing `blocked/` row + done/ release-sizing thresholds |
| `fw-backlog.md` | DRIFTED | |
| `fw-next-id.md` | DRIFTED | |
| `fw-session-history.md` | DRIFTED | |
| `fw-swarm.md` | DRIFTED | |
| `fw-topic-index.md` | DRIFTED | |
| `fw-wip.md` | DRIFTED | |
| `fw-release.md` | **MISSING from starter** | the TECH-156 Part A gap — root has it, starter doesn't |

**Disposition:** Remove ALL command `.md` files from `templates/starter/.claude/commands/`. Build script copies the entire canonical `.claude/commands/` set fresh. This simultaneously **closes TECH-156 Part A** (fw-release ships automatically) and **kills 9 already-drifted duplicates**.

> Open design point for the build step: the distribution should ship exactly the `fw-*` user commands. Confirm whether any root command is dev-only and must be excluded (current root set is all `fw-*`, all intended for consumers).

### Group 2 — `framework/docs/ref/*` (DUPLICATE-OF-SOURCE) ⚠️ already drifted

The ENTIRE `templates/starter/framework/` subtree contains only two files, both duplicates:

| File | vs canonical | Notes |
|------|--------------|-------|
| `framework/docs/ref/framework-commands.md` | IDENTICAL | pure duplicate |
| `framework/docs/ref/GLOSSARY.md` | **DRIFTED** | starter copy missing "IC" + "PI" terms (33 vs canonical 35) |

**Disposition:** Delete the whole `templates/starter/framework/` subtree. The build already populates `framework/docs/` from canonical source in **Step 3** — these starter copies are redundant and were already going stale. No new build step needed; removing them is sufficient (Step 3 covers `docs/**`, which includes `docs/ref/`).

### Group 3 — Root project docs (STARTER-ORIGINAL) ✅ keep

These are the placeholder files a NEW project starts with. They intentionally differ from the framework's own root files — they contain `[placeholders]` and starter scaffolding, not framework content. NOT duplicates.

- `CLAUDE.md` (project template, not `framework/CLAUDE.md`)
- `README.md`, `INDEX.md`, `QUICK-START.md`, `PROJECT-STATUS.md`, `CHANGELOG.md`
- `framework.yaml` (template config with placeholders)
- `.gitignore`
- `docs/README.md`, `project-hub/**/README.md` (starter-authored guidance for each hub folder)

> **Verify-before-fix caveat:** confirm each of these genuinely contains placeholder/starter content and is not a silently-copied framework file. Group 3 is "keep" *on the assumption* they are templates; spot-check at implementation.

### Group 4 — Scaffolding (STARTER-ORIGINAL) ✅ keep

- `Setup-Framework.ps1` — the project-creation script; no canonical counterpart, starter-owned.
- All `.gitkeep` / `.limit` files — empty-folder structure markers.

---

## Recommended fix sequence (folder by folder)

1. **Group 2 first (simplest, zero new build code):** `git rm -r templates/starter/framework/`. Verify Step 3 of the build still lands `framework/docs/ref/{GLOSSARY,framework-commands}.md` in the bundle from canonical. Rebuild + link-walk.
2. **Group 1:** `git rm templates/starter/.claude/commands/*.md`; add a build step that copies canonical `.claude/commands/*.md` → bundle `.claude/commands/`. Closes TECH-156 Part A. Add a drift-guard (TECH-074 precedent): build fails if starter still contains any tracked command file.
3. **Groups 3 & 4:** no change — but spot-check Group 3 placeholder claim during implementation.
4. Rebuild distribution, run the Link Integrity Gate, headless `Setup-Framework` integration test, confirm `/fw-release` + `/fw-swarm` + fresh ref docs all present in an integrated project.

## Implementation outcome (2026-06-29)

Implemented as **TECH-159**. Both groups removed; `Build-FrameworkArchive.ps1` now copies canonical `.claude/commands/*.md` fresh (scoped to `*.md`, excludes framework hooks/settings) with a build-time drift-guard. Groups 3 & 4 kept (spot-check confirmed `{{PLACEHOLDER}}` content).

**One pre-existing defect surfaced and fixed in the same pass (user-approved scope expansion):** the bundle stored **backslash path separators**, breaking macOS/Linux extraction. Proven environmental (original script reproduces it), not caused by the de-dup. Fixed by replacing `Compress-Archive` with direct `System.IO.Compression` using forward-slash entry names. (The robocopy `/MIR` approach floated in the fix sequence below was dropped in favor of `Copy-Item` into a freshly-emptied dir — same guarantee, uniform with the rest of the build.)

## Relationship to existing work items

- **TECH-156 Part A** (fw-release missing from distribution) — *subsumed* by Group 1 fix.
- **TECH-074** (v3.6.0) — precedent: same "commands not propagated to template" bug class. Justifies the drift-guard.
- **TECH-155** — precedent: same remove-duplicate + build-time-copy pattern, applied to `framework/CLAUDE.md`.
- Suggest filing a single **TECH** item: "Eliminate templates/starter duplication; build copies canonical fresh" with Groups 1+2 as scope, TECH-156 Part A folded in.

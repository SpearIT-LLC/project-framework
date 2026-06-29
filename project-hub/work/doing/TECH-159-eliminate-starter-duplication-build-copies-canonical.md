# Tech Debt: Eliminate templates/starter Duplication — Build Copies Canonical Fresh

**ID:** TECH-159
**Type:** Tech Debt
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-06-29
**Theme:** Distribution Hygiene

---

## Summary

`templates/starter/` ships files that are **copies of canonical source** elsewhere in the repo. Most have already drifted, producing a consuming project that gets stale commands and reference docs. Apply the proven TECH-155 pattern (remove the duplicate; copy canonical fresh at build time) to **all** such files so `templates/starter/` contains **zero duplicate-of-source content**. This subsumes **TECH-156 Part A** (`/fw-release` missing from the distribution), which is just one symptom of the same root cause.

Full per-file audit: [`project-hub/research/starter-duplication-audit.md`](../../research/starter-duplication-audit.md).

---

## Problem Statement

**What is the current state?**

Audited 2026-06-29. `templates/starter/` carries two groups of duplicate-of-source files, **most already drifted** — proof the duplication is actively harmful, not theoretical:

### Group 1 — `.claude/commands/*.md` (10 files)

Canonical source: repo-root `.claude/commands/` (11 files). Starter ships 10; `fw-roadmap.md` is byte-identical, the other **9 have drifted**, and `fw-release.md` is **absent**.

| Symptom | Detail |
|---------|--------|
| `fw-move.md` drifted | starter copy lacks `--force`, batch IDs, `blocked/`, `move.sh` integration — a whole generation behind |
| `fw-status.md` drifted | starter copy lacks `blocked/` row + done/ release-sizing thresholds |
| `fw-help.md` drifted | starter copy has the old swarm description |
| `fw-release.md` MISSING | **= TECH-156 Part A** — root has it, starter does not, so no bundle ships `/fw-release` |
| 6 others drifted | `fw-backlog, fw-next-id, fw-session-history, fw-swarm, fw-topic-index, fw-wip` |

The build (`tools/Build-FrameworkArchive.ps1` Step 1) copies all of `templates/starter/*` wholesale into the bundle, so these drifted copies — and the *absence* of `fw-release` — are exactly what reaches a new project.

### Group 2 — `templates/starter/framework/` subtree (2 files)

The entire subtree is two duplicates of canonical source:

| File | vs canonical | |
|------|--------------|--|
| `framework/docs/ref/framework-commands.md` | IDENTICAL | pure duplicate |
| `framework/docs/ref/GLOSSARY.md` | **DRIFTED** | starter missing "IC" + "PI" terms (33 vs canonical 35) |

The build already populates `framework/docs/` from canonical in **Step 3** — these starter copies are redundant AND already stale.

**Why is this a problem?**

- New projects scaffolded from the bundle get **stale commands** (old `/fw-move`, `/fw-status`) and a **stale glossary**, and are **missing `/fw-release`** entirely.
- It is a recurrence of the bug class TECH-074 fixed (commands not propagated to template) and TECH-155 fixed for `framework/CLAUDE.md`. With no enforced drift-guard, every new canonical file risks slipping out of sync again.

**What is the desired state?**

- `templates/starter/` contains **zero** files that are copies of a canonical source. (User principle: "I don't want any duplicate files in templates/starter. NOTHING.")
- The build copies any distribution-needed canonical files (`.claude/commands/*`, `framework/docs/**`) **fresh from source** at build time, so they can never go stale.
- A build-time drift-guard fails the build if a known-canonical file reappears under `templates/starter/`.

---

## Proposed Solution

Apply the TECH-155 pattern folder-by-folder:

**Group 2 first (no new build code):**
- `git rm -r templates/starter/framework/`.
- Verify Step 3 still lands `framework/docs/ref/{GLOSSARY,framework-commands}.md` in the bundle from canonical (it copies `docs/**`, which includes `docs/ref/`).

**Group 1:**
- `git rm templates/starter/.claude/commands/*.md`.
- Add a build step (mirroring Step 5.5) that copies canonical `.claude/commands/*.md` → bundle `.claude/commands/`. Closes TECH-156 Part A automatically.
- Confirm the canonical set is exactly the consumer-facing `fw-*` commands (current root set is all `fw-*`); exclude any dev-only command if one is later added.

**Drift-guard (TECH-074 precedent):**
- Build fails (exit 1) if `templates/starter/.claude/commands/` or `templates/starter/framework/` contains any tracked file — prevents silent recurrence.

**Verification:**
- Rebuild; run the Link Integrity Gate (`distribution-build-checklist.md` Post-Build §2); headless `Setup-Framework.ps1` into a throwaway project; confirm an integrated project has current `/fw-move` + `/fw-status`, `/fw-release`, `/fw-swarm`, and current `GLOSSARY.md`/`framework-commands.md`.

**Files Affected:**
- `tools/Build-FrameworkArchive.ps1` — new command-copy step + drift-guard
- `templates/starter/.claude/commands/*.md` — removed (10 files)
- `templates/starter/framework/**` — removed (subtree, 2 files)
- `framework/CHANGELOG.md` — entry
- `framework/docs/process/distribution-build-checklist.md` — note the build-time copy + drift-guard (if procedure documented there)

**Out of scope (kept — STARTER-ORIGINAL):**
- Root project placeholder docs (`CLAUDE.md`, `README.md`, `INDEX.md`, `QUICK-START.md`, `PROJECT-STATUS.md`, `CHANGELOG.md`, `framework.yaml`), `Setup-Framework.ps1`, `.gitkeep`/`.limit` markers, per-hub `README.md`s. **Spot-check at implementation** that each Group 3 root doc genuinely contains placeholder/starter content and is not a silently-copied framework file.

---

## Acceptance Criteria

- [ ] `templates/starter/.claude/commands/` contains no tracked command `.md` files
- [ ] `templates/starter/framework/` subtree removed
- [ ] Build script copies canonical `.claude/commands/*.md` into the bundle fresh from source
- [ ] Build-time drift-guard fails the build if a duplicate-of-source file reappears in `templates/starter/`
- [ ] Group 3 root placeholder docs spot-checked and confirmed STARTER-ORIGINAL (not silently-copied framework files)
- [ ] Rebuilt bundle + headless integration test: integrated project has current `/fw-move`, `/fw-status`, `/fw-release`, `/fw-swarm`, and current ref docs
- [ ] Link Integrity Gate passes on the rebuilt bundle
- [ ] CHANGELOG.md updated
- [ ] TECH-156 Part A closed/cross-referenced as subsumed

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->
<!-- User can say "continue to completion" to approve remaining steps at once. -->

- [ ] **PRE-IMPLEMENTATION REVIEW COMPLETED**
  - AI presents: per-group removal list, build-step + drift-guard design, Group 3 spot-check plan, scope
  - User explicitly approves before proceeding
- [ ] Group 2: `git rm -r templates/starter/framework/`; verify Step 3 covers ref docs
- [ ] Group 1: `git rm templates/starter/.claude/commands/*.md`; add canonical-copy build step
- [ ] Add build-time drift-guard
- [ ] Spot-check Group 3 root docs are placeholders (not framework copies)
- [ ] Rebuild distribution; headless `Setup-Framework` integration test
- [ ] Run Link Integrity Gate; confirm zero genuine broken links
- [ ] CHANGELOG.md updated; TECH-156 Part A reconciled

---

## Notes

- Driven by user principle (2026-06-29): "I don't want any duplicate files in templates/starter. NOTHING. If we need them in the distribution archive, then let Build-FrameworkArchive add them fresh from the source so they never get stale."
- Audit method and full per-file classification: [`project-hub/research/starter-duplication-audit.md`](../../research/starter-duplication-audit.md).
- Priority **High**: a consuming project currently gets a stale, generation-behind `/fw-move` and no `/fw-release` — directly affects new-project usability (the trigger for this audit was wanting to use `/fw-swarm` + `/fw-release` in a new project).

---

## Related

- **TECH-156 Part A** — `/fw-release` missing from distribution; **subsumed** by this item's Group 1 fix. Part B (GitHub sync) was already done ad hoc on 2026-06-25.
- **TECH-155** — established the pattern: removed the `framework/CLAUDE.md` starter duplicate, added build Step 5.5 to copy canonical. Direct precedent for the mechanism here.
- **TECH-074** (v3.6.0) — fixed the same "commands not propagated to template" bug class for the 8 commands that existed then; justifies the drift-guard.
- **TECH-158** — sibling distribution-hygiene item (structural-stale links); `GLOSSARY.md` appears in both — coordinate so the de-dup here doesn't re-introduce a stale glossary.

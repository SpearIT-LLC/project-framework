# Session History: 2026-06-25

**Date:** 2026-06-25
**Participants:** Gary Elliott, Claude Code
**Session Focus:** Distribution archive audit — fw-swarm/fw-release coverage and GitHub sync status

---

## Summary

Investigated whether the framework distribution archives are up to date, prompted by `/fw-swarm` appearing to be missing from the v5.2.0 bundle. The swarm concern turned out to be a false alarm (correct version gating), but the audit surfaced two real distribution/release-publishing gaps: `/fw-release` is absent from every distribution bundle, and the GitHub remote is far behind local (3 unpushed commits + 19 unpushed tags). Captured both in a new work item, TECH-156.

---

## Work Completed

### Catch-up / Context Refresh

- Read `framework.yaml`, `framework/PROJECT-STATUS.md`, `framework/CHANGELOG.md`, root + framework `CLAUDE.md`.
- Confirmed current state: **v5.4.0** (2026-03-03), production-ready; `doing/` and `done/` both empty.
- Reviewed the recently-added (untracked) TECH-155 backlog item.

### Distribution Audit (investigation, no fix yet)

- **fw-swarm false alarm resolved:** `/fw-swarm` was introduced by FEAT-147 in **v5.3.0**, so its absence from the v5.2.0 archive is correct version gating. It IS present in the v5.4.0 bundle (full 21KB multi-mode version).
- **Part A finding — `fw-release` missing from distribution:** `tools/Build-FrameworkArchive.ps1:48` sources commands from `templates/starter/.claude/commands/`, which contains 10 commands but NOT `fw-release.md`. The repo-root `.claude/commands/` has 11 (includes `fw-release.md`). Result: no distribution bundle ships `/fw-release`, despite it being the headline feature of v5.3.0–v5.4.0.
- **Part B finding — GitHub out of sync:** Verified via `git fetch` + `git ls-remote --tags origin`:
  - `origin/main` HEAD at `bca93e2`; local `main` ahead by 3 commits (entire v5.4.0 release unpushed).
  - Remote tags stop at **v3.0.0**; 16 framework tags (v3.0.1→v5.4.0) + 3 plugin tags are local-only.
  - Releases-page ZIPs (user observed "up to 5.2.0") drifted independently from git tags/branch.
- **Precedent identified:** This is a recurrence of **TECH-074** (v3.6.0), which fixed the same "commands not propagated to template" class of bug for the 8 commands that existed then. No enforced drift-guard, so `fw-release` slipped through later.

### Work Item Created

- **TECH-156** (backlog, High priority): documents Part A (fw-release distribution gap) and Part B (GitHub sync gap), with TECH-074 cross-referenced as precedent and an optional build-time drift-guard proposed.

---

## Decisions Made

1. **Bundle the two findings into one work item, not two:**
   - Both are distribution/release-publishing hygiene; kept as TECH-156 with clearly separated Part A / Part B sections.
   - Rationale: shared root theme and likely fixed in the same release pass; user can split later if desired.

2. **Priority set to High:**
   - Driven by Part B — local is currently the only copy of v3.0.1→v5.4.0 release history (tags) and the v5.4.0 release commit, a single-point-of-failure / data-loss risk.

3. **No implementation performed this session:**
   - Stopped at the pre-implementation review per ADR-001 checkpoint policy.
   - Part B specifically involves `git push` (commits + tags), which requires explicit user approval under git safety policy before execution.

---

## Epistemic Notes

- Git-layer findings (branch ahead/behind, tag list) verified authoritatively via `git ls-remote`.
- The GitHub **Releases** page (uploaded ZIP assets) could NOT be inspected from the CLI. "GitHub shows up to v5.2.0" for assets is the user's observation — consistent with, but not directly verified against, the git-layer findings. Recorded as a caveat in TECH-156.
- No v5.3.0 ZIP exists in `distrib/framework/` (build-as-part-of-release only landed in v5.4.0), so there is no v5.3.0 asset to publish.

---

## Files Created

- `project-hub/work/backlog/TECH-156-distribution-and-github-sync-gaps.md` - New work item for the two distribution/sync gaps
- `project-hub/history/sessions/2026-06-25-SESSION-HISTORY.md` - This session history

---

## Files Modified

- None (investigation + work-item creation only)

---

## Current State

### In done/ (awaiting release)
- (empty)

### In doing/
- (empty)

### Backlog (new this session)
- TECH-155 — Distribution bundle broken links (was untracked at session start)
- TECH-156 — fw-release missing from distribution + GitHub out of sync

### Git
- `main` ahead of `origin/main` by 3 commits (v5.4.0 release unpushed)
- 19 unpushed tags (v3.0.1→v5.4.0 + plugin tags)
- TECH-155 still untracked; TECH-156 staged

---

## Next Steps

1. Decide disposition of TECH-156 (fix now vs. schedule). Likely sequence:
   - Part B (push commits + tags) — needs explicit approval; addresses data-loss risk first.
   - Part A (copy `fw-release.md` into starter, rebuild bundle).
   - Optional: add drift-guard to `Build-FrameworkArchive.ps1` to prevent recurrence (per TECH-074 precedent).
2. Reconcile GitHub Releases assets with git tags.
3. Track/commit TECH-155 (currently untracked).

---

**Last Updated:** 2026-06-25

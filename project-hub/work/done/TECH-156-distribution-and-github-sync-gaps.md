# Tech Debt: fw-release Missing From Distribution + GitHub Out of Sync (19 unpushed tags, v5.4.0 unpushed)

**ID:** TECH-156
**Type:** Tech Debt
**Priority:** High
**Version Impact:** PATCH
**Created:** 2026-06-25
**Completed:** 2026-06-30
**Theme:** Distribution & Release Hygiene

---

## Summary

Two distinct release-publishing gaps discovered during a 2026-06-25 distribution audit:
**(A)** `/fw-release` is absent from every framework distribution bundle because `fw-release.md` was never copied into `templates/starter/.claude/commands/`; and
**(B)** the GitHub remote (`origin`) is far behind local — the `main` branch is 3 commits behind (the entire v5.4.0 release is unpushed) and **19 version tags** (everything from v3.0.1 through v5.4.0) plus the plugin tags were never pushed.

---

## Problem Statement

**What is the current state?**

### Part A — `fw-release` missing from distribution

- The framework build script (`tools/Build-FrameworkArchive.ps1:48`) sources commands from `templates/starter/.claude/commands/`.
- That starter directory contains **10** commands but **not** `fw-release.md`.
- The repo-root `.claude/commands/` contains **11** commands, including `fw-release.md`.
- Result: the v5.4.0 distribution ZIP (`distrib/framework/spearit_framework_v5.4.0.zip`) ships `fw-swarm` but **not** `fw-release` — even though `/fw-release` was the headline feature of v5.3.0 (FEAT-099) and v5.4.0 (FEAT-153/TECH-154).
- Consuming projects that pull the framework therefore never receive the release command.

Note (resolved during audit, not a bug): `fw-swarm` is correctly absent from the v5.2.0 bundle — it was introduced in v5.3.0 (FEAT-147), so its absence from the older archive is expected. It IS present in v5.4.0.

### Part B — GitHub remote out of sync

Verified via `git fetch` + `git ls-remote --tags origin` on 2026-06-25:

- **Branch:** `origin/main` HEAD is at `bca93e2` (docs: Session history 2026-03-03). Local `main` is **ahead by 3 unpushed commits**:
  - `d2b1048` chore: Release v5.4.0 — fw-release full pipeline + portability + archival fixes
  - `1a8aa46` chore: Archive v5.4.0 work items
  - `c349514` chore: Build distribution artifact v5.4.0
- **Tags:** Authoritative remote tag list stops at **v3.0.0**. Local-only (unpushed) tags:
  - `v2.2.3, v2.2.4, v2.2.5, v3.0.1, v3.1.0, v3.3.0, v3.4.0, v3.5.0, v3.6.0, v4.0.0, v4.1.0, v5.0.0, v5.1.0, v5.2.0, v5.3.0, v5.4.0` (16 framework tags)
  - `plugin-full-v1.0.0-dev3, plugin-light-v1.0.0, plugin-light-v1.0.4` (3 plugin tags)
- The GitHub Releases page reportedly shows ZIP assets up to v5.2.0 — consistent with assets being uploaded separately from (and ahead of) the git tags/branch, indicating the two publishing paths drifted independently.

**Why is this a problem?**

- **Part A:** The distribution is internally inconsistent. Downstream projects get partial command coverage and cannot use `/fw-release`, the framework's own release automation.
- **Part B:** Local is the only copy of v3.0.1→v5.4.0 release history (tags) and the v5.4.0 release commit. This is a single-point-of-failure / data-loss risk, and the public repo misrepresents the framework's true state. No verifiable provenance for released versions on GitHub.

**What is the desired state?**

- `/fw-release` ships in the framework distribution bundle alongside the other `/fw-*` commands.
- `origin/main` matches local `main`; all framework and plugin tags present on the remote; GitHub Releases assets reconciled with the tags they correspond to.
- A guard prevents the starter command set from drifting out of sync with the source command set, and a release-publish step ensures tags/commits are pushed.

---

## Proposed Solution

### Part A
1. Copy `fw-release.md` into `templates/starter/.claude/commands/`.
2. Confirm `framework/docs/ref/framework-commands.md` lists `/fw-release`.
3. Rebuild the framework distribution so the bundle includes it (PATCH bump or rolled into next release per maintainer call).
4. (Optional hardening) Add a build/CI check that diffs `templates/starter/.claude/commands/` against the source command set and fails on drift.

### Part B
1. `git push origin main` (3 commits).
2. `git push origin --tags` (push the 19 missing tags) — **review first** to confirm no tag should be withheld.
3. Reconcile GitHub Releases assets (v5.3.0 had no ZIP built; v5.4.0 ZIP exists locally) — decide which assets to upload to match tags.
4. (Optional) Add a post-release reminder/step in `/fw-release` to push commits + tags.

**Files Affected:**
- `templates/starter/.claude/commands/fw-release.md` — new (copied from `.claude/commands/fw-release.md`)
- `framework/docs/ref/framework-commands.md` — verify/add `/fw-release` entry
- `tools/Build-FrameworkArchive.ps1` — optional drift-guard
- `distrib/framework/` — rebuilt bundle
- `.claude/commands/fw-release.md` — optional post-release push step

---

## Acceptance Criteria

- [x] ~~`fw-release.md` present in `templates/starter/.claude/commands/`~~ **SUPERSEDED by TECH-159** — the de-dup work removed ALL command files from the starter; the build copies the canonical command set (incl. `fw-release.md`) fresh. The original goal (it ships) is met by a better method; the starter no longer holds command files by design.
- [x] Fresh framework bundle contains `fw-release.md` — verified in TECH-159 integration test (bundle has all 11 commands incl. `fw-release.md`)
- [x] `framework-commands.md` documents `/fw-release` — done 2026-06-30; the doc was rewritten to cover all 11 commands (it previously documented only 5 and used the stale `/fw-wip-check` + non-existent `/fw-archive` names)
- [x] `origin/main` == local `main` (0 ahead) — pushed via VSCode on 2026-06-25 (verified 0/0 that session)
- [x] All intended framework + plugin tags present on `origin` — `git push origin --tags` on 2026-06-25 pushed all 19 tags (v3.0.1→v5.4.0 + 3 plugin tags)
- [x] ~~GitHub Releases assets reconciled with tags~~ **REMOVED — false premise.** This criterion assumed the project publishes via the GitHub *Releases* feature. It does not: investigation (2026-06-30) confirmed "released" here means **the distribution ZIP is committed to the repo** (`distrib/framework/*.zip` at a tagged commit). `/fw-release` builds + commits + tags; it has no GitHub-Releases step, and `gh release list` shows zero release objects. The 2026-06-25 "shows up to v5.2.0" observation was the committed `distrib/` zips in the repo browser, not Release objects. Adopting GitHub Releases would be NEW infrastructure, not a gap to close (see Notes).
- [x] (Optional) Drift-guard prevents starter/source command divergence — added in TECH-159 (pre-flight guard in `Build-FrameworkArchive.ps1`)

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->
<!-- User can say "continue to completion" to approve remaining steps at once. -->

- [x] **PRE-IMPLEMENTATION REVIEW COMPLETED** (2026-06-30) — reconciled the item against reality: functional goals already met (Part A via TECH-159, Part B pushed 2026-06-25). User's framing: "we have a documentation problem, not a command functionality issue." Scope reduced to the genuine remainder — bring `framework-commands.md` up to date — plus recording what other work satisfied the rest.
- [x] ~~Part A: Copy `fw-release.md` into starter template~~ **SUPERSEDED by TECH-159** (build copies canonical fresh; starter holds no command files)
- [x] Part A: Verify/update `framework-commands.md` — rewrote to cover all 11 commands; fixed stale `/fw-wip-check` → `/fw-wip` and removed non-existent `/fw-archive`
- [x] Part A: Bundle contains `fw-release.md` — verified in TECH-159 integration test
- [x] Part B: Review unpushed commits/tags, confirm intent — done 2026-06-25
- [x] Part B: Push `main` and tags to `origin` — done 2026-06-25 (branch via VSCode, tags via `git push origin --tags`)
- [x] ~~Part B: Reconcile GitHub Releases assets~~ **REMOVED — false premise** (project publishes via committed `distrib/` zips, not GitHub Releases; see Acceptance Criteria + Notes)
- [x] (Optional) Add drift-guard to build script — done in TECH-159
- [x] CHANGELOG.md updated (TECH-156 entry for the command-reference doc update)
- [x] Acceptance criteria verified (all but the manual Releases-assets task)

---

## Notes

- Discovered during a 2026-06-25 catch-up session investigating why `/fw-swarm` appeared missing from the v5.2.0 archive. The `fw-swarm` concern was a false alarm (correct version gating); the `fw-release` gap and the GitHub sync gap are the real findings.
- Epistemic caveat: the git layer (tags/branch) was verified via `git ls-remote`. The GitHub **Releases** page (uploaded ZIP assets) could not be inspected from the CLI; "GitHub shows up to v5.2.0" for assets is the maintainer's observation and is consistent with — but not directly verified against — the git-layer findings.
- No v5.3.0 ZIP exists in `distrib/framework/` (build-as-part-of-release only landed in v5.4.0), so there is no v5.3.0 asset to publish.

### Resolution (2026-06-30)

This item's two original parts were satisfied by other work, and one criterion was retired as a false premise:
- **Part A (fw-release in distribution):** subsumed by **TECH-159** — the build copies the canonical command set fresh; `/fw-release` ships in the bundle. The original "copy fw-release.md into starter" approach was superseded (the starter holds no command files by design).
- **Part B (git sync):** completed ad hoc on **2026-06-25** — `origin/main` synced, all 19 tags pushed.
- **Genuine remainder, done here (2026-06-30):** the command-reference doc `framework/docs/ref/framework-commands.md` was stale (documented 5 of 11 commands, used `/fw-wip-check`, referenced a non-existent `/fw-archive`). User reframed: "we have a documentation problem, not a command functionality issue." Rewrote it to cover all 11 commands accurately.
- **GitHub Releases assets — removed (false premise):** the project does not use the GitHub Releases feature. "Released" = distribution ZIP committed to `distrib/framework/` at a tagged commit (verified: zips are git-tracked; `c349514 chore: Build distribution artifact v5.4.0`; no GitHub-Releases step in `/fw-release` or the release process doc; `gh release list` empty).

### Future option (not a committed work item)

Adopting GitHub Releases as an *additional* publishing channel (create Release objects per tag, attach the `distrib/` zips, add a publish step to `/fw-release`) is a viable enhancement — `gh` is installed and authenticated for this repo. It is **new infrastructure**, not a gap in TECH-156. File a DECISION item if/when this is wanted.

---

## Related

- TECH-155 (distribution bundle broken links) — sibling distribution-hygiene item
- FEAT-099, FEAT-153, TECH-154 — `/fw-release` feature history (v5.3.0–v5.4.0)
- FEAT-147 — `/fw-swarm` introduced in v5.3.0 (explains v5.2.0 absence)
- TECH-074 — "include fw-commands in template" (prior precedent for this class of drift)

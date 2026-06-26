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

## Afternoon Session — GitHub Sync + TECH-155 Implementation

### GitHub Sync Closed (TECH-156 Part B, done ad hoc)

- User pushed `main` via VSCode → branch synced (`origin/main` == local). Verified `0/0`.
- **Tags did NOT push** — plain branch push omits tags by Git design. Confirmed 19 tags still local-only.
- Ran `git push origin --tags` → all 19 tags now on remote (v3.0.1→v5.4.0 + 3 plugin tags). Verified 0 unpushed.
- **Decision:** This closes the data-loss risk that drove TECH-156's High priority. Part A (fw-release in distribution) remains open in TECH-156.
- Teaching note captured for user: plain push ≠ tag push; `git config push.followTags true` is the durable backstop; the real fix is a push step in `/fw-release`.

### Workflow moves

- `/fw-move 155,156 todo` → both required `--force` (unchecked `[ ]` boxes + literal word "decide" in TECH-156 tripped the readiness scanner; not real blockers). Moved.
- `/fw-move 155 doing` → TECH-155 started; pre-implementation review presented.

### TECH-155 Implementation — 13 broken distribution links

**Investigation first (user: "investigate, document, then fix"):** Each of the 13 links verified against the *actual v5.4.0 bundle*, not just source. Dispositions documented in artifact `TECH-155/link-disposition.md`. Resolution mix: 10 REMOVE, 1 IN-TEXT, 2 FIX-PATH.

**Corrections to the original downstream report:**
- Two Group D links were *stale-path bugs* (target ships, link wrong) → FIX-PATH, strictly better than removal. D2 (`collaboration/README.md` wrong nesting), D4 (the `NEW-PROJECT-CHECKLIST.md` link used obsolete `templates/standard/` — file actually ships to project ROOT via Setup-Framework, matching user's hunch).
- Group C (ADR-001 link): verified no practical reason to keep — the policy is already fully described in-place in `framework/CLAUDE.md`; the link pointed to an unbundled duplicate in the consuming project's own ADR namespace. Removed (DRY).

**Major root-cause discovery during verification:** The bundle's `framework/CLAUDE.md` was NOT sourced from canonical `framework/CLAUDE.md` — it shipped a **divergent, stale duplicate** carried in `templates/starter/framework/CLAUDE.md`. So the Group B/C edits did not initially reach the bundle. The two copies had genuinely drifted (stale links + older content), with NO placeholders or starter-specific content — pure duplication debt.

- **Fix (user principle: "copy non-unique files from source, never maintain a duplicate"):**
  - `git rm templates/starter/framework/CLAUDE.md` (deleted stale duplicate).
  - Added Step 5.5 to `Build-FrameworkArchive.ps1` to copy canonical `framework/CLAUDE.md` into the bundle.
- This is preferred over a runtime copy in Setup-Framework (fewer moving parts; eliminates the drift source at build time).

**Verification (user: "let's do the test" — real integration test):**
- Rebuilt bundle, ran `Setup-Framework.ps1` headless into a throwaway project, link-walked the integrated project's `framework/`.
- **All 13 TECH-155 links confirmed resolved** (zero survivors) in the integrated project.
- A crude walker reported ~169 "broken" — characterized as: ~155 intended `framework/templates/` placeholder links (correctly excluded by the downstream audit), ~4 walker false-positives (root files that exist), and **~10 genuine stale links in non-template reference docs** that are NOT among TECH-155's 13.

### Decisions Made (afternoon)

1. **TECH-155 scope held to its documented 13.** Did not silently expand. Verified complete on stated scope.
2. **New structural-staleness item → TECH-157** (to be filed): `framework/INDEX.md`'s 33 stale links (to a nonexistent `project-hub/framework/templates/` structure) + the ~10 reference-doc stale links surfaced by the integration test. Same root cause as TECH-106's incomplete `standard→starter` rename.
3. **`scratch/` cleanup → separate activity** (user): the 5 tracked `scratch/*.md` files PROBABLY should have been in `poc/`. Treat as its own cleanup, not folded into TECH-155. Relates to never-delete policy (TECH-077).
4. **TECH-156 build-process notes:** the `templates/standard/` PowerShell command examples in `distribution-build-checklist.md` are stale build *instructions* — belong with TECH-156's build-process scope, not link-integrity.

### Files Created (afternoon)

- `project-hub/work/doing/TECH-155/link-disposition.md` - Verified per-link disposition + verification result (TECH-155 artifact)

### Files Modified (afternoon)

- `framework/CLAUDE.md` - Group B (2) + Group C (1) link fixes
- `framework/docs/PROJECT-STRUCTURE.md` - Group A (in-text)
- `framework/docs/REPOSITORY-STRUCTURE.md` - Group A (in-text)
- `framework/docs/plugin-development-guide.md` - Group D1 (remove)
- `framework/docs/collaboration/README.md` - Group D2 (fix-path)
- `framework/docs/project/planning-model.md` - Group D3 (remove)
- `framework/docs/process/distribution-build-checklist.md` - Group D4 (fix-path)
- `tools/Build-FrameworkArchive.ps1` - Step 5.5: copy canonical framework/CLAUDE.md
- `distrib/framework/spearit_framework_v5.4.0.zip` - rebuilt bundle

### Files Removed (afternoon)

- `templates/starter/framework/CLAUDE.md` - stale duplicate of canonical framework/CLAUDE.md (DRY)

### Files Moved (afternoon)

- `project-hub/work/backlog/TECH-155-...` → `todo/` → `doing/`
- `project-hub/work/backlog/TECH-156-...` → `todo/`

---

## Current State (end of session)

### In doing/
- TECH-155 (implementation complete + verified; pending acceptance-criteria check-off and `→ done` move)

### In todo/
- TECH-156 (Part B done ad hoc; Part A — fw-release in distribution — remains)
- FEAT-092, TECH-079 (pre-existing)

### Git
- `origin/main` synced; all tags pushed.
- This session's afternoon implementation pending commit.

### Next Steps
1. Commit TECH-155 implementation (this commit).
2. Check off TECH-155 acceptance criteria → `/fw-move 155 done`.
3. File TECH-157 (structural-staleness links: INDEX.md + reference-doc stale links).
4. Separate cleanup: relocate `scratch/*.md` → `poc/` (or archive), then gitignore.
5. TECH-156 Part A: add `fw-release.md` to starter, rebuild.

---

## Late Session — TECH-155 Completion + Provenance Investigation + Backlog Filing

### TECH-155 closed honestly (not force-checked)

- The `→ done` move is hard-blocked on unchecked acceptance criteria (NOT `--force`-able — verified; framework enforcement working as intended). Rather than bypass, finished the genuinely-remaining work:
  - **Link Integrity Gate** added to `distribution-build-checklist.md` (Post-Build Validation §2) — portable integrated link-walk, excludes `framework/templates/`.
  - **CHANGELOG** `[Unreleased]` updated (Added/Changed/Removed/Fixed for the link fixes, build change, duplicate removal).
  - **AC#2 reworded** honestly: zero broken links *for the 13*; additional stale links carried to TECH-158.
  - **SpearIT-KB notify** reworded from an open task to a recorded release-time follow-up (in Notes) — cross-project coordination that can't be done from this repo, so not a `→ done` blocker.
- Moved TECH-155 + artifact folder → `done/`. Committed (`c613219`).

### SpearIT-KB notification — clarified (user asked "did we discuss this?")

- We did NOT. It came pre-written in TECH-155's checklist (authored 2026-05-21). It is a note-to-self parked in the work item, NOT an automation. Nothing notifies any consuming project; no project knows about any other. The trigger, if any, must live in SpearIT-KB's own files.

### Framework provenance / update-mechanism investigation (user-prompted)

User raised: projects have no awareness of each other, but all should know the framework came from THIS project. Investigated open items + history.

**Findings (user's memory was correct — prior work exists):**
- **DECISION-050** (Framework-as-Dependency, adopted v4.0.0): decided the whole model — per-project `framework/` copies, `.framework-version` stamp, planned `Update-Framework.ps1` (preserve/replace/interactive), `<!-- CUSTOM -->` tagging. Shipped build/setup pieces; **deferred the update tooling** ("MVP is manual").
- **FEAT-051** (Update Test Harness) + **FEAT-008** (Upgrade Automation): the deferred tooling, still backlog.
- **Provenance gap (DECISION-050 Q4):** a `framework:` block with `version`/`source`/`lastUpdated` was *designed* but **never built**. Verified: distribution stamps only bare `5.4.0`; consuming `framework.yaml` has no provenance block.
- **Notification:** confirmed by design — the model is pull-based self-checking (`-Check`), never push; no consumer registry. So "no project knows about another" is intentional.

**Decision (user):** File ONLY the provenance slice now; leave larger update tooling to existing FEAT-008/FEAT-051.

### Backlog filed

- **FEAT-157** (Medium): Framework provenance stamp — source URL + version + integratedDate in the distribution; scoped to exclude update/notification tooling. References DECISION-050 Q4. Committed (`16f79ae`).
- **TECH-158** (Low): Structurally-stale links — `framework/INDEX.md`'s 33 obsolete `templates/standard/` links (not bundled, dev-facing) + small set of genuinely-stale reference-doc paths. Honestly separates the ~155 intended template placeholders and ~4 walker false-positives as NOT defects; instructs re-derivation at implementation. Committed (`860f02c`).

### ID/naming note

- "TECH-157" was floated verbally earlier for the stale-links item but never filed. To avoid collision, the provenance item took FEAT-157 and the stale-links item became TECH-158. No duplicate IDs exist.

### Decisions Made (late session)

1. **Did not `--force` TECH-155 to done** — completed real remaining work instead. The hard block is correct behavior; honoring it kept the record truthful.
2. **Provenance scoped to smallest useful slice** (FEAT-157) — source back-link is high-leverage and a prerequisite for any future staleness check, independent of whether the larger tooling is ever built.
3. **Stale links split from TECH-155** (TECH-158) — avoided silently expanding a completed item; preserved the triage (defect vs placeholder vs false-positive).

### Files Created (late session)

- `project-hub/work/backlog/FEAT-157-framework-provenance-stamp.md`
- `project-hub/work/backlog/TECH-158-framework-structural-stale-links.md`

### Files Modified (late session)

- `framework/CHANGELOG.md` - TECH-155 [Unreleased] entries
- `framework/docs/process/distribution-build-checklist.md` - Link Integrity Gate (Post-Build §2)
- `project-hub/work/done/TECH-155-...md` - criteria checked, AC#2/notify reworded, Completed date

### Files Moved (late session)

- `project-hub/work/doing/TECH-155-...` + `TECH-155/` artifact → `done/`

---

## Final State (end of session)

### In done/
- TECH-155 (complete, verified, criteria honest)

### In todo/
- TECH-156 (Part B done; Part A — fw-release in starter — remains), FEAT-092, TECH-079

### In backlog/ (new this session)
- FEAT-157 (provenance stamp, Medium)
- TECH-158 (structural-stale links, Low)

### Git
- `origin/main` branch synced earlier; all tags pushed earlier.
- 5 unpushed commits at session end (TECH-155 track + completion + FEAT-157 + TECH-158 + this session history) → **pushed at session close** per `/fw-session-history commit push`.

### Open follow-ups (all tracked, none floating)
- TECH-156 Part A: add `fw-release.md` to starter, rebuild distribution.
- FEAT-157: implement provenance stamp.
- TECH-158: fix structural-stale links.
- Separate cleanup (UNFILED — informal note): relocate `scratch/*.md` → `poc/`, then gitignore. User called this a separate activity; not yet a work item.
- Release-time: notify SpearIT-KB so it can close its TECH-001.

---

**Last Updated:** 2026-06-25

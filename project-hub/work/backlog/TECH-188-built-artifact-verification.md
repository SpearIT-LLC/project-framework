# Tech Debt: Built-Artifact Verification — Test the Archive, Not Just the Source Repo (ADR-008 WS5)

**ID:** TECH-188
**Type:** Tech Debt
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-07-22
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->
**Theme:** Distribution & Onboarding

---

## Summary

A recurring failure class (ADR-008 Root 2, ~6 items): things that work in the source repo break in the
*built* archive — `move.sh` didn't ship (BUG-170), the contract never reached derived projects
(BUG-181), `/fw-release` was absent from every bundle (TECH-156), a stale CLAUDE.md shipped (TECH-155).
The gap is invisible from inside the repo because in-repo development never exercises a built project.
This item adds a **standing check that core commands work in a built archive**, so this class fails at
build time instead of in a client's project.

**No hard dependency** — but most valuable *after* BUG-181 and TECH-185/186 land, since it then guards
the very guarantees they establish.

---

## Problem Statement

**What is the current state?**

The build (`Build-FrameworkArchive.ps1`) is verified by inspection, not by *exercising the output*.
Nothing runs `/fw-move`, `/fw-release`, or the contract-delivery end-to-end in a freshly-built project.
"Works here, not downstream" recurs (precedent traces to TECH-074, v3.6.0).

**Why is this a problem?**

Every deterministic guarantee the framework ships can silently fail to *reach* the consuming project,
and no one notices until a client hits it. It is the distribution-side twin of the silent-degradation
problem.

**What is the desired state?**

Building the archive (or a preflight in `/fw-release`) extracts to a scratch project and asserts the core
commands actually run there — engine present, contract delivered, Completed-stamp fires — failing the
build/release loud if not.

---

## Scope

**In:** an automated post-build (or `/fw-release` preflight) smoke test against an *extracted* archive
covering: `move.sh`/engine reachable, `/fw-move` performs a real move + stamps Completed, the contract
region is populated in the derived `CLAUDE.md`, `sources:` targets exist.
**Out:** full end-to-end UX testing; the git pre-commit-hook approach (rejected in BUG-170 notes — a hook
can't auto-install downstream; target a surface that ships and runs, e.g. the build or `/fw-release`).

**Files likely affected:** `tools/Build-FrameworkArchive.ps1`, `.claude/commands/fw-release.md` /
`framework/scripts`, a new smoke-test script.

---

## Acceptance Criteria

- [ ] A build/release step **extracts the archive** and runs core commands against the extracted project.
- [ ] Asserts: engine reachable; `/fw-move <id> done` moves **and** stamps `**Completed:**`; derived root
      `CLAUDE.md` contract region is populated; every `framework.yaml:sources:` target exists in the archive.
- [ ] The check **fails loud** (non-zero / blocks release) when any assertion fails — no silent pass.
- [ ] Targets a surface that provably ships/runs downstream (build or `/fw-release`), **not** a git hook.
- [ ] `framework/CHANGELOG.md` updated.

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->

- [ ] **PRE-IMPLEMENTATION REVIEW COMPLETED** — present the smoke-test surface (build vs `/fw-release`),
      the assertion list, and the failure behavior; user approves before coding.
- [ ] Author the extract-and-exercise smoke test.
- [ ] Wire it into the chosen surface (build or `/fw-release` preflight).
- [ ] Verify it catches a deliberately-broken build (e.g. omit the engine) with a loud failure.
- [ ] CHANGELOG updated.

---

## Notes

BUG-170's own notes reached this conclusion: a git pre-commit hook is the wrong backstop for a distributed
framework (`core.hooksPath` never survives clone/archive). Target the build or `/fw-release` — surfaces
that ship and run. This item generalizes BUG-170's one-off downstream check into a standing guard.

**2026-09-28 — retarget before implementation: the archive retires; the artifact is the plugin.**
This card was written against `Build-FrameworkArchive.ps1`, but ADR-009 D3 retires the archive
channel at graduation, and its Graduation Criteria make this check apply to the **plugin** ("builds
and installs from the local marketplace and passes built-artifact verification"). Two things the
card must now decide, because ADR-009 leaves both open:

1. **The published shape.** `workspaces/framework/` also holds dev-only content (`tests/`, `tools/`,
   `standards/`, `CLAUDE.md`, `workspace.yaml`). Define the shipped file list and the build/filter
   step that produces it; the smoke test verifies *that* output, not the source tree.
2. **The host — recommended: SpearIT's own GitHub marketplace**, a separate small repo (e.g.
   `SpearIT-LLC/claude-plugins`) with `.claude-plugin/marketplace.json` listing
   `spearit-framework`; users `/plugin marketplace add` it. Rationale: the earlier official-directory
   submission got no response; a self-hosted marketplace needs no approval, and the cost
   (discoverability) is nil for a framework SpearIT installs on client repos itself. A separate repo
   lets the published copy be the stripped build rather than this whole repo. This reverses the
   "submit to official marketplace only" note in `project-hub/research/plugin-anthropic-standards.md`
   §6 (FEAT-118 era); resubmitting to the official directory later remains possible.
   *Unverified, check when implementing:* whether a project's `.claude/settings.json` can declare
   the marketplace so client repos prompt for the install.

The Scope, Acceptance Criteria and Files above still name the archive; rewrite them at the
pre-implementation review, not before.

---

## Related

- **ADR-008** — Workstream 5 (built-artifact verification); the "works here, not downstream" class. Parent.
- **BUG-170** — the exemplar; its regression tests are the seed for this standing check.
- **BUG-181** — contract delivery; this guards that it keeps reaching derived projects.
- **TECH-156 / TECH-155 / TECH-074** — prior instances of ship-gap defects.
- **TECH-159** — the build's "single build method"; this extends it with output verification.

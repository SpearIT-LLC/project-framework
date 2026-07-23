# Tech Debt: Source-Repo Drift Guard — Make Divergence Unmergeable, Not Just Discouraged (ADR-008)

**ID:** TECH-189
**Type:** Tech Debt
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-07-23
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->
**Theme:** Framework Consistency

---

## Summary

The Single-Source Rule (ADR-008) is, today, **prose only** — the exact state DRY was in when the onion
grew. DRY was a stated principle "since very early," and the duplication happened anyway; the retrospective's
decisive insight is that *a principle written in a document is just another document, and documents rot.*
This item builds the one thing that makes the new rule structurally different from the old one: **a gate
that fails — non-zero, blocking — when a derived artifact drifts from its single source**, running on every
commit *to this repo* via a git pre-commit hook **and** a CI workflow.

It is the **keystone of the consolidation**: TECH-185/186/187/188 each perform a one-time cleanup, but
without a standing drift-guard every "we consolidated" is a snapshot that decays. This item is what protects
that cleanup as it happens and forever after. It should land **first** — the guard should exist before the
content it guards, so the sweeps are verified from their first commit.

**Distinct from the sibling items** (verified against the repo, not overlapping):
- **TECH-188** verifies the *built archive* at build/release time and explicitly rejects git hooks (correct
  for the *downstream/distributed* surface a hook can't reach). **This** item guards the *source repo* during
  day-to-day editing — the daily-drift window TECH-188 does not cover.
- **TECH-186** puts invariants behind `/fw-*` command chokepoints, which fire only when a command is run.
  **This** item fires on every commit regardless of which tool made it.
- Together: TECH-189 = repo stays consistent continuously; TECH-188 = the shipped artifact is consistent;
  TECH-186 = runtime invariants hold when commands run. Three surfaces, no overlap.

---

## Problem Statement

**What is the current state?**

There is **no drift or duplication guard anywhere** — not automated, not manual. Verified 2026-07-23:
- `.git/hooks/` is **empty**. The `pre-commit hook validates work items in done/` claimed in
  `framework/CLAUDE.md` is **not a git hook** — it is a Claude Code `PreToolUse` hook
  (`.claude/hooks/Validate-WorkItems.ps1`) that fires *only* when the commit is issued through Claude Code.
  A commit from a terminal, VSCode's git panel, or any other tool runs **nothing**. (This is itself a
  BUG-170-class prose/mechanism gap and this item corrects the claim.)
- `validate-framework.ps1` checks `framework.yaml` against its schema (required fields, enums) and **has no
  automatic trigger** — it runs only if a human invokes it.
- No check compares a derived artifact (e.g. the composed root `CLAUDE.md`, plugin command copies) against
  its authored source.

**Why is this a problem?**

The specific rot that caused the onion — the contract in 5 hand-synced copies drifting silently — has **zero
mechanism** watching it. Consolidation without a standing guard reproduces the original failure the moment
the repo is edited under client pressure. Enforcement that depends on a human *remembering to run a script*
is prose with extra steps; it is not a mechanism.

**What is the desired state?**

A drift-guard that (a) compares every declared derived artifact against its single source and every declared
duplication-ban pattern against the tree, (b) **exits non-zero on any mismatch**, and (c) runs on every
commit through **two independent surfaces** — a `.git/hooks/pre-commit` (fast local feedback) and a CI
workflow (`.github/workflows/`, the un-skippable backstop, since git hooks are not installed on fresh clones
and can be bypassed with `--no-verify`). Drift becomes **unmergeable**, not merely discouraged.

---

## Scope

**In:**
- A drift-check script (`tools/` or `framework/tools/`) that reads a **declarative manifest** of
  source→derived relationships and duplication-ban rules, re-derives/compares, and fails loud on mismatch.
  The manifest is itself single-source (drives both the guard and, ideally, the build).
- A `.git/hooks/pre-commit` that runs the check locally, plus a one-line installer (`core.hooksPath` or a
  setup step) so a fresh clone actually gets it — with the explicit acknowledgement that the hook is the
  *convenience* layer and **CI is the authority**.
- A **CI workflow** (GitHub Actions) that runs the drift-check on push/PR and blocks merge on failure. This
  is the "CI job" that makes enforcement independent of any human deciding to enforce.
- Correcting the false "git pre-commit hook" claim in `framework/CLAUDE.md` (and any derived copies) to
  describe what actually ships.
- A deliberately-broken fixture proving the guard goes red.

**Out:**
- The *content* consolidation itself (TECH-185/186/187 own that; this only guards it).
- Downstream/archive verification (TECH-188 owns the built artifact; a hook can't reach it).
- Runtime command chokepoints (TECH-186).
- Choosing *which* artifacts are derived vs authored — this item consumes that decision from BUG-181 /
  TECH-185; where the manifest is empty at first, the guard is a no-op that still runs green (so it can land
  before the sweeps populate it).

**Files likely affected:** new `tools/Test-Drift.ps1` (or `.sh`), new drift manifest (e.g.
`framework.yaml` `derived:`/`duplication-bans:` block or a dedicated file), new `.git/hooks/pre-commit` +
installer, new `.github/workflows/drift-guard.yml`, `framework/CLAUDE.md` (correct the hook claim),
`framework/CHANGELOG.md`.

---

## Acceptance Criteria

- [ ] A drift-check script reads a **declarative manifest** of source→derived pairs + duplication-ban
      patterns and **exits non-zero** on any mismatch, zero when clean.
- [ ] A **CI workflow** runs the drift-check on push/PR and **blocks merge** on failure (the authoritative,
      un-skippable surface). Demonstrated red on a deliberately-broken commit, green when fixed.
- [ ] A `.git/hooks/pre-commit` runs the same check locally, with an installer that a fresh clone can run;
      docs state plainly that the hook is convenience and **CI is the authority** (git hooks don't survive
      clone and `--no-verify` bypasses them).
- [ ] The guard is a **safe no-op when the manifest is empty**, so it can land before TECH-185 populates it.
- [ ] The false "git pre-commit hook" claim in `framework/CLAUDE.md` is corrected to describe the real
      mechanism (Claude Code `PreToolUse` hook) plus this new git/CI drift-guard.
- [ ] Single-source honored by the guard itself: the manifest is authored once and drives the check (and,
      where practical, the build) — the guard does not restate what it protects.
- [ ] `framework/CHANGELOG.md` updated.

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->

- [ ] **PRE-IMPLEMENTATION REVIEW COMPLETED** — present the manifest format, the check's compare strategy,
      the two-surface wiring (git hook + CI), and the empty-manifest no-op behavior; user approves before
      coding.
- [ ] Define the declarative drift manifest (source→derived pairs + duplication-ban patterns); start empty
      or with one known pair as a smoke case.
- [ ] Author the drift-check script; verify green on clean tree, red on a deliberately-broken fixture.
- [ ] Add the CI workflow (`.github/workflows/drift-guard.yml`); confirm it blocks a PR with induced drift.
- [ ] Add `.git/hooks/pre-commit` + installer; document hook-is-convenience / CI-is-authority.
- [ ] Correct the `framework/CLAUDE.md` hook claim (and derived copies).
- [ ] CHANGELOG updated.

---

## Notes

**Why this is the assurance Gary asked for (2026-07-23).** The retrospective's cure — "author once → derive
at build → enforce at a chokepoint → verify the built artifact" — is a *pattern*, and a pattern is a promise
until something forces it. The three places it already works (BUG-170's Completed-stamp, ADR-006, ADR-007)
work because each has a specific script wired to a specific trigger; the channels that rot are the ones with
nothing wired. This item wires the trigger for the Single-Source Rule so the rule stops being prose. The test
that separates real enforcement from a re-worded principle: *"What runs this without me deciding to?"* If the
answer is "I run the script" or "the AI checks," it rots under pressure. If the answer is "the commit is
rejected / CI is red / the merge is blocked," it holds. This item exists to make the answer the second one.

**Two surfaces on purpose.** The git hook gives fast local feedback but is not installed on fresh clones and
is bypassable with `--no-verify`; CI is un-skippable but slower. Neither alone is sufficient — the hook
without CI is skippable, CI without the hook lets you discover drift only after pushing. Both, and CI is the
authority.

**Anti-irony guard.** This item must not itself introduce a second copy of the rule it protects. The manifest
is the single source; the guard and the build both consume it; prose that describes the rule *points* at the
manifest rather than restating it.

---

## Related

- **ADR-008** — the Single-Source Rule + the proven pattern; this item supplies its missing enforcement trigger. Parent.
- **The Onion Retrospective (2026-07-22)** — Root 1 (hand-synced duplication) and the "DRY-by-declaration
  never survives; only DRY-by-mechanism does" insight this item operationalizes.
- **TECH-185** (duplication sweep) — populates this guard's manifest; the sweep is protected by this guard from its first commit.
- **TECH-186** (chokepoint audit) — sibling; runtime command chokepoints vs this item's commit-time repo guard. No overlap.
- **TECH-188** (built-artifact verification) — sibling; the *shipped archive* vs this item's *source repo*. Complementary surfaces.
- **BUG-181** — the contract SoT + build composer; its derived contract is the first high-value pair this guard should assert.
- **BUG-170** — the silent-degradation exemplar; and the source of the "a git hook can't reach downstream"
  lesson — honored here by making CI (not the hook) the authority and scoping the hook to the *source repo* only.

# Tech Debt: Pre-Commit Hook to Enforce `Completed` Date in done/

**ID:** TECH-168
**Type:** Tech Debt
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-07-02
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->
**Theme:** Workflow

---

## Summary

Build a pre-commit hook (and an install mechanism) that **rejects any commit where a
work item in `done/` lacks a `**Completed:** YYYY-MM-DD` date**. This is the
"suspenders" enforcement backstop for BUG-167 — it catches any path to `done/` that
bypasses `move.sh` so the field cannot silently lapse again.

## Motivation

BUG-167 restored the `Completed` field and made `move.sh` stamp it on `→ done/`
(the "belt"). But that only guarantees the date when the sanctioned move script runs.
A backstop is needed for bypass paths (manual `git mv`, plugin inline scripts,
future tooling).

**Discovered during BUG-167:** CLAUDE.md states "a pre-commit hook validates work
items in done/", but **no such hook actually exists** — `.git/hooks/` contains only
samples, no `core.hooksPath` is configured, and no hook script is committed to the
repo. So this is a from-scratch build, not an extension. That's why it was split out
of BUG-167.

## Scope

**In:**
- A pre-commit hook script (committed to the repo, e.g. `framework/hooks/pre-commit`
  or `.githooks/`) that scans staged `project-hub/work/done/*.md` and fails the
  commit if any lacks a `**Completed:**` date (YYYY-MM-DD).
- An **install mechanism** — git hooks are not version-controlled/auto-installed by
  default. Options: `git config core.hooksPath <dir>` documented in setup, or an
  install step in `Setup-Framework.ps1` / a `tools/` script. Decide during impl.
- Clear failure message pointing at the fix ("run /fw-move to set the date").
- Reconcile CLAUDE.md's claim with reality (either the hook now exists, or fix the
  doc).

**Out:**
- The stamping logic itself (done in BUG-167).
- Broader hook framework / other validations (keep this hook single-purpose unless
  an existing validation hook is adopted).

## Acceptance Criteria

- [ ] Pre-commit hook exists in the repo and is installable via a documented step.
- [ ] Commit is rejected when a staged `done/` item lacks a `Completed:` date.
- [ ] Commit succeeds when all `done/` items have the date.
- [ ] Failure message is actionable.
- [ ] CLAUDE.md's "pre-commit hook validates done/" claim is now true (or corrected).

## Notes

- Consider whether the hook should validate other `done/` invariants (acceptance
  criteria checked) to avoid a proliferation of single-purpose hooks — but don't let
  scope creep block the `Completed`-date enforcement.

## Related

- BUG-167 (restored + stamps the field — the "belt"; this is the "suspenders")
- TECH-169 (command-copy reconcile)
- DECISION-162, TECH-161 (command-tier drift)

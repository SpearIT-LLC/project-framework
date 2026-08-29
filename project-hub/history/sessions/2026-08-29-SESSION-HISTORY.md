# Session History: 2026-08-29

**Date:** 2026-08-29
**Participants:** Gary Elliott, Claude Code
**Session Focus:** TASK-206 review — UAT run results, cards filed, task closed

---

## Summary

Reviewed the completed UAT run (`workspaces/framework/tests/UAT-RESULTS-2026-08-26.md`,
2026-08-26..29, plugin 0.4.0): 30 rows (UAT-00–29 incl. 15b), 29 PASS, 1 FAIL (UAT-13).
Filed the cards the run called for, ticked TASK-206's acceptance criteria, and moved
TASK-206 → done. Gary decided to keep the `framework-uat` throwaway repo for further
testing.

---

## Work Completed

### TASK-206: Run UAT-COMMANDS Against a Fresh Consuming Repo (done)

Cards filed (all `Workspace: framework`, in backlog/):

- **BUG-207** — contact records: optional fields deleted by template rule, no update
  path in `/fw-contacts` (UAT-13 FAIL; folds in the UAT-10 error-wording note and the
  `fw-new-contact.sh` option).
- **BUG-208** — `fw-new-workspace` leaves a half-built workspace when a project override
  lacks the type overlay (UAT-06 ad-hoc); validate before creating; announce override runs.
- **FEAT-209** — kb sub-topic depth, option (b) decided by Gary on 2026-08-29 (UAT-23):
  `<domain>/<subtopic>`, provenance folders at the leaf, one level.
- **FEAT-210** — one UX pass for the remaining findings, grouped by command (guard
  errors in command syntax + type mapping, purpose pre-fill/help, ops-record intake before
  slug, contacts INDEX/exports, rung names + announce, configurable kb path, anchor
  ambiguity). Carries the deferred crossover decision (bare ids → require prefix) and
  the surprising-but-correct notes for the owning FEATs.

Judgment call: the owning FEATs (164, 192, 194, 195, 202, TASK-197) are archived under
`history/releases/framework-dev/v0.4.0/`; rather than edit release archives, their UAT
notes are recorded in FEAT-210. The UAT-25 "product BUG" is against the throwaway
`widget` and was not filed.

## Files Created

- `project-hub/work/backlog/BUG-207-contact-records-optional-fields-and-update-path.md`
- `project-hub/work/backlog/BUG-208-new-workspace-half-built-on-missing-override-overlay.md`
- `project-hub/work/backlog/FEAT-209-kb-sub-topic-depth.md`
- `project-hub/work/backlog/FEAT-210-new-build-command-ux-pass.md`

## Files Modified

- `project-hub/work/done/TASK-206-run-uat-commands-fresh-repo.md` - acceptance criteria ticked, Outcome section
- `workspaces/framework/tests/UAT-RESULTS-2026-08-26.md` - housekeeping line: repo kept, cards filed

## Files Moved

- `project-hub/work/doing/TASK-206-run-uat-commands-fresh-repo.md` → `project-hub/work/done/`

---

## Current State

### In doing/
- (empty)

### In done/ (awaiting release)
- FEAT-193, FEAT-195, TASK-206 — 3 items

### Next
- Pick up BUG-207 (the one FAIL) and FEAT-209 (decided design); FEAT-210 at design review.
- `framework-uat` kept; re-run affected UAT rows there as each card lands.

---

**Last Updated:** 2026-08-29

# Session History: 2026-08-30

**Date:** 2026-08-30
**Participants:** Gary Elliott, Claude Code
**Session Focus:** BUG-207 verification — UAT-10..13 re-run against spearit-framework-dev 0.4.1

---

## Summary

Re-ran the four `/fw-contacts` tests (UAT-10..13) from `UAT-COMMANDS.md` in the
`framework-uat` throwaway repo against the 0.4.1 build (BUG-207 fix). All four PASS;
UAT-13 — the one FAIL of the 2026-08-26..29 run — is now superseded. BUG-207 moved to
`done/`. Session ran from a remote session in `framework-uat` with the plugin installed
from the `dev-marketplace` manifest in this repo.

---

## Work Completed

### BUG-207: Contact records — optional fields deleted, no update path (→ done)

- Start state prepared by tester: prior records moved to `kb/company/contacts-back/`
  (kept for now), so no registry existed; stale 0.4.0 `CONTACTS.md` views left in place.
- UAT-10: no-records error now in command syntax (`/fw-contacts <person name>`); ad-hoc
  `--root` check confirms the separate no-`company`-domain message
  (`/fw-new-kb-domain company`) from both `fw-contacts.sh` and `fw-new-contact.sh`.
- UAT-11: intake conversation first (drafts offered, "ok"); `fw-new-contact.sh` seeded
  `contacts/` + registry README on first use and stripped the template header; two records
  filled with blank optionals retained; views generated, `ghost-ws` warning, zero contact
  facts in views (grep).
- UAT-12: stale `widget/CONTACTS.md` removed on rerun; header guard intact.
- UAT-13: contract met (no `__` placeholders, blanks kept, Activity clean); "phone is
  555-0100" filled the blank Phone in place; duplicate create refused by the gate
  ("record already exists … update it instead"). Last acceptance criterion ticked.
- Results recorded: re-run section in `UAT-RESULTS-2026-08-26.md`, new row in the
  runbook's Results table.

---

## Decisions Made

1. **Realistic start state over a clean wipe:** stale generated views from 0.4.0 were left
   for UAT-11 to overwrite; the old records stay in `contacts-back/` in `framework-uat`
   (tester's call) rather than being deleted.
2. **Commit straight to `main`:** matches the repo's existing practice for this work.

---

## Files Modified

- `project-hub/work/done/BUG-207-contact-records-optional-fields-and-update-path.md` - last AC ticked, Completed stamped by fw-move.sh
- `workspaces/framework/tests/UAT-COMMANDS.md` - Results row for the 2026-08-30 re-run
- `workspaces/framework/tests/UAT-RESULTS-2026-08-26.md` - "Re-run 2026-08-30" section

## Files Created

- `.claude-plugin/marketplace.json` - dev-marketplace manifest (plugins served from this repo; committed this session)

## Files Moved

- `project-hub/work/doing/BUG-207-…md` → `project-hub/work/done/`

---

## Current State

### In doing/
- (empty)

### In done/ (awaiting release)
- FEAT-193, FEAT-195, TASK-206, BUG-207 — see folder listing (5 files)

### Next
- FEAT-209 (kb sub-topic depth, design decided); FEAT-210 at design review.
- `framework-uat` kept; `contacts-back/` can be deleted once no longer useful.

---

**Last Updated:** 2026-08-30

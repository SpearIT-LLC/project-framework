# Session History: 2026-09-01

**Date:** 2026-09-01
**Participants:** Gary Elliott, Claude Code
**Session Focus:** BUG-212 completion — verify the contact create gate against the installed plugin, then close the refresh gap that verification surfaced (0.4.4 → 0.4.6)

---

## Summary

BUG-212's last acceptance criterion required verification against the built plugin.
Getting there meant committing the pending 0.4.4 auto-refresh work, clearing a stale
plugin install record, and running UAT-13's name-only case on the installed plugin —
which passed. The verification run then surfaced a real gap: a contact record edited
outside Claude Code left `CONTACTS.md` stale for the rest of the session. No open card
covered it, so it was folded into BUG-212 and fixed in 0.4.5 with a `SessionStart`
refresh. 0.4.6 renamed the manual regen to `/fw-contacts refresh`, and UAT-30..32 were
back-recorded so the three refresh paths are numbered tests rather than prose.

---

## Work Completed

### BUG-212: Contact create gate seeds placeholder tokens → **done**

- Verified the create gate on the **installed** plugin in `framework-uat` (0.4.4):
  `/fw-contacts Wilma Flintstone` produced a valid name-only record — display name
  title-cased from the slug, all other fields blank, `Assigned: Unassigned`, no `__`
  tokens. Registry-wide grep for `__` clean across all five records.
- Scope extended mid-session to cover stale views after an outside-Claude edit (see
  Decisions #1). Fixed in 0.4.5; criterion added and ticked.
- Moved to `done/` via `/fw-move` (Completed date stamped automatically).

### 0.4.4 — CONTACTS.md auto-refresh from both ends (committed, was pending)

- `hooks/hooks.json` + `hooks/refresh-contacts.sh` (PostToolUse), `fw-contacts.sh
  --check`, `tools/pre-commit`, `tools/install-git-hooks.sh`.
- `--check` verified green against `framework-uat`. Note it exits 1 in *this* repo by
  design — the framework source tree has no `workspaces/kb/company`, so it has no
  contacts to check. Relevant if `--check` is ever wired into CI here.

### 0.4.5 — SessionStart refresh

- `hooks.json` gains `SessionStart` (`startup|resume|clear`) running
  `refresh-contacts.sh --all`: skips the stdin `file_path` parse, resolves the repo root
  via `git rev-parse`, regenerates unconditionally.
- Verified by direct invocation: outside-Claude edit picked up; no-registry repo silent
  at exit 0; non-git directory silent at exit 0; PostToolUse path and its
  unrelated-file no-op unregressed. Later confirmed live by Gary at session start.

### 0.4.6 — `/fw-contacts refresh`

- Self-documenting name for what was the bare argument-less form (which still works).
- Follows `/fw-move`'s existing bare-`sweep` keyword convention.
- `refresh` reserved in that slot; a person named Refresh is addressed by slug
  (`/fw-contacts refresh-smith`). Documented in the command file.

### UAT-30..32 back-recorded

- Numbered tests added to section C: PostToolUse refresh on a Claude edit; outside-Claude
  edit *not* caught mid-session (expected, not a defect); `/fw-contacts refresh`.
- Results marked back-recorded with per-observation provenance. **These have never been
  executed as written, start to finish** — they describe what was observed, not a clean
  run. Worth an actual pass in a restarted `framework-uat` session.

---

## Decisions Made

1. **Fold the outside-edit refresh gap into BUG-212 rather than file a new card.**
   - Checked first: no open card in `backlog/`, `todo/`, or `doing/` covered it.
   - Gary's call — "if not, just extend BUG-212, fix it and move on." Arguably out of
     BUG-212's original create-gate scope, but filing a card to immediately close it
     added ceremony without adding information.

2. **Reject `FileChanged` as the mechanism for outside-edit detection.**
   - It is the hook designed for this, but its matcher takes literal filenames from a
     narrow character set (letters, digits, `_`, `|`) and cannot express "any record in
     `contacts/`" when filenames are arbitrary person-slugs. Docs also leave its
     watch-list construction and payload unspecified.
   - `SessionStart` chosen instead: documented, sufficient, and the earliest boundary at
     which an outside edit can be caught. Revisit if `FileChanged` semantics change.

3. **No real-time filesystem watcher.**
   - Gary: a contacts list changes mostly at project start and very little mid-project,
     so a watcher is disproportionate to the problem.
   - Accepted contract: Claude edits refresh themselves; `/fw-contacts refresh` is the
     mid-session catch-up; session start and pre-commit are the backstops.

---

## Corrections Recorded

Both are written into `UAT-RESULTS-2026-08-26.md` so the record isn't misleading:

1. **`fw-contacts.sh` is not case-buggy.** It was briefly mis-diagnosed as having a
   case-sensitivity/overwrite defect after an `Assigned: Widget` record produced a view
   missing that contact. A `bash -x` trace showed the parse and write paths are sound —
   `Widget` and `widget` are the same directory on Windows, and the two `WSLIST` passes
   overwrote each other. Diagnosis was made from a code read before running the script;
   running it first would have avoided the error.
   - **Real latent risk noted for FEAT-211:** on a case-sensitive filesystem the same
     record yields a genuinely separate `Workspace/` directory, and two assignment
     spellings resolving to one directory silently clobber each other.

2. **Our `hooks.json` schema is correct.** A subagent reported that a plugin's
   `hooks/hooks.json` should not wrap the event map in a top-level `"hooks"` key. The
   official docs show the wrapper *is* correct for plugins — consistent with the hook
   demonstrably firing. Primary source beat the summary.

---

## Environment Fix

**Stale plugin install records cleared.** `~/.claude/plugins/installed_plugins.json` held
two entries for `spearit-framework-dev@dev-marketplace`, both 0.4.3, both pointing at a
`cache/dev-marketplace/...` directory that does not exist. Gary edited the file (writes
to it were blocked for the AI, and Claude Code appended a duplicate entry mid-session).
The plugin then loaded correctly at 0.4.4 with **no cache directory at all** — a
`directory`-source marketplace resolves in place rather than through the cache, so the
missing directory was never a fault. No defect filed.

---

## Files Modified

- `workspaces/framework/.claude-plugin/plugin.json` — 0.4.3 → 0.4.6
- `workspaces/framework/CHANGELOG.md` — SessionStart refresh; `/fw-contacts refresh`
- `workspaces/framework/commands/fw-contacts.md` — `refresh` keyword, when to use it,
  reserved-word escape hatch; manual-rerun instruction dropped
- `workspaces/framework/scripts/fw-contacts.sh` — `--check` mode
- `workspaces/framework/hooks/hooks.json` — SessionStart entry added
- `workspaces/framework/hooks/refresh-contacts.sh` — `--all` branch
- `workspaces/framework/tests/UAT-COMMANDS.md` — UAT-30..32 + two run-log rows
- `workspaces/framework/tests/UAT-RESULTS-2026-08-26.md` — 2026-09-01 sections
- `project-hub/work/done/BUG-212-*.md` — criteria ticked, scope-extension section
- `claude-local-marketplace/.claude-plugin/marketplace.json` (outside repo) — 0.4.6

## Files Created

- `workspaces/framework/hooks/hooks.json` — plugin hook declaration
- `workspaces/framework/hooks/refresh-contacts.sh` — PostToolUse + SessionStart refresh
- `workspaces/framework/tools/pre-commit` — blocks a commit with stale views
- `workspaces/framework/tools/install-git-hooks.sh` — per-clone hook installer

## Files Moved

- `project-hub/work/doing/BUG-212-contact-create-gate-seeds-placeholder-tokens.md` →
  `project-hub/work/done/`

---

## Commits

- `466114c` feat: CONTACTS.md views auto-refresh from both ends; 0.4.4
- `a850222` fix: Complete BUG-212 — session-start refresh closes the outside-edit gap; 0.4.5
- `8929c1e` feat: /fw-contacts refresh — self-documenting name for the view regen; 0.4.6
- `79853bb` docs: back-record UAT-30..32 — the three CONTACTS.md refresh paths

---

## Current State

### In done/ (awaiting release) — 6 items
- BUG-207, BUG-208, BUG-212, FEAT-193, FEAT-195, TASK-206

### In doing/
- *(empty)*

### Open threads for next session
- **UAT-30..32 never executed as written.** Back-recorded from observation; worth a
  clean pass in a restarted `framework-uat` session.
- **FEAT-211** carries the `Role:` vs per-assignment function work, plus the new
  case-sensitivity risk in `Assigned:` values.
- **CI not wired for `--check`.** Ready to drop into a workflow; `framework-uat` has no
  `.github/`. Note the source repo itself has no contact registry, so `--check` exits 1
  there by design.
- **6 items in done/** — under the 10-item nudge threshold, but a release is approaching.

---

**Last Updated:** 2026-09-01

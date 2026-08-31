# Session History: 2026-08-31

**Date:** 2026-08-31
**Participants:** Gary Elliott, Claude Code
**Session Focus:** BUG-208 (fw-new-workspace half-built on missing override overlay) — fix, 0.4.2, UAT-06 re-run; dev-marketplace recovery

---

## Summary

Reviewed the 2026-08-30 UAT-10..13 re-run (4/4 PASS on 0.4.1; BUG-207 already closed by that
session). Took BUG-208 through `/fw-move → doing`, pre-implementation review, fix, scratchpad
checks, 0.4.2 bump + marketplace republish, and the UAT-06 re-run in `framework-uat` (PASS,
recorded in the results file by the consuming-repo session). Diagnosed a broken dev-marketplace
registration at session end: the marketplace was removed wholesale while chasing a duplicate
install record; recovery steps given, nothing lost.

---

## Work Completed

### BUG-208: fw-new-workspace half-built workspace on missing override overlay (verified; all criteria ticked)

- **Root cause (confirmed in source):** `fw-new-workspace.sh` resolved `$TPL` (override or plugin)
  and ran `mkdir -p "$WS"` before checking that `$TPL/floor` and `$TPL/$TYPE` exist, so a
  missing overlay died mid-`cp` and left the half-built tree.
- **Fix:** validate the template set before creating anything; `operations` needs only its own
  overlay (it opts out of the floor). Refusal message names the missing folder(s) and the
  wholesale rule ("copy the plugin's full templates/workspaces/ tree first, then edit. Nothing
  created."); a broken plugin install on the non-override path gets a distinct message.
  Override runs print `Using project template override: .claude/templates/workspaces/`.
- Command file (`commands/fw-new-workspace.md`) now states that an override replaces the plugin
  templates entirely, and describes the announce/refuse behaviour.
- Runbook UAT-06 gained the ad-hoc case as a scripted step (`product missing-type` → clean
  refusal, nothing on disk) plus the announce line.
- Scratchpad checks (`--root`): normal path unchanged; missing type, missing floor+type, and
  missing operations overlay all refuse with nothing on disk; valid override announced with
  `custom-floor/` and the override README.
- Plugin bumped 0.4.1 → 0.4.2; `Publish-ToLocalMarketplace.ps1` republished (pwsh 7 — the
  script `#requires` 7.0, Windows PowerShell 5.1 refuses it); repo copy
  `.claude-plugin/marketplace.json` refreshed to match.
- **UAT-06 re-run (framework-uat, 0.4.2): PASS** — announce line, wholesale override, missing
  overlay refused before mkdir, plugin templates checksum-identical before/after. Recorded in
  `UAT-RESULTS-2026-08-26.md` "Re-run 2026-08-31" and the runbook Results table. Note from that
  run: `installed_plugins.json` pointed at a cache path that did not exist after the reinstall —
  the script ran from the source plugin root.

### Dev-marketplace breakage (diagnosed, not yet repaired)

- Symptom: Gary tried to remove a duplicate entry and "goofed up" the dev-marketplace.
- Found: `known_marketplaces.json` lists only `claude-plugins-official`; no `marketplaces/`,
  `cache/`, or `installed_plugins.json` entries for dev-marketplace; `framework-uat`
  `enabledPlugins` is `{}`. I.e. the marketplace registration was removed entirely (likely
  `/plugin marketplace remove dev-marketplace`), which uninstalls everything from it.
- The duplicate being chased was almost certainly the two `spearit-framework-dev@dev-marketplace`
  install records seen 2026-08-29, identical except `C:\` vs `c:\` in `projectPath` — a Claude
  Code quirk, harmless.
- Source is intact: `Projects/claude-local-marketplace/` manifest at 0.4.2, three junctions valid.
- Recovery: `/plugin marketplace add C:\Users\gelliott\OneDrive\Documents\SpearIT\Projects\claude-local-marketplace`;
  in framework-uat `/plugin install spearit-framework-dev@dev-marketplace --scope local`; in
  project-framework the three `@dev-marketplace` plugins are still enabled in
  `settings.local.json` and should auto-install once the marketplace is known. Restart after.

---

## Decisions Made

1. **Validate-before-create is the rule for scaffold scripts:** every "cannot proceed" condition
   is checked before the first `mkdir`; the script never leaves partial structure. Same posture
   as `fw-new-contact.sh` (BUG-207).
2. **Type discovery from template folders (`type.conf`) stays back-pocket** — recorded on the
   BUG-208 card's Notes; would amend ADR-009 D3's closed type list. Not now.
3. **Dev-version bumps are routine for UAT re-tests** (0.4.1 → 0.4.2): the consuming repo runs a
   cached copy, so only a version change makes it pick up fixes.

---

## Files Modified

- `workspaces/framework/scripts/fw-new-workspace.sh` - template-set validation before mkdir; override announce; distinct broken-install message
- `workspaces/framework/commands/fw-new-workspace.md` - wholesale-override rule, announce/refuse behaviour
- `workspaces/framework/tests/UAT-COMMANDS.md` - UAT-06 expanded (announce + missing-overlay step); Results row for the 0.4.2 re-run
- `workspaces/framework/tests/UAT-RESULTS-2026-08-26.md` - "Re-run 2026-08-31" section (UAT-06 PASS)
- `workspaces/framework/CHANGELOG.md` - Fixed entry for BUG-208
- `workspaces/framework/.claude-plugin/plugin.json` - 0.4.2
- `.claude-plugin/marketplace.json` - refreshed copy of the published manifest (0.4.2)
- `project-hub/work/doing/BUG-208-new-workspace-half-built-on-missing-override-overlay.md` - all four acceptance criteria ticked with evidence

## Files Moved

- `project-hub/work/todo/BUG-208-…md` → `project-hub/work/doing/`

---

## Current State (as of the first commit, `ce76296`)

### In doing/
- BUG-208 — all acceptance criteria ticked; ready for `/fw-move BUG-208 done` (not moved this
  session — Gary is restarting after the marketplace fix).

### In done/ (awaiting release)
- FEAT-193, FEAT-195, TASK-206, BUG-207 — 4 items

### In todo/ (from the UAT run)
- FEAT-209 (kb sub-topic depth, design decided), FEAT-210 (command UX pass)

### Next
1. Re-add the dev marketplace and reinstall (steps above); restart.
2. `/fw-move BUG-208 done`.
3. FEAT-209 or FEAT-210 next; both re-test in `framework-uat` (kept for this purpose).

---

## (Later) BUG-208 → done

**Continuation:** after the restart, `/fw-move BUG-208 done` — acceptance-criteria gate passed
(all four ticked), `Completed: 2026-08-31` stamped by the script. No artifact folder.

### Current State (end of session)

- **doing/:** empty
- **done/ (awaiting release):** FEAT-193, FEAT-195, TASK-206, BUG-207, BUG-208 — 5 items
- **todo/:** FEAT-209, FEAT-210 (+ BUG-181, FEAT-163, FEAT-175, TECH-177 from before)
- **Next:** FEAT-209 (kb sub-topic depth) or FEAT-210 (command UX pass); a framework-dev
  release could bundle the five done items once one of those lands.

---

## (Later) Ad-hoc contacts run on 0.4.2 — two cards filed

**Continuation:** after the marketplace was re-registered, the plugin worked in
`framework-uat` and Gary ran an ad-hoc `/fw-contacts <name>` add (not a numbered test),
recorded in the results file's "Ad-hoc 2026-08-31" section.

- **Result:** the BUG-207 add path works end to end from the *installed* plugin, and
  `Assigned: Unassigned` is handled cleanly — no error, no spurious view, no attempt to
  create an `Unassigned` workspace folder. It also demonstrated the UAT-12 master-view
  gap concretely: an unassigned person appears in no generated view at all.
- **BUG-212 filed** — the create gate seeds placeholder tokens (`__ORG__`, `__EMAIL__`)
  while the template forbids placeholders surviving, so there is no legal resting state
  between "created" and "fully filled". Since the normal case is partial (often you only
  have a name), the gate should emit empty `**Field:**` lines instead; guidance moves to
  the command or a stripped comment header. Notably, the card records a *withdrawn*
  reading: this is not the ops-record "intake before create" ordering problem, because a
  contact slug encodes the name — the one fact always known first.
- **FEAT-211 filed** — contact assignment rework: `Role:` conflates org title with
  per-engagement function (rename the header to `Title:`); `—` is a poor delimiter
  (`;` chosen, comma rejected — it occurs inside names); batch assign for the O(N)
  problem at ~50 contacts. Wildcards/shorthand rejected on auditability grounds (a
  derived set is not a fact); defaulting function from title proposed and withdrawn.
- **Cross-references added by me:** FEAT-210's contacts section had claimed the grammar
  spec and `fw-contacts --check`, which FEAT-211 now owns — FEAT-210 keeps the INDEX
  master view and structured exports, both of which consume whatever grammar FEAT-211
  settles. Recommended order recorded on the cards: BUG-212 (small, independent) →
  FEAT-211 (grammar + `--check`) → FEAT-210's remaining contacts items.

### Current State (end of session, revised)

- **doing/:** empty
- **done/ (awaiting release):** FEAT-193, FEAT-195, TASK-206, BUG-207, BUG-208 — 5 items
- **todo/:** FEAT-209, FEAT-210 (+ BUG-181, FEAT-163, FEAT-175, TECH-177)
- **backlog/ (new today):** BUG-212, FEAT-211

---

**Last Updated:** 2026-08-31

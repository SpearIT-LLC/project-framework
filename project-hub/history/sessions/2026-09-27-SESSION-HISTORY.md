# Session History: 2026-09-27

**Date:** 2026-09-27
**Participants:** Gary Elliott, Claude Code
**Session Focus:** Remote session (no UAT machine). Release-order recommendation, and a
review of the framework a year on, which produced SPIKE-248.

---

## Summary

Gary was away from the UAT machine, so the session did the work that only needs this repo.
The release question carried from 2026-09-24 got a recommendation grounded in the repo: there
is no `v5.7.0`. Gary then asked what about the framework is still valid after nearly a year.
The review found the principles sound and the delivery channel (`CLAUDE.md`) dated. It also
found `CLAUDE.md` has drifted from its own single source. That became SPIKE-248, with a slim
`CLAUDE.md` draft attached.

---

## Work Completed

### Release order (recommendation, awaiting Gary's yes)

**Recommendation: one release, `framework-dev-v0.5.0`, after G2 passes and FEAT-229 closes.
There is no `v5.7.0`.** The facts behind it:
- All 13 cards in `done/` are `Workspace: framework`, the new build.
- The `v5.6.0` tag message says "archive line superseded by the ADR-009 plugin build".
- `framework-dev` is the line that's overdue: its last tag is `framework-dev-v0.4.0`
  (2026-08-24), `plugin.json` has gone up to 0.4.7 untagged, and the CHANGELOG has about 260
  lines under `[Unreleased]`.

The 2026-09-24 framing of an "overdue main framework `v5.7.0` (13 cards in `done/`)" was wrong.
It assumed those cards belonged to the old line.

### Framework review: what still holds after a year

Gary asked what is still valid and what is old methodology, judged by the framework's primary
purpose, with particular interest in `CLAUDE.md`.

- **Still holds:**
  - ADR-001: implement only approved work. More important with more capable models.
  - ADR-008: mechanism over prose, and one source per concept.
  - The written record in git.
  - The Epistemic Standards.
- **Dated:**
  - ADR-007's premise that `CLAUDE.md` is the only auto-loaded channel. There are now skills,
    hooks, plugins, user-level memory and output styles.
  - Bootstrap steps written as prose that a hook could enforce.
  - Persona framing, and the emphatic prompting written for 2025 models.
  - Ceremony sized for a team, run by one person.
- **Verified drift:** the root `CLAUDE.md` Response Style was edited directly on 2026-09-10.
  `.claude/framework-contract.md`, its supposed single source, still has the old "5 lines or
  fewer" rule (last changed 2026-07-22).
- **The meta-cost:** most recent effort goes into the framework itself. The proposed audit asks
  of each part: does Claude Code now do this natively? If so, delete ours.

### SPIKE-248 filed

`backlog/SPIKE-248-rebaseline-framework-against-current-claude-code.md` (High, 4h timebox).
The card holds the evidence, the starting hypotheses, what to determine and exit criteria. Its
bundle `SPIKE-248/claude-md-slim-draft.md` is a draft root `CLAUDE.md` of about 40 lines. It
keeps the repo identity, the Implementation Rule, the Epistemic Standards and the one-source
rule, and lists where each removed section goes.

---

## Decisions Made

1. **The framework review goes into a spike, not piecemeal edits** (Gary: "Yes"). The findings
   touch ADR-007, which carries a decision; they should be weighed against the backlog, not
   applied while Gary is away.
2. **The slim `CLAUDE.md` is a draft only.** The live `CLAUDE.md` is unchanged.

**Pending:** Gary's yes on the release recommendation.

3. **Release order — decided (later in the session).** Gary confirmed: **one release,
   `framework-dev-v0.5.0`, after G2 passes and the FEAT-229 family reaches `done/`. No `v5.7.0`.**
   The v5.x line ended at `v5.6.0`; the 13 cards in `done/` ship with the board in v0.5.0.

---

## Files Created

- `project-hub/work/backlog/SPIKE-248-rebaseline-framework-against-current-claude-code.md`
- `project-hub/work/backlog/SPIKE-248/claude-md-slim-draft.md` - draft, not applied
- `project-hub/history/sessions/2026-09-27-SESSION-HISTORY.md` - this file

## Files Moved

- None.

---

## Current State

### In doing/ — 1 WIP item (5 files)
The FEAT-229 family. UAT-37 to UAT-52 pass. **Resume at UAT-53** on the local machine.

### In done/ — 13 · todo/ — 13 · backlog/ — 95

---

## Next Session

1. **Resume at UAT-53** (local): `/fw-move 904 doing` typed to Claude in `framework-uat`, then
   UAT-54 to UAT-57.
2. **FEAT-229 family to `done/`**, then `/fw-release` for `framework-dev-v0.5.0` (decided).
3. **SPIKE-248:** prioritize it against the backlog. It feeds the ADR-009 build, so it is
   cheaper to do before graduation.
4. **Carried:** BUG-245 (now including the UAT-49 findings), BUG-246, TECH-247, the old-vs-new
   `fw-move.sh` audit, the duplicate `installed_plugins.json` entry, TECH-243, the TECH-232
   reconcile, a `/fw-backlog` pass, BUG-237, and `git mv` of BUG-225 to `archive/`.

---

**Last Updated:** 2026-09-27

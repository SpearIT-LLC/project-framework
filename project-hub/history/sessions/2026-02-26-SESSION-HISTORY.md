# Session History: 2026-02-26

**Date:** 2026-02-26
**Participants:** User, Claude Code
**Session Focus:** fw-move command testing and bug fix

---

## Summary

Ran batch move tests using test fixture work items in the 900-series ID block. Identified and fixed an AI behavior issue where the `/fw-move` command caused unnecessary clarification prompts when moving a parent item that has children.

---

## Work Completed

### /fw-move command — batch test runs

- Moved FEAT-901, FEAT-902, FEAT-903, BUG-904, FEAT-905 from `todo/` → `backlog/` (batch numeric IDs)
- Attempted move of FEAT-909 (parent with 3 children) from `backlog/` → `todo/`
  - Paused due to AI asking for clarification on parent vs. parent+children scope
  - Root cause identified: command prompt was silent on child-auto-move behavior

### /fw-move command — AI behavior fix (FEAT-145)

- Added global note to `.claude/commands/fw-move.md` under `## Embedded Transition Checklists`:
  > "When a parent ID is specified, the script automatically includes all child items. Do NOT ask for clarification — always move parent + children together."
- Confirmed the fix belongs in the local command file only (plugin version has a different structure with no embedded checklists)

---

## Decisions Made

1. **Where to place the parent+children clarification note:**
   - Placed once at the top of `## Embedded Transition Checklists`, covering all transitions globally
   - Rejected: duplicating it in each per-transition checklist (6+ locations, maintenance burden)
   - Rejected: placing it only in `→ todo/` (would miss other targets like `doing/`, `done/`)

2. **Script is not the problem:**
   - `framework/scripts/move.sh` already handles parent+child auto-move correctly via `find_parent()` / `find_children()` functions
   - The issue was purely in AI prompt guidance, not script behavior

---

## Files Modified

- `.claude/commands/fw-move.md` — Added parent+children auto-move note to `## Embedded Transition Checklists` header

## Files Moved

- `project-hub/work/todo/FEAT-901-test-single-full-id.md` → `backlog/`
- `project-hub/work/todo/FEAT-902-test-single-numeric-id.md` → `backlog/`
- `project-hub/work/todo/FEAT-903-test-batch-full-id-a.md` → `backlog/`
- `project-hub/work/todo/BUG-904-test-batch-full-id-b.md` → `backlog/`
- `project-hub/work/todo/FEAT-905-test-batch-numeric-a.md` → `backlog/`

---

## Current State

### In doing/
- FEAT-145: fw-move + script engine (active — today's fix is part of this work item)

### In todo/
- (900-series test fixtures now deprioritized back to backlog/)

---

---

## (Later) fw-move Child Split Detection — Design & Implementation

### Additional Test Runs

- Moved FEAT-909 (parent) + children 909.1, 909.2, 909.3 from `backlog/` → `todo/`
  - Parent auto-moved correctly; children 909.1–909.3 were already in `todo/` (skipped, no error)
- Moved FEAT-910 from `backlog/` → `todo/`
  - Two files matched: `FEAT-910-test-any-extension.md` and `FEAT-910-test-any-extension.txt`
  - Both moved correctly — confirms move.sh handles non-.md extensions
- Moved FEAT-909.1 independently from `todo/` → `backlog/` (deliberate split test)
  - No warning issued — gap identified

### Decision: Child Split Warning

**Trigger:** Moving a child ID directly (e.g. `909.1`) when parent is in a different folder than the target.

**Rule:**
- **Warn** on `backlog`, `todo`, `blocked` targets — lifecycle state changes where a split family is unusual
- **Skip warning** on `doing`, `done`, `archive` — children legitimately progress or cancel independently

**Rationale:** The only common legitimate reason to move a child separately is `→ done` (sub-task completed) or `→ doing` (starting just this sub-task). Moving a child to `backlog`/`todo`/`blocked` without the parent is almost always accidental.

**Implementation:** Added "Child moved separately — split family detection" block to `.claude/commands/fw-move.md` under the "Parent + children" note. Added matching example to Error Handling section.

---

## Files Modified (Later)

- `.claude/commands/fw-move.md` — Added child-split warning rule and error handling example

## Files Moved (Later)

- `project-hub/work/backlog/FEAT-909-test-parent.md` → `todo/`
- `project-hub/work/backlog/FEAT-910-test-any-extension.md` → `todo/`
- `project-hub/work/backlog/FEAT-910-test-any-extension.txt` → `todo/`
- `project-hub/work/todo/FEAT-909.1-test-child-one.md` → `backlog/` (deliberate split test)

---

## (Later) FEAT-145 — Script-Layer Policy POC (SPIKE-145)

### Context: WIP Check Architecture Discussion

Reviewed the WIP limit check that exists in both `move.sh` (warning only) and `fw-move` (hard block).
Identified that these are independent implementations of the same check — the script's warning is
redundant for normal `fw-move` usage since the AI always blocks first. It only provides value for
direct `move.sh` callers bypassing `fw-move`.

### Decision: Push Policy Into Script Layer

**Hypothesis:** Moving hard-block policy checks into the script yields faster execution on the
happy path. The AI layer only engages when something needs judgment or interactive recovery.

**Checks moving to script layer:**
- Transition matrix — pure rule lookup, no judgment needed
- Dependency check — scriptable grep of `Depends On:` field
- Acceptance criteria — scriptable grep for unchecked `[ ]`

**Checks staying in AI layer:**
- Interactive recovery ("2 criteria unchecked — fix them?")
- Metadata prompts for `→ blocked` and `→ archive`
- Pre-implementation review for `→ doing`
- Post-move actions (session history, commit prompts)

**What we lose:** Interactive recovery on failure becomes user-driven. Script exits 1 with a message;
user must fix manually and re-run. Deliberate trade-off: faster happy path, more friction for
incomplete items.

**WIP limit stays as warning only** — user preference. Script outputs `⚠️ WIP: N/N` to the console
but does not block. AI layer no longer needs to check it separately.

### Implementation: SPIKE-145 POC

Created side-by-side comparison setup:

- `poc-move-policy.sh` — copy of `move.sh` with 3 hard-block policy functions added
- `fw-move-poc` command — thin AI wrapper calling the new script; all policy checks removed
- Pre-flight loop: checks all items before moving any (fail-fast batch behavior)

---

## Files Created (Later)

- `project-hub/poc/SPIKE-145-script-policy/poc-move-policy.sh` — POC script with hard-block policy
- `project-hub/poc/SPIKE-145-script-policy/SPIKE-145-script-policy.md` — POC doc and architecture comparison
- `.claude/commands/fw-move-poc.md` — Thin AI layer for POC testing

## Files Moved (Later)

- `project-hub/work/todo/FEAT-909-test-parent.md` → `backlog/`
- `project-hub/work/todo/FEAT-909.2-test-child-two.md` → `backlog/` (triggered child-split warning → user chose to move whole family)
- `project-hub/work/todo/FEAT-909.3-test-child-three.md` → `backlog/`

---

## (Later) fw-move-poc — Readiness Check at `→ todo` + `--force` Flag

### Problem Identified

The `→ todo` pre-check was an AI approval prompt ("Have you approved this work?") that added
friction with no value — the user already expressed intent by running the command. Flagged as
redundant noise.

### Decision: Replace Approval Prompt with Script-Layer Readiness Check

**New behavior for `→ todo`:**
- Script runs `check_readiness()` — scans the item file for:
  - Unchecked `[ ]` criteria
  - Unresolved markers (`TODO`, `TBD`, `DECIDE`)
  - Undecided options (`Option A/B/C` style headings)
  - Unfilled placeholder text (`[Description]`, `NNN`, `YYYY-MM-DD`)
- Issues listed; move blocked unless `--force` is passed
- `--force` warns but proceeds — applies to entire batch (no per-item prompts)

**`→ doing` unchanged** — full pre-implementation review still required at that stage.

**Rationale:** Readiness issues surface at queue time (before items sit in `todo/` unnoticed)
rather than at implementation time. No template changes needed — existing placeholder patterns
in the templates are sufficient for detection. Fully script-side, no AI judgment required.

**Deliberate design choice — no template changes:** Templates already contain `TODO`, `TBD`,
`[Description]` patterns as placeholder text. Script greps for those patterns rather than
requiring a dedicated "Open Questions" section.

### Implementation Notes

Several bash portability issues resolved during development:
- `grep -c` returns empty string (not `0`) on no-match under `set -uo pipefail` — fixed with
  `$(grep -c ...; true)` + `${var:-0}` defaulting
- Non-zero function return code used for issue count conflicts with `set -e` — fixed with
  `set +e` / capture `$?` / `set -e` around the readiness call
- `--force` stripped from args before positional parsing via a filter loop

### Files Modified (Later)

- `project-hub/poc/SPIKE-145-script-policy/poc-move-policy.sh` — Added `check_readiness()`,
  `--force` flag parsing, readiness check in pre-flight loop
- `.claude/commands/fw-move-poc.md` — Removed `→ todo` approval prompt, added `--force` to
  usage/arguments/examples, updated "What the Script Handles" section

---

## (Later) SPIKE-145 — Test Harness Expansion and Bug Fix

### Test Coverage Gap Identified

Reviewed the existing 900-series test fixtures against the SPIKE-145 test scenario matrix.
Missing scenarios:

| Gap | Root cause |
|---|---|
| Dep not in done/ | No test item with `Depends On:` field |
| Unchecked criteria blocking `→ done` | No test item with unchecked `[ ]` criteria |
| Readiness markers blocking `→ todo` | No test item with TODO/TBD/Option markers |
| `--force` bypassing readiness | Same — no test item with markers |
| All criteria checked allowing `→ done` | No test item with all `[x]` criteria |

### New Test Fixtures Added (913–916)

- **FEAT-913** (`todo/`) — `Depends On: FEAT-999` (nonexistent) — tests dep block on `→ doing`
- **FEAT-914** (`todo/`) — 2 unchecked `[ ]` criteria — tests criteria block on `→ done`
- **FEAT-915** (`backlog/`) — `TODO:`, `TBD:`, `Option A/B` markers — tests readiness block and `--force` bypass on `→ todo`
- **FEAT-916** (`todo/`) — all `[x]` criteria — tests criteria-clean path on `→ done`

### Reset Script Simplified

`Reset-PocTests.ps1` was carrying per-item repositioning logic that would need maintaining for every new fixture. Redesigned as a thin wrapper: Cleanup → Create. `Cleanup-PocTestItems.ps1` already handled the delete step correctly.

### Bug Found: `grep -c '- \[ \]'` Silent Failure

**Root cause:** GNU grep on Windows Git Bash interprets the leading `- ` in the pattern `- \[ \]` as an unknown flag, returning empty string and exit 2. The `|| true` swallowed the error, leaving the count variable empty — causing `[ "" -gt 0 ]` to throw a non-fatal error and default to "allow".

**Fix:** Changed `grep -c` to `grep -ce` (explicit `-e` flag to delimit the pattern). Also added `${unchecked:-0}` default as belt-and-suspenders.

**Affected:** Both `check_acceptance_criteria()` and `check_readiness()` in `poc-move-policy.sh`.

### All 7 Tests Passing on poc-move-policy.sh

---

## (Later) FEAT-145 — Promoted POC to Production

### Policy Architecture Decisions (Final)

Walked through all checks one-by-one before promoting:

| Check | Final home | Rationale |
|---|---|---|
| Transition matrix | Script (hard block) | Pure rule lookup |
| Dependency check (→ doing) | Script (hard block) | Deterministic; not bypassable by `--force` |
| Acceptance criteria (→ done) | Script (hard block) | Deterministic; not bypassable by `--force` |
| Readiness markers (→ todo/backlog/blocked/archive) | Script (soft block, `--force` bypasses) | Deterministic |
| Priority field check | **Dropped** | Low signal, adds friction without value |
| Completed date (→ done) | AI layer | Script can't set dates; AI offers to set today |
| Implementation checklist enforcement | AI layer | Step-by-step execution control |
| Child split detection | AI layer | Requires asking user a question |
| Blocked/archive metadata prompts | AI layer | Requires user interaction before move |

**`--force` scope:** Available on all valid targets except `→ doing/`. Dependency checks on `→ doing` always enforced. Silently ignored if passed with `→ doing` — comment in script documents the intent.

**Readiness check scope fix:** Initial port had readiness check running on all targets except `→ doing`. Found during testing that `→ done` triggered false positives (the word "Todo" in fixture description text matched the TODO marker regex). Corrected: readiness check now only runs on `→ todo`, `backlog`, `blocked`, `archive`. The `→ done` acceptance criteria check is sufficient and more precise.

### Files Promoted / Updated

- `framework/scripts/move.sh` — Replaced with policy-enabled version (promoted from `poc-move-policy.sh` with cleanup)
- `.claude/commands/fw-move.md` — Rewritten with lean two-layer architecture; dropped verbose per-transition AI checklists
- `.claude/commands/fw-move-poc.md` — Moved to `project-hub/poc/SPIKE-145-script-policy/` (spike folder retained as reference)

### FEAT-145 Completed

All 10 acceptance criteria met (Priority check deliberately dropped — noted in work item).
7/7 test scenarios passing against production `framework/scripts/move.sh`.

---

## Current State (End of Session)

### In done/
- FEAT-145: fw-move+ Script-Backed Move Command with Batch & Child Support ✅
- FEAT-147, FEAT-150 (previously completed)

### In doing/
- (empty)

---

**Last Updated:** 2026-02-26

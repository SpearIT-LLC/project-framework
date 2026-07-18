# Session History: 2026-07-18

**Date:** 2026-07-18
**Participants:** Gary Elliott, Claude Code
**Session Focus:** BUG-184 — implement the readiness-check fix; ship code + docs; move to done/

---

## Summary

Implemented and completed **BUG-184**. The fix that shipped is *simpler* than the one BUG-184's fix
design proposed: rather than tightening `check_readiness`'s greps, we **removed the function entirely**.
That inversion was driven by an empirical finding mid-session — the `TODO/TBD/DECIDE` marker convention
the check assumed **never existed** in these work items — which collapsed the four-step "tighten it" plan
into a single "delete it" move. Code + three doc surfaces updated, tested end-to-end (both gates), and
BUG-184 moved `doing → done` with the `Completed:` date auto-stamped. `doing/` is now empty.

---

## Work Completed

### BUG-184: `check_readiness` blocks legitimate `→ todo` moves

**Shipped and moved to done/.** All 13 acceptance-criteria + checklist boxes checked (truthfully — see
the AC reconciliation below).

**What changed in code:**
- `.claude/scripts/fw-move.sh` — **removed `check_readiness()` and its call site** entirely. Left
  `check_acceptance_criteria()` (the `→ done` unchecked-`[ ]` gate) untouched. `--force` parsing retained
  as a no-op for backward compatibility; header comments rewritten to document it as reserved.

**What changed in docs (BUG-184 Documentation section):**
- `.claude/commands/fw-move.md` — corrected the `--force`/"readiness check" descriptions, replaced them
  with a **Ripeness** note (no deterministic `→ todo` gate; ripeness is the `→ doing` review), removed
  the stale `--force` example.
- `framework/docs/collaboration/workflow-guide.md` — added a note under the `→ todo/` checklist making
  explicit that ripeness is **not** gated there (ADR-007 D7 / BUG-184).
- `framework/CHANGELOG.md` — added **Removed** (the check) and **Fixed** (the bug) entries.

---

## Decisions Made

### D1 — Remove `check_readiness` entirely, don't tighten it (INVERTS the fix design)

**BUG-184's fix design proposed a four-step tune-up:** drop `todo` from the gate, remove the
unchecked-`[ ]` sub-check, and **tighten** the marker + placeholder greps to match template stubs only.

**What changed it — the journey:**

1. **Terminology reconciliation first.** Gary said the check "needs to happen" at `→ doing` and `→ done`.
   That read as contradicting BUG-184 (which doubts a *grep* check belongs at `→ doing`). The resolution:
   "check" meant two different things — the **AI ripeness review** (`→ doing`, behavioral) vs. the
   **script function** (`check_readiness`, grep). Once split, Gary and BUG-184 agreed completely. Gary
   restated the model precisely: **deterministic check → done via the script; AI check → doing for
   ripeness.** That is exactly ADR-007 D7.

2. **The empirical finding that inverted the plan.** Asked "how did we detect markers before the
   script?" — grepped the work-item templates. Result: **there is no `TODO/TBD/DECIDE` marker convention
   at all.** The only `TODO` in the framework is documentation *about* grepping code. The real template
   tokens are `NNN` / `YYYY-MM-DD` / bracketed placeholders — which live in a freshly-*created* item, not
   a *ready* one. So the marker grep never matched a real convention; it only ever fired false positives
   on the ordinary word "decide."

3. **Collapse.** Every job `check_readiness` claimed was either already done better elsewhere
   (unchecked-`[ ]` → `check_acceptance_criteria` at `→ done`) or was never real (markers; Option A/B/C;
   the catch-all `\[.{3,40}\]` placeholder that matched Markdown links). "Tighten the greps" had nothing
   left to tighten. → **Delete the function.** Gary confirmed.

**Scope note (Gary):** `→ done` gates on empty checkboxes now; **TECH-177** will later enrich that with
Obsidian task markers. BUG-184 is deliberately the minimal removal, not the enrichment.

### D2 — Acceptance criteria reconciled to what shipped (truthful, if "backwards")

Two of BUG-184's acceptance criteria assumed the *tighten* design and became false when we *removed*
instead:
- **AC-4** ("marker + placeholder greps match stubs not content") — no greps remain to match.
- **AC-6** ("a genuine stub still warns appropriately") — with the check gone, stubs are **not** warned
  at `→ todo` by design (correct per D7).

Gary's call: **match AC to what we built**, noting it's "technically a bit backwards" (AC is normally the
contract you build *to*, not a post-hoc record) but keeping it **truthful**. Both AC were rewritten with
inline `*(Revised from …)*` notes so the divergence is auditable, not silently rewritten. The two
Implementation Checklist items that assumed "tighten" were corrected the same way.

**How this surfaced:** it was caught by the `→ done` gate itself. Gary set up a deliberate test — leave
the boxes unchecked, attempt `→ done` — and the script hard-blocked on 13 unchecked criteria (exit 1,
nothing moved). Reviewing which boxes were *truthfully* checkable is what exposed the two stale AC.

---

## Testing (end-to-end, both gates)

- **`→ todo` no longer blocks a thorough item.** Copied BUG-181 (unchecked checklist + Markdown links +
  the word "decide") as a temp item, moved `backlog → todo`: **clean, no readiness block, no `--force`.**
  This is the exact bug, fixed.
- **`→ done` still hard-blocks on unchecked `[ ]`.** Verified twice: a temp item with unchecked boxes was
  blocked; the fully-checked copy moved clean and got its `Completed:` stamp. Then BUG-184 itself (13
  unchecked boxes) was blocked — the deliberate test above — and after checking the boxes, moved clean.
- `bash -n` syntax check passed. Temp test artifacts cleaned up (incl. an `AD` git-index ghost from a
  `git mv`'d-then-`rm`'d test file).

---

## Files Modified

- `.claude/scripts/fw-move.sh` — removed `check_readiness()` + call site; `--force` now a no-op; header docs updated
- `.claude/commands/fw-move.md` — Ripeness note replaces readiness-check descriptions; stale example removed
- `framework/docs/collaboration/workflow-guide.md` — "ripeness not gated at → todo" note under the checklist
- `framework/CHANGELOG.md` — BUG-184 Removed + Fixed entries

## Files Created

- `project-hub/history/sessions/2026-07-18-SESSION-HISTORY.md` — this file

## Files Moved

- `project-hub/work/doing/BUG-184-…md` → `project-hub/work/done/BUG-184-…md` (Completed: 2026-07-18 auto-stamped)

---

## Current State

### In done/ (awaiting release)
- **BUG-184** — complete (7 items now in done/; under the 10-item release-nudge threshold).

### In doing/
- *(empty — BUG-184 freed the slot, exactly as planned to unblock BUG-181's path through the gate.)*

### In todo/
- **BUG-181** — Decisions 1–3 all settled; the checklist edit recording Decision 3 is **still not
  written** (carried over from 2026-07-17). This is the next task.

---

## Next Session — continue from here

1. **Write the BUG-181 checklist update** (docs-only, scoped + approved-in-principle on 2026-07-17):
   record Decision 3 in its compose-starter / verify-root form; make the compose-vs-verify split
   explicit; add the `tools/Check-ContractDrift.ps1` step and the archive ships-check-and-snapshot step;
   mark PRE-IMPLEMENTATION REVIEW COMPLETED. See 2026-07-17 history for the full detail.
2. **BUG-181 can now move `todo → doing`** through the fixed gate when its review is done.
3. **Retrospective** when Gary's thoughts doc is ready.

---

**Last Updated:** 2026-07-18

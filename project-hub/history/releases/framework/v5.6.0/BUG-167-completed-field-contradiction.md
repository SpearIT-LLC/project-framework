# Bug: `Completed` Date Contradiction Between Procedure/Command and Templates

**ID:** BUG-167
**Type:** Bug
**Priority:** Medium
**Version Impact:** PATCH
**Created:** 2026-07-02
**Completed:** 2026-07-02
**Theme:** Workflow

<!-- Decision recorded 2026-07-02: Option A (restore + mechanize). See Decision section. -->
<!-- Note: touches move.sh, same as TECH-166 — coordinate/sequence to avoid conflicts, but not a hard dependency. -->

---

## Summary

The `workflow-guide.md` procedure and the `/fw-move` command both **require** a
`**Completed:** YYYY-MM-DD` field to be set when a work item moves to `done/`, but
the work-item **templates do not define this field** — it was deliberately retired.
This forces the date to be invented ad hoc by the AI on every completion, and it
silently fails when the AI doesn't remember (as happened with FEAT-165 on
2026-07-02, which reached `done/` with no date until manually corrected).

## Steps to Reproduce

1. Create a work item from any current template (e.g. `FEATURE-TEMPLATE.md`) — note
   there is no `**Completed:**` field.
2. Complete it and run `/fw-move <id> done`.
3. The `workflow-guide.md` `→ done/` checklist (line ~435) and `/fw-move` both say
   "Completed date is set" — but there is no field to set, so compliance depends on
   the AI hand-adding a field the template never declared.

## Expected vs. Actual

- **Expected:** The procedure, the command, and the templates agree on whether a
  `Completed` date is part of a work item — either all require it or none do.
- **Actual:** Procedure + command require it; templates omit it. The convention
  survives only by manual re-creation, and lapses silently when it isn't.

## Root Cause (git archaeology — 2026-07-02)

The field was **deliberately retired, then accidentally resurrected in one layer:**

| Date | Commit | Event |
|------|--------|-------|
| 2026-01-20 | TECH-064 (`6f43274`) | Removed `Completed` (and `Status`) from templates. Documented rationale: *"Git history captures this; location indicates completion."* The `workflow-guide.md` `→ done` checklist at this commit did **not** require a Completed date — internally consistent. |
| 2026-01-20 | TECH-066 | Migrated 41 existing items, stripping `**Completed:**` from all. Convention fully retired end-to-end. |
| 2026-01-29 | TECH-094 (`1b1ec2d`) | Embedded transition checklists into `/fw-move`; re-introduced "Check `Completed` date is set." |
| 2026-02-04 | TECH-108 (`7071e8d`) | *"Remove Status field contradiction from all enforcement layers"* — while removing the retired `Status` field's contradiction, **re-added** a "Completed date is set" checklist line to the guide's `→ done` checklist, resurrecting a requirement TECH-064 had deliberately removed — without restoring the field to templates. |

**Irony:** TECH-108's explicit purpose was to *remove* a retired-field contradiction
(`Status`); it *created* the same contradiction for `Completed`.

## Evidence of Live Impact

- Every item in recent framework releases (v5.4.0, v5.5.0) carries `**Completed:**`
  — added by hand, because the templates don't supply it. The convention is alive
  in practice but unsupported by tooling.
- FEAT-165 (2026-07-02) reached `done/` with **no** Completed date because the AI,
  reading the templates, concluded no such field existed. Corrected manually.

## Proposed Resolution (decide during implementation)

This is a **decision between two coherent end-states**, not just a patch. Pick one
and make ALL layers agree (templates, `workflow-guide.md`, `/fw-move` command +
plugin copies, and optionally `move.sh`):

**Option A — Restore the convention (recommended lean).**
- Add `**Completed:** YYYY-MM-DD` back to all work-item templates.
- Have `move.sh` stamp it automatically on `→ done/` (so it can't silently lapse
  and doesn't depend on the AI remembering).
- Keep the guide/command requirement.
- Rationale: the close *date* is genuinely useful (cycle time, release notes) and is
  NOT fully redundant with folder location (location says *that* it's done, not
  *when*). TECH-064's "git history captures this" is true but inconvenient to query.

**Option B — Fully retire it (honor TECH-064's original decision).**
- Remove the `Completed date is set` line from `workflow-guide.md` and `/fw-move`
  (and plugin command copies).
- Accept git history / release-archive placement as the record of when.
- Rationale: it was deliberately retired for a stated reason; the mistake was
  TECH-108 resurrecting it, not TECH-064 removing it.

## Decision (2026-07-02): Option A — restore, and mechanize it

Decided with Gary. **Restore the `Completed` field and make the `Completed:` field
the definitive record of completion**, with the git commit timestamp treated as
incidental (NOT a completion record).

Rationale, and why the counter-arguments collapse in this project's context:

- **Git records commit date, not the move-to-done date** — these diverge
  non-deterministically (batched commits, rebase/squash rewrites). The commit
  timestamp is therefore not a definitive completion record.
- **`→ done/` IS the completion event here, by construction.** `move.sh` hard-blocks
  moving to done/ unless acceptance criteria are satisfied, so "moved to done/" =
  "complete per Kanban," not "decided to stop." Recording the date *at the move* is
  the correct action.
- **Release date ≠ completion date** — release-archive folder timestamps answer a
  different question and are not a substitute.
- **No dual-source-of-truth problem** — there are only two records if we *declare*
  both authoritative. We declare the `Completed:` field authoritative; git time is
  incidental. One source of truth.
- **Choke point holds** — the user uses ONLY `/fw-move`, which always invokes
  `move.sh` (verified: `.claude/commands/fw-move.md:75`). So a script-written date is
  universal in practice.

**The precondition that makes this safe: the date must be written mechanically, not
by an AI following an instruction** (a hand-written field is exactly what lapsed and
caused this bug).

### Implementation approach

- **Belt** — `move.sh` writes `**Completed:** <today>` into the item header when it
  moves an item to `done/` (idempotent; don't overwrite an existing value on
  re-runs). Also declare the field in all work-item templates (blank/optional at
  creation; populated on completion).
  - **Guardrail — stamp only on a genuine transition, never partial-write on
    failure.** The stamp must happen only when an item *actually* transitions into
    `done/` (source folder ≠ `done/`; `move.sh:396-401` already skips
    already-in-target no-ops, so a `done → done` re-move never re-stamps). And if the
    `git mv` into `done/` fails — e.g. a rare duplicate-ID collision where a file with
    the same ID already exists in `done/` (see Notes) — the script must **not** write
    the `Completed:` date to a file that didn't move. Order the write *after* a
    confirmed-successful `git mv`, or the field could be set on an item still sitting
    in its source folder. Duplicate-ID collisions are low-risk (Get-NextWorkItemId
    scans work/ + releases/ + poc/ + history/spikes/, so the counter never re-issues
    a used number; prefix + descriptive filename make accidental dupes visible) — this
    is a correctness guardrail on the stamping logic, not a call to handle the dupe
    case itself.
- **Suspenders** — extend the existing pre-commit hook that validates `done/` items
  to also **reject any commit where a `done/` item lacks a `Completed:` date**. This
  catches any bypass path so the field cannot silently lapse again (the BUG-167
  failure mode). Note: a git hook cannot force `/fw-move` to be used, but it CAN
  enforce the invariant at commit time — which is what actually matters.
- Update `workflow-guide.md` and `/fw-move` so the requirement matches reality, and
  **reconcile the `.claude/` vs `plugins/*/commands/move.md` divergence** (the plugin
  copies did not reference `move.sh` in a 2026-07-02 grep).

## Scope Decision (2026-07-02): Tier 1 this item; Tiers 2 & 3 spun out

During implementation, two facts changed the scope:
1. **The "suspenders" pre-commit hook does NOT exist yet.** `.git/hooks/` has only
   samples, no `core.hooksPath` is set, and no hook script is in the repo. CLAUDE.md's
   claim that "a pre-commit hook validates work items in done/" is aspirational. So
   this would be building a hook + install mechanism from scratch — separate work.
2. **The plugin `move.md` copies use their own inline bash**, not `framework/scripts/
   move.sh` (verified: `plugins/*/commands/move.md` embed a `#!/usr/bin/env bash`
   block). Reconciling them is a distinct, distribution-touching change overlapping
   the command-tier drift work.

Decision (with Gary): ship **Tier 1** here — it fully resolves the reported
contradiction. Spin out Tiers 2 & 3 as follow-up items:
- **TECH-168** — pre-commit hook (from scratch) + install mechanism that rejects
  `done/` items missing a `Completed:` date (the enforcement backstop).
- **TECH-169** — reconcile `/fw-move` command copies: plugin inline scripts vs.
  `framework/scripts/move.sh` (so all paths stamp / behave identically).

## Acceptance Criteria

- [x] Decision recorded (restore vs. retire) with rationale. → **Option A (restore).**
- [x] `**Completed:**` declared in all work-item templates (all 5: FEATURE, BUG,
      TECHDEBT, DECISION, SPIKE).
- [x] `move.sh` writes `**Completed:** <today>` on `→ done/` (idempotent — no
      overwrite of an existing date; stamps only after a confirmed move; stages the
      file). Verified with 4 test cases (blank→stamped, insert-when-absent,
      already-in-target no-op, pre-existing date preserved).
- [x] `workflow-guide.md` and `.claude/commands/fw-move.md` reworded to say the date
      is set automatically (no manual/hand-edit step).
- [x] Grep confirms no remaining contradiction across the layers **touched in Tier 1**.

**Deferred (out of Tier 1 scope — not acceptance criteria of this item):**
- Pre-commit hook rejecting `done/` items missing a `Completed:` date → **TECH-168**
  (hook doesn't exist; from-scratch build).
- `.claude/` and `plugins/*/commands/move.md` reconciled → **TECH-169** (plugin
  copies use inline bash, not `move.sh`).

## Notes

- Related to the broader command-tier drift work (DECISION-162, TECH-161) and the
  `/fw-move` false-positive item (TECH-166) — all symptoms of enforcement layers
  drifting from source-of-truth docs.
- Also verified: the `/fw-move` instruction lives in the `.claude/commands/` copy but
  NOT the `plugins/*/commands/move.md` copies — a separate command-copy divergence to
  reconcile as part of the fix.

## Related

- TECH-064 (retired the field), TECH-066 (migrated items), TECH-094 & TECH-108
  (re-introduced the requirement)
- TECH-166 (move.sh readiness false-positives)
- DECISION-162, TECH-161 (command-tier drift)

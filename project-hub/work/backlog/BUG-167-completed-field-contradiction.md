# Bug: `Completed` Date Contradiction Between Procedure/Command and Templates

**ID:** BUG-167
**Type:** Bug
**Priority:** Medium
**Version Impact:** PATCH
**Created:** 2026-07-02
**Theme:** Workflow

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
| 2026-02-04 | TECH-108 (`7071e8d`) | *"Remove Status field contradiction from all enforcement layers"* — while removing the retired `Status` field's contradiction, **re-added** `- [ ] Completed date is set` to the guide's `→ done` checklist, resurrecting a requirement TECH-064 had deliberately removed — without restoring the field to templates. |

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

## Acceptance Criteria

- [ ] Decision recorded (restore vs. retire) with rationale.
- [ ] Templates, `workflow-guide.md`, and `/fw-move` (incl. plugin copies) all agree.
- [ ] If restored: `move.sh` sets the date on `→ done/` (no reliance on AI memory),
      and templates declare the field.
- [ ] If retired: no enforcement layer references a Completed date.
- [ ] Grep confirms no remaining contradiction across the four layers.

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

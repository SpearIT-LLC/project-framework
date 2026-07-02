# Tech: Move Readiness Check False-Positives on `→ todo/`

**ID:** TECH-166
**Type:** Tech
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-07-02
**Theme:** Workflow

---

## Summary

`framework/scripts/move.sh` blocks legitimate planning items from moving
`backlog → todo` because its readiness heuristics misfire on normal work-item
content. On 2026-07-02, FEAT-163/164/165 all failed the readiness gate and required
`--force`, even though nothing was actually wrong with them.

## Problem

Three readiness heuristics produce false-positives for planning items:

1. **Unchecked acceptance criteria (`[ ]`) block `→ todo`.**
   Acceptance criteria are *supposed* to be unchecked in `todo/` — they are
   completed during `doing/` and enforced on `→ done`. Treating unchecked criteria
   as a readiness blocker for `→ todo` is wrong for the lifecycle stage. The script
   already (correctly) enforces unchecked criteria on `→ done`; that same check
   should not fire on `→ todo`.

2. **The word "decide" (and "todo") is flagged as an unresolved marker.**
   The marker detector matches DECIDE/TODO/TBD anywhere in the file. But a work
   item can *legitimately describe* a decision to be made — e.g. FEAT-163's scope
   literally includes "decide the stream field (reuse `Theme` vs. new `Stream`)."
   The detector matched the ordinary English word "decide." Marker detection should
   be scoped (e.g. only in status/decision fields, or only as standalone
   `TODO:` / `DECIDE:` markers), not a bare case-insensitive word match across prose.

3. **`[Optional]` field hints flagged as unfilled placeholders.**
   Templates leave `**Planning Period:** [Optional]` and similar hints. These are
   deliberate "leave blank if not needed" markers, not unfilled required fields.
   The placeholder detector should ignore hints explicitly marked `[Optional]`.

## Impact

- Every planning/decision item hitting `todo/` needs `--force`, which trains users
  to reflexively force — eroding the value of the readiness gate for the cases it
  *should* catch (genuinely unready items).
- False sense that items are "not ready" when they are correctly staged.

## Proposed Direction (to refine during implementation)

- **Stage-aware criteria check:** don't treat unchecked acceptance criteria as a
  blocker for `→ todo`; keep enforcing on `→ done` (already present).
- **Scoped marker detection:** match only structured markers (`TODO:`, `TBD`,
  `DECIDE:` as standalone tokens / in status fields), not the word "decide" in
  descriptive prose. Consider excluding a designated "Scope"/"Acceptance" section.
- **Respect `[Optional]`:** exclude placeholder hints tagged `[Optional]` from the
  unfilled-placeholder count.

## Acceptance Criteria

- [ ] Unchecked acceptance criteria no longer block `backlog → todo`.
- [ ] Descriptive use of "decide"/"todo" in prose does not trip marker detection.
- [ ] `[Optional]` field hints are not counted as unfilled placeholders.
- [ ] `→ done` acceptance-criteria enforcement is unchanged (regression check).
- [ ] FEAT-163/164/165 (or equivalent fixtures) would pass `→ todo` without `--force`.

## Notes

- Discovered while moving FEAT-163/164/165 to `todo/` after the 2026-07-02 decision
  swarm. All three were legitimate; `--force` was used as a workaround.
- Script source: `framework/scripts/move.sh`.

## Related

- FEAT-163, FEAT-164, FEAT-165 (the items that surfaced this)

# Bug: fw-new-workspace Leaves a Half-Built Workspace When an Override Lacks the Type Overlay

**ID:** BUG-208
**Type:** Bug
**Priority:** Medium
**Version Impact:** PATCH
**Created:** 2026-08-29
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

Found ad-hoc during UAT-06. With a project template override
(`.claude/templates/workspaces/`) that has `floor/` and `project/` but no `product/`,
`/fw-new-workspace product missing-type` copies the floor, then fails at
`cp -R "$TPL/product/."` with a raw `cp: cannot stat` error (exit 1) — leaving
`workspaces/missing-type/custom-floor/` on disk. Violates the script's own "never leave
structure half-made" posture.

## Reproduction

1. Create `.claude/templates/workspaces/floor/x/.gitkeep` and
   `.claude/templates/workspaces/project/README.md` (no `product/`).
2. `> /fw-new-workspace product missing-type`
3. Observe: raw `cp` error; `workspaces/missing-type/x/` exists.

**Reproducibility:** Always.

## Fix Design

- Validate `$TPL/floor` and `$TPL/$TYPE` exist **before** creating anything; on failure,
  a message naming the missing overlay and the override path, exit 1, nothing created.
- Print `Using project template override: .claude/templates/workspaces/` when the
  override path is taken, so an override run is distinguishable (UAT-06 UX note).
- Command/README state plainly that an override replaces the plugin templates
  **wholesale** — copy the full tree first, then edit.

## Acceptance Criteria

- [x] Missing overlay → clear message, exit 1, no directory created *(2026-08-31;
      validation runs before mkdir; message names the missing folder(s) and the
      wholesale rule; broken plugin install gets its own message. Scratchpad checks:
      normal path, missing type, missing floor+type, operations overlay missing —
      nothing on disk in every refusal)*
- [x] Override runs announce themselves *(2026-08-31: "Using project template
      override: .claude/templates/workspaces/")*
- [x] Wholesale-replacement rule stated in the command *(2026-08-31:
      commands/fw-new-workspace.md)*
- [x] UAT-06 (incl. the ad-hoc case, now scripted in the runbook) PASS against the
      built plugin *(2026-08-31: re-run in framework-uat against 0.4.2 — announce
      line printed, `product missing-type` refused with the wholesale message, exit 1,
      nothing on disk; plugin templates untouched. See UAT-RESULTS-2026-08-26.md
      "Re-run 2026-08-31")*

## Notes

Back-pocket design raised in the same test (not now): discover valid types from the
template folders with a small per-type manifest (`type.conf`: `named=`, `floor=`,
`aliases=`) instead of the hard-coded `case`; would amend ADR-009 D3's closed type list.
Revisit if the four types become limiting.

## Related

- **FEAT-164** — `/fw-new-workspace` (owning FEAT).
- `workspaces/framework/tests/UAT-RESULTS-2026-08-26.md` row UAT-06.

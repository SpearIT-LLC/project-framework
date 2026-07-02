# Tech Debt: Reconcile `/fw-move` Command Copies (Plugin Inline Script vs. move.sh)

**ID:** TECH-169
**Type:** Tech Debt
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-07-02
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->
**Theme:** Workflow

---

## Summary

There are multiple copies of the `/fw-move` command that do not share the same move
logic. The `.claude/commands/fw-move.md` copy calls `framework/scripts/move.sh`, but
the plugin copies (`plugins/spearit-framework/commands/move.md` and
`plugins/spearit-framework-light/commands/move.md`) embed their **own inline bash
script** instead. Behavior can therefore diverge between the dev command and the
shipped plugins — as it now does for the BUG-167 `Completed`-date stamping, which
lives only in `move.sh`.

## Motivation

**Discovered during BUG-167:** the `Completed`-date stamping was added to
`framework/scripts/move.sh`. The `.claude/` command picks it up (it calls the
script). The **plugin copies do not** — they run inline bash that has no stamping.
So an item completed via a plugin would silently miss the date — re-creating the
BUG-167 failure mode through a different door.

More broadly, this is the command-copy half of the command-tier drift the project is
already tracking (DECISION-162, TECH-161): the same command in three places, free to
drift.

## Scope

**In:**
- Decide the reconciliation model: either (a) plugins call the shared
  `framework/scripts/move.sh` (single source of truth), or (b) a build step
  generates the plugin inline script FROM `move.sh` so they can't drift.
- Apply BUG-167's stamping behavior to the plugin path (whichever model).
- Verify all three command copies produce identical move behavior, including the
  `Completed`-date stamp on `→ done/`.

**Out:**
- The stamping logic itself (BUG-167).
- The pre-commit backstop (TECH-168).
- Broader command-tier drift remediation beyond `/fw-move` (see DECISION-162 /
  TECH-161 for the general effort).

## Acceptance Criteria

- [ ] Reconciliation model chosen and documented.
- [ ] Plugin `/fw-move` stamps `Completed:` on `→ done/` identically to `move.sh`.
- [ ] All three copies verified to behave identically on a representative move set.
- [ ] No independent inline copy of the move logic remains that can silently drift
      (or, if inline is kept, it is generated from the shared script).

## Notes

- Verified 2026-07-02: `plugins/*/commands/move.md` embed `#!/usr/bin/env bash`
  inline (around line 53), separate from `framework/scripts/move.sh`.

## Related

- BUG-167 (added stamping to move.sh — this ensures plugins match)
- TECH-168 (pre-commit enforcement backstop)
- DECISION-162, TECH-161 (command-tier drift)

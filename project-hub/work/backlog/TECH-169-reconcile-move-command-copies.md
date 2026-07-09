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
logic. The `.claude/commands/fw-move.md` copy calls `.claude/scripts/fw-move.sh`, but
the plugin copies (`plugins/spearit-framework/commands/move.md` and
`plugins/spearit-framework-light/commands/move.md`) embed their **own inline bash
script** instead. Behavior can therefore diverge between the dev command and the
shipped plugins — as it now does for the BUG-167 `Completed`-date stamping, which
lives only in `move.sh`.

## Motivation

**Discovered during BUG-167:** the `Completed`-date stamping was added to
`.claude/scripts/fw-move.sh`. The `.claude/` command picks it up (it calls the
script). The **plugin copies do not** — they run inline bash that has no stamping.
So an item completed via a plugin would silently miss the date — re-creating the
BUG-167 failure mode through a different door.

More broadly, this is the command-copy half of the command-tier drift the project is
already tracking (DECISION-162, TECH-161): the same command in three places, free to
drift.

## Scope

**In:**
- Decide the reconciliation model: either (a) plugins call the shared
  `.claude/scripts/fw-move.sh` (single source of truth), or (b) a build step
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
  inline (around line 53), separate from `.claude/scripts/fw-move.sh`.
- **Update (BUG-170, 2026-07-07):** the shared engine was relocated
  `framework/scripts/move.sh` → **`.claude/scripts/fw-move.sh`** (co-located with its
  command per DECISION-171/`fw-` naming) and the build now ships it. Path references
  above updated. This does **not** resolve TECH-169 — the plugin copies still embed
  their own inline bash and can still drift; reconciliation option (a) now means
  "plugins call `.claude/scripts/fw-move.sh`."

- **Update (2026-07-09, during FEAT-175 planning) — option (a) is ruled out; a third option may
  exist; FEAT-179 pilots the answer.** Verified this session:
  - **Option (a) as written is not viable.** The plugin ships via marketplace cache and explicitly
    forbids reaching outside itself (`plugins/*/commands/help.md`: "Do NOT read from
    `.claude/commands/`"; ADR-006 lines 83–85: "self-contained and isolated … a single
    *shared runtime file* across channels is impossible"). A plugin cannot call the
    consuming repo's `.claude/scripts/fw-move.sh` — that file belongs to the *user's*
    project, not the plugin, and is absent in a plugin-only install. **Inline embedding is
    forced by channel isolation, not a stylistic choice.**
  - **A third option was identified: the plugin calls a script it ships *itself*.** The isolation
    rule forbids reaching *outside* the plugin; it says nothing about a `scripts/` folder *inside*
    it (plugins already ship `templates/`, `skills/`). If that works, the build step is a verbatim
    `Copy-Item` and the copies **cannot** drift — strictly better than any transform.
    **→ SPIKE-178** tests exactly this.
  - **FEAT-179 (plugin create-gate parity) pilots the pattern**, on `/fw-new` — a command with no
    legacy inline copy to unpick. If it holds, TECH-169 becomes "apply the proven FEAT-179
    derivation pattern to `move`," a much smaller item than deciding the model from scratch.
  - **If SPIKE-178 says no**, derivation is a **transform**, not a copy: the plugin's inline bash is
    *parameterized by AI substitution* — `TARGET="<target-folder>"`,
    `ITEM_IDS=(<space-separated-list-of-resolved-ids>)` — where the shared script takes `$1`/`$2`
    positionally. The build would inject a resolved-arguments preamble and strip the CLI arg-parsing
    block. Whatever FEAT-179 lands is what TECH-169 inherits.
  - Consequence for AC #4 below: "if inline is kept, it is generated from the shared script" is now
    the **fallback** outcome; shipping a real script into the plugin is the preferred one.
  - Also relevant: the plugins ship executable bash *today* (`move.md`, `backlog.md`,
    `kanban-state.md` all embed `#!/usr/bin/env bash`). There is **no** "plugins are prose-only"
    policy in this repo — searched and confirmed absent 2026-07-09. Nothing blocks shipping a `.sh`.

## Related

- BUG-167 (added stamping to move.sh — this ensures plugins match)
- TECH-168 (pre-commit enforcement backstop)
- DECISION-162, TECH-161 (command-tier drift)
- **SPIKE-178** (can a plugin invoke a script it ships itself? — decides copy vs. transform)
- **FEAT-179** (plugin create-gate parity — pilots the derivation pattern this item inherits)
- **FEAT-175** (builds the authored `fw-new.sh` engine; full framework only)
- **ADR-006** lines 83–85 (the cache-isolation constraint that rules out option (a))

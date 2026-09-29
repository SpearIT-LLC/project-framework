# Tech: The Mechanical Bootstrap Steps Become Hooks

**ID:** TECH-253
**Type:** Tech
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-09-28
**Workspace:** framework
**Depends On:**
**Completed:**

---

## Summary

From SPIKE-248 (D4) and ADR-007 Amendment 1 (A4). Two of the root `CLAUDE.md` bootstrap
steps are prose that a hook can enforce, which ADR-008's test says they should be:

- **Report `doing/`** at session start becomes a SessionStart hook that prints the WIP state
  (the cards in `doing/` and their titles).
- **`git mv` only on the board** becomes a PreToolUse hook that denies `mv`, `Move-Item` and
  `cp` against the board path. Its reason names `/fw-move`; Claude Code shows the reason to
  Claude (code.claude.com/docs/en/hooks, verified 2026-09-28).

The other two steps are deleted, not mechanized: "ask what kind of work" and the
`roles.default` persona.

## Problem Statement

Both steps hold today only because the AI follows them. The `git mv` rule exists because
plain moves lose history on the board. A PreToolUse deny makes it hold whether or not the AI
remembers it. The same hook type already ships in this plugin (`hooks/hooks.json`,
contacts refresh).

## Open at Review

- **The board path before the ADR-009 D5 crossover.** The plugin's hooks target `kanban/`,
  but this repo's live board is `project-hub/work/` until graduation. Choose one: read the
  board path from config (`workspace.yaml` / `framework.yaml`), or have a project-level
  interim hook cover `project-hub/work/`.
- **Matching.** Bash commands arrive as strings (`tool_input.command`). Decide how strictly
  to match `mv`/`cp` (quoting, `git mv` must pass, PowerShell `Move-Item`) without blocking
  unrelated commands.
- **Whether a WIP report on `resume` is noise.** It might be `startup|clear` only.

## Acceptance Criteria

- [ ] A fresh session in a repo with the plugin shows the `doing/` state without being asked
- [ ] `mv`, `cp` and `Move-Item` on a board card are denied with a reason naming `/fw-move`; `git mv` and moves outside the board pass
- [ ] Verified on the installed plugin in `framework-uat`, not the source tree
- [ ] Bootstrap steps 1–4 are removed from the root `CLAUDE.md` (coordinate with BUG-181's slim-down)
- [ ] Plugin CHANGELOG updated

## Related

- **SPIKE-248** — D4; evidence in `SPIKE-248/findings.md`
- **ADR-007 Amendment 1** — A4
- **BUG-181** — the contract hook and the root `CLAUDE.md` slim-down
- **TECH-114** — WIP-enforcement hook (Legacy C1); the tabled Implementation-Rule hook bears on it

# Tech: The Mechanical Bootstrap Steps Become Hooks

**ID:** TECH-253
**Type:** Tech
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-09-28
**Started:** 2026-09-29
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

**Added 2026-09-29 (TASK-223):** the same PreToolUse hook also denies **deleting** a board
card (`rm`, `git rm`, `Remove-Item`). That is the check behind TECH-077's never-delete rule,
which the board README already states. The rule and the move rule protect the same thing, the
card's history, so one hook covers both.

The other two steps are deleted, not mechanized: "ask what kind of work" and the
`roles.default` persona.

## Problem Statement

Both steps hold today only because the AI follows them. The `git mv` rule exists because
plain moves lose history on the board. A PreToolUse deny makes it hold whether or not the AI
remembers it. The same hook type already ships in this plugin (`hooks/hooks.json`,
contacts refresh).

## Decisions at Review (Gary, 2026-09-29)

- **Which folders.** The hooks guard the namespace roots the engine declares, `kanban/` and
  `operations/` (operations records follow the same `git mv` rule). The roots moved out of
  `fw-move.sh` into `scripts/lib/namespace-roots.sh`, read by the engine, `fw-next-id.sh` and
  both hooks, so the guard can't protect a different folder from the one the engine uses.
- **This repo's board until the ADR-009 D5 crossover.** `.claude/settings.json` sets
  `SPRIT_BOARD_ROOTS=project-hub/work` (the `SPRIT_` prefix is DECISION-171's rule for
  environment variables). Both hooks add it to their list. No copy of the hook, and one line to
  delete at crossover. **Depends on a `settings.json` `env` value reaching a plugin hook**: the
  settings docs say `env` is "applied to every session", which is not explicit about hooks, so
  UAT-62 is the proof.
- **Matching.** The command is split at `;`, `&&`, `||`, `|`. A segment is denied when its verb
  is a move, copy or delete (`mv cp rm rmdir`, `git rm`, the PowerShell cmdlets and aliases,
  `find -delete/-exec`, `xargs rm`) and an argument resolves under a guarded root. `cd` is
  followed, and Windows, Git Bash and POSIX spellings of a path compare equal. `git mv` passes.
  **A file inside a record's bundle folder passes**: working material is the author's to reshape
  (found while building; without it, deleting a scratch log in `FEAT-012/` would be blocked).
  The guard stops the ordinary mistake, not a determined workaround (`eval`, a path in a
  variable); its header says so.
- **Known trade-off.** Copying a card *out* of the board is also denied. Rare, and safer than
  guessing which argument is the destination.
- **`resume`.** The WIP report runs on `startup`, `clear` and `compact`, not `resume`.
- **Matcher.** `Bash|PowerShell`. `PowerShell` as a matcher value works but is not in the hooks
  reference (checked 2026-09-29), so UAT-59 should be run once from each shell if possible.
- **Root `CLAUDE.md`.** Remove steps 1, 3, 4 and the persona part of step 2 **after** UAT-62
  passes, not before: until then the prose is the only guard this repo has. Step 2's pointer to
  `framework.yaml`'s `sources:` index and transition policy stays until BUG-181 rewrites the file.

## Acceptance Criteria

- [/] A fresh session in a repo with the plugin shows the `doing/` state without being asked
      *(built and run by hand against `framework-uat` and this repo; UAT-58 proves it live)*
- [/] `mv`, `cp` and `Move-Item` on a board card are denied with a reason naming `/fw-move`; `git mv` and moves outside the board pass
      *(`tests/test-board-guard.sh`: 29 cases pass; UAT-59 and UAT-61 prove it live)*
- [/] `rm`, `git rm` and `Remove-Item` on a board card are denied with a reason naming `cancelled/` (TECH-077's never-delete rule, added by TASK-223 on 2026-09-29)
      *(same table test; UAT-60 proves it live)*
- [ ] Verified on the installed plugin in `framework-uat`, not the source tree *(Gary: UAT-58..61)*
- [ ] This repo's interim board is covered through `SPRIT_BOARD_ROOTS` *(Gary: UAT-62)*
- [ ] Bootstrap steps 1–4 are removed from the root `CLAUDE.md` (coordinate with BUG-181's slim-down) *(after UAT-62; step 2 keeps its `sources:` pointer)*
- [x] Plugin CHANGELOG updated

## Related

- **SPIKE-248** — D4; evidence in `SPIKE-248/findings.md`
- **ADR-007 Amendment 1** — A4
- **BUG-181** — the contract hook and the root `CLAUDE.md` slim-down
- **TECH-114** — WIP-enforcement hook (Legacy C1); the tabled Implementation-Rule hook bears on it

# Spike: Can a Claude Code Plugin Invoke a Script Inside Its Own Cached Directory?

**ID:** SPIKE-178
**Type:** Spike
**Priority:** Medium
**Version Impact:** None
**Created:** 2026-07-09
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->
**Theme:** Framework Consistency

---

## Investigation Goal

**Can a plugin command invoke an executable script that ships inside the plugin's own directory
(e.g. `plugins/spearit-framework/scripts/fw-new.sh`), resolved from the marketplace cache at
runtime?**

Concretely: does Claude Code expose a reliable path to the installed plugin's root — such as a
`${CLAUDE_PLUGIN_ROOT}` environment variable or equivalent — that a command's bash block can use to
locate and run a sibling script?

**Time-box:** one working session. Output is a **decision**, not an implementation.

---

## Background

**Why is this investigation needed?**

Verified 2026-07-09 during FEAT-175's pre-implementation review:

- The plugins **already ship executable bash** — `plugins/*/commands/move.md`, `backlog.md`, and
  `kanban-state.md` each embed a `#!/usr/bin/env bash` block and instruct the AI to run it. There is
  **no** "plugins are prose-only" policy recorded anywhere in the repo. (Searched; confirmed absent.)
- The real constraint is **cache isolation**: a plugin ships via marketplace cache and explicitly
  forbids reaching outside itself (`help.md`: "Do NOT read from `.claude/commands/`"; ADR-006
  lines 83–85: "self-contained and isolated … a single *shared runtime file* across channels is
  impossible"). A plugin therefore **cannot** call the consuming repo's `.claude/scripts/fw-move.sh`.
- That constraint forbids reaching **outside** the plugin. It says nothing about a script **inside**
  the plugin's own directory. Plugins already ship non-command files (`templates/`, `skills/`,
  `.claude-plugin/plugin.json`) — a `scripts/` folder is not a new category.

**Nobody has tested whether the inline-bash design is necessary or merely historical.** If a plugin
can run its own script, the inline-embedding pattern is an artifact, and a large simplification opens
up across every plugin command.

---

## Questions to Answer

1. Does Claude Code expose the installed plugin's root path to a command at runtime
   (`${CLAUDE_PLUGIN_ROOT}` or equivalent)? Cite the official documentation.
2. If yes: can a command's bash block execute `bash "${CLAUDE_PLUGIN_ROOT}/scripts/foo.sh"` from the
   **marketplace cache** (not just from a local dev checkout)?
3. Does it work on Windows (Git Bash) as well as macOS/Linux? The framework's only shell dependency
   today is bash-via-git.
4. Are shipped `.sh` files preserved by the plugin packaging path (`Build-Plugin.ps1` →
   `Compress-Archive` → marketplace install)? Do execute bits / line endings survive?
5. Does shipping executable scripts change the plugin marketplace's install/trust prompt in any way
   the user should know about?

---

## Method

1. Read the official Claude Code plugin documentation on command execution and plugin paths.
2. Build a throwaway plugin with one command and one `scripts/hello.sh`.
3. Publish it via the existing local marketplace flow
   (`.\tools\Publish-ToLocalMarketplace.ps1 -Build`, `/plugin marketplace update dev-marketplace`).
4. Install it, restart, invoke the command, observe whether the script runs.
5. Record the resolved path and any errors verbatim.

---

## Acceptance Criteria

- [ ] Documented answer (yes/no) to "can a plugin invoke its own script from the cache?", with a
      citation to official documentation **and** an observed result from a real local install
- [ ] The exact path-resolution mechanism recorded (variable name, value observed on Windows)
- [ ] Packaging fidelity confirmed: `.sh` files survive the build → zip → install path intact
- [ ] A recommendation for **FEAT-179**: verbatim `Copy-Item` derivation, or build-time transform
      into the existing inline-bash form
- [ ] If the answer is **no**, the inline-bash transform is specified concretely enough for FEAT-179
      to implement without re-investigating

---

## Why This Matters (Impact)

The answer decides how **FEAT-179** ships plugin create-gate parity, and how **TECH-169** eventually
reconciles the three `/fw-move` copies:

| SPIKE-178 answer | Build step | Can copies drift? | Plugin cost |
|---|---|---|---|
| **Yes — can invoke own script** | `Copy-Item` (verbatim) | No — byte-identical | Cheaper (AI reads 1 line, not ~150) |
| **No — must inline** | parse + strip args + splice | Only if the transform is buggy | Current (AI reads whole script) |

"Yes" is strictly better and would let **every** plugin command stop embedding bash — a change to
what the plugin *is*, not just how `/fw-new` works. It also means the current inline design costs the
plugin *more* tokens for no benefit, which would make it an artifact rather than a deliberate
light/full tier decision.

---

## Related

- **FEAT-175** — builds the authored `fw-new.sh` engine (full framework). Unblocked; does not wait
  on this spike.
- **FEAT-179** — plugin create-gate parity. **Blocked by this spike.**
- **TECH-169** — `/fw-move` copy reconciliation. Its option (a) ("plugins call the shared script") is
  ruled out by cache isolation; this spike tests whether a *third* option exists (plugins call
  **their own** shipped copy of the script).
- **ADR-006** (lines 83–85) — the cache-isolation constraint being tested at its boundary.
- **BUG-170** — the "put the engine where it actually runs, and ship it" lesson.

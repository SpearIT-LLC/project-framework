# Session History: 2026-07-23

**Date:** 2026-07-23
**Participants:** Gary Elliott, Claude Code
**Session Focus:** Post-retrospective enforcement question → plugin-driven architecture exploration

---

## Summary

Reviewed the 2026-07-22 Onion Retrospective, then pursued Gary's core doubt: *what assurance is there that
"consolidate, don't rewrite" won't rot like DRY did?* That question drove a chain of discovery — from "we
have no drift guard at all" to "the plugins ship no engine" to a candidate architecture: **plugin owns
behavior + freshness, build owns verifiable content, archive shrinks to a seed.** Drafted TECH-189 (source-repo
drift guard) and reconciled the architecture question against three existing backlog items. No implementation —
this was a design/decision session, deliberately paced slow.

---

## The Journey (why, not just what)

### 1. The confidence question (the session's spine)

Gary: DRY was a stated principle since very early *and the duplication happened anyway* — so why trust the new
consolidation plan? Investigation confirmed his doubt is **evidence-backed, not a worry**:

- `.git/hooks/` is **empty**. `framework/CLAUDE.md`'s claim of a "pre-commit hook validates done/" is **false** —
  it's a Claude Code `PreToolUse` hook (`.claude/hooks/Validate-WorkItems.ps1`) that fires *only* when the commit
  is made through Claude Code. Terminal/VSCode/other commits run nothing. (A BUG-170-class prose/mechanism gap.)
- `validate-framework.ps1` checks schema only, and **has no automatic trigger**.
- **No drift/duplication guard exists anywhere** — automated or manual. The Single-Source Rule (ADR-008) is
  currently *prose only* — the exact state DRY was in.

**Conclusion reached:** as written, the plan is *not* structurally different from last time. The missing piece is
a **failing gate** — a check that exits non-zero and *blocks*, run somewhere a human can't skip. Defined "CI job"
for Gary: a script a server runs automatically on a git event, whose non-zero exit blocks merge/release.

### 2. TECH-189 drafted — then narrowed by the conversation

Drafted `TECH-189-source-repo-drift-guard` (backlog): a drift-check driven by a declarative source→derived
manifest, wired to two surfaces — a `.git/hooks/pre-commit` (convenience) **and** a CI workflow (authority).
Safe no-op when the manifest is empty, so it can land *first* and protect the sweeps from their first commit.

Refined through Gary's questions:
- **Scope-to-the-commit?** Yes for the hook — but check the *manifest-family* of each staged file, not the file
  in isolation (editing a source with no derived files staged must still verify the derived copies). CI always
  full-scans (never trusts the diff — catches `--no-verify`, pre-hook commits, fresh clones).
- **How would it work in a derived project?** It *wouldn't, and shouldn't.* A derived project receives only the
  *derived* side — no source→derived pairs to drift. Guard is **repo-local; it does not ship.**

### 3. The reframe that collapsed the design (Gary's snapshot model)

Gary: a derived project is a **snapshot** — the user owns it at unpack; there is no update mechanism, by design;
the only thing worth controlling is the *framework's own files*, never the user's additions.

This **dissolved** the phantom "ship a downstream guard" idea. Two guards remain, both here:
- **TECH-189** — framework's own authoring duplication stays in sync (this repo, CI + hook).
- **TECH-188** — the *snapshot handed over* is internally consistent at build/release time.
- One-sentence boundary: **the framework guards what it authors, up to and including handoff — and nothing after.**

### 4. The architecture question Gary kept circling (and the retro left unexamined)

Gary pressed: "consolidate, don't rewrite" *assumed* the static-file/archive core rather than choosing it — and
if static files are the core, static files may *be* part of the problem. Key distinction surfaced:

- **Static-as-delivery** (archive snapshot) — innocent, keep it.
- **Static-as-authoring** (hand-editing the same concept in many files) — **this** is Root 1. It's a *missing
  build*, not a wrong medium. "Consolidate" only works this time if it means **add the compile step**, not
  "tidy the pile."

Then Gary sharpened it further: should the core be **commands that build the pieces on demand** (runtime
derivation via plugin) rather than build-time archive? Analysis:
- Runtime generation fixes the **update gap** (commands travel with the user via plugin; always current) and
  Root 1 — but does **not** fix Root 2 (a generator that runs on demand is still only as good as something
  forcing it) and sacrifices verifiability (no single moment to diff/gate).
- Resolution — **not either/or, assign each concern to the surface that fits**:
  | Concern | Surface |
  |---|---|
  | Engine + generators + guards | **Plugin (commands)** — must stay current, must run, travels with user |
  | Gate-able content (contract, type lists, indexes) | **Build-derived files** — must be diffable/CI-checkable |
  | Initial scaffold | **Command that generates once** (seed), then user owns it |

### 5. Evidence check — the plugins ship NO engine

Verified source vs plugin surfaces:
- `.claude/scripts/` has `fw-move.sh` + `work-item-types.txt` (a real single-source list).
- **Neither plugin edition ships any `.sh`/`.ps1`.** Plugin commands are *prose the AI interprets* — permanently
  the BUG-170 "silently degraded" mode. Even the one existing "author once" win (`work-item-types.txt`) doesn't
  reach the plugins.

So the real fork isn't "archive vs commands" — it's **"do the plugins ship the scripts, or keep faking behavior
in prose?"** Today they fake it. An engine-carrying plugin *is* "commands that build the pieces, always current"
+ the update channel. An engine-less plugin is a snapshot of prose — worse than the archive.

### 6. Reconciliation — the fork is already half-captured (avoid a new onion layer)

Read the relevant backlog items rather than spawning duplicates:
- **DECISION-162 (Option C)** — "single source + per-tier generation: `.claude/commands/` is source; plugin build
  *generates* plugin commands with a per-tier manifest." **This IS Gary's fork, written but `Chosen Option: TBD`.**
  Documents the drift quantitatively: `swarm` 697 lines apart, `roadmap` 436, `move` 427; plugins run *older*
  logic than `/fw-*`.
- **TECH-160** — plugin build zip/execution-model alignment. The *plumbing* (precondition), not the decision.
- **TECH-189** (new) — the guard that catches the composed content drifting.

**Highest-leverage unmade decision in the backlog: DECISION-162 → Option C.** Making it ratifies "plugin ships
engine, generated from source" and unblocks TECH-160 + the plugin-as-update-channel role.

### 7. `fw-init` sanity checks (Gary's plugin-driven contract sketch)

- **Should a future plugin-driven framework have a contract-generating command?** Yes — it's the linchpin. The
  contract can't be a frozen archive file if the plugin is the living part. `/fw-init` composes the contract into
  the project on demand, refreshing a **marked framework region** and leaving user content untouched (compose,
  never overwrite — honors "user owns their project"). It's BUG-181's build composer, moved to the plugin surface.
- **Embed logic in the command, or call `fw-init.sh`?** **Deterministic script, called by a thin command.** Prose
  composition is non-reproducible → un-guardable; TECH-189 can only re-derive-and-compare if "derive" is a
  re-runnable script. Command-as-prose and TECH-189 are mutually exclusive. Design rule: **one `fw-init.sh`,
  three callers** (plugin, archive setup, drift guard's re-derive step) — single-sourced, never hand-copied.

---

## Decisions Made (this session)

1. **Gary's confidence doubt is correct and evidence-backed** — the consolidation plan, as written, lacks the one
   thing that makes it differ from the failed DRY principle: a failing gate. Producing that gate is the assurance.
2. **The framework guards what it authors, up to handoff — nothing after.** Snapshot model is deliberate; the
   "downstream guard" idea is dropped, not logged.
3. **Do NOT spawn new items** for the content/build/guard questions — DECISION-162, TECH-160, TECH-189 hold them.
4. **Candidate architecture (not yet ratified):** plugin owns behavior + freshness; build owns verifiable content;
   archive shrinks to a seed. Deserves a short ADR (currently *assumed* in three places).
5. **`fw-init` = thin command + single-source `fw-init.sh`, one script three callers, re-runnable by the guard.**

---

## Open Questions / Next Session

- **Make the DECISION-162 call** (Option C) — highest-leverage unmade decision. Then unblocks TECH-160.
- **Write the architecture ADR** — "plugin = behavior, build = content, archive = seed" — with its load-bearing
  consequences: `fw-init` contract composition + managed-region, engine-in-plugin, one-script-three-callers.
  Gary asked the architecture question three distinct ways this session — signal it needs a stated home.
- **TECH-189 refinements to fold in** (deferred to pre-implementation review): hook = manifest-family of staged
  files; CI = full scan; explicit repo-local / no-ship boundary; the derived-vs-authored comparison-strength caveat.
- Gary's 07-23 notes (`2026-07-16-garys-thoughts.md` after line 163) sketch the full command set for the
  plugin-driven model (`/fw-init`, `/fw-new`, `/fw-move`, `/fw-kanban-state`, `/fw-next-id`, journaling, swarm,
  roadmap, research, release) — the concrete input for the architecture ADR.

---

## Files Modified

- `project-hub/retrospectives/2026-07-16-garys-thoughts.md` — Gary added a 2026-07-23 section (after line 163)
  sketching the plugin-driven architecture: `/fw-init` + `fw-init.sh` contract composition, deterministic Kanban
  commands, journaling, planning, release.
- `.claude/settings.local.json` — (working-tree change, permissions/config)

## Files Created

- `project-hub/work/backlog/TECH-189-source-repo-drift-guard.md` — the failing-gate drift guard (repo-local, CI +
  hook, empty-manifest no-op, lands first to protect the consolidation sweeps).
- `project-hub/history/sessions/2026-07-23-SESSION-HISTORY.md` — this file.

---

## Current State

### In doing/
- **BUG-181** — starter CLAUDE.md missing collaboration contract (the consolidation keystone; contract SoT +
  build composer). Unchanged this session.

### In backlog/ (relevant cluster)
- **TECH-189** (new) — source-repo drift guard.
- **DECISION-162** — command-tier sync strategy (Option C = Gary's fork; **awaiting decision**).
- **TECH-160** — plugin build execution-model alignment (Option C precondition).
- **TECH-185/186/187/188** — the four ADR-008 consolidation workstreams.

---

**Last Updated:** 2026-07-23

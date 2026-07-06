# DECISION-171: `fw-` Namespace for Framework Artifacts in User-Shared Folders

**ID:** DECISION-171
**Type:** Decision (ADR — Minor)
**Status:** Accepted
**Date:** 2026-07-06
**Deciders:** Gary Elliott, Claude Code
**Impact:** Minor
**Version Impact:** None (convention; applied incrementally by referencing items)
**Scope:** Any framework-authored file placed into a folder the consuming project also populates — primarily `.claude/` (`commands/`, `scripts/`, and future subfolders).
**Theme:** Distribution & Onboarding
**Supersedes:** None

---

## Context

**What problem are we solving?**

The framework ships files into `.claude/` — a folder that Claude Code defines and that a
consuming project **also owns and populates** with its own commands, hooks, and (potentially)
scripts. Every framework file dropped into such a folder is a potential **name collision**
with the user's own files.

The framework already mitigates this for **commands** via the `fw-` prefix (`fw-move.md`,
`fw-status.md`, … — 11 commands). But the convention was never stated as a rule, so it
didn't extend to other artifact types. **BUG-170** surfaced the gap: relocating the
`/fw-move` engine into `.claude/scripts/` as plain `move.sh` would plant a maximally-generic
filename into a user-shared folder — precisely the collision the `fw-` command prefix was
invented to avoid.

**This is not hypothetical.** **BUG-144** (filed with Anthropic,
[issue #26906](https://github.com/anthropics/claude-code/issues/26906)) documents a real
`.claude/` name-collision that **silently mis-dispatched**: an explicit
`/spearit-framework:move` ran the local `fw-move` instead, with no error. It was benign only
because both commands did the same thing; the item itself notes it would be *"catastrophic if
colliding commands have different effects."* Collisions in `.claude/` are a live, proven risk.

**Forward-looking constraint — the brownfield merge.** A recurring (discussed, not yet
tracked) scenario: someone with an **already-established repo** wants to add framework
functionality by **merging the full framework in** (the heavy path) rather than using the
plugin (the light path). Such a repo may already have its own `.claude/` with its own
`commands/`, `hooks/`, and `scripts/`. The merge is only viable if **every framework file is
collision-safe by construction** — namespaced so it can neither clobber, nor be clobbered by,
the user's existing files. We are not building the merge now, but we should not make it harder.
A namespacing convention adopted today is the cheap down-payment that keeps that door open.

---

## Options

1. **`fw-` prefix for all framework files in `.claude/`.**
   - Pros: Zero migration — consistent with the 11 already-shipped `fw-*` commands. Short
     (these names are typed and read constantly). Extends an existing, understood pattern.
   - Cons: `fw` (= "framework") is a somewhat generic token; lower brand signal and marginally
     weaker collision-resistance than a coined prefix.

2. **`sprit-` prefix (the SpearIT env-var prefix, `SPRIT_`, applied to files too).**
   - Pros: Coined, brand-bearing, higher collision-resistance; unifies with the env-var prefix.
   - Cons: Makes the 11 existing `fw-*` commands non-compliant → either a **breaking rename**
     (every downstream `/fw-move` and user muscle-memory breaks) or a grandfather clause that
     **fractures the convention** into two framework prefixes — worse for collision-reasoning
     than either pure option.

3. **`spearit-` prefix.** Highest brand/uniqueness, longest, same breaking-migration problem
   as Option 2 but more verbose. (Already in use as the plugin command namespace
   `spearit-framework:`.)

---

## Decision

We chose **Option 1 — `fw-` for all framework-authored files in user-shared folders
(`.claude/`)** because:

- **`fw-` is already the deployed reality.** 11 commands ship with it; consuming projects and
  users already type `/fw-move`. Options 2/3 would break that for a marginal safety gain.
- **The realistic collision surface is already well-covered by `fw-`.** For a file like
  `fw-move.sh`, the collision question is "does the user *also* have a file literally named
  `fw-move.sh`?" — verb+noun+framework-prefix is already very unlikely, and far safer than bare
  `move.sh`. The strong-uniqueness lever for *command dispatch* (the BUG-144 surface) is the
  fully-qualified plugin namespace `spearit-framework:`, which is unaffected by this choice.
- **Per-surface prefixes, by design** (not an accident to be "cleaned up" later):

  | Surface | Prefix | Why |
  |---|---|---|
  | Files in `.claude/` (`commands/`, `scripts/`, …) | `fw-` | Typed/read constantly → keep short; extends the existing command convention |
  | Environment variables | `SPRIT_` | Flat global namespace, no folder scoping → the extra brand-uniqueness earns its length |
  | Plugin command namespace | `spearit-framework:` | Claude Code's fully-qualified dispatch key; the strong lever against command mis-dispatch (BUG-144) |

**Implementation:** Any file the framework places into `.claude/` (or any other folder the
consuming project also populates) is named `fw-<name>`. This applies immediately to
**BUG-170**: the relocated `/fw-move` engine ships as `.claude/scripts/fw-move.sh`, not
`move.sh`.

---

## Consequences

**Good:**
- Every framework file in a user-shared folder is collision-safe by construction, extending the
  protection that previously existed only for commands.
- Keeps the future **full-framework merge into an established repo** viable — framework files
  won't clobber (or be clobbered by) a brownfield project's own `.claude/` contents.
- No migration: the 11 existing `fw-*` commands are already compliant.
- The `fw-` / `SPRIT_` / `spearit-framework:` split is now *documented as intentional per-surface
  policy*, so it stops being re-litigated.

**Bad / accepted trade-offs:**
- `fw-` carries less brand signal than `sprit-`/`spearit-`. Accepted: brand is carried by the
  plugin namespace and env-var prefix; the file prefix optimizes for brevity + zero-migration.
- Slightly weaker theoretical collision-resistance than a coined prefix. Accepted as negligible
  given the realistic collision surface.

**Revisit if:**
- Claude Code introduces a first-class mechanism for third-party files in `.claude/` (e.g. a
  vendored/namespaced subfolder), which could supersede a filename-prefix convention.
- A downstream `fw-*` collision is actually observed in the wild (would argue for a stronger
  prefix despite the migration cost).
- The brownfield-merge capability is formally scoped — it may impose additional structural
  requirements (e.g. a dedicated `.claude/fw/` subtree) that extend or replace this rule.

---

## References

- **BUG-170** — `move.sh` not shipped in distribution; its fix adopts this rule
  (`.claude/scripts/fw-move.sh`). This DECISION resolves BUG-170's open "where + what name"
  question.
- **BUG-144** — live `.claude/` command name-collision / silent mis-dispatch
  ([Anthropic #26906](https://github.com/anthropics/claude-code/issues/26906)); the evidence
  that collisions in this folder are real and dangerous.
- **FEAT-157** — Framework Provenance Stamp; sibling "framework-as-dependency" hygiene item
  (origin, not collision).
- **DECISION-050** — Framework-as-Dependency Model; the distribution model this convention
  serves.
- **Brownfield merge scenario** — discussed but not yet a work item: adding framework
  functionality to an established repo by merging the full framework (vs. the plugin path).
  Recorded here as a forward-compatibility constraint rather than as tracked work.
- **Command-tier drift cluster** — DECISION-162, TECH-161, TECH-169 (reconcile `/fw-move`
  command copies); this rule reduces future drift by fixing naming policy.

---

**Last Updated:** 2026-07-06

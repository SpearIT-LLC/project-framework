# Feature: /fw-new — Deterministic Work-Item Create Command with Type Gate

**ID:** FEAT-175
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-07-08
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->
**Theme:** Framework Consistency

---

## Summary

Introduce a `fw-new` create command whose **deterministic core** assigns the ID and **enforces the
accepted work-item type** by reading the single source of truth
(`.claude/scripts/work-item-types.txt`, ADR-006), rejecting non-`accepted` types with an actionable
message — the true implementation of ADR-006 **D6** (deterministic enforcement at the create gate).
The rest of item creation stays AI-collaborative (discovery, scoping, writing). This closes the gap
TECH-173 deliberately left open once we established that **type enforcement belongs at creation, not
at move**.

---

## Problem Statement

**What is the current state?** (verified 2026-07-08)

- TECH-173 shipped the type SoT, build-derivation into the full-framework archive, and DRY'd every
  human-facing type list — but **no deterministic gate reads it at creation.**
- The **full framework has no create command at all** (ADR-006 D7 called this "an acknowledged
  oversight"). The only create path is the **plugin `new.md`**, which is AI-driven prose — i.e.
  *probabilistic* enforcement ("the AI reads the list and usually complies").
- ADR-006's settled philosophy (D6, and the project's repeated lesson) is that **where a silent lapse
  is costly, enforcement must be deterministic** — not AI-discretion.

**Why is this a problem?**

- Nothing mechanically stops an off-list type at creation. The SoT exists and is *available*, but no
  code path *gates* on it. The guarantee ADR-006 wanted is not yet realized.
- Type drift can re-enter through the one place it matters most: item birth.

**What is the desired state?**

- A `fw-new` engine (`.claude/scripts/fw-new.sh`, beside `fw-move.sh`) that:
  1. Reads the SoT and **rejects a non-`accepted` type** with a helpful message listing the
     canonical set (and noting legacy prefixes are recognized-but-not-creatable).
  2. Assigns the next ID deterministically, using the scoped work-item scan.
  3. Hands off to the AI layer for discovery/scoping/writing (unchanged).
  4. **Commits the new item** once it is fully drafted and settled — a new work item should be a
     durable, tracked artifact from birth, not an uncommitted working-tree file that can be lost.
- The user **learns the taxonomy before they can violate it** — at setup, in `/fw-help`, and in the
  rejection message itself. Education is the first line of defense; the gate is the backstop.

*(The plugin editions get the same guarantee via **FEAT-179**, gated on **SPIKE-178**.)*

---

## Scope

> **Narrowed 2026-07-09 (pre-implementation review).** Originally spanned all three channels. The
> plugin half is split out to SPIKE-178 + FEAT-179 because it is *blocked* on an unanswered question
> (can a plugin invoke a script inside its own marketplace cache?), while the full-framework half is
> unblocked and shippable today. Education surfaces are folded **in**, not out: per the "add feature
> X, add documentation for X" principle, a gate whose only user-facing surface is a rejection message
> is not a finished feature.

**In scope — full framework only:**
- The deterministic `fw-new` create engine: **type gate** (reads the SoT) + **next-ID assignment**.
- The `/fw-new` AI layer (discovery, type suggestion, writing, commit-on-create).
- Wiring the create command for the **full framework** (closes the ADR-006 D7 "no create command" gap).
- **Education surfaces** (the feature's documentation — ships with the feature):
  - The **rejection message** itself — the teachable moment (see Type Gate Behavior below).
  - **`Setup-Framework.ps1`** — introduce the 5 accepted types at project birth (first contact).
    Ships only with the full framework; runs once at project start. It already derives `project.type`
    from `framework-schema.yaml` — deriving work-item types from the SoT is the same pattern.
  - **`/fw-help`** — add `/fw-new`; add a work-item-types section. *(Also fixes a pre-existing
    staleness bug: its command table omits `/fw-next-id` and `/fw-topic-index`, both of which exist
    in `.claude/commands/`. Verified 2026-07-09.)*
  - **`workflow-guide.md`** — document the create command + the story-with-tasks structure answer.
- **SoT header notes** — editing guidance for the next human/AI who changes the type list.

**Out of scope:**
- The type taxonomy itself (owned by ADR-006 / TECH-173 — this item consumes it).
- **Both plugin editions** — create gate, templates, and `Build-Plugin.ps1` SoT/engine derivation.
  → **FEAT-179**, which depends on **SPIKE-178**.
- A durable semantic-alias table (`chore→TECH`, `defect→BUG`). **Deliberately rejected** — see
  Type Gate Behavior. The AI reasons from the SoT + the guide's "why 5" rationale; a table would be
  a fourth copy of the type vocabulary, the exact fragmentation ADR-006 exists to prevent.
- Making a `## Documentation` section mandatory on every work item → **FEAT-180** (this item
  dogfoods it voluntarily; see its own Documentation section below).

---

## Type Gate Behavior (design settled 2026-07-09)

**Division of labor — the ADR-006 D6 split.** The AI *chooses and suggests*; the script *decides*.

1. **AI infers the type** from conversation when not given explicitly (`/fw-new "add CSV export"` →
   proposes `FEAT`), or passes through an explicit one.
2. **AI may normalize/suggest before calling the script.** Two mechanisms, both AI-layer, both
   producing a *suggestion the user confirms* — never a silent substitution:
   - **Prefix normalization** (mechanical): a canonical name that is a prefix of what the user typed
     resolves to that type. `FEATURE`→`FEAT`, `BUGFIX`→`BUG`, `TECHDEBT`→`TECH`, `TECHNICAL DEBT`→`TECH`.
     *Verified 2026-07-09 against 74 real type-name strings harvested from Jira, Jira Service
     Management, GitHub Issue Types + default labels, Azure DevOps (Agile/Scrum/CMMI/Basic), GitLab,
     Linear, Redmine, Shortcut, Conventional Commits, and SAFe: **zero false positives.** The rule
     reproduces ADR-006 D2's hand-maintained alias map exactly, with nothing to maintain.*
   - **Semantic suggestion** (judgment): the ~15 strings prefix-matching cannot reach and a real user
     actually types — `story`, `enhancement`, `improvement`, `defect`, `fix`, `incident`, `chore`,
     `refactor`, `docs`, `perf`, `research`. **No table.** The AI reasons from the accepted set plus
     the "why 5" rationale in `workflow-guide.md#work-item-types` (which already records that DOCS,
     CHORE, and REFACTOR fold into TECH as "work on the system itself").
3. **The script is strict.** `fw-new.sh` accepts only a member of the SoT's accepted set, case-
   insensitively. It has no alias logic, no fuzzy logic, no opinion about whether the *right* type
   was chosen. Every corrected type re-enters through the gate on its own merits — nothing is
   admitted by AI assertion.

**Why strict-script + lenient-AI (and not fuzzy matching in the script):** prefix-matching is safe
against today's 5 types by *property of the current list*, not by property of the rule. A future
type whose name prefixes another (or is prefixed by one) makes it silently pick wrong — and the
person adding a line to a `.txt` file has no reason to think about prefix collisions. A create gate
bakes its answer into a filename that lives forever; a type silently guessed wrong (e.g. `buggy
behavior` prefix-matching to `BUG`) is cheap to catch at the prompt and expensive to fix after it is
committed and referenced. Rejection costs one round-trip. This mirrors `fw-move.sh`: hard block in
the script, interactive recovery in the command.

**The rejection message is the primary education surface** — a lesson, not a wall. It must:
- name the accepted set,
- note legacy prefixes are recognized on existing items but never offered for creation,
- when the input maps semantically, say so *and why* (`chore` → "`TECH` covers work on the system
  itself — docs, chores, refactors"),
- and when the input is a **structural** request rather than a type, answer the real question. The
  most common: `story`. A Jira user typing `story` is asking *how do I model a story with tasks
  under it?* The framework's answer is hierarchical numbering
  (`workflow-guide.md#hierarchical-numbering-sub-items`): `FEAT-042` with `FEAT-042.1`, `FEAT-042.2`,
  max depth 3. `fw-move.sh` already moves parent + children together — the machinery exists.

---

## Next-ID Assignment

Reuse the proven rule, **not** a naive glob. The scan is scoped to the work-item folders
(`work/`, `releases/`, `poc/`, `history/spikes/`) per ADR-006 D2.

**This is load-bearing, verified 2026-07-09:** a naive `TYPE-NNN` grep across `project-hub/` returns
`202` — matching `ROADMAP-2026-02-04.md` as `ROADMAP-202`. The canonical scoped scan returns `178`.
An unscoped implementation would silently burn 25 IDs on its first run and corrupt the shared
namespace. (This is the same scan-boundary hazard ADR-006 D2 documents and TECH-173 hit in testing.)

`Get-NextWorkItemId` (PowerShell) stays as-is for `/fw-next-id`. Consolidating the bash and
PowerShell implementations is deferred to the ADR-006 D7 "deterministic engine strategy" decision —
note that `FrameworkWorkflow.psm1:121` also carries a **hardcoded fallback copy** of the accepted set,
which that consolidation should delete.

---

## Acceptance Criteria

**Gate + engine**
- [ ] `fw-new.sh` reads `.claude/scripts/work-item-types.txt` and **rejects** any type not in the
      accepted set, case-insensitively, exiting non-zero
- [ ] The script contains **no alias or fuzzy logic** — normalization/suggestion is AI-layer only
- [ ] Legacy prefixes are **not** offered for creation (but remain recognized by scanning elsewhere)
- [ ] Next-ID assignment is deterministic and collision-free, using the **scoped** work-item folders
      (`work/`, `releases/`, `poc/`, `history/spikes/`) — verified it returns `178`, not `202`,
      on this repo
- [ ] Full framework gains a working `/fw-new` create path (closes ADR-006 D7 oversight)
- [ ] **New item is committed once fully drafted** — the create flow prompts to commit (default-yes)
      after the item is written and settled. (Prompt-first per 2026-07-08 discussion; may tighten to
      silent auto-commit later. Today's plugin `new.md` prompts at Step 8 — carry that behavior.)

**Education (ships with the feature)**
- [ ] Rejection message names the accepted set, notes legacy-recognized-not-creatable, and gives a
      semantic suggestion when one applies
- [ ] Rejection on `story` (or similar) explains **hierarchical sub-items** (`FEAT-042.1`) rather
      than merely rejecting
- [ ] `Setup-Framework.ps1` introduces the accepted types at project setup, **derived from the SoT**
      (not hardcoded — mirrors its existing `project.type`-from-schema derivation)
- [ ] `/fw-help` lists `/fw-new` and documents the work-item types
- [ ] `/fw-help` command table no longer omits `/fw-next-id` and `/fw-topic-index` (pre-existing bug)
- [ ] `workflow-guide.md` documents the create command and points at the sub-item structure
- [ ] `work-item-types.txt` header explains how to add/edit a type, notes that a new type **requires a
      matching `TYPE-TEMPLATE.md`**, and points at ADR-006 D1 for the "why 5" rationale (pointer,
      not a restatement)
- [ ] CHANGELOG.md updated

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->

- [x] **PRE-IMPLEMENTATION REVIEW COMPLETED** — engine design, gate behavior, ID strategy, channel
      strategy, and education surfaces reviewed and approved 2026-07-09. Scope narrowed to the full
      framework; plugin work split to SPIKE-178 + FEAT-179.
- [ ] Build `fw-new.sh`: deterministic type gate (reads SoT, strict)
- [ ] Wire next-ID assignment into `fw-new.sh` (scoped scan — verify `178` not `202`)
- [ ] Write `.claude/commands/fw-new.md` (AI layer: discovery, prefix-normalize, semantic-suggest,
      confirm, write from template, commit-on-create)
- [ ] Rejection-message education (accepted set, legacy note, semantic suggestion, sub-item answer)
- [ ] SoT header notes (edit guidance, template requirement, ADR-006 pointer)
- [ ] `Setup-Framework.ps1` — types at project birth, derived from SoT
- [ ] `/fw-help` — add `/fw-new` + types section; fix the two stale omissions
- [ ] `workflow-guide.md` — create-command + sub-item structure
- [ ] CHANGELOG.md updated

---

## Documentation

<!-- Dogfooding FEAT-180's proposal (mandatory documentation section) before making it a rule. -->

Documentation shipping **as part of this feature**, not after it:

| Surface | What it must say | Audience |
|---|---|---|
| `Setup-Framework.ps1` | the 5 accepted types, at project birth | brand-new project |
| `/fw-help` | `/fw-new` syntax; the accepted types | any user, any time |
| `/fw-new` rejection | why this type isn't accepted; what to use instead | user who guessed wrong |
| `workflow-guide.md` | create command; story→sub-item structure | reader learning the model |
| `work-item-types.txt` header | how to add/edit a type safely | whoever edits the SoT |

**Not documented here (deliberate):** the semantic alias mapping. It lives in AI judgment informed by
`workflow-guide.md#work-item-types`; writing it down would create the fourth copy of the type
vocabulary that ADR-006 exists to prevent.

---

## Cross-Channel Equivalence (added 2026-07-09, pre-implementation review)

All three channels (full framework, plugin-full, plugin-light) must produce **functionally identical**
`new` behavior. Verified facts that shape how:

- **Plugins already ship executable bash.** `plugins/*/commands/move.md`, `backlog.md`, and
  `kanban-state.md` embed `#!/usr/bin/env bash` inline and instruct the AI to run it. There is no
  "plugins are prose-only" policy anywhere in the repo — searched and confirmed. The channel
  difference is **inline-embedded vs. shared-file**, not scripts-vs-AI.
- **The plugin cannot call the shared script.** It ships via marketplace cache and forbids reading
  outside itself (`help.md`: "Do NOT read from `.claude/commands/`"; ADR-006 lines 83–85). Inline
  embedding is *forced by channel isolation.*
- **Therefore: derive, don't restate.** `.claude/scripts/fw-new.sh` (built by *this* item) is the one
  authored engine. **FEAT-179** makes `Build-Plugin.ps1` generate each plugin edition's copy from it.
- **Open question — how the plugin consumes it.** If a plugin can invoke a script inside its own
  cached directory (**SPIKE-178**), the build is a verbatim `Copy-Item` and the copies cannot drift.
  If not, the build must *transform* the script into the plugin's existing inline-bash form —
  the inline block is parameterized by AI substitution (`TARGET="<target-folder>"`) where the `.sh`
  takes positional `$1`, so the build would inject a resolved-arguments preamble and strip the CLI
  arg-parsing block. Copy is strictly better; the spike decides.
- **Efficiency tiering survives either way.** Full framework invokes the script file directly (one
  bash call). Note the inline form costs the plugin *more* tokens, not fewer — so if SPIKE-178
  succeeds, the plugin gets faster, and the current inline design turns out to be an artifact rather
  than a deliberate tier choice.

This makes `/fw-new` the **first command equivalent across all three channels by construction**
rather than by hand-syncing — the pattern TECH-169 has been holding open for `/fw-move`. This item
builds the authored engine; FEAT-179 fans it out.

---

## Related

- **ADR-006** (Accepted 2026-07-07) — **D6** (deterministic enforcement at the mechanical gate) and
  **D7** (`/fw-new` named as separate future work). This item implements D6's create gate.
- **TECH-173** — shipped the SoT, build-derivation (full framework), and DRY. Established that type
  enforcement belongs at **creation, not move**, and deliberately left this gate to this item.
- **SPIKE-178** — can a plugin invoke a script inside its own marketplace cache? Blocks FEAT-179.
- **FEAT-179** — plugin create-gate parity (both editions): gate, templates, `Build-Plugin.ps1`
  derivation of the SoT + engine. **Depends on SPIKE-178.** Carries the work split out of this item.
- **FEAT-180** — make a `## Documentation` section mandatory on work items. This item dogfoods it.
- **TECH-169** — `/fw-move` copy reconciliation. FEAT-179 pilots its option (b) (build-generated
  inline script); option (a) is ruled out by plugin cache isolation. See its Notes.
- **DECISION-162 / TECH-161** — the broader command-tier drift effort this equivalence work serves.
- **TECH-176** — template filename rename (`FEATURE-`/`TECHDEBT-` → `FEAT-`/`TECH-`). The create flow
  resolves a template per type, so it must not hard-code the pre-rename names.
- **TECH-177** — checkbox convention (`[-]` for not-applicable). Relevant to FEAT-180's doc checkbox.
- **BUG-170 / FEAT-145** — the "put the engine where it actually runs, and ship it" lesson.

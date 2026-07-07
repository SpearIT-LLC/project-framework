# ADR-006: Work-Item Type Taxonomy, Single Source of Truth, and Cross-Channel Derivation

**Status:** Proposed
**Date:** 2026-07-06
**Deciders:** Gary Elliott, Claude Code
**Impact:** Major
**Scope:** Work-item type system across all distribution channels (full framework, plugin, plugin-light) — canonical types, legacy aliases, the source-of-truth file, and how each channel consumes it.
**Supersedes:** None

> **This ADR is a WORKSPACE (Status: Proposed).** Nothing here is decided until the Status
> flips to Accepted. Each numbered decision below carries options + a recommendation; we ratify
> or revise them one at a time. TECH-173 is re-pointed to "implement this ADR once Accepted."

---

## Context and Problem Statement

The framework's set of valid work-item types is **restated in many places that disagree**, and
the DRY single-source-of-truth we keep trying to establish "keeps showing up" fragmented. Verified
2026-07-06:

**Four+ disagreeing lists exist:**

| Source | Types listed |
|---|---|
| `workflow-guide.md` "5 total" table | FEAT, BUG, TECH, DECISION, SPIKE |
| ID-namespace prose / `FrameworkWorkflow.psm1` | + POLICY (+ BUGFIX in `.psm1`) |
| plugin `new.md` (both editions, identical) | FEAT, BUG, CHORE, TASK, DOCS, REFACTOR, DECISION, TECH |
| full framework | **has no `/new` command** — type list only in docs |

The two plugin editions agree with each other; the **full framework channel has already drifted
from the plugin channel** (plugins list CHORE/TASK/DOCS/REFACTOR but not SPIKE; docs list SPIKE but
not those). The lists are also polluted by **multiple spellings of one concept** (see usage data).

**Actual usage across all 239 work items (work/ + history/), by prefix (verified 2026-07-06):**

| Prefix | Count | Note |
|---|---|---|
| FEAT | 105 | canonical |
| TECH | 65 | canonical (template is `TECHDEBT-TEMPLATE.md` — 3rd spelling) |
| FEATURE | 14 | **alias of FEAT** (old spelling) |
| DECISION | 14 | being retired → ADR (per TECH-172) |
| BUGFIX | 8 | **alias of BUG** (deliberate past rename) |
| BUG | 8 | canonical |
| CHORE | 6 | real, used |
| DOCS | 4 | canonical |
| DOC | 3 | **alias of DOCS** |
| TASK | 2 | real, used |
| REFACTOR | 2 | real, used |
| SPIKE | 1 | barely used, architecturally distinct (time-boxed research) |
| POLICY | 0 | **phantom — declared in plumbing, never instantiated** |

**Root cause (why DRY keeps re-fragmenting):** four different *consumers* (human docs, AI
create-flow, the bash engine, PowerShell tooling) each needed the list in their own form, across
**two distribution channels that share no runtime file**, and nothing connected them. DRY-by-
discipline (hand-keeping copies in sync) has failed every time — the documented, repeated failure
mode this whole project fights.

**Settled philosophy (from prior experience, not re-litigated here):** *probabilistic* enforcement
(AI reads a rule and usually follows it) is insufficient for anything where a silent lapse is
costly — this is why the CLAUDE.md bootstrap, move.sh, and the checkpoint policy exist.
**Where it matters, enforcement must be deterministic/guaranteed.** This ADR must honor that.

**Key constraints discovered:**
- The **plugin is self-contained and isolated** — it explicitly forbids reading from `.claude/`
  (`help.md`: "Do NOT read from `.claude/commands/`") and ships via marketplace cache, not copied
  into the consuming repo. So a single *shared runtime file* across channels is impossible.
- The **live deterministic engine is `move.sh` (bash)** — the SoT format must be bash-consumable
  with zero ceremony (YAML is bash-hostile; rich JSON needs `jq`).

---

## Decisions (each: options + recommendation — ratify one at a time)

### D1 — Canonical type set

The industry-standard-aligned set the usage data supports. **Recommendation:** adopt the
conventional-commits / agile-aligned set actually in use, drop the phantom:

- **FEAT, BUG, TECH, DOCS, CHORE, REFACTOR, TASK, SPIKE** (8 accepted)
- Drop **POLICY** (0 uses, never instantiated). **DECISION** → retired to ADR (TECH-172).

*Open sub-question:* **SPIKE** has only 1 use — keep (it's architecturally distinct: time-boxed
research, and it's an agile standard) or drop? Recommendation: **keep** (low cost, real concept).
*Open sub-question:* are **TASK** (2) and **REFACTOR** (2) worth keeping as distinct types, or fold
TASK→CHORE / REFACTOR→TECH? Recommendation: **keep both** — they're conventional-commits standard
and semantically distinct.

### D2 — Legacy alias map (recognized-for-parsing, never created)

**Recommendation:**

| Legacy | Canonical | Reason |
|---|---|---|
| FEATURE | FEAT | old spelling (14 items) |
| BUGFIX | BUG | deliberate past rename (8 items) |
| DOC | DOCS | spelling (3 items) |
| TECHDEBT | TECH | template-name spelling |
| DECISION | (ADR) | retired per TECH-172 (14 items) |
| POLICY | (none) | phantom; recognized only if any ever appear |

Legacy prefixes **parse/validate** (historical items never break) but are **never offered for
creation**. This is the accepted-vs-recognized distinction, now backed by usage data.

### D3 — Types are UNIVERSAL, not tiered

**Recommendation (decided-in-principle 2026-07-06):** Work-item *types* are a **universal,
non-tiered constant**. Feature tiering (light < plugin < full framework) applies to **which
commands ship**, never to the **type vocabulary**. Evidence: both plugin editions already ship the
identical type list; a type is a type regardless of tooling depth. Light users create the same
kinds of items; they just have fewer power-tools.

### D4 — Single source of truth: one authored source, build derives per channel (Option A)

Because the two channels share no runtime file (constraint above), a single *runtime* file is
impossible. **Recommendation:** one **authored** source; the build **derives** each channel's copy.

- **Author once** — a flat, bash-readable file (format in D5), living in the full framework's
  source (candidate: `.claude/scripts/`, beside its engine/commands).
- **Full framework** reads it directly.
- **Plugin build** (`Build-Plugin.ps1`) **generates** the plugin editions' copies from it — never
  hand-edited. Two runtime files, **one authored source.**
- Docs / `new.md` / skills **derive-from or point-to** the source; they do not restate it.

This is "derive, don't restate" applied across the build boundary — the mechanism that structurally
prevents re-fragmentation (nothing to hand-sync).

*Rejected — Option B (two authored sources + a release-time equality check):* keeps two
hand-authored copies (the exact thing that has bitten us), merely guarded. DRY-by-derivation beats
DRY-by-enforcement here.

### D5 — SoT file format (flat / bash-readable)

**Recommendation:** a **flat line-based file** the bash engine reads natively — e.g.
`name<TAB>status<TAB>alias-target`:

```
FEAT      accepted
BUG       accepted
TECH      accepted
DOCS      accepted
CHORE     accepted
REFACTOR  accepted
TASK      accepted
SPIKE     accepted
FEATURE   legacy    FEAT
BUGFIX    legacy    BUG
DOC       legacy    DOCS
TECHDEBT  legacy    TECH
DECISION  legacy    ADR
```

*Open:* exact shape (whitespace-delimited vs CSV vs minimal JSON). **Left UNDECIDED per Gary** —
tied to D7 (engine strategy). Constraint: must be trivially readable by `move.sh` today **and** by a
future compiled tool unchanged. Flat text satisfies both; JSON would need `jq` in bash now.

### D6 — Enforcement is deterministic at the mechanical gate

**Recommendation (per settled philosophy):** type validation runs in the **deterministic engine**
(the create/move path — `move.sh` and whatever create-script exists), reading the SoT, rejecting
non-`accepted` types. Not "the AI reads a rule and usually complies." The AI's role is **choosing**
which valid type fits and **writing** the item well — it is fed the canonical list, it does not
define or gate it.

### D7 — Named-but-OUT-OF-SCOPE (future, separate ADRs)

- **`framework-schema.yaml` relationship:** the type SoT being a flat file does **not** imply the
  schema is wrong. They are **different consumers** — rich human/AI *project config* (YAML earns its
  complexity) vs. a simple machine-facing *type list* (flat file). "Right tool per job." This ADR
  states this as a **deliberate one-off split, not a general format flip**; the schema is left
  as-is. (Answers Gary's Q2.)
- **`/fw-new` for the full framework:** the full framework has **no create command** (an
  acknowledged oversight). Create-parity across channels is real work but **separate** — flagged
  here, not decided.
- **Deterministic engine strategy (bash vs. a future C# / compiled CLI):** as deterministic logic
  grows, bash's limits (no data structures, painful parsing) may justify a small compiled CLI.
  **Own ADR.** The D5 flat-file format is chosen to work for bash now and such a tool later
  unchanged — so this decision is *deferrable without cost.* (Answers Gary's Q1.)

---

## Consequences

**Good:**
- One authored source of work-item types; every channel derives from it — the re-fragmentation
  stops structurally, not by discipline.
- Type vocabulary reconciled across the (currently-drifted) channels and de-duplicated of spellings.
- Deterministic enforcement where it matters; AI does what it's good at (choosing/writing).
- Future engine (C#) and create-parity (`/fw-new`) decisions are cleanly deferred, not blocked.

**Bad / accepted trade-offs:**
- Two runtime files (per-channel), unavoidable given channel isolation — accepted, because there is
  **one authored source** and the build fans it out.
- Adds a small generation step to `Build-Plugin.ps1`.
- Introduces a second config format (flat file alongside YAML) — accepted and *named* as a
  deliberate per-consumer choice (D7), not silent drift.

**Revisit if:**
- The deterministic surface grows enough to warrant the compiled-CLI ADR (D7).
- A channel needs a genuinely different type set (would challenge D3's universality).
- Claude Code introduces a first-class shared-config mechanism across plugin + local (could
  replace the build-derivation in D4).

---

## References

- **TECH-173** — implements this ADR (re-pointed from "add a YAML enum" to "implement ADR-006").
- **TECH-172** — retires the `DECISION-*` type → ADR; this ADR classifies DECISION as legacy.
- **DECISION-042** — defined the shared work-item ID namespace.
- **BUG-170 / FEAT-145** — the move.sh-ships-and-runs lesson that shaped D4/D5/D6 (put the SoT
  where the deterministic engine can actually read it, downstream).
- Usage data + channel analysis — captured inline (Context), verified 2026-07-06.
- Industry basis — conventional-commits type vocabulary (feat/fix/docs/chore/refactor), agile SPIKE.

---

**Last Updated:** 2026-07-06

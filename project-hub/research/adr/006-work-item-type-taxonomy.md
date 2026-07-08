# ADR-006: Work-Item Type Taxonomy, Single Source of Truth, and Cross-Channel Derivation

**Status:** Accepted
**Date:** 2026-07-06 (Proposed) · 2026-07-07 (Accepted)
**Deciders:** Gary Elliott, Claude Code
**Impact:** Major
**Scope:** Work-item type system across all distribution channels (full framework, plugin, plugin-light) — canonical types, legacy aliases, the source-of-truth file, and how each channel consumes it.
**Supersedes:** None

> **RATIFIED 2026-07-07.** This ADR began as a workspace (Status: Proposed); all seven decisions
> D1–D7 are now decided. The two D1 sub-questions (SPIKE; TASK/REFACTOR) and the D5 format were
> resolved this session — all as recommended. TECH-173 is now re-scoped to "implement this ADR."

> **AMENDED 2026-07-08 (during TECH-173 implementation).** A taxonomy sanity-check against usage data
> and industry trackers revised two decisions. See the amendment notes inline at **D1** and **D2**;
> summary:
> - **D1 — canonical set reduced 8 → 5: FEAT, BUG, TECH, TASK, SPIKE.** Dropped DOCS, CHORE, REFACTOR
>   (fold into TECH) and reinstated **TASK** over the earlier 8-set. Rationale: usage data (FEAT 105,
>   TECH 65 dominate; DOCS/CHORE/REFACTOR/TASK/SPIKE all ≤6) plus interop — Jira & GitHub both default
>   to Feature/Bug/**Task** (neither ships CHORE/REFACTOR/SPIKE as a default type). TECH kept (2nd-most-
>   used; the product-vs-internal distinction). SPIKE kept (distinct research lifecycle + poc/ handling).
> - **D2/D4/D5 — "legacy" is no longer an authored list.** Any prefix present on disk that is not in
>   the accepted set is, *by definition*, legacy: recognized for parsing, never offered for creation.
>   Legacy is per-project and self-discovered — nothing to ship. The SoT therefore ships the **accepted
>   set only** (universal, zero historical baggage), as a flat newline-delimited **`.txt`** (the
>   TAB/alias-column of D5 is obsolete once only accepted names are listed). A small fixed
>   spelling-alias map (FEATURE→FEAT, BUGFIX→BUG, DOC→DOCS, TECHDEBT→TECH) lives in the tooling as a
>   closed normalization set, not project history.
> - **Enforcement** (create-not-move): the deterministic gate belongs at **creation** (`/fw-new`,
>   FEAT-175), not the move path; `fw-move.sh` stays type-agnostic. (Clarifies D6.)

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

**DECIDED 2026-07-07:** **SPIKE is kept** (1 use, but architecturally distinct — time-boxed
research — and an agile standard; low cost to retain). **TASK and REFACTOR are both kept as
distinct accepted types** — conventional-commits standard, semantically distinct from CHORE/TECH.
Canonical set is therefore the full **8: FEAT, BUG, TECH, DOCS, CHORE, REFACTOR, TASK, SPIKE.**

> **AMENDED 2026-07-08 — canonical set reduced to 5: FEAT, BUG, TECH, TASK, SPIKE.** The 8-set did
> not survive a sanity-check. **Usage data:** FEAT (105) and TECH (65) dominate; every other type is
> ≤6 uses (CHORE 6, DOCS 4, TASK 2, REFACTOR 2, SPIKE 1) — four lightly-used buckets with overlapping
> boundaries (CHORE/REFACTOR/DOCS all describe "work on the system"). **Simplicity:** the framework's
> thesis is a simple file-based Kanban; an 8-way taxonomy was its least-simple part, and a type here
> only picks a prefix/template (it drives no automation), so fine discrimination has little payoff.
> **Interop:** Jira and GitHub both default to Feature/Bug/**Task**; neither ships CHORE/REFACTOR/DOCS/
> SPIKE as a default *type* (labels instead). So **DOCS, CHORE, REFACTOR are dropped** (fold into TECH)
> and **TASK is reinstated** (universal tracker default; maps cleanly for e.g. Jira-linked projects).
> **TECH is kept** despite not being a CC/Jira default — it is the 2nd-most-used type and carries the
> product-vs-internal distinction (a TECH item still maps to a Jira Task + `tech-debt` label). **SPIKE
> is kept** — its research lifecycle (decision-as-done, `poc/` → `history/spikes/` handling) is
> unmergeable. Dropped types remain valid on existing items via the disk-derived-legacy rule (see D2).

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

> **AMENDED 2026-07-08 — legacy is disk-derived, not an authored list.** The table above is
> illustrative, not a shipped artifact. "Legacy" = *this project's* accumulated history, which a
> brand-new project does not share — shipping a legacy list would impose our baggage as their default.
> Instead: **any prefix found on an existing item that is not in the accepted set is, by definition,
> legacy** — recognized for parsing/scanning, never offered for creation. The recognized set is thus
> "accepted ∪ whatever is present on disk," self-discovered per project, nothing to author or ship.
> The dropped D1 types (DOCS, CHORE, REFACTOR) need no special handling: their existing items are
> recognized-as-legacy automatically. The tooling keeps only a small **fixed spelling-alias** map
> (FEATURE→FEAT, BUGFIX→BUG, DOC→DOCS, TECHDEBT→TECH) — closed spelling variants, not history.
> **DECISION** is recognized-as-legacy but never rewritten (ADR is a separate document series). Prefix
> matching is case-insensitive (uppercase canonical, lowercase accepted).
>
> **Scope of "on disk" = the work-item folders, not the whole repo.** Discovery matches a generic
> `TYPE-NNN` prefix, but only within the work-item scan locations (`work/`, `releases/`, `poc/`,
> `history/spikes/`). This boundary (pre-existing in `Get-NextWorkItemId`) is what keeps non-work-item
> artifacts out: e.g. `/fw-roadmap` output (`ROADMAP-YYYY-MM-DD` in `history/archive/`) and test
> fixtures (`TEST-0xx` inside a work item's artifact folder under `history/releases/`) are NOT in the
> scanned folders, so they are correctly never treated as work items or legacy types. Verified by
> dogfooding this repo 2026-07-08: the scoped scan yields legacy = BUGFIX, CHORE, DECISION, DOCS,
> FEATURE — all genuine historical prefixes, no false positives.

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

### D5 — SoT file format (flat / bash-readable) — **DECIDED: TAB-delimited**

**DECIDED 2026-07-07:** a **flat, TAB-delimited, line-based file** the bash engine reads natively:
`name<TAB>status[<TAB>alias-target]`. One type per line; `#` comment lines and blank lines ignored;
`alias-target` present only on `legacy` rows. Chosen over CSV (needless ceremony for the empty alias
column) and JSON (would introduce a `jq` dependency the engine must avoid). Satisfies the constraint
in both directions: trivially parseable by `move.sh` today (`while IFS=$'\t' read`) and by a future
compiled tool unchanged.

> **AMENDED 2026-07-08 — simplified to a newline-delimited `.txt` (accepted names only).** Once the
> D2 amendment made "legacy" disk-derived, the file lists *only accepted type names* — so the
> `status` and `alias-target` columns vanish and there is nothing tab-separated left. The shipped
> file is therefore `.claude/scripts/work-item-types.txt`: one accepted type per line, `#` comments
> and blanks ignored, case-insensitive. Still zero-dependency and bash-trivial (`while read`). The
> D5 reasoning (flat, no `jq`, future-tool-friendly) stands; only the shape shrank.

Canonical file shape (columns shown space-aligned for readability; **actual separator is a TAB**):

```
# work-item types — single source of truth (ADR-006). Format: name<TAB>status[<TAB>alias-target]
# status: accepted (offered for creation) | legacy (recognized for parsing, never created)
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

The exact filename/location is an implementation detail for TECH-173 (candidate:
`.claude/scripts/`, beside the engine per D4).

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

**Last Updated:** 2026-07-08 (amended during TECH-173 impl — set reduced 8→5; legacy now disk-derived;
SoT is `.txt`. Status remains Accepted.)

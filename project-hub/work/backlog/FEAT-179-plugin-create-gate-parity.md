# Feature: Plugin Create-Gate Parity — Derive the Engine, SoT, and Templates into Both Editions

**ID:** FEAT-179
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-07-09
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->
**Theme:** Framework Consistency
**Depends On:** SPIKE-178, FEAT-175

---

## Summary

Bring both plugin editions to **functional parity** with the full framework's `/fw-new` create gate
(FEAT-175), by **deriving** the engine, the type single-source-of-truth, and the work-item templates
into each edition at build time — rather than hand-maintaining copies that are free to drift.

Also fixes a **live bug** discovered 2026-07-09: the plugins offer 5 work-item types but ship only
3 templates, two of which are wrong.

---

## Problem Statement

**What is the current state?** (verified 2026-07-09)

- **The plugins have no deterministic create gate.** Their `new.md` is AI prose that restates the
  accepted type list in an HTML comment (`new.md:63-68`). Probabilistic enforcement.
- **The plugins offer 5 types but ship 3 templates.** `new.md:63` correctly lists
  `FEAT, BUG, TECH, TASK, SPIKE` (post-ADR-006). `plugins/*/templates/` contains only
  `FEAT-template.md`, `BUG-template.md`, `CHORE-template.md`. So:
  - a plugin user choosing **TECH, TASK, or SPIKE has no template to resolve** — the create flow
    Step 5 ("Read `templates/{TYPE}-template.md`") fails;
  - **`CHORE` is a retired type** that still ships a template and is still walked through as a
    worked example in `new.md` Step 2 and Step 5.
- **Nobody decided this.** Traced 2026-07-09: the 3 templates are an artifact of
  `FEAT-118-PLAN-template-extraction.md:19,31` (Feb 2026), which extracted the three templates that
  *happened to be inline* in `new.md` — for **file-size reasons** ("~180 lines"). No document records
  a decision to cap plugin types at three, or a rationale for `CHORE`. The full plugin later copied
  the same three from light (`FEAT-127.1:129`). ADR-006 **D3** says types are a *universal, non-tiered
  constant* — so there is no principled basis for a plugin/framework type difference.
- **The full plugin's `new.md` is a stale copy of the light one** — it self-names
  `/spearit-framework-light:new` throughout.
- **TECH-176 explicitly assigned the plugin template trees here:** *"Plugin template trees (their own
  reconciliation — coordinate with the plugin work in FEAT-175)."*

**Why is this a problem?**

Three channels that must behave identically, don't. A user's `/fw-new TECH` succeeds in the full
framework and fails in the plugin. And the type list is restated in plugin prose — the very
re-fragmentation ADR-006 D4 exists to structurally prevent.

**What is the desired state?**

`Build-Plugin.ps1` derives everything type-related into each edition from the one authored source.
Nothing about work-item types is hand-authored in the plugin tree. The three channels agree by
**construction**, not by discipline.

---

## Scope

**In scope:**
- **Derive the create engine** into both editions from `.claude/scripts/fw-new.sh` (built by FEAT-175).
  Mechanism depends on **SPIKE-178**:
  - *If a plugin can invoke its own cached script* → ship `scripts/fw-new.sh` via verbatim `Copy-Item`.
  - *If not* → build-time transform into the plugin's existing inline-bash form (inject a
    resolved-arguments preamble, strip the CLI arg-parsing block, splice between
    `<!-- BEGIN GENERATED -->` / `<!-- END GENERATED -->` markers).
- **Derive the type SoT** (`work-item-types.txt`) into each edition. *(Deferred from TECH-173
  precisely because the plugin had no consumer of the SoT until a create gate existed.)*
- **Reconcile the plugin template trees to the accepted 5** — add `TECH`, `TASK`, `SPIKE`; retire
  `CHORE`. Prefer deriving from `framework/templates/work-items/` over hand-authoring.
- **Rewrite plugin `new.md`** (both editions) to invoke the gate rather than restate the type list;
  fix the full edition's `/spearit-framework-light:` self-naming.
- **Build hard-fails** if a derivation source is missing or a splice marker is absent (BUG-170 posture:
  a ship-gap must break the build, not ship quietly).

**Out of scope:**
- The `fw-new` engine itself and its type-gate design (**FEAT-175** — this item consumes it).
- The type taxonomy (**ADR-006** / TECH-173).
- Reconciling `/fw-move`'s three copies (**TECH-169** — but this item establishes the pattern it
  inherits).
- Template *filename* rename in the full framework (**TECH-176**).

---

## Acceptance Criteria

- [ ] Both plugin editions have a deterministic create gate that **rejects** non-accepted types
- [ ] Both editions ship `work-item-types.txt`, derived (never hand-edited)
- [ ] Both editions ship a template for **every** accepted type — `FEAT, BUG, TECH, TASK, SPIKE`
- [ ] `CHORE-template.md` removed from both editions; no `CHORE` examples remain in `new.md`
- [ ] Full edition's `new.md` no longer self-names `/spearit-framework-light:`
- [ ] Plugin `new.md` no longer restates the accepted type list — it derives or points
- [ ] `Build-Plugin.ps1` **fails the build** if the SoT, the engine, or a required template is missing
- [ ] Generated content cannot survive a hand-edit: build re-derives and diffs (or copies verbatim)
- [ ] All three channels verified to produce identical results for the same `/fw-new` input:
      same accepted set, same rejection behavior, same next ID, same template resolution
- [ ] `/fw-new TECH`, `/fw-new TASK`, `/fw-new SPIKE` all succeed in **both** plugin editions
      (they currently fail — no template)
- [ ] Plugin `skills/work-items.md` (both editions) reconciled — no restated type list
- [ ] Documentation ships with the feature: plugin `help.md` + `README.md` reflect the create command
      and the accepted types
- [ ] Plugin CHANGELOGs updated (both editions)

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->

- [ ] **PRE-IMPLEMENTATION REVIEW COMPLETED** — confirm SPIKE-178's answer, present the derivation
      design (copy vs. transform), template strategy, and build-failure posture; user approves
- [ ] `Build-Plugin.ps1`: derive `work-item-types.txt` into both editions
- [ ] `Build-Plugin.ps1`: derive the create engine (mechanism per SPIKE-178)
- [ ] `Build-Plugin.ps1`: derive/reconcile templates to the accepted 5; remove `CHORE`
- [ ] Rewrite plugin `new.md` (both editions) — invoke the gate; fix full edition's self-naming
- [ ] Reconcile plugin `skills/work-items.md` (both editions)
- [ ] Build-failure guards (missing source, missing marker, missing template)
- [ ] Cross-channel equivalence test (all three channels, same inputs, same outputs)
- [ ] Plugin `help.md` / `README.md` documentation
- [ ] Plugin CHANGELOGs updated

---

## Documentation

| Surface | What it must say |
|---|---|
| plugin `help.md` (both) | `/new` syntax; the accepted types |
| plugin `README.md` (both) | the 5 types; that they match the full framework |
| plugin `new.md` rejection | same teaching message as the full framework's gate |
| plugin CHANGELOGs | the `CHORE` retirement (a breaking change for anyone using it) |

**Migration note to document:** removing `CHORE-template.md` is user-visible. Existing `CHORE-*` items
remain valid (recognized-as-legacy, ADR-006 D2); only *creation* stops. Say so explicitly.

---

## Related

- **SPIKE-178** — **blocks this item.** Decides copy-vs-transform.
- **FEAT-175** — builds the authored `fw-new.sh` engine + gate design this item fans out.
- **TECH-169** — `/fw-move` copy reconciliation. This item establishes the derivation pattern
  TECH-169 inherits; option (a) is ruled out by cache isolation.
- **TECH-176** — full-framework template rename. Coordinate: it explicitly deferred the *plugin*
  template trees to this work.
- **ADR-006** — **D3** (types are universal, non-tiered — the basis for demanding parity),
  **D4** (build derives per channel), **D6** (deterministic enforcement at the create gate).
- **DECISION-162 / TECH-161** — the broader command-tier drift effort.
- **FEAT-118 / FEAT-127.1** — where the 3-template artifact originated (file-size extraction, Feb 2026).
- **BUG-170** — ship-gaps must break the build.

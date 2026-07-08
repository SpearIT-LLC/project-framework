# Tech Debt: Enforce an Accepted Work-Item-Type Allowlist (Canonical List + Legacy-Recognized Superset)

**ID:** TECH-173
**Type:** Tech Debt
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-07-06
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->
**Theme:** Framework Consistency

---

## Summary

**Implement ADR-006** (Accepted 2026-07-07). The framework's set of "valid work-item types" was
**defined in 4+ places that disagreed** across two isolated distribution channels, and nothing
*enforced* a single canonical list. ADR-006 designed the fix: **one authored flat TAB-delimited
source of truth**, the **build derives** each channel's copy, and **deterministic enforcement** runs
in the mechanical engine (create/move path) rather than relying on the AI to "usually comply." This
item builds that. It closes type-drift structurally and is the mechanism that makes TECH-172's
DECISION retirement stick.

> **Re-scoped 2026-07-07.** This item originally proposed a `work_item.type` YAML enum inside
> `framework-schema.yaml`. That spec is **superseded by ADR-006**, which decided (D4/D5) a flat
> TAB-delimited file — build-derived per channel — and (D7) that the schema stays as-is (it's a
> different consumer). Implement the ADR, not the original enum spec. The original spec text is
> retained below the line for provenance.

> **Re-scoped again 2026-07-08 (create-not-move correction).** Implementation exposed that the
> original framing wrongly located type enforcement at the **move** path. A move operates on an
> *already-created* file, so it can never introduce a bad type — and gating it would wrongly reject
> legacy `DECISION-*`/`BUGFIX-*` items. **Type enforcement belongs at creation, not move.** The
> deterministic create gate (ADR-006 **D6**) is therefore split out to **FEAT-175** (`/fw-new`),
> which is where creation actually happens and which ADR-006 **D7** already named as separate work.
> `fw-move.sh` correctly gets **no type logic**. This item is re-scoped to what it truly is: the
> **mechanism** — author the SoT, ship/derive it, and DRY every human-facing list to agree with it.
> The two enforcement-at-the-gate items below are struck and moved to FEAT-175. Two follow-ups filed:
> **FEAT-175** (deterministic `/fw-new` create gate + plugin `Build-Plugin.ps1` SoT derivation) and
> **TECH-176** (rename `FEATURE`/`TECHDEBT` templates to canonical prefixes).

> **Taxonomy revised 2026-07-08 (ADR-006 amended, 8 → 5).** A sanity-check of the type set against
> usage data + industry trackers (Jira/GitHub) reduced the canonical set from 8 to **5: FEAT, BUG,
> TECH, TASK, SPIKE.** DOCS/CHORE/REFACTOR fold into TECH; TASK reinstated (tracker-standard). Also:
> **"legacy" is now disk-derived, not authored** — any on-disk prefix not in the accepted set is
> legacy by definition (recognized, never created), so nothing legacy ships. The SoT is therefore an
> accepted-only, newline-delimited **`work-item-types.txt`** (not the earlier TAB `.tsv`). The AC/
> checklist text below that still says "8" or ".tsv" reflects the mid-implementation state; the
> **shipped result is the 5-type / disk-derived / `.txt` model.** See ADR-006's 2026-07-08 amendment.

---

## Problem Statement

**What is the current state?** (verified 2026-07-06)

"Valid types" is stated in at least three places, and they **do not match**:

| Source | Types listed | Count |
|---|---|---|
| `workflow-guide.md` line 1120 "Work Item Types (5 total)" | FEAT, BUG, TECH, DECISION, SPIKE | 5 |
| `workflow-guide.md` ID-namespace prose (lines 976, 1033, 1058) | + POLICY | 6 |
| `framework/tools/FrameworkWorkflow.psm1` `$validPrefixes` (line 197) | + POLICY, + BUGFIX | 7 |

None of these is enforced against the others; there is no single source of truth. A stray or
retired type is caught only by chance.

**Why is this a problem?**

- **Type drift is invisible.** A new prefix can appear in one list and not others; a retired one
  (DECISION, per TECH-172) can linger. This is the exact failure the user wants closed so the
  framework is stable enough to use across multiple projects.
- **No creation-time guardrail.** Nothing stops an item being created with an off-list type.

**The core distinction — authoring mode vs. historical-reference mode:**

Every type-aware policy, template, or script operates in one of two modes, and must use the
matching list:

- **Authoring mode** ("what may I create *now*?") → the **accepted** set (enforced, narrow).
  Consumers: plugin `new` flow, work-item templates, `/fw-next-id`, "choose a type" doc tables.
  Proposed accepted set: **FEAT, BUG, TECH, SPIKE, POLICY** (final list decided during
  implementation; DECISION is being retired by TECH-172).
- **Historical-reference mode** ("what must I *parse/understand*?") → the **recognized** superset
  (accepted + legacy). Consumers: `move.sh` validation, `FrameworkWorkflow.psm1` parsing,
  `Get-BacklogItems`, `/fw-status`, `/fw-session-history`, ID-collision scans. Includes legacy
  **DECISION** (retired by TECH-172) and **BUGFIX** (deliberate past rename to BUG — legacy items
  exist).

⚠️ **Both lists are required, and each artifact must use the one matching its mode.** If a
reference-mode consumer used the narrow accepted list, every archived `DECISION-0xx` and
`BUGFIX-0xx` item would fail the moment the switch flips. Conversely, if an authoring-mode consumer
used the recognized superset, retired types would become creatable again — re-opening the drift.
`BUGFIX → BUG` is the worked example: `BUG` is accepted (authoring); `BUGFIX` is
recognized-only (reference).

**Single source of truth — a machine-readable type master (mirrors `project.type`).**

The framework already has a machine-readable master for **project types** — `project.type` is an
`enum` with described `values:` in `framework/docs/ref/framework-schema.yaml` (declared the
"single source of truth for valid values", line 3). **There is no equivalent for work-item types**
(verified 2026-07-06). Add one, in the same file and shape, so the accepted/recognized sets live in
**one machine-readable place** and every other artifact references it instead of restating it:

```yaml
work_item.type:
  type: enum
  required: true
  description: "Single source of truth for valid work-item types"
  values:
    FEAT:     { status: accepted, description: "New capability or enhancement" }
    BUG:      { status: accepted, description: "Defect fix" }
    TECH:     { status: accepted, description: "Internal improvement / tech debt" }
    SPIKE:    { status: accepted, description: "Time-boxed research" }
    POLICY:   { status: accepted, description: "..." }        # confirm inclusion during impl
    DECISION: { status: legacy,   description: "Retired (recorded as ADR). Recognized for parsing only" }
    BUGFIX:   { status: legacy,   description: "Renamed to BUG. Recognized for parsing only" }
```

The `status: accepted | legacy` field **is** the authoring-vs-reference distinction made
machine-readable: **accepted** = the authoring set; **accepted + legacy** = the recognized superset.
Adding or retiring a type becomes a **one-field edit** in this master.

**What is the desired state?**

- **One machine-readable master** (`work_item.type` in `framework-schema.yaml`) with per-type
  `status`; mirrors the existing `project.type` pattern.
- **DRY:** every human-facing "valid types" list (workflow-guide table, plugin docs, `.psm1`
  comments) **points to the master** rather than restating the set — no independent copies to drift.
- Creation-time enforcement rejects non-`accepted` types (with a helpful message).
- Parsing/validation uses the full recognized set (accepted + legacy).
- Adding or retiring a type is a **one-place edit** the rest of the framework follows.

---

## Scope

**In scope:**
- **Add the `work_item.type` master** to `framework/docs/ref/framework-schema.yaml` (mirroring
  `project.type`), with per-type `status: accepted | legacy` — the single source of truth.
- Enforce **accepted** types at item creation (plugin `new` flow + any create path); reject
  non-accepted with a helpful message.
- Use the **recognized superset** (accepted + legacy) for parsing/validation of existing items
  (`move.sh`, `FrameworkWorkflow.psm1`, status/history/collision scans).
- **DRY the human-facing lists:** workflow-guide "5 total" table, ID-namespace prose, `.psm1`
  comments, plugin docs → **reference the master**, not their own copies.
- Classify `BUGFIX` and `DECISION` as `legacy` in the master (recognized, not accepted).

**Out of scope:**
- Retiring DECISION from user-facing docs/templates/plugins — that's **TECH-172** (content
  cleanup). This item is the **mechanism**; TECH-172 is a consumer of it.
- Renaming/rewriting any existing item.
- Deciding the substance of open decision items — TECH-172 handles their disposition.

---

## Acceptance Criteria (per ADR-006)

- [x] **The authored SoT file exists** — a flat, TAB-delimited `name<TAB>status[<TAB>alias-target]`
      file (ADR-006 D5) with the canonical 8 (`accepted`) and legacy aliases (`legacy`), `#` comments
      allowed. **Shipped at `.claude/scripts/work-item-types.tsv`** beside the engine (D4)
- [x] **Canonical accepted set = FEAT, BUG, TECH, DOCS, CHORE, REFACTOR, TASK, SPIKE** (D1); POLICY
      dropped; DECISION not accepted
- [x] **Legacy aliases recognized-for-parsing, never offered** (D2): FEATURE→FEAT, BUGFIX→BUG,
      DOC→DOCS, TECHDEBT→TECH, DECISION→ADR. *(Note: DECISION→ADR is a retirement pointer, not a
      normalization rename — ADR is a separate document series, so the psm1 ID-normalizer recognizes
      DECISION but does not rewrite it. Same-namespace renames do normalize.)*
- [x] **Build derives, no hand-sync** (D4) — **full-framework scope:** `Build-FrameworkArchive.ps1`
      ships the SoT (Step 1.6b) and the full framework reads it directly. **Plugin derivation
      (`Build-Plugin.ps1`) deferred to FEAT-175** — the plugin had no *consumer* of the TSV until the
      `/fw-new` gate exists, so shipping it into plugins now would be inert plumbing ahead of its use.
- [ ] ~~**Deterministic enforcement at the mechanical gate** (D6)~~ — **MOVED to FEAT-175.**
      Enforcement belongs at **creation** (`/fw-new`), not move; `fw-move.sh` correctly gets no type
      logic. See the 2026-07-08 re-scope note above.
- [x] **Reference-mode parsing uses the full recognized set** — **verified live:** `fw-move.sh`
      moved a real `BUGFIX-045` end-to-end; the psm1 recognizes all 5 legacy prefixes and normalizes
      correctly (`DECISION-042` stays `DECISION-042`); next-ID scan returns 175 across real items.
- [x] **DRY the human-facing lists** — workflow-guide type table + ID-namespace prose + collision-scan
      glob, `.psm1` (`$validPrefixes` + alias switch now **read the SoT**, fixing a latent
      incomplete-list bug), plugin `new.md` + `skills/work-items.md` + light `README` all reconciled
      to the canonical 8 / point at the SoT. No independent creatable-type lists remain.
- [x] **Schema left as-is** (D7) — no `work_item.type` enum added to `framework-schema.yaml`
- [x] CHANGELOG.md updated

**Added during implementation (types↔templates must match, per user direction 2026-07-08):**
- [x] Templates synced to the accepted 5: created `TASK-TEMPLATE.md`; SPIKE/FEATURE/BUG/TECHDEBT
      kept. *(DOCS/CHORE/REFACTOR templates were created then removed when the set was cut to 5 —
      those types fold into TECH.)*
- [x] Deleted the retired `DECISION-TEMPLATE.md` (decisions → ADR templates in `templates/decisions/`)
- [ ] ~~Rename `FEATURE`/`TECHDEBT` templates to canonical prefixes~~ — **MOVED to TECH-176**
      (40+ live references; kept separate to avoid tangling a mechanical rename with taxonomy work).

---

## Implementation Checklist (per ADR-006)

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->
<!-- User can say "continue to completion" to approve remaining steps at once. -->

- [x] **PRE-IMPLEMENTATION REVIEW COMPLETED** — reviewed 2026-07-08; scope corrected to
      create-not-move (see re-scope note); user approved step-by-step.
- [x] Author the SoT file (flat TAB-delimited; canonical 8 + legacy aliases; `#` header)
- [ ] ~~Wire deterministic enforcement in the create/move engine~~ — **MOVED to FEAT-175**
      (enforcement is at creation, not move; `fw-move.sh` gets no type logic).
- [x] Ship the SoT via `Build-FrameworkArchive.ps1` (Step 1.6b) — verified in the built zip.
      *(Plugin `Build-Plugin.ps1` derivation deferred to FEAT-175 — no plugin consumer yet.)*
- [x] Confirm reference-mode parsing reads the full recognized set (accepted + legacy) — psm1 reads
      the SoT; verified live.
- [x] Re-point the human-facing lists at the SoT (workflow-guide table + prose + glob, `.psm1`
      `$validPrefixes`/alias switch, plugin `new.md` + skill + light README) — DRY, no restated lists.
- [x] Sync templates to the accepted set (add `TASK-TEMPLATE.md`) + delete retired
      `DECISION-TEMPLATE.md` (types↔templates match). *(Final set = 5; see 2026-07-08 note.)*
- [x] Verify legacy `DECISION-0xx` and `BUGFIX-0xx` items still parse — done end-to-end.
- [x] File follow-ups: FEAT-175 (`/fw-new` gate + plugin derivation), TECH-176 (template rename).
- [x] CHANGELOG.md updated

---

<!-- ══════════════════════════════════════════════════════════════════════════════ -->
<!-- SUPERSEDED SPEC (retained for provenance) — the original "add a YAML enum" plan. -->
<!-- ADR-006 (Accepted 2026-07-07) replaced this with a flat TAB file + build-derivation. -->
<!-- Do NOT implement the sections below; they are the pre-ADR framing. -->
<!-- ══════════════════════════════════════════════════════════════════════════════ -->

### (Superseded) Original Acceptance Criteria

- [ ] ~~A `work_item.type` master exists in `framework-schema.yaml` (mirrors `project.type`)~~ →
      ADR-006 D7 keeps the schema as-is; the SoT is a flat file instead.
- [ ] ~~Human-facing sources reference the YAML master~~ → now reference the flat SoT.

*(Full original text preserved in git history at commit `13e70c3` / `accc1a3`.)*

---

## Related

- **ADR-006** (Accepted 2026-07-07) — **the decision this item implements.** Defines the canonical 8,
  the legacy alias map, the flat TAB-delimited SoT, build-derivation across channels, and
  deterministic enforcement. This item is the build; the ADR is the record.
- **TECH-172** — retires the `DECISION-*` type in docs/templates/plugins; **depends on this item's
  two-list model** so retired DECISION stays parseable. 172 = content; 173 = mechanism. Can be
  sequenced 173→172 or run together.
- **BUGFIX → BUG** — a prior deliberate type rename; the canonical example of a
  recognized-but-not-accepted (legacy) prefix.
- **DECISION-042** — defined the shared work-item ID namespace.
- Command-tier drift cluster (DECISION-162, TECH-169) — same class of "one concept, many
  out-of-sync copies" problem this enforcement prevents.

---

**Last Updated:** 2026-07-07 (re-scoped to implement ADR-006)

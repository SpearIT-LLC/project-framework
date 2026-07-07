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

The framework's set of "valid work-item types" is **defined in multiple places that disagree**,
and nothing *enforces* a single canonical list — so new types (or retired ones) drift in and out
undetected. Make the type schema **self-defending**: one canonical **accepted-for-creation** list,
enforced at item creation, plus a separate **recognized-for-parsing** superset that still accepts
legacy prefixes so historical items never fail validation. This closes type-drift structurally
(not just for today's cases) and is the mechanism that makes TECH-172's DECISION retirement stick.

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

## Acceptance Criteria

- [ ] A `work_item.type` master exists in `framework-schema.yaml` (mirrors `project.type`), each
      type carrying `status: accepted | legacy` — the single source of truth
- [ ] `DECISION` and `BUGFIX` are present as `status: legacy` (recognized, not accepted)
- [ ] **Authoring-mode** consumers (create paths, `new` flow, templates, `/fw-next-id`) offer only
      `accepted` types and **reject** a non-accepted type with an actionable message
- [ ] **Reference-mode** consumers (`move.sh`, `.psm1`, status/history/collision scans) parse the
      full recognized set — verified: real archived `DECISION-0xx` **and** `BUGFIX-0xx` items still
      validate
- [ ] The disagreeing human-facing sources (workflow-guide "5 total" table, ID-namespace prose,
      `.psm1` comments, plugin docs) **reference the master** instead of restating it (DRY — no
      independent copies remain)
- [ ] CHANGELOG.md updated

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->
<!-- User can say "continue to completion" to approve remaining steps at once. -->

- [ ] **PRE-IMPLEMENTATION REVIEW COMPLETED** — AI presents: final accepted set, legacy set,
      the `work_item.type` master shape, which consumers are authoring- vs reference-mode, and the
      enforcement point(s); user approves
- [ ] Add the `work_item.type` master to `framework-schema.yaml` (per-type `status`)
- [ ] Wire authoring-mode enforcement (create paths reject non-accepted; helpful message)
- [ ] Confirm reference-mode consumers read the full recognized set
- [ ] Point the human-facing lists at the master (stop restating — DRY)
- [ ] Verify legacy `DECISION-0xx` and `BUGFIX-0xx` items still parse
- [ ] CHANGELOG.md updated

---

## Related

- **TECH-172** — retires the `DECISION-*` type in docs/templates/plugins; **depends on this item's
  two-list model** so retired DECISION stays parseable. 172 = content; 173 = mechanism. Can be
  sequenced 173→172 or run together.
- **BUGFIX → BUG** — a prior deliberate type rename; the canonical example of a
  recognized-but-not-accepted (legacy) prefix.
- **DECISION-042** — defined the shared work-item ID namespace.
- Command-tier drift cluster (DECISION-162, TECH-169) — same class of "one concept, many
  out-of-sync copies" problem this enforcement prevents.

---

**Last Updated:** 2026-07-06

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

**The two-list distinction (the core of the fix):**

- **Accepted for creation** (enforced, narrow) — the types a user/AI may create *today*.
  Proposed: **FEAT, BUG, TECH, SPIKE, POLICY** (final list decided during implementation; note
  DECISION is being retired by TECH-172).
- **Recognized for parsing** (superset, includes legacy) — every prefix that must still
  parse/validate for historical items, even though it's no longer creatable. Includes **DECISION**
  (retired by TECH-172) and **BUGFIX** (a deliberate past rename to BUG — legacy items exist).

⚠️ **Both lists are required.** If enforcement used only the narrow list for *parsing*, every
archived `DECISION-0xx` and `BUGFIX-0xx` item would fail validation the moment the switch flips.
`BUGFIX → BUG` is the worked example: `BUG` is accepted-for-creation; `BUGFIX` is
recognized-for-parsing only.

**What is the desired state?**

- A single canonical **accepted-types** list, referenced everywhere (docs generated from / pointed
  at it, not re-typed by hand).
- Creation-time enforcement rejects off-list types (with a helpful message).
- A **recognized-types** superset used for parsing/validation of existing items.
- Adding or retiring a type is a **one-place edit** that the rest of the framework follows.

---

## Scope

**In scope:**
- Define the canonical accepted-types list and the recognized-for-parsing superset (single source
  of truth — likely in `FrameworkWorkflow.psm1` and/or a small ref doc; decide during
  implementation).
- Enforce accepted-types at item creation (plugin `new` flow + any create path).
- Reconcile the disagreeing lists (workflow-guide "5 total" table, ID-namespace prose, `.psm1`)
  to reference the canonical source rather than restating it.
- Include `BUGFIX` and `DECISION` in the recognized superset (legacy), NOT in accepted.

**Out of scope:**
- Retiring DECISION from user-facing docs/templates/plugins — that's **TECH-172** (content
  cleanup). This item is the **mechanism**; TECH-172 is a consumer of it.
- Renaming/rewriting any existing item.
- Deciding the substance of open decision items — TECH-172 handles their disposition.

---

## Acceptance Criteria

- [ ] A single canonical **accepted-types** list exists; all human-facing "valid types" lists point
      to it or are generated from it (no independent restatements that can drift)
- [ ] A **recognized-for-parsing** superset exists that includes legacy `DECISION` and `BUGFIX`
- [ ] Item creation **rejects** an off-accepted-list type with an actionable message
- [ ] Existing archived items with legacy prefixes (`DECISION-0xx`, `BUGFIX-0xx`) still
      parse/validate — verified against a real archived item of each
- [ ] The three disagreeing sources (workflow-guide table, ID-namespace prose, `.psm1`) now agree
      (same accepted set), via reference to the canonical source
- [ ] CHANGELOG.md updated

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->
<!-- User can say "continue to completion" to approve remaining steps at once. -->

- [ ] **PRE-IMPLEMENTATION REVIEW COMPLETED** — AI presents: final accepted list, recognized
      superset, where the canonical source lives, enforcement point(s); user approves
- [ ] Define canonical accepted list + recognized superset in one place
- [ ] Wire creation-time enforcement (reject off-list; helpful message)
- [ ] Point the human-facing lists at the canonical source (stop restating)
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

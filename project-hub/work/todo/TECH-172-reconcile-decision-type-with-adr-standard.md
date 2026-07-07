# Tech Debt: Reconcile the `DECISION-*` Work-Item Type onto the Industry-Standard ADR Model

**ID:** TECH-172
**Type:** Tech Debt
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-07-06
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->
**Theme:** Framework Consistency

---

## Summary

The framework has **two overlapping concepts for the same thing**: industry-standard **ADRs**
(`project-hub/research/adr/`, `ADR-NNN`, compliant) *and* a bespoke **`DECISION-*` work-item
type** (`DECISION-NNN`, flows the kanban board). Industry standard has **one** concept — an ADR
*is* a decision record — so `DECISION-*` is a non-standard invention that duplicates ADRs and is
the direct source of recurring "which do I use?" confusion. This item **retires `DECISION-*` as a
distinct work-item type** and standardizes on: *the decision record is an ADR; if the act of
deciding needs tracking, use an ordinary work item (SPIKE/TASK) whose deliverable is an ADR.*

---

## Problem Statement

**What is the current state?** (all verified 2026-07-06)

The framework documents ADRs **correctly and compliantly**, then separately grew a `DECISION-*`
work-item type that the ADR documentation never mentions or reconciles:

- `framework/docs/collaboration/workflow-guide.md` **line 1127** defines the Decision type's
  Purpose as literally **"ADR / design choice"** — the docs equate the two in writing.
- The same guide's **§ADR (lines 1881+)** is a textbook-compliant ADR spec (when-to-create,
  MAJOR/MINOR, `research/adr/`, sequential numbering, supersede-don't-edit) that makes **zero
  mention** of the `DECISION-*` work item. The two sections don't reference each other.
- **No guidance anywhere** tells a user when to file a `DECISION-*` work item vs. write an ADR.
- `framework/docs/ref/GLOSSARY.md` line 13 defines ADR but points to `project-hub/decisions/` —
  **a path that does not exist** (ADRs live in `project-hub/research/adr/`). Stale/broken.
- The oldest decision item, `DECISION-042`, self-labels `Type: Decision (Architectural)` — an
  ADR by another name.

**When & why did `DECISION-*` appear?** (git-traced)

- `DECISION-TEMPLATE.md` was introduced **2026-01-20** under **TECH-064** ("Standardize work item
  metadata templates") — it arrived as part of a *template-standardization sweep* ("every type
  gets a matching template"), **not** as a reasoned decision to create a second decision concept
  distinct from ADRs. The overlap is an accident of standardization, never a deliberate design.

**Why is this a problem?**

- **Two names for one industry concept** → perpetual ambiguity (this very session spent
  significant time trying to distinguish them by "scope" and "artifact-vs-work" — axes that don't
  actually separate them, because the data has global `DECISION`s (050) and narrow `ADR`s (004)).
- **Non-compliance with the ADR standard** (Nygard / MADR / ThoughtWorks): the record *is* the
  decision; there is no separate "DECISION" artifact type in the standard.
- **Duplication of templates** (DECISION-TEMPLATE vs ADR-MAJOR/MINOR) that must be kept in sync.

**What is the desired state?**

One model, standards-compliant:
- **The decision record is an ADR** in `project-hub/research/adr/` (`ADR-NNN`). This is already
  correct and stays.
- **If the *act of deciding* needs board-tracking** (evaluation is real work), use an ordinary
  work item (SPIKE for time-boxed investigation, or TASK/TECH) **whose deliverable is an ADR** —
  the work item flows and closes; the ADR is the lasting record.
- **`DECISION-*` is retired as an offered type.** The `DECISION-` *prefix stays valid* in tooling
  for backward-compatibility with already-archived `DECISION-0xx` records (do not rewrite history).

---

## Scope

**In scope — forward-looking reconciliation:**
- Retire `DECISION-*` from all **user-facing "choose a type" lists** and type tables.
- Add the standardized rule (ADR is the record; track with a work item if needed) to the ADR
  section of the workflow-guide.
- Fix the stale GLOSSARY ADR path.
- Convert this session's **DECISION-171** into an ADR (the **next available ADR number** —
  allocated at implementation time, never hard-coded here) as the first case under the new rule.
- **Disposition the existing OPEN `DECISION-*` items** (see the three-bucket plan below).
- Record the decision itself as an **ADR** (dogfooding — see Plan step 1).

### Existing `DECISION-*` items — three buckets (verified against folders 2026-07-06)

A flat "leave all `DECISION-0xx` alone" rule is **wrong**: several `DECISION-*` items are not
history — they are **live, undecided items still in `backlog/`**. Handle by bucket:

| Bucket | Items (verified location) | Disposition |
|---|---|---|
| **Archived / released** | 037, 042, 050, 097, 105 (`history/releases/…`) | **Leave untouched** — true historical record. |
| **Cancelled** | 029 (`work/archive/`) | **Leave untouched** — already terminal. |
| **OPEN / undecided** | **035, 036, 110, 162** (`work/backlog/`) | **Must be dispositioned** — these are in-flight work, not history. For each: re-type to what it actually is (TECH/FEAT/SPIKE if it's tracked work whose deliverable is an ADR), or leave as a work item explicitly tagged "resolve as an ADR when worked." **Do NOT force-decide their substance now** — only assign each a clear handling so none falls through the reconcile. |
| **This session's** | **171** (`work/backlog/`) | → converted to an ADR (next available number). |

**Explicitly OUT of scope:**
- **Do NOT rename or rewrite archived/cancelled `DECISION-*` items** (029, 037, 042, 050, 097,
  105). They are released/terminal records; they stay as-is. The `DECISION-` prefix remains
  recognized by tooling for exactly this reason.
- **Do NOT force-decide the substance** of the open items (035, 036, 110, 162) — this cleanup only
  assigns their *type/handling*, not their outcome.
- No change to the ADR spec/templates themselves — they are already compliant.

---

## Straggler Inventory (edit targets — verified 2026-07-06)

Every location that currently offers/defines `DECISION-*` as a type. **The plan must clear all of
these** ("no stragglers"):

**Documentation:**
- [ ] `framework/docs/collaboration/workflow-guide.md`
  - line **1127** — "5 total" type table row `| Decision | DECISION-TEMPLATE.md | DECISION- | ADR / design choice |` → remove row; update "5 total" → 4
  - lines **966, 976, 1031, 1058** — DECISION in ID-namespace / prefix lists (⚠️ keep prefix
    *recognized* for legacy, but stop listing it as a *creatable* type — reword, don't just delete)
  - **§ADR (1881+)** — add the "record = ADR; track-with-a-work-item if needed" rule + a pointer
    from the type list to ADRs
- [ ] `framework/docs/ref/GLOSSARY.md` — fix ADR path `project-hub/decisions/` → `project-hub/research/adr/`; reconcile any "Decision" work-item glossary entry
- [ ] `framework/docs/collaboration/architecture-guide.md` line **71** — "templates (FEAT, BUG, TECH, DECISION, SPIKE)" → drop DECISION
- [ ] `framework/docs/REPOSITORY-STRUCTURE.md` — DECISION reference(s)
- [ ] `framework/docs/process/distribution-build-checklist.md` — DECISION reference(s)

**Templates:**
- [ ] `framework/templates/work-items/DECISION-TEMPLATE.md` — retire, OR convert to a thin
  stub that points to `ADR-MAJOR/MINOR-TEMPLATE.md` (decide during implementation)
- [ ] `templates/README.md`, `templates/starter/project-hub/work/README.md` — DECISION in type lists

**Plugin (user-facing "new item" flows):**
- [ ] `plugins/spearit-framework/commands/new.md` line **63** — "Valid types: … DECISION …" → drop
- [ ] `plugins/spearit-framework-light/commands/new.md` — same
- [ ] `plugins/spearit-framework/skills/work-items.md`, `plugins/spearit-framework-light/skills/work-items.md`, `plugins/spearit-framework-light/README.md` — DECISION references

**Tooling (⚠️ keep prefix valid; only update guidance/comments):**
- [ ] `framework/tools/FrameworkWorkflow.psm1` line **197** `$validPrefixes` — **KEEP `DECISION`**
  (legacy items must still parse); line **139** comment — annotate as legacy-recognized-only
- [ ] `framework/tools/Get-BacklogItems.ps1` line 53 — comment mentions DECISION prefix; harmless,
  update only if touched

**Changelog:**
- [ ] `framework/CHANGELOG.md` — add the reconciliation entry on release

---

## Acceptance Criteria

- [ ] An ADR exists recording the decision to standardize on ADRs and retire the `DECISION-*` type
- [ ] `DECISION-*` no longer appears as a creatable/offered type in any user-facing list, table,
  template menu, or plugin `new` flow (full straggler list above cleared)
- [ ] The workflow-guide ADR section states the rule: *record = ADR; track the act of deciding
      with a SPIKE/TASK whose deliverable is an ADR*
- [ ] GLOSSARY ADR path corrected to `project-hub/research/adr/`
- [ ] The `DECISION-` prefix remains **recognized** by tooling (archived `DECISION-0xx` items still
      parse/validate) — verified against an existing archived DECISION item
- [ ] Archived/cancelled `DECISION-*` records (029, 037, 042, 050, 097, 105) are untouched
- [ ] **No OPEN `DECISION-*` items remain in the work folders** — each of 035, 036, 110, 162 is
      re-typed, converted, or explicitly dispositioned (tagged "resolve as ADR when worked"); their
      substance is NOT force-decided
- [ ] DECISION-171 is converted to an ADR (next available number) or a clear disposition recorded
- [ ] CHANGELOG.md updated

---

## Implementation Cautions (verified 2026-07-06 — read before editing)

- **Line numbers WILL drift.** The Straggler Inventory cites line numbers as of 2026-07-06, but
  editing the workflow-guide top-down (and removing a table row early) shifts every later line.
  **Locate each edit by content/anchor, not by line number** — or edit bottom-up. (Line 1031→1033
  already drifted this session; treat all cited numbers as hints, not addresses.)
- **"decision" is an overloaded word — scope edits to the TYPE only.** Edit only the work-item type
  `DECISION-` / `DECISION-TEMPLATE`. **Do NOT touch:** the `/fw-swarm decision` mode, "decisions
  made" in session-history templates/prose, or ADR body text that uses the word "decision". A blind
  grep-and-replace on "decision" will corrupt these.
- **Enforcement mechanism is TECH-173, not here.** This item retires DECISION in *content*;
  TECH-173 builds the accepted-type allowlist that makes retirement stick and keeps legacy prefixes
  parseable. Retiring DECISION here relies on TECH-173's recognized-for-parsing superset.
- **Verified safe (no action needed):** `.claude/scripts/fw-move.sh` does not hard-code DECISION;
  plugins ship no DECISION *template* file (prose only); `framework-schema.yaml` has no enforced
  type enum.

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->
<!-- User can say "continue to completion" to approve remaining steps at once. -->

- [ ] **PRE-IMPLEMENTATION REVIEW COMPLETED** — AI presents the reconciliation approach + full
      straggler list; user approves before edits
- [ ] Write the ADR (allocate the next available ADR number at this step — do NOT assume a number)
      that records this standardization decision + converts DECISION-171 content into it
- [ ] Disposition the OPEN `DECISION-*` items (035, 036, 110, 162): review each, assign a
      type/handling (re-type to TECH/FEAT/SPIKE, or tag "resolve as ADR when worked") — do NOT
      force-decide their substance
- [ ] Edit documentation stragglers (workflow-guide type table + ADR section + ID lists, GLOSSARY
      path, architecture-guide, REPOSITORY-STRUCTURE, distribution-build-checklist)
- [ ] Retire/stub `DECISION-TEMPLATE.md`
- [ ] Edit template + plugin type lists (templates READMEs, both `new.md`, work-items skills)
- [ ] Annotate tooling (keep `DECISION` prefix valid; mark legacy-only in comments)
- [ ] Re-run the straggler grep to prove zero remaining *creatable-type* references
- [ ] Verify an archived `DECISION-0xx` item still parses via the tooling
- [ ] CHANGELOG.md updated

---

## Related

- **DECISION-171** (this session) — the item that surfaced the overlap; becomes an ADR (next
  available number), the first case handled under the new rule. (Its subject — the `fw-` namespace
  convention — is independent of this cleanup and carries over intact.)
- **BUG-170** — blocked-behind-context only; the `fw-` decision it depends on lives in
  DECISION-171 (→ its ADR). This cleanup should land before or alongside so BUG-170 cites the ADR.
- **TECH-173** (this session) — enforce accepted work-item types (canonical allowlist + legacy
  recognized superset). The mechanism this content-cleanup depends on so retired DECISION (and
  legacy BUGFIX) stay parseable.
- **TECH-064** (v-history) — introduced `DECISION-TEMPLATE.md` in the standardization sweep that
  created the overlap.
- **DECISION-042** — defined the shared work-item ID namespace (why the `DECISION-` prefix must
  stay recognized); self-labeled "Decision (Architectural)".
- **ADR standard** — Nygard (2011), MADR, ThoughtWorks Tech Radar: the record *is* the decision;
  no separate "DECISION" artifact type exists in the standard.
- Command-tier drift cluster (DECISION-162 → itself an example of the pattern, TECH-169) —
  reducing type sprawl reduces future drift.

---

**Last Updated:** 2026-07-06

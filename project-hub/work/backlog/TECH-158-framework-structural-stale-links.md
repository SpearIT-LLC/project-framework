# Tech Debt: Structurally-Stale Internal Links in framework/INDEX.md and Reference Docs

**ID:** TECH-158
**Type:** Tech Debt
**Priority:** Low
**Version Impact:** PATCH
**Created:** 2026-06-25
**Theme:** Distribution Hygiene

---

## Summary

Beyond the 13 links fixed in TECH-155, a link-walk over an integrated framework distribution surfaced additional broken internal links that assume an **obsolete folder structure** — chiefly `framework/INDEX.md` (33 links to a `templates/standard/project-hub/framework/...` layout that no longer exists) plus a handful of stale paths in non-template reference docs. Same root cause as TECH-106's incomplete `standard → starter` rename. These were NOT part of TECH-155's reported scope and are tracked separately here.

---

## Problem Statement

**What is the current state?**

During TECH-155 verification (2026-06-25), an integrated link-walk (`Setup-Framework.ps1` into a throwaway project, then walk `framework/**`) reported ~169 broken links. Triage classified them:

- **~155 — intended template placeholder links** in `framework/templates/` (INDEX-TEMPLATE, CLAUDE-TEMPLATE, quick-start/research templates). A consuming project resolves these when it copies the template. **NOT defects — out of scope.**
- **~4 — link-walker false positives**: `framework/CLAUDE.md` → root files (`PROJECT-STATUS.md`, `CHANGELOG.md`, `README.md`, `INDEX.md`) that DO exist at the integrated project root; the walker wrongly resolves them relative to `framework/`. **NOT broken in reality — do NOT "fix".**
- **The genuine debt (this item):** structurally-stale links in reference content, in two clusters below.

### Cluster 1 — `framework/INDEX.md` (33 links)

`framework/INDEX.md` contains 33 links to `templates/standard/...` paths, many assuming a `templates/standard/project-hub/framework/templates/...` nesting that **does not exist anywhere** (real location is e.g. `framework/templates/work-items/FEATURE-TEMPLATE.md`). This is not a simple folder rename — a mechanical `standard → starter` swap would still leave them broken because the deeper structure changed.

**Mitigating fact:** `framework/INDEX.md` is **NOT bundled** into the distribution (verified — absent from the v5.4.0 bundle). So these 33 links do **not** appear in a consuming project's `framework/` link-walk. This is framework-developer-facing debt, not consumer-facing distribution debt — hence Low priority.

Last meaningfully edited 2026-02-04 (TECH-106 "unified framework positioning"), before the structure settled.

### Cluster 2 — non-template reference docs (small set)

A handful of genuinely stale paths in bundled reference docs, e.g.:
- `framework/docs/collaboration/workflow-guide.md` → `../../framework/process/version-control-workflow.md` — missing `docs/` segment (should resolve under `framework/docs/process/`).
- `framework/docs/process/distribution-build-checklist.md` → `../docs/PROJECT-STRUCTURE.md` (lines 21, 275) — wrong relative depth.
- Additional stale paths surfaced in `version-control-workflow.md`, `documentation-dry-principles.md`, `REPOSITORY-STRUCTURE.md`, `GLOSSARY.md` (exact set to be re-derived during implementation; see verification artifact).

**Note:** Each candidate in Cluster 2 must be re-verified at implementation time and classified as FIX-PATH (target ships, path wrong) vs REMOVE (target genuinely not bundled) vs walker-false-positive — same discipline as TECH-155's disposition.

**Why is this a problem?**

- Cluster 1: noise for framework developers navigating `framework/INDEX.md`; misleads readers (and AI) toward a structure that no longer exists.
- Cluster 2: these ARE in the distributed reference docs, so they reach consumers — a stricter consumer link-walk could flag them. Lower volume than TECH-155's 13 but same nature.

**What is the desired state?**

- `framework/INDEX.md` links resolve to the current structure (or INDEX is regenerated/retired if redundant).
- Non-template reference docs in the distribution have zero genuinely-broken internal links (excluding intended template placeholders and known root-file walker false-positives).

---

## Proposed Solution

Per cluster, classify each link then FIX-PATH / REMOVE / convert-to-in-text (TECH-155 method):

- **Cluster 1 (`framework/INDEX.md`):** Likely remap paths to the current structure. Consider whether INDEX.md should be hand-maintained at all vs. generated, given it drifted — but that's a design aside, not required here.
- **Cluster 2 (reference docs):** Re-derive the exact list via integrated link-walk, classify, and fix-path or remove case by case.

**Verification:** Reuse the Link Integrity Gate added by TECH-155 (`framework/docs/process/distribution-build-checklist.md`, Post-Build Validation §2) — integrated walk over `framework/**` excluding `framework/templates/`, ignoring known root-file false positives.

**Files Affected:**
- `framework/INDEX.md` — Cluster 1 (33 links)
- `framework/docs/collaboration/workflow-guide.md` — Cluster 2
- `framework/docs/process/distribution-build-checklist.md` — Cluster 2
- `framework/docs/process/version-control-workflow.md` — Cluster 2 (verify)
- `framework/docs/collaboration/documentation-dry-principles.md` — Cluster 2 (verify)
- `framework/docs/REPOSITORY-STRUCTURE.md`, `framework/docs/ref/GLOSSARY.md` — Cluster 2 (verify)

---

## Acceptance Criteria

- [ ] `framework/INDEX.md` links resolve to the current structure (or INDEX retired/regenerated)
- [ ] Cluster 2 reference-doc stale links re-derived, classified, and resolved (fix-path/remove/in-text)
- [ ] Integrated link-walk over `framework/**` (excluding `framework/templates/`, ignoring known root-file false positives) reports zero genuine broken links
- [ ] Walker false-positives (root files) documented as expected, not "fixed"
- [ ] CHANGELOG.md updated

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->
<!-- User can say "continue to completion" to approve remaining steps at once. -->

- [ ] **PRE-IMPLEMENTATION REVIEW COMPLETED**
  - AI presents: re-derived link list per cluster, per-link classification, scope
  - User explicitly approves before proceeding

- [ ] Re-derive exact broken-link set via integrated link-walk (don't trust the indicative list above verbatim)
- [ ] Resolve Cluster 1 (`framework/INDEX.md`)
- [ ] Resolve Cluster 2 (reference docs)
- [ ] Re-run integrated link-walk to confirm zero genuine broken links
- [ ] CHANGELOG.md updated

---

## Notes

- Discovered 2026-06-25 during TECH-155's integration test. TECH-155 was deliberately held to its documented 13; this item captures the remainder so nothing is silently swept in or lost.
- The indicative link lists in this item are from a crude walker and include false positives; **re-derive and re-classify at implementation time** rather than fixing the list as-is.
- Root cause shared with TECH-106 (incomplete `standard → starter` rename, 2026-02-04).

---

## Related

- **TECH-155** (13 broken distribution links) — sibling; established the disposition method + Link Integrity Gate. See its artifact `project-hub/work/done/TECH-155/link-disposition.md`.
- **TECH-106** — unified framework positioning; origin of the `standard → starter` rename that left these paths stale.
- **TECH-156** — distribution & GitHub sync gaps; its build-doc `templates/standard/` PowerShell *command examples* (stale build instructions, not links) are related but tracked under TECH-156's build-process scope.

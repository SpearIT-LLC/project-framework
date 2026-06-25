# Feature: Framework Provenance Stamp in Distribution

**ID:** FEAT-157
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-06-25
**Theme:** Distribution & Onboarding

---

## Summary

Stamp **provenance** into every framework distribution — source repository, version, and integration date — so a consuming project knows *where its framework came from*, not just *what version it is*. Today the distribution records only a bare version string (`.framework-version` = `5.4.0`) with no back-link to the source. This is the small, high-leverage prerequisite for any future update-awareness tooling.

---

## Problem Statement

**What is the current state?**

Verified 2026-06-25 against a freshly built v5.4.0 bundle and an integrated test project:

- `framework/.framework-version` contains exactly `5.4.0` — a bare version, nothing else.
- A consuming project's `framework.yaml` has **no** `framework:` provenance block (no `source`, `repository`, `lastUpdated`, or `customizedFiles`).
- The distribution is therefore **fire-and-forget**: a project knows its framework version but has no recorded pointer to the upstream source (this repo: `https://github.com/SpearIT-LLC/project-framework`).

**Why is this a problem?**

- **No origin:** Projects (and AI agents working in them) cannot determine where their framework came from, how to get updates, or how to report issues upstream.
- **No basis for staleness checks:** Any future "am I behind?" capability (`Update-Framework.ps1 -Check`) needs a source URL + version baseline to compare against. Without provenance, that tooling has nothing to point at.
- **No notification path exists or is intended:** The framework cannot and does not notify consumers (no project knows about any other; this repo holds no registry of consumers). The model is pull-based self-checking — which still requires provenance to function.

This was already *designed* in **DECISION-050 Open Question Q4** (a `framework:` config block with `version` / `source` / `lastUpdated` / `customizedFiles`) but was **never implemented** — DECISION-050 shipped the build/setup/`.framework-version` pieces and deferred the provenance/update tooling.

**What is the desired state?**

After this feature, a freshly integrated project records, in a durable and discoverable place, at minimum:
- `version` — framework version integrated
- `source` — upstream repository URL
- `integratedDate` — when Setup-Framework ran (the project's first stamp)

…so the project is self-describing about its framework origin.

---

## Scope

**In scope:**
- Provenance stamping at build and/or setup time.
- A single canonical location for provenance (recommend a `framework:` block in the consuming project's `framework.yaml`, per DECISION-050 Q4 — `.framework-version` may remain as the simple machine-readable version, or be superseded).

**Explicitly OUT of scope (tracked elsewhere — do NOT build here):**
- `Update-Framework.ps1` and the `-Check` staleness comparison → deferred per DECISION-050; relates to **FEAT-008** (upgrade automation) and **FEAT-051** (update test harness).
- Customization tracking / `customizedFiles` / `<!-- CUSTOM -->` merge logic → DECISION-050 customization model.
- Any cross-project notification or consumer registry → not intended by the framework-as-dependency model.

---

## Proposed Solution

Stamp provenance in the distribution/setup flow. Two candidate insertion points (decide during pre-implementation review):

1. **Build-time** (`tools/Build-FrameworkArchive.ps1`): write `source` + `version` into the bundle (extend `.framework-version` to structured content, or add a `framework:` block to the template's `framework.yaml`). The build knows the version (from PROJECT-STATUS.md) and can hardcode/derive the source URL.
2. **Setup-time** (`templates/starter/Setup-Framework.ps1`): stamp `integratedDate` (and confirm `version`/`source`) into the new project's `framework.yaml` when the project is created — this is the natural place for the per-project integration timestamp.

Likely split: **source + version at build**, **integratedDate at setup**.

Recommended provenance shape (from DECISION-050 Q4, trimmed to in-scope fields):

```yaml
# framework.yaml (consuming project)
framework:
  version: "5.4.0"
  source: "https://github.com/SpearIT-LLC/project-framework"
  integratedDate: "2026-06-25"
```

**Files Affected:**
- `tools/Build-FrameworkArchive.ps1` — stamp source + version
- `templates/starter/Setup-Framework.ps1` — stamp integratedDate at setup
- `templates/starter/framework.yaml` (and/or `.framework-version` format) — provenance block / structured stamp
- `framework/docs/...` — document the provenance block (where consuming projects/AI should read origin)

---

## Acceptance Criteria

- [ ] A freshly built + integrated project records framework `version`, `source` (this repo URL), and `integratedDate` in a single documented location
- [ ] Provenance location is documented so a human or AI can find "where did my framework come from?"
- [ ] No regression: existing `.framework-version` consumers (if any) still work, or the change is documented
- [ ] Out-of-scope update/notification tooling is explicitly NOT introduced
- [ ] CHANGELOG.md updated

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->
<!-- User can say "continue to completion" to approve remaining steps at once. -->

- [ ] **PRE-IMPLEMENTATION REVIEW COMPLETED**
  - AI presents: chosen provenance location + field set, build-vs-setup split, source-URL derivation, downstream impact
  - User explicitly approves before proceeding

- [ ] Decide provenance location (`framework.yaml` block vs structured `.framework-version`) and field set
- [ ] Stamp source + version at build time
- [ ] Stamp integratedDate at setup time
- [ ] Document the provenance block for humans + AI
- [ ] Verify via integration test (build → Setup-Framework → inspect provenance)
- [ ] CHANGELOG.md updated

---

## Notes

- Surfaced 2026-06-25 from a user question: "none of the projects have awareness of other projects, although all of those should know the framework came from this project." Investigation confirmed provenance was designed (DECISION-050 Q4) but never built; only a bare version is stamped today.
- This is intentionally the **smallest useful slice**. The larger update mechanism (`Update-Framework.ps1`, `-Check`, test harness) remains deferred per DECISION-050 and is covered by FEAT-008 / FEAT-051.
- Provenance is a **prerequisite** for any future staleness check — worth doing first regardless of whether the larger tooling is ever built.

---

## Related

- **DECISION-050** (Framework-as-Dependency Model) — Q4 designed this provenance block; adopted v4.0.0, provenance piece never implemented. Located at `project-hub/history/releases/v4.0.0/DECISION-050-framework-distribution-model.md`.
- **FEAT-051** (Framework Update Test Harness) — backlog; validates the deferred update script.
- **FEAT-008** (Upgrade Automation) — backlog; framework-level upgrade migration.
- **TECH-156** — distribution & GitHub sync gaps (sibling distribution-hygiene item).

# Tech Debt: Framework Distribution Bundle Has 13 Broken Internal Links

**ID:** TECH-155
**Type:** Tech Debt
**Priority:** Low
**Version Impact:** PATCH
**Created:** 2026-05-21
**Completed:** 2026-06-25
**Theme:** Distribution Hygiene

---

## Summary

The distributed framework template ships `framework/CLAUDE.md` and several files under `framework/docs/` with 13 internal links that point at files not bundled into the distribution. The targets exist in this development repo (or in this repo's release history) but were not copied into the template that consuming projects receive. Reported from downstream project SpearIT-KB during a Phase 6 link-integrity audit.

---

## Problem Statement

**What is the current state?**

When the framework template is integrated into a consuming project, the consuming project inherits 13 dangling links inside its `framework/` folder. The downstream project (`SpearIT-KB`) ran a comprehensive link-walk during its FEAT-MIGRATION-001 Phase 6 verification, and these 13 links surfaced as broken — all inside `framework/`, all pointing at files that exist in this framework's own repo but were not bundled into the distributed template.

The broken links group into four categories:

### Group A — FEAT-026 work-item references (6 links)

Files in the distribution:
- `framework/docs/PROJECT-STRUCTURE.md` (2 refs)
- `framework/docs/REPOSITORY-STRUCTURE.md` (4 refs)

These cite `FEAT-026-structure-migration.md` and `FEAT-026-universal-structure-decisions.md` as authoritative context for the framework's structural decisions. The actual files exist in this framework's release history at `project-hub/history/releases/v3.0.0/` — that location is internal to this framework repo and is not (and arguably should not be) bundled into the distribution.

### Group B — `CLAUDE-QUICK-REFERENCE.md` (2 hits)

File in the distribution: `framework/CLAUDE.md` references a sibling `framework/CLAUDE-QUICK-REFERENCE.md`.

This framework repo has `framework/CLAUDE-QUICK-REFERENCE.md` at the expected path, but it isn't being bundled into the distributed template — or the link in `CLAUDE.md` predates a pattern decision that consuming projects author their own quick-reference rather than receiving one from the framework.

Downstream context (Gary, on 2026-05-12, in SpearIT-KB): *"I think the intent was a new project would generate its own quick reference guide."* If that's the settled pattern, the link in `framework/CLAUDE.md` should be removed (or rephrased as a soft pointer). If the file is meant to ship, it needs to be bundled.

### Group C — Framework's ADR-001 collision (1 hit)

File in the distribution: `framework/CLAUDE.md` line 216 references `project-hub/research/adr/001-ai-workflow-checkpoint-policy.md` as the rationale for the AI Workflow Checkpoint Policy.

This collides with consuming-project ADR numbering. In `SpearIT-KB`, ADR-001 is `001-consolidate-into-knowledge-library.md` — the project's first architectural decision. The framework's expectation of *its own* ADR-001 existing at that path cannot be satisfied without either renaming the consuming project's ADR or letting the framework's link dangle.

Suggested resolution: framework should reference its structural-decision ADR by name or by relative path into a framework-owned subfolder (e.g., `framework/decisions/...`), not via the numeric `001` slot in the consuming project's `project-hub/research/adr/`.

### Group D — Other one-off missing files (4 links)

- `framework/docs/plugin-development-guide.md` → `../../research/plugins-performance-optimization.md`
- `framework/docs/collaboration/README.md` → `../../framework/templates/` (directory)
- `framework/docs/process/distribution-build-checklist.md` → `../../templates/standard/NEW-PROJECT-CHECKLIST.md`
- `framework/docs/project/planning-model.md` → `../../project-hub/planning/design/project-guidance.md`

All four reference files that exist in this framework's source repo but weren't bundled into the distributed template.

**Why is this a problem?**

Low immediate impact — the broken links are inside `framework/` reference content. They don't block any consuming-project work. But they:

- Generate noise on any consuming project's link-walking audit
- Could mislead readers (especially AI agents) into expecting documents that aren't there
- Indicate distribution-bundle debt: the distribution should be self-consistent

**What is the desired state?**

After fix: a consuming project that pulls the latest framework distribution and runs a link-walk on its `framework/` folder sees zero broken links.

---

## Proposed Solution

For each group, choose one of:

1. **Bundle the target file into the distribution** — make the link resolve.
2. **Remove the link from the source file** — drop the reference.
3. **Convert to in-text description without an active link** — keep the context, drop the broken pointer.

**Group-by-group suggestions (the downstream report flagged these but final calls live here):**

- **Group A (FEAT-026 refs):** Probably option 3 (in-text). The work-item history is framework-internal context — describe the decision in `PROJECT-STRUCTURE.md` and `REPOSITORY-STRUCTURE.md` rather than linking out to release-history files that consuming projects don't have.
- **Group B (CLAUDE-QUICK-REFERENCE):** Option 2 (remove the link), if the settled pattern is that consuming projects author their own. Optionally replace with a comment in `framework/CLAUDE.md` explaining the expectation.
- **Group C (ADR-001):** Option 2 or 3 — replace the numeric ADR-001 reference with either a framework-owned location or an in-text description. The numeric slot in the consuming project's ADR namespace is not the framework's to claim.
- **Group D (one-offs):** Case by case. Some may be bundle candidates (`NEW-PROJECT-CHECKLIST.md`?), others are framework-development context that should be in-text or removed.

**Files Affected (in the distribution):**

- `framework/CLAUDE.md` — Group B (2 links) and Group C (1 link)
- `framework/docs/PROJECT-STRUCTURE.md` — Group A (2 links)
- `framework/docs/REPOSITORY-STRUCTURE.md` — Group A (4 links)
- `framework/docs/plugin-development-guide.md` — Group D (1 link)
- `framework/docs/collaboration/README.md` — Group D (1 link)
- `framework/docs/process/distribution-build-checklist.md` — Group D (1 link)
- `framework/docs/project/planning-model.md` — Group D (1 link)

---

## Acceptance Criteria

- [x] All 13 broken links resolved (bundled, removed, or converted to in-text descriptions per group)
- [x] A fresh distribution build, when integrated into a clean consuming project, has zero broken links inside `framework/` **for the 13 reported links** — verified via integration test (Setup-Framework + link-walk). Note: the test surfaced ~10 *additional* stale links in non-template reference docs (e.g. missing `docs/` in paths) plus the `framework/INDEX.md` cluster; these were NOT among the reported 13 and are tracked separately as **TECH-157** (same structural-staleness family as TECH-106's incomplete `standard→starter` rename).
- [x] Distribution-build checklist updated with a link-walk gate (Post-Build Validation §2, "Link Integrity Gate")

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->
<!-- User can say "continue to completion" to approve remaining steps at once. -->

- [x] **PRE-IMPLEMENTATION REVIEW COMPLETED**
  - AI presents: chosen resolution per group, scope, downstream impact
  - User explicitly approves before proceeding

- [x] Resolve Group A links (6) in `PROJECT-STRUCTURE.md` and `REPOSITORY-STRUCTURE.md`
- [x] Resolve Group B links (2) in `framework/CLAUDE.md`
- [x] Resolve Group C link (1) in `framework/CLAUDE.md`
- [x] Resolve Group D links (4) — case by case (D1/D3 removed; D2/D4 path-fixed)
- [x] Re-run link-walk locally against the distribution build to confirm zero broken links inside `framework/` (integration test: Setup-Framework + link-walk; the 13 confirmed resolved)
- [x] Update CHANGELOG.md
- [x] SpearIT-KB notification recorded as a **release-time follow-up** (see Notes → "Release-time follow-up"). The actual cross-project notify cannot be done from this repo and depends on the rebuilt bundle shipping in a release; it is carried forward rather than blocking `→ done`.

---

## Notes

The link-walk PowerShell snippet that surfaced this in SpearIT-KB is preserved in that project's session log at `project-hub/history/sessions/2026-05-12-SESSION-HISTORY.md`. It's a portable pattern any consuming project (or this framework's own CI) could adopt as a distribution-bundle gate.

The downstream work item is `SpearIT-KB/project-hub/work/backlog/TECH-001-framework-template-link-cleanup.md` (path relative to that repo). It explicitly chose *not* to patch locally so the consuming project stays aligned with the upstream template — making this upstream fix the lever to unblock that downstream cleanup.

**Release-time follow-up (carried forward from this item):** When this fix ships in a framework release and the rebuilt bundle is available to SpearIT-KB, notify that project so it can pull the new distribution and close its TECH-001. This is cross-project coordination outside this repo; it is intentionally not a `→ done` blocker for TECH-155.

---

## Related

- Downstream report: `SpearIT-KB/project-hub/work/backlog/TECH-001-framework-template-link-cleanup.md`
- Audit context: `SpearIT-KB/project-hub/history/sessions/2026-05-12-SESSION-HISTORY.md` (Phase 6 link-walk methodology)

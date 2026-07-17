# Session History: 2026-07-16

**Date:** 2026-07-16
**Participants:** Gary Elliott, Claude Code
**Session Focus:** BUG-181 pre-implementation review (ADR-007 implementation anchor)

---

## Summary

Conducted the pre-implementation review of BUG-181 (the ADR-007 implementation anchor, in `todo/`).
Plan verified sound against sources; three design decisions surfaced. Decisions 1 and 2 were settled;
Decision 3 (shells shrink) was explained in depth and Gary is absorbing it before approving — the
review is **not yet complete**. Gary also began drafting retrospective thoughts.

---

## Work Completed

### BUG-181: Starter CLAUDE.md does not deliver the framework collaboration contract

**Pre-implementation review (in progress — Decision 3 pending):**

- **Verified clean against sources:**
  - ADR-007 Accepted; D1–D7 + OQ2 form a complete fix design. OQ1 (upgrade detection) explicitly
    does not block — markers ship, upgrade tooling doesn't.
  - Drift-guard machinery exists (`Build-FrameworkArchive.ps1:113-132`); Step 5.5 confirmed
    (`:234-241`).
  - D2a precondition met: `README.md:101-109` already carries the `framework/`/`templates/`/`tools/`
    orientation, so root `CLAUDE.md` can drop "Which Project Are You Working On?" without restating.
- **Identified a gap in the plan:** ADR-007 says the contract is "composed at build time," but the
  repo's own root `CLAUDE.md` is not produced by a build — it is checked in and auto-loaded live.
  Something must write the composed region into the checked-in shells. → Decision 1.
- **Sequencing flagged:** `doing/` = WIP 1, occupied by BUG-184. Recommended finishing BUG-184 first
  so BUG-181 can `/fw-move → doing` cleanly (no `--force`) through the fixed gate.

---

## Decisions Made

1. **Decision 1 — Compose mechanism (SETTLED): manual compose script + build-time verification.**
   - New `tools/Compose-ClaudeContract.ps1` is the **only writer**: reads
     `.claude/framework-contract.md` and replaces the text between the `BEGIN/END FRAMEWORK CONTRACT`
     markers in both checked-in shells (repo root `CLAUDE.md` + `templates/starter/CLAUDE.md`).
     Insert/refresh only — touches nothing outside the markers, never creates a file.
   - **Trigger is manual:** edit fragment → run compose → commit fragment + both shells together.
     Gary chose manual over build-time auto-compose ("the file doesn't change much"); a release build
     should not mutate checked-in source, especially the live contract governing the AI running it.
   - `Build-FrameworkArchive.ps1` **verifies only**: drift-guard extension checks each shell's region
     byte-matches the fragment; hard-fails on region deleted, region hand-edited, or fragment updated
     without re-composing. Same regime as the existing three copy-fresh guards.
   - **SoT clarified:** `.claude/framework-contract.md` is the authored SoT even though the AI never
     reads it at runtime — "authored in the fragment, delivered in `CLAUDE.md`" (ADR-007 OQ2's
     compiler analogy: source vs. object code). The drift-guard is what keeps the delivered copies
     from becoming editable duplicates. `framework.yaml` deliberately does not index the fragment.

2. **Decision 2 — Version stamp in the marker (SETTLED): dropped from BUG-181's scope.**
   - Gary flagged the overlap with **FEAT-157** (framework provenance stamp — version/source/
     integratedDate in `framework.yaml`, designed in DECISION-050 Q4). Stamping a framework version
     into the contract marker would invent a second, parallel provenance mechanism ahead of
     FEAT-157's design — two stamps that can disagree.
   - Markers ship **unversioned**. The stamp only pays off for OQ1 upgrade tooling, which does not
     ship in this item anyway. Note to add to FEAT-157: the contract region marker should carry/
     reference the provenance version when that lands.

3. **Decision 3 — Shells shrink (PENDING — Gary absorbing before approving).**
   - The claim: adding the contract region is not purely additive; most of the shells' current
     content must delete because the contract now carries it (D1: no restatement) or D3 forbids it
     (summary layers).
   - Starter (82 lines): bootstrap block, Epistemic Standards, and the framework.yaml pointer move
     into the contract region; Workflow Quick Reference, Framework Documentation / Key Documents
     tables, and Project Structure **delete** (summary layers over what `framework.yaml sources:`
     and the guides own); identity (`{{PROJECT_NAME}}`, description) stays as the shell;
     Project-Specific Notes becomes the PROJECT INSTRUCTIONS region.
   - Repo root: drops "Which Project Are You Working On?" (D2a), Repository Structure, and Quick
     Reference; keeps ~15 lines of repo identity. Its Epistemic Standards + Response Style move into
     the fragment — that is the extraction step.
   - Rationale on the table: without the shrink we ship the contract *and* keep the old restatements
     beside it — two copies in one file, the disease ADR-007 treats.

---

## Retrospective Preparation

- Gary began drafting `project-hub/retrospectives/2026-07-16-garys-thoughts.md` — a fresh look at
  what the framework is: core features, guiding principles ("no implementation without a plan," DRY
  docs, aids contractors), known problems (doc duplication despite DRY; balancing deterministic vs.
  AI processes), and open questions (does it do too much? how would Anthropic approach it? is a
  clean-slate version warranted?). The "onion" cascade of issues — fixing one exposes another — is
  the presenting symptom. Doc still in progress.

---

## Files Created

- `project-hub/history/sessions/2026-07-16-SESSION-HISTORY.md` - This file
- `project-hub/retrospectives/2026-07-16-garys-thoughts.md` - Gary's retrospective prep notes (Gary-authored, in progress)

---

## Current State

### In doing/
- **BUG-184** — readiness check blocks legitimate `→ todo` moves (untouched this session; still the
  recommended next implementation before BUG-181 enters `doing/`)

### In todo/
- **BUG-181** — pre-implementation review in progress: Decisions 1–2 settled, Decision 3 pending
  Gary's approval. Once approved, update BUG-181's Implementation Checklist to reflect all three,
  then the review is complete.

### Next Session

1. Gary decides Decision 3 (shells shrink).
2. Update BUG-181's checklist with the three settled decisions → pre-implementation review complete.
3. Implement BUG-184 (frees `doing/` and fixes the gate BUG-181 must pass through).
4. Retrospective when Gary's thoughts doc is ready.

---

**Last Updated:** 2026-07-16

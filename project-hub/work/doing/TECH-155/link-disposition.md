# TECH-155 — Link Disposition (Verified)

**Investigated:** 2026-06-25
**Method:** Each link checked against (a) the source repo and (b) the actual v5.4.0 distribution bundle (`distrib/framework/spearit_framework_v5.4.0.zip`). Disposition is based on what the *consumer* receives, not what exists in this dev repo.
**Guiding principle:** DRY — one copy of each fact; fix pointers to the real location; remove pointers to things the consumer can't (and shouldn't) have.

**Resolution types:**
- **FIX-PATH** — target ships in the bundle, but the link path is stale/wrong → correct the path.
- **REMOVE** — target is not (and should not be) bundled; content is framework-internal or duplicated in-place → drop the link, keep surrounding prose.
- **IN-TEXT** — replace the link with a short in-text description (keep the context, drop the pointer).

---

## Correction to original report

- The original TECH-155 counted "13 broken internal links." Verified count of **link-bearing references** is **13**, but Group A spreads across **6 markdown links + 2 prose mentions** (the prose mentions on `PROJECT-STRUCTURE.md:702` and `REPOSITORY-STRUCTURE.md:319` are bare filenames, not `[...](...)` links — they should still be neutralized for accuracy but aren't "broken links" per se).
- Two Group D items are **stale-path bugs** (target ships, link wrong), not unbundled-target removals as the report assumed. These get FIX-PATH, which is strictly better than removal.

---

## Group A — FEAT-026 work-item references → IN-TEXT / REMOVE

**Bundle fact:** Neither `FEAT-026-structure-migration.md` nor `FEAT-026-universal-structure-decisions.md` is bundled. They live only in this repo's release history (`project-hub/history/releases/v3.0.0/`). Consumer can never resolve these.

| # | File:Line | Current | Disposition |
|---|---|---|---|
| A1 | `PROJECT-STRUCTURE.md:718` | `[FEAT-026-structure-migration.md](FEAT-026-structure-migration.md)` | REMOVE link, keep as in-text note |
| A2 | `PROJECT-STRUCTURE.md:719` | `[FEAT-026-universal-structure-decisions.md](...)` | REMOVE link, keep as in-text note |
| A3 | `REPOSITORY-STRUCTURE.md:139` | `[FEAT-026-universal-structure-decisions.md](...)` | IN-TEXT (describe DECISION-015 inline) |
| A4 | `REPOSITORY-STRUCTURE.md:321` | `[FEAT-026-structure-migration.md](...)` | REMOVE link, keep prose |
| A5 | `REPOSITORY-STRUCTURE.md:328` | `[FEAT-026-structure-migration.md](...)` | REMOVE link |
| A6 | `REPOSITORY-STRUCTURE.md:329` | `[FEAT-026-universal-structure-decisions.md](...)` | REMOVE link |

Also neutralize bare-filename prose mentions: `PROJECT-STRUCTURE.md:702, :712` and `REPOSITORY-STRUCTURE.md:319` — rephrase to describe the v3.0.0 structural decision without naming an unreachable file as if it were available.

**Rationale:** FEAT-026 is framework-internal development history. The structural *decisions* it records can be stated in-text; the consumer doesn't need (and can't reach) the work-item files. DRY: keep the decision description that's present, drop the dangling pointer.

---

## Group B — CLAUDE-QUICK-REFERENCE.md → REMOVE

**Bundle fact:** `CLAUDE-QUICK-REFERENCE.md` is NOT bundled. Settled pattern (Gary, 2026-05-12): consuming projects author their own quick-reference.

| # | File:Line | Current | Disposition |
|---|---|---|---|
| B1 | `framework/CLAUDE.md:7` | `[CLAUDE-QUICK-REFERENCE.md](CLAUDE-QUICK-REFERENCE.md)` | REMOVE link |
| B2 | `framework/CLAUDE.md:479` | `[CLAUDE-QUICK-REFERENCE.md](...)` | REMOVE link |

Note: `framework/CLAUDE.md:39` is an ASCII-tree mention inside a code block (not a link) — leave or soften; not a broken link.

**User decision:** Remove (confirmed).

---

## Group C — framework's ADR-001 reference → REMOVE

**Bundle fact:** `001-ai-workflow-checkpoint-policy.md` exists in this repo but is NOT bundled (consumer gets only `project-hub/research/adr/.gitkeep`). Link always dangles AND collides with the consuming project's own ADR-001 namespace.

| # | File:Line | Current | Disposition |
|---|---|---|---|
| C1 | `framework/CLAUDE.md:216` | `[ADR-001](project-hub/research/adr/001-ai-workflow-checkpoint-policy.md)` | REMOVE link |

**Rationale (user Q2 — "real practical reason to keep the link?"): No.** The checkpoint policy is already fully described in `framework/CLAUDE.md` lines 186–216 (the three checkpoints + core rule + why). The link points to a fuller *duplicate* the consumer can't see, in a folder the consumer owns. DRY-correct = keep the in-place description, drop the unreachable pointer. Lines 186, 410, 412 mention "ADR-001" as text (not links) — leave; they're internal labels, harmless.

---

## Group D — one-offs → 2 FIX-PATH, 2 REMOVE

| # | File:Line | Current link | Target in bundle? | Disposition |
|---|---|---|---|---|
| D1 | `plugin-development-guide.md:87` | `../../research/plugins-performance-optimization.md` | **NO** | REMOVE link, keep prose ("see performance analysis") |
| D2 | `collaboration/README.md:428` | `../../framework/templates/` | **YES** (dir ships) but **path wrong** | FIX-PATH → `../../templates/` |
| D3 | `project/planning-model.md:6` | `../../project-hub/planning/design/project-guidance.md` | **NO** | REMOVE link (keep "Related:" label as plain text or drop) |
| D4 | `process/distribution-build-checklist.md:258` | `../../templates/standard/NEW-PROJECT-CHECKLIST.md` | n/a — file ships to **project root** via Setup-Framework | FIX-PATH → `../../../templates/NEW-PROJECT-CHECKLIST.md` (correct source path; no `standard/` folder) |

**D2 detail:** README is at `framework/docs/collaboration/README.md`. `../../framework/templates/` resolves to `framework/docs/` → up 2 → repo-root-relative `framework/templates` — wrong nesting. Correct relative path to `framework/templates/` from `collaboration/` is `../../templates/`. Target dir IS bundled, so FIX-PATH resolves it.

**D4 detail:** Link path uses obsolete `templates/standard/` (now `templates/`). `NEW-PROJECT-CHECKLIST.md` exists at `templates/NEW-PROJECT-CHECKLIST.md` and Setup-Framework.ps1 copies it to the consuming **project root** (its own "Next steps" output references it root-relative, L394). Since `distribution-build-checklist.md` is a framework-DEV doc (about building the distribution), the correct pointer is to the real source path. FIX-PATH, not bundle-a-duplicate (DRY).

**D1/D3 detail:** Both targets (`plugins-performance-optimization.md`, `project-guidance.md`) exist in this repo but are NOT bundled — they're framework-internal research/planning. REMOVE the link, preserve any useful surrounding prose.

---

## Summary count

- **REMOVE:** A1–A2, A4–A6, B1, B2, C1, D1, D3 = 10 links removed (+ 3 prose mentions neutralized)
- **IN-TEXT:** A3 = 1 link converted
- **FIX-PATH:** D2, D4 = 2 links repaired

**Net:** 13 link references resolved → consumer-facing `framework/` link-walk should report zero broken internal links after rebuild.

---

## Verification gate (user Q4 — "always verify")

1. Apply edits to source files above. ✅ DONE
2. Rebuild bundle: `tools/Build-FrameworkArchive.ps1`. ✅ DONE
3. Integration test: ran `Setup-Framework.ps1` into a throwaway project, then link-walked the **integrated project's** `framework/` folder. ✅ DONE
4. Mark acceptance criteria complete. ✅

### Verification result (2026-06-25)

**The 13 documented TECH-155 links: ALL RESOLVED** — confirmed in both the rebuilt bundle and a fully integrated test project (`Setup-Framework.ps1` run headless). Zero of the 13 reported links survive.

**Root-cause fix beyond the report:** Discovered the bundle's `framework/CLAUDE.md` was NOT sourced from canonical `framework/CLAUDE.md` — it shipped a *divergent, stale duplicate* from `templates/starter/framework/CLAUDE.md`, so Group B/C edits did not initially reach the bundle. Resolved by:
- Deleting the stale duplicate `templates/starter/framework/CLAUDE.md` (`git rm`).
- Adding Step 5.5 to `Build-FrameworkArchive.ps1` to copy canonical `framework/CLAUDE.md` into the bundle.
- Principle (per Gary): the archive must copy non-unique files from their single canonical source, never maintain a duplicate.

### Scope honesty — additional findings NOT in TECH-155's 13

A crude link-walker over the integrated project reported ~169 "broken" links. Characterization:
- **~155 are in `framework/templates/` files** (INDEX-TEMPLATE 68, CLAUDE-TEMPLATE 20, quick-start/research templates). These are fill-in-the-blank **template example links** — a consuming project resolves them when it copies the template. The downstream audit correctly excluded `templates/`. NOT bugs.
- **~4 are walker false-positives** in `framework/CLAUDE.md` pointing at project-ROOT files (`PROJECT-STATUS.md`, `CHANGELOG.md`, `README.md`, `INDEX.md`) that DO exist at the project root; the walker wrongly resolves them relative to `framework/`. NOT broken in reality.
- **~10 are genuine stale links in non-template reference docs** — e.g. `workflow-guide.md → framework/process/version-control-workflow.md` (missing `docs/`), `version-control-workflow.md → framework/FRAMEWORK-CHANGELOG.md` (nonexistent), `distribution-build-checklist.md → ../docs/PROJECT-STRUCTURE.md` (wrong depth). These are the **same structural-staleness family as the `framework/INDEX.md` cluster** and were NOT part of TECH-155's reported 13.

**Conclusion:** TECH-155 is complete for its documented scope (the 13). The additional structural-staleness links (reference docs + `framework/INDEX.md`) are tracked separately as **TECH-157**. The `templates/` example-link noise is expected behavior, not tracked as a defect.

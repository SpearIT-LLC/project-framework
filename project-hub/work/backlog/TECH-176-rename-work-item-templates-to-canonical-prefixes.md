# Tech Debt: Rename Work-Item Templates to Canonical Type Prefixes

**ID:** TECH-176
**Type:** Tech Debt
**Priority:** Low
**Version Impact:** MINOR
**Created:** 2026-07-08
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->
**Theme:** Framework Consistency

---

## Summary

Two work-item templates carry filenames that don't match their canonical type prefix:
`FEATURE-TEMPLATE.md` (type `FEAT`) and `TECHDEBT-TEMPLATE.md` (type `TECH`). Rename them to
`FEAT-TEMPLATE.md` and `TECH-TEMPLATE.md` for consistency with the canonical set (ADR-006), and fix
**all live references** across docs, glossary, index, quick-reference, starter template, and process
checklists. Kept separate from TECH-173 deliberately: it's a mechanical rename with a **40+ reference
blast radius**, and mixing it into the taxonomy/DRY work would obscure both.

---

## Problem Statement

**What is the current state?** (verified 2026-07-08)

- The canonical convention is `<PREFIX>-TEMPLATE.md` where `<PREFIX>` is the type prefix (the 4 new
  templates from TECH-173 already follow it: `DOCS/CHORE/REFACTOR/TASK-TEMPLATE.md`, plus existing
  `BUG-`, `SPIKE-`).
- Two legacy outliers remain: `FEATURE-TEMPLATE.md` (should be `FEAT-`) and `TECHDEBT-TEMPLATE.md`
  (should be `TECH-`). ADR-006 explicitly flagged `TECHDEBT` as a "3rd spelling" of TECH.
- `grep` finds **40+ references** to `FEATURE-TEMPLATE.md` and several to `TECHDEBT-TEMPLATE.md`
  across `framework/docs/**`, `GLOSSARY.md`, `INDEX.md`, `CLAUDE-QUICK-REFERENCE.md`,
  `templates/starter/**`, and process checklists — **plus** many mentions inside historical/backlog
  work items and CHANGELOG that must **not** be rewritten (history is immutable; backlog items
  describe their own era's context).

**Why is this a problem?**

- Inconsistent template naming is exactly the "one concept, several spellings" drift ADR-006 fights.
- The mismatch confuses the type→template mapping the workflow-guide documents.

**What is the desired state?**

- `FEAT-TEMPLATE.md` and `TECH-TEMPLATE.md` on disk; every **live** reference updated; historical
  references left intact.

---

## Scope

**In scope:**
- `git mv` the two templates to canonical-prefix names.
- Update all **live** references (docs, GLOSSARY, INDEX, QUICK-REFERENCE, starter template, process
  checklists, the workflow-guide type table + per-template section).
- Verify the distribution build (`Build-FrameworkArchive.ps1`) still copies templates correctly.

**Out of scope:**
- Rewriting historical references in `history/`, `releases/`, CHANGELOG, or backlog work-item bodies
  (immutable / era-specific context).
- Plugin template trees (their own reconciliation — coordinate with the plugin work in FEAT-175).

---

## Acceptance Criteria

- [ ] `FEATURE-TEMPLATE.md` → `FEAT-TEMPLATE.md`, `TECHDEBT-TEMPLATE.md` → `TECH-TEMPLATE.md` (git mv)
- [ ] All live references updated; no broken links introduced
- [ ] Historical/backlog/CHANGELOG references deliberately left as-is (documented)
- [ ] Distribution build still ships templates correctly
- [ ] CHANGELOG.md updated

---

## Related

- **TECH-173 / ADR-006** — established the canonical type set and naming convention; created the 4
  new correctly-named templates and left this rename as a focused follow-up.
- **TECH-158** — framework structural stale links. **Coordinate:** this rename touches the same doc
  surface; ideally sequenced with or near TECH-158 to fix links once.

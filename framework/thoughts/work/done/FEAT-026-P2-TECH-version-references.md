# FEAT-026 Sub-Item: Fix Hardcoded Version References

**ID:** FEAT-026-P2-TECH-version-references
**Parent:** FEAT-026-structure-migration
**Type:** Technical Debt
**Priority:** P2 (Should fix before merge)
**Status:** Done
**Created:** 2026-01-06
**Completed:** 2026-01-07

---

## Summary

Remove or update hardcoded version numbers that will become stale and create maintenance burden.

---

## Problem

**From followup lines 22, 25:**
- Line 22: "Should we reference a specific version here and risk it not be up-to-date?"
- Line 25: "Another version reference that's already outdated. Maybe we just say 'Planned'."

Hardcoded version numbers in documentation:
- Become outdated quickly
- Create maintenance burden
- Can mislead users

---

## Examples

**README.md:**
- Line 193: "Current Version: v2.0.0 (2025-12-19)" - Could become stale
- Line 198: "What's Next (v2.1.0)" - Specific version for future plans
- Line 272: Version strategy references specific version

---

## Strategy

**For current version:**
- Link to PROJECT-STATUS.md (single source of truth)
- Use "See PROJECT-STATUS.md for current version"
- Never duplicate version number

**For future plans:**
- Use "Planned" instead of specific version
- Or "Next release" / "Future version"
- Don't commit to specific version numbers in advance

**For historical references:**
- Keep in CHANGELOG.md (appropriate)
- Keep in release notes (appropriate)
- Remove from general documentation

---

## Scope

**Search for:**
- "v2." or "v1." (version patterns)
- "version 2" / "version 1"
- "(2025-" / "(2026-" (dates next to versions)

**Files to check:**
- README.md
- QUICK-START.md
- All framework/ documentation
- Template files

---

## Approach

**Replace version-specific references with:**
- "See [PROJECT-STATUS.md](framework/PROJECT-STATUS.md) for current version"
- "Planned for future release"
- "Latest version"
- Remove entirely if not needed

**Keep versions only in:**
- PROJECT-STATUS.md (source of truth)
- CHANGELOG.md (historical record)
- Release history files

---

## Implementation

1. **Search** for all version references
2. **Categorize:** Current, Future, Historical
3. **Update** current versions to link to PROJECT-STATUS
4. **Update** future versions to generic "planned"
5. **Keep** historical versions only where appropriate

---

## Completion Criteria

- [x] All hardcoded version numbers found
- [x] Current version refs link to PROJECT-STATUS.md
- [x] Future version refs use generic "planned" language
- [x] No duplicate version sources of truth
- [x] Changes committed (185a3c4)

---

## Implementation Notes

**Files Updated:**

**README.md:**
- "What's Next (v2.1.0)" → "What's Next" (removed version commitment)
- "Planned (v2.1.0)" → "Planned" (removed version commitment)
- "Framework Version: v2.0.0 (tracked in...)" → "See framework/PROJECT-STATUS.md for current version"
- "CONTRIBUTING.md planned for v2.2.0" → "planned for future release"
- Removed "(as of v2.0.0)" from dogfooding section

**framework/CLAUDE.md:**
- "Framework Version: Standard (v2.1.0)" → "Framework Level: Standard (see PROJECT-STATUS.md for current version)"
- Emergency example updated from "v2.1.0" to "vX.Y.Z"

**QUICK-START.md:**
- Release example updated from "v1.2.0" to "vX.Y.Z"

**Rationale:**
- PROJECT-STATUS.md is the single source of truth for current version
- Future version commitments create stale references that require maintenance
- Generic version placeholders (vX.Y.Z) better for examples and won't become outdated
- Reduces maintenance burden and eliminates version number drift

**Historical versions preserved in:**
- framework/CHANGELOG.md (appropriate - historical record)
- Credits section showing first release dates (appropriate - historical fact)
- Release history files in thoughts/history/releases/ (appropriate - archives)

**Commit:** 185a3c4

---

**Last Updated:** 2026-01-07
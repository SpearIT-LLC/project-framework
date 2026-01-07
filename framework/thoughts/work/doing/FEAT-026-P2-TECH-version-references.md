# FEAT-026 Sub-Item: Fix Hardcoded Version References

**ID:** FEAT-026-P2-TECH-version-references
**Parent:** FEAT-026-structure-migration
**Type:** Technical Debt
**Priority:** P2 (Should fix before merge)
**Status:** Todo
**Created:** 2026-01-06

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

- [ ] All hardcoded version numbers found
- [ ] Current version refs link to PROJECT-STATUS.md
- [ ] Future version refs use generic "planned" language
- [ ] No duplicate version sources of truth
- [ ] Changes committed

---

**Last Updated:** 2026-01-06
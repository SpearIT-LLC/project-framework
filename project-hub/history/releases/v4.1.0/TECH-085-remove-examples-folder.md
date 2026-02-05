# TECH-085: Remove examples/ Folder

**ID:** TECH-085
**Type:** Tech Debt
**Priority:** Low
**Version Impact:** MINOR
**Status:** Done
**Created:** 2026-01-26
**Completed:** 2026-01-26

---

## Summary

Remove the `examples/` folder from the repository. With the new framework-as-dependency distribution model, this folder is redundant.

---

## Context

**Old monorepo model:**
- `examples/hello-world/` demonstrated "here's what a project looks like"
- It referenced `../framework/` as a shared dependency
- Served as a living reference implementation

**New distribution model (DECISION-050):**
- `templates/starter/` IS the reference - it's exactly what users get
- Every project created from the archive IS an example
- `examples/hello-world/` becomes redundant
- Would require conversion to have its own `framework/` copy (maintenance burden)

---

## Implementation

- [x] Remove `examples/` folder entirely
- [x] Update any references to examples/ in documentation
- [x] Update CLAUDE.md if it mentions examples/
- [x] Update framework.yaml if it references examples/ (no references found)

---

## Files to Remove

- `examples/hello-world/` (entire directory tree)

---

## Rationale

- The distribution archive itself serves as the example
- Less maintenance overhead
- No confusion about examples/ vs templates/starter/
- Aligns with framework-as-dependency model

---

## Related

- DECISION-050: Framework Distribution Model (enabled this change)

---

## Files Modified

- `CLAUDE.md` - Updated repository structure, removed examples references
- `README.md` - Updated references
- `QUICK-START.md` - Updated references
- `framework/README.md` - Updated references
- `framework/docs/REPOSITORY-STRUCTURE.md` - Updated structure and references
- `framework/CHANGELOG.md` - Added to Unreleased

## Files Removed

- `examples/hello-world/` - Entire directory (21 files)

---

**Last Updated:** 2026-01-26
**Status:** Done

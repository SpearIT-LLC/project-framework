# FEAT-026 Sub-Item: Align Framework Structure with Standard Template

**ID:** FEAT-026-P1-BUG-framework-structure
**Parent:** FEAT-026-structure-migration
**Type:** Bug (Structure Inconsistency)
**Priority:** P1 (Critical - must fix before merge)
**Status:** Todo
**Created:** 2026-01-06

---

## Summary

The framework/ directory does not follow its own Standard Project structure specification. Missing docs/ folder and potentially other structure elements.

---

## Problem

**From followup line 48-50:**
- "Where is the docs/ folder?"
- "Does this structure match our project structure standard? It seems it doesn't."

The framework/ project should dogfood the Standard Project Framework structure, but currently missing:
- `docs/` folder
- Possibly other standard structure elements

---

## Expected Structure

Framework/ should match Standard Project template:
```
framework/
├── src/              # (N/A - framework has no source code)
├── tests/            # (N/A - framework has no tests currently)
├── docs/             # MISSING - Should exist
├── thoughts/         # EXISTS ✓
├── CLAUDE.md         # EXISTS ✓
├── README.md         # Should we have one?
├── PROJECT-STATUS.md # EXISTS ✓
├── CHANGELOG.md      # EXISTS ✓
└── INDEX.md          # EXISTS ✓
```

Plus framework-specific folders:
```
├── collaboration/    # EXISTS ✓
├── patterns/         # EXISTS ✓
├── process/          # EXISTS ✓
├── templates/        # EXISTS ✓
└── tools/            # EXISTS ✓
```

---

## Questions to Resolve

1. **Should framework/ have its own README.md?**
   - Currently the root README serves this purpose
   - Framework-specific README might be useful

2. **What goes in framework/docs/?**
   - Extended documentation beyond root markdown files
   - Process guides (currently in process/)
   - Collaboration guides (currently in collaboration/)
   - Or should this be for user-facing docs only?

3. **Do we need src/ and tests/?**
   - Framework has no executable code
   - Could add .gitkeep or omit entirely

---

## Implementation

**Minimum fix:**
- [ ] Create `framework/docs/` folder
- [ ] Add `framework/docs/README.md` explaining purpose

**Consider:**
- [ ] Document framework/ structure deviation from standard (if intentional)
- [ ] Or fully align with standard structure

---

## Completion Criteria

- [ ] framework/ structure matches Standard template (or deviations documented)
- [ ] docs/ folder exists with README
- [ ] Decision documented on src/ and tests/ folders
- [ ] Changes committed

---

**Last Updated:** 2026-01-06
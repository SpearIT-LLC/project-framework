# Tech Debt: Align POC Folder Location with ADR-004

**ID:** 086
**Type:** Tech Debt
**Version Impact:** PATCH (documentation fix)
**Status:** Done
**Created:** 2026-01-26
**Completed:** 2026-01-26
**Developer:** Claude

---

## Summary

PROJECT-STRUCTURE-STANDARD.md and the starter template show `poc/` at the project root, but ADR-004 decided it should be at `project-hub/poc/`. Align documentation and template with the ADR decision.

---

## Problem Statement

**What problem does this solve?**

Documentation inconsistency between:
- ADR-004 (decision): `project-hub/poc/`
- PROJECT-STRUCTURE-STANDARD.md: `poc/` at project root
- Starter template: `templates/starter/poc/` (at root)
- Framework actual structure: `framework/project-hub/poc/` (correct)

The framework follows its own ADR, but the documentation and starter template do not.

**Who is affected?**

- Users creating new projects from the starter template (get wrong structure)
- AI assistants reading PROJECT-STRUCTURE-STANDARD.md (get conflicting guidance)

**Current workaround (if any):**

None - this creates confusion about where POC belongs.

---

## Requirements

### Changes Needed

1. **PROJECT-STRUCTURE-STANDARD.md** - Move `poc/` from project root section to under `project-hub/`
2. **Starter template** - Move `templates/starter/poc/` to `templates/starter/project-hub/poc/`
3. **Update .gitkeep list** - Change item 3 from `poc/.gitkeep` to `project-hub/poc/.gitkeep`

---

## Design

### Rationale

Per ADR-004, POC was placed in `project-hub/` because:
- POCs are tracked (spike docs) but don't follow kanban workflow
- Clear separation: `work/` = formal workflow, `poc/` = experiments
- Sibling to `research/` - both are "thinking" but different types
- No WIP limits (experimentation shouldn't be constrained)

Users who want informal scratch space can add their own folders - the framework provides the formal tracking approach.

### Files to Modify

| File | Lines | Change |
|------|-------|--------|
| `framework/docs/PROJECT-STRUCTURE-STANDARD.md` | 67-69 | Move `poc/` from root to under `project-hub/` |
| `framework/docs/PROJECT-STRUCTURE-STANDARD.md` | 364 | Change `poc/.gitkeep` to `project-hub/poc/.gitkeep` |
| `framework/docs/process/distribution-build-checklist.md` | 45 | Update checklist to show `project-hub/poc/` |
| `tools/Build-FrameworkArchive.ps1` | 179 | Update output text (remove `poc/` from root scaffolding list) |

**Physical folder move:**
- `templates/starter/poc/` → `templates/starter/framework/project-hub/poc/`
  (Starter template uses embedded framework model)

**No changes needed (already correct):**
- `framework/docs/collaboration/workflow-guide.md` - already shows `project-hub/poc/`
- `framework/docs/ref/framework-roles.yaml` - already shows `project-hub/poc/`

---

## Implementation Checklist

- [x] Update PROJECT-STRUCTURE-STANDARD.md structure diagram (lines 67-69)
- [x] Update .gitkeep list in PROJECT-STRUCTURE-STANDARD.md (line 364)
- [x] Update distribution-build-checklist.md (line 45)
- [x] Update Build-FrameworkArchive.ps1 output text (line 179)
- [x] Move `templates/starter/poc/` to `templates/starter/framework/project-hub/poc/`
- [x] Verify starter template `project-hub/` folder structure is complete
- [x] Update CHANGELOG.md

---

## References

- ADR-004: POC Folder for Experiments
- FEAT-062: POC Folder and Spike Workflow
- Discussion: 2026-01-26 session

---

**Last Updated:** 2026-01-26 (checklist refined)

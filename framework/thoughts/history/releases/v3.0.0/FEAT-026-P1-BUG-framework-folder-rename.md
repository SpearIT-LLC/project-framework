# FEAT-026 Sub-Item: Consider Renaming project-framework-template/

**ID:** FEAT-026-P1-BUG-framework-folder-rename
**Parent:** FEAT-026-structure-migration
**Type:** Bug (Confusing Naming)
**Priority:** P1 (Critical - decide before merge)
**Status:** Todo
**Created:** 2026-01-06

---

## Summary

The folder `project-framework-template/` name could be confusing. Consider renaming to `project-templates/` or similar for clarity.

---

## Problem

**From followup line 17:**
"We're calling the folder, project-framework-template/ but that name could be confusing but it's really just project-templates/."

Current structure:
```
./
├── framework/                    # The framework implementation
├── project-hello-world/          # Example project
└── project-framework-template/   # CONFUSING NAME
```

The name `project-framework-template` could imply:
- Template for the framework project itself?
- Framework for project templates?

Actually contains: Template packages for new projects (Minimal, Light, Standard)

---

## Options

**Option 1: Rename to `project-templates/`**
- Pros: Clear, simple, accurate
- Cons: Loses "framework" association

**Option 2: Rename to `templates/`**
- Pros: Very simple
- Cons: Might conflict with framework/templates/, could be ambiguous

**Option 3: Rename to `project-starter-templates/`**
- Pros: Very descriptive
- Cons: Longer name

**Option 4: Keep as-is, clarify in docs**
- Pros: No breaking change
- Cons: Name remains potentially confusing

---

## Impact

- **Low impact** - folder is primarily referenced in documentation
- **Good time to change** - before v2.3.0 release
- **Documentation updates** required regardless of decision

---

## Implementation

If renaming:
1. **Use git mv** to preserve history
2. **Update all documentation references**
3. **Update README.md structure diagram**
4. **Update QUICK-START.md paths**
5. **Update any template selection guides**

---

## Decision Required

Need to decide:
1. Should we rename?
2. If yes, to what?
3. Now or later?

---

## Completion Criteria

- [ ] Decision made (rename or keep)
- [ ] If renaming: git mv executed
- [ ] All documentation updated
- [ ] Changes committed

---

**Last Updated:** 2026-01-06
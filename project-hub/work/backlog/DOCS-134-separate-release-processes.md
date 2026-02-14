# DOCS-134: Separate Release Processes by Product

**ID:** DOCS-134
**Type:** Documentation
**Priority:** Medium
**Created:** 2026-02-13

---

## Summary

Split the current unified release process documentation into separate, product-specific release process documents to avoid confusion between framework and plugin release workflows.

---

## Problem Statement

Current release documentation (`version-control-workflow.md`) is framework-centric and doesn't properly account for plugin releases having a completely different build/distribution workflow:

**Framework releases:**
- Build distribution archive (Build-FrameworkArchive.ps1)
- Create ZIP in distrib/
- Version from PROJECT-STATUS.md

**Plugin releases:**
- Build plugin package (Build-Plugin.ps1)
- Create ZIP in distrib/plugin-light/
- Version from plugin.json
- Optional local marketplace publish for testing
- Future: marketplace submission workflow

Trying to document both in one process creates conditional logic and confusion.

---

## Proposed Solution

Create separate, self-contained release process documents:

```
framework/docs/process/
├── framework-release-process.md    (NEW - complete framework release steps)
├── plugin-release-process.md       (NEW - complete plugin release steps)
└── version-control-workflow.md     (UPDATE - high-level git workflow, references specific processes)
```

---

## Scope

### 1. Create framework-release-process.md

**Content:**
- Framework-specific release checklist
- Build distribution archive steps
- Distribution to users
- Version management (PROJECT-STATUS.md)
- Framework testing requirements
- Common steps (tagging, archival) included

**Example structure:**
```markdown
# Framework Release Process

## Pre-Release Checklist
- All work items in done/
- Tests passing
- CHANGELOG.md updated

## Release Steps
1. Update PROJECT-STATUS.md version
2. Create git tag
3. Build distribution archive
4. Archive work items to releases/framework/vX.Y.Z/
5. Distribute framework

## Post-Release
- Verify distribution
- Update documentation if needed
```

### 2. Create plugin-release-process.md

**Content:**
- Plugin-specific release checklist
- Build plugin package steps
- Local marketplace testing workflow
- Marketplace submission process (when applicable)
- Version management (plugin.json)
- Plugin testing requirements
- Common steps (tagging, archival) included

**Example structure:**
```markdown
# Plugin Release Process

## Pre-Release Checklist
- All work items in done/
- Plugin commands tested
- Version bumped in plugin.json
- README.md updated

## Release Steps
1. Update plugin.json version
2. Create git tag (plugin-light-vX.Y.Z)
3. Build plugin package
4. Test in local marketplace
5. Archive work items to releases/plugin-light/vX.Y.Z/
6. Submit to Anthropic marketplace (if public release)

## Post-Release
- Verify installation works
- Monitor for issues
```

### 3. Update version-control-workflow.md

**Changes:**
- Remove product-specific build steps
- Keep high-level git workflow (branching, merging, tagging)
- Add references to product-specific release docs
- Add section: "For complete release process, see:"
  - Framework: [framework-release-process.md](framework-release-process.md)
  - Plugin: [plugin-release-process.md](plugin-release-process.md)

---

## Benefits

✅ **Clear separation** - No "if framework/if plugin" conditional logic
✅ **Self-contained** - Each doc has complete process for that product
✅ **Scalable** - Easy to add plugin-full-release-process.md later
✅ **Focused** - Framework users don't see plugin steps, and vice versa
✅ **Maintainable** - Product-specific changes don't affect other docs

---

## Implementation Plan

### Phase 1: Create Framework Release Process

1. Read current version-control-workflow.md
2. Extract framework-specific content
3. Add common steps (tagging, archival)
4. Create complete framework-release-process.md
5. Include Build-FrameworkArchive.ps1 usage

### Phase 2: Create Plugin Release Process

1. Document plugin build workflow
2. Include Build-Plugin.ps1 usage
3. Add local marketplace testing steps
4. Document marketplace submission (when applicable)
5. Create complete plugin-release-process.md

### Phase 3: Update Version Control Workflow

1. Remove product-specific build steps
2. Keep git workflow fundamentals
3. Add clear references to product-specific docs
4. Update archival step to mention product selection

### Phase 4: Update References

1. Find all references to version-control-workflow.md
2. Update to point to appropriate product-specific doc
3. Update CLAUDE.md references
4. Update workflow-guide.md references

---

## Acceptance Criteria

- [ ] framework-release-process.md created with complete framework release steps
- [ ] plugin-release-process.md created with complete plugin release steps
- [ ] version-control-workflow.md updated to reference product-specific docs
- [ ] Build script usage documented in appropriate process docs
- [ ] All cross-references updated
- [ ] No conditional "if framework/if plugin" logic in docs
- [ ] Each process document is self-contained and complete

---

## Common Steps to Include in Both

Even though separate, both should include these common steps:
- **Tagging:** `git tag -a {product}-vX.Y.Z -m "Release notes"`
- **Archival:** `git mv project-hub/work/done/*.md project-hub/history/releases/{product}/vX.Y.Z/`
- **Verification:** Check done/ is empty
- **Commit:** `git commit -m "chore: Archive {product} vX.Y.Z work items"`

**Note:** Small duplication is acceptable for clarity and self-contained documentation.

---

## Files to Search for References

```bash
grep -r "version-control-workflow" framework/docs/ framework/CLAUDE.md
grep -r "release process" framework/docs/
```

---

## Future Expansion

When plugin-full is ready:
- Create `plugin-full-release-process.md` following same pattern
- Update version-control-workflow.md to reference it
- Each plugin has its own complete release documentation

---

## Related Work Items

- **CHORE-131:** Reorganize Releases by Product (established product-based structure)
- **DOCS-133:** Update Release Documentation (updated paths to use product nesting)
- **FEAT-127:** Full Framework Plugin (future - will need its own release process)

---

## Notes

**Design principle:** Self-contained documentation > DRY in this case. Each product team (framework maintainer vs plugin maintainer) should be able to follow their release process without cross-referencing multiple documents or navigating conditional logic.

**Duplication strategy:** Common git steps (tag, archive, commit) are duplicated in each doc because:
1. They're simple and unlikely to change
2. Product-specific context (tag naming, folder paths) differs
3. Self-contained docs are more valuable than avoiding 5-10 lines of duplication

---

**Last Updated:** 2026-02-13
**Status:** Backlog

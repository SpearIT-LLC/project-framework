# Chore: Update distrib/framework/ Path References After Restructuring

**ID:** CHORE-147
**Type:** Chore
**Priority:** Medium
**Created:** 2026-02-19

---

## Summary

The framework distribution ZIPs were moved from `distrib/` root into `distrib/framework/` as part of a manual restructuring to align with the existing `distrib/plugin-light/` and `distrib/plugin-full/` subfolder convention. Forward-looking files that reference the old path need to be updated.

---

## Background

Current `distrib/` structure after restructuring:
```
distrib/
├── framework/          ← ZIPs moved here (was distrib/ root)
│   ├── spearit_framework_v3.7.0.zip
│   ├── spearit_framework_v4.0.0.zip
│   ├── spearit_framework_v5.0.0.zip
│   └── spearit_framework_v5.1.0.zip
├── plugin-full/
│   ├── spearit-framework-v1.0.0-dev2.zip
│   └── spearit-framework-v1.0.0.zip
└── plugin-light/
    ├── spearit-framework-light-v1.0.0-dev2.zip
    ├── spearit-framework-light-v1.0.0-dev3.zip
    └── spearit-framework-light-v1.0.0.zip
```

---

## Scope

**Files to update (live/forward-looking only):**

- [ ] `tools/Build-FrameworkArchive.ps1` — output path: `distrib/` → `distrib/framework/`
- [ ] `.gitignore` — ensure pattern covers `distrib/**/*.zip` (not just `distrib/*.zip`)
- [ ] `framework/docs/process/version-control-workflow.md` — update path reference
- [ ] `framework/docs/process/distribution-build-checklist.md` — update path reference

**Do NOT update:**
- Historical session histories, release records, or work item history files — they accurately reflect what was true at the time

---

## Acceptance Criteria

- [ ] `Build-FrameworkArchive.ps1` outputs to `distrib/framework/`
- [ ] `.gitignore` excludes ZIPs in all three subdirectories
- [ ] Process docs reference `distrib/framework/` for framework ZIPs
- [ ] Running the build script produces output in the correct location

---

## Related Work Items

- **DOCS-134:** Separate Release Processes by Product — will consume the corrected paths when implemented; no coordination needed

---

**Last Updated:** 2026-02-19
**Status:** Backlog

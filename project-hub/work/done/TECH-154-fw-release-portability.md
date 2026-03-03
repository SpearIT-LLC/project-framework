# Tech Debt: /fw-release Command Portability

**ID:** TECH-154
**Type:** Tech Debt
**Priority:** Medium
**Version Impact:** PATCH
**Created:** 2026-03-03
**Completed:** 2026-03-03
**Theme:** Workflow

---

## Summary

The `/fw-release` command contains hardcoded project-specific values (paths, product names, version strings) in its bash snippets that only apply to this repo. Any project adopting the framework would need to manually edit the command before using it.

---

## Problem Statement

**What is the current state?**

`.claude/commands/fw-release.md` Steps 6, 7, and 8 contain hardcoded values:

- `framework/PROJECT-STATUS.md` — hardcoded path (Step 6)
- `framework/CHANGELOG.md` — hardcoded path (Step 6)
- `project-hub/history/releases/framework/v5.3.0` — hardcoded archive path (Step 7, 3x)
- `project-hub/work/done/` — hardcoded work folder path (Step 7)
- `v5.3.0` — hardcoded version string in commit messages and paths (Steps 6, 7, 8)
- `SpearIT Project Framework`, `7` — hardcoded in the summary display template (Step 8)

**Why is this a problem?**

The framework is designed to be adopted by other projects via the `templates/starter/` package. When a new project installs the framework, `/fw-release` won't work correctly without manual edits — defeating the "zero-config" intent. Any project with a different product name, different `project-hub` path, or different `CHANGELOG.md` location will get wrong behavior.

**What is the desired state?**

All bash snippets use variables derived from `framework.yaml` (already read in Step 1) and the version calculated in Step 3. No hardcoded project-specific values remain. The command works correctly on any project that follows the framework's `framework.yaml` schema.

---

## Proposed Solution

Step 1 already reads `framework.yaml` and resolves the product config. Introduce a set of variables at that point and use them consistently throughout:

```bash
# Resolved from framework.yaml + Step 3
PRODUCT_LABEL="SpearIT Project Framework"   # products[].label
ARCHIVE_PATH="project-hub/history/releases/framework"  # products[].archive_path
PROJECT_HUB="project-hub"                  # top-level project_hub path (or convention)
STATUS_FILE="framework/PROJECT-STATUS.md"  # products[].status_file (or convention)
CHANGELOG_FILE="framework/CHANGELOG.md"   # products[].changelog_file (or convention)
NEW_VERSION="v5.3.0"                       # calculated in Step 3
ARCHIVE_DIR="${PROJECT_HUB}/${ARCHIVE_PATH}/${NEW_VERSION}"
DONE_DIR="${PROJECT_HUB}/work/done"
```

Replace all hardcoded literals in Steps 6, 7, and 8 bash snippets with these variables. Update illustrative examples to use `vX.Y.Z` placeholders rather than `v5.3.0`.

**Files Affected:**
- `.claude/commands/fw-release.md` — Steps 1, 6, 7, 8 bash snippets and surrounding prose

**Optional `framework.yaml` additions** (if convention-based paths aren't sufficient):
```yaml
release:
  products:
    - id: framework
      label: "SpearIT Project Framework"
      priority: 1
      archive_path: "history/releases/framework"
      status_file: "framework/PROJECT-STATUS.md"    # optional, defaults to framework/PROJECT-STATUS.md
      changelog_file: "framework/CHANGELOG.md"      # optional, defaults to framework/CHANGELOG.md
```

If these fields are absent, fall back to the conventional paths (`framework/PROJECT-STATUS.md`, `framework/CHANGELOG.md`).

---

## Acceptance Criteria

- [x] No hardcoded version strings (`v5.3.0`, etc.) remain in bash snippets
- [x] No hardcoded product-specific paths remain in bash snippets (`framework/`, `project-hub/`, `SpearIT Project Framework`)
- [x] All values derive from `framework.yaml` config or the calculated version
- [x] Command works correctly on a project with a different product label and archive path
- [x] Illustrative examples in prose use `vX.Y.Z` placeholders, not literal versions
- [x] `framework.yaml` optionally supports `status_file` and `changelog_file` per product; absent → conventional defaults

---

## Notes

- Discovered while reviewing fw-release.md during BUG-152 implementation
- This is a separate concern from BUG-152 (archival script bugs) and FEAT-153 (full pipeline)
- FEAT-153 will also touch the command — coordinate so FEAT-153 builds on the portable version

---

## Related

- BUG-152: fw-release archival script bugs (in doing/)
- FEAT-153: fw-release full pipeline — include distribution build (in todo/)

---

**Last Updated:** 2026-03-03

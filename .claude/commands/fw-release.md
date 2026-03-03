# /fw-release - Automated Release Command

Automate the release process: validate readiness, calculate version, update files, create git tag, archive work items.

## Usage

```
/fw-release [product-id]
```

## Arguments

- `product-id` (optional): Product to release. If omitted, uses `default_product` from `framework.yaml`. If no `framework.yaml` config, archives to `history/releases/vX.Y.Z/`.

**Examples:**
```
/fw-release                 → default product (framework in this repo)
/fw-release framework       → history/releases/framework/vX.Y.Z/
/fw-release plugin-full     → history/releases/plugin-full/vX.Y.Z/
/fw-release plugin-light    → history/releases/plugin-light/vX.Y.Z/
/fw-release my-product      → history/releases/my-product/vX.Y.Z/
```

---

## Step 1: Read Configuration

Read `framework.yaml` and extract `release` section:

```bash
# Check for release config
cat framework.yaml
```

Resolve the target product:
- If `product-id` argument given → find matching entry in `products[]` by `id`; if no match, treat the argument as a literal path segment (e.g., `fw-release my-thing` → `history/releases/my-thing/`)
- If no argument → use `default_product` to find the matching entry
- If no `release` section at all → archive path is `history/releases/`

---

## Step 2: Pre-Release Validation

### 2a. Check doing/ for in-progress work

```bash
ls project-hub/work/doing/
```

**If doing/ is non-empty:**

> ❌ **Release blocked — items in doing/**
>
> The following items are in progress:
> - FEAT-NNN: [title]
>
> Releasing with in-progress work risks an incomplete or out-of-sync release.
>
> Options:
> 1. Move doing/ items to done/ first, then release
> 2. Move doing/ items back to todo/, then release
> 3. Use `--force` to release anyway (not recommended)

Stop unless `--force` is given.

### 2b. Check done/ is not empty

```bash
ls project-hub/work/done/*.md 2>/dev/null
```

If no `.md` files found (only `.gitkeep` or empty):

> ❌ **Release blocked — nothing in done/**
>
> There are no completed work items to release.

Stop. No `--force` override for this.

### 2c. Check for cross-product items (multi-product repos only)

If `products[]` has more than one entry, scan `done/` items and identify which product(s) each item affects. Use file path hints from the work item content (e.g., references to `plugins/spearit-framework-full/` → plugin-full).

If items appear to span multiple products:

> ⚠️  **Cross-product items detected**
>
> The following items in done/ may affect multiple products:
> - FEAT-NNN: [title] → appears to affect: framework, plugin-full
>
> **Recommendation:** Archive FEAT-NNN under `framework` (priority 1, highest rank).
> Both framework and plugin-full CHANGELOGs will include this entry.
>
> Proceed with this recommendation? (y/n)

If user confirms, note which items are cross-product for the CHANGELOG step.

---

## Step 3: Calculate Version

Read `framework/PROJECT-STATUS.md` to get current version:

```bash
grep "Current Version" framework/PROJECT-STATUS.md
```

Read all `done/` work items and extract `Version Impact` field. Apply highest:
- `MAJOR` → bump major, reset minor and patch to 0
- `MINOR` → bump minor, reset patch to 0
- `PATCH` → bump patch only
- `None` → treat as PATCH

Present to user:

> **Version Calculation**
>
> Current version: v5.2.0
> Items in done/: 7
> Highest Version Impact: MINOR
>
> Proposed next version: **v5.3.0**
>
> Confirm? (or enter a different version)

Wait for confirmation before proceeding.

---

## Step 4: Build CHANGELOG Entries

For each item in `done/`, extract CHANGELOG content:

1. **Check for `## CHANGELOG Notes` section** — if present, use the content inside the fenced code block verbatim
2. **If absent** — synthesize from the work item:
   - Use the `## Summary` field as the primary description
   - Pull key bullet points from `## Work Completed`, `## Consequences`, or equivalent sections
   - Prefix with the work item ID and title

Group entries by type (Added / Changed / Fixed / Removed) based on work item `**Type:**` field:
- Feature → Added
- Tech Debt → Changed
- Bug → Fixed
- Decision → Changed (or Added if it introduces new policy)
- Spike → omit from CHANGELOG (learning, not delivery) unless it has explicit CHANGELOG Notes

Present the full synthesized CHANGELOG block to the user for review:

> **CHANGELOG Preview — [Unreleased] → [v5.3.0] - 2026-03-02**
>
> ### Added
> - **FEAT-099: /fw-release Command** — Automated release process...
>
> ### Changed
> - **TECH-151: Work Item Artifacts Pattern** — ...
>
> Looks good? (y/edit/n)

If user says `edit`, pause and let them make changes before continuing.

For cross-product items: note that those entries will also appear in the secondary product's CHANGELOG section (added as a "Also included in this release" note).

---

## Step 5: Update Files

### 5a. Update PROJECT-STATUS.md

Find and update the version line:

```
**Current Version:** vX.Y.Z (YYYY-MM-DD)
```

Replace with new version and today's date.

### 5b. Update CHANGELOG.md

In `framework/CHANGELOG.md`:

1. Find `## [Unreleased]`
2. Replace heading with `## [vX.Y.Z] - YYYY-MM-DD`
3. Insert new `## [Unreleased]` block above it with reset subsections:

```markdown
## [Unreleased]

### Added

None

### Changed

None

### Removed

None

### Fixed

None

---
```

4. Replace the old Unreleased content with the approved CHANGELOG entries under the new versioned heading.

---

## Step 6: Git Commit and Tag

```bash
git add framework/PROJECT-STATUS.md framework/CHANGELOG.md
git commit -m "chore: Release v5.3.0 - [brief description of highest-impact item]"
git tag -a v5.3.0 -m "Release v5.3.0 - [brief description]"
```

Report tag created. Then:

> Ready to push to GitHub:
> ```
> git push origin main --tags
> ```

Do NOT push automatically. Leave push to the developer.

---

## Step 7: Archive Work Items

Determine archive path:
- From resolved product config: `{archive_path}/vX.Y.Z/`
- Example: `history/releases/framework/v5.3.0/`

Create the release folder and move items:

```bash
mkdir -p project-hub/history/releases/framework/v5.3.0

# Move each work item and its artifact folder (if present)
for item in project-hub/work/done/*.md; do
  [ "$(basename $item)" = ".gitkeep" ] && continue
  [ ! -f "$item" ] && continue
  git mv "$item" project-hub/history/releases/framework/v5.3.0/ || { echo "⚠️  Could not move $item — skipping"; continue; }
  ITEM_ID=$(basename "$item" | grep -oE '^[A-Z]+-[0-9]+')
  ARTIFACT_DIR="project-hub/work/done/${ITEM_ID}"
  if [ -d "$ARTIFACT_DIR" ]; then
    git mv "$ARTIFACT_DIR" project-hub/history/releases/framework/v5.3.0/
  fi
done

git commit -m "chore: Archive v5.3.0 work items"
```

---

## Step 8: Release Summary

Display:

```
✅ Release v5.3.0 complete

  Product:        SpearIT Project Framework
  Items released: 7
  Tag created:    v5.3.0
  Archived to:    project-hub/history/releases/framework/v5.3.0/

  To push to GitHub:
    git push origin main --tags

  Next steps:
  - Verify CHANGELOG.md looks correct
  - Announce release if applicable
  - Start next cycle: move backlog/todo items to doing/
```

---

## Error Handling

| Condition | Behavior |
|---|---|
| `doing/` non-empty | Block (bypassable with `--force`) |
| `done/` empty | Block (not bypassable) |
| Unknown product-id argument | Use as literal path segment, warn user |
| Git tag already exists | Block — report duplicate tag, ask for different version |
| Uncommitted changes in working directory | Warn, ask to confirm before proceeding |
| `framework.yaml` missing `release` section | Default to `history/releases/` path |

---

## Policy Reference

- Release sizing policy: DECISION-097
- Archive path config: `framework.yaml` → `release.products[].archive_path`
- Version calculation: highest `Version Impact` across all `done/` items
- Artifacts pattern: `workflow-guide.md#work-item-artifacts`

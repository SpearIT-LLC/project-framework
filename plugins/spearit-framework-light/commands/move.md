# /spearit-framework-light:move - Move Work Item Between Folders

Move one or more work items between workflow folders. Automatically moves child work items when moving a parent item. Supports any file extension.

## Usage

```
/spearit-framework-light:move <item-id-or-list> <target-folder>
```

## Arguments

- `item-id-or-list` (required): Single ID or multiple IDs — comma-separated, space-separated, or mixed. Full IDs (`FEAT-136`) or bare numbers (`136`) both work. Case insensitive. The numeric ID is what matters — type prefix (`FEAT-`, `BUG-`, etc.) is stripped before matching.
- `target-folder` (required): One of: `backlog`, `todo`, `doing`, `done`, `archive`

---

## Parsing Rules

**Target folder detection:**
- Last token is checked against valid folder names: `backlog`, `todo`, `doing`, `done`, `archive`
- If last token is a valid folder → it's the target, everything else is the item list
- If last token is NOT a valid folder → report error with valid folder names, stop

**Item list parsing:**
- Strip surrounding quotes (if any)
- Split on commas, spaces, or both
- Filter out any tokens that match valid folder names
- Remaining tokens are resolved as IDs

**ID resolution:**
- Full ID (`FEAT-136`, `BUG-140`) → strip type prefix, match by numeric ID
- Bare number (`136`, `140`) → match by numeric ID directly
- Numeric ID matches zero files → report not found, skip, continue
- Numeric ID matches more than one parent → report ambiguity, skip, continue

**Single-item invocations work exactly as before** (backwards compatible).

---

## Execution Instructions

**Parse the user's arguments to extract the item list and target folder.**

**Then execute this bash script, substituting the resolved item IDs and target folder.**

**This single script handles ALL targets. Run it once per command invocation.**

---

### Core Script (all targets)

```bash
#!/usr/bin/env bash
set -uo pipefail

VALID_FOLDERS="backlog todo doing done archive"
TARGET="<target-folder>"
ITEM_IDS=(<space-separated-list-of-resolved-ids>)

# Repo root guard
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || {
  echo "❌ Not inside a git repository."
  exit 1
}
cd "$REPO_ROOT"

WORK_DIR="project-hub/work"

# ID normalization: strip type prefix, keep numeric part only
# FEAT-125 → 125, feat-125 → 125, 125 → 125
normalize_id() {
  echo "$1" | sed 's/^[A-Za-z]*[-_]*//' | tr '[:upper:]' '[:lower:]'
}

# Find all parent files for a numeric ID (any extension, excludes children)
# Pattern: ID must be preceded by - and followed by -, ., or end-of-string
# Excludes: files where ID is followed by .{digit} (those are children)
find_parent() {
  local numeric_id="$1"
  find "$WORK_DIR" -type f \
    | grep -iE "[-]${numeric_id}([-.]|$)" \
    | grep -ivE "[-]${numeric_id}[.][0-9]" \
    || true
}

# Find all child files for a numeric ID
# Pattern: ID followed by .{digit}
find_children() {
  local numeric_id="$1"
  find "$WORK_DIR" -type f \
    | grep -iE "[-]${numeric_id}[.][0-9]" \
    || true
}

# WIP limit check for doing target
if [ "$TARGET" = "doing" ] && [ -f "$WORK_DIR/doing/.limit" ]; then
  LIMIT=$(cat "$WORK_DIR/doing/.limit" | tr -d '[:space:]')
  COUNT=$(find "$WORK_DIR/doing" -type f ! -name ".limit" | wc -l | tr -d '[:space:]')
  if [ "$COUNT" -ge "$LIMIT" ]; then
    echo "⚠️  WIP limit: $COUNT/$LIMIT items already in doing/"
    echo ""
  fi
fi

echo "Moving ${#ITEM_IDS[@]} item(s) to $TARGET/..."
echo ""

MOVED=0
SKIPPED=0
FAILED=0

move_item() {
  local raw_id="$1"
  local target="$2"
  local numeric_id
  numeric_id=$(normalize_id "$raw_id")

  # Find all parent files (any extension, not children)
  local all_parents
  all_parents=$(find_parent "$numeric_id")

  if [ -z "$all_parents" ]; then
    echo "❌ Not found: '$raw_id' (ID=$numeric_id) — skipped"
    ((FAILED++)) || true
    return
  fi

  # Use first result to determine source folder and display name
  local source
  source=$(echo "$all_parents" | head -1)
  local item_name
  item_name=$(basename "$source")
  local source_folder
  source_folder=$(basename "$(dirname "$source")")

  # Validate transition rules per target
  case "$target" in
    todo)
      if [ "$source_folder" = "todo" ]; then
        echo "⚠️  $item_name already in todo/ — skipped"
        ((SKIPPED++)) || true
        return
      fi
      if [ "$source_folder" = "done" ]; then
        echo "❌ $item_name: cannot move from done/ to todo/ — skipped"
        ((FAILED++)) || true
        return
      fi
      ;;
    doing)
      if [ "$source_folder" = "doing" ]; then
        echo "⚠️  $item_name already in doing/ — skipped"
        ((SKIPPED++)) || true
        return
      fi
      if [ "$source_folder" = "backlog" ]; then
        echo "❌ $item_name: cannot move from backlog/ directly to doing/ (backlog → todo → doing) — skipped"
        ((FAILED++)) || true
        return
      fi
      if [ "$source_folder" = "done" ]; then
        echo "❌ $item_name: cannot move from done/ to doing/ — skipped"
        ((FAILED++)) || true
        return
      fi
      ;;
    done)
      if [ "$source_folder" = "done" ]; then
        echo "⚠️  $item_name already in done/ — skipped"
        ((SKIPPED++)) || true
        return
      fi
      if [ "$source_folder" != "doing" ]; then
        echo "⚠️  $item_name: moving from $source_folder/ to done/ (typically from doing/)"
      fi
      ;;
    backlog)
      if [ "$source_folder" = "backlog" ]; then
        echo "⚠️  $item_name already in backlog/ — skipped"
        ((SKIPPED++)) || true
        return
      fi
      ;;
    archive)
      # No transition restrictions
      ;;
  esac

  # Find children before moving parent
  local children
  children=$(find_children "$numeric_id")

  # Move all parent files (first file gets ✅, additional siblings get +)
  local first_moved=false
  while IFS= read -r parent_file; do
    local pname
    pname=$(basename "$parent_file")
    git mv "$parent_file" "$WORK_DIR/$target/" 2>/dev/null
    if [ $? -eq 0 ]; then
      if [ "$first_moved" = false ]; then
        echo "✅ $pname → $target/"
        ((MOVED++)) || true
        first_moved=true
      else
        echo "   + $pname → $target/"
      fi
    else
      echo "❌ git mv failed for $pname"
      ((FAILED++)) || true
    fi
  done <<< "$all_parents"

  # Move children (each gets ↳)
  if [ -n "$children" ]; then
    while IFS= read -r child; do
      local child_name
      child_name=$(basename "$child")
      git mv "$child" "$WORK_DIR/$target/" 2>/dev/null && echo "   ↳ $child_name"
    done <<< "$children"
  fi
}

for ID in "${ITEM_IDS[@]}"; do
  move_item "$ID" "$TARGET"
done

echo ""

# WIP summary
if [ -f "$WORK_DIR/$TARGET/.limit" ]; then
  LIMIT_TEXT=$(cat "$WORK_DIR/$TARGET/.limit" | tr -d '[:space:]')
else
  LIMIT_TEXT="∞"
fi
FINAL_COUNT=$(find "$WORK_DIR/$TARGET" -type f ! -name ".limit" | wc -l | tr -d '[:space:]')
echo "📊 $TARGET/: $FINAL_COUNT/$LIMIT_TEXT items"
echo "   ✅ moved: $MOVED  ⚠️  skipped: $SKIPPED  ❌ failed: $FAILED"
```

---

### Additional step when target is `doing`

After the script completes, for each item successfully moved to `doing/`, perform an AI review:

1. Read the work item file at `project-hub/work/doing/<item-name>`
2. Present a concise pre-implementation review:
   ```
   📋 Pre-Implementation Review: ITEM-NNN

   Building: [1-2 sentence summary]
   Dependencies: [list or "None"]
   Open Questions: [any TODO/TBD/DECIDE markers, or "None"]
   ```
3. **STOP — wait for user confirmation before proceeding with implementation**

### Additional step when target is `archive`

After the script completes:
```
Optional: Add cancellation metadata to each archived file (Status: Cancelled, Cancelled Date, Reason)
```

### Additional step when target is `done`

After the script completes:
```
Optional: Document completion in session history with /spearit-framework-light:session-history
```

---

## Output Format

**Single item:**
```
Moving 1 item(s) to todo/...

✅ FEAT-141-move-command-batch-support.md → todo/

📊 todo/: 3/10 items
   ✅ moved: 1  ⚠️  skipped: 0  ❌ failed: 0
```

**Batch:**
```
Moving 3 items to todo/...

✅ FEAT-136-project-guidance-design-doc.md → todo/
✅ FEAT-137-plugin-project-guidance-commands.md → todo/
❌ Not found: 'FEAT-999' (ID=999) — skipped

📊 todo/: 5/10 items
   ✅ moved: 2  ⚠️  skipped: 0  ❌ failed: 1
```

**Parent with children:**
```
Moving 1 item(s) to todo/...

✅ FEAT-127-full-framework-plugin.md → todo/
   ↳ FEAT-127.1-full-plugin-structure.md
   ↳ FEAT-127.2-full-plugin-session-history.md
   ↳ FEAT-127.3-full-plugin-roadmap-command.md

📊 todo/: 6/10 items
   ✅ moved: 1  ⚠️  skipped: 0  ❌ failed: 0
```

---

## Examples

**Single work items:**
```
/spearit-framework-light:move feat-018 todo      # Move to todo
/spearit-framework-light:move BUG-042 doing      # Start work (with review)
/spearit-framework-light:move feat-018 done      # Complete work
/spearit-framework-light:move 42 backlog         # Bare numeric ID
```

**Batch — multiple items:**
```
/spearit-framework-light:move "FEAT-136, FEAT-137, FEAT-138" todo
/spearit-framework-light:move FEAT-136 FEAT-137 FEAT-138 todo
/spearit-framework-light:move "136, 137, 138" todo
/spearit-framework-light:move "FEAT-136, 137, CHORE-138" todo
```

**Parent/Epic items (automatically moves children):**
```
/spearit-framework-light:move feat-127 doing     # Moves FEAT-127 + all FEAT-127.x children
/spearit-framework-light:move epic-050 done      # Moves EPIC-050 + all EPIC-050.x children
/spearit-framework-light:move feat-127 backlog   # Deprioritizes parent + children
```

**Other operations:**
```
/spearit-framework-light:move feat-127 archive   # Cancel parent + children
```

# /spearit-framework-light:move - Move Work Item Between Folders

Move a work item between workflow folders using optimized script-based execution.

## Usage

```
/spearit-framework-light:move <item-id> <target-folder>
```

## Arguments

- `item-id` (required): Work item ID (e.g., FEAT-018, feat-127) - case insensitive
- `target-folder` (required): One of: `backlog`, `todo`, `doing`, `done`, `archive`

---

## Execution Instructions

**Based on the target folder, execute the corresponding bash script below.**

**Substitute `ITEM_ID` with the user's item-id argument (preserve their casing).**

---

### When target is: `todo`

**Execute this EXACT bash command:**

```bash
ITEM_ID="<item-id>"

# Find the work item
SOURCE=$(find project-hub/work -type f \( -iname "${ITEM_ID}*.md" -o -iname "${ITEM_ID^^}*.md" \) 2>/dev/null | head -1)

if [ -z "$SOURCE" ]; then
  echo "❌ Could not find work item: $ITEM_ID"
  exit 1
fi

# Validate transition
SOURCE_DIR=$(dirname "$SOURCE")
SOURCE_FOLDER=$(basename "$SOURCE_DIR")

case "$SOURCE_FOLDER" in
  todo)
    echo "⚠️ Item already in todo/"
    exit 0
    ;;
  done)
    echo "❌ Cannot move from done/ to todo/ (no reopening - create new item instead)"
    exit 1
    ;;
esac

# Check WIP limit
if [ -f "project-hub/work/todo/.limit" ]; then
  LIMIT=$(cat project-hub/work/todo/.limit | tr -d '[:space:]')
  COUNT=$(find project-hub/work/todo -type f -name "*.md" 2>/dev/null | wc -l | tr -d '[:space:]')
  if [ "$COUNT" -ge "$LIMIT" ]; then
    echo "⚠️ WIP limit: $COUNT/$LIMIT items in todo/"
  fi
fi

# Execute move
git mv "$SOURCE" project-hub/work/todo/

if [ $? -eq 0 ]; then
  ITEM_NAME=$(basename "$SOURCE")
  NEW_COUNT=$(find project-hub/work/todo -type f -name "*.md" 2>/dev/null | wc -l | tr -d '[:space:]')
  LIMIT_TEXT=$(cat project-hub/work/todo/.limit 2>/dev/null || echo '∞')
  echo "✅ Moved $ITEM_NAME to todo/"
  echo "📊 WIP: $NEW_COUNT/$LIMIT_TEXT items"
fi
```

---

### When target is: `doing`

**Execute this EXACT bash command:**

```bash
ITEM_ID="<item-id>"

# Find the work item
SOURCE=$(find project-hub/work -type f \( -iname "${ITEM_ID}*.md" -o -iname "${ITEM_ID^^}*.md" \) 2>/dev/null | head -1)

if [ -z "$SOURCE" ]; then
  echo "❌ Could not find work item: $ITEM_ID"
  exit 1
fi

# Validate transition
SOURCE_DIR=$(dirname "$SOURCE")
SOURCE_FOLDER=$(basename "$SOURCE_DIR")

case "$SOURCE_FOLDER" in
  doing)
    echo "⚠️ Item already in doing/"
    exit 0
    ;;
  backlog)
    echo "❌ Cannot move directly from backlog/ to doing/"
    echo "   Valid path: backlog → todo → doing"
    exit 1
    ;;
  done)
    echo "❌ Cannot move from done/ to doing/ (no reopening - create new item instead)"
    exit 1
    ;;
esac

# Check WIP limit
if [ -f "project-hub/work/doing/.limit" ]; then
  LIMIT=$(cat project-hub/work/doing/.limit | tr -d '[:space:]')
  COUNT=$(find project-hub/work/doing -type f -name "*.md" 2>/dev/null | wc -l | tr -d '[:space:]')
  if [ "$COUNT" -ge "$LIMIT" ]; then
    echo "⚠️ WIP limit: $COUNT/$LIMIT items in doing/"
  fi
fi

# Execute move
git mv "$SOURCE" project-hub/work/doing/

if [ $? -eq 0 ]; then
  ITEM_NAME=$(basename "$SOURCE")
  echo "✅ Moved $ITEM_NAME to doing/"
fi
```

**After the script completes, perform AI review:**

1. Read the work item file at `project-hub/work/doing/$ITEM_NAME`
2. Extract key information:
   - Summary: What we're building (1-2 sentences)
   - Dependencies: Check "Depends On" field
   - Open questions: Search for TODO, TBD, DECIDE markers
3. Present concise review:
   ```
   📋 Pre-Implementation Review: ITEM-NNN

   Building: [1-2 sentence summary]
   Dependencies: [list or "None"]
   Open Questions: [list or "None"]

   Ready to proceed?
   ```
4. **STOP - Wait for user confirmation**

---

### When target is: `done`

**Execute this EXACT bash command:**

```bash
ITEM_ID="<item-id>"

# Find the work item
SOURCE=$(find project-hub/work -type f \( -iname "${ITEM_ID}*.md" -o -iname "${ITEM_ID^^}*.md" \) 2>/dev/null | head -1)

if [ -z "$SOURCE" ]; then
  echo "❌ Could not find work item: $ITEM_ID"
  exit 1
fi

# Validate transition
SOURCE_DIR=$(dirname "$SOURCE")
SOURCE_FOLDER=$(basename "$SOURCE_DIR")

if [ "$SOURCE_FOLDER" != "doing" ]; then
  echo "⚠️ Moving from $SOURCE_FOLDER to done/ (typically done → from doing/)"
fi

# Execute move
git mv "$SOURCE" project-hub/work/done/

if [ $? -eq 0 ]; then
  ITEM_NAME=$(basename "$SOURCE")
  echo "✅ Moved $ITEM_NAME to done/"
  echo ""
  echo "Optional: Document completion in session history with /fw-session-history"
fi
```

---

### When target is: `backlog`

**Execute this EXACT bash command:**

```bash
ITEM_ID="<item-id>"

# Find the work item
SOURCE=$(find project-hub/work -type f \( -iname "${ITEM_ID}*.md" -o -iname "${ITEM_ID^^}*.md" \) 2>/dev/null | head -1)

if [ -z "$SOURCE" ]; then
  echo "❌ Could not find work item: $ITEM_ID"
  exit 1
fi

# Validate transition
SOURCE_DIR=$(dirname "$SOURCE")
SOURCE_FOLDER=$(basename "$SOURCE_DIR")

if [ "$SOURCE_FOLDER" = "backlog" ]; then
  echo "⚠️ Item already in backlog/"
  exit 0
fi

# Execute move
git mv "$SOURCE" project-hub/work/backlog/

if [ $? -eq 0 ]; then
  ITEM_NAME=$(basename "$SOURCE")
  echo "✅ Moved $ITEM_NAME to backlog/"
fi
```

---

### When target is: `archive`

**Execute this EXACT bash command:**

```bash
ITEM_ID="<item-id>"

# Find the work item
SOURCE=$(find project-hub/work -type f \( -iname "${ITEM_ID}*.md" -o -iname "${ITEM_ID^^}*.md" \) 2>/dev/null | head -1)

if [ -z "$SOURCE" ]; then
  echo "❌ Could not find work item: $ITEM_ID"
  exit 1
fi

# Execute move
git mv "$SOURCE" project-hub/history/archive/

if [ $? -eq 0 ]; then
  ITEM_NAME=$(basename "$SOURCE")
  echo "✅ Moved $ITEM_NAME to archive/ (cancelled)"
  echo ""
  echo "Optional: Add cancellation metadata (Status: Cancelled, Cancelled Date, Reason)"
fi
```

---

## Examples

```
/spearit-framework-light:move feat-127 todo      # Move to todo
/spearit-framework-light:move FEAT-127 doing     # Start work (with review)
/spearit-framework-light:move feat-127 done      # Complete work
/spearit-framework-light:move FEAT-127 backlog   # Deprioritize
/spearit-framework-light:move feat-127 archive   # Cancel work
```

---

## Performance

**Target times:**
- → backlog/todo/done/archive: 5-8 seconds (script execution)
- → doing (with AI review): 12-18 seconds (script + review)

**Note:** Performance is limited by Claude Code's architecture (API latency per command ~2-3 seconds unavoidable).

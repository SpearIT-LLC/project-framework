# /spearit-framework:move - Move Work Item Between Folders

Move a work item between workflow folders using optimized script-based execution. Automatically moves child work items when moving parent/epic items.

## Usage

```
/spearit-framework:move <item-id> <target-folder>
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
ITEM_ID_UPPER=$(echo "$ITEM_ID" | tr '[:lower:]' '[:upper:]')

# Find the work item (exact match for parent, not children)
SOURCE=$(find project-hub/work -type f -iname "${ITEM_ID}-*.md" 2>/dev/null | grep -v "/${ITEM_ID_UPPER}\." | head -1)
if [ -z "$SOURCE" ]; then
  SOURCE=$(find project-hub/work -type f -iname "${ITEM_ID_UPPER}-*.md" 2>/dev/null | grep -v "/${ITEM_ID_UPPER}\." | head -1)
fi

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

# Check if this is a parent/epic with children
ITEM_NAME=$(basename "$SOURCE")
CHILDREN=$(find project-hub/work -type f -iname "${ITEM_ID_UPPER}.*.md" 2>/dev/null)

# Check WIP limit
if [ -f "project-hub/work/todo/.limit" ]; then
  LIMIT=$(cat project-hub/work/todo/.limit | tr -d '[:space:]')
  COUNT=$(find project-hub/work/todo -type f -name "*.md" 2>/dev/null | wc -l | tr -d '[:space:]')
  if [ "$COUNT" -ge "$LIMIT" ]; then
    echo "⚠️ WIP limit: $COUNT/$LIMIT items in todo/"
  fi
fi

# Execute move (parent first)
git mv "$SOURCE" project-hub/work/todo/

if [ $? -eq 0 ]; then
  echo "✅ Moved $ITEM_NAME to todo/"

  # Move children if any exist
  if [ -n "$CHILDREN" ]; then
    CHILD_COUNT=0
    for CHILD in $CHILDREN; do
      git mv "$CHILD" project-hub/work/todo/ 2>/dev/null
      if [ $? -eq 0 ]; then
        CHILD_NAME=$(basename "$CHILD")
        echo "   ↳ Moved child: $CHILD_NAME"
        ((CHILD_COUNT++))
      fi
    done
    if [ $CHILD_COUNT -gt 0 ]; then
      echo "📦 Moved parent + $CHILD_COUNT children"
    fi
  fi

  NEW_COUNT=$(find project-hub/work/todo -type f -name "*.md" 2>/dev/null | wc -l | tr -d '[:space:]')
  LIMIT_TEXT=$(cat project-hub/work/todo/.limit 2>/dev/null || echo '∞')
  echo "📊 WIP: $NEW_COUNT/$LIMIT_TEXT items"
fi
```

---

### When target is: `doing`

**Execute this EXACT bash command:**

```bash
ITEM_ID="<item-id>"
ITEM_ID_UPPER=$(echo "$ITEM_ID" | tr '[:lower:]' '[:upper:]')

# Find the work item (exact match for parent, not children)
SOURCE=$(find project-hub/work -type f -iname "${ITEM_ID}-*.md" 2>/dev/null | grep -v "/${ITEM_ID_UPPER}\." | head -1)
if [ -z "$SOURCE" ]; then
  SOURCE=$(find project-hub/work -type f -iname "${ITEM_ID_UPPER}-*.md" 2>/dev/null | grep -v "/${ITEM_ID_UPPER}\." | head -1)
fi

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

# Check if this is a parent/epic with children
ITEM_NAME=$(basename "$SOURCE")
CHILDREN=$(find project-hub/work -type f -iname "${ITEM_ID_UPPER}.*.md" 2>/dev/null)

# Check WIP limit
if [ -f "project-hub/work/doing/.limit" ]; then
  LIMIT=$(cat project-hub/work/doing/.limit | tr -d '[:space:]')
  COUNT=$(find project-hub/work/doing -type f -name "*.md" 2>/dev/null | wc -l | tr -d '[:space:]')
  if [ "$COUNT" -ge "$LIMIT" ]; then
    echo "⚠️ WIP limit: $COUNT/$LIMIT items in doing/"
  fi
fi

# Execute move (parent first)
git mv "$SOURCE" project-hub/work/doing/

if [ $? -eq 0 ]; then
  echo "✅ Moved $ITEM_NAME to doing/"

  # Move children if any exist
  if [ -n "$CHILDREN" ]; then
    CHILD_COUNT=0
    for CHILD in $CHILDREN; do
      git mv "$CHILD" project-hub/work/doing/ 2>/dev/null
      if [ $? -eq 0 ]; then
        CHILD_NAME=$(basename "$CHILD")
        echo "   ↳ Moved child: $CHILD_NAME"
        ((CHILD_COUNT++))
      fi
    done
    if [ $CHILD_COUNT -gt 0 ]; then
      echo "📦 Moved parent + $CHILD_COUNT children"
    fi
  fi
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
ITEM_ID_UPPER=$(echo "$ITEM_ID" | tr '[:lower:]' '[:upper:]')

# Find the work item (exact match for parent, not children)
SOURCE=$(find project-hub/work -type f -iname "${ITEM_ID}-*.md" 2>/dev/null | grep -v "/${ITEM_ID_UPPER}\." | head -1)
if [ -z "$SOURCE" ]; then
  SOURCE=$(find project-hub/work -type f -iname "${ITEM_ID_UPPER}-*.md" 2>/dev/null | grep -v "/${ITEM_ID_UPPER}\." | head -1)
fi

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

# Check if this is a parent/epic with children
ITEM_NAME=$(basename "$SOURCE")
CHILDREN=$(find project-hub/work -type f -iname "${ITEM_ID_UPPER}.*.md" 2>/dev/null)

# Execute move (parent first)
git mv "$SOURCE" project-hub/work/done/

if [ $? -eq 0 ]; then
  echo "✅ Moved $ITEM_NAME to done/"

  # Move children if any exist
  if [ -n "$CHILDREN" ]; then
    CHILD_COUNT=0
    for CHILD in $CHILDREN; do
      git mv "$CHILD" project-hub/work/done/ 2>/dev/null
      if [ $? -eq 0 ]; then
        CHILD_NAME=$(basename "$CHILD")
        echo "   ↳ Moved child: $CHILD_NAME"
        ((CHILD_COUNT++))
      fi
    done
    if [ $CHILD_COUNT -gt 0 ]; then
      echo "📦 Moved parent + $CHILD_COUNT children"
    fi
  fi

  echo ""
  echo "Optional: Document completion in session history with /spearit-framework:session-history"
fi
```

---

### When target is: `backlog`

**Execute this EXACT bash command:**

```bash
ITEM_ID="<item-id>"
ITEM_ID_UPPER=$(echo "$ITEM_ID" | tr '[:lower:]' '[:upper:]')

# Find the work item (exact match for parent, not children)
SOURCE=$(find project-hub/work -type f -iname "${ITEM_ID}-*.md" 2>/dev/null | grep -v "/${ITEM_ID_UPPER}\." | head -1)
if [ -z "$SOURCE" ]; then
  SOURCE=$(find project-hub/work -type f -iname "${ITEM_ID_UPPER}-*.md" 2>/dev/null | grep -v "/${ITEM_ID_UPPER}\." | head -1)
fi

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

# Check if this is a parent/epic with children
ITEM_NAME=$(basename "$SOURCE")
CHILDREN=$(find project-hub/work -type f -iname "${ITEM_ID_UPPER}.*.md" 2>/dev/null)

# Execute move (parent first)
git mv "$SOURCE" project-hub/work/backlog/

if [ $? -eq 0 ]; then
  echo "✅ Moved $ITEM_NAME to backlog/"

  # Move children if any exist
  if [ -n "$CHILDREN" ]; then
    CHILD_COUNT=0
    for CHILD in $CHILDREN; do
      git mv "$CHILD" project-hub/work/backlog/ 2>/dev/null
      if [ $? -eq 0 ]; then
        CHILD_NAME=$(basename "$CHILD")
        echo "   ↳ Moved child: $CHILD_NAME"
        ((CHILD_COUNT++))
      fi
    done
    if [ $CHILD_COUNT -gt 0 ]; then
      echo "📦 Moved parent + $CHILD_COUNT children"
    fi
  fi
fi
```

---

### When target is: `archive`

**Execute this EXACT bash command:**

```bash
ITEM_ID="<item-id>"
ITEM_ID_UPPER=$(echo "$ITEM_ID" | tr '[:lower:]' '[:upper:]')

# Find the work item (exact match for parent, not children)
SOURCE=$(find project-hub/work -type f -iname "${ITEM_ID}-*.md" 2>/dev/null | grep -v "/${ITEM_ID_UPPER}\." | head -1)
if [ -z "$SOURCE" ]; then
  SOURCE=$(find project-hub/work -type f -iname "${ITEM_ID_UPPER}-*.md" 2>/dev/null | grep -v "/${ITEM_ID_UPPER}\." | head -1)
fi

if [ -z "$SOURCE" ]; then
  echo "❌ Could not find work item: $ITEM_ID"
  exit 1
fi

# Check if this is a parent/epic with children
ITEM_NAME=$(basename "$SOURCE")
CHILDREN=$(find project-hub/work -type f -iname "${ITEM_ID_UPPER}.*.md" 2>/dev/null)

# Execute move (parent first)
git mv "$SOURCE" project-hub/work/archive/

if [ $? -eq 0 ]; then
  echo "✅ Moved $ITEM_NAME to archive/ (cancelled)"

  # Move children if any exist
  if [ -n "$CHILDREN" ]; then
    CHILD_COUNT=0
    for CHILD in $CHILDREN; do
      git mv "$CHILD" project-hub/work/archive/ 2>/dev/null
      if [ $? -eq 0 ]; then
        CHILD_NAME=$(basename "$CHILD")
        echo "   ↳ Moved child: $CHILD_NAME"
        ((CHILD_COUNT++))
      fi
    done
    if [ $CHILD_COUNT -gt 0 ]; then
      echo "📦 Moved parent + $CHILD_COUNT children"
    fi
  fi

  echo ""
  echo "Optional: Add cancellation metadata (Status: Cancelled, Cancelled Date, Reason)"
fi
```

---

## Examples

**Single work items:**
```
/spearit-framework:move feat-018 todo      # Move to todo
/spearit-framework:move BUG-042 doing      # Start work (with review)
/spearit-framework:move feat-018 done      # Complete work
```

**Parent/Epic items (automatically moves children):**
```
/spearit-framework:move feat-127 doing     # Moves FEAT-127 + all FEAT-127.x children
/spearit-framework:move epic-050 done      # Moves EPIC-050 + all EPIC-050.x children
/spearit-framework:move feat-127 backlog   # Deprioritizes parent + children
```

**Other operations:**
```
/spearit-framework:move feat-127 archive   # Cancel parent + children
```

---

## Performance

**Target times:**
- → backlog/todo/done/archive: 5-8 seconds (script execution)
- → doing (with AI review): 12-18 seconds (script + review)

**Note:** Performance is limited by Claude Code's architecture (API latency per command ~2-3 seconds unavoidable).

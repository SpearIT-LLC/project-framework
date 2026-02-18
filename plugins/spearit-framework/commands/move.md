# /spearit-framework:move - Move Work Item Between Folders

Move one or more work items between workflow folders using optimized script-based execution. Automatically moves child work items when moving parent/epic items.

## Usage

```
/spearit-framework:move <item-id-or-list> <target-folder>
```

## Arguments

- `item-id-or-list` (required): Single ID or multiple IDs — comma-separated, space-separated, or mixed. Full IDs (`FEAT-136`) or bare numbers (`136`) both work. Case insensitive.
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
- Full ID (`FEAT-136`, `BUG-140`) → match directly, case insensitive
- Bare number (`136`, `140`) → scan all work folders, match file with that number regardless of type prefix
- Bare number matches zero files → report not found, skip, continue
- Bare number matches more than one file → data integrity error, stop entire batch and report

**Single-item invocations work exactly as before** (backwards compatible).

---

## Execution Instructions

**Parse the user's arguments to extract the item list and target folder.**

**Then, based on the target folder, execute the corresponding bash script below for EACH resolved item ID.**

**Substitute `ITEM_ID` with each resolved ID (uppercase) when executing the script.**

---

### When target is: `todo`

**For each resolved item ID, execute this EXACT bash command:**

```bash
ITEM_ID="<item-id>"
ITEM_ID_UPPER=$(echo "$ITEM_ID" | tr '[:lower:]' '[:upper:]')

# Find the work item (exact match for parent, not children)
SOURCE=$(find project-hub/work -type f -iname "${ITEM_ID}-*.md" 2>/dev/null | grep -v "/${ITEM_ID_UPPER}\." | head -1)
if [ -z "$SOURCE" ]; then
  SOURCE=$(find project-hub/work -type f -iname "${ITEM_ID_UPPER}-*.md" 2>/dev/null | grep -v "/${ITEM_ID_UPPER}\." | head -1)
fi

if [ -z "$SOURCE" ]; then
  echo "❌ Could not find work item: $ITEM_ID (skipped)"
  exit 0
fi

# Validate transition
SOURCE_DIR=$(dirname "$SOURCE")
SOURCE_FOLDER=$(basename "$SOURCE_DIR")

case "$SOURCE_FOLDER" in
  todo)
    echo "⚠️ $ITEM_ID already in todo/ (skipped)"
    exit 0
    ;;
  done)
    echo "❌ $ITEM_ID: Cannot move from done/ to todo/ (skipped)"
    exit 0
    ;;
esac

# Check if this is a parent/epic with children
ITEM_NAME=$(basename "$SOURCE")
CHILDREN=$(find project-hub/work -type f -iname "${ITEM_ID_UPPER}.*.md" 2>/dev/null)

# Execute move (parent first)
git mv "$SOURCE" project-hub/work/todo/

if [ $? -eq 0 ]; then
  echo "✅ $ITEM_NAME → todo/"

  # Move children if any exist
  if [ -n "$CHILDREN" ]; then
    CHILD_COUNT=0
    for CHILD in $CHILDREN; do
      git mv "$CHILD" project-hub/work/todo/ 2>/dev/null
      if [ $? -eq 0 ]; then
        CHILD_NAME=$(basename "$CHILD")
        echo "   ↳ $CHILD_NAME"
        ((CHILD_COUNT++))
      fi
    done
  fi
fi
```

**After all items are moved, print the WIP summary:**

```bash
NEW_COUNT=$(find project-hub/work/todo -type f -name "*.md" 2>/dev/null | wc -l | tr -d '[:space:]')
LIMIT_TEXT=$(cat project-hub/work/todo/.limit 2>/dev/null || echo '∞')
echo "📊 WIP: $NEW_COUNT/$LIMIT_TEXT items in todo/"
```

---

### When target is: `doing`

**Check WIP limit before starting:**

```bash
if [ -f "project-hub/work/doing/.limit" ]; then
  LIMIT=$(cat project-hub/work/doing/.limit | tr -d '[:space:]')
  COUNT=$(find project-hub/work/doing -type f -name "*.md" 2>/dev/null | wc -l | tr -d '[:space:]')
  if [ "$COUNT" -ge "$LIMIT" ]; then
    echo "⚠️ WIP limit: $COUNT/$LIMIT items in doing/"
  fi
fi
```

**For each resolved item ID, execute this EXACT bash command:**

```bash
ITEM_ID="<item-id>"
ITEM_ID_UPPER=$(echo "$ITEM_ID" | tr '[:lower:]' '[:upper:]')

# Find the work item (exact match for parent, not children)
SOURCE=$(find project-hub/work -type f -iname "${ITEM_ID}-*.md" 2>/dev/null | grep -v "/${ITEM_ID_UPPER}\." | head -1)
if [ -z "$SOURCE" ]; then
  SOURCE=$(find project-hub/work -type f -iname "${ITEM_ID_UPPER}-*.md" 2>/dev/null | grep -v "/${ITEM_ID_UPPER}\." | head -1)
fi

if [ -z "$SOURCE" ]; then
  echo "❌ Could not find work item: $ITEM_ID (skipped)"
  exit 0
fi

# Validate transition
SOURCE_DIR=$(dirname "$SOURCE")
SOURCE_FOLDER=$(basename "$SOURCE_DIR")

case "$SOURCE_FOLDER" in
  doing)
    echo "⚠️ $ITEM_ID already in doing/ (skipped)"
    exit 0
    ;;
  backlog)
    echo "❌ $ITEM_ID: Cannot move directly from backlog/ to doing/ (skipped)"
    echo "   Valid path: backlog → todo → doing"
    exit 0
    ;;
  done)
    echo "❌ $ITEM_ID: Cannot move from done/ to doing/ (skipped)"
    exit 0
    ;;
esac

# Check if this is a parent/epic with children
ITEM_NAME=$(basename "$SOURCE")
CHILDREN=$(find project-hub/work -type f -iname "${ITEM_ID_UPPER}.*.md" 2>/dev/null)

# Execute move (parent first)
git mv "$SOURCE" project-hub/work/doing/

if [ $? -eq 0 ]; then
  echo "✅ $ITEM_NAME → doing/"

  # Move children if any exist
  if [ -n "$CHILDREN" ]; then
    CHILD_COUNT=0
    for CHILD in $CHILDREN; do
      git mv "$CHILD" project-hub/work/doing/ 2>/dev/null
      if [ $? -eq 0 ]; then
        CHILD_NAME=$(basename "$CHILD")
        echo "   ↳ $CHILD_NAME"
        ((CHILD_COUNT++))
      fi
    done
  fi
fi
```

**After all items are moved, perform AI review for each moved item:**

For each item successfully moved to doing/:
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
   ```
4. **STOP - Wait for user confirmation before proceeding with implementation**

---

### When target is: `done`

**For each resolved item ID, execute this EXACT bash command:**

```bash
ITEM_ID="<item-id>"
ITEM_ID_UPPER=$(echo "$ITEM_ID" | tr '[:lower:]' '[:upper:]')

# Find the work item (exact match for parent, not children)
SOURCE=$(find project-hub/work -type f -iname "${ITEM_ID}-*.md" 2>/dev/null | grep -v "/${ITEM_ID_UPPER}\." | head -1)
if [ -z "$SOURCE" ]; then
  SOURCE=$(find project-hub/work -type f -iname "${ITEM_ID_UPPER}-*.md" 2>/dev/null | grep -v "/${ITEM_ID_UPPER}\." | head -1)
fi

if [ -z "$SOURCE" ]; then
  echo "❌ Could not find work item: $ITEM_ID (skipped)"
  exit 0
fi

# Validate transition
SOURCE_DIR=$(dirname "$SOURCE")
SOURCE_FOLDER=$(basename "$SOURCE_DIR")

if [ "$SOURCE_FOLDER" != "doing" ]; then
  echo "⚠️ $ITEM_ID: Moving from $SOURCE_FOLDER to done/ (typically from doing/)"
fi

# Check if this is a parent/epic with children
ITEM_NAME=$(basename "$SOURCE")
CHILDREN=$(find project-hub/work -type f -iname "${ITEM_ID_UPPER}.*.md" 2>/dev/null)

# Execute move (parent first)
git mv "$SOURCE" project-hub/work/done/

if [ $? -eq 0 ]; then
  echo "✅ $ITEM_NAME → done/"

  # Move children if any exist
  if [ -n "$CHILDREN" ]; then
    CHILD_COUNT=0
    for CHILD in $CHILDREN; do
      git mv "$CHILD" project-hub/work/done/ 2>/dev/null
      if [ $? -eq 0 ]; then
        CHILD_NAME=$(basename "$CHILD")
        echo "   ↳ $CHILD_NAME"
        ((CHILD_COUNT++))
      fi
    done
  fi
fi
```

**After all items are moved:**

```
Optional: Document completion in session history with /spearit-framework:session-history
```

---

### When target is: `backlog`

**For each resolved item ID, execute this EXACT bash command:**

```bash
ITEM_ID="<item-id>"
ITEM_ID_UPPER=$(echo "$ITEM_ID" | tr '[:lower:]' '[:upper:]')

# Find the work item (exact match for parent, not children)
SOURCE=$(find project-hub/work -type f -iname "${ITEM_ID}-*.md" 2>/dev/null | grep -v "/${ITEM_ID_UPPER}\." | head -1)
if [ -z "$SOURCE" ]; then
  SOURCE=$(find project-hub/work -type f -iname "${ITEM_ID_UPPER}-*.md" 2>/dev/null | grep -v "/${ITEM_ID_UPPER}\." | head -1)
fi

if [ -z "$SOURCE" ]; then
  echo "❌ Could not find work item: $ITEM_ID (skipped)"
  exit 0
fi

# Validate transition
SOURCE_DIR=$(dirname "$SOURCE")
SOURCE_FOLDER=$(basename "$SOURCE_DIR")

if [ "$SOURCE_FOLDER" = "backlog" ]; then
  echo "⚠️ $ITEM_ID already in backlog/ (skipped)"
  exit 0
fi

# Check if this is a parent/epic with children
ITEM_NAME=$(basename "$SOURCE")
CHILDREN=$(find project-hub/work -type f -iname "${ITEM_ID_UPPER}.*.md" 2>/dev/null)

# Execute move (parent first)
git mv "$SOURCE" project-hub/work/backlog/

if [ $? -eq 0 ]; then
  echo "✅ $ITEM_NAME → backlog/"

  # Move children if any exist
  if [ -n "$CHILDREN" ]; then
    CHILD_COUNT=0
    for CHILD in $CHILDREN; do
      git mv "$CHILD" project-hub/work/backlog/ 2>/dev/null
      if [ $? -eq 0 ]; then
        CHILD_NAME=$(basename "$CHILD")
        echo "   ↳ $CHILD_NAME"
        ((CHILD_COUNT++))
      fi
    done
  fi
fi
```

---

### When target is: `archive`

**For each resolved item ID, execute this EXACT bash command:**

```bash
ITEM_ID="<item-id>"
ITEM_ID_UPPER=$(echo "$ITEM_ID" | tr '[:lower:]' '[:upper:]')

# Find the work item (exact match for parent, not children)
SOURCE=$(find project-hub/work -type f -iname "${ITEM_ID}-*.md" 2>/dev/null | grep -v "/${ITEM_ID_UPPER}\." | head -1)
if [ -z "$SOURCE" ]; then
  SOURCE=$(find project-hub/work -type f -iname "${ITEM_ID_UPPER}-*.md" 2>/dev/null | grep -v "/${ITEM_ID_UPPER}\." | head -1)
fi

if [ -z "$SOURCE" ]; then
  echo "❌ Could not find work item: $ITEM_ID (skipped)"
  exit 0
fi

# Check if this is a parent/epic with children
ITEM_NAME=$(basename "$SOURCE")
CHILDREN=$(find project-hub/work -type f -iname "${ITEM_ID_UPPER}.*.md" 2>/dev/null)

# Execute move (parent first)
git mv "$SOURCE" project-hub/work/archive/

if [ $? -eq 0 ]; then
  echo "✅ $ITEM_NAME → archive/ (cancelled)"

  # Move children if any exist
  if [ -n "$CHILDREN" ]; then
    CHILD_COUNT=0
    for CHILD in $CHILDREN; do
      git mv "$CHILD" project-hub/work/archive/ 2>/dev/null
      if [ $? -eq 0 ]; then
        CHILD_NAME=$(basename "$CHILD")
        echo "   ↳ $CHILD_NAME"
        ((CHILD_COUNT++))
      fi
    done
  fi
fi
```

**After all items are moved:**

```
Optional: Add cancellation metadata (Status: Cancelled, Cancelled Date, Reason)
```

---

## Output Format

**Single item:**
```
✅ FEAT-141-move-command-batch-support.md → todo/
📊 WIP: 3/10 items in todo/
```

**Batch:**
```
Moving 3 items to todo/...

✅ FEAT-136-project-guidance-design-doc.md → todo/
✅ FEAT-137-plugin-project-guidance-commands.md → todo/
❌ Could not find work item: FEAT-999 (skipped)

📊 WIP: 5/10 items in todo/
```

---

## Examples

**Single work items:**
```
/spearit-framework:move feat-018 todo      # Move to todo
/spearit-framework:move BUG-042 doing      # Start work (with review)
/spearit-framework:move feat-018 done      # Complete work
```

**Batch — multiple items:**
```
/spearit-framework:move "FEAT-136, FEAT-137, FEAT-138" todo
/spearit-framework:move FEAT-136 FEAT-137 FEAT-138 todo
/spearit-framework:move "136, 137, 138" todo
/spearit-framework:move "FEAT-136, 137, CHORE-138" todo
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
- → backlog/todo/done/archive: 5-8 seconds per item (script execution)
- → doing (with AI review): 12-18 seconds (script + review)

**Note:** Performance is limited by Claude Code's architecture (API latency per command ~2-3 seconds unavoidable).

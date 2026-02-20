#!/usr/bin/env bash
# POC: move command logic
# Usage: bash project-hub/poc/SPIKE-142-move-command-test-harness/poc-move.sh <item-id-or-list> <target-folder>
#
# Create test items first:
#   powershell -ExecutionPolicy Bypass -File project-hub/poc/SPIKE-142-move-command-test-harness/Create-PocTestItems.ps1
#
# Reset between runs:
#   powershell -ExecutionPolicy Bypass -File project-hub/poc/SPIKE-142-move-command-test-harness/Reset-PocTests.ps1
#
# Test scenarios:
#   bash poc-move.sh FEAT-901 todo                   # single, full ID
#   bash poc-move.sh 902 todo                        # single, numeric ID only
#   bash poc-move.sh "FEAT-903, BUG-904" todo        # batch, full IDs
#   bash poc-move.sh "905, 906" todo                 # batch, numeric IDs
#   bash poc-move.sh "FEAT-907, 908" todo            # batch, mixed
#   bash poc-move.sh FEAT-909 todo                   # parent → children follow
#   bash poc-move.sh FEAT-911 todo                   # already in todo → skip
#   bash poc-move.sh "FEAT-901, FEAT-999" todo       # one found, one not → skip missing
#   bash poc-move.sh 901 todo                        # must NOT match FEAT-9010
#   bash poc-move.sh FEAT-910 todo                   # moves .md AND .txt
#   bash poc-move.sh FEAT-912 todo                   # blocked: done → todo

set -uo pipefail

# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------
VALID_FOLDERS="backlog todo doing done archive"

# ---------------------------------------------------------------------------
# Repo root guard
# ---------------------------------------------------------------------------
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || {
  echo "❌ Not inside a git repository."
  exit 1
}
cd "$REPO_ROOT"

WORK_DIR="project-hub/work"

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------
if [ $# -lt 2 ]; then
  echo "Usage: $0 <item-id-or-list> <target-folder>"
  echo "Valid targets: $VALID_FOLDERS"
  exit 1
fi

# Last argument is the target folder
TARGET="${!#}"

# Validate target
if ! echo "$VALID_FOLDERS" | grep -qw "$TARGET"; then
  echo "❌ Invalid target folder: '$TARGET'"
  echo "   Valid targets: $VALID_FOLDERS"
  exit 1
fi

# Everything except the last arg is the item list
ALL_ARGS=("$@")
ITEM_ARGS=("${ALL_ARGS[@]:0:${#ALL_ARGS[@]}-1}")
RAW_LIST="${ITEM_ARGS[*]}"

# Strip surrounding quotes, split on commas/spaces, filter out folder names
IFS=', ' read -ra TOKENS <<< "$RAW_LIST"
ITEM_IDS=()
for TOKEN in "${TOKENS[@]}"; do
  TOKEN=$(echo "$TOKEN" | tr -d '",')
  [ -z "$TOKEN" ] && continue
  echo "$VALID_FOLDERS" | grep -qw "$TOKEN" && continue
  ITEM_IDS+=("$TOKEN")
done

if [ ${#ITEM_IDS[@]} -eq 0 ]; then
  echo "❌ No item IDs provided."
  exit 1
fi

echo "Moving ${#ITEM_IDS[@]} item(s) to $TARGET/..."
echo ""

# ---------------------------------------------------------------------------
# ID normalization: strip type prefix, extract numeric ID
# FEAT-125 → 125, feat-125 → 125, 125 → 125
# ---------------------------------------------------------------------------
normalize_id() {
  echo "$1" | sed 's/^[A-Za-z]*[-_]*//' | tr '[:upper:]' '[:lower:]'
}

# ---------------------------------------------------------------------------
# Find all parent files for a numeric ID (any extension, excludes children)
# Pattern: ID preceded by -, followed by -, ., or end-of-string
# Excludes: ID followed by .{digit} (children)
# ---------------------------------------------------------------------------
find_parent() {
  local numeric_id="$1"
  find "$WORK_DIR" -type f \
    | grep -iE "[-]${numeric_id}([-.]|$)" \
    | grep -ivE "[-]${numeric_id}[.][0-9]" \
    || true
}

# ---------------------------------------------------------------------------
# Find all child files for a numeric ID
# Pattern: ID followed by .{digit}
# ---------------------------------------------------------------------------
find_children() {
  local numeric_id="$1"
  find "$WORK_DIR" -type f \
    | grep -iE "[-]${numeric_id}[.][0-9]" \
    || true
}

# ---------------------------------------------------------------------------
# WIP limit check (for doing target)
# ---------------------------------------------------------------------------
if [ "$TARGET" = "doing" ] && [ -f "$WORK_DIR/doing/.limit" ]; then
  LIMIT=$(cat "$WORK_DIR/doing/.limit" | tr -d '[:space:]')
  COUNT=$(find "$WORK_DIR/doing" -type f ! -name ".limit" | wc -l | tr -d '[:space:]')
  if [ "$COUNT" -ge "$LIMIT" ]; then
    echo "⚠️  WIP limit: $COUNT/$LIMIT items already in doing/"
    echo ""
  fi
fi

# ---------------------------------------------------------------------------
# Process each item
# ---------------------------------------------------------------------------
MOVED=0
SKIPPED=0
FAILED=0

move_item() {
  local raw_id="$1"
  local target="$2"
  local numeric_id
  numeric_id=$(normalize_id "$raw_id")

  local all_parents
  all_parents=$(find_parent "$numeric_id")

  if [ -z "$all_parents" ]; then
    echo "❌ Not found: '$raw_id' (ID=$numeric_id) — skipped"
    ((FAILED++)) || true
    return
  fi

  local source
  source=$(echo "$all_parents" | head -1)
  local item_name
  item_name=$(basename "$source")
  local source_folder
  source_folder=$(basename "$(dirname "$source")")

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

  local children
  children=$(find_children "$numeric_id")

  # Move all parent files (first gets ✅, siblings get +)
  local first_moved=false
  while IFS= read -r parent_file; do
    local pname move_note=""
    pname=$(basename "$parent_file")
    if git mv "$parent_file" "$WORK_DIR/$target/" 2>/dev/null; then
      :
    else
      local is_tracked
      git ls-files --error-unmatch "$parent_file" 2>/dev/null && is_tracked=true || is_tracked=false
      if [ "$is_tracked" = false ]; then
        if mv "$parent_file" "$WORK_DIR/$target/" 2>/dev/null; then
          move_note=" (untracked)"
        else
          echo "❌ mv failed for $pname"; ((FAILED++)) || true; continue
        fi
      else
        echo "❌ git mv failed for $pname"; ((FAILED++)) || true; continue
      fi
    fi
    if [ "$first_moved" = false ]; then
      echo "✅ $pname → $target/$move_note"
      ((MOVED++)) || true; first_moved=true
    else
      echo "   + $pname → $target/$move_note"
    fi
  done <<< "$all_parents"

  # Move children
  if [ -n "$children" ]; then
    while IFS= read -r child; do
      local child_name child_tracked
      child_name=$(basename "$child")
      if git mv "$child" "$WORK_DIR/$target/" 2>/dev/null; then
        echo "   ↳ $child_name"
      else
        git ls-files --error-unmatch "$child" 2>/dev/null && child_tracked=true || child_tracked=false
        if [ "$child_tracked" = false ]; then
          mv "$child" "$WORK_DIR/$target/" 2>/dev/null && echo "   ↳ $child_name (untracked)"
        else
          echo "   ↳ ❌ git mv failed for $child_name"
        fi
      fi
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

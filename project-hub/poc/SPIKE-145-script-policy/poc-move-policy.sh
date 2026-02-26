#!/usr/bin/env bash
# poc/SPIKE-145-script-policy/poc-move-policy.sh — POC: Policy checks in script layer
#
# PURPOSE: Evaluate moving policy enforcement from AI layer into the script.
#          Compare against framework/scripts/move.sh (AI-enforced policy).
#
# New hard blocks (vs move.sh):
#   - Transition matrix: invalid from→to exits 1
#   - Dependency check: Depends On field must be in done/ before → doing
#   - Acceptance criteria: no unchecked [ ] before → done
#
# Still AI layer:
#   - WIP limit: warning only (same as move.sh)
#   - Interactive recovery (fix criteria, set priority, etc.)
#   - Post-move actions (pre-impl review, session history, metadata prompts)
#
# Usage:
#   bash poc-move-policy.sh <item-id-or-list> <target-folder>
#
# Examples:
#   bash poc-move-policy.sh FEAT-145 doing
#   bash poc-move-policy.sh "FEAT-145, FEAT-146" todo
#   bash poc-move-policy.sh "145, 146" done

set -uo pipefail

# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------
VALID_FOLDERS="backlog todo doing done blocked archive releases"
FORCE=false

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

# Strip --force flag before positional parsing
FILTERED_ARGS=()
for arg in "$@"; do
  if [ "$arg" = "--force" ]; then
    FORCE=true
  else
    FILTERED_ARGS+=("$arg")
  fi
done
set -- "${FILTERED_ARGS[@]}"

if [ $# -lt 2 ]; then
  echo "Usage: $0 <item-id-or-list> <target-folder> [--force]"
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

# ---------------------------------------------------------------------------
# ID normalization: strip type prefix, extract numeric ID
# FEAT-125 → 125, feat-125 → 125, 125 → 125
# ---------------------------------------------------------------------------
normalize_id() {
  echo "$1" | sed 's/^[A-Za-z]*[-_]*//' | tr '[:upper:]' '[:lower:]'
}

# ---------------------------------------------------------------------------
# Find all parent files for a numeric ID (any extension, excludes children)
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
# ---------------------------------------------------------------------------
find_children() {
  local numeric_id="$1"
  find "$WORK_DIR" -type f \
    | grep -iE "[-]${numeric_id}[.][0-9]" \
    || true
}

# ---------------------------------------------------------------------------
# POLICY: Transition matrix
# Defines INVALID from→to pairs. Any transition not listed here is allowed.
# ---------------------------------------------------------------------------
INVALID_TRANSITIONS=(
  "backlog:doing"
  "done:backlog"
  "done:todo"
  "done:doing"
)

check_transition() {
  local source_folder="$1"
  local target="$2"
  local item_name="$3"
  local pair="${source_folder}:${target}"

  for invalid in "${INVALID_TRANSITIONS[@]}"; do
    if [ "$pair" = "$invalid" ]; then
      echo "❌ Invalid transition for $item_name: $source_folder/ → $target/"
      case "$pair" in
        "backlog:doing")
          echo "   Must commit to work first: backlog → todo → doing" ;;
        "done:backlog"|"done:todo"|"done:doing")
          echo "   Completed items cannot be reopened. Create a new work item instead." ;;
      esac
      return 1
    fi
  done
  return 0
}

# ---------------------------------------------------------------------------
# POLICY: Dependency check (for → doing)
# Reads "Depends On:" field from item file, verifies each dependency is in done/
# ---------------------------------------------------------------------------
check_dependencies() {
  local item_file="$1"
  local item_name
  item_name=$(basename "$item_file")

  local deps_line
  deps_line=$(grep -i "^\*\*Depends On:\*\*" "$item_file" 2>/dev/null || true)

  [ -z "$deps_line" ] && return 0

  # Extract dep IDs — everything after the field label, split on commas/spaces
  local deps_raw
  deps_raw=$(echo "$deps_line" | sed 's/\*\*Depends On:\*\*//i' | tr -d '*')

  local errors=0
  IFS=', ' read -ra DEP_TOKENS <<< "$deps_raw"
  for dep in "${DEP_TOKENS[@]}"; do
    dep=$(echo "$dep" | tr -d ' \t')
    [ -z "$dep" ] && continue

    local dep_numeric
    dep_numeric=$(normalize_id "$dep")

    # Check if dependency exists in done/
    local dep_in_done
    dep_in_done=$(find "$WORK_DIR/done" -type f \
      | grep -iE "[-]${dep_numeric}([-.]|$)" \
      | grep -ivE "[-]${dep_numeric}[.][0-9]" \
      || true)

    if [ -z "$dep_in_done" ]; then
      # Find where it actually is
      local dep_location
      dep_location=$(find_parent "$dep_numeric" | head -1)
      if [ -n "$dep_location" ]; then
        local dep_folder
        dep_folder=$(basename "$(dirname "$dep_location")")
        echo "❌ $item_name depends on $dep (currently in $dep_folder/) — must be in done/ first"
      else
        echo "❌ $item_name depends on $dep — not found in any folder"
      fi
      ((errors++)) || true
    fi
  done

  return $errors
}

# ---------------------------------------------------------------------------
# POLICY: Acceptance criteria check (for → done)
# Fails if any unchecked [ ] items exist in the file
# ---------------------------------------------------------------------------
check_acceptance_criteria() {
  local item_file="$1"
  local item_name
  item_name=$(basename "$item_file")

  local unchecked
  unchecked=$(grep -ce '- \[ \]' "$item_file" 2>/dev/null || true)
  unchecked=${unchecked:-0}

  if [ "$unchecked" -gt 0 ]; then
    echo "❌ $item_name has $unchecked unchecked acceptance criteria — cannot move to done/"
    echo "   Fix: mark all [ ] as [x] before completing"
    return 1
  fi
  return 0
}

# ---------------------------------------------------------------------------
# POLICY: Readiness check (for → todo)
# Warns if item has open issues: unresolved markers, placeholder text,
# unchecked criteria. Blocks unless --force is set.
# Returns number of issues found (caller decides whether to block).
# ---------------------------------------------------------------------------
check_readiness() {
  local item_file="$1"
  local item_name
  item_name=$(basename "$item_file")

  local issues=0

  # Unchecked acceptance criteria
  local unchecked
  unchecked=$(grep -ce '- \[ \]' "$item_file" 2>/dev/null; true)
  unchecked=$(echo "$unchecked" | tr -d '[:space:]')
  unchecked=${unchecked:-0}
  if [ "$unchecked" -gt 0 ]; then
    echo "   ⚠️  $unchecked unchecked criteria ([ ])"
    ((issues++)) || true
  fi

  # Unresolved inline markers
  local markers
  markers=$(grep -oiE "\b(TODO|TBD|DECIDE)\b" "$item_file" 2>/dev/null | sort -u | tr '\n' ' ' | sed 's/ $//' || true)
  if [ -n "$markers" ]; then
    echo "   ⚠️  Unresolved markers: $markers"
    ((issues++)) || true
  fi

  # Open options (Option A/B/C style)
  local options
  options=$(grep -cE "^\*\*Option [A-Z]" "$item_file" 2>/dev/null; true)
  options=$(echo "$options" | tr -d '[:space:]')
  options=${options:-0}
  if [ "$options" -gt 0 ]; then
    echo "   ⚠️  $options undecided option(s) (Option A/B/C...)"
    ((issues++)) || true
  fi

  # Placeholder text: [Some description], NNN in ID fields, YYYY-MM-DD
  local placeholders=0
  { grep -qE "\[.{3,40}\]" "$item_file" 2>/dev/null && ((placeholders++)); } || true
  { grep -qE "\bNNN\b" "$item_file" 2>/dev/null && ((placeholders++)); } || true
  { grep -qE "\bYYYY-MM-DD\b" "$item_file" 2>/dev/null && ((placeholders++)); } || true
  if [ "$placeholders" -gt 0 ]; then
    echo "   ⚠️  Unfilled placeholder text detected"
    ((issues++)) || true
  fi

  return $issues
}

# ---------------------------------------------------------------------------
# WIP limit warning (for → doing) — warning only, does not block
# ---------------------------------------------------------------------------
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

# ---------------------------------------------------------------------------
# Pre-flight policy checks for all items before moving any
# Fail fast: if any item fails policy, abort the whole batch
# ---------------------------------------------------------------------------
POLICY_ERRORS=0

for ID in "${ITEM_IDS[@]}"; do
  numeric_id=$(normalize_id "$ID")
  all_parents=$(find_parent "$numeric_id")

  if [ -z "$all_parents" ]; then
    echo "❌ Not found: '$ID' (ID=$numeric_id)"
    ((POLICY_ERRORS++)) || true
    continue
  fi

  source=$(echo "$all_parents" | head -1)
  source_folder=$(basename "$(dirname "$source")")

  # Skip already-in-target (not a policy error, handled gracefully later)
  [ "$source_folder" = "$TARGET" ] && continue

  # Transition matrix check
  check_transition "$source_folder" "$TARGET" "$(basename "$source")" || ((POLICY_ERRORS++)) || true

  # Dependency check (→ doing only)
  if [ "$TARGET" = "doing" ]; then
    check_dependencies "$source" || ((POLICY_ERRORS++)) || true
  fi

  # Acceptance criteria check (→ done only)
  if [ "$TARGET" = "done" ]; then
    check_acceptance_criteria "$source" || ((POLICY_ERRORS++)) || true
  fi

  # Readiness check (→ todo only)
  if [ "$TARGET" = "todo" ]; then
    set +e
    check_readiness "$source"
    readiness_issues=$?
    set -e
    if [ "$readiness_issues" -gt 0 ]; then
      if [ "$FORCE" = true ]; then
        echo "⚠️  $(basename "$source") has $readiness_issues readiness issue(s) — proceeding (--force)"
      else
        echo "❌ $(basename "$source") has $readiness_issues readiness issue(s) — use --force to queue anyway"
        ((POLICY_ERRORS++)) || true
      fi
    fi
  fi
done

if [ "$POLICY_ERRORS" -gt 0 ]; then
  echo ""
  echo "❌ $POLICY_ERRORS policy check(s) failed — no items moved"
  exit 1
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

  # Skip if already in target
  if [ "$source_folder" = "$target" ]; then
    echo "⚠️  $item_name already in $target/ — skipped"
    ((SKIPPED++)) || true
    return
  fi

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

# Final count
if [ -f "$WORK_DIR/$TARGET/.limit" ]; then
  LIMIT_TEXT=$(cat "$WORK_DIR/$TARGET/.limit" | tr -d '[:space:]')
else
  LIMIT_TEXT="∞"
fi
FINAL_COUNT=$(find "$WORK_DIR/$TARGET" -type f ! -name ".limit" | wc -l | tr -d '[:space:]')
echo "📊 $TARGET/: $FINAL_COUNT/$LIMIT_TEXT items"
echo "   ✅ moved: $MOVED  ⚠️  skipped: $SKIPPED  ❌ failed: $FAILED"

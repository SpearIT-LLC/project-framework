#!/usr/bin/env bash
# fw-move.sh — the namespace-aware move engine of the ADR-009 build (FEAT-195).
#
# ONE engine, one policy table per namespace. A namespace is a root folder where
# STATUS IS THE FIRST PATH SEGMENT under the root; anything deeper (year buckets,
# release buckets, artifact bundles <ID>/, child items) is grouping, never status.
# Records are files <PREFIX>-<n>-<slug>.md; a sibling folder <PREFIX>-<n>/ is the
# record's artifact bundle and always moves with it.
#
# Namespaces (root queues beside the board — ADR-009 D2 as amended by TASK-213):
#   operations — root operations/; prefixes INC, REQ; folders open, onhold, closed
#                transitions: open->onhold, onhold->open, open->closed, onhold->closed
#                closed is terminal; -> closed REQUIRES --resolution <code> and stamps
#                **Closed:** <today> and **Resolution:** <code>. No kanban gates apply.
#   kanban     — not active in this repo until the board crosses over (ADR-009 D5);
#                the live board uses the root /fw-move. The policy slot exists so the
#                crossover is a table entry, not a second engine.
#
# Usage:
#   fw-move.sh [--root <dir>] <id|"id, id, ..."> <target> [--resolution <code>]
#   fw-move.sh [--root <dir>] sweep          (operations: prior-year closed -> closed/YYYY/)
#   <id>: INC-012, REQ-3, or bare 12 (one shared sequence per namespace makes it unambiguous)
#         A list is comma- or space-separated; quote it. Items are validated and moved
#         one at a time, continuing past failures, with a summary at the end (BUG-215).
#   codes: resolved | cancelled | duplicate | no-fault-found | rejected
#   --resolution is per RECORD, so it is only accepted with a single id. A batch
#   -> closed prompts for each record's code in turn (BUG-215).
# --root is TESTING ONLY.
set -uo pipefail

ROOT=""
if [ "${1:-}" = "--root" ]; then ROOT="${2:?--root requires a directory}"; shift 2; fi
[ -n "$ROOT" ] || ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "Error: not inside a git repository" >&2; exit 1; }

OPS_ROOT="$ROOT/operations"
OPS_FOLDERS="open onhold closed"
OPS_TRANSITIONS="open:onhold onhold:open open:closed onhold:closed"
CODES="resolved cancelled duplicate no-fault-found rejected"

die() { echo "❌ $*" >&2; exit 1; }

# Per-item failure inside a batch: report, mark, and keep going (BUG-215).
FAILED=0; MOVED=0; SKIPPED=0
fail_item() { echo "❌ $*" >&2; FAILED=$((FAILED+1)); }

# git mv with untracked fallback (fixtures and fresh records are often untracked)
gmv() { git -C "$ROOT" mv "$1" "$2" 2>/dev/null || mv "$1" "$2"; }

# ---------------------------------------------------------------------------
# sweep: operations closed/*.md whose Closed: year < current year -> closed/YYYY/
# ---------------------------------------------------------------------------
if [ "${1:-}" = "sweep" ]; then
  [ -d "$OPS_ROOT/closed" ] || die "no operations closed/ folder at operations/"
  THIS_YEAR="$(date +%Y)"; MOVED=0
  for f in "$OPS_ROOT"/closed/*.md; do
    [ -f "$f" ] || continue
    y="$(grep -m1 -oE '^\*\*Closed:\*\* *[0-9]{4}' "$f" | grep -oE '[0-9]{4}$' || true)"
    [ -n "$y" ] || { echo "⚠️  skipped (no Closed: stamp): $(basename "$f")"; continue; }
    [ "$y" -lt "$THIS_YEAR" ] || continue
    mkdir -p "$OPS_ROOT/closed/$y"
    gmv "$f" "$OPS_ROOT/closed/$y/"
    b="$(basename "$f")"; bundle="$OPS_ROOT/closed/$(printf '%s' "$b" | grep -oE '^[A-Z]+-[0-9]+')"
    [ -d "$bundle" ] && gmv "$bundle" "$OPS_ROOT/closed/$y/"
    echo "✅ $b → closed/$y/"; MOVED=$((MOVED+1))
  done
  echo "Sweep done: $MOVED record(s) bucketed."
  exit 0
fi

# ---------------------------------------------------------------------------
# move: <id> <target> [--resolution <code>]
# ---------------------------------------------------------------------------
RESOLUTION=""
ARGS=()
while [ $# -gt 0 ]; do
  case "$1" in
    --resolution) RESOLUTION="${2:?--resolution requires a code}"; shift 2 ;;
    *) ARGS+=("$1"); shift ;;
  esac
done
[ ${#ARGS[@]} -ge 2 ] || { echo "Usage: fw-move.sh <id|\"id, id, ...\"> <open|onhold|closed> [--resolution <code>]  |  fw-move.sh sweep" >&2; exit 1; }

# The target is the LAST argument; everything before it is the id list. This lets an
# unquoted list work too: fw-move.sh 1 2 3 closed
TARGET="$(printf '%s' "${ARGS[${#ARGS[@]}-1]}" | tr '[:upper:]' '[:lower:]')"
unset 'ARGS[${#ARGS[@]}-1]'
IFS=', ' read -ra IDS <<< "${ARGS[*]}"
# Drop empties left by ", ," or stray whitespace
CLEAN=(); for t in "${IDS[@]:-}"; do [ -n "$t" ] && CLEAN+=("$t"); done; IDS=("${CLEAN[@]}")
[ ${#IDS[@]} -gt 0 ] || die "no ids given"

# --resolution is a per-record decision (BUG-215); it cannot speak for a list.
if [ ${#IDS[@]} -gt 1 ] && [ -n "$RESOLUTION" ]; then
  die "--resolution applies to one record; with a list, each record is prompted for its own code"
fi

# Namespace/target validation is list-wide: one target, one namespace policy.
[ -d "$OPS_ROOT" ] || die "no operations queue at operations/ — create the first record with /fw-new-ops-record"
echo "$OPS_FOLDERS" | grep -qw "$TARGET" || die "invalid target '$TARGET' — operations folders: $OPS_FOLDERS"

# ---------------------------------------------------------------------------
# move_one <id> — validate and move a single record. Never exits; returns non-zero
# on failure so the batch continues (BUG-215).
# ---------------------------------------------------------------------------
move_one() {
  local ID_IN="$1"
  local PREFIX NUM NUM_RE REL REC SOURCE BASE FULL_ID BUNDLE DEST RES TODAY

  PREFIX="$(printf '%s' "$ID_IN" | grep -oE '^[A-Za-z]+' | tr '[:lower:]' '[:upper:]' || true)"
  NUM="$(printf '%s' "$ID_IN" | grep -oE '[0-9]+$' || true)"
  [ -n "$NUM" ] || { fail_item "cannot parse an id from '$ID_IN'"; return 1; }
  case "$PREFIX" in
    ""|INC|REQ) : ;;
    *) fail_item "prefix '$PREFIX' belongs to the kanban namespace, which is not active in this repo until the board crosses over (ADR-009 D5) — use the root /fw-move"; return 1 ;;
  esac

  # Locate the record: status folder is the first segment; scan recursively (buckets)
  NUM_RE="$(printf '%s' "$NUM" | sed 's/^0*//')"
  REL="$(find "$OPS_ROOT" -type f -name '*.md' -printf '%P\n' | grep -E "(^|/)(INC|REQ)-0*${NUM_RE}-[^/]*\.md$" | head -1 || true)"
  [ -n "$REL" ] || { fail_item "no operations record with id $NUM"; return 1; }
  REC="$OPS_ROOT/$REL"; SOURCE="${REL%%/*}"; BASE="$(basename "$REC")"
  FULL_ID="$(printf '%s' "$BASE" | grep -oE '^[A-Z]+-[0-9]+')"

  if [ "$SOURCE" = "$TARGET" ]; then
    echo "⚠️  $FULL_ID is already in $TARGET/ — skipped"; SKIPPED=$((SKIPPED+1)); return 0
  fi
  [ "$SOURCE" = "closed" ] && { fail_item "$FULL_ID is closed — closed is terminal; open a new record instead"; return 1; }
  echo "$OPS_TRANSITIONS" | grep -qw "$SOURCE:$TARGET" || { fail_item "$FULL_ID: invalid transition $SOURCE → $TARGET (allowed: $OPS_TRANSITIONS)"; return 1; }

  # Resolution is per record. Single id may pass --resolution; a batch is prompted.
  RES="$RESOLUTION"
  if [ "$TARGET" = "closed" ]; then
    if [ -z "$RES" ]; then
      if [ -t 0 ]; then
        printf 'Resolution for %s (%s): ' "$FULL_ID" "$(echo "$CODES" | tr ' ' '|')" >&2
        read -r RES </dev/tty || RES=""
      else
        fail_item "$FULL_ID: → closed requires a resolution and no terminal is available to prompt (codes: $CODES)"; return 1
      fi
    fi
    [ -n "$RES" ] || { fail_item "$FULL_ID: → closed requires a resolution ($CODES)"; return 1; }
    echo "$CODES" | grep -qw "$RES" || { fail_item "$FULL_ID: unknown resolution '$RES' (codes: $CODES)"; return 1; }
  fi

  # Move record + bundle (bundle sits beside the record, named for the id)
  gmv "$REC" "$OPS_ROOT/$TARGET/" || { fail_item "move failed for $BASE"; return 1; }
  BUNDLE="$(dirname "$REC")/$FULL_ID"
  [ -d "$BUNDLE" ] && { gmv "$BUNDLE" "$OPS_ROOT/$TARGET/"; echo "   bundle $FULL_ID/ moved"; }
  DEST="$OPS_ROOT/$TARGET/$BASE"

  # Stamp on terminal move: fill existing Closed:/Resolution: lines, else insert after Opened:
  if [ "$TARGET" = "closed" ]; then
    TODAY="$(date +%Y-%m-%d)"
    if grep -qE '^\*\*Closed:\*\*' "$DEST"; then
      sed -i "s/^\*\*Closed:\*\*.*/**Closed:** $TODAY/" "$DEST"
    else
      sed -i "0,/^\*\*Opened:\*\*.*/s//&\n**Closed:** $TODAY/" "$DEST"
    fi
    if grep -qE '^\*\*Resolution:\*\*' "$DEST"; then
      sed -i "s/^\*\*Resolution:\*\*.*/**Resolution:** $RES/" "$DEST"
    else
      sed -i "0,/^\*\*Closed:\*\*.*/s//&\n**Resolution:** $RES/" "$DEST"
    fi
    git -C "$ROOT" add "$DEST" 2>/dev/null || true
    echo "✅ $BASE → closed/  (Closed: $TODAY, Resolution: $RES)"
  else
    echo "✅ $BASE → $TARGET/"
  fi
  MOVED=$((MOVED+1))
  return 0
}

for id in "${IDS[@]}"; do
  move_one "$id" || true
done

# Summary only for a batch; a single move already printed its own line.
if [ ${#IDS[@]} -gt 1 ]; then
  echo "📊 moved: $MOVED  skipped: $SKIPPED  failed: $FAILED"
fi
[ "$FAILED" -eq 0 ] || exit 1
exit 0

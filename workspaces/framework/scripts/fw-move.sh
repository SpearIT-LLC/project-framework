#!/usr/bin/env bash
# fw-move.sh — the namespace-aware move engine of the ADR-009 build (FEAT-195).
#
# ONE engine, one policy table per namespace. A namespace is a root folder where
# STATUS IS THE FIRST PATH SEGMENT under the root; anything deeper (year buckets,
# release buckets, artifact bundles <ID>/, child items) is grouping, never status.
# Records are files <PREFIX>-<n>-<slug>.md; a sibling folder <PREFIX>-<n>/ is the
# record's artifact bundle and always moves with it.
#
# Namespaces:
#   operations — prefixes INC, REQ; folders open, onhold, closed
#                transitions: open->onhold, onhold->open, open->closed, onhold->closed
#                closed is terminal; -> closed REQUIRES --resolution <code> and stamps
#                **Closed:** <today> and **Resolution:** <code>. No kanban gates apply.
#   kanban     — not active in this repo until the board crosses over (ADR-009 D5);
#                the live board uses the root /fw-move. The policy slot exists so the
#                crossover is a table entry, not a second engine.
#
# Usage:
#   fw-move.sh [--root <dir>] <id> <target> [--resolution <code>]
#   fw-move.sh [--root <dir>] sweep          (operations: prior-year closed -> closed/YYYY/)
#   <id>: INC-012, REQ-3, or bare 12 (one shared sequence per namespace makes it unambiguous)
#   codes: resolved | cancelled | duplicate | no-fault-found | rejected
# --root is TESTING ONLY.
set -uo pipefail

ROOT=""
if [ "${1:-}" = "--root" ]; then ROOT="${2:?--root requires a directory}"; shift 2; fi
[ -n "$ROOT" ] || ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "Error: not inside a git repository" >&2; exit 1; }

OPS_ROOT="$ROOT/workspaces/operations"
OPS_FOLDERS="open onhold closed"
OPS_TRANSITIONS="open:onhold onhold:open open:closed onhold:closed"
CODES="resolved cancelled duplicate no-fault-found rejected"

die() { echo "❌ $*" >&2; exit 1; }

# git mv with untracked fallback (fixtures and fresh records are often untracked)
gmv() { git -C "$ROOT" mv "$1" "$2" 2>/dev/null || mv "$1" "$2"; }

# ---------------------------------------------------------------------------
# sweep: operations closed/*.md whose Closed: year < current year -> closed/YYYY/
# ---------------------------------------------------------------------------
if [ "${1:-}" = "sweep" ]; then
  [ -d "$OPS_ROOT/closed" ] || die "no operations closed/ folder at workspaces/operations"
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
[ ${#ARGS[@]} -eq 2 ] || { echo "Usage: fw-move.sh <id> <open|onhold|closed> [--resolution <code>]  |  fw-move.sh sweep" >&2; exit 1; }
ID_IN="${ARGS[0]}"; TARGET="$(printf '%s' "${ARGS[1]}" | tr '[:upper:]' '[:lower:]')"

# Namespace by prefix (bare numeric → operations, the only active namespace here)
PREFIX="$(printf '%s' "$ID_IN" | grep -oE '^[A-Za-z]+' | tr '[:lower:]' '[:upper:]' || true)"
NUM="$(printf '%s' "$ID_IN" | grep -oE '[0-9]+$' || true)"
[ -n "$NUM" ] || die "cannot parse an id from '$ID_IN'"
case "$PREFIX" in
  ""|INC|REQ) NS="operations" ;;
  *) die "prefix '$PREFIX' belongs to the kanban namespace, which is not active in this repo until the board crosses over (ADR-009 D5) — use the root /fw-move" ;;
esac

[ -d "$OPS_ROOT" ] || die "no operations workspace at workspaces/operations"
echo "$OPS_FOLDERS" | grep -qw "$TARGET" || die "invalid target '$TARGET' — operations folders: $OPS_FOLDERS"

# Locate the record: status folder is the first segment; scan recursively (buckets)
NUM_RE="$(printf '%s' "$NUM" | sed 's/^0*//')"
REL="$(find "$OPS_ROOT" -type f -name '*.md' -printf '%P\n' | grep -E "(^|/)(INC|REQ)-0*${NUM_RE}-[^/]*\.md$" | head -1 || true)"
[ -n "$REL" ] || die "no operations record with id $NUM"
REC="$OPS_ROOT/$REL"; SOURCE="${REL%%/*}"; BASE="$(basename "$REC")"
FULL_ID="$(printf '%s' "$BASE" | grep -oE '^[A-Z]+-[0-9]+')"

[ "$SOURCE" = "$TARGET" ] && die "$FULL_ID is already in $TARGET/"
[ "$SOURCE" = "closed" ] && die "$FULL_ID is closed — closed is terminal; open a new record instead"
echo "$OPS_TRANSITIONS" | grep -qw "$SOURCE:$TARGET" || die "invalid transition $SOURCE → $TARGET (allowed: $OPS_TRANSITIONS)"

if [ "$TARGET" = "closed" ]; then
  [ -n "$RESOLUTION" ] || die "→ closed requires --resolution <code> ($CODES)"
  echo "$CODES" | grep -qw "$RESOLUTION" || die "unknown resolution '$RESOLUTION' (codes: $CODES)"
fi

# Move record + bundle (bundle sits beside the record, named for the id)
gmv "$REC" "$OPS_ROOT/$TARGET/" || die "move failed for $BASE"
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
    sed -i "s/^\*\*Resolution:\*\*.*/**Resolution:** $RESOLUTION/" "$DEST"
  else
    sed -i "0,/^\*\*Closed:\*\*.*/s//&\n**Resolution:** $RESOLUTION/" "$DEST"
  fi
  git -C "$ROOT" add "$DEST" 2>/dev/null || true
  echo "✅ $BASE → closed/  (Closed: $TODAY, Resolution: $RESOLUTION)"
else
  echo "✅ $BASE → $TARGET/"
fi

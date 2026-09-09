#!/usr/bin/env bash
# fw-move.sh — the namespace-aware move engine of the ADR-009 build (FEAT-195).
#
# ONE engine, one policy table per namespace. A namespace is a root folder where
# STATUS IS THE FIRST PATH SEGMENT under the root; anything deeper (year buckets,
# release buckets, artifact bundles <ID>/, child items) is grouping, never status.
# Records are files <PREFIX>-<n>-<slug>.md; a sibling folder <PREFIX>-<n>/ is the
# record's artifact bundle and always moves with it.
#
# THE NAMESPACE IS AN ARGUMENT, NEVER INFERRED (BUG-215). Each namespace gets its own
# command; the command passes its namespace in. Inferring it from the id shape or the
# target folder was rejected: a bare numeric silently meant operations, and inferring
# from the folder name would have made folder names globally unique across namespaces
# forever, enforced by nothing.
#
# Namespaces (root queues beside the board — ADR-009 D2 as amended by TASK-213):
#   operations — root operations/; prefixes INC, REQ; folders open, onhold, closed
#                closed is terminal; -> closed REQUIRES a resolution code (flag for one
#                record, prompt for a list) and stamps **Closed:** and **Resolution:**.
#   kanban     — root kanban/; the board. Folder set authored in the repo-structure
#                diagram (see project-hub/docs/diagram-index.md). NOT WIRED UP HERE:
#                the live board is project-hub/work/ under the root /fw-move until the
#                ADR-009 D5 crossover, which is a single atomic moment at graduation.
#                The policy row below is the crossover's landing spot; the gates it
#                needs (dependencies, acceptance criteria, ripeness) are not ported yet.
#
# Usage:
#   fw-move.sh [--root <dir>] <namespace> <id|"id, id, ..."> <target> [--resolution <code>]
#   fw-move.sh [--root <dir>] <namespace> sweep   (operations: prior-year closed -> closed/YYYY/)
#   <namespace>: operations | kanban
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

# ---------------------------------------------------------------------------
# POLICY TABLE — one row per namespace. Folders and transitions are data; the
# gates each namespace needs are functions (see below), because a dependency
# lookup and a resolution prompt are not expressible as a list.
# ---------------------------------------------------------------------------
NAMESPACES="operations kanban"

operations_ROOT="operations"
operations_FOLDERS="open onhold closed"
operations_TRANSITIONS="open:onhold onhold:open open:closed onhold:closed"
operations_TERMINAL="closed"

# kanban: authored folder set (repo-structure diagram). Transitions and gates are
# NOT yet ported from the old engine — see the header note. Declared so the
# crossover is a table edit, not a new engine.
kanban_ROOT="kanban"
kanban_FOLDERS="backlog blocked todo doing accept done cancelled"
kanban_TRANSITIONS=""
kanban_TERMINAL="done cancelled"

CODES="resolved cancelled duplicate no-fault-found rejected"

die() { echo "❌ $*" >&2; exit 1; }

# The namespace is the first positional argument. It is never inferred (BUG-215).
NS="${1:-}"
[ -n "$NS" ] || die "usage: fw-move.sh <namespace> <id|\"id, id, ...\"> <target> [--resolution <code>]  |  fw-move.sh <namespace> sweep"
echo "$NAMESPACES" | grep -qw "$NS" || die "unknown namespace '$NS' (known: $NAMESPACES)"
shift

# Resolve this namespace's policy row.
eval "NS_ROOT_REL=\"\$${NS}_ROOT\"; NS_FOLDERS=\"\$${NS}_FOLDERS\"; NS_TRANSITIONS=\"\$${NS}_TRANSITIONS\"; NS_TERMINAL=\"\$${NS}_TERMINAL\""
NS_ROOT="$ROOT/$NS_ROOT_REL"

# kanban is declared in the table but not wired: its transitions and gates are not
# ported, and the live board is project-hub/work/ under the root /fw-move until the
# ADR-009 D5 crossover. Refuse rather than half-move a card.
if [ -z "$NS_TRANSITIONS" ]; then
  die "namespace '$NS' is declared but not active in this engine yet — the live board is project-hub/work/ under the root /fw-move until the ADR-009 D5 crossover"
fi

# Per-item failure inside a batch: report, mark, and keep going (BUG-215).
FAILED=0; MOVED=0; SKIPPED=0
fail_item() { echo "❌ $*" >&2; FAILED=$((FAILED+1)); }

# git mv with untracked fallback (fixtures and fresh records are often untracked)
gmv() { git -C "$ROOT" mv "$1" "$2" 2>/dev/null || mv "$1" "$2"; }

# ---------------------------------------------------------------------------
# sweep: operations closed/*.md whose Closed: year < current year -> closed/YYYY/
# ---------------------------------------------------------------------------
if [ "${1:-}" = "sweep" ]; then
  [ "$NS" = "operations" ] || die "sweep is an operations action (prior-year closed records into closed/YYYY/); '$NS' has no equivalent"
  [ -d "$NS_ROOT/closed" ] || die "no operations closed/ folder at $NS_ROOT_REL/"
  THIS_YEAR="$(date +%Y)"; MOVED=0
  for f in "$NS_ROOT"/closed/*.md; do
    [ -f "$f" ] || continue
    y="$(grep -m1 -oE '^\*\*Closed:\*\* *[0-9]{4}' "$f" | grep -oE '[0-9]{4}$' || true)"
    [ -n "$y" ] || { echo "⚠️  skipped (no Closed: stamp): $(basename "$f")"; continue; }
    [ "$y" -lt "$THIS_YEAR" ] || continue
    mkdir -p "$NS_ROOT/closed/$y"
    gmv "$f" "$NS_ROOT/closed/$y/"
    b="$(basename "$f")"; bundle="$NS_ROOT/closed/$(printf '%s' "$b" | grep -oE '^[A-Z]+-[0-9]+')"
    [ -d "$bundle" ] && gmv "$bundle" "$NS_ROOT/closed/$y/"
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
[ ${#ARGS[@]} -ge 2 ] || { echo "Usage: fw-move.sh $NS <id|\"id, id, ...\"> <$(echo "$NS_FOLDERS" | tr ' ' '|')> [--resolution <code>]" >&2; exit 1; }

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
[ -d "$NS_ROOT" ] || die "no $NS queue at $NS_ROOT_REL/ — create the first record with /fw-new-ops-record"
echo "$NS_FOLDERS" | grep -qw "$TARGET" || die "invalid target '$TARGET' — $NS folders: $NS_FOLDERS"

# ---------------------------------------------------------------------------
# move_one <id> — validate and move a single record. Never exits; returns non-zero
# on failure so the batch continues (BUG-215).
# ---------------------------------------------------------------------------
move_one() {
  local ID_IN="$1"
  local PREFIX NUM NUM_RE REL REC SOURCE BASE FULL_ID BUNDLE DEST RES TODAY

  # The namespace came from the command line, so a bare numeric is unambiguous and a
  # prefix is decoration. Only the number is used to locate the record (BUG-215).
  NUM="$(printf '%s' "$ID_IN" | grep -oE '[0-9]+$' || true)"
  [ -n "$NUM" ] || { fail_item "cannot parse an id from '$ID_IN'"; return 1; }

  # Locate the record: status folder is the first segment; scan recursively (buckets)
  NUM_RE="$(printf '%s' "$NUM" | sed 's/^0*//')"
  REL="$(find "$NS_ROOT" -type f -name '*.md' -printf '%P\n' | grep -E "(^|/)[A-Za-z]+-0*${NUM_RE}-[^/]*\.md$" | head -1 || true)"
  [ -n "$REL" ] || { fail_item "no $NS record with id $NUM"; return 1; }
  REC="$NS_ROOT/$REL"; SOURCE="${REL%%/*}"; BASE="$(basename "$REC")"
  FULL_ID="$(printf '%s' "$BASE" | grep -oE '^[A-Z]+-[0-9]+')"

  if [ "$SOURCE" = "$TARGET" ]; then
    echo "⚠️  $FULL_ID is already in $TARGET/ — skipped"; SKIPPED=$((SKIPPED+1)); return 0
  fi
  if echo "$NS_TERMINAL" | grep -qw "$SOURCE"; then
    fail_item "$FULL_ID is in $SOURCE/ — that is terminal; open a new record instead"; return 1
  fi
  echo "$NS_TRANSITIONS" | grep -qw "$SOURCE:$TARGET" || { fail_item "$FULL_ID: invalid transition $SOURCE → $TARGET (allowed: $NS_TRANSITIONS)"; return 1; }

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
  gmv "$REC" "$NS_ROOT/$TARGET/" || { fail_item "move failed for $BASE"; return 1; }
  BUNDLE="$(dirname "$REC")/$FULL_ID"
  [ -d "$BUNDLE" ] && { gmv "$BUNDLE" "$NS_ROOT/$TARGET/"; echo "   bundle $FULL_ID/ moved"; }
  DEST="$NS_ROOT/$TARGET/$BASE"

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

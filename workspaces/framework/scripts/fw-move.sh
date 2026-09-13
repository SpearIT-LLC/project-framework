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
#                closed is terminal; -> closed REQUIRES a resolution code (--resolution,
#                which applies to the whole batch) and stamps **Closed:** and **Resolution:**.
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
#   --resolution applies to the WHOLE BATCH (BUG-215, superseding the 2026-09-07 design).
#   THE ENGINE NEVER PROMPTS. A -> closed with no --resolution is refused per record,
#   naming the valid codes; the human supplies one and runs again — the kanban experience.
#   Behaviour is identical with or without a terminal, which is what headless use needs.
#   A batch close shares one code because a batch close happens precisely when the records
#   share a root cause; the per-record *reason* lives in each record's Outcome section.
# --root is TESTING ONLY.
set -uo pipefail

ROOT=""
if [ "${1:-}" = "--root" ]; then ROOT="${2:?--root requires a directory}"; shift 2; fi
[ -n "$ROOT" ] || ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "Error: not inside a git repository" >&2; exit 1; }

# ---------------------------------------------------------------------------
# POLICY TABLE — one row per namespace. Folders and transitions are data; the
# gates each namespace needs are functions (see below), because a dependency
# lookup is not expressible as a list.
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

# ---------------------------------------------------------------------------
# REPORT (BUG-225, merged into BUG-215). One formatter, used by every namespace,
# so the kanban row inherits the report by construction rather than diverging.
#
# Status first, fixed-width, left-aligned: the eye scans one column. A trailing
# status cannot align without padding every filename. The bundle is INLINE on its
# own record's row — that is what removes the misattribution, rather than
# re-ordering around it: a free-floating bundle line can no longer be attached to
# the wrong record by indentation. A failure's reason is on its own row, adjacent,
# because the report is read closely exactly when something failed.
#
# DECIDED (BUG-225's open question): the reason goes on the row, and ONLY on the row.
# A stderr copy was tried and removed — every failure printed twice and the two streams
# interleaved on a terminal, which is the detached-reason problem this card exists to fix.
# `die` still writes to stderr: that is a usage error about the whole invocation, not a
# per-record outcome, and it is the only thing a caller needs to read off stderr.
# ---------------------------------------------------------------------------
row() { # row <OK|FAILED|SKIPPED> <text>
  printf '  %-8s %s\n' "$1" "$2"
}
fail_item() { row FAILED "$*"; FAILED=$((FAILED+1)); }

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

# --resolution applies to the whole batch (BUG-215, superseding 2026-09-07). A batch
# close happens precisely when the records share a root cause, and sharing a cause means
# sharing a classification. Records that genuinely differ are closed separately.
# Validate the code ONCE, here, rather than per record: an unknown code is a usage error
# in the invocation, not a property of any one record.
if [ -n "$RESOLUTION" ]; then
  echo "$CODES" | grep -qw "$RESOLUTION" || die "unknown resolution '$RESOLUTION' (codes: $CODES)"
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
  local PREFIX NUM NUM_RE REL REC SOURCE BASE FULL_ID BUNDLE BUNDLE_NOTE DEST RES TODAY

  # The namespace came from the command line, so a bare numeric is unambiguous and a
  # prefix is decoration. Only the number is used to locate the record (BUG-215).
  NUM="$(printf '%s' "$ID_IN" | grep -oE '[0-9]+$' || true)"
  [ -n "$NUM" ] || { fail_item "$ID_IN — cannot parse an id"; return 1; }

  # Locate the record: status folder is the first segment; scan recursively (buckets)
  NUM_RE="$(printf '%s' "$NUM" | sed 's/^0*//')"
  REL="$(find "$NS_ROOT" -type f -name '*.md' -printf '%P\n' | grep -E "(^|/)[A-Za-z]+-0*${NUM_RE}-[^/]*\.md$" | head -1 || true)"
  [ -n "$REL" ] || { fail_item "$ID_IN — no $NS record with that id"; return 1; }
  REC="$NS_ROOT/$REL"; SOURCE="${REL%%/*}"; BASE="$(basename "$REC")"
  FULL_ID="$(printf '%s' "$BASE" | grep -oE '^[A-Z]+-[0-9]+')"

  if [ "$SOURCE" = "$TARGET" ]; then
    row SKIPPED "$BASE — already in $TARGET/"; SKIPPED=$((SKIPPED+1)); return 0
  fi
  if echo "$NS_TERMINAL" | grep -qw "$SOURCE"; then
    fail_item "$BASE — in $SOURCE/, which is terminal; open a new record instead"; return 1
  fi
  echo "$NS_TRANSITIONS" | grep -qw "$SOURCE:$TARGET" || { fail_item "$BASE — invalid transition $SOURCE → $TARGET (allowed: $NS_TRANSITIONS)"; return 1; }

  # THE ENGINE NEVER PROMPTS (BUG-215). A → closed with no code is refused, per record,
  # naming what is missing and the valid codes; the human supplies one and runs again.
  # The code was validated once at parse time, so there is nothing to re-check here.
  # This is identical with or without a terminal — no `read`, no /dev/tty, no `[ -t 0 ]`.
  RES="$RESOLUTION"
  if [ "$TARGET" = "closed" ] && [ -z "$RES" ]; then
    fail_item "$BASE — → closed requires a resolution: pass --resolution <$(echo "$CODES" | tr ' ' '|')>"
    return 1
  fi

  # Move record + bundle (bundle sits beside the record, named for the id).
  # The bundle is recorded, not printed: it goes INLINE on this record's row below,
  # which is what stops it being attributed to the record above (BUG-225).
  gmv "$REC" "$NS_ROOT/$TARGET/" || { fail_item "$BASE — move failed"; return 1; }
  BUNDLE="$(dirname "$REC")/$FULL_ID"
  BUNDLE_NOTE=""
  [ -d "$BUNDLE" ] && { gmv "$BUNDLE" "$NS_ROOT/$TARGET/"; BUNDLE_NOTE="  (bundle $FULL_ID/)"; }
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
    row OK "$BASE — Closed: $TODAY, Resolution: $RES$BUNDLE_NOTE"
  else
    # A batch prints its destination once in the header; a single move has no header,
    # so it carries the destination on its own row (BUG-225: single moves unchanged).
    if [ "${#IDS[@]}" -gt 1 ]; then
      row OK "$BASE$BUNDLE_NOTE"
    else
      row OK "$BASE → $TARGET/$BUNDLE_NOTE"
    fi
  fi
  MOVED=$((MOVED+1))
  return 0
}

# A batch gets a header and a summary; a single move keeps its own one-line output
# (BUG-225 — unchanged behaviour for the single case).
[ ${#IDS[@]} -gt 1 ] && echo "Move → $TARGET/"

for id in "${IDS[@]}"; do
  move_one "$id" || true
done

# Summary only for a batch. The exact shape of this line is asserted verbatim by
# UAT-33 and UAT-35 — do not reformat it without updating those cases.
if [ ${#IDS[@]} -gt 1 ]; then
  echo "📊 moved: $MOVED  skipped: $SKIPPED  failed: $FAILED"
fi
[ "$FAILED" -eq 0 ] || exit 1
exit 0

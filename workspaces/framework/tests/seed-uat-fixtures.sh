#!/usr/bin/env bash
# seed-uat-fixtures.sh — create mock records for UAT of the move engine.
#
# ONE authored copy, pointed at whatever repo you are testing (ADR-008). Never copy
# this script into the target repo: a second copy goes stale the moment fw-move.sh
# changes, which is the class of bug BUG-215 itself was.
#
# Ids are the RESERVED 900 BLOCK. Real records never use it, so fixtures and live
# records coexist and --reset can remove fixtures without touching real work.
#
# Usage:
#   seed-uat-fixtures.sh --root <repo> [operations|kanban] [--reset] [--force]
#   seed-uat-fixtures.sh --root ../framework-uat operations
#
# The namespace is an ARGUMENT, never inferred (BUG-215). Omitted, it is prompted.
set -uo pipefail

ROOT=""; NS=""; RESET=0; FORCE=0
while [ $# -gt 0 ]; do
  case "$1" in
    --root)  ROOT="${2:?--root requires a directory}"; shift 2 ;;
    --reset) RESET=1; shift ;;
    --force) FORCE=1; shift ;;
    -h|--help) sed -n '2,14p' "$0"; exit 0 ;;
    *)       NS="$1"; shift ;;
  esac
done

die() { echo "❌ $*" >&2; exit 1; }

[ -n "$ROOT" ] || die "--root <repo> is required (the repo under test, e.g. ../framework-uat)"
[ -d "$ROOT" ] || die "no such directory: $ROOT"
ROOT="$(cd "$ROOT" && pwd)"
git -C "$ROOT" rev-parse --show-toplevel >/dev/null 2>&1 || die "not a git repository: $ROOT"

# Refuse to seed this repo's own live board by accident.
SELF="$(cd "$(dirname "$0")/../../.." && pwd)"
if [ "$ROOT" = "$SELF" ] && [ "$FORCE" -eq 0 ]; then
  die "refusing to seed the framework repo's own tree — pass --root <uat repo> (or --force if you mean it)"
fi

# Namespace: prompt rather than guess when absent.
if [ -z "$NS" ]; then
  if [ -t 0 ]; then
    printf 'Namespace (operations|kanban): ' >&2
    read -r NS </dev/tty || NS=""
  else
    die "no namespace given and no terminal to prompt (operations|kanban)"
  fi
fi

case "$NS" in
  operations) ;;
  kanban)
    die "kanban fixtures are not useful yet: fw-move.sh refuses the namespace before it reads
    any record (kanban_TRANSITIONS is empty until the ADR-009 D5 crossover), so seeded cards
    would change nothing. Seed kanban once the crossover ports its gates." ;;
  *) die "unknown namespace '$NS' (operations|kanban)" ;;
esac

QUEUE="$ROOT/operations"
[ -d "$QUEUE" ] || die "no operations queue at $ROOT/operations — create the first record with /fw-new-ops-record"

LAST_YEAR=$(( $(date +%Y) - 1 ))
TODAY="$(date +%Y-%m-%d)"

# --- reset: remove only the 900 block -------------------------------------
if [ "$RESET" -eq 1 ]; then
  N=0
  while IFS= read -r p; do
    [ -n "$p" ] || continue
    git -C "$ROOT" rm -rq --ignore-unmatch "$p" 2>/dev/null || rm -rf "$ROOT/$p"
    N=$((N+1))
  done < <(cd "$ROOT" && find operations -regextype posix-extended \
             -regex '.*/(INC|REQ)-9[0-9]{2}(-[^/]*\.md|)$' -printf '%p\n' 2>/dev/null)
  echo "🧹 removed $N fixture path(s) from $ROOT/operations"
  exit 0
fi

# --- fixture table --------------------------------------------------------
# folder | id | slug | closed-stamp (blank = none)
FIXTURES="
open|INC-901|batch-item-one|
open|INC-902|batch-item-two|
open|REQ-903|batch-item-three|
open|INC-904|partial-failure-survivor|
onhold|REQ-905|already-in-onhold|
closed|INC-906|terminal-record|$TODAY
closed|INC-907|sweep-candidate|$LAST_YEAR-11-14
open|INC-9010|substring-trap|
"

mk_record() {
  local folder="$1" id="$2" slug="$3" closed="$4"
  local kind="Incident"; case "$id" in REQ-*) kind="Request" ;; esac
  local f="$QUEUE/$folder/$id-$slug.md"
  {
    printf '# %s: %s\n\n' "$kind" "$(printf '%s' "$slug" | tr '-' ' ')"
    printf '**ID:** %s\n' "$id"
    printf '**Kind:** %s\n' "$kind"
    printf '**Opened:** %s\n' "$TODAY"
    [ -n "$closed" ] && printf '**Closed:** %s\n**Resolution:** resolved\n' "$closed"
    printf '\n---\n\nUAT fixture — reserved id block 900-999. Safe to delete with --reset.\n'
  } > "$f"
  echo "  created $folder/$id-$slug.md"
}

echo "Seeding operations fixtures into $ROOT/operations"
printf '%s\n' "$FIXTURES" | while IFS='|' read -r folder id slug closed; do
  [ -n "${folder:-}" ] || continue
  mkdir -p "$QUEUE/$folder"
  mk_record "$folder" "$id" "$slug" "$closed"
done

# Bundle on INC-902 — must travel with its record on every move (UAT-33).
mkdir -p "$QUEUE/open/INC-902"
printf 'UAT fixture attachment for INC-902.\n' > "$QUEUE/open/INC-902/evidence.txt"
echo "  created open/INC-902/evidence.txt (bundle)"

# Bundle on the sweep candidate — must travel into the year bucket.
mkdir -p "$QUEUE/closed/INC-907"
printf 'UAT fixture attachment for INC-907.\n' > "$QUEUE/closed/INC-907/evidence.txt"
echo "  created closed/INC-907/evidence.txt (bundle)"

# git mv needs the files tracked; stage them.
git -C "$ROOT" add operations >/dev/null 2>&1 || true

cat <<EOF

✅ Fixtures staged in $ROOT/operations

  open/    INC-901, INC-902 (+bundle), REQ-903, INC-904, INC-9010
  onhold/  REQ-905
  closed/  INC-906, INC-907 (+bundle, Closed: $LAST_YEAR)

Live records 1-6 are untouched. Remove fixtures with:
  bash $0 --root $ROOT operations --reset
EOF

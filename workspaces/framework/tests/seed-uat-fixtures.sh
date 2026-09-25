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
  operations|kanban) ;;
  *) die "unknown namespace '$NS' (operations|kanban)" ;;
esac

# Per-namespace fixture shape. Both use the reserved 900-999 id block, so --reset
# never touches a live record. Generalized from operations-only by FEAT-229.1.
case "$NS" in
  operations)
    QUEUE="$ROOT/operations"
    ID_RE='(INC|REQ)'
    CREATE_HINT="/fw-new-ops-record" ;;
  kanban)
    QUEUE="$ROOT/kanban"
    ID_RE='(FEAT|BUG|TECH|TASK|SPIKE)'
    CREATE_HINT="/fw-new" ;;
esac
[ -d "$QUEUE" ] || die "no $NS queue at $QUEUE — create the first record with $CREATE_HINT"

LAST_YEAR=$(( $(date +%Y) - 1 ))
TODAY="$(date +%Y-%m-%d)"

# --- reset: remove only the 900 block -------------------------------------
if [ "$RESET" -eq 1 ]; then
  N=0
  # 9[0-9]{2,3}: the substring-trap fixtures (INC-9010, FEAT-9010) are four digits.
  # (\.[0-9]+)*: dotted family fixtures. Spikes leave the board for history/spikes/
  # on a terminal move (FEAT-229.3), so the kanban reset looks there too.
  SCAN="$NS"; [ "$NS" = "kanban" ] && [ -d "$ROOT/history/spikes" ] && SCAN="$NS history/spikes"
  while IFS= read -r p; do
    [ -n "$p" ] || continue
    [ -e "$ROOT/$p" ] || continue   # already removed with its bundle folder
    # --ignore-unmatch succeeds on an UNTRACKED path without removing it (a card the
    # UAT created with /fw-new, never staged), so check the disk, not the exit code.
    git -C "$ROOT" rm -rq --ignore-unmatch "$p" 2>/dev/null
    [ -e "$ROOT/$p" ] && rm -rf "$ROOT/$p"
    N=$((N+1))
  done < <(cd "$ROOT" && find $SCAN -regextype posix-extended \
             -regex ".*/${ID_RE}-9[0-9]{2,3}(\.[0-9]+)*(-[^/]*\.md|)$" -printf '%p\n' 2>/dev/null)
  echo "🧹 removed $N fixture path(s) from $QUEUE"
  exit 0
fi

# --- fixture table --------------------------------------------------------
# folder | id | slug | 4th field (operations: closed-stamp · kanban: criteria state)
if [ "$NS" = "operations" ]; then
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
else
# kanban: the 4th field seeds the ACCEPTANCE CRITERIA state — one fixture per
# checkbox state (TECH-177's six), read by the gates (FEAT-229.2). `dep:<ID>` seeds
# all-done criteria plus a **Depends On:** line, for the dependency gate and the
# family union rule (FEAT-229.4). FEAT-912 is a dotted family; SPIKE-913/914 are
# the research and POC spikes that archive to history/spikes/ (FEAT-229.3).
FIXTURES="
backlog|FEAT-901|batch-item-one|open
backlog|BUG-902|batch-item-two|open
backlog|TECH-903|batch-item-three|open
todo|FEAT-904|partial-failure-survivor|open
todo|TASK-905|already-in-todo|open
doing|FEAT-906|all-criteria-done|done
doing|BUG-907|in-progress-criterion|inprogress
doing|TECH-908|cancelled-criterion|cancelled
doing|TASK-909|question-marker|question
doing|SPIKE-910|hold-marker|hold
doing|FEAT-911|quoted-marker-in-prose|quoted
backlog|FEAT-9010|substring-trap|open
todo|FEAT-912|family-parent|done
todo|FEAT-912.1|family-child-one|done
todo|FEAT-912.2|family-child-with-dep|dep:FEAT-906
todo|TASK-915|depends-off-board|dep:FEAT-999
todo|SPIKE-914|poc-spike|done
doing|SPIKE-913|research-spike|done
"
fi

mk_record() {
  local folder="$1" id="$2" slug="$3" extra="$4"
  local f="$QUEUE/$folder/$id-$slug.md"

  if [ "$NS" = "operations" ]; then
    local kind="Incident"; case "$id" in REQ-*) kind="Request" ;; esac
    {
      printf '# %s: %s\n\n' "$kind" "$(printf '%s' "$slug" | tr '-' ' ')"
      printf '**ID:** %s\n' "$id"
      printf '**Kind:** %s\n' "$kind"
      printf '**Opened:** %s\n' "$TODAY"
      [ -n "$extra" ] && printf '**Closed:** %s\n**Resolution:** resolved\n' "$extra"
      printf '\n---\n\nUAT fixture — reserved id block 900-999. Safe to delete with --reset.\n'
    } > "$f"
  else
    # kanban. The criteria block is what the done-gate will read (FEAT-229.2): one
    # fixture per checkbox state so every branch of TECH-177's contract is
    # exercisable. Semantics: skills/fw-checkbox-states/SKILL.md.
    local crit dep=""
    case "$extra" in dep:*) dep="${extra#dep:}"; extra="done" ;; esac
    case "$extra" in
      done)       crit='- [x] A finished criterion' ;;
      inprogress) crit='- [x] A finished criterion
- [/] A criterion still in progress — must BLOCK the move to done' ;;
      cancelled)  crit='- [x] A finished criterion
- [-] A cancelled criterion — must PASS to done, by design' ;;
      question)   crit='- [x] A finished criterion
- [?] Needs information — must BLOCK the move to doing
      **Question:** what the run needs to know before it can proceed.' ;;
      hold)       crit='- [x] A finished criterion
- [h] Blocked — must BLOCK the move to doing
      **Hold:** what prevents completion of this one line.' ;;
      quoted)     crit='- [x] A finished criterion

  TECH-166 item 4 regression fixture: the marker `- [ ]` is QUOTED in prose here
  and must NOT be counted as a live unchecked criterion.' ;;
      *)          crit='- [ ] An open criterion' ;;
    esac
    {
      printf '# Fixture: %s\n\n' "$(printf '%s' "$slug" | tr '-' ' ')"
      printf '**ID:** %s\n' "$id"
      printf '**Type:** %s\n' "${id%%-*}"
      printf '**Created:** %s\n' "$TODAY"
      printf '**Completed:**\n'
      [ -n "$dep" ] && printf '**Depends On:** %s\n' "$dep"
      printf '\n---\n\n## Acceptance Criteria\n\n%s\n' "$crit"
      printf '\n---\n\nUAT fixture — reserved id block 900-999. Safe to delete with --reset.\n'
    } > "$f"
  fi
  echo "  created $folder/$id-$slug.md"
}

echo "Seeding $NS fixtures into $QUEUE"
printf '%s\n' "$FIXTURES" | while IFS='|' read -r folder id slug extra; do
  [ -n "${folder:-}" ] || continue
  mkdir -p "$QUEUE/$folder"
  mk_record "$folder" "$id" "$slug" "$extra"
done

# Bundles — a bundle sits beside its record and must travel with it on every move.
if [ "$NS" = "operations" ]; then
  mkdir -p "$QUEUE/open/INC-902"
  printf 'UAT fixture attachment for INC-902.\n' > "$QUEUE/open/INC-902/evidence.txt"
  echo "  created open/INC-902/evidence.txt (bundle)"

  # Bundle on the sweep candidate — must travel into the year bucket.
  mkdir -p "$QUEUE/closed/INC-907"
  printf 'UAT fixture attachment for INC-907.\n' > "$QUEUE/closed/INC-907/evidence.txt"
  echo "  created closed/INC-907/evidence.txt (bundle)"
else
  mkdir -p "$QUEUE/backlog/BUG-902"
  printf 'UAT fixture attachment for BUG-902.\n' > "$QUEUE/backlog/BUG-902/evidence.txt"
  echo "  created backlog/BUG-902/evidence.txt (bundle)"

  # A dotted child's bundle is named for the FULL id — it must travel with the
  # family and never resolve to the parent's bundle (BUG-241, second half).
  mkdir -p "$QUEUE/todo/FEAT-912.1"
  printf 'UAT fixture attachment for FEAT-912.1.\n' > "$QUEUE/todo/FEAT-912.1/notes.txt"
  echo "  created todo/FEAT-912.1/notes.txt (child bundle)"

  # A POC spike is a record plus working code; the bundle is what makes it one.
  mkdir -p "$QUEUE/todo/SPIKE-914"
  printf '#!/usr/bin/env bash\necho "UAT fixture POC for SPIKE-914"\n' > "$QUEUE/todo/SPIKE-914/poc.sh"
  echo "  created todo/SPIKE-914/poc.sh (POC bundle)"
fi

# git mv needs the files tracked; stage them.
git -C "$ROOT" add "$NS" >/dev/null 2>&1 || true

if [ "$NS" = "operations" ]; then
cat <<EOF

✅ Fixtures staged in $QUEUE

  open/    INC-901, INC-902 (+bundle), REQ-903, INC-904, INC-9010
  onhold/  REQ-905
  closed/  INC-906, INC-907 (+bundle, Closed: $LAST_YEAR)

Live records 1-6 are untouched. Remove fixtures with:
  bash $0 --root $ROOT operations --reset
EOF
else
cat <<EOF

✅ Fixtures staged in $QUEUE

  backlog/ FEAT-901, BUG-902 (+bundle), TECH-903, FEAT-9010
  todo/    FEAT-904, TASK-905 · FEAT-912 + .1 (+bundle) + .2 (Depends On FEAT-906)
           TASK-915 (Depends On FEAT-999, off-board) · SPIKE-914 (POC, +bundle)
  doing/   FEAT-906 (all done), BUG-907 ([/]), TECH-908 ([-]),
           TASK-909 ([?]), SPIKE-910 ([h]), FEAT-911 (quoted marker),
           SPIKE-913 (research)

The doing/ set is one fixture per checkbox state, read by the gates. FEAT-911 is
the TECH-166 item 4 regression: a marker quoted in prose that must NOT count as a
live criterion. doing/ starts over its limit of 2 on purpose: WIP warns, never
blocks.

Live cards are untouched. Remove fixtures with:
  bash $0 --root $ROOT kanban --reset
EOF
fi

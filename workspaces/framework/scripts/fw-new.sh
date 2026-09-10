#!/usr/bin/env bash
# fw-new.sh — the create gate for board items (FEAT-175). The create-side twin
# of fw-move.sh, and the fifth and last create gate (workspaces, ops records,
# contacts, kb domains being the other four).
#
# TWO JOBS, and deliberately no others: it ASSIGNS THE ID (via fw-next-id.sh —
# never its own scan) and ENFORCES THE ACCEPTED TYPE. Discovery, scoping and
# writing the card stay with the AI and the user; this script has no opinion
# about whether the right type was chosen, only whether it exists.
#
# STRICT SCRIPT, LENIENT AI (ADR-006 D6). The accepted set is parsed from the
# TYPES: line in templates/records/work-item.md — the single source of truth,
# which lives in the template because a new type needs a template that supports
# it (ADR-008). This script does NO alias mapping and NO fuzzy matching:
#   - Prefix normalization (FEATURE->FEAT) and semantic suggestion (chore->TECH)
#     belong to the AI layer in commands/fw-new.md, always as a suggestion the
#     user confirms, never a silent substitution.
#   - Fuzzy matching here would be safe only by property of today's five names,
#     not by property of the rule: add a type that prefixes another and it
#     silently picks wrong, and whoever added a line to the list had no reason
#     to think about prefix collisions. A create gate bakes its answer into a
#     filename that lives forever, so rejection (one round-trip) is cheap and a
#     wrong type committed and cross-referenced is not.
# A corrected type re-enters through this gate on its own merits. Nothing is
# admitted by AI assertion.
#
# The rejection message is the primary education surface — see reject() below.
#
# Usage: fw-new.sh [--root <dir>] <type> <slug> [--title <title>] [--parent <id>]
#   type: FEAT | BUG | TECH | TASK | SPIKE (case-insensitive)
#   slug: plain file-name fragment, e.g. csv-export-for-reports
#   --parent <id> mints a DOTTED child id under <id> (FEAT-021.1) — tight
#     coupling: the child moves with its parent and counts as the same one item
#     against WIP. For work that merely came FROM a parent, omit this and use
#     the record's Parent: field instead (provenance; stands alone).
# Lands the item in kanban/backlog/ — creating the queue scaffold on first use.
# --root is TESTING ONLY.
set -euo pipefail

ROOT=""
if [ "${1:-}" = "--root" ]; then ROOT="${2:?--root requires a directory}"; shift 2; fi

TYPE_IN=""; SLUG=""; TITLE=""; PARENT=""
while [ $# -gt 0 ]; do
  case "$1" in
    --title)  TITLE="${2:?--title requires a value}"; shift 2 ;;
    --parent) PARENT="${2:?--parent requires an id}"; shift 2 ;;
    --root)   echo "Error: --root must come first" >&2; exit 1 ;;
    -*)       echo "Error: unknown option '$1'" >&2; exit 1 ;;
    *)
      if   [ -z "$TYPE_IN" ]; then TYPE_IN="$1"
      elif [ -z "$SLUG" ];    then SLUG="$1"
      else echo "Error: unexpected argument '$1'" >&2; exit 1; fi
      shift ;;
  esac
done
[ -n "$TYPE_IN" ] && [ -n "$SLUG" ] || {
  echo "Usage: fw-new.sh <type> <slug> [--title <title>] [--parent <id>]" >&2; exit 1; }

case "$SLUG" in
  */*|*\\*|.|..|-*) echo "Error: slug must be a plain file-name fragment, got '$SLUG'" >&2; exit 1 ;;
esac

[ -n "$ROOT" ] || ROOT="$(git rev-parse --show-toplevel)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Template + the accepted set it carries -------------------------------
# Project override first, same channel as every other record template.
TPL="$ROOT/.claude/templates/records/work-item.md"
[ -f "$TPL" ] || TPL="$SCRIPT_DIR/../templates/records/work-item.md"
[ -f "$TPL" ] || { echo "Error: work-item template not found (looked for .claude/templates/records/work-item.md and $SCRIPT_DIR/../templates/records/work-item.md)" >&2; exit 1; }

# The SoT: the TYPES: line inside the marked block in the template header.
# Read ONLY from between the markers, so a card's pointer prose (which mentions
# "the TYPES: line") can never be mistaken for the list itself. Fail loudly on
# anything unexpected — a missing or malformed list must never quietly degrade
# into "accept anything", which is the one failure this gate exists to prevent.
[ "$(grep -c '^TYPES-SOT-BEGIN$' "$TPL")" = "1" ] && [ "$(grep -c '^TYPES-SOT-END$' "$TPL")" = "1" ] || {
  echo "Error: $TPL must contain exactly one TYPES-SOT-BEGIN and one TYPES-SOT-END line." >&2
  echo "       They delimit the accepted-type list; without them the set is undefined." >&2
  exit 1; }
TYPES="$(awk '/^TYPES-SOT-BEGIN$/{i=1;next} /^TYPES-SOT-END$/{i=0} i' "$TPL" \
  | sed -n 's/^TYPES:[[:space:]]*//p' | head -1)"
case "$TYPES" in
  *[A-Za-z]*) ;;
  *) echo "Error: no 'TYPES:' line inside the TYPES-SOT block of $TPL." >&2
     echo "       Expected an unindented line, e.g. 'TYPES: FEAT BUG TECH TASK SPIKE'." >&2
     exit 1 ;;
esac
# Every entry must be a usable filename prefix — a stray character here would be
# baked into ids forever.
for t in $TYPES; do
  case "$t" in
    *[!A-Za-z]*) echo "Error: invalid type '$t' in the TYPES: line of $TPL — letters only." >&2; exit 1 ;;
  esac
done

TYPE="$(printf '%s' "$TYPE_IN" | tr '[:lower:]' '[:upper:]')"

# --- The rejection message: a lesson, not a wall ---------------------------
reject() {
  {
    echo "Error: '$TYPE_IN' is not an accepted work-item type."
    echo ""
    echo "Accepted types: $TYPES"
    echo ""
    case "$TYPE" in
      STORY|EPIC|USERSTORY|USER-STORY)
        echo "'$TYPE_IN' is a structural question, not a type. To model a story with"
        echo "work under it, create the parent as a FEAT and give it sub-items:"
        echo "  - a dotted child (FEAT-nnn.1) when the child makes no sense on its"
        echo "    own — it moves with the parent and counts as one item against WIP;"
        echo "  - the Parent: field when the child stands alone but traces back."
        echo "/fw-move already treats a dotted child as grouping that moves with its"
        echo "parent, so the machinery exists on both sides." ;;
      ENHANCEMENT|FEATURE|STORY-POINT|IMPROVEMENT|REQUEST)
        echo "Closest accepted type: FEAT — new capability or a change to what the"
        echo "system does for its users." ;;
      DEFECT|FIX|HOTFIX|ISSUE|PROBLEM)
        echo "Closest accepted type: BUG — something that does not work as intended." ;;
      CHORE|REFACTOR|DOCS|DOC|PERF|MAINTENANCE|DEBT|TECHDEBT|CLEANUP|BUILD|CI|TEST)
        echo "Closest accepted type: TECH — work on the system itself: docs, chores,"
        echo "refactors, performance, build and test scaffolding. It is not a lesser"
        echo "FEAT; it is work whose beneficiary is the system rather than the user." ;;
      RESEARCH|INVESTIGATION|POC|PROTOTYPE|EXPERIMENT|DISCOVERY|ANALYSIS)
        echo "Closest accepted type: SPIKE — time-boxed work whose deliverable is an"
        echo "answer, not a change. If you already know what to build, it is not a spike." ;;
      INCIDENT|OUTAGE|INC|REQ|SERVICE-REQUEST|TICKET)
        echo "That sounds like an operations record, not a board item. Incidents and"
        echo "requests live in their own namespace with their own sequence:"
        echo "  /fw-new-ops-record   (INC-nnn / REQ-nnn)" ;;
      *)
        echo "If none of these fit, the work is usually a TASK — a discrete piece of"
        echo "work that is none of the other four." ;;
    esac
    echo ""
    echo "Note: prefixes already on disk that are not listed above are legacy —"
    echo "recognized when scanning, never offered for creation. The accepted set is"
    echo "defined by the TYPES: line in templates/records/work-item.md; adding a type"
    echo "there means also making the template serve it."
  } >&2
  exit 1
}

# Strict membership test against the SoT. Word-boundary match, not substring.
ACCEPTED=""
for t in $TYPES; do
  [ "$(printf '%s' "$t" | tr '[:lower:]' '[:upper:]')" = "$TYPE" ] && { ACCEPTED="$t"; break; }
done
[ -n "$ACCEPTED" ] || reject
TYPE="$ACCEPTED"

# --- Queue scaffold on first use ------------------------------------------
# Mirrors fw-new-ops-record.sh: scaffolding is not a separate init step.
KANBAN="$ROOT/kanban"
if [ ! -d "$KANBAN/backlog" ]; then
  QTPL="$ROOT/.claude/templates/queues/kanban"
  [ -d "$QTPL" ] || QTPL="$SCRIPT_DIR/../templates/queues/kanban"
  [ -d "$QTPL" ] || { echo "Error: kanban queue template not found (looked for .claude/templates/queues/kanban and $SCRIPT_DIR/../templates/queues/kanban)" >&2; exit 1; }
  mkdir -p "$KANBAN"
  cp -R "$QTPL/." "$KANBAN/"
  echo "Created kanban queue at kanban/ (first use)"
fi

# --- ID assignment: call the one home, never reimplement the scan ---------
# fw-next-id.sh scans the NAMESPACE ROOT recursively. Do not widen this to a
# grep over mixed content: verified 2026-07-09, a naive TYPE-NNN grep across
# project-hub/ returned 202 by matching ROADMAP-2026-02-04.md as ROADMAP-202,
# where the correct scoped scan returned 178 — 25 ids silently burned.
if [ -n "$PARENT" ]; then
  # Dotted child: the id is derived from the parent, not from the sequence.
  PARENT_UC="$(printf '%s' "$PARENT" | tr '[:lower:]' '[:upper:]')"
  case "$PARENT_UC" in
    [A-Z]*-[0-9]*) ;;
    *) echo "Error: --parent must be a full id like FEAT-021 or FEAT-021.1, got '$PARENT'" >&2; exit 1 ;;
  esac
  PFILE="$(find "$KANBAN" -type f -name "$PARENT_UC-*.md" -print -quit 2>/dev/null || true)"
  [ -n "$PFILE" ] || { echo "Error: parent not found on the board: $PARENT_UC" >&2; exit 1; }
  # Depth cap of 3 (parent.child.grandchild) — a 4th level means the parent is too big.
  DEPTH="$(printf '%s' "$PARENT_UC" | tr -cd '.' | wc -c)"
  [ "$DEPTH" -lt 2 ] || { echo "Error: max dotted-id depth is 3; '$PARENT_UC' is already at the limit — the parent is too big" >&2; exit 1; }
  NEXT=0
  for f in "$KANBAN"/*/"$PARENT_UC".[0-9]*-*.md; do
    [ -e "$f" ] || continue
    n="$(basename "$f" | sed -n "s/^${PARENT_UC}\.\([0-9]\{1,\}\)-.*/\1/p")"
    [ -n "$n" ] && [ "$n" -gt "$NEXT" ] && NEXT="$n"
  done
  FULL="$PARENT_UC.$((NEXT + 1))"
  # A dotted child inherits its parent's folder — it moves with the parent.
  DEST="$(basename "$(dirname "$PFILE")")"
else
  ID="$(bash "$SCRIPT_DIR/fw-next-id.sh" --root "$ROOT" kanban)"
  FULL="$TYPE-$ID"
  DEST="backlog"   # Creation is always into backlog/: adding an idea is free.
fi

FILE="$KANBAN/$DEST/$FULL-$SLUG.md"
[ -e "$FILE" ] && { echo "Error: already exists: $FILE" >&2; exit 1; }
[ -d "$KANBAN/$DEST" ] || { echo "Error: destination folder missing: kanban/$DEST" >&2; exit 1; }

TODAY="$(date +%Y-%m-%d)"
[ -n "$TITLE" ] || TITLE="$(printf '%s' "$SLUG" | tr '-' ' ')"

# Placeholder fill. The template keeps every other __PLACEHOLDER__ for the
# author to complete or delete — this gate fills only what it knows for certain.
# The header comment travels with the card on purpose (ops-record.md does the
# same): the authoring guidance is wanted where the author is. The TYPES: line
# is the exception — it is parsed DATA, and copying it onto every card would
# make each one a stale copy of the SoT (ADR-008). It is dropped here, and the
# surrounding prose is reworded to point at the template instead.
# The SoT block is delimited by markers, so the boundary is data rather than a
# line count that silently rots when the prose is reworded.
awk -v id="$FULL" -v type="$TYPE" -v created="$TODAY" -v title="$TITLE" '
  /^TYPES-SOT-BEGIN$/ {
    print "     TYPES (ADR-006): the accepted set is defined by the TYPES: line in"
    print "     templates/records/work-item.md and enforced by fw-new.sh. It is not"
    print "     repeated here, so this card cannot become a stale copy of it."
    inblock = 1; next }
  /^TYPES-SOT-END$/ { inblock = 0; next }
  inblock { next }
  { gsub(/__ID__/, id); gsub(/__TYPE__/, type)
    gsub(/__CREATED__/, created); gsub(/__TITLE__/, title); print }
' "$TPL" > "$FILE"

# Record provenance when a parent was named but the child stands alone. (For a
# dotted child the id already carries it, so the field would be a second copy.)
echo "Created: kanban/$DEST/$FULL-$SLUG.md"
echo "Next: fill the Summary and Acceptance Criteria; delete optional fields you don't need."

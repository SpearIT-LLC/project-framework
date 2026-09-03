#!/usr/bin/env bash
# fw-new-ops-record.sh — the create gate for operations records (FEAT-195).
# Mints the next id from the shared operations sequence (fw-next-id.sh), copies
# the plugin's templates/records/ops-record.md, and lands the record in the root
# operations/open/ queue (ADR-009 D2 as amended by TASK-213). The only
# sanctioned way to create a record. First use creates the queue scaffold from
# templates/queues/operations/ (a project's .claude/templates/queues/ overrides).
#
# Usage: fw-new-ops-record.sh [--root <dir>] <inc|req> <slug>
#   inc → INC-nnn-<slug>.md (incident)   req → REQ-nnn-<slug>.md (request)
# --root is TESTING ONLY.
set -euo pipefail

ROOT=""
if [ "${1:-}" = "--root" ]; then ROOT="${2:?--root requires a directory}"; shift 2; fi
[ $# -eq 2 ] || { echo "Usage: fw-new-ops-record.sh <inc|req> <slug>" >&2; exit 1; }
KIND_IN="$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')"
SLUG="$2"
case "$KIND_IN" in
  inc|incident) PREFIX="INC"; KIND="Incident" ;;
  req|request)  PREFIX="REQ"; KIND="Request" ;;
  *) echo "Error: kind must be inc or req, got '$1'" >&2; exit 1 ;;
esac
case "$SLUG" in
  */*|*\*|.|..|"") echo "Error: slug must be a plain file-name fragment, got '$SLUG'" >&2; exit 1 ;;
esac

[ -n "$ROOT" ] || ROOT="$(git rev-parse --show-toplevel)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# The queue lives at the repo root (TASK-213). First use creates it — scaffold
# from the template tree, project override first (same channel as records).
OPS="$ROOT/operations"
if [ ! -d "$OPS/open" ]; then
  QTPL="$ROOT/.claude/templates/queues/operations"
  [ -d "$QTPL" ] || QTPL="$SCRIPT_DIR/../templates/queues/operations"
  [ -d "$QTPL" ] || { echo "Error: operations queue template not found (looked for .claude/templates/queues/operations and $SCRIPT_DIR/../templates/queues/operations)" >&2; exit 1; }
  mkdir -p "$OPS"
  cp -R "$QTPL/." "$OPS/"
  echo "Created operations queue at operations/ (first use)"
fi
TPL="$ROOT/.claude/templates/records/ops-record.md"
[ -f "$TPL" ] || TPL="$SCRIPT_DIR/../templates/records/ops-record.md"
[ -f "$TPL" ] || { echo "Error: ops-record template not found" >&2; exit 1; }

ID="$(bash "$SCRIPT_DIR/fw-next-id.sh" --root "$ROOT" operations)"
FULL="$PREFIX-$ID"
FILE="$OPS/open/$FULL-$SLUG.md"
[ -e "$FILE" ] && { echo "Error: already exists: $FILE" >&2; exit 1; }

TODAY="$(date +%Y-%m-%d)"
sed "s/__ID__/$FULL/g; s/__KIND__/$KIND/g; s/__OPENED__/$TODAY/g" "$TPL" > "$FILE"
echo "Created: operations/open/$FULL-$SLUG.md"
echo "Next: fill __TITLE__ and the body; delete optional fields you don't need."

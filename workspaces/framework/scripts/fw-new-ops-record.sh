#!/usr/bin/env bash
# fw-new-ops-record.sh — the create gate for operations records (FEAT-195).
# Mints the next id from the shared operations sequence (fw-next-id.sh), copies
# the plugin's templates/records/ops-record.md, and lands the record in
# workspaces/operations/open/. The only sanctioned way to create a record.
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
OPS="$ROOT/workspaces/operations"
if [ ! -d "$OPS/open" ]; then
  echo "Error: no operations workspace with flow folders at workspaces/operations — create it first: fw-new-workspace.sh operations" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TPL="$ROOT/.claude/templates/records/ops-record.md"
[ -f "$TPL" ] || TPL="$SCRIPT_DIR/../templates/records/ops-record.md"
[ -f "$TPL" ] || { echo "Error: ops-record template not found" >&2; exit 1; }

ID="$(bash "$SCRIPT_DIR/fw-next-id.sh" --root "$ROOT" operations)"
FULL="$PREFIX-$ID"
FILE="$OPS/open/$FULL-$SLUG.md"
[ -e "$FILE" ] && { echo "Error: already exists: $FILE" >&2; exit 1; }

TODAY="$(date +%Y-%m-%d)"
sed "s/__ID__/$FULL/g; s/__KIND__/$KIND/g; s/__OPENED__/$TODAY/g" "$TPL" > "$FILE"
echo "Created: workspaces/operations/open/$FULL-$SLUG.md"
echo "Next: fill __TITLE__ and the body; delete optional fields you don't need."

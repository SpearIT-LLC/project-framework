#!/usr/bin/env bash
# fw-new-workspace.sh — deterministic scaffold generator for /fw-new-workspace.
# THE one home for workspace structure (ADR-009 D3 / FEAT-164): no document may
# restate the folder tree below. To change the structure, change it here only.
set -euo pipefail

usage() {
  {
    echo "Usage: fw-new-workspace.sh [--root <dir>] <name> <type>"
    echo "       fw-new-workspace.sh [--root <dir>] <type>"
    echo ""
    echo "Types: application  knowledgebase  sow  operations"
    echo "The one-argument form is allowed only for knowledgebase and operations,"
    echo "whose name defaults to the type. --root overrides the repo root (the"
    echo "directory containing workspaces/); default is the enclosing git repo."
  } >&2
  exit 1
}

ROOT=""
if [ "${1:-}" = "--root" ]; then
  ROOT="${2:?--root requires a directory}"
  shift 2
fi

case $# in
  1)
    TYPE="$1"
    NAME="$1"
    case "$TYPE" in
      knowledgebase|operations) ;;
      application|sow) echo "Error: type '$TYPE' requires an explicit name" >&2; usage ;;
      *) echo "Error: unknown type '$TYPE'" >&2; usage ;;
    esac
    ;;
  2)
    NAME="$1"
    TYPE="$2"
    ;;
  *)
    usage
    ;;
esac

case "$TYPE" in
  application|knowledgebase|sow|operations) ;;
  *) echo "Error: unknown type '$TYPE'" >&2; usage ;;
esac

case "$NAME" in
  */*|*\\*|.|..) echo "Error: name must be a plain folder name, got '$NAME'" >&2; exit 1 ;;
esac

if [ -z "$ROOT" ]; then
  ROOT="$(git rev-parse --show-toplevel)"
fi

WS="$ROOT/workspaces/$NAME"
if [ -e "$WS" ]; then
  echo "Error: workspace already exists: $WS" >&2
  exit 1
fi

# Common floor — every type; document-only, no source tree required (ADR-009 D4)
FLOOR="meetings reference deliverables contacts agreements"

# Type scaffolds — differ ONLY in initial folders, never runtime behavior (ADR-009 OQ5)
case "$TYPE" in
  application)   EXTRA="poc src tests dist" ;;
  knowledgebase) EXTRA="domain cookbook faq" ;;
  sow)           EXTRA="requirements reports" ;;
  operations)    EXTRA="intake/requests intake/incidents" ;;
esac

for d in $FLOOR $EXTRA; do
  mkdir -p "$WS/$d"
  touch "$WS/$d/.gitkeep"
done

cat > "$WS/README.md" <<EOF
# $NAME

**Type:** $TYPE
**Purpose:** _PURPOSE_PENDING_
EOF

echo "Created workspace: $WS ($TYPE)"
( cd "$WS" && find . -type d | sort )

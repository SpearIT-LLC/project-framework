#!/usr/bin/env bash
# fw-new-workspace.sh — deterministic scaffold generator for /fw-new-workspace.
# THE one home for workspace structure (ADR-009 D3 / FEAT-164): no document may
# restate the folder tree below. To change the structure, change it here only.
set -euo pipefail

usage() {
  {
    echo "Usage: fw-new-workspace.sh [--root <dir>] <name> <type> [domain]"
    echo "       fw-new-workspace.sh [--root <dir>] operations"
    echo ""
    echo "Types: application  knowledgebase  sow  operations"
    echo "knowledgebase requires a domain — its first domain, e.g. 'licensing'."
    echo "The one-argument form is allowed only for operations, whose name defaults"
    echo "to the type. --root overrides the repo root (the directory containing"
    echo "workspaces/); default is the enclosing git repo."
  } >&2
  exit 1
}

ROOT=""
if [ "${1:-}" = "--root" ]; then
  ROOT="${2:?--root requires a directory}"
  shift 2
fi

DOMAIN=""
case $# in
  1)
    TYPE="$1"
    NAME="$1"
    case "$TYPE" in
      operations) ;;
      knowledgebase) echo "Error: knowledgebase requires a name and a domain" >&2; usage ;;
      application|sow) echo "Error: type '$TYPE' requires an explicit name" >&2; usage ;;
      *) echo "Error: unknown type '$TYPE'" >&2; usage ;;
    esac
    ;;
  2)
    NAME="$1"
    TYPE="$2"
    ;;
  3)
    NAME="$1"
    TYPE="$2"
    DOMAIN="$3"
    ;;
  *)
    usage
    ;;
esac

case "$TYPE" in
  application|knowledgebase|sow|operations) ;;
  *) echo "Error: unknown type '$TYPE'" >&2; usage ;;
esac

if [ "$TYPE" = "knowledgebase" ] && [ -z "$DOMAIN" ]; then
  echo "Error: knowledgebase requires a domain — its first domain, e.g. 'licensing'" >&2
  usage
fi
if [ "$TYPE" != "knowledgebase" ] && [ -n "$DOMAIN" ]; then
  echo "Error: a domain argument applies only to knowledgebase" >&2
  usage
fi

case "$NAME" in
  */*|*\\*|.|..) echo "Error: name must be a plain folder name, got '$NAME'" >&2; exit 1 ;;
esac
case "$DOMAIN" in
  */*|*\\*|.|..) echo "Error: domain must be a plain folder name, got '$DOMAIN'" >&2; exit 1 ;;
esac

if [ -z "$ROOT" ]; then
  ROOT="$(git rev-parse --show-toplevel)"
fi

WS="$ROOT/workspaces/$NAME"
if [ -e "$WS" ]; then
  echo "Error: workspace already exists: $WS" >&2
  exit 1
fi

# Common floor — document-only, no source tree required (ADR-009 D4).
# knowledgebase opts out of the floor (D4 amendment 2026-08-18): a kb holds
# knowledge by domain — domains sit directly under the kb root.
FLOOR="meetings reference deliverables contacts agreements"

# Type scaffolds — differ ONLY in initial folders, never runtime behavior (ADR-009 OQ5)
case "$TYPE" in
  application)   DIRS="$FLOOR poc src tests dist" ;;
  knowledgebase) DIRS="$DOMAIN/cookbook $DOMAIN/faq $DOMAIN/reference" ;;
  sow)           DIRS="$FLOOR requirements reports" ;;
  operations)    DIRS="$FLOOR intake/requests intake/incidents" ;;
esac

for d in $DIRS; do
  mkdir -p "$WS/$d"
  touch "$WS/$d/.gitkeep"
done

# One INDEX per knowledgebase (not per domain) — the single entry point
if [ "$TYPE" = "knowledgebase" ]; then
  cat > "$WS/INDEX.md" <<EOF
# $NAME — Index

One index per knowledgebase: list every domain here with a one-line description.

- [$DOMAIN]($DOMAIN/) — _one-line description pending_
EOF
fi

cat > "$WS/README.md" <<EOF
# $NAME

**Type:** $TYPE
**Purpose:** _PURPOSE_PENDING_
EOF

echo "Created workspace: $WS ($TYPE)"
( cd "$WS" && find . -type d | sort )

#!/usr/bin/env bash
# fw-new-workspace.sh — deterministic scaffold generator for /fw-new-workspace.
# THE one chokepoint for workspace creation (ADR-009 D3, amended 2026-08-20 /
# TASK-197). Structure and seeded content are authored once in
# ../templates/workspaces/ — a shared floor/ plus thin per-type overlays — and
# composed here. No document may restate the trees; to change a scaffold, change
# the templates. A consuming project's .claude/templates/workspaces/ overrides
# the plugin's templates as a whole, when present.
set -euo pipefail

usage() {
  {
    echo "Usage: fw-new-workspace.sh [--root <dir>] <name> <type> [domain]"
    echo "       fw-new-workspace.sh [--root <dir>] operations"
    echo ""
    echo "Types: product  project  knowledgebase  operations"
    echo "product  — created, delivered, maintained; named for the product."
    echo "project  — finite, freezes at close; contracted work (an SOW) is a"
    echo "           project named for the SOW, e.g. bd-sow-001."
    echo "knowledgebase requires a domain — its first domain, e.g. 'licensing'."
    echo "The one-argument form is allowed only for operations, whose name defaults"
    echo "to the type. --root overrides the repo root (the directory containing"
    echo "workspaces/); default is the enclosing git repo."
  } >&2
  exit 1
}

# Retired type names get a pointer, not a bare 'unknown' (TASK-197).
check_type() {
  case "$1" in
    product|project|knowledgebase|operations) ;;
    application) echo "Error: type 'application' was renamed 'product' (TASK-197)" >&2; usage ;;
    sow) echo "Error: 'sow' is not a type — an SOW is a project named for the SOW, e.g. bd-sow-001 (TASK-197)" >&2; usage ;;
    *) echo "Error: unknown type '$1'" >&2; usage ;;
  esac
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
    check_type "$TYPE"
    case "$TYPE" in
      operations) ;;
      knowledgebase) echo "Error: knowledgebase requires a name and a domain" >&2; usage ;;
      *) echo "Error: type '$TYPE' requires an explicit name" >&2; usage ;;
    esac
    ;;
  2)
    NAME="$1"
    TYPE="$2"
    check_type "$TYPE"
    ;;
  3)
    NAME="$1"
    TYPE="$2"
    DOMAIN="$3"
    check_type "$TYPE"
    ;;
  *)
    usage
    ;;
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

# Template resolution: project override first, then the plugin's own templates
# (this script's sibling ../templates — same layout in source tree and plugin).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TPL="$ROOT/.claude/templates/workspaces"
[ -d "$TPL" ] || TPL="$SCRIPT_DIR/../templates/workspaces"
if [ ! -d "$TPL" ]; then
  echo "Error: workspace templates not found (looked for .claude/templates/workspaces and $SCRIPT_DIR/../templates/workspaces)" >&2
  exit 1
fi

mkdir -p "$WS"

# Compose: floor + type overlay. knowledgebase opts out of the floor (ADR-009 D4
# amendment 2026-08-18) and names its first domain from the template's _domain_.
case "$TYPE" in
  product|project|operations)
    cp -R "$TPL/floor/." "$WS/"
    cp -R "$TPL/$TYPE/." "$WS/"
    ;;
  knowledgebase)
    cp -R "$TPL/knowledgebase/." "$WS/"
    mv "$WS/_domain_" "$WS/$DOMAIN"
    ;;
esac

# Fill placeholders in seeded markdown (__NAME__, __DOMAIN__).
find "$WS" -type f -name '*.md' -print0 | while IFS= read -r -d '' f; do
  sed -i "s/__NAME__/$NAME/g; s/__DOMAIN__/$DOMAIN/g" "$f"
done

echo "Created workspace: $WS ($TYPE)"
( cd "$WS" && find . -type d | sort )

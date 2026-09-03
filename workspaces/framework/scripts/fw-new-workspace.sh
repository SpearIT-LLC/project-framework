#!/usr/bin/env bash
# fw-new-workspace.sh — deterministic scaffold generator for /fw-new-workspace.
# THE one chokepoint for workspace creation (ADR-009 D3, amended 2026-08-20 /
# TASK-197). Structure and seeded content are authored once in
# ../templates/workspaces/ — a shared floor/ plus thin per-type overlays — and
# composed here. No document may restate the trees; to change a scaffold, change
# the templates. A consuming project's .claude/templates/workspaces/ overrides
# the plugin's templates as a whole, when present.
#
# --root <dir> (before the type) overrides the repo root — TESTING ONLY, kept
# out of the usage text on purpose; workspaces always land in <root>/workspaces/.
set -euo pipefail

usage() {
  {
    echo "Usage: fw-new-workspace.sh <type> <name>"
    echo "       fw-new-workspace.sh kb <domain>"
    echo ""
    echo "Types (case-insensitive): product  project  kb"
    echo "product    — created, delivered, maintained; named for the product."
    echo "project    — finite, freezes at close; contracted work (an SOW) is a"
    echo "             project named for the SOW, e.g. bd-sow-001."
    echo "kb         — the knowledgebase; always created at workspaces/kb with its"
    echo "             first domain, e.g. 'licensing'. No custom name."
  } >&2
  exit 1
}

ROOT=""
if [ "${1:-}" = "--root" ]; then
  ROOT="${2:?--root requires a directory}"
  shift 2
fi

[ $# -ge 1 ] || usage

# Type is case-insensitive; 'kb' is the canonical short form of knowledgebase
# and the fixed folder name (Gary, 2026-08-20). Retired names get pointers.
TYPE="$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')"
case "$TYPE" in
  kb|knowledgebase) TYPE="knowledgebase" ;;
  product|project) ;;
  operations) echo "Error: operations is not a workspace — it is the root queue at operations/, created on first /fw-new-ops-record (TASK-213)" >&2; usage ;;
  application) echo "Error: type 'application' was renamed 'product' (TASK-197)" >&2; usage ;;
  sow) echo "Error: 'sow' is not a type — an SOW is a project named for the SOW, e.g. bd-sow-001 (TASK-197)" >&2; usage ;;
  *) echo "Error: unknown type '$1'" >&2; usage ;;
esac

# kb is one-per-repo with a fixed folder name; product and project take a
# custom name.
NAME=""
DOMAIN=""
case "$TYPE" in
  knowledgebase)
    NAME="kb"
    case $# in
      1) echo "Error: kb requires a domain — its first domain, e.g. 'licensing'" >&2; usage ;;
      2) DOMAIN="$2" ;;
      *) echo "Error: kb takes just a domain — the workspace is always workspaces/kb" >&2; usage ;;
    esac
    ;;
  product|project)
    case $# in
      1) echo "Error: type '$TYPE' requires a name — ask the user for one" >&2; usage ;;
      2) NAME="$2" ;;
      *) echo "Error: too many arguments for type '$TYPE'" >&2; usage ;;
    esac
    ;;
esac

case "$NAME" in
  */*|*\\*|.|..) echo "Error: name must be a plain folder name, got '$NAME'" >&2; exit 1 ;;
esac
case "$DOMAIN" in
  */*|*\\*|.|..) echo "Error: domain must be a plain folder name, got '$DOMAIN'" >&2; exit 1 ;;
esac

if [ -z "$ROOT" ]; then
  ROOT="$(git rev-parse --show-toplevel)"
fi

# kb delegates wholesale to fw-new-kb-domain.sh — the one home for kb-domain
# logic (FEAT-192): it creates the kb shell on first use and adds the domain,
# so the create and grow paths cannot drift. (It also owns the kb collision
# handling: an existing kb is legal there — the domain guard applies instead.)
if [ "$TYPE" = "knowledgebase" ]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  exec bash "$SCRIPT_DIR/fw-new-kb-domain.sh" ${ROOT:+--root "$ROOT"} "$DOMAIN"
fi

# Collision guard — case-insensitive, so App2 vs app2 is refused even on a
# case-sensitive filesystem (Windows checkouts would collide silently).
WS="$ROOT/workspaces/$NAME"
if [ -e "$WS" ]; then
  echo "Error: workspace already exists: $WS" >&2
  exit 1
fi
if [ -d "$ROOT/workspaces" ]; then
  NAME_LC="$(printf '%s' "$NAME" | tr '[:upper:]' '[:lower:]')"
  for existing in "$ROOT/workspaces"/*/; do
    [ -d "$existing" ] || continue
    base="$(basename "$existing")"
    if [ "$(printf '%s' "$base" | tr '[:upper:]' '[:lower:]')" = "$NAME_LC" ]; then
      echo "Error: workspace name collides with existing '$base' (names are case-insensitive): $NAME" >&2
      exit 1
    fi
  done
fi

# Template resolution: project override first, then the plugin's own templates
# (this script's sibling ../templates — same layout in source tree and plugin).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OVERRIDE=""
TPL="$ROOT/.claude/templates/workspaces"
if [ -d "$TPL" ]; then
  OVERRIDE=1
else
  TPL="$SCRIPT_DIR/../templates/workspaces"
fi
if [ ! -d "$TPL" ]; then
  echo "Error: workspace templates not found (looked for .claude/templates/workspaces and $SCRIPT_DIR/../templates/workspaces)" >&2
  exit 1
fi

# Validate the template set BEFORE creating anything (BUG-208): a missing
# overlay must refuse cleanly, never die mid-copy leaving a half-built tree.
MISSING=""
[ -d "$TPL/floor" ] || MISSING="floor"
[ -d "$TPL/$TYPE" ] || MISSING="${MISSING:+$MISSING and }$TYPE"
if [ -n "$MISSING" ]; then
  if [ -n "$OVERRIDE" ]; then
    echo "Error: template override at .claude/templates/workspaces is missing the '$MISSING' folder(s) — an override replaces the plugin templates wholesale, so copy the plugin's full templates/workspaces/ tree first, then edit. Nothing created." >&2
  else
    echo "Error: plugin templates at $TPL are missing the '$MISSING' folder(s) — broken install? Nothing created." >&2
  fi
  exit 1
fi
[ -z "$OVERRIDE" ] || echo "Using project template override: .claude/templates/workspaces/"

mkdir -p "$WS"

# Compose: floor + type overlay. (knowledgebase never reaches here — it
# delegated to fw-new-kb-domain.sh above; kb opts out of the floor per the
# ADR-009 D4 amendment 2026-08-18. The operations queue is not a workspace —
# TASK-213 — its scaffold lives in templates/queues/ and is laid down by
# fw-new-ops-record.sh on first use.)
cp -R "$TPL/floor/." "$WS/"
cp -R "$TPL/$TYPE/." "$WS/"

# Fill placeholders in seeded markdown (__NAME__, __DOMAIN__).
find "$WS" -type f -name '*.md' -print0 | while IFS= read -r -d '' f; do
  sed -i "s/__NAME__/$NAME/g; s/__DOMAIN__/$DOMAIN/g" "$f"
done

echo "Created workspace: $WS ($TYPE)"
( cd "$WS" && find . -type d | sort )

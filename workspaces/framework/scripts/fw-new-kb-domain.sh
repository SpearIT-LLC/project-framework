#!/usr/bin/env bash
# fw-new-kb-domain.sh — add a domain to the knowledgebase (creating the kb on
# first use). THE one home for kb-domain scaffolding logic (FEAT-192/201):
# fw-new-workspace.sh's kb path delegates here, so create and grow cannot drift.
# Domain structure + seeded content are authored once in
# ../templates/workspaces/knowledgebase/ (_domain_/ = the per-domain shape).
#
# --root <dir> (before the domain) overrides the repo root — TESTING ONLY.
set -euo pipefail

usage() {
  {
    echo "Usage: fw-new-kb-domain.sh <domain>"
    echo ""
    echo "Adds <domain> to the knowledgebase at workspaces/kb, creating the kb"
    echo "itself on first use. The domain gets the standard folder set and its"
    echo "line in INDEX.md. Domain examples: licensing, hpc, company."
  } >&2
  exit 1
}

ROOT=""
if [ "${1:-}" = "--root" ]; then
  ROOT="${2:?--root requires a directory}"
  shift 2
fi

[ $# -eq 1 ] || usage
DOMAIN="$1"

case "$DOMAIN" in
  */*|*\\*|.|..) echo "Error: domain must be a plain folder name, got '$DOMAIN'" >&2; exit 1 ;;
esac

if [ -z "$ROOT" ]; then
  ROOT="$(git rev-parse --show-toplevel)"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TPL="$ROOT/.claude/templates/workspaces"
[ -d "$TPL" ] || TPL="$SCRIPT_DIR/../templates/workspaces"
if [ ! -d "$TPL/knowledgebase" ]; then
  echo "Error: kb templates not found (looked in .claude/templates/workspaces and $SCRIPT_DIR/../templates/workspaces)" >&2
  exit 1
fi

KB="$ROOT/workspaces/kb"
CREATED_KB=""

if [ ! -d "$KB" ]; then
  # First use: stand up the kb shell (README + INDEX header, no domain yet).
  if [ -e "$KB" ]; then
    echo "Error: workspaces/kb exists but is not a directory" >&2
    exit 1
  fi
  mkdir -p "$KB"
  for f in README.md INDEX.md; do
    if [ -f "$TPL/knowledgebase/$f" ]; then
      cp "$TPL/knowledgebase/$f" "$KB/$f"
    fi
  done
  # The seeded INDEX lists the placeholder domain line; strip it — domains are
  # appended per-domain below, so the shell starts with an empty list.
  sed -i "/__DOMAIN__/d; s/__NAME__/kb/g" "$KB/INDEX.md" "$KB/README.md"
  CREATED_KB="yes"
else
  if [ ! -f "$KB/INDEX.md" ]; then
    echo "Error: $KB exists but has no INDEX.md — not a knowledgebase this script recognizes" >&2
    exit 1
  fi
fi

# Duplicate-domain guard — case-insensitive, like the workspace collision guard.
DOMAIN_LC="$(printf '%s' "$DOMAIN" | tr '[:upper:]' '[:lower:]')"
for existing in "$KB"/*/; do
  [ -d "$existing" ] || continue
  base="$(basename "$existing")"
  if [ "$(printf '%s' "$base" | tr '[:upper:]' '[:lower:]')" = "$DOMAIN_LC" ]; then
    echo "Error: domain already exists (names are case-insensitive): $base" >&2
    exit 1
  fi
done

# Compose the domain from the template's _domain_ shape and fill placeholders.
cp -R "$TPL/knowledgebase/_domain_/." "$KB/$DOMAIN/"
find "$KB/$DOMAIN" -type f -name '*.md' -print0 | while IFS= read -r -d '' f; do
  sed -i "s/__DOMAIN__/$DOMAIN/g; s/__NAME__/kb/g" "$f"
done

# Append the domain's line to the one-per-kb INDEX.
printf -- '- [%s](%s/) — _one-line description pending_\n' "$DOMAIN" "$DOMAIN" >> "$KB/INDEX.md"

[ -n "$CREATED_KB" ] && echo "Created knowledgebase: $KB"
echo "Created domain: $DOMAIN"
echo "INDEX.md: + [$DOMAIN]($DOMAIN/) — _one-line description pending_"
( cd "$KB" && find . -type d | sort )

#!/usr/bin/env bash
# report-wip.sh — SessionStart hook: tell the session what is in progress (TECH-253).
#
# "Report doing/ before suggesting next steps" was a bootstrap step in the root
# CLAUDE.md: prose the AI had to remember. Its stdout here is added to Claude's
# context when a session starts, so the state is simply there (ADR-008).
#
# Runs on startup, clear and compact. Not on resume: a resumed session already has
# its context, and the report would be noise.
#
# WHICH FOLDERS — each namespace's <ns>_WIP folder from scripts/lib/namespace-roots.sh
# (kanban/doing/). SPRIT_BOARD_ROOTS adds more boards, each read at <root>/doing/;
# see hooks/board-guard.sh for why that variable exists.
#
# Silent when the repo has no board. Never fails a session opening.
set -uo pipefail
cat >/dev/null 2>&1 || true   # drain stdin; nothing in the payload is needed

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB="${CLAUDE_PLUGIN_ROOT:-$HERE/..}/scripts/lib/namespace-roots.sh"
[ -f "$LIB" ] || exit 0
. "$LIB"

REPO="${CLAUDE_PROJECT_DIR:-}"
[ -n "$REPO" ] || REPO="$(git rev-parse --show-toplevel 2>/dev/null)" || exit 0

WIP_DIRS=""
for ns in $NAMESPACES; do
  eval "r=\"\${${ns}_ROOT:-}\"; w=\"\${${ns}_WIP:-}\""
  [ -n "$r" ] && [ -n "$w" ] && WIP_DIRS="$WIP_DIRS $r/$w"
done
for r in ${SPRIT_BOARD_ROOTS:-}; do WIP_DIRS="$WIP_DIRS $r/doing"; done

for d in $WIP_DIRS; do
  [ -d "$REPO/$d" ] || continue
  n=0; lines=""
  for f in "$REPO/$d"/*.md; do
    [ -f "$f" ] || continue
    id="$(basename "$f" | grep -oE '^[A-Z]+-[0-9]+(\.[0-9]+)*')" || continue
    [ -n "$id" ] || continue
    title="$(sed -n '1{s/^# *//;p;q}' "$f")"
    lines="$lines  - $id: $title"$'\n'
    n=$((n+1))
  done
  if [ "$n" -eq 0 ]; then
    echo "Work in progress ($d/): none."
  else
    echo "Work in progress ($d/): $n card(s). Implementation happens only on these."
    printf '%s' "$lines"
  fi
done
exit 0

#!/usr/bin/env bash
# fw-next-id.sh — THE one home for next-ID logic across namespaces (FEAT-195,
# ADR-008). A namespace is a root folder whose records are files named
# <PREFIX>-<n>-<slug>.md (bundles are sibling folders <PREFIX>-<n>/). All
# prefixes in a namespace share ONE sequence (kanban precedent): the next id is
# max(n)+1 over every record and bundle under the root, scanned recursively —
# status is only the first path segment under the root; deeper folders (year
# buckets, release buckets, bundles) are grouping, never status, and still count.
#
# Usage: fw-next-id.sh [--root <dir>] <namespace>
#   namespace: operations | kanban | <path to a namespace root>
# Prints the next id zero-padded to 3 digits (e.g. 007). --root is TESTING ONLY.
set -euo pipefail

ROOT=""
if [ "${1:-}" = "--root" ]; then ROOT="${2:?--root requires a directory}"; shift 2; fi
[ $# -eq 1 ] || { echo "Usage: fw-next-id.sh <operations|kanban|path>" >&2; exit 1; }
[ -n "$ROOT" ] || ROOT="$(git rev-parse --show-toplevel)"

case "$1" in
  operations) NS="$ROOT/workspaces/operations" ;;
  kanban)
    NS="$ROOT/kanban"
    if [ ! -d "$NS" ]; then
      echo "Error: the kanban namespace is not active in this repo until the board crosses over (ADR-009 D5) — the live board uses the root /fw-next-id" >&2
      exit 1
    fi ;;
  *) NS="$1" ;;
esac
[ -d "$NS" ] || { echo "Error: namespace root not found: $NS" >&2; exit 1; }

MAX=$(find "$NS" \( -type f -name '*.md' -o -type d \) -printf '%f\n' 2>/dev/null \
  | grep -oE '^[A-Za-z]+-[0-9]+' | grep -oE '[0-9]+$' | sort -n | tail -1 || true)
MAX="${MAX:-0}"
printf '%03d\n' "$((10#$MAX + 1))"

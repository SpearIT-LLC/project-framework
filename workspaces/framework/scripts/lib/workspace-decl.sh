#!/usr/bin/env bash
# workspace-decl.sh — read a workspace's own declaration (TECH-232).
#
# THE one reader for workspace.yaml. Every gate that needs to know what a
# workspace is, or what a card there serves, sources this — so there is one
# parse and one set of error messages, not one per command (ADR-008).
#
# Why a workspace declares this at all: ADR-009 makes the repo the customer,
# hosting many workspaces of different types. A product has FEATURES, a project
# has DELIVERABLES, a kb has DOMAINS. The word is not cosmetic — it is the hint
# that sets direction for the human and the AI at the moment a card is created.
#
# Deliberately NOT a yaml parser. The declaration is a small, flat, authored
# file; `key: value` and one nested block is the whole grammar it needs. A real
# parser would be a dependency for no gain.
#
# Usage (source it):
#   . "$(dirname "$0")/lib/workspace-decl.sh"
#   ws_decl_read <workspace-dir>   -> sets WS_TYPE, WS_SERVES_KIND, WS_SERVES_LOCATION
#   ws_serves_kind <workspace-dir> -> prints the kind, e.g. feature

# Read one top-level `key: value`.
_ws_scalar() {
  sed -n "s/^${2}:[[:space:]]*\(.*[^[:space:]]\)[[:space:]]*$/\1/p" "$1" | head -1
}

# Read `key:` nested one level under `parent:` — the only nesting the
# declaration uses. Stops at the next unindented line so a later block cannot
# leak into this one.
_ws_nested() {
  sed -n "/^${2}:/,/^[^[:space:]#]/p" "$1" \
    | sed -n "s/^[[:space:]]\{1,\}${3}:[[:space:]]*\(.*[^[:space:]]\)[[:space:]]*$/\1/p" \
    | head -1
}

# ws_decl_read <workspace-dir>
# Sets WS_TYPE, WS_SERVES_KIND, WS_SERVES_LOCATION. Returns non-zero and
# explains on stdout/stderr if the declaration is missing or incomplete —
# never guesses, because a guessed workspace type silently mis-files work.
ws_decl_read() {
  local ws="${1:?ws_decl_read requires a workspace directory}"
  local f="$ws/workspace.yaml"

  WS_TYPE=""; WS_SERVES_KIND=""; WS_SERVES_LOCATION=""

  if [ ! -f "$f" ]; then
    echo "Error: no workspace.yaml in $ws" >&2
    echo "       Every workspace declares its own type and what a card there serves." >&2
    echo "       A workspace created before this was required needs one added (TECH-232)." >&2
    return 1
  fi

  WS_TYPE="$(_ws_scalar "$f" type)"
  WS_SERVES_KIND="$(_ws_nested "$f" serves kind)"
  WS_SERVES_LOCATION="$(_ws_nested "$f" serves location)"

  if [ -z "$WS_TYPE" ]; then
    echo "Error: $f declares no 'type:'" >&2
    return 1
  fi
  case "$WS_TYPE" in
    product|project|knowledgebase) ;;
    *) echo "Error: $f declares unknown type '$WS_TYPE' (product|project|knowledgebase)" >&2; return 1 ;;
  esac
  if [ -z "$WS_SERVES_KIND" ] || [ -z "$WS_SERVES_LOCATION" ]; then
    echo "Error: $f is missing 'serves.kind' or 'serves.location'" >&2
    echo "       Both are required: the kind is the word a gate asks with, the" >&2
    echo "       location is where those are authored." >&2
    return 1
  fi
  return 0
}

# ws_serves_kind <workspace-dir> — prints the kind (feature|deliverable|domain).
# The convenience a create gate wants: ask in the workspace's own vocabulary.
ws_serves_kind() {
  ws_decl_read "$1" || return 1
  printf '%s\n' "$WS_SERVES_KIND"
}

# ws_serves_dir <workspace-dir> — prints the absolute directory where the
# things a card serves are authored. Resolves './' to the workspace root.
ws_serves_dir() {
  ws_decl_read "$1" || return 1
  case "$WS_SERVES_LOCATION" in
    ./|.) printf '%s\n' "$1" ;;
    /*)   printf '%s\n' "$WS_SERVES_LOCATION" ;;
    *)    printf '%s/%s\n' "${1%/}" "${WS_SERVES_LOCATION%/}" ;;
  esac
}

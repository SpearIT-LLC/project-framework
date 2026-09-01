#!/usr/bin/env bash
# refresh-contacts.sh — PostToolUse hook: keep generated CONTACTS.md views in
# step with the contact registry whenever Claude edits a contact record.
#
# CONTACTS.md is derived output (ADR-008): the per-contact record is the only
# authored home. A refresh the AI must remember to run is not a guardrail, so
# the harness runs it here instead. Outside-Claude edits are covered by the
# pre-commit hook (tools/pre-commit) and by `fw-contacts.sh --check` in CI.
#
# Reads the PostToolUse payload on stdin; a no-op unless the edited file was a
# record under workspaces/kb/company/contacts/. Never blocks the edit.
#
# --all (SessionStart): no file_path in the payload — refresh unconditionally so
# a session never opens on views left stale by an edit made outside Claude Code
# (notepad, another editor, a merge), which no PostToolUse hook can observe. The
# session boundary is the earliest point those edits can be caught; the
# pre-commit hook (tools/pre-commit) is the later backstop.
set -uo pipefail

if [ "${1:-}" = "--all" ]; then
  cat >/dev/null 2>&1 || true   # drain stdin; SessionStart carries no file_path
  script="${CLAUDE_PLUGIN_ROOT:-}/scripts/fw-contacts.sh"
  [ -f "$script" ] || exit 0
  # No registry in this repo (the common case for non-framework projects): silent.
  root="$(git rev-parse --show-toplevel 2>/dev/null)" || exit 0
  [ -d "$root/workspaces/kb/company/contacts" ] || exit 0
  if ! out="$(bash "$script" 2>&1)"; then
    printf 'fw-contacts: session-start refresh failed\n%s\n' "$out" >&2
    exit 0   # never block a session opening
  fi
  printf '%s\n' "$out"
  exit 0
fi

payload="$(cat)"

# file_path lives at .tool_input.file_path; MultiEdit/Write use the same key.
path="$(printf '%s' "$payload" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)"
[ -n "$path" ] || exit 0

# Normalise Windows separators and JSON-escaped backslashes before matching.
norm="${path//\\//}"     # backslashes -> forward slashes
norm="${norm//\/\///}"   # collapse any doubled separators
case "$norm" in
  */workspaces/kb/company/contacts/*.md) ;;
  *) exit 0 ;;
esac
case "$(basename "$norm")" in README.md) exit 0 ;; esac

script="${CLAUDE_PLUGIN_ROOT:-}/scripts/fw-contacts.sh"
[ -f "$script" ] || exit 0

# cd to the edited record so the script resolves the right repo root, and keep
# a failure advisory — a broken refresh must not fail the user's edit.
cd "$(dirname "$norm")" 2>/dev/null || exit 0
if ! out="$(bash "$script" 2>&1)"; then
  printf 'fw-contacts: refresh failed after editing %s\n%s\n' "$(basename "$norm")" "$out" >&2
  exit 1
fi
printf '%s\n' "$out"
exit 0

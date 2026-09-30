#!/usr/bin/env bash
# board-guard.sh — PreToolUse hook: a board record is moved only by `git mv`, and
# never deleted (TECH-253; the never-delete rule is TECH-077's).
#
# Both rules protect the same thing, the record's history. They were prose in the
# root CLAUDE.md ("file moves use git mv"), which holds only while the AI remembers
# it. A PreToolUse deny holds whether or not it does (ADR-008).
#
# WHAT IT DENIES — a shell command (Bash or PowerShell tool) in which a move, copy
# or delete verb is aimed at a path under a namespace root:
#   mv cp rm rmdir unlink · git rm · Move-Item Copy-Item Remove-Item Rename-Item and
#   their aliases · find ... -delete / -exec rm|mv|cp · xargs rm|mv|cp
# WHAT PASSES:
#   - `git mv` (the engine's own primitive; also right for a rename in place)
#   - anything outside the namespace roots, and every read (cat, ls, grep, ...)
#   - files INSIDE a record's bundle folder (kanban/doing/FEAT-012/scratch.log):
#     working material is the author's to reshape. The bundle folder itself is not.
#   - the engine and the fixture seeder: the hook sees the command Claude runs
#     (`bash .../fw-move.sh ...`), never what a script does inside.
#
# This stops the ordinary mistake, not a determined workaround: a command built by
# `eval`, a variable holding the path, or an edit made outside Claude Code is not
# seen. The git pre-commit hook (tools/pre-commit) is the backstop for the last.
#
# WHICH FOLDERS — the namespace roots in scripts/lib/namespace-roots.sh, the same
# list the engine moves records in. SPRIT_BOARD_ROOTS (space-separated, relative to
# the repo root) adds more: the framework's own repo sets it to `project-hub/work`
# until its board crosses over (ADR-009 D5). Nothing else should need it.
#
# Reads the PreToolUse payload on stdin. Prints a deny decision as JSON, or nothing.
# Always exits 0: a broken guard must never block unrelated work.
set -uo pipefail
set -f   # arguments are inspected as written; never glob-expanded here

payload="$(cat)"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB="${CLAUDE_PLUGIN_ROOT:-$HERE/..}/scripts/lib/namespace-roots.sh"
[ -f "$LIB" ] || exit 0
. "$LIB"

# --- payload: the command string and the cwd, without a JSON parser ----------
# A JSON string is "(\\.|[^"\\])*". Unescape only what a path or a separator needs.
json_str() { # json_str <key>
  printf '%s' "$payload" | grep -oE "\"$1\"[[:space:]]*:[[:space:]]*\"(\\\\.|[^\"\\\\])*\"" | head -1 \
    | sed -E "s/^\"$1\"[[:space:]]*:[[:space:]]*\"//; s/\"\$//"
}
unescape() { sed -E 's/\\n/ ; /g; s/\\t/ /g; s/\\r//g; s/\\"/"/g; s/\\\\/\\/g'; }
CMD="$(json_str command | unescape)"
[ -n "$CMD" ] || exit 0
CWD="$(json_str cwd | unescape)"

# --- paths: one spelling for Windows, Git Bash and POSIX ----------------------
# Backslashes to slashes, /c/x to c:/x, lower-cased (the comparison is
# case-insensitive everywhere; on a case-sensitive disk that errs toward a deny).
norm() { # norm <path> -> normalized, no trailing slash, . and .. resolved
  local p out="" seg IFS=/
  p="$(printf '%s' "$1" | tr '\\' '/' | tr '[:upper:]' '[:lower:]' | sed -E 's#^/([a-z])(/|$)#\1:/#')"
  local lead=""; case "$p" in /*) lead="/" ;; esac
  for seg in $p; do
    case "$seg" in
      ''|.) ;;
      ..) out="${out%/*}" ;;
      *) out="$out/$seg" ;;
    esac
  done
  out="${out#/}"
  printf '%s%s' "$lead" "$out"
}
is_abs() { case "$1" in /*|[A-Za-z]:[\\/]*) return 0 ;; esac; return 1; }

REPO="${CLAUDE_PROJECT_DIR:-}"
[ -n "$REPO" ] || REPO="$(git -C "${CWD:-.}" rev-parse --show-toplevel 2>/dev/null)" || exit 0
REPO="$(norm "$REPO")"
[ -n "$CWD" ] || CWD="$REPO"

ROOTS=""
for ns in $NAMESPACES; do eval "r=\"\${${ns}_ROOT:-}\""; [ -n "$r" ] && ROOTS="$ROOTS $r"; done
ROOTS="$ROOTS ${SPRIT_BOARD_ROOTS:-}"

# under_board <path> -> prints the matching root and returns 0 when the path is a
# record, a bundle folder, a status folder or the root itself. A file INSIDE a
# bundle folder (<TYPE>-<n>/...) is working material and returns 1.
under_board() {
  local p r full rel
  p="$(printf '%s' "$1" | sed -E "s/^[\"']+//; s/[\"',;)]+\$//")"
  [ -n "$p" ] || return 1
  case "$p" in -*) return 1 ;; esac
  if is_abs "$p"; then full="$(norm "$p")"; else full="$(norm "$EFF_CWD/$p")"; fi
  for r in $ROOTS; do
    r="$REPO/$(printf '%s' "$r" | tr '[:upper:]' '[:lower:]')"
    case "$full" in
      "$r") printf '%s' "$r"; return 0 ;;
      "$r"/*)
        rel="${full#"$r"/}"
        printf '%s' "$rel" | grep -qE '(^|/)[a-z]+-[0-9]+(\.[0-9]+)*/.+' && return 1
        printf '%s' "$r"; return 0 ;;
    esac
  done
  return 1
}

deny() { # deny <reason>
  local reason
  reason="$(printf '%s' "$1" | sed -E 's/\\/\\\\/g; s/"/\\"/g')"
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"%s"}}\n' "$reason"
  exit 0
}

MOVE_VERBS='mv|cp|move-item|copy-item|rename-item|mi|move|copy|cpi|ren|rni'
DEL_VERBS='rm|rmdir|unlink|remove-item|ri|del|erase|rd'

# --- walk the command one simple command at a time -------------------------
EFF_CWD="$CWD"
while IFS= read -r seg; do
  seg="$(printf '%s' "$seg" | sed -E 's/^[[:space:](]+//')"
  [ -n "$seg" ] || continue
  # shellcheck disable=SC2086
  set -- $seg
  verb="$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')"; kind=""
  case "$verb" in
    cd|pushd|set-location|sl|chdir)
      if [ -n "${2:-}" ]; then
        d="$(printf '%s' "$2" | sed -E "s/^[\"']+//; s/[\"']+\$//")"
        if is_abs "$d"; then EFF_CWD="$d"; else EFF_CWD="$EFF_CWD/$d"; fi
      fi
      continue ;;
    git)
      sub="$(printf '%s' "${2:-}" | tr '[:upper:]' '[:lower:]')"
      [ "$sub" = "rm" ] && kind="del"
      shift 2 2>/dev/null || true ;;        # `git mv` and every other git verb pass
    find)
      printf '%s' "$seg" | grep -qiE -- "-delete|-exec[[:space:]]+($DEL_VERBS)\b" && kind="del"
      [ -z "$kind" ] && printf '%s' "$seg" | grep -qiE -- "-exec[[:space:]]+($MOVE_VERBS)\b" && kind="move"
      shift ;;
    xargs)
      printf '%s' "$seg" | grep -qiE "xargs[[:space:]]+(-[^[:space:]]+[[:space:]]+)*($DEL_VERBS)\b" && kind="del"
      [ -z "$kind" ] && printf '%s' "$seg" | grep -qiE "xargs[[:space:]]+(-[^[:space:]]+[[:space:]]+)*($MOVE_VERBS)\b" && kind="move"
      # xargs gets its paths from the pipe, so its own arguments name none. Judge
      # by every path in the whole command: `ls kanban/doing/* | xargs rm`.
      # shellcheck disable=SC2086
      [ -n "$kind" ] && set -- $CMD ;;
    *)
      if printf '%s' "$verb" | grep -qxE "$MOVE_VERBS"; then kind="move"; shift
      elif printf '%s' "$verb" | grep -qxE "$DEL_VERBS"; then kind="del"; shift
      fi ;;
  esac
  [ -n "$kind" ] || continue
  for arg in "$@"; do
    root="$(under_board "$arg")" || continue
    where="${root#"$REPO"/}"
    if [ "$kind" = "del" ]; then
      deny "Blocked: a record under $where/ is never deleted (its id and history are the record). Cancel it instead: /fw-move <id> cancelled for a board card, or /fw-move-ops <id> closed --resolution cancelled for an operations record. Files inside a record's own bundle folder (<ID>/...) are yours to remove."
    else
      deny "Blocked: a record under $where/ moves only through the engine, which uses git mv and runs the gates: /fw-move <id> <folder> (board) or /fw-move-ops <id> <folder> (operations). A plain mv or cp loses the record's git history. To rename a record in place, use git mv."
    fi
  done
done < <(printf '%s\n' "$CMD" | sed -E 's/(\|\||&&|[;|])/\n/g')
exit 0

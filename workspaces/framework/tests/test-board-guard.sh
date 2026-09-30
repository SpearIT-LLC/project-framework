#!/usr/bin/env bash
# test-board-guard.sh — table test for hooks/board-guard.sh (TECH-253).
#
# Feeds the hook the PreToolUse payload Claude Code would send and checks the
# decision. No board has to exist: the hook judges paths, not files.
#
# Usage: bash tests/test-board-guard.sh      (from the plugin root; exit 1 on any miss)
set -uo pipefail

PLUGIN="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
R="/c/work/demo-repo"          # a repo root that need not exist
RW='C:\work\demo-repo'         # the same root as PowerShell spells it
FAILS=0

esc() { printf '%s' "$1" | sed -E 's/\\/\\\\/g; s/"/\\"/g'; }

t() { # t <allow|deny> <cwd> <command> [extra roots]
  local want="$1" cwd="$2" cmd="$3" extra="${4:-}" out got
  out="$(printf '{"session_id":"x","cwd":"%s","tool_name":"Bash","tool_input":{"command":"%s","description":"d"}}' \
          "$(esc "$cwd")" "$(esc "$cmd")" \
        | CLAUDE_PROJECT_DIR="$R" CLAUDE_PLUGIN_ROOT="$PLUGIN" SPRIT_BOARD_ROOTS="$extra" bash "$PLUGIN/hooks/board-guard.sh")"
  got=allow; printf '%s' "$out" | grep -q '"permissionDecision":"deny"' && got=deny
  if [ "$got" = "$want" ]; then printf 'ok     %-5s  %s\n' "$got" "$cmd"
  else printf 'WRONG  %-5s  (want %s)  %s\n' "$got" "$want" "$cmd"; FAILS=$((FAILS+1)); fi
}

# --- moves and copies --------------------------------------------------------
t deny  "$R" 'mv kanban/backlog/FEAT-901-x.md kanban/todo/'
t deny  "$R" 'cp kanban/backlog/FEAT-901-x.md kanban/todo/'
t allow "$R" 'git mv kanban/backlog/FEAT-901-x.md kanban/todo/'
t deny  "$RW" 'Move-Item kanban\backlog\FEAT-901-x.md kanban\todo\'
t deny  "$R" 'mv operations/open/INC-901-a.md operations/closed/'
# --- deletes -----------------------------------------------------------------
t deny  "$R" 'rm kanban/backlog/FEAT-901-x.md'
t deny  "$R" 'git rm -q kanban/backlog/FEAT-901-x.md'
t deny  "$R" 'rm -rf kanban'
t deny  "$R" 'rm kanban/doing/*'
t deny  "$R" 'rm -rf kanban/doing/FEAT-012'
t deny  "$R" "Remove-Item -Force \"$RW\\kanban\\todo\\BUG-2-y.md\""
t deny  "$R" "rm $R/operations/open/INC-901-a.md"
t deny  "$R" 'find kanban -name "*.md" -delete'
t deny  "$R" 'ls kanban/doing/*.md | xargs rm'
# --- where the command runs ---------------------------------------------------
t deny  "$R" 'cd kanban && rm doing/FEAT-1-x.md'
t deny  "$R/kanban/doing" 'rm FEAT-1-x.md'
t deny  "$R/docs" 'rm ../kanban/doing/FEAT-1-x.md'
# --- passes ---------------------------------------------------------------------
t allow "$R" 'rm kanban/doing/FEAT-012/scratch.log'
t allow "$R" 'mv kanban/doing/FEAT-012/a.txt kanban/doing/FEAT-012/b.txt'
t allow "$R" 'mv notes.md docs/notes.md'
t allow "$R" 'cat kanban/doing/FEAT-1-x.md | grep rm'
t allow "$R" 'ls kanban/doing && git status'
t allow "$R" 'bash ../plugin/scripts/fw-move.sh kanban 901 todo'
t allow "$R" 'rm workspaces/app1/templates/queues/kanban/README.md'
t allow "$R" 'git commit -m "rm old card" && git log kanban/'
t allow "$R" 'rm ../other-repo/kanban/x.md'
# --- SPRIT_BOARD_ROOTS: an extra root is guarded only when it is declared -----
t allow "$R" 'mv project-hub/work/todo/TECH-1-x.md project-hub/work/doing/'
t deny  "$R" 'mv project-hub/work/todo/TECH-1-x.md project-hub/work/doing/' 'project-hub/work'
t allow "$R" 'git mv project-hub/work/todo/TECH-1-x.md project-hub/work/doing/' 'project-hub/work'

[ "$FAILS" -eq 0 ] && echo "all passed" || { echo "$FAILS wrong"; exit 1; }

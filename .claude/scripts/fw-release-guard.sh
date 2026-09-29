#!/usr/bin/env bash
# .claude/scripts/fw-release-guard.sh — pre-release check for unfinished work (TECH-243)
#
# A release cuts from the REPO, not from done/. A card that entered implementation
# may have code in the repo whatever folder it is in now, so the guard asks of each
# unfinished state: can this card have code in the repo?
#
# SEVERITY TABLE — the states differ in what they mean for a release. Do not
# flatten this back to one rule:
#
#   Folder     Code in repo?                       Guard
#   doing/     maybe; actively changing            BLOCK (--force bypasses)
#   accept/    yes, by definition (implemented,    BLOCK (--force bypasses)
#              awaiting acceptance)
#   blocked/   only if it was started              has **Started:** date → WARN, confirm
#   hold/                                          no Started:           → INFO line only
#   todo/, backlog/  no, never started             not checked
#
# Why blocked/hold do not block: a card parked before any code existed does not
# affect a release, and blocking on it would make this the guard people --force
# past habitually. The **Started:** stamp (written by fw-move.sh on → doing, first
# start only) tells the two apart. A card parked before the stamp existed has none
# and reads as never started.
#
# A folder that does not exist is skipped, so accept/ and hold/ are guarded the day
# the board gains them. One loop serves every folder; folders differ only in severity.
#
# Usage: bash .claude/scripts/fw-release-guard.sh [--root <dir>]   (--root: testing only)
# Exit:  0 clear (INFO lines may print) · 1 blocked · 2 warnings need confirmation
set -uo pipefail

ROOT=""
if [ "${1:-}" = "--root" ]; then ROOT="${2:?--root requires a directory}"; shift 2; fi
[ -n "$ROOT" ] || ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "Error: not inside a git repository" >&2; exit 1; }
WORK_DIR="$ROOT/project-hub/work"

# folder:severity — the table above, as data
POLICY="doing:block accept:block blocked:park hold:park"

title_of() { sed -n '1{s/^# *//;p;q}' "$1"; }
id_of()    { basename "$1" | grep -oE '^[A-Z]+-[0-9]+(\.[0-9]+)*'; }
started()  { grep -oE '^\*\*Started:\*\* *[0-9]{4}-[0-9]{2}-[0-9]{2}' "$1" 2>/dev/null | grep -oE '[0-9-]{10}$'; }

BLOCKS=0; WARNS=0
for entry in $POLICY; do
  folder="${entry%%:*}"; sev="${entry##*:}"
  [ -d "$WORK_DIR/$folder" ] || continue
  for f in "$WORK_DIR/$folder"/*.md; do
    [ -f "$f" ] || continue
    case "$(basename "$f")" in README.md) continue ;; esac
    id="$(id_of "$f")"; [ -n "$id" ] || continue
    if [ "$sev" = "block" ]; then
      echo "BLOCK  $folder/  $id: $(title_of "$f")"
      BLOCKS=$((BLOCKS+1))
    elif d="$(started "$f")" && [ -n "$d" ]; then
      echo "WARN   $folder/  $id: $(title_of "$f")  (started $d; code may be in the repo)"
      WARNS=$((WARNS+1))
    else
      echo "INFO   $folder/  $id: $(title_of "$f")  (never started)"
    fi
  done
done

[ "$BLOCKS" -gt 0 ] && exit 1
[ "$WARNS" -gt 0 ] && exit 2
exit 0

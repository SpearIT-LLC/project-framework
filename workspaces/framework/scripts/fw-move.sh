#!/usr/bin/env bash
# fw-move.sh — the namespace-aware move engine of the ADR-009 build (FEAT-195).
#
# ONE engine, one policy table per namespace. A namespace is a root folder where
# STATUS IS THE FIRST PATH SEGMENT under the root; anything deeper (year buckets,
# release buckets, artifact bundles <ID>/, child items) is grouping, never status.
# Records are files <PREFIX>-<n>-<slug>.md; a sibling folder <PREFIX>-<n>/ is the
# record's artifact bundle and always moves with it.
#
# THE NAMESPACE IS AN ARGUMENT, NEVER INFERRED (BUG-215). Each namespace gets its own
# command; the command passes its namespace in. Inferring it from the id shape or the
# target folder was rejected: a bare numeric silently meant operations, and inferring
# from the folder name would have made folder names globally unique across namespaces
# forever, enforced by nothing.
#
# Namespaces (root queues beside the board — ADR-009 D2 as amended by TASK-213):
#   operations — root operations/; prefixes INC, REQ; folders open, onhold, closed
#                closed is terminal; -> closed REQUIRES a resolution code (--resolution,
#                which applies to the whole batch) and stamps **Closed:** and **Resolution:**.
#   kanban     — root kanban/; the board. Folder set authored in the repo-structure
#                diagram (see project-hub/docs/diagram-index.md). NOT WIRED UP HERE:
#                the live board is project-hub/work/ under the root /fw-move until the
#                ADR-009 D5 crossover, which is a single atomic moment at graduation.
#                The policy row below is the crossover's landing spot; the gates it
#                needs (dependencies, acceptance criteria, ripeness) are not ported yet.
#
# Usage:
#   fw-move.sh [--root <dir>] <namespace> <id|"id, id, ..."> <target> [--resolution <code>]
#   fw-move.sh [--root <dir>] <namespace> sweep   (operations: prior-year closed -> closed/YYYY/)
#   <namespace>: operations | kanban
#   <id>: INC-012, REQ-3, or bare 12 (one shared sequence per namespace makes it unambiguous)
#         A list is comma- or space-separated; quote it. Items are validated and moved
#         one at a time, continuing past failures, with a summary at the end (BUG-215).
#   codes: resolved | cancelled | duplicate | no-fault-found | rejected
#   --resolution applies to the WHOLE BATCH (BUG-215, superseding the 2026-09-07 design).
#   THE ENGINE NEVER PROMPTS. A -> closed with no --resolution is refused per record,
#   naming the valid codes; the human supplies one and runs again — the kanban experience.
#   Behaviour is identical with or without a terminal, which is what headless use needs.
#   A batch close shares one code because a batch close happens precisely when the records
#   share a root cause; the per-record *reason* lives in each record's Outcome section.
# --root is TESTING ONLY.
set -uo pipefail

ROOT=""
if [ "${1:-}" = "--root" ]; then ROOT="${2:?--root requires a directory}"; shift 2; fi
[ -n "$ROOT" ] || ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "Error: not inside a git repository" >&2; exit 1; }

# ---------------------------------------------------------------------------
# POLICY TABLE — one row per namespace. Folders and transitions are data; the
# gates each namespace needs are functions (see below), because a dependency
# lookup is not expressible as a list.
# ---------------------------------------------------------------------------
NAMESPACES="operations kanban"

operations_ROOT="operations"
operations_FOLDERS="open onhold closed"
operations_TRANSITIONS="open:onhold onhold:open open:closed onhold:closed"
operations_TERMINAL="closed"
# No gates: an operations record has no acceptance criteria and no dependencies.
# Its one policy — a resolution code on -> closed — lives in move_one, because it
# writes stamps rather than merely refusing.
operations_GATES=""

# kanban: authored folder set (repo-structure diagram).
#
# TRANSITIONS IS AN ALLOWLIST, not a denylist (FEAT-229.1). The old engine listed
# INVALID pairs and permitted everything else, which silently allows every pair
# nobody thought to forbid — backlog:done among them. Enumerate what is legal.
#
# The five settled folders only. `accept` and `cancelled` stay declared in FOLDERS
# with NO transitions: their semantics (what enters accept, whether cancelled is
# terminal, the closure code) are TASK-223 Group 2a and are not settled. FEAT-229.3
# adds their rows once they are. An unsettled pair stays illegal — that is the
# allowlist doing its job, not an omission.
#
# The pairs, and why each is legal:
#   backlog:todo    commit to work            todo:backlog    de-prioritize
#   todo:doing      start work                doing:todo      stop without abandoning
#   doing:done      finish                    todo:blocked    blocked before starting
#   backlog:blocked blocked before ranking    doing:blocked   blocked mid-flight
#   blocked:todo    unblocked, queued         blocked:backlog unblocked, de-prioritized
#   blocked:doing   unblocked, resume         done:blocked    NOT legal (see below)
#
# Deliberately absent, carried from the old engine's INVALID list:
#   backlog:doing — commit to work first (backlog → todo → doing)
#   done:*        — completed items are not reopened; create a new item.
#                   `done` is also in TERMINAL, which refuses it earlier with a
#                   clearer message; the absence here is the second lock.
kanban_ROOT="kanban"
kanban_FOLDERS="backlog blocked todo doing accept done cancelled"
kanban_TRANSITIONS="backlog:todo todo:backlog todo:doing doing:todo doing:done backlog:blocked todo:blocked doing:blocked blocked:backlog blocked:todo blocked:doing"
kanban_TERMINAL="done cancelled"
# The gates, as data (FEAT-229.2). Order is report order, not precedence: all of
# them run, so one invocation names every reason a move is refused.
kanban_GATES="gate_dependencies gate_markers gate_acceptance"

CODES="resolved cancelled duplicate no-fault-found rejected"

die() { echo "❌ $*" >&2; exit 1; }

# The namespace is the first positional argument. It is never inferred (BUG-215).
NS="${1:-}"
[ -n "$NS" ] || die "usage: fw-move.sh <namespace> <id|\"id, id, ...\"> <target> [--resolution <code>]  |  fw-move.sh <namespace> sweep"
echo "$NAMESPACES" | grep -qw "$NS" || die "unknown namespace '$NS' (known: $NAMESPACES)"
shift

# Resolve this namespace's policy row.
eval "NS_ROOT_REL=\"\$${NS}_ROOT\"; NS_FOLDERS=\"\$${NS}_FOLDERS\"; NS_TRANSITIONS=\"\$${NS}_TRANSITIONS\"; NS_TERMINAL=\"\$${NS}_TERMINAL\""
NS_ROOT="$ROOT/$NS_ROOT_REL"

# A namespace declared in the table with no transitions is not wired yet. Refuse
# rather than half-move a record. This is generic, not kanban-specific: it fired for
# kanban until FEAT-229.1 filled its row, and it is the guard any future namespace
# gets for free between being declared and being wired.
#
# NOTE: kanban's gates are wired (FEAT-229.2) — see the *_GATES rows above. The live
# board remains project-hub/work/ under the root /fw-move until the ADR-009 D5
# crossover; kanban here is exercised by fixtures until that moment.
if [ -z "$NS_TRANSITIONS" ]; then
  die "namespace '$NS' is declared but not active in this engine yet — its transitions are not wired"
fi

# Per-item failure inside a batch: report, mark, and keep going (BUG-215).
FAILED=0; MOVED=0; SKIPPED=0

# ---------------------------------------------------------------------------
# REPORT (BUG-225, merged into BUG-215). One formatter, used by every namespace,
# so the kanban row inherits the report by construction rather than diverging.
#
# Status first, fixed-width, left-aligned: the eye scans one column. A trailing
# status cannot align without padding every filename. The bundle is INLINE on its
# own record's row — that is what removes the misattribution, rather than
# re-ordering around it: a free-floating bundle line can no longer be attached to
# the wrong record by indentation. A failure's reason is on its own row, adjacent,
# because the report is read closely exactly when something failed.
#
# DECIDED (BUG-225's open question): the reason goes on the row, and ONLY on the row.
# A stderr copy was tried and removed — every failure printed twice and the two streams
# interleaved on a terminal, which is the detached-reason problem this card exists to fix.
# `die` still writes to stderr: that is a usage error about the whole invocation, not a
# per-record outcome, and it is the only thing a caller needs to read off stderr.
# ---------------------------------------------------------------------------
row() { # row <OK|FAILED|SKIPPED> <text>
  printf '  %-8s %s\n' "$1" "$2"
}
fail_item() { row FAILED "$*"; FAILED=$((FAILED+1)); }

# git mv with untracked fallback (fixtures and fresh records are often untracked)
gmv() { git -C "$ROOT" mv "$1" "$2" 2>/dev/null || mv "$1" "$2"; }

# ---------------------------------------------------------------------------
# GATES (FEAT-229.2). Which gates a namespace gets is DATA — the *_GATES row in
# the policy table — for the same reason its transitions are: policy belongs in
# the table, not in an if-chain inside the mover.
#
# Each gate takes <record> <target>, prints its own refusal via fail_item, and
# returns non-zero. The engine never prompts (BUG-215): a refusal names what is
# missing and the human runs again.
#
# RIPENESS IS NOT A GATE, and must never become one (ADR-007 D7). Whether a plan
# is *ready* is a judgment — an unchecked box, or the word "decide", is normal in
# a well-planned card — and the command's pre-implementation review enforces it.
# What a gate may read is a FACT that has already happened: which folder a
# dependency sits in, which state a checkbox carries. The distinction is the one
# TECH-177 draws for [?] and [h]: a marker records an event, not an opinion.
# ---------------------------------------------------------------------------

# Criteria live under "## Acceptance Criteria" and nowhere else in the record.
#
# WHY A SECTION AND NOT THE WHOLE FILE (TECH-166 item 4): the old engine greps
# for an unchecked box across the entire file, so PROSE QUOTING A MARKER counts
# as a live criterion. On 2026-09-22 that hard-blocked TECH-177 — whose own line
# 33 described this very bug, in backticks — and since the check ignores --force
# the only way through was rewording a true sentence to satisfy a faulty grep.
# Scoping to the section is the fix TECH-166 itself prescribes.
#
# Fenced blocks inside the section are skipped: a fence may legitimately show a
# marker as an example.
criteria_block() {
  awk '
    /^##[[:space:]]+Acceptance Criteria[[:space:]]*$/ { inblock=1; next }
    inblock && /^##[[:space:]]/                       { inblock=0 }
    inblock && /^```/                                 { fence = !fence; next }
    inblock && !fence                                 { print }
  ' "$1"
}

# Count criteria lines carrying one of the six states (see the fw-checkbox-states
# skill). Anchored at line start, allowing indentation, so an inline marker in the
# middle of a sentence is not counted.
count_state() { # count_state <file> <state char, or space>
  criteria_block "$1" | grep -cE "^[[:space:]]*- \[$2\]" || true
}

# --- GATE: acceptance criteria (target: done) ------------------------------
# TECH-177's contract, IMPLEMENTED, not restated (ADR-008). The authored source
# is skills/fw-checkbox-states/SKILL.md.
#
#   [ ] and [/] BLOCK        [x] and [-] PASS
#
# [-] passes BY DESIGN. Today's engines count only unchecked boxes, so [-] slips
# through because nothing looked — indistinguishable from correct until someone
# writes [/] and it sails past too. The rule is "cancelled work does not block
# completion", and it is written as that rule.
gate_acceptance() {
  local f="$1" target="$2" base open inprog
  [ "$target" = "done" ] || return 0
  base="$(basename "$f")"
  open="$(count_state "$f" ' ')"
  inprog="$(count_state "$f" '/')"
  if [ "$open" -gt 0 ] || [ "$inprog" -gt 0 ]; then
    fail_item "$base — $open unchecked, $inprog in progress: both block → done/ (mark [x] when done, [-] if cancelled)"
    return 1
  fi
  return 0
}

# --- GATE: markers (target: doing) -----------------------------------------
# [?] needs information; [h] something prevents completion. Both block → doing,
# because an unresolved marker means the card will fail again for a reason
# already known.
#
# The refusal NAMES THE MARKED LINE. A marker's whole job is to be a cursor onto
# the exact criterion, so a refusal that does not point at it has discarded the
# information the marker exists to carry.
gate_markers() {
  local f="$1" target="$2" base hit n
  [ "$target" = "doing" ] || return 0
  base="$(basename "$f")"
  n=0
  while IFS= read -r hit; do
    [ -n "$hit" ] || continue
    n=$((n+1))
    fail_item "$base — $(printf '%s' "$hit" | sed 's/^[[:space:]]*//')"
  done < <(criteria_block "$f" | grep -E "^[[:space:]]*- \[[?h]\]" || true)
  [ "$n" -eq 0 ] && return 0
  # The note sits on an indented continuation line beneath the marker, behind a
  # fixed label. That fixed label is the one thing here worth mechanizing: it is
  # what makes "a marker with no note" greppable.
  criteria_block "$f" | grep -E "^[[:space:]]+\*\*(Hold|Question):\*\*" \
    | sed 's/^[[:space:]]*/           /' || true
  return 1
}

# --- GATE: dependencies (target: doing) ------------------------------------
# Depends On: names whole cards that must reach done/ first. Never bypassable.
# The refusal names the dependency's CURRENT FOLDER: "not done" without saying
# where it is leaves the user to search the board by hand.
#
# SCOPE NOTE (FEAT-229.4): this gates the NAMED record only. Gating a dotted
# family per member needs addressable members, which BUG-241 shows the engine
# does not have yet. Deliberately out of scope here rather than half-built.
gate_dependencies() {
  local f="$1" target="$2" base deps dep found loc n
  [ "$target" = "doing" ] || return 0
  base="$(basename "$f")"
  deps="$(grep -m1 -i '^\*\*Depends On:\*\*' "$f" 2>/dev/null | sed 's/^\*\*[Dd]epends [Oo]n:\*\*//' || true)"
  [ -n "$deps" ] || return 0
  n=0
  for dep in $(printf '%s' "$deps" | grep -oE '[A-Za-z]+-[0-9]+(\.[0-9]+)*' || true); do
    found="$(find "$NS_ROOT" -type f -name "$dep-*.md" -printf '%P\n' 2>/dev/null | head -1 || true)"
    if [ -z "$found" ]; then
      fail_item "$base — depends on $dep, which is not on this board"
      n=$((n+1)); continue
    fi
    loc="${found%%/*}"
    if [ "$loc" != "done" ]; then
      fail_item "$base — depends on $dep (currently in $loc/), which must reach done/ first"
      n=$((n+1))
    fi
  done
  [ "$n" -eq 0 ]
}

# --- WIP warning — WARNS, NEVER BLOCKS (kanban section 5) ------------------
# A limit is a signal to a human, not a machine's veto: the move still succeeds.
#
# COUNTS .md ONLY (BUG-174). The old engine excludes .limit but not .gitkeep, so
# every count is inflated by one — verified 2026-09-22, doing/ reported 3/2 while
# holding two cards. The queue scaffold ships .gitkeep in every folder, so a naive
# file count is wrong from the very first move.
#
# SCOPE NOTE (FEAT-229.4 / BUG-240): this counts FILES, so a dotted family counts
# as N rather than the one WIP item TASK-219 says it is. It over-warns until .4
# lands; the limit is warning-only, so the cost is cosmetic.
count_items() { find "$1" -maxdepth 1 -type f -name '*.md' 2>/dev/null | wc -l | tr -d '[:space:]'; }

wip_warn() {
  local folder="$NS_ROOT/$1" limit count
  [ -f "$folder/.limit" ] || return 0
  limit="$(tr -d '[:space:]' < "$folder/.limit")"
  [ -n "$limit" ] || return 0
  count="$(count_items "$folder")"
  [ "$count" -ge "$limit" ] && echo "⚠️  WIP limit: $count/$limit items already in $1/"
  return 0
}

# Run every gate this namespace declares. ALL of them run — one invocation
# reports every reason a move is refused, rather than making the user fix one
# thing at a time and run again.
run_gates() { # run_gates <record> <target>
  local f="$1" target="$2" g rc=0 list
  eval "list=\"\${${NS}_GATES:-}\""
  for g in $list; do "$g" "$f" "$target" || rc=1; done
  return $rc
}

# ---------------------------------------------------------------------------
# sweep: operations closed/*.md whose Closed: year < current year -> closed/YYYY/
# ---------------------------------------------------------------------------
if [ "${1:-}" = "sweep" ]; then
  [ "$NS" = "operations" ] || die "sweep is an operations action (prior-year closed records into closed/YYYY/); '$NS' has no equivalent"
  [ -d "$NS_ROOT/closed" ] || die "no operations closed/ folder at $NS_ROOT_REL/"
  THIS_YEAR="$(date +%Y)"; MOVED=0
  for f in "$NS_ROOT"/closed/*.md; do
    [ -f "$f" ] || continue
    y="$(grep -m1 -oE '^\*\*Closed:\*\* *[0-9]{4}' "$f" | grep -oE '[0-9]{4}$' || true)"
    [ -n "$y" ] || { echo "⚠️  skipped (no Closed: stamp): $(basename "$f")"; continue; }
    [ "$y" -lt "$THIS_YEAR" ] || continue
    mkdir -p "$NS_ROOT/closed/$y"
    gmv "$f" "$NS_ROOT/closed/$y/"
    b="$(basename "$f")"; bundle="$NS_ROOT/closed/$(printf '%s' "$b" | grep -oE '^[A-Z]+-[0-9]+')"
    [ -d "$bundle" ] && gmv "$bundle" "$NS_ROOT/closed/$y/"
    echo "✅ $b → closed/$y/"; MOVED=$((MOVED+1))
  done
  echo "Sweep done: $MOVED record(s) bucketed."
  exit 0
fi

# ---------------------------------------------------------------------------
# move: <id> <target> [--resolution <code>]
# ---------------------------------------------------------------------------
RESOLUTION=""
ARGS=()
while [ $# -gt 0 ]; do
  case "$1" in
    --resolution) RESOLUTION="${2:?--resolution requires a code}"; shift 2 ;;
    *) ARGS+=("$1"); shift ;;
  esac
done
[ ${#ARGS[@]} -ge 2 ] || { echo "Usage: fw-move.sh $NS <id|\"id, id, ...\"> <$(echo "$NS_FOLDERS" | tr ' ' '|')> [--resolution <code>]" >&2; exit 1; }

# The target is the LAST argument; everything before it is the id list. This lets an
# unquoted list work too: fw-move.sh 1 2 3 closed
TARGET="$(printf '%s' "${ARGS[${#ARGS[@]}-1]}" | tr '[:upper:]' '[:lower:]')"
unset 'ARGS[${#ARGS[@]}-1]'
IFS=', ' read -ra IDS <<< "${ARGS[*]}"
# Drop empties left by ", ," or stray whitespace
CLEAN=(); for t in "${IDS[@]:-}"; do [ -n "$t" ] && CLEAN+=("$t"); done; IDS=("${CLEAN[@]}")
[ ${#IDS[@]} -gt 0 ] || die "no ids given"

# --resolution applies to the whole batch (BUG-215, superseding 2026-09-07). A batch
# close happens precisely when the records share a root cause, and sharing a cause means
# sharing a classification. Records that genuinely differ are closed separately.
# Validate the code ONCE, here, rather than per record: an unknown code is a usage error
# in the invocation, not a property of any one record.
if [ -n "$RESOLUTION" ]; then
  echo "$CODES" | grep -qw "$RESOLUTION" || die "unknown resolution '$RESOLUTION' (codes: $CODES)"
fi

# Namespace/target validation is list-wide: one target, one namespace policy.
[ -d "$NS_ROOT" ] || die "no $NS queue at $NS_ROOT_REL/ — create the first record with /fw-new-ops-record"
echo "$NS_FOLDERS" | grep -qw "$TARGET" || die "invalid target '$TARGET' — $NS folders: $NS_FOLDERS"

# ---------------------------------------------------------------------------
# move_one <id> — validate and move a single record. Never exits; returns non-zero
# on failure so the batch continues (BUG-215).
# ---------------------------------------------------------------------------
move_one() {
  local ID_IN="$1"
  local PREFIX NUM NUM_RE REL REC SOURCE BASE FULL_ID BUNDLE BUNDLE_NOTE DEST RES TODAY

  # The namespace came from the command line, so a bare numeric is unambiguous and a
  # prefix is decoration. Only the number is used to locate the record (BUG-215).
  NUM="$(printf '%s' "$ID_IN" | grep -oE '[0-9]+$' || true)"
  [ -n "$NUM" ] || { fail_item "$ID_IN — cannot parse an id"; return 1; }

  # Locate the record: status folder is the first segment; scan recursively (buckets)
  NUM_RE="$(printf '%s' "$NUM" | sed 's/^0*//')"
  REL="$(find "$NS_ROOT" -type f -name '*.md' -printf '%P\n' | grep -E "(^|/)[A-Za-z]+-0*${NUM_RE}-[^/]*\.md$" | head -1 || true)"
  [ -n "$REL" ] || { fail_item "$ID_IN — no $NS record with that id"; return 1; }
  REC="$NS_ROOT/$REL"; SOURCE="${REL%%/*}"; BASE="$(basename "$REC")"
  FULL_ID="$(printf '%s' "$BASE" | grep -oE '^[A-Z]+-[0-9]+')"

  if [ "$SOURCE" = "$TARGET" ]; then
    row SKIPPED "$BASE — already in $TARGET/"; SKIPPED=$((SKIPPED+1)); return 0
  fi
  if echo "$NS_TERMINAL" | grep -qw "$SOURCE"; then
    fail_item "$BASE — in $SOURCE/, which is terminal; open a new record instead"; return 1
  fi
  echo "$NS_TRANSITIONS" | grep -qw "$SOURCE:$TARGET" || { fail_item "$BASE — invalid transition $SOURCE → $TARGET (allowed: $NS_TRANSITIONS)"; return 1; }

  # Gates run AFTER the transition is known legal and BEFORE anything is moved
  # (FEAT-229.2). Order matters: an illegal transition is a usage error and its
  # message is the useful one, so it is not worth also listing a card's unmet
  # dependencies for a move that could never have happened.
  run_gates "$REC" "$TARGET" || return 1

  # THE ENGINE NEVER PROMPTS (BUG-215). A → closed with no code is refused, per record,
  # naming what is missing and the valid codes; the human supplies one and runs again.
  # The code was validated once at parse time, so there is nothing to re-check here.
  # This is identical with or without a terminal — no `read`, no /dev/tty, no `[ -t 0 ]`.
  RES="$RESOLUTION"
  if [ "$TARGET" = "closed" ] && [ -z "$RES" ]; then
    fail_item "$BASE — → closed requires a resolution: pass --resolution <$(echo "$CODES" | tr ' ' '|')>"
    return 1
  fi

  # Move record + bundle (bundle sits beside the record, named for the id).
  # The bundle is recorded, not printed: it goes INLINE on this record's row below,
  # which is what stops it being attributed to the record above (BUG-225).
  gmv "$REC" "$NS_ROOT/$TARGET/" || { fail_item "$BASE — move failed"; return 1; }
  BUNDLE="$(dirname "$REC")/$FULL_ID"
  BUNDLE_NOTE=""
  [ -d "$BUNDLE" ] && { gmv "$BUNDLE" "$NS_ROOT/$TARGET/"; BUNDLE_NOTE="  (bundle $FULL_ID/)"; }
  DEST="$NS_ROOT/$TARGET/$BASE"

  # Stamp on terminal move: fill existing Closed:/Resolution: lines, else insert after Opened:
  if [ "$TARGET" = "closed" ]; then
    TODAY="$(date +%Y-%m-%d)"
    if grep -qE '^\*\*Closed:\*\*' "$DEST"; then
      sed -i "s/^\*\*Closed:\*\*.*/**Closed:** $TODAY/" "$DEST"
    else
      sed -i "0,/^\*\*Opened:\*\*.*/s//&\n**Closed:** $TODAY/" "$DEST"
    fi
    if grep -qE '^\*\*Resolution:\*\*' "$DEST"; then
      sed -i "s/^\*\*Resolution:\*\*.*/**Resolution:** $RES/" "$DEST"
    else
      sed -i "0,/^\*\*Closed:\*\*.*/s//&\n**Resolution:** $RES/" "$DEST"
    fi
    git -C "$ROOT" add "$DEST" 2>/dev/null || true
    row OK "$BASE — Closed: $TODAY, Resolution: $RES$BUNDLE_NOTE"
  else
    # A batch prints its destination once in the header; a single move has no header,
    # so it carries the destination on its own row (BUG-225: single moves unchanged).
    if [ "${#IDS[@]}" -gt 1 ]; then
      row OK "$BASE$BUNDLE_NOTE"
    else
      row OK "$BASE → $TARGET/$BUNDLE_NOTE"
    fi
  fi
  MOVED=$((MOVED+1))
  return 0
}

# WIP warning fires ONCE per invocation, before anything moves — not per record.
# A batch of three into an over-limit folder is one situation the human is being
# told about, not three. It never blocks (kanban§5).
wip_warn "$TARGET"

# A batch gets a header and a summary; a single move keeps its own one-line output
# (BUG-225 — unchanged behaviour for the single case).
[ ${#IDS[@]} -gt 1 ] && echo "Move → $TARGET/"

for id in "${IDS[@]}"; do
  move_one "$id" || true
done

# Summary only for a batch. The exact shape of this line is asserted verbatim by
# UAT-33 and UAT-35 — do not reformat it without updating those cases.
if [ ${#IDS[@]} -gt 1 ]; then
  echo "📊 moved: $MOVED  skipped: $SKIPPED  failed: $FAILED"
fi
[ "$FAILED" -eq 0 ] || exit 1
exit 0

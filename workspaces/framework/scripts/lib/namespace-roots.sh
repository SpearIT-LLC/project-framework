#!/usr/bin/env bash
# namespace-roots.sh — where each record namespace lives, authored once (ADR-008).
#
# A namespace is a root folder whose records the move engine owns. Everything that
# must agree on WHERE the records are sources this file rather than spelling the
# folder itself: the move engine (fw-move.sh), the id scanner (fw-next-id.sh) and the
# board hooks (hooks/board-guard.sh, hooks/report-wip.sh). A guard that protected a
# different folder from the one the engine moves records in would be worse than none.
#
# INVARIANT (BUG-258): no record ever leaves its namespace root. The id scan and the
# hooks are correct only because of that.
#
# Sourced, never executed. Paths are relative to the repo root.
NAMESPACES="operations kanban"
operations_ROOT="operations"
kanban_ROOT="kanban"

# The folder a namespace implements work in — what a session should be told is in
# progress. Operations has no such state (open/onhold/closed), so it has none.
kanban_WIP="doing"

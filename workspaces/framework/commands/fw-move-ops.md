---
description: Move an operations record between open/onhold/closed (with closure code), or sweep prior-year closed records into year buckets
argument-hint: "<id|\"id, id, ...\"> <open|onhold|closed> [--resolution <code>]  |  sweep"
---

# /fw-move-ops - Move an Operations Record (ADR-009 build engine)

The operations half of the new build's move engine. One engine, one policy table
per namespace; **status is the first path segment under the namespace root**,
anything deeper (year buckets, artifact bundles `INC-nnn/`) is grouping, never
status. Namespaces are root queues beside the board (ADR-009 D2 as amended by
TASK-213): operations lives at `operations/`.

**One command per namespace; the namespace is never inferred** (BUG-215). This
command always passes `operations` to the script. Inferring it from the id shape
or the target folder was rejected — a bare numeric silently meant operations, and
inferring from the folder name would have made folder names globally unique across
namespaces forever, enforced by nothing.

The kanban row exists in the script's policy table but is **not wired up**: the
live board is `project-hub/work/` under the root `/fw-move` until the ADR-009 D5
crossover, a single atomic moment at graduation. `/fw-move-ops kanban ...` is not
a thing — the namespace is fixed by which command you run.

## Operations policy (what the script enforces)

- Folders `open/ → onhold/ → closed/`; `open ↔ onhold` both ways; `closed` is
  terminal (reopening = a new record).
- `→ closed` **requires** a resolution code: `resolved | cancelled | duplicate |
  no-fault-found | rejected` — the outcome is a field, not a folder. The engine
  stamps `**Closed:**` and `**Resolution:**`. Supply it with `--resolution` for a
  single record; a batch is prompted per record, because the code classifies one
  record and the close gate is already per record (BUG-215).
- The record's artifact bundle (`INC-nnn/` sibling folder) moves with it.
- No kanban gates (ripeness, dependencies, acceptance criteria) apply to ops.

## Steps

1. **For `→ closed`, run the close gate first** (the judgment step, from the
   fw-troubleshoot pattern, FEAT-202): ask the user for the closure code and a
   one-line reason; for an incident ask "Durable knowledge? — a kb research
   case or cookbook recipe to link, or explicitly *nothing durable*?" and put
   the answer in the record's **Outcome** section before moving.

2. **Run the script:**

   ```bash
   bash "${CLAUDE_PLUGIN_ROOT}/scripts/fw-move.sh" operations <id> <target> [--resolution <code>]
   bash "${CLAUDE_PLUGIN_ROOT}/scripts/fw-move.sh" operations "<id, id, ...>" <target>
   ```

   **Batch (BUG-215).** The id argument accepts a list, comma- or space-separated;
   quote it. Items are validated and moved one at a time and the run continues past
   a failure, so a batch may partially apply — the summary line
   (`moved / skipped / failed`) is what reports it. A record already in the target is
   *skipped*, not failed. Exit is non-zero if any item failed.

   **`--resolution` is per record, so it is refused with a list.** A batch
   `-> closed` prompts for each record's code in turn; with no terminal to prompt,
   those items fail rather than silently sharing one code.

   Ids: `INC-012`, `REQ-3`, or bare `12`. If the script rejects the move
   (invalid transition, closed-is-terminal, missing/unknown code), report its
   message verbatim and stop — never `git mv` a record by hand.

3. **Sweep** (on demand, when `closed/` gets long): records closed in a prior
   calendar year move to `closed/YYYY/`; nothing changes status.

   ```bash
   bash "${CLAUDE_PLUGIN_ROOT}/scripts/fw-move.sh" operations sweep
   ```

4. **Report** what moved (and any stamp or bundle lines the script printed).

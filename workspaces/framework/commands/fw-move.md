---
description: Move an operations record between open/onhold/closed (with closure code), or sweep prior-year closed records into year buckets
argument-hint: "<id> <open|onhold|closed> [--resolution <code>]  |  sweep"
---

# /fw-move - Move a Record (ADR-009 build engine)

The namespace-aware move engine of the new build. One engine, one policy table
per namespace; **status is the first path segment under the namespace root**,
anything deeper (year buckets, artifact bundles `INC-nnn/`) is grouping, never
status. Today only the **operations** namespace is active here — the kanban
policy slot fills at board crossover (ADR-009 D5); until then the live board
keeps using the root `/fw-move`.

## Operations policy (what the script enforces)

- Folders `open/ → onhold/ → closed/`; `open ↔ onhold` both ways; `closed` is
  terminal (reopening = a new record).
- `→ closed` **requires** `--resolution <code>`: `resolved | cancelled |
  duplicate | no-fault-found | rejected` — the outcome is a field, not a folder.
  The engine stamps `**Closed:**` and `**Resolution:**`.
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
   bash "${CLAUDE_PLUGIN_ROOT}/scripts/fw-move.sh" <id> <target> [--resolution <code>]
   ```

   Ids: `INC-012`, `REQ-3`, or bare `12`. If the script rejects the move
   (invalid transition, closed-is-terminal, missing/unknown code), report its
   message verbatim and stop — never `git mv` a record by hand.

3. **Sweep** (on demand, when `closed/` gets long): records closed in a prior
   calendar year move to `closed/YYYY/`; nothing changes status.

   ```bash
   bash "${CLAUDE_PLUGIN_ROOT}/scripts/fw-move.sh" sweep
   ```

4. **Report** what moved (and any stamp or bundle lines the script printed).

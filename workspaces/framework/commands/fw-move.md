---
description: Move a board work item between kanban folders — gated by the engine, with the pre-implementation review on → doing
argument-hint: "<id|\"id, id, ...\"> <backlog|todo|doing|accept|done|blocked|hold|cancelled>"
---

# /fw-move - Move a Board Work Item (ADR-009 build engine)

The kanban half of the new build's move engine — the sibling of `/fw-move-ops`. One
engine, one policy table per namespace; **this command always passes `kanban`**. The
namespace is never inferred from the id or the folder (BUG-215).

**Board location.** The engine acts on `kanban/` at the repo root, created by the first
`/fw-new`. In a repo whose live board is elsewhere (the framework repo's
`project-hub/work/`, until the ADR-009 D5 crossover), there is no `kanban/` and the
engine refuses — it cannot touch a board it was not built for.

## The division of labor — read this before helping

**The engine decides; you judge.** Every rule that is a *fact* — which transitions are
legal, whether dependencies are in `done/`, which checkbox state a criterion carries, the
WIP count, whether a dotted family moves together, where a spike archives — is enforced
by `fw-move.sh`. None of it is restated here (ADR-008): read the engine's refusal, don't
predict it.

What the engine cannot do is **judgment**, and that is this command's whole job:

- **Ripeness is not a gate, and must never become one** (ADR-007 D7). Whether a plan is
  ready to implement is decided by the **pre-implementation review** on `→ doing` — by
  you, with the user — never by a script check.
- **Never work around a refusal.** Don't `git mv` a card by hand, don't tick a checkbox
  or delete a `Depends On:` to get a move through, and don't retry via a different path
  the user didn't choose. A refusal is information; bring it to the user.

## Steps

1. **Pre-move, by target** (skip when nothing applies):
   - **`→ cancelled`** — ask why, and write a free-text `**Cancellation Reason:**` into
     the card header before moving. There is no closure code on the board (TASK-242 D4):
     the `cancelled/` folder *is* the outcome. The state is terminal, so ask once — the
     reason is what stops the work being re-proposed later.
   - **`→ blocked`** — ask what the card is waiting on. When the external party is
     nameable, fill `**Blocked By:**` (and `**External Reference:**` if there is one);
     both are optional (TASK-242 D3). If a single criterion is what's stuck, mark that
     line `[h]` or `[?]` with its note — see the `fw-checkbox-states` skill.
   - **`→ hold`** — confirm it is a *decision to prioritize other work*. If something
     external is stopping it, it belongs in `blocked/` instead: the two differ by
     cause, not severity.
   - **`→ doing`, `→ accept`, `→ done`, and the rest** — nothing before the move.

2. **Run the engine:**

   ```bash
   bash "${CLAUDE_PLUGIN_ROOT}/scripts/fw-move.sh" kanban <id> <target>
   bash "${CLAUDE_PLUGIN_ROOT}/scripts/fw-move.sh" kanban "<id, id, ...>" <target>
   ```

   Ids: `FEAT-012`, `12`, or a dotted child `FEAT-012.1`. A list is comma- or
   space-separated; quote it. **Naming any member of a dotted family moves the whole
   family** — that is the engine's rule (tight coupling, TASK-219), so don't ask the
   user whether to move the rest.

   **Reading the output.** One row per card — `OK` / `SKIPPED` / `FAILED` with the
   reason on the row; family members appear as indented `↳` rows; a batch adds a
   `Move → <target>/` header and a `moved / skipped / failed` summary. A `⚠️ WIP limit`
   line is a warning — the move still happened.

   **On a refusal, report the rows verbatim and stop.** Then offer the recovery that
   fits, as a question — never as an action already taken:
   - *invalid transition* → name the legal path (e.g. `backlog → todo → doing`).
   - *depends on X (currently in Y/)* → X must reach `done/` first; offer to look at X.
   - *N unchecked, M in progress* → offer to walk the open criteria with the user; each
     one is `[x]` only if it is actually done, `[-]` only if the user cancels it.
   - *`[?]` / `[h]` line* → the quoted line and its note are the blocker; resolve that.
   - *terminal* → open a new card with `/fw-new`.

3. **Post-move, by target:**
   - **`→ doing` — the pre-implementation review (REQUIRED).** Read the card
     completely. Present: what is being built, the design decisions already made (with
     their reasons), any open questions (`TBD`, `decide`, `Option A/B`, `[?]`), and the
     scope boundary. **Then STOP and wait for the user's go-ahead before implementing.**
     If the review shows the plan is not ready, say so and offer `/fw-move <id> todo` —
     it is a legal move and the honest one.

     *Why after the move, not before:* the engine's gates are facts and cheap; running
     them first means a card with an unmet dependency is refused before anyone spends a
     review on it.
   - **`→ accept`** — tell the user what to accept: the card's acceptance criteria, and
     how to check them. `accept/` has exactly two exits — `done` when accepted, `doing`
     to refine.
   - **`→ done`** — the engine stamps `**Completed:**`; never hand-edit it. A spike
     leaves the board for `history/spikes/` — report where it went.
   - **`→ done` or `→ cancelled`** — offer to commit (default yes):
     `feat: Complete <ID> - <title>` or `chore: Cancel <ID> - <reason>`.

4. **Report** what moved, what was refused and why, and any archive destination the
   engine printed.

## Policy reference

The transition set, gates and archival rules are authored in the policy table and gate
functions of `scripts/fw-move.sh`; the flow is summarized for humans in the board's
`kanban/README.md`. Checkbox semantics: the `fw-checkbox-states` skill.

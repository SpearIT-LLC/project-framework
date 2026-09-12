# Feature: The Close Gate Enforces the Durable-Knowledge Hand-off

**ID:** FEAT-226
**Type:** Feature
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-09-11
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

Closing an incident is supposed to route what was learned into the kb. Today nothing
enforces that: the close gate's durable-knowledge question is **prose in a command file**,
and an AI that skips it closes the record exactly as successfully as one that asks it.

This is the highest-value gap in the operations workflow, because the kb hand-off is the
*entire point* of recording incidents. A record that closes without it leaves the
diagnosis in a file nobody will search.

## Evidence

**The instruction exists at three layers and is enforced at none.**

The close gate ([`commands/fw-move-ops.md:39-43`](../../../workspaces/framework/commands/fw-move-ops.md#L39-L43)):

> ask the user for the closure code and a one-line reason; for an incident ask
> "Durable knowledge? — a kb research case or cookbook recipe to link, or explicitly
> *nothing durable*?" and put the answer in the record's **Outcome** section before moving.

The record template ([`templates/records/ops-record.md`](../../../workspaces/framework/templates/records/ops-record.md)):

> ## Outcome
> *How it ended. If an incident produced durable knowledge, link the kb research case or
> cookbook recipe here (fw-troubleshoot close gate); otherwise say "nothing durable"
> explicitly.*

The move engine stamps `Closed:` and `Resolution:`
([`scripts/fw-move.sh:195-208`](../../../workspaces/framework/scripts/fw-move.sh#L195-L208))
and **never reads the Outcome section**. No check, no refusal, no warning.

**This is ADR-008 Root 2** — *an instruction the AI merely reads is not a guardrail* — in
the one workflow whose value is the knowledge it captures.

**The asymmetry with kanban makes it sharper.** `→ done` is blocked mechanically by
unchecked acceptance criteria. The operations equivalent has no gate at all.

**No live evidence either way.** This repo holds zero real ops records (verified
2026-09-11), and `framework-uat`'s are fixtures. So this is a defect in the mechanism, not
a measured failure rate — which is the argument for fixing it *before* real volume arrives
and the retrofit cost starts compounding (the same argument TASK-217 makes about kb
provenance).

## Design

**The value split, settled in discussion 2026-09-11.** Three artifacts, three jobs:

| Artifact | Holds | Value |
|---|---|---|
| `Resolution:` code | One of five words | Filtering and counting — macro level only |
| Outcome reason | One line, per record | Why *this* record closed |
| **kb entry** | The diagnosis | **Solving the next one** |

Gary: *"A 'code' only records basic information about the closure. The value is some record
of how we identified the problem and resolved it."* Correct — so the code stays cheap and
the design attention goes here. **The ticket carries a link to the kb when closed.**

**"Nothing durable" is a legitimate answer.** Most requests produce no knowledge, and many
incidents genuinely don't. So the gate cannot demand a kb link.

**What it can demand:** that the Outcome section is *resolved one way or the other* — a kb
link, or an explicit "nothing durable". That is greppable, the same class of check as the
acceptance-criteria gate, and it makes a skipped question fail loudly instead of silently.

**Open design questions:**

- Does the check apply to `REQ` as well as `INC`? The close gate asks the durable-knowledge
  question for incidents only. A request that reveals a durable recipe is plausible but not
  the common case.
- Is an unresolved-but-non-empty Outcome (prose that is neither a link nor the literal
  phrase) accepted, warned, or refused? Refusing risks a fight with legitimate free text;
  accepting risks the check becoming decorative.
- Where the kb entry is *created* — the close gate can link an existing entry, but creating
  one mid-close is a larger interaction. `fw-troubleshoot` already produces research cases;
  the hand-off may be "link the case the skill made" rather than "write one now."

## Acceptance Criteria

- [ ] Closing an incident with an unresolved Outcome section is refused, naming what is
      missing and both valid answers (a kb link, or "nothing durable")
- [ ] "Nothing durable" closes cleanly — the gate never demands a kb entry that should not
      exist
- [ ] A kb link in Outcome satisfies the gate, and the link is validated as resolving to a
      real kb path (not merely present)
- [ ] The check lives in the script, not in command prose — an AI that never reads the
      command file still cannot close past it
- [ ] Batch closes enforce it **per record**: one shared `--resolution` code, but each
      record's Outcome answered on its own (see BUG-215 supersession, 2026-09-11)
- [ ] Validated: **AI** — a scripted close with an empty Outcome is refused;
      **Human** — a UAT case in `framework-uat` closing one incident each way
      (kb link / nothing durable / empty → refused)

## Related

- **TASK-217** — kb staleness and provenance metadata. Same *prose→mechanism* pattern
  applied to the kb; these two are the kb's trust story together.
- **FEAT-209** — kb sub-topic depth. Determines what a "kb link" resolves to.
- **FEAT-202 / `fw-troubleshoot`** — produces the research cases this gate links to. The
  close gate's question is lifted from that skill's pattern.
- **BUG-215** — the operations close gate's `--resolution` handling; superseded
  2026-09-11 to a shared batch code, which is what makes the per-record Outcome the thing
  that must stay per-record.
- **Roadmap D2** — the kb deliverable. This card is kb work that happens to fire at a move.

**Sequencing note:** deliberately **not** built now. The kb hand-off should be designed
with the kb feature (third in the agreed feature order: kanban → operations → kb →
workspaces → other), not ahead of it — designing it before kanban and operations settle is
the guessing pattern this project keeps catching.

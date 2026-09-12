# Tech: A SPIKE Template, and the Invalidation Question on Every Feature

**ID:** TECH-228
**Type:** Tech
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-09-11
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

Make cheap early spikes the path of least resistance, in two mechanisms:

1. **A SPIKE gets its own template** — one question, a timebox, exit criteria stated as a
   *decision*. Today all five types share one `work-item.md`, so a SPIKE is shaped exactly
   like a FEAT.
2. **Every feature file names the one unknown that could invalidate it**, and that question is
   sequenced *first* — before the valuable work, regardless of value.

## The Problem

**The type exists; the discipline does not.** The new build accepts SPIKE
([`fw-new.sh:30`](../../../workspaces/framework/scripts/fw-new.sh#L30)) and even coaches
toward it — *"SPIKE — time-boxed work whose deliverable is an answer"*
([`fw-new.sh:126`](../../../workspaces/framework/scripts/fw-new.sh#L126)) — but
`templates/records/` holds a single `work-item.md` for all five types. A created SPIKE has no
timebox field, no question field, and no exit criteria. It is a card with a different prefix.

Gary, 2026-09-11: *"Sometimes I'll do the cheap poc spikes but probably not as often as I
should."* The reason is mechanical, not a discipline failure: **nothing about creating a spike
makes it feel different from creating a card.**

### The old framework's template is the second reason

`framework/templates/work-items/SPIKE-TEMPLATE.md` exists and is **355 lines across 22
sections** — Findings with per-finding confidence levels, Recommendations with trade-offs,
Alternative Approaches, Risks with likelihood/impact/mitigation, a Retrospective, and an
Implementation Checklist.

**It is long to fill in and its output is a report.** A spike should be the inverse: **short
to fill in, output is a decision.** SPIKE-227 answers one question in a two-hour box;
completing that template honestly would cost more than the spike.

It also carries `Theme:` and `Planning Period:` — the old roadmap model, superseded by
FEAT-198.

**Most of those 22 sections are what a spike *produces*, not what it needs at creation.** A
findings section with three pre-numbered slots and confidence ratings is a reporting scaffold
imposed before anything is known.

## Why This Sequencing Rule and Not Large-Org Process

Reviewed what a large development department would do here. Three practices are worth taking —
discovery as a funded phase with an exit gate, sequencing by *risk* rather than value, and
dependency mapping before commitment. The rest of their sequencing machinery
(estimation ceremonies, capacity planning, phase gates, RACI) exists to solve **coordination
among many people and commitment to stakeholders who cannot inspect the work** — overhead that
buys nothing for a single practitioner who holds the whole design in their head.

**The failure mode of copying it is already on the record here:** `ROADMAP-DELIVERABLES.md` is
what a large org would have produced, and its own reconciliation notes say the derived half
drifted twice while the ordering was never wrong.

**So the rule is deliberately small:** one named question per feature, answered early. Not a
phase, not a gate, not a ceremony.

## Design

### The SPIKE template — a carry-in, deliberately trimmed

Per `workspaces/framework/CLAUDE.md`: read the history, don't inherit the structure. The old
template is mined for what earned its place; the rest does not carry forward.

**Carried in, with reasons:**

- **Timebox with an explicit stop rule.** The old template's line 110 — *"Stop at time box
  even if investigation incomplete. Document what's left and whether to continue."* — is the
  whole discipline in one sentence. Keep it verbatim in spirit.
- **"What decision depends on this?"** (old line 42). The right question, and it forces the
  spike to justify itself before it starts.
- **Out of Scope.** Spikes sprawl; the old template guards this and the guard works.
- **The research/POC split** (old lines 338-354). A research spike is a doc; a POC spike is a
  folder under `project-hub/poc/SPIKE-NNN-description/` holding the doc *and* code artifacts.
  `SPIKE-142`'s move-command harness is the POC form. This is a genuine structural insight and
  the new build has no equivalent.
- **Spikes archive to `history/spikes/`, never `history/releases/`** (old line 336) — they are
  for learning, not delivering. This is a **lifecycle gap in the new build**; see Related.

**Not carried, with reasons:**

- **Findings / Detailed Findings / Answers / Recommendations / Alternative Approaches /
  Risks / Retrospective** — these are what a spike *produces*. Pre-structuring them with
  numbered slots and confidence ratings imposes a reporting scaffold before anything is known,
  and is most of the 355 lines.
- **Implementation Checklist** — a spike's exit criteria *are* its checklist.
- **`Theme:` / `Planning Period:`** — the old roadmap model, superseded by FEAT-198.

**Added, not in the old template:**

- **The Question — one question, singular.** The old template has a "Research Questions"
  section with three numbered slots, which invites a spike to answer three things and finish
  none. A spike with three questions is three spikes, or it is a card.
- **Exit Criteria phrased as a decision**, with candidate outcomes named up front — and one of
  them must be *"not viable"*, or the spike cannot honestly reach that answer.

`SPIKE-227` was written to this shape by hand and is the worked example: ~60 lines against the
old template's 355.

### The invalidation question on feature files

A section, **What Could Invalidate This**, immediately after *Why It Exists*: the single
unknown that could kill or block the feature, and the card that answers it.

Already applied to both existing feature files:
- **time-tracking** — the data source (transcripts are a third-party private format) → SPIKE-227
- **kanban** — the FEAT-021 / TECH-082 parent-child conflict, which blocks the MVP because no
  work-item template can be authored until it resolves

### Open design questions

- Does the create gate **ask** for the timebox and question, or only provide fields? Asking
  makes the difference felt; it also adds friction to the one thing we want to be cheap.
- Should a spike past its timebox be surfaced anywhere (it is a *finding*, not a failure), or
  is that reporting's problem?
- Is "What Could Invalidate This" required on every feature file, or omitted when a feature
  genuinely has no killer unknown? **Recommendation: required, with "nothing — the mechanism
  is proven" as a legitimate answer**, so the question is always asked.

## Acceptance Criteria

- [ ] A SPIKE created through the create gate carries the question, timebox, and
      decision-shaped exit criteria fields — visibly different from a FEAT
- [ ] The template is **short enough to fill in at creation** — target under 80 lines against
      the old template's 355; a spike that costs more to write up than to run will not be run
- [ ] `work-item.md` continues to serve FEAT/BUG/TECH/TASK unchanged
- [ ] The feature template (when authored) includes **What Could Invalidate This** as a
      required section
- [ ] Every existing feature file has the section filled — with "nothing" being an acceptable
      answer given a reason
- [ ] Validated: **AI** — creating one of each type yields the right shape; **Human** — a real
      spike created during ordinary work feels different to create and is finished by a
      decision

## Related

- **SPIKE-227** — the worked example; written by hand to the shape this card would generate.
- **FEAT-175** — the board create gate that must resolve a template per type. This card adds a
  type to resolve; it is a **dependency on FEAT-175's template resolution**, not separate work.
- **TASK-219 / kanban§6** — board conventions. The template set is part of that inventory.
- **kanban§8** — acceptance criteria vs sub-tasks. A spike's exit criteria are the sharpest
  case of a *testable condition* that is not a work checklist.

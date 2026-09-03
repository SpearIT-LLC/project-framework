# Task: `Workspace:` Field on Operations Records

**ID:** TASK-214
**Type:** Task
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-09-01
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

Ops records gain a `**Workspace:**` field, the way kanban cards already carry one
(`Workspace: framework` on every board item). Blank-or-real: a real workspace name, or
blank meaning "not known yet, or belongs to none."

This is the piece that makes TASK-213's root move **better rather than merely tidier**.
Today an ops record is scoped by living inside `workspaces/operations/`; move the queue
to root and that implicit scoping disappears. The field replaces it explicitly — the
same way the board scopes its cards.

## The Scaling Case

A contractor with Honda and Toyota both sending tickets gets, today, one
`workspaces/operations/` for both with nothing distinguishing them — or two ops
workspaces, at which point `fw-next-id.sh`'s one-shared-sequence fractures and INC-001
exists twice. A `Workspace:` field scopes without fracturing the sequence.

## Decisions (2026-09-01, Gary)

1. **Blank-or-real. No freeform workspace names.**

   Considered and rejected: freeform text for tickets with no corresponding
   project/product. Rejected because arbitrary text drifts — `honda`, `Honda`,
   `honda-hpc`, `Honda HPC` become four values across a year of tickets, and every
   derived view (reporting, per-workspace slices, the calendar) silently splits. Same
   class of failure as the `Assigned: Widget` casing collision found 2026-09-01, and
   the reason FEAT-211 exists.

2. **Blank is a legal resting state**, not a gap to be filled. A ticket may arrive
   before anyone knows where it belongs, belong nowhere (a one-off password reset, a
   question), and may legitimately **close** unattached. Forcing a workspace at intake
   would recreate the "no legal state between created and fully filled" trap BUG-212
   just fixed. Blank means "not known yet", is greppable, and commits nothing false —
   the convention BUG-207 and BUG-212 established for contacts.

3. **An unresolvable value warns, it does not fail.** Precedent: `fw-contacts.sh`
   accepts any workspace name in `Assigned:` and warns when it names a workspace that
   does not exist (the live `ghost-ws` warning). Ops inherits that behaviour — visible
   drift beats silent drift, and a warning never blocks intake.

4. **What an unattached ticket "relates to" does not get a freeform field.** The
   `## What happened / What is requested` section already carries the subject in prose —
   "VPN drops for the Toyota CAD team" says what it relates to. A `Relates to:` free-text
   field would be a second home for the same fact (ADR-008).

## Proposed: `Related:` for record-to-record links only

**Not yet decided — needs Gary's call.** The one gap prose does not cover is a ticket
that relates to *another record*: a duplicate INC, a follow-on REQ, a kanban card that
came out of it, a kb case. Those are cross-references, not narrative, and the framework's
convention for them is links (`Contacts:` shows the pattern).

Proposal: `**Related:**` holds **ids and links only** — never free text. Prose keeps the
narrative, `Related:` keeps the pointers, neither restates the other.

Open: is this needed now, or does `Customer ref:` plus prose cover enough until a real
case demands it? Filing the option rather than the implementation.

## Evidence (2026-09-03, UAT)

First real intake that needed the field: `REQ-006-new-widget-install` in framework-uat.
Gary's intake: "It's for the Rustic Robotics project. Barney is a SpearIT employee."
With no field for the project, the AI first wrote `Customer: Rustic Robotics` into the
body (wrong — Rustic Robotics is the project, not a customer ticket source), then
improvised a `**Project:**` header the template does not have. Gary's question at the
time: "Do we associate a project/product with each INC/REQ? Make it optional?" — the
answer is this card; Gary agreed an optional field is right. The record was reconciled
to the decisions above: `Workspace:` blank (no `rustic-robotics` workspace exists in that
repo), the project named in prose.

Two notes for the open questions:

- `Contacts:` alone cannot carry the association — Barney is the install *target*, not
  the customer, and his contact record says SpearIT. The field is needed, not merely nice.
- The intake step should ask "Which workspace is this for?" and accept blank; the
  command doc should say so.

## Scope

- `templates/records/ops-record.md`: add `**Workspace:**`, with the blank-means-unknown
  rule in the stripped comment header.
- `fw-new-ops-record.sh`: seed the field blank (never a placeholder token — BUG-212).
- A validation pass warning on unresolvable values. **Check whether this can reuse
  `fw-contacts.sh`'s existing workspace-resolution logic** rather than writing a second
  implementation (ADR-008 — one home for the rule).
- `/fw-new-ops-record` command doc: what the field means, when to leave it blank.

## Open Questions (resolve before → doing)

- [ ] `Related:` — adopt now, or defer until a real case demands it?
- [ ] Where does the warning fire: at create, at move, in a `--check` pass, or all
      three? (Contacts warns at generate-time, which has no ops equivalent.)
- [ ] Does an ops record ever need **more than one** workspace? A ticket spanning two
      products is plausible. Contacts solved the analogous problem with repeatable
      `Assigned:` lines — but multi-valued scope complicates every derived view, so
      single-valued unless there is evidence.

## Acceptance Criteria

- [ ] `Workspace:` present on the template, seeded blank, no placeholder token
- [ ] A record with a blank `Workspace:` is valid, parses, and closes without warning
- [ ] A record naming a non-existent workspace warns (does not fail) and names the value
- [ ] The workspace-resolution rule has one implementation, shared with contacts
- [ ] Verified against the built plugin, not the source tree (TECH-188)

## Related

- **TASK-213** — the root move this field enables; land together.
- **FEAT-211** — contact assignment grammar; same drift concern, same resolution rule.
- **BUG-207 / BUG-212** — the blank-means-unknown convention this follows.
- **FEAT-196 / FEAT-199 / FEAT-200** — reporting, `Due:` surfacing, calendar; all consume
  workspace scope and are the reason drift matters.

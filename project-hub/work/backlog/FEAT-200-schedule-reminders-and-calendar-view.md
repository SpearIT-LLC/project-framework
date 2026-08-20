# Feature: Schedule Reminders and the Calendar View

**ID:** FEAT-200
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-08-20
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

A schedule/reminder capability with a life of its own, layered above FEAT-199's
due-date surfacing: a *calendar view* of everything dated — due dates, recurrence
definitions (month-end close), planning periods, possibly meetings — and eventually
active reminders rather than consult-time surfacing only.

Filed from TASK-197 refinement (Gary, 2026-08-20). Deliberately separate from
FEAT-199: 199 is the foundation (one `Due:` field convention + overdue/due-soon
listing at `/fw-status`); this item is the schedule product built on that data.

## The granularity question (the item's core open question)

Gary: *"Do I maintain 1 calendar per person, 1 per repo, or 1 per workspace?"*

**Proposed answer: none of them is maintained — every calendar is derived.** A
hand-kept calendar would be a second home for dates already written in records and
definitions — the ADR-008 pattern. The schedule *data* has one home each (the `Due:`
field on the record; the recurrence definition in the ops workspace); a *calendar* is
a generated view over that data, so granularity is just the filter applied:

- **per workspace** — a filter (`Workspace:` field), not a thing to maintain
- **per repo** — the natural output of a framework command (`/fw-calendar`?): the
  whole customer's dated obligations, grouped by workspace
- **per person** — what a solo contractor actually wants each morning: an aggregation
  *across* customer repos. That layer lives outside any one repo (a script over N
  repos, or export), and is the part with "a life of its own."

## Open Questions (resolve before → doing)

- [ ] What is dated content, v1? Four source shapes identified (2026-08-20), each with
      one authored home the calendar derives from — nothing is ever only a card:
      1. kanban cards with `Due:` (planned work);
      2. operations records with `Due:` (live ops flow);
      3. the ops workspace's **schedule definition** — recurring entries (month-end
         close) *and* one-shot future obligations (domain renewal) — no record exists
         until mint-on-observation creates one at due time;
      4. **plan-artifact milestones** — dated lines in a workspace `ROADMAP.md`
         (FEAT-198), machine-readable convention; for a sow, the contract's key dates
         transcribed into `requirements/` (the signed PDF is the legal authority but
         unparseable — the transcription is the one machine-readable home, ADR-008-ok).
      Decide v1 subset; meetings/ content — decide.
- [ ] Per-person aggregation mechanism: a multi-repo script, an exported feed
      (e.g. .ics into a real calendar app), or out of scope for v1?
- [ ] Active reminders vs derived view only: does anything ever *push* (scheduled
      agent, OS notification), or does consulting the framework remain the trigger
      (FEAT-199's model)? Push implies a scheduler dependency — decide deliberately.
- [ ] Command shape: extend `/fw-status`, or a dedicated `/fw-calendar`?

## Acceptance Criteria

- [ ] A calendar view exists, generated entirely from single-home schedule data — no
      hand-maintained calendar artifact anywhere
- [ ] View filterable by workspace; repo-level is the default scope
- [ ] Per-person (cross-repo) direction decided and recorded, even if deferred
- [ ] Verified against the built plugin, not the source tree

## Related

- **FEAT-199** — deadline awareness; the field convention and surfacing this builds on.
- **FEAT-195** — recurrence definitions in operations; a primary date source.
- **FEAT-163** — one shared parser; calendar generation reuses it.
- **TASK-197** — taxonomy refinement that surfaced the accounting/calendar case.
- **ADR-008** — Single-Source Rule; why calendars are derived, never maintained.

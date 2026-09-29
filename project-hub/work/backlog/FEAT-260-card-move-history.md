# Feature: A Timestamped Move History on Every Card

**ID:** FEAT-260
**Type:** Feature
**Priority:** Low
**Version Impact:** MINOR
**Created:** 2026-09-29
**Workspace:** framework
**Depends On:**
**Completed:**

---

## Summary

Raised by Gary on 2026-09-29, during TECH-243's pre-implementation review, as a "big perhaps".
The engine would add one timestamped line to the card on every move, so each card carries its
full history:

```
2026-09-01 1:00 - Created in backlog
2026-09-02 8:10 - todo
2026-09-03 3:14 - doing
```

`fw-new` writes the first line and the move engine writes the rest.

**Not built now. The open question is whether we'll use it.** Nothing reads it yet: TECH-243's
release guard only needs "was this card ever started", which the `**Started:**` stamp answers.

## What we already have: session history (Gary)

`project-hub/history/sessions/` probably already holds most of this, just not per card.
A session history lists the day's moves ("Files Moved"), so which **day** something happened
can usually be dug out by searching for the card's id. It's less precise, but it may be good
enough.

Checked 2026-09-29 against that claim: 54 of 103 session histories have a "Files Moved"
section, and the rest record moves in prose or not at all. The histories are written by the
AI after the session, so a move can be left out or folded into a summary. For example, today's
history records `backlog/BUG-250 → doing/ (via todo/)` as one line. Good enough to answer "about
when", not reliable enough to compute from.

## When to build it

When someone actually asks a question the session history can't answer well enough:
- how long did X sit in `hold/` or `blocked/`?
- how often do we interrupt work in `doing/`?
- cycle time from `doing` to `done`, per card or per workspace?

The likely consumer is **FEAT-163** (workspace reporting).

## Things to settle when it's built

- **`Started:` becomes derived.** Once the log exists, "was it started" is "does the log have a
  `doing` line". Retire the stamp or derive it, but keep one source (ADR-008).
- **Where the log lives:** a section at the end of the card, or a sidecar file. Every move edits
  the card, so a batch move edits every card in the batch.
- **Operations** would want the same, so decide it once for both namespaces.
- **Cards created before it lands** have no log; reports must handle partial histories.
- **Timestamp precision and time zone.**

## Acceptance Criteria

- [ ] A named consumer (a report or a question) exists before this is built
- [ ] One log format for both namespaces, written only by `fw-new` and the move engine
- [ ] `Started:` retired or derived from the log, never kept as a second source

## Related

- **TECH-243**: where this was raised; adds the `Started:` stamp this would replace
- **FEAT-163**: workspace reporting, the likely consumer

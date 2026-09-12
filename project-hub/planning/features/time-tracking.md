# Feature: Time Tracking

**Workspace:** framework
**MVP Target:** post-1.0
**Last Reviewed:** 2026-09-11

<!-- Membership is derived: cards carry `Feature: Time Tracking`. This file never
     lists them.

     Cite sections as `time-tracking§N`. Numbering is flat across groups. Numbers
     are stable once published: retire a criterion by marking it superseded;
     insert with §Na rather than renumbering.

     Names functions, never commands. -->

---

## Definition

**Passive effort measurement from work that already happened.** Every Claude Code session
writes a timestamped transcript per project. Reading those timestamps and clustering them into
**activity blocks** yields how much time was actually spent on each project — with no clock to
punch, no timer to remember, and no change to how work is done.

The unit is the **activity block**: a run of interaction with no gap longer than a threshold.
Blocks are attributed to a project, summed over a period, and reported.

## Why It Exists

Two problems, one mechanism.

**Parallel projects break punch-clock tracking.** Gary: *"often I'll run multiple projects in
parallel."* A single punched clock cannot represent three projects worked in an interleaved
hour; the tracker forces a serialization that did not happen. Per-project transcripts already
record the real interleaving.

**SpearIT's own work is tracked nowhere.** Gary: *"I haven't tracked SpearIT projects at
all."* Internal work is invisible, so its true cost is unknown — which makes it impossible to
judge what the framework, the kb, or any internal investment is actually costing.

## What This Measures — and What It Does Not

**Stated up front because every criterion depends on it.** This measures **time spent
interacting with Claude on a project**. It does not see: thinking away from the keyboard,
client calls, whiteboard sessions, reading documentation, or coding without Claude.

So the output is a **floor on effort, not a measure of it** — and it must be labelled that way
everywhere it is reported. A number presented as complete when it is systematically low is
worse than no number.

**Consequences for use:**
- **Internal work** — high value. Nothing is tracked today, so a floor beats zero outright.
- **Client work** — supplementary. Reconcile against what was punched; catch unbilled hours.
  **Not a billing source of record**: a punched clock is a human assertion, a computed one is
  an inference, and a client querying a line item may not accept "the transcript says so."

## What Could Invalidate This

**The data source.** Per-interaction timestamps currently come from Claude Code's transcripts
(`~/.claude/projects/<slug>/*.jsonl`) — a third-party private format with no stability
guarantee, free to change without notice. If no source the framework may depend on provides
per-interaction timestamps, there is nothing to build: every other criterion here is
arithmetic over those timestamps.

**Answered by SPIKE-227 — sequenced before any implementation work on this feature.**

<!-- Every feature names the one unknown that could kill it, and that question is
     sequenced FIRST — before the valuable work, regardless of value. The cost of
     answering it early is hours; the cost of answering it late is the whole build. -->

---

## A. Measurement

### §1. Activity blocks, not sessions

**Met when:** elapsed time is computed from **gaps between timestamped interactions**, never
from session open/close. A session left open overnight contributes only the blocks in which
something happened.

**Why it cannot be session-based:** a Claude Code session is a container that can sit idle
indefinitely. This very session (2026-09-11) ran overnight across a date rollover with the
user asleep; session duration would have billed it all.
**Validated by:** AI: a transcript with a long idle gap yields blocks, not one span · Human:
a day's reported total matches recollection of that day
**State:** Pending

### §2. The idle threshold is declared, tunable, and its effect is visible

**Met when:** the gap that ends a block is a **declared parameter**, not a constant buried in
code, and reports state which threshold produced them.

**Measured on real data** (this project, 2128 user messages, 2026-08-18 → 2026-09-12):

| Threshold | Blocks | Hours |
|---|---|---|
| 15 min | 116 | 36.0 |
| 20 min | 93 | 42.8 |
| 30 min | 59 | 56.8 |

**The threshold is not a detail — it is a 58% swing** across the same period. A reported total
without its threshold is meaningless. 15–20 minutes is the defensible range: long enough to
survive thinking, reading, or running a test in another window; short enough that lunch is not
billed. **Default 20; a shorter threshold is the conservative choice** since it under-counts.
**Validated by:** AI: changing the threshold changes the totals as expected, and the value
appears in the output · Human: the default produces blocks matching real working sessions
**State:** Pending — method proven 2026-09-11, nothing built

### §3. Attribution is per project, and parallel work stays parallel

**Met when:** blocks are attributed to the project whose transcript they come from, so two
projects worked in the same hour each get their own blocks — the interleaving punch-clocks
cannot express.

Claude Code already stores transcripts per project directory (13 projects present on this
machine as of 2026-09-11), so attribution needs no tagging by the user.
**Validated by:** AI: an interleaved hour across two projects yields blocks in both · Human:
a day spent switching projects reports plausibly against each
**State:** Pending — the data is already per project

### §4. Measurement is passive and cannot be forgotten

**Met when:** no start, stop, tag, or confirmation is required. The user does nothing; the
record is a by-product of work already done.

**This is the feature's main advantage over the punch-clock app** and the reason the floor
limitation is acceptable: an imperfect measure that always runs beats a perfect one that is
forgotten.
**Validated by:** AI: a project worked with no time-related action still reports time · Human:
n/a — the criterion is that there is nothing for a human to do
**State:** Pending

---

## B. Reporting

### §5. Time reports per project and per period

**Met when:** total time is reported for a project over a period (day, week, month), and
across projects for one period — always carrying the threshold (§2) and the floor caveat.
**Validated by:** AI: totals reconcile against the block list · Human: a week's report is
usable without further arithmetic
**State:** Pending

### §6. Time attributes to work items where the evidence supports it

**Met when:** a block that can be tied to a work item (the card was moved, created, or named
during it) reports against that card, and a block that cannot is reported as project-level
time — **never guessed onto a card**.

**Why the guard matters:** per-card time is the most useful output and the easiest to
fabricate. A card with invented hours is worse than a card with none.
**Validated by:** AI: blocks with no card evidence stay project-level · Human: spot-checked
card totals match what was actually worked on
**State:** Pending — depends on the board being readable for the period (kanban§2 lifecycle
data)

### §7. Client-work output is reconcilable, not authoritative

**Met when:** output intended for client work is shaped to be **compared against punched
time** — showing computed hours beside a period the user can check — and is labelled as a
floor, never emitted as an invoice line.
**Validated by:** AI: output carries the caveat · Human: a real client period reconciles
against the tracker app without manual re-keying
**State:** Pending

---

## Out of Scope

- **Invoicing and billing rates** — money is a separate concern; this feature produces hours,
  not amounts. Not planned.
- **Manual time entry / correcting the record** — possible later, but it reintroduces the
  discipline problem §4 exists to avoid. Deliberately deferred.
- **Tracking work done outside Claude** — impossible by construction; see *What This Measures*.
- **Deadlines, reminders, calendar** — roadmap D6 (FEAT-199, FEAT-200). Time-shaped, but about
  *future* obligations; this feature is about *past* effort. They pair, they are not the same.
- **Reporting infrastructure** — the "other" feature owns how reports are rendered and sliced
  per workspace (FEAT-163, FEAT-196). This feature owns the *data*.

## Open Questions

- [ ] **The data source, cross-machine reality, and retention** — all three are supply
      questions and all three are owned by **SPIKE-227**. See *What Could Invalidate This*.
- [ ] **Does an operations record want a time field?** Client incidents are the most
      billing-relevant work the framework tracks, and ops records have no effort field today.
      — **not yet carded**

## Change Log

| Version | Date | Change |
|---------|------|--------|
| v0.1 | 2026-09-11 | Initial draft. Method proven against 2128 real messages: activity blocks with a declared idle threshold; 15/20/30-minute thresholds measured (36.0h / 42.8h / 56.8h over the same 26 days). |

---

## Related

- **Roadmap D6** (FEAT-199 deadlines, FEAT-200 calendar) — the other time-shaped work. D6 is
  about future obligations; this is about past effort. Likely siblings under one "time"
  grouping later.
- **The "other" feature** (reporting) — owns rendering and per-workspace slicing; this feature
  owns the data.
- **Operations** — client incidents are the most billing-relevant records the framework holds;
  see the open question on an effort field.
- **`kanban§2`** — per-card attribution (§6) needs the board's lifecycle data to know what was
  worked when.

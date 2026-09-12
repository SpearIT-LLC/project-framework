# Spike: Where Time-Tracking Data Comes From

**ID:** SPIKE-227
**Type:** Spike
**Priority:** Medium
**Version Impact:** NONE
**Created:** 2026-09-11
**Workspace:** framework
**Timebox:** 2 hours
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## The Question

**Can the framework read per-interaction timestamps from a source it is allowed to depend
on?**

This is the one unknown that can invalidate the Time Tracking feature outright. Everything
else in that feature is arithmetic over timestamps; if the timestamps are not reliably
available, there is nothing to build.

## Why It Must Be Answered First

The method is already proven — 2128 real user messages from this project clustered into
activity blocks, with the idle threshold measured at three values (15 min → 36.0h, 20 min →
42.8h, 30 min → 56.8h over 26 days). **The maths works. The supply does not yet have an
answer.**

The data currently comes from `~/.claude/projects/<slug>/*.jsonl` — **a third-party private
format with no stability guarantee**, undocumented as an integration surface, and free to
change without notice. Building a feature on it without deciding that is acceptable means
discovering the problem after the code exists.

**This is the pattern the spike exists to establish** (see the process note below): name the
one thing that could kill a feature, answer it cheaply, *then* decide whether to build.

## What to Determine

1. **Stability of the transcript format.** Is it documented anywhere as stable? How has it
   changed historically? What breaks if a field is renamed — a wrong number, or a loud
   failure? *(A silent wrong number is disqualifying; a loud failure may be acceptable.)*
2. **Can a hook see individual interactions?** A `Stop` hook fires once per session and sees
   only session boundaries — **the wrong unit**, per `time-tracking§1`: this very session ran
   overnight across a date rollover and would have recorded ~18 hours instead of two real
   blocks. Is there a per-interaction hook (`UserPromptSubmit`, `PostToolUse`, or similar)
   that could append to a log the framework owns?
3. **What a framework-owned log would cost.** If a hook can capture interactions, the
   framework writes its own stable record and never depends on a private format. What is the
   write volume, where does the file live, and does it need pruning?
4. **Cross-machine reality.** Transcripts are local. Is work on a second machine simply out of
   scope, or does the log need to live in the repo (and therefore in git)?
5. **Retention.** If transcripts are pruned by the tool, time data must be summarized into the
   repo *before* that happens — which turns a read-only feature into one with its own stored
   record, and changes the feature's shape.

## Exit Criteria

A spike ends in a **decision, not a document**.

- [ ] One of three outcomes chosen and written down with its reasoning:
      **(a)** read transcripts directly, accepting the fragility, with the failure mode named;
      **(b)** framework-owned log written by a per-interaction hook;
      **(c)** not viable — the feature is deferred or dropped, and `time-tracking.md` says so
- [ ] If (b): the hook event confirmed to exist and fire per interaction — **demonstrated, not
      assumed**
- [ ] The failure mode is named for whichever source is chosen: what happens when it breaks,
      and whether a break is loud or silent
- [ ] `time-tracking.md` updated — the data-source open question closed, `§1`/`§2` states
      revised if the answer changes them
- [ ] Timebox respected: if 2 hours does not settle it, that **is** the finding — record what
      is known and what remains

## Out of Scope

Everything the Time Tracking feature covers: block computation, reporting, per-card
attribution, client reconciliation. This spike answers *where the data comes from* and nothing
else.

## Related

- **Time Tracking feature** — `project-hub/planning/features/time-tracking.md`. This spike
  closes its first open question; the whole feature depends on the answer.
- **FEAT-222** — session history in the new build. Shares the hook question: if a
  session-boundary hook is the mechanism there, the two features share plumbing (and only
  plumbing — a session summary wants boundaries, time wants interactions).

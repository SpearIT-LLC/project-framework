# Tech Debt: /fw-session-history Doesn't Enforce Per-Date Files Across a Midnight Rollover

**ID:** TECH-161
**Type:** Tech Debt
**Priority:** Medium
**Version Impact:** PATCH
**Theme:** Workflow Commands

---

## Summary

The `/fw-session-history` command names files per date (`YYYY-MM-DD-SESSION-HISTORY.md`) but assumes **one session = one calendar day**. When a single continuous working session crosses midnight, the command gives no instruction to start a new dated file — its append guidance ("Multiple updates per day append to same file"; markers "(Later)"/"(Afternoon Session)") is all within-day. Result: cross-midnight work gets appended to the *prior* day's file. Encode the per-date convention (one file per calendar date, with continued-from/on cross-references) so the command enforces it.

---

## Problem Statement

**What is the current state?**

`.claude/commands/fw-session-history.md`:
- **Behavior step 1** writes to `project-hub/history/sessions/YYYY-MM-DD-SESSION-HISTORY.md` for "today".
- **Behavior step 2** appends if the file exists, creates if new.
- **Notes** (line ~129): "Multiple updates per **day** append to **same** file."
- **Append-Only Principle** markers: "(Later)", "(Afternoon Session)" — all within-day.

There is **no instruction** for the case where one session spans a date rollover. "Today" is ambiguous: does it mean the session's start date, or the current date at write time?

**How it surfaced:** During the 2026-06-29 → 06-30 session, work continued past midnight. The command's wording led to appending 06-30 content into `2026-06-29-SESSION-HISTORY.md`. This was corrected manually by splitting into `2026-06-30-SESSION-HISTORY.md` with bidirectional "continued from/on" pointers (see that session's history). The convention was decided conversationally but is **not yet encoded in the command**.

**Why is this a problem?**

- A future session crossing midnight will re-hit the same ambiguity — the command actively reinforces same-file-per-day.
- Per-date files are easier to scan, archive, and reason about ("what happened on date X") than a multi-day file keyed to a session's start.

**What is the desired state?**

- The command always resolves the file by the **current date at write time**, not the session's start date.
- When a session spans midnight: **start a new dated file** for the new date, and add cross-references:
  - prior file → "Continued on YYYY-MM-DD" pointer (with a short bullet summary + link)
  - new file → "Continued from YYYY-MM-DD" back-pointer near the top
- Within-day append behavior and the Append-Only Principle remain unchanged.

---

## Proposed Solution

Edit `.claude/commands/fw-session-history.md`:

1. **Behavior step 1** — clarify "today" means the **current date at the time of writing** (re-evaluate per update, not fixed at session start).
2. **Add a "Session Spans Midnight" subsection** under Behavior or Notes:
   - If the current date differs from the most recent session file's date AND the session is continuing, create a new `YYYY-MM-DD` file for the current date.
   - Add a "Continued from [YYYY-MM-DD](<link>)" back-pointer at the top of the new file.
   - Add a "## Continued on YYYY-MM-DD" section at the end of the prior file with a link and a brief bullet summary.
3. **Reconcile the Notes wording** ("Multiple updates per day…") so it's clearly *within-day*, not *within-session*.
4. Keep the format template and Append-Only Principle as-is.

**Files Affected:**
- `.claude/commands/fw-session-history.md` — full-framework command (ships to consumers via `Build-FrameworkArchive.ps1` Step 1.5 since TECH-159)
- `plugins/spearit-framework/commands/session-history.md` — advanced-plugin copy of the same command (it exists separately and is NOT identical — uses an external template)
- `plugins/spearit-framework/templates/session-history-template.md` — the plugin's external template; the rollover guidance may need to land here too, since the plugin command delegates its format to this file

> **Scope note (2026-06-30):** Investigation found the session-history command exists in 3 forms across the command tiers, and the `fw-*` and plugin command sets have broadly drifted (see DECISION-162 + the drift inventory). TECH-161 is **narrowly scoped** to the per-date rollover fix and applies it to the two session-history copies that exist (`fw` + full plugin; the light plugin has no session-history command). The broader fw-*-vs-plugin sync strategy is **out of scope here** — it's DECISION-162. If DECISION-162 later consolidates these copies to a single source, this fix lands in that source instead; coordinate ordering.
>
> The `/fw-session-history` "skill" referenced earlier is the harness entry that maps to `.claude/commands/fw-session-history.md` — it is the same artifact as the first file above, not a separate copy.

---

## Acceptance Criteria

- [ ] Command resolves the session-history file by the current date at write time (not session start)
- [ ] Command instructs: when a session spans midnight, create a new dated file
- [ ] Command specifies the bidirectional cross-reference ("Continued from" / "Continued on")
- [ ] Within-day append behavior + Append-Only Principle unchanged
- [ ] Notes wording reconciled (within-day, not within-session)
- [ ] Rollover fix applied to BOTH session-history copies: `.claude/commands/fw-session-history.md` and `plugins/spearit-framework/commands/session-history.md` (+ the plugin's external template if it carries the format)
- [ ] CHANGELOG.md updated

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->
<!-- User can say "continue to completion" to approve remaining steps at once. -->

- [ ] **PRE-IMPLEMENTATION REVIEW COMPLETED**
  - AI presents: exact wording changes, the spans-midnight subsection, skill-vs-command check
  - User explicitly approves before proceeding
- [ ] Update `.claude/commands/fw-session-history.md` Behavior + add spans-midnight subsection + cross-reference spec
- [ ] Reconcile Notes wording (within-day)
- [ ] Apply the same change to `plugins/spearit-framework/commands/session-history.md` (+ its external template if needed)
- [ ] CHANGELOG.md updated

---

## Notes

- Convention decided conversationally on 2026-06-30 (user: "Let's always keep the per date history pattern. We can note 'continued on YYYY-MM-DD' if needed."). Recorded in `2026-06-30-SESSION-HISTORY.md` (Decision #4) but not yet enforced by the command — this item closes that gap.
- First real-world application of the convention (the 06-29 → 06-30 split) is the reference example for the cross-reference format.

---

## Related

- **TECH-159** — made the build copy `.claude/commands/*.md` fresh; a fix here ships to consumers on the next release automatically.
- **TECH-072** — session-history template (prior session-history work).

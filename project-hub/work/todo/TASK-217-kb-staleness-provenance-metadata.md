# Task: kb Staleness — Make the Provenance Rule a Mechanism

**ID:** TASK-217
**Type:** Task
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-09-01
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

The kb's long-term viability depends on being able to tell whether a claim is still true.
Today the staleness rule exists as prose in the domain README and nothing enforces it.

> "The long term viability of the kb is the biggest challenge in my opinion. […] Without
> some means to flag potentially out of date info makes the kb unreliable."
> — Gary, 2026-09-01

Agreed, with one refinement that shapes the whole design: **the problem is not that we
cannot tell what is old — it is that we do not record what a claim depends on.** Make the
dependency explicit and staleness becomes a checkable question.

## What Already Exists (and why it is not enough)

The domain README already draws the right distinction — two staleness models tied to
provenance:

- `reference/` — "Goes stale by *release* — replace when the upstream version moves."
- `research/` — "Goes stale by *refutation* — a claim is disproven, we revise."

That decomposition is correct and better than a generic review date. **But it is prose,
and the plugin's own rule says an instruction the AI merely reads is not a guardrail.**
Nothing records what a `reference/` document is a version *of*, so nothing can detect
that the upstream moved.

## Why Not a "Last Reviewed" Date

Considered and rejected as the primary mechanism. A date tells you a file is old; it
cannot tell you whether old means wrong. A FlexLM recipe from 2019 may be perfectly
current because FlexLM has not changed, while a Kubernetes note from six months ago is
dangerously stale. **Age is a weak proxy in both directions**, and a review date that
nobody can act on becomes noise that trains people to ignore the signal.

A date is still useful as *supporting* metadata (retrieval date on a `reference/` doc);
it is just not the thing that answers "is this still true?".

## Design Direction

Record the dependency, then the question has an answer:

- **`reference/`** — record the upstream identity it mirrors: product/version
  (`FlexLM 11.19.x`), source URL, retrieval date. "Is this stale?" becomes "has the
  upstream version moved?" — checkable, or at minimum promptable at the right moment.
- **`research/`** — record what the conclusion was drawn *from*, and when. It does not
  expire on a clock; but when a cited source is superseded or refuted, everything
  downstream is flagged for re-examination.

This also resolves the local-cache objection in TASK-216. A cache is dangerous when it is
an undated copy of unknown vintage; a cache carrying "retrieved <date> from <url>,
upstream version X" **is** a `reference/` doc with correct provenance. The existing model
already covers it — the metadata is what makes it safe.

## Open Questions (resolve before → doing)

- [ ] **Where does the metadata live?** Front matter on each document, a per-folder
      manifest, or a header block like the record templates use? Front matter is
      greppable and travels with the file; a manifest is one place to read but drifts
      from its contents.
- [ ] **What is checkable versus promptable?** A URL can be fetched and compared; a
      vendor version usually cannot be resolved automatically. Likely a `--check` that
      reports *what to verify* rather than asserting staleness itself.
- [ ] **When does the check run?** At `fw-troubleshoot` rung 2 (so a stale hit is flagged
      at the moment of use — highest value, most intrusive), on demand, or at session
      start like the contacts refresh.
- [ ] **What about existing content?** This repo and SpearIT-KB already hold documents
      with no provenance metadata. Backfill, or treat "unknown provenance" as its own
      flag? Unknown-is-a-flag is honest and cheaper.
- [ ] **Does a flagged document stay usable?** It must — a stale-flagged doc is still the
      best information available. Flag, never hide.

## Explicit Non-Goal

**Nothing here catches a claim that quietly became wrong** without its source changing or
being refuted. That needs a human re-reading it. The honest mitigation is scope
discipline — a small kb that is actually maintained beats a large one that cannot be.
Worth stating in the domain README so the metadata is not mistaken for a guarantee.

## Acceptance Criteria

- [ ] `reference/` documents carry upstream identity (product/version), source, and
      retrieval date
- [ ] `research/` documents carry what they concluded from, and when
- [ ] A check reports what needs verifying, per document, without asserting more
      certainty than it has
- [ ] Documents with no provenance metadata are reported as unknown, not as current
- [ ] Flagged documents remain readable and searchable — flagging never hides content
- [ ] The domain README states the non-goal above
- [ ] Verified against the built plugin, not the source tree (TECH-188)

## Related

- **TASK-216** — kb at root + multi-source referencing. **Sequence this first**:
  federating search across sources whose freshness is unknown makes the problem worse.
- **FEAT-201** — the provenance folders whose rule this makes mechanical.
- **FEAT-202 / TASK-205** — troubleshoot cases land in `research/`; they carry evidence
  and a conclusion, so they are the natural first consumer of "concluded from".
- **FEAT-209** — sub-topic depth; more surface area to keep current.
- **ADR-008** — the Single-Source Rule; this is the same argument applied to time.

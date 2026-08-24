# Session History: 2026-08-24

**Date:** 2026-08-24
**Participants:** Gary Elliott, Claude Code
**Session Focus:** workspaces/ in general — kb branch (FEAT-192/194/201); FEAT-164 closed

---

## Summary

Day's focus set: finish the kb branch (FEAT-192 `/fw-new-domain`, FEAT-194 `company`
domain, FEAT-201 `research/` folder). FEAT-201 (filed 2026-08-22 from the HPC repo —
first field use of the kb scaffold) reviewed and its cross-refs fixed. FEAT-164
closed: its criteria were satisfied by the TASK-197/interface work of 2026-08-20,
re-verified under the current enum and annotated rather than rewritten.

---

## Work Completed

### FEAT-201: intake review and fixes

- Reviewed the card from the HPC repo: reference-vs-research provenance split
  (theirs/ours; stale-by-release vs stale-by-refutation). Assessment: sound, and the
  dogfood loop working — field use surfaced the gap within days of the scaffold
  landing.
- Fixed cross-refs: `/fw-new-domain` is FEAT-192 (not 194); Related section
  disentangled; direction sharpened — the definitions home is a seeded
  `_domain_/README.md`, which does not exist yet and this card creates (192/194
  want the same home).

### FEAT-164: closed (doing → done)

- Criteria mapped against what landed 2026-08-20 under TASK-197: all four types
  generate from the published plugin (live command run created `app2`); the
  document-only floor test holds under the dissolved-sow vocabulary (`project` =
  floor + requirements, no source tree); README name/type seeded via `__NAME__`
  substitution, purpose step exercised live.
- Original 2026-08-18 criterion annotations preserved; 2026-08-24 resolution notes
  appended (append-don't-rewrite). Closing note added marking the Scope sketch as
  journey record, superseded by TASK-197's enum and the template-tree D3 amendment.
- All five test fixtures' READMEs given an explicit test-fixture purpose line
  (was `_PURPOSE_PENDING_` — the 2026-08-20 loose end).

---

## Current State

### In done/ (10 — release-nudge threshold reached)
- FEAT-164 newly complete; TASK-197 and 8 others awaiting release

### In doing/
- (empty — kb branch cards move next)

### Next
- FEAT-192 + FEAT-201 → doing together (one script/template window: shared
  domain-scaffold path + research/ + domain README), then FEAT-194.

---

**Last Updated:** 2026-08-24

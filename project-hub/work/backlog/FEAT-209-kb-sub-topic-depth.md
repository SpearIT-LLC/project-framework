# Feature: Knowledgebase Sub-Topic Depth (Topic-First, Provenance at the Leaf)

**ID:** FEAT-209
**Type:** Feature
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-08-29
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

The kb has no depth: one level of domains, each holding the four provenance folders. Real
knowledge is topic-first — SpearIT-KB keeps five license managers under `licensing/`
(`licensing/flexlm/cookbook/…`), and the one-level model forces `licensing-flexlm`,
`licensing-dsls`, … with no home for domain-level material and a long INDEX.

**Decided 2026-08-29 (Gary, UAT-23): option (b)** — one optional sub-topic level under a
domain, the four provenance folders always at the leaf, capped at one level. A sub-topic
folder is a self-contained, shareable unit (zip just `licensing/flexlm/`).

## Design

- `fw-new-kb-domain.sh` accepts `<domain>` or `<domain>/<subtopic>`. Sub-topic is
  optional; small domains stay one-level. Creating `<domain>/<subtopic>` on a domain
  that doesn't exist creates both.
- Domain README + domain-level material live at `<domain>/`; sub-topic gets its own
  README (same provenance text) and the four folders.
- `INDEX.md` nests sub-topic lines under the domain line (one line per domain, indented
  one per sub-topic). Case-insensitive uniqueness applies at both levels.
- `fw-troubleshoot` rung 2 greps `kb/**/{cookbook,research,reference}`; cases file under
  the sub-topic when one exists; the domain-choice prompt at the close gate offers
  sub-topics.
- `/fw-new-workspace kb <name>` keeps delegating; accepts the same `domain/subtopic` form.
- Migration of existing flat content is a `git mv` + INDEX edit (documented in the
  command, not scripted). This repo's `licensing` FlexLM cases would move to
  `licensing/flexlm/research/`.

## Alternatives rejected

- (a) flat prefixed domains — works today, no domain-level home, long INDEX; interim only.
- (c) sub-topic folders inside each provenance folder — zero script change but splits a
  vendor across four folders.

## Acceptance Criteria

- [ ] `<domain>/<subtopic>` form creates the leaf with provenance folders; refuses a
      second level
- [ ] INDEX nests correctly; existing one-level domains unchanged
- [ ] fw-troubleshoot search and case filing are depth-aware
- [ ] UAT-04/07/08/09 still PASS; new UAT rows for the sub-topic form added to the runbook
- [ ] Verified against the built plugin, not the source tree

## Related

- **FEAT-192** — `/fw-new-kb-domain` (owning FEAT). **FEAT-201** — provenance folders.
- **FEAT-202 / TASK-205** — troubleshoot skill; cases land under sub-topics.
- **FEAT-210** — configurable kb search path (external SpearIT-KB), same UAT-23 row.
- `workspaces/framework/tests/UAT-RESULTS-2026-08-26.md` row UAT-23.

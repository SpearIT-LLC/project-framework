# Feature: kb Domain `research/` Folder — Reference-vs-Research Provenance Split

**ID:** FEAT-201
**Type:** Feature
**Priority:** Low
**Version Impact:** MINOR
**Created:** 2026-08-22
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

Add `research/` to the knowledgebase domain scaffold, alongside `cookbook/`,
`faq/`, and `reference/`. The two folders encode **provenance**, which a reader
cannot recover from content alone:

- **`reference/`** = authoritative material we *read but did not write* —
  vendor documentation, saved spec pages, standards. Not ours to edit, only to
  annotate. Goes stale by *release* (replace when the upstream version moves).
- **`research/`** = material we *curated and concluded* — synthesis from one
  or many sources, with our own conclusions. We stand behind it, not the
  vendor. Goes stale by *refutation* (a claim is disproven, we revise).

Surfaced 2026-08-22 in the HPC repo (Gary), first field use of the kb
scaffold: a 3DEXPERIENCE filter study cited vendor docs heavily but its
conclusions were ours — including a finding the vendor docs omit entirely
(behavior present in the product, absent from documentation). In one folder
that reads as a contradiction; in two folders it is legible as "vendor silent,
our research fills the gap."

## Direction (proposed, confirm at design)

- Knowledgebase overlay `_domain_/` gains `research/` (with `.gitkeep`):
  `cookbook/ faq/ reference/ research/`.
- Definition lines live once in the seeded kb README (or domain README):
  *reference = theirs, research = ours*; neither automatically outranks the
  other on conflict — they are different kinds of claims.
- **Boundary vs `project-hub/research/`:** same word, two concepts. kb
  `research/` holds the distilled, durable output (reads like a position
  paper); `project-hub/research/` holds the investigation process record
  (spikes, dead ends — reads like a lab notebook). State the distinction in
  the seeded README rather than renaming either.
- Licensing note for `reference/` in the seeded README: pointers, install
  paths, and brief excerpts commit; wholesale copies of licensed vendor docs
  stay in git-ignored scratch.

## Precedent

HPC repo (`HPCJobQueuePrototype`) `workspaces/kb/3dx/` already carries the
four-folder shape, built by hand 2026-08-22 with a provenance note pointing
back at the template. Reconcile when this lands.

## Acceptance Criteria

- [ ] `templates/workspaces/knowledgebase/_domain_/research/` exists in the
      plugin template tree
- [ ] Seeded README states the reference-vs-research provenance rule and the
      kb-research vs project-hub-research boundary
- [ ] `/fw-new-domain` (FEAT-194 territory) generates the four-folder shape

## Related

- TASK-197 — workspace type taxonomy (kb scaffold origin)
- FEAT-194 — kb `company` domain / `/fw-new-domain`
- HPC repo `workspaces/kb/README.md` — first field use, carries the
  definitions this card upstreams

# Task: kb at Root, and Referencing Multiple Knowledgebases

**ID:** TASK-216
**Type:** Task
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-09-01
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

Two related moves for the knowledgebase:

1. **`kb/` moves out of `workspaces/` to the repo root**, beside the board and
   operations — spine, not work.
2. **The framework gains a source list**: one authored local kb plus N external
   corpora it may consult (SpearIT-KB, a corporate kb, a web source).

Second half of Gary's 2026-09-01 question about whether `kb/` and `operations/` belong
under `workspaces/`. Operations is TASK-213; this is kb, and the argument is different.

## Why kb Is Not a Workspace

Operations converged with kanban on **shape** (a queue that looked like the board). kb
diverges on **scope** — it is referenced by everything and owned by nothing.

> "the kb can apply to any project, product, or topics outside of those, like company or
> issues related to operations. A kb can expand very quickly in many directions."
> — Gary, 2026-09-01

Three legs:

- **Scope.** `company` serves the whole repo; a `licensing` domain may inform three
  products; troubleshooting cases arising from operations land in kb `research/`. That
  is one-to-many, but sitting under `workspaces/` reads as peer-to-peer.
- **Lifecycle.** It fails TASK-197's close-test in **both** directions: a product
  persists as a delivered thing, a project ends — a kb does neither, it accretes. That
  is why FEAT-209 has to cap sub-topic depth by decree rather than by work concluding.
- **Locality.** FEAT-210 already anticipates "a configurable kb search path so rung 2 can
  include an external/shared kb (SpearIT-KB)". A shared kb spans customer repos; the
  ADR-005/009 model is one repo per customer. **A workspace cannot be somewhere else.**

### On TASK-197 Decision 5 (the counter-argument)

Decision 5 — "one real-world activity may split across types; that is the taxonomy
working" — has Toyota app support decomposing into operations + product + kb as peers,
tied by cross-references. It **survives** this move: its requirement is that each part
has one home and they link rather than nest. Moving both operations and kb to root keeps
them peers; the peer set becomes "spine things that work refers to" rather than
"workspaces." Arguably truer — a kb domain serving three products was never really a
sibling of those products.

## Decisions (2026-09-01, Gary)

1. **kb moves to root.**
2. **The framework may reference multiple kbs**, potentially of different shapes:
   the internal kb, SpearIT-KB, and others parallel to it (corporate, web-based).
3. **Local cache of an external kb: not adopted.** Gary's objection — over time the
   challenge becomes knowing what is current. See TASK-217; a cache is only safe if it
   carries the provenance that item defines, at which point it is just a `reference/`
   doc.
4. **SpearIT-KB should be referenceable from GitHub**, so it works when off this
   machine. A source entry therefore needs to accept a URL/remote, not only a path.

## Design Direction (not yet settled)

**One authored home, N consulted sources.** This mirrors a line the kb already draws one
level down — `reference/` is theirs, `research/` is ours. The same boundary at corpus
level should look the same:

- `kb/` at root — the one **authored** home; write here. Domains, provenance folders,
  FEAT-209's sub-topic depth.
- A **source list** in `framework.yaml` (already the machine-readable index) naming
  external corpora to **consult**, read-only by default. Each entry declares a type,
  because access differs: filesystem path, git remote, HTTP.

## Open Questions (resolve before → doing)

- [ ] **Automatic or on-request?** Is an external kb searched as part of
      `fw-troubleshoot` rung 2, or consulted only when asked? Automatic is more useful
      and much more work — it needs result merging, per-hit provenance tagging (an
      authored case must be distinguishable from a vendor forum scrape), and a staleness
      story (TASK-217).
- [ ] **Copy or link on a useful find?** Copying into the local kb means drift
      (ADR-008); linking breaks when offline or the source moves. No clean answer —
      decide rather than default.
- [ ] **Shape divergence.** SpearIT-KB presumably shares this framework's structure and
      is greppable the same way; a corporate wiki or web source is not. Either sources
      declare an adapter, or non-conforming ones get a weaker "here is where to look"
      pointer. **Lean: pointer first** — a pointer that always works beats an adapter
      framework maintained per source.
- [ ] **Does the local kb keep the `kb` name at root**, or does root placement invite a
      clearer one now that it is no longer "the kb workspace"?
- [ ] **Sequencing with TASK-213.** Both change root layout and both break relative
      paths; one migration is cheaper than two.

## Scope

- ADR-009 amendment (D2, shared with TASK-213 — a queue and a knowledgebase are both
  spine, not work).
- `kb` removed from the workspace type enum (TASK-197's four types → two, with
  operations also leaving; **verify the scenario table still partitions cleanly**).
- Path changes: `fw-new-kb-domain.sh`, `fw-new-contact.sh`, `fw-contacts.sh`,
  `fw-troubleshoot` rung 2, `fw-new-workspace.sh`'s kb delegation.
- **Relative-link churn — the real cost.** `../kb/company/contacts/` is embedded in every
  generated `CONTACTS.md` and in `templates/records/ops-record.md`. Depth-sensitive and
  load-bearing; regenerate rather than hand-edit the views.
- `framework.yaml` source list + schema entry.
- Command docs: `/fw-new-kb-domain`, `/fw-new-workspace`, `/fw-troubleshoot`.

## Acceptance Criteria

- [ ] `kb/` at repo root; all scripts and the troubleshoot skill resolve it there
- [ ] `kb` removed from the workspace type enum with a pointer to the new path
- [ ] Generated `CONTACTS.md` links resolve at the new depth (regenerated, not edited)
- [ ] `framework.yaml` names at least one external source, and it is honored
- [ ] An unreachable external source degrades gracefully — never blocks a local search
- [ ] Verified against the built plugin, not the source tree (TECH-188)

## Related

- **TASK-217** — kb staleness/provenance metadata. **Sequence that first**: federating
  search across sources whose freshness is unknown makes the problem worse.
- **TASK-213** — operations to root; same ADR-009 D2 amendment, same migration window.
- **FEAT-209** — sub-topic depth; the expansion pressure that shows kb accretes.
- **FEAT-210** — line 79, the configurable kb search path this generalizes.
- **TASK-197** — workspace type taxonomy and Decision 5.
- **FEAT-194** — contacts in the kb company domain; the most path-sensitive consumer.

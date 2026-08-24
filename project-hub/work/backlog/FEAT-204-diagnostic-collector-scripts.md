# Feature: Diagnostic Collector Scripts — Pre-Scrubbed Evidence Bundles as Products

**ID:** FEAT-204
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-08-24
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

In remote-mode troubleshooting (the usual case — FEAT-202), evidence arrives by
the user pasting stdout, screenshots, and config into `evidence/`, ten cycles
per case. A **collector script** per environment gathers logs, status,
versions, and config into one **pre-scrubbed** bundle — one run, one drop — and
makes scrubbing (hostnames, users, license keys, PII) a mechanism instead of a
reminder. This is the script-promotion test (TASK-197 D5, the Toyota
admin-script-library lesson) applied in advance: collectors are **products**,
living in a product workspace, not one-shot case scripts.

## Direction (proposed, confirm at design)

- One collector per environment/product family (FlexLM host, CATIA/3DX client,
  HPC Pack head node), producing a timestamped bundle folder the user drops
  into a case's `evidence/` as-is.
- Scrubbing is part of the collector, not a post-step: a documented
  substitution map (hostnames → `HOST1`, users → `USER1`, keys → `<REDACTED>`)
  applied before the bundle is written; the map stays local, never in the
  bundle.
- **Baseline mode:** the same collector run on a healthy system produces the
  environment baseline the domain playbook (FEAT-203) links — rung 6 becomes
  a diff.
- Collectors live in a `product` workspace (e.g. `workspaces/diag-collectors`
  or per-customer tooling workspaces), versioned; the case links the collector
  version used.

## Open Questions (resolve before → doing)

- [ ] Language/runtime: PowerShell for Windows hosts (the field reality), bash
      for Linux HPC nodes — one convention for bundle layout across both?
- [ ] Where the first collector lives: framework-shipped starter, or
      per-customer product workspace only?

## Acceptance Criteria

- [ ] Bundle layout documented in one home; a case's `evidence/` accepts a
      bundle unchanged
- [ ] Scrub map applied by mechanism; a bundle contains no raw hostnames,
      usernames, or keys (test with a known-dirty fixture)
- [ ] Baseline mode produces a diffable snapshot the playbook can link
- [ ] Verified against the built plugin, not the source tree

## Related

- **FEAT-202** — remote-mode evidence flow this collapses.
- **FEAT-203** — playbooks + baselines (the human half).
- **TASK-197 D5** — product work splits out; run-again scripts are products.
- **ADR-005 / ADR-009 OQ4** — vault-pointer and secrets-hygiene precedents.

# Feature: Domain Troubleshooting Playbooks — "First Five Minutes" Cookbook Entries

**ID:** FEAT-203
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-08-24
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

The fw-troubleshoot skill (FEAT-202) is generic; expertise lives in knowing
*which* log, *which* status command, *which* config to read for a given
product. Capture that per domain as a **playbook** — a `cookbook/` entry the
skill reads at rung 6 (observe before experimenting) — so observation becomes a
checklist rather than judgment. Highest-leverage sharpener identified
2026-08-24: it is knowledge Gary already carries, and the cheapest capture
there is.

## Direction (proposed, confirm at design)

- One playbook per domain, at `kb/<domain>/cookbook/first-five-minutes.md`
  (fixed name so the skill can find it deterministically): log locations,
  status/version commands, config files, ports, the top documented failure
  modes with their tell-tale log lines, and where the vendor's KB lives.
- The skill's rung 6 reads the domain playbook if present and works through
  it before proposing anything; rung 3 reads its vendor-KB pointers.
- Playbook template ships in `templates/records/playbook.md`; first real
  instances come from real domains (kb `licensing` here; `3dx`/`hpc` in the
  HPC repo) — never invented in the abstract.
- **Environment baselines** fold in: a playbook links a known-good baseline
  snapshot (versions, ports, config hashes) so rung 6 can *diff* instead of
  read — produced by the collector script (FEAT-204) run on a healthy system.

## Open Questions (resolve before → doing)

- [ ] Fixed filename vs a `Playbook:` marker in any cookbook entry?
- [ ] First domain to author for real — `licensing` (FlexLM) here, or `3dx` in
      the HPC repo where the field precedent lives?

## Acceptance Criteria

- [ ] `templates/records/playbook.md` ships; the skill's rung 6 consults the
      domain playbook when present
- [ ] At least one real domain playbook authored and used in a real case
- [ ] Baseline linkage defined (with FEAT-204)
- [ ] Verified against the built plugin, not the source tree

## Related

- **FEAT-202** — the skill and case pattern this sharpens.
- **FEAT-204** — collector scripts / baselines (the playbook's tooling half).
- **TASK-205** — real-case dogfooding; supplies the first playbook's content.
- **FEAT-201** — cookbook/reference provenance split the playbook lives inside.

# Feature: `company` Knowledgebase Domain — One Home for Company Facts

**ID:** FEAT-194
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-08-19
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

Company-wide facts — contacts, policies, org info — get exactly one authored home: a
`company` domain in the knowledgebase, using the domain-first kb model (ADR-009 D4
amended). Contacts carry an activity-type designation (operations, sales, SOW-xxx, …)
instead of living in per-workspace `contacts/` folders.

Surfaced 2026-08-19 during the operations scaffold review (FEAT-193): multiple workspace
types scaffold a `contacts/` folder, so contact info would scatter and drift — the exact
pattern the Single-Source Rule (ADR-008) forbids. The original idea was a new `company/`
folder in fw-init; the kb domain is the better shape because the mechanism (domains,
INDEX.md, `/fw-new-domain`) already exists — no new top-level concept.

---

## Scope

**In scope:**
- Define the `company` domain's content shape: at minimum a contact list with activity
  designations; likely policies and org facts.
- Decide and implement how the domain comes to exist (see open questions).

**Out of scope:**
- FEAT-193's operations trim (files separately).
- CRM-grade contact management; this is a list with designations, not a database.

---

## Open Questions (resolve before → doing)

- [ ] Seeding: does fw-init / the kb scaffold create the `company` domain by default, or
      is it created on demand via `/fw-new-domain` (FEAT-192)?
- [ ] Does `contacts/` leave the shared scaffold floor for `application` and `sow` too,
      replaced by pointers to the kb domain? (FEAT-193 removes it only for operations.)
- [ ] Contact record format — one list file vs. per-contact files; how the activity
      designation is recorded.

---

## Acceptance Criteria

- [ ] Company facts have exactly one authored home; no workspace scaffold creates a
      competing `contacts/` copy (per the floor decision above)
- [ ] Contacts support an activity-type designation
- [ ] `framework.yaml` `sources:` (or the kb INDEX) points at the domain — pointers,
      never restatement
- [ ] Verified against the built plugin, not the source tree

---

## Related

- **FEAT-193** — operations scaffold trim; drops `contacts/` on the strength of this item.
- **FEAT-192** — `/fw-new-domain`; the likely creation path for the domain.
- **ADR-008** — Single-Source Rule; the reason contacts get one home.
- **ADR-009 D4 (amended)** — domain-first knowledgebase; the mechanism this reuses.

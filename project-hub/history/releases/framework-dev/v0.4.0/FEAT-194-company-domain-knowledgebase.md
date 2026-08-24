# Feature: `company` Knowledgebase Domain — One Home for Company Facts

**ID:** FEAT-194
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-08-19
**Workspace:** framework
**Completed:** 2026-08-24

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

- [x] Seeding: does fw-init / the kb scaffold create the `company` domain by default, or
      is it created on demand via `/fw-new-domain` (FEAT-192)?
      *Confirmed at review 2026-08-24 — on demand, via `/fw-new-kb-domain company`
      (FEAT-192's command, renamed at its implementation).*
      *Direction (Gary + AI, 2026-08-20, confirm at this item's review):* on demand via
      `/fw-new-domain`, not scaffolded (same lean as FEAT-198's on-demand `ROADMAP.md` —
      a pre-created empty domain is noise). The domain name is the **literal `company`**,
      never `<company-name>`: pointers need one predictable path across repos, and since
      the repo is the customer (ADR-009), each repo's `company` domain unambiguously
      means that customer.
- [x] Does `contacts/` leave the shared scaffold floor for `application` and `sow` too,
      replaced by pointers to the kb domain? (FEAT-193 removes it only for operations.)
      *Resolved 2026-08-24 (Gary): yes — `contacts/` leaves the floor entirely; any
      scaffolded contacts folder invites the scattered-copies drift this item exists
      to kill. Floor is now `meetings/ reference/ deliverables/ agreements/`.*
- [x] Contact record format — one list file vs. per-contact files; how the activity
      designation is recorded.
      *Resolved 2026-08-24 (Gary + AI): **per-contact records + generated views.**
      One file per person (`kb/company/contacts/<name-slug>.md`, shaped by the
      plugin's `templates/records/contact.md`): affiliation (customer / vendor /
      spearit — a field, so vendors share the registry), role, email/phone,
      activity designations, and repeatable
      `**Assigned:** <workspace> — <role in that work>` lines. Each workspace's
      `CONTACTS.md` is **derived** by `fw-contacts.sh` from those declarations
      (generated header; overwritten on refresh; removed when assignments go) —
      the board's `Workspace:`-field grammar applied to people. Chosen over one
      list file because cross-workspace links need stable targets (heading anchors
      break silently; a file rename is a visible `git mv`), and over hand-kept
      links because a generated view cannot drift.*

---

## Acceptance Criteria

- [x] Company facts have exactly one authored home; no workspace scaffold creates a
      competing `contacts/` copy (per the floor decision above) *(2026-08-24:
      `contacts/` removed from the floor template; fixtures regenerated without it;
      the registry at `kb/company/contacts/` is the one home)*
- [x] Contacts support an activity-type designation *(2026-08-24: `Activity:` field
      in `templates/records/contact.md`, plus per-workspace `Assigned:` context)*
- [x] `framework.yaml` `sources:` (or the kb INDEX) points at the domain — pointers,
      never restatement *(2026-08-24: the kb INDEX carries the domain's line — the
      new build's pointer surface; `framework.yaml` is the old repo's index and
      retires at graduation)*
- [x] Verified against the built plugin, not the source tree *(2026-08-24:
      `fw-contacts.sh` and `fw-new-kb-domain.sh company` both run from the
      published marketplace copy against the fixture registry — generation, stale
      removal, and missing-workspace warning all verified)*

---

## Related

- **FEAT-193** — operations scaffold trim; drops `contacts/` on the strength of this item.
- **FEAT-192** — `/fw-new-domain`; the likely creation path for the domain.
- **ADR-008** — Single-Source Rule; the reason contacts get one home.
- **ADR-009 D4 (amended)** — domain-first knowledgebase; the mechanism this reuses.

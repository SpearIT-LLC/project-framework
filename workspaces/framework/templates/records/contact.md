<!-- Contact record template (plugin: templates/records/contact.md).
     Created by fw-new-contact.sh <slug> into workspaces/kb/company/contacts/
     (the script strips this header and fills the # heading from the slug).
     This record is THE one home for this person's facts (ADR-008) — phone,
     email, role live here and nowhere else. Workspaces never keep copies:
     each workspace's CONTACTS.md is GENERATED from the Assigned lines below
     by fw-contacts.sh.

     The file slug is the record's KEY (links and fw-contacts bind to it); the
     # heading is the display name — the slug is lossy on purpose, so fix the
     heading's casing and punctuation by hand where the slug cannot carry them
     (o-brien -> O'Brien). Name collision (a second Jane Doe): keep the first
     file untouched, distinguish the new slug by org, then title
     (jane-doe-acme.md), and disambiguate the display too — "# Jane Doe
     (Acme)" — so generated views stay legible. Before reusing an existing
     record, confirm Affiliation/Role match your person.

     Affiliation grammar: "<org> (<relationship>)" — the organisation is always
     named, the relationship to this repo's engagement is one of
     customer | vendor | subcontractor | spearit. E.g. "Honda (customer)",
     "Bosch (vendor)", "Acme (subcontractor)", "SpearIT (spearit)".

     Fill rule: a field you don't know yet stays BLANK — blank means "not known
     yet", is greppable, and commits nothing false. A name-only record is a
     valid resting state. Delete only what cannot apply: extra Assigned lines.
     Workspace ties live ONLY in Assigned, never in Activity.

     Assigned: one line per workspace, "<workspace> — <role in that work>", or
     the single word "Unassigned" (registry membership needs no assignment).

     Previously: an assignment that has ENDED - same grammar as Assigned. When
     someone is replaced, MOVE their Assigned line to Previously rather than
     deleting it; add the successor's Assigned line to their own record. The
     generated CONTACTS.md reads only Assigned, so the view stays current while
     the record keeps the answer to "who set up the servers originally?" - a
     question that outlives the assignment. No dates: a start date would have to
     be captured at assignment time to be true, and the field you must remember
     to fill at the right moment is the field that stays empty. -->
# __FULL_NAME__

**Affiliation:**
**Group:**
**Role:**
**Email:**
**Phone:**
**Activity:**
**Assigned:** Unassigned
**Previously:**

## Notes


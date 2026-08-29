<!-- Contact record template (plugin: templates/records/contact.md).
     Created by fw-new-contact.sh <slug> into workspaces/kb/company/contacts/
     (the script strips this header). This record is THE one home for this
     person's facts (ADR-008) — phone, email, role live here and nowhere else.
     Workspaces never keep copies: each workspace's CONTACTS.md is GENERATED
     from the Assigned lines below by fw-contacts.sh.

     The file slug is the record's KEY (links and fw-contacts bind to it); the
     # heading is display only. Name collision (a second Jane Doe): keep the
     first file untouched, distinguish the new slug by org, then title
     (jane-doe-acme.md), and disambiguate the display too — "# Jane Doe
     (Acme)" — so generated views stay legible. Before reusing an existing
     record, confirm Affiliation/Role match your person.

     Affiliation grammar: "<org> (<relationship>)" — the organisation is always
     named, the relationship to this repo's engagement is one of
     customer | vendor | subcontractor | spearit. E.g. "Honda (customer)",
     "Bosch (vendor)", "Acme (subcontractor)", "SpearIT (spearit)".

     Required: the # name heading, Affiliation, Role, at least one of
     Email/Phone, and Assigned (one line per workspace, or the single word
     "Unassigned"). Fill rule: placeholder tokens (__X__) never survive a fill;
     an optional field you don't know stays BLANK (it is a prompt for later,
     and fw-contacts.sh ignores it); delete only what cannot apply — extra
     Assigned lines. Workspace ties live ONLY in Assigned, never in Activity. -->
# __FULL_NAME__

**Affiliation:** __ORG__ (__customer | vendor | subcontractor | spearit__)
**Role:** __ROLE_OR_TITLE__
**Email:** __EMAIL__
**Phone:** __PHONE__
**Activity:** __routing tags, each completing "contact this person for ___" at engagement level (billing, escalation, contracts); blank if none__
**Assigned:** __workspace-name__ — __role in that work__
**Assigned:** __one line per workspace; delete unused lines; or a single "Unassigned"__

## Notes


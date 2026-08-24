<!-- Contact record template (plugin: templates/records/contact.md).
     Usage: copy to workspaces/kb/company/contacts/<name-slug>.md and fill in.
     This record is THE one home for this person's facts (ADR-008) — phone,
     email, role live here and nowhere else. Workspaces never keep copies:
     each workspace's CONTACTS.md is GENERATED from the Assigned lines below
     by fw-contacts.sh. Repeat the Assigned line once per workspace; the text
     after the dash is this person's role in that specific work.

     The file slug is the record's KEY (links and fw-contacts bind to it); the
     # heading is display only. Name collision (a second Jane Doe): keep the
     first file untouched, distinguish the new slug by org, then title
     (jane-doe-acme.md), and disambiguate the display too — "# Jane Doe
     (Acme)" — so generated views stay legible. Before reusing an existing
     record, confirm Affiliation/Role match your person.

     Required: the # name heading, Affiliation, Role, and at least one of
     Email/Phone. Everything else is optional — DELETE empty optional fields
     rather than leaving placeholders (absence is honest; an empty field
     drifts). Assigned is optional: registry membership doesn't require an
     assignment. -->
# __FULL_NAME__

**Affiliation:** __customer | vendor:<org> | spearit__
**Role:** __ROLE_OR_TITLE__
**Email:** __EMAIL__
**Phone:** __PHONE__
**Activity:** __routing tags — each completes "contact this person for ___" at engagement level (billing, escalation, contracts). If the blank names a workspace, it's an Assigned line instead; if it doesn't complete the sentence, it's Role material. Delete if none__
**Assigned:** __workspace-name__ — __role in that work__
**Assigned:** __repeat one Assigned line per workspace; delete unused lines. Workspace ties live ONLY here, never in Activity__

## Notes


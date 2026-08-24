---
description: Regenerate per-workspace CONTACTS.md views from the contact registry
argument-hint: ""
---

# /fw-contacts - Refresh Workspace Contact Views

Contacts have exactly one authored home: per-contact records in the kb
`company` domain (`workspaces/kb/company/contacts/<name-slug>.md`, shaped by
the plugin's `templates/records/contact.md`). Each contact record declares its
workspace assignments (`**Assigned:** <workspace> — <role in that work>`,
repeatable); every workspace `CONTACTS.md` is a **generated view** of those
declarations — never edited by hand, same grammar as the board's
`Workspace:` field and its derived slices.

## Steps

1. **Run the script** — deterministic, no judgment involved:

   ```bash
   bash "${CLAUDE_PLUGIN_ROOT}/scripts/fw-contacts.sh"
   ```

   It regenerates `CONTACTS.md` in every assigned workspace, removes stale
   generated views from workspaces with no remaining assignments, and warns
   about assignments naming a workspace that doesn't exist. If it errors
   (e.g. no registry yet), report its message verbatim — the fix it names
   (create the `company` domain, add records from the template) is the path;
   do not hand-create any CONTACTS.md.

2. **Adding or changing a contact** (when the user asks): copy
   `${CLAUDE_PLUGIN_ROOT}/templates/records/contact.md` to
   `workspaces/kb/company/contacts/<name-slug>.md`, fill the fields with the
   user (affiliation, role, activity designations, assignments), then rerun
   the script. Never add a person directly to a CONTACTS.md.

3. **Report**: the script's generated/removed/warning lines.

---
description: Add or update a contact record, and regenerate per-workspace CONTACTS.md views from the contact registry
argument-hint: "<person name> [what to change]  |  refresh"
---

# /fw-contacts - Contacts: Add, Update, Refresh Views

Contacts have exactly one authored home: per-contact records in the kb
`company` domain (`workspaces/kb/company/contacts/<name-slug>.md`, created by
`fw-new-contact.sh` from the plugin's `templates/records/contact.md`). Each
record declares its workspace assignments (`**Assigned:** <workspace> — <role
in that work>`, repeatable, or the single word `Unassigned`); every workspace
`CONTACTS.md` is a **generated view** of those declarations — never edited by
hand, same grammar as the board's `Workspace:` field and its derived slices.
The `company` domain holds this repo's engagement facts whoever the
counterparty is; people from any organisation live in the one registry
(`Affiliation: <org> (customer | vendor | subcontractor | spearit)`).

**Arguments are never script arguments.** Words after the command name are a
person's name, optionally followed by what to change about them (step 2) —
except the single word `refresh` (step 1). The scripts take a slug or nothing.

## Steps

1. **`refresh`, or no arguments — regenerate the views.** Deterministic, no
   judgment involved:

   ```bash
   bash "${CLAUDE_PLUGIN_ROOT}/scripts/fw-contacts.sh"
   ```

   It regenerates `CONTACTS.md` in every assigned workspace, removes stale
   generated views from workspaces with no remaining assignments, and warns
   about assignments naming a workspace that doesn't exist. If it errors,
   report its message verbatim — the fix it names is the path (no `company`
   domain → `/fw-new-kb-domain company`; no contacts yet → step 2). Never
   hand-create a `CONTACTS.md` or the `contacts/` folder.

   Reach for this after editing a record **outside** Claude Code (another
   editor, a merge) — the `PostToolUse` hook cannot see those writes. Edits
   made through Claude refresh themselves, and a session start refreshes
   everything, so `refresh` is the mid-session catch-up for outside edits.

   `refresh` is a reserved word in this slot: to act on a person actually
   named Refresh, use their slug — `/fw-contacts refresh-smith`.

2. **With a name — add or update that person.** Resolve the name to a slug
   (`jane-doe`; if the registry already has a different Jane Doe, qualify
   by org: `jane-doe-acme`, display `# Jane Doe (Acme)`). Look for
   `workspaces/kb/company/contacts/<slug>.md`.

   - **Not found → add.** Confirm "No record for Jane Doe — create one?",
     then run the create gate (it makes the registry folder on first use):

     ```bash
     bash "${CLAUDE_PLUGIN_ROOT}/scripts/fw-new-contact.sh" <slug>
     ```

     The record arrives valid and name-only: display name filled from the
     slug, every other field blank, `Assigned: Unassigned`. **Fix the display
     name first** if the slug lost casing or punctuation (`o-brien` →
     `O'Brien`), then ask in one prompt for what the user knows: organisation
     and relationship (customer / vendor / subcontractor / spearit), role,
     email or phone, and which workspaces they're assigned to with their role
     in each. Whatever they don't know stays **blank** — blank means "not
     known yet", and the record is a legitimate resting state at any point.
     Never write a placeholder token; delete only unused `Assigned` lines.

   - **Found → update.** Show the record's current fields in a few lines and
     ask what changes (if the user already said — "assign to widget as PM",
     "phone is …" — confirm that reading instead of asking). Edit in place:
     add/remove `Assigned` lines, fill a blank field, correct a value.
     Replace an `Unassigned` line when the first assignment arrives.

   The `PostToolUse` hook (`hooks/refresh-contacts.sh`) regenerates the views
   as soon as the record is written, so no follow-up step is needed. Run the
   step 1 script by hand only if the hook's output did not appear.

3. **Report**: what was created or changed, then the
   generated / removed / warning lines (from the hook, or from the script if
   you ran it yourself).

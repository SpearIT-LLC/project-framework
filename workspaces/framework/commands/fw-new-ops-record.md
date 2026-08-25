---
description: Create an operations record (incident or request) with the next shared id
argument-hint: "<inc|req> <slug>"
---

# /fw-new-ops-record - Create an Operations Record

Operations records (`INC-nnn` incidents, `REQ-nnn` requests) are created by a
command, never by hand — the id comes from one shared sequence per operations
workspace (FEAT-195), the shape from the plugin's `templates/records/ops-record.md`
(a project's `.claude/templates/records/` overrides), and the record lands in
`workspaces/operations/open/`. The prefix carries the kind; the folder carries the
status. Customer ticket ids are a cross-reference field, never our key.

## Steps

1. **Run the script** — the create gate:

   ```bash
   bash "${CLAUDE_PLUGIN_ROOT}/scripts/fw-new-ops-record.sh" <inc|req> <slug>
   ```

   If the user gave a kind but no slug, ask: "Short slug for the filename?"
   (symptom-first for incidents, outcome-first for requests). If the script
   errors (no operations workspace yet, bad kind), report its message verbatim
   and stop — do not create anything by hand.

2. **Fill the record with the user** (the judgment step): replace `__TITLE__`,
   write "What happened / What is requested" verbatim where possible, add the
   customer ticket id(s) and contact links if known, and **delete optional
   fields that don't apply** (`Due`, `Customer ref`, `Contacts`) rather than
   leaving placeholders. Leave `Closed:` and `Resolution:` blank — the move
   engine stamps them.

3. **Report** the created path. If the record is an incident that needs
   investigation, the `fw-troubleshoot` skill takes it from here (it uses this
   record as the flow anchor).

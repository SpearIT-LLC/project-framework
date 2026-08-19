---
description: Create a new workspace with the scaffold for its type
argument-hint: "<name> <type> [domain]  |  operations"
---

# /fw-new-workspace - Create a Workspace

Stand up a workspace under `workspaces/` as a command, not an improvisation
(ADR-009 D3). The folder structure has exactly one home:
`scripts/fw-new-workspace.sh`. Never create workspace folders by hand, and never
restate the folder tree in this or any other document.

## Steps

1. **Run the script** — it is the sole authority for structure:

   ```bash
   bash "${CLAUDE_PLUGIN_ROOT}/scripts/fw-new-workspace.sh" <name> <type> [domain]
   ```

   Types: `application`, `knowledgebase`, `sow`, `operations`. For `operations`
   the name may be omitted and defaults to the type. Naming convention:
   applications are named for the application; sow workspaces for the SOW id
   (e.g. `BD-SOW-001`).

   A `knowledgebase` requires a **domain** — the subject area its first content
   belongs to (e.g. `licensing`). If the user didn't provide one, ask: "What is
   the first domain this knowledgebase will hold?" — then pass their answer as
   the third argument. If the script errors, report its message verbatim and
   stop — do not create anything by hand.

2. **Fill in the purpose** (the judgment step). Ask the user: "What is this
   workspace for, in a sentence or two?" Replace `_PURPOSE_PENDING_` in the
   generated `README.md` with their answer — edited for clarity, not
   embellished.

3. **Report**: the tree the script printed and the finished README.

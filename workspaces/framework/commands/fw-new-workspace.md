---
description: Create a new workspace with the scaffold for its type
argument-hint: "<type> <name>  |  operations  |  kb <domain>"
---

# /fw-new-workspace - Create a Workspace

Stand up a workspace under `workspaces/` as a command, not an improvisation
(ADR-009 D3, amended by TASK-197). Structure and seeded content have exactly one
authored home: `templates/workspaces/` (floor + per-type overlays), composed by
`scripts/fw-new-workspace.sh` — the sole creation path. Never create workspace
folders by hand, and never restate the folder trees in this or any other
document. A project may override the templates wholesale via its own
`.claude/templates/workspaces/`.

## Steps

1. **Run the script** — it is the sole authority for structure:

   ```bash
   bash "${CLAUDE_PLUGIN_ROOT}/scripts/fw-new-workspace.sh" <type> <name>
   bash "${CLAUDE_PLUGIN_ROOT}/scripts/fw-new-workspace.sh" operations
   bash "${CLAUDE_PLUGIN_ROOT}/scripts/fw-new-workspace.sh" kb <domain>
   ```

   **Argument order is type first.** Types (case-insensitive): `product`,
   `project`, `kb`, `operations`. Only `product` and `project` take a custom
   name — **if the user gave one of those types but no name, ask:** "What
   should this workspace be called?" `kb` and `operations` are one-per-repo
   with fixed folder names (`workspaces/kb`, `workspaces/operations`); the
   script accepts any casing or the long form `knowledgebase` but always
   creates `kb/`.

   Naming convention: a product is named for the product; a project for the
   initiative — and **contracted work (an SOW) is a project named for the SOW
   id** (e.g. `bd-sow-001`); there is no `sow` type. Software or tooling a
   project delivers gets its own `product` workspace from day one — the
   project workspace references it.

   `kb` requires a **domain** — the subject area its first content belongs to
   (e.g. `licensing`). If the user didn't provide one, ask: "What is the first
   domain this knowledgebase will hold?" — then pass their answer as the
   second argument. If the script errors, report its message verbatim and
   stop — do not create anything by hand.

2. **Fill in the purpose** (the judgment step). Ask the user: "What is this
   workspace for, in a sentence or two?" Replace `_PURPOSE_PENDING_` in the
   generated `README.md` with their answer — edited for clarity, not
   embellished.

3. **Report**: the tree the script printed and the finished README.

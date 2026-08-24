---
description: Add a domain to the knowledgebase (creates the kb on first use)
argument-hint: "<domain>"
---

# /fw-new-kb-domain - Add a Knowledgebase Domain

Grow the knowledgebase by a domain, as a command, not an improvisation
(ADR-009 D3). The kb lives at the fixed path `workspaces/kb`; this command
creates it on first use, so it works from zero. Domain structure and seeded
content have exactly one authored home: the workspace templates' knowledgebase
`_domain_/` shape. Never create domain folders by hand, and never restate the
folder tree in this or any other document. (`/fw-new-workspace kb <domain>`
delegates to this same script — either door, one path.)

## Steps

1. **Run the script** — it is the sole authority for structure:

   ```bash
   bash "${CLAUDE_PLUGIN_ROOT}/scripts/fw-new-kb-domain.sh" <domain>
   ```

   The domain is the subject area the content belongs to (e.g. `licensing`,
   `hpc`, `company`). If the user didn't name one, ask: "What subject area is
   this domain for?" If the script errors, report its message verbatim and
   stop — do not create anything by hand.

2. **Fill in the INDEX line** (the judgment step). Ask the user: "One line —
   what does this domain hold?" Replace the domain's
   `_one-line description pending_` entry in `workspaces/kb/INDEX.md` with
   their answer — edited for clarity, not embellished. If this run also
   created the kb itself, fill the README purpose the same way (ask: "What is
   this knowledgebase for, in a sentence?").

3. **Report**: the tree the script printed and the updated INDEX line.

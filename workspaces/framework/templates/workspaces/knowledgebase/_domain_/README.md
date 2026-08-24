# __DOMAIN__

A knowledgebase domain. The folders encode **provenance** — where a claim comes
from — which a reader cannot recover from content alone:

- `cookbook/` — working recipes: do-this-to-get-that, verified by use.
- `faq/` — questions actually asked, with their answers.
- `reference/` — authoritative material we **read but did not write**: vendor
  docs, saved spec pages, standards. Not ours to edit, only to annotate. Goes
  stale by *release* — replace when the upstream version moves.
- `research/` — material we **curated and concluded**: synthesis from one or
  many sources, carrying our own conclusions. We stand behind it, not the
  vendor. Goes stale by *refutation* — a claim is disproven, we revise.
  Troubleshooting cases (symptom → evidence → conclusion) live here as case
  folders — see the plugin's `templates/records/ts-case.md` and the
  fw-troubleshoot skill.

On conflict, neither `reference/` nor `research/` automatically outranks the
other — they are different kinds of claims (the vendor may be silent or wrong;
our conclusion may be stale). A conflict is a finding: record it.

**Boundary:** kb `research/` holds the distilled, durable output — it reads
like a position paper. The investigation *process* record (spikes, dead ends,
lab-notebook material) belongs in the project hub's research area, not here.

**Licensing note for `reference/`:** pointers, install paths, and brief
excerpts commit; wholesale copies of licensed vendor documents stay in
git-ignored scratch.

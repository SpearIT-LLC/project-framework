# Bug: Contact Records — Optional Fields Deleted, No Update Path

**ID:** BUG-207
**Type:** Bug
**Priority:** High
**Version Impact:** PATCH
**Created:** 2026-08-29
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

UAT-13 (the one FAIL of the 2026-08-26..29 run) — `templates/records/contact.md` tells
the author to delete empty optional fields, and `/fw-contacts` has no procedure for
updating an existing record. Result: a later-arriving phone or email must be re-added by
hand with the right field name and order, and the record shape drifts from the template.

## Bug Description

**Actual:** the template's comment header says delete empty optionals (Email, Phone,
Activity, Notes). `fw-contacts.sh` parses only `# Name` and `**Assigned:**` (and already
skips blank / `__` Assigned lines) — the delete rule has no machine basis. Command step 2
covers *adding* a contact only; arguments to `/fw-contacts` print a usage line from the
script (UAT-10).

**Expected:** required fields filled; placeholder tokens (`__X__`) never survive; blank
optional fields stay as a prompt; delete only what cannot apply (extra `Assigned` lines).
`/fw-contacts <name>` → AI opens the record, edits per template, reruns the script.

**Impact:** every contact record authored so far; the registry is the one authored home
for contacts (ADR-008), so a lossy shape is a data problem, not cosmetic.

## Fix Design

1. `templates/records/contact.md` — replace the delete rule with the keep-blank rule above.
2. `commands/fw-contacts.md` — add an **Update** step: arguments are a request to add or
   change that contact (not script args); open or create the record, edit per template,
   rerun. Also fix the no-registry error to distinguish "no `company` domain" from "no
   contacts yet", and to speak in command syntax (`/fw-new-kb-domain company`,
   `/fw-contacts <name>`), not `.sh` (UAT-10).
3. **Option (decide at review):** a small `fw-new-contact.sh <slug>` that copies the
   template, strips the comment header, and creates `contacts/` on first use — making
   record creation deterministic (as `fw-new-ops-record.sh` is) and closing the
   hand-made-`contacts/` gap (UAT-08/11/28). If taken, FEAT-210's "seed `contacts/`"
   item is satisfied here.

## Acceptance Criteria

- [x] Template no longer instructs deleting blank optionals; placeholders never survive
      *(2026-08-29; also: `Assigned: Unassigned`, `Affiliation: <org> (relationship)`)*
- [x] `/fw-contacts <name>` adds or updates a record and regenerates views *(2026-08-29;
      option 3 taken — `fw-new-contact.sh <slug>` is the create gate, seeds `contacts/`)*
- [x] No-registry error names the actual gap in command syntax *(2026-08-29; script-level
      checks in scratchpad: no domain / no records / bad slug / create+header strip / dup /
      Unassigned → no view / assigned → view)*
- [ ] UAT-10 and UAT-13 re-run PASS against the built plugin

## Decisions (2026-08-29, Gary)

- No assignment → literal `**Assigned:** Unassigned` (script ignores it).
- `company` stays the fixed domain name: one repo per customer (Honda, Boston Dynamics,
  Toyota, SpearIT), and `company` holds that engagement's facts. People from any org share
  the registry; `Affiliation: <org> (customer | vendor | subcontractor | spearit)` names
  the org always, so records stay portable and give the future INDEX its grouping key.
- `/fw-contacts` argument grammar: `<name> [what to change]`; never script args.

## Related

- **FEAT-194** — company domain / contact registry (owning FEAT).
- **FEAT-210** — command UX pass (contacts INDEX/exports live there, not here).
- `workspaces/framework/tests/UAT-RESULTS-2026-08-26.md` rows UAT-08, 10, 11, 13.

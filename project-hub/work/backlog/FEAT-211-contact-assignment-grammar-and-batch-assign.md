# Feature: Contact Assignment Rework — Title vs Function, `;` Delimiter, Batch Assign

**ID:** FEAT-211
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR (unreleased feature — format correction, not a break)
**Created:** 2026-08-31
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

Raised by Gary during the UAT-06 session (2026-08-31) while adding a contact with
no assignments. Three related defects in the contact record grammar, reworked
together because they touch the same lines and the same parser:

1. **`Role:` means two different things.** The top-level `**Role:**` is an
   org-level *title* (changes on promotion). The trailing part of each
   `**Assigned:** <workspace> — <role>` line is that person's *function on that
   engagement* — senior developer on one product, architect on another, tester on
   a third. One word, two facts. Rename the header field to `**Title:**`.
2. **`—` is a poor delimiter.** A dash is common inside role and org names and is
   used inconsistently as a separator. Adopt `;` — a comma was considered and
   rejected because it occurs naturally inside names ("Engineering, Platform")
   and would need escaping.
3. **Re-assigning a team to a new workspace is O(N) hand edits.** With ~50
   contacts, standing up a new project means opening 50 records.

Contacts have not shipped yet, so all three are straight corrections to the
format — no migration, no back-compat period.

## Direction (proposed, confirm at design)

- **Grammar spec.** Formalise the `**Field:** value` line grammar in one authored
  home (the UAT-12 note already proposed this): first `;` splits an `Assigned:`
  line; workspace must match a real `workspaces/<name>` folder; function required
  and non-empty; `Unassigned` remains the single-word alternative.
- **`--check` validation** in `fw-contacts.sh`: unknown workspace, empty function,
  surviving `__PLACEHOLDER__`.
- **Batch assign** — `/fw-contacts assign <workspace>`: lists the registry, user
  multi-selects, **then prompts for each selected person's function on that
  workspace**, and writes real `Assigned:` lines into each record. The command
  removes the typing, not the explicitness — every assignment stays an authored,
  greppable fact.
- **No migration.** The feature is unreleased; `;` simply becomes the format and
  `—` is never parsed. The only `—` records in existence are the UAT fixtures in
  `framework-uat`, rewritten by hand or discarded.

## Rejected

- **Shorthand / wildcards** (`all`, `*`, "all of Fred's projects"). A derived set
  is not a fact: it silently re-scopes people when someone else's record changes
  or a new workspace appears, making the registry non-auditable. Assignment stays
  explicit, dated, attributable.
- **Defaulting the per-engagement function from the title.** Varying function per
  engagement is the normal case, so there is no correct default to inherit. (This
  was proposed and withdrawn in the same conversation.)
- **Groups / `Member-of:`** — deferred, not rejected. Adds a second authored home
  and indirection; revisit only if the same set of people demonstrably move
  together more than once.
- **YAML front matter** — only if a third element ever joins the tuple (dates,
  allocation %), which would make the positional line form unreadable.

## Open Questions (resolve before → doing)

- [ ] Does `Title:` want to be optional? (A contact may have no meaningful org title.)
- [ ] Should batch assign also support batch *un*assign when a project closes?
- [ ] Does the master `INDEX.md` (UAT-12 suggestion) land first? Batch assignment is
      hard to verify without a whole-registry view, and "who are our architects?"
      becomes a query across `Assigned:` lines rather than a title lookup.

## Acceptance Criteria

- [ ] `Title:` / per-engagement function distinction documented and in the template
- [ ] `;` is the delimiter; `—` is not parsed at all
- [ ] Grammar spec has exactly one authored home; no document restates it
- [ ] `--check` catches unknown workspace, empty function, surviving placeholders
- [ ] Batch assign writes explicit per-person lines and prompts per-workspace function
- [ ] Verified against the built plugin, not the source tree

## Related

- **FEAT-194** — contacts in the kb company domain (owning FEAT).
- **BUG-207** — blank optionals persist; same template-contract territory.
- **BUG-212** — its fix leans on this card's `--check` to enforce required-vs-optional
  once placeholder tokens are gone. Land BUG-212's blank-field seeding first (it is
  small and independent); `--check` then validates records that already parse.
- **FEAT-210** — the grammar spec and `--check` were split out of its contacts section
  into this card on 2026-08-31; FEAT-210 keeps the INDEX master view and exports, which
  consume the grammar settled here. Its third open question depends on that ordering.
- `workspaces/framework/tests/UAT-RESULTS-2026-08-26.md` — UAT-12 notes (master
  contact view, formalise the grammar, `--check`, structured exports).

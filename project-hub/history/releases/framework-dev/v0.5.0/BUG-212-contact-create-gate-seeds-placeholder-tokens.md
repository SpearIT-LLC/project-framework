# Bug: Contact Create Gate Seeds Placeholder Tokens, Leaving No Valid Resting State

**ID:** BUG-212
**Type:** Bug
**Priority:** Medium
**Version Impact:** PATCH
**Created:** 2026-08-31
**Workspace:** framework
**Completed:** 2026-09-01

---

## Summary

Found ad-hoc on 2026-08-31 while adding a contact through `/fw-contacts <name>`.
`fw-new-contact.sh` copies `templates/records/contact.md`, which seeds every field
with a placeholder token (`__ORG__`, `__EMAIL__`, `__ROLE_OR_TITLE__`,
`__workspace-name__ — __role in that work__`). The template contract also states
that placeholder tokens must never survive. Between "created" and "fully filled"
there is therefore **no legal state**.

That matters because the normal case is a partial one: often all you have when a
person first comes up is their name. An interrupted add leaves a record on disk
that is indistinguishable from a botched fill, with no cleanup path short of
deleting it.

The blank-field convention established by BUG-207 already expresses "not known
yet", is greppable, and commits nothing false:

```
# The Great Gazoo

**Affiliation:**
**Role:** Galactic Technical Wizard
**Email:**
**Phone:**
**Activity:**
**Assigned:** Unassigned
```

## Reproduction

1. `/fw-contacts <a name not in the registry>` → accept the create.
2. `fw-new-contact.sh <slug>` creates the record; stop before filling it.
3. Observe: the record contains `__ORG__`, `__EMAIL__`, etc. — a state the
   template forbids, sitting in the registry.

**Reproducibility:** Always.

## Fix Design

- The create gate emits **empty** `**Field:**` lines, not placeholder tokens.
- Field guidance lives in the command, or in a comment header the script strips
  on copy (as it already strips the template's header) — never in the values.
- Required-vs-optional is enforced by a `fw-contacts --check` pass (see
  FEAT-211), not by tokens sitting in the file.
- `Assigned:` defaults to the single word `Unassigned` so a name-only record is
  valid and parses.

## Not the Problem

An earlier reading — that the create gate should follow the intake conversation,
by analogy with the UAT-15 finding on ops records — was **withdrawn**. An ops
record's slug encodes the symptom, which is not known at open time; a contact's
slug encodes the person's name, which is the one fact you always have first.
Creating on the name alone is correct; only the seeded content is wrong.

## Acceptance Criteria

- [x] A freshly created record contains no `__` tokens *(2026-08-31: template seeds empty
      `**Field:**` lines; `fw-new-contact.sh` fills `# __FULL_NAME__` from the slug)*
- [x] A name-only record (all other fields blank, `Assigned: Unassigned`) is
      valid, parses, and round-trips through `fw-contacts.sh` without warnings
      *(2026-08-31 scratchpad: "Done: 0 workspace view(s) generated.", exit 0, no warning;
      a later-filled `Assigned` line generates the view as before)*
- [x] Field guidance is available to the user without living in the record values
      *(2026-08-31: stripped comment header + `/fw-contacts` step 2)*
- [x] Verified against the built plugin, not the source tree *(2026-09-01: installed
      0.4.4 in framework-uat — `/plugin` shows 0.4.4 Enabled, hooks registered.
      `/fw-contacts Wilma Flintstone` → valid name-only record: `# Wilma Flintstone`
      from the slug, all other fields blank, `Assigned: Unassigned`, no `__` tokens;
      registry-wide grep for `__` clean. Caveat: `dev-marketplace` is a directory
      source behind a symlink, so the installed plugin and the source tree are the
      same bytes — this verifies the plugin machinery (command resolution, script
      execution, `CLAUDE_PLUGIN_ROOT`, hook registration), not an independently
      built artifact. TECH-188 covers that gap.)*
- [x] A record edited **outside** Claude Code does not leave the views stale for the
      rest of the session *(2026-09-01: `SessionStart` hook, 0.4.5 — see below)*

## Decision (2026-08-31, Gary)

The `#` heading is the **display name**; the slug is the **key**. Not duplication — the slug
is lossy by design (lowercase, dashed, org-qualified on collision). The gate seeds the
heading title-cased from the slug as a convenience and tells the user to fix what the slug
could not carry (`o-brien` → `O'Brien`, `jane-doe-acme` → `Jane Doe (Acme)`).

`Role:` is left untouched here — FEAT-211 renames it to `Title:` and reworks the
per-engagement function in the same pass.

## Scope Extension (2026-09-01, Gary) — stale views after an outside-Claude edit

Found while verifying the criterion above: editing a contact record by hand left
`CONTACTS.md` stale. The 0.4.4 `PostToolUse` hook fires only for Claude's own
Edit/Write tools — verified working: one Edit call changing Wilma's assignment
refreshed the view with no script run. But an edit made in notepad, another editor,
or by a merge is invisible to the harness, so no `PostToolUse` hook can observe it.
`tools/pre-commit` caught it at the commit boundary (verified: `--check` exit 1 with
the diff), leaving the view stale on disk for the whole window in between.

No open card covered this, so it was folded in here rather than filed separately.

**Fix (0.4.5):** a `SessionStart` hook (`startup|resume|clear`) running
`refresh-contacts.sh --all`, which skips the stdin `file_path` parse, resolves the
repo root via `git rev-parse`, and regenerates unconditionally. The session boundary
is the earliest point an outside edit can be caught; pre-commit stays the backstop.

`FileChanged` was considered and rejected: its matcher takes literal filenames from a
narrow character set (letters, digits, `_`, `|`), which cannot express "any record in
`contacts/`" when the filenames are arbitrary person-slugs. The docs also leave its
watch-list construction and payload unspecified. Worth revisiting if that changes.

**Verified 2026-09-01** (hook script invoked directly with realistic payloads):
outside-Claude edit (`sed`) → session-start refresh picked it up; no-registry repo →
silent, exit 0; non-git directory → silent, exit 0; `PostToolUse` path and its
unrelated-file no-op both still correct. A live in-session `SessionStart` firing
needs a restart to observe, and is not yet covered by a numbered UAT.

## Related

- **FEAT-194** — contacts in the kb company domain (owning FEAT).
- **BUG-207** — blank optionals persist rather than being deleted; same contract.
- **FEAT-211** — grammar spec and `--check` that this fix leans on.
- `workspaces/framework/tests/UAT-RESULTS-2026-08-26.md` — ad-hoc 2026-08-31 section.

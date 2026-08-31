# Feature: New-Build Command UX Pass (UAT 2026-08-26..29 Findings)

**ID:** FEAT-210
**Type:** Feature
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-08-29
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

One card for the user-experience findings from the first full UAT run of the ADR-009
build (TASK-206). Every item is "works, but the user experience depends on AI
improvisation or reads like a script log." Grouped by command; each bullet cites its UAT
row. Split out any item that grows past a session's work.

## Scope

### Guard errors and type mapping — `/fw-new-workspace` (UAT-05, 14, 20; also 10)
- Script messages: drop card/ADR ids (`TASK-197`, `ADR-009 D5`); no usage dump on type
  errors; where the intent is inferable add `Did you mean: /fw-new-workspace product foo`
  in **command** syntax. Every "create it first" fix names the command, never the `.sh`.
- Command prompt states the mapping rule: any deliverable software/tool/service/db/
  pipeline → `product`; contracted work → `project`. On `unknown type` (or the
  `application`/`sow` redirects) the AI does not relay the error — it explains product vs
  project in a sentence each, proposes the likely type carrying the user's name
  ("Create `/fw-new-workspace product tradewinds`?"), falls back to "product or
  project?" when it cannot tell, and runs the script only after confirmation. Never
  auto-create on a guess. Script stays four-type strict.
- Short-form aliases: bare `/fw-new-workspace` reports `Unknown command` before resolving
  to the namespaced form (UAT-00) — confirm whether the plugin can register them.

### Purpose prompts (UAT-03, 04, 07)
- `operations` and `kb` (one-per-repo) get a pre-filled purpose from the template — no
  prompt. Operations README gains a type-guidance paragraph like product/project.
- Purpose / INDEX one-liner prompts offer help: "enter a description, or say *help* and
  I'll draft one from the name and context for you to edit" (kb domains, products,
  projects). Overlaps FEAT-191 — reconcile at design.

### Ops records — `/fw-new-ops-record`, `/fw-move` (UAT-15, 15b, 17, 21)
- **Intake first, slug second:** the command runs an intake conversation (INC: symptom,
  when/pattern, impact, environment + recent changes, reporter/customer ref, already
  tried, urgency/due, contacts; REQ: requested outcome, requester, due, acceptance;
  unknowns recorded as unknown), the AI proposes a symptom-first slug, *then* the script
  creates the record. Today the slug is fixed before the facts are known and there is no
  rename path.
- Keep blank optionals (same rule as BUG-207); template header rules that matter after
  fill (attachments → `<ID>/` bundle beside the record, linked from Actions) move into
  the command; notes convention stated: notes → dated, attributed `## Actions` line;
  header facts edited in place. Script validates `Due` ≥ `Opened`.
- Close gate asks which kb domain when ambiguous (UAT-17). Sweep prints "bundle … moved"
  like status moves do (UAT-21).

### Contacts — `/fw-contacts` (UAT-08, 11, 12)
- Seed `kb/company/contacts/` (+ pointer README) when the `company` domain is created,
  or via the `fw-new-contact.sh` option in BUG-207 — closes the one hand-made structural
  folder found by UAT-28.
- Master view: `fw-contacts.sh` also emits `kb/company/contacts/INDEX.md` (machine
  header; per person link, affiliation, role, assigned workspaces; grouped by
  affiliation; no email/phone). Same script, same run, no new command.
- Registry format: keep Markdown-per-record as the authored source; formalise the
  `**Field:** value` grammar as a spec; add `fw-contacts --check`; emit `contacts.csv`/
  `.json` and per-workspace `CONTACTS.csv` from the same collected data. YAML front
  matter is the fallback if the grammar proves too loose; CSV as *source* rejected.
  **Split out 2026-08-31:** the grammar spec and `--check` moved to **FEAT-211**, which
  reworks the same lines (`Title:` vs per-engagement function, `;` delimiter, batch
  assign). Do FEAT-211 first; what remains here is the INDEX master view and the
  structured exports, both of which read whatever grammar FEAT-211 settles on.

### Troubleshoot skill — `fw-troubleshoot` (UAT-23, 24, 26)
- Rungs get names alongside numbers (numbers stay for the `Resolved at rung` stamp):
  1 Capture · 2 Search own kb · 3 Documented causes · 4 Anchor · 5 Open the case ·
  6 Observe · 7 Test · 9 Close gate; rung 8 (evidence hygiene) becomes a standing rule.
  The skill announces the rung by name at each step ("Rung 6 · Observe — nothing changed
  yet").
- Configurable kb search path so rung 2 can include an external/shared kb (SpearIT-KB)
  without the user steering it each time.
- Anchor ambiguity: with an ops workspace present, a rung-2 resolution opens no INC while
  a rung-4+ one does. Decide whether every troubleshoot with an ops workspace gets an
  anchor; write the rule into the ladder.

### Deferred — decide before board crossover (UAT-20)
Ids are unique only within a namespace (`fw-next-id.sh` keeps one sequence per root), so
`INC-003` and `FEAT-003` can coexist; bare numeric ids resolve today only because
operations is the sole active namespace. **Recommendation (a):** once two namespaces are
active, require the prefix — bare ids refused with "which: INC-003 or FEAT-003?". Not
part of this card's implementation; carry to the crossover decision (ADR-009 D5).

## Surprising-but-correct notes for owning FEATs

Owning FEATs shipped in framework-dev v0.4.0 (archived under `history/releases/`), so
the notes are recorded here rather than by editing archives.

- **FEAT-164:** short-form alias behaviour (UAT-00); exists-check fires before the
  case-insensitive loop on Windows — correct either way (UAT-05); override is wholesale
  (UAT-06 → BUG-208).
- **FEAT-192/194:** `company` is an ordinary domain by structure; `contacts/` is a
  convention no script seeds (UAT-08).
- **FEAT-195:** bucketed records still count toward the sequence — correct (UAT-21).
- **FEAT-202:** rung-2 vs rung-4 anchor difference is consistent with the ladder but
  reads as ambiguity (UAT-23/26). Sample-config contents chosen by AI — gate should ask
  for real values or mark SAMPLE (UAT-25).
- Not filed: the UAT-25 "product BUG" (ship a sample config + clear error) is against the
  throwaway `widget` in `framework-uat`, not this repo.

## Acceptance Criteria

- [ ] Each scoped item implemented or explicitly split to its own card
- [ ] Affected UAT rows re-run PASS against the built plugin; runbook rows adjusted
      where the expected behaviour changed (UAT-05, 10, 14, 15, 24)
- [ ] No new prose-only invariant: anything that must hold lives in a script or the
      command's steps

## Related

- **TASK-206** — the run that produced these. **BUG-207 / BUG-208 / FEAT-209** — split
  out already. **FEAT-191** — purpose intake overlap. **TASK-205** — real-case dogfooding
  will re-test the skill items.
- `workspaces/framework/tests/UAT-RESULTS-2026-08-26.md` (rows cited above).

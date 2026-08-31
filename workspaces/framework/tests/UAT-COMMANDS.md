# UAT — spearit-framework-dev Commands, Scripts, and Skills

**Purpose:** user-acceptance tests for everything the ADR-009 build ships, run the way a
user runs them — through Claude Code, in a **consuming repo** where `workspaces/framework/`
does not exist. That last condition is the point: it proves the plugin is self-contained
(`${CLAUDE_PLUGIN_ROOT}` resolves templates and scripts) and that no structure is
hand-made. Script-level tests already live in the session histories; UAT is about the
user's experience of the commands, including the AI judgment steps the scripts can't do.

**How to run:** one test at a time, in order (later tests depend on earlier state). Record
results in the table at the end — date, plugin version, pass/fail, notes. A failed test
files a BUG card; a surprising-but-correct result files a note on the owning FEAT.

**Conventions:** `>` = what the user types (a slash command or a plain sentence).
"AI asks" = the command's judgment step must actually prompt, not assume.

---

## UAT-00 — Environment (precondition for everything)

1. Create a throwaway repo outside this one: `mkdir uat-repo && cd uat-repo && git init`.
   Add a one-line `CLAUDE.md` so Claude Code opens it as a project.
2. Install the plugin from the dev marketplace (`/plugin marketplace add …`, then
   `/plugin install spearit-framework-dev@dev-marketplace --scope local`); restart.
3. **Expected:** `/help` lists `fw-new-workspace`, `fw-new-kb-domain`, `fw-contacts`,
   `fw-new-ops-record`, `fw-move` under the plugin namespace, and the `fw-troubleshoot`
   skill is available. No `workspaces/` exists yet.
4. **Pass:** all listed; nothing pre-created.

---

## A. `/fw-new-workspace`

**UAT-01 — product.** `> /fw-new-workspace product widget`
- Expected: `workspaces/widget/` with `agreements deliverables dist meetings poc reference
  requirements src tests` + `README.md`; `deliverables/README.md` carries the
  handed-over-and-accepted rule; **AI asks** for the purpose and writes it into README.
- Pass: tree exact (no `contacts/`), README `Type: product`, purpose filled, product README
  states the requirements living-vs-frozen distinction.

**UAT-02 — project (SOW-named).** `> /fw-new-workspace project bd-sow-001`
- Expected: floor + `requirements/`; README `Type: project` with the "contracted work is a
  project named for the SOW" guidance and the product-splits-out rule; AI asks purpose.
- Pass: tree = `agreements deliverables meetings reference requirements`; no `src`.

**UAT-03 — operations (no name).** `> /fw-new-workspace operations`
- Expected: `workspaces/operations/` = `open onhold closed meetings agreements reference`
  + README. Then `> /fw-new-workspace operations east` → refused: "operations takes no
  name".
- Pass: exact six folders; no `intake/`, `deliverables/`, `contacts/`; the named form errors.

**UAT-04 — kb through the workspace door.** `> /fw-new-workspace KB licensing`
- Expected: `workspaces/kb/` (fixed name despite `KB` casing) with `README.md`, `INDEX.md`
  listing `licensing`, and `licensing/{cookbook,faq,reference,research}` + a domain README
  stating reference = theirs / research = ours; **AI asks** for the INDEX one-liner and
  the kb purpose.
- Pass: four-folder domain; INDEX line filled from the user's answer.

**UAT-05 — negatives and guards.**
- `> /fw-new-workspace application foo` → "renamed product" pointer, nothing created.
- `> /fw-new-workspace sow bd-sow-002` → "an SOW is a project named for the SOW" pointer.
- `> /fw-new-workspace product` → **AI asks** "What should this workspace be called?"
  (the script must not be run with a missing name).
- `> /fw-new-workspace product Widget` → refused, case-insensitive collision with `widget`.
- Pass: all four behave; the AI never hand-creates a folder to "help".

**UAT-06 — project-level template override.** Create
`.claude/templates/workspaces/floor/custom-floor/.gitkeep` and
`.claude/templates/workspaces/project/README.md` containing `# __NAME__ (override)`.
`> /fw-new-workspace project ovr-test`
- Expected: script announces "Using project template override: …"; tree contains
  `custom-floor/`; README reads `# ovr-test (override)`.
- Then, with the override still lacking a `product/` overlay:
  `> /fw-new-workspace product missing-type`
- Expected: clean refusal naming the missing overlay and the wholesale rule (copy the
  full tree first); exit 1; **nothing on disk** — no `workspaces/missing-type/`.
- Pass: override used wholesale and announced; missing overlay refused with no
  half-built tree; plugin templates untouched. Delete the override after.

---

## B. `/fw-new-kb-domain`

**UAT-07 — from zero.** In a second throwaway repo (or after removing `workspaces/kb`):
`> /fw-new-kb-domain hpc`
- Expected: creates the `workspaces/kb/` shell (README + INDEX with an empty list) **and**
  the `hpc` domain; INDEX gains the hpc line; AI asks the one-liner (and the kb purpose,
  since it created the kb).
- Pass: works with no prior kb.

**UAT-08 — grow + duplicate.** `> /fw-new-kb-domain company` then `> /fw-new-kb-domain HPC`
- Expected: `company` added and INDEX appended in order; `HPC` refused as a
  case-insensitive duplicate of `hpc`.
- Pass: INDEX has exactly one line per domain; the refusal names the existing domain.

**UAT-09 — domain README content.** Open `workspaces/kb/hpc/README.md`.
- Pass: provenance rule (reference vs research; stale-by-release vs by-refutation),
  conflict-is-a-finding note, kb-research vs project-hub boundary, licensing note, and the
  pointer to troubleshooting cases living in `research/`.

---

## C. `/fw-contacts`

**UAT-10 — no registry.** `> /fw-contacts` before any contacts exist.
- Expected: clean error naming the fix in command syntax — `/fw-new-kb-domain company` if
  the domain is missing, otherwise `/fw-contacts <person name>` to add the first record;
  nothing generated. `> /fw-contacts Fred Flintstone` is read as "add Fred", not as
  script arguments.

**UAT-11 — generate views.** Ask the AI to add two contacts (fake people). It should copy
`templates/records/contact.md` into `workspaces/kb/company/contacts/<slug>.md` and fill
the fields **with you**: one contact assigned to `widget` and `bd-sow-001` with role text,
one assigned to `bd-sow-001` and to a bogus `ghost-ws`. Then `> /fw-contacts`
- Expected: `widget/CONTACTS.md` and `bd-sow-001/CONTACTS.md` generated with a machine
  header and one line per assignment (`[Name](../kb/company/contacts/slug.md) — role`);
  warning names `ghost-ws`.
- Pass: no contact facts (email/phone) appear in CONTACTS.md — links + context only.

**UAT-12 — refresh and stale removal.** Delete the `widget` assignment line from the
contact; `> /fw-contacts`
- Expected: `widget/CONTACTS.md` removed ("Removed stale"); `bd-sow-001` regenerated.
- Pass: only generated files (header check) are ever removed.

**UAT-13 — template contract review (human).** Read the filled contact records (they must
have been created by `fw-new-contact.sh` via `/fw-contacts <name>`, not hand-copied —
`contacts/` and its README appear on the first add).
- Also check a **name-only** record (create one and stop): heading filled from the slug,
  every other field blank, `Assigned: Unassigned` — a valid resting state, no `__` tokens,
  and `/fw-contacts` runs clean over it (no view, no warning).
- Pass: required fields present (name heading, `Affiliation: <org> (relationship)`, Role,
  one of Email/Phone, Assigned lines or `Unassigned`); no `__placeholder__` survives;
  unknown optionals are *blank*, not deleted; each `Activity:` value completes "contact
  this person for ___"; no workspace name appears in Activity. Then
  `> /fw-contacts <existing name> phone is 555-0100` → AI confirms the reading, fills the
  blank Phone in place, reruns the script; no second record created.

---

## D. Operations records — `/fw-new-ops-record`, `/fw-move`, sweep

**UAT-14 — no ops workspace.** In a repo without `workspaces/operations`:
`> /fw-new-ops-record inc test` → error pointing at `/fw-new-workspace operations`.

**UAT-15 — create, shared sequence.** With the operations workspace from UAT-03:
`> /fw-new-ops-record inc vpn-drops-nightly` then `> /fw-new-ops-record req add-user-jdoe`
- Expected: `open/INC-001-vpn-drops-nightly.md` and `open/REQ-002-add-user-jdoe.md`
  (one sequence, two prefixes); **AI asks** for title/body and deletes unused optional
  fields; `Closed:`/`Resolution:` left blank.
- Pass: ids 001 and 002; `Kind:` and `Opened:` filled by the script.

**UAT-15b — attachments.** The reporter (us — this is our own intake record, not the
client's ServiceNow/Jira) hands over a text file and a screenshot for INC-001:
`> here are the crash log and a screenshot for INC-001` with `crash.txt` and `crash.png`.
- Expected: the AI files both into the record's bundle folder `open/INC-001/` (created on
  first use, named for the bare id), adds one dated, attributed Actions line per file with
  a relative link (`[crash.png](INC-001/crash.png)`), and **reads** both — quoting the
  text and describing what the image shows — recording only what they contain. Other
  binary types (pptx, docx, xlsx) file the same way; reading them is a separate concern.
- Pass: files in `INC-001/`, links resolve from the record, no content invented; the
  bundle then travels in UAT-16/17/19/21 moves.

**UAT-16 — flow moves.** `> /fw-move INC-001 onhold` then `> /fw-move 1 open`
- Pass: both succeed; a bare numeric id works; the file is in the named folder each time.

**UAT-17 — close gate.** `> /fw-move INC-001 closed`
- Expected: **AI runs the close gate first** — asks for the closure code and a one-line
  reason, and (incident) "durable knowledge? research case / recipe / nothing durable" —
  writes the answer into Outcome, then runs the script with `--resolution <code>`.
- Pass: record in `closed/` with `**Closed:** <today>` and `**Resolution:** <code>`;
  an unknown code is refused; a missing code is refused.

**UAT-18 — terminal.** `> /fw-move INC-001 open` → refused: closed is terminal.

**UAT-19 — bundle travels.** Create `open/REQ-002/notes.txt`; `> /fw-move REQ-002 onhold`
- Pass: `onhold/REQ-002/notes.txt` exists; the script reports "bundle REQ-002/ moved".

**UAT-20 — kanban prefix.** `> /fw-move FEAT-12 doing` (the plugin command)
- Pass: refused with the pointer to the root `/fw-move` until board crossover.

**UAT-21 — sweep.** Edit `closed/INC-001-….md` so `**Closed:**` is a date last year.
`> /fw-move sweep`
- Expected: the record (and any bundle) moves to `closed/<lastyear>/`; nothing else moves.
- Then `> /fw-new-ops-record req after-sweep` → id **003** (the bucketed record still
  counts).
- Pass: bucket layout correct; sequence continues.

**UAT-22 — next-id direct.** `bash "$PLUGIN/scripts/fw-next-id.sh" operations` → `004`.

---

## E. `fw-troubleshoot` skill

**UAT-23 — natural-language routing.** Type a plain sentence, no command:
`> the license server on the build box won't start, help me figure out why`
- Expected: the skill engages on its own: captures the symptom, asks environment and
  local/remote **mode**, and **searches the kb first**, reporting hits (or "no hits")
  before proposing anything.
- Pass: skill loaded without being named; search happened before hypotheses.

**UAT-24 — explicit invocation.** `> /fw-troubleshoot FlexLM checkout fails after reboot`
- Pass: same behavior.

**UAT-25 — full loop, local mode (fake case).** Run a contrived local problem to the end
(e.g. a script that fails because a config file is missing).
- Expected, in order: external documented causes considered before hypotheses (rung 3);
  case folder created at `kb/<domain>/research/<symptom-slug>/README.md` from
  `ts-case.md`; **observation before experiment** (reads logs/config first); hypothesis
  table has a "What would falsify it" column filled; evidence files named `h<N>-…`;
  close gate writes a cookbook recipe (symptom-first title, links the case) and stamps
  Environment, Status, and **Resolved at rung**.
- Pass: all artifacts present; no invented evidence (every verdict traces to a file or a
  user-reported result).

**UAT-26 — remote mode.** Say the problem is on another machine.
- Expected: the skill writes the exact command to run and names the evidence file it
  expects; you drop a text file and a screenshot into `evidence/`; the skill reads both
  (including the image) and records only what they show; the scrub reminder appears
  before the drop.
- Pass: no verdict is asserted before the evidence lands.

---

## F. Cross-cutting

**UAT-27 — self-containment.** Everything above ran in a repo with no
`workspaces/framework/`. Pass if no command referenced a path outside the plugin or the
repo.

**UAT-28 — no hand-made structure.** `find workspaces -type d` — every directory must be
attributable to a command run above (or to a record bundle / kb content you created as
content). Pass if nothing else exists.

**UAT-29 — session-cached skill bodies.** After editing `SKILL.md` on disk, invoke the
skill again in the *same* session — expect the old body (known behavior, 2026-08-24);
restart → new body. Pass if the restart picks up the edit. (Documents the constraint;
not a defect.)

---

## Results

| Run date | Plugin version | Tester | Passed | Failed | Notes / cards filed |
|---|---|---|---|---|---|
| 2026-08-26..29 | spearit-framework-dev 0.4.0 | Gary Elliott | 30 | 1 (UAT-13) | See UAT-RESULTS-2026-08-26.md. Cards: FEAT kb depth (b) sub-topics; UX rung names/announce rung (UAT-24); BUG widget sample config + clear error (UAT-25); anchor-at-rung-2 ambiguity (UAT-23/26). UAT-29 confirms session-cached skill bodies (restart required). |
| 2026-08-30 | spearit-framework-dev 0.4.1 | Gary Elliott | 4 (UAT-10..13 re-run) | 0 | BUG-207 verified fixed: create gate `fw-new-contact.sh` seeds registry + README, blank optionals persist, update path in `/fw-contacts <name>`; error messages now in command syntax. See UAT-RESULTS-2026-08-26.md re-run section. |
| 2026-08-31 | spearit-framework-dev 0.4.2 | Gary Elliott | 1 (UAT-06 re-run) | 0 | BUG-208 verified fixed: override runs announce themselves, missing overlay refused before mkdir (nothing on disk), wholesale rule stated in the command. See UAT-RESULTS-2026-08-26.md re-run section. |

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
   `fw-new-ops-record`, `fw-move-ops`, `fw-new`, `fw-move` under the plugin namespace, and the `fw-troubleshoot`
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

**UAT-03 — operations is not a workspace (TASK-213).** `> /fw-new-workspace operations`
- Expected: refused with the pointer "operations is not a workspace — it is the root
  queue at `operations/`, created on first `/fw-new-ops-record`". Nothing created.
- Pass: the pointer names `/fw-new-ops-record`; `workspaces/operations/` does not exist.

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

**UAT-30 — auto-refresh on a Claude edit (`PostToolUse`).** With a contact assigned to a
workspace, ask the AI to change that person's assignment role (e.g. "make Wilma's widget
role QA Tester"). Do **not** run `/fw-contacts` afterwards.
- Expected: the AI edits the record, and `CONTACTS.md` shows the new role with no
  refresh step — the `PostToolUse` hook ran the generator.
- Pass: the view's mtime moves on the edit alone; the hook's generated/warning lines are
  reported. Editing an unrelated file, or `contacts/README.md`, refreshes nothing.
- Note: a newly installed or changed hook needs `/reload-plugins` or a restart first —
  a running session does not pick it up (same constraint as UAT-29).

**UAT-31 — outside-Claude edit is *not* caught mid-session.** Edit a contact record in
another editor (notepad), changing an assignment role. Do not touch Claude.
- Expected: `CONTACTS.md` does **not** change. The harness cannot observe writes made
  outside Claude Code, so no `PostToolUse` hook can fire — this is the documented limit,
  not a defect.
- Pass: the stale view is then resolved by any of: `/fw-contacts refresh` (UAT-32), the
  next session start (`SessionStart` hook), or `git commit`, which `tools/pre-commit`
  blocks with a diff and exit 1 until the views are regenerated and staged.

**UAT-32 — `/fw-contacts refresh`.** After UAT-31's stale state, `> /fw-contacts refresh`
- Expected: views regenerated; same output as the bare argument-less form, which still
  works.
- Pass: `refresh` is read as the keyword, not as a person named Refresh; a contact
  actually named Refresh is still reachable by slug (`/fw-contacts refresh-smith`).

---

## D. Operations records — `/fw-new-ops-record`, `/fw-move-ops`, sweep

**UAT-14 — first use creates the queue (TASK-213).** In a repo without a root
`operations/`: `> /fw-new-ops-record inc test`
- Expected: the script creates `operations/` = `open onhold closed meetings agreements
  reference` + README from `templates/queues/operations/`, prints "Created operations
  queue at operations/ (first use)", then creates the record.
- Pass: exact six folders at the repo root (not under `workspaces/`); record in `open/`.

**UAT-15 — create, shared sequence.** With the operations queue from UAT-14:
`> /fw-new-ops-record inc vpn-drops-nightly` then `> /fw-new-ops-record req add-user-jdoe`
- Expected: `open/INC-…` and `open/REQ-…` continue one sequence, two prefixes; **AI
  asks** for title/body and deletes unused optional fields; `Closed:`/`Resolution:`
  left blank.
- Pass: consecutive ids; `Kind:` and `Opened:` filled by the script.

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

**UAT-16 — flow moves.** `> /fw-move-ops INC-001 onhold` then `> /fw-move-ops 1 open`
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

**UAT-20 — the namespace is the command, never the prefix.** `> /fw-move-ops FEAT-901 doing`
- **Rewritten 2026-09-24** (FEAT-229). It previously expected a refusal because kanban was
  *not wired*; kanban now moves (section G), so what this case guards is BUG-215's rule:
  `/fw-move-ops` always means operations, whatever the id looks like.
- Expected: `❌ invalid target 'doing' — operations folders: open onhold closed`, exit 1.
  The `FEAT-` prefix is not read as a request for the board.
- Pass: refused on the target; nothing moves in `kanban/` or `operations/`.

**UAT-21 — sweep.** Edit `closed/INC-001-….md` so `**Closed:**` is a date last year.
`> /fw-move sweep`
- Expected: the record (and any bundle) moves to `closed/<lastyear>/`; nothing else moves.
- Then `> /fw-new-ops-record req after-sweep` → id **003** (the bucketed record still
  counts).
- Pass: bucket layout correct; sequence continues.

**UAT-22 — next-id direct.** `bash "$PLUGIN/scripts/fw-next-id.sh" operations` → `004`.

---

## D2. Batch moves and namespace parity (BUG-215)

**Fixtures required.** These four run against the reserved 900 block, seeded by
`bash workspaces/framework/tests/seed-uat-fixtures.sh --root <this repo> operations`
(the script is authored in the framework repo and points here via `--root`; it is never
copied in). Start state: `open/` INC-901, INC-902 (+bundle `INC-902/`), REQ-903, INC-904,
INC-9010 · `onhold/` REQ-905 · `closed/` INC-906, INC-907 (+bundle, `Closed:` last year).
Live records 1–6 are untouched by the fixtures and by these tests. Re-seed between runs
with `--reset` then seed again.

**UAT-33 — batch move, quoted commas.** `> /fw-move-ops "901, 902, 903" onhold`
- Expected: all three move in one invocation; bundle `INC-902/` travels with its record;
  a summary line `📊 moved: 3  skipped: 0  failed: 0`. Report shape (BUG-225):

  ```
  Move → onhold/
    OK       INC-901-batch-item-one.md
    OK       INC-902-batch-item-two.md  (bundle INC-902/)
    OK       REQ-903-batch-item-three.md
  📊 moved: 3  skipped: 0  failed: 0
  ```
- Pass: three records in `onhold/`, `onhold/INC-902/evidence.txt` present, summary shown.
  **The bundle note is on INC-902's own row** — it must not appear under INC-901.
- Note: INC-9010 must **not** move — the substring trap. `901` matches INC-901 only.

**UAT-34 — `--resolution` on a list.** `> /fw-move-ops "901, 902" closed --resolution resolved`
- **Rewritten 2026-09-11** (BUG-215 supersession). It previously expected a *refusal*;
  `--resolution` now applies to the whole batch, because a batch close happens precisely
  when the records share a root cause.
- Expected: both records close, each stamped `**Closed:** <today>` and the **same**
  `**Resolution:** resolved`.
- Pass: both in `closed/`, both stamped, summary `moved: 2`.
- Note: the AI still runs the close gate per record for the *reason* and the
  durable-knowledge answer — one shared code, but each record's Outcome written on its own.

**UAT-35 — partial failure continues.** With 901 and 903 in `onhold/` and no record 999:
`> /fw-move-ops 901 999 903 open` (unquoted list)
- Expected: 901 and 903 move; 999 reported as not found; `📊 moved: 2 … failed: 1`:

  ```
  Move → open/
    OK       INC-901-batch-item-one.md
    FAILED   999 — no operations record with that id
    OK       REQ-903-batch-item-three.md
  📊 moved: 2  skipped: 0  failed: 1
  ```
- Pass: the bad id in the middle did not stop 903 from moving; both good records in `open/`.
  **The failure reason is on the failing row**, in order, not on a detached stderr line.

**UAT-36 — close with no resolution is refused, per record.** `> /fw-move-ops "901, 903" closed`
- **Rewritten 2026-09-11** (BUG-215 supersession). It previously tested per-record
  *prompting*; the engine no longer prompts at all. Operations now behaves like kanban —
  a move missing its required input is refused and the user runs again.
- Expected: **the script refuses each record**, naming what is missing and enumerating the
  five valid codes. **Nothing moves.** No prompt appears, and the behaviour is identical
  whether or not a terminal is attached (pipe the command to confirm):

  ```
  Move → closed/
    FAILED   INC-901-batch-item-one.md — → closed requires a resolution: pass --resolution <resolved|cancelled|duplicate|no-fault-found|rejected>
    FAILED   REQ-903-batch-item-three.md — → closed requires a resolution: pass --resolution <resolved|cancelled|duplicate|no-fault-found|rejected>
  📊 moved: 0  skipped: 0  failed: 2
  ```
- Pass: exit 1, both records still in their source folder, rows name the codes, and the
  piped run is **byte-identical** to the interactive one.
- Related: an *unknown* code is a usage error about the invocation, not a per-record
  outcome, so it is refused once on stderr before any record is touched:
  `❌ unknown resolution 'bogus' (codes: …)`, exit 1.
- Note: the **AI-side close gate is unchanged** — it still asks for the code, a one-line
  reason per record, and the incident durable-knowledge question, then calls the script
  with `--resolution`. What was removed is the *script* prompting, not the judgment step.

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

## G. The kanban board (FEAT-229)

**What this proves.** The board creates, moves, gates and archives from the **installed**
plugin, in a repo where `workspaces/framework/` does not exist. It runs in two layers:
**UAT-37..51 call the engine directly** — the rules are facts, and testing the `.sh`
isolates them from the AI — then **UAT-52..57 run the same board through `/fw-move`**, the
command a user actually types, for the judgment the engine cannot do.

**`$K` is a shell variable, not a slash command.** Open a **Git Bash** terminal in
`framework-uat` and set it once — it points at the installed plugin's move engine, with
the `kanban` namespace already supplied:

```bash
K='bash ../claude-local-marketplace/framework/scripts/fw-move.sh kanban'
$K FEAT-901 todo     # = bash …/fw-move.sh kanban FEAT-901 todo
```

In UAT-37..51, every `$K …` is typed in that terminal; only the `>` lines (UAT-37,
UAT-49) are typed to Claude. G2 is all `>`. A terminal is used rather than `!` in the Claude prompt so the variable
reliably persists from one case to the next.

**Fixtures.** Reserved 900 block, seeded **after** UAT-37 creates the board:
`bash ../project-framework/workspaces/framework/tests/seed-uat-fixtures.sh --root . kanban`.
Start state — `backlog/` FEAT-901, BUG-902 (+bundle), TECH-903, FEAT-9010 · `todo/`
FEAT-904, TASK-905, the FEAT-912 family (.1 has a bundle, .2 `Depends On: FEAT-906`),
TASK-915 (`Depends On: FEAT-999`, not on the board), SPIKE-914 (POC, +bundle) · `doing/`
one card per checkbox state — FEAT-906 `[x]`, BUG-907 `[/]`, TECH-908 `[-]`, TASK-909 `[?]`,
SPIKE-910 `[h]`, FEAT-911 (a marker quoted in prose), plus SPIKE-913 (research). Run in
order; each case starts from the state the last one left. Re-run with `--reset`, then seed.
`doing/` starts over its limit of 2 **on purpose** — every move into it should warn.

**UAT-37 — the board is created on first use.** In a repo with no `kanban/`:
`> /fw-new add CSV export to the report page`
- Expected: **AI proposes** `FEAT` and says why; on yes, the script prints
  `Created kanban queue at kanban/ (first use)` and creates `kanban/backlog/FEAT-001-….md`.
- Pass: `kanban/` = `accept backlog blocked cancelled doing done hold release todo` +
  `README.md`; `todo/.limit` = 10, `doing/.limit` = 2; the card is in `backlog/` and
  nowhere else. Then seed the fixtures.

**UAT-38 — the transitions are an allowlist.** `$K FEAT-901 done`, then `$K 901 doing`,
then `$K 901 accept`
- Expected: each refused on its row — `invalid transition backlog → done (allowed: …)`,
  likewise `→ doing` and `→ accept`; exit 1. A card goes backlog → todo → doing →
  accept → done, and skips nothing.
- Pass: FEAT-901 still in `backlog/`. (`$K 901 doing` also prints the WIP warning first;
  the warning never decides anything — see UAT-41.)

**UAT-39 — batch move (mirrors UAT-33).** `$K "901, 902, 903" todo`

  ```
  Move → todo/
    OK       FEAT-901-batch-item-one.md
    OK       BUG-902-batch-item-two.md  (bundle BUG-902/)
    OK       TECH-903-batch-item-three.md
  📊 moved: 3  skipped: 0  failed: 0
  ```
- Pass: three cards and `todo/BUG-902/evidence.txt` in `todo/`; **FEAT-9010 has not
  moved** (the substring trap — `901` matches FEAT-901 only).

**UAT-40 — partial failure and skip (mirrors UAT-35).** `$K 901 999 903 backlog`
- Expected: `OK` FEAT-901, `FAILED 999 — no kanban record with that id`, `OK` TECH-903,
  `📊 moved: 2  skipped: 0  failed: 1`, exit 1. Then `$K "904, 905" todo` → both
  `SKIPPED … already in todo/`, `moved: 0  skipped: 2  failed: 0`, exit 0.
- Pass: the bad id in the middle did not stop 903; a no-op is a skip, not a failure.

**UAT-41 — WIP warns, never blocks.** `$K 904 doing`
- Expected: `⚠️  WIP limit: 7/2 items already in doing/` **and** `OK FEAT-904-… → doing/`.
- Pass: the card moved despite the warning; the count is 7 cards, not 8 (the `.gitkeep`
  and `.limit` files are not counted — BUG-174).

**UAT-42 — `[?]` and `[h]` block `→ doing`, naming the line.** `$K "909, 910" todo`
(both move — and **SPIKE-910 stays on the board**: only a *terminal* move archives a
spike), then `$K "909, 910" doing`

  ```
  ⚠️  WIP limit: 6/2 items already in doing/
  Move → doing/
    FAILED   TASK-909-question-marker.md — - [?] Needs information — must BLOCK the move to doing
             **Question:** what the run needs to know before it can proceed.
    FAILED   SPIKE-910-hold-marker.md — - [h] Blocked — must BLOCK the move to doing
             **Hold:** what prevents completion of this one line.
  📊 moved: 0  skipped: 0  failed: 2
  ```
- Pass: both in `todo/`; each refusal quotes the marked line **and** its note.

**UAT-43 — the dependency gate, and the family union rule.** `$K 915 doing`, then `$K 912 doing`
- Expected: TASK-915 refused — `depends on FEAT-999, which is not on this board`. The
  FEAT-912 family is refused **as a family**, the reason on the member that carries it:

  ```
    FAILED   FEAT-912.2-family-child-with-dep.md — depends on FEAT-906 (currently in doing/), which must reach done/ first
    FAILED   FEAT-912 family — not moved: tightly-coupled members move together or not at all
  ```
- Pass: FEAT-912, .1, .2 and the `FEAT-912.1/` bundle **all** still in `todo/` — no
  partial family move. The refusal names where the dependency is, not just "not done".

**UAT-44 — the done gate: the checkbox contract (TECH-177).** This is the Human half of
FEAT-229/.2's validation. `$K "906, 907, 908, 911" accept` (all four move — no gate on
`→ accept`), then `$K "906, 907, 908, 911" done`

  ```
  Move → done/
    OK       FEAT-906-all-criteria-done.md
    FAILED   BUG-907-in-progress-criterion.md — 0 unchecked, 1 in progress: both block → done/ (mark [x] when done, [-] if cancelled)
    OK       TECH-908-cancelled-criterion.md
    OK       FEAT-911-quoted-marker-in-prose.md
  📊 moved: 3  skipped: 0  failed: 1
  ```
- Pass: **`[/]` blocks; `[-]` passes by design**; FEAT-911 passes — a marker quoted in
  prose is not a criterion (TECH-166 item 4). Each card in `done/` has
  **`**Completed:** <today>`** stamped (the template and `/fw-new` both promise it).

**UAT-45 — `accept/` has exactly two exits.** BUG-907 is in `accept/`.
`$K 907 todo`, `$K 907 hold`, `$K 907 cancelled` → each `invalid transition accept → …`.
`$K 907 doing` → moves. Then `$K 907 done` → `invalid transition doing → done`.
- Pass: code that has merged cannot be parked, requeued or cancelled — only refined
  (`→ doing`) or accepted (`→ done`); and `accept/` is the **only** route to `done/`.

**UAT-46 — terminal states.** `$K 906 doing`, then `$K 906 cancelled`
- Expected: both `in done/, which is terminal; open a new record instead`.
- Pass: FEAT-906 still in `done/`. Completed work is never cancelled.

**UAT-47 — `hold/`, `blocked/`, `cancelled/`.** On FEAT-901 (in `backlog/`), in order:
`hold` ✅ · `blocked` ❌ (`hold → blocked`) · `todo` ✅ · `blocked` ✅ · `hold` ❌
(`blocked → hold`) · `cancelled` ❌ (`blocked → cancelled`) · `backlog` ✅ ·
`cancelled` ✅ · `todo` ❌ (`in cancelled/, which is terminal`)
- Pass: every ✅ moves and every ❌ is refused as shown. A changed *cause* goes via a
  real state; parked folders are not a shuffling ground.

**UAT-48 — the family moves together, named by any member.** FEAT-906 is now `done/`,
so FEAT-912.2's dependency is met. `$K 912.1 doing` — naming a **child**:

  ```
    OK         ↳ FEAT-912-family-parent.md
    OK         ↳ FEAT-912.2-family-child-with-dep.md
    OK       FEAT-912.1-family-child-one.md → doing/  (bundle FEAT-912.1/)
  ```
- Pass: all three plus `doing/FEAT-912.1/notes.txt` in `doing/` (the child's bundle is its
  own, not the parent's — BUG-241). Then `$K 905 doing`: the WIP line counts the FEAT-912
  family as **one** item (BUG-240) — check it against the distinct base ids in `doing/`.

**UAT-49 — dotted create, and the depth cap.**
`> add a sub-task under FEAT-912.1: write the migration note`
- Expected: **AI picks the dotted mechanism** (the child is meaningless alone) and creates
  `FEAT-912.1.1-…` in **`doing/`** — a dotted child is born in its parent's folder, not
  `backlog/`. Then `> add a sub-task under FEAT-912.1.1` → refused: `max dotted-id depth
  is 3 … the parent is too big`, reported verbatim, nothing created.
- Pass: depth 3 exists; depth 4 does not; the AI does not work around the refusal.

**UAT-50 — spikes leave the board, only on a terminal move.** `$K 913 accept` (moves,
**stays on the board**), `$K 913 done`, then `$K 914 cancelled`
- Expected: SPIKE-913 → `↳ archived to history/spikes/ (research spike)`; SPIKE-914 →
  `↳ archived to history/spikes/SPIKE-914/ (POC spike — record + code)`.
- Pass: `history/spikes/SPIKE-913-research-spike.md` (a file);
  `history/spikes/SPIKE-914/` holds the record **and** `poc.sh` (a folder); neither is left
  in `kanban/done/` or `kanban/cancelled/`; **no `history/releases/`** exists — a spike
  produces knowledge, not a release.

**UAT-51 — reset, and operations unaffected.** `…/seed-uat-fixtures.sh --root . kanban --reset`
- Pass: no `*-9xx*` path remains in `kanban/` or `history/spikes/` — including the
  FEAT-912.1.1 card UAT-49 created — and FEAT-001 from UAT-37 is untouched. Then re-run
  **D2 (UAT-33..36)**: the engine the board now shares must behave for operations exactly
  as before.

### G2. Through the command — `/fw-move`

Re-seed first (`--reset`, then seed). These are typed to **Claude**, not the terminal:
what is under test is the command's judgment layer — the engine's rules were proven above.

**UAT-52 — a refusal is reported, not worked around.** `> /fw-move FEAT-901 done`
- Expected: the AI runs the engine, quotes the `invalid transition backlog → done` row
  **verbatim**, and names the legal path (`backlog → todo → doing → accept → done`) as an
  offer, not an action.
- Pass: FEAT-901 still in `backlog/`; no `git mv` by hand; nothing else moved.

**UAT-53 — the pre-implementation review on `→ doing`.** `> /fw-move 904 doing`
- Expected: the move succeeds (the WIP warning is reported, not treated as a refusal);
  then the AI reads FEAT-904 in full and presents what is being built, the decisions,
  open questions and scope — and **stops**. A fixture card has almost no plan, so the
  honest review says so and offers `/fw-move 904 todo`.
- Pass: the AI waits for a go-ahead and implements nothing; the review is a judgment,
  never a script check (ADR-007 D7).

**UAT-54 — a gate is never cheated.** `> /fw-move 907 accept`, then `> /fw-move 907 done`
- Expected: `→ accept` moves and the AI says what there is to accept (the criteria).
  `→ done` is refused — `0 unchecked, 1 in progress` — and the AI **offers** to walk the
  open criterion with you.
- Pass: the AI does not tick `[/]` to `[x]` (or `[-]`) on its own to get the move through;
  BUG-907 stays in `accept/`.

**UAT-55 — cancelling records why.** `> /fw-move TECH-903 cancelled`
- Expected: **AI asks why** before moving, writes `**Cancellation Reason:** <your answer>`
  into the card header, runs the move, and offers to commit (`chore: Cancel TECH-903 - …`).
- Pass: TECH-903 in `cancelled/` with the reason; no closure code is asked for (TASK-242 D4).

**UAT-56 — naming a child moves the family, without asking.** `> /fw-move FEAT-912.2 hold`
- Expected: the AI confirms `hold` is a *prioritization decision* (not an external
  blocker), then runs the move; FEAT-912, .1 (with its bundle) and .2 all land in `hold/`.
- Pass: the AI does **not** ask whether to move the siblings — a dotted family is one item.

**UAT-57 — a repo whose board is elsewhere is untouched.** In the **framework repo**, where
the live board is `project-hub/work/` and there is no `kanban/`:
`> /spearit-framework-dev:fw-move FEAT-229 accept`
- Expected: `❌ no kanban queue at kanban/ — create the first record with /fw-new`, exit 1.
- Pass: nothing in `project-hub/work/` moves; the root `/fw-move` is unaffected. The two
  commands live in different namespaces and cannot reach each other's board.

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
| 2026-08-31 | spearit-framework-dev 0.4.3 → 0.4.4 | Gary Elliott | ad-hoc (not numbered) | 0 | `/fw-contacts` add + update path exercised; BUG-212 verified fixed (create gate emits blank fields, no `__TOKEN__`). Built the auto-refresh guardrail shipping in 0.4.4: `PostToolUse` hook for edits inside Claude Code, `fw-contacts.sh --check` + `tools/pre-commit` + `tools/install-git-hooks.sh` for edits outside it (both verified end-to-end; stale commit blocked). Findings: FEAT-211(a) reproduced live from the ordinary update path; UX — a no-change refresh is indistinguishable from a failed one, suggest "N view(s) unchanged". Open: CI not wired; hook needs a numbered re-test after restart. See UAT-RESULTS-2026-08-26.md. |
| 2026-09-01 | spearit-framework-dev 0.4.4 → 0.4.5 | Gary Elliott | 1 (UAT-13 re-run) | 0 | BUG-212 verified fixed on the installed plugin: name-only record valid (display name from slug, blank fields, `Assigned: Unassigned`, no `__` tokens). Cleared two stale `installed_plugins.json` entries pointing at a non-existent cache dir (directory sources resolve in place; not a defect). Finding folded into BUG-212: outside-Claude edits leave CONTACTS.md stale — `PostToolUse` verified firing for Claude's own edits, but cannot see other editors; fixed in 0.4.5 with a `SessionStart` refresh (`--all`). `FileChanged` rejected (literal-filename matcher). Correction: `fw-contacts.sh` was briefly mis-diagnosed as case-buggy — it is not; latent case risk noted for FEAT-211. Open: live SessionStart firing needs a restart to observe. See UAT-RESULTS-2026-08-26.md. |
| 2026-09-01 | spearit-framework-dev 0.4.5 → 0.4.6 | Gary Elliott | 3 (UAT-30..32, back-recorded) | 0 | Refresh paths recorded as numbered tests after the fact: UAT-30 `PostToolUse` refreshes on a Claude edit (observed); UAT-31 an outside-Claude edit is not caught mid-session and must not be — harness limit, with `--check`/pre-commit as the backstop (observed twice); UAT-32 `/fw-contacts refresh` (observed, 0.4.6). `SessionStart` refresh confirmed live by the operator. Real-time watcher declined by decision (contacts change rarely mid-project); `FileChanged` rejected on mechanism. See UAT-RESULTS-2026-08-26.md. |

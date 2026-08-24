# Session History: 2026-08-24

**Date:** 2026-08-24
**Participants:** Gary Elliott, Claude Code
**Session Focus:** workspaces/ in general — kb branch (FEAT-192/194/201); FEAT-164 closed

---

## Summary

Day's focus set: finish the kb branch (FEAT-192 `/fw-new-domain`, FEAT-194 `company`
domain, FEAT-201 `research/` folder). FEAT-201 (filed 2026-08-22 from the HPC repo —
first field use of the kb scaffold) reviewed and its cross-refs fixed. FEAT-164
closed: its criteria were satisfied by the TASK-197/interface work of 2026-08-20,
re-verified under the current enum and annotated rather than rewritten.

---

## Work Completed

### FEAT-201: intake review and fixes

- Reviewed the card from the HPC repo: reference-vs-research provenance split
  (theirs/ours; stale-by-release vs stale-by-refutation). Assessment: sound, and the
  dogfood loop working — field use surfaced the gap within days of the scaffold
  landing.
- Fixed cross-refs: `/fw-new-domain` is FEAT-192 (not 194); Related section
  disentangled; direction sharpened — the definitions home is a seeded
  `_domain_/README.md`, which does not exist yet and this card creates (192/194
  want the same home).

### FEAT-164: closed (doing → done)

- Criteria mapped against what landed 2026-08-20 under TASK-197: all four types
  generate from the published plugin (live command run created `app2`); the
  document-only floor test holds under the dissolved-sow vocabulary (`project` =
  floor + requirements, no source tree); README name/type seeded via `__NAME__`
  substitution, purpose step exercised live.
- Original 2026-08-18 criterion annotations preserved; 2026-08-24 resolution notes
  appended (append-don't-rewrite). Closing note added marking the Scope sketch as
  journey record, superseded by TASK-197's enum and the template-tree D3 amendment.
- All five test fixtures' READMEs given an explicit test-fixture purpose line
  (was `_PURPOSE_PENDING_` — the 2026-08-20 loose end).

---

## Current State

### In done/ (10 — release-nudge threshold reached)
- FEAT-164 newly complete; TASK-197 and 8 others awaiting release

### In doing/
- (empty — kb branch cards move next)

### Next
- FEAT-192 + FEAT-201 → doing together (one script/template window: shared
  domain-scaffold path + research/ + domain README), then FEAT-194.

---

## FEAT-192 + FEAT-201 Implemented and Closed (Continued)

**Journey notes (the interface evolved twice during review):**

1. Pre-implementation review proposed `/fw-new-domain <domain>` requiring an
   existing kb, with three judgment calls (drop the `<kb>` arg — kb is a fixed
   singleton since 2026-08-20; regenerate the kb fixture; add an INDEX
   description prompt).
2. Gary pushed further: the command should **create the base kb on first use** —
   making it self-sufficient from zero and `/fw-new-workspace kb` fully
   redundant. Sample output reviewed before build.
3. Naming: `fw-new-domain` "silently implies a kb workspace but a new user might
   not get that" (Gary) → renamed **`/fw-new-kb-domain`** — the target lives in
   the name (mechanism), not in help text (prose).

**Landed:**

- `scripts/fw-new-kb-domain.sh` — THE home for kb-domain logic: creates the kb
  shell (README + INDEX, empty domain list) on first use; composes the domain
  from the template `_domain_/`; appends the INDEX line; case-insensitive
  duplicate guard; tampered-kb (no INDEX.md) errors. `fw-new-workspace.sh`'s kb
  path now `exec`-delegates here (dead kb compose branch removed) — either
  door, one path; an existing kb + new domain grows instead of erroring (the
  exact 2026-08-18 failure that filed FEAT-192).
- FEAT-201's shape: `_domain_/research/` + authored `_domain_/README.md`
  (provenance rule: reference = theirs / research = ours; stale-by-release vs
  stale-by-refutation; conflict-is-a-finding; kb-research vs project-hub
  boundary; licensing note). Copied per domain — derived copies of one
  authored template.
- New command doc `fw-new-kb-domain.md` (INDEX-description judgment step,
  mirroring the purpose step); `fw-new-workspace.md` kb section updated.
- `workspaces/framework/CHANGELOG.md` created (FEAT-192's doc checklist wanted
  an entry; the file didn't exist) — starts at [Unreleased] with this window's
  changes back through TASK-197.
- Verified: scratch-root create/grow/dupe/delegation tests; kb fixture
  regenerated **from the published marketplace copy** (old fixture parked in
  scratchpad — `rm -rf` denied by sandbox, `mv` used instead).
- Both cards annotated (interface deviations recorded on FEAT-192) and moved
  to done/.

### Current State (after kb branch)

- **done/ (12):** FEAT-164, FEAT-192, FEAT-201 today; release overdue-ish —
  threshold nudge stands
- **doing/:** empty
- **Next per plan:** FEAT-194 (kb `company` domain — content shape + the
  contacts/floor decision), the last kb-branch card

---

## FEAT-194 Implemented and Closed — kb Branch Complete (Continued)

**Design conversation (the contact model evolved in three steps):**

1. Review proposed: floor drops `contacts/`; one list file with activity
   designations.
2. Gary's requirement broke the list file: each product/project needs its own
   *narrow* slice (customer people + external vendors), so links need stable
   targets → **per-contact records** (`kb/company/contacts/<slug>.md`), with
   workspace lists as links + role-in-this-work context.
3. Gary pushed one step further: make the workspace list a **generated view** —
   the contact record carries repeatable `Assigned: <workspace> — <role>`
   declarations; `fw-contacts.sh` builds/refreshes every `CONTACTS.md`.
   Accepted as the board's own grammar (`Workspace:` field → derived slices)
   applied to people: a generated view cannot drift.

**Path-layering clarification (worth keeping for onboarding):** the template
home confused even us for a beat. Three layers: authored source
`workspaces/framework/templates/…` (THIS repo only — the framework workspace is
the one non-generated workspace; it IS the plugin source, ADR-009);
runtime `${CLAUDE_PLUGIN_ROOT}/templates/…` (any consuming repo, from the
installed plugin — no `workspaces/framework/` exists there); optional per-repo
override `.claude/templates/…` (mirrors the plugin's templates subtree shape).
Affiliation (customer/vendor/spearit) is a *field*, so vendor contacts share
the registry despite the domain's name.

**Landed:** floor template loses `contacts/` (floor = meetings, reference,
deliverables, agreements); `templates/records/contact.md` (new records/ area —
FEAT-195's INC/REQ templates will join it); `scripts/fw-contacts.sh`
(generate + stale-removal + missing-workspace warning, machine-written header);
`commands/fw-contacts.md`; CHANGELOG entry. Fixtures regenerated without
`contacts/`; company domain created in the kb fixture via
`fw-new-kb-domain company` with a fake sample contact; full cycle verified from
the published marketplace copy (generate → reassign → stale view removed).
All three FEAT-194 open questions and all criteria resolved/checked; card
annotated and moved to done/.

### Current State (kb branch closed)

- **done/ (13):** FEAT-164, 192, 194, 201 today — release strongly recommended
- **doing/:** empty
- **kb branch: complete.** Remaining workspaces/ cards: FEAT-193 (ops trim),
  FEAT-191 (guided intake), FEAT-195/196/198/199/200 (records, reporting,
  roadmaps, deadlines, calendar)

---

## Contact Template Hardening (Continued — Gary's Field Review)

Gary read the shipped template and fixture line by line; three real gaps
surfaced and were fixed (first two committed as `77c811e`, rest in this
commit):

1. **Multiple assignments were invisible.** The repeat-one-Assigned-line-per-
   workspace rule lived only in the HTML comment, and the Jane Doe fixture
   showed a single line (its second had been deleted during the stale-removal
   test). Fixed: a second visible `Assigned:` placeholder carries the
   instruction; fixture restored to two assignments; parser hardened to skip
   any `__placeholder` Assigned line (verified against a raw template copy).
2. **Activity/Assigned double-home.** The fixture had `sow-001` in both fields
   — two homes for one fact. Then the first fix ("tags not tied to a
   workspace") left Activity "very open to interpretation" (Gary). Final form
   is a **contract, not examples**: each Activity value must complete
   *"contact this person for ___"* at engagement level — a workspace-shaped
   answer belongs in Assigned, an identity-shaped one in Role; delete the
   field if nothing fits. (Deletion of the whole field was considered — nothing
   mechanized consumes it — kept because "who do I call about billing" is a
   real routing query and grep is the consumer.)
3. **Required vs optional + keying.** Required: the `#` name heading (display,
   used by generated views), Affiliation (the registry mixes customer/vendor/
   SpearIT), Role, one of Email/Phone. Optional fields are *deleted* when
   empty, never left as placeholders. **The file slug is the record's key**
   (links and fw-contacts bind to it); the heading is display only. Name
   collisions are loud (filesystem refuses the slug) — convention: distinguish
   new slug by org then title (`jane-doe-acme.md`), disambiguate the display
   (`# Jane Doe (Acme)`), and check Affiliation/Role before assuming an
   existing record is your person.

### Current State

- **done/ (13)** — release strongly recommended, next order of business
- **doing/:** empty; FEAT-193 (ops trim) queued after the release decision

---

## FEAT-202: Troubleshooting Case Pattern — the Actual Last kb Card (Continued)

**Origin:** pre-release discussion. Gary brought the Toyota-project format
(`kb/<domain>/TS-nnn-<slug>/` with `evidence/`, `scripts/`, journey README) and
asked what to add or change; then named the two primary goals — a systematic
AI-assisted methodology with capture, and easy retrieval of already-solved
problems ("final doc = a KB article?").

**Design (discussed, then filed as FEAT-202 and implemented same-day):**

- **The split:** investigation is flow (ops `INC-` anchor + working-material
  bundle — FEAT-195 to define the bundle); the case is knowledge at
  `kb/<domain>/research/<symptom-slug>/` — no `TS-` tree, no new domain
  folder: a troubleshooting case is the purest instance of FEAT-201's
  research/ definition. Toyota's shape survives inside the case folder.
- **The final doc is a kb article in two grades:** cookbook recipe = the
  findable solution card (symptom-first title, links its case as proof);
  research case = the evidence behind it; no repeatable fix → the case alone
  is the article.
- **Four additions:** distillation gate at close (the piece TS formats
  usually lack); environment/version stamp (makes stale-by-refutation
  checkable); symptom-first titling + FEAT-195 cross-ref + contact links;
  hygiene (evidence scrubbed before kb entry, raw logs git-ignored with
  pointers; script promotion test — run-again scripts are product material).

**Landed:** `skills/fw-troubleshoot/SKILL.md` — **the plugin's first skill**
(search-solved-first, hypothesis–evidence loop with capture-during, close
gate, never-invent-evidence rule); `templates/records/ts-case.md` (case-folder
README skeleton, required: symptom/Status/Environment); domain README
research/ bullet now points at both; CHANGELOG entry; FEAT-195 annotated
(artifact bundle + gate mechanism are its to build). Verified: both files
serve from the published marketplace copy; sample case created in the fixture
kb from the published template. Skill registration awaits next restart.
All four OQs resolved on the card; moved to done/.

### Current State — kb activity fully closed

- **done/ (14):** FEAT-164, 192, 194, 201, 202 today
- **doing/:** empty
- **Pending decision:** the 0.4.0-dev milestone sweep (board release, not a
  product release — the product story stays graduation per ADR-009)

---

## Skill Invocation + Restart Plan (Session Close)

Gary asked what invokes fw-troubleshoot. Answer recorded for the record: the
frontmatter `description:` is the routing surface — descriptions are the only
part of a skill loaded into every session (progressive disclosure); a matching
conversation loads the body. Ours is written as trigger conditions ("use when
the user reports a technical problem to investigate… or asks 'have we seen
this before'"), so natural language fires it; `/fw-troubleshoot` works
explicitly. Model-invocation is probabilistic — description quality determines
reliability, and sharpening the description is the tuning loop.

**Next session opens with the routing test:** after restart (registers
fw-troubleshoot, /fw-new-kb-domain, /fw-contacts), describe a realistic
symptom ("FlexLM is doing X, help me figure out why") WITHOUT naming the
skill, and see whether the description routes to it. Then: the 0.4.0-dev
milestone sweep decision (done/ at 14), and FEAT-193 (ops trim) as the next
build card.

---

## After Restart: Routing Test Passed, Method Sharpened (Later Session)

**Routing test — two runs:**
1. `/fw-troubleshoot "FlexLM is not starting…"` — explicit invocation worked;
   the search-first step immediately forced disclosure that the only kb hit
   was today's fixture sample, not real knowledge (the step doing its job).
2. Plain sentence, no command — *"I'm having a problem the widget license
   server. It won't start."* — **the description routed to the skill
   unprompted.** Natural-language invocation confirmed. Observation: the skill
   *body* loaded was the pre-edit version (bodies appear session-cached; the
   description routes fresh) — body edits take effect at next restart.
   `/plugin marketplace update` is not available in this environment; the
   restart alone registered the new skills.

**Gary's two methodology corrections (both landed in SKILL.md):**
- **Remote mode is the norm.** Most cases are on machines the AI can't reach:
  the AI writes exact commands and names the evidence file it expects; the
  user drops stdout/screenshots/config into `evidence/`; the AI reads them
  (screenshots included) and never infers a verdict from unseen output.
  Evidence naming `h<N>-<what>.<ext>` keyed to the hypothesis row.
- **Delay trial-and-error as long as possible.** The loop became a **ladder**:
  1 capture (+ mode) → 2 own kb (cookbook/research/*reference*) → 3 external
  documented causes (vendor docs/KB, exact-error search, release notes for the
  stamped versions; finds saved to `reference/` under its licensing rule;
  output = ranked *documented* causes) → 4 anchor → 5 open case seeded from
  rung 3 → 6 **observe before experimenting** (read every existing log/
  status/config, change nothing — most "won't start" cases end here) → 7
  discriminating tests, read-only before invasive, one change at a time,
  revert if unconfirmed → 8 hygiene → 9 close gate. Anti-skip rule: proposing
  a change with rungs 2–6 absent from the case file means go back.

**"What else sharpens this?" — four recommendations, all actioned:**
1. **Domain playbooks** ("first five minutes" cookbook entries the skill reads
   at rung 6) → **FEAT-203** (with environment baselines folded in).
2. **Collector scripts as products** (one-run, pre-scrubbed evidence bundles;
   baseline mode on a healthy system) → **FEAT-204**.
3. **`Resolved at rung:` field** on the case template + close-gate step — the
   method's self-check (rung-7 clustering in a domain = its playbook/reference
   is missing something). Landed now.
4. **Dogfood three real cases, then retro** — the actual sharpening plan →
   **TASK-205** (High).
Also landed: a **"What would falsify it"** column in the hypothesis table and
the matching rule at rung 7 — a hypothesis you can't name a falsifier for
isn't testable yet.

### Current State

- **done/ (14)**, **doing/ empty**; backlog +3 (FEAT-203/204, TASK-205)
- Uncommitted: SKILL.md ladder rewrite, ts-case.md fields, three new cards,
  this history section
- Pending: 0.4.0-dev sweep decision; FEAT-193 next build card

---

## Release: framework-dev v0.4.0 (Session Close)

**Decision (Gary):** release now, plain semver — "we dropped the -dev
nomenclature": version `0.4.0`, not `0.4.0-dev`. Earlier framing stands: a
*board* release, not a product release — the product story remains graduation
(ADR-009); this checkpoints the record while the work is fresh.

**Found on inspection — done/ held two products' work:**
- 7 new-build items (`Workspace: framework`): FEAT-164, 190, 192, 194, 201,
  202, TASK-197 → released as **framework-dev v0.4.0**.
- 6 old-framework items with no workspace field, completed July after v5.5.0
  (2026-06-30): BUG-167, BUG-170, BUG-184, FEAT-165, TECH-079, TECH-173 →
  **left in done/**, deliberately. They belong to the old product's next
  release (a v5.6.0), not the dev plugin; misattributing them into 0.4.0's
  archive would corrupt history, whereas leaving them is reversible. Open
  decision for Gary: sweep them as old-framework v5.6.0 (with or without the
  retiring archive build), or hold them until graduation.

**Mechanics (followed `/fw-release`'s steps by hand, since the dev plugin was
not a configured product):**
- `framework.yaml` gains a `framework-dev` product entry (priority 4,
  `archive_path: history/releases/framework-dev`, changelog in the workspace;
  no status file — version lives in `plugin.json`; no build script — the dev
  channel publishes by junction). Pointer-only config, no restatement.
- `plugin.json` 0.3.0 → **0.4.0**; workspace CHANGELOG `[Unreleased]` rolled
  to `[0.4.0] - 2026-08-24` (FEAT-190 kickoff line added — it predated the
  CHANGELOG's creation), fresh `[Unreleased]` block above.
- Commit `d8c4029` + annotated tag **`framework-dev-v0.4.0`** (product-prefixed,
  matching the existing `plugin-light-v1.0.4` convention — a bare `v0.4.0`
  would sit ambiguously beside the old framework's `v5.x` tags).
- Seven items `git mv`'d to `project-hub/history/releases/framework-dev/v0.4.0/`
  (commit `5d0afc8`); no artifact folders existed.
- Marketplace republished so the cache reflects 0.4.0 (version drives plugin
  updates). Not pushed — push left to Gary per the release command.

### Current State (end of day)

- **done/ (6):** old-framework items awaiting their own release decision
- **doing/:** empty
- **Released:** framework-dev v0.4.0 — first release of the ADR-009 build
- **Next:** old-framework v5.6.0 decision; FEAT-193 (ops trim) as the next
  build card; TASK-205 dogfooding when a real case arrives

---
## Cleanup Release: Old Framework v5.6.0 (Session Close, continued)

**Gary:** "Let's clean it up" — release the six held old-framework items rather
than leave them in done/ until graduation. Two questions answered:

- **5.6.0 or 5.5.1?** Computed, not guessed: highest `Version Impact` across
  the six is MINOR (BUG-184, FEAT-165, TECH-173), so **v5.6.0** per the release
  rule (highest impact wins; PATCH-only would have been 5.5.1).
- **Disclaimer for the partial release:** a blockquote heads the `[v5.6.0]`
  CHANGELOG entry — maintenance release, partial by design; the archive line is
  superseded by the ADR-009 plugin build (framework-dev 0.4.0, same day); no
  further feature work on this line; archive channel retires at graduation;
  FEAT-165's `engagement` type ships but is superseded in effect by the
  workspace model. `PROJECT-STATUS.md` status line changed from
  "Production-ready" to "Maintenance — superseded…".

**Mechanics:** the July `[Unreleased]` block already covered TECH-173, BUG-170,
BUG-184 in depth; FEAT-165, TECH-079, and a standalone BUG-167 line were
synthesized from the items' summaries. Rolled to `[v5.6.0] - 2026-08-24` with a
fresh `[Unreleased]` above. Commit + annotated tag `v5.6.0`; six items `git mv`'d
to `project-hub/history/releases/framework/v5.6.0/`; done/ is now empty.
**Distribution built** (`distrib/framework/spearit_framework_v5.6.0.zip`) —
meaningful rather than ceremonial, because BUG-170 *was* a distribution bug
(the move engine never shipped); this is the first archive that carries it.

### Current State (end of day, final)

- **done/: empty. doing/: empty.** Both products released: framework-dev
  v0.4.0 (first ADR-009 build release) and framework v5.6.0 (maintenance).
- Unpushed: 2 tags + the release commits — push is Gary's (`git push origin
  main --tags`).
- **Next:** FEAT-193 (ops trim) as the next build card; TASK-205 dogfooding on
  the first real case; old-framework line now maintenance-only.

---
## Post-Release Board Triage (Session Close, final)

**Next cycle queued — operations pair:** FEAT-193 (ops scaffold trim) and
FEAT-195 (ops record convention) moved backlog → todo together: 193 lays the
flow folders, 195 defines what moves through them (and carries FEAT-202's
hand-offs — INC artifact bundles, close-gate mechanism). Adjacent cards held in
backlog until those land, in dependency order: FEAT-199 (Due: needs 195's record
shape) → FEAT-196 (the reporting leg of ops; consumes the flow folders) →
FEAT-200 (schedule definition lives in ops; builds on 199). Other "operations"
grep hits (TECH-049/096, BUGFIX-045) are the generic word, not workspace ops.

**Troubleshooting theme, for the record:** three follow-on cards exist, not one —
FEAT-203 (playbooks), FEAT-204 (collectors), TASK-205 (dogfood + retro, High).

**todo/ triage (Gary: "move the old-framework cards back to backlog"):** of five
unlabeled items only two were old-framework — FEAT-092 (sprint support, Jan
2026) and TECH-172 (DECISION-type reconcile) → backlog. TECH-172 got a re-scope
note: the old line is maintenance-only, so its doc/template/plugin straggler
edits are dead work; what survives is the board half (disposition open
DECISION-* items 035/036/110/162/171, record the ADR). The other three are
engine or new-build work that merely lacked the field, now labeled
`Workspace: framework`: BUG-181 (re-scoped to /fw-init under ADR-009), FEAT-175
(/fw-new create gate — the DECISION-197 lesson's mechanism; the kanban engine
carries into the new build), TECH-177 (checkbox states in fw-move.sh gates).

### Board at close

- **todo/ (6):** BUG-181, FEAT-163, FEAT-175, FEAT-193, FEAT-195, TECH-177 —
  all new-build or engine (the script's "7/10" counts a dotfile — BUG-174)
- **doing/: empty. done/: empty.** Both products released today.
- **Next session:** `/fw-move 193 doing` (small: ops overlay + regenerate
  fixture), then 195's review (three open questions).

---

**Last Updated:** 2026-08-24

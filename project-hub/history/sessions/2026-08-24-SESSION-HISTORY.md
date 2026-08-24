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

**Last Updated:** 2026-08-24

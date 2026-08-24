# Feature: Troubleshooting Case Pattern — Ops Flow + kb Research Cases

**ID:** FEAT-202
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-08-24
**Workspace:** framework
**Completed:** 2026-08-24

---

## Summary

Define the framework's troubleshooting format. Field precedent (Gary, Toyota
project): `kb/<domain>/TS-nnn-<slug>/` with `evidence/`, `scripts/`, and a
journey README — good bones, adopted with two structural changes and four
additions (designed 2026-08-24 during the kb-branch session).

**The split (change 1):** a TS case fuses two lifecycles. The *investigation*
is flow → an operations `INC-nnn` record (location-is-status, FEAT-193/195),
with working material (raw logs, half-run scripts, dead ends) as the record's
artifact bundle — the kanban's artifact-folder pattern applied to ops records.
The *case* — symptom, hypotheses, discriminating evidence, conclusion — is
knowledge.

**The address (change 2):** cases live at **`kb/<domain>/research/<case>/`** —
no parallel `TS-` tree, no new domain folder. A troubleshooting case is the
purest instance of FEAT-201's `research/` definition: curated by us, concluded
by us, often covering exactly what vendor docs omit, stale-by-refutation.
Toyota's `evidence/`, `scripts/`, journey-README shape survives intact *inside*
the case folder.

## The four additions

1. **Distillation gate at close** (the piece most TS formats lack): closing the
   INC asks — durable knowledge? → write the research case, plus a `cookbook/`
   recipe if the fix is repeatable (recipe links the case; the case carries the
   proof), or explicitly record "nothing durable." Without the gate, journeys
   are write-only and the kb never receives what the investigation bought.
   Mechanism candidate: the ops close flow (FEAT-195's move treatment) carries
   the prompt.
2. **Environment/version stamp** on every case — a conclusion is valid only for
   the versions it was proven on; the stamp makes stale-by-refutation checkable.
3. **Symptom-first titling** (future-you searches by symptom, not case number) +
   customer-ticket cross-reference (FEAT-195's field) + contact links
   (FEAT-194 registry) where relevant.
4. **Hygiene rules:** evidence is curated and scrubbed before entering the kb —
   raw customer logs (PII/credentials) stay git-ignored scratch with pointers
   (sibling of FEAT-201's licensing rule); scripts get the promotion test — a
   diagnostic that will run again is *product* material (TASK-197 D5 /
   Toyota script-library lesson): the case keeps the one-shot proof and links
   the promoted tool.

## Primary goals (Gary, 2026-08-24 — what this pattern must deliver)

1. **A systematic, AI-assisted troubleshooting methodology and capture.** Home:
   a troubleshooting **skill** (standards-as-skills, ADR-009 OQ1) that walks the
   loop — capture symptom → **search the kb first** ("have we solved this?" is
   step one of the method) → open the INC anchor → hypothesis/evidence
   iterations with the AI keeping the journey README current *during* the work
   → the close gate distills. Capture-as-you-go, never end-of-case archaeology.
2. **Easy retrieval of already-solved problems.** The final doc is a kb article
   in two grades: the **cookbook recipe** is the findable "solution card"
   (symptom-first title, terse fix) whenever the fix is repeatable; the
   **research case** is the evidence behind it (recipe links case; with no
   repeatable fix, the case alone is the article). Findability = the
   search-first step + symptom-first naming + one consistent case skeleton (the
   AI is the search engine; consistency is what makes it reliable). Any
   browsable solutions index is a generated view (CONTACTS.md grammar), never
   hand-kept.

## Open Questions (resolve before → doing)

- [x] The troubleshooting skill (goal 1): scope it here or as its own card? Its
      shape (skill vs command), name, and how it hands off to the ops close
      flow.
      *Resolved 2026-08-24: scoped here; shipped as the plugin's FIRST skill,
      `skills/fw-troubleshoot/SKILL.md` (a skill, not a command — the method
      loads when troubleshooting language appears, per standards-as-skills).
      Ops handoff: opens an INC anchor when the ops flow exists; until
      FEAT-193/195 land it notes the anchor as pending and runs case-only.*
- [x] Case record template: ship `templates/records/ts-case.md` (journey README
      skeleton: symptom → environment → hypotheses → evidence → conclusion →
      links)? Lean yes — joins `contact.md` in the records area.
      *Resolved 2026-08-24: yes. The case is a folder
      (`research/<symptom-slug>/` + README from the template; evidence/ and
      scripts/ only if used); required: symptom heading, Status, Environment.*
- [x] Does the distillation gate need mechanism now (prompt in the ops close
      flow) or convention first (documented in the case template) until
      FEAT-195's move treatment lands?
      *Resolved 2026-08-24: convention first, carried by the skill's close-gate
      step (the skill is the surface an AI actually loads); becomes mechanism
      in FEAT-195's ops close flow — note added there.*
- [x] Artifact-bundle convention for ops records (`INC-nnn/` sibling folder,
      mirroring kanban artifact folders) — define here or in FEAT-195?
      *Resolved 2026-08-24: FEAT-195's to define (it owns record mechanics);
      note added there.*

## Acceptance Criteria

- [x] The pattern documented in exactly one home *(2026-08-24: the method lives
      in the fw-troubleshoot skill, the record shape in ts-case.md, and the
      domain README's research/ bullet points at both — pointers, no
      restatement)*
- [x] Case template ships in `templates/records/` *(2026-08-24: ts-case.md)*
- [x] Distillation gate exists as convention or mechanism, per the OQ
      *(2026-08-24: convention — the skill's close-gate step; mechanism noted
      for FEAT-195)*
- [x] Evidence-scrubbing and script-promotion rules stated where cases are made
      *(2026-08-24: in the template's Artifacts section and the skill's rules)*
- [x] Verified against the built plugin, not the source tree *(2026-08-24:
      SKILL.md and ts-case.md present in the published marketplace copy; sample
      case created in the fixture kb from the published template. Skill
      registration itself needs the next Claude Code restart — file-presence
      verified now.)*

## Related

- **FEAT-201** — `research/` provenance definition; cases are its purest instance.
- **FEAT-195** — ops record IDs, close flow (the gate's mechanism home),
  customer-ticket cross-ref field.
- **FEAT-193** — ops flow folders the INC anchor lives in.
- **FEAT-194** — contact registry cases link into.
- **TASK-197 D5** — one activity splits across types; the script-promotion test.
- **Field precedent** — Toyota project `kb/<domain>/TS-nnn-<slug>/` (evidence/,
  scripts/, journey README), 2026; adopted-with-changes here.

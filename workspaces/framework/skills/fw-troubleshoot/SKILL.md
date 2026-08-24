---
name: fw-troubleshoot
description: Systematic AI-assisted troubleshooting - use when the user reports a technical problem to investigate (errors, failures, unexplained behavior in their products or infrastructure), wants to resume a troubleshooting case, or asks "have we seen this before". Searches solved cases first, then runs a hypothesis-evidence loop with capture as you go.
---

# fw-troubleshoot — Systematic Troubleshooting with Capture

You are walking a troubleshooting investigation. Two obligations override
everything: **search before investigating** (the fastest fix is one already
made), and **capture during, not after** (update the case file at every
iteration — an unwritten journey is archaeology by evening).

## The loop

1. **Capture the symptom.** One sentence, symptom-first, plus environment
   (products, exact versions) and error text verbatim. Ask for what's missing.

2. **Search solved work FIRST.** Grep `workspaces/kb/*/cookbook/` and
   `workspaces/kb/*/research/` for symptom terms (error strings, product
   names, behavior words — several phrasings). Report hits to the user before
   any new investigation: a matching cookbook recipe may end this now; a
   related case seeds the hypothesis list. No hits → say so and continue.

3. **Anchor the activity.** If an operations workspace with the flow folders
   exists, open an `INC-` record as the flow anchor (cross-reference any
   customer ticket — their id is never our key). Until the ops flow lands in
   this repo, note the anchor as pending and continue with the case alone.

4. **Open the case.** Create
   `workspaces/kb/<domain>/research/<symptom-slug>/README.md` from the
   plugin's `templates/records/ts-case.md` (create the domain first via
   `fw-new-kb-domain.sh` if needed). Fill symptom, environment, status
   `investigating`.

5. **Hypothesis–evidence iterations.** Maintain the hypothesis table: each
   hypothesis gets a discriminating test; each test's outcome is recorded as
   evidence with a verdict (confirmed / refuted / open). Propose the test
   that discriminates most cheaply. **After every iteration, update the case
   file** — hypotheses added, verdicts changed, evidence filed. Dead ends
   stay in the table; a refuted hypothesis is knowledge.

6. **Evidence hygiene, at capture time.** Into `evidence/` goes only what is
   curated and scrubbed — customer logs carry PII and credentials, so raw
   dumps stay in git-ignored scratch with a pointer from the case. Never
   commit a raw log.

7. **Close gate (the distillation — do not skip).** When resolved:
   - Stamp the conclusion with the environment it was proven on; set status.
   - **Repeatable fix?** Write the cookbook recipe — symptom-first title,
     terse steps, linking this case as its proof. The recipe is what future
     searches find; the case is why it's trusted.
   - **Not repeatable?** The case alone is the record. "Nothing durable" is a
     legitimate outcome — record it explicitly on the case and (when the ops
     flow exists) the closing INC record.
   - **Script promotion test:** any script from `scripts/` you would run
     again is product material — flag it to the user for promotion to a
     product workspace; the case keeps the frozen one-shot proof.
   - Close the INC anchor if one exists.

## Rules

- The case folder is the one home for the journey; the INC record is flow,
  the cookbook recipe is the findable solution card — never duplicate content
  across the three; link.
- Conclusions are valid only for their Environment stamp. A refuted
  conclusion is revised in place with the refutation noted — cases go stale
  by refutation, not by age (kb research/ provenance rule).
- Never invent evidence or verdicts; record only what a test actually showed.
  If the user reports a result, record it as reported by them.

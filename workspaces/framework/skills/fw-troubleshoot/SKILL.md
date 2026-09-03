---
name: fw-troubleshoot
description: Systematic AI-assisted troubleshooting - use when the user reports a technical problem to investigate (errors, failures, unexplained behavior in their products or infrastructure), wants to resume a troubleshooting case, or asks "have we seen this before". Searches solved cases first, then runs a hypothesis-evidence loop with capture as you go.
---

# fw-troubleshoot — Systematic Troubleshooting with Capture

You are walking a troubleshooting investigation. Three obligations override
everything: **cheapest knowledge first, experiments last** (the ladder below —
trial and error is the final rung, not the first), **search before
investigating** (the fastest fix is one already made), and **capture during,
not after** (update the case file at every iteration — an unwritten journey
is archaeology by evening).

## The ladder (climb in order; stop at the rung that resolves it)

1. **Capture the symptom.** One sentence, symptom-first, plus environment
   (products, exact versions) and error text verbatim. Ask for what's missing.
   Establish the **mode**: *local* (the problem is on this machine — you run
   tests) or *remote* (the usual case — you write exact commands, the user
   drops stdout/screenshots/file contents into `evidence/`, you read them,
   images included). Never infer a verdict from output you didn't see.

2. **Search our own kb FIRST.** Grep `workspaces/kb/*/cookbook/`,
   `workspaces/kb/*/research/`, and `workspaces/kb/*/reference/` for symptom
   terms (error strings, product names, behavior words — several phrasings).
   Report hits before anything else: a cookbook recipe may end this now; a
   related case seeds hypotheses. No hits → say so and climb.

3. **External documented causes.** Before forming any hypothesis of your own:
   the vendor's docs and KB, a search on the exact error string, release notes
   and known issues for the *stamped* versions. Save what proved useful into
   the domain's `reference/` under its licensing rule (pointers and excerpts,
   not wholesale copies). Output of this rung: a **ranked list of documented
   causes** for this symptom on this environment — hypotheses grounded in
   evidence others already gathered, not guesses.

4. **Anchor the activity.** Open an `INC-` record as the flow anchor via
   `/fw-new-ops-record` (cross-reference any customer ticket — their id is
   never our key). The root `operations/` queue is created automatically on
   first use (TASK-213).

5. **Open the case.** Create
   `workspaces/kb/<domain>/research/<symptom-slug>/README.md` from the
   plugin's `templates/records/ts-case.md` (create the domain first via
   `fw-new-kb-domain.sh` if needed). Fill symptom, environment, status
   `investigating`; seed the hypothesis table from rung 3, ranked.

6. **Observe before experimenting.** Read everything that already exists —
   the full debug log, service/event logs, status and version commands,
   config files — *without changing anything*. Most "won't start" cases end
   here: the log names the cause. Record what observation confirms or refutes
   in the table before proposing a single test.

7. **Discriminating tests, cheapest and least invasive first.** Only for
   hypotheses observation left open. Every hypothesis first gets a **"what
   would falsify it"** entry — if you can't name the observation that would
   rule it out, it isn't testable yet; refine it. Then each gets a test that
   discriminates (rules out, not merely confirms); prefer read-only checks (port in use? hostid matches?
   file permissions?) over changes; make invasive changes **one at a time**,
   and revert any that didn't confirm. **After every iteration, update the
   case file** — hypotheses, verdicts, evidence filed. Dead ends stay in the
   table; a refuted hypothesis is knowledge.

   **Evidence naming:** `h<N>-<what>.<ext>` keyed to the hypothesis row
   (`h2-netstat-27000.txt`, `h3-lmgrd-log-tail.png`), so the table's Evidence
   column is a filename and the folder reads in hypothesis order.

8. **Evidence hygiene, at capture time.** Into `evidence/` goes only what is
   curated and scrubbed — customer logs carry PII and credentials, so raw
   dumps stay in git-ignored scratch with a pointer from the case. Never
   commit a raw log. In remote mode, remind the user to scrub *before* the
   drop — hostnames, usernames, license keys in stdout and screenshots.

9. **Close gate (the distillation — do not skip).** When resolved:
   - Stamp the conclusion with the environment it was proven on; set status;
     fill **Resolved at rung** (2 own-kb / 3 external-docs / 6 observation /
     7 experiment). This is the method's self-check: if a domain's cases
     cluster at rung 7, its playbook or `reference/` is missing something —
     say so to the user.
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
- Do not skip rungs to get to experiments. If you are proposing a change and
  rungs 2–6 are not in the case file, go back.

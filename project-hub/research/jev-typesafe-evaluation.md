# Research: Jev (TypeSafe AI), and Whether It Complements the Framework

**Date:** 2026-09-27
**Author:** Claude Code, for Gary Elliott
**Status:** Research only. No decision taken. Feeds SPIKE-248.
**Shelf life:** short. Jev launched 2026-09-15, twelve days before this was written. Re-check
the facts below before acting on them.

---

## Bottom line

**Jev fits the framework's gap in principle, but it is too early to adopt.** The framework
already splits work into *facts*, which scripts enforce, and *judgments*, which the AI does
in prose. ADR-008 found that the prose half rots. Jev is a cheap, fast way to make a judgment
into a hook the harness calls. The community's best pattern for using it, "facts go to code,
judgments go to Jev, only facts can block", matches the framework's own rule that warnings
never block (WIP, UAT-41).

**Recommendation:** don't integrate now. There are three reasons:
- The product is 12 days old.
- It sends repo content to a third party, which is a problem for client repos.
- SPIKE-248 is trying to *reduce* the framework's surface.

If it is tried at all, try it in one place: an **optional, fail-open, advisory** check for
the Implementation Rule, in this repo only. Measure it against real sessions before shipping
anything.

---

## What Jev is (verified from sources, 2026-09-27)

- **Maker and date:** TypeSafe AI (San Francisco). Launched 2026-09-15 with a reported $40M
  seed. Current model: jev-1.13.
- **What it does:** a "System One" decision model. It **does not generate text.** You send
  state (text or JSON, up to about 150,000 characters) and typed questions. You get back a
  calibrated probability for each answer in one forward pass. There are three question types:
  - **Noul:** yes/no, returned as a probability.
  - **Choice:** pick one of up to 255 options, returned with the full distribution and a
    confidence.
  - **Score:** a scale of 2 to 10 levels, returned as a weighted mean and a distribution.
- **Limits:** about 64k tokens shared across all questions in a request, and about 32k for a
  single question.
- **Latency:** vendor-stated "70 to 500 milliseconds end to end, most around 100".
- **Price:** $0.042 per million input tokens. Output tokens are free.
- **Access:**
  - The TypeSafe API, plus Cloudflare Workers AI, Netlify AI Gateway, Vercel AI Gateway and
    OpenRouter.
  - SDKs for JavaScript (`@typesafe-ai/sdk`) and Python (`typesafe-sdk`).
  - An official Claude Code plugin: `claude plugin marketplace add typesafe-ai/skills`, then
    `claude plugin install typesafe@typesafe-ai`. It teaches the agent the API and how to find
    places where a judgment call could replace fragile parsing code. It needs no key to
    install.
- **Data:** TypeSafe says it does not train on customer data. **Zero data retention is for
  enterprise customers only** ("contact sales"). I could not read the default retention
  period: the Data Processing Agreement text wasn't in the pages I fetched. **This is
  unverified.**
- **Local or offline:** I found no statement that it can run locally. Community projects
  mention local runners ("Kev", "Laya"), but I didn't verify them. Assume cloud-only.

## What it is bad at (the vendor's own limitations page, confirmed by reviewers)

- Counting, arithmetic, dates, comparisons.
- Instructions that rely on **negation or multi-step indirection.** It reads literally.
- Noisy state: irrelevant content lowers accuracy. It is also exposed to adversarial
  instructions embedded in the state.
- Generating or extracting anything. It can only choose among options you provide.
- **It can be confidently wrong.** "Zero schema violations" is guaranteed by construction; a
  correct answer is not (Hacker News discussion).

## Independent evidence (community evaluations, as summarized in awesome-typesafe-jev)

- **Action gating** (111 cases): Jev matched 100 labels with one unsafe "allow"; Claude
  matched 102, also with one. Most errors came from mapping an answer to an action, not from
  the model.
- **Ambiguity:** when an "unknown" option was offered, Jev chose it for 95% of ambiguous items.
  Without that option it scored 0% and fell back on stereotypes. **Always offer an explicit
  "unclear / needs review" option.**
- **Ordering:** it passed synthetic ranking gates but failed 4 of 6 on human-graded pairs.
- **Routing:** calibration bounds broke when the traffic mix shifted. Calibrate on
  representative data, and re-check when the data changes.

## Closest existing work to our design

- **Canny** (`qkal/Canny`, MIT license). Claude Code hooks on SessionStart, PreToolUse,
  PostToolUse and PostToolUseFailure:
  - An append-only ledger records commands, exit codes and edited paths.
  - **Deterministic rules block:** no passing check since the last edit, secrets, removed
    tests, the fourth repeated failure.
  - **Jev only advises:** whether an edit breaks the rules in `CLAUDE.md`, and whether a
    message is a "done" claim. Jev can only *relax* a gate, never tighten one.
  - If Jev is unavailable after 3 seconds it **fails open**. A crash in a hook returns `{}`.
  - Design principle: *"Facts go to code. Judgments go to Jev. Only facts can block."*
- Similar projects: `jev-belay`, `clear-head` and `jev-claude` (Stop hooks that check "done"
  claims against evidence), `jev-cli` (permission gating, prompt-injection screening), and
  `jev-review` (an MCP server scoring diffs on 15+ quality dimensions, community-built).

## Where it could fit the framework (my assessment, ranked)

1. **The Implementation Rule.** CLAUDE.md calls it "the only guard that cannot be mechanized",
   and SPIKE-248 already questions that.
   - The deterministic half (source edited while `doing/` is empty) needs no Jev.
   - Jev would add an advisory judgment: *does this edit belong to a card in `doing/`?* This
     is the best fit, because it makes a prose-only rule partly mechanical.
2. **Card-ripeness pre-check on `→ doing`.** A Score or Noul rubric:
   - Is there a clear goal?
   - Are the criteria checkable?
   - Is there at most one dependency?

   It would **inform** the AI's pre-implementation review, never replace it. That would
   honour ADR-007 D7 (the review is a judgment, never a script check).
3. **fw-troubleshoot's "have we seen this before?"** Re-rank keyword hits from the kb with a
   Noul per candidate (the jevsearch pattern). This helps once the kb is large; today it is
   small.
4. **Drift between documents** (TECH-189). Ask "does passage A contradict passage B?" across
   document pairs. **Low confidence:** contradiction usually hinges on negation, which is a
   documented weakness. Deterministic checks (grep, a composed build) stay the primary guard.

**Not a fit:** proposing the type in `/fw-new`. Claude already does this inline, in context,
at no extra cost. A second model adds a dependency and saves nothing.

## Risks for this framework specifically

- **Client confidentiality.** Framework repos hold Honda, Boston Dynamics and other SOW work.
  Sending diffs or cards to a third party needs the client's agreement and, realistically,
  zero data retention, which is enterprise-only. Any integration must be **opt-in per repo**
  and off by default.
- **Self-containment.** The plugin must work with no external key (UAT-27). Jev can only
  ever be an optional add-on that fails open.
- **Maturity.** One model version, twelve days of public use, a startup vendor, and community
  tools that are days old.
- **Maintenance cost.** This is SPIKE-248's own concern. Every integration is more framework
  to keep alive.

## If it is ever trialled: the rules to carry

- **Only facts block. Jev only advises**, like the WIP warning and Canny's pattern.
- **Fail open** when there is no key, on a timeout (about 3 seconds), or on any error. A
  crash in a hook must never stop work.
- **Always offer an "unclear" option**, and treat middling confidence (for example 0.1 to 0.9)
  as "use the deterministic default".
- **Keep the state short and relevant**, and don't phrase questions in the negative.
- **Log each question and answer** to a local ledger so calibration can be measured on our
  own data before any threshold is trusted.
- **This repo first. Never a client repo** without the client's agreement.

---

## Sources

- [A deep dive into Jev, TypeSafe's System One model — flaviocopes.com](https://flaviocopes.com/jev/)
- [TypeSafe docs](https://docs.typesafe.ai) · [llms.txt index](https://docs.typesafe.ai/llms.txt) · [Legal](https://docs.typesafe.ai/legal.md) · [Agent skill](https://docs.typesafe.ai/agent-skill.md)
- [awesome-typesafe-jev (field guide, evaluations, integrations)](https://github.com/AbdelStark/awesome-typesafe-jev)
- [Canny — deterministic hooks decide, Jev advises](https://github.com/qkal/Canny)
- [jev-review — MCP quality review](https://github.com/NiazMorshed2007/jev-review)
- [jev-belay](https://github.com/valentynkit/jev-belay) · [clear-head](https://github.com/VladyslavHontar/clear-head) · [jev-cli](https://github.com/Gilbert09/jev-cli) · [jev-claude](https://github.com/takezou621/jev-claude)
- [Hacker News discussion](https://news.ycombinator.com/item?id=49745752) · [eesel AI review](https://www.eesel.ai/blog/typesafe-jev-review) · [Forbes, 2026-09-22](https://www.forbes.com/sites/ronschmelzer/2026/09/22/why-everyone-is-talking-about-jev-the-ai-that-doesnt-chat/)

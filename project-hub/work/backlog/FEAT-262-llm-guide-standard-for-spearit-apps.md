# Feature: LLM Guide Standard for SpearIT Apps

**ID:** FEAT-262
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-11-14
**Workspace:** framework
**Depends On:**
**Completed:**

---

## Summary

Every SpearIT app gets a `docs/llm-guide.md`: everything an AI agent needs to know to use the app,
short of an MCP server. Gary started it in Hearth and wants one outline and shape for all the apps
(Gary, 2026-11-13: *"I like the idea of capturing the outline and shape for all SpearIT apps."*).
This item captures that outline, the rules that make a guide good, and a skeleton, drawn from the
two guides that exist.

---

## Problem Statement

**What problem does this solve?**

An agent asked to work with an app (write its config, add content, run it, check the result)
reads the user manual, which is written for people: friendly, partial, spread out. It guesses the
rest. The guide gives it the exact facts in one place, and a way to check its own work. Without a
shared shape, each app's guide is invented again, and an agent moving between apps re-learns where
things are.

**Who is affected?** AI agents (Claude, Copilot, ...) working in or with any SpearIT app; the
people who ask them to.

**Current state:** two guides, written by hand:

| App | Guide | Notes |
|---|---|---|
| Hearth (Announcements) | `Hearth/docs/llm-guide.md` (GitHub SpearIT-LLC/Hearth) | The first. Work in progress (Gary). |
| Burst (was BatchWrapper) | `Burst/docs/llm-guide.md`, shipped beside the exe | Written 2026-11-14 from Hearth's outline. Kept honest by tests. |

---

## The outline

Sections in this order. Reference before prose; a section the app has nothing for is left out,
not left empty.

1. **Title and opening.** "<App> guide for AI agents". One paragraph: who it is for ("an AI agent
   asked to ..."), "precise rather than friendly", and that people start with the user manual
   (named).
2. **Version line.** "**Describes <App> <major.minor>.**", how to see the installed version, and
   what to do if they differ (trust the manual beside that install). A stale copy then shows.
3. **What it is.** What the app does in two or three sentences, the shape of a run, and **when it
   is the wrong tool**.
4. **Where things are.** The installed layout as a tree, one comment per entry; which folders
   are the agent's to edit and which never (Hearth: `bin\` never).
5. **Reference.** The facts, in tables: settings with type, default and meaning (every form, e.g.
   JSON and XML); accepted formats, exactly ("the only accepted formats: ..."); tokens or
   placeholders; what is refused and why. Command-line options and exit codes get their own
   tables (sections 8 and 7), or sit here when short.
6. **Do the work.** Numbered steps for the common tasks (Hearth: new item, change, remove; Burst:
   write the config, quote tokens, choose threads, run, read results).
7. **Verify.** The command that checks the agent's work without side effects, and its exit codes:
   Hearth `--check-report <file>` (exit code = the number of Fix findings); Burst `--dryRun`
   (0 would run, 2 with messages). The loop: run it until it passes, then act. The message shape
   the app uses (Problem / Action), and "do what the Action line says; don't retry unchanged".
8. **Command-line options.** Table: option, effect, default.
9. **Do and don't.** The mistakes an agent would make, as rules, each with its reason: what not
   to edit, what needs a person's say-so (Hearth: alerts flash every workstation; Burst: never
   allow linked output folders to silence an error), what not to work around (Burst: no `cmd /c`
   wrapper around the rule set), what not to invent (settings, tokens, formats).

## What makes a guide good

- **Exact, not friendly.** Tables of facts an agent can copy; the accepted formats spelled out,
  with examples of what is refused.
- **One verify loop with an exit code.** The most useful part: the agent checks its own work.
  An app without a check-only mode should get one (Burst gained `--dryRun` for its guide).
- **Reasons with the rules.** "Don't X: Y happens" lets an agent handle the case the rule didn't
  name.
- **Found where the agent works.** Hearth: an `AGENTS.md` in the content folder points to it.
  Burst: `--help` and the README name it. Shipped beside the app, so it matches the installed
  version.
- **Kept honest mechanically** (the Single-Source Rule's lesson: prose drifts). Burst's tests
  fail when a setting, option or token is missing from the guide, when the shipped copy differs
  from the source, or when the guide's major.minor isn't the app's.
- **Plain ASCII** where it may be printed to logs or terminals.
- **No customer data**, as in any shipped file.

---

## Requirements

- [ ] The outline and the rules above, as the framework's standard for an app's LLM guide.
- [ ] A skeleton an agent or a person can fill in (below), with Hearth's and Burst's guides as
      the worked examples.
- [ ] A pointer from wherever a new project's documents are listed, so a new app starts with one.

## Open question (for Gary): where it lands

ADR-009 makes `workspaces/framework/` the only design authority, and the old `framework/templates/`
is being replaced. Options:

1. **A skill in the new framework** (`workspaces/framework/skills/fw-llm-guide/`): "write or
   review this app's LLM guide", carrying the outline, the rules and the skeleton. Fits TECH-254
   (commands become skills) and the way the guide gets written: by an agent, from the app's code
   and manual.
2. **A template in the old framework** (`framework/templates/documentation/LLM-GUIDE-TEMPLATE.md`),
   next to README-TEMPLATE and the quick starts. Ships with the current framework, but adds to the
   layout ADR-009 is retiring.

Claude's recommendation: 1, with the skill's text drafted from this item. Not started: the item
is in backlog until Gary chooses and it moves to doing.

---

## Skeleton (draft)

```markdown
# <App> guide for AI agents

How to <the main tasks> with <App>. Written for an AI agent asked to <task>; precise rather than
friendly. People start with `<manual>`.

**Describes <App> <major.minor>.** `<how to see the version>`. If it differs, trust `<manual>`
beside that install.

## What it is

<What it does, in two or three sentences. The shape of a run.>

Not the right tool when: <cases>.

## Where things are

    <install>\
      <entry>      <what it is; edit or never>

## <Reference sections: settings, formats, tokens, what is refused>

| Setting | Type | Default | Meaning |
|---|---|---|---|

## Do the work

1. <step>

## Verify

    <check command>

- Exit <n>: <meaning>. Repeat until <passing>, then <act>.
- Messages: <shape>. Do what the Action line says.

## Command-line options

| Option | Effect | Default |
|---|---|---|

## Do and don't

- **Do** <the verify loop> after every change.
- **Don't** <mistake>: <why>.
```

---

## Origin

Raised in the BatchWrapper/Burst project, 2026-11-13 to 2026-11-14 (its `planning/PLAN.md`
open question 6 and session records). Gary chose project-framework over SpearIT-CommonLibrary
(*"Let's start with project-framework when you're ready."*): the guide is a document every app
has, whatever its language; the common library is the message standard plus .NET code. The
guide's Verify section points to that message standard.

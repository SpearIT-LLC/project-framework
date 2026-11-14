---
name: fw-llm-guide
description: Write or review an app's docs/llm-guide.md, the guide that gives any AI agent the exact facts to use the app (its config, content, commands, verify loop) - use when a SpearIT app needs its LLM guide, when an app's settings, options or formats change and its guide must follow, or when asked to check a guide against the standard.
---

# fw-llm-guide: Write or Review an App's LLM Guide

Every SpearIT app has a `docs/llm-guide.md`: everything an AI agent needs to use the app, short
of an MCP server. **The standard is `standard.md` in this folder** (the outline, the rules, the
review checklist); `skeleton.md` is the file to fill in. Read `standard.md` before writing
anything: this file only says how to work.

Two obligations override everything:

- **The guide is for any AI, not this one.** It belongs to the app. Someone may read it with
  another model or assistant, so it must assume nothing about the reader's tools (standard.md,
  rules 7-12). The way you work here is your business; nothing of it may show in the guide.
- **Facts from the app, never from memory.** Every setting, option, format and exit code in
  the guide is read from the app's code, `--help` or manual in this session. If you can't verify
  one, leave it out and say so to the user.

## Writing a guide

1. **Read the sources.** The user manual, the app's `--help` (run it if you can), its settings
   model or config schema, its error messages and exit codes. If the app has a check-only mode,
   find it; that becomes the Verify section.
2. **No check-only mode?** Stop and tell the user: the Verify loop is the most useful part of a
   guide (standard.md, rule 2), and the app should get one first (as Burst got `--dryRun`).
   Write the rest only if the user says to go on without it.
3. **Fill in `skeleton.md`** section by section, in the outline's order. Tables for the
   reference. Every "don't" gets its reason. Leave out what the app doesn't have.
4. **Make it findable:** the app's README and `--help` name `docs/llm-guide.md`; where an agent
   works with the app (a content folder, a repo), an `AGENTS.md` points to it. Ship the guide
   with the app (copied beside the executable or into the install), so it matches the version.
5. **Keep it honest:** propose a test in the app's own suite that fails when a setting, option
   or token is missing from the guide, when the shipped copy differs from the source, or when the
   version line doesn't match (Burst's `SchemaAndGuideTests` is the example).
6. **Review it** against the checklist in `standard.md`, and fix what fails before handing it
   over.

## Reviewing a guide

Read `standard.md`, then the guide from top to bottom as an agent that knows nothing else about
the app. Go through the review checklist; for each item that fails, quote the line and say what
to change. Compare the reference tables with the app's current `--help` and settings: drift is
the commonest fault. Report findings to the user; change the guide only when asked.

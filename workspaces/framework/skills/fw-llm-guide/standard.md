# The LLM guide standard

What every SpearIT app's `docs/llm-guide.md` is, the outline it follows, and the rules it
must meet. This file is the **authored source** for the standard (ADR-008): the skill
(`SKILL.md`) and the skeleton (`skeleton.md`) point here rather than restating it. It is plain
Markdown so it can be read and applied without any particular AI tool.

## What a guide is for

Everything an AI agent needs to know to use the app, short of an MCP server: to write its
configuration, add its content, run it, and check the result. The user manual is written for
people (friendly, partial, spread out); the guide gives an agent the exact facts in one place
and a way to check its own work.

Two guides exist and are the worked examples:

| App | Guide |
|---|---|
| Hearth (Announcements) | `docs/llm-guide.md` in SpearIT-LLC/Hearth: content files, dates, `--check-report` |
| Burst (was BatchWrapper) | `docs/llm-guide.md` in SpearIT-LLC/Burst, shipped beside `Burst.exe`: a config file, tokens, `--dryRun` |

## The outline

In this order. Reference before prose. A section the app has nothing for is left out, not left
empty.

1. **Title and opening.** `# <App> guide for AI agents`. One paragraph: what tasks it covers,
   who it is for ("an AI agent asked to ..."), "precise rather than friendly", and that people
   start with the user manual (named).
2. **Version line.** `**Describes <App> <major.minor>.**`, the command or place that shows the
   installed version, and what to do when they differ (trust the manual beside that install).
3. **What it is.** What the app does in two or three sentences, the shape of a run, and **when
   it is the wrong tool**.
4. **Where things are.** The installed layout as a tree with one comment per entry; which
   folders and files are the agent's to edit, and which never.
5. **Reference.** The facts, in tables: every setting with its type, default and meaning (every
   form, e.g. JSON and XML); accepted formats exactly ("the only accepted formats: ..."), with
   examples of what is refused; placeholders or tokens; what the app refuses and why.
6. **Do the work.** Numbered steps for the common tasks.
7. **Verify.** The command that checks the agent's work without side effects, its exit codes,
   and the loop: run it until it passes, then act. The shape of the app's messages, and "do what
   the message says to do; don't retry the same thing unchanged".
8. **Command-line options.** Table: option, effect, default; exit codes as their own table. When
   the command line is the app's main interface (a console tool such as Burst), these two tables
   come first in the Reference instead.
9. **Do and don't.** The mistakes an agent would make, as rules, each with its reason: what not
   to edit, what needs a person's say-so, what not to work around, what not to invent.

## Rules: what makes a guide good

1. **Exact, not friendly.** Tables of facts an agent can copy. Accepted formats spelled out, with
   examples of what is rejected. No marketing, no history, no design rationale (that stays in the
   project's records).
2. **A verify loop with an exit code.** The most useful section. An app without a check-only
   mode should get one: Burst gained `--dryRun` for its guide; Hearth has `--check-report`
   (exit code = the number of findings to fix).
3. **A reason with every rule.** "Don't X: Y happens" lets an agent handle the case the rule
   didn't name.
4. **Shipped with the app**, so the guide matches the installed version; the version line shows
   when it doesn't.
5. **Kept honest mechanically.** A test fails when a setting, option or token the app knows is
   missing from the guide, when the shipped copy differs from the source, or when the version line
   no longer matches. (Burst: `SchemaAndGuideTests`.) Prose alone drifts.
6. **No customer data**, as in any shipped file: no customer server, share or path names, job
   numbers or ticket ids.

## Rules: useful whatever AI reads it

The guide belongs to the app, not to the tool that helped write it. Someone else may use another
model or assistant (Gary, 2026-11-14).

7. **Plain Markdown, one self-contained file.** Headings, tables, lists, code blocks. No front
   matter, includes or links that must be followed to understand it (pointers to the manual are
   fine).
8. **No vendor or tool assumptions.** The reader is "an AI agent", never a named model or
   assistant. No tool names (`Read`, `Bash`, MCP servers, skills, slash commands). No prompt
   syntax tuned to one model (XML-tagged sections, role markers, "You are ..."). Plain
   imperatives: "Run", "Don't".
9. **The interface is commands, exit codes and files.** Commands any shell can run, with full
   option names. An agent without a shell can still use the reference and the rules; the Verify
   section says what to ask a person to run.
10. **Found by neutral routes.** The app's README and `--help` name the guide; where an agent
    works (a content folder, a repo), an `AGENTS.md` points to it (a convention several agent
    tools read). A tool-specific file such as `CLAUDE.md` may point to it too, but is never the
    only route.
11. **Short enough to read in full in one pass,** including by a small-context model. Aim for
    under about 400 lines; put the reference in tables.
12. **Plain ASCII** (it may be printed to logs and terminals): `->` not arrows, `-` not dashes,
    straight quotes.

## Review checklist

For a new guide before it ships, and for an existing one at each minor release.

- [ ] Sections follow the outline; none left empty.
- [ ] The version line names the current major.minor, and how to see the installed version.
- [ ] Every setting, option, token and exit code the app has is in a table (compare with the
      app's `--help` and settings; better, a test does it).
- [ ] Accepted formats are exact, with a refused example.
- [ ] A Verify section with a command, its exit codes, and the loop.
- [ ] Every "don't" has its reason.
- [ ] No model, assistant or tool names; no prompt syntax; no front matter.
- [ ] Commands are plain, with full option names; nothing needs a particular agent tool.
- [ ] The README and `--help` name the guide; `AGENTS.md` where an agent works.
- [ ] Plain ASCII; no customer data.
- [ ] Read once from top to bottom as an agent that knows nothing else about the app: could it
      do the common task and check it?

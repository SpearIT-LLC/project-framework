# Skeleton for docs/llm-guide.md

Copy everything below the line into the app's `docs/llm-guide.md` and fill it in. The outline
and the rules are in `standard.md`; Hearth's and Burst's guides are worked examples. Delete a
section the app has nothing for, and every `<...>` placeholder.

---

```markdown
# <App> guide for AI agents

How to <the main tasks> with <App>. Written for an AI agent asked to <task>; precise rather than
friendly. People start with `<user manual>`.

**Describes <App> <major.minor>.** `<command that prints the version>` shows the installed
version. If it differs, this guide may be out of date: trust `<user manual>` beside that install.

## What it is

<What the app does, in two or three sentences. The shape of a run: what goes in, what comes
out, when it stops.>

Not the right tool when: <cases>.

## Where things are

    <install>\
      <entry>          <what it is>; <edit it | never edit>
      <entry>          <what it is>

## <Reference: name it for what it covers, e.g. "The config", "Items", "Dates">

| Setting | Type | Default | Meaning |
|---|---|---|---|
| `<name>` | <type> | <default> | <meaning> |

- The only accepted formats: `<format>` (`<example>`). Rejected: `<example>`, `<example>`.
- <What the app refuses, and why.>

## Do the work

1. <step>
2. <step>
3. Verify (next section), then <act>.

## Verify

    <check command with full option names>

- Exit `0`: <meaning>. Exit `<n>`: <meaning>.
- Run it after every change, until it passes; then <act>.
- Without a shell: ask a person to run it and give you the output.
- Messages look like this:

      <example message>

  Do what the message says to change. Don't retry the same thing unchanged.

## Command-line options

| Option | Effect | Default |
|---|---|---|
| `<--option>` | <effect> | <default> |

| Exit code | Meaning |
|---|---|
| 0 | <meaning> |

## Do and don't

- **Do** run the Verify command after every change.
- **Don't** <mistake>: <what happens>.
- **Don't** <work around a refusal>: <why it is refused>; tell the person instead.
- **Don't** invent settings, options or formats: <what the app does with them>.
```

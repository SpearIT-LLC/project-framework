# External: Anthropic Bug Report — Plugin Command Namespace Collision

**ID:** BUG-144
**Type:** External Dependency
**Priority:** Medium
**Version Impact:** None (tracking only)
**Created:** 2026-02-18
**Theme:** Plugin Development

---

## Summary

Track the filed bug report with Anthropic regarding Claude Code plugin commands being replaced by similarly-named local skills or user commands without platform-level notification, even when the fully-qualified namespace is used.

---

## External Dependency Details

**Blocked By:** Anthropic (Claude Code team)
**External Reference:** https://github.com/anthropics/claude-code/issues/26906
**Reported Date:** 2026-02-19
**Expected Resolution:** Unknown — platform-level fix required
**Workaround:** Avoid plugin commands that share names/intent with local commands; do not use plugin commands for irreversible operations (see `project-hub/research/plugin-best-practices.md`)
**Follow-up Actions:**
- File the GitHub issue (human action)
- Update this item with issue URL once filed
- Monitor issue for Anthropic response
- When resolved: update `plugin-best-practices.md` to reflect fix
- When resolved: reassess plugin command reliability for write operations

---

## Problem Description

When invoking a fully-qualified plugin command (e.g., `/spearit-framework:move`), Claude Code may silently execute a different command — a local skill, `.claude/commands/` file, or another plugin command with similar name or intent.

**Observed (2026-02-18):**
- Invoked: `/spearit-framework:move feat-201 todo`
- Executed: `fw-move` skill (local `.claude/commands/` file)
- Result: Move succeeded (benign coincidence — both commands do the same thing)
- Visibility: None — user had no indication the wrong command ran

**Root Cause:**
No runtime dispatcher enforces namespace routing. The `<command-name>` tag is passed to Claude as text. Claude pattern-matches on intent rather than routing by exact namespace key.

**Related Anthropic Issue:**
[#24420](https://github.com/anthropics/claude-code/issues/24420) — skill name collision between multiple plugins (similar but distinct failure mode; that issue is about autocomplete, this is about execution dispatch)

---

## Impact

- **Severity:** High (potential) — benign in this case, catastrophic if colliding commands have different effects
- **Scope:** Any project with both a plugin command and a local command/skill covering similar operations
- **Workaround available:** Yes (see plugin-best-practices.md) — but it's behavioral guidance, not a technical fix

---

## Research

Full documentation of the issue, failure scenarios, and mitigations:
→ `project-hub/research/plugin-best-practices.md` — "Plugin Command Namespace Collision — Known Limitation"

---

## GitHub Issue Draft

**Title:** `[BUG] Fully-qualified plugin command namespace ignored — local skill executed instead`

```markdown
## Preflight Checklist
- [x] I have searched existing issues and this is not a duplicate
- [x] I have read the documentation
- [x] I am using the latest version of Claude Code

## What's Wrong?

When invoking a plugin command using its fully-qualified namespace
(e.g., `/spearit-framework:move feat-201 todo`), Claude Code silently
executed a different command — a local `.claude/commands/` skill named
`fw-move` — without any error, warning, or platform-level indication
that the wrong command ran. The move succeeded by coincidence (both
commands perform the same operation). The mis-dispatch was only caught
because the user was actively monitoring the output; no system
mechanism flagged it.

## What Should Happen?

The fully-qualified namespace `/spearit-framework:move` should
unambiguously route to the plugin command defined in
`plugins/spearit-framework/commands/move.md`. The namespace exists
precisely to prevent collision and should be enforced at dispatch time,
not treated as a hint.

## Error Messages/Logs

No error was produced. The wrong command ran silently and produced
plausible-looking output.

## Steps to Reproduce

1. Install a plugin with a command (e.g., `spearit-framework:move`)
2. Have a local `.claude/commands/` skill with a similar name/intent
   (e.g., `fw-move`) in the same project
3. In a VSCode session where the local skill has previously been invoked,
   type the fully-qualified plugin command:
   `/spearit-framework:move feat-201 todo`
4. Observe that the local `fw-move` skill SOMETIMES executes instead of the plugin
   command
5. No error is reported; output appears correct

## Claude Model

claude-sonnet-4-6

## Is this a regression?

Unknown — first time testing plugin commands alongside local skills with
similar names.

## Last Working Version

No response

## Claude Code Version

2.1.45

## Platform

Other (Claude Code CLI / VSCode Extension)

## Operating System

Windows 11 Pro

## Terminal/Shell

VSCode integrated terminal (bash)

## Additional Information

This is distinct from #24420 (autocomplete resolves to first plugin when
multiple plugins share a skill name). That issue notes that manually typing
the fully-qualified name works as a workaround — our case is the opposite:
the fully-qualified name was used explicitly and was still not respected.

The root cause appears to be that Claude Code passes the `<command-name>`
tag to Claude as text with no runtime dispatcher enforcing namespace routing.
Claude pattern-matches on intent and session context. A recently-invoked local
command with similar intent can override an explicitly namespaced plugin command.

If the colliding commands had different effects (e.g., a `release` command that
deploys vs. one that archives work items), silent mis-dispatch could cause
irreversible damage with no indication anything went wrong.
```

---

## Follow-up Checklist

- [x] Draft GitHub issue
- [x] Review draft and file on GitHub (human action)
- [x] Update **External Reference** field above with issue URL
- [x] Move this item to `blocked/` once filed
- [ ] Monitor for Anthropic response / fix
- [ ] When resolved: update `plugin-best-practices.md`
- [ ] When resolved: move to `done/`

---

**Last Updated:** 2026-02-18

# Tech: Convert the Plugin's Commands to Skills

**ID:** TECH-254
**Type:** Tech
**Priority:** Low
**Version Impact:** MINOR
**Created:** 2026-09-28
**Workspace:** framework
**Depends On:**
**Completed:**

---

## Summary

From SPIKE-248 (D8). Claude Code has merged custom commands into skills: "A file at
`.claude/commands/deploy.md` and a skill at `.claude/skills/deploy/SKILL.md` both create
`/deploy` and work the same way. Your existing `.claude/commands/` files keep working"
(code.claude.com/docs/en/skills, verified 2026-09-28). Nothing is broken, so this waits until
after graduation.

## What the conversion would buy

- **`disable-model-invocation: true`** for commands with side effects (`fw-move`,
  `fw-move-ops`, the create gates), so that only the user can start them. Whether that is
  wanted is a judgment for the review, because some flows expect Claude to run `/fw-move`
  on the user's request.
- **A skill folder** for supporting files beside the command.
- **One format across the plugin**, which already ships two skills.

Keep each `SKILL.md` under 500 lines (the docs' guidance).

## Acceptance Criteria

- [ ] Each of the 7 `commands/*.md` is a `skills/<name>/SKILL.md`; the invocation names are unchanged
- [ ] The invocation-control choice is recorded per skill, with a reason
- [ ] UAT's `/fw-*` cases pass unchanged on the installed plugin
- [ ] Plugin CHANGELOG updated

## Related

- **SPIKE-248** — D8

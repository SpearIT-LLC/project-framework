# Bug: Script Input Validation Gaps and CRLF Line Endings

**ID:** BUG-261
**Type:** Bug
**Priority:** Medium
**Version Impact:** PATCH
**Created:** 2026-10-09
**Workspace:** framework
**Depends On:**
**Completed:**

---

## Summary

Found when the `workspaces/framework/` commands, scripts and hooks were copied into the SpearIT
repo by hand (feedback: `SpearIT/notes/framework-feedback.md`, 2026-10-08). Three scripts put
an unchecked argument or record value into an `eval` or a file path, and three `.sh` files have
CRLF endings in the working tree, so a copy taken from it breaks on Linux, macOS and WSL bash.
The file-copy install itself is not supported. The defects are real in any install.

## Bug Description

All verified 2026-10-09 against `workspaces/framework/`:

1. **`eval` injection, `scripts/fw-move.sh:141`.** The namespace check is
   `echo "$NAMESPACES" | grep -qw "$NS"`. That treats `$NS` as a regular expression, so
   `kanban\|;touch pwned;` passes (tested with the grep alone). Line 145 then interpolates
   `$NS` into an `eval`. The `eval` loops in `hooks/report-wip.sh:29` and
   `hooks/board-guard.sh:79` read only the trusted `$NAMESPACES` value and are not affected.
2. **Slug path traversal, `scripts/fw-new-ops-record.sh:25`.** In a `case` pattern, `*\*`
   matches a literal asterisk, not a backslash. `..\..\x` is accepted (tested), and on Git
   Bash it can escape `operations/open/` through `FILE=` on line 48.
3. **Workspace name from record content, `scripts/fw-contacts.sh`.** `ws` comes from the first
   word of an assignment line (lines 120 and 134). Line 155 uses it in a path and line 197
   writes `CONTACTS.md` there, with no allow-list. A record naming `../../x` writes outside
   `workspaces/`. Low severity: it needs a bad or mistyped record. The stale-view cleanup
   (around line 229) has not been reviewed for the same issue.
4. **CRLF in the working tree.** The repo has no `.gitattributes`, and Git's system config
   sets `core.autocrlf=true`. `hooks/board-guard.sh`, `scripts/fw-move.sh` and
   `scripts/fw-next-id.sh` are `i/lf w/crlf`. Git for Windows bash runs them anyway (the
   guard denied a test `mv`), so this repo did not notice. Other bash builds fail with
   `$'\r': command not found`.

## Proposed Solution

- **(1)** Match the namespace exactly before any `eval`, and check its characters:
  `case " $NAMESPACES " in *" $NS "*) ;; *) die ... ;; esac`. The table rows are named by
  variable, so a strict allow-list here is simpler than replacing `eval` across all three
  sites.
- **(2), (3)** Reuse the allow-list that `scripts/fw-new-contact.sh:18` already uses
  (`*[!a-z0-9-]*|""|-*|*-`). For `ws`, also require that the folder exists as a direct child
  of `workspaces/`.
- **(4)** Add a `.gitattributes` with `*.sh text eol=lf` (plus the extensionless
  `tools/pre-commit`) at the repo root, then renormalize. It must reach what ships: the
  junctioned plugin reads the working tree directly.
- **Out of scope:** supporting a file-copy install (`${CLAUDE_PLUGIN_ROOT}` is unset there).
  The framework is the plugin (ADR-009 D3). One line in the plugin README saying a file copy
  is unsupported and pointing to the marketplace install is enough.

## Acceptance Criteria

- [ ] `fw-move.sh` refuses `kanban\|x` and any namespace not in `$NAMESPACES` before line 145's `eval` runs
- [ ] `fw-new-ops-record.sh` refuses slugs containing `\`, `/`, `.` or uppercase (`..\..\x`, `a/b`, `A`)
- [ ] `fw-contacts.sh` skips, with a warning, any `ws` that is not an allow-listed name of an existing `workspaces/<ws>/`; the cleanup near line 229 is checked for the same issue
- [ ] Tests cover the three rejections (extend the existing script tests or add a table test like `tests/test-board-guard.sh`)
- [ ] `.gitattributes` is committed; `git ls-files --eol workspaces/framework` shows no `w/crlf` on `.sh` files
- [ ] The plugin README states that a file-copy install is unsupported and names the supported install
- [ ] Plugin CHANGELOG updated

## Related

- **TECH-253**: `board-guard.sh` is one of the CRLF files; the guard's bypass limits are stated in its header
- **SpearIT feedback items 6 and 7** were not taken: 6 is the documented guard limitation; 7 is
  this repo's legacy `.claude/commands/fw-session-history.md`, not the new framework

# Bug: `fw-contacts.sh --check` Crashes When `workspaces/` Is Absent

**ID:** BUG-235
**Type:** Bug
**Priority:** Medium
**Version Impact:** PATCH
**Created:** 2026-09-21
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

`fw-contacts.sh --check` performs an unguarded `cp` against `<repo>/workspaces` and dies
when that directory does not exist. A check operation should be read-only and should exit
cleanly when there is nothing to check.

Because the pre-commit hook treats any non-zero exit from `--check` as "views are stale",
the crash surfaces to the operator as a stale-views block with advice that cannot be
followed — there are no views to regenerate. See **BUG-236** for that second defect; the
two were found together but are independent.

## Evidence

Found during the 2026-09-21 UAT run in `framework-uat` (TASK-206), while exercising
first-use creation of the operations queue. The run archived the prior state — moving
`workspaces/` to `archive/workspaces/` — so the repo legitimately had no `workspaces/`
tree.

Invoking the check directly:

```
$ bash .../framework/scripts/fw-contacts.sh --check
cp: cannot stat 'C:/Users/gelliott/.../framework-uat/workspaces': No such file or directory
```

The same failure via the commit path:

```
$ git commit -F- <<'EOF'
...
cp: cannot stat 'C:/Users/gelliott/.../framework-uat/workspaces': No such file or directory

pre-commit: blocked — regenerate the views, stage them, and commit again.
```

The commit was completed with `--no-verify` (framework-uat `5919f18`) after confirming the
block was spurious.

**Note on exit codes:** when the `cp` failure was observed through a pipeline during
diagnosis, `$?` reported `0` because it captured the tail of the pipeline rather than the
script. The hook, which calls `bash "$FW" --check` directly in an `if !`, does see the
non-zero status — that is why it blocks. Worth confirming during the fix that the script's
own exit status is what the hook should be reading, and that `set -uo pipefail` (no `-e`)
in the hook is not masking anything else.

## Fix Design

A `--check` must not copy. Two changes in `fw-contacts.sh`:

1. **Guard the workspaces traversal.** If `<repo>/workspaces` does not exist, there are no
   per-workspace `CONTACTS.md` views to compare and the check should exit `0` with a clear
   message (e.g. `no workspaces/ tree — nothing to check`) rather than attempting any
   filesystem operation against the missing path.
2. **Make `--check` read-only.** Locate why a check needs `cp` at all — if it is staging a
   regenerated view to a temp location for comparison, that work belongs behind the
   regenerate path, or it should write into a scratch dir that is created first and cleaned
   up, never derived from an assumed-present source tree.

Worth checking whether the same unguarded assumption exists for a missing
`workspaces/kb/company/contacts/` registry, which is the other input this script reads.

## Acceptance Criteria

- [ ] `fw-contacts.sh --check` exits `0` with an explanatory message in a repo with no
      `workspaces/` directory
- [ ] `fw-contacts.sh --check` performs no `cp` and creates/modifies no files in the repo —
      verified by a clean `git status` and by inspection of the script
- [ ] A missing or empty contacts registry is likewise handled without a crash
- [ ] A genuinely stale view is still detected and still exits non-zero (no regression in
      the case the check exists for)
- [ ] Validated: **AI** — run `--check` against a repo with `workspaces/` absent, present
      and stale, and present and current; **Human** — re-run the framework-uat archive
      scenario and confirm the commit is not blocked

## Related

- **BUG-236** — the pre-commit hook reports this crash as stale views. Found in the same
  run; independent fix.
- **TASK-206** — the UAT runbook whose 2026-09-21 run surfaced this.
- **framework-uat `5919f18`** — the commit made with `--no-verify`, whose message records
  the block.

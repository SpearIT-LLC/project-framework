# Bug: Pre-Commit Hook Reports a `--check` Crash as Stale Views

**ID:** BUG-236
**Type:** Bug
**Priority:** Medium
**Version Impact:** PATCH
**Created:** 2026-09-21
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

The `pre-commit` hook installed by `tools/install-git-hooks.sh` treats *any* non-zero exit
from `fw-contacts.sh --check` as "the CONTACTS.md views are stale" and prints fixed advice:

```
pre-commit: blocked — regenerate the views, stage them, and commit again.
```

When the check fails for any other reason — it crashed, the repo is shaped unexpectedly,
an input is missing — that advice is wrong and, in the case that found this, impossible to
act on. The operator is sent to regenerate views that do not exist.

A blocked commit must tell the truth about why it was blocked.

## Evidence

Found during the 2026-09-21 UAT run in `framework-uat` (TASK-206). `workspaces/` had been
archived, so `fw-contacts.sh --check` crashed on a missing path (**BUG-235**). The hook
rendered that crash as a staleness block:

```
cp: cannot stat 'C:/Users/gelliott/.../framework-uat/workspaces': No such file or directory

pre-commit: blocked — regenerate the views, stage them, and commit again.
```

The `cp` error is the script's own stderr passing through; the second line is the hook's
interpretation. Nothing distinguishes them for the reader, and the actionable line is the
one that is wrong.

The relevant hook logic:

```bash
if ! bash "$FW" --check; then
  echo "" >&2
  echo "pre-commit: blocked — regenerate the views, stage them, and commit again." >&2
  exit 1
fi
```

There is no exit-status discrimination — one branch, one message.

## Fix Design

**Give `--check` a documented exit-status contract and have the hook honour it.** Suggested:

| Status | Meaning | Hook behaviour |
|--------|---------|----------------|
| `0` | views current (or nothing to check) | allow the commit |
| `1` | views stale | block, advise regenerate |
| `2`+ | check could not run | block, report the failure verbatim as a check error |

The third row is the fix: a message along the lines of *"pre-commit: the contacts check
could not run (exit N). This is not a staleness failure — see the error above."* That
phrasing tells the operator the advice they would expect does not apply, which is the
information missing today.

**Also worth settling as part of this card:** whether the hook should fire at all in this
scenario. It triggers on staged paths matching
`workspaces/kb/company/contacts/.*\.md`, and the archive move matched that pattern on the
*old* side of its renames — so moving contacts *out* of the tree tripped the contacts gate.
Arguably a rename whose destination is outside `workspaces/` should not trigger a view
check. This is a design call, not obviously a defect; flagged here rather than assumed.

Note the hook already fails open when the plugin is unreachable (`[ -f "$FW" ] || exit 0`),
which is the right instinct — this card extends the same care to "reachable but broken".

## Acceptance Criteria

- [ ] `fw-contacts.sh --check` documents distinct exit statuses for current / stale /
      could-not-run
- [ ] The hook distinguishes a staleness block from a check failure and prints a different,
      accurate message for each
- [ ] A check failure's own stderr remains visible and is clearly attributed to the script
      rather than to the hook
- [ ] A genuine staleness block still prints the regenerate advice, unchanged
- [ ] Decided and recorded: whether a rename out of `workspaces/` should trigger the gate
- [ ] Validated: **AI** — force each exit status and inspect the hook's output; **Human** —
      re-run the framework-uat archive scenario and confirm the message names the real cause

## Related

- **BUG-235** — the `--check` crash that exposed this. Fixing that removes this instance
  but not the class: the hook would still misreport the next check failure.
- **TASK-206** — the UAT runbook whose 2026-09-21 run surfaced this.
- **framework-uat `5919f18`** — committed with `--no-verify` after diagnosing the block.

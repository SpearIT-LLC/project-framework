# /fw-move - Move Work Item Between Folders

Move a work item between workflow folders with policy enforcement, transition validation, and proper git operations.

## Usage

```
/fw-move <item-id> <target-folder> [--force]
/fw-move "<id1>, <id2>" <target-folder> [--force]
```

## Arguments

- `item-id` (required): One or more work item IDs — full (`FEAT-145`), bare numeric (`145`), or mixed (`"FEAT-145, 146"`). Comma or space separated. Quote multi-item lists.
- `target-folder` (required): One of: `backlog`, `todo`, `doing`, `done`, `blocked`, `archive`, `releases`
- `--force` (optional): Bypass readiness blocks (unresolved markers, unchecked criteria, placeholders). Has no effect on `→ doing/` — dependency checks are always enforced.

---

## What the Script Handles

`framework/scripts/move.sh` enforces these as hard blocks (exit 1):

- **Transition matrix** — invalid from→to pairs rejected
- **Dependency check** — `Depends On:` items must be in `done/` before `→ doing` (not bypassable)
- **Acceptance criteria** — unchecked `[ ]` items block `→ done` (not bypassable)
- **Readiness check** — detects TODO/TBD/DECIDE markers, Option A/B/C, unfilled placeholders — blocks unless `--force`
- **WIP limit** — warning only (does not block)

If the script exits 1, report the error and offer interactive recovery:
- Unchecked criteria → "Mark them complete?"
- Dependency not in done/ → "Move FEAT-NNN to done first?"
- Invalid transition → explain valid paths
- Readiness issues → "Use --force to queue anyway?"

---

## What the AI Layer Handles

**Parent + children:** When a parent ID is specified (e.g. `909`), the script auto-moves all children. Do NOT ask for clarification.

**Child split detection:** When a child ID is specified directly (e.g. `909.1`), check whether its parent is in a different folder than the target.
- Warn if target is `backlog`, `todo`, or `blocked`
- Skip warning if target is `doing`, `done`, or `archive`

```
⚠️  FEAT-909.1 is a child of FEAT-909 (currently in todo/).
    Moving FEAT-909.1 to backlog/ will split it from its parent.

    Options:
    1. Move FEAT-909.1 only (proceed as requested)
    2. Move FEAT-909 + all children to backlog/ instead

    Which would you prefer?
```

---

## Pre-Move (AI)

**Before calling the script:**
1. ✅ Check for child split (warn if needed — see above)
2. ✅ For `→ blocked`: prompt user to add blocked metadata first:
   - `**Blocked By:**`, `**External Reference:**`, `**Reported Date:**`, `**Expected Resolution:**`, `**Workaround:**`, `**Follow-up Actions:**`
3. ✅ For `→ archive`: prompt user to add cancellation metadata first:
   - `**Status:** Cancelled`, `**Cancelled Date:**`, `**Cancellation Reason:**`

For all other targets — no pre-checks needed. The script handles the rest.

---

## Execute Move

```bash
bash framework/scripts/move.sh <ids> <target> [--force]
```

---

## Post-Move (AI)

### → doing/
1. ✅ Pre-implementation review (REQUIRED):
   - Read work item file completely
   - Identify open questions (TODO, TBD, DECIDE, Option A/B/C)
   - Present: what we're building, design decisions, open questions, scope
2. ✅ **STOP — wait for user confirmation before implementing**

**During implementation** — if work item has an Implementation Checklist with:
```markdown
<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->
```
Follow step-by-step: mark `[x]` immediately after each step, stop and wait for approval before proceeding. User may say "continue to completion" to approve all remaining steps at once.

### → done/
1. ✅ Check `Completed` date is set — if missing, offer to set it to today
2. ✅ Update session history using `/fw-session-history`
3. ✅ Commit:
   ```bash
   git add .
   git commit -m "feat: Complete ITEM-NNN - [brief description]"
   ```
4. ✅ Count items in `project-hub/work/done/` and nudge if thresholds exceeded:
   - 10–14 items: "You now have N items in done/. Consider releasing soon."
   - 15+ items: "You have N items in done/ — this is a large release. Recommend releasing or splitting by theme."
   - Under 10: no nudge

### → archive/
1. ✅ Update session history noting cancellation
2. ✅ Commit: `git commit -m "chore: Cancel ITEM-NNN - [brief reason]"`

### → blocked/
- No immediate commit required

### All other targets
- No additional actions required

---

## Examples

```bash
/fw-move FEAT-042 todo                    # Single item — full ID
/fw-move 042 todo                         # Single item — bare numeric
/fw-move FEAT-042 doing                   # Start work (with pre-implementation review)
/fw-move FEAT-042 done                    # Complete work
/fw-move FEAT-042 todo --force            # Queue despite readiness issues
/fw-move "FEAT-042, FEAT-043" todo        # Batch — full IDs
/fw-move "042, 043" todo                  # Batch — bare numerics
/fw-move "FEAT-042, 043" todo             # Batch — mixed
/fw-move FEAT-099 archive                 # Cancel work (add metadata first)
/fw-move BUG-144 blocked                  # Block on external party (add metadata first)
```

---

## Policy Reference

Transition policy: `framework/docs/collaboration/workflow-guide.md#workflow-transitions`
Script source: `framework/scripts/move.sh`

# /fw-move-poc - Move Work Item (POC: Script-Layer Policy)

**POC command for SPIKE-145.** Companion to `/fw-move` — uses `poc-move-policy.sh` which enforces
transition matrix, dependency checks, and acceptance criteria as hard blocks in the script layer.

Use side-by-side with `/fw-move` to compare behavior.

---

## Usage

```
/fw-move-poc <item-id> <target-folder> [--force]
/fw-move-poc "<id1>, <id2>" <target-folder> [--force]
```

## Arguments

- `item-id` (required): One or more work item IDs — full (`FEAT-145`), bare numeric (`145`), or mixed (`"FEAT-145, 146"`). Comma or space separated. Quote multi-item lists.
- `target-folder` (required): One of: `backlog`, `todo`, `doing`, `done`, `blocked`, `archive`, `releases`
- `--force` (optional): Skip readiness block for → `todo`. Issues are still shown as warnings but the move proceeds.

---

## What the Script Handles (no AI checks needed)

The script (`poc-move-policy.sh`) enforces these and will exit 1 with a clear message (unless noted):

- **Transition matrix** — invalid from→to pairs are rejected (hard block)
- **Dependency check** — `Depends On:` field items must be in `done/` before → `doing` (hard block)
- **Acceptance criteria** — unchecked `[ ]` items block → `done` (hard block)
- **Readiness check** — for → `todo`: detects unchecked criteria, unresolved markers (`TODO`, `TBD`, `DECIDE`), undecided options (`Option A/B/C`), and unfilled placeholder text. Blocks unless `--force` is passed, in which case issues are shown as warnings and the move proceeds.
- **WIP limit** — warning only (does not block)

If the script exits 1, report the error to the user and offer interactive recovery (e.g., "mark criteria complete?", "move dependency to done first?", "use --force to queue anyway?").

---

## What the AI Layer Handles

**Parent + children:** When a parent ID is specified (e.g. `909`), the script auto-moves all children. Do NOT ask for clarification.

**Child split detection:** When a child ID is specified directly (e.g. `909.2`), check if parent is in a different folder than target.
- Warn if target is `backlog`, `todo`, or `blocked`
- Skip warning if target is `doing`, `done`, or `archive`

```
⚠️  FEAT-909.2 is a child of FEAT-909 (currently in todo/).
    Moving FEAT-909.2 to backlog/ will split it from its parent.

    Options:
    1. Move FEAT-909.2 only (proceed as requested)
    2. Move FEAT-909 + all children to backlog/ instead

    Which would you prefer?
```

---

## Pre-Move (AI)

**Before calling the script:**
1. ✅ Check for child split (warn if needed — see above)
2. ✅ For → `blocked`: prompt user to add blocked metadata first
3. ✅ For → `archive`: prompt user to add cancellation metadata first

For `todo`, `doing`, `done`, `backlog` — no other pre-checks needed. The script handles the rest.

---

## Execute Move

```bash
bash project-hub/poc/SPIKE-145-script-policy/poc-move-policy.sh <ids> <target>
```

**If script exits 1:** Report the error message to the user. Offer to help fix:
- Unchecked criteria → "Mark them complete?"
- Dependency not in done/ → "Move FEAT-NNN to done first?"
- Invalid transition → explain valid paths

**If script exits 0:** Proceed to post-move actions.

---

## Post-Move (AI)

### → doing/
1. ✅ Pre-implementation review (REQUIRED):
   - Read work item file completely
   - Identify open questions (TODO, TBD, DECIDE, Option A/B/C)
   - Present: what we're building, design decisions, open questions, scope
2. ✅ **STOP — wait for user confirmation before implementing**

### → done/
1. ✅ Update session history using `/fw-session-history`
2. ✅ Commit:
   ```bash
   git add .
   git commit -m "feat: Complete ITEM-NNN - [brief description]"
   ```

### → blocked/
- No immediate commit required

### → archive/
1. ✅ Update session history noting cancellation
2. ✅ Commit: `git commit -m "chore: Cancel ITEM-NNN - [brief reason]"`

### All other targets
- No additional actions required

---

## Examples

```bash
/fw-move-poc FEAT-042 todo
/fw-move-poc FEAT-042 todo --force
/fw-move-poc 042 doing
/fw-move-poc "FEAT-042, FEAT-043" todo
/fw-move-poc "FEAT-042, FEAT-043" todo --force
/fw-move-poc FEAT-042 done
```

---

## POC Notes

- Script: `project-hub/poc/SPIKE-145-script-policy/poc-move-policy.sh`
- Reference: `project-hub/poc/SPIKE-145-script-policy/SPIKE-145-script-policy.md`
- Compare against: `/fw-move` (AI-layer policy) + `framework/scripts/move.sh`

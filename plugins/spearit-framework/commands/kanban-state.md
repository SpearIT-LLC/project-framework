# /spearit-framework:kanban-state - Project Kanban State

Show a summary of current project state: version, workflow counts, WIP health, active work, and items awaiting release.

---

## Role & Mindset

**For this command, adopt a Kanban Board Reader mindset:**

### Core Responsibilities
- Report what's on the board — counts, limits, item names
- Present the data clearly and accurately; do not interpret or editorialize
- Be concise — this is a snapshot, not a narrative

### Key Behaviors
- Facts only: what's in each column, how many, what the limits are
- Flag limit conditions with ⚠ or ❌ — these are data points, not judgments
- If something is missing (no PROJECT-STATUS.md, empty folder), report it cleanly and continue

---

## Usage

```
/spearit-framework:kanban-state
```

---

## Execution

Run this bash script to gather raw data, then render the formatted output described below.

```bash
#!/usr/bin/env bash
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "Not a git repo"; exit 1; }
cd "$REPO_ROOT"

WORK_DIR="project-hub/work"

# Folder counts (exclude .limit and non-.md files)
count_folder() {
  find "$WORK_DIR/$1" -maxdepth 1 -name "*.md" 2>/dev/null | wc -l | tr -d ' '
}

BACKLOG=$(count_folder backlog)
TODO=$(count_folder todo)
DOING_RAW=$(count_folder doing)
DONE=$(count_folder done)
BLOCKED=$(count_folder blocked 2>/dev/null || echo 0)

# WIP limits (read .limit file for any folder that has one)
TODO_LIMIT=""
if [ -f "$WORK_DIR/todo/.limit" ]; then
  TODO_LIMIT=$(cat "$WORK_DIR/todo/.limit" | tr -d '[:space:]')
fi
DOING_LIMIT=""
if [ -f "$WORK_DIR/doing/.limit" ]; then
  DOING_LIMIT=$(cat "$WORK_DIR/doing/.limit" | tr -d '[:space:]')
fi

# Hierarchical WIP count: group by base ID (FEAT-018 + FEAT-018.1 = 1)
DOING_HIER=$(find "$WORK_DIR/doing" -maxdepth 1 -name "*.md" 2>/dev/null \
  | sed 's|.*/||' \
  | grep -oiE '^[A-Za-z]+-[0-9]+' \
  | sort -u \
  | wc -l | tr -d ' ')

# Items in doing/ (names + titles)
echo "=== DOING_ITEMS ==="
find "$WORK_DIR/doing" -maxdepth 1 -name "*.md" 2>/dev/null | sort | while read -r f; do
  fname=$(basename "$f")
  title=$(grep -m1 '^# ' "$f" 2>/dev/null | sed 's/^# //' | sed 's/^[A-Za-z]*: //' | sed 's/^[A-Z]*-[0-9]*[:.] *//')
  echo "$fname | $title"
done

# Items in done/ (names + titles)
echo "=== DONE_ITEMS ==="
find "$WORK_DIR/done" -maxdepth 1 -name "*.md" 2>/dev/null | sort | while read -r f; do
  fname=$(basename "$f")
  title=$(grep -m1 '^# ' "$f" 2>/dev/null | sed 's/^# //' | sed 's/^[A-Za-z]*: //' | sed 's/^[A-Z]*-[0-9]*[:.] *//')
  echo "$fname | $title"
done

# Items in blocked/
echo "=== BLOCKED_ITEMS ==="
find "$WORK_DIR/blocked" -maxdepth 1 -name "*.md" 2>/dev/null | sort | while read -r f; do
  fname=$(basename "$f")
  title=$(grep -m1 '^# ' "$f" 2>/dev/null | sed 's/^# //' | sed 's/^[A-Za-z]*: //' | sed 's/^[A-Z]*-[0-9]*[:.] *//')
  echo "$fname | $title"
done

# Version from PROJECT-STATUS.md
echo "=== VERSION ==="
for candidate in "framework/PROJECT-STATUS.md" "PROJECT-STATUS.md"; do
  if [ -f "$candidate" ]; then
    grep -m1 'Current Version:' "$candidate" 2>/dev/null || true
    break
  fi
done

# Summary line
echo "=== COUNTS ==="
echo "BACKLOG=$BACKLOG TODO=$TODO TODO_LIMIT=${TODO_LIMIT:-} DOING_RAW=$DOING_RAW DOING_HIER=$DOING_HIER DOING_LIMIT=${DOING_LIMIT:-} DONE=$DONE BLOCKED=$BLOCKED"
```

---

## Output Format

Use the script output to render this format. Parse `=== SECTION ===` markers to separate data.

### Default (full report)

Render the Workflow Summary as a table with three columns: Stage, Count, and Limit.

```
Project Status: [Project Name]
=======================================================

Version: v1.0.0 (2026-01-17)

Workflow Summary:

┌─────────┬──────────┬──────────────┐
│  Stage  │  Count   │    Limit     │
├─────────┼──────────┼──────────────┤
│ Backlog │ 12 items │              │
├─────────┼──────────┼──────────────┤
│ Todo    │  3 items │  3 / 10      │
├─────────┼──────────┼──────────────┤
│ Doing   │  1 item  │  1 / 2  ✅   │
├─────────┼──────────┼──────────────┤
│ Blocked │  1 item  │              │
├─────────┼──────────┼──────────────┤
│ Done    │  1 item  │              │
└─────────┴──────────┴──────────────┘

Currently In Progress:
  - FEAT-018: Claude Command Framework (+2 sub-items)
  - FEAT-022: Session History Command

Blocked:
  - BUG-042: Some blocked item

Awaiting Release:
  - DOC-063: Add README Update Step to Release Process
```

**Limit column rules:**
- Show `N / limit` whenever a `.limit` file exists for that folder, regardless of whether the limit is reached
- Backlog, Blocked, and Done have no limit by default — leave the Limit cell empty unless a `.limit` file is found
- Append WIP indicator after the fraction: `✅` under limit, `⚠` at limit, `❌` over limit
- If no `.limit` file exists for a folder, leave the Limit cell empty (no `∞`)

**Hierarchical counting:** FEAT-018 + FEAT-018.1 + FEAT-018.2 = 1 item toward WIP limit. Show `(+N sub-items)` when a parent has children in the "Currently In Progress" list.

**Version:** Extract from `**Current Version:** vX.Y.Z (YYYY-MM-DD)` in PROJECT-STATUS.md. If not found, omit the version line silently.

**Blocked section:** Show only if count > 0.

**Awaiting Release section:** Show only if done/ count > 0.

## Examples

```
/spearit-framework:kanban-state    # Show kanban board state
```

---

## Edge Cases

- **PROJECT-STATUS.md missing**: Omit version line, continue
- **Empty folders**: Show `0 items` — not an error
- **No WIP limit file**: Leave Limit cell empty, no indicator
- **Not a git repo / work folder missing**: Report error and stop

# /spearit-framework:backlog - Backlog Review and Prioritization

Review backlog items, identify what's ready to pull into todo, and flag stale or blocked candidates.

---

## Role & Mindset

**For this command, adopt a Discerning Project Manager mindset:**

### Core Responsibilities
- Surface what's ready to act on — don't just list, recommend
- Flag items that may need attention: stale, dependency-blocked, or ambiguous
- End with a clear prompt: what should move forward this session?

### Key Behaviors
- Read dependency fields and reason about whether they're met
- Items with no unmet dependencies and clear scope are pull candidates
- Items older than 90 days that haven't moved are worth flagging
- The list is a starting point for a decision, not just an inventory

---

## Usage

```
/spearit-framework:backlog [subcommand] [item-id]
```

## Subcommands

- `(none)` — List all backlog items (compact table)
- `full` — List all backlog items with full summaries
- `detail <item-id>` — Show full details for a specific item
- `prioritize` — Interactive prioritization: step through items one at a time

---

## Execution

Run this bash script to gather raw file data, then render the output using AI synthesis as described below.

```bash
#!/usr/bin/env bash
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "Not a git repo"; exit 1; }
cd "$REPO_ROOT"

BACKLOG_DIR="project-hub/work/backlog"

if [ ! -d "$BACKLOG_DIR" ]; then
  echo "No backlog/ folder found."
  exit 0
fi

FILES=$(find "$BACKLOG_DIR" -maxdepth 1 -name "*.md" | sort)
COUNT=$(echo "$FILES" | grep -c . || echo 0)

echo "Total: $COUNT"
echo "=== ITEMS ==="

echo "$FILES" | while read -r f; do
  [ -z "$f" ] && continue
  fname=$(basename "$f")

  # Extract metadata fields
  id=$(grep -m1 '^\*\*ID:\*\*' "$f" 2>/dev/null | sed 's/\*\*ID:\*\*\s*//' | tr -d ' \r')
  type=$(grep -m1 '^\*\*Type:\*\*' "$f" 2>/dev/null | sed 's/\*\*Type:\*\*\s*//' | tr -d '\r')
  impact=$(grep -m1 '^\*\*Version Impact:\*\*' "$f" 2>/dev/null | sed 's/\*\*Version Impact:\*\*\s*//' | tr -d '\r')
  created=$(grep -m1 '^\*\*Created:\*\*' "$f" 2>/dev/null | sed 's/\*\*Created:\*\*\s*//' | tr -d '\r')
  depends=$(grep -m1 '^\*\*Depends On:\*\*' "$f" 2>/dev/null | sed 's/\*\*Depends On:\*\*\s*//' | tr -d '\r')

  # Extract title from first heading, strip type prefix and ID prefix
  title=$(grep -m1 '^# ' "$f" 2>/dev/null \
    | sed 's/^# //' \
    | sed 's/^[A-Za-z][A-Za-z ]*: //' \
    | sed 's/^[A-Z]*-[0-9]*[:.] *//' \
    | tr -d '\r')

  # Extract first paragraph of Summary section
  summary=$(awk '/^## Summary/{found=1; next} found && /^## /{exit} found && NF{print; exit}' "$f" 2>/dev/null | tr -d '\r')

  echo "FILE: $fname"
  echo "ID: ${id:-unknown}"
  echo "TYPE: ${type:-unknown}"
  echo "IMPACT: ${impact:-unknown}"
  echo "CREATED: ${created:-unknown}"
  echo "DEPENDS: ${depends:-}"
  echo "TITLE: ${title:-}"
  echo "SUMMARY: ${summary:-}"
  echo "---"
done
```

For `detail <item-id>`: Read the specific file directly with the Read tool. No script needed.

---

## Output Format

### List View (default)

Parse the script output and render a formatted table. Use AI judgment to identify pull-ready candidates.

```
Backlog Review
──────────────────────────────────────────────────────────────

12 items in backlog

ID            Type        Impact   Created      Summary
──────────────────────────────────────────────────────────────────
FEAT-037      Feature     MINOR    2026-01-10   Project config file
FEAT-038      Feature     MINOR    2026-01-11   Template validation
BUGFIX-012    Bugfix      PATCH    2026-01-12   Fix path handling
TECH-033      Tech Debt   PATCH    2026-01-08   Status field review

⬆ Ready for todo (no unmet dependencies):
  Bugs (1):      BUGFIX-012
  Features (1):  FEAT-037
  Tech Debt (1): TECH-033

⚠ Stale (>90 days, never started):
  TECH-033 (created 2025-10-01)

To move an item to todo:
  /spearit-framework:move <id> todo
```

**Ready for todo logic:**
- `Depends On:` field is empty, "None", or all referenced IDs are in done/
- Item has no obvious blockers in its content
- Group by ID prefix (BUG → Bugs, FEAT → Features, TECH → Tech Debt, everything else → Other)

**Stale logic:**
- Created date > 90 days ago from today
- Still in backlog/ (never moved)

### Full View (`full`)

Same table, but replace truncated Summary column with full summary text below each row (word-wrapped).

### Detail View (`detail <item-id>`)

Read the file directly and display:

```
FEAT-037: Project Config File
──────────────────────────────────────────────────────────────

Type: Feature
Version Impact: MINOR
Created: 2026-01-10
Depends On: None

Summary:
Add project-config.yaml file for multi-project repositories
to enable context switching between projects.

Problem:
Currently, CLAUDE.md at root must manually direct to correct
project CLAUDE.md. A config file would automate this.

To pull to todo:
  /spearit-framework:move FEAT-037 todo
```

### Interactive Prioritization (`prioritize`)

Step through backlog items one at a time. For each item:

1. Show compact summary (ID, type, title, created, depends)
2. Offer: `[T] Pull to todo  [K] Keep in backlog  [D] Show details  [S] Skip`
3. Wait for user response before proceeding to next item
4. At the end, summarize: items pulled, items kept, items skipped

Pull candidates go first. Stale items go last.

After each `[T]` response:
> "To move this: `/spearit-framework:move <ID> todo`"

---

## Examples

```
/spearit-framework:backlog                      # List all (compact)
/spearit-framework:backlog full                 # List with full summaries
/spearit-framework:backlog detail FEAT-037      # Full details for one item
/spearit-framework:backlog prioritize           # Interactive session
```

---

## Edge Cases

- **Empty backlog**: `No items in backlog. Nothing to review.`
- **All items have unmet dependencies**: Note this — the backlog may be blocked on in-flight work
- **Malformed metadata**: Show item with `(unknown)` fields, don't skip it
- **Item ID not found** (detail subcommand): Report not found, list available IDs

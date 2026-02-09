# /spearit-framework-light:next-id - Get Next Available Work Item ID

Returns the next available work item ID from the common namespace.

## Usage

```
/spearit-framework-light:next-id
```

## Behavior (Standalone - No Scripts Required)

**This command works in any project without external dependencies.**

### Step 1: Scan for Existing IDs

Search for work items in these locations (if they exist):
- `project-hub/work/backlog/`
- `project-hub/work/todo/`
- `project-hub/work/doing/`
- `project-hub/work/done/`
- `project-hub/history/archive/`
- `project-hub/history/releases/*/`

### Step 2: Extract ID Numbers

From filenames matching pattern: `{TYPE}-{NNN}-*.md`
- Examples: `FEAT-042-*.md`, `BUGFIX-018-*.md`, `TECH-099-*.md`
- Extract the numeric ID (NNN)
- Types: FEAT, BUGFIX, TECH, SPIKE, DECISION, REFACTOR, DOC, etc.

### Step 3: Determine Next ID

1. Find the highest ID number across all work items
2. Add 1 to get the next available ID
3. Format as 3-digit zero-padded number (e.g., 042 → 043)

### Step 4: Handle Edge Cases

**Case 1: No project-hub/ structure exists**
- Report: "No project-hub/ structure found. Starting at ID: 001"
- Offer: "Would you like me to create the project-hub/ structure?"

**Case 2: Structure exists but no work items**
- Report: "No existing work items found. Starting at ID: 001"

**Case 3: Work items exist**
- Report: "Next available work item ID: {NNN}" (where NNN is highest + 1)

## Example Output

```
Scanning for existing work items...
Found highest ID: 067 (FEAT-067-authentication-system.md)

Next available work item ID: 068
```

Or if no structure:

```
No project-hub/ structure found.
Starting at ID: 001

Would you like me to create the project-hub/work/ structure?
```

## How to Use the Result

When creating a new work item, use this ID:

```
FEAT-068-my-feature-description.md
BUGFIX-068-fix-something.md
TECH-068-refactor-component.md
```

## For AI Assistants

**Implementation Instructions:**

**CRITICAL: Do NOT use Task tool or spawn agents. This must be done directly with Glob tool and simple regex parsing.**

When the user runs `/spearit-framework-light:next-id`:

1. **Use Glob tool ONLY** to search for work items:
   ```
   Call Glob with pattern: project-hub/work/**/*.md
   Call Glob with pattern: project-hub/history/**/*.md
   ```

2. **YOU parse the filenames directly** (no Task agent needed):
   - Regex pattern: `([A-Z]+)-(\d{3})-.*\.md`
   - Extract group 2 (the numeric portion)
   - Example: `FEAT-042-description.md` → extract "042"
   - Convert each to integer: "042" → 42

3. **YOU find maximum ID directly** (no Task agent needed):
   - Take all extracted integers
   - Use simple max() operation
   - Add 1 to get next ID

4. **Format result:**
   - Zero-pad to 3 digits
   - Example: 43 → "043"

5. **Report to user:**
   ```
   Found highest ID: {current_max} ({example_filename})
   Next available work item ID: {next_id}
   ```

**PERFORMANCE REQUIREMENT:** This command should complete in under 5 seconds and use under 1k tokens. It is a simple file scanning and regex operation - NO AI reasoning or Task agents required.

**Error Handling:**

- If glob fails or returns empty, assume no structure exists
- If ID extraction fails for some files, skip those files
- Always return a valid 3-digit ID number

**No External Scripts Required:**
This command is fully self-contained and works using Claude's native tools (Glob, file reading). No PowerShell, bash scripts, or external dependencies.

---

**Standalone Operation:** This command requires no framework installation. It works in any project by scanning the file system directly.

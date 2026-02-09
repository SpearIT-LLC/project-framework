# /spearit-framework-light:new - Create New Work Item

Create a new work item interactively with prompts for type, title, priority, and summary.

## Usage

```
/spearit-framework-light:new
```

## What This Command Does

This command guides you through creating a new work item:
1. Prompts for work item type
2. Prompts for title
3. Prompts for priority
4. Optionally prompts for summary
5. Generates next available ID automatically
6. Creates file in `project-hub/work/backlog/`
7. Git adds the file
8. Confirms creation with file path

## Interactive Prompts

### 1. Work Item Type

**Prompt:** "What type of work item?"

**Valid types:**
- `FEAT` - New feature or functionality
- `BUG` - Bug fix
- `CHORE` - Maintenance task (dependencies, tooling, etc.)
- `TASK` - General task
- `DOCS` - Documentation
- `REFACTOR` - Code refactoring
- `DECISION` - Architectural or design decision
- `TECH` - Technical improvement or debt

**Example:**
```
What type of work item? FEAT
```

### 2. Title

**Prompt:** "What is the title?" (short description)

**Guidelines:**
- Short, descriptive phrase
- Will be converted to kebab-case for filename
- Examples:
  - "Add dark mode"
  - "Fix login redirect"
  - "Update dependencies"

**Example:**
```
What is the title? Add dark mode
```

### 3. Priority

**Prompt:** "What is the priority?"

**Valid priorities:**
- `High` - Critical or urgent work
- `Medium` - Normal priority (default)
- `Low` - Nice to have, not urgent

**Example:**
```
What is the priority? High
```

### 4. Summary (Optional)

**Prompt:** "Provide a brief summary (or press Enter to use 'TBD'):"

**Guidelines:**
- 1-3 sentences describing the work
- Can skip by pressing Enter (uses "TBD")
- Can be filled in later

**Example:**
```
Provide a brief summary: Implement dark mode theme with toggle in settings
```

Or:
```
Provide a brief summary: [Enter]
(Uses "TBD")
```

## File Creation

### Generated Filename

Pattern: `{TYPE}-{ID}-{kebab-case-title}.md`

**Examples:**
- `FEAT-001-add-dark-mode.md`
- `BUG-042-fix-login-redirect.md`
- `CHORE-099-update-dependencies.md`

### File Template

```markdown
# {Type}: {Title}

**ID:** {TYPE-ID}
**Type:** {Type}
**Priority:** {Priority}
**Created:** {Date}

---

## Summary

{User-provided summary or "TBD"}

---

## Problem Statement

[To be filled in]

---

## Requirements

[To be filled in]

---

## Acceptance Criteria

- [ ] [To be filled in]

---

## Notes

[Optional notes]

---

**Last Updated:** {Date}
**Status:** Backlog
```

### Location

All new work items are created in: `project-hub/work/backlog/`

**Rationale:**
- New items start in backlog (not immediately ready for work)
- Allows time for refinement before committing to todo
- Consistent with framework workflow: backlog → todo → doing → done
- User can immediately move with `:move` if ready

## Success Output

```
Creating new work item...

Type: FEAT
Title: Add dark mode
Priority: High
Summary: Implement dark mode theme with toggle in settings
Next ID: 043

✓ Created: project-hub/work/backlog/FEAT-043-add-dark-mode.md
✓ Git added successfully

Work item ready! Use /spearit-framework-light:move FEAT-043 todo when ready to commit to it.
```

## Graceful Degradation

### Case 1: No project-hub/ structure exists

**Behavior:**
- Creates `project-hub/work/backlog/` directory
- Creates work item as first item (ID 001)
- Informs user structure was created

**Output:**
```
No project-hub/ structure found. Creating minimal structure...

✓ Created: project-hub/work/backlog/
✓ Created: project-hub/work/backlog/FEAT-001-add-dark-mode.md
✓ Git added successfully

Tip: This is your first work item! The plugin created the minimal folder structure.
     You can expand the structure later or continue with just backlog/ for now.
```

### Case 2: Structure exists but no work items

**Behavior:**
- Uses existing structure
- Creates first work item (ID 001)

### Case 3: Work items exist

**Behavior:**
- Scans for highest existing ID
- Uses next available ID
- Creates work item normally

## Error Handling

### Invalid Type

```
❌ Invalid work item type: "feat"
   Valid types: FEAT, BUG, CHORE, TASK, DOCS, REFACTOR, DECISION, TECH

Would you like to retry?
```

### Invalid Priority

```
❌ Invalid priority: "urgent"
   Valid priorities: High, Medium, Low

Would you like to retry?
```

### Empty Title

```
❌ Title cannot be empty.

Please provide a short description of the work item.
```

### File Creation Failed

```
❌ Failed to create work item file.
   Error: [specific error message]

Please check permissions and try again.
```

### Git Add Failed

```
⚠️  Work item created but git add failed.
   File: project-hub/work/backlog/FEAT-043-add-dark-mode.md

You may need to add it manually: git add project-hub/work/backlog/FEAT-043-add-dark-mode.md
```

## For AI Assistants

**Implementation Instructions:**

**CRITICAL: Do NOT use Task tool or spawn agents. This must be done directly with AskUserQuestion and file operations.**

When the user runs `/spearit-framework-light:new`:

### Step 1: Get Next ID

**Reuse `:next-id` logic:**
1. Use Glob to scan: `project-hub/work/**/*.md` and `project-hub/history/**/*.md`
2. Parse filenames with regex: `([A-Z]+)-(\d{3})-.*\.md`
3. Extract numeric IDs, find max, add 1
4. If no files found, start at 001

### Step 2: Prompt for Details

**Use AskUserQuestion tool for interactive prompts:**

```javascript
AskUserQuestion({
  questions: [
    {
      question: "What type of work item?",
      header: "Type",
      multiSelect: false,
      options: [
        { label: "FEAT - New feature", description: "New feature or functionality" },
        { label: "BUG - Bug fix", description: "Fix a bug or defect" },
        { label: "CHORE - Maintenance", description: "Dependencies, tooling, maintenance" },
        { label: "TASK - General task", description: "General task or work item" },
        { label: "DOCS - Documentation", description: "Documentation updates" },
        { label: "REFACTOR - Refactoring", description: "Code refactoring" },
        { label: "DECISION - Decision", description: "Architectural or design decision" },
        { label: "TECH - Technical", description: "Technical improvement or debt" }
      ]
    },
    {
      question: "What is the title? (short description)",
      header: "Title",
      // Text input via "Other" option
    },
    {
      question: "What is the priority?",
      header: "Priority",
      multiSelect: false,
      options: [
        { label: "High", description: "Critical or urgent work" },
        { label: "Medium", description: "Normal priority" },
        { label: "Low", description: "Nice to have, not urgent" }
      ]
    },
    {
      question: "Provide a brief summary (optional - can be filled in later):",
      header: "Summary",
      // Text input via "Other" option, allow skip
    }
  ]
})
```

### Step 3: Sanitize Title

**Convert title to kebab-case for filename:**
1. Convert to lowercase
2. Replace spaces with hyphens
3. Remove special characters (keep alphanumeric and hyphens)
4. Collapse multiple hyphens to single hyphen
5. Trim leading/trailing hyphens

**Examples:**
- "Add dark mode" → "add-dark-mode"
- "Fix: Login Redirect" → "fix-login-redirect"
- "Update dependencies (npm)" → "update-dependencies-npm"

### Step 4: Generate Filename

Pattern: `{TYPE}-{ID}-{sanitized-title}.md`

**Examples:**
- Type: FEAT, ID: 043, Title: "Add dark mode" → `FEAT-043-add-dark-mode.md`
- Type: BUG, ID: 018, Title: "Fix Login" → `BUG-018-fix-login.md`

### Step 5: Create File

**File content:**
```markdown
# {Type}: {Original Title}

**ID:** {TYPE-ID}
**Type:** {Type}
**Priority:** {Priority}
**Created:** {Current Date YYYY-MM-DD}

---

## Summary

{Summary or "TBD"}

---

## Problem Statement

[To be filled in]

---

## Requirements

[To be filled in]

---

## Acceptance Criteria

- [ ] [To be filled in]

---

## Notes

[Optional notes]

---

**Last Updated:** {Current Date YYYY-MM-DD}
**Status:** Backlog
```

### Step 6: Create Directory (if needed)

**If `project-hub/work/backlog/` doesn't exist:**
1. Create the directory structure
2. Inform user: "Created minimal project-hub/work/backlog/ structure"

### Step 7: Write File

Use Write tool to create: `project-hub/work/backlog/{filename}`

### Step 8: Git Add

**Execute:**
```bash
git add project-hub/work/backlog/{filename}
```

**Handle errors gracefully:**
- If git add fails (not a git repo, permissions, etc.), warn but don't fail
- User can add manually if needed

### Step 9: Confirm Success

**Output format:**
```
Creating new work item...

Type: {TYPE}
Title: {Title}
Priority: {Priority}
Summary: {Summary or "TBD"}
Next ID: {ID}

✓ Created: project-hub/work/backlog/{filename}
✓ Git added successfully

Work item ready! Use /spearit-framework-light:move {TYPE-ID} todo when ready to commit to it.
```

**PERFORMANCE REQUIREMENT:** This command should complete in under 30 seconds total. Use efficient file operations and avoid unnecessary steps.

**Error Handling:**
- Validate all inputs before creating file
- Provide helpful error messages
- Allow retry on validation failures
- Handle missing directories gracefully
- Handle git errors gracefully (warn but don't fail)

**No External Scripts Required:**
This command is fully self-contained and works using Claude's native tools (AskUserQuestion, Write, Glob, Bash for git). No PowerShell, bash scripts, or external dependencies.

---

## Examples

### Example 1: Full Workflow

```
User: /spearit-framework-light:new

[Interactive prompts]
Type: FEAT
Title: Add user authentication
Priority: High
Summary: Implement JWT-based authentication with login/logout

✓ Created: project-hub/work/backlog/FEAT-043-add-user-authentication.md
✓ Git added successfully

User: /spearit-framework-light:move FEAT-043 todo
✓ Moved to todo/

User: /spearit-framework-light:move FEAT-043 doing
✓ Moved to doing/ - Ready to start work
```

### Example 2: Quick Creation (TBD Summary)

```
User: /spearit-framework-light:new

Type: CHORE
Title: Update dependencies
Priority: Medium
Summary: [Enter - uses TBD]

✓ Created: project-hub/work/backlog/CHORE-044-update-dependencies.md
```

### Example 3: First Work Item (No Structure)

```
User: /spearit-framework-light:new

No project-hub/ structure found. Creating minimal structure...

Type: FEAT
Title: Setup project
Priority: High
Summary: Initial project setup and configuration

✓ Created: project-hub/work/backlog/
✓ Created: project-hub/work/backlog/FEAT-001-setup-project.md
✓ Git added successfully

Tip: This is your first work item! You can expand the structure later.
```

---

**Standalone Operation:** This command requires no framework installation. It works in any project and creates the minimal structure needed.

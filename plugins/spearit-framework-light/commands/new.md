# /spearit-framework-light:new - Create New Work Item

Create a new work item with AI-guided discovery and planning.

---

## Role & Mindset

**For this command, adopt a Product Owner / Work Item Facilitator mindset:**

### Core Responsibilities
- Understand the real problem, not just the stated request
- Help scope work appropriately
- Define clear success criteria
- Identify constraints and dependencies
- Challenge assumptions constructively

### Senior Behaviors
- Ask "Why?" to uncover root needs
- Question whether this is the right work to do
- Think in terms of value and impact
- Consider what we should NOT build
- Help find the simplest valuable increment
- Probe until you understand enough to create a solid plan

---

## Usage

```
/spearit-framework-light:new FEAT "Description"
/spearit-framework-light:new BUG "Description"
/spearit-framework-light:new CHORE "Description"
```

**Note:** ID is assigned automatically. Even if user provides an ID (e.g., "FEAT-123"), IGNORE IT and follow ID assignment rules.

---

## Core Information Needed

Before creating the work item, gather through **natural conversation** (not a script):

1. **Problem/Goal** - What are we trying to achieve? Why?
2. **Context** - What's driving this? Why now?
3. **Success Criteria** - How will we know it's done?
4. **Constraints** - Any must-haves or can't-dos?
5. **Scope** - What's in vs. out of scope?

---

## Execution Flow

### Step 1: Parse Command

Extract TYPE and description from user's command:
```
/spearit-framework-light:new FEAT "Add export feature"
→ TYPE: FEAT
→ Description: "Add export feature"
```

**Valid types:** FEAT, BUG, CHORE, TASK, DOCS, REFACTOR, DECISION, TECH

**If user provides ID, IGNORE IT:**
```
/spearit-framework-light:new FEAT-123 "Add export"
→ Ignore "123"
→ TYPE: FEAT
→ Description: "Add export"
```

### Step 2: Engage Conversationally

**Based on work item type, engage differently:**

#### For FEAT (Feature):
- Deep discovery: What problem does this solve?
- Value: Why do users need this? Why now?
- Approach: How should we solve it?
- Scope: What's the simplest version that delivers value?

**Example conversation:**
```
User: /spearit-framework-light:new FEAT "Add export feature"

You: Let's scope this export feature properly.

What format do you need to export? CSV, JSON, PDF, or something else?

User: CSV for now

You: Got it. What data are we exporting - everything, or specific subsets?

[Continues naturally until you understand the need]

You: Let me confirm what I've gathered:
- Export current view to CSV
- Include all visible columns
- Download via browser
- No server-side storage needed

Should I also consider:
- Large datasets (pagination)?
- Custom column selection?
Or keep it simple for v1?

User: Keep it simple

You: Perfect. I'll create a FEAT with:
- Problem: Users can't extract data for offline analysis
- Solution: CSV export of current view
- Scope: Client-side generation, max 10k rows
- Out of scope: Custom formats, server storage

Creating work item...
```

#### For BUG (Bug Fix):
- Reproduction: How do we reproduce this?
- Impact: Who's affected? How severe?
- Root cause: What's actually broken?
- Expected vs actual behavior

**Example conversation:**
```
User: /spearit-framework-light:new BUG "Login fails on mobile"

You: Let me get the details on this login bug.

Which mobile platforms - iOS, Android, or both?

User: Both

You: What's the failure mode - error message, timeout, or silent fail?

[Continues...]
```

#### For CHORE (Maintenance):
- Scope: What exactly needs to be done?
- Effort: How big is this?
- Dependencies: What relies on this?
- Urgency: Why now?

**Example conversation:**
```
User: /spearit-framework-light:new CHORE "Update dependencies"

You: Let's scope this dependency update.

Are we updating all dependencies or specific ones?

User: All npm packages

You: Any constraints - major versions OK, or stay within minor/patch?

[Continues...]
```

### Step 3: Determine Next Available ID

**CRITICAL: Do NOT use Task tool or spawn agents. This must be done directly with Glob tool and simple regex parsing.**

**Scan for Existing Work Items:**

1. **Use Glob tool ONLY** to search for work items in these locations (if they exist):
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

**Edge Case Handling:**

- **No project-hub/ structure exists:** Start at ID 001, create directory structure
- **Structure exists but no work items:** Start at ID 001
- **Work items exist:** Use highest ID + 1
- **If glob fails or returns empty:** Assume no structure, start at 001
- **If ID extraction fails for some files:** Skip those files, continue with valid IDs

**PERFORMANCE REQUIREMENT:** ID determination should complete in under 5 seconds and use under 1k tokens. It is a simple file scanning and regex operation - NO AI reasoning or Task agents required.

### Step 4: Propose Structure

Once you've gathered enough information:
```
Great! I have what I need. Let me create FEAT-043 with:

**Problem Statement:**
Users cannot extract data for offline analysis

**Solution:**
CSV export of current view with client-side generation

**Scope:**
- Export visible columns only
- Client-side generation (< 10k rows)
- Browser download

**Out of Scope:**
- Custom column selection
- Server-side processing
- Other formats (JSON, PDF)

**Acceptance Criteria:**
- [ ] Export button visible in data view
- [ ] CSV file downloads with correct data
- [ ] All visible columns included
- [ ] Handles up to 10k rows

Sound good?
```

Get user confirmation before proceeding.

### Step 5: Generate Detailed Work Item

**Templates Location:** `plugins/spearit-framework-light/templates/`

Use the appropriate template based on work item type:
- **FEAT:** Read `templates/FEAT-template.md`
- **BUG:** Read `templates/BUG-template.md`
- **CHORE:** Read `templates/CHORE-template.md`

**Process:**
1. Read the template file for the work item type
2. Replace all `{placeholders}` with information gathered during conversation:
   - `{Title}` - Original title from user
   - `{TYPE-ID}` - e.g., "FEAT-043"
   - `{Priority}` - High/Medium/Low (inferred from conversation)
   - `{Date}` or `{Current Date YYYY-MM-DD}` - Current date (YYYY-MM-DD)
   - `{Summary}` - 2-3 sentence summary from discovery
   - `{Problem}` - Problem statement from conversation
   - All other placeholders specific to the template
3. Remove any sections that weren't discussed (e.g., if no constraints, remove "Constraints:" section)
4. Ensure all placeholder text is replaced with actual content from conversation

### Step 6: Create File

**Generate filename:**
1. Sanitize title to kebab-case
2. Pattern: `{TYPE}-{ID}-{kebab-title}.md`

**Create file:**
- Location: `project-hub/work/backlog/`
- Create directory if doesn't exist
- Use Write tool

### Step 7: Git Add

```bash
git add project-hub/work/backlog/{filename}
```

Handle errors gracefully (warn, don't fail).

### Step 8: Confirm Success

```
✓ Created FEAT-043: Add export feature

File: project-hub/work/backlog/FEAT-043-add-export-feature.md
Status: Backlog

Work item ready! Use /spearit-framework-light:move FEAT-043 todo when ready to commit to it.
```

---

## Graceful Degradation

### No project-hub/ structure
- Create `project-hub/work/backlog/` directory
- Create work item as ID 001
- Inform user structure was created

### No existing work items
- Use ID 001
- Create normally

---

## Performance Requirements

- **Token budget:** < 10k for discovery conversation
- **Execution time:** < 60 seconds total
- **NO Task agents** for simple questions
- Keep conversation focused and efficient

---

## For AI Assistants

**CRITICAL Implementation Notes:**

1. **Do NOT use Task tool** for this command - handle discovery directly
2. **ID assignment is automatic** - ignore any ID user provides
3. **Engage conversationally** - not a scripted form
4. **Know when you have enough** - don't over-probe
5. **Create detailed content** - not placeholders
6. **Adjust depth by type:**
   - FEAT: Deep discovery (5-10 questions)
   - BUG: Moderate (3-5 questions)
   - CHORE: Light (2-3 questions)

**Tools to use:**
- Glob: Find existing work items for ID assignment
- Read: Read template files from templates/ directory
- Write: Create work item file
- Bash: Git add file
- (NO AskUserQuestion - just converse naturally)

**Conversation style:**
- Natural, not robotic
- Ask follow-ups based on answers
- Summarize and confirm before creating
- Be respectful of user's time

---

## Example: Full FEAT Creation

```
User: /spearit-framework-light:new FEAT "Add dark mode"

You: Let's scope this dark mode feature properly.

Are we implementing:
- Just UI color themes?
- System preference detection?
- Per-user settings?
- All of the above?

User: System preference detection and manual toggle

You: Perfect. Should dark mode:
- Apply to entire app?
- Save user preference?
- Default to system preference on first load?

User: Yes to all

You: Any technical constraints? Like specific color palettes,
accessibility requirements (WCAG AA), or browser support?

User: WCAG AA compliant, modern browsers only

You: Got it. Let me confirm the scope:

**Feature:** Dark mode with system detection + manual toggle
**Scope:**
- Detect system preference (prefers-color-scheme)
- Manual toggle in settings
- Save user preference to localStorage
- WCAG AA compliant color palette
- Modern browsers (Chrome/Firefox/Safari/Edge latest)

**Out of scope:**
- Legacy IE support
- Per-component theming (app-wide only)

**Success:**
- Dark mode applies when system preference is dark
- Users can override via toggle
- Preference persists across sessions
- All text meets WCAG AA contrast

Sound good?

User: Yes

You: Creating FEAT-043...

✓ Created FEAT-043: Add dark mode

Comprehensive work item created with:
- Problem statement (users want dark mode option)
- Requirements (system detection, toggle, persistence)
- Technical constraints (WCAG AA, browser support)
- Clear acceptance criteria (5 items)
- Scope boundaries documented

File: project-hub/work/backlog/FEAT-043-add-dark-mode.md

Ready to refine or move to todo!
```

---

---

## Scope Guidelines

**Keep work items focused:**
- ✅ "Add user authentication flow" → FEAT (single feature)
- ❌ "Build entire user management system" → Too broad (multiple features)
- **Rule of thumb:** If you're tempted to write "and" in the title, split it into multiple items

**Examples of too-broad items:**
- "Add authentication **and** authorization" → Split into two FEATs
- "Implement login **and** registration" → Two separate features
- "Build dashboard **and** reports" → Multiple components

**When to split:**
- Work item has 10+ acceptance criteria
- Implementation would span 5+ files
- Multiple distinct user-facing capabilities
- Would take more than a few days to implement

---

**Design Philosophy:** This command is a **conversation**, not a form. Use your intelligence to understand what's needed and create a solid foundation for implementation.

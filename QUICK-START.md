# SpearIT Project Framework - Quick Start

**Purpose:** Comprehensive quick reference for working with the framework.
**For overview:** See [README.md](README.md) for project introduction and philosophy.

**Last Updated:** 2026-02-19

**See It In Action:** Extract the framework distribution and run `Setup-Framework.ps1` to scaffold a new project.

---

## 1. Setup Your Project

### Quick Setup
```bash
# 1. Extract the framework distribution archive (replace X.Y.Z with your version)
Expand-Archive .\spearit_framework_vX.Y.Z.zip

# 2. Run the setup script (prompts for project details)
cd .\spearit_framework_vX.Y.Z
.\Setup-Framework.ps1
```

**After Setup:**
- Review [NEW-PROJECT-CHECKLIST.md](NEW-PROJECT-CHECKLIST.md) for post-setup tasks
- Author info stored in `framework.yaml` (Source of Truth)

**Detailed Setup:** [NEW-PROJECT-CHECKLIST.md](NEW-PROJECT-CHECKLIST.md)

---

## 2. First Steps After Setup

1. Review the starter template: [templates/starter/](templates/starter/)
2. Update README.md with project details
3. Set initial version in PROJECT-STATUS.md
4. Complete research phase (use templates from `framework/templates/research/`)
5. Plan features in `project-hub/work/backlog/`
6. Move features through workflow: `work/todo/` → `work/doing/` → `work/done/`
7. Update CHANGELOG.md and PROJECT-STATUS.md for releases

**Detailed Workflow:** See [workflow-guide.md](framework/docs/collaboration/workflow-guide.md)

---

## 3. Common Operations

### Work Item Types

Work items are markdown files named `{TYPE}-{NNN}-{slug}.md`.

The **accepted types** are the single source of truth in
[.claude/scripts/work-item-types.txt](.claude/scripts/work-item-types.txt) (ADR-006) — creation is
enforced against it, so it cannot drift. **When to use each type** is explained in
[workflow-guide.md](framework/docs/collaboration/workflow-guide.md#work-item-templates). Templates
live in `framework/templates/work-items/`.

**Workflow:**
- Create in `project-hub/work/backlog/`
- Move to `todo/` when committing to work
- Move to `doing/` when starting (WIP limit: 1)
- Move to `done/` when complete

**With AI:** Just ask "Create a feature for user authentication" — the AI picks the type and template.

### Create Release
```bash
# 1. Update CHANGELOG.md with changes
# 2. Update PROJECT-STATUS.md with new version
# 3. Commit
git add -A
git commit -m "Release: vX.Y.Z"
git tag vX.Y.Z
git push origin main --tags

# 4. Move completed work to history/releases/
```

### End of Day
```bash
# Create session history from framework template
cp framework/templates/documentation/session-history-template.md \
   project-hub/history/sessions/YYYY-MM-DD-session-N.md
# Document what you did, decisions made, blockers
```

---

## 4. Framework Commands

When working with AI assistants, framework commands (`/fw-*`) provide shortcuts for common workflow operations.

**To see what is available, run `/fw-help`.** It reads the installed commands, so it is never out of
date — unlike a list in a document.

### Quick Examples

```
/fw-status                  # Show project status
/fw-wip                     # Check WIP limit
/fw-move FEAT-042 todo      # Move item to todo/
/fw-backlog                 # Review backlog items
/fw-next-id                 # Get next work item number
/fw-help move               # Get help on /fw-move
```

**Full Reference:** [framework/docs/ref/framework-commands.md](framework/docs/ref/framework-commands.md)

---

## 5. Key Framework Rules

- **Single Source of Truth:** Version and status ONLY in PROJECT-STATUS.md
- **Update "Last Updated":** When content materially changes (not typos)
- **Semantic Versioning:** MAJOR.MINOR.PATCH (breaking.feature.bugfix)
- **WIP Limits:** Max 1 item in `work/doing/` at once (check `.limit` file)
- **Research First:** Complete research phase before coding new projects
- **Document Decisions:** Use ADRs for technical choices with alternatives
- **Work Item Flow:** backlog → todo → doing → done → history/releases/{product}/{version}/

---

## 6. Quick Troubleshooting

**Problem:** "Too much documentation overhead"
→ **Solution:** Start simple with just README and PROJECT-STATUS. Add structure progressively as your project grows.

**Problem:** "Lost in the kanban workflow"
→ **Solution:** Think: backlog (someday) → todo (planned) → doing (now, max 1) → done (shipped)

**Problem:** "When do I create an ADR?"
→ **Solution:** When you choose between 2+ approaches OR make a decision future-you needs context for

---

## 7. Essential Links

| What You Need | Document | Time to Read |
|--------------|----------|--------------|
| Full overview | [README.md](README.md) | 10 min |
| Starter template | [templates/starter/](templates/starter/) | 5 min |
| Setup instructions | [NEW-PROJECT-CHECKLIST.md](templates/NEW-PROJECT-CHECKLIST.md) | 15 min |
| Current version/status | [framework/PROJECT-STATUS.md](framework/PROJECT-STATUS.md) | 2 min |
| Change history | [framework/CHANGELOG.md](framework/CHANGELOG.md) | 5 min |
| All documentation | [framework/INDEX.md](framework/INDEX.md) | 3 min |
| File structure | [STRUCTURE.md](templates/STRUCTURE.md) | 5 min |

---

## 8. Templates

| Kind | Location |
|------|----------|
| Work items | `framework/templates/work-items/` |
| ADRs | `framework/templates/decisions/` |
| Session history | `framework/templates/documentation/` |
| Research phase | `framework/templates/research/` |

**Accepted work item types:** see §3 above.

**Research Phase Templates** (in `framework/templates/research/`):
- Problem statement - What problem are we solving?
- Landscape analysis - What solutions exist?
- Feasibility assessment - Can/should we build this?
- Project justification - BUILD/BUY/ADAPT/ABANDON decision
- Project definition - What exactly are we building?

---

## 9. Workflow Cheat Sheet

```
NEW PROJECT:
  Research → Define → Plan → Code → Release
  │         │        │       │       │
  │         │        │       │       └─ Update CHANGELOG + PROJECT-STATUS
  │         │        │       └───────── Implement in work/doing/
  │         │        └───────────────── Break into features in work/backlog/
  │         └────────────────────────── Write project-definition.md
  └──────────────────────────────────── Complete research templates

DAILY WORK:
  work/backlog/ → work/todo/ → work/doing/ (max 1) → work/done/ → history/releases/{product}/{version}/

  At end of day: Document in history/sessions/YYYY-MM-DD-session-N.md
```

---

## 10. Getting Help

- **Framework terminology:** [GLOSSARY.md](framework/docs/ref/GLOSSARY.md)
- **See starter template:** [templates/starter/](templates/starter/)
- **Framework structure questions:** [STRUCTURE.md](templates/STRUCTURE.md)
- **Workflow questions:** [workflow-guide.md](framework/docs/collaboration/workflow-guide.md)
- **Complete doc index:** [framework/INDEX.md](framework/INDEX.md)
- **Maintainer:** gary.elliott@spearit.solutions

---

**Remember:** The framework serves you, not the other way around. If something feels like overhead, you're over-engineering. Start simple, add structure progressively as your project grows.

---

**Next Steps:**
1. Run setup commands (section 1)
2. Follow first steps (section 2)
3. Start building!

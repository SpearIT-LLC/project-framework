# SpearIT Project Framework - Quick Start

**Version:** 2.2.x | **Last Updated:** 2026-01-06 | **Need Details?** See [README.md](README.md)

**See It In Action:** Check out [project-hello-world/](project-hello-world/) for a complete working example.

---

## 1. Choose Your Framework Level (30 seconds)

```
Do you have 3+ files AND ongoing maintenance?
├─ NO  → Minimal (2 files, 10 min setup)
└─ YES → Is this for a team OR requires formal planning?
         ├─ NO  → Light (7 files, 45 min setup)
         └─ YES → Standard (50+ files, 3 hr setup)
```

**Still unsure?** See [README-TEMPLATE-SELECTION.md](project-templates/README-TEMPLATE-SELECTION.md)

---

## 2. Setup Commands (15 seconds)

### Minimal Framework (Single Scripts)
```bash
cd /path/to/your-project
cp /path/to/framework/project-templates/minimal/README.md .
# Edit README.md, add your code
```

### Light Framework (Small Tools)
```bash
cd /path/to/your-project
cp -r /path/to/framework/project-templates/light/* .
# Edit README.md, PROJECT-STATUS.md, CHANGELOG.md
```

### Standard Framework (Applications)
```bash
cd /path/to/your-project
cp -r /path/to/framework/project-templates/standard/* .
cp -r /path/to/framework/project-templates/standard/.gitignore .
# Follow NEW-PROJECT-CHECKLIST.md
```

**Detailed Setup:** [NEW-PROJECT-CHECKLIST.md](project-templates/NEW-PROJECT-CHECKLIST.md)

---

## 3. First Steps After Setup

### Minimal
1. Fill out "Why This Exists" section in README.md
2. Write your code
3. Done!

### Light
1. Update README.md with project details
2. Set initial version in PROJECT-STATUS.md
3. Document your first decision in `thoughts/project/history/`
4. Code and update CHANGELOG.md as you go

### Standard
1. Review the example: [project-hello-world/](project-hello-world/)
2. Complete research phase (use templates from `framework/templates/research/`)
3. Define project in `thoughts/reference/project-definition.md`
4. Plan features in `thoughts/work/backlog/`
5. Move features to `work/todo/` → `work/doing/` → `work/done/`
6. Update CHANGELOG.md and PROJECT-STATUS.md for releases

**Detailed Workflow:** See framework documentation in [framework/process/](framework/process/)

---

## 4. Common Operations

### Start New Feature (Standard)
```bash
# Copy template from framework
cp framework/templates/work-items/FEAT-NNN-template.md \
   thoughts/work/backlog/FEAT-NNN-name.md
# Edit feature file
# Move to work/todo/ when ready to plan
# Move to work/doing/ when ready to implement (max 1 in doing/)
```

### Fix a Bug (Standard)
```bash
# Copy template from framework
cp framework/templates/work-items/BUG-NNN-template.md \
   thoughts/work/backlog/BUG-NNN-name.md
# Document bug, implement fix, test
# Move through workflow: backlog → todo → doing → done
```

### Make Architectural Decision (Standard)
```bash
# Use ADR template from framework
cp framework/templates/decisions/ADR-NNNN-template.md \
   thoughts/research/adr/ADR-NNNN-decision-name.md
```

### Create Release (Light/Standard)
```bash
# 1. Update CHANGELOG.md with changes
# 2. Update PROJECT-STATUS.md with new version
# 3. Commit
git add -A
git commit -m "Release: v1.2.0"
git tag v1.2.0
git push origin main --tags

# 4. (Standard only) Move completed work to history/releases/
```

### End of Day (Standard)
```bash
# Create session history from framework template
cp framework/templates/documentation/session-history-template.md \
   thoughts/history/sessions/YYYY-MM-DD-session-N.md
# Document what you did, decisions made, blockers
```

---

## 5. Key Framework Rules

### All Levels
- **Single Source of Truth:** Version and status ONLY in PROJECT-STATUS.md
- **Update "Last Updated":** When content materially changes (not typos)
- **Semantic Versioning:** MAJOR.MINOR.PATCH (breaking.feature.bugfix)

### Standard Level
- **WIP Limits:** Max 1-2 items in `work/doing/` at once (check `.limit` file)
- **Research First:** Always complete research phase before coding new projects
- **Document Decisions:** Use ADRs for technical choices with alternatives
- **Work Item Flow:** backlog → todo → doing → done → history/releases/

---

## 6. Quick Troubleshooting

**Problem:** "Too much documentation overhead"
→ **Solution:** You might need a lower framework level. See [UPGRADE-PATH.md](project-templates/UPGRADE-PATH.md) (works both ways)

**Problem:** "Don't know which framework level"
→ **Solution:** Start with Light. Upgrade to Standard when you need planning, downgrade to Minimal if it's overkill.

**Problem:** "Lost in the kanban workflow"
→ **Solution:** Think: backlog (someday) → todo (planned) → doing (now, max 2) → done (shipped)

**Problem:** "When do I create an ADR?"
→ **Solution:** When you choose between 2+ approaches OR make a decision future-you needs context for

---

## 7. Essential Links

| What You Need | Document | Time to Read |
|--------------|----------|--------------|
| Full overview | [README.md](README.md) | 10 min |
| Working example | [project-hello-world/](project-hello-world/) | 5 min |
| Choose framework level | [README-TEMPLATE-SELECTION.md](project-templates/README-TEMPLATE-SELECTION.md) | 5 min |
| Setup instructions | [NEW-PROJECT-CHECKLIST.md](project-templates/NEW-PROJECT-CHECKLIST.md) | 15 min |
| Current version/status | [framework/PROJECT-STATUS.md](framework/PROJECT-STATUS.md) | 2 min |
| Change history | [framework/CHANGELOG.md](framework/CHANGELOG.md) | 5 min |
| All documentation | [framework/INDEX.md](framework/INDEX.md) | 3 min |
| Upgrade/downgrade | [UPGRADE-PATH.md](project-templates/UPGRADE-PATH.md) | 10 min |
| File structure | [STRUCTURE.md](project-templates/STRUCTURE.md) | 5 min |

---

## 8. Templates Quick Reference (Standard Level)

| Template | Use When | Location |
|----------|----------|----------|
| FEAT-NNN | Planning new feature | `framework/templates/work-items/` |
| BUG-NNN | Fixing a bug | `framework/templates/work-items/` |
| TECH-NNN | Technical improvement | `framework/templates/work-items/` |
| SPIKE-NNN | Research/investigation | `framework/templates/work-items/` |
| ADR-NNNN | Architectural decision | `framework/templates/decisions/` |
| Session history | End of coding day | `framework/templates/documentation/` |

**Research Phase Templates** (in `framework/templates/research/`):
- Problem statement - What problem are we solving?
- Landscape analysis - What solutions exist?
- Feasibility assessment - Can/should we build this?
- Project justification - BUILD/BUY/ADAPT/ABANDON decision
- Project definition - What exactly are we building?

---

## 9. Workflow Cheat Sheet (Standard)

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
  work/backlog/ → work/todo/ → work/doing/ (max 1) → work/done/ → history/releases/

  At end of day: Document in history/sessions/YYYY-MM-DD-session-N.md
```

---

## 10. Getting Help

- **See working example:** [project-hello-world/](project-hello-world/)
- **Framework structure questions:** [STRUCTURE.md](project-templates/STRUCTURE.md)
- **Workflow questions:** [framework/process/](framework/process/)
- **Complete doc index:** [framework/INDEX.md](framework/INDEX.md)
- **Maintainer:** gary.elliott@spearit.solutions

---

**Remember:** The framework serves you, not the other way around. If something feels like overhead, you might be using the wrong framework level or over-engineering. Start simple, upgrade as needed.

---

**Next Steps:**
1. Choose your framework level (section 1)
2. Run setup commands (section 2)
3. Follow first steps (section 3)
4. Start building!

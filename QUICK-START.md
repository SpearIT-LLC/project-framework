# SpearIT Project Framework - Quick Reference

**Version:** 2.1.0 | **Last Updated:** 2025-12-20 | **Need Details?** See [README.md](README.md)

---

## 1. Choose Your Framework Level (30 seconds)

```
Do you have 3+ files AND ongoing maintenance?
├─ NO  → Minimal (2 files, 10 min setup)
└─ YES → Is this for a team OR requires formal planning?
         ├─ NO  → Light (7 files, 45 min setup)
         └─ YES → Standard (50+ files, 3 hr setup)
```

**Still unsure?** See [README-TEMPLATE-SELECTION.md](project-framework-template/README-TEMPLATE-SELECTION.md)

---

## 2. Setup Commands (15 seconds)

### Minimal Framework (Single Scripts)
```bash
cd /path/to/your-project
cp /path/to/framework/project-framework-template/minimal/README.md .
# Edit README.md, add your code
```

### Light Framework (Small Tools)
```bash
cd /path/to/your-project
cp -r /path/to/framework/project-framework-template/light/* .
# Edit README.md, PROJECT-STATUS.md, CHANGELOG.md
```

### Standard Framework (Applications)
```bash
cd /path/to/your-project
cp -r /path/to/framework/project-framework-template/standard/* .
cp -r /path/to/framework/project-framework-template/standard/.gitignore .
# Follow NEW-PROJECT-CHECKLIST.md
```

**Detailed Setup:** [NEW-PROJECT-CHECKLIST.md](project-framework-template/NEW-PROJECT-CHECKLIST.md)

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
1. Complete research phase:
   - `thoughts/project/research/problem-statement.md`
   - `thoughts/project/research/landscape-analysis.md`
   - `thoughts/project/research/feasibility.md`
   - `thoughts/project/research/project-justification.md`
2. Define project in `thoughts/project/reference/project-definition.md`
3. Plan features in `thoughts/project/planning/backlog/`
4. Move features to `work/todo/` → `work/doing/` → `work/done/`
5. Update CHANGELOG.md and PROJECT-STATUS.md for releases

**Detailed Workflow:** [kanban-workflow.md](project-framework-template/standard/thoughts/framework/process/kanban-workflow.md)

---

## 4. Common Operations

### Start New Feature (Standard)
```bash
# Copy template
cp thoughts/framework/templates/FEATURE-TEMPLATE.md \
   thoughts/project/planning/backlog/feature-NNN-name.md
# Edit feature file
# Move to work/todo/ when ready to plan
# Move to work/doing/ when ready to implement (max 1-2 in doing/)
```

### Fix a Bug (Standard)
```bash
# Copy template
cp thoughts/framework/templates/BUGFIX-TEMPLATE.md \
   thoughts/project/work/doing/bugfix-NNN-name.md
# Document bug, implement fix, test
# Move to work/done/ when complete
```

### Make Architectural Decision (Standard)
```bash
# For major decisions (affects 3+ files, hard to change)
cp thoughts/framework/templates/ADR-MAJOR-TEMPLATE.md \
   thoughts/project/research/adr/NNN-decision-name.md

# For minor decisions (1-2 files, easy to change)
cp thoughts/framework/templates/ADR-MINOR-TEMPLATE.md \
   thoughts/project/research/adr/NNN-decision-name.md
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
# Create session history
cp thoughts/framework/templates/SESSION-HISTORY-TEMPLATE.md \
   thoughts/project/history/YYYY-MM-DD-SESSION-HISTORY.md
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
→ **Solution:** You might need a lower framework level. See [UPGRADE-PATH.md](project-framework-template/UPGRADE-PATH.md) (works both ways)

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
| Choose framework level | [README-TEMPLATE-SELECTION.md](project-framework-template/README-TEMPLATE-SELECTION.md) | 5 min |
| Setup instructions | [NEW-PROJECT-CHECKLIST.md](project-framework-template/NEW-PROJECT-CHECKLIST.md) | 15 min |
| Current version/status | [PROJECT-STATUS.md](PROJECT-STATUS.md) | 2 min |
| Change history | [CHANGELOG.md](CHANGELOG.md) | 5 min |
| All documentation | [INDEX.md](INDEX.md) | 3 min |
| Upgrade/downgrade | [UPGRADE-PATH.md](project-framework-template/UPGRADE-PATH.md) | 10 min |
| File structure | [STRUCTURE.md](project-framework-template/STRUCTURE.md) | 5 min |

---

## 8. Templates Quick Reference (Standard Level)

| Template | Use When | Location |
|----------|----------|----------|
| FEATURE-TEMPLATE | Planning new capability | `thoughts/framework/templates/` |
| BUGFIX-TEMPLATE | Fixing a bug | `thoughts/framework/templates/` |
| BLOCKER-TEMPLATE | Stuck on something | `thoughts/framework/templates/` |
| SPIKE-TEMPLATE | Need to research/investigate | `thoughts/framework/templates/` |
| ADR-MAJOR-TEMPLATE | Big architectural decision | `thoughts/framework/templates/` |
| ADR-MINOR-TEMPLATE | Small technical decision | `thoughts/framework/templates/` |
| SESSION-HISTORY-TEMPLATE | End of coding day | `thoughts/framework/templates/` |

**Research Phase Templates:**
- PROBLEM-STATEMENT-TEMPLATE - What problem are we solving?
- LANDSCAPE-ANALYSIS-TEMPLATE - What solutions exist?
- FEASIBILITY-TEMPLATE - Can/should we build this?
- PROJECT-JUSTIFICATION-TEMPLATE - BUILD/BUY/ADAPT/ABANDON decision
- PROJECT-DEFINITION-TEMPLATE - What exactly are we building?

---

## 9. Workflow Cheat Sheet (Standard)

```
NEW PROJECT:
  Research → Define → Plan → Code → Release
  │         │        │       │       │
  │         │        │       │       └─ Update CHANGELOG + PROJECT-STATUS
  │         │        │       └───────── Implement in work/doing/
  │         │        └───────────────── Break into features in planning/backlog/
  │         └────────────────────────── Write project-definition.md
  └──────────────────────────────────── Complete 5 research templates

DAILY WORK:
  work/todo/ → work/doing/ (max 2) → work/done/ → history/releases/

  At end of day: Document in history/YYYY-MM-DD-SESSION-HISTORY.md
```

---

## 10. Getting Help

- **Framework structure questions:** [STRUCTURE.md](project-framework-template/STRUCTURE.md)
- **Workflow questions:** [kanban-workflow.md](project-framework-template/standard/thoughts/framework/process/kanban-workflow.md)
- **Complete doc index:** [INDEX.md](INDEX.md)
- **Maintainer:** gary.elliott@spearit.solutions

---

**Remember:** The framework serves you, not the other way around. If something feels like overhead, you might be using the wrong framework level or over-engineering. Start simple, upgrade as needed.

---

**Next Steps:**
1. Choose your framework level (section 1)
2. Run setup commands (section 2)
3. Follow first steps (section 3)
4. Start building!

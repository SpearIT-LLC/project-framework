# DECISION-037: Project-Hub Location (Root vs Framework Subfolder)

**ID:** DECISION-037
**Type:** Decision
**Priority:** Low
**Version Impact:** MAJOR (if moved to root)
**Created:** 2026-01-27

---

## Summary

Decide whether project-hub/ should remain at `framework/project-hub/` or move to repository root as `project-hub/`.

---

## Context

**Current structure:**
```
project-framework/
├── framework/
│   ├── project-hub/          # Current location
│   │   ├── work/
│   │   ├── history/
│   │   ├── research/
│   │   └── external-references/
│   ├── docs/                  # Framework documentation
│   └── ...
├── templates/
└── tools/
```

**Question:** Should project-hub/ be at repo root alongside framework/, or stay inside framework/?

**Related work:**
- TECH-084 (done): Renamed thoughts/ → project-hub/ (but kept in framework/)
- FEAT-093 (backlog): Reorganizes project-hub internally (project/, history/archive/) but doesn't move to root

---

## Discussion (2026-01-27)

During roadmap planning session, considered two organizational models:

**Option A: Keep project-hub in framework/ (current)**
- Project-hub is part of the framework project
- Framework is using its own structure (dogfooding)
- Clear: framework's project management lives in framework/

**Option B: Move project-hub to root**
- project-hub/ becomes sibling to framework/
- Separates "meta project management" from framework content
- Could clarify that project-hub is for the repo, not just framework

**Decision at time:** Defer moving to root, but reorganize internally (FEAT-093).

**Alternative considered:** Instead of moving project-hub to root, we could:
1. Keep project-hub in framework/ (dogfooding the framework)
2. Reorganize internally: project-hub/project/ for active planning, project-hub/history/archive/ for completed periods
3. This achieves better organization without the breaking change of moving to root

---

## Arguments For Moving to Root

**Conceptual clarity:**
- `project-hub/` at root = "This repo's project management"
- `framework/` at root = "The framework being developed"
- `templates/` at root = "Template packages"
- Clear separation of concerns

**Symmetry:**
- Repository has multiple projects (framework, templates)
- Root-level project-hub could manage all of them
- But currently, only framework uses project-hub

**Precedent:**
- Some monorepos put shared tooling at root
- Project management could be "shared infrastructure"

---

## Arguments Against Moving to Root

**Framework dogfooding:**
- Framework should use its own structure
- framework/project-hub/ demonstrates framework usage
- "Practice what you preach"

**Single project focus:**
- Only framework/ uses project-hub currently
- templates/ are derived from framework, not independent projects
- No real multi-project coordination needed

**Breaking change:**
- All references to project-hub location would need updating
- Git history becomes harder to follow
- CLAUDE.md, workflow docs, scripts all reference current location
- High churn for unclear benefit

**FEAT-093 solves the real problem:**
- Internal reorganization (project/, history/archive/) addresses planning needs
- Separating active planning from archives was the actual pain point
- Location relative to repo root doesn't solve any stated problem

---

## Recommendation

**Recommended:** Keep project-hub at `framework/project-hub/` (Option A - current)

**Reasoning:**

1. **Dogfooding principle:** Framework should use its own structure. Moving project-hub out would break this.

2. **YAGNI:** No concrete problem is solved by moving to root. The actual issues (roadmap growth, archival) are solved by FEAT-093's internal reorganization.

3. **Cost vs benefit:** Breaking change with widespread impact, unclear benefit.

4. **Single project:** This repository has one main project (framework). templates/ and tools/ are supporting artifacts, not independent projects.

5. **FEAT-093 is sufficient:** Internal reorganization provides the structure needed without the breaking change.

---

## If Decision Changes Later

**Triggers to reconsider:**
- Repository becomes true multi-project monorepo
- Multiple independent projects need shared project management
- Clear evidence that current location causes problems

**Migration path if needed:**
```bash
git mv framework/project-hub project-hub
# Update all references in:
# - CLAUDE.md (framework and root)
# - Workflow guides
# - Skills (.claude/commands/)
# - Scripts (if any)
# - Documentation links
```

**Version impact:** MAJOR (breaking change for users following framework structure)

---

## Alternative: Hybrid Approach (Future Consideration)

If repository grows to have multiple projects:

```
project-framework/
├── project-hub/              # Repo-level project management
│   ├── meta/                 # Cross-project coordination
│   └── projects/
│       ├── framework/        # Framework-specific work items
│       └── templates/        # Template-specific work items
├── framework/
│   └── ...
└── templates/
    └── ...
```

**Not recommended now:** Premature optimization for a problem we don't have.

---

## Decision Criteria

Choose based on:

1. **Is framework dogfooding valuable?** (yes → keep in framework/)
2. **Do multiple projects need coordination?** (no → keep in framework/)
3. **Does current location cause problems?** (no → keep in framework/)
4. **Does FEAT-093 solve the actual pain point?** (yes → keep in framework/)

All criteria point to: **Keep project-hub in framework/**

---

## Completion Criteria

- [ ] Decision made and documented
- [ ] If moving: Migration plan executed, all references updated
- [ ] If keeping: Document rationale (this file)
- [ ] Related work items (FEAT-093) aware of decision

---

## Related

- TECH-084: Renamed thoughts/ to project-hub/ (kept in framework/)
- FEAT-093: Internal reorganization (project/, history/archive/)
- DECISION-035: Root status reference (similar question about repository vs framework artifacts)

---

## Notes

**Session context (2026-01-27):**

During roadmap planning, discussed:
> "We talked about moving project-hub/ to repo root but decided to defer. However, perhaps project-hub/project/ would be a better long term location for the roadmap. Then closed quarters/sprints/phases can move to project-hub/history/archive. This keeps project info together and frees repo-root/docs/ to be solution documentation."

Key insight: The actual need was **internal reorganization of project-hub**, not moving it to root. FEAT-093 addresses this by:
- Creating project-hub/project/ for active planning (roadmap, etc.)
- Creating project-hub/history/archive/ for completed periods
- Keeping docs/ for technical/solution documentation

This achieves the goal (separation of active planning from history, and from technical docs) without the breaking change of moving project-hub to root.

**Deferral reason:** FEAT-093's internal reorganization solves the stated problem. Moving to root is a solution looking for a problem.

---

**Last Updated:** 2026-01-27

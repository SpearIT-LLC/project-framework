# DECISION-037: Project-Hub Location (Root vs Framework Subfolder)

**ID:** DECISION-037
**Type:** Decision
**Priority:** Low
**Version Impact:** MAJOR (if moved to root)
**Created:** 2026-01-27
**Theme:** Distribution & Onboarding
**Planning Period:** Sprint D&O 0
**Status:** Active

---

## Summary

Decide whether project-hub/ should move to repository root as `project-hub/` or remain at `framework/project-hub/`.

**Current Status:** Decision deferred. Would expand scope of current work (FEAT-093). Revisit after internal reorganization is complete.

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

## Decision Status

**Status:** DEFERRED

**Reason for Deferral:**

During roadmap planning session (2026-01-27), discussed moving project-hub/ to root as part of reorganization work. However, this would significantly expand the scope of FEAT-093 (planning period archival), which is already a substantial change.

**Why defer:**
1. **Scope creep:** FEAT-093 is reorganizing project-hub internally (project/, history/archive/). Adding a move to root would combine two major changes.
2. **Focus:** Internal reorganization solves the immediate pain point (roadmap growth, archival). Location relative to repo root is a separate concern.
3. **Testing:** Better to complete internal reorganization first, validate it works, then consider relocation.
4. **Breaking change:** Moving to root is a breaking change for users. Should be its own deliberate decision, not bundled with other work.

**When to revisit:**
- After FEAT-093 is implemented and stable
- When internal reorganization is proven to work
- If new evidence emerges that root location solves specific problems

---

## When Revisiting This Decision

**Prerequisites for decision:**
- FEAT-093 implemented and in use for 1-2 quarters
- Clear understanding of whether root location solves problems

**Triggers to favor moving to root:**
- Repository becomes true multi-project monorepo
- Multiple independent projects need shared project management
- Evidence that current location causes problems

**Migration path if decision is to move:**
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

## Evaluation Criteria (When Revisiting)

When FEAT-093 is complete and we revisit this decision, evaluate:

1. **Does internal reorganization solve all problems?**
   - If yes → likely keep in framework/
   - If no → identify what problems remain

2. **Is framework dogfooding still valuable?**
   - Does having project-hub in framework/ demonstrate framework usage?
   - Or does it just create confusion?

3. **Has repository become multi-project?**
   - Are templates/, tools/, or other projects independent enough to need shared project management?
   - If yes → consider root location

4. **Does current location cause concrete problems?**
   - Documentation confusion?
   - Path references awkward?
   - User complaints?

5. **What's the cost/benefit of moving?**
   - Breaking change impact
   - Migration effort
   - Actual benefit gained

**Decision guideline:**
- If internal reorganization solves all issues → keep in framework/
- If root location solves concrete remaining problems → move to root
- If unsure → defer again until evidence emerges

---

## Completion Criteria

**For Deferral (current):**
- [x] Deferral reason documented
- [x] Context captured for future decision
- [x] Related work item (FEAT-093) aware of deferral
- [ ] Trigger conditions defined for revisiting

**For Final Decision (when revisited):**
- [ ] FEAT-093 complete and stable
- [ ] Evaluation completed: does root location solve remaining problems?
- [ ] Decision made: move or keep
- [ ] If moving: Migration plan executed, all references updated
- [ ] If keeping: Final rationale documented

---

## Related

- TECH-084: Renamed thoughts/ to project-hub/ (kept in framework/)
- FEAT-093: Internal reorganization (project/, history/archive/)
- DECISION-035: Root status reference (similar question about repository vs framework artifacts)

---

## Notes

**Session context (2026-01-27):**

During roadmap planning, discussed moving project-hub/ to root:
> "We talked about moving project-hub/ to repo root but decided to defer. However, perhaps project-hub/project/ would be a better long term location for the roadmap. Then closed quarters/sprints/phases can move to project-hub/history/archive. This keeps project info together and frees repo-root/docs/ to be solution documentation."

**Key insight:** The immediate need is **internal reorganization of project-hub**, not necessarily moving it to root. FEAT-093 addresses the immediate needs:
- Creating project-hub/project/ for active planning (roadmap, etc.)
- Creating project-hub/history/archive/ for completed periods
- Separating project management from technical docs

**Why deferral makes sense:**
1. FEAT-093's internal reorganization is substantial work on its own
2. Adding relocation to root would expand scope significantly
3. Better to prove internal reorganization works first
4. Moving to root can be evaluated independently later
5. Not clear yet if root location provides benefits beyond internal reorganization

**What needs to happen before deciding:**
- Complete FEAT-093 implementation
- Use the new structure for 1-2 quarters
- Evaluate if root location would solve any remaining problems
- Consider user impact of breaking change

**Deferral reason:** Too much scope expansion during active feature work. Need to complete internal reorganization first, then evaluate if root location is still needed.

---

**Last Updated:** 2026-01-27

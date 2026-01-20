# ADR-004: POC Folder for Experiments

**Status:** Accepted
**Date:** 2026-01-17
**Deciders:** Gary Elliott, Claude
**Impact:** Minor
**Scope:** thoughts/ folder structure, developer.prototype workflow
**Supersedes:** None

---

## Context

During FEAT-059 testing, we discovered that the `developer.prototype` variant creates code outside the formal workflow. This raised questions:

1. Should POC/prototype work be tracked?
2. Where should experimental code artifacts live?
3. How does this relate to existing `research/` and `work/` folders?

The framework already has a spike pattern (time-boxed investigations) but no dedicated location for code experiments.

---

## Options

1. **Option A: `thoughts/work/poc/`** - POC as part of work folders
   - Pros: Part of work tracking, visible in workflow
   - Cons: POCs don't follow kanban flow (backlog→todo→doing→done)

2. **Option B: `thoughts/poc/`** - POC as sibling to work/
   - Pros: Separate from formal workflow, clear it's experimental, sibling to research/
   - Cons: Another top-level folder

3. **Option C: `src/poc/` or `framework/scripts/poc/`** - Code near code
   - Pros: Experimental code near production code
   - Cons: Mixes experimental with production, harder to clean up

4. **Option D: `thoughts/research/poc/`** - POC as part of research
   - Pros: POCs are a form of exploration
   - Cons: Research is typically documentation, not code artifacts

---

## Decision

We chose **Option B: `thoughts/poc/`** because:

- POCs are tracked (spike docs) but don't follow kanban workflow
- Clear separation: `work/` = formal workflow, `poc/` = experiments
- Sibling to `research/` - both are "thinking" but different types:
  - `research/` = understanding & analysis (documentation)
  - `poc/` = proving & experimenting (code + spike docs)
- Easy to find, easy to clean up
- No WIP limits (experimentation shouldn't be constrained)

**Implementation:**

```
thoughts/
├── work/           # Formal kanban workflow
├── research/       # Analysis, ADRs, landscape reviews
├── poc/            # Experiments and spikes (NEW)
│   ├── .gitkeep
│   └── SPIKE-XXX-description/   # Spike folder with artifacts
│       ├── SPIKE-XXX-description.md
│       └── [code artifacts]
└── history/
    └── spikes/     # Archived spike docs
```

**Workflow:**
1. User says "let's prototype X"
2. AI adopts `developer.prototype` variant
3. AI asks: "Should I create a spike to track this experiment?"
4. If yes → create spike folder in `thoughts/poc/SPIKE-XXX-description/`
5. Spike doc and code artifacts live in that folder
6. When spike complete → archive entire folder to `history/spikes/SPIKE-XXX-description/`
7. After production solution implemented → optionally delete code artifacts, keep spike doc (lessons learned)

---

## Consequences

**Good:**
- Experiments are tracked without workflow overhead
- History preserved (what worked, what didn't)
- Clear separation from production code
- Supports rapid iteration (no WIP limits)
- Artifacts available during production implementation
- Lessons learned preserved even after artifact cleanup

**Bad:**
- Another folder to know about
- Need to update documentation and templates

**Revisit if:** POC folder becomes dumping ground for abandoned experiments (may need cleanup policy)

---

## Artifact Retention Policy

**During spike:** All artifacts live in `thoughts/poc/SPIKE-XXX/`

**On spike completion:** Entire folder archives to `history/spikes/SPIKE-XXX/`
- Artifacts preserved for reference during production implementation

**After production implementation:** Optionally clean up archived artifacts
- Keep: Spike doc (captures lessons learned, approach, findings)
- Delete: Code artifacts (now superseded by production code)
- Decision is manual - not all spikes lead to production work

---

## References

- FEAT-059: Context-aware AI roles (testing revealed this need)
- Spike pattern in workflow-guide.md
- Session discussion: 2026-01-17


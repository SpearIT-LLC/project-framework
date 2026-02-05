# ADR-003: Work Item Lifecycle and Archival Process

**Status:** Proposed
**Date:** 2025-12-29
**Deciders:** Gary Elliott, Claude Code
**Impact:** Major
**Supersedes:** None

---

## Context and Problem Statement

When releasing FEAT-020 (v2.2.0), we discovered supporting documents left in `doing/` folder that weren't part of the primary deliverable. This revealed gaps in our workflow:

1. **No guidance on supporting documents:** When a feature creates working documents (migration matrices, planning docs), what happens to them at release?
2. **Unclear done → archive transition:** When do completed items move from `done/` to `history/releases/`?
3. **Incomplete release process:** Current workflow ends at "move to done/" but doesn't address post-release archival

**Key Requirements:**
- Keep complete work history for features (including supporting docs)
- Clear doing/ folder when work completes (maintain WIP limits)
- Maintain audit trail for releases
- Simple, deterministic process

**Constraints:**
- Must work with file-based kanban system
- Must not lose work history
- Must be clear when to archive (avoid ambiguity)

**Scale/Scope:** Affects all work items, all releases, both human and AI workflows

---

## Decision Drivers

1. **Process clarity** - Eliminate ambiguity about document lifecycle
2. **WIP limit enforcement** - doing/ must be cleared when work completes
3. **Historical accuracy** - Preserve complete picture of what was done
4. **Simplicity** - Clear rules, minimal steps

---

## Options Considered

### Option 1: Archive Immediately After Release

**How it works:**
- When feature releases (git tag created), immediately move ALL related docs from `done/` to `history/releases/vX.Y.Z/`
- Supporting docs in `doing/` move with primary work item
- done/ folder is always empty after release

**Pros:**
- Clean separation between active and historical work
- done/ accurately reflects "ready to release" state
- Clear trigger: release happens → archive happens
- Maintains complete feature history together

**Cons:**
- Extra step after every release
- done/ folder rarely has content
- May feel like busy work for small releases

**Trade-offs:** Adds release step but provides clean separation

---

### Option 2: Archive Periodically (Monthly/Quarterly)

**How it works:**
- Items accumulate in done/ folder
- Periodically (monthly/quarterly) batch archive to `history/releases/`
- Supporting docs stay in doing/ until batch archive

**Pros:**
- Less frequent archival operations
- Can batch multiple releases together

**Cons:**
- **WIP limit violation:** Supporting docs left in doing/ indefinitely
- done/ grows unbounded between archives
- Unclear when to archive (subjective timing)
- Loses connection between work item and release version

**Trade-offs:** Simpler day-to-day but creates ambiguity and WIP violations

---

### Option 3: Keep in done/ Forever (No Archive)

**How it works:**
- Work items move to done/ and stay there forever
- Supporting docs move to done/ with primary item
- No archival process

**Pros:**
- Simplest workflow (no archival step)
- Everything "released" in one place

**Cons:**
- done/ grows unbounded over time
- No separation between recent and ancient releases
- Harder to find specific release content
- No clear release grouping

**Trade-offs:** Simple but doesn't scale

---

### Option 4: Hybrid - Archive Primary, Keep Supporting in doing/

**How it works:**
- Primary work item (FEAT-XXX.md) moves to done/ then archives
- Supporting/working docs stay in doing/ or are deleted

**Pros:**
- Only archive "important" documents
- Flexibility on supporting docs

**Cons:**
- **Process gap remains unsolved:** Still unclear what to do with supporting docs
- Loses complete work history
- Subjective decision on what's "important"

**Trade-offs:** Avoids the problem rather than solving it

---

## Decision

**We chose Option 1: Archive Immediately After Release**

**Primary Reasons:**
1. **Clear trigger:** Release happens → archive happens (deterministic)
2. **Maintains WIP limits:** Clears doing/ and done/ after release
3. **Complete history:** All related docs archived together by version
4. **Scalability:** done/ doesn't grow unbounded
5. **Traceability:** Easy to find "what was in v2.2.0?" - just check `history/releases/v2.2.0/`

**Implementation Location:**
- `project-hub/project/collaboration/workflow-guide.md` (update release process)
- `CLAUDE.md` (add to AI Workflow Checkpoint Policy)
- This ADR (new guidance)

---

## Consequences

### Positive
- ✅ Clear, unambiguous process for all work item types
- ✅ WIP limits maintained (doing/ cleared after release)
- ✅ Complete feature history preserved together
- ✅ Easy to audit releases (all docs in one folder per version)
- ✅ done/ folder accurately reflects "ready for next release" state

### Negative
- ⚠️ Extra step after every release (archival)
- ⚠️ done/ folder is usually empty (items archive quickly)

### Accepted Risks
- **Risk:** Archival step might be forgotten
  - **Mitigation:** Document in atomic release checklist, add to CLAUDE.md AI workflow
- **Risk:** Large releases generate many files in archive folder
  - **Mitigation:** Acceptable - better than unbounded done/ folder

---

## Detailed Process

### Work Item Lifecycle (Complete)

```
1. User requests feature
2. AI creates backlog item → planning/backlog/FEAT-XXX.md
3. [CHECKPOINT] AI asks for approval
4. User approves
5. AI checks WIP limits
6. AI moves backlog → work/todo/FEAT-XXX.md
7. AI moves todo → work/doing/FEAT-XXX.md
8. Implementation begins
   - Supporting docs created in doing/ (e.g., FEAT-XXX-MIGRATION-MATRIX.md)
   - Sub-items may be created (FEAT-XXX.1.md, FEAT-XXX.2.md) if work is subdivided
   - Work progresses
9. Implementation completes
10. AI updates version files (PROJECT-STATUS.md, CHANGELOG.md)
11. AI moves ALL FEAT-XXX docs: doing/ → work/done/
    - Primary: FEAT-XXX.md
    - Sub-items: FEAT-XXX.1.md, FEAT-XXX.2.md (if exist)
    - Supporting: FEAT-XXX-*.md, feature-XXX-*.md
12. AI commits atomically with version tag
13. **[NEW STEP] Immediately after release:**
    - Create history/releases/vX.Y.Z/ if needed
    - Move ALL FEAT-XXX* files from done/ → history/releases/vX.Y.Z/
      - Includes primary, sub-items, and supporting documents
    - Commit: "Archive: vX.Y.Z work items"
14. doing/ and done/ are now clear
```

### What Moves to Archive?

**All files related to the work item:**
- ✅ Primary work item (FEAT-XXX.md, BUGFIX-XXX.md, BLOCKER-XXX.md, SPIKE-XXX.md)
- ✅ Sub-items (FEAT-XXX.1.md, BUGFIX-XXX.2.md, etc.)
- ✅ Supporting documents (FEAT-XXX-*.md, bugfix-XXX-*.md, etc.)
- ✅ Test plans (FEAT-XXX-TESTING-PLAN.md)
- ✅ Test results (FEAT-XXX-TEST-RESULTS.md)
- ✅ Migration matrices, planning docs, any other related files

**Applies to ALL work item types:**
- FEAT-XXX (features)
- BUGFIX-XXX (bug fixes)
- BLOCKER-XXX (blockers)
- SPIKE-XXX (research spikes)

**Identifying related files:**
- Filename contains work item ID with dash or dot separator
- Pattern: `{TYPE}-{NUMBER}[.sub][dash-description].md`

**Examples by work item type:**

*Features (FEAT-XXX):*
- FEAT-020.md (primary)
- FEAT-020.1.md, FEAT-020.2.md (sub-items)
- FEAT-020-TESTING-PLAN.md (supporting)
- feature-020-planning.md (supporting, alternate naming)

*Bug Fixes (BUGFIX-XXX):*
- BUGFIX-042.md (primary)
- BUGFIX-042-ROOT-CAUSE-ANALYSIS.md (supporting)
- bugfix-042-reproduction-steps.md (supporting, alternate)

*Blockers (BLOCKER-XXX):*
- BLOCKER-005.md (primary)
- BLOCKER-005-WORKAROUND.md (supporting)

*Spikes (SPIKE-XXX):*
- SPIKE-013.md (primary)
- SPIKE-013-FINDINGS.md (supporting)
- spike-013-comparison-matrix.md (supporting, alternate)

**General rule:** All files created during implementation that reference the work item ID

**Why sub-items archive together:**
Sub-items (FEAT-XXX.1, FEAT-XXX.2) are part of the same logical feature and should stay together in the archive. Breaking up a feature across releases would lose context.

---

## Future Guidance

**When to revisit this decision:**
- If archival step becomes burdensome (e.g., >10 releases/month)
- If we need different archival strategies for different work item types
- If filesystem performance degrades with many archive folders

**Similar decisions should consider:**
- Complete work history > minimal archival effort
- Clear triggers > subjective timing
- Deterministic process > flexible process

**Related patterns:**
- Atomic releases (ADR-001 checkpoint policy)
- Work item naming conventions (FEAT-XXX prefix)
- Version-tagged archive folders

---

## Common Mistakes to Avoid

**Mistake 1: Copying instead of moving**
- ❌ Wrong: `cp project-hub/work/done/FEAT-*.md project-hub/history/releases/vX.Y.Z/`
- ✅ Correct: `git mv project-hub/work/done/FEAT-*.md project-hub/history/releases/vX.Y.Z/`
- **Impact:** Creates duplicates in both done/ and releases/, violates policy
- **Fix:** Remove duplicates from done/ after copying

**Mistake 2: Forgetting to verify done/ is empty**
- ❌ Wrong: Archive files and move on without checking
- ✅ Correct: Run `ls project-hub/work/done/*.md` after archiving
- **Expected:** Should return empty or "No such file"
- **If files remain:** You copied instead of moved, or missed some files

**Mistake 3: Archiving only the primary work item**
- ❌ Wrong: Moving only FEAT-026.md
- ✅ Correct: Moving ALL FEAT-026*.md files (primary + sub-items + supporting)
- **Use wildcard:** `git mv project-hub/work/done/FEAT-026*.md ...`

**Mistake 4: Forgetting the archival step entirely**
- ❌ Wrong: Release and leave files in done/ indefinitely
- ✅ Correct: Archive immediately after creating release tag
- **Trigger:** Release tag created → archive happens (atomic with release)

---

## Validation

**How we verify correctness:**
- After release, doing/ should be empty or only contain new work
- After release, done/ should be empty
- Archive folder should contain all work item docs for that release

**Success Criteria:**
- ✅ No orphaned supporting docs in doing/
- ✅ WIP limits maintained
- ✅ Complete release history in archive folders
- ✅ AI can execute archival process without ambiguity

---

## References

- [workflow-guide.md](../../collaboration/workflow-guide.md) - Kanban workflow documentation
- [ADR-001: AI Workflow Checkpoint Policy](001-ai-workflow-checkpoint-policy.md) - Approval process
- [2025-12-29 Session] - Discovery of process gap during FEAT-020 release

---

**Change Log:**
- 2025-12-29: Initial decision (process gap discovered during FEAT-020 release)

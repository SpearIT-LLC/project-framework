# FEAT-047: Small Team ID Collision Support

**ID:** FEAT-047
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-01-11

---

## Summary

Design and implement a solution for work item ID assignment that prevents collisions in small team (2-5 developers) distributed git workflows, enabling the framework to support collaborative development.

---

## Problem Statement

**Current Limitation:** The framework's ID discovery algorithm (TECH-046) only works reliably for solo developers. In distributed team environments, concurrent work item creation causes ID collisions.

**Collision Scenario:**
```
Developer A (local repo):
- Scans work items, finds max ID: 046
- Creates FEAT-047-new-feature.md
- Works offline

Developer B (local repo, simultaneously):
- Scans work items, finds max ID: 046
- Creates FEAT-047-bug-fix.md
- Works offline

Both push to remote → filename collision → git merge conflict
```

**Who is affected:**
- Small teams (2-5 people) attempting to use the framework
- Organizations wanting team-based AI-assisted development
- Anyone who believed "small team" support claims

**Current workaround:**
- None - teams must manually coordinate ID assignment (defeats automation)
- Or accept collision and manually renumber after conflict (error-prone)

---

## Requirements

### Functional Requirements

- [ ] Prevent ID collisions in distributed workflow
- [ ] Work with standard git workflows (no special setup)
- [ ] Maintain sequential ID readability where possible
- [ ] Support 2-5 concurrent developers
- [ ] No external services required (local-first philosophy)
- [ ] Graceful degradation if conflicts occur
- [ ] Clear resolution process documented

### Non-Functional Requirements

- [ ] Simple for developers to understand
- [ ] Minimal ceremony for creating work items
- [ ] Compatible with existing work item format
- [ ] No breaking changes to ID referencing system
- [ ] Works offline (airplane mode)
- [ ] Performance: ID assignment in < 1 second

---

## Design Considerations

### Challenge Analysis

**Core Problem:** Distributed systems need consensus for unique ID assignment, but git is eventually consistent (not immediately consistent).

**Constraints:**
1. **Local-first**: No external services (defeats framework philosophy)
2. **Manual-friendly**: Must work for humans creating work items manually
3. **Git-native**: Can't require special git hooks or server-side enforcement
4. **Simple**: Can't require complex conflict resolution training

**Why This Is Hard:**
- Git won't prevent filename collisions until merge time
- Race condition window exists even with remote checks
- Sequential IDs are inherently centralized (require coordination)

---

## Potential Solutions

### Option 1: Developer-Scoped IDs

**Approach:** Include developer identifier in ID
- Format: `FEAT-047-alice-feature-name.md`, `FEAT-047-bob-bug-fix.md`
- ID field: `**ID:** 047-alice`, `**ID:** 047-bob`

**Pros:**
- ✅ Collision-free (unique per developer)
- ✅ Sortable by base ID
- ✅ Works offline
- ✅ Simple to implement

**Cons:**
- ❌ Breaks sequential ID convention
- ❌ Ugly filenames
- ❌ Multiple items share same base number (confusing in references)
- ❌ Requires developer identity configuration

**Assessment:** Works but violates aesthetic and simplicity goals

---

### Option 2: Timestamp-Based IDs

**Approach:** Use timestamp as ID
- Format: `FEAT-20260111-153042-feature-name.md`
- ID field: `**ID:** 20260111-153042`

**Pros:**
- ✅ Collision-free (unless simultaneous to the second)
- ✅ Sortable chronologically
- ✅ Works offline
- ✅ Self-documenting (includes creation date)

**Cons:**
- ❌ Loses sequential simplicity (001, 002, 003)
- ❌ Harder to reference verbally ("work on 20260111-153042")
- ❌ Breaking change to ID format
- ❌ Longer filenames

**Assessment:** Practical but breaks convention significantly

---

### Option 3: Pre-assigned ID Ranges

**Approach:** Each developer gets an ID range
- Alice: 001-199
- Bob: 200-399
- Carol: 400-599

**Pros:**
- ✅ Sequential IDs preserved
- ✅ No collisions
- ✅ Works offline

**Cons:**
- ❌ Requires upfront coordination
- ❌ Wastes ID space (gaps between ranges)
- ❌ Doesn't scale (what if Alice needs 201?)
- ❌ Manual configuration required

**Assessment:** Too rigid and wasteful

---

### Option 4: Git-Aware Check Before Create

**Approach:** Check remote before creating work item
1. `git fetch origin`
2. Check `origin/main` for latest IDs
3. Create work item with next ID
4. Immediate push to claim ID

**Pros:**
- ✅ Sequential IDs preserved
- ✅ Minimal changes to workflow

**Cons:**
- ❌ Requires network access (defeats offline use)
- ❌ Race condition still exists (push can fail)
- ❌ Adds complexity to work item creation
- ❌ Breaks if push delayed

**Assessment:** Reduces collisions but doesn't eliminate them

---

### Option 5: Accept Collisions + Manual Resolution Process

**Approach:** Document clear process for resolving ID collisions when they occur
1. Git detects filename collision on merge
2. Later developer renumbers their work item
3. Search/replace references to old ID
4. Update cross-references in related items
5. Commit renumbering as separate commit

**Pros:**
- ✅ Sequential IDs preserved
- ✅ No changes to creation workflow
- ✅ Works offline
- ✅ Simple for common case (solo developer)

**Cons:**
- ❌ Manual resolution required (error-prone)
- ❌ Breaking references risk
- ❌ Requires clear documentation
- ❌ Annoying for frequent collaborators

**Assessment:** Pragmatic but not ideal

---

### Option 6: Hybrid Sequential + Collision Suffix

**Approach:** Sequential by default, add suffix on collision
- First attempt: `FEAT-047-feature-name.md`
- On collision: `FEAT-047-B-feature-name.md` (B = second attempt)
- ID field: `**ID:** 047-B`

**Pros:**
- ✅ Sequential IDs for common case
- ✅ Collision resolution built-in
- ✅ Works offline
- ✅ Minimal complexity

**Cons:**
- ❌ Still requires detecting collision (at merge time)
- ❌ Manual renaming after collision
- ❌ References need updating

**Assessment:** Compromise between purity and pragmatism

---

## Recommended Approach (To Be Decided)

**Current thinking:** Combination of Option 5 (Accept Collisions) + Option 6 (Collision Suffix)

**Workflow:**
1. **Normal case:** Developer creates `FEAT-047-feature.md` (no changes)
2. **Collision detected:** Git merge conflict on filename
3. **Resolution:** Later developer renames to `FEAT-047-B-feature.md`
4. **Update references:** Search/replace `047` → `047-B` in related files
5. **Document:** Clear guide with examples

**Why this works:**
- Preserves simplicity for solo developers (most users)
- Provides clear path for teams
- No breaking changes to existing system
- Offline-friendly
- Git handles detection automatically

**Tradeoffs:**
- Manual resolution required (but infrequent)
- Slightly uglier IDs on collision (acceptable)
- Need good documentation (we can provide this)

---

## Implementation Plan

### Phase 1: Documentation

1. **Create collision resolution guide:**
   - Detecting collisions (git conflict on filename)
   - Renaming work item file
   - Updating ID field
   - Searching for references
   - Updating cross-references
   - Example walkthrough with screenshots

2. **Update workflow-guide.md:**
   - Add "Team Workflow" section
   - Document collision resolution process
   - Provide examples

3. **Update TECH-046:**
   - Remove solo-only limitation note
   - Reference team workflow section

### Phase 2: Tooling (Optional)

Create helper script: `resolve-id-collision.sh`
- Input: Conflicting work item
- Finds next available collision suffix (A, B, C...)
- Renames file
- Updates ID field
- Searches codebase for references
- Reports files needing manual review

### Phase 3: Testing

1. **Create test repository:**
   - Simulate 2-developer workflow
   - Force ID collision
   - Walk through resolution
   - Document pain points

2. **Refine process:**
   - Based on real testing
   - Update documentation
   - Consider tooling needs

### Phase 4: Documentation Updates

Update all references to "solo developer" limitation:
- README.md
- PROJECT-STATUS.md
- Marketing materials
- Executive summaries

---

## Dependencies

**Requires:**
- TECH-046 implemented (ID discovery algorithm)
- DECISION-042 (ID definition)

**Blocks:**
- TECH-048 (Remove solo-developer scope from docs)

**Related:**
- Project scope currently: "Solo developers using Standard Framework"
- This feature expands to: "Solo developers and small teams (2-5)"

---

## Success Metrics

**How do we know this feature works?**

1. ✅ Two developers can create work items concurrently without coordination
2. ✅ Collision detection is automatic (via git)
3. ✅ Resolution process is documented and clear
4. ✅ Resolution takes < 5 minutes
5. ✅ References don't break after resolution
6. ✅ Process validated with real 2-person test
7. ✅ Documentation includes examples and screenshots

**Failure Criteria:**
- Collisions go undetected
- Resolution is manual and unclear
- References break frequently
- Process too complex for small teams

---

## Open Questions

1. **Collision suffix format:** A, B, C or 1, 2, 3 or timestamps?
   - Recommendation: Letters (more distinct from base number)

2. **Reference update automation:** Helper script or manual?
   - Phase 1: Manual with clear docs
   - Phase 2: Consider tooling if pain point

3. **Maximum team size:** How many developers before this breaks down?
   - Initial target: 2-5 developers
   - Assess scaling after real-world usage

4. **Conflict resolution timing:** Immediate or batch at release?
   - Recommendation: Immediate (keep work items clean)

5. **Should we support team workflows at all?** Is solo developer enough?
   - Decision: Yes, small team support is valuable
   - But acknowledge it's not enterprise-scale

---

## Alternatives Not Pursued

### Centralized ID Server
- Requires external service (defeats local-first)
- Adds deployment complexity
- Single point of failure

### Git Hooks for Enforcement
- Requires all developers to install hooks
- Can be bypassed
- Doesn't work with git GUIs

### UUID-based IDs
- Loses sequential simplicity entirely
- Terrible for human reference ("work on a7f3c9d2...")
- Overkill for small teams

---

## Notes

**Design Philosophy:**
- Optimize for solo developer (most common case)
- Support small teams without breaking solo simplicity
- Accept some manual work for rare collisions
- Don't over-engineer for enterprise scale (not our target)

**Key Insight:**
Perfect collision prevention requires centralization. We can't avoid this in a distributed, local-first system. Instead, make collisions:
1. Rare (sequential assignment works most of the time)
2. Detectable (git handles this automatically)
3. Resolvable (clear process with good docs)

**Reality Check:**
In a 3-person team creating ~5 work items/week each, collisions might happen 1-2 times per month. Spending 5 minutes on resolution is acceptable overhead.

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Added
- **FEAT-047: Small Team ID Collision Support**
  - Documented collision resolution process for distributed teams
  - Added team workflow section to workflow-guide.md
  - Framework now supports 2-5 developer teams (previously solo only)
  - Created collision resolution guide with examples
  - Optional helper script for automated conflict resolution
```

---

**Last Updated:** 2026-01-11

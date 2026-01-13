# DECISION-035: Root Status Reference Strategy

**ID:** DECISION-035
**Type:** Decision / Investigation
**Priority:** Low
**Status:** Backlog
**Created:** 2026-01-08
**Related:** FEAT-026

---

## Summary

Decide whether the root README.md should reference framework/PROJECT-STATUS.md or have its own root-level status document for the repository.

---

## Context

**Issue identified during:** FEAT-026 external-readiness review

Current structure:
- Root README.md references `framework/PROJECT-STATUS.md`
- This treats framework/ as the "main" project in the repository
- No root-level status document exists

**Questions:**
- Is the framework the "main" project? (probably yes)
- Should repository have its own status document?
- Should we distinguish repository status from framework status?

---

## Current Approach

Root README.md currently includes:
```markdown
**Current Status:** See [framework/PROJECT-STATUS.md](framework/PROJECT-STATUS.md)
```

**This implies:**
- Framework is the primary project
- Framework status represents repository status
- No distinction needed between repository and framework

---

## Options

### Option 1: Keep As-Is (Framework is Main Project)

**Approach:** Continue referencing framework/PROJECT-STATUS.md from root

**Rationale:**
- Framework IS the main project
- examples/hello-world/ is just an example
- templates/ are derived from framework
- Framework status represents repository status

**Pros:**
- ✅ Already working
- ✅ Accurate (framework is main project)
- ✅ No changes needed
- ✅ Simple and clear

**Cons:**
- ❌ Could be confusing in true multi-project repository
- ❌ Doesn't distinguish repository from project

---

### Option 2: Add Root-Level PROJECT-STATUS.md

**Approach:** Create PROJECT-STATUS.md at root for repository status

**Content might include:**
- Overall repository status
- Status of each project (framework, hello-world, templates)
- Monorepo-level decisions and versions

**Pros:**
- ✅ Clear separation: repository vs. project status
- ✅ Room for repository-level information
- ✅ Better for multi-project structure

**Cons:**
- ❌ Redundant if framework is the main project
- ❌ Additional file to maintain
- ❌ Might duplicate framework status

---

### Option 3: Create REPOSITORY-STATUS.md

**Approach:** Create REPOSITORY-STATUS.md at root for repository-specific info

**Content:**
- Monorepo structure and purpose
- Relationship between projects
- Monorepo-level decisions
- Reference to individual project status docs

**Example:**
```markdown
# Monorepo Status

## Projects in This Monorepo

- **framework/** - The Standard Project Framework (MAIN PROJECT)
  - Status: See framework/PROJECT-STATUS.md
  - Version: See framework/CHANGELOG.md

- **examples/hello-world/** - Reference implementation
  - Status: Stable example
  - Purpose: Demonstrate framework usage

- **templates/** - Project starter templates
  - Status: Maintained with framework
  - Purpose: Bootstrap new projects
```

**Pros:**
- ✅ Explicit about repository structure
- ✅ Doesn't duplicate project status
- ✅ Clear separation of concerns

**Cons:**
- ❌ Another file to maintain
- ❌ May be unnecessary complexity

---

## Investigation Questions

1. **What is the primary purpose of the root README?**
   - Introduce the framework? (yes)
   - Explain repository structure? (secondary)

2. **Who is the target audience for root README?**
   - Framework users (primary)
   - Contributors (secondary)
   - Both see root first

3. **Is repository status different from framework status?**
   - Currently no
   - Could diverge in future
   - Probably won't need distinction

4. **What information would go in root status that isn't in framework status?**
   - Probably very little
   - Maybe repository structure decisions
   - Likely redundant

---

## Recommendation

**Recommended:** Option 1 (Keep as-is)

**Reasoning:**
- Framework IS the main project in this repository
- hello-world and templates are supporting projects
- Framework status accurately represents repository status
- No real need for separate root status document
- YAGNI (You Ain't Gonna Need It) principle

**If needed in future:**
- Can add root status document later
- Current approach doesn't prevent future changes
- Wait for actual need rather than anticipating

---

## Decision Criteria

Choose based on:
1. Is framework the primary project? (yes → Option 1)
2. Are other projects independent? (no → Option 1)
3. Is repository information distinct from framework info? (no → Option 1)
4. Will we need root-level status tracking? (unlikely → Option 1)

---

## Implementation

**If Option 1 (recommended):**
- [ ] No changes needed
- [ ] Document decision (this file or ADR)
- [ ] Close this work item

**If Option 2:**
- [ ] Create root-level PROJECT-STATUS.md
- [ ] Reference from root README.md
- [ ] Link to framework/PROJECT-STATUS.md
- [ ] Maintain both going forward

**If Option 3:**
- [ ] Create REPOSITORY-STATUS.md
- [ ] Document repository structure
- [ ] Reference from root README.md
- [ ] Keep framework/PROJECT-STATUS.md unchanged

---

## Completion Criteria

- [ ] Decision made on which option to implement
- [ ] Rationale documented
- [ ] Changes implemented (if not Option 1)
- [ ] Root README.md updated if needed

---

## References

- Source: framework/thoughts/research/backlog-ideas-from-feat-026.md (Item #8)
- Origin: FEAT-026-followup.md line 20-21
- Related: FEAT-026 (external-readiness)

---

## Notes

**Current reality:**
- Framework is clearly the main project
- Monorepo structure is organizational convenience
- Other projects support the framework

**Philosophy:**
- Don't create structure until needed
- Keep simple until complexity is justified
- Current approach works fine

**When to reconsider:**
- If other projects become independent
- If repository tracking becomes distinct from framework
- If contributors are confused by current structure

---

**Last Updated:** 2026-01-08

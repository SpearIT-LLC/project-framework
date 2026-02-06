# Tech: /fw-move Performance Investigation

**ID:** TECH-117
**Type:** Tech Debt
**Priority:** Medium
**Version Impact:** PATCH
**Created:** 2026-02-06
**Theme:** Workflow
**Planning Period:** Sprint WF 2

---

## Summary

Investigate and optimize /fw-move command performance to reduce user friction and improve workflow experience.

---

## Problem Statement

**What problem does this solve?**

`/fw-move` command execution is noticeably slow, creating friction in the workflow.

**Discovered in:** FEAT-011 validation (hello-father project)
- User feedback: "/fw-move was very slow"
- Impact: User experience degradation, workflow friction
- Observation: Test project was slower than framework project, but neither are "blazing fast"

**Current state:**
- /fw-move uses embedded checklists in skill prompt (no PowerShell script)
- Large skill prompt with transition validation logic
- Multiple file reads for precondition checking
- May be spawning subagents

**Who is affected?**
- All users moving work items through workflow
- Impacts every transition (backlog → todo → doing → done)

---

## Requirements

### Functional Requirements

- [ ] Profile /fw-move execution to identify bottlenecks
- [ ] Reduce execution time without sacrificing safety/validation
- [ ] Maintain all transition validations and precondition checks
- [ ] No regression in functionality

### Non-Functional Requirements

- [ ] Measurable improvement (baseline → optimized comparison)
- [ ] No increase in token usage
- [ ] No new dependencies
- [ ] Maintain readable, maintainable code

---

## Investigation Plan

### Phase 1: Profile Current Performance

**Measure:**
1. Baseline execution time for each transition type:
   - backlog → todo
   - todo → doing
   - doing → done
   - done → releases
2. Identify slowest transitions
3. Compare framework project vs. user project performance

**Hypotheses to test:**
- Large skill prompt (embedded checklists) adds overhead
- Multiple file reads (work item, .limit files, dependencies)
- Subagent spawning (if applicable)
- Validation logic complexity

### Phase 2: Identify Bottlenecks

**Potential bottlenecks:**

1. **Skill prompt size**
   - Current: ~400 lines with embedded checklists
   - Could: Reference external checklist files instead?

2. **File read operations**
   - Multiple reads of same work item
   - Reading .limit files
   - Checking dependencies (reading other work items)

3. **Validation complexity**
   - Transition matrix validation
   - Precondition checking
   - Acceptance criteria verification

4. **Subagent spawning**
   - If skill spawns subagent, that adds overhead

### Phase 3: Optimization Strategies

**Option A: Cache work item reads**
- Read work item once, cache in memory
- Reuse for all validations
- Pros: Reduces file I/O
- Cons: Must ensure cache coherency

**Option B: PowerShell script for validations**
- Move validation logic to script
- Script returns pass/fail with reasons
- Pros: Faster execution, less token usage
- Cons: Adds dependency on script

**Option C: Simplify embedded checklists**
- Reference external docs instead of embedding
- Smaller skill prompt
- Pros: Faster skill loading
- Cons: May need more file reads

**Option D: Parallel validation checks**
- Run independent checks concurrently
- Pros: Faster for multi-check transitions
- Cons: More complex implementation

---

## Acceptance Criteria

- [ ] Performance baseline established (current execution times)
- [ ] Bottlenecks identified and documented
- [ ] Optimization implemented with measurable improvement
- [ ] All transition validations still work correctly
- [ ] No regression in safety or functionality
- [ ] Performance improvement verified in both framework and user projects

---

## Dependencies

**Related:**
- TECH-102: Slash command performance optimization (general)
  - Note: TECH-102 focuses on script-based commands
  - /fw-move doesn't use scripts (logic in skill prompt)
  - May have different performance characteristics
- FEAT-011: Discovered performance issue during validation

---

## Open Questions

### 1. Is this related to TECH-102?

**Question:** Does TECH-102's PowerShell startup overhead apply to /fw-move?

**Answer:** Probably not - /fw-move doesn't use PowerShell scripts currently
- TECH-102 addresses script startup time
- /fw-move slowness likely from different cause (skill size, file reads, validation)

**Decision:** Investigate separately, may have different solutions

### 2. What's the acceptable performance target?

**Options:**
- A: Sub-second for simple transitions
- B: Under 3 seconds for complex transitions (doing → done with checks)
- C: 50% improvement from baseline

**Decision:** TBD after baseline measurement

### 3. Should we add a PowerShell script for /fw-move?

**Pros:**
- Centralize validation logic
- Potentially faster
- Reusable outside Claude Code

**Cons:**
- Adds dependency
- Need to keep skill and script in sync
- May not address root cause

**Decision:** Evaluate after profiling

---

## CHANGELOG Notes

```markdown
### Improved
- `/fw-move` command performance optimized
  - [X]% faster execution time
  - Reduced transition latency
  - Maintained all safety validations
```

---

## Notes

**Comparison with TECH-102:**

| Aspect | TECH-102 | TECH-117 |
|--------|----------|----------|
| Scope | All `/fw-*` commands | Specifically `/fw-move` |
| Current impl | PowerShell scripts | Skill prompt logic |
| Bottleneck | Script startup time | Skill size / validation |
| Solution | Cache, optimize scripts | TBD after profiling |

**User Feedback Context:**
- "Test project was slower than framework project"
- Suggests performance varies with project complexity
- May be related to number of work items, dependencies, etc.

**Investigation Priority:**
1. Measure baseline (quantify the problem)
2. Profile to find bottleneck
3. Implement targeted fix (don't over-optimize)

---

**Last Updated:** 2026-02-06

# Spike: [Investigation Topic]

**ID:** SPIKE-NNN
**Type:** Spike
**Priority:** [High | Medium | Low]
**Version Impact:** None
**Created:** YYYY-MM-DD
**Theme:** [Optional - e.g., "Workflow", "Developer Guidance"]
**Planning Period:** [Optional - e.g., "Sprint 3", "Q2 2026"]

<!-- Optional fields - uncomment if needed:
**Assigned:** [Name]
**Depends On:** [ITEM-NNN, ITEM-NNN]
-->

<!-- Blocked fields - uncomment if item is in blocked/:
**Blocked By:** [External party name/description]
**External Reference:** [URL, ticket number, email thread, etc.]
**Reported Date:** YYYY-MM-DD
**Expected Resolution:** YYYY-MM-DD or "Unknown"
**Workaround:** [What we're doing in the meantime, or "None"]
**Follow-up Actions:** [What needs to happen when unblocked]
-->

---

## Investigation Goal

[Clear, focused question or objective for this spike]

**Example:** "Investigate HPC Pack 2016 XML schema compatibility requirements"

---

## Background

**Why is this investigation needed?**

[Context that prompted this spike]

**What decision depends on this?**

[What will we do with these findings?]

**Current knowledge gaps:**

- [ ] Gap 1: [What we don't know]
- [ ] Gap 2: [What we don't know]
- [ ] Gap 3: [What we don't know]

---

## Investigation Scope

### In Scope

- [ ] Area 1 to investigate
- [ ] Area 2 to investigate
- [ ] Area 3 to investigate

### Out of Scope

- [What we explicitly won't investigate in this spike]
- [Keeps focus and prevents scope creep]

---

## Research Questions

1. **Question 1:** [Specific question to answer]
2. **Question 2:** [Specific question to answer]
3. **Question 3:** [Specific question to answer]

---

## Investigation Approach

### Resources to Review

- [ ] Documentation: [Links to docs, specs, RFCs]
- [ ] Code: [Repositories, modules to examine]
- [ ] Tools: [Tools to evaluate]
- [ ] Experts: [People to consult]

### Experiments to Run

- [ ] Experiment 1: [What to test]
  - **Expected outcome:** [Hypothesis]
  - **Actual outcome:** [To be filled]

- [ ] Experiment 2: [What to test]
  - **Expected outcome:** [Hypothesis]
  - **Actual outcome:** [To be filled]

### Prototypes/POCs

- [ ] POC 1: [Quick prototype to build]
  - **Purpose:** [What it will prove/disprove]
  - **Effort:** [Time estimate]

---

## Time Boxing

**Allocated Time:** [X hours]
**Start Time:** [YYYY-MM-DD HH:MM]
**Stop Time:** [YYYY-MM-DD HH:MM or when time box expires]

**Rule:** Stop at time box even if investigation incomplete. Document what's left and whether to continue.

---

## Findings

### Summary

[High-level summary of what was learned]

### Detailed Findings

#### Finding 1: [Topic]

**What we learned:**

[Detailed explanation]

**Evidence/Source:**

[Links, references, test results]

**Confidence Level:** [High | Medium | Low]

#### Finding 2: [Topic]

**What we learned:**

[Detailed explanation]

**Evidence/Source:**

[Links, references, test results]

**Confidence Level:** [High | Medium | Low]

#### Finding 3: [Topic]

**What we learned:**

[Detailed explanation]

**Evidence/Source:**

[Links, references, test results]

**Confidence Level:** [High | Medium | Low]

---

## Answers to Research Questions

1. **Question 1:** [Answer with supporting evidence]
2. **Question 2:** [Answer with supporting evidence]
3. **Question 3:** [Answer with supporting evidence]

---

## Recommendations

### Recommended Approach

[Based on findings, what should we do?]

**Rationale:** [Why this approach?]

**Trade-offs:**
- **Pros:** [Benefits]
- **Cons:** [Drawbacks]

### Alternative Approaches

**Option 1:** [Alternative]
- **Pros:** [Benefits]
- **Cons:** [Drawbacks]
- **When to use:** [Conditions]

**Option 2:** [Alternative]
- **Pros:** [Benefits]
- **Cons:** [Drawbacks]
- **When to use:** [Conditions]

---

## Risks & Unknowns

### Remaining Unknowns

- [ ] Unknown 1: [What we still don't know]
- [ ] Unknown 2: [What we still don't know]

### Risks Identified

- **Risk 1:** [Description]
  - **Likelihood:** [High | Medium | Low]
  - **Impact:** [High | Medium | Low]
  - **Mitigation:** [How to address]

- **Risk 2:** [Description]
  - **Likelihood:** [High | Medium | Low]
  - **Impact:** [High | Medium | Low]
  - **Mitigation:** [How to address]

---

## Next Steps

### Immediate Actions

- [ ] Action 1: [What to do next]
- [ ] Action 2: [What to do next]

### Future Work

- [ ] Follow-up spike if needed: [Topic]
- [ ] Feature to implement: [If spike answers questions]
- [ ] Documentation to update: [What needs updating]

### Decision Required

[What decision can now be made based on these findings?]

**Decision Maker:** [Who needs to decide]
**Timeline:** [When decision is needed]

---

## Prototype/POC Code

**Location:** [Path to prototype code if created]

**Note:** Spike code is exploratory and should NOT be used in production without proper refactoring and testing.

```powershell
# Example prototype code or commands used
# Document experiments run during investigation
```

---

## References

### Documentation

- [Link to relevant documentation]
- [Link to API references]
- [Link to specifications]

### Code Examples

- [Link to example repositories]
- [Link to similar implementations]

### Related Spikes

- [Link to related investigation work]

---

## Retrospective

### What Worked Well

- [What helped the investigation]
- [Useful resources or approaches]

### What Didn't Work Well

- [Dead ends encountered]
- [Wasted effort]

### Lessons Learned

- [Key insights about investigation process]
- [What would we do differently next time]

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->
<!-- User can say "continue to completion" to approve remaining steps at once. -->

- [ ] **PRE-INVESTIGATION REVIEW COMPLETED**
  - AI presents: Investigation goal, research questions, time box, approach
  - User explicitly approves before proceeding

- [ ] Time box set and respected
- [ ] Resources reviewed (documentation, code, tools)
- [ ] Experiments/prototypes completed
- [ ] Findings documented with evidence
- [ ] Research questions answered
- [ ] Recommendations formulated
- [ ] Follow-up work items identified
- [ ] Spike archived to history/spikes/

---

## Notes

[Any additional context, observations, or insights]

**Important Caveats:**

[Limitations of findings, conditions under which conclusions are valid]

---

**Last Updated:** [YYYY-MM-DD]

---

## Spike Workflow Notes

**Spikes DO NOT create releases:**
- Spikes are for learning, not delivering features
- Findings inform future work (features, bugfixes)
- Archive to `history/spikes/` when complete (not `history/releases/`)

**Two Spike Workflows:**

1. **Research Spike (no code artifacts):**
   - Create spike doc in `project-hub/work/backlog/` or directly in `doing/`
   - Archive doc to `project-hub/history/spikes/` when complete

2. **POC Spike (with code artifacts):**
   - Create spike folder in `project-hub/poc/SPIKE-XXX-description/`
   - Put spike doc and code artifacts in the folder
   - Archive entire folder to `project-hub/history/spikes/SPIKE-XXX-description/`
   - After production implementation → optionally delete code artifacts, keep spike doc

**Archive Location (research spike):**
`project-hub/history/spikes/SPIKE-NNN-description.md`

**Archive Location (POC spike):**
`project-hub/history/spikes/SPIKE-NNN-description/` (entire folder)

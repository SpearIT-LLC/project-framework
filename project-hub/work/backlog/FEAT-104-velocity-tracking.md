# Feature: Velocity Tracking and Estimation Improvement

**ID:** FEAT-104
**Type:** Feature
**Priority:** Low
**Version Impact:** MINOR
**Created:** 2026-02-03
**Theme:** Workflow

---

## Summary

Explore feasibility of tracking work velocity to improve estimation accuracy and planning confidence. Considers whether this adds value or creates unnecessary overhead for framework users.

---

## Problem Statement

**What problem does this solve?**

Time estimates for work items and planning periods are often inaccurate:
- FEAT-095 test: Estimated 15-25 minutes, actual experience felt generous but not measured
- Sprint planning: Estimated ~2 weeks per sprint, but no historical data to validate
- No feedback loop: Estimates don't improve over time without measuring actuals

**Who is affected?**

- Solo developers trying to plan realistically
- Teams wanting predictable delivery
- Anyone setting expectations with stakeholders

**Current workaround (if any):**

- Gut-feel estimates based on perceived complexity
- No historical data to inform future estimates
- Planning adjusts reactively when estimates are wrong

---

## Requirements

### Research Questions

**Feasibility:**
- Is velocity tracking too heavyweight for framework's target users (solo devs, small teams)?
- What's the minimum viable approach that provides value without overhead?
- Can this be optional/opt-in for teams that want it?

**Mechanics:**
- What to track: Started date, completed date, estimation (if provided)?
- Where to track: Work item metadata? Separate metrics file?
- How to calculate: Items per period? Points-based? Time-based?

**Value:**
- Does historical velocity actually improve estimation?
- Is the effort to track worth the insight gained?
- What decisions would this data inform?

### Functional Requirements (If Feasible)

- [ ] Minimal metadata addition to work items (started date, optional estimation)
- [ ] Completion date already tracked (exists)
- [ ] Optional velocity calculation command (/fw-velocity?)
- [ ] Simple metrics: Items/sprint, cycle time averages
- [ ] No complex point systems or heavy process

### Non-Functional Requirements

- [ ] Optional - Users can ignore if not valuable for their project
- [ ] Lightweight - Minimal overhead to track
- [ ] Retroactive - Works with historical data (completed dates in work items)
- [ ] Insightful - Provides actionable data, not vanity metrics

---

## Design

### Option 1: Work Item Metadata (Lightweight)

Add optional fields to work item template:
```yaml
**Estimated Effort:** [Optional - XS/S/M/L/XL or hours]
**Started:** [YYYY-MM-DD - when moved to doing/]
**Completed:** [YYYY-MM-DD - when moved to done/] # Already exists
```

Calculate velocity from completed items:
- Count items completed per planning period
- Calculate average cycle time (Started → Completed)
- Track estimation accuracy (Estimated vs Actual)

**Pros:**
- No new files or complex tracking
- Works with existing workflow
- Can be added retroactively

**Cons:**
- Relies on users filling in metadata
- T-shirt sizing is subjective

### Option 2: Planning Period Metrics (Retrospective)

Track metrics as part of planning period archival (FEAT-093):
```markdown
## Metrics
- **Committed:** 5 items
- **Completed:** 4 items
- **Velocity:** 4 items / 2 weeks = 2 items/week
- **Cycle Time:** Average 3.5 days per item
```

**Pros:**
- Only tracked during retrospectives
- Minimal overhead
- Provides trend data over time

**Cons:**
- Only useful if doing planning periods
- Retrospective data, not real-time

### Option 3: Dedicated Metrics File (Heavyweight)

Create `project-hub/project/METRICS.md` tracking all work:
- Detailed time tracking per item
- Burndown charts
- Trend analysis

**Pros:**
- Comprehensive data
- Supports advanced analysis

**Cons:**
- Significant overhead
- Likely overkill for framework's target users

---

## Recommendation

**Start with Option 2 (Planning Period Metrics)**

**Rationale:**
- Already doing retrospectives (FEAT-093)
- Minimal additional work
- Provides actionable trend data
- Can upgrade to Option 1 if users want more detail

**Decision criteria:**
- If 3+ planning periods show consistent underestimation → valuable insight
- If metrics don't change behavior → not worth the overhead
- Re-evaluate after 6 months of usage

---

## Alternative: Just Track Completion Rate

Simplest possible approach:
- Committed: N items
- Completed: M items
- Completion rate: M/N %

No cycle time, no estimation, just "did we finish what we said we would?"

**Benefit:** Dead simple, immediately actionable
**Limitation:** Doesn't help improve estimation accuracy

---

## Dependencies

**Requires:**
- FEAT-093: Planning period archival (provides retrospective capture point)

**Blocks:**
- None (nice-to-have enhancement)

**Related:**
- FEAT-095: Roadmap planning (estimates planning period durations)
- Retrospectives (natural place to review velocity trends)

---

## Acceptance Criteria

**Research Phase:**
- [ ] Evaluate 3 options (lightweight metadata, retrospective metrics, dedicated file)
- [ ] Prototype with framework project for 2-3 planning periods
- [ ] Assess: Does velocity data improve planning accuracy?
- [ ] Decision: Implement, defer, or reject based on value vs overhead

**If Implementing (TBD):**
- [ ] Chosen approach documented
- [ ] Minimal overhead confirmed (<5 min per retrospective)
- [ ] Users can opt-out if not valuable
- [ ] Demonstrates measurable improvement in estimation

---

## Open Questions

1. **Is this solving a real problem?** Do framework users actually struggle with estimation enough to justify tracking?
2. **What's the minimum viable version?** Can we get value with even less than Option 2?
3. **Should this be opt-in or default?** Recommend for all users or only when requested?

---

## CHANGELOG Notes

**For CHANGELOG.md (if implemented):**

```markdown
### Added
- Optional velocity tracking in planning period retrospectives
- Completion rate metrics (committed vs completed items)
- Cycle time averages for completed work
- Historical trend data to improve future estimation
```

---

## Notes

**Triggered by:** FEAT-095 test observation - "time estimates seemed generous, should we track velocity?"

**Philosophy:** Framework should be lightweight. Only add tracking if it meaningfully improves planning without adding burden.

**Success criteria:** Users say "this helps me plan better" not "this is busywork."

**Key insight:** Velocity is only useful if:
1. You're doing repeated planning periods (sprints, quarters)
2. Work is similar enough for historical data to be predictive
3. You actually use the data to adjust future plans

**Consider:** Many solo developers don't need velocity tracking. Teams doing regular sprints might. Make it optional.

---

**Last Updated:** 2026-02-03

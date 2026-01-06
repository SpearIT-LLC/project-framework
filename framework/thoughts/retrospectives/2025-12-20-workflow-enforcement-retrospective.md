# Retrospective: Workflow Enforcement and FEAT-016 Process Violation

**Date:** 2025-12-20
**Participants:** Gary Elliott, Claude Code
**Trigger:** Process violation during FEAT-016 (Quick Reference Guide) implementation
**Type:** Incident Retrospective

---

## Summary

During implementation of FEAT-016 (Framework Quick Reference Guide), we bypassed the established kanban workflow (backlog → todo → doing → done), jumping directly from user request to implementation. This violated the framework's own Standard-level process and revealed a gap in CLAUDE.md guidance for AI-assisted development.

---

## What Happened (Timeline)

1. **User Request:** "Add feature: framework quick reference guide"
2. **AI Response:** Immediately created feature document in backlog/ with status "Doing"
3. **AI Action:** Implemented QUICK-REFERENCE.md without user approval checkpoint
4. **AI Action:** Updated INDEX.md, README.md, CHANGELOG.md
5. **User Observation:** "We just bypassed our own workflow standards"
6. **Team Response:** Stopped, analyzed root cause, implemented fixes

**Violation Details:**
- Feature created in `planning/backlog/` but marked status "Doing"
- Never moved through workflow folders (backlog → todo → doing)
- No approval checkpoint before implementation
- WIP limits not checked
- Framework's own process not followed (dogfooding failure)

---

## What Went Well ✅

### 1. Dogfooding Caught the Issue
- **What:** Using the framework on itself revealed the process gap
- **Why It Mattered:** Real-world validation of framework processes
- **Lesson:** Dogfooding works! Keep doing it.

### 2. User Caught the Violation Immediately
- **What:** User noticed and called out the process violation
- **Why It Mattered:** Quick detection prevented pattern from continuing
- **Lesson:** Clear processes make violations obvious

### 3. Quick, Decisive Response
- **What:** Stopped feature work, analyzed root cause, fixed the system
- **Why It Mattered:** Prevented future violations
- **Lesson:** When process breaks, fix the process (don't just fix the instance)

### 4. Collaborative Problem-Solving
- **What:** User and AI worked together to design solution
- **Why It Mattered:** Better solution than either would create alone
- **Lesson:** AI + human collaboration strengthens process design

### 5. Comprehensive Fix
- **What:** Created ADR-001, updated CLAUDE.md, planned future features
- **Why It Mattered:** Addressed root cause, not just symptoms
- **Lesson:** Process improvements should be thorough and documented

---

## What Didn't Go Well ⚠️

### 1. CLAUDE.md Lacked Workflow Enforcement Guidance
- **What:** No explicit instruction for AI to pause before implementing features
- **Why It Happened:** CLAUDE.md said "output a clear plan first" but didn't enforce workflow
- **Impact:** AI jumped to implementation without approval
- **Root Cause:** Implicit vs. explicit guidance - AI needs explicit steps

### 2. No Distinction Between Backlog and Implementation
- **What:** Creating backlog item was treated as permission to implement
- **Why It Happened:** No clear checkpoint defined
- **Impact:** User lost control over timing and priorities
- **Root Cause:** Conversation-based AI assumes continuity; needs explicit stops

### 3. Status Field in Document vs. Folder Location Mismatch
- **What:** Document said "Doing" while sitting in backlog/ folder
- **Why It Happened:** Status field updated before file moved
- **Impact:** Inconsistent state, confusing workflow tracking
- **Root Cause:** Two sources of truth (folder + status field) can diverge

### 4. WIP Limits Not Checked
- **What:** No verification of work/doing/ capacity before starting
- **Why It Happened:** Process jumped directly to implementation
- **Impact:** Could have violated WIP limit (didn't in this case)
- **Root Cause:** No enforcement mechanism in AI guidance

---

## Process Improvements Implemented

### Immediate Actions (Completed)

1. **ADR-001: AI Workflow Checkpoint Policy**
   - **What:** Formal decision requiring approval before implementation
   - **Location:** `thoughts/project/research/adr/001-ai-workflow-checkpoint-policy.md`
   - **Impact:** Establishes pattern for all future features

2. **CLAUDE.md Updated**
   - **What:** Added "AI Workflow Checkpoint Policy" section
   - **Content:** 9-step process with explicit approval checkpoint
   - **Impact:** AI now has clear, enforceable workflow steps

3. **FEAT-017: Backlog Review Command (Planned)**
   - **What:** Command to help review and approve backlog items
   - **Why:** Makes approval checkpoint easier to follow
   - **Status:** Backlog, not implementing yet (following our new process!)

4. **FEAT-018: Claude Command Framework (Planned)**
   - **What:** Infrastructure for workflow automation commands
   - **Why:** Makes framework operations consistent and reusable
   - **Status:** Backlog, planned for future

### Future Actions (Recommendations)

1. **Validation Script** (From existing FEAT-007)
   - Add check: Verify status field matches folder location
   - Add check: Ensure WIP limits respected
   - Run automatically or on-demand

2. **Session History Review**
   - At end of each session, review workflow compliance
   - Document any violations and fixes

3. **Retrospective After Major Milestones**
   - Review process effectiveness
   - Gather feedback on what's working/not working

---

## Key Learnings

### Technical Learnings

1. **Explicit > Implicit for AI Guidance**
   - AI needs step-by-step instructions, not principles
   - "Pause for approval" must be explicit, not implied

2. **Single Source of Truth Matters**
   - Status should be determined by folder location
   - Document status field is redundant (consider removing?)

3. **Checkpoints Are Non-Negotiable**
   - Without explicit checkpoint, AI will optimize for speed
   - User control requires forced stops in workflow

### Process Learnings

1. **Dogfooding Reveals Truth**
   - Using framework on itself found real issues
   - Best validation method we have

2. **Backlog Should Be "Safe Space"**
   - Users should freely add ideas without triggering work
   - Clear separation between "idea captured" and "work started"

3. **Workflow Enforcement Requires Tools**
   - Manual compliance is error-prone
   - Commands/scripts can help enforce process

### Collaboration Learnings

1. **User Feedback Is Critical**
   - AI can't self-detect process violations
   - User calling out issues makes framework better

2. **Fix The System, Not The Symptom**
   - Don't just correct one violation
   - Update process to prevent future violations

---

## Action Items for Next Session

- [x] ADR-001 created
- [x] CLAUDE.md updated
- [x] FEAT-017 planned (backlog)
- [x] FEAT-018 planned (backlog)
- [x] Retrospective documented
- [ ] FEAT-016 moved through proper workflow (retroactive compliance)
- [ ] Update kanban-workflow.md to reference ADR-001
- [ ] Consider: Remove status field from templates (folder = source of truth)

---

## Metrics

**Process Violations:** 1 (FEAT-016)
**Time to Detection:** < 5 minutes (immediate)
**Time to Fix:** ~2 hours (analysis + ADR + CLAUDE.md + features + retro)
**Outcome:** Process strengthened, future violations prevented

---

## Similar Issues to Watch For

1. **Bugfixes bypassing workflow** - Same pattern could happen with urgent bugs
2. **Documentation updates skipping review** - Docs might seem "quick" enough to skip process
3. **Multi-feature requests** - User requests A, B, C - does AI implement all immediately?

---

## References

- [ADR-001: AI Workflow Checkpoint Policy](../research/adr/001-ai-workflow-checkpoint-policy.md)
- [CLAUDE.md](../../CLAUDE.md) - Updated with checkpoint policy
- [FEAT-016](../planning/backlog/feature-016-quick-reference.md) - The triggering incident
- [FEAT-017](../planning/backlog/feature-017-backlog-review-command.md) - Follow-up feature
- [FEAT-018](../planning/backlog/feature-018-claude-command-framework.md) - Follow-up feature
- [kanban-workflow.md](../../project-framework-template/standard/thoughts/framework/process/kanban-workflow.md) - Process we violated

---

## Conclusion

This incident was a **valuable learning opportunity** that:
- Validated dogfooding approach
- Strengthened framework process
- Clarified AI-human collaboration patterns
- Created reusable decision (ADR-001)
- Planned future improvements (FEAT-017, FEAT-018)

The framework is now more robust and explicit about workflow enforcement. Future AI-assisted development will follow a clear, user-controlled process.

**Most Important Takeaway:** When the process breaks, fix the process. Don't just fix the instance.

---

**Next Review:** After implementing FEAT-017 (backlog review command) - evaluate if checkpoint policy is working well in practice.

**Last Updated:** 2025-12-20

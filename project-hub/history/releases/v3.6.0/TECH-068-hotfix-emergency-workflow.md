# Tech Debt: Document WIP Limit Flexibility

**ID:** TECH-068
**Type:** Tech Debt
**Priority:** High
**Version Impact:** PATCH
**Created:** 2026-01-23

---

## Summary

The framework lacks guidance on when and how to temporarily adjust WIP limits. After discussion, the "hotfix path" is better addressed through WIP flexibility guidance rather than a separate expedited workflow.

---

## Problem Statement

**What is the current state?**

- WIP limit of 1 is documented but inflexible
- No guidance on handling urgent work while mid-feature
- No documented pattern for "pause and resume" vs "temporary parallel work"

**Why is this a problem?**

- Developers unsure when it's okay to adjust WIP
- No clear criteria for temporary exceptions
- Missing guidance leads to either rigid adherence or ignoring limits entirely

**What is the desired state?**

- Clear guidance on when WIP adjustment is appropriate
- Documented patterns: pause/resume vs temporary bump
- Guardrails for returning to normal WIP

---

## Proposed Solution

Add "WIP Limit Flexibility" section to `workflow-guide.md` covering:

1. **Pause & Resume Pattern** (keep WIP=1)
   - When: Current work can wait, new issue isn't time-critical
   - How: Move current item to todo, work new item, resume later
   - Benefit: Enforced focus, clean history

2. **Temporary WIP Bump** (WIP=2)
   - When: Current work mid-flight, new issue urgent but not "drop everything"
   - Criteria:
     - Production issue while mid-feature
     - Blocking dependency on another team
     - Time-boxed parallel work
   - Guardrails:
     - Document why in work item or session history
     - Set time limit
     - Return to WIP=1 when one item completes

3. **Guidance Principles**
   - WIP limits are tools, not laws
   - The overhead of pause/resume is low (~2 minutes)
   - Most "emergencies" don't require WIP bump
   - When in doubt, pause and resume

**Files Affected:**
- `framework/docs/collaboration/workflow-guide.md` - Add WIP Limit Flexibility section
- `templates/standard/framework/docs/collaboration/workflow-guide.md` - Sync changes

---

## Acceptance Criteria

- [x] WIP Limit Flexibility section added to workflow-guide.md
- [x] Pause & Resume pattern documented
- [x] Temporary WIP Bump criteria documented
- [x] Guardrails for returning to normal WIP
- [x] Template synced to templates/standard/

---

## Notes

Discovered during FEAT-025 validation testing. Originally scoped as "Hotfix/Emergency Workflow" but refined through discussion to focus on WIP limit flexibility, which addresses the underlying need more elegantly.

**Completed 2026-01-23:**
- Added "WIP Limit Flexibility" section to workflow-guide.md
- Documented Pause & Resume pattern (recommended default)
- Documented Temporary WIP Bump pattern with guardrails
- Synced to templates/standard/

---

## Related

- FEAT-025: Manual Setup Validation (source of finding)
- TECH-069: Work item cancellation process
- TECH-070: Rollback/revert policy

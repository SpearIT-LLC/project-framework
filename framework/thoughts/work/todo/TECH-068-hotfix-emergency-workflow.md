# Tech Debt: Document Hotfix/Emergency Workflow

**ID:** TECH-068
**Type:** Tech Debt
**Priority:** High
**Version Impact:** PATCH
**Created:** 2026-01-23

---

## Summary

The framework lacks documented procedures for handling critical bugs that need expedited resolution. Testing (FEAT-007 in project-hello-world) revealed no hotfix path exists.

---

## Problem Statement

**What is the current state?**

- No expedited workflow path for critical issues
- WIP limits don't have priority-based exceptions
- All workflow constraints are advisory only with no enforcement
- Critical bugs must follow same backlog → todo → doing → done path as features

**Why is this a problem?**

- Production-breaking bugs cannot be fast-tracked
- Team may need to violate workflow to respond to emergencies
- No documented guidance leads to ad-hoc decisions under pressure

**What is the desired state?**

- Documented hotfix workflow with clear criteria for when to use
- Defined WIP limit exceptions for priority-based work
- Clear escalation path for critical issues

---

## Proposed Solution

Add hotfix/emergency workflow section to `workflow-guide.md`:

1. **Hotfix Criteria** - When does an issue qualify for expedited handling?
   - Production down
   - Security vulnerability
   - Data corruption risk
   - SLA breach imminent

2. **Expedited Path** - What workflow modifications are allowed?
   - Direct backlog → doing transition permitted
   - WIP limit temporarily suspended
   - Skip pre-implementation review (but document why)

3. **Required Documentation** - What must be captured?
   - Reason for expedited handling
   - Impact assessment
   - Post-incident review requirement

4. **Return to Normal** - How to restore workflow discipline?
   - Complete retrospective after emergency
   - Document lessons learned
   - Update procedures if needed

**Files Affected:**
- `framework/docs/collaboration/workflow-guide.md` - Add Hotfix Workflow section
- `templates/standard/framework/docs/collaboration/workflow-guide.md` - Sync changes

---

## Acceptance Criteria

- [ ] Hotfix workflow documented in workflow-guide.md
- [ ] Clear criteria for when hotfix path applies
- [ ] WIP limit exception documented
- [ ] Required documentation for expedited items defined
- [ ] Template synced to templates/standard/

---

## Notes

Discovered during FEAT-025 validation testing. See:
- `project-hello-world/FRAMEWORK-TEST-RESULTS.md`
- `project-hello-world/SETUP-VALIDATION-NOTES.md`

---

## Related

- FEAT-025: Manual Setup Validation (source of finding)
- TECH-069: Work item cancellation process
- TECH-070: Rollback/revert policy

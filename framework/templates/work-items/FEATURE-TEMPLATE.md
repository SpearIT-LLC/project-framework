# Feature: [Feature Name]

**ID:** FEAT-NNN
**Type:** Feature
**Priority:** [High | Medium | Low]
**Version Impact:** [MAJOR | MINOR | PATCH]
**Created:** YYYY-MM-DD
**Theme:** [Optional - e.g., "Distribution & Onboarding", "Workflow", "Project Guidance", "Developer Guidance"]
**Planning Period:** [Optional - e.g., "Sprint 3", "Q2 2026", "Beta Phase", "Foundation Epic"]

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

## Summary

[1-2 sentence description of what this feature does and why it's needed]

---

## Problem Statement

**What problem does this solve?**

[Detailed description of the problem or limitation this feature addresses]

**Who is affected?**

[Users, administrators, developers, etc.]

**Current workaround (if any):**

[How users currently handle this, or "None"]

---

## Requirements

### Functional Requirements

- [ ] Requirement 1: [Clear, testable requirement]
- [ ] Requirement 2: [Clear, testable requirement]
- [ ] Requirement 3: [Clear, testable requirement]

### Non-Functional Requirements

- [ ] Performance: [Performance requirements, if any]
- [ ] Security: [Security considerations, if any]
- [ ] Compatibility: [Backward compatibility requirements]
- [ ] Documentation: [Documentation that must be updated]

---

## Design

### Architecture Impact

**Files Modified:**
- `path/to/file1.ps1` - [Brief description of changes]
- `path/to/file2.psm1` - [Brief description of changes]

**Files Added:**
- `path/to/newfile.ps1` - [Purpose of new file]

**Configuration Changes:**
```json
{
  "new_setting": "value",
  "description": "What this setting controls"
}
```

**Data Schema Changes:**

[Describe any changes to JSON schemas, XML formats, or data structures]

### Implementation Approach

[High-level description of how this will be implemented. Include key algorithms, patterns, or techniques.]

**Key Components:**

1. **Component 1:** [Description]
2. **Component 2:** [Description]
3. **Component 3:** [Description]

### Alternative Approaches Considered

**Option 1:** [Alternative approach]
- Pros: [Benefits]
- Cons: [Drawbacks]
- Decision: [Why not chosen]

**Option 2:** [Alternative approach]
- Pros: [Benefits]
- Cons: [Drawbacks]
- Decision: [Why not chosen]

---

## Dependencies

**Requires:**
- [Other features, libraries, or components needed]

**Blocks:**
- [Features that are waiting on this]

**Related:**
- [Related features or issues]

---

## Testing Plan

### Unit Tests

- [ ] Test scenario 1: [Description]
- [ ] Test scenario 2: [Description]

### Integration Tests

- [ ] Test scenario 1: [Description]
- [ ] Test scenario 2: [Description]

### Edge Cases

- [ ] Edge case 1: [Description and expected behavior]
- [ ] Edge case 2: [Description and expected behavior]

### Manual Testing Steps

1. [Step-by-step instructions for manual testing]
2. [Include expected results]
3. [Include verification steps]

---

## Security Considerations

[Review against security-policy.md]

- [ ] Input validation implemented
- [ ] No credential exposure in logs
- [ ] Path traversal prevention
- [ ] Error messages don't leak sensitive info
- [ ] Follows principle of least privilege

---

## Documentation Updates

### Files to Update

- [ ] README.md - [What sections need updating]
- [ ] system-architecture.md - [What sections need updating]
- [ ] [Other relevant documentation]

### New Documentation Needed

- [ ] Usage examples
- [ ] Configuration guide
- [ ] Troubleshooting section

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->
<!-- User can say "continue to completion" to approve remaining steps at once. -->

- [ ] **PRE-IMPLEMENTATION REVIEW COMPLETED**
  - AI presents: What we're building, key decisions, open questions, scope
  - User explicitly approves before proceeding

- [ ] Design reviewed and approved
- [ ] Code implemented following coding-standards.md
- [ ] ASCII-only characters in code (no Unicode)
- [ ] PowerShell 5.1 compatibility verified
- [ ] Unit tests written and passing
- [ ] Integration tests written and passing
- [ ] Edge cases tested
- [ ] Security review completed
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
- [ ] Version numbers bumped in affected files

---

## Rollout Plan

**Deployment Steps:**

1. [Step-by-step deployment instructions]
2. [Include backup/rollback procedures]

**Rollback Plan:**

[How to revert this feature if issues are found]

---

## Success Metrics

**How do we know this feature is successful?**

- Metric 1: [Measurable success criterion]
- Metric 2: [Measurable success criterion]

---

## Timeline

| Phase | Estimated Hours | Actual Hours | Status |
|-------|-----------------|--------------|--------|
| Planning | X hours | Y hours | [Complete/In Progress/Pending] |
| Implementation | X hours | Y hours | [Complete/In Progress/Pending] |
| Testing | X hours | Y hours | [Complete/In Progress/Pending] |
| Documentation | X hours | Y hours | [Complete/In Progress/Pending] |
| **Total** | **XX hours** | **YY hours** | |

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Added
- [Brief description of what was added]
  - [Detail 1]
  - [Detail 2]
```

**Keep notes here during development, copy to CHANGELOG.md when releasing.**

---

## Notes

[Any additional notes, decisions, or context that doesn't fit elsewhere]

---

## References

- [Link to related documentation]
- [Link to external resources]
- [Link to related issues or discussions]

---

**Last Updated:** [YYYY-MM-DD]

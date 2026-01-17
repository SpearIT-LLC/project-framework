# Session History: 2026-01-17

**Date:** 2026-01-17
**Participants:** Gary Elliott, Claude (Opus 4.5)
**Session Focus:** FEAT-059 - Role Reduction and Schema Enhancement
**Duration:** ~1 hour

---

## Summary

Senior Architect review of the roles system leading to significant reduction (22 → 13 base roles) and two new schema features: `requires_context` for roles needing domain clarification, and `triggers` for variant activation hints.

---

## Work Completed

### 1. Role Redundancy Analysis

Reviewed 22 base roles from Senior Architect perspective, identifying:

**Clear Redundancies:**
- `user_advocate` and `ux_designer` had identical senior mindsets (word-for-word)
- Four overlapping security roles: `security_analyst`, `qa_engineer.security`, `reviewer.security`, `analyst.security`
- `reviewer` role duplicated functionality of other roles (sme, legal, security, architecture variants)
- C-suite roles (`ceo`, `cto`) provided perspective but limited practical activation scenarios
- `compliance_officer`, `auditor`, `legal_counsel` all addressed "are we doing this right?" with subtle differences
- `project_manager` overlapped with `scrum_master` for kanban workflows

**Roles Removed:**
- `reviewer` (other roles can review)
- `ux_designer` (merged into `user_advocate.ux` variant)
- `ceo`, `cto` (perspective folded into existing roles)
- `project_manager` (scrum_master sufficient for workflow)
- `support_engineer`, `change_manager` (operational roles with unclear activation)
- `compliance_officer`, `auditor`, `legal_counsel` (merged into `compliance`)

### 2. New `compliance` Role

Created merged role combining legal, audit, and regulatory perspectives:

```yaml
compliance:
  family: governance
  verb: ensures
  description: "Verifies regulatory compliance, legal obligations, and audit readiness"
  tiers:
    senior:
      mindset: "What's our exposure? What would a third party conclude? Are we building trust or just checking boxes?"
  variants:
    legal:
      mindset: "What's our liability? Is this enforceable? What are we agreeing to?"
    audit:
      mindset: "Can we prove this? What evidence exists? Would this pass scrutiny?"
```

### 3. `requires_context` Schema Feature

Added for roles that need domain clarification before activation:

```yaml
requires_context:
  question: "What domain should I focus my expertise on?"
  examples:
    - "Legal/contracts"
    - "Healthcare/HIPAA"
    - "Financial services"
```

**Roles using `requires_context`:**
- `subject_matter_expert` - "What domain should I focus my expertise on?"
- `compliance` - "What regulatory or compliance framework applies?"
- `analyst` - "What are we analyzing?"

### 4. `triggers` Schema Feature

Added to variants as conversational matching hints:

```yaml
variants:
  prototype:
    mindset: "Speed over polish. Prove the concept. Don't overthink."
    triggers:
      - "prototype"
      - "spike"
      - "proof of concept"
      - "POC"
      - "just exploring"
```

**Key insight:** Variants fundamentally change the *approach* to work, not just the domain. `developer.prototype` and `developer.refactoring` will write completely different code.

---

## Decisions Made

### Decision 1: Reduce to 13 Base Roles
**Question:** Can we reduce roles without losing capability?
**Decision:** Yes - 22 → 13 roles with no practical loss.
**Rationale:** Several roles duplicated functionality, others had unclear activation scenarios.

### Decision 2: `requires_context` for Domain Clarification
**Question:** How do we handle `subject_matter_expert` without knowing the domain?
**Decision:** Add `requires_context` field with question + examples.
**Rationale:** AI should ask rather than guess domain expertise needed.

### Decision 3: `triggers` as Hints, Not Automatic
**Question:** Should triggers automatically activate variants?
**Decision:** No - triggers are hints for conversational matching.
**Rationale:** Explicit over implicit. User stays in control.

### Decision 4: Domain Knowledge via Adaptation
**Question:** Do we lose domain knowledge with fewer roles?
**Decision:** No - Claude adapts to domains. We lose pre-packaged mindset constraints, which `subject_matter_expert` + `requires_context` addresses.
**Rationale:** Roles constrain *stance*, not *knowledge*. Claude has the knowledge regardless.

---

## Final Role Structure (13 Base Roles)

| Family | Roles |
|--------|-------|
| Perspective | `claude` |
| Creation | `developer`, `architect`, `technical_writer`, `data_engineer` |
| Validation | `qa_engineer`, `security_analyst`, `subject_matter_expert`, `user_advocate` |
| Governance | `scrum_master`, `release_manager`, `compliance` |
| Strategy | `product_owner`, `analyst` |
| Operations | `devops_engineer` |

---

## Files Modified This Session

1. `framework/docs/ref/framework-roles.yaml` - Rewrote with 13 roles, added `requires_context` and `triggers` (schema v2.0)
2. `framework/docs/ref/framework-schema.yaml` - Added role definition schema including `requires_context` and `triggers`

---

## Commits This Session

(Pending)

---

## Open Questions

1. **Variant inheritance:** Currently variant mindset replaces base mindset. Should experience tier still apply to variants?
   - Current: `developer.prototype` uses prototype mindset only
   - Alternative: `senior-developer.prototype` = senior judgment + prototype approach

2. **Update FEAT-059 work item:** Checklist and CHANGELOG notes need updating to reflect role reduction.

---

## Future Exploration: Human Roles

**Question explored:** Do humans have roles too? Should we formalize them?

### Observation: Humans Shift Roles Unconsciously

| Activity | Human's Implicit Role | AI Role |
|----------|----------------------|---------|
| "I have an idea for a feature" | Product Owner (defining need) | analyst, product_owner |
| "Let's plan how to build this" | Architect/PM (structuring) | architect, scrum_master |
| "Write the code for X" | Delegator/Reviewer (directing) | developer |
| "This doesn't look right" | QA/Reviewer (validating) | qa_engineer |
| "Ship it" | Release Authority (approving) | release_manager |

### Key Insight: Complementary Role Pairing

The human often plays a **complementary** role to the AI:
- When AI is `developer`, human is reviewer/director
- When AI is `scrum_master`, human is workflow authority
- When AI is `architect`, human is decision maker

### Asymmetries in the Collaboration

**Humans have authority the AI doesn't:**
- Final approval on releases
- Commit to work (backlog → todo approval)
- Override calculated versions
- Accept/reject AI recommendations

**AI has capabilities humans leverage:**
- Rapid implementation
- Consistent policy enforcement
- Exhaustive search/analysis
- Parallel exploration of options

### Recommendation: Don't Formalize (Yet)

**Why not formalize human roles now:**
- Humans shift roles unconsciously and fluidly
- Formalizing could feel bureaucratic
- The framework already captures human authority through approval checkpoints
- Human role is implicitly defined by the AI's role

**The human is always the authority and context source.** The AI adopts roles to serve different aspects of that authority.

**Captured for future reference** - if we find a use case where explicit human role pairing adds value, this analysis provides a starting point.

---

## Notes

- Significant simplification achieved without losing practical capability
- `requires_context` is a natural extension of conversational triggering design
- `triggers` enable future "smart suggestion" features without automatic activation
- The Senior Architect mindset proved valuable for this review - "What's the simplest thing that could work?"

---

**Last Updated:** 2026-01-17

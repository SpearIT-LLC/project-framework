# Session History: 2026-01-16

**Date:** 2026-01-16
**Participants:** Gary Elliott, Claude Code
**Session Focus:** FEAT-059 - Context-Aware AI Roles (Deep Exploration + Schema Draft)
**Duration:** ~3 hours

---

## Summary

Deep exploration of AI role patterns for FEAT-059. Cataloged 25 base roles with 40 variants, designed a minimal 5-property schema, established `/fw-` command prefix as the primary activation mechanism, drafted the complete YAML schema, and simplified to 22 base roles by removing redundancies.

---

## Work Completed

### 1. Comprehensive Role Exploration

Created extensive research document cataloging potential AI roles:

**25 Base Roles** organized into 6 categories:
- **Creation (5):** Developer, Architect, Technical Writer, UX Designer, DBA
- **Validation (6):** QA Engineer, Security Analyst, Performance Engineer, Auditor, SME, User Advocate
- **Governance (4):** Scrum Master, Release Manager, Compliance Officer, Legal Counsel
- **Strategy (6):** Product Owner, Business Analyst, Financial Analyst, CEO, CTO, Project Manager
- **Operations (4):** DevOps Engineer, Support Engineer, Change Manager, Risk Manager

**40 Role Variants** across 6 base role families:
- Developer (8): Prototype, Production, Refactoring, Performance, Security-Focused, Test, Maintenance, API
- Writer (9): Draft, Technical, Policy, Editorial, User Guide, Executive, Compliance, Training, Maintenance
- Reviewer (8): SME, Editorial, Stakeholder, Legal, User, Code, Security, Architecture
- Architect (5): Solution, Enterprise, Security, Data, Integration
- Analyst (5): Business, Data, Security, Financial, Risk
- QA (5): Manual Tester, Automation Engineer, Performance Tester, Security Tester, Accessibility Tester

### 2. Role Schema Design

Explored comprehensive role properties, then refined to minimal schema:

**Key insight:** A well-written mindset statement encodes priorities, constraints, and outputs without needing separate fields.

**Final schema (5 properties):**
```yaml
role_name:
  family: creation | validation | governance | strategy | operations
  verb: builds | validates | governs | directs | operates
  description: "Human-readable summary"
  tiers:
    mid_level:
      mindset: "The internal voice at this level"
    senior:
      mindset: "The internal voice at this level"
  variants:  # null for singular roles
    variant_name:
      mindset: "Context-specific internal voice"
```

**Naming pattern:** `{experience}-{variant}-{base_role}` (e.g., `senior-production-developer`)

### 3. Activation Mechanism Design

Evaluated 5 activation approaches:

| Mechanism | Reliability | Friction |
|-----------|-------------|----------|
| Explicit selection | High | High |
| Trigger phrase matching | Medium | Low |
| Context inference | Low-Medium | None |
| Project configuration | High | Medium (once) |
| Hybrid | High | Hard to implement |

**Decision:** Reliability is essential. Start with explicit commands.

### 4. User Configuration Design

Explored collision-free, scalable solution for user preferences:

**Decision:** `~/.spearit/projects.yaml` keyed by `project.id`

```yaml
# ~/.spearit/projects.yaml
projects:
  project-framework:
    default_role: senior-production-developer
  client-webapp:
    default_role: senior-security-focused-developer
```

**Why this works:**
- Zero collision risk (each user has own home directory)
- Keyed by project.id from framework.yaml
- Survives fresh clones
- Team members never touch each other's config

### 5. Slash Command Design

**Problem:** Need reliable activation that avoids collision with Claude Code builtins.

**Research:** Found `/init`, `/status`, `/help` are built-in Claude Code commands.

**Decision:** `/fw-` prefix for all framework commands.

**Benefits:**
- Avoids collision with builtins and plugins
- Self-teaching via autocomplete (type `/fw-` to see all commands)
- Clear namespace for framework functionality

**Proposed commands:**

| Command | Purpose |
|---------|---------|
| `/fw-role` | Show/switch AI role |
| `/fw-roles` | List available roles |
| `/fw-setup` | Initialize framework, set defaults |
| `/fw-status` | Project status summary |
| `/fw-backlog` | Review backlog (FEAT-017) |
| `/fw-wip` | Check WIP limits |
| `/fw-release` | Prepare release |
| `/fw-validate` | Check framework compliance |

### 6. Cross-References Added

Updated FEAT-017 and FEAT-018 with references to FEAT-059 activation strategy and `/fw-` prefix convention.

---

## Decisions Made

### Decision 1: Mindset Is Sufficient
**Question:** Should role definitions include priorities, constraints, typical_outputs as separate fields?
**Decision:** No - a well-written mindset statement captures all of this.
**Rationale:** Simplicity. Fewer fields = easier to maintain and understand.

### Decision 2: Default to Senior Experience
**Question:** What if experience tier is unspecified?
**Decision:** Default to Senior. Include validation check for missing context.
**Rationale:** We want excellence from the start.

### Decision 3: Variant Mindset Overrides Tier Mindset
**Question:** Does `prototype-developer` inherit base developer mindset?
**Decision:** No - variant mindset replaces tier mindset. Variant is more specific.
**Rationale:** Avoid confusing mixed signals.

### Decision 4: No Role Combinations
**Question:** Support "Developer with Security focus" as combination?
**Decision:** No - that's just Security-Focused Developer. One role at a time.
**Rationale:** Simplicity. Revisit if limiting in practice.

### Decision 5: Phases Are Documentation Only
**Question:** Should lifecycle phases be a framework activation mechanism?
**Decision:** No - phases are reference material, not tracked state.
**Rationale:** Users say "handle edge cases" not "I'm in Harden phase." Variants capture this naturally.

### Decision 6: Explicit Commands First
**Question:** How do we activate roles?
**Decision:** Start with explicit `/fw-role` command. Add smart features later.
**Rationale:** Reliability is essential. Explicit = testable, predictable.

### Decision 7: `/fw-` Command Prefix
**Question:** Should framework commands have a namespace prefix?
**Decision:** Yes - `/fw-` prefix for all framework commands.
**Rationale:** Avoids collision with Claude Code builtins, enables self-teaching via autocomplete.

### Decision 8: User Config in Home Directory
**Question:** Where do user preferences live?
**Decision:** `~/.spearit/projects.yaml` keyed by project.id.
**Rationale:** Zero collision risk, scales to teams, survives fresh clones.

---

## Files Modified This Session

1. `framework/thoughts/work/backlog/FEAT-059-role-exploration.md` - Created and expanded (research + decisions)
2. `framework/thoughts/work/backlog/FEAT-059-roles.yaml` - Created (complete role schema, 22 base roles + 40 variants)
3. `framework/thoughts/work/todo/feature-017-backlog-review-command.md` - Added FEAT-059 cross-reference
4. `framework/thoughts/work/todo/feature-018-claude-command-framework.md` - Added FEAT-059 cross-reference

### Role Simplification

Removed 3 redundant standalone roles:
- `performance_engineer` → use `qa_engineer.variants.performance`
- `business_analyst` → use `analyst.variants.business`
- `financial_analyst` → use `analyst.variants.financial`

**Final count:** 22 base roles + 40 variants (down from 25 base roles)

---

## Commits This Session

1. `docs(FEAT-059): Add comprehensive role exploration and schema design`
2. `docs(FEAT-059): Explore role activation mechanisms`
3. `docs(FEAT-059): Design /fw- command activation strategy`
4. `docs(FEAT-059): Draft complete role schema and simplify to 22 base roles`

---

## Open Questions Resolved This Session

1. **No role + no default:** ~~Ask user, or fall back to generic assistant?~~ → **Use project type default**
2. **Project type → default base role:** ~~Should project type suggest a starting role?~~ → **Yes**
3. **Trigger phrases:** ~~Worth adding as Phase 2 supplement, or skip to AI suggestions?~~ → **Skip trigger phrases, go straight to AI suggestions**

### Decision 9: Project Type Defaults
**Question:** What role to use when none specified?
**Decision:** Default based on project type (e.g., `application` → `senior-production-developer`)
**Rationale:** Sensible starting point without requiring explicit selection.

### Decision 10: Skip Trigger Phrases
**Question:** Should Phase 2 use trigger phrase matching?
**Decision:** No - skip to AI suggestions with user confirmation.
**Rationale:** Trigger phrases are brittle (false positives, phrase explosion, context blindness). Let the smart system be smart.

---

## Notes

- FEAT-059 role exploration is substantial research (1100+ lines)
- Key insight: "verb per role family" organizes roles naturally (builds, validates, governs, directs, operates)
- `/fw-` prefix decision has implications for FEAT-017 (`/fw-backlog`) and FEAT-018 (whole command framework)
- User config solution prioritizes scalability over convenience (config doesn't travel with repo)
- Phased rollout: Explicit commands → AI suggestions → Context inference (never overriding explicit)

---

**Session End:** FEAT-059 role schema drafted, simplified to 22 roles, all design decisions resolved

---

**Last Updated:** 2026-01-16

# Session History: 2026-01-17

**Date:** 2026-01-17
**Participants:** Gary Elliott, Claude (Opus 4.5)
**Session Focus:** FEAT-059 - Role Reduction, Testing, and Policy Enforcement Analysis
**Duration:** ~2 hours (2 sessions)

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

## Session 2 - FEAT-059 Testing and Policy Enforcement

### Summary

Tested the roles system and discovered a fundamental gap: roles help with judgment but don't reliably enforce procedure. Even with documentation, policies, and roles in place, the AI didn't proactively follow all policy requirements.

### Work Completed

#### 1. Project Type Defaults Review

Fixed misaligned defaults in `framework-roles.yaml`:
- `framework` type: `senior-production-developer` → `senior-architect` (design focus, not code focus)
- Renamed `tool` → `toolbox` project type with `senior-prototype-developer` default
- Updated `framework-schema.yaml` with new `toolbox` type definition

#### 2. FEAT-059 Testing

| Test | Result | Notes |
|------|--------|-------|
| Invalid transition (backlog → doing) | ✅ Pass | AI read policy, pushed back correctly |
| Valid transition (backlog → todo) | ❌ Partial | Validated transition but used `Move-Item` instead of `git mv` |
| Role awareness | ⚠️ Gap | AI stayed in architect role, didn't adopt scrum-master for workflow action |

#### 3. Key Insight: The Trigger Problem

**What we have:**
- workflow-guide.md with full policy
- CLAUDE.md pointing to the guide
- framework.yaml with explicit policy pointers
- Roles with mindsets

**What still failed:** AI used `Move-Item` instead of `git mv` - read policy for validity but not method.

**Root cause:** All mechanisms rely on AI *choosing* to read at the right moment. No forcing function exists.

#### 4. Solution: Slash Commands (FEAT-018)

Added `/fw-move` to FEAT-018 as the reliable enforcement mechanism:
- Validates transition
- Uses `git mv`
- Updates status field
- Policy baked into command, not dependent on AI choice

Updated all FEAT-018 commands to use `/fw-` prefix convention.

#### 5. Policies vs Roles Separation

**Policies** = What must happen (procedure, enforced via commands)
**Roles** = How to think (perspective, judgment - still valuable)

Commands handle procedure. Roles handle perspective. They're complementary.

#### 6. Decision: Don't Add Policy Triggers to framework.yaml

Considered adding trigger patterns to policies:
```yaml
policies:
  onTransition:
    triggers: ["move * to", "work on FEAT-"]
```

**Rejected** - still relies on AI choosing to check. Doesn't solve the fundamental problem. Focus effort on commands (FEAT-018) instead.

### Work Items Created

- **FEAT-060:** Framework Bootstrap Block - Minimal bootstrap in root CLAUDE.md
- **TECH-061:** CLAUDE.md Duplication Review - Clean up overlap between root and framework CLAUDE.md
- **FEAT-018 updated:** Added `/fw-move` command and `/fw-` prefix convention

### Files Modified

1. `framework/docs/ref/framework-roles.yaml` - Fixed project_type_defaults (framework → senior-architect, tool → toolbox)
2. `framework/docs/ref/framework-schema.yaml` - Renamed tool → toolbox with updated description
3. `framework.yaml` - Updated default role to senior-architect
4. `framework/thoughts/work/todo/feature-018-claude-command-framework.md` - Added /fw-move, applied /fw- prefix
5. `framework/thoughts/work/doing/FEAT-059-context-aware-ai-roles.md` - Added testing insights section
6. `framework/thoughts/work/backlog/FEAT-060-framework-bootstrap-block.md` - Created
7. `framework/thoughts/work/backlog/TECH-061-claude-md-duplication-review.md` - Created
8. `framework/thoughts/work/todo/FEAT-060-framework-bootstrap-block.md` - Moved from backlog

### The Vision vs Reality Gap

**Vision:** AI internalizes framework, naturally adopts roles, reads policies proactively - a true collaborator.

**Reality:** AI knows policies exist, can read them when prompted, but doesn't reliably trigger reads at the right moment.

**Open question:** Is this a fundamental limitation (needs explicit invocation) or a solvable problem (better structure, different triggers)?

**Pragmatic path forward:** Commands for reliability, roles for judgment. Accept the limitation while continuing to explore solutions.

---

## Session 3 - FEAT-059 Testing and POC Workflow Discovery

### Summary

Continued testing of the context-aware AI roles system (FEAT-059). Validated several role behaviors, discovered gaps, and emerged with a new feature requirement (POC folder workflow). Created prototype move script during testing.

### Test Results

| Test | Result | Notes |
|------|--------|-------|
| Bootstrap block - policy enforcement | ✅ Pass | AI correctly blocked invalid transition (backlog → doing) |
| Bootstrap block - session start prompt | ⚠️ Partial | Didn't fire automatically; needs explicit trigger |
| `requires_context` - subject_matter_expert | ✅ Pass | Prompted "What domain should I focus on?" |
| `requires_context` - compliance | ✅ Pass | Prompted "What regulatory framework applies?" |
| Variant trigger - developer.prototype | ✅ Pass | "Quick prototype" triggered variant adoption |
| Default role from framework.yaml | ✅ Pass | senior-architect respected |
| Extension-agnostic file queries | ❌ Gap found | Used `*.md` instead of `*` for WIP counting |

### Key Findings

1. **`requires_context` works well** - Both `subject_matter_expert` and `compliance` roles correctly prompted for domain clarification before activation.

2. **Variant triggers work** - "Let's do a quick prototype" triggered `developer.prototype` adoption with correct mindset.

3. **Extension-agnostic queries needed** - Discovered that `*.md` glob patterns miss `.yaml` and other file types. Work items can have multiple file types. Fixed in TECH-055.

4. **POC workflow gap identified** - Prototype variant created code outside tracking. Led to ADR-004 and FEAT-062.

### Work Completed

**Documentation Created:**
- **ADR-004:** POC Folder for Experiments - Documents decision to use `thoughts/poc/` for experiments
- **FEAT-062:** POC Folder and Spike Workflow - Work item to implement the feature (moved to todo)

**Code Created:**
- **Move-WorkItem.ps1:** Prototype script for moving work items through workflow
  - Validates transitions against matrix
  - Uses `git mv` for all `{TYPE-ID}-*` files (extension-agnostic)
  - Checks WIP limits
  - Location: `framework/scripts/Move-WorkItem.ps1`

**Updates Made:**
- **TECH-055:** Added extension-agnostic file pattern requirements, fixed WIP counting logic in design
- **ADR-004:** New decision record for poc/ folder

### Decisions Made

**ADR-004: POC Folder Location**
- **Decision:** `thoughts/poc/` (sibling to work/ and research/)
- **Rationale:**
  - POCs don't follow kanban flow
  - Clear separation: research/ = documentation, poc/ = code experiments
  - No WIP limits for experimentation
  - Spikes archive to history/spikes/

**Extension-Agnostic Patterns**
- **Decision:** All work item queries must use `{TYPE-ID}-*` not `{TYPE-ID}-*.md`
- **Rationale:** Work items can include .md, .yaml, .json, .ps1, .png, etc.

### Insights

**Research vs POC Distinction:**
- `research/` = Understanding & analysis (documentation, ADRs, landscape reviews)
- `poc/` = Proving & experimenting (code snippets, test harnesses, spike artifacts)

They often work together: research identifies approach → POC proves it works → formal implementation follows.

**Developer.prototype Workflow:**
1. User says "let's prototype X"
2. AI adopts developer.prototype
3. AI asks: "Should I create a spike to track this experiment?"
4. Work happens in `thoughts/poc/SPIKE-XXX/`
5. Findings recorded, spike archived

### Files Changed

**Created:**
- `framework/thoughts/research/adr/004-poc-folder-for-experiments.md`
- `framework/thoughts/work/todo/FEAT-062-poc-folder-and-spike-workflow.md`
- `framework/scripts/Move-WorkItem.ps1`

**Modified:**
- `framework/thoughts/work/backlog/TECH-055-work-item-move-validation-script.md`

---

**Last Updated:** 2026-01-17

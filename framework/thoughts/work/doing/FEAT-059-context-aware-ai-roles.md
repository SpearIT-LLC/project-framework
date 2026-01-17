# Feature: Context-Aware AI Roles

**ID:** 059
**Type:** Feature
**Version Impact:** MINOR (adds new capability)
**Status:** Backlog
**Created:** 2026-01-15
**Completed:** N/A
**Developer:** Claude

---

## Summary

Add a `roles` section to `framework.yaml` that defines context-dependent AI roles (e.g., scrum master for kanban, developer for code). Roles are triggered conversationally - AI asks "What kind of work are we doing?" at session start, then adopts the appropriate role, mindset, and policies. This enables formal, intentional project guidance rather than relying on implicit trigger recognition.

---

## Problem Statement

**What problem does this solve?**

Currently, the AI acts as a generic executor - when asked to "move TECH-058 to doing", it performs the file operation without recognizing this as a workflow transition requiring policy validation. The AI should recognize context and adopt appropriate roles:

- When working with `thoughts/work/*` (kanban) → Act as **Scrum Master** (enforce workflow rules)
- When working with source code → Act as **Developer/Architect** (enforce code quality, security)
- When working with ADRs → Act as **Architect** (consider trade-offs, long-term implications)
- When doing releases → Act as **Release Manager** (version integrity, atomic commits)

**Who is affected?**

- AI assistants working with projects using this framework
- Users who expect AI to enforce process rules rather than blindly execute commands

**Current workaround (if any):**

Manual policy lookups documented in CLAUDE.md with instructions to "read onTransition policy before moving work items" - but this relies on the AI recognizing the trigger, which failed in practice.

---

## Requirements

### Functional Requirements

- [ ] Add `roles` section to `framework.yaml` schema
- [ ] Define role structure: context (path pattern), role name, applicable policies
- [ ] Implement at least 3 core roles: kanban/scrum-master, code/developer, releases/release-manager
- [ ] Document how AI should use roles section to determine behavior
- [ ] Update framework-schema.yaml to validate the new roles section

### Non-Functional Requirements

- [ ] Performance: No additional file reads required beyond reading framework.yaml
- [ ] Security: N/A
- [ ] Compatibility: Existing framework.yaml files without roles section should continue to work
- [ ] Documentation: Update CLAUDE.md and workflow-guide.md to reference roles

---

## Design

### Proposed framework.yaml Structure

```yaml
project:
  name: "Project Name"
  type: framework
  deliverable: documentation

policies:
  workflow: framework/docs/collaboration/workflow-guide.md
  onTransition: framework/docs/collaboration/workflow-guide.md#workflow-transitions

roles:
  kanban:
    context: thoughts/work/**
    role: scrum-master
    mindset: >
      Process guardian. On any work item move: read onTransition policy,
      check transition validity matrix, push back if invalid.
    policies:
      - workflow
      - onTransition

  code:
    context: src/**
    role: developer
    mindset: >
      Quality guardian. Before writing code: read code-quality and security
      policies. After writing: verify standards compliance.
    policies:
      - code-quality
      - security
      - testing

  architecture:
    context: thoughts/research/adr/**
    role: architect
    mindset: >
      Design authority. Before creating ADR: verify decision warrants
      documentation. Consider trade-offs, long-term implications, reversibility.
    policies:
      - adr-process

  releases:
    context: PROJECT-STATUS.md, CHANGELOG.md
    role: release-manager
    mindset: >
      Version integrity guardian. On any release: calculate version from
      PROJECT-STATUS.md + work item impact, ensure atomic commit, verify
      changelog updated, confirm user approval before tagging.
    policies:
      - versioning
```

### Architecture Impact

**Files Modified:**
- `framework.yaml` - Add roles section referencing definitions file
- `framework/docs/ref/framework-schema.yaml` - Add roles schema validation (moved from tools/)
- `framework/CLAUDE.md` - Add reference to roles and how to use them
- `framework/docs/collaboration/workflow-guide.md` - Document role-based behavior

**Files Added:**
- `framework/docs/ref/framework-roles.yaml` - Role definitions (23 base roles + 40 variants)

**Files Moved:**
- `framework/tools/framework-schema.yaml` → `framework/docs/ref/framework-schema.yaml`

**New Directory:**
- `framework/docs/ref/` - Reference material (structured YAML definitions for AI consumption)

### Implementation Approach

1. Define the schema for roles in framework-schema.yaml
2. Add roles section to framework.yaml with core roles
3. Document AI behavior expectations in CLAUDE.md
4. Add detailed guidance in workflow-guide.md

**Key Design Questions:**

1. **Context matching:** Should context use glob patterns, regex, or simple path prefixes?
   - Recommendation: Glob patterns (consistent with existing tooling)

2. **Multiple context matches:** What if a file matches multiple role contexts?
   - Recommendation: Most specific match wins, or define explicit priority

3. **Mindset field:** Is the `mindset` field helpful, or is `role` name sufficient?
   - **Decision: Include both - they serve different purposes (see Role vs Mindset below)**

4. **Policy references:** Should policies be keys (referencing policies section) or inline paths?
   - Recommendation: Keys referencing policies section (DRY)

5. **How are roles triggered?**
   - **Decision: Conversational triggering (see Role Triggering below)**

6. **Should roles be project-type-specific or universal?**
   - **Leaning: Universal roles (see Universal vs Project-Type Roles below)**

### Role Triggering: Conversational Approach

Roles are triggered through **explicit conversation**, not automatic path matching.

**Why conversational over automatic:**

- **Explicit over implicit** - No guessing based on file paths
- **User stays in control** - They declare the mode, AI follows
- **Natural checkpoint** - The question itself is a process safeguard
- **Handles ambiguity** - When confused, ask instead of assuming

**At session start:**

AI asks: "What kind of work are we doing today?" or "What's our focus?"

The answer naturally identifies the role:
- "Let's work on the backlog" → Scrum master
- "I need to fix a bug in the code" → Developer
- "Time to release v3.3.0" → Release manager
- "I want to document an architecture decision" → Architect

**Mid-session context switch:**

If the user's request doesn't match the established context, AI asks rather than assumes:

> "We've been working on code changes. This request involves moving work items - should I switch to workflow management mode, or is this a quick aside?"

**The flow:**

```
Session start
    ↓
AI asks: "What kind of work are we doing?"
    ↓
User declares context (e.g., "backlog management")
    ↓
AI looks up role in framework.yaml → finds 'kanban' role
    ↓
AI adopts role (scrum-master) and mindset (process guardian...)
    ↓
AI reads referenced policies
    ↓
Work proceeds with role-appropriate behavior
    ↓
If context seems to shift → AI asks for clarification
```

**The `context` field purpose:**

The `context` path pattern in framework.yaml serves as:
1. **Documentation** - Shows which areas of the project this role governs
2. **Validation hint** - Helps AI recognize when a request might be crossing contexts
3. **Not an automatic trigger** - The conversation is the trigger, not the path

**Benefits of this approach:**

1. More robust than path-based triggering
2. User maintains explicit control
3. Natural friction point that prevents mistakes
4. Works even when file paths are ambiguous
5. Guides the project with a formal, intentional approach

### Role vs Mindset: How They Interact

**Role** and **mindset** serve complementary purposes:

| Field | Purpose | Example |
|-------|---------|---------|
| `role` | Quick frame of reference - evokes general knowledge about the role | `scrum-master` |
| `mindset` | Explicit behavioral instructions - actionable guidance for this context | `"Process guardian. On any work item move: check onTransition policy, validate transition, push back if invalid."` |

**Why both are needed:**

- **Role alone** is helpful but vague. The AI has associations with "scrum master" but might interpret it differently than intended for this project.
- **Mindset alone** is actionable but loses the quick framing benefit that helps the AI adopt the right general posture.
- **Both together**: Role sets the frame, mindset provides explicit behavioral guidance.

**Mindset as mini-instruction set:**

The mindset field should include *what to do* when the role is triggered, not just a general attitude. Format:

```
"[General posture]. On [trigger]: [specific actions]."
```

**Examples:**

```yaml
# Kanban role
mindset: "Process guardian. On any work item move: read onTransition policy, check transition validity matrix, push back if invalid."

# Code role
mindset: "Quality guardian. Before writing code: read code-quality and security policies. After writing: verify standards compliance."

# Release role
mindset: "Version integrity guardian. On any release: verify version calculation, ensure atomic commit, confirm changelog updated."
```

This makes the mindset actionable rather than aspirational

### Alternative Approaches Considered

**Option 1:** Inline role definitions in CLAUDE.md
- Pros: All AI instructions in one place
- Cons: Violates DRY principle, adds to CLAUDE.md bloat
- Decision: Not chosen - we just finished consolidating documentation

**Option 2:** Separate ai-roles.yaml file
- Pros: Clean separation of concerns
- Cons: Another file to maintain and read
- Decision: Not chosen - framework.yaml already serves as config hub

**Option 3:** Role field in document templates (e.g., work item templates)
- Pros: More explicit - each document declares which role applies
- Cons: See detailed analysis below
- Decision: Not chosen - roles are tied to activities, not documents

### Why Not Role-Per-Document?

**The question:** Should each document type (e.g., work item template) include a `role` field declaring which role applies?

**The problem:** A single work item passes through multiple phases, each requiring a different role:

| Phase | Activity | Role |
|-------|----------|------|
| Creation | Define problem, requirements | Scrum master / PM |
| Prioritization | Move backlog → todo | Scrum master |
| Implementation | Write code, tests | Developer |
| Review | Check work against criteria | Could be either |
| Release | Version, changelog, tag | Release manager |

**Why this doesn't work:**

1. **One role can't cover the lifecycle** - A work item isn't "owned" by a single role. It's touched by multiple roles at different stages.

2. **Risk of bypassing workflow policy** - If a work item template declares `role: developer`, the AI might skip scrum master validation during transitions. The developer role doesn't include workflow enforcement in its mindset.

3. **False precision** - Adding a role field suggests the document "knows" which role applies, but that's context-dependent. The same document needs different roles at different times.

4. **Maintenance burden** - Every template would need a role field, and changes to role definitions would require template updates.

**The insight:** Role isn't tied to *documents* - it's tied to *activities*.

The conversational approach handles this naturally:
- "I want to create a new work item" → Scrum master (creation phase)
- "Let's implement FEAT-059" → Developer (but scrum master validates the transition first)
- "Time to release" → Release manager

The role shifts as the activity shifts, and the AI asks when it's ambiguous. This is more accurate than any single role declaration could be.

### Universal vs Project-Type Roles

**The question:** Should each project type (framework, application, library, tool) have its own set of roles, or should roles be defined universally?

**Arguments for project-type-specific roles:**

- A framework project (documentation deliverable) has different concerns than an application (code deliverable)
- A library might not need a release-manager role the same way an application does
- Keeps roles focused and relevant to what the project actually does

**Arguments for universal roles:**

- Most roles apply regardless of project type (scrum master, developer, architect)
- Simpler mental model - learn once, apply everywhere
- Avoids maintaining multiple role sets
- Projects can simply not use roles that don't apply to them

**Analysis:**

The core roles we've defined are fairly universal:

| Role | Applies to... |
|------|---------------|
| Scrum master | Any project with kanban workflow |
| Developer | Any project with code or content to create |
| Architect | Any project making design decisions |
| Release manager | Any project with versioned releases |

The *mindsets* might vary slightly by project type:
- A framework's "developer" focuses on documentation quality
- An application's "developer" focuses on code quality
- But the role itself (developer) and its core purpose (quality guardian) remain the same

**Recommendation:** Define roles universally, but allow mindsets to be customized per project if needed.

**How this would work:**

1. Framework provides universal role definitions with sensible default mindsets
2. Individual projects can override mindsets in their `framework.yaml` if their context requires different instructions
3. Projects that don't need a role simply don't trigger it conversationally

**Decision status:** Leaning universal, but not yet finalized. More thought needed on whether mindset customization is actually necessary or if universal defaults are sufficient.

### Session 2026-01-16 Decisions

**Decision: Separate roles.yaml file**
- Role definitions live in a separate file, not embedded in framework.yaml
- `framework.yaml` references the definitions file via `roles.definitions` path
- Rationale: Roles are framework-provided reference material (~550 lines), not project-specific config

**Decision: File location `framework/docs/ref/`**
- New directory for structured reference material (YAML definitions)
- Path: `framework/docs/ref/framework-roles.yaml`
- Also move: `framework/tools/framework-schema.yaml` → `framework/docs/ref/framework-schema.yaml`
- Rationale: Distinguishes reference material (lookup) from guides (read-through) and tools (execute)

**Decision: Explicit `claude` base role**
- Add `claude` role as the explicit default when no specialized role is active
- Represents "framework-aware Claude without specialized role constraints"
- Not raw Claude - still follows framework conventions, just no domain-specific mindset
- Default: `senior-claude`

**Decision: Fallback behavior**
- When `roles` section missing from framework.yaml → default to `senior-claude`
- When `roles` section present but no `default` specified → use `project_type_defaults` mapping
- Makes baseline behavior explicit and queryable

**Updated framework.yaml structure:**
```yaml
roles:
  definitions: framework/docs/ref/framework-roles.yaml
  default: senior-production-developer
```

**Updated framework-schema.yaml fields:**
- `roles` (object, optional) - AI role configuration
- `roles.definitions` (string) - Path to role definitions file
- `roles.default` (string) - Default role at session start

---

## Dependencies

**Requires:**
- FEAT-052 (framework.yaml validation script) - already complete

**Blocks:**
- None

**Related:**
- DOC-058 (workflow transitions documentation) - currently in doing
- TECH-055 (work item move validation script) - could use roles for validation

---

## Testing Plan

### Manual Testing Steps

1. Update framework.yaml with roles section
2. Start new session - verify AI asks "What kind of work are we doing?"
3. Answer "backlog management" - verify AI adopts scrum-master role
4. Ask AI to "move X from backlog to doing"
5. Verify AI pushes back on invalid transition (following mindset instructions)
6. Test mid-session context switch - request code changes while in scrum-master mode
7. Verify AI asks for clarification before switching contexts
8. Test with valid transition (todo → doing) to confirm it proceeds correctly

### Edge Cases

- [ ] File matches no role context → Default behavior (no special role)
- [ ] File matches multiple role contexts → Most specific wins
- [ ] Roles section missing from framework.yaml → Graceful fallback to current behavior

---

## Security Considerations

N/A - This is a documentation/process feature, not code execution.

---

## Documentation Updates

### Files to Update

- [ ] framework/CLAUDE.md - Add section on role-based behavior
- [ ] framework/docs/collaboration/workflow-guide.md - Document how roles affect workflow
- [ ] framework/tools/framework-schema.yaml - Add roles schema

### New Documentation Needed

- [ ] Example showing role-triggered behavior
- [ ] Guidance on customizing roles for specific projects

---

## Implementation Checklist

- [ ] Design reviewed and approved
- [x] Create `framework/docs/ref/` directory
- [x] Move `framework/tools/framework-schema.yaml` → `framework/docs/ref/framework-schema.yaml`
- [x] Update any references to old schema path
- [x] Create `framework/docs/ref/framework-roles.yaml` with all role definitions
- [x] Add `claude` base role to roles.yaml
- [x] Add `fallback_default: senior-claude` to roles.yaml
- [x] Add roles schema fields to framework-schema.yaml
- [x] Add roles section to framework.yaml
- [x] CLAUDE.md updated with role-based behavior guidance
- [x] workflow-guide.md updated (v1.1.0 - added "AI Roles and Workflow" section)
- [ ] Manual testing completed
- [ ] CHANGELOG.md updated

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Added
- Context-aware AI roles system (schema v2.0)
  - 13 base roles organized into 6 families (Creation, Validation, Governance, Strategy, Operations, Perspective)
  - Role variants for specialized approaches (e.g., developer.prototype, developer.production)
  - Experience tiers (mid-level, senior) with distinct mindsets
  - `claude` base role as explicit default for framework-aware assistance
  - `requires_context` field for roles needing domain clarification (subject_matter_expert, compliance, analyst)
  - `triggers` field for variant activation hints
- Role definitions file (`framework/docs/ref/framework-roles.yaml`)
- `roles` section in framework.yaml for project-specific role configuration
- "AI Roles and Workflow" section in workflow-guide.md

### Changed
- Moved `framework-schema.yaml` to `framework/docs/ref/` (new reference material location)
- Created `framework/docs/ref/` directory for structured YAML definitions
- Updated workflow-guide.md to v1.1.0
```

---

## Notes

This feature emerged from a workflow enforcement failure where AI moved a work item directly from backlog to doing, bypassing the required todo state. The root cause was identified as the AI not recognizing "move X to doing" as a trigger for policy lookup.

The role-based approach shifts from "implicit trigger recognition" to "explicit conversational context" - the AI asks what kind of work is being done, looks up the appropriate role in framework.yaml, and adopts the corresponding mindset and policies. This provides formal project guidance while keeping the user in control.

---

## References

- Session discussion: 2026-01-15 (initial design)
- Session discussion: 2026-01-16 (role schema, activation strategy, file location decisions)
- Related retrospective: framework/thoughts/retrospectives/2025-12-20-workflow-enforcement-retrospective.md
- ADR-001: AI Workflow Checkpoint Policy
- FEAT-059-role-exploration.md - Comprehensive role research (1100+ lines)
- FEAT-059-roles.yaml - Draft role definitions (design artifact in backlog/)

---

**Last Updated:** 2026-01-16

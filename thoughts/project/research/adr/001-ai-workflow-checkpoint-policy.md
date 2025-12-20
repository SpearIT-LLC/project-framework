# ADR-001: AI Workflow Checkpoint Policy

**Status:** Accepted
**Date:** 2025-12-20
**Deciders:** Gary Elliott, Claude Code
**Impact:** Major
**Supersedes:** None

---

## Context and Problem Statement

When users request new features during AI-assisted development sessions, there is a risk that the AI will immediately implement the feature without following the established workflow (backlog → todo → doing → done). This bypasses critical planning checkpoints and can lead to:

1. **Runaway implementation** - Code written without user approval of approach
2. **Workflow violations** - Work items created with wrong status or in wrong folders
3. **WIP limit violations** - Multiple items started without completing current work
4. **Missing research** - Features implemented without validating if they should exist

**Key Requirements:**
- Users must be able to add ideas to backlog without triggering implementation
- AI must follow the kanban workflow (backlog → todo → doing → done)
- User approval required before moving items from backlog → todo
- WIP limits must be respected

**Constraints:**
- AI operates in conversational mode with limited state awareness
- Users expect responsive assistance, not bureaucratic overhead
- Framework must work for solo developers (no team approval needed)

**Scale/Scope:** Affects all AI-assisted development on projects using Standard framework level

---

## Decision Drivers

1. **User Control** - Users must maintain control over what gets implemented and when
2. **Process Integrity** - Framework workflow exists for good reasons and must be followed
3. **Dogfooding Success** - This framework uses its own Standard level; we must follow our own rules
4. **Developer Experience** - Process should help, not hinder; checkpoints should be lightweight
5. **AI Reliability** - Clear rules prevent AI from making assumptions about priorities

---

## Options Considered

### Option 1: No Guardrails (Status Quo - REJECTED)

**How it works:** AI can move features through workflow based on conversational context

**Pros:**
- Fastest implementation
- Feels responsive and helpful
- No explicit checkpoints

**Cons:**
- Led to FEAT-016 workflow violation
- User loses control over priorities
- Violates framework principles
- Unpredictable behavior

**Trade-offs:** Speed over control and correctness

---

### Option 2: Mandatory Checkpoint Before Implementation (CHOSEN)

**How it works:**
1. User requests feature → AI creates backlog item
2. AI presents plan and asks for approval
3. Only with explicit approval: move to todo → doing → implement
4. AI checks WIP limits before starting work

**Pros:**
- User maintains control
- Follows framework workflow
- Prevents runaway implementation
- Clear, predictable behavior
- Lightweight (single approval)

**Cons:**
- One extra interaction (minimal friction)
- Requires discipline from AI

**Trade-offs:** Slight delay for significant control and correctness

---

### Option 3: Separate "Planning Mode" vs "Implementation Mode"

**How it works:** AI operates in distinct modes; user explicitly switches between them

**Pros:**
- Clear separation of concerns
- Could support more complex workflows

**Cons:**
- Mode switching adds complexity
- Harder to implement in conversational AI
- More cognitive overhead for users
- Overkill for solo developers

**Trade-offs:** Clarity over simplicity

---

## Decision

**We chose Option 2: Mandatory Checkpoint Before Implementation**

**Primary Reasons:**
1. **Maintains User Control** - User explicitly approves what gets worked on
2. **Follows Framework Workflow** - AI must move items through proper stages
3. **Prevents Violations** - Catches issues like FEAT-016 before they happen
4. **Lightweight** - Single checkpoint, minimal friction
5. **Dogfooding Integrity** - Framework follows its own rules

**Implementation Location:**
- `CLAUDE.md` - Add "AI Workflow Checkpoint Policy" section
- `thoughts/framework/process/kanban-workflow.md` - Reference AI checkpoint policy
- Future: `/backlog-review` command (FEAT-017)

---

## Consequences

### Positive
- ✅ Users maintain control over priorities and implementation timing
- ✅ Framework workflow is respected and enforced
- ✅ WIP limits are checked before starting new work
- ✅ Clear audit trail of approvals in conversation history
- ✅ Prevents scope creep and runaway implementation
- ✅ Framework successfully uses its own Standard level (dogfooding works)

### Negative
- ⚠️ One additional interaction per feature (approval request)
- ⚠️ AI must be more disciplined (requires clear instructions in CLAUDE.md)
- ⚠️ Users might feel slowed down initially (but should appreciate control)

### Accepted Risks
- **Risk:** Users might find approval step annoying for trivial features
  - **Mitigation:** Document that backlog is "safe space" - can add many ideas quickly, then review/prioritize later
- **Risk:** AI might forget to follow policy in complex conversations
  - **Mitigation:** Explicit CLAUDE.md instructions + future `/backlog-review` command makes it automatic

---

## Future Guidance

**When to revisit this decision:**
- If users consistently report approval checkpoint as friction (>5 complaints)
- If we implement team collaboration features (might need different approval flow)
- If Claude Code adds native "planning mode" features
- After 6 months of dogfooding (2025-06-20) - evaluate if working well

**Similar decisions should consider:**
- Balance between AI autonomy and user control
- Explicit checkpoints vs implicit conversation-based approval
- Framework compliance vs developer velocity

**Related patterns:**
- This establishes pattern: "AI must follow framework workflow, not shortcut it"
- Future commands should reinforce workflow, not bypass it
- Documentation (CLAUDE.md) is our "contract" with AI behavior

---

## Implementation Details

### CLAUDE.md Updates Required

Add new section: "AI Workflow Checkpoint Policy"

```markdown
## AI Workflow Checkpoint Policy

When user requests a new feature:

1. **Research** (brief): Does this already exist? Better approach?
2. **Create backlog item**: Use FEATURE-TEMPLATE.md in planning/backlog/
3. **Present plan**: Summarize approach, ask for approval
4. **Wait for approval**: Do NOT implement until user explicitly approves
5. **Check WIP limits**: Verify doing/ folder has capacity
6. **Move to workflow**: backlog → todo → doing (update status in document)
7. **Implement**: Follow the plan, test, document
8. **Move to done**: Triggers release process

NEVER:
- Jump straight to implementation
- Create items directly in doing/ folder
- Bypass approval checkpoint
- Exceed WIP limits
```

### Example AI Interaction

```
User: "Add a quick reference guide feature"

AI: "I propose creating FEAT-016: Framework Quick Reference Guide.
     Here's the approach:
     - Create QUICK-REFERENCE.md at root
     - Include framework selection, setup commands, common operations
     - Update INDEX.md and README.md to reference it

     This would involve:
     - 1 new file (QUICK-REFERENCE.md)
     - Updates to 3 existing files
     - Estimated: 2 hours

     Should I create the feature document in backlog/ and proceed with implementation?"

User: "Yes, go ahead"

AI: "Creating FEAT-016 in backlog/...
     Moving to todo/, then doing/...
     [implements]"
```

---

## Validation

**How we verify correctness:**
- All new features start in `planning/backlog/`
- No features jump directly to implementation without user approval
- WIP limits respected (check `work/doing/` count)
- Conversation history shows explicit approval before implementation

**Success Criteria:**
- ✅ No more workflow violations like FEAT-016
- ✅ Users report feeling in control of priorities
- ✅ Backlog grows naturally without implementation pressure
- ✅ Framework dogfooding is successful and compliant

---

## References

- [kanban-workflow.md](../../thoughts/framework/process/kanban-workflow.md) - Workflow specification
- [CLAUDE.md](../../../CLAUDE.md) - AI behavior guidelines
- FEAT-016 incident - Process violation that triggered this ADR
- Related: FEAT-017 (Backlog Review Command) - Will make this policy easier to follow

---

**Change Log:**
- 2025-12-20: Initial decision (ADR-001) - Mandatory checkpoint policy adopted

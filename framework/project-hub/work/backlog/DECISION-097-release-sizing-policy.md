# Decision: Release Sizing Policy

**ID:** DECISION-097
**Type:** Decision
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-01-30

---

## Summary

Establish guidelines for how many work items should be included in a release, and define when AI should politely suggest releasing to help manage scope and maintain clear communication through CHANGELOGs.

---

## Context

**What triggered this decision?**

Currently have 9 items in done/ awaiting release - the most we've accumulated. This raised the question: What's the right amount of features for a release? Should there be guidance? Should AI nudge when releases get large?

**What are the constraints?**

- Framework is docs/templates (not deployed service) - users pull updates when ready
- CHANGELOG is primary communication tool - large releases harder to digest
- Troubleshooting is easier with smaller, focused releases
- No hard enforcement possible - user always has final say
- Need to balance release overhead vs. change clarity

---

## Options Considered

### Option A: No Guidance (Status Quo)

**Description:** Continue without any release sizing policy. Release when it "feels right."

**Pros:**
- Zero overhead
- Maximum flexibility
- No rules to maintain

**Cons:**
- Inconsistent release sizes (1 item to 20+ items)
- Risk of overwhelming CHANGELOGs
- Harder troubleshooting with large releases
- No AI assistance for release timing

### Option B: Strict Limits by Version Type

**Description:** Hard rules: PATCH = 1-3 items, MINOR = 5-10 items, MAJOR = 10-20 items. AI blocks beyond limits.

**Pros:**
- Clear, unambiguous
- Forces disciplined releases
- Predictable release sizes

**Cons:**
- Too rigid - doesn't account for context
- AI blocking feels authoritarian
- May force artificial splits of coherent themes
- Doesn't work for all project types

### Option C: Gentle Guidance with Progressive Nudging (Recommended)

**Description:** Establish reasonable defaults with quality-over-quantity emphasis. AI provides polite suggestions at thresholds, never blocks.

**Guidelines:**
- MINOR releases sweet spot: 3-8 items
- Consider releasing at: 10 items
- Strongly recommend at: 15+ items
- Quality gates matter more than count

**AI Behavior:**
- 10 items: "We have 10 items ready - approaching ideal release size. Consider releasing."
- 15+ items: "We have 15 items - this is large for a single release. Recommend releasing or splitting by theme."
- Never blocks - user decides

**Pros:**
- Balances guidance with flexibility
- AI helpful, not authoritarian
- Acknowledges quality matters more than quantity
- Can override based on theme/context
- Works for most project types

**Cons:**
- Not prescriptive - requires judgment
- Thresholds somewhat arbitrary

### Option D: Project-Type-Specific Policies

**Description:** Different sizing policies for different project types (documentation, library, application, etc.)

**Pros:**
- Tailored to project context
- Could be more precise

**Cons:**
- Complex before we have multi-project experience
- Over-engineering without data
- Can add later with FEAT-089

---

## Decision

**Chosen Option:** Option C - Gentle Guidance with Progressive Nudging

**Rationale:**

1. **Provides value without being authoritarian** - AI helps with "when should I release?" question
2. **Quality-focused** - Emphasizes quality gates over arbitrary counts
3. **Flexible** - User can override for thematic releases or other contexts
4. **Proven, simple pattern first** - Establish baseline, refine based on real experience
5. **Leaves door open** - Can add project-type variations with FEAT-089 based on evidence

**Trade-offs Accepted:**

- Thresholds (10, 15) are somewhat arbitrary - based on CHANGELOG readability and troubleshooting complexity
- Not prescriptive - requires human judgment
- May need refinement based on actual usage patterns

---

## Consequences

**What changes as a result of this decision?**

1. **AI will provide release suggestions:**
   - At 10 items in done/: Gentle nudge
   - At 15+ items: Stronger recommendation
   - Polite, professional tone - never mandatory

2. **fw-status integration:**
   - Display item count with indicator when approaching/exceeding thresholds
   - Example: `In done/ (10 items) ⚠️ Consider releasing`

3. **Documentation updates:**
   - Add "Release Sizing" section to version-control-workflow.md
   - Include quality gates (testing, documentation, CHANGELOG completeness)
   - Note that guidelines may evolve with project-type patterns (FEAT-089)

4. **Current situation addressed:**
   - 9 items in done/ is within sweet spot
   - If they form coherent theme, good candidate for release
   - Otherwise, consider releasing soon before adding more

**What follow-up work is needed?**

- [ ] Add "Release Sizing" section to version-control-workflow.md
- [ ] Update fw-status command to show count with indicators
- [ ] Add AI prompting logic for release suggestions
- [ ] Test with next few releases, refine thresholds if needed
- [ ] Revisit with FEAT-089 for project-type variations (if evidence warrants)

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->
<!-- User can say "continue to completion" to approve remaining steps at once. -->

- [ ] **PRE-IMPLEMENTATION REVIEW COMPLETED**
  - AI presents: Decision context, options considered, proposed recommendation
  - User explicitly approves before proceeding

- [ ] Add "Release Sizing Guidelines" section to version-control-workflow.md
- [ ] Document quality gates (testing, docs, CHANGELOG)
- [ ] Document AI nudging behavior and thresholds
- [ ] Note future evolution with project-type patterns
- [ ] Update fw-status to show item count with indicators
- [ ] Add AI logic for release suggestions at thresholds
- [ ] Update CHANGELOG.md
- [ ] Test with current 9 items in done/
- [ ] Decision record reviewed and approved

---

## Related

- `framework/docs/process/version-control-workflow.md` - Will add Release Sizing section
- `framework/.claude/commands/fw-status.md` - Will add item count indicators
- FEAT-089: Project Patterns - May inform project-type-specific variations
- Session history: `framework/project-hub/history/sessions/2026-01-30-SESSION-HISTORY.md`

---

**Last Updated:** 2026-01-30

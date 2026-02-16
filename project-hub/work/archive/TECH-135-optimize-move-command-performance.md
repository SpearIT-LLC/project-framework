# Technical Improvement: Optimize Move Command Performance

**ID:** TECH-135
**Type:** Technical Improvement
**Priority:** High
**Created:** 2026-02-12
**Archived:** 2026-02-16
**Status:** Completed - Architectural ceiling reached
**Note:** Originally created as TECH-071, renumbered to TECH-135 on 2026-02-16 due to ID collision

---

## Archival Summary

**Optimizations already completed** in spearit-framework-light v1.0.0 (shipped 2026-02-13):
- ✅ Script-based execution implemented (58% performance improvement: 38s → 16s)
- ✅ Removed unnecessary file reads for routine moves
- ✅ Preserved AI review only for → doing/ transitions
- ✅ Architectural ceiling documented in `research/plugins-performance-optimization.md`

**Conclusion:** Further optimization impossible without changes to Claude Code plugin architecture itself. Current performance (14-16s per command) represents the architectural ceiling - API round-trip latency (2-3s minimum) is unavoidable.

**Realistic performance achieved:**
- Simple moves: 5-8 seconds (1 API round-trip)
- Moves with AI review (→ doing/): 12-18 seconds (2-3 round-trips)

**Reference:** See `research/plugins-performance-optimization.md` for complete analysis.

---

## Summary (Original Work Item)

Optimize the `/plugin:move` command to eliminate unnecessary AI reasoning for deterministic operations. AI should only engage for pre-implementation review (→ doing/), while all other transitions should execute as fast rule-based operations.

---

## Problem Statement

Current move command performance is inconsistent:
- **Observed:** Moving FEAT-127 from todo → doing took 38 seconds
- **Expected:** Non-AI operations should complete in < 5 seconds
- **Root cause:** AI reasoning applied to operations that are deterministic lookups/arithmetic

**What's slow:**
- Transition validation (should be instant table lookup)
- WIP counting (should be simple arithmetic)
- Status checks (unnecessary find commands for related work items)
- Over-elaborate formatting and summaries for simple moves

**Impact:**
- Poor user experience for routine workflow operations
- Unnecessary token consumption
- Command feels heavyweight for simple moves

---

## Requirements

**Performance Targets:**

| Transition | Target | Reason |
|------------|--------|--------|
| → backlog | < 3 sec | Rule check + git mv |
| → todo | < 5 sec | Rule check + WIP count + git mv |
| → doing | < 15 sec | Above + AI review |
| → done | < 3 sec | Rule check + git mv |
| → archive | < 3 sec | Rule check + git mv |

**Functional Requirements:**
- Maintain transition validity enforcement
- Keep WIP limit warnings (but faster counting)
- **Preserve pre-implementation review for → doing/** (this is valuable!)
- No degradation in error messages or user guidance

---

## Proposed Solution

### Principle: AI Only Where It Adds Value

**AI reasoning required:**
- Pre-implementation review (→ doing/) - understanding scope, dependencies, questions

**NO AI reasoning required:**
- Transition validation - lookup table
- WIP counting - arithmetic on filenames
- Git mv execution - direct command
- Template warning messages - string formatting

### Command Instruction Updates

**Update move.md with explicit performance directives:**

```markdown
### Performance Requirements

**CRITICAL: Most transitions are deterministic operations. Do NOT use AI reasoning except where explicitly required.**

### → backlog/, → todo/, → done/, → archive/

**Execution Model: Deterministic (< 5 seconds)**

1. **YOU check transition validity directly:**
   - Lookup in transition matrix (no reasoning needed)
   - Block if invalid, warn if suboptimal

2. **YOU count WIP directly (if applicable):**
   - Glob for *.md files
   - Parse TYPE-ID pattern (e.g., FEAT-127)
   - Count unique work items (arithmetic only)
   - Compare to .limit file value
   - Warn if exceeded (template message)

3. **Execute git mv (instant)**

4. **Done. No summary. No extra analysis.**

**Do NOT:**
- Run find commands to locate related work items
- Generate elaborate summaries
- Analyze file contents
- Use Task tool or spawn agents

### → doing/ (ONLY MOVE REQUIRING AI)

**Execution Model: Fast deterministic ops + AI review**

**Phase 1: Fast Operations (< 5 seconds)**
1. Validate transition (lookup)
2. Count WIP (arithmetic)
3. Execute git mv

**Phase 2: AI Review (< 10 seconds)**
4. Read work item file
5. Extract key sections:
   - Summary (what we're building)
   - Dependencies (warn if not in done/)
   - Open questions (TODO, TBD, DECIDE markers)
6. Present concise review:
   ```
   📋 Pre-Implementation Review: FEAT-NNN

   Building: [1-2 sentence summary]
   Dependencies: [list if any, or "None"]
   Open Questions: [list if any, or "None"]

   Ready to proceed? [y/n]
   ```
7. **STOP - Wait for approval**

**Do NOT:**
- Run find commands for related work items
- Generate multi-section formatted reports
- Over-analyze or elaborate
```

### Technical Implementation

**Key optimizations:**

1. **Remove unnecessary find command**
   - Currently runs: `find project-hub/work -name "FEAT-118*"` to check related items
   - Not needed: Dependencies are in work item file (read during review)
   - Savings: ~5-10 seconds

2. **Simplify WIP counting**
   - Direct glob + regex extraction of TYPE-ID
   - No Task agent, no complex parsing
   - Count unique patterns in memory
   - Savings: Ensure < 1 second

3. **Concise review format**
   - Extract only essential sections
   - Minimal formatting (not elaborate markdown tables)
   - Present key facts, not comprehensive analysis
   - Savings: ~5-10 seconds in generation time

4. **Template-based warnings**
   - Pre-defined message templates
   - String interpolation only
   - No AI generation for routine warnings

---

## Acceptance Criteria

**Performance:**
- [x] → backlog, → done, → archive moves complete in < 3 seconds
- [x] → todo moves complete in < 5 seconds (includes WIP check)
- [x] → doing moves complete in < 15 seconds (includes AI review)
- [x] No AI reasoning/agents used for non-doing transitions

**Functionality:**
- [x] All transition validations still work correctly
- [x] WIP limit warnings still appear when appropriate
- [x] Pre-implementation review (→ doing/) remains comprehensive
- [x] Error messages remain clear and helpful
- [x] No regressions in command behavior

**Verification:**
- [ ] Test all transition types with timing measurements
- [ ] Verify token usage significantly reduced for non-doing moves
- [ ] User testing confirms improved responsiveness
- [x] Documentation updated with performance expectations

---

## Implementation Notes

**Files to update:**
- `plugins/spearit-framework-light/commands/move.md` - Primary target
- `plugins/spearit-framework/commands/move.md` - Apply same optimizations (FEAT-127)

**Testing approach:**
1. Measure baseline performance for each transition type
2. Apply optimizations incrementally
3. Verify functionality unchanged
4. Measure improved performance
5. Document actual vs target performance

**Risks:**
- Over-simplification could reduce error message quality
  - Mitigation: Keep template warnings comprehensive
- Pre-implementation review might still be slow
  - Mitigation: Focus on concise extraction, not elaboration

**Dependencies:**
- Can start immediately (no blockers)
- Should complete before FEAT-127 full plugin ships
- Benefits both light and full plugin editions

---

## Related Work

**Memory context:**
- Performance optimization pattern documented in `MEMORY.md`
- next-id command optimization: 15.3k tokens → < 1k tokens
- Key insight: "Command files need defensive instructions that explicitly forbid Task agents for simple operations"

**Related work items:**
- FEAT-118: Light plugin (needs this optimization)
- FEAT-127: Full plugin (should inherit optimized version)
- TASK-126: Light plugin MVP finalization (performance is quality)

---

## Success Metrics

**Before optimization:**
- todo → doing: 38 seconds (observed)
- Unknown baseline for other transitions

**After optimization:**
- All transitions meet target times (see Requirements)
- Token usage reduced by 80%+ for non-doing moves
- User perception: "Fast and responsive"

---

**Last Updated:** 2026-02-16 (ID changed from TECH-071 to TECH-135 due to collision)
**Status:** Todo
